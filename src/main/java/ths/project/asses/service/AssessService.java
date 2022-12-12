package ths.project.asses.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import lombok.SneakyThrows;
import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ths.jdp.core.dao.base.Paging;
import ths.jdp.core.model.LoginUserModel;
import ths.jdp.core.web.LoginCache;
import ths.project.analysis.forecast.numericalmodel.query.ForecastQuery;
import ths.project.asses.entity.AssessEmission;
import ths.project.asses.entity.AssessMain;
import ths.project.asses.entity.AssessScene;
import ths.project.asses.mapper.AssessEmissionMapper;
import ths.project.asses.mapper.AssessMainMapper;
import ths.project.asses.mapper.AssessSceneMapper;
import ths.project.asses.params.AddOrEditAfterAssesParams;
import ths.project.asses.params.PollutantAbatementParams;
import ths.project.asses.params.ScenarioParams;
import ths.project.common.uid.SnowflakeIdGenerator;
import ths.project.common.util.DateUtil;
import ths.project.common.util.ExcelUtil;
import ths.project.system.base.util.PageSelectUtil;

import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.lang.reflect.InvocationTargetException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import static org.apache.commons.beanutils.BeanUtils.copyProperties;

@Service
public class AssessService {

    /**
     * 场景服务
     */
    @Autowired
    private AssessSceneMapper assessSceneMapper;
    /**
     * 方案服务
     */
    @Autowired
    private AssessMainMapper assessMainMapper;
    /**
     * 排放信息服务
     */
    @Autowired
    private AssessEmissionMapper assessEmissionMapper;
    /**
     * 获取全局唯一id
     */
    @Autowired
    private SnowflakeIdGenerator idGenerator;

    /**
     * 根据评估id查询场景信息
     *
     * @param assessId
     * @return
     */
    public List<AssessScene> getSceneby(String assessId) {
        return assessSceneMapper.selectList(Wrappers.lambdaQuery(AssessScene.class).eq(AssessScene::getMainId, assessId)
                .orderByAsc(AssessScene::getCreateTime));
    }

    /**
     * 根据场景id查询场景信息
     *
     * @param assessEmission
     * @return
     */
    public List<AssessEmission> getAssessEmission(AssessEmission assessEmission) {
        LambdaQueryWrapper<AssessEmission> lambdaQueryWrapper = Wrappers.lambdaQuery(AssessEmission.class);
        if (assessEmission != null && StringUtils.isNotBlank(assessEmission.getSceneId())) {
            lambdaQueryWrapper.eq(AssessEmission::getSceneId, assessEmission.getSceneId());
        }
        if (assessEmission != null && assessEmission.getEmissionBigType() != null) {
            lambdaQueryWrapper.eq(AssessEmission::getEmissionBigType, assessEmission.getEmissionBigType());
        }
        lambdaQueryWrapper.orderByAsc(AssessEmission::getCreateTime);
        return assessEmissionMapper.selectList(lambdaQueryWrapper);
    }


    /**
     * 计算不同场景的减排比例
     *
     * @param assessEmission
     * @return
     */
    public List<Map<String, Object>> getRate(AssessEmission assessEmission) {
        List<Map<String, Object>> result = new ArrayList<>();
        assessEmission.setAlertLevel("yellow");
        result.add(assessEmissionMapper.getRate(assessEmission));
        assessEmission.setAlertLevel("orange");
        result.add(assessEmissionMapper.getRate(assessEmission));
        assessEmission.setAlertLevel("red");
        result.add(assessEmissionMapper.getRate(assessEmission));
        return result;
    }

    /**
     * 添加或编辑
     *
     * @param params
     */
    @Transactional(rollbackFor = Exception.class)
    public void addOrEditAfterAsses(AddOrEditAfterAssesParams params,LoginUserModel loginUser) throws InvocationTargetException, IllegalAccessException {
        if (params == null) {
            throw new IllegalArgumentException("请求参数为null");
        }
        if (StringUtils.isBlank(params.getAssessName())) {
            throw new IllegalArgumentException("计划名称为空");
        }
        if (params.getStartTime() == null || params.getEndTime() == null) {
            throw new IllegalArgumentException("时间参数为空");
        }
        // 匹配1-9开始,1个或者0个.号,0-9结尾|匹配0开始必须有.号,结尾至少出现一次0-9|匹配一个0开始以及结束
        String regx = "^\\-?[0-9]+(\\.[0-9]+)?$";
        Pattern compile = Pattern.compile(regx);
        //1:方案
        AssessMain assessMain = new AssessMain();
        BeanUtils.copyProperties(assessMain, params);
        //新增方案
        if (StringUtils.isBlank(params.getPkid())) {
            assessMain.setPkid(idGenerator.getUniqueId());
            //创建时间
            assessMain.resolveCreate(loginUser.getUserName());
            assessMainMapper.insert(assessMain);
        } else {
            //创建时间
            assessMain.resolveUpdate(loginUser.getUserName());
            assessMainMapper.updateById(assessMain);
        }
        //2:场景
        List<ScenarioParams> scenarioParamsList = params.getList();
        for (int i = 0, leng = (scenarioParamsList == null ? 0 : scenarioParamsList.size()); i < leng; i++) {
            ScenarioParams scenarioParams = scenarioParamsList.get(i);
            AssessScene assessScene = saveOrEditScene(scenarioParams, assessMain.getPkid(), loginUser);
            //3:排放信息
            //--3.1污染物减排信息
            List<PollutantAbatementParams> pollutantList = scenarioParams.getPollutantList();
            for (int j = 0, len = (pollutantList == null ? 0 : pollutantList.size()); j < len; j++) {
                PollutantAbatementParams pollutant = pollutantList.get(j);
                saveOrEditPolution(pollutant, loginUser, assessScene,compile);
            }

            //--3.2质量改善信息
            List<PollutantAbatementParams> quality = scenarioParams.getQuality();
            AssessEmission assessEmission1 = new AssessEmission();
            //重新组合数据
            List<PollutantAbatementParams> qualityNew = new ArrayList<>(6);
            for (int n = 0; n < 6; n++) {
                qualityNew.add(new PollutantAbatementParams());
            }
            quality.stream().forEach(val -> {
                // 消减浓度(ug/m³)
                if (val.getWarningType().equals("1")) {
                    if (val.getWarningColor().equals("red")) {
                        PollutantAbatementParams pollutantAbatementParams = qualityNew.get(0);
                        qualityNew.set(0, changData(pollutantAbatementParams, val));
                    } else if (val.getWarningColor().equals("orange")) {
                        PollutantAbatementParams pollutantAbatement = qualityNew.get(1);
                        qualityNew.set(1, changData(pollutantAbatement, val));
                    } else if (val.getWarningColor().equals("yellow")) {
                        PollutantAbatementParams pollutantAbatement = qualityNew.get(2);
                        qualityNew.set(2, changData(pollutantAbatement, val));
                    }
                } else {
                    //消减比列(%)
                    if (val.getWarningColor().equals("red")) {
                        PollutantAbatementParams pollutantAbatement = qualityNew.get(3);
                        qualityNew.set(3, changData(pollutantAbatement, val));
                    } else if (val.getWarningColor().equals("orange")) {
                        PollutantAbatementParams pollutantAbatement = qualityNew.get(4);
                        qualityNew.set(4, changData(pollutantAbatement, val));
                    } else if (val.getWarningColor().equals("yellow")) {
                        PollutantAbatementParams pollutantAbatement = qualityNew.get(5);
                        qualityNew.set(5, changData(pollutantAbatement, val));
                    }
                }
            });

            qualityNew.stream().forEach(pollutant -> {
                assessEmission1.setSceneId(assessScene.getSceneId());//场景id
                assessEmission1.setEmissionType("5");//减排类型code
                assessEmission1.setEmissionName("质量改善");//减排类型名称
                assessEmission1.setEmissionBigType(2);//减排大类型 1污染减排,2质量改善
                String warningType = pollutant.getWarningType();
                assessEmission1.setEmissionCompanyType(warningType);//减排单位类型code
                assessEmission1.setEmissionCompanyName(warningType.equals("1") ? "减排量" : "比例");//减排单位类型名称
                String warningColor = pollutant.getWarningColor();
                assessEmission1.setAlertLevel(warningColor);//颜色等级
                assessEmission1.setAlertLevelType(warningColor.equals("red") ? "1" : warningColor.equals("orange") ? "2" : "3");
                //污染物的值
                List<String> list = pollutant.getList();
                if (list == null) {
                    throw new IllegalArgumentException("未填写数据");
                }
                for (int o = 0; o < list.size(); o++) {
                    String value = list.get(o);
                    if (StringUtils.isNotBlank(value)) {
                        boolean matches = compile.matcher(value).matches();
                        if (!matches) {
                            throw new IllegalArgumentException("数据格式错误");
                        }
                    } else {
                        value = "0";//默认为0
                    }
                    if (o == 0) {
                        assessEmission1.setPm10(value);
                    } else if (o == 1) {
                        assessEmission1.setPm25(value);
                    } else if (o == 2) {
                        assessEmission1.setNox(value);
                    }
                }
                if (StringUtils.isBlank(pollutant.getId())) {
                    //创建时间
                    assessEmission1.resolveCreate(loginUser.getUserName());
                    assessEmission1.setEmissionId(idGenerator.getUniqueId());
                    assessEmissionMapper.insert(assessEmission1);
                } else {
                    assessEmission1.setEmissionId(pollutant.getId());
                    assessEmission1.resolveUpdate(loginUser.getUserName());
                    assessEmissionMapper.updateById(assessEmission1);
                }
            });
        }
    }

    /**
     * 保存场景
     */
    @Transactional
    public AssessScene saveOrEditScene(ScenarioParams scenarioParams, String mainId, LoginUserModel loginUser) throws
            InvocationTargetException, IllegalAccessException {
        AssessScene assessScene = new AssessScene();
        BeanUtils.copyProperties(assessScene, scenarioParams);
        assessScene.setMainId(mainId);
        //新增场景
        if (StringUtils.isBlank(scenarioParams.getSceneId())) {
            assessScene.resolveCreate(loginUser.getUserName());//创建时间
            assessScene.setSceneId(idGenerator.getUniqueId());
            assessSceneMapper.insert(assessScene);
        } else {
            assessScene.resolveUpdate(loginUser.getUserName());//更新日期
            assessSceneMapper.updateById(assessScene);
        }
        return assessScene;
    }

    /**
     * 保存污染物
     * @param pollutant
     * @param loginUser
     * @param assessScene
     * @param compile
     */
    @Transactional
    public void saveOrEditPolution(PollutantAbatementParams pollutant, LoginUserModel loginUser, AssessScene assessScene, Pattern compile) {
        AssessEmission assessEmission = new AssessEmission();
        assessEmission.setSceneId(assessScene.getSceneId());//场景id
        String emissionsType = pollutant.getEmissionsType();
        assessEmission.setEmissionType(emissionsType);//减排类型code
        String emissionName = emissionsType.equals("1") ? "建筑扬程减排" : emissionsType.equals("2") ? "工业减排" : emissionsType.equals("3") ? "机动车减排" : emissionsType.equals("4")?"其他减排":"全社会减排";
        assessEmission.setEmissionName(emissionName);//减排类型名称
        assessEmission.setEmissionBigType(1);//减排大类型 1污染减排,2质量改善
        String warningType = pollutant.getWarningType();
        assessEmission.setEmissionCompanyType(warningType);//减排单位类型code
        assessEmission.setEmissionCompanyName(warningType.equals("1") ? "减排量" : "比例");//减排单位类型名称
        String warningColor = pollutant.getWarningColor();
        assessEmission.setAlertLevel(warningColor);//颜色等级
        assessEmission.setAlertLevelType(warningColor.equals("red") ? "1" : warningColor.equals("orange") ? "2" : "3");
        //污染物的值
        List<String> list = pollutant.getList();
        if (list == null) {
            throw new IllegalArgumentException("未填写数据");
        }
        for (int m = 0; m < list.size(); m++) {
            String value = list.get(m);
            if (StringUtils.isNotBlank(value)) {
                boolean matches = compile.matcher(value).matches();
                if (!matches) {
                    throw new IllegalArgumentException("数据格式错误");
                }
            } else {
                value = "0";//默认为0
            }
            if (m == 0) {
                assessEmission.setPm10(value);
            } else if (m == 1) {
                assessEmission.setPm25(value);
            } else if (m == 2) {
                assessEmission.setSo2(value);
            } else if (m == 3) {
                assessEmission.setNox(value);
            } else if (m == 4) {
                assessEmission.setVocs(value);
            }
        }
        if (StringUtils.isBlank(pollutant.getId())) {
            assessEmission.setEmissionId(idGenerator.getUniqueId());
            //创建时间
            assessEmission.resolveCreate(loginUser.getUserName());
            assessEmissionMapper.insert(assessEmission);
        } else {
            assessEmission.setEmissionId(pollutant.getId());
            assessEmission.resolveUpdate(loginUser.getUserName());
            assessEmissionMapper.updateById(assessEmission);
        }
    }

    private PollutantAbatementParams changData(PollutantAbatementParams params, PollutantAbatementParams val) {
        PollutantAbatementParams pollutantAbatementParams = new PollutantAbatementParams();
        pollutantAbatementParams.setId(val.getId());
        pollutantAbatementParams.setWarningColor(val.getWarningColor());
        pollutantAbatementParams.setEmissionsType(val.getEmissionsType());
        pollutantAbatementParams.setWarningType(val.getWarningType());
        List<String> list = params.getList();
        if (list != null) {
            String s = val.getList().get(0);
            params.getList().add(s);
            return params;
        } else {
            pollutantAbatementParams.setList(val.getList());
        }
        return pollutantAbatementParams;
    }

    /**
     * 分页查询方案(未完善)
     *
     * @param query
     * @param pageInfo
     * @return
     */
    public Map<String, Object> getWeatherDayDataPage(ForecastQuery query, Paging<AssessMain> pageInfo) {
        HashMap<String, Object> resultMap = new HashMap<>();
        LambdaQueryWrapper<AssessMain> queryWrapper = Wrappers.lambdaQuery();
        Date startTime = query.getStartTime();
        Date endTime = query.getEndTime();
        queryWrapper.select(AssessMain::getAssessName, AssessMain::getDate, AssessMain::getPkid, AssessMain::getRemark, AssessMain::getCreateTime);
        queryWrapper.ge(startTime != null, AssessMain::getStartTime, startTime);
        queryWrapper.le(endTime != null, AssessMain::getStartTime, endTime);
        queryWrapper.eq(AssessMain::getAssessType,query.getAssessType());
        queryWrapper.orderByDesc(AssessMain::getStartTime);
        resultMap.put("data", PageSelectUtil.selectListPage1(assessMainMapper, pageInfo, AssessMainMapper::selectList, queryWrapper));
        return resultMap;
    }

    /**
     * 编辑方案
     *
     * @param assessMain(未完善)
     */
    @Transactional
    public void editAssessMain(AssessMain assessMain) {
        String pkid = assessMain.getPkid();
        if (StringUtils.isNotBlank(pkid)) {
            String[] split = pkid.split(",");
            assessMain.setUpdateTime(DateUtil.parse(DateUtil.getNowDateTime(), "yyyy-MM-dd HH:mm:ss"));
            LambdaUpdateWrapper<AssessMain> updateWrapper = Wrappers.lambdaUpdate(AssessMain.class);
            updateWrapper.set(AssessMain::getDeleteFlag, assessMain.getDeleteFlag());
            updateWrapper.in(AssessMain::getPkid, split);
            assessMainMapper.update(assessMain, updateWrapper);
        } else {
            throw new IllegalArgumentException("未选择的选项");
        }
    }

    /**
     * 根据方案id 获取场景以及数据
     *
     * @param param
     * @return
     */
    public AddOrEditAfterAssesParams getAfterAssesById(Map<String, Object> param) {
        String id = MapUtils.getString(param, "id");
        if (StringUtils.isNotBlank(id)) {
            AddOrEditAfterAssesParams result = new AddOrEditAfterAssesParams();//创建结果集
            //1先获取方案
            AssessMain assessMain = assessMainMapper.selectById(id);
            if (assessMain != null) {
                result.setPkid(id);//主键id
                result.setRemark(assessMain.getRemark());//备注
                result.setAssessName(assessMain.getAssessName());//方案名称
                result.setStartTime(assessMain.getStartTime());
                result.setEndTime(assessMain.getEndTime());
                //2获取改方案下的所有场景
                LambdaQueryWrapper<AssessScene> queryWrapper = Wrappers.lambdaQuery();
                queryWrapper.eq(AssessScene::getMainId, id);
                List<AssessScene> assessSceneList = assessSceneMapper.selectList(queryWrapper);
                List<ScenarioParams> scenarioParamsList = new ArrayList<>();//创建场景vo,初始容器
                AtomicReference<Integer> index = new AtomicReference<>(0);
                if (assessSceneList != null && assessSceneList.size() > 0) {
                    assessSceneList.stream().forEach((assessScene) -> {//遍历场景
                        ScenarioParams scenarioParams = new ScenarioParams();//创建场景vo
                        scenarioParams.setSceneId(assessScene.getSceneId());
                        scenarioParams.setSceneName(assessScene.getSceneName());
                        scenarioParams.setActive(false);//默认补选中
                        scenarioParams.setIndex(index.get());
                        scenarioParams.setAriaHidden(true);
                        if (index.get() == 0) {
                            scenarioParams.setActive(true);
                        }
                        index.getAndSet(index.get() + 1);
                        //3根据场景获取减排数据
                        LambdaQueryWrapper<AssessEmission> queryWrapperEmission = Wrappers.lambdaQuery();
                        queryWrapperEmission.eq(AssessEmission::getSceneId, assessScene.getSceneId());
                        queryWrapperEmission.orderByAsc(AssessEmission::getEmissionType, AssessEmission::getEmissionCompanyType
                                , AssessEmission::getAlertLevelType);
                        List<AssessEmission> assessEmissions = assessEmissionMapper.selectList(queryWrapperEmission);
                        List<PollutantAbatementParams> pollutantList = new ArrayList<>();//创建排放容器
                        List<PollutantAbatementParams> quality = new ArrayList<>();//创建质量容器
                        assessEmissions.stream().forEach(assessEmission -> {//遍历排放数据
                            String pm10 = assessEmission.getPm10();
                            String pm25 = assessEmission.getPm25();
                            String so2 = assessEmission.getSo2();
                            String nox = assessEmission.getNox();
                            String vocs = assessEmission.getVocs();
                            if (assessEmission.getEmissionType().equals("5")) {//质量改善,一行三个字段需要拆分成三个集合
                                //PM10
                                PollutantAbatementParams pollutantAbatementParams1 = new PollutantAbatementParams();
                                pollutantAbatementParams1.setId(assessEmission.getEmissionId());//主键
                                pollutantAbatementParams1.setWarningColor(assessEmission.getAlertLevel());//颜色等级
                                pollutantAbatementParams1.setWarningType(assessEmission.getEmissionCompanyType());//排放类型
                                pollutantAbatementParams1.setEmissionsType("5");
                                pollutantAbatementParams1.setDataType("1");
                                List<String> listPm10 = new ArrayList<>();
                                listPm10.add(pm10);
                                pollutantAbatementParams1.setList(listPm10);
                                quality.add(pollutantAbatementParams1);
                                //PM25
                                PollutantAbatementParams pollutantAbatementParams2 = new PollutantAbatementParams();
                                pollutantAbatementParams2.setId(assessEmission.getEmissionId());//主键
                                pollutantAbatementParams2.setWarningColor(assessEmission.getAlertLevel());//颜色等级
                                pollutantAbatementParams2.setWarningType(assessEmission.getEmissionCompanyType());//排放类型
                                pollutantAbatementParams2.setEmissionsType("5");
                                pollutantAbatementParams2.setDataType("2");
                                List<String> listPm25 = new ArrayList<>();
                                listPm25.add(pm25);
                                pollutantAbatementParams2.setList(listPm25);
                                quality.add(pollutantAbatementParams2);
                                //NO2
                                PollutantAbatementParams pollutantAbatementParams3 = new PollutantAbatementParams();
                                pollutantAbatementParams3.setId(assessEmission.getEmissionId());//主键
                                pollutantAbatementParams3.setWarningColor(assessEmission.getAlertLevel());//颜色等级
                                pollutantAbatementParams3.setWarningType(assessEmission.getEmissionCompanyType());//排放类型
                                pollutantAbatementParams3.setEmissionsType("5");
                                pollutantAbatementParams3.setDataType("3");
                                List<String> listNo2 = new ArrayList<>();
                                listNo2.add(nox);
                                pollutantAbatementParams3.setList(listNo2);
                                quality.add(pollutantAbatementParams3);

                            } else {//其它
                                PollutantAbatementParams pollutantAbatementParams = new PollutantAbatementParams();
                                pollutantAbatementParams.setId(assessEmission.getEmissionId());//主键
                                pollutantAbatementParams.setWarningColor(assessEmission.getAlertLevel());//颜色等级
                                pollutantAbatementParams.setWarningType(assessEmission.getEmissionCompanyType());//排放类型
                                List<String> list = new ArrayList<>();
                                list.add(pm10);
                                list.add(pm25);
                                list.add(so2);
                                list.add(nox);
                                list.add(vocs);
                                pollutantAbatementParams.setList(list);//添加排放数据
                                pollutantAbatementParams.setEmissionsType(assessEmission.getEmissionType());
                                pollutantList.add(pollutantAbatementParams);
                            }
                        });
                        scenarioParams.setPollutantList(pollutantList);//放入减排数据
                        scenarioParams.setQuality(quality);//放入质量信息
                        scenarioParamsList.add(scenarioParams);
                    });
                }
                result.setList(scenarioParamsList);//将所有场景,放入方案里
                return result;
            }

        }
        return null;
    }

    /**
     * 删除或者编辑场景
     *
     * @param assessScene
     */
    @Transactional
    public void editAssessScene(AssessScene assessScene) {
        AssessScene assessSceneOld = assessSceneMapper.selectById(assessScene.getSceneId());
        if (assessSceneOld != null) {
            LambdaUpdateWrapper<AssessScene> updateWrapper = Wrappers.lambdaUpdate(assessScene);
            updateWrapper.set(AssessScene::getDeleteFlag, assessScene.getDeleteFlag());
            assessSceneOld.setUpdateTime(DateUtil.parse(DateUtil.getNowDateTime(), "yyyy-MM-dd HH:mm:ss"));
            assessSceneMapper.update(assessSceneOld, updateWrapper);
        }
    }

    /**
     * 导出excel数据
     *
     * @param param
     */
    public void exportExcel(Map<String, Object> param, HttpServletResponse response) throws IOException {
        AddOrEditAfterAssesParams afterAssesById = getAfterAssesById(param);//
        Integer tabIndex = MapUtils.getInteger(param, "index", 0);
        ScenarioParams scenarioParams = afterAssesById.getList().get(tabIndex);//获取第几个场景数据
        List<PollutantAbatementParams> pollutantList = scenarioParams.getPollutantList();//污染物减排信息
        List<PollutantAbatementParams> qualityList = scenarioParams.getQuality();
        //读取模板
        FileInputStream in = new FileInputStream(getFilePath("pollutionReduction.xlsx"));
        //读取excel模板
        XSSFWorkbook wb = new XSSFWorkbook(in);
        //读取了模板内所有sheet内容
        XSSFSheet sheet = wb.getSheetAt(0);//污染物减排信息
        XSSFSheet sheet2 = wb.getSheetAt(1);//质量改善信息>>
        for (int i = 0; i < 5; i++) {//总行数
            int finalI = i;
            AtomicInteger index = new AtomicInteger(2);//自增,当前行的第几格
            XSSFRow row = sheet.getRow(finalI + 3);//当前行
            String typeCode = (finalI == 4 ? 6 : (finalI + 1)) + "";//获取类型
            pollutantList.stream().filter(pollutant -> pollutant.getEmissionsType().equals(typeCode))
                    .collect(Collectors.toList())
                    .forEach(item -> {
                        List<String> list = item.getList();
                        for (int j = 0; j < 5; j++) {
                            String s = list.get(j);
                            int i1 = index.get();
                            XSSFCell cell = row.getCell(i1);//获取当前单元格
                            if (cell != null) {
                                cell.setCellValue(s);//给当前单元格设置值
                                index.getAndIncrement();//每次增加一格
                            }
                        }
                    });
        }

        for (int i = 0; i < 3; i++) {////总行数
            XSSFRow row = sheet2.getRow(i + 3);//当前行
            int finalI = i;
            AtomicInteger index = new AtomicInteger(1);//自增,当前行的第几格
            String typeCode = (finalI + 1) + "";//获取类型
            qualityList.stream().filter(quality -> quality.getDataType().equals(typeCode))
                    .collect(Collectors.toList())
                    .forEach(item -> {
                        XSSFCell cell = row.getCell(index.get());//获取当前单元格
                        if (cell != null) {
                            String s = item.getList().get(0);
                            cell.setCellValue(s);//给当前单元格设置值
                            index.getAndIncrement();//每次增加一格
                        }
                    });
        }
        //导出excel
        outExcelToClient(response, wb, scenarioParams.getSceneName().concat(".xlsx"));
    }


    private String getFilePath(String fileName) throws UnsupportedEncodingException {
        String root = ExcelUtil.class.getResource("/").getPath();
        if (root.indexOf("target") >= 0) {
            root = root.substring(1, root.indexOf("target"));
            root = root.replaceAll("/", "\\\\");
            root = root + "src\\main\\webapp" + File.separator + "assets" + File.separator + "template" + File.separator + fileName;
        } else {
            root = root.substring(1, root.indexOf("WEB-INF"));
            root = root.replaceAll("/", "\\\\");
            root = root + "assets" + File.separator + "template" + File.separator + fileName;
        }

        return URLDecoder.decode(root, "GBK");
    }

    private void outExcelToClient(HttpServletResponse response, Workbook wb, String fileName) {
        OutputStream out = null;
        try {
            response.addHeader("Content-Disposition", "attachment; filename=" + URLEncoder.encode(fileName, "UTF-8"));
            response.setContentType("application/vnd.ms-excel; charset=UTF-8");
            out = response.getOutputStream();
            wb.write(out);
            out.flush();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (out != null) {
                try {
                    out.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}

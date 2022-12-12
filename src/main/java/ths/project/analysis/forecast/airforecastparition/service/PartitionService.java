package ths.project.analysis.forecast.airforecastparition.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import ths.jdp.core.context.PropertyConfigure;
import ths.jdp.core.web.LoginCache;
import ths.jdp.core.web.RequestHelper;
import ths.jdp.eform.service.components.word.DocDynamicTable;
import ths.jdp.eform.service.components.word.DocDynamicTable.InnerDocTable;
import ths.jdp.eform.service.components.word.DocImage;
import ths.jdp.eform.service.components.word.DocSuperAndSub;
import ths.jdp.eform.service.components.word.DocumentPage;
import ths.jdp.eform.service.components.word.RepDocTemplate;
import ths.project.analysis.forecast.airforecastcity.entity.AnsFlowInfo;
import ths.project.analysis.forecast.airforecastparition.entity.FlowArea24H;
import ths.project.analysis.forecast.airforecastparition.entity.FlowArea3D;
import ths.project.analysis.forecast.airforecastparition.entity.FlowAreaInfo;
import ths.project.analysis.forecast.airforecastparition.entity.FlowAreaTips;
import ths.project.analysis.forecast.airforecastparition.mapper.FlowArea24hMapper;
import ths.project.analysis.forecast.airforecastparition.mapper.FlowArea3DMapper;
import ths.project.analysis.forecast.airforecastparition.mapper.FlowAreaInfoMapper;
import ths.project.analysis.forecast.airforecastparition.mapper.FlowAreaTipsMapper;
import ths.project.analysis.forecast.report.entity.GeneralReport;
import ths.project.analysis.forecast.report.enums.AnalysisStateEnum;
import ths.project.analysis.forecast.report.enums.AscriptionTypeEnum;
import ths.project.analysis.forecast.report.service.GeneralReportService;
import ths.project.common.data.DiskMultipartFile;
import ths.project.common.uid.SnowflakeIdGenerator;
import ths.project.common.util.*;
import ths.project.system.base.util.BatchSqlSessionUtil;
import ths.project.system.file.entity.CommFile;
import ths.project.system.file.mapper.CommFileMapper;
import ths.project.system.file.service.CommFileService;

import javax.annotation.Resource;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.CountDownLatch;

@Service
public class PartitionService {
    /**
     * 通用文件-服务层
     */
    @Autowired
    private FlowAreaTipsMapper flowAreaTipsMapper;
    @Autowired
    private CommFileService commFileService;
    @Autowired
    private GeneralReportService generalReportService;
    @Autowired
    private CommFileMapper commFileMapper;
    @Autowired
    private FlowArea24hMapper flowArea24hMapper;
    @Autowired
    private FlowArea3DMapper flowArea3DMapper;
    @Autowired
    private FlowAreaInfoMapper flowAreaInfoMapper;
    @Autowired
    SnowflakeIdGenerator idGenerator;

    /**
     * 异步线程池，详情参考spring-thread.xml
     */
    @Resource
    private ThreadPoolTaskExecutor threadPoolTaskExecutor;

    private final String FILE_ROOT_TEMP_PATH = CommFileService.FILE_ROOT_TEMP_PATH;
    private final String FILE_ROOT_PATH = CommFileService.FILE_ROOT_PATH;

    /**
     * 获取成都市区县
     *
     * @return
     */
    public List<Map<String, Object>> getcountrys() {
        return flowAreaInfoMapper.getcountrys();
    }

    /**
     * 获取填报人列表
     *
     * @return
     */
    public List<Map<String, Object>> getCreateUser() {
        return flowAreaInfoMapper.getCreateUser();
    }

    /**
     * 分区预报信息
     *
     * @param paramMap
     * @return
     */
    public Map<String, Object> getForecastFlowInfo(Map<String, Object> paramMap) {
        return flowAreaInfoMapper.getForecastFlowInfo(paramMap);
    }

    /**
     * 分区预报3天列表
     *
     * @param map
     * @return
     */
    public List<Map<String, Object>> getArea3DData(Map<String, Object> map) {
        return flowArea3DMapper.getArea3DData(map);
    }

    /**
     * 分区重要提示列表
     *
     * @param map
     * @return
     */
    public List<Map<String, Object>> getAreaTipsData(Map<String, Object> map) {
        return flowAreaInfoMapper.getAreaTipsData(map);
        // return dao.list(map, sqlPackage + ".getAreaTipsData");
    }

    /**
     * 分区预报24小时列表
     *
     * @param map
     * @return
     */
    public List<Map<String, Object>> getArea24hData(Map<String, Object> map) {
        return flowArea24hMapper.getArea24hData(map);
    }

    /**
     * 增加分区预报数据
     *
     * @param paramMap
     * @param areas
     * @param countrys3d
     * @throws Exception
     */
    @SuppressWarnings({"unchecked", "rawtypes"})
    @Transactional
    public Map<String, Object> addForecastFlowInfo(Map<String, Object> paramMap, List<Map<String, Object>> areas, List<Map<String, Object>> countrys3d, MultipartFile[] multipartFiles) throws Exception {
        String pkid = paramMap.get("FORECAST_ID").toString();
        // 区县重要提示列表
        List<Map<String, Object>> countrysTips = JsonUtil.toList((String) paramMap.get("COUNTRYS_TIPS"));
        paramMap.put("CREATE_TIME", paramMap.get("FORECAST_TIME").toString());
        paramMap.put("FLOW_STATE", "TEMP".equals(paramMap.get("STATE").toString()) ? 0 : 1);
        long flowState = "TEMP".equals(paramMap.get("STATE").toString()) ? 0 : 1;
        // 封装reportMap,专门 向T_ANS_GENERAL_REPORT插入数据
        String reportName = paramMap.get("FORECAST_TIME").toString().replaceAll("-", "");
        reportName = reportName + "分区预报";
        paramMap.put("reportType", "");
        GeneralReport report = new GeneralReport();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        report.setReportId(pkid);
        report.setAscriptionType(AscriptionTypeEnum.PARTITION_FORECAST.getValue());
        report.setReportFrequency("09".compareToIgnoreCase(reportName.substring(6, 8)) >= 0 ? reportName.substring(7, 8) : reportName.substring(6, 8));
        report.setReportName(reportName);
        report.setReportTime(sdf.parse(paramMap.get("FORECAST_TIME").toString()));
        report.setReportRate("DAY");
        report.setReportTip(paramMap.get("HINT").toString());
        report.setState(paramMap.get("STATE").toString());
        report.setIsMain(paramMap.get("STATE").toString().equals("UPLOAD") ? 1 : 0);
        FlowAreaInfo flowAreaInfo = new FlowAreaInfo(sdf.parse(paramMap.get("FORECAST_TIME").toString()), paramMap.get("CREATE_USER").toString(),
                null, paramMap.get("SAVE_USER").toString(), flowState, paramMap.get("AREA_OPINION").toString(), null,
                paramMap.get("INSCRIBE").toString(), paramMap.get("HINT").toString());
        if (pkid == null || "".equals(pkid)) {
            // 新增文件和主信息
            pkid = generalReportService.saveReport(report, multipartFiles, "");
            paramMap.put("PKID", pkid);
            flowAreaInfo.setPkid(pkid);
            flowAreaInfoMapper.insert(flowAreaInfo);
        } else {
            // 修改文件和主信息
            paramMap.put("PKID", pkid);
            generalReportService.saveReport(report, multipartFiles, "");
            flowAreaInfo.setPkid(pkid);
            flowAreaInfoMapper.updateById(flowAreaInfo);
            flowArea3DMapper.delete(Wrappers.lambdaQuery(FlowArea3D.class).eq(FlowArea3D::getAreaPkid, pkid));
            flowArea24hMapper.delete(Wrappers.lambdaQuery(FlowArea24H.class).eq(FlowArea24H::getAreaPkid, pkid));
        }
        //如果提交预报，则修改当天其他人的所有预报数据状态为提交
        if ("UPLOAD".equals(paramMap.get("STATE").toString())) {
            updateAllState(paramMap);
        }
        //保存区县预报数据
        List<FlowArea3D> countrys3dList = new ArrayList<>();
        FlowArea3D flowArea3D = null;
        for (Map map : countrys3d) {
            flowArea3D = new FlowArea3D();
            MapUtil.toBeanByUpperName(map, flowArea3D);
            Date dt = sdf.parse(ParamUtils.getString(paramMap, "FORECAST_TIME"));
            flowArea3D.setPkid(UUID.randomUUID().toString());
            flowArea3D.setCreateTime(dt);
            flowArea3D.setAreaPkid(pkid);
            Calendar createTime = Calendar.getInstance();
            createTime.setTime(dt);
            createTime.add(Calendar.DATE, 1);
            flowArea3D.setForecastDate1(createTime.getTime());
            createTime.add(Calendar.DATE, 1);
            flowArea3D.setForecastDate2(createTime.getTime());
            createTime.add(Calendar.DATE, 1);
            flowArea3D.setForecastDate3(createTime.getTime());
            countrys3dList.add(flowArea3D);
        }

        if (countrys3dList != null && countrys3dList.size() > 0) {
            BatchSqlSessionUtil.insertBatch(flowArea3DMapper, countrys3dList);
        }
        //保存区县重要提示
        List<FlowAreaTips> countrysTipsList = new ArrayList<>();
        FlowAreaTips flowAreaTips = null;
        for (Map<String, Object> map : countrysTips) {
            flowAreaTips = new FlowAreaTips();
            MapUtil.toBeanByUpperName(map, flowAreaTips);
            flowAreaTips.setPkid(UUIDUtil.randomUUID().toString());
            flowAreaTips.setInfoId(pkid);
            flowAreaTips.setCreateTime(sdf.parse(ParamUtils.getString(paramMap, "FORECAST_TIME")));
            map.put("PKID", UUIDUtil.getUniqueId());
            map.put("INFO_ID", pkid);
            map.put("CREATE_TIME", ParamUtils.getString(paramMap, "FORECAST_TIME"));
            countrysTipsList.add(flowAreaTips);
        }
        if (countrysTipsList != null && countrysTipsList.size() > 0) {
            BatchSqlSessionUtil.insertBatch(flowAreaTipsMapper, countrysTipsList);
        }
        return paramMap;
    }

    /**
     * 一条预报数据提交，修改当天所有预报为已提交
     */
    @Transactional
    public void updateAllState(Map<String, Object> paramMap) {
        FlowAreaInfo flowAreaInfo = new FlowAreaInfo();
        flowAreaInfo.setFlowState(Integer.parseInt(paramMap.get("FLOW_STATE").toString()));
        LambdaQueryWrapper<FlowAreaInfo> flowInfoWrapper = Wrappers.lambdaQuery();
        flowInfoWrapper.eq(FlowAreaInfo::getCreateTime, DateUtil.parseDate(paramMap.get("FORECAST_TIME").toString()));
        flowAreaInfoMapper.update(flowAreaInfo, flowInfoWrapper);
        generalReportService.update(Wrappers.lambdaUpdate(GeneralReport.class)
                .set(GeneralReport::getState, paramMap.get("STATE"))
                .eq(GeneralReport::getReportTime, DateUtil.parseDate(paramMap.get("FORECAST_TIME").toString()))
                .eq(GeneralReport::getAscriptionType, AscriptionTypeEnum.PARTITION_FORECAST.getValue()));
    }

    /**
     * 生成区县预报数据
     *
     * @param paramMap
     * @param isTransToPDF
     * @param destPath
     * @throws Exception
     */
    public void buildWord2(Map<String, Object> paramMap, boolean isTransToPDF, String destPath, List<Map<String, Object>> countrysTips) throws Exception {
        // 处理各区县重要提示
        Map<String, Object> countyMap = new HashMap<String, Object>();
        for (int i = 0; i < countrysTips.size(); i++) {
            Map<String, Object> map = countrysTips.get(i);
            if (!StringUtils.isBlank((String) map.get("REGION_NAME")) && !StringUtils.isBlank((String) map.get("IMPORTANT_HINTS"))) {
                // 每个区县重要提示所包含的区县code
                String[] regionCodes = map.get("REGION_NAME").toString().split(",");
                for (int j = 0; j < regionCodes.length; j++) {
                    String code = regionCodes[j].trim();
                    // 如果countyMap没有该区县的code
                    if (StringUtils.isBlank((String) countyMap.get(code))) {
                        countyMap.put(code, map.get("IMPORTANT_HINTS").toString());
                    } else {
                        String str = countyMap.get(code).toString() + "；" + map.get("IMPORTANT_HINTS").toString();
                        countyMap.put(code, str);
                    }
                }
            }
        }
        // 预报id
        String pkId = paramMap.get("PKID").toString();
        List<Map<String, Object>> form3d = getArea3DData(paramMap);
        // 文件id
        String fileId = idGenerator.getUniqueId();
        // 模板
        String templatePath = RequestHelper.getRequest().getServletContext().getRealPath("/assets/template/countyForecast72HoursModel.docx");
        // 保存临时路径
        String fileSavePathTemp = FILE_ROOT_TEMP_PATH + File.separator + pkId;
        // 压缩文件临时路径
        String filePathTemp = FILE_ROOT_TEMP_PATH + File.separator + pkId + ".zip";
        // 压缩文件路径
        String filePath = FILE_ROOT_PATH + File.separator + AscriptionTypeEnum.PARTITION_FORECAST + File.separator + pkId + ".zip";
        String fileName = "空气质量预报";
        String title = "未来24、48、72小时空气质量预报";
        // 报告时间
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat fileDateFormat = new SimpleDateFormat("yyyyMMdd");
        SimpleDateFormat reportFormat = new SimpleDateFormat("yyyy年M月d日");
        String time = paramMap.get("FORECAST_TIME").toString();
        String fileTime = fileDateFormat.format(dateFormat.parse(time));
        String reportTime = reportFormat.format(dateFormat.parse(time));
        Calendar ca = Calendar.getInstance();
        ca.setTime(dateFormat.parse(time));//实例化一个日期
        String nper = time.substring(0, 4) + "年第" + ca.get(Calendar.DAY_OF_YEAR) + "期";
        // 获取当前操作用户
        String userName = LoginCache.getLoginUser().getUserName();
        //倒计时锁存器，在完成一组正在其他线程中执行的操作之前，它允许一个或多个线程一直等待
        final CountDownLatch latch = new CountDownLatch(22);
        // 循环生成word
        for (int m = 0; m < form3d.size(); m++) {
            final int i = m;
            threadPoolTaskExecutor.execute(new Runnable() {
                @Override
                public void run() {
                    try {
                        Map<String, Object> map = form3d.get(i);
                        String regionName = map.get("REGIONNAME").toString();
                        // 报告名称
                        String reportName = regionName + fileName + fileTime;
                        // 文档参数Map(文字部分)
                        Map<String, Object> docParamMap = new HashMap<String, Object>();
                        docParamMap.put("TITLE", regionName);
                        docParamMap.put("NPER", nper);
                        docParamMap.put("REPORTTIME", reportTime);
                        docParamMap.put("REPORTNAME", regionName + title);
                        // 组装文本内容
                        StringBuilder builder = new StringBuilder();
                        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                        SimpleDateFormat forecatFormat = new SimpleDateFormat("M月d日");
                        String date = forecatFormat.format(dateFormat.parse(ParamUtils.getString(map, "FORECAST_DATE1")));
                        int aqiStart = Integer.valueOf(map.get("AQI_START1").toString());
                        int aqiEnd = Integer.valueOf(map.get("AQI_END1").toString());
                        // AQI范围
                        String aqi = aqiStart + "-" + aqiEnd;
                        // 空气质量等级
                        String before = getLevel(aqiStart);
                        String after = getLevel(aqiEnd);
                        String result = getForecastLevel(before, after);
                        String forecastStr = date + "预计AQI为" + aqi + "，空气质量等级为" + result;
                        builder.append(forecastStr);
                        if (StringUtils.isBlank((String) map.get("PULLNAME1"))) {
                            builder.append("。");
                        } else {
                            builder.append("，首要污染物为" + map.get("PULLNAME1").toString().trim());
                        }
                        builder.append("\r\n");
                        date = forecatFormat.format(dateFormat.parse(ParamUtils.getString(map, "FORECAST_DATE2")));
                        aqiStart = Integer.valueOf(map.get("AQI_START2").toString());
                        aqiEnd = Integer.valueOf(map.get("AQI_END2").toString());
                        // AQI范围
                        aqi = aqiStart + "-" + aqiEnd;
                        // 空气质量等级
                        before = getLevel(aqiStart);
                        after = getLevel(aqiEnd);
                        result = getForecastLevel(before, after);
                        forecastStr = date + "预计AQI为" + aqi + "，空气质量等级为" + result;
                        builder.append(forecastStr);
                        if (StringUtils.isBlank((String) map.get("PULLNAME2"))) {
                            builder.append("。");
                        } else {
                            builder.append("，首要污染物为" + map.get("PULLNAME2").toString().trim());
                        }
                        builder.append("\r\n");
                        date = forecatFormat.format(dateFormat.parse(ParamUtils.getString(map, "FORECAST_DATE3")));
                        aqiStart = Integer.valueOf(map.get("AQI_START3").toString());
                        aqiEnd = Integer.valueOf(map.get("AQI_END3").toString());
                        // AQI范围
                        aqi = aqiStart + "-" + aqiEnd;
                        // 空气质量等级
                        before = getLevel(aqiStart);
                        after = getLevel(aqiEnd);
                        result = getForecastLevel(before, after);
                        forecastStr = date + "预计AQI为" + aqi + "，空气质量等级为" + result;
                        builder.append(forecastStr);
                        if (StringUtils.isBlank((String) map.get("PULLNAME3"))) {
                            builder.append("。");
                        } else {
                            builder.append("，首要污染物为" + map.get("PULLNAME3").toString().trim() + "。");
                        }
                        builder.append("\r\n");
                        // 重要提示
                        if (!StringUtils.isBlank((String) countyMap.get(regionName))) {
                            String tip = "重要提示：" + countyMap.get(regionName).toString().trim();
                            builder.append(tip);
                        }
                        docParamMap.put("FORECAST_STR", builder);
                        docParamMap.put("USERNAME", userName);
                        // 文档体参数对象
                        DocumentPage documentPage = new DocumentPage();
                        // 将文本插入到文档中
                        documentPage.setParamMap(docParamMap);
                        RepDocTemplate repDocTemplate = new RepDocTemplate();
                        repDocTemplate.saveWord(documentPage, null, null, reportName, templatePath, false, fileSavePathTemp);
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        latch.countDown();
                    }
                }
            });
        }
        latch.await();
        // 压缩word
        ZipUtil.zip(fileSavePathTemp, filePathTemp);
        File file = new File(filePathTemp);
        String name = title + "-" + fileTime + file.getName().substring(file.getName().lastIndexOf("."));
        MultipartFile multipartFile = new DiskMultipartFile(name, name, file);
        CommFile commFile = commFileService.saveUploadFileToDisk(multipartFile);
        // 插入数据库文件记录
        commFile.setFileId(fileId);
        commFile.setAscriptionType(AscriptionTypeEnum.PARTITION_FORECAST.getValue());
        commFile.setAscriptionId(pkId);
        commFile.setFileAlias(pkId + ".zip");
        commFile.setTransform("N");
        commFile.setFileSource("COMPRESSION");
        commFileService.deleteFileByFileSource(commFile.getAscriptionId(), commFile.getFileSource());
        commFile.resolveCreate(userName);
        commFileMapper.insert(commFile);
        // 删除本地word文件记录
        File directory = new File(fileSavePathTemp);
        FileUtils.deleteDirectory(directory);
        //删除临时zip文件
        File directoryZip = new File(filePathTemp);
        FileUtils.deleteQuietly(directoryZip);
    }

    /**
     * 获取aqi等级
     *
     * @param value
     * @return
     */
    public String getLevel(int value) {
        String result = "";
        if (0 <= value && value <= 50) {
            result = "优";
        } else if (50 < value && value <= 100) {
            result = "良";
        } else if (100 < value && value <= 150) {
            result = "轻度污染";
        } else if (150 < value && value <= 200) {
            result = "中度污染";
        } else if (200 < value && value <= 300) {
            result = "重度污染";
        } else if (300 < value) {
            result = "严重污染";
        } else {
            result = "无";
        }
        return result;
    }

    /**
     * 获取预报等级
     *
     * @param before
     * @param after
     * @return
     */
    public String getForecastLevel(String before, String after) {
        String result = "";
        if (before == after) {
            result = before;
        } else {
            if (before == "优" || before == "良") {
                result = before + "至" + after;
            } else {
                result = before.substring(0, 2) + "至" + after;
            }
        }
        return result;
    }

    /**
     * 分区预报数据导出
     *
     * @param paramMap
     * @param isTransToPDF
     * @return
     * @throws Exception
     */
    @SuppressWarnings("deprecation")
    public String buildWord(Map<String, Object> paramMap, boolean isTransToPDF, String destPath) throws Exception {

        // 根据id,查询分区预报信息
        Map<String, Object> flowInfo = getForecastFlowInfo(paramMap);

        String datetime = ParamUtils.getString(flowInfo, "CREATE_TIME");
        // 定义模板路径和名称
        String fileName = "成都市区县未来24、48、72小时空气质量分区预报-" + datetime.replaceAll("-", "");
        String templatePath = RequestHelper.getRequest().getServletContext().getRealPath("/assets/template/areaForecast24HoursModel.docx");
        String childPath = RequestHelper.getRequest().getServletContext().getRealPath("/assets/template/AreaChild.docx");
        // 定义区县重要提示列表子表单模板
        // String childPath_tips=FileUtil.getTemplateFilePath("AreaChildTipsList.docx");
        DocumentPage page = new DocumentPage();

        Map<String, Object> pMap = new HashMap<String, Object>();

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat dateFormatMd = new SimpleDateFormat("yyyy年M月d日");

        String dateStr = dateFormatMd.format(dateFormat.parse(datetime));
        if (flowInfo.get("AREA_OPINION") != null) {
            String str = flowInfo.get("AREA_OPINION").toString().trim();
            if (str.endsWith("。")) {
                pMap.put("FORECAST_STR", str);
            } else {
                pMap.put("FORECAST_STR", str + "。");
            }
        } else {
            pMap.put("FORECAST_STR", "--");
        }

        if (flowInfo.get("HINT") != null && !"".equals(flowInfo.get("HINT"))) {
            String str = flowInfo.get("HINT").toString().trim();
            if (str.endsWith("。")) {
                pMap.put("IMPORTANT_HINTS", "重要提示：" + str);
            } else {
                pMap.put("IMPORTANT_HINTS", "重要提示：" + str + "。");
            }
        } else {
            pMap.put("IMPORTANT_HINTS", "");
        }
        if (ParamUtils.getString(flowInfo, "INSCRIBE") != null && !"".equals(ParamUtils.getString(flowInfo, "INSCRIBE"))) {
            pMap.put("INSCRIBE", ParamUtils.getString(flowInfo, "INSCRIBE"));
        } else {
            pMap.put("INSCRIBE", "");
        }

        pMap.put("CREATE_TIME_CH", dateStr);

        page.setParamMap(pMap);

        // 表格数据
        List<Map<String, Object>> tableList = this.getArea3DData(flowInfo);
        // 定义Word模板动态表格替换的map
        Map<String, DocDynamicTable> paramDynamicTableMap = new HashMap<String, DocDynamicTable>();
        // 封装循环动态表的数据
        DocDynamicTable cycleTable = new DocDynamicTable();
        // 生成第一个单表
        InnerDocTable innerTable = cycleTable.getMultiTable().newDocTable();
        // 设置数据开始开始行
        innerTable.setDataRowStarts(new int[]{3});
        Map<String, Object> tableMap = new HashMap<String, Object>();
        if (tableList.size() > 0) {
            tableMap.put("FORECAST_DATE1", ParamUtils.getString(tableList.get(0), "FORECAST_DATE1"));
            tableMap.put("FORECAST_DATE2", ParamUtils.getString(tableList.get(0), "FORECAST_DATE2"));
            tableMap.put("FORECAST_DATE3", ParamUtils.getString(tableList.get(0), "FORECAST_DATE3"));
        }
        innerTable.setParamMap(tableMap);
        for (int i = 0; i < tableList.size(); i++) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("REGION", ParamUtils.getString(tableList.get(i), "REGIONNAME"));
            map.put("AQI1", ParamUtils.getString(tableList.get(i), "AQI_START1", "") + "-" + ParamUtils.getString(tableList.get(i), "AQI_END1", ""));
            String pull1 = ParamUtils.getString(tableList.get(i), "PULLNAME1", "");
            if ("".equals(pull1)) {
                map.put("PULL1", "--");
            } else {
                map.put("PULL1", pull1);
            }
            map.put("AQI2", ParamUtils.getString(tableList.get(i), "AQI_START2", "") + "-" + ParamUtils.getString(tableList.get(i), "AQI_END2", ""));
            String pull2 = ParamUtils.getString(tableList.get(i), "PULLNAME2", "");
            if ("".equals(pull2)) {
                map.put("PULL2", "--");
            } else {
                map.put("PULL2", pull2);
            }
            map.put("AQI3", ParamUtils.getString(tableList.get(i), "AQI_START3", "") + "-" + ParamUtils.getString(tableList.get(i), "AQI_END3", ""));
            String pull3 = ParamUtils.getString(tableList.get(i), "PULLNAME3", "");
            if ("".equals(pull3)) {
                map.put("PULL3", "--");
            } else {
                map.put("PULL3", pull3);
            }
            innerTable.addRow(map);
        }
        // 设置子模板全路径
        cycleTable.getMultiTable().setModelPath(childPath);
        // 将动态多表放入全局表格map中
        paramDynamicTableMap.put("areatable", cycleTable);

        /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
        /* 开始封装区县重要提示表单数据 */
        /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

        // 获取当前报告的区县重要提示查询结果
        List<Map<String, Object>> tableTipsList = this.getAreaTipsData(flowInfo);
        // 创建动态表对象
        DocDynamicTable cycleTable2 = new DocDynamicTable();
        InnerDocTable innerTable2 = cycleTable2.getMultiTable().newDocTable();
        // 设置数据开始开始行
        innerTable2.setDataRowStarts(new int[]{2});
        // 遍历区县重要提示查询结果
        for (int i = 0; i < tableTipsList.size(); i++) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("REGION_CODE", ParamUtils.getString(tableTipsList.get(i), "REGION_NAME"));
            map.put("IMPORTANT_TIPS", ParamUtils.getString(tableTipsList.get(i), "IMPORTANT_HINTS"));
            innerTable2.addRow(map);
        }
        // 设置子模板全路径
        // cycleTable2.getMultiTable().setModelPath(childPath_tips);
        // 将动态多表放入全局表格map中
        // paramDynamicTableMap.put("areatable2", cycleTable2);

        /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
        /* 封装区县重要提示表单数据结束 */
        /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

        // 父模板中循环表格所在位置的书签名称
        List<String> bookmarks = new ArrayList<String>();
        bookmarks.add("areatable");
        bookmarks.add("areatable2");
        List<CommFile> imgResultList = commFileService.queryFileList((String) paramMap.get("PKID"), AnalysisStateEnum.UPLOAD.getValue());
        setImage(imgResultList, page, "OLE_LINK100");
        this.setPrimPolluteSub(page);
        // RepDocTemplate docTemplate = new RepDocTemplate();
        if (StringUtils.isNotBlank(destPath)) {

        } else {
            CommFile commFile = commFileService.saveGenerateWordFile(page, paramDynamicTableMap, bookmarks, templatePath, fileName, AscriptionTypeEnum.PARTITION_FORECAST.getValue());
            String ascriptionId = paramMap.get("PKID").toString();
            String ascriptionType = AscriptionTypeEnum.PARTITION_FORECAST.getValue();
            commFile.setFileSource("GENERATE");
            commFileService.deleteFileByAscription(ascriptionId, ascriptionType);
            commFileService.saveFileInfo(commFile, ascriptionId, ascriptionType, paramMap.get("CREATE_USER").toString());
        }
        return destPath + fileName;
    }

    /**
     * 主要污染物格式化
     *
     * @param page
     */
    public void setPrimPolluteSub(DocumentPage page) {
        DocSuperAndSub docSub = new DocSuperAndSub();
        docSub.setAllWord("PM2.5");
        docSub.setBaseWord("PM");
        docSub.setSubscript("2.5");
        page.getSuperAndSubs().add(docSub);
        docSub = new DocSuperAndSub();
        docSub.setAllWord("SO2");
        docSub.setBaseWord("SO");
        docSub.setSubscript("2");
        page.getSuperAndSubs().add(docSub);
        docSub = new DocSuperAndSub();
        docSub.setAllWord("NO2");
        docSub.setBaseWord("NO");
        docSub.setSubscript("2");
        page.getSuperAndSubs().add(docSub);
        docSub = new DocSuperAndSub();
        docSub.setAllWord("PM10");
        docSub.setBaseWord("PM");
        docSub.setSubscript("10");
        page.getSuperAndSubs().add(docSub);
        docSub = new DocSuperAndSub();
        docSub.setAllWord("O3");
        docSub.setBaseWord("O");
        docSub.setSubscript("3");
        page.getSuperAndSubs().add(docSub);
    }

    /**
     * 设置图片
     *
     * @param imgResultList
     * @param page
     * @param label
     */
    @Transactional(rollbackFor = Exception.class)
    public void setImage(List<CommFile> imgResultList, DocumentPage page, String label) {
        List<DocImage> imageList = new ArrayList<DocImage>();
        for (int i = 0; i < imgResultList.size(); i++) {
            String imgPath = commFileService.getFileFullPath(imgResultList.get(i), false);
            // String imgPath = ParamUtils.getString(imgResultList.get(i), "FILE_SAVE_PATH");
            String imgName = imgResultList.get(i).getFileName().replace(".jpg", "").replace(".gif", "").replace(".png", "");
            File file = new File(imgPath);
            if (file.exists()) {
                // 图片对象构造方法有多个重载，本例中使用的构造方法有3个参数，分别为图片路径，长，宽
                DocImage img = new DocImage(imgPath, null, null);
                img.setLegendContent("图" + (i + 1) + " " + imgName);
                // img.setLengendFont(font);
                imageList.add(img);
            }
        }
        page.getImages().put(label, imageList);
    }

    /**
     * 查询文件信息
     *
     * @param form
     * @return
     */
    public List<Map<String, Object>> queryDayGeneralReportByIdAndFileSource(Map<String, Object> form) {
        List<Map<String, Object>> fileList = commFileService.queryFileListByAscription((String) form.get("PKID"), AnalysisStateEnum.UPLOAD.getValue());
        return fileList;
    }

    /**
     * 查询分区预报信息
     *
     * @param paramMap
     * @return
     */
    public Map<String, Object> queryPartitionForecastByReportId(Map<String, Object> paramMap) {
        paramMap.put("fileSources", "GENERATE");
        paramMap.put("PKID", paramMap.get("reportId").toString());
        Map<String, Object> partitionForecastMap = generalReportService.queryDayGeneralReportByIdAndFileSource(paramMap);
        // 查询预报AQI信息
        List<Map<String, Object>> form3d = getArea3DData(paramMap);
        partitionForecastMap.put("form3d", form3d);
        // 获取zip的fileI
        partitionForecastMap.put("zipFileInfo", commFileService.queryFileListByFileSources(paramMap.get("reportId").toString(), AnalysisStateEnum.COMPRESSION.getValue()));
        return partitionForecastMap;
    }

    /**
     * 修改报告状态
     *
     * @param paramMap
     * @return
     */
    @Transactional(rollbackFor = Exception.class)
    public int updateForecastState(Map<String, Object> paramMap) {
        paramMap.put("IS_MAIN", 1);
        generalReportService.updateReportState(paramMap);
        FlowAreaInfo flowAreaInfo = new FlowAreaInfo();
        flowAreaInfo.setPkid(paramMap.get("reportId").toString());
        flowAreaInfo.setFlowState(Integer.parseInt(paramMap.get("FLOW_STATE").toString()));
        int resultforecast = flowAreaInfoMapper.updateById(flowAreaInfo);
        //如果提交预报，则修改当天其他人的所有预报数据状态为提交
        paramMap.put("STATE", paramMap.get("state"));
        updateAllState(paramMap);
        return resultforecast;
    }

    /**
     * 根据报告ID删除报告
     *
     * @param paramMap 参数
     * @return 删除的条数
     */
    @Transactional(rollbackFor = Exception.class)
    public Integer deleteForecastById(Map<String, Object> paramMap) {
        generalReportService.deleteReportById(paramMap);
        paramMap.put("PKID", paramMap.get("reportId").toString());
        flowArea24hMapper.delete(Wrappers.lambdaQuery(FlowArea24H.class).eq(FlowArea24H::getAreaPkid, paramMap.get("reportId").toString()));
        flowArea3DMapper.delete(Wrappers.lambdaQuery(FlowArea3D.class).eq(FlowArea3D::getAreaPkid, paramMap.get("reportId").toString()));
        int resultforecast = flowAreaInfoMapper.deleteById(paramMap.get("reportId").toString());
        return resultforecast;
    }

    /**
     * 查询excel模板导入的数据
     *
     * @param paramMap
     * @return
     */
    public List<Map<String, Object>> queryExcel(Map<String, Object> paramMap) {
        List<Map<String, Object>> relist = new ArrayList<Map<String, Object>>();
        paramMap.put("LOGINNAME", LoginCache.getLoginUser().getLoginName());
        List<Map<String, Object>> list = flowArea3DMapper.list(paramMap);

        //List<Map<String, Object>> list = dao.list(paramMap, sqlPackage + ".list");
        Map<String, Object> map = new HashMap<>();
        for (int i = 0; i < list.size(); i++) {
            map = new HashMap<>();
            map.put("REGIONNAME", list.get(i).get("REGIONNAME").toString());
            String strAqi = list.get(i).get("AQI1") == null || list.get(i).get("AQI1") == "" ? "" : list.get(i).get("AQI1").toString().replaceAll(" ", "");
            int location = strAqi.indexOf("-");
            if (location < 0) {
                map.put("AQI_START1", "");
                map.put("AQI_END1", "");
            } else if (location == 0) {
                map.put("AQI_START1", "");
                map.put("AQI_END1", strAqi.substring(location + 1));
            } else if (location == strAqi.length() - 1) {
                map.put("AQI_START1", strAqi.substring(0, location));
                map.put("AQI_END1", "");
            } else {
                map.put("AQI_START1", strAqi.substring(0, location));
                map.put("AQI_END1", strAqi.substring(location + 1));
            }
            map.put("PULLNAME1", list.get(i).get("PULLNAME1") == null || list.get(i).get("PULLNAME1") == "" ? "" : setFormat(list.get(i).get("PULLNAME1").toString().replaceAll(" ", "").replace("，", ",")));

            strAqi = list.get(i).get("AQI2") == null || list.get(i).get("AQI2") == "" ? "" : list.get(i).get("AQI2").toString();
            location = strAqi.indexOf("-");
            if (location < 0) {
                map.put("AQI_START2", "");
                map.put("AQI_END2", "");
            } else if (location == 0) {
                map.put("AQI_START2", "");
                map.put("AQI_END2", strAqi.substring(location + 1));
            } else if (location == strAqi.length() - 1) {
                map.put("AQI_START2", strAqi.substring(0, location));
                map.put("AQI_END2", "");
            } else {
                map.put("AQI_START2", strAqi.substring(0, location));
                map.put("AQI_END2", strAqi.substring(location + 1));
            }
            map.put("PULLNAME2", list.get(i).get("PULLNAME2") == null || list.get(i).get("PULLNAME2") == "" ? "" : setFormat(list.get(i).get("PULLNAME2").toString().replaceAll(" ", "").replace("，", ",")));

            strAqi = list.get(i).get("AQI3") == null || list.get(i).get("AQI3") == "" ? "" : list.get(i).get("AQI3").toString();
            location = strAqi.indexOf("-");
            if (location < 0) {
                map.put("AQI_START3", "");
                map.put("AQI_END3", "");
            } else if (location == 0) {
                map.put("AQI_START3", "");
                map.put("AQI_END3", strAqi.substring(location + 1));
            } else if (location == strAqi.length() - 1) {
                map.put("AQI_START3", strAqi.substring(0, location));
                map.put("AQI_END3", "");
            } else {
                map.put("AQI_START3", strAqi.substring(0, location));
                map.put("AQI_END3", strAqi.substring(location + 1));
            }
            map.put("PULLNAME3", list.get(i).get("PULLNAME3") == null || list.get(i).get("PULLNAME3") == "" ? "" : setFormat(list.get(i).get("PULLNAME3").toString().replaceAll(" ", "").replace("，", ",")));
            relist.add(map);
        }
        return relist;
    }

    /**
     * 设置污染物格式
     *
     * @param poll
     * @return
     */
    private String setFormat(String poll) {
        poll = poll.toUpperCase().replace("PM25", "PM2.5");
        return poll;
    }
}

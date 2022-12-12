package ths.project.api.env_emergency.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.google.common.collect.Lists;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ths.jdp.core.dao.base.Paging;
import ths.jdp.core.service.base.BaseService;
import ths.project.analysis.forecast.numericalmodel.entity.WrfDataHour;
import ths.project.analysis.forecast.trendforecast.entity.TBasModelwqHourRow;
import ths.project.api.env_emergency.mapper.EnvEmergencyMapper;
import ths.project.api.env_emergency.vo.*;
import ths.project.service.common.CommonUtils;
import ths.project.service.common.vo.SimpleEchartsVo;
import ths.project.service.common.vo.drowDown.DropDownVo;
import ths.project.system.base.util.PageSelectUtil;

import java.util.*;

@Service
public class EnvEmergencyService extends BaseService {

    public static List<EmergencyListVo> emergencyListVos = new ArrayList<>();

    static {
        emergencyListVos.add(new EmergencyListVo("深圳华安液化石油气有限公司", "2", "914403006188880720", "1"));
        emergencyListVos.add(new EmergencyListVo("比亚迪股份有限公司", "2", "91440300192317458F", "1"));
        emergencyListVos.add(new EmergencyListVo("斯比泰科技（深圳）有限公司葵涌分公司", "2", "91440300MA5EL2N990", "1"));

        emergencyListVos.add(new EmergencyListVo("深圳市生态环境局大鹏管理局", "1", "49", "4"));
        emergencyListVos.add(new EmergencyListVo("深圳市大鹏新区综合办公室", "1", "44", "1"));
        emergencyListVos.add(new EmergencyListVo("深圳市规划和自然资源局大鹏管理局", "1", "2", "1"));
    }


    private final EnvEmergencyMapper envEmergencyMapper;

    @Autowired
    public EnvEmergencyService(EnvEmergencyMapper envEmergencyMapper) {
        this.envEmergencyMapper = envEmergencyMapper;
    }

    /**
     * 风险与敏感点统计
     */
    public EnvRiseVo riskSensitive() {
        return envEmergencyMapper.riskSensitive();
    }


    public List<EnvReceptorsVo> environmentalReceptors(String monType) {
        Map<String, Object> queryMap = new HashMap<>();
        queryMap.put("monType", monType);
        return envEmergencyMapper.environmentalReceptors(queryMap);
    }

    /**
     * 应急保障统计
     *
     * @return
     */
    public ContactNumsVo getContactNums() {
        ContactNumsVo vo = envEmergencyMapper.getContactNums();
        return vo;
    }

    /**
     * 应急保障列表
     *
     * @param type
     * @return
     */
    public List<Map<String, Object>> getContact(String securityType, String securityKeyWord) {
        Map<String, Object> map = new HashMap<>();
        map.put("securityType", securityType);
        map.put("securityKeyWord", securityKeyWord);
        List<Map<String, Object>> list = envEmergencyMapper.getContact(map);
        return list;
    }

    /**
     * 获取物资同比占比
     *
     * @param type
     * @return
     */
    public List<EnvSuppliesVo> getSupplies(String type) {
        Map map = new HashMap();
        map.put("type", type);
        return envEmergencyMapper.getSupplies(map);
    }

    /**
     * @param queryParam
     * @return
     * @Author: ZT
     * @Description: 查询应急预案
     * @Date: 2021年3月16日
     **/
    public List<Map<String, Object>> getContingencyPlan(Map<String, Object> queryParam) {
        return envEmergencyMapper.getContingencyPlan(queryParam);
    }

    /**
     * 首页环境应急
     *
     * @return
     */
    public EvnStatisticalVo evnStatistical() {
        return new EvnStatisticalVo(495, 256, 183, 496, 22, 11, 23);
    }

    /**
     * 应急预案统计
     *
     * @param type 类型
     * @return
     */
    public EnvEmergencyPlanVo emergencyPlan(String type) {
        EnvEmergencyPlanVo vo = new EnvEmergencyPlanVo();
        if ("1".equals(type)) {
            vo.setEnterprise(6);
            vo.setComprehensive(33.32);
            vo.setSoilPollution(16.67);
            vo.setFireExplosion(16.67);
            vo.setTrafficAccident(16.67);
            vo.setDrinkingWater(16.67);
        } else {
            vo.setEnterprise(3);
            vo.setNaturalDisasters(33.33);
            vo.setAccidentDisasters(33.33);
            vo.setPublicDisasters(33.34);
            vo.setSoilPollution(0);
        }
        return vo;
    }

    /**
     * 近污染应急事件统计
     *
     * @param startTime 开始时间
     * @param endTime   结束时间
     * @return
     */
    public EnvBeforEmergencyVo beforEmergency(String startTime, String endTime) {
        return new EnvBeforEmergencyVo(102, 12, 20d, 30d, 40d, 10d);
    }

    /**
     * 风险企业详情
     *
     * @param code 公司编码
     * @return
     */
    public EnvRiskDetailsVo riskDetails(String code) {
        Map<String, Object> queryParam = new HashMap<>();
        queryParam.put("code", code);
        return envEmergencyMapper.getRiskEnt(queryParam).get(0);
    }

    /**
     * 环境风险物质存放情况
     *
     * @param code 公司编码
     * @return
     */
    public List<EnvRiskMaterialVo> riskMaterial(String code, String name) {
        List<EnvRiskMaterialVo> vo = Lists.newArrayList();
        Map<String, Object> map = envEmergencyMapper.riskMaterial(CommonUtils.getParamByContent());
        if (MapUtils.isNotEmpty(map)) {
            String risk_substance_type = MapUtils.getString(map, "RISK_SUBSTANCE_TYPE", "");
            //次氯酸钠；酒精；医疗废物  PAM：0.18吨
            List<String> lists = Arrays.asList(risk_substance_type.split("；"));
            for (String str :
                    lists) {
                //name参数存在时,字符串匹配不了,跳过
                if (StringUtils.isNotBlank(str) && !str.contains(name)) {
                    continue;
                }
                String[] split = str.split("：");
                EnvRiskMaterialVo envRiskMaterialVo = EnvRiskMaterialVo.getInstance().name(split[0]).num(split.length > 1 ? split[1] : "");
                vo.add(envRiskMaterialVo);

            }
        }
        return vo;
    }

    /**
     * 应急物资详情
     *
     * @param code 公司编码
     * @return
     */
    public EvnNsuppliesDetail suppliesDetail(Map<String, Object> param) {
        EvnNsuppliesDetail vo = envEmergencyMapper.suppliesDetail(param);
        return vo;
    }

    /**
     * 应急物资详情列表
     */
    public List<SuppliesDetailListVo> suppliesDetailList(Map<String, Object> param) {
        List<SuppliesDetailListVo> list = envEmergencyMapper.suppliesDetailList(param);
        return list;
    }

    /**
     * 应急物资列表
     *
     * @param code   公司编码
     * @param search 关键词
     * @return
     */
    public List<MaterialStatisticsVo> suppliesList(Map<String, Object> param) {
        List<MaterialStatisticsVo> detailsE = envEmergencyMapper.suppliesList(param);
        return detailsE;
    }

    /**
     * 环境受体详情
     *
     * @param code 公司编码
     * @return
     */
    public EnvSensitiveVo sensitive(String code, String type) {
        Map<String, Object> paramByContent = CommonUtils.getParamByContent();
        EnvSensitiveVo vo = envEmergencyMapper.sensitive(paramByContent);
        return vo;
    }

    /**
     * 应急事件分析列表
     *
     * @param name      公司名称
     * @param longitude 经度
     * @param latitude  纬度
     * @param source    涉及风险源
     * @param evenType  事件类型
     * @param material  涉及风险物质
     * @return
     */
    public List<EnvEventsListVo> eventsList(String name, String longitude, String latitude, String source, String evenType, String material) {
        Map<String, Object> paramByContent = CommonUtils.getParamByContent();
        List<EnvEventsListVo> list = envEmergencyMapper.eventsList(paramByContent);
        return list;
    }


    /**
     * 应急事件分析详情
     *
     * @param code     公司code
     * @param distance 距离范围
     * @return
     */
    public EnvEventsDtailsVo eventsDtails(String code, String distance) {

        List<EnvEventsDtailsVo.Compare> list = Lists.newArrayList();
        list.add(new EnvEventsDtailsVo.Compare("104.2555", "30.2545", "001", "食品加工厂", null));
        list.add(new EnvEventsDtailsVo.Compare("104.2555", "30.2545", "002", "一凡食品", null));
        list.add(new EnvEventsDtailsVo.Compare("104.2555", "30.2545", "003", "水务管理局", null));


        List<DropDownVo> listd = Lists.newArrayList();
        listd.add(DropDownVo.build().code("001").name("土壤环境应急"));
        listd.add(DropDownVo.build().code("002").name("水环境应急"));
        listd.add(DropDownVo.build().code("003").name("南土地环境应急"));
        //应急物资
        List<EnvEventsDtailsVo.Compare> list1 = Lists.newArrayList();
        list1.add(new EnvEventsDtailsVo.Compare("104.2555", "30.2545", "1", "大鹏消防急救", "1"));
        list1.add(new EnvEventsDtailsVo.Compare("104.2555", "30.2545", "2", "大鹏环境检测站", "2"));
        //应急保障 应急救援队伍、环境监测站
        List<EnvEventsDtailsVo.Compare> list12 = Lists.newArrayList();
        list12.add(new EnvEventsDtailsVo.Compare("104.2555", "30.2545", "001", "大鹏环境检测站", null));
        list12.add(new EnvEventsDtailsVo.Compare("104.2555", "30.2545", "001", "大鹏消防急救", null));
        //应急避难场所
        List<EnvEventsDtailsVo.Compare> list13 = Lists.newArrayList();
        list13.add(new EnvEventsDtailsVo.Compare("104.2555", "30.2545", "001", "大鹏街道室内避难所", null));
        return new EnvEventsDtailsVo("应急事件", "104.35655", "30.5456556", "土壤污染", "火药", list, listd, list, list, list1, list12, list13);
    }


    /**
     * @return java.util.List<ths.project.service.vo.envEmergency.EmergencyMaterialVo>
     * @Author ZT
     * @Description 应急物质列表
     * @Date 15:27 2021/4/20
     * @Param [paramMap]
     **/
    public List<EmergencyMaterialVo> getEmergencySupportMaterial(Map<String, Object> paramMap) {
        return envEmergencyMapper.getEmergencySupportMaterial(paramMap);
    }

    public Paging<EmergencyMaterialVo> getEmergencySupportMaterial(Map<String, Object> paramMap, Paging<EmergencyMaterialVo> pageInfo) {
        return PageSelectUtil.selectListPage(pageInfo, () -> envEmergencyMapper.getEmergencySupportMaterial(paramMap));
    }

    /**
     * @return java.util.List<ths.project.service.common.vo.drowDown.DropDownVo>
     * @Author ZT
     * @Description 应急物质类型下拉
     * @Date 15:36 2021/4/20
     * @Param [paramMap]
     **/
    public List<DropDownVo> getMaterialType(Map<String, Object> paramMap) {
        return envEmergencyMapper.getMaterialType(paramMap);
    }

    /**
     * 应急预案列表
     *
     * @param
     * @param type
     * @param env
     * @return
     */
    public List<EmergencyListVo> emergencyList(String type, String env, String name) {
        List<EmergencyListVo> vo = new ArrayList<>();
        vo.addAll(emergencyListVos);
        for (int x = 0; x < vo.size(); x++) {
            EmergencyListVo listVo = vo.get(x);
            if (StringUtils.isNotBlank(name) && !listVo.getName().contains(name)) {
                vo.remove(x);
                x = x >= 0 ? --x : x;
                continue;
            }
            if (StringUtils.isNotBlank(type) && type.equals("1") && listVo.getType().equals("2")) {// 镇府
                vo.remove(x);
                x = x >= 0 ? --x : x;
            } else if (StringUtils.isNotBlank(type) && type.equals("2") && listVo.getType().equals("1")) {//企业
                vo.remove(x);
                x = x >= 0 ? --x : x;
            }
        }
        return vo;
    }

    /**
     * 应急预案详情
     *
     * @param code
     * @return
     */
    public List<EmergencyDetailVo> emergencyDetail(String code) {
        if (StringUtils.isBlank(code)) {
            return null;
        }
        Map<String, Object> paramByContent = CommonUtils.getParamByContent();
        List<EmergencyDetailVo> list = envEmergencyMapper.emergencyDetail(paramByContent);
        return list;
    }

    /**
     * 环境受体列表
     *
     * @param type
     * @return
     */
    public List<SensitiveListVo> sensitiveList(Map<String, Object> param) {
        List<SensitiveListVo> vo = envEmergencyMapper.sensitiveList(param);
        return vo;
    }

    /**
     * @return java.util.List<ths.project.service.vo.envEmergency.EnvRiskDetailsVo>
     * @Author ZT
     * @Description 风险企业列表
     * @Date 18:21 2021/4/23
     * @Param [paramMap]
     **/
    public List<EnvRiskDetailsVo> getRiskEntList(Map<String, Object> paramMap) {
        List<EnvRiskDetailsVo> list = envEmergencyMapper.getRiskEnt(paramMap);
        for (EnvRiskDetailsVo vo : list) {
            vo.setEnvironmentalEnterprise(vo.getRiskLevel());
            vo.setRiskType(vo.getType());
        }
        return list;
    }


    /**
     * 应急避难场所统计
     *
     * @return
     */
    public List<SimpleEchartsVo> shelterStatistics() {
        return envEmergencyMapper.shelterStatistics();
    }

    /**
     * 应急避难场所列表
     *
     * @param name
     * @return
     */
    public List<ShelterListVo> shelterList(Map<String, Object> param) {
        //Map<String, Object> paramByContent = CommonUtils.getParamByContent();
        return envEmergencyMapper.shelterList(param);
    }

    /**
     * 应急避难场所详情
     *
     * @param code
     * @return
     */
    public ShelterDetailVo shelterDetail(String code) {
        Map<String, Object> paramByContent = CommonUtils.getParamByContent();
        return envEmergencyMapper.shelterDetail(paramByContent);
    }

    /**
     * 典型突发事件情景分析列表
     *
     * @param name
     * @return
     */
    public List<EmergencyScenarioVo> emergencyScenario(String name) {
        Map<String, Object> paramByContent = CommonUtils.getParamByContent();
        return envEmergencyMapper.emergencyScenario(paramByContent);
    }

    /**
     * 典型突发事件情景分析详情
     *
     * @param id
     * @return
     */
    public List<EmergencyScenarioVo> emergencyScenarioDetail(String id) {
        Map<String, Object> paramByContent = CommonUtils.getParamByContent();
        return envEmergencyMapper.emergencyScenario(paramByContent);
    }

    /**
     * 应急事件列表
     *
     * @param name
     * @return
     */
    public List<EmergencyEventsListVo> emergencyEventsList(String name) {
        Map<String, Object> paramByContent = CommonUtils.getParamByContent();
        return envEmergencyMapper.emergencyEventsList(paramByContent);
    }

    /**
     * 化学产品列表
     *
     * @param name
     * @param casNum
     * @return
     */
    public Paging<ChemicalsVo> chemicals(String name, String casNum, Integer pageNum, Integer pageSize) {
        Paging<ChemicalsVo> paging = new Paging<>();
        pageNum = (pageNum == null || pageNum == 0) ? 1 : pageNum;
        pageSize = (pageSize == null || pageSize == 0) ? 10 : pageSize;
        paging.setPageNum(pageNum);
        paging.setPageSize(pageSize);
        Map<String, Object> paramByContent = CommonUtils.getParamByContent();
        Paging<ChemicalsVo> chemicalsVoPaging = PageSelectUtil.selectListPage1(envEmergencyMapper, paging, EnvEmergencyMapper::chemicals, paramByContent);
        return chemicalsVoPaging;
    }

    /**
     * 化学产品详情
     *
     * @param code
     * @return
     */
    public ChemicalsDetailsVo chemicalsDetails(String code) {
        ChemicalsDetailsVo vo = new ChemicalsDetailsVo();

        return vo;
    }


    /**
     * 应急预案删除(或新增暂定)
     *
     * @param code
     * @param type
     */
    public void emergencyEdit(String id, String code, String type) {
        Map<String, Object> paramByContent = CommonUtils.getParamByContent();
        envEmergencyMapper.emergencyEdit(paramByContent);
        envEmergencyMapper.emergencyEdit1(paramByContent);
    }

    /**
     * 应急事件分类列表
     *
     * @param name
     * @return
     */
    public List<Map<String, Object>> emergencyEvents(String name) {
        return envEmergencyMapper.emergencyEvents(name);
    }

}
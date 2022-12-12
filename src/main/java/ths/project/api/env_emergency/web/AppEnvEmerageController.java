package ths.project.api.env_emergency.web;import org.apache.commons.collections.MapUtils;import org.springframework.web.bind.annotation.RequestMapping;import org.springframework.web.bind.annotation.RequestParam;import org.springframework.web.bind.annotation.ResponseBody;import org.springframework.web.bind.annotation.RestController;import ths.jdp.core.dao.base.Paging;import ths.project.api.env_emergency.service.AppEnvEmerageService;import ths.project.api.env_emergency.vo.EmergencyShelterVo;import ths.project.api.env_emergency.vo.EmergencySupplieVo;import ths.project.api.env_emergency.vo.EmergencySupportTeamVo;import ths.project.api.env_emergency.vo.RiskSourceStatisticalVo;import ths.project.service.common.vo.DataResult;import java.util.ArrayList;import java.util.HashMap;import java.util.List;import java.util.Map;/** * @author:Toledo * @date:2021/11/16 14:20 * @descripthion: **/@RestController@RequestMapping("/app/dyh/env_emergency/EnvEmergency")public class AppEnvEmerageController {    private final AppEnvEmerageService service;    public AppEnvEmerageController(AppEnvEmerageService service) {        this.service = service;    }    /**     * 风险源统计     *     * @return     */    @ResponseBody    @RequestMapping("/riskSourceStatistical")    public DataResult<RiskSourceStatisticalVo> riskSourceStatistical() {        /**-------风险源统计---------**/        RiskSourceStatisticalVo riskSourceStatisticalVo = service.riskSourceStatistical();        /**-------气敏感点统计--------------**/        Map<String, Object> airMap = service.airStatistical();        riskSourceStatisticalVo.setAir(MapUtils.getInteger(airMap, "NUM"));        /**-------水敏感点统计--------------**/        Map<String, Object> waterMap = service.waterStatistical();        riskSourceStatisticalVo.setWater(MapUtils.getInteger(waterMap, "NUM"));        return DataResult.ok(riskSourceStatisticalVo);    }    @ResponseBody    @RequestMapping("/emergencySupplie")    public DataResult<List<EmergencySupplieVo>> emergencySupplie(Paging<Map<String, Object>> pageInfo,                                                                 @RequestParam String lon,                                                                 @RequestParam String lat,                                                                 String materialName,                                                                 String materialType,                                                                 String governmentName) {        if (materialType == null || "".equals(materialType)) {            materialType = "0";        }        Map<String, Object> param = new HashMap<String, Object>();        param.put("lon", lon);        param.put("lat", lat);        param.put("materialName", materialName);        param.put("materialType", materialType);        param.put("governmentName", governmentName);        List<EmergencySupplieVo> list = service.emergencySupplie(param);        return DataResult.ok(list);    }    /**     * 物资存放情况     *     * @param pkid     * @return     */    @ResponseBody    @RequestMapping("/suppliesInfo")    public DataResult<List<Map<String, Object>>> suppliesInfo(@RequestParam String companyId) {        List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();        Map<String, Object> param = new HashMap<String, Object>();        param.put("PKID", companyId);        Map<String, Object> resultMap = service.suppliesInfo(param);        if (resultMap == null) {            return null;        }        String riskSubstanceType = MapUtils.getString(resultMap, "RISK_SUBSTANCE_TYPE");        if (!riskSubstanceType.isEmpty()) {            String[] wzInfo = riskSubstanceType.split("；");            for (int i = 0; i < wzInfo.length; i++) {                String[] split = wzInfo[i].split(":");                Map<String, Object> map = new HashMap<String, Object>();                if (split.length == 1) {                    map.put("materialName", split[0]);                    map.put("materialNum", 0);                } else {                    map.put("materialName", split[0]);                    map.put("materialNum", split[1]);                }                resultList.add(map);            }        }        return DataResult.ok(resultList);    }    /**     * 应急保障队伍信息     *     * @return     */    @ResponseBody    @RequestMapping("/emergencyInfo")    public DataResult<EmergencySupportTeamVo> emergencyInfo() {        EmergencySupportTeamVo emergencySupportTeamVo = new EmergencySupportTeamVo();        /**-----------管理人员数量----------**/        Map<String, Object> managementPersonMap = service.managementPersonInfo();        emergencySupportTeamVo.setManagementPerson(MapUtils.getInteger(managementPersonMap, "NUM"));        /**-----------专家组数量----------**/        Map<String, Object> panelMap = service.panelInfo();        emergencySupportTeamVo.setPanel(MapUtils.getInteger(panelMap, "NUM"));        /**-----------相关单位----------**/        Map<String, Object> relevantUnitsMap = service.relevantUnitsInfo();        emergencySupportTeamVo.setRelevantUnits(MapUtils.getInteger(relevantUnitsMap, "NUM"));        /**-----------救援队伍----------**/        Map<String, Object> rescueTeamsMap = service.rescueTeamsInfo();        emergencySupportTeamVo.setRescueTeams(MapUtils.getInteger(rescueTeamsMap, "NUM"));        /**-----------环境监测站----------**/        Map<String, Object> environmentalMonitorStationMap = service.environmentalMonitorStationInfo();        emergencySupportTeamVo.setenvironmentalMonitorStation(MapUtils.getInteger(environmentalMonitorStationMap, "NUM"));        /**-----------值班人员----------**/        Map<String, Object> dutypersonMap = service.dutypersonInfo();        emergencySupportTeamVo.setDutyperson(MapUtils.getInteger(dutypersonMap, "NUM"));        return DataResult.ok(emergencySupportTeamVo);    }    /**     * 应急避难场所数量     *     * @return     */    @ResponseBody    @RequestMapping("/emergencyShelterInfo")    public DataResult<EmergencyShelterVo> emergencyShelterInfo() {        EmergencyShelterVo emergencyShelterVo = service.emergencyShelterInfo();        return DataResult.ok(emergencyShelterVo);    }    /**     * 应急保障队伍详细信息     *     * @param type     * @param institutions     * @return     */    @ResponseBody    @RequestMapping("/emergencySafeguardInfo")    public DataResult<List<Map<String, Object>>> emergencySafeguardInfo(@RequestParam String armyType,                                                                        String unit) {        Map<String, Object> param = new HashMap<String, Object>();        param.put("NAME", unit);        List<Map<String, Object>> list = null;        if ("management".equals(armyType)) {            /**---------管理人员----------**/            list = service.managementpersonnelInfo(param);        } else if ("panel".equals(armyType)) {            /**---------专家组----------**/            list = service.panel(param);        } else if ("relativeUnit".equals(armyType)) {            /**---------相关单位----------**/            list = service.relevantUnits(param);        } else if ("rescueTeam".equals(armyType)) {            /**---------救援队伍----------**/            list = service.rescueTeams(param);        } else if ("environmentalStation".equals(armyType)) {            /**---------环境监测站----------**/            list = service.environmentalMonitoreStationInfo(param);        } else if ("personOnDuty".equals(armyType)) {            /**---------值班人员----------**/            list = service.personnelOnDutyInfo(param);        }        return DataResult.ok(list);    }    @ResponseBody    @RequestMapping("/getSuppliesApp")    public DataResult getSuppliesApp(String type, String name, String suppliesName) {        Map<String, Object> param = new HashMap<>();        param.put("type", type);        param.put("name", name);        param.put("suppliesName", suppliesName);        List<Map<String, Object>> suppliesApp = service.getSuppliesApp(param);        return DataResult.ok(suppliesApp);    }    /**     * 鉴权     *     * @return     * @throws InterruptedException     */    @ResponseBody    @RequestMapping("/authentication")    public DataResult authentication(String url, String nonceStr) {        Map<String, Object> map = service.authentication(url,nonceStr);        return DataResult.ok(map);    }}
package ths.project.api.env_emergency.web;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import lombok.AllArgsConstructor;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ths.jdp.core.dao.base.Paging;
import ths.jdp.core.web.base.BaseController;
import ths.project.api.env_emergency.service.EnvEmergencyService;
import ths.project.api.env_emergency.vo.*;
import ths.project.common.util.ExcelUtil;
import ths.project.service.common.vo.DataResult;
import ths.project.service.common.vo.SimpleEchartsVo;
import ths.project.service.common.vo.drowDown.DropDownVo;

import java.io.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Api(tags = "环境应急")
@RestController
@RequestMapping("/api/dyh/env_emergency/EnvEmergency")
@AllArgsConstructor
public class EnvEmergencyController extends BaseController {

    private final EnvEmergencyService service;

    @ApiOperation(value = "风险企业统计")
    @RequestMapping("riskSensitive")
    public DataResult<EnvRiseVo> riskSensitive() {
        EnvRiseVo vo = service.riskSensitive();
        return DataResult.ok(vo);
    }

    @ApiOperation(value = "风险企业列表")
    @RequestMapping("getRiskEntList")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "riskEenterpriseLevel", value = "风险级别1重大环境风险,2:较大环境风险3,一般环境风险,4:暂无环境风险"),
            @ApiImplicitParam(name = "riskEenterpriseName", value = "企业名称"),
            @ApiImplicitParam(name = "riskEenterpriseType", value = "风险源类型1 只涉气企业,2只涉水企业,3 同时涉水企业,涉气企业"),
    })
    public DataResult<List<EnvRiskDetailsVo>> getRiskEntList(String riskEenterpriseLevel, String riskEenterpriseName, String riskEenterpriseType) {
        DataResult<List<EnvRiskDetailsVo>> vo = new DataResult<>();
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("riskLevel", riskEenterpriseLevel);
        paramMap.put("name", riskEenterpriseName);
        paramMap.put("riskType", riskEenterpriseType);
        try {
            List<EnvRiskDetailsVo> list = service.getRiskEntList(paramMap);
            vo.success(list);
        } catch (Exception e) {
            log.error("查询出错", e);
            vo.failure("查询出错");
        }
        return vo;
    }

    @ApiOperation(value = "环境受体统计")
    @RequestMapping("environmentalReceptors")
    @ApiImplicitParams({
            @ApiImplicitParam(value = "gas:气，water:水", name = "monType")
    })
    public DataResult<List<EnvReceptorsVo>> environmentalReceptors(String monType) {
        List<EnvReceptorsVo> vo = service.environmentalReceptors(monType);
        return DataResult.ok(vo);
    }

    @ApiOperation(value = "环境受体列表")
    @RequestMapping("sensitiveList")
    @ApiImplicitParams({
            @ApiImplicitParam(value = "敏感点类型(小类)", name = "sensitiveLevel"),
            @ApiImplicitParam(value = "受体名称", name = "sensitiveKeyWord")
    })
    public DataResult<List<SensitiveListVo>> sensitiveList(String sensitiveLevel, String sensitiveKeyWord) {
        try {
            Map<String, Object> param = new HashMap<String, Object>();
            param.put("sensitiveLevel", sensitiveLevel);
            param.put("sensitiveKeyWord", sensitiveKeyWord);
            List<SensitiveListVo> list = service.sensitiveList(param);
            return DataResult.ok(list);
        } catch (Exception e) {
            log.error("查询出错", e);
            return DataResult.fail("查询出错");
        }
    }

    @ApiOperation(value = "环境受体详情")
    @RequestMapping("sensitive")
    @ApiImplicitParams({
            @ApiImplicitParam(value = "类型 gas 大气,water水", name = "type"),
            @ApiImplicitParam(value = "公司编码", name = "code", required = true)
    })
    public DataResult<EnvSensitiveVo> sensitive(String code, String type) {
        try {
            EnvSensitiveVo vo = service.sensitive(code, type);
            return DataResult.ok(vo);
        } catch (Exception e) {
            e.printStackTrace();
            return DataResult.fail("查询失败");
        }
    }

    @ApiOperation(value = "应急保障统计")
    @RequestMapping("getContactNums")
    public DataResult<ContactNumsVo> getContactNums() {
        ContactNumsVo map = service.getContactNums();
        return DataResult.ok(map);
    }

    @ApiOperation(value = "应急保障列表")
    @ApiImplicitParams({
            @ApiImplicitParam(value = "类型,1:管理组,2:专家组,3:公司组(默认全部),4:救援队伍,5:环境监测", name = "securityType"),
            @ApiImplicitParam(value = "组织机构名称", name = "securityKeyWord")
    })
    @RequestMapping("getContact")
    public DataResult<List<Map<String, Object>>> getContact(String securityType, String securityKeyWord) {
        List<Map<String, Object>> list = service.getContact(securityType, securityKeyWord);
        return DataResult.ok(list);
    }

    @ApiOperation(value = "应急避难场所统计")
    @RequestMapping("shelterStatistics")
    public DataResult<List<SimpleEchartsVo>> shelterStatistics() {
        DataResult<List<SimpleEchartsVo>> vo = new DataResult<>();
        try {
            List<SimpleEchartsVo> list = service.shelterStatistics();
            vo.success(list);
        } catch (Exception e) {
            e.printStackTrace();
            vo.failure("查询出错");
        }
        return vo;
    }

    @ApiOperation(value = "应急避难场所列表")
    @RequestMapping("shelterList")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "sheltKeyWrod", value = "避难场所名称"),
            @ApiImplicitParam(name = "sheltStreetCode", value = "避难场所所属编码")
    })
    public DataResult<List<ShelterListVo>> shelterList(String sheltKeyWrod, String sheltStreetCode) {
        DataResult<List<ShelterListVo>> vo = new DataResult<>();
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("sheltKeyWrod", sheltKeyWrod);
        param.put("sheltStreetCode", sheltStreetCode);
        try {
            List<ShelterListVo> list = service.shelterList(param);
            vo.success(list);
        } catch (Exception e) {
            e.printStackTrace();
            vo.failure("查询出错");
        }
        return vo;
    }

    @ApiOperation(value = "应急避难场所详情")
    @RequestMapping("shelterDetail")
    @ApiImplicitParam(name = "code", value = "避难场所code")
    public DataResult<ShelterDetailVo> shelterDetail(String code) {
        DataResult<ShelterDetailVo> vo = new DataResult<>();
        try {
            ShelterDetailVo list = service.shelterDetail(code);
            vo.success(list);
        } catch (Exception e) {
            e.printStackTrace();
            vo.failure("查询出错");
        }
        return vo;
    }

    @ApiOperation(value = "应急物资列表")
    @RequestMapping("suppliesList")
    @ApiImplicitParams({
            @ApiImplicitParam(value = "企业名称", name = "materialUnitName"),
            @ApiImplicitParam(value = "物资类型", name = "emergencyType"),
            @ApiImplicitParam(value = "企业类型,政府:government,企业:social", name = "emergencyBelongType", required = true)
    })
    public DataResult<List<MaterialStatisticsVo>> suppliesList(String materialUnitName, String emergencyType, String emergencyBelongType) {
        try {
            Map<String, Object> param = new HashMap<String, Object>();
            param.put("materialUnitName", materialUnitName);
            param.put("emergencyType", emergencyType);
            param.put("emergencyBelongType", emergencyBelongType);
            List<MaterialStatisticsVo> vo = service.suppliesList(param);
            return DataResult.ok(vo);
        } catch (Exception e) {
            e.printStackTrace();
            return DataResult.fail("查询失败");
        }
    }

    @ApiOperation(value = "应急物资详情")
    @RequestMapping("suppliesDetail")
    @ApiImplicitParams({
            @ApiImplicitParam(value = "公司编码", name = "emergencyEnterprisePkid", required = true),
            @ApiImplicitParam(value = "企业类型", name = "emergencyEnterpriseType", required = true)
    })
    public DataResult<EvnNsuppliesDetail> suppliesDetail(String emergencyEnterprisePkid, String emergencyEnterpriseType) {
        try {
            Map<String, Object> param = new HashMap<String, Object>();
            param.put("emergencyEnterprisePkid", emergencyEnterprisePkid);
            param.put("emergencyEnterpriseType", emergencyEnterpriseType);
            EvnNsuppliesDetail vo = service.suppliesDetail(param);
            return DataResult.ok(vo);
        } catch (Exception e) {
            e.printStackTrace();
            return DataResult.fail("查询失败");
        }
    }

    @ApiOperation(value = "应急物资详情列表")
    @RequestMapping("suppliesDetailList")
    @ApiImplicitParams({
            @ApiImplicitParam(value = "公司编码", name = "emergencyEnterprisePkid", required = true),
            @ApiImplicitParam(value = "企业类型", name = "emergencyEnterpriseType", required = true),
            @ApiImplicitParam(value = "物资名称", name = "emergencySuppliesKeyWord")
    })
    public DataResult<List<SuppliesDetailListVo>> suppliesDetailList(String emergencyEnterprisePkid, String emergencySuppliesKeyWord, String emergencyEnterpriseType) {
        try {
            Map<String, Object> param = new HashMap<String, Object>();
            param.put("emergencyEnterprisePkid", emergencyEnterprisePkid);
            param.put("emergencySuppliesKeyWord", emergencySuppliesKeyWord);
            param.put("emergencyEnterpriseType", emergencyEnterpriseType);
            List<SuppliesDetailListVo> list = service.suppliesDetailList(param);
            return DataResult.ok(list);
        } catch (Exception e) {
            e.printStackTrace();
            return DataResult.fail("查询失败");
        }
    }


    @ApiOperation(value = "应急预案统计")
    @RequestMapping("emergencyPlan")
    @ApiImplicitParam(value = "类型(1政府.2企业)", name = "type", required = true)
    public DataResult<EnvEmergencyPlanVo> emergencyPlan(String type) {
        try {
            EnvEmergencyPlanVo vo = service.emergencyPlan(type);
            return DataResult.ok(vo);
        } catch (Exception e) {
            e.printStackTrace();
            return DataResult.fail("查询失败");
        }
    }

    @ApiOperation(value = "获取物资同比占比")
    @RequestMapping("getSupplies")
    @ApiImplicitParam(value = "物资类型,1:政府物资,2社会物资(默认政府)", name = "type")
    public DataResult<List<EnvSuppliesVo>> getSupplies(String type) {
        List<EnvSuppliesVo> vo = service.getSupplies(type);
        return DataResult.ok(vo);
    }


    @ApiOperation(value = "查询应急预案数据")
    @RequestMapping("getContingencyPlan")
    @ApiImplicitParams({
            @ApiImplicitParam(value = "应急预案编码", name = "planCode"),
            @ApiImplicitParam(value = "父节点ID", name = "parentId"),
            @ApiImplicitParam(value = "1事件类型；2工作组职责；3应急处置队；4应急物资；5应急响应流程；6应急响应措施,7 预防措施 ,8 监测措施,9 预警措施", name = "planType")
    })
    public DataResult<List<Map<String, Object>>> getContingencyPlan(String planCode, String parentId, String planType) {
        DataResult<List<Map<String, Object>>> responseVo = new DataResult<List<Map<String, Object>>>();
        Map<String, Object> queryMap = new HashMap<String, Object>();
        queryMap.put("planCode", planCode);
        queryMap.put("parentId", parentId);
        queryMap.put("planType", planType);
        List<Map<String, Object>> vo = service.getContingencyPlan(queryMap);
        return responseVo.success(vo);
    }

    @ApiOperation(value = "首页环境应急")
    @RequestMapping("evnStatistical")
    public DataResult<EvnStatisticalVo> evnStatistical() {
        EvnStatisticalVo vo = service.evnStatistical();
        return DataResult.ok(vo);
    }

    @ApiOperation(value = "近5年污染应急事件统计")
    @RequestMapping("beforEmergency")
    @ApiImplicitParams({
            @ApiImplicitParam(value = "开始时间", name = "startTime", required = true),
            @ApiImplicitParam(value = "结束时间", name = "endTime", required = true)
    })

    public DataResult<EnvBeforEmergencyVo> beforEmergency(String startTime, String endTime) {
        try {
            EnvBeforEmergencyVo vo = service.beforEmergency(startTime, endTime);
            return DataResult.ok(vo);
        } catch (Exception e) {
            log.error("查询失败");
            return DataResult.fail("查询失败");
        }
    }

    @ApiOperation(value = "风险企业详情")
    @RequestMapping("riskDetails")
    @ApiImplicitParam(value = "公司编码", name = "code", required = true)
    public DataResult<EnvRiskDetailsVo> riskDetails(String code) {
        try {
            EnvRiskDetailsVo vo = service.riskDetails(code);
            return DataResult.ok(vo);
        } catch (Exception e) {
            log.error("查询失败");
            return DataResult.fail("查询失败");
        }
    }

    @ApiOperation(value = "环境风险物质存放情况")
    @RequestMapping("riskMaterial")
    @ApiImplicitParams({
            @ApiImplicitParam(value = "公司编码", name = "code", required = true),
            @ApiImplicitParam(value = "物资名称", name = "name")
    })
    public DataResult<List<EnvRiskMaterialVo>> riskMaterial(String code, String name) {
        try {
            List<EnvRiskMaterialVo> vo = service.riskMaterial(code, name);
            return DataResult.ok(vo);
        } catch (Exception e) {
            e.printStackTrace();
            return DataResult.fail("查询失败");
        }
    }

    @ApiOperation(value = "应急事件分析列表")
    @RequestMapping("eventsList")
    @ApiImplicitParams({
            @ApiImplicitParam(value = "公司名称", name = "name"),
            @ApiImplicitParam(value = "经度", name = "longitude"),
            @ApiImplicitParam(value = "纬度", name = "latitude"),
            @ApiImplicitParam(value = "涉及风险源", name = "source"),
            @ApiImplicitParam(value = "事件类型", name = "evenType"),
            @ApiImplicitParam(value = "涉及风险物质", name = "material")
    })
    public DataResult<List<EnvEventsListVo>> eventsList(String name, String longitude, String latitude, String source,
                                                        String evenType, String material) {
        try {
            List<EnvEventsListVo> vo = service.eventsList(name, longitude, latitude, source, evenType, material);
            return DataResult.ok(vo);
        } catch (Exception e) {
            e.printStackTrace();
            return DataResult.fail("查询失败");
        }
    }

    @ApiOperation(value = "应急事件分析详情")
    @RequestMapping("eventsDtails")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "code", value = "公司code", required = true),
            @ApiImplicitParam(name = "distance", value = "距离范围"),
            @ApiImplicitParam(name = "index", value = "序号"),
    })
    public DataResult<EnvEventsDtailsVo> eventsDtails(String code, String distance, String index) {
        try {
            EnvEventsDtailsVo vo = service.eventsDtails(code, distance);
            return DataResult.ok(vo);
        } catch (Exception e) {
            e.printStackTrace();
            return DataResult.fail("查询失败");
        }
    }


    @ApiOperation(value = "应急物质列表")
    @RequestMapping("getEmergencySupportMaterial")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "entName", value = "企业名称"),
            @ApiImplicitParam(name = "materialType", value = "物质类型"),
            @ApiImplicitParam(name = "entType", value = "单位类型1政府2公司"),
    })
    public DataResult<List<EmergencyMaterialVo>> getEmergencySupportMaterial(String entName, String materialType, String entType) {
        DataResult<List<EmergencyMaterialVo>> vo = new DataResult<>();
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("entName", entName);
        paramMap.put("materialType", materialType);
        paramMap.put("entType", entType);
        try {
            List<EmergencyMaterialVo> list = service.getEmergencySupportMaterial(paramMap);
            vo.success(list);
        } catch (Exception e) {
            e.printStackTrace();
            vo.failure("查询出错");
        }
        return vo;
    }

    @ApiOperation(value = "应急物质列表分页")
    @RequestMapping("getEmergencySupportMaterialPage")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "entName", value = "企业名称"),
            @ApiImplicitParam(name = "materialType", value = "物质类型"),
            @ApiImplicitParam(name = "entType", value = "单位类型1政府2公司"),
            @ApiImplicitParam(name = "pageSize", value = "当前分页数量", dataType = "int"),
            @ApiImplicitParam(name = "pageNum", value = "第几页", dataType = "int"),
    })
    public DataResult<Paging<EmergencyMaterialVo>> getEmergencySupportMaterial(String entName, String materialType, String entType, int pageSize, int pageNum) {
        DataResult<Paging<EmergencyMaterialVo>> vo = new DataResult<>();
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("entName", entName);
        paramMap.put("materialType", materialType);
        paramMap.put("entType", entType);
        try {
            Paging<EmergencyMaterialVo> pageInfo = new Paging<>();
            pageInfo.setPageSize(pageSize);
            pageInfo.setPageNum(pageNum);
            Paging<EmergencyMaterialVo> emergencySupportMaterial = service.getEmergencySupportMaterial(paramMap, pageInfo);
            vo.success(emergencySupportMaterial);
        } catch (Exception e) {
            e.printStackTrace();
            vo.failure("查询出错");
        }
        return vo;
    }


    @ApiOperation(value = "应急物质类型下拉")
    @RequestMapping("getMaterialType")
    public DataResult<List<DropDownVo>> getMaterialType() {
        DataResult<List<DropDownVo>> vo = new DataResult<>();
        Map<String, Object> paramMap = new HashMap<>();
        try {
            List<DropDownVo> list = service.getMaterialType(paramMap);
            vo.success(list);
        } catch (Exception e) {
            e.printStackTrace();
            vo.failure("查询出错");
        }
        return vo;
    }

    @ApiOperation(value = "应急预案列表")
    @RequestMapping("emergencyList")
    @ApiImplicitParams({
            @ApiImplicitParam(value = "1政府 2企业 ", name = "type"),
            @ApiImplicitParam(value = "应急预案类型(应急预案类型下拉)", name = "env"),
            @ApiImplicitParam(value = "企业名称", name = "name")
    })
    public DataResult<List<EmergencyListVo>> emergencyList(String type, String env, String name) {
        try {
            List<EmergencyListVo> list = service.emergencyList(type, env, name);
            return DataResult.ok(list);
        } catch (Exception e) {
            log.error("查询出错", e);
            return DataResult.fail("查询出错");
        }
    }

    @ApiOperation(value = "应急预案详情")
    @RequestMapping("emergencyDetail")
    @ApiImplicitParams({
            @ApiImplicitParam(value = "企业code", name = "code")
    })
    public DataResult<List<EmergencyDetailVo>> emergencyDetail(String code) {
        try {
            List<EmergencyDetailVo> list = service.emergencyDetail(code);
            return DataResult.ok(list);
        } catch (Exception e) {
            log.error("查询出错", e);
            return DataResult.fail("查询出错");
        }
    }

    @ApiOperation(value = "应急预案删除(或新增暂定)")
    @RequestMapping("emergencyEdit")
    @ApiImplicitParams({
            @ApiImplicitParam(value = "事件id", name = "id"),
            @ApiImplicitParam(value = "企业code", name = "code"),
            @ApiImplicitParam(value = "1政府2企业", name = "type"),
    })
    public DataResult emergencyEdit(String id, String code, String type) {
        try {
            service.emergencyEdit(id, code, type);
            return DataResult.ok();
        } catch (Exception e) {
            log.error("查询出错", e);
            return DataResult.fail("出错");
        }
    }

    @ApiOperation(value = "典型突发事件情景分析列表")
    @RequestMapping("emergencyScenario")
    @ApiImplicitParam(name = "name", value = "典型突发事件名称")
    public DataResult<List<EmergencyScenarioVo>> emergencyScenario(String name) {
        DataResult<List<EmergencyScenarioVo>> vo = new DataResult<>();
        try {
            List<EmergencyScenarioVo> list = service.emergencyScenario(name);
            vo.success(list);
        } catch (Exception e) {
            log.error("查询出错", e);
            vo.failure("查询出错");
        }
        return vo;
    }

    @ApiOperation(value = "典型突发事件情景分析详情")
    @RequestMapping("emergencyScenarioDetail")
    @ApiImplicitParam(name = "id", value = "典型突发事id")
    public DataResult<List<EmergencyScenarioVo>> emergencyScenarioDetail(String id) {
        DataResult<List<EmergencyScenarioVo>> vo = new DataResult<>();
        try {
            List<EmergencyScenarioVo> list = service.emergencyScenarioDetail(id);
            vo.success(list);
        } catch (Exception e) {
            log.error("查询出错", e);
            vo.failure("查询出错");
        }
        return vo;
    }

    @ApiOperation(value = "应急事件列表")
    @RequestMapping("emergencyEventsList")
    @ApiImplicitParam(name = "name", value = "应急事件名称")
    public DataResult<List<EmergencyEventsListVo>> emergencyEventsList(String name) {
        DataResult<List<EmergencyEventsListVo>> vo = new DataResult<>();
        try {
            List<EmergencyEventsListVo> list = service.emergencyEventsList(name);
            vo.success(list);
        } catch (Exception e) {
            log.error("查询出错", e);
            vo.failure("查询出错");
        }
        return vo;
    }

    @ApiOperation(value = "化学产品列表")
    @RequestMapping("chemicals")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "name", value = "化学名称"),
            @ApiImplicitParam(name = "casNum", value = "cas号"),
            @ApiImplicitParam(name = "pageSize", value = "每页记录数", required = true),
            @ApiImplicitParam(name = "pageNum", value = "页码数", required = true)
    })
    public DataResult<Paging<ChemicalsVo>> chemicals(Integer pageNum, Integer pageSize, String name, String casNum) {
        DataResult<Paging<ChemicalsVo>> vo = new DataResult<>();
        try {
            Paging<ChemicalsVo> list = service.chemicals(name, casNum, pageNum, pageSize);
            vo.success(list);
        } catch (Exception e) {
            log.error("查询出错", e);
            vo.failure("查询出错");
        }
        return vo;
    }

    @ApiOperation(value = "化学产品详情")
    @RequestMapping("chemicalsDetails")
    @ApiImplicitParam(name = "code", value = "化学code")
    public DataResult<ChemicalsDetailsVo> chemicalsDetails(String code) {
        DataResult<ChemicalsDetailsVo> vo = new DataResult<>();
        try {
            ChemicalsDetailsVo list = service.chemicalsDetails(code);
            vo.success(list);
        } catch (Exception e) {
            log.error("查询出错", e);
            vo.failure("查询出错");
        }
        return vo;
    }

    @ApiOperation(value = "应急事件分类列表")
    @RequestMapping("EmergencyEvents")
    @ApiImplicitParam(name = "code", value = "化学code")
    public DataResult EmergencyEvents(String name) {
        List<Map<String, Object>> result = service.emergencyEvents(name);
        return DataResult.ok(result);
    }


    @RequestMapping("test")
    public DataResult test() throws IOException {
        String filePath = "D:\\文档\\思路创新\\项目\\成都大运会\\标准污染源信息来源关联.xlsx";

        File excelFile = new File(filePath);
        HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(excelFile));
        HSSFSheet sheet = wb.getSheetAt(0);

        return DataResult.ok();
    }
}

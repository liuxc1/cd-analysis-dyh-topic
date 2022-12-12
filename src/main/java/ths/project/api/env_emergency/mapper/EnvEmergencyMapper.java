package ths.project.api.env_emergency.mapper;

import ths.project.api.env_emergency.vo.*;
import ths.project.service.common.vo.SimpleEchartsVo;
import ths.project.service.common.vo.drowDown.DropDownVo;

import java.util.List;
import java.util.Map;

public interface EnvEmergencyMapper {

    public EnvRiseVo riskSensitive();

    public List<EnvReceptorsVo> environmentalReceptors(Map<String, Object> queryMap);

    public ContactNumsVo getContactNums();

    public List<Map<String, Object>> getContact(Map<String, Object> queryMap);

    public List<EnvSuppliesVo> getSupplies(Map<String, Object> queryMap);

    public List<Map<String, Object>> getContingencyPlan(Map<String, Object> queryMap);

    public EnvRiskDetailsVo getRiskEnt();

    public Map<String, Object> riskMaterial(Map<String, Object> queryMap);

    public EvnNsuppliesDetail suppliesDetail(Map<String, Object> queryMap);

    public List<SuppliesDetailListVo> suppliesDetailList(Map<String, Object> queryMap);

    public List<MaterialStatisticsVo> suppliesList(Map<String, Object> queryMap);

    public EnvSensitiveVo sensitive(Map<String, Object> queryMap);

    public List<EnvEventsListVo> eventsList(Map<String, Object> queryMap);

    public List<EmergencyMaterialVo> getEmergencySupportMaterial(Map<String, Object> queryMap);

    public List<DropDownVo> getMaterialType(Map<String, Object> queryMap);

    public List<EmergencyDetailVo> emergencyDetail(Map<String, Object> queryMap);

    public List<SensitiveListVo> sensitiveList(Map<String, Object> queryMap);

    public List<EnvRiskDetailsVo> getRiskEnt(Map<String, Object> queryMap);

    public List<SimpleEchartsVo> shelterStatistics();

    public List<ShelterListVo> shelterList(Map<String, Object> queryMap);

    public ShelterDetailVo shelterDetail(Map<String, Object> queryMap);

    public List<EmergencyScenarioVo> emergencyScenario(Map<String, Object> queryMap);

    public List<EmergencyEventsListVo> emergencyEventsList(Map<String, Object> queryMap);

    public List<ChemicalsVo> chemicals(Map<String, Object> queryMap);

    public int emergencyEdit(Map<String, Object> queryMap);

    public int emergencyEdit1(Map<String, Object> queryMap);

    List<Map<String, Object>> emergencyEvents(String name);

}

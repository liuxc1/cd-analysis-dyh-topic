package ths.project.api.env_emergency.mapper;

import ths.project.api.env_emergency.vo.EmergencyShelterVo;
import ths.project.api.env_emergency.vo.EmergencySupplieVo;
import ths.project.api.env_emergency.vo.RiskSourceStatisticalVo;

import java.util.List;
import java.util.Map;

public interface AppEnvEmergencyMapper {

    RiskSourceStatisticalVo riskSourceStatistical();

    Map<String, Object> airStatistical();

    Map<String, Object> waterStatistical();

    List<EmergencySupplieVo> emergencySupplie(Map<String, Object> param);

    Map<String, Object> suppliesInfo(Map<String, Object> param);

    Map<String, Object> managementPersonInfo();

    Map<String, Object> panelInfo();

    Map<String, Object> relevantUnitsInfo();

    Map<String, Object> rescueTeamsInfo();

    Map<String, Object> environmentalMonitorStationInfo();

    Map<String, Object> dutypersonInfo();

    EmergencyShelterVo emergencyShelterInfo();

    List<Map<String, Object>> managementpersonnelInfo(Map<String, Object> param);

    List<Map<String, Object>> panel(Map<String, Object> param);

    List<Map<String, Object>> relevantUnits(Map<String, Object> param);

    List<Map<String, Object>> rescueTeams(Map<String, Object> param);

    List<Map<String, Object>> environmentalMonitoreStationInfo(Map<String, Object> param);

    List<Map<String, Object>> personnelOnDutyInfo(Map<String, Object> param);

    List<Map<String, Object>> getSuppliesApp(Map<String, Object> param);

    List<Map<String, Object>> getList();

    void insert(Map<String, Object> param);
}

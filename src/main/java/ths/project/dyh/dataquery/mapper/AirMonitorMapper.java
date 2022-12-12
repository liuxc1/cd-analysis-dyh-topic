package ths.project.dyh.dataquery.mapper;

import ths.jdp.core.dao.base.Paging;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface AirMonitorMapper {

    List<Map<String, Object>> getAirMonitorDatas(Map<String, Object> queryParam);

    List<Map<String, Object>> getAirMonitorDatas1(Map<String, Object> queryMap);

    List<Map<String, Object>> getAirMonitorDatas2(Map<String, Object> map);

    List<Map<String, Object>> getStationName(Map<String, Object> querymap);

    List<Map<String, Object>> getRegionName(Map<String, Object> querymap);

    Map<String, Object> getMaxTime(Map<String, Object> querymap);

    List<Map<String, Object>> getNearStationList(HashMap<String, String> nameMap);
}

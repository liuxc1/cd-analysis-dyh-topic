package ths.project.analysis.forecast.sanddust.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface ISandDustMapper {

    Map<String, Object> getMaxDate(@Param("month") String month);

    List<Map<String, Object>> getForecastDateList(Map<String, Object> maxDate);

    List<Map<String, Object>> getDustForecastDataList(Map<String, Object> queryParam);

    List<Map<String, Object>> getRegionList();
}

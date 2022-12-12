package ths.project.analysis.forecast.airforecastmonth.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import ths.project.analysis.forecast.airforecastmonth.entity.TAnsMonthForecast;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public interface MonthTrendMapper extends BaseMapper<TAnsMonthForecast> {

    List<Map<String, Object>> getForecastValues(Map<String, Object> paramMap);

    List<LinkedHashMap<String,Object>> getForecastValuesExecl(Map<String, Object> paramMap);

    List<Map<String, Object>> queryMonthForecastByReportId(Map<String, Object> paramMap);

    int deleteForecastValues(Map<String, Object> paramMap);

    List<Map<String, Object>> queryExcel(Map<String, Object> paramMap);

    int deleteForecastTempById(Map<String, Object> paramMap);
}

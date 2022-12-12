package ths.project.analysis.forecast.numericalmodel.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;
import ths.project.analysis.forecast.numericalmodel.entity.ForecastLog;
import ths.project.analysis.forecast.numericalmodel.entity.Pm25Components;
import ths.project.analysis.forecast.numericalmodel.query.ForecastQuery;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 预报日志
 * @date 2021年06月22日 15:34
 */
public interface ForecastLogMapper extends BaseMapper<ForecastLog> {
    Map<String,Object> queryMaxLogTime();

    List<LinkedHashMap<String, Object>> getExportForecastLogFormLogTime(@Param("forecastTimeStart") String forecastTimeStart, @Param("forecastTimeEnd") String forecastTimeEnd);
}

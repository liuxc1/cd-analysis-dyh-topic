package ths.project.analysis.forecast.trendforecast.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;
import ths.project.analysis.forecast.numericalmodel.query.ForecastQuery;
import ths.project.analysis.forecast.trendforecast.entity.TBasModelwqHourRow;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public interface TrendForecastMapper extends BaseMapper<TBasModelwqHourRow> {

    List<TBasModelwqHourRow> getHourDate(@Param("modelTime") String modelTime, @Param("pointCode") String pointCode, @Param("type") String type);

    List<LinkedHashMap<String, Object>> getForecastExportData(ForecastQuery query);

    List<TBasModelwqHourRow> queryTBasModelwqHourRowZeroPageList(Map<String, Object> paramMap);

    List<TBasModelwqHourRow> queryTBasModelwqHourRowTwelvePageList(Map<String, Object> paramMap);
}

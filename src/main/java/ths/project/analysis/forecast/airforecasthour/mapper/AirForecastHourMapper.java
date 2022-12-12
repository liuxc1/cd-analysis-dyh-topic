package ths.project.analysis.forecast.airforecasthour.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;
import ths.project.analysis.forecast.airforecasthour.entity.ModelwqHourRow;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;


public interface AirForecastHourMapper extends BaseMapper<ModelwqHourRow>{


	List<ModelwqHourRow> getForecastTypeAndUser(@Param("modeltime") String modeltime);

	List<Map<String,Object>> getTableData(Map<String, Object> param);


    Map<String,Object> getMonth(Map<String, Object> param);

	List<Map<String, Object>> getDayList(Map<String, Object> param);

    void updateByUser(Map<String, Object> paramMap);
}

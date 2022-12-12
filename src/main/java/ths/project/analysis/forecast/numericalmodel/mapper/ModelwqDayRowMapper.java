package ths.project.analysis.forecast.numericalmodel.mapper;


import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;
import ths.project.analysis.forecast.numericalmodel.entity.ModelwqDayRow;
import ths.project.analysis.forecast.numericalmodel.query.ForecastQuery;


import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 *
 */
public interface ModelwqDayRowMapper extends BaseMapper<ModelwqDayRow> {


    /**
     * 查询未来14天预报最大时间
     * @param model 模型
     * @param pointCode 行政区编码
     * @return
     */
    Map<String,Object> maxDate(@Param("model") String model,@Param("pointCode")  String pointCode,@Param("month")  String month);

    /**
     * 查询未来14天预报查询日数据
     * @param param
     * @return
     */
    List<Map<String, Object>> getDayList(Map<String, Object> param);

    /**
     * 查询近期污染预报数据
     * @param query
     * @return
     */
    List<Map<String, Object>> getForecastData(ForecastQuery query);

    /**
     * 查询最新的预报日期
     * @param query
     * @return
     */
    Map<String, Object> queryMaxResultDate(ForecastQuery query);
    /**
     * 查询近期污染预报数据--导出
     * @param query
     * @return
     */
    List<LinkedHashMap<String, Object>> getForecastExportData(ForecastQuery query);
    /**
     * 查询行政区和点位数据
     * @return
     */
    List<Map<String, Object>> getRegionPointList(@Param("type") String type);
}

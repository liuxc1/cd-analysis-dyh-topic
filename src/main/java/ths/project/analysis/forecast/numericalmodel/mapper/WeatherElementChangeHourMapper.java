package ths.project.analysis.forecast.numericalmodel.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;
import ths.project.analysis.forecast.numericalmodel.entity.WrfDataHour;
import ths.project.analysis.forecast.numericalmodel.query.ForecastQuery;

import java.util.LinkedHashMap;
import java.util.List;


/**
 * 气象要素变化(小时数据)
 *
 * @date 2021年06月23日 14:16
 */
public interface WeatherElementChangeHourMapper extends BaseMapper<WrfDataHour> {
    /**
     * 气象小时数据导出
     *
     * @param query
     * @return
     */
    List<LinkedHashMap<String, Object>> getWrfDataHourExportData(ForecastQuery query);

    /**
     * 气象多要素导出
     *
     * @param query
     * @return
     */
    List<LinkedHashMap<String, Object>> getWrfDataHourYsExportData(ForecastQuery query);
}

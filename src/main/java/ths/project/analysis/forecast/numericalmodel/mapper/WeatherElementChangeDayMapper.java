package ths.project.analysis.forecast.numericalmodel.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;
import ths.project.analysis.forecast.numericalmodel.entity.WrfDataDay;
import ths.project.analysis.forecast.numericalmodel.query.ForecastQuery;

import java.util.LinkedHashMap;
import java.util.List;


/**
 * 气象要素变化--风速风向（日数据）
 * @date 2021年06月23日 14:16
 */
public interface WeatherElementChangeDayMapper extends BaseMapper<WrfDataDay> {
    /**
     * 风向风速日数据导出
     * @param query
     * @return
     */
    List<LinkedHashMap<String, Object>> getWrfDataWindExportData(ForecastQuery query);
}

package ths.project.analysis.forecast.numericalmodel.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import ths.project.analysis.forecast.numericalmodel.entity.WrfDataHourNw;
import ths.project.analysis.forecast.numericalmodel.query.ForecastQuery;

import java.util.LinkedHashMap;
import java.util.List;


/**
 * 气象变化（逆温）
 * @date 2021年06月23日 14:16
 */
public interface WeatherElementChangeNwMapper extends BaseMapper<WrfDataHourNw> {
    /**
     * 气象逆温数据导出
     * @param query 查询条件
     * @return 逆温数据
     */
     List<LinkedHashMap<String, Object>> getWrfDataHourNwList(ForecastQuery query);
}

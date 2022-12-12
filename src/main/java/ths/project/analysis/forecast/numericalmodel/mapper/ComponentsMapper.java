package ths.project.analysis.forecast.numericalmodel.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import ths.project.analysis.forecast.numericalmodel.entity.Pm25Components;
import ths.project.analysis.forecast.numericalmodel.query.ForecastQuery;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * PM25组分预报
 * @date 2021年06月22日 15:34
 */
public interface ComponentsMapper extends BaseMapper<Pm25Components> {
    List<Map<String, Object>> queryComponentsData(ForecastQuery query);

    List<LinkedHashMap<String, Object>> getComponentsExportData(ForecastQuery query);
}

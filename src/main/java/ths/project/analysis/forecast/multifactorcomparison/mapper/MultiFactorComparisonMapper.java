package ths.project.analysis.forecast.multifactorcomparison.mapper;

import ths.project.analysis.forecast.numericalmodel.query.ForecastQuery;

import java.util.List;
import java.util.Map;

public interface MultiFactorComparisonMapper {

    List<Map<String, Object>> getPollutes();

    List<Map<String, Object>> getModelForcatsDayData(ForecastQuery forecastQuery);

    List<Map<String, Object>> getModelForcatsHourData(ForecastQuery forecastQuery);
}

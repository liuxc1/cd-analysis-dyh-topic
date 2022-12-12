package ths.project.analysis.forecast.ensembleprediction.mapper;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface EnsemblePredictionMapper {

    List<Map<String, Object>> getForecastAirDataList(Map<String, Object> queryParam);
    List<Map<String, Object>> getForecastWaterDataList(Map<String, Object> queryParam);

    List<Map<String, Object>> getModelList(Map<String, Object> queryParam);

}

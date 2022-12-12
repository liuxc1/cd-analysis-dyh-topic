package ths.project.analysis.forecast.ensembleprediction.service;

import org.springframework.stereotype.Service;
import ths.project.analysis.forecast.ensembleprediction.mapper.EnsemblePredictionMapper;

import java.util.HashMap;
import java.util.Map;

@Service
public class EnsemblePredictionService {

    private final EnsemblePredictionMapper ensemblePredictionMapper;

    public EnsemblePredictionService(EnsemblePredictionMapper ensemblePredictionMapper) {
        this.ensemblePredictionMapper = ensemblePredictionMapper;
    }

    public Map<String, Object> getForecastDataList(Map<String, Object> queryParam) {
        Map<String,Object> resultMap = new HashMap<>();
        resultMap.put("legend",ensemblePredictionMapper.getModelList(queryParam));
        resultMap.put("forecastAirDataData",ensemblePredictionMapper.getForecastAirDataList(queryParam));
        resultMap.put("forecastWaterData",ensemblePredictionMapper.getForecastWaterDataList(queryParam));
        return resultMap;
    }
}

package ths.project.analysis.forecast.multifactorcomparison.service;

import org.springframework.stereotype.Service;
import ths.project.analysis.forecast.multifactorcomparison.mapper.MultiFactorComparisonMapper;
import ths.project.analysis.forecast.numericalmodel.query.ForecastQuery;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class MultiFactorComparisonService {

    private final MultiFactorComparisonMapper multiFactorComparisonMapper;

    public MultiFactorComparisonService(MultiFactorComparisonMapper multiFactorComparisonMapper) {
        this.multiFactorComparisonMapper = multiFactorComparisonMapper;
    }


    public List<Map<String, Object>> getPollutes() {

        return multiFactorComparisonMapper.getPollutes();
    }

    public Map<String, Object> getModelForcatsData(ForecastQuery forecastQuery) {

        HashMap<String, Object> resultMap = new HashMap<>();
        //日期
        String modelTime = forecastQuery.getModelTime();
        String oldModelTime = forecastQuery.getOldModelTime();

        //当天12时
        forecastQuery.setModelTime(modelTime + " 12:00:00");
        forecastQuery.setStartStep(1);
        resultMap.put("twelve", multiFactorComparisonMapper.getModelForcatsHourData(forecastQuery));
        //当天00时
        forecastQuery.setModelTime(modelTime + " 00:00:00");
        resultMap.put("zero", multiFactorComparisonMapper.getModelForcatsHourData(forecastQuery));

        //上一天12时
        //forecastQuery.setModelTime(oldModelTime + " 12:00:00");
       //forecastQuery.setStartStep(2);
        //resultMap.put("oldTwelve", multiFactorComparisonMapper.getModelForcatsHourData(forecastQuery));
        //上一天00时
       //forecastQuery.setModelTime(oldModelTime + " 00:00:00");
        //resultMap.put("oldZero", multiFactorComparisonMapper.getModelForcatsHourData(forecastQuery));

        return resultMap;
    }
}

package ths.project.api.airQualityImprovement.mapper;

import ths.project.api.airQualityImprovement.entity.AirQualityImprovement;
import ths.project.api.airQualityImprovement.entity.AirQualityImprovementHour;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface AirQualityImprovementMapper {

    List<AirQualityImprovement> queryAirQualityImprovementYear();

    List<AirQualityImprovement> queryAirQualityImprovementMonth();

    List<AirQualityImprovement> queryAirQualityImprovementDay();

    List<AirQualityImprovementHour> queryAirQualityImprovementHour();

    HashMap<String,Object> queryAirQualityImprovementMonthRemark(Map<String, Object> param);

    HashMap<String, Object> queryAirQualityImprovementYearRemark(Map<String, Object> param);

    HashMap<String, Object> queryAirQualityImprovementDayRemark(Map<String, Object> param);

    HashMap<String, Object> queryAirQualityImprovementHourRemark(Map<String, Object> param);
}


package ths.project.api.airQualityImprovement.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ths.project.api.airQualityImprovement.entity.AirQualityImprovement;
import ths.project.api.airQualityImprovement.entity.AirQualityImprovementHour;
import ths.project.api.airQualityImprovement.mapper.AirQualityImprovementMapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class AirQualityImprovementService {

    @Autowired
    private AirQualityImprovementMapper airQualityImprovementMapper;
    /**
     * 查询空气质量改善(近5年)
     * @return
     */
    public List<AirQualityImprovement> queryAirQualityImprovementYear() {
        return airQualityImprovementMapper.queryAirQualityImprovementYear();
    }


    /**
     * 查询空气质量改善(近12个月)
     * @return
     */
    public List<AirQualityImprovement> queryAirQualityImprovementMonth() {
        return airQualityImprovementMapper.queryAirQualityImprovementMonth();
    }

    /**
     * 查询空气质量改善(近30天，无优良天数和重污染天数)
     * @return
     */
    public List<AirQualityImprovement> queryAirQualityImprovementDay() {
        return airQualityImprovementMapper.queryAirQualityImprovementDay();
    }


    /**
     * 查询空气质量改善(近24小时，无优良天数和重污染天数)
     * @return
     */
    public List<AirQualityImprovementHour> queryAirQualityImprovementHour() {
        return airQualityImprovementMapper.queryAirQualityImprovementHour();
    }

    /**
     * 查询空气质量改善(近12个月)
     * @return
     * @param param
     */
    public HashMap<String,Object> queryAirQualityImprovementMonthRemark(Map<String, Object> param) {
        return airQualityImprovementMapper.queryAirQualityImprovementMonthRemark(param);
    }

    public HashMap<String,Object> queryAirQualityImprovementYearRemark(Map<String, Object> param) {
        return airQualityImprovementMapper.queryAirQualityImprovementYearRemark(param);
    }

    public HashMap<String,Object> queryAirQualityImprovementDayRemark(Map<String, Object> param) {
        return airQualityImprovementMapper.queryAirQualityImprovementDayRemark(param);
    }

    public HashMap<String,Object> queryAirQualityImprovementHourRemark(Map<String, Object> param) {
        return airQualityImprovementMapper.queryAirQualityImprovementHourRemark(param);
    }
}

package ths.project.api.airQualityImprovement.web;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import ths.project.common.data.DataResult;
import ths.project.api.airQualityImprovement.service.AirQualityImprovementService;

import java.util.Map;


@RequestMapping("/api/airQualityImprovement")
@Controller
public class AirQualityImprovementController {

    @Autowired
    private AirQualityImprovementService airQualityImprovementService;



    /**
     * 查询空气质量改善数据（近12个月）
     *
     * @return DataResult
     */
    @RequestMapping("/queryAirQualityImprovementMonth")
    @ResponseBody
    public DataResult queryAirQualityImprovementMonth() {
        return DataResult.success(airQualityImprovementService.queryAirQualityImprovementMonth());
    }


    /**
     * 查询空气质量改善数据（近5年）
     *
     * @return DataResult
     */
    @RequestMapping("/queryAirQualityImprovementYear")
    @ResponseBody
    public DataResult queryAirQualityImprovementYear() {
        return DataResult.success(airQualityImprovementService.queryAirQualityImprovementYear());
    }



    /**
     * 查询空气质量改善数据（近30天数据，无优良天数和重污染天数）
     *
     * @return DataResult
     */
    @RequestMapping("/queryAirQualityImprovementDay")
    @ResponseBody
    public DataResult queryAirQualityImprovementDay() {
        return DataResult.success(airQualityImprovementService.queryAirQualityImprovementDay());
    }



    /**
     * 查询空气质量改善数据（近24小时数据，无优良天数和重污染天数）
     *
     * @return DataResult
     */
    @RequestMapping("/queryAirQualityImprovementHour")
    @ResponseBody
    public DataResult queryAirQualityImprovementHour() {
        return DataResult.success(airQualityImprovementService.queryAirQualityImprovementHour());
    }


    /**
     * 查询空气质量改善数据（近12个月）备注
     *
     * @return DataResult
     */
    @RequestMapping("/queryAirQualityImprovementMonthRemark")
    @ResponseBody
    public DataResult queryAirQualityImprovementMonthRemark(@RequestParam Map<String, Object> param) {
        return DataResult.success(airQualityImprovementService.queryAirQualityImprovementMonthRemark(param));
    }

    /**
     * 查询空气质量改善数据（近5年）备注
     *
     * @return DataResult
     */
    @RequestMapping("/queryAirQualityImprovementYearRemark")
    @ResponseBody
    public DataResult queryAirQualityImprovementYearRemark(@RequestParam Map<String, Object> param) {
        return DataResult.success(airQualityImprovementService.queryAirQualityImprovementYearRemark(param));
    }


    /**
     * 查询空气质量改善数据（近30天数据，无优良天数和重污染天数）备注
     *
     * @return DataResult
     */
    @RequestMapping("/queryAirQualityImprovementDayRemark")
    @ResponseBody
    public DataResult queryAirQualityImprovementDayRemark(@RequestParam Map<String, Object> param) {
        return DataResult.success(airQualityImprovementService.queryAirQualityImprovementDayRemark(param));
    }

    /**
     * 查询空气质量改善数据（近24小时数据，无优良天数和重污染天数）备注
     *
     * @return DataResult
     */
    @RequestMapping("/queryAirQualityImprovementHourRemark")
    @ResponseBody
    public DataResult queryAirQualityImprovementHourRemark(@RequestParam Map<String, Object> param) {
        return DataResult.success(airQualityImprovementService.queryAirQualityImprovementHourRemark(param));
    }
}

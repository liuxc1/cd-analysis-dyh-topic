package ths.project.analysis.airqualitystatus.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import ths.jdp.core.context.PropertyConfigure;
import ths.project.analysis.airqualitystatus.service.AirQualityStatusService;

import java.util.Map;

/**
 * 空气质量现状
 *
 * @date 2021年09月08日 11:00
 */
@Controller
@RequestMapping("/analysis/airQualityStatus")
public class AirQualityStatusController {

    @Autowired
    private AirQualityStatusService airQualityStatusService;

    @RequestMapping("/index")
    public ModelAndView index() {
        ModelAndView result = new ModelAndView("analysis/airqualitystatus/index");
        //查询最新日数据和小时数据最新时间
        Map<String, String> maxDate = airQualityStatusService.getMaxDate();
        result.addObject("dateHourTime",maxDate.get("dateHourTime"));
        result.addObject("dateDayTime",maxDate.get("dateDayTime"));
        result.addObject("path", PropertyConfigure.getProperty("airImageUrl").toString());
        return result;
    }
}

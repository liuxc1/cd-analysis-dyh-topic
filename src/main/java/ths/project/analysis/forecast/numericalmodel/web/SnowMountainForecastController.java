package ths.project.analysis.forecast.numericalmodel.web;

import org.apache.commons.collections.MapUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import ths.jdp.core.context.PropertyConfigure;
import ths.project.analysis.forecast.numericalmodel.service.ModelwqDayRowService;

import java.util.Map;

/**
 * @author lx
 * @date 2022年05月09日 20:25
 * 雪山指数预报
 */
@Controller
@RequestMapping("/analysis/air/snowMountainForecast")
public class SnowMountainForecastController {

    @Autowired
    private ModelwqDayRowService modelwqDayRowService;
    /**
     * 跳转雪山指数预报
     * @return
     */
    @RequestMapping("/index")
    public ModelAndView index(){
        ModelAndView result = new ModelAndView("/analysis/forecast/numericalmodel/snowMountainForecast");
        Map<String, Object> maxDate = modelwqDayRowService.getMaxDate();
        result.addObject("dateTime", MapUtils.getString(maxDate,"MAX_DATE").substring(0,10));
        result.addObject("path", PropertyConfigure.getProperty("wrfUrl").toString());
        return result;
    }

}

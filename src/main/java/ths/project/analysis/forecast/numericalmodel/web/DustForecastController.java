package ths.project.analysis.forecast.numericalmodel.web;

import org.apache.commons.collections.MapUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import ths.jdp.core.context.PropertyConfigure;
import ths.project.analysis.forecast.numericalmodel.service.ModelwqDayRowService;
import ths.project.common.util.DateUtil;

import java.util.Map;

/**
 * 沙尘预报
 */
@Controller
@RequestMapping("/analysis/air/dustForecast")
public class DustForecastController {
    @Autowired
    private ModelwqDayRowService modelwqDayRowService;

    @RequestMapping("/index")
    public ModelAndView index()  {
        ModelAndView result = new ModelAndView("analysis/forecast/numericalmodel/dustForecast");
        Map maxDate = modelwqDayRowService.getMaxDate();
        result.addObject("dateTime", DateUtil.history("yyyy-MM-dd", 0));
        if(maxDate != null && maxDate.get("MAX_DATE") != null && !"".equals(maxDate.get("MAX_DATE"))){
            result.addObject("dateTime", MapUtils.getString(maxDate,"MAX_DATE").substring(0,10));
        }
        result.addObject("path", PropertyConfigure.getProperty("wrfUrl").toString());
        return result;
    }
}

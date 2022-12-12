package ths.project.analysis.forecast.concentrationdistribution.web;

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
 * 浓度分布
 */
@Controller
@RequestMapping("/analysis/pollutants/concentration")
public class ConcentrationDistributionController {

    @Autowired
    private ModelwqDayRowService modelwqDayRowService;

    @RequestMapping("/distributed")
    public ModelAndView wrfmap()  {
        ModelAndView result = new ModelAndView("analysis/forecast/concentrationdistribution/concentrationdistribution");
        Map maxDate = modelwqDayRowService.getMaxDate();
        result.addObject("dateTime", DateUtil.history("yyyy-MM-dd", -1));
        if(maxDate != null && maxDate.get("MAX_DATE") != null && !"".equals(maxDate.get("MAX_DATE"))){
            result.addObject("dateTime", MapUtils.getString(maxDate,"MAX_DATE").substring(0,10));
        }
        result.addObject("path", PropertyConfigure.getProperty("wrfUrl").toString());
        return result;
    }

    /**
     *
     * @return
     */
    @RequestMapping("/distributed_new")
    public ModelAndView index()  {
        ModelAndView result = new ModelAndView("analysis/forecast/concentrationdistribution/concentrationdistribution_new");
        Map maxDate = modelwqDayRowService.getMaxDate();
        result.addObject("dateTime", DateUtil.history("yyyy-MM-dd", -1));
        if(maxDate != null && maxDate.get("MAX_DATE") != null && !"".equals(maxDate.get("MAX_DATE"))){
            result.addObject("dateTime", MapUtils.getString(maxDate,"MAX_DATE").substring(0,10));
        }
        result.addObject("path", PropertyConfigure.getProperty("wrfUrl").toString());
        return result;
    }
}

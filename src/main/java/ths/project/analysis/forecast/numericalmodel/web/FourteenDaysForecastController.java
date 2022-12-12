package ths.project.analysis.forecast.numericalmodel.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import ths.jdp.core.context.PropertyConfigure;
import ths.project.analysis.forecast.numericalmodel.query.ForecastQuery;
import ths.project.analysis.forecast.numericalmodel.service.FourteenDaysForecastService;
import ths.project.common.data.DataResult;

import java.util.Map;

/**
 * 未来14天预报
 */
@Controller
@RequestMapping("/analysis/air/fourteenDaysForecast")
public class FourteenDaysForecastController {

    @Autowired
    private FourteenDaysForecastService fourteenDaysForecastService;

    /**
     * 跳转14天预报页面
     *
     * @return
     */
    @RequestMapping("/toFourteenDaysForecast")
    public String toFourteenDaysForecast() {
        return "/analysis/forecast/numericalmodel/fourteenDaysForecast";
    }


    /**
     * 根据时间，站点或者行政区查询14天预报数据
     *
     * @param modelwqDayRowQuery
     * @return
     */
    @RequestMapping("/getEchartsData")
    @ResponseBody
    public DataResult getEchartsData(ForecastQuery modelwqDayRowQuery) {
        Map<String, Object> result = fourteenDaysForecastService.getEchartsData(modelwqDayRowQuery);
        return DataResult.success(result);
    }

    /**
     * 跳转14天预报页面(新)
     *
     * @return
     */
    @RequestMapping("/toFourteenDaysForecastNew")
    public ModelAndView toFourteenDaysForecastNew() {
        ModelAndView result = new ModelAndView("/analysis/forecast/numericalmodel/fourteenDaysForecast_new");
        result.addObject("path", PropertyConfigure.getProperty("wrfUrl").toString());
        return result;
    }

    /**
     * 雪山指数空气质量预报
     *
     * @return
     */
    @RequestMapping("/snowMountainForecast")
    public ModelAndView snowMountainForecast() {
        ModelAndView result = new ModelAndView("/analysis/forecast/numericalmodel/snowMountainForecast_index");
        result.addObject("path", PropertyConfigure.getProperty("wrfUrl").toString());
        return result;
    }

}

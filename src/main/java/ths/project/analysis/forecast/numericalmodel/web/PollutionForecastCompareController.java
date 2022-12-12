package ths.project.analysis.forecast.numericalmodel.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import ths.project.analysis.forecast.numericalmodel.query.ForecastQuery;
import ths.project.analysis.forecast.numericalmodel.service.PollutionForecastCompareService;
import ths.project.common.data.DataResult;

import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

/**
 * 近期污染物浓度预报比较
 */
@Controller
@RequestMapping("/analysis/air/pollutionForecastCompare")
public class PollutionForecastCompareController {
    @Autowired
    private PollutionForecastCompareService pollutionForecastCompareService;

    /**
     * 跳转预报比较页面
     *
     * @return
     */
    @RequestMapping("/toPollutionForecastCompare")
    public String toFourteenDaysForecast() {
        return "/analysis/forecast/numericalmodel/pollutionForecastCompare";
    }

    /**
     * 查询默认时间
     */
    @RequestMapping("/getMaxDate")
    @ResponseBody
    public DataResult getMaxDate(ForecastQuery query) {
        return DataResult.success(pollutionForecastCompareService.queryMaxDate(query));
    }

    /**
     * 获取echarts数据
     */
    @RequestMapping("/getEchartsData")
    @ResponseBody
    public DataResult getEchartsData(ForecastQuery query) {
        return DataResult.success(pollutionForecastCompareService.queryForecastData(query));
    }

    /**
     * 导出数据
     */
    @RequestMapping("/exportExcel")
    @ResponseBody
    public void exportExcel(ForecastQuery query, HttpServletResponse response) {
        pollutionForecastCompareService.exportExcel(query, response);
    }

}

package ths.project.analysis.forecast.fourteendayforecastcalendar.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import ths.project.analysis.forecast.fourteendayforecastcalendar.service.PlainForecastCalendarService;
import ths.project.analysis.forecast.numericalmodel.query.ForecastQuery;
import ths.project.common.data.DataResult;

import javax.servlet.http.HttpServletResponse;

/**
 * 平原城市14天预报数据
 */
@Controller
@RequestMapping("/analysis/calendar/forecast")
public class PlainForecastCalendarController {

    @Autowired
    private PlainForecastCalendarService plainForecastCalendarService;

    /**
     * 跳转到列表页面
     */
    @RequestMapping("/forecastList")
    public String forecastList() {
        return "analysis/forecast/calendarforecast/calendarForecastList";
    }


    /**
     * 获取天数数据
     */
    @RequestMapping("/getEchartsData")
    @ResponseBody
    public DataResult getEchartsData(ForecastQuery query) {
        return DataResult.success( plainForecastCalendarService.getDayList(query));
    }


    /**
     * 导出数据
     */
    @RequestMapping("/exportExcel")
    @ResponseBody
    public void exportExcel(ForecastQuery query,HttpServletResponse response) {
        plainForecastCalendarService.exportExcel(query, response);
    }
}

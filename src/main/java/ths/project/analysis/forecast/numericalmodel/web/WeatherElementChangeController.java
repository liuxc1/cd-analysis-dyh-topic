package ths.project.analysis.forecast.numericalmodel.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import ths.jdp.core.dao.base.Paging;
import ths.project.analysis.forecast.numericalmodel.entity.WrfDataDay;
import ths.project.analysis.forecast.numericalmodel.entity.WrfDataHour;
import ths.project.analysis.forecast.numericalmodel.entity.WrfDataHourNw;
import ths.project.analysis.forecast.numericalmodel.query.ForecastQuery;
import ths.project.analysis.forecast.numericalmodel.service.WeatherElementChangeService;
import ths.project.common.data.DataResult;

import javax.servlet.http.HttpServletResponse;
import java.util.LinkedHashMap;

/**
 * 气象要素变化
 *
 * @date 2021年06月23日 11:42
 */
@Controller
@RequestMapping("/analysis/air/weatherElementChange")
public class WeatherElementChangeController {

    @Autowired
    private WeatherElementChangeService weatherElementChangeService;

    /**
     * 跳转气象要素变化页面
     *
     * @return
     */
    @RequestMapping("/toWeatherElementChange")
    public String toWeatherElementChange() {
        return "/analysis/forecast/numericalmodel/weatherElementChange";
    }

    /**
     * 获取气象数据
     */
    @RequestMapping("/getWeatherData")
    @ResponseBody
    public DataResult getWeatherData(ForecastQuery query) {
        return DataResult.success(weatherElementChangeService.getWeatherData(query));
    }
    @RequestMapping("/getWeatherData2")
    @ResponseBody
    public DataResult getWeatherData2(ForecastQuery query) {
        return DataResult.success(weatherElementChangeService.getWeatherData2(query));
    }
    /**
     * 获取气象数据(分页)（小时数据）
     */
    @RequestMapping("/getWeatherDataPage")
    @ResponseBody
    public DataResult getWeatherDataPage(ForecastQuery query, Paging<WrfDataHour> pageInfo) {
        return DataResult.success(weatherElementChangeService.queryWeatherDataList(query, pageInfo));
    }

    /**
     * 获取气象数据(分页)（日数据）
     */
    @RequestMapping("/getWeatherDayDataPage")
    @ResponseBody
    public DataResult getWeatherDayDataPage(ForecastQuery query, Paging<WrfDataDay> pageInfo) {
        return DataResult.success(weatherElementChangeService.getWeatherDayDataPage(query, pageInfo));
    }
    /**
     * 获取气象数据(分页)（逆温数据）
     */
    @RequestMapping("/getWeatherDataNwPage")
    @ResponseBody
    public DataResult getWeatherDataNwPage(ForecastQuery query,  Paging<LinkedHashMap<String, Object>> pageInfo) {
        return DataResult.success(weatherElementChangeService.queryWeatherDataNwList(query, pageInfo));
    }
    /**
     * 获取气象数据(分页)（水汽分布）
     */
    @RequestMapping("/getWeatherDataSqPage")
    @ResponseBody
    public DataResult getWeatherDataSqPage(ForecastQuery query, Paging<WrfDataHourNw> pageInfo) {
        return DataResult.success(weatherElementChangeService.queryWeatherDataSqList(query, pageInfo));
    }

    /**
     * 导出数据
     */
    @RequestMapping("/exportExcel")
    @ResponseBody
    public void exportExcel(ForecastQuery query, HttpServletResponse response) {
        weatherElementChangeService.exportExcel(query, response);
    }
}

package ths.project.analysis.forecast.numericalmodel.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import ths.project.analysis.forecast.numericalmodel.query.ForecastQuery;
import ths.project.analysis.forecast.numericalmodel.service.ComponentsForecastService;
import ths.project.common.data.DataResult;

import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 * PM25组分预报
 * @date 2021年06月22日 15:15
 */
@Controller
@RequestMapping("/analysis/air/componentsForecast")
public class ComponentsForecastController {

    @Autowired
    private ComponentsForecastService componentsForecastService;
    /**
     * 跳转pm25组分预报页面
     *
     * @return
     */
    @RequestMapping("/toComponentsForecast")
    public String toFourteenDaysForecast() {
        return "/analysis/forecast/numericalmodel/componentsForecast";
    }

    /**
     * 获取PM25组分数据
     * @param query
     * @return
     */
    @RequestMapping("/getComponentsData")
    @ResponseBody
    public DataResult getComponentsData(ForecastQuery query){
        return DataResult.success(componentsForecastService.getComponentsData(query));
    }

    /**
     * 导出数据
     */
    @RequestMapping("/exportExcel")
    @ResponseBody
    public void exportExcel(ForecastQuery query, HttpServletResponse response) {
        componentsForecastService.exportExcel(query, response);
    }


}

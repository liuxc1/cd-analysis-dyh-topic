package ths.project.analysis.forecast.trendforecast.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import ths.jdp.core.dao.base.Paging;
import ths.project.analysis.forecast.numericalmodel.query.ForecastQuery;
import ths.project.analysis.forecast.trendforecast.entity.TBasModelwqHourRow;
import ths.project.analysis.forecast.trendforecast.service.TrendForecastService;
import ths.project.common.data.DataResult;

import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 *天气天空预报变化趋势
 */

@Controller
@RequestMapping("/analysis/forecast/trend")
public class TrendForecastController {

    @Autowired
    private TrendForecastService trendForecastService;
    /**
     * 跳转到列表页面
     */
    @RequestMapping("/trendList")
    public String trendList() {
        return "analysis/forecast/trendforecast/thendForecast";
    }


    /**
     * 获取天数据
     */
    @RequestMapping("/getEchartsData")
    @ResponseBody
    public DataResult getEchartsData(String modelTime,String pointCode) {
        return DataResult.success(trendForecastService.getHourList(modelTime,pointCode));
    }

    /**
     * 获取分页数据
     */
    @RequestMapping("/getPagingDataList")
    @ResponseBody
    public DataResult getPagingDataList(@RequestParam Map<String, Object> paramMap, Paging<TBasModelwqHourRow> paging) {
        return DataResult.success(trendForecastService.getPagingHourData(paramMap,paging));
    }

    /**
     * 导出预报数据
     */
    @RequestMapping("/exportExcel")
    @ResponseBody
    public void exportExcel(ForecastQuery query, HttpServletResponse response) {
        trendForecastService.exportExcel(query, response);
    }
}

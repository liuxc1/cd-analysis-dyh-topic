package ths.project.analysis.forecast.numericalmodel.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import ths.jdp.core.dao.base.Paging;
import ths.project.analysis.forecast.numericalmodel.entity.ForecastLog;
import ths.project.analysis.forecast.numericalmodel.query.ForecastQuery;
import ths.project.analysis.forecast.numericalmodel.service.ForecastLogService;
import ths.project.common.data.DataResult;
import ths.project.common.entity.Image;
import ths.project.common.util.ExcelUtil;

import javax.servlet.http.HttpServletResponse;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 预报进程
 */
@Controller
@RequestMapping("/analysis/air/ForecastProcess")
public class ForecastProcessController {
    @Autowired
    private ForecastLogService forecastLogService;
    /**
     * 跳转预报进程
     * @return
     */
    @RequestMapping("/toForecastProcess")
    public String toFourteenDaysForecast(){
        return "/analysis/forecast/numericalmodel/forecastProcess";
    }

    /**
     *查询最大时间
     * @return
     */
    @RequestMapping("/queryMaxLogTime")
    @ResponseBody
    public DataResult queryMaxLogTime(){
        return DataResult.success(forecastLogService.queryMaxLogTime());
    }

    /**
     *查询预报日志数据
     * @param forecastTimeStart，forecastTimeEnd
     * @return
     */
    @RequestMapping("/getForecastLog")
    @ResponseBody
    public DataResult getForecastLog(String forecastTimeStart, String forecastTimeEnd, Paging pageInfo){
        return DataResult.success(forecastLogService.getForecastLogFormLogTime(forecastTimeStart,forecastTimeEnd,pageInfo));
    }


    /**
     * 导出数据
     */
    @RequestMapping("/exportExcel")
    @ResponseBody
    public void exportExcel(HttpServletResponse response,String forecastTimeStart, String forecastTimeEnd) {
        List<LinkedHashMap<String,Object>> dataList = forecastLogService.getExportForecastLogFormLogTime(forecastTimeStart,forecastTimeEnd);
        ExcelUtil.exportExcelByTemp07(response, "pollutionForecastProcess.xlsx", "预报进程.xlsx",0,1,  0, dataList,null);

    }
}

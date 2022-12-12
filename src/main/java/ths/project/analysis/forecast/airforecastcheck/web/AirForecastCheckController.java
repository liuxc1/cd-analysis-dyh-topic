package ths.project.analysis.forecast.airforecastcheck.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import ths.project.analysis.forecast.airforecastcheck.service.AirForecastCheckService;
import ths.project.common.data.DataResult;
import ths.project.common.util.ExcelUtil;

import javax.servlet.http.HttpServletResponse;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 预报核对模块
 */
@RequestMapping({"analysis/forecast/airforecastcheck/airForecastCheck", "/analysis/forecastflow/humanForecastCheck"})
@Controller
public class AirForecastCheckController {

    @Autowired
    private AirForecastCheckService airForecastCheckService;

    /**
     * 数值预报页面
     */
    @RequestMapping("/index")
    public ModelAndView index() {
        ModelAndView modelAndView = new ModelAndView("analysis/forecast/airforecastcheck/index");
        Map<String, Object> timeMap = airForecastCheckService.queryMaxTime(null);
        modelAndView.addObject("START_TIME", timeMap.get("START_TIME"));
        modelAndView.addObject("END_TIME", timeMap.get("END_TIME"));
        return modelAndView;
    }

    /**
     * 获取最新监测时间
     *
     */
    @RequestMapping("/getMaxTime")
    @ResponseBody
    public DataResult getMaxTime(String isCd) {
        return DataResult.success(airForecastCheckService.queryMaxTime(isCd));
    }

    /**
     * 获取预报核对Echarts
     *
     * @param map 请求参数
     */
    @RequestMapping("/getForecastCheckEchartsData")
    @ResponseBody
    public Object getForecastCheckEchartsData(@RequestParam Map<String, Object> map) {
        // 获取预报核对Echarts
        return DataResult.success(airForecastCheckService.getForecastEchartsData(map));
    }

    /**
     * 获取预报表格数据
     *
     * @param map 请求参数
     */
    @RequestMapping("/getForecastTableData")
    @ResponseBody
    public Object getForecastTableData(@RequestParam Map<String, Object> map) {
        return DataResult.success(airForecastCheckService.queryForecastTableData(map));
    }


    /**
     * 获取模型类型
     */
    @RequestMapping("/getForecastModel")
    @ResponseBody
    public DataResult getForecastModel() {
        return DataResult.success(airForecastCheckService.getForecastModel());
    }

    /**
     * 获取预报用户
     */
    @RequestMapping("/getForecastUser")
    @ResponseBody
    public DataResult getForecastUser() {
        return DataResult.success(airForecastCheckService.getForecastUser());
    }

    /**
     * 跳转区县准备率页面
     * @return
     */
    @RequestMapping("/countyIndex")
    public ModelAndView countyIndex() {
        ModelAndView modelAndView = new ModelAndView("analysis/forecast/airforecastcheck/countyIndex2");
        return modelAndView;
    }

    /**
     * 区县预报准确率
     * @param param
     * @return
     */
    @RequestMapping("/getForecastCountyTableData")
    @ResponseBody
    public DataResult getForecastCountyTableData(@RequestParam Map<String,Object> param) {
        return DataResult.success(airForecastCheckService.getForecastCountyTableData(param));
    }


    /**
     * 导出区县预报准确率
     * @param param
     * @param response
     */
    @RequestMapping("/exportExcel")
    @ResponseBody
    public void exportExcel(@RequestParam Map<String,Object> param,HttpServletResponse response) {
        List<LinkedHashMap<String,Object>> dataList = airForecastCheckService.getForecastCountyTableData(param);
        ExcelUtil.exportExcelByTemp07(response, "QXYBZQL.xlsx", "区县预报准确率.xlsx",0,2,  0, dataList,null);
    }
}

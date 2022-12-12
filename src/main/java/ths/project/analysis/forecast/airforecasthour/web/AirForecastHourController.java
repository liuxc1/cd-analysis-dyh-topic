package ths.project.analysis.forecast.airforecasthour.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import ths.jdp.core.model.LoginUserModel;
import ths.jdp.core.web.LoginCache;
import ths.project.analysis.forecast.airforecasthour.entity.ModelwqHourRow;
import ths.project.analysis.forecast.airforecasthour.service.AirForecastHourService;
import ths.project.common.data.DataResult;

import javax.servlet.http.HttpServletResponse;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 科研平台-逐小时预报
 *
 * @author qsx
 */
@Controller
@RequestMapping("/analysis/forecastflow/AirForecastHour")
public class AirForecastHourController {

    @Autowired
    private AirForecastHourService airForecastHourService;

    /**
     * 科研平台-逐小时预报
     */
    @RequestMapping("/toAirForecastHour")
    public String toAirForecastHour() {
        return "analysis/forecast/airforecasthour/airforecasthour_index";
    }

    /**
     * 获取最大时间
     */
    @RequestMapping("/getMaxDateAndUser")
    @ResponseBody
    public DataResult getMaxDateAndUser() {
        Map<String, Object> result = null;
        LoginUserModel loginUser = LoginCache.getLoginUser();
        result = new HashMap<String, Object>();
        result.put("userId", loginUser.getLoginName());
        result.put("userName", loginUser.getUserName());
        return DataResult.success(result);
    }

    /**
     * 获取预报类型和用户
     */
    @RequestMapping("/getForecastTypeAndUser")
    @ResponseBody
    public DataResult getForecastTypeAndUser(String modeltime) {
        List<ModelwqHourRow> result = null;
        result = airForecastHourService.getForecastTypeAndUser(modeltime);
        return DataResult.success(result);
    }

    /**
     * 获取小时数据列表信息
     */
    @RequestMapping("/getTableData")
    @ResponseBody
    public DataResult getTableData(String modeltime, String models) {
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("modeltime", modeltime);
        param.put("models", models);
        param.put("pointCode", "510100000000");
        List<Map<String, Object>> tableDataList = null;
        tableDataList = airForecastHourService.getTableData(param);
        return DataResult.success(tableDataList);
    }

    /**
     * 获取时间数据
     */
    @RequestMapping("/getDayList")
    @ResponseBody
    public DataResult getDayList(@RequestParam Map<String, Object> param) {
        List<Map<String, Object>> dayList;
        dayList = airForecastHourService.getDayList(param);
        return DataResult.success(dayList);
    }


    /**
     * 保存
     */
    @RequestMapping("/save")
    @ResponseBody
    public DataResult save(@RequestBody List<Map<String, Object>> paramList) throws ParseException {
        LoginUserModel loginUser = LoginCache.getLoginUser();
        airForecastHourService.save(paramList, loginUser);
        return DataResult.success();
    }

    /**
     * 导出数据
     *
     * @param response
     * @param modeltime
     * @param models
     */
    @RequestMapping("/exportExcel")
    @ResponseBody
    public void exportExcel(HttpServletResponse response, String modeltime, String models) {
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("modeltime", modeltime);
        param.put("models", models);
        param.put("pointCode", "510100000000");
        airForecastHourService.exportExcel(response, param);
    }


}

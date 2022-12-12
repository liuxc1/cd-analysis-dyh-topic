package ths.project.warnreport.dailyreport.web;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import ths.jdp.core.web.LoginCache;
import ths.project.common.data.DataResult;
import ths.project.common.util.DateUtil;
import ths.project.common.util.ExcelUtil;
import ths.project.warnreport.dailyreport.service.DailyReportService;

import javax.servlet.http.HttpServletResponse;
import java.lang.reflect.InvocationTargetException;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 夏季臭氧报警日报
 */
@RequestMapping({"warnreport/dailyReport"})
@Controller
public class DailyReportController {


    private final DailyReportService dailyReportService;

    @Autowired
    public DailyReportController(DailyReportService dailyReportService) {
        this.dailyReportService = dailyReportService;
    }

    @RequestMapping("/dailyReport")
    public String dailyReport() {
        return "warnreport/dailyReport/dailyReportIndex";
    }

    /**
     * 根据时间类型查询有报告情况
     *
     * @param param
     * @return
     */
    @RequestMapping("/queryDayRecordListByReportTime")
    @ResponseBody
    public DataResult queryDayRecordListByReportTime(@RequestParam Map<String, Object> param) {
        return DataResult.success(dailyReportService.queryDayRecordListByReportTime(param));
    }

    /**
     * 查询具体文件
     *
     * @param param
     * @return
     */
    @RequestMapping("/getFile")
    @ResponseBody
    public DataResult getFile(@RequestParam Map<String, Object> param) {
        return DataResult.success(dailyReportService.getFile(param));
    }

    /**
     * 导出日报数据
     */
    @RequestMapping("/exportExcel")
    @ResponseBody
    public void exportExcel(HttpServletResponse response, String dateTime) throws IllegalAccessException, NoSuchMethodException, InvocationTargetException {
        List<LinkedHashMap<String, Object>> dataList = dailyReportService.dailyReportEmergencyControlList(dateTime);
        ExcelUtil.exportExcelByTemp07(response, "YJYAZXQK.xlsx", "成都市臭氧重污染天气应急管控工作日报表.xlsx", 0, 1, 3, dataList, null);
    }

    /**
     * 导出生态环境局日报
     *
     * @param response
     * @param dateTime
     */
    @RequestMapping("/exportStDailyReportExcel")
    @ResponseBody
    public void exportStDailyReportExcel(HttpServletResponse response, String dateTime) {
        List<LinkedHashMap<String, Object>> dataList = dailyReportService.exportStDailyReportExcel(dateTime);
        ExcelUtil.exportExcelByTemp07(response, "STHJJ.xlsx", "重污染天气应急管控工作日报表.xlsx", 0, 2, 0, dataList, null);
    }

    /**
     * 跳转新增页面
     *
     * @return
     */
    @RequestMapping("/addWarnDailyReport")
    public String addWarnDailyReport() {
        return "warnreport/dailyReport/dailyReportEdit";
    }

    /**
     * 查询监测数据和预报数据
     *
     * @param param
     * @return
     */
    @ResponseBody
    @RequestMapping("/getAirDataAndForecast")
    public DataResult getAirDataAndForecast(@RequestParam Map<String, Object> param) {
        Map<String, Object> result = dailyReportService.getAirDataAndForecast(param);
        return DataResult.success(result);
    }

    /**
     * 保存并且生成文档
     *
     * @param param
     * @param response
     * @return
     */
    @ResponseBody
    @RequestMapping("/saveWarnDailyReport")
    public DataResult saveWarnDailyReport(@RequestParam Map<String, Object> param, HttpServletResponse response) {
        param.put("createUser", LoginCache.getLoginUser().getUserName());
        Map<String, Object> result = dailyReportService.saveWarnDailyReport(param);
        return DataResult.success(result);
    }

    /**
     * 生成、保存生态环境局日报
     *
     * @param dateTime http://localhost:7090/dyh_analysis/warnreport/dailyReport/saveDailyReportExcel.vm
     */
    @RequestMapping("/saveDailyReportExcel")
    @ResponseBody
    public DataResult saveDailyReportExcel(String dateTime) {
        String reportId = "";
        if (StringUtils.isNotBlank(dateTime)) {
            int days = DateUtil.daysBetween(DateUtil.parseDate(dateTime), new Date());
            String newDate;
            for (int i = 0; i < days; i++) {
                newDate = DateUtil.formatDate(DateUtil.addDay(DateUtil.parseDate(dateTime), i));
                reportId += dailyReportService.saveDailyReportExcel(newDate, LoginCache.getLoginUser()) + ",";
            }
        } else {
            reportId += dailyReportService.saveDailyReportExcel(dateTime, LoginCache.getLoginUser()) + ",";
        }
        return DataResult.success(reportId);
    }
}

package ths.project.analysis.forecast.airforecastmonth.web;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import ths.project.common.util.ExcelUtil;
import ths.project.common.vo.ResponseVo;
import ths.project.analysis.forecast.airforecastmonth.service.MonthTrendService;
import ths.jdp.core.web.LoginCache;
import ths.jdp.core.web.RequestHelper;
import ths.jdp.core.web.base.BaseController;
import ths.project.common.data.DataResult;
import ths.project.common.util.DateUtil;

@Controller
@RequestMapping("/analysis/forecastflow/monthtrend")
public class MonthTrendController extends BaseController {
    @Autowired
    private MonthTrendService monthTrendService;

    /**
     * 跳转到列表页面
     */
    @RequestMapping("/trendList")
    public String cityForecastList() {
        return "analysis/forecast/airforecastmonth/trendList";
    }

    /**
     * 根据报告ID，查询月趋势预报所有信息
     *
     * @param paramMap 参数
     * @return 月趋势预报信息
     */
    @RequestMapping("/queryMonthForecastByReportId")
    @ResponseBody
    public DataResult queryMonthForecastByReportId(@RequestParam Map<String, Object> paramMap) {
        // 报告ID
        String reportId = (String) paramMap.get("reportId");
        paramMap.put("FORECAST_ID", reportId);

        // 验证
        if (StringUtils.isNotBlank(reportId)) {
            Map<String, Object> resultMap = monthTrendService.queryMonthForecastByReportId(paramMap);
            if (resultMap != null && resultMap.size() > 0) {
                return DataResult.success(resultMap);
            } else {
                return DataResult.failure("暂无数据！");
            }
        } else {
            return DataResult.failure("请求参数错误，可能值为空或包含非法字符！");
        }
    }

    /**
     * 跳转到月趋势预报显示页面
     *
     * @return 列表页面
     */
    @RequestMapping("trendView")
    public String trendView(Model model, @RequestParam Map<String, Object> paramMap) {
        model.addAllAttributes(paramMap);
        return "analysis/forecast/airforecastmonth/trendView";
    }

    /**
     * 编辑和添加页面跳转
     */
    @RequestMapping("/trendEditOrAdd")
    public String editOrAdd(Model model, @RequestParam Map<String, Object> paramMap) {
        paramMap.put("LOGINNAME", LoginCache.getLoginUser().getLoginName());
        model.addAllAttributes(paramMap);
        return "/analysis/forecast/airforecastmonth/trendEditOrAdd";
    }

    /**
     * 查询aqi、首要污染物等具体信息
     */
    @RequestMapping("/getForecastValues")
    @ResponseBody
    public ResponseVo getForecastValues(@RequestParam Map<String, Object> paMap) {
        ResponseVo responseVo = new ResponseVo();
        List<Map<String, Object>> forecastValueList = null;
        if (paMap.get("datetime") == null || StringUtils.isBlank(paMap.get("datetime").toString())) {
            return responseVo.failure("请求参数错误，可能值为空或包含非法字符。");
        }
        forecastValueList = monthTrendService.getForecastValues(paMap);
        Map<String, Object> reMap = new HashMap<String, Object>();
        reMap.put("forecastValueList", forecastValueList);
        reMap.put("forecastFlowInfo", "");
        return responseVo.success(reMap);
    }

    /**
     * 保存月趋势预报信息
     */
    @RequestMapping("/saveMonthTrendInfo")
    @ResponseBody
    public ResponseVo saveMonthTrendInfo(@RequestParam(value = "FILES", required = false) MultipartFile[] multipartFiles,
                                         @RequestParam Map<String, Object> paramMap1) throws IOException, ParseException {
        ResponseVo responseVo = new ResponseVo();
        //写入AQI、首要污染物登具体信息，从表
        monthTrendService.saveMonthTrendInfo(multipartFiles, paramMap1);
        responseVo.success("保存成功！");
        return responseVo;
    }

    /**
     * 根据报告ID删除预报
     *
     * @param paramMap 参数
     * @return 删除的条数
     */
    @RequestMapping("/deleteForecastById")
    @ResponseBody
    public ResponseVo deleteForecastById(@RequestParam Map<String, Object> paramMap) {
        ResponseVo responseVo = new ResponseVo();
        int result = monthTrendService.deleteForecastById(paramMap);
        responseVo.success(result);
        return responseVo;
    }

    /**
     * 模版下载
     */
    @RequestMapping("/templateDownload")
    public void templateDownload(HttpServletResponse response, @RequestParam Map<String, Object> paramMap) throws Exception {
        InputStream input = null;
        OutputStream ouputStream = null;
        StringBuilder path = new StringBuilder("/template/");
        SimpleDateFormat sDateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date date = sDateFormat.parse(MapUtils.getString(paramMap, "datetime", DateUtil.getNowDateTime()));
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        int thisYear = calendar.get(Calendar.YEAR);
        int thisMonth = calendar.get(Calendar.MONTH) + 1;
        // 闰年
        if (thisMonth == 2 && (thisYear % 4 == 0 && thisYear % 100 != 0 || thisYear % 400 == 0)) {
            path.append(thisMonth).append("_leap").append(".xlsx");
        } else {
            path.append(thisMonth).append(".xlsx");
        }

        try {
            input = new FileInputStream(RequestHelper.getSession().getServletContext().getRealPath(path.toString()));
            String monthName = thisMonth + "月";
            monthName = new String(monthName.getBytes("gbk"), "iso8859-1");
            response.setHeader("Content-Length", String.valueOf(input.available()));
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-disposition", "attachment;filename=" + monthName + ".xlsx");

            ouputStream = response.getOutputStream();
            byte[] b = new byte[1024];
            int len;
            while ((len = input.read(b)) > 0) {
                ouputStream.write(b, 0, len);
            }
        } finally {
            if (input != null) {
                try {
                    input.close();
                } catch (IOException ignored) {
                }
            }
            if (ouputStream != null) {
                try {
                    ouputStream.close();
                } catch (IOException ignored) {
                }
            }
        }
    }

    /**
     * 查询excel模板导入的数据
     */
    @RequestMapping("/queryExcel")
    @ResponseBody
    public ResponseVo queryExcel(@RequestParam Map<String, Object> paramMap) {
        ResponseVo responseVo = new ResponseVo();
        List<Map<String, Object>> relist = monthTrendService.queryExcel(paramMap);
        responseVo.success(relist);
        return responseVo;
    }

    /**
     * 根据报告时间查询频率为月的记录列表
     *
     * @param paramMap 参数
     * @return 频率为月的记录列表
     */
    @RequestMapping("/monthlyRecordList")
    @ResponseBody
    public ResponseVo queryMonthRecordListByReportTime(@RequestParam Map<String, Object> paramMap) throws ParseException {
        ResponseVo responseVo = new ResponseVo();
        // 归属类型
        String ascriptionType = (String) paramMap.get("ascriptionType");
        // 报告时间(yyyy-MM)
        String reportTime = (String) paramMap.get("reportTime");
        // 验证
        if (StringUtils.isNotBlank(ascriptionType) && StringUtils.isNotBlank(reportTime)) {
            // 根据报告时间查询频率为日的记录列表 和上一个月大气超标指数
            Map<String, Object> resultList = monthTrendService.queryMonthRecordListByReportTime(paramMap);
            if (resultList != null && resultList.size() > 0) {
                responseVo.success(resultList);
            } else {
                responseVo.failure("暂无数据！");
            }
        } else {
            responseVo.failure("请求参数错误，可能值为空或包含非法字符！");
        }
        return responseVo;
    }

    /**
     * 导出数据
     */
    @RequestMapping("/exportExcel")
    @ResponseBody
    public void exportExcel(HttpServletResponse response, String reportId, String reportTime) {
        HashMap<String, Object> paramMap = new HashMap<>();
        // 验证
        if (StringUtils.isNotBlank(reportId)) {
            paramMap.put("FORECAST_ID", reportId);
            List<LinkedHashMap<String, Object>> dataList = monthTrendService.exportExcel(paramMap);
            if (StringUtils.isNotBlank(reportTime)) {
                ExcelUtil.exportExcelByTemp07(response, "MONTH_FORECAST.xlsx", reportTime + "月趋势预报.xlsx", 0, 1, 0, dataList, null);
            }
        }
    }
}
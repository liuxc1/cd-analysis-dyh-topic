package ths.project.analysis.analysisreport.web;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import ths.project.analysis.analysisreport.entity.WeeklyAnalysis;
import ths.project.analysis.analysisreport.entity.WeeklyAnalysisAttach2;
import ths.project.analysis.analysisreport.entity.WinterExpress;
import ths.project.analysis.analysisreport.service.WeekReportService;
import ths.project.analysis.forecast.report.enums.AscriptionTypeEnum;
import ths.project.common.data.DataResult;


import java.util.List;
import java.util.Map;

/**
 * 周报
 */
@RequestMapping("/analysis/analysisreport/weekReport")
@Controller
public class WeekReportController {

    @Autowired
    private WeekReportService weekReportService;

    /**
     * 跳转周报页面
     * @param model
     * @return
     */
    @RequestMapping("/weekReportIndex")
    public String dayAnalysisReportList(Model model) {
        String ascriptionType = AscriptionTypeEnum.WEEK_REPORT.getValue();
        model.addAttribute("ascriptionType", ascriptionType);
         return "/analysis/analysisreport/week/weekReportIndex";
    }

    /**
     * 根据月份，查询频率为日的时间轴列表（月份 可为空）
     * @param paramMap
     * @return
     */
    @RequestMapping("/queryForecastListByWeek")
    @ResponseBody
    public DataResult queryForecastListByWeek(@RequestParam Map<String, Object> paramMap) {
        if (paramMap == null || StringUtils.isBlank((String) paramMap.get("ascriptionType"))) {
            return DataResult.failure("请求参数错误，可能值为空或包含非法字符！");
        } else {
            paramMap.put("ascriptionTypes", "FAST_ANALYSIS_REPORT");
            List<Map<String, Object>> resultList = weekReportService.queryForecastListByWeek(paramMap);

            if (resultList != null && resultList.size() > 0) {
                return DataResult.success(resultList);
            } else {
                return DataResult.failure("暂无数据！");
            }
        }
    }
    /**
     * 跳转编辑
     * @param model
     * @param paramMap
     * @return
     */
    @RequestMapping("/weekReportEdit")
    public String fastAnalysisReportEdit(Model model, @RequestParam Map<String, Object> paramMap) {
        model.addAttribute("reportId", paramMap.get("reportId"));
        model.addAttribute("ascriptionType", AscriptionTypeEnum.WEEK_REPORT.getValue());
        return "/analysis/analysisreport/week/weekReportEdit";
    }


    @RequestMapping("/saveWeekReport")
    @ResponseBody
    public DataResult saveWeekReport(WeeklyAnalysis weeklyAnalysis){
        if(weeklyAnalysis == null){
            return DataResult.failure("请求参数错误，可能值为空或包含非法字符。");
        }
        weekReportService.save(weeklyAnalysis);
        return DataResult.success();
    }

    /**
     * 删除
     * @param paramMap
     * @return
     */
    @RequestMapping("/deleteReportById")
    @ResponseBody
    public DataResult deleteReportById(@RequestParam Map<String, Object> paramMap) {
        if(paramMap == null || StringUtils.isBlank(MapUtils.getString(paramMap,"reportId"))){
            return DataResult.failure("请求参数错误，可能值为空或包含非法字符！");
        }
        weekReportService.deleteReportById(paramMap);
        return DataResult.success();
    }

    /**
     * 查询周报内容
     * @param paramMap
     * @return
     */
    @RequestMapping("/queryReportInfo")
    @ResponseBody
    public DataResult queryReportInfo( @RequestParam Map<String, Object> paramMap){
        if (StringUtils.isBlank((String) paramMap.get("ascriptionType"))) {
            return DataResult.failure("请求参数错误，可能值为空或包含非法字符。");
        }
       Map<String,Object> result = weekReportService.queryReportInfo(paramMap);
        if (result != null ) {
            return DataResult.success(result);
        } else {
            return DataResult.failure("暂无数据！");
        }
    }

    /**
     * 查询监测数据
     * @param startTime
     * @param endTime
     * @return
     */
    @RequestMapping("/getAirData")
    @ResponseBody
    public DataResult getAirData(String startTime,String endTime){
        if (StringUtils.isBlank(startTime) && StringUtils.isBlank(endTime)) {
            return DataResult.failure("请求参数错误，可能值为空或包含非法字符。");
        }
        Map<String,Object> result = weekReportService.getAirData(startTime,endTime);
        if (result != null ) {
            return DataResult.success(result);
        } else {
            return DataResult.failure("暂无数据！");
        }
    }

    /**
     * 保存当前周的监测数据到附表2
     * @param list
     * @return
     */
    @RequestMapping("/saveWeekReportAttach2")
    @ResponseBody
    public DataResult saveWeekReportAttach2(@RequestBody List<WeeklyAnalysisAttach2> list){
        if(list == null && list.size() <= 0){
            return DataResult.failure("请求参数错误，可能值为空或包含非法字符。");
        }
        weekReportService.saveWeekReportAttach2(list);
        return DataResult.success();
    }

}

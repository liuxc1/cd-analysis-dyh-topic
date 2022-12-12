package ths.project.analysis.analysisreport.web;


import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import ths.project.analysis.analysisreport.entity.TNewsletterAnalysis;
import ths.project.analysis.analysisreport.service.ExpressListService;
import ths.project.analysis.forecast.report.enums.AnalysisStateEnum;
import ths.project.analysis.forecast.report.enums.AscriptionTypeEnum;
import ths.project.common.data.DataResult;
import ths.project.common.uid.SnowflakeIdGenerator;
import ths.project.system.enums.ReportRateEnum;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

/**
 * 快报
 */
@Controller
@RequestMapping("/analysis/express/newsletterAnalysis")
public class ExpressListController {

    @Autowired
    private ExpressListService dayAnalysisReportService;

    @Autowired
    private SnowflakeIdGenerator idGenerator;


    /**
     * 跳转快报页面
     *
     * @param model ascriptionType 归属类型
     *              fileSources 文件来源
     * @return
     */
    @RequestMapping("/expressList")
    public String expressList(Model model) {
        String ascriptionType = AscriptionTypeEnum.EXPRESS_NEWS.getValue();
        model.addAttribute("ascriptionType", ascriptionType);
        model.addAttribute("fileSources", AnalysisStateEnum.UPLOAD.getValue());
        return "analysis/analysisreport/day/expressList";
    }


    /**
     * 新增添加页面跳转
     *
     * @param model    reportId 报告id
     *                 ascriptionType 归属类型
     *                 reportRate 报告频率
     * @param paramMap
     * @return
     */
    @RequestMapping("/expressEdit")
    public String fastAnalysisReportEdit(Model model, @RequestParam Map<String, Object> paramMap) {
        model.addAttribute("reportId", paramMap.get("reportId"));
        model.addAttribute("ascriptionType", AscriptionTypeEnum.EXPRESS_NEWS.getValue());
        model.addAttribute("reportRate", ReportRateEnum.OTHER.getValue());
        return "analysis/analysisreport/day/expressListEdit";
    }


    /**
     * 通过id获取文件数据
     *
     * @param paramMap ascriptionType 归属类型
     *                 reportTime 报告时间
     *                 reportId 报告id
     * @return DataResult
     */
    @RequestMapping("/queryDayGeneralReportByIdAndFileSource")
    @ResponseBody
    public DataResult queryDayGeneralReportByIdAndFileSource(@RequestParam Map<String, Object> paramMap) {
        String ascriptionType = (String) paramMap.get("ascriptionType");
        String reportTime = (String) paramMap.get("reportTime");
        String reportId = (String) paramMap.get("reportId");
        if (StringUtils.isBlank(ascriptionType)) {
            return DataResult.failure("请求参数错误，可能值为空或包含非法字符。");
        }
        Map<String, Object> reportMap = dayAnalysisReportService.queryDayGeneralReportByIdAndFileSource(ascriptionType,reportTime,reportId);
        if (reportMap != null && reportMap.size() > 0) {
            return DataResult.success(reportMap);
        } else {
            return DataResult.failure("暂无数据！");
        }
    }

    /**
     * 根据月份，查询频率为日的时间轴列表（月份 可为空）
     *
     * @param paramMap ascriptionType 归属类型
     *                 startMonth 开始月
     *                 endMonth 结束月
     *                 reportTime 报告时间
     * @return DataResult
     */
    @RequestMapping("/queryForecastListByMonth")
    @ResponseBody
    public DataResult queryForecastListByMonth(@RequestParam Map<String, Object> paramMap) {
        String ascriptionType = "EXPRESS_NEWS";
        String startMonth = (String) paramMap.get("startMonth");
        String endMonth = (String) paramMap.get("endMonth");
        String reportTime = (String) paramMap.get("reportTime");
        if (StringUtils.isBlank(ascriptionType)) {
            return DataResult.failure("请求参数错误，可能值为空或包含非法字符！");
        } else {
            List<Map<String, Object>> resultList = dayAnalysisReportService.queryForecastListByMonth(ascriptionType,startMonth,endMonth,reportTime);
            if (resultList != null && resultList.size() > 0) {
                return DataResult.success(resultList);
            } else {
                return DataResult.failure("暂无数据！");
            }
        }
    }

    /**
     * 保存报告
     *
     * @param tNewsletterAnalysis 快报实体类
     * @return DataResult
     */
    @RequestMapping("/saveForecast")
    @ResponseBody
    public DataResult saveForecast(TNewsletterAnalysis tNewsletterAnalysis) {
        if (tNewsletterAnalysis == null) {
            return DataResult.failure("请求参数错误，可能值为空或包含非法字符！");
        }
        dayAnalysisReportService.saveForecast(tNewsletterAnalysis);
        return DataResult.success(null);
    }

    /**
     * 删除报告
     *
     * @param paramMap reportId 报告id
     * @return DataResult
     */
    @RequestMapping("/deleteReportById")
    @ResponseBody
    public DataResult deleteReportById(@RequestParam Map<String, Object> paramMap) {
        if (paramMap == null) {
            return DataResult.failure("请求参数错误，可能值为空或包含非法字符！");
        }
        String reportId = (String) paramMap.get("reportId");
        return DataResult.success(dayAnalysisReportService.deleteReportById(reportId));
    }


    /**
     * 获取uuid
     *
     * @return DataResult
     */
    @RequestMapping("/getUuid")
    @ResponseBody
    public DataResult getUuid() {
        return DataResult.success(idGenerator.getUniqueId());
    }

    /**
     * 查询超标数据
     *
     * @param paramMap reportTime 报告时间
     * @return DataResult
     */
    @RequestMapping("/queryOverStandard")
    @ResponseBody
    public DataResult queryOverStandard(@RequestParam Map<String, Object> paramMap) throws ParseException {
        String reportTime = (String) paramMap.get("reportTime");
        return DataResult.success(dayAnalysisReportService.queryOverStandard(reportTime));
    }
}

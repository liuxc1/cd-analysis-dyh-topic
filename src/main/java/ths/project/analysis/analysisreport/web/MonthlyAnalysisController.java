package ths.project.analysis.analysisreport.web;


import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import ths.project.analysis.analysisreport.entity.TMonthlyAnalysis;
import ths.project.analysis.analysisreport.service.MonthlyAnalysisService;
import ths.project.analysis.forecast.report.enums.AnalysisStateEnum;
import ths.project.analysis.forecast.report.enums.AscriptionTypeEnum;
import ths.project.common.data.DataResult;
import ths.project.system.enums.ReportRateEnum;

import java.text.ParseException;
import java.util.Map;

/**
 * 月报
 */
@Controller
@RequestMapping("/analysis/analysisreport/monthlyAnalysis")
public class MonthlyAnalysisController {


    @Autowired
    private MonthlyAnalysisService monthlyAnalysisService;

    /**
     * 跳转月报页面
     *
     * @param model ascriptionType 归属类型
     *              fileSources 文件来源
     * @return
     */
    @RequestMapping("/monthlyAnalysisList")
    public String expressList(Model model) {
        String ascriptionType = AscriptionTypeEnum.MONTHLY_ANALYSIS.getValue();
        model.addAttribute("ascriptionType", ascriptionType);
        model.addAttribute("fileSources", AnalysisStateEnum.UPLOAD.getValue());
        return "analysis/analysisreport/monthlyAnalysis/monthlyAnalysisList";
    }

    /**
     * 新增添加页面跳转
     *
     * @param model    reportId 报告id
     *                 reportTime 报告时间
     *                 ascriptionType 归属类型
     *                 reportRate 报告频率
     * @param paramMap
     * @return
     */
    @RequestMapping("/monthlyAnalysisEditOrAdd")
    public String fastAnalysisReportEdit(Model model, @RequestParam Map<String, Object> paramMap) {
        model.addAttribute("reportId", paramMap.get("reportId"));
        model.addAttribute("reportTime", paramMap.get("reportTime"));
        model.addAttribute("ascriptionType", AscriptionTypeEnum.MONTHLY_ANALYSIS.getValue());
        model.addAttribute("reportRate", ReportRateEnum.MONTH.getValue());
        return "analysis/analysisreport/monthlyAnalysis/monthlyAnalysisListEdit";
    }


    /**
     * 查询月数据
     *
     * @param paramMap ascriptionType 归属类型
     *                 reportTime 报告时间
     * @return DataResult
     */
    @RequestMapping("/queryMonthGeneralReportByIdAndFileSource")
    @ResponseBody
    public DataResult queryMonthGeneralReportByIdAndFileSource(@RequestParam Map<String, Object> paramMap) {
        String ascriptionType = (String) paramMap.get("ascriptionType");
        String reportTime = (String) paramMap.get("reportTime");
        if (org.apache.commons.lang.StringUtils.isBlank(ascriptionType) && StringUtils.isBlank(reportTime)) {
            return DataResult.failure("请求参数错误，可能值为空或包含非法字符。");
        }
        Map<String, Object> reportMap = monthlyAnalysisService.queryMonthGeneralReportByIdAndFileSource(ascriptionType, reportTime);
        if (reportMap != null && reportMap.size() > 0) {
            return DataResult.success(reportMap);
        } else {
            return DataResult.failure("暂无数据！");
        }
    }

    /**
     * 保存报告
     *
     * @param tMonthlyAnalysis 月报实体类
     * @return DataResult
     */
    @RequestMapping("/saveForecast")
    @ResponseBody
    public DataResult saveForecast(TMonthlyAnalysis tMonthlyAnalysis) {
        if (tMonthlyAnalysis == null) {
            return DataResult.failure("请求参数错误，可能值为空或包含非法字符！");
        }
        monthlyAnalysisService.saveForecast(tMonthlyAnalysis);
        return DataResult.success(null);
    }


    /**
     * 查询默认值
     *
     * @return
     */
    @RequestMapping("/queryDefaultData")
    @ResponseBody
    public DataResult queryDefaultData(@RequestParam Map<String, Object> paramMap) throws ParseException {
        String startMonth = (String) paramMap.get("startMonth");
        return DataResult.success(monthlyAnalysisService.queryDefaultData(startMonth));
    }
}

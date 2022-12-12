package ths.project.analysis.analysisreport.web;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import ths.project.analysis.analysisreport.entity.WinterExpress;
import ths.project.analysis.analysisreport.service.WinterExpressService;
import ths.project.analysis.forecast.report.enums.AnalysisStateEnum;
import ths.project.analysis.forecast.report.enums.AscriptionTypeEnum;
import ths.project.common.data.DataResult;
import ths.project.system.enums.ReportRateEnum;

import java.util.List;
import java.util.Map;

/**
 * 冬季快报
 */
@Controller
@RequestMapping("/analysis/analysisreport/winterExpress")
public class WinterExpressController {

    @Autowired
    private WinterExpressService winterExpressService;

    /**
     * 跳转冬季快报页面
     *
     * @param model ascriptionType 归属类型
     *              fileSources 文件来源
     * @return
     */
    @RequestMapping("/winterExpressList")
    public String dayAnalysisReportList(Model model) {
        String ascriptionType = AscriptionTypeEnum.WINTER_EXPRESS.getValue();
        model.addAttribute("ascriptionType", ascriptionType);
        model.addAttribute("fileSources", AnalysisStateEnum.UPLOAD.getValue());
        return "/analysis/analysisreport/winterexpress/winterExpressList";
    }

    /**
     * 跳转编辑
     *
     * @param model
     * @param paramMap reportId 报告id
     *                 ascriptionType 归属类型
     *                 reportRate 报告频率
     * @return
     */
    @RequestMapping("/winterExpresEdit")
    public String fastAnalysisReportEdit(Model model, @RequestParam Map<String, Object> paramMap) {
        model.addAttribute("reportId", paramMap.get("reportId"));
        model.addAttribute("ascriptionType", AscriptionTypeEnum.WINTER_EXPRESS.getValue());
        model.addAttribute("reportRate", ReportRateEnum.OTHER.getValue());
        return "/analysis/analysisreport/winterexpress/winterExpresEdit";
    }

    /**
     * 查询报告数据
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
            return DataResult.failure("请求参数错误，可能值为空或包含非法字符！");
        } else {
            WinterExpress result = winterExpressService.queryDayGeneralReportByIdAndFileSource(ascriptionType, reportTime, reportId);
            if (result != null) {
                return DataResult.success(result);
            } else {
                return DataResult.failure("暂无数据！");
            }
        }
    }


    /**
     * 根据报告时间和类型，查询改报告的数据
     *
     * @param paramMap reportTime 报告时间
     *                 ascriptionType 归属类型
     * @return DataResult
     */
    @RequestMapping("/queryForecastListByMonth")
    @ResponseBody
    public DataResult queryForecastListByMonth(@RequestParam Map<String, Object> paramMap) {
        String reportTime = (String) paramMap.get("reportTime");
        String ascriptionType = (String) paramMap.get("ascriptionType");
        if (StringUtils.isBlank(ascriptionType)) {
            return DataResult.failure("请求参数错误，可能值为空或包含非法字符！");
        } else {
            List<Map<String, Object>> resultList = winterExpressService.queryForecastListByMonth(reportTime, ascriptionType);
            if (resultList != null && resultList.size() > 0) {
                return DataResult.success(resultList);
            } else {
                return DataResult.failure("暂无数据！");
            }
        }
    }

    /**
     * 保存
     *
     * @param winterExpress 冬季快报实体类
     * @return DataResult
     */
    @RequestMapping("/saveWinterExpress")
    @ResponseBody
    public DataResult saveForecast(WinterExpress winterExpress) {
        if (winterExpress == null) {
            return DataResult.failure("请求参数错误，可能值为空或包含非法字符！");
        }
        winterExpressService.saveWinterExpress(winterExpress);
        return DataResult.success(null);
    }

    /**
     * 删除
     *
     * @param paramMap reportId 报告id
     * @return DataResult
     */
    @RequestMapping("/deleteReportById")
    @ResponseBody
    public DataResult deleteReportById(@RequestParam Map<String, Object> paramMap) {
        String reportId = (String) paramMap.get("reportId");
        if (StringUtils.isBlank(reportId)) {
            return DataResult.failure("请求参数错误，可能值为空或包含非法字符！");
        }
        winterExpressService.deleteReportById(reportId);
        return DataResult.success();
    }

    /**
     * 查询成都市当天的监测数据
     *
     * @param reportTime
     * @return
     */
    @RequestMapping("/getRegionPoint")
    @ResponseBody
    public DataResult getRegionPoint(String reportTime) {
        if (reportTime == null) {
            return DataResult.failure("请求参数错误，可能值为空或包含非法字符！");
        }
        return DataResult.success(winterExpressService.getRegionPoint(reportTime));
    }
}

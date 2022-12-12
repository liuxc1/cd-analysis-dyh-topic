package ths.project.analysis.forecast.report.web;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import ths.jdp.core.dao.base.Paging;
import ths.jdp.core.web.LoginCache;
import ths.project.analysis.forecast.numericalmodel.entity.WrfDataDay;
import ths.project.analysis.forecast.report.entity.GeneralReport;
import ths.project.analysis.forecast.report.enums.AnalysisStateEnum;
import ths.project.analysis.forecast.report.service.GeneralReportService;
import ths.project.common.data.DataResult;
import ths.project.common.util.DateUtil;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 普通报告-控制器
 *
 * @author liangdl
 */
@Controller
@RequestMapping("/analysis/report/generalReport")
public class GeneralReportController {

    /**
     * 普通报告-服务层
     */
    @Resource
    private GeneralReportService generalReportService;

    /**
     * 根据月份，查询频率为日的时间轴列表
     *
     * @param paramMap 参数
     * @return 频率为日的时间轴列表
     */
    @RequestMapping("/queryDayTimeAxisListByMonth")
    @ResponseBody
    public DataResult queryDayTimeAxisListByMonth(@RequestParam Map<String, Object> paramMap) {
        // 验证
        String ascriptionType = (String) paramMap.get("ascriptionType");
        if (StringUtils.isBlank(ascriptionType)) {
            return DataResult.failure("请求参数错误，可能值为空或包含非法字符！");
        }
        List<Map<String, Object>> resultList = generalReportService.queryDayTimeAxisListByMonth(paramMap);
        if (resultList != null && resultList.size() > 0) {
            return DataResult.success(resultList);
        } else {
            return DataResult.failure("暂无数据！");
        }
    }

    /**
     * 根据报告时间查询频率为日的记录列表
     *
     * @param paramMap 参数
     * @return 频率为日的记录列表
     */
    @RequestMapping("/queryDayRecordListByReportTime")
    @ResponseBody
    public DataResult queryDayRecordListByReportTime(@RequestParam Map<String, Object> paramMap) {
        // 归属类型
        String ascriptionType = (String) paramMap.get("ascriptionType");
        // 报告时间
        String reportTime = (String) paramMap.get("reportTime");
        // 验证
        if (StringUtils.isNotBlank(ascriptionType) && StringUtils.isNotBlank(reportTime)) {
            // 根据报告时间查询频率为日的记录列表
            List<Map<String, Object>> resultList = generalReportService.queryDayRecordListByReportTime(paramMap);
            if (resultList != null && resultList.size() > 0) {
                return DataResult.success(resultList);
            } else {
                return DataResult.failure("暂无数据！");
            }
        } else {
            return DataResult.failure("请求参数错误，可能值为空或包含非法字符！");
        }
    }

    /**
     * 根据月份，查询频率为周的时间轴列表
     *
     * @param paramMap 参数
     * @return 频率为周的时间轴列表
     */
    @RequestMapping("/queryWeekTimeAxisListByMonth")
    @ResponseBody
    public DataResult queryWeekTimeAxisListByMonth(@RequestParam Map<String, Object> paramMap) {
        // 验证
        String ascriptionType = (String) paramMap.get("ascriptionType");
        if (StringUtils.isNotBlank(ascriptionType)) {
            // 时间
            // 文本
            // 是否有数据
            // 是否有重要提示
            String month = generalReportService.queryWeekMaxMonth(paramMap);
            paramMap.put("month", month);

            List<Map<String, Object>> resultList = generalReportService.queryWeekTimeAxisListByMonth(paramMap);
            if (resultList != null && resultList.size() > 0) {
                Map<String, Object> resultMap = new HashMap<>();
                resultMap.put("month", month);
                resultMap.put("resultList", resultList);
                return DataResult.success(resultMap);
            } else {
                return DataResult.failure("暂无数据！");
            }
        } else {
            return DataResult.failure("请求参数错误，可能值为空或包含非法字符！");
        }
    }

    /**
     * 根据报告时间查询频率为周的记录列表
     *
     * @param paramMap 参数
     * @return 频率为日的记录列表
     */
    @RequestMapping("/queryWeekRecordListByReportTime")
    @ResponseBody
    public DataResult queryWeekRecordListByReportTime(@RequestParam Map<String, Object> paramMap) {
        // 归属类型
        String ascriptionType = (String) paramMap.get("ascriptionType");
        // 报告时间
        String reportTime = (String) paramMap.get("reportTime");
        // 验证
        if (StringUtils.isNotBlank(ascriptionType) && StringUtils.isNotBlank(reportTime)) {
            // 根据报告时间查询频率为日的记录列表
            List<Map<String, Object>> resultList = generalReportService.queryWeekRecordListByReportTime(paramMap);
            if (resultList != null && resultList.size() > 0) {
                return DataResult.success(resultList);
            } else {
                return DataResult.failure("暂无数据！");
            }
        } else {
            return DataResult.failure("请求参数错误，可能值为空或包含非法字符！");
        }
    }

    /**
     * 根据年份，查询频率为月的时间轴列表
     *
     * @param paramMap 参数
     * @return 频率为月的时间轴列表
     */
    @RequestMapping("/queryMonthTimeAxisListByYear")
    @ResponseBody
    public DataResult queryMonthTimeAxisListByYear(@RequestParam Map<String, Object> paramMap) {
        // 验证
        String ascriptionType = (String) paramMap.get("ascriptionType");
        if (StringUtils.isNotBlank(ascriptionType)) {
            // 时间
            // 文本
            // 是否有数据
            // 是否有重要提示
            List<Map<String, Object>> resultList = generalReportService.queryMonthTimeAxisListByYear(paramMap);
            if (resultList != null && resultList.size() > 0) {
                return DataResult.success(resultList);
            } else {
                return DataResult.failure("暂无数据！");
            }
        } else {
            return DataResult.failure("请求参数错误，可能值为空或包含非法字符！");
        }
    }

    /**
     * 根据报告时间查询频率为月的记录列表
     *
     * @param paramMap 参数
     * @return 频率为月的记录列表
     */
    @RequestMapping("/queryMonthRecordListByReportTime")
    @ResponseBody
    public DataResult queryMonthRecordListByReportTime(@RequestParam Map<String, Object> paramMap) {
        // 归属类型
        String ascriptionType = (String) paramMap.get("ascriptionType");
        // 报告时间(yyyy-MM)
        String reportTime = (String) paramMap.get("reportTime");
        // 验证
        if (StringUtils.isNotBlank(ascriptionType) && StringUtils.isNotBlank(reportTime)) {
            // 根据报告时间查询频率为日的记录列表 和上一个月大气超标指数
            List<Map<String, Object>> resultList = generalReportService.queryMonthRecordListByReportTime(paramMap);
            if (resultList != null && resultList.size() > 0) {
                return DataResult.success(resultList);
            } else {
                return DataResult.failure("暂无数据！");
            }
        } else {
            return DataResult.failure("请求参数错误，可能值为空或包含非法字符！");
        }
    }

    /**
     * 根据报告ID和文件来源（可选）查询频率为日的报告内容
     *
     * @param paramMap 参数
     * @return 报告内容
     */
    @RequestMapping("/queryDayGeneralReportByIdAndFileSource")
    @ResponseBody
    public DataResult queryDayGeneralReportByIdAndFileSource(@RequestParam Map<String, Object> paramMap) {
        // 报告ID不能为空
        if (StringUtils.isBlank((String) paramMap.get("reportId"))) {
            return DataResult.failure("请求参数错误，可能值为空或包含非法字符。");
        }
        Map<String, Object> reportMap = generalReportService.queryDayGeneralReportByIdAndFileSource(paramMap);
        if (reportMap != null && reportMap.size() > 0) {
            return DataResult.success(reportMap);
        } else {
            return DataResult.failure("暂无数据！");
        }
    }

    /**
     * 查询特定状态记录数
     *
     * @param paramMap 参数
     * @return 特定状态记录数
     */
    @RequestMapping("/queryStateNumber")
    @ResponseBody
    public DataResult queryStateNumber(@RequestParam Map<String, Object> paramMap) {
        // 归属类型不能为空
        if (StringUtils.isBlank((String) paramMap.get("ascriptionType"))) {
            return DataResult.failure("请求参数错误，可能值为空或包含非法字符。");
        }
        // 如果报告时间为空，则使用当前时间作为默认值
        if (StringUtils.isBlank((String) paramMap.get("reportTime"))) {
            paramMap.put("reportTime", DateUtil.history("yyyy-MM-dd", 0));
        }
        // 如果状态为空，则使用上报的状态作为默认值
        if (StringUtils.isBlank((String) paramMap.get("state"))) {
            paramMap.put("state", AnalysisStateEnum.UPLOAD.getValue());
        }
        Map<String, Object> resultMap = generalReportService.queryStateNumber(paramMap);
        return DataResult.success(resultMap);
    }

    /**
     * 根据归属类型查询最大月份
     *
     * @param ascriptionType 归属类型
     * @return 最大月份
     */
    @RequestMapping("/queryMaxMonthByAscriptionType")
    @ResponseBody
    public DataResult queryMaxMonthByAscriptionType(@RequestParam String ascriptionType) {
        // 根据归属类型查询最大月份
        String maxMonth = generalReportService.queryMaxMonthByAscriptionType(ascriptionType);
        return DataResult.success(maxMonth);
    }

    /**
     * 修改报告状态
     *
     * @param paramMap 参数
     * @return 修改的记录条数
     */
    @RequestMapping("/updateReportState")
    @ResponseBody
    public DataResult updateReportState(@RequestParam Map<String, Object> paramMap) {
        // 报告ID不能为空
        if (StringUtils.isBlank((String) paramMap.get("reportId"))) {
            return DataResult.failure("请求参数错误，可能值为空或包含非法字符。");
        }
        // 如果状态为空，则使用上报的状态作为默认值
        if (StringUtils.isBlank((String) paramMap.get("state"))) {
            paramMap.put("state", AnalysisStateEnum.UPLOAD.getValue());
        }
        int result = generalReportService.updateReportState(paramMap);
        String userName = LoginCache.getLoginUser().getUserName();
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("result", result);
        resultMap.put("userName", userName);
        return DataResult.success(resultMap);
    }

    /**
     * 根据报告ID删除报告
     *
     * @param paramMap 参数
     * @return 删除的条数
     */
    @RequestMapping("/deleteReportById")
    @ResponseBody
    public DataResult deleteReportById(@RequestParam Map<String, Object> paramMap) {
        int result = generalReportService.deleteReportById(paramMap);
        return DataResult.success(result);
    }

    /**
     * 查询当月是否有提交记录
     */

    @RequestMapping("/queryStateNumberByTime")
    @ResponseBody
    public DataResult queryStateNumberByTime(@RequestParam Map<String, Object> paramMap) {
        // 归属类型不能为空
        if (StringUtils.isBlank((String) paramMap.get("ascriptionType"))) {
            return DataResult.failure("请求参数错误，可能值为空或包含非法字符。");
        }
        // 如果报告时间为空，则使用当前时间作为默认值
        if (StringUtils.isBlank((String) paramMap.get("reportTime"))) {
            paramMap.put("reportTime", DateUtil.history("yyyy-MM-dd", 0));
        }
        paramMap.put("tempState", AnalysisStateEnum.TEMP.getValue());
        paramMap.put("uploadState", AnalysisStateEnum.UPLOAD.getValue());
        Map<String, Object> resultMap = generalReportService.queryReport(paramMap);
        return DataResult.success(resultMap);
    }

    /**
     * 查询当月是否有提交记录
     */

    @RequestMapping("/queryReportListByAscriptionType")
    @ResponseBody
    public DataResult queryReportListByAscriptionType(@RequestParam Map<String, Object> paramMap, Paging<GeneralReport> pageInfo) {
        // 归属类型不能为空
        if (StringUtils.isBlank((String) paramMap.get("ascriptionType"))) {
            return DataResult.failure("请求参数错误，可能值为空或包含非法字符。");
        }
        Paging<GeneralReport> generalReportPaging = generalReportService.queryReportListByAscriptionType(paramMap, pageInfo);
        return DataResult.success(generalReportPaging);
    }

}

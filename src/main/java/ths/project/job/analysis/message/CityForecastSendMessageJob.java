package ths.project.job.analysis.message;

import org.springframework.stereotype.Component;
import ths.project.analysis.forecast.airforecastcity.service.AirForecastCityService;
import ths.project.analysis.forecast.report.enums.AnalysisStateEnum;
import ths.project.analysis.forecast.report.enums.AscriptionTypeEnum;
import ths.project.analysis.forecast.report.service.GeneralReportService;
import ths.project.common.util.DateUtil;
import ths.project.system.message.enums.SendTypeEnum;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * 城市预报短信推送-任务
 *
 * @author liangdl
 */
@Component
public class CityForecastSendMessageJob {
    /**
     * 普通报告-服务层
     */
    @Resource
    private GeneralReportService generalReportService;
    /**
     * 城市预报-服务层
     */
    @Resource
    private AirForecastCityService airForecastCityService;

    /**
     * 推送3天预报短信
     */
    public void sendMessageBy3Day() {
        sendMessage(SendTypeEnum.CITY_FORECAST_3DAY);
    }

    /**
     * 推送7天预报短信
     */
    public void sendMessageBy7Day() {
        sendMessage(SendTypeEnum.CITY_FORECAST_7DAY);
    }

    /**
     * 推送预报短信
     *
     * @param sendTypeEnum 短信推送类型。和第三方（力鼎）约定，每增加一个，都需要和力鼎对接，第三方根据该类型将短信推送给不同的人员。
     */
    private void sendMessage(SendTypeEnum sendTypeEnum) {
        // 推送的数据时间，默认当天
        // reportTime = OtherUtil.nullToReplace(reportTime,
        // DateUtil.history("yyyy-MM-dd", 0));
        String reportTime = DateUtil.history("yyyy-MM-dd", 0);
        // 1、根据时间查询所有已提交的主任务信息
        List<Map<String, Object>> generalReportList = generalReportService.queryGeneralReportByTimeAndState(
                AscriptionTypeEnum.CITY_FORECAST.getValue(), reportTime, reportTime, AnalysisStateEnum.UPLOAD.getValue());
        if (generalReportList == null || generalReportList.size() == 0) {
            return;
        }
        // 取最后提交的一条数据发送
        Map<String, Object> generalReportMap = generalReportList.get(0);
        String reportId = (String) generalReportMap.get("REPORT_ID");
        airForecastCityService.sendMessageByReportId(sendTypeEnum, reportId);
    }


}
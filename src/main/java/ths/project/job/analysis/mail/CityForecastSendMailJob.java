package ths.project.job.analysis.mail;

import org.springframework.stereotype.Component;
import ths.project.analysis.forecast.airforecastcity.service.AirForecastCityService;
import ths.project.analysis.forecast.report.enums.AnalysisStateEnum;
import ths.project.analysis.forecast.report.enums.AscriptionTypeEnum;
import ths.project.analysis.forecast.report.service.GeneralReportService;
import ths.project.common.util.DateUtil;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * 城市预报推送邮件-任务
 *
 * @author liangdl
 */
@Component
public class CityForecastSendMailJob {
    /**
     * 普通报告-服务层
     */
    @Resource
    private GeneralReportService generalReportService;
    /**
     *
     */
    @Resource
    private AirForecastCityService airForecastCityService;


    /**
     * 发送人，通过外部传递
     */
    private String[] tos;
    /**
     * 主题，默认参考：TEMPLATE_SUBJECT。可通过外部传递
     */
    private String subject;

    /**
     * 推送3天预报邮件
     */
    public void sendMailBy3Day() {
        sendMail(3);
    }

    /**
     * 推送7天预报邮件
     */
    public void sendMailBy7Day() {
        sendMail(7);
    }

    /**
     * 推送预报邮件
     */
    private void sendMail(Integer step) {
        // 推送的数据时间，默认当天
        String reportTime = DateUtil.history("yyyy-MM-dd", 0);
        // 归属类型
        String ascriptionType = AscriptionTypeEnum.CITY_FORECAST.getValue();
        // 1、根据时间查询所有已提交的主任务信息
        List<Map<String, Object>> generalReportList = generalReportService.queryGeneralReportByTimeAndState(ascriptionType, reportTime, reportTime, AnalysisStateEnum.UPLOAD.getValue());
        if (generalReportList == null || generalReportList.size() == 0) {
            return;
        }
        String reportId = (String) generalReportList.get(0).get("REPORT_ID");
        airForecastCityService.sendMailByReportId(subject, step, reportId, tos, null);
    }

    public String[] getTos() {
        return tos;
    }

    public void setTos(String[] tos) {
        this.tos = tos;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }
}

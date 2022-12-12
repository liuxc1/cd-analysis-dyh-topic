package ths.project.job.analysis.oa;

import ths.project.analysis.forecast.report.enums.AnalysisStateEnum;
import ths.project.analysis.forecast.report.enums.AscriptionTypeEnum;
import ths.project.common.util.OtherUtil;
import ths.project.analysis.forecast.report.service.GeneralReportService;
import ths.project.common.util.DateUtil;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * 分区预报推送协同OA-任务
 *
 * @author liangdl
 */
public class PartitionForecastSendOaJob {
    /**
     * 普通报告-服务层
     */
    @Resource
    private GeneralReportService generalReportService;

//    /**
//     * 数据推送OA-服务层
//     */
//    @Resource
//    private SendOaService sendOaService;

    /**
     * 报告默认名称
     */
    private final String REPORT_NAME_DEFAULT = "成都市区县未来 24、48、72 小时空气质量指导预报";

    /**
     * 报告时间，默认当天。可以由外部传入
     */
    // private String reportTime;
    /**
     * 报告时间，默认值参考常量：REPORT_NAME_DEFAULT。可以由外部传入
     */
    private String reportName;
    /**
     * 创建人手机号，可由外部传入
     */
    private String createMobile;
    /**
     * 推送对象
     */
    private String[] userMobiles;

    /**
     * 推送分区预报到协同OA
     */
    public void sendOa() {
        sendOa(AscriptionTypeEnum.PARTITION_FORECAST);
    }

    /**
     * 推送分区预报到协同OA
     */
    private void sendOa(AscriptionTypeEnum ascriptionTypeEnum) {
        // 推送的数据时间，默认当天
        // reportTime = OtherUtil.nullToReplace(reportTime, DateUtil.history("yyyy-MM-dd", 0));
        String reportTime = DateUtil.history("yyyy-MM-dd", 0);
        // 归属类型
        String ascriptionType = ascriptionTypeEnum.getValue();
        // 1、根据时间查询所有已提交的主任务信息
        List<Map<String, Object>> reportList = generalReportService.queryGeneralReportByTimeAndState(ascriptionType, reportTime, reportTime,
                AnalysisStateEnum.UPLOAD.getValue());
        if (reportList == null || reportList.size() == 0) {
            return;
        }
        AnalysisStateEnum[] analysisStateEnums = {AnalysisStateEnum.GENERATE};
        // 2、循环得到每条已提交的主任务信息，得到每条的ID
        for (Map<String, Object> reportMap : reportList) {
            String reportId = (String) reportMap.get("REPORT_ID");
            reportName = OtherUtil.nullToReplace(reportName, REPORT_NAME_DEFAULT);
            // 3、推送OA
//            sendOaService.sendContentToCoordinationOa(reportName, reportName, ascriptionType, reportId, analysisStateEnums, createMobile, userMobiles, null, null);
        }
    }

	/*public String getReportTime() {
		return reportTime;
	}

	public void setReportTime(String reportTime) {
		this.reportTime = reportTime;
	}*/

    public String getCreateMobile() {
        return createMobile;
    }

    public void setCreateMobile(String createMobile) {
        this.createMobile = createMobile;
    }

    public String[] getUserMobiles() {
        return userMobiles;
    }

    public void setUserMobiles(String[] userMobiles) {
        this.userMobiles = userMobiles;
    }
}

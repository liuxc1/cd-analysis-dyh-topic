package ths.project.job.analysis.oa;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import ths.project.analysis.forecast.report.enums.AnalysisStateEnum;
import ths.project.analysis.forecast.report.enums.AscriptionTypeEnum;
import ths.project.common.util.OtherUtil;
import ths.project.analysis.forecast.airforecastmonth.service.MonthTrendService;
import ths.project.analysis.forecast.report.service.GeneralReportService;
import ths.project.common.util.DateUtil;

/**
 * 月趋势预报推送协同OA-任务
 *
 * @author liangdl
 */
public class MonthForecastSendOaJob {
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
     * 月趋势预报-服务层
     */
    @Resource
    private MonthTrendService monthTrendService;

    /**
     * 模板-月趋势预报
     */
    private final String TEMPLATE_MONTH = "（成都市环保局）成都市区空气质量月趋势预报\n#reportTip#\n#forecastAqi#。";

    /**
     * 预报AQI模板
     */
    private final String TEMPLATE_FORECAST_AQI = "#reportTimeZh#，气象扩散条件为#weatherLevel#，预计AQI为#aqi#，空气质量等级为#aqiLevel##primPollute#；\n";

    /**
     * 报告时间，默认当天。可以由外部传入
     */
    // private String reportTime;
    /**
     * 创建人手机号，可由外部传入
     */
    private String createMobile;
    /**
     * 推送对象，可由外部传入
     */
    private String[] userMobiles;

    /**
     * 推送月趋势预报到协同OA
     */
    public void sendOa() {
        sendOa(AscriptionTypeEnum.MONTH_FORECAST, -1, TEMPLATE_MONTH);
    }

    /**
     * 推送月趋势预报到协同OA
     */
    private void sendOa(AscriptionTypeEnum ascriptionTypeEnum, Integer step, String template) {
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
        AnalysisStateEnum[] analysisStateEnums = new AnalysisStateEnum[1];
        analysisStateEnums[0] = AnalysisStateEnum.UPLOAD;
        // 2、循环得到每条已提交的主任务信息，得到每条的ID
        for (Map<String, Object> reportMap : reportList) {
            String reportId = (String) reportMap.get("REPORT_ID");
            String reportName = (String) reportMap.get("REPORT_NAME");
            // 3、根据每条的ID查询预报详情数据
            List<Map<String, Object>> aqiList = monthTrendService.queryMonthForecastByReportId(reportId);
            if (aqiList == null || aqiList.size() == 0) {
                continue;
            }
            // 4、拼接发送内容
            String content = getContent(reportMap, aqiList, step, template);
            // 5、推送OA
//            sendOaService.sendContentToCoordinationOa(reportName, content, ascriptionType, reportId, analysisStateEnums, createMobile, userMobiles, null, null);
        }
    }

    /**
     * 获取短信内容
     *
     * @param reportMap 报告信息
     * @param aqiList   AQI预报信息
     * @param step      步长
     * @return
     */
    private String getContent(Map<String, Object> reportMap, List<Map<String, Object>> aqiList, Integer step, String template) {
        // 重要提示
        String reportTip = OtherUtil.nullToReplace((String) reportMap.get("REPORT_TIP"), "");
        // 预报AQI
        String forecastAqi = "";
        if (aqiList != null && aqiList.size() > 0) {
            StringBuilder forecastAqiBuilder = new StringBuilder();
            for (int i = 0, size = aqiList.size(); i < size; i++) {
                if (step > 0 && i >= step) {
                    break;
                }
                Map<String, Object> aqiMap = aqiList.get(i);
                // 时间
                String reportTimeZh = DateUtil.format(DateUtil.parse((String) aqiMap.get("RESULT_TIME"), "yyyy-MM-dd"), "MM月dd日");
                // 扩散条件
                String weatherLevel = OtherUtil.nullToReplace((String) reportMap.get("WEATHER_LEVEL"), "--");
                // AQI范围
                String aqi = OtherUtil.nullToReplace((String) reportMap.get("AQI"), "--");
                // AQI等级
                String aqiLevel = OtherUtil.nullToReplace((String) reportMap.get("AQI_LEVEL"), "--");
                // 首要污染物
                String primPollute = OtherUtil.nullToReplace((String) reportMap.get("PRIM_POLLUTE"), "");
                if (!"".equals(primPollute)) {
                    primPollute = "，首要污染物为" + primPollute;
                }
                // 替换预报AQI模板，并将替换的结果追加到Builder
                forecastAqiBuilder.append(TEMPLATE_FORECAST_AQI.replaceAll("#reportTimeZh#", reportTimeZh)
                        .replaceAll("#weatherLevel#", weatherLevel).replaceAll("#aqi#", aqi)
                        .replaceAll("#aqiLevel#", aqiLevel).replaceAll("#primPollute#", primPollute));
            }
            // 将最后一个分号替换为逗号
            forecastAqi = forecastAqiBuilder.delete(forecastAqiBuilder.lastIndexOf("；"), forecastAqiBuilder.length())
                    .append("。").toString();
        }
        // 替换模板，获得发送文本内容
        return template.replaceAll("#reportTip#", reportTip).replaceAll("#forecastAqi#", forecastAqi);
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

//package ths.air.job.mail;
//
//import java.util.List;
//import java.util.Map;
//
//import javax.annotation.Resource;
//
//import ths.air.enums.AnalysisStateEnum;
//import ths.air.enums.AscriptionTypeEnum;
//import ths.air.util.DateUtil;
//import ths.air.util.OtherUtil;
//import ths.air.web.analysis.forecastflow.forecastflowcity.service.ForecastFlowCityService;
//import ths.air.web.analysis.report.service.GeneralReportService;
//import ths.air.web.common.entity.MailFile;
//import ths.air.web.common.service.FileService;
//import ths.air.web.common.service.SendMailService;
//import ths.jdp.core.context.PropertyConfigure;
//
///**
// * 分区预报发送邮件-任务
// * @author liangdl
// *
// */
//public class PartitionForecastSendMailJob {
//	/**
//	 * 普通报告-服务层
//	 */
//	@Resource
//	private GeneralReportService generalReportService;
//	/**
//	 * 城市预报-服务层
//	 */
//	@Resource
//	private ForecastFlowCityService forecastFlowCityService;
//	/**
//	 * 通用文件-服务层
//	 */
//	@Resource
//	private FileService fileService;
//	/**
//	 * 推送邮件-服务层
//	 */
//	@Resource
//	private SendMailService sendMailService;
//	/**
//	 * 主题模板
//	 */
//	private final String TEMPLATE_SUBJECT = "成都市区县未来 24、48、72 小时空气质量指导预报";
//	/**
//	 * 报告时间，默认当天。可以由外部传入
//	 */
//	// private String reportTime;
//	/**
//	 * 发送人，通过外部传递
//	 */
//	private String[] tos;
//	/**
//	 * 主题，默认参考：TEMPLATE_SUBJECT。可通过外部传递
//	 */
//	private String subject;
//
//	/**
//	 * 推送预报邮件
//	 */
//	public void sendMail() {
//		sendMail(AscriptionTypeEnum.PARTITION_FORECAST);
//	}
//
//	/**
//	 * 推送分区预报邮件
//	 */
//	private void sendMail(AscriptionTypeEnum ascriptionTypeEnum) {
//		// 推送的数据时间，默认当天
//		// reportTime = OtherUtil.nullToReplace(reportTime, DateUtil.history("yyyy-MM-dd", 0));
//		String reportTime = DateUtil.history("yyyy-MM-dd", 0);
//		// 归属类型
//		String ascriptionType = ascriptionTypeEnum.getValue();
//		// 1、根据时间查询所有已提交的主任务信息
//		List<Map<String, Object>> reportList = generalReportService.queryGeneralReportByTimeAndState(ascriptionType, reportTime, reportTime,
//				AnalysisStateEnum.UPLOAD.getValue());
//		if (reportList == null || reportList.size() == 0) {
//			return;
//		}
//		// 2、循环得到每条已提交的主任务信息，得到每条的ID
//		String from = (String) PropertyConfigure.getProperty("mail.username");
//		for (Map<String, Object> reportMap : reportList) {
//			String reportId = (String) reportMap.get("REPORT_ID");
//			// 3、获取需要邮件发送的文件
//			MailFile[] mailFiles = getMailFiles(reportId);
//			subject = OtherUtil.nullToReplace(subject, TEMPLATE_SUBJECT);
//			// 4、发送邮件
//			sendMailService.sendAttachmentMail(tos, from, subject, subject, false, mailFiles, ascriptionType, reportId, null);
//		}
//	}
//
//	/**
//	 * 获取需要邮件发送的文件
//	 * @param reportId 报告ID
//	 * @return 需要邮件发送的文件集合
//	 */
//	private MailFile[] getMailFiles(String reportId) {
//		List<Map<String, Object>> fileList = fileService.queryFileListByAscriptionId(reportId, AnalysisStateEnum.GENERATE);
//		MailFile[] mailFiles = null;
//		if (fileList != null && fileList.size() > 0) {
//			int size = fileList.size();
//			mailFiles = new MailFile[size];
//			for (int i = 0; i < size; i++) {
//				Map<String, Object> fileMap = fileList.get(i);
//				String fileFullName = (String) fileMap.get("FILE_FULL_NAME");
//				String fileFullPath = fileService.getFileFullPath(fileMap);
//				mailFiles[i] = new MailFile(fileFullName, fileFullPath);
//			}
//		}
//		return mailFiles;
//	}
//
//	/*public String getReportTime() {
//		return reportTime;
//	}
//
//	public void setReportTime(String reportTime) {
//		this.reportTime = reportTime;
//	}*/
//
//	public String[] getTos() {
//		return tos;
//	}
//
//	public void setTos(String[] tos) {
//		this.tos = tos;
//	}
//
//	public String getSubject() {
//		return subject;
//	}
//
//	public void setSubject(String subject) {
//		this.subject = subject;
//	}
//}

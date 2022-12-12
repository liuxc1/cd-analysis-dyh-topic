package ths.project.analysis.forecast.report.enums;

/**
 * 发送短信类型枚举。和第三方（力鼎）约定，每增加一个，都需要和力鼎对接，第三方根据该类型将短信推送给不同的人员。
 * @author liangdl
 *
 */
public enum SendMessageTypeEnum {
	/** 任务通知 **/
	TASK_TO_INFORM,
	/** 预警快报 **/
	WARN_BULLETIN,
	/** 3天城市预报 **/
	CITY_FORECAST_3DAY,
	/** 7天城市预报 **/
	CITY_FORECAST_7DAY,
	/** 快报分析报告 **/
	FAST_ANALYSIS,
	/** 超标报警，系统自动发送 **/
	WARN_AUTO,
	/** 预留1 **/
	RESERVE_1,
	/** 预留2 **/
	RESERVE_2,
	/** 预留3 **/
	RESERVE_3,
	TEST
	
}

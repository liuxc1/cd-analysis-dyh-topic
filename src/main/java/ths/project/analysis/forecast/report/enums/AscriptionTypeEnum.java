package ths.project.analysis.forecast.report.enums;

/**
 * 归属类型枚举
 * @author liangdl
 *
 */
public enum AscriptionTypeEnum {
	/**
	 * 重点工作
	 */
	PRIORITY_WORK("PRIORITY_WORK"),
	/**
	 * 源解析报告
	 */
	SOURCE_RESOLVE_REPORT("SOURCE_RESOLVE_REPORT"),
	/**
	 * 周报分析报告
	 */
	WEEK_FORECAST_FILL("WEEK_FORECAST_FILL"),
	/**
	 * 月报分析报告
	 */
	MONTH_FORECAST_FILL("MONTH_FORECAST_FILL"),
	/**
	/**
	 * 简报（周报）
	 */
	WEEK_BRIEFING("WEEK_BRIEFING"),
	/**
	 * 分区预报
	 */
	PARTITION_FORECAST("PARTITION_FORECAST"),
	/**
	 * 年度分析报告
	 */
	YEAR_ANALYSIS_REPORT("YEAR_ANALYSIS_REPORT"),
	/**
	 * 季度分析报告
	 */
	QUARTERLY_ANALYSIS("QUARTERLY_ANALYSIS"),
	/**
	 * 专题分析报告
	 */
	SPECIAL_ANALYSIS_REPORT("SPECIAL_ANALYSIS_REPORT"),
	/**
	 * 快速分析报告
	 */
	FAST_ANALYSIS_REPORT("FAST_ANALYSIS_REPORT"),
	/**
	 * 快报
	 */
	EXPRESS_NEWS("EXPRESS_NEWS"),
	/**
	 * 冬季快报
	 */
	WINTER_EXPRESS("WINTER_EXPRESS"),
	/**
	 * 日报分析报告
	 */
	DAY_ANALYSIS_REPORT("DAY_ANALYSIS_REPORT"),
	/**
	 * 周报报告
	 */
	WEEK_REPORT("WEEK_REPORT"),
	/**
	 * 月趋势预报
	 */
	MONTH_FORECAST("MONTH_FORECAST"),
	/**
	 * 月份分析
	 */
	MONTHLY_ANALYSIS("MONTHLY_ANALYSIS"),
	/**
	 * 预警快报
	 */
	WARN_BULLETIN("WARN_BULLETIN"),
	/**
	 * 城市预报
	 */
	CITY_FORECAST("CITY_FORECAST"),
	/**
	 * 专题预报
	 */
	SPECIAL_FORECAST("SPECIAL_FORECAST"),
	/**
	 * 中长期预报
	 */
	LONG_TERM_FORECAST("LONG_TERM_FORECAST"),
	/**
	 * 重污染会商
	 */
	WARN_CONSULT("WARN_CONSULT"),
	/**
	 * 日常会商
	 */
	DAILY_CONSULT("DAILY_CONSULT"),
	/**
	 * 会商材料
	 */
	CONSULT_MATERIAL("CONSULT_MATERIAL"),
	/**
	 * 重污染天气应急应急专报
	 */
	HEAVY_POLLUTION("HEAVY_POLLUTION"),
	/**
	 * 垂直观测
	 */
	VERTICAL_OBSERVE("VERTICAL_OBSERVE"),
	/**
	 * 分析平台-污染特征分析
	 */
	ANS_FEATURE("ANS_FEATURE"),
	
	/**
	 * 风向频率玫瑰图
	 * **/
	ANS_ROSE_DIAGRAM("ANS_ROSE_DIAGRAM"),
	/**
	 * 重污染天气过程评估
	 */
	POLLUTION_EVALUATION("POLLUTION_EVALUATION"),
	/**
	 * 源解析
	 */
	SOURCE_ANALYSIS("SOURCE_ANALYSIS"),
	
	/**
	 * 区县源解析
	 */
	DISTINCTSOURCE_ANALYSIS("DISTINCTSOURCE_ANALYSIS"),
	/**
	 * 气十条成效评估
	 */
	EFFECT_EVALUATION("EFFECT_EVALUATION"),
	
	/**
	 *  本地图片上传
	 */
	UPLOAD_IMAGE("UPLOAD_IMAGE"),
	
	/**
	 * 走航观测
	 */
	ZH_OBSERVATION("ZH_OBSERVATION"),
	
	/**
	 *  专家解读
	 */
	EXPERTS_READ("EXPERTS_READ"),
	/**
	 *  逐小时预报
	 */
	FORECAST_HOUR("FORECAST_HOUR"),

	/**
	 * 会商
	 */

	MEETING("MEETING");

	private AscriptionTypeEnum(String value) {
		this.value = value;
	}
	
	

	/**
	 * 会商归属取值
	 */
	private String value;
	
	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}
}

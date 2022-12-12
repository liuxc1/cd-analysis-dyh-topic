package ths.project.system.enums;

/**
 * 报告频率枚举
 * @author liangdl
 *
 */
public enum ReportRateEnum {
	/**
	 * 年
	 */
	YEAR("YEAR"),
	/**
	 * 季
	 */
	SEASON("SEASON"),
	/**
	 * 月
	 */
	MONTH("MONTH"),
	/**
	 * 周
	 */
	WEEK("WEEK"),
	/**
	 * 日
	 */
	DAY("DAY"),
	/**
	 * 其他
	 */
	OTHER("OTHER");
	
	private ReportRateEnum(String value) {
		this.value = value;
	}

	/**
	 * 
	 */
	private String value;

	public String getValue() {
		return value;
	}
}

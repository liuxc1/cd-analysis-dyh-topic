package ths.project.analysis.forecast.report.enums;

/**
 * 分析状态枚举
 * @author liangdl
 *
 */
public enum AnalysisStateEnum {
	/**
	 * 上传
	 */
	UPLOAD("UPLOAD"), 
	/**
	 * 暂存
	 */
	TEMP("TEMP"),
	/**
	 * 生成
	 */
	GENERATE("GENERATE"),
	/**
	 * 生成的zip
	 */
	COMPRESSION("COMPRESSION");
	
	private AnalysisStateEnum(String value) {
		this.value = value;
	}

	/**
	 * 值
	 */
	private String value;

	public String getValue() {
		return value;
	}
	
}

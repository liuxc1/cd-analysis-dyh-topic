package ths.project.common.enums;

/**
 * 树节点类型
 *
 * @author L
 *
 */
public enum TaskTypeEnum {

	/**
	 * 环境要素
	 */
	ENVIRONMENTAL_FACTORS("EF"),
	/**
	 * 污染源类型
	 */
	POLLUTE_TYPE("PT"),
	/**
	 * 重污染应急
	 */
	HEAVY_POLLUTION("HP"),
	/**
	 * 事件分类
	 */
	EVENT_CLASS("EC");

	private final String value;

	private TaskTypeEnum(String value) {
		this.value = value;
	}

	public String getValue() {
		return value;
	}
}

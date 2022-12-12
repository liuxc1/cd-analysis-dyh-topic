package ths.project.common.enums;

/**
 * 标志位类型
 *
 * @author L
 *
 */
public enum FlagEnum {

	/**
	 * true
	 */
	TRUE(1),
	/**
	 * false
	 */
	FALSE(0);

	private final Integer value;

	private FlagEnum(Integer value) {
		this.value = value;
	}

	public Integer getValue() {
		return value;
	}
}

package ths.project.system.commdata.enums;

public enum UpdateEntityEnum {
	/**
	 * 污染源信息表
	 */
	T_CS_PS("T_CS_PS"),
	/**
	 * 
	 */
	T_PS_AREA_SOURCE("T_PS_AREA_SOURCE"),
	/**
	 * 
	 */
	T_PS_MOBILE_SOURCE("T_PS_MOBILE_SOURCE"),
	/**
	 * 子任务-相关污染源信息
	 */
	T_DD_TASK_PS("T_DD_TASK_PS"),

	/**
	 * 工业企业、砂石场、商砼、建材厂
	 */
	T_PS_INDU_ENTER("T_PS_INDU_ENTER"),
	/**
	 * 工地表单
	 */
	T_PS_CONSTRUCTION_SITE("T_PS_CONSTRUCTION_SITE"),
	/**
	 * 餐饮行业表单
	 */
	T_PS_FOOD("T_PS_FOOD"),
	/**
	 * 汽修表单
	 */
	T_PS_MECHANIC("T_PS_MECHANIC"),
	/**
	 * 面源及移动源
	 */
	T_PS_AREA_MOVE("T_PS_AREA_MOVE"),
	/**
	 * 其它污染源
	 */
	T_PS_COMM_EXT("T_PS_COMM_EXT");

	private String value;

	private UpdateEntityEnum(String value) {
		this.value = value;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

}

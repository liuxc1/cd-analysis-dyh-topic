package ths.project.system.commdata.vo;

import ths.project.system.commdata.entity.UpdateEntity;

public class UpdateEntityVo extends UpdateEntity {
	/**
	 * 实体对应的字段信息
	 */
	private String updateField;

	public String getUpdateField() {
		return updateField;
	}

	public void setUpdateField(String updateField) {
		this.updateField = updateField;
	}

	@Override
	public String toString() {
		return "UpdateEntityVo [updateField=" + updateField + "]" + super.toString();
	}

}

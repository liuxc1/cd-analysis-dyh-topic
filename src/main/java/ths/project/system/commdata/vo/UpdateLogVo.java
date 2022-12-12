package ths.project.system.commdata.vo;

import ths.project.system.commdata.entity.UpdateLog;

public class UpdateLogVo extends UpdateLog {
	private Integer updateNum;

	public Integer getUpdateNum() {
		return updateNum;
	}

	public void setUpdateNum(Integer updateNum) {
		this.updateNum = updateNum;
	}

	@Override
	public String toString() {
		return "UpdateLogVo [updateNum=" + updateNum + "]" + super.toString();
	}

}

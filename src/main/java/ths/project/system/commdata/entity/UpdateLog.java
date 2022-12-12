package ths.project.system.commdata.entity;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;

import ths.project.common.constant.SchemaConstants;

/**
 * 公用-修改记录日志表
 * 
 * @author zl
 *
 */
@TableName(value = "T_COMM_DATA_UPDATE_LOG", schema = SchemaConstants.DEFAULT)
public class UpdateLog {
	/**
	 * 日志ID
	 */
	private String logId;
	/**
	 * 归属ID
	 */
	private String ascriptionId;
	/**
	 * 归属类型
	 */
	private String ascriptionType;
	/**
	 * 修改字段名称
	 */
	private String updateField;
	/**
	 * 修改字段中文名称
	 */
	private String updateFieldName;
	/**
	 * 修改字段所属表
	 */
	private String updateTable;
	/**
	 * 修改前的值
	 */
	private String updateBefVal;
	/**
	 * 修改后的值
	 */
	private String updateAefVal;
	/**
	 * 备注
	 */
	private String remake;
	/**
	 * 修改人
	 */
	private String updateUser;
	/**
	 * 修改时间
	 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm")
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm")
	private Date updateTime;

	public String getLogId() {
		return logId;
	}

	public void setLogId(String logId) {
		this.logId = logId;
	}

	public String getAscriptionId() {
		return ascriptionId;
	}

	public void setAscriptionId(String ascriptionId) {
		this.ascriptionId = ascriptionId;
	}

	public String getAscriptionType() {
		return ascriptionType;
	}

	public void setAscriptionType(String ascriptionType) {
		this.ascriptionType = ascriptionType;
	}

	public String getUpdateField() {
		return updateField;
	}

	public void setUpdateField(String updateField) {
		this.updateField = updateField;
	}

	public String getUpdateFieldName() {
		return updateFieldName;
	}

	public void setUpdateFieldName(String updateFieldName) {
		this.updateFieldName = updateFieldName;
	}

	public String getUpdateTable() {
		return updateTable;
	}

	public void setUpdateTable(String updateTable) {
		this.updateTable = updateTable;
	}

	public String getUpdateBefVal() {
		return updateBefVal;
	}

	public void setUpdateBefVal(String updateBefVal) {
		this.updateBefVal = updateBefVal;
	}

	public String getUpdateAefVal() {
		return updateAefVal;
	}

	public void setUpdateAefVal(String updateAefVal) {
		this.updateAefVal = updateAefVal;
	}

	public String getRemake() {
		return remake;
	}

	public void setRemake(String remake) {
		this.remake = remake;
	}

	public String getUpdateUser() {
		return updateUser;
	}

	public void setUpdateUser(String updateUser) {
		this.updateUser = updateUser;
	}

	public Date getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}

	/**
	 * 设置部分值
	 * 
	 * @param userName
	 */
	public void resolveUpdate(String userName) {
		Date date = new Date();
		this.setUpdateTime(date);
		this.setUpdateUser(userName);
	}

	@Override
	public String toString() {
		return "UpdateLog [logId=" + logId + ", ascriptionId=" + ascriptionId + ", ascriptionType=" + ascriptionType
				+ ", updateField=" + updateField + ", updateFieldName=" + updateFieldName + ", updateTable="
				+ updateTable + ", updateBefVal=" + updateBefVal + ", updateAefVal=" + updateAefVal + ", remake="
				+ remake + ", updateUser=" + updateUser + ", updateTime=" + updateTime + "]";
	}

}

package ths.project.system.commdata.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import ths.project.common.constant.SchemaConstants;
import ths.project.common.entity.BaseEntity;

/**
 * 公共-数据修改-实体配置表
 * @author zl
 *
 */
@TableName(value = "T_COMM_DATA_UPDATE_ENTITY", schema = SchemaConstants.DEFAULT)
public class UpdateEntity extends BaseEntity {
	/**
	 * 实体id
	 */
	@TableId
	private String entityId;
	/**
	 * 实体编码
	 */
	private String entityCode;
	/**
	 * 实体名称
	 */
	private String entityName;
	/**
	 * 实体描述
	 */
	private String entityDesc;

	public String getEntityId() {
		return entityId;
	}

	public void setEntityId(String entityId) {
		this.entityId = entityId;
	}

	public String getEntityCode() {
		return entityCode;
	}

	public void setEntityCode(String entityCode) {
		this.entityCode = entityCode;
	}

	public String getEntityName() {
		return entityName;
	}

	public void setEntityName(String entityName) {
		this.entityName = entityName;
	}

	public String getEntityDesc() {
		return entityDesc;
	}

	public void setEntityDesc(String entityDesc) {
		this.entityDesc = entityDesc;
	}

	@Override
	public String toString() {
		return "UpdateEntity [entityId=" + entityId + ", entityCode=" + entityCode + ", entityName=" + entityName
				+ ", entityDesc=" + entityDesc + "]";
	}

}

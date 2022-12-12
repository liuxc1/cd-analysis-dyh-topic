package ths.project.system.commdata.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import ths.project.common.constant.SchemaConstants;
import ths.project.common.entity.BaseEntity;

/**
 * 公共-数据修改-实体字段表
 * 
 * @author zl
 *
 */
@TableName(value = "T_COMM_DATA_UPDATE_FIELD", schema = SchemaConstants.DEFAULT)
public class UpdateField extends BaseEntity {
	/**
	 * 字段id
	 */
	private String fieldId;
	/**
	 * 字段编码
	 */
	private String fieldCode;
	/**
	 * 字段名称
	 */
	private String fieldName;
	/**
	 * 字段描述
	 */
	private String fieldDesc;
	/**
	 * 实体id
	 */
	private String entityId;
	/**
	 * 排序
	 */
	private Integer sort;

	public String getFieldId() {
		return fieldId;
	}

	public void setFieldId(String fieldId) {
		this.fieldId = fieldId;
	}

	public String getFieldCode() {
		return fieldCode;
	}

	public void setFieldCode(String fieldCode) {
		this.fieldCode = fieldCode;
	}

	public String getFieldName() {
		return fieldName;
	}

	public void setFieldName(String fieldName) {
		this.fieldName = fieldName;
	}

	public String getFieldDesc() {
		return fieldDesc;
	}

	public void setFieldDesc(String fieldDesc) {
		this.fieldDesc = fieldDesc;
	}

	public String getEntityId() {
		return entityId;
	}

	public void setEntityId(String entityId) {
		this.entityId = entityId;
	}

	public Integer getSort() {
		return sort;
	}

	public void setSort(Integer sort) {
		this.sort = sort;
	}

	@Override
	public String toString() {
		return "UpdateField [fieldId=" + fieldId + ", fieldCode=" + fieldCode + ", fieldName=" + fieldName
				+ ", fieldDesc=" + fieldDesc + ", entityId=" + entityId + ", sort=" + sort + "]";
	}
}

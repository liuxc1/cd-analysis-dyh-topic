package ths.project.system.user.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import ths.project.common.constant.SchemaConstants;
import ths.project.common.entity.BaseEntity;

@TableName(value = "T_COMM_UNIT_INFO", schema = SchemaConstants.DEFAULT)
public class UnitInfo extends BaseEntity {
    @TableId
    private String unitId;
    private String unitType;
    private String unitName;
    private String parentUnitId;
    private Integer unitLevel;
    private String unitIdPath;
    private String unitNamePath;

    public String getUnitId() {
        return unitId;
    }

    public void setUnitId(String unitId) {
        this.unitId = unitId;
    }

    public String getUnitType() {
        return unitType;
    }

    public void setUnitType(String unitType) {
        this.unitType = unitType;
    }

    public String getUnitName() {
        return unitName;
    }

    public void setUnitName(String unitName) {
        this.unitName = unitName;
    }

    public String getParentUnitId() {
        return parentUnitId;
    }

    public void setParentUnitId(String parentUnitId) {
        this.parentUnitId = parentUnitId;
    }

    public Integer getUnitLevel() {
        return unitLevel;
    }

    public void setUnitLevel(Integer unitLevel) {
        this.unitLevel = unitLevel;
    }

    public String getUnitIdPath() {
        return unitIdPath;
    }

    public void setUnitIdPath(String unitIdPath) {
        this.unitIdPath = unitIdPath;
    }

    public String getUnitNamePath() {
        return unitNamePath;
    }

    public void setUnitNamePath(String unitNamePath) {
        this.unitNamePath = unitNamePath;
    }
}

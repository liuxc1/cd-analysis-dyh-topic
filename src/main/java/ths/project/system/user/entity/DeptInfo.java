package ths.project.system.user.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import ths.project.common.constant.SchemaConstants;

import java.io.Serializable;

/**
 * 部门信息
 */
@TableName(value = "T_COMM_DEPT_INFO", schema = SchemaConstants.DEFAULT)
public class DeptInfo implements Serializable {

    private static final long serialVersionUID = -7923174876992048515L;
    @TableId
    private String deptId;
    private String deptName;
    private String deptCode;
    private String deptType;
    private String parent;
    private String codeRegion;
    private String ext1;
    private String ext2;
    private String ext3;
    private String ext4;
    private Integer sort;
    private Integer treeGrade;
    private String deptPath;
    @TableField(exist = false)
    private String deptPathName;

    public String getDeptId() {
        return deptId;
    }

    public void setDeptId(String deptId) {
        this.deptId = deptId;
    }

    public String getDeptName() {
        return deptName;
    }

    public void setDeptName(String deptName) {
        this.deptName = deptName;
    }

    public String getDeptCode() {
        return deptCode;
    }

    public void setDeptCode(String deptCode) {
        this.deptCode = deptCode;
    }

    public String getDeptType() {
        return deptType;
    }

    public void setDeptType(String deptType) {
        this.deptType = deptType;
    }

    public String getParent() {
        return parent;
    }

    public void setParent(String parent) {
        this.parent = parent;
    }

    public String getCodeRegion() {
        return codeRegion;
    }

    public void setCodeRegion(String codeRegion) {
        this.codeRegion = codeRegion;
    }

    public String getExt1() {
        return ext1;
    }

    public void setExt1(String ext1) {
        this.ext1 = ext1;
    }

    public String getExt2() {
        return ext2;
    }

    public void setExt2(String ext2) {
        this.ext2 = ext2;
    }

    public String getExt3() {
        return ext3;
    }

    public void setExt3(String ext3) {
        this.ext3 = ext3;
    }

    public String getExt4() {
        return ext4;
    }

    public void setExt4(String ext4) {
        this.ext4 = ext4;
    }

    public Integer getSort() {
        return sort;
    }

    public void setSort(Integer sort) {
        this.sort = sort;
    }

    public Integer getTreeGrade() {
        return treeGrade;
    }

    public void setTreeGrade(Integer treeGrade) {
        this.treeGrade = treeGrade;
    }

    public String getDeptPath() {
        return deptPath;
    }

    public void setDeptPath(String deptPath) {
        this.deptPath = deptPath;
    }

    public String getDeptPathName() {
        return deptPathName;
    }

    public void setDeptPathName(String deptPathName) {
        this.deptPathName = deptPathName;
    }
}

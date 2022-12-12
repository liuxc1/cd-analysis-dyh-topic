package ths.project.system.dictionary.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import ths.project.common.constant.SchemaConstants;

import java.util.Date;

/**
 * 字典条码类
 *
 * @author lym
 */
@TableName(value = "JDP_EFORM_DICTIONARYTREE", schema = SchemaConstants.DEFAULT)
public class DictionaryTree {
    @TableId
    private String treeId;
    private String treeCode;
    private String treeName;
    private Integer treeSort;
    private String treeDescription;
    private String treePid;
    private String ext1;
    private String ext2;
    private String ext3;
    private String ext4;
    private Date createDate;
    private String createUser;
    private Date modifyDate;
    private String modifyUser;
    private Integer treeFlag;
    private Integer isparent;
    private String jdpAppCode;

    public String getTreeId() {
        return treeId;
    }

    public void setTreeId(String treeId) {
        this.treeId = treeId;
    }

    public String getTreeCode() {
        return treeCode;
    }

    public void setTreeCode(String treeCode) {
        this.treeCode = treeCode;
    }

    public String getTreeName() {
        return treeName;
    }

    public void setTreeName(String treeName) {
        this.treeName = treeName;
    }

    public Integer getTreeSort() {
        return treeSort;
    }

    public void setTreeSort(Integer treeSort) {
        this.treeSort = treeSort;
    }

    public String getTreeDescription() {
        return treeDescription;
    }

    public void setTreeDescription(String treeDescription) {
        this.treeDescription = treeDescription;
    }

    public String getTreePid() {
        return treePid;
    }

    public void setTreePid(String treePid) {
        this.treePid = treePid;
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

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public String getCreateUser() {
        return createUser;
    }

    public void setCreateUser(String createUser) {
        this.createUser = createUser;
    }

    public Date getModifyDate() {
        return modifyDate;
    }

    public void setModifyDate(Date modifyDate) {
        this.modifyDate = modifyDate;
    }

    public String getModifyUser() {
        return modifyUser;
    }

    public void setModifyUser(String modifyUser) {
        this.modifyUser = modifyUser;
    }

    public Integer getTreeFlag() {
        return treeFlag;
    }

    public void setTreeFlag(Integer treeFlag) {
        this.treeFlag = treeFlag;
    }

    public Integer getIsparent() {
        return isparent;
    }

    public void setIsparent(Integer isparent) {
        this.isparent = isparent;
    }

    public String getJdpAppCode() {
        return jdpAppCode;
    }

    public void setJdpAppCode(String jdpAppCode) {
        this.jdpAppCode = jdpAppCode;
    }
}

package ths.project.system.dictionary.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import ths.project.common.constant.SchemaConstants;

import java.util.Date;

/**
 * 字典条码类
 */
@TableName(value = "JDP_EFORM_DICTIONARY", schema = SchemaConstants.DEFAULT)
public class Dictionary {
    @TableId
    private String dictionaryId;
    @TableField(value = "DICTIONARY_CODE")
    private String code;
    @TableField(value = "DICTIONARY_NAME")
    private String name;
    private String dictionaryTreeId;
    private Integer dictionarySort;
    private String dictionaryDescription;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createDate;
    private String createUser;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private Date modifyDate;
    private String modifyUser;
    private Integer dictionaryFlag;
    private String ext1;
    private String ext2;
    private String ext3;
    private String ext4;

    public String getDictionaryId() {
        return dictionaryId;
    }

    public void setDictionaryId(String dictionaryId) {
        this.dictionaryId = dictionaryId;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDictionaryTreeId() {
        return dictionaryTreeId;
    }

    public void setDictionaryTreeId(String dictionaryTreeId) {
        this.dictionaryTreeId = dictionaryTreeId;
    }

    public Integer getDictionarySort() {
        return dictionarySort;
    }

    public void setDictionarySort(Integer dictionarySort) {
        this.dictionarySort = dictionarySort;
    }

    public String getDictionaryDescription() {
        return dictionaryDescription;
    }

    public void setDictionaryDescription(String dictionaryDescription) {
        this.dictionaryDescription = dictionaryDescription;
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

    public Integer getDictionaryFlag() {
        return dictionaryFlag;
    }

    public void setDictionaryFlag(Integer dictionaryFlag) {
        this.dictionaryFlag = dictionaryFlag;
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

    @Override
    public String toString() {
        return "Dictionary{" +
                "dictionaryId='" + dictionaryId + '\'' +
                ", code='" + code + '\'' +
                ", name='" + name + '\'' +
                ", dictionaryTreeId='" + dictionaryTreeId + '\'' +
                ", dictionarySort=" + dictionarySort +
                ", dictionaryDescription='" + dictionaryDescription + '\'' +
                ", createDate=" + createDate +
                ", createUser='" + createUser + '\'' +
                ", modifyDate=" + modifyDate +
                ", modifyUser='" + modifyUser + '\'' +
                ", dictionaryFlag=" + dictionaryFlag +
                ", ext1='" + ext1 + '\'' +
                ", ext2='" + ext2 + '\'' +
                ", ext3='" + ext3 + '\'' +
                ", ext4='" + ext4 + '\'' +
                '}';
    }
}

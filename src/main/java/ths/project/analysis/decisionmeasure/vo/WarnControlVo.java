package ths.project.analysis.decisionmeasure.vo;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.format.annotation.DateTimeFormat;
import ths.project.common.constant.SchemaConstants;
import ths.project.common.entity.BaseEntity;

import java.util.Date;

/**
 * 预警管控信息表
 * @author
 *
 */
public class WarnControlVo {
    /**
     * 报告id
     */
    private String reportId;
    /**
     * 归属类型
     */
    private String ascriptionType;
    /**
     * 报告名称
     */
    private String reportName;
    /**
     * 报告日期
     */
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "GMT+8")
    private Date reportTime;
    /**
     * 重要提示
     */
    private String reportTip;
    /**
     * 创建时间
     */
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm", timezone = "GMT+8")
    private Date createTime;
    /**
     * 创建人
     */
    private String createUser;
    /**
     * 管控ID
     */
    @TableId
    private String warnControlId;
    /**
     * 管控名称
     */
    private String controlName;
    /**
     * 管控开始时间
     */
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private Date warnStartTime;
    /**
     * 管控结束时间
     */
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private Date warnEndTime;
    /**
     * 发布时间
     */
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private Date pushDate;

    /**
     * 文件名
     */
    private String fileName;

    /**
     * 文件编号
     */
    private String fileId;
    /**
     * 备注
     */
    private String remark;

    /**
     * 预警等级
     */
    private String warnLevel;
    /**
     * 预警等级名称
     */
    private String warnLevelName;
    /**
     * 是否添加预警管控
     */
    private String isWarmControl;
    /**
     * 状态 0 停用 1 启用
     */
    private Integer state;

    public String getWarnControlId() {
        return warnControlId;
    }

    public void setWarnControlId(String warnControlId) {
        this.warnControlId = warnControlId;
    }

    public String getControlName() {
        return controlName;
    }

    public void setControlName(String controlName) {
        this.controlName = controlName;
    }

    public Date getWarnStartTime() {
        return warnStartTime;
    }

    public void setWarnStartTime(Date warnStartTime) {
        this.warnStartTime = warnStartTime;
    }

    public Date getWarnEndTime() {
        return warnEndTime;
    }

    public void setWarnEndTime(Date warnEndTime) {
        this.warnEndTime = warnEndTime;
    }

    public Date getPushDate() {
        return pushDate;
    }

    public void setPushDate(Date pushDate) {
        this.pushDate = pushDate;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFileId() {
        return fileId;
    }

    public void setFileId(String fileId) {
        this.fileId = fileId;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public String getWarnLevel() {
        return warnLevel;
    }

    public void setWarnLevel(String warnLevel) {
        this.warnLevel = warnLevel;
    }

    public String getWarnLevelName() {
        return warnLevelName;
    }

    public void setWarnLevelName(String warnLevelName) {
        this.warnLevelName = warnLevelName;
    }

    public String getAscriptionType() {
        return ascriptionType;
    }

    public void setAscriptionType(String ascriptionType) {
        this.ascriptionType = ascriptionType;
    }

    public String getReportName() {
        return reportName;
    }

    public void setReportName(String reportName) {
        this.reportName = reportName;
    }

    public Date getReportTime() {
        return reportTime;
    }

    public void setReportTime(Date reportTime) {
        this.reportTime = reportTime;
    }

    public String getReportTip() {
        return reportTip;
    }

    public void setReportTip(String reportTip) {
        this.reportTip = reportTip;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public String getCreateUser() {
        return createUser;
    }

    public void setCreateUser(String createUser) {
        this.createUser = createUser;
    }

    public String getReportId() {
        return reportId;
    }

    public void setReportId(String reportId) {
        this.reportId = reportId;
    }

    public Integer getState() {
        return state;
    }

    public void setState(Integer state) {
        this.state = state;
    }

    public String getIsWarmControl() {
        return isWarmControl;
    }

    public void setIsWarmControl(String isWarmControl) {
        this.isWarmControl = isWarmControl;
    }
}

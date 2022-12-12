package ths.project.analysis.decisionmeasure.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.format.annotation.DateTimeFormat;
import ths.project.common.constant.SchemaConstants;
import ths.project.common.entity.BaseEntity;

import java.util.Date;

/**
 * 预警管控信息表
 */
@TableName(value = "T_WARN_CONTROL_INFO", schema = SchemaConstants.DEFAULT)
public class WarnControlInfo extends BaseEntity {
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
     * 事件枢纽-预警开始推送是否成功（0：失败，1：成功）
     */
    private Integer eventHubStartPushSuccessFlag;

    /**
     * 事件枢纽-预警结束推送是否成功（0：失败，1：成功）
     */
    private Integer eventHubEndPushSuccessFlag;

    /**
     * 事件推送成功工单号
     */
    private String flowNo;

    public String getIsWarmControl() {
        return isWarmControl;
    }

    public void setIsWarmControl(String isWarmControl) {
        this.isWarmControl = isWarmControl;
    }

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

    public Integer getEventHubStartPushSuccessFlag() {
        return eventHubStartPushSuccessFlag;
    }

    public void setEventHubStartPushSuccessFlag(Integer eventHubStartPushSuccessFlag) {
        this.eventHubStartPushSuccessFlag = eventHubStartPushSuccessFlag;
    }

    public Integer getEventHubEndPushSuccessFlag() {
        return eventHubEndPushSuccessFlag;
    }

    public void setEventHubEndPushSuccessFlag(Integer eventHubEndPushSuccessFlag) {
        this.eventHubEndPushSuccessFlag = eventHubEndPushSuccessFlag;
    }

    public String getFlowNo() {
        return flowNo;
    }

    public void setFlowNo(String flowNo) {
        this.flowNo = flowNo;
    }
}

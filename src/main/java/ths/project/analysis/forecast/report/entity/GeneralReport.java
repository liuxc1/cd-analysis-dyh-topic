package ths.project.analysis.forecast.report.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.format.annotation.DateTimeFormat;
import ths.project.common.entity.BaseEntity;

import java.util.Date;

@TableName("T_ANS_GENERAL_REPORT")
public class GeneralReport extends BaseEntity {
    @TableId
    private String reportId;
    private String ascriptionType;
    private String reportBatch;
    private String reportName;
    private String samllType;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "GMT+8")
    private Date reportTime;
    private String reportUserCode;
    private String reportUserName;
    private String reportRate;
    private String reportFrequency;
    private String reportType;
    private String reportTip;
    private String remark;
    private String field1;
    private String field2;
    private String field3;
    private String field4;
    private String field5;
    private String field6;
    private String reportInscribe;
    private String state;
    private String createDept;
    private Integer isMain;
    /**
     * 管控开始时间
     */
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private Date controlStartTime;
    /**
     * 管控结束时间
     */
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private Date controlEndTime;

    public String getReportId() {
        return reportId;
    }

    public void setReportId(String reportId) {
        this.reportId = reportId;
    }

    public String getAscriptionType() {
        return ascriptionType;
    }

    public void setAscriptionType(String ascriptionType) {
        this.ascriptionType = ascriptionType;
    }

    public String getReportBatch() {
        return reportBatch;
    }

    public void setReportBatch(String reportBatch) {
        this.reportBatch = reportBatch;
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

    public String getReportRate() {
        return reportRate;
    }

    public void setReportRate(String reportRate) {
        this.reportRate = reportRate;
    }

    public String getReportFrequency() {
        return reportFrequency;
    }

    public void setReportFrequency(String reportFrequency) {
        this.reportFrequency = reportFrequency;
    }

    public String getReportType() {
        return reportType;
    }

    public void setReportType(String reportType) {
        this.reportType = reportType;
    }

    public String getReportTip() {
        return reportTip;
    }

    public void setReportTip(String reportTip) {
        this.reportTip = reportTip;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public String getField1() {
        return field1;
    }

    public void setField1(String field1) {
        this.field1 = field1;
    }

    public String getField2() {
        return field2;
    }

    public void setField2(String field2) {
        this.field2 = field2;
    }

    public String getField3() {
        return field3;
    }

    public void setField3(String field3) {
        this.field3 = field3;
    }

    public String getField4() {
        return field4;
    }

    public void setField4(String field4) {
        this.field4 = field4;
    }

    public String getField5() {
        return field5;
    }

    public void setField5(String field5) {
        this.field5 = field5;
    }

    public String getField6() {
        return field6;
    }

    public void setField6(String field6) {
        this.field6 = field6;
    }

    public String getReportInscribe() {
        return reportInscribe;
    }

    public void setReportInscribe(String reportInscribe) {
        this.reportInscribe = reportInscribe;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getCreateDept() {
        return createDept;
    }

    public void setCreateDept(String createDept) {
        this.createDept = createDept;
    }

    public Integer getIsMain() {
        return isMain;
    }

    public void setIsMain(Integer isMain) {
        this.isMain = isMain;
    }

    public String getReportUserCode() {
        return reportUserCode;
    }

    public void setReportUserCode(String reportUserCode) {
        this.reportUserCode = reportUserCode;
    }

    public String getReportUserName() {
        return reportUserName;
    }

    public void setReportUserName(String reportUserName) {
        this.reportUserName = reportUserName;
    }

    public String getSamllType() {
        return samllType;
    }

    public void setSamllType(String samllType) {
        this.samllType = samllType;
    }

    public Date getControlStartTime() {
        return controlStartTime;
    }

    public void setControlStartTime(Date controlStartTime) {
        this.controlStartTime = controlStartTime;
    }

    public Date getControlEndTime() {
        return controlEndTime;
    }

    public void setControlEndTime(Date controlEndTime) {
        this.controlEndTime = controlEndTime;
    }
}

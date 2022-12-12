package ths.project.asses.entity;


import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.format.annotation.DateTimeFormat;
import ths.project.common.entity.BaseEntity;

import java.util.Date;
@TableName("T_ASSESS_MAIN" )
public class AssessMain extends BaseEntity {

  @TableId
  private String pkid;
  private String assessName;
  private String assessType;
  private String date;
  private String remark;
  @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm")
  @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm", timezone = "GMT+8")
  private Date startTime;
  @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm")
  @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm", timezone = "GMT+8")
  private Date endTime;


  public String getPkid() {
    return pkid;
  }

  public void setPkid(String pkid) {
    this.pkid = pkid;
  }


  public String getAssessName() {
    return assessName;
  }

  public void setAssessName(String assessName) {
    this.assessName = assessName;
  }


  public String getAssessType() {
    return assessType;
  }

  public void setAssessType(String assessType) {
    this.assessType = assessType;
  }


  public String getDate() {
    return date;
  }

  public void setDate(String date) {
    this.date = date;
  }


  public String getRemark() {
    return remark;
  }

  public void setRemark(String remark) {
    this.remark = remark;
  }

  public Date getStartTime() {
    return startTime;
  }

  public void setStartTime(Date startTime) {
    this.startTime = startTime;
  }

  public Date getEndTime() {
    return endTime;
  }

  public void setEndTime(Date endTime) {
    this.endTime = endTime;
  }
}

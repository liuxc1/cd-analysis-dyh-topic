package ths.project.analysis.forecast.airforecastparition.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

@TableName(value = "T_ANS_FLOW_AREA_INFO")
public class FlowAreaInfo {

  //主键
  @TableId
  private String pkid;
  //创建时间
  @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
  @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
  private Date createTime;
  //创建人
  private String createUser;
  //保存时间
  @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
  @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
  private Date saveTime;
  //保存人
  private String saveUser;
  //流程状态
  private long flowState;
  //意见
  private String areaOpinion;
  //重要提示1
  private String importantHints;
  //落款
  private String inscribe;
  //重要提示
  private String hint;


  public FlowAreaInfo(String pkid, Date createTime, String createUser, Date saveTime, String saveUser, long flowState, String areaOpinion, String importantHints, String inscribe, String hint) {
    this.pkid = pkid;
    this.createTime = createTime;
    this.createUser = createUser;
    this.saveTime = saveTime;
    this.saveUser = saveUser;
    this.flowState = flowState;
    this.areaOpinion = areaOpinion;
    this.importantHints = importantHints;
    this.inscribe = inscribe;
    this.hint = hint;
  }

  public FlowAreaInfo(Date createTime, String createUser, Date saveTime, String saveUser, long flowState, String areaOpinion, String importantHints, String inscribe, String hint) {
    this.createTime = createTime;
    this.createUser = createUser;
    this.saveTime = saveTime;
    this.saveUser = saveUser;
    this.flowState = flowState;
    this.areaOpinion = areaOpinion;
    this.importantHints = importantHints;
    this.inscribe = inscribe;
    this.hint = hint;
  }

  public FlowAreaInfo() {
  }

  public String getPkid() {
    return pkid;
  }

  public void setPkid(String pkid) {
    this.pkid = pkid;
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

  public Date getSaveTime() {
    return saveTime;
  }

  public void setSaveTime(Date saveTime) {
    this.saveTime = saveTime;
  }

  public String getSaveUser() {
    return saveUser;
  }

  public void setSaveUser(String saveUser) {
    this.saveUser = saveUser;
  }

  public long getFlowState() {
    return flowState;
  }

  public void setFlowState(long flowState) {
    this.flowState = flowState;
  }

  public String getAreaOpinion() {
    return areaOpinion;
  }

  public void setAreaOpinion(String areaOpinion) {
    this.areaOpinion = areaOpinion;
  }

  public String getImportantHints() {
    return importantHints;
  }

  public void setImportantHints(String importantHints) {
    this.importantHints = importantHints;
  }

  public String getInscribe() {
    return inscribe;
  }

  public void setInscribe(String inscribe) {
    this.inscribe = inscribe;
  }

  public String getHint() {
    return hint;
  }

  public void setHint(String hint) {
    this.hint = hint;
  }
}

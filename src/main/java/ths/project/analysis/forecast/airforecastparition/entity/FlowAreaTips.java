package ths.project.analysis.forecast.airforecastparition.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

@TableName(value = "T_ANS_FLOW_AREA_TIPS")
public class FlowAreaTips {

  private String pkid;
  private String infoId;
  private String regionCode;
  private String regionName;
  private String importantHints;
  private long sort;
  @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
  @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
  private Date createTime;


  public String getPkid() {
    return pkid;
  }

  public void setPkid(String pkid) {
    this.pkid = pkid;
  }


  public String getInfoId() {
    return infoId;
  }

  public void setInfoId(String infoId) {
    this.infoId = infoId;
  }


  public String getRegionCode() {
    return regionCode;
  }

  public void setRegionCode(String regionCode) {
    this.regionCode = regionCode;
  }


  public String getRegionName() {
    return regionName;
  }

  public void setRegionName(String regionName) {
    this.regionName = regionName;
  }


  public String getImportantHints() {
    return importantHints;
  }

  public void setImportantHints(String importantHints) {
    this.importantHints = importantHints;
  }


  public long getSort() {
    return sort;
  }

  public void setSort(long sort) {
    this.sort = sort;
  }


  public Date getCreateTime() {
    return createTime;
  }

  public void setCreateTime(Date createTime) {
    this.createTime = createTime;
  }

}

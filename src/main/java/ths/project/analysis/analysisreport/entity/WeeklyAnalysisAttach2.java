package ths.project.analysis.analysisreport.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;


import java.util.Date;

@TableName(value = "T_WEEKLY_ANALYSIS_ATTACH2", schema = "AIR_ANALYSISREPORT")
public class WeeklyAnalysisAttach2 {

  @TableId
  private String id;
  private String reportId;
  @TableField("MONITORTIME")
  private Date monitorTime;
  private String aqi;
  @TableField("primarypollutant")
  private String primaryPollutant;
  @TableField("O3_8")
  private String o38;
  private String pm25;
  private String pm10;


  public String getId() {
    return id;
  }

  public void setId(String id) {
    this.id = id;
  }


  public String getReportId() {
    return reportId;
  }

  public void setReportId(String reportId) {
    this.reportId = reportId;
  }

  public Date getMonitorTime() {
    return monitorTime;
  }

  public void setMonitorTime(Date monitorTime) {
    this.monitorTime = monitorTime;
  }

  public String getPrimaryPollutant() {
    return primaryPollutant;
  }

  public void setPrimaryPollutant(String primaryPollutant) {
    this.primaryPollutant = primaryPollutant;
  }

  public String getO38() {
    return o38;
  }

  public void setO38(String o38) {
    this.o38 = o38;
  }

  public String getAqi() {
    return aqi;
  }

  public void setAqi(String aqi) {
    this.aqi = aqi;
  }

  public String getPm25() {
    return pm25;
  }

  public void setPm25(String pm25) {
    this.pm25 = pm25;
  }

  public String getPm10() {
    return pm10;
  }

  public void setPm10(String pm10) {
    this.pm10 = pm10;
  }

  @Override
  public String toString() {
    return "WeeklyAnalysisAttach2{" +
            "id='" + id + '\'' +
            ", reportId='" + reportId + '\'' +
            ", monitorTime=" + monitorTime +
            ", aqi='" + aqi + '\'' +
            ", primaryPollutant='" + primaryPollutant + '\'' +
            ", o38='" + o38 + '\'' +
            ", pm25='" + pm25 + '\'' +
            ", pm10='" + pm10 + '\'' +
            '}';
  }
}

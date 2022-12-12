package ths.project.analysis.forecast.numericalmodel.entity;


import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;
@TableName(value = "T_BAS_FORECAST_LOG",schema ="AIR_FORECAST" )
public class ForecastLog {

  private String pkid;
  @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm")
  @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm")
  private Date logTime;
  private String logText;
  @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm")
  @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm")
  private Date updateTime;

  public String getPkid() {
    return pkid;
  }

  public void setPkid(String pkid) {
    this.pkid = pkid;
  }

  public Date getLogTime() {
    return logTime;
  }

  public void setLogTime(Date logTime) {
    this.logTime = logTime;
  }

  public String getLogText() {
    return logText;
  }

  public void setLogText(String logText) {
    this.logText = logText;
  }

  public Date getUpdateTime() {
    return updateTime;
  }

  public void setUpdateTime(Date updateTime) {
    this.updateTime = updateTime;
  }
}

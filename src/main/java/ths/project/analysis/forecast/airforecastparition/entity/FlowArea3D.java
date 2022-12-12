package ths.project.analysis.forecast.airforecastparition.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;


@TableName(value = "T_ANS_FLOW_AREA_3D")
public class FlowArea3D {
    //主键
    @TableId
    private String pkid;
    //逻辑外键。与报告主表中的REPORT_ID关联
    private String areaPkid;
    //区域编码
    private String regioncode;
    //区域名称
    private String regionname;
    //起报时间，yyyy-MM-dd
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createTime;
    //预报第一天，yyyy-MM-dd
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private Date forecastDate1;
    //AQI开始1
    private String aqiStart1;
    //AQI结束1
    private String aqiEnd1;
    //首要污染物1
    private String pullname1;
    //预报第二天，yyyy-MM-dd
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private Date forecastDate2;
    //AQI开始2
    private String aqiStart2;
    //AQI结束2
    private String aqiEnd2;
    //首要污染物2
    private String pullname2;
    //预报第三天，yyyy-MM-dd
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private Date forecastDate3;
    //AQI开始4
    private String aqiStart3;
    //AQI结束3
    private String aqiEnd3;
    //首要污染物3
    private String pullname3;

    public String getPkid() {
        return pkid;
    }

    public void setPkid(String pkid) {
        this.pkid = pkid;
    }

    public String getAreaPkid() {
        return areaPkid;
    }

    public void setAreaPkid(String areaPkid) {
        this.areaPkid = areaPkid;
    }

    public String getRegioncode() {
        return regioncode;
    }

    public void setRegioncode(String regioncode) {
        this.regioncode = regioncode;
    }

    public String getRegionname() {
        return regionname;
    }

    public void setRegionname(String regionname) {
        this.regionname = regionname;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Date getForecastDate1() {
        return forecastDate1;
    }

    public void setForecastDate1(Date forecastDate1) {
        this.forecastDate1 = forecastDate1;
    }

    public String getAqiStart1() {
        return aqiStart1;
    }

    public void setAqiStart1(String aqiStart1) {
        this.aqiStart1 = aqiStart1;
    }

    public String getAqiEnd1() {
        return aqiEnd1;
    }

    public void setAqiEnd1(String aqiEnd1) {
        this.aqiEnd1 = aqiEnd1;
    }

    public String getPullname1() {
        return pullname1;
    }

    public void setPullname1(String pullname1) {
        this.pullname1 = pullname1;
    }

    public Date getForecastDate2() {
        return forecastDate2;
    }

    public void setForecastDate2(Date forecastDate2) {
        this.forecastDate2 = forecastDate2;
    }

    public String getAqiStart2() {
        return aqiStart2;
    }

    public void setAqiStart2(String aqiStart2) {
        this.aqiStart2 = aqiStart2;
    }

    public String getAqiEnd2() {
        return aqiEnd2;
    }

    public void setAqiEnd2(String aqiEnd2) {
        this.aqiEnd2 = aqiEnd2;
    }

    public String getPullname2() {
        return pullname2;
    }

    public void setPullname2(String pullname2) {
        this.pullname2 = pullname2;
    }

    public Date getForecastDate3() {
        return forecastDate3;
    }

    public void setForecastDate3(Date forecastDate3) {
        this.forecastDate3 = forecastDate3;
    }

    public String getAqiStart3() {
        return aqiStart3;
    }

    public void setAqiStart3(String aqiStart3) {
        this.aqiStart3 = aqiStart3;
    }

    public String getAqiEnd3() {
        return aqiEnd3;
    }

    public void setAqiEnd3(String aqiEnd3) {
        this.aqiEnd3 = aqiEnd3;
    }

    public String getPullname3() {
        return pullname3;
    }

    public void setPullname3(String pullname3) {
        this.pullname3 = pullname3;
    }
}

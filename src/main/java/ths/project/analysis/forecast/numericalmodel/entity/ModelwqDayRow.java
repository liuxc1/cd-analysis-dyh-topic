package ths.project.analysis.forecast.numericalmodel.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

@TableName(value = "T_BAS_MODELWQ_DAY_ROW",schema ="AIR_FORECAST" )
public class ModelwqDayRow {

    private String model;
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm")
    private Date modeltime;
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm")
    private Date resulttime;
    private String regioncode;
    private String regionname;
    private String pointcode;
    private String pointname;
    private long pointtype;
    private long backtype;
    private long pm25;
    private long pm25Iaqi;
    private long pm10;
    private long pm10Iaqi;
    private double co;
    private long coIaqi;
    private long o3;
    private long o3Iaqi;
    @TableField("O3_8")
    private long o38;
    @TableField("O3_8_IAQI")
    private long o38Iaqi;
    private long so2;
    private long so2Iaqi;
    private long no2;
    private long no2Iaqi;
    private long aqi;
    private String primpollute;
    private String aqilevel;
    private long aqilevelindex;
    private String aqilevelstate;
    private long step;
    private String aqiReange;
    private long aqiMin;
    private long aqiMax;
    private String aqilevelreangestate;

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public Date getModeltime() {
        return modeltime;
    }

    public void setModeltime(Date modeltime) {
        this.modeltime = modeltime;
    }

    public Date getResulttime() {
        return resulttime;
    }

    public void setResulttime(Date resulttime) {
        this.resulttime = resulttime;
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

    public String getPointcode() {
        return pointcode;
    }

    public void setPointcode(String pointcode) {
        this.pointcode = pointcode;
    }

    public String getPointname() {
        return pointname;
    }

    public void setPointname(String pointname) {
        this.pointname = pointname;
    }

    public long getPointtype() {
        return pointtype;
    }

    public void setPointtype(long pointtype) {
        this.pointtype = pointtype;
    }

    public long getBacktype() {
        return backtype;
    }

    public void setBacktype(long backtype) {
        this.backtype = backtype;
    }

    public long getPm25() {
        return pm25;
    }

    public void setPm25(long pm25) {
        this.pm25 = pm25;
    }

    public long getPm25Iaqi() {
        return pm25Iaqi;
    }

    public void setPm25Iaqi(long pm25Iaqi) {
        this.pm25Iaqi = pm25Iaqi;
    }

    public long getPm10() {
        return pm10;
    }

    public void setPm10(long pm10) {
        this.pm10 = pm10;
    }

    public long getPm10Iaqi() {
        return pm10Iaqi;
    }

    public void setPm10Iaqi(long pm10Iaqi) {
        this.pm10Iaqi = pm10Iaqi;
    }

    public double getCo() {
        return co;
    }

    public void setCo(double co) {
        this.co = co;
    }

    public long getCoIaqi() {
        return coIaqi;
    }

    public void setCoIaqi(long coIaqi) {
        this.coIaqi = coIaqi;
    }

    public long getO3() {
        return o3;
    }

    public void setO3(long o3) {
        this.o3 = o3;
    }

    public long getO3Iaqi() {
        return o3Iaqi;
    }

    public void setO3Iaqi(long o3Iaqi) {
        this.o3Iaqi = o3Iaqi;
    }

    public long getO38() {
        return o38;
    }

    public void setO38(long o38) {
        this.o38 = o38;
    }

    public long getO38Iaqi() {
        return o38Iaqi;
    }

    public void setO38Iaqi(long o38Iaqi) {
        this.o38Iaqi = o38Iaqi;
    }

    public long getSo2() {
        return so2;
    }

    public void setSo2(long so2) {
        this.so2 = so2;
    }

    public long getSo2Iaqi() {
        return so2Iaqi;
    }

    public void setSo2Iaqi(long so2Iaqi) {
        this.so2Iaqi = so2Iaqi;
    }

    public long getNo2() {
        return no2;
    }

    public void setNo2(long no2) {
        this.no2 = no2;
    }

    public long getNo2Iaqi() {
        return no2Iaqi;
    }

    public void setNo2Iaqi(long no2Iaqi) {
        this.no2Iaqi = no2Iaqi;
    }

    public long getAqi() {
        return aqi;
    }

    public void setAqi(long aqi) {
        this.aqi = aqi;
    }

    public String getPrimpollute() {
        return primpollute;
    }

    public void setPrimpollute(String primpollute) {
        this.primpollute = primpollute;
    }

    public String getAqilevel() {
        return aqilevel;
    }

    public void setAqilevel(String aqilevel) {
        this.aqilevel = aqilevel;
    }

    public long getAqilevelindex() {
        return aqilevelindex;
    }

    public void setAqilevelindex(long aqilevelindex) {
        this.aqilevelindex = aqilevelindex;
    }

    public String getAqilevelstate() {
        return aqilevelstate;
    }

    public void setAqilevelstate(String aqilevelstate) {
        this.aqilevelstate = aqilevelstate;
    }

    public long getStep() {
        return step;
    }

    public void setStep(long step) {
        this.step = step;
    }

    public String getAqiReange() {
        return aqiReange;
    }

    public void setAqiReange(String aqiReange) {
        this.aqiReange = aqiReange;
    }

    public long getAqiMin() {
        return aqiMin;
    }

    public void setAqiMin(long aqiMin) {
        this.aqiMin = aqiMin;
    }

    public long getAqiMax() {
        return aqiMax;
    }

    public void setAqiMax(long aqiMax) {
        this.aqiMax = aqiMax;
    }

    public String getAqilevelreangestate() {
        return aqilevelreangestate;
    }

    public void setAqilevelreangestate(String aqilevelreangestate) {
        this.aqilevelreangestate = aqilevelreangestate;
    }
}

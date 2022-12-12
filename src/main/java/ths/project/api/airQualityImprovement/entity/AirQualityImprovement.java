package ths.project.api.airQualityImprovement.entity;

import java.math.BigDecimal;

/**
 * 空气质量改善实体类
 */
public class AirQualityImprovement {
    /**
     * 模型时间
     *
     */
    private String monitorTime;
    /**
     * 优良天数
     */
    private Integer goodDay;

    /**
     * 重污染天数
     */
    private Integer contaminationDay;

    /**
     * AQI
     */
    private BigDecimal aqi;
    /**
     * PM25
     */
    private BigDecimal pm25;
    /**
     * PM10
     */
    private BigDecimal pm10;
    /**
     * SO2
     */
    private BigDecimal so2;
    /**
     * NO2
     */
    private BigDecimal no2;
    /**
     * co
     */
    private float co;
    /**
     * O3
     */
    private float o3;

    public String getMonitorTime() {
        return monitorTime;
    }

    public void setMonitorTime(String monitorTime) {
        this.monitorTime = monitorTime;
    }

    public Integer getGoodDay() {
        return goodDay;
    }

    public void setGoodDay(Integer goodDay) {
        this.goodDay = goodDay;
    }

    public Integer getContaminationDay() {
        return contaminationDay;
    }

    public void setContaminationDay(Integer contaminationDay) {
        this.contaminationDay = contaminationDay;
    }

    public BigDecimal getAqi() {
        return aqi;
    }

    public void setAqi(BigDecimal aqi) {
        this.aqi = aqi;
    }

    public BigDecimal getPm25() {
        return pm25;
    }

    public void setPm25(BigDecimal pm25) {
        this.pm25 = pm25;
    }

    public BigDecimal getPm10() {
        return pm10;
    }

    public void setPm10(BigDecimal pm10) {
        this.pm10 = pm10;
    }

    public BigDecimal getSo2() {
        return so2;
    }

    public void setSo2(BigDecimal so2) {
        this.so2 = so2;
    }

    public BigDecimal getNo2() {
        return no2;
    }

    public void setNo2(BigDecimal no2) {
        this.no2 = no2;
    }

    public float getCo() {
        return co;
    }

    public void setCo(float co) {
        this.co = co;
    }

    public float getO3() {
        return o3;
    }

    public void setO3(float o3) {
        this.o3 = o3;
    }
}

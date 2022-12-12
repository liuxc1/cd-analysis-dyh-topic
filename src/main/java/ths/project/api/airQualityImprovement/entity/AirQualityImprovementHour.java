package ths.project.api.airQualityImprovement.entity;

public class AirQualityImprovementHour {
    /**
     * 模型时间
     *
     */
    private String monitorTime;
    /**
     * AQI
     */
    private Integer aqi;
    /**
     * PM25
     */
    private Integer pm25;
    /**
     * PM10
     */
    private Integer pm10;
    /**
     * SO2
     */
    private Integer so2;
    /**
     * NO2
     */
    private Integer no2;
    /**
     * co
     */
    private float co;
    /**
     * O3
     */
    private Integer o3;

    public String getMonitorTime() {
        return monitorTime;
    }

    public void setMonitorTime(String monitorTime) {
        this.monitorTime = monitorTime;
    }

    public Integer getAqi() {
        return aqi;
    }

    public void setAqi(Integer aqi) {
        this.aqi = aqi;
    }

    public Integer getPm25() {
        return pm25;
    }

    public void setPm25(Integer pm25) {
        this.pm25 = pm25;
    }

    public Integer getPm10() {
        return pm10;
    }

    public void setPm10(Integer pm10) {
        this.pm10 = pm10;
    }

    public Integer getSo2() {
        return so2;
    }

    public void setSo2(Integer so2) {
        this.so2 = so2;
    }

    public Integer getNo2() {
        return no2;
    }

    public void setNo2(Integer no2) {
        this.no2 = no2;
    }

    public float getCo() {
        return co;
    }

    public void setCo(float co) {
        this.co = co;
    }

    public Integer getO3() {
        return o3;
    }

    public void setO3(Integer o3) {
        this.o3 = o3;
    }
}

package ths.project.analysis.forecastcaselibrary.vo;

/**
 * 要素简析
 */
public class FactorAnalysis {

    private String monitortime;
    private String pm25;
    private String temperature;
    private String rhu;
    private String rainfal;
    private String windSpeed;
    private String windFrequency;
    private String tempInversion08;
    private String tempInversion20;

    public static FactorAnalysis build() {
        return new FactorAnalysis();
    }

    public FactorAnalysis tempInversion20(String tempInversion20) {
        this.tempInversion20 = tempInversion20;
        return this;
    }

    public FactorAnalysis tempInversion08(String tempInversion08) {
        this.tempInversion08 = tempInversion08;
        return this;
    }

    public FactorAnalysis windFrequency(String windFrequency) {
        this.windFrequency = windFrequency;
        return this;
    }

    public FactorAnalysis windSpeed(String windSpeed) {
        this.windSpeed = windSpeed;
        return this;
    }

    public FactorAnalysis rainfal(String rainfal) {
        this.rainfal = rainfal;
        return this;
    }

    public FactorAnalysis rhu(String rhu) {
        this.rhu = rhu;
        return this;
    }

    public FactorAnalysis temperature(String temperature) {
        this.temperature = temperature;
        return this;
    }

    public FactorAnalysis monitortime(String monitortime) {
        this.monitortime = monitortime;
        return this;
    }

    public FactorAnalysis pm25(String pm25) {
        this.pm25 = pm25;
        return this;
    }

    public String getMonitortime() {
        return monitortime;
    }

    public void setMonitortime(String monitortime) {
        this.monitortime = monitortime;
    }

    public String getPm25() {
        return pm25;
    }

    public void setPm25(String pm25) {
        this.pm25 = pm25;
    }

    public String getTemperature() {
        return temperature;
    }

    public void setTemperature(String temperature) {
        this.temperature = temperature;
    }

    public String getRhu() {
        return rhu;
    }

    public void setRhu(String rhu) {
        this.rhu = rhu;
    }

    public String getRainfal() {
        return rainfal;
    }

    public void setRainfal(String rainfal) {
        this.rainfal = rainfal;
    }

    public String getWindSpeed() {
        return windSpeed;
    }

    public void setWindSpeed(String windSpeed) {
        this.windSpeed = windSpeed;
    }

    public String getWindFrequency() {
        return windFrequency;
    }

    public void setWindFrequency(String windFrequency) {
        this.windFrequency = windFrequency;
    }

    public String getTempInversion08() {
        return tempInversion08;
    }

    public void setTempInversion08(String tempInversion08) {
        this.tempInversion08 = tempInversion08;
    }

    public String getTempInversion20() {
        return tempInversion20;
    }

    public void setTempInversion20(String tempInversion20) {
        this.tempInversion20 = tempInversion20;
    }
}

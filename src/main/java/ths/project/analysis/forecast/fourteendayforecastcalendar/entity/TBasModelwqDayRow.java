package ths.project.analysis.forecast.fourteendayforecastcalendar.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import java.util.Objects;

@TableName(value = "T_BAS_MODELWQ_DAY_ROW", schema = "AIR_FORECAST")
public class TBasModelwqDayRow {
    //模型时间
    private String modeltime;
    //预报时间
    private String resulttime;
    //点位
    private String regionName;
    //AQI最小值
    private Integer aqiMin;
    //AQI最大值
    private Integer aqiMax;

    public TBasModelwqDayRow() {
    }

    public TBasModelwqDayRow(String modeltime, String resulttime, String regionName, Integer aqiMin, Integer aqiMax) {
        this.modeltime = modeltime;
        this.resulttime = resulttime;
        this.regionName = regionName;
        this.aqiMin = aqiMin;
        this.aqiMax = aqiMax;
    }

    public String getModeltime() {
        return modeltime;
    }

    public void setModeltime(String modeltime) {
        this.modeltime = modeltime;
    }

    public String getResulttime() {
        return resulttime;
    }

    public void setResulttime(String resulttime) {
        this.resulttime = resulttime;
    }

    public String getRegionName() {
        return regionName;
    }

    public void setRegionName(String regionName) {
        this.regionName = regionName;
    }

    public Integer getAqiMin() {
        return aqiMin;
    }

    public void setAqiMin(Integer aqiMin) {
        this.aqiMin = aqiMin;
    }

    public Integer getAqiMax() {
        return aqiMax;
    }

    public void setAqiMax(Integer aqiMax) {
        this.aqiMax = aqiMax;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        TBasModelwqDayRow that = (TBasModelwqDayRow) o;
        return Objects.equals(modeltime, that.modeltime) &&
                Objects.equals(resulttime, that.resulttime) &&
                Objects.equals(regionName, that.regionName) &&
                Objects.equals(aqiMin, that.aqiMin) &&
                Objects.equals(aqiMax, that.aqiMax);
    }

    @Override
    public int hashCode() {
        return Objects.hash(modeltime, resulttime, regionName, aqiMin, aqiMax);
    }
}

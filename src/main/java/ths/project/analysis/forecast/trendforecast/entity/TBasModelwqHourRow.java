package ths.project.analysis.forecast.trendforecast.entity;

import com.baomidou.mybatisplus.annotation.TableName;

import java.math.BigDecimal;
import java.util.Objects;


@TableName(value = "T_BAS_MODELWQ_HOUR_ROW", schema = "AIR_FORECAST")
public class TBasModelwqHourRow {
    //点位名称
    private String pointName;
    //时间
    private String resultTime;
    //SO2
    private Integer so2;
    //NO2
    private Integer no2;
    //PM10
    private Integer pm10;
    //CO
    private BigDecimal co;
    //O3
    private Integer o3;
    //PM25
    private Integer pm25;
    //CO
    private BigDecimal vocs;


    public TBasModelwqHourRow() {
    }

    public TBasModelwqHourRow(String pointName, String resultTime, Integer so2, Integer no2, Integer pm10, BigDecimal co, Integer o3, Integer pm25, BigDecimal vocs) {
        this.pointName = pointName;
        this.resultTime = resultTime;
        this.so2 = so2;
        this.no2 = no2;
        this.pm10 = pm10;
        this.co = co;
        this.o3 = o3;
        this.pm25 = pm25;
        this.vocs = vocs;
    }

    public String getPointName() {
        return pointName;
    }

    public void setPointName(String pointName) {
        this.pointName = pointName;
    }

    public String getResultTime() {
        return resultTime;
    }

    public void setResultTime(String resultTime) {
        this.resultTime = resultTime;
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

    public Integer getPm10() {
        return pm10;
    }

    public void setPm10(Integer pm10) {
        this.pm10 = pm10;
    }

    public BigDecimal getCo() {
        return co;
    }

    public void setCo(BigDecimal co) {
        this.co = co;
    }

    public Integer getO3() {
        return o3;
    }

    public void setO3(Integer o3) {
        this.o3 = o3;
    }

    public Integer getPm25() {
        return pm25;
    }

    public void setPm25(Integer pm25) {
        this.pm25 = pm25;
    }

    public BigDecimal getVocs() {
        return vocs;
    }

    public void setVocs(BigDecimal vocs) {
        this.vocs = vocs;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        TBasModelwqHourRow that = (TBasModelwqHourRow) o;
        return Objects.equals(pointName, that.pointName) &&
                Objects.equals(resultTime, that.resultTime) &&
                Objects.equals(so2, that.so2) &&
                Objects.equals(no2, that.no2) &&
                Objects.equals(pm10, that.pm10) &&
                Objects.equals(co, that.co) &&
                Objects.equals(o3, that.o3) &&
                Objects.equals(pm25, that.pm25) &&
                Objects.equals(vocs, that.vocs);
    }

    @Override
    public int hashCode() {
        return Objects.hash(pointName, resultTime, so2, no2, pm10, co, o3, pm25, vocs);
    }
}

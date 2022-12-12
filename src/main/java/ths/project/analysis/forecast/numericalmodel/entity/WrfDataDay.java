package ths.project.analysis.forecast.numericalmodel.entity;


import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;

import org.springframework.format.annotation.DateTimeFormat;

import java.math.BigDecimal;
import java.util.Date;

/**
 * @Description
 * @Author Hunter
 * @Date 2021-06-25
 */

@TableName(value = "T_WRF_DATA_DAY", schema = "AIR_FORECAST")
public class WrfDataDay {


    /**
     * 模型
     */
    private String model;

    /**
     * 模拟时间
     */
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm")
    private Date modelTime;

    /**
     * 预报时间
     */
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private Date resultTime;

    /**
     * 站点编码
     */
    private String pointCode;

    /**
     * 站点名称
     */
    private String pointName;

    /**
     * 管控类型（国控 0，省控 1，市控 2,气象站3）
     */
    private Integer pointType;

    /**
     * 行政区编码
     */
    private String regionCode;

    /**
     * 行政区名称
     */
    private String regionName;

    /**
     * 行政区类型
     */
    private Integer regionType;

    /**
     * 风向
     */
    private BigDecimal windDirection;

    /**
     * 风速
     */
    private BigDecimal windSpeed;

    private Integer step;

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public Date getModelTime() {
        return modelTime;
    }

    public void setModelTime(Date modelTime) {
        this.modelTime = modelTime;
    }

    public Date getResultTime() {
        return resultTime;
    }

    public void setResultTime(Date resultTime) {
        this.resultTime = resultTime;
    }

    public String getPointCode() {
        return pointCode;
    }

    public void setPointCode(String pointCode) {
        this.pointCode = pointCode;
    }

    public String getPointName() {
        return pointName;
    }

    public void setPointName(String pointName) {
        this.pointName = pointName;
    }

    public Integer getPointType() {
        return pointType;
    }

    public void setPointType(Integer pointType) {
        this.pointType = pointType;
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

    public Integer getRegionType() {
        return regionType;
    }

    public void setRegionType(Integer regionType) {
        this.regionType = regionType;
    }

    public BigDecimal getWindDirection() {
        return windDirection;
    }

    public void setWindDirection(BigDecimal windDirection) {
        this.windDirection = windDirection;
    }

    public BigDecimal getWindSpeed() {
        return windSpeed;
    }

    public void setWindSpeed(BigDecimal windSpeed) {
        this.windSpeed = windSpeed;
    }

    public Integer getStep() {
        return step;
    }

    public void setStep(Integer step) {
        this.step = step;
    }
}

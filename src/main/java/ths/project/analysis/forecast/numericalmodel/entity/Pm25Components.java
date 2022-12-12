package ths.project.analysis.forecast.numericalmodel.entity;


import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.format.annotation.DateTimeFormat;

import java.math.BigDecimal;
import java.util.Date;

/**
 * PM25 组分
 */
@TableName(value = "T_PM25_COMPONENTS", schema = "AIR_FORECAST")
public class Pm25Components {

    /**
     * 模式
     */
    private String model;

    /**
     * 起报时间
     */
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm")
    private Date modelTime;

    /**
     * 预报时间
     */
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm")
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
     * 站点类型
     */
    private Integer pointType;

    /**
     * 行政区编码
     */
    private String regionCode;

    /**
     * 行政区
     */
    private String regionName;

    /**
     * 行政区类型
     */
    private Integer regionType;

    private BigDecimal pm25So4;

    private BigDecimal pm25No3;

    private BigDecimal pm25Nh4;

    private BigDecimal pm25Ec;

    private BigDecimal pm25Oc;

    private BigDecimal pm25Na;

    private BigDecimal pm25Cl;

    private BigDecimal pm25Other;

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

    public BigDecimal getPm25So4() {
        return pm25So4;
    }

    public void setPm25So4(BigDecimal pm25So4) {
        this.pm25So4 = pm25So4;
    }

    public BigDecimal getPm25No3() {
        return pm25No3;
    }

    public void setPm25No3(BigDecimal pm25No3) {
        this.pm25No3 = pm25No3;
    }

    public BigDecimal getPm25Nh4() {
        return pm25Nh4;
    }

    public void setPm25Nh4(BigDecimal pm25Nh4) {
        this.pm25Nh4 = pm25Nh4;
    }

    public BigDecimal getPm25Ec() {
        return pm25Ec;
    }

    public void setPm25Ec(BigDecimal pm25Ec) {
        this.pm25Ec = pm25Ec;
    }

    public BigDecimal getPm25Oc() {
        return pm25Oc;
    }

    public void setPm25Oc(BigDecimal pm25Oc) {
        this.pm25Oc = pm25Oc;
    }

    public BigDecimal getPm25Na() {
        return pm25Na;
    }

    public void setPm25Na(BigDecimal pm25Na) {
        this.pm25Na = pm25Na;
    }

    public BigDecimal getPm25Cl() {
        return pm25Cl;
    }

    public void setPm25Cl(BigDecimal pm25Cl) {
        this.pm25Cl = pm25Cl;
    }

    public BigDecimal getPm25Other() {
        return pm25Other;
    }

    public void setPm25Other(BigDecimal pm25Other) {
        this.pm25Other = pm25Other;
    }

    public Integer getStep() {
        return step;
    }

    public void setStep(Integer step) {
        this.step = step;
    }
}

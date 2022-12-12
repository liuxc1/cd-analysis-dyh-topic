package ths.project.analysis.forecast.numericalmodel.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.format.annotation.DateTimeFormat;

import java.math.BigDecimal;
import java.util.Date;

/**
 * @Description
 * @Author Hunter
 * @Date 2021-06-23
 */

@TableName(value = "T_WRF_DATA_HOUR", schema = "AIR_FORECAST")
public class WrfDataHour {


    /**
     * 模型
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
     * 地面温度
     */
    private BigDecimal temperature;

    /**
     * 风向
     */
    private BigDecimal windDirection;

    /**
     * 风速
     */
    private BigDecimal windSpeed;

    /**
     * 边界层
     */
    private BigDecimal boundingLayer;

    /**
     * 地面气压
     */
    private BigDecimal pressure;

    /**
     * 相对湿度
     */
    private BigDecimal humidity;

    /**
     * 降水
     */
    private BigDecimal rainfall;

    /**
     * 太阳辐射
     */
    private BigDecimal radiation;

    /**
     * 云覆盖
     */
    private BigDecimal cloudCover;
    /**
     * 可见度
     */
    private BigDecimal vis;

    private Integer step;

    /**
     * 通风系数
     */
    private BigDecimal ventilationCoefficient;

    /**
     * 气象综合指数
     */
    private BigDecimal compositeIndex;

    /**
     * 露点差
     */
    private BigDecimal dewPointSpread;

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

    public BigDecimal getTemperature() {
        return temperature;
    }

    public void setTemperature(BigDecimal temperature) {
        this.temperature = temperature;
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

    public BigDecimal getBoundingLayer() {
        return boundingLayer;
    }

    public void setBoundingLayer(BigDecimal boundingLayer) {
        this.boundingLayer = boundingLayer;
    }

    public BigDecimal getPressure() {
        return pressure;
    }

    public void setPressure(BigDecimal pressure) {
        this.pressure = pressure;
    }

    public BigDecimal getHumidity() {
        return humidity;
    }

    public void setHumidity(BigDecimal humidity) {
        this.humidity = humidity;
    }

    public BigDecimal getRainfall() {
        return rainfall;
    }

    public void setRainfall(BigDecimal rainfall) {
        this.rainfall = rainfall;
    }

    public BigDecimal getRadiation() {
        return radiation;
    }

    public void setRadiation(BigDecimal radiation) {
        this.radiation = radiation;
    }

    public BigDecimal getCloudCover() {
        return cloudCover;
    }

    public void setCloudCover(BigDecimal cloudCover) {
        this.cloudCover = cloudCover;
    }

    public BigDecimal getVis() {
        return vis;
    }

    public void setVis(BigDecimal vis) {
        this.vis = vis;
    }

    public Integer getStep() {
        return step;
    }

    public void setStep(Integer step) {
        this.step = step;
    }

    public BigDecimal getVentilationCoefficient() {
        return ventilationCoefficient;
    }

    public void setVentilationCoefficient(BigDecimal ventilationCoefficient) {
        this.ventilationCoefficient = ventilationCoefficient;
    }

    public BigDecimal getCompositeIndex() {
        return compositeIndex;
    }

    public void setCompositeIndex(BigDecimal compositeIndex) {
        this.compositeIndex = compositeIndex;
    }

    public BigDecimal getDewPointSpread() {
        return dewPointSpread;
    }

    public void setDewPointSpread(BigDecimal dewPointSpread) {
        this.dewPointSpread = dewPointSpread;
    }
}

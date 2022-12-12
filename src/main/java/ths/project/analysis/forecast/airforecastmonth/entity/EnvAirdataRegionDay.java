package ths.project.analysis.forecast.airforecastmonth.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 监测数据_区域日报数据表(TEnvAirdataRegionDay)实体类
 *
 * @author hexd
 * @since 2021-04-12 14:13:12
 */
@TableName(value = "T_ENV_AIRDATA_REGION_DAY",schema ="TENVAIR" )
public class EnvAirdataRegionDay{
    /**
    * 监测时间
    */
    @TableField("MONITORTIME")
    private Date monitorTime;
    /**
    * 所属区域编码
    */
    private String codeRegion;
    /**
    * 所属区域名称
    */
    @TableField("regionname")
    private String regionName;
    /**
    * PM10浓度
    */
    private BigDecimal pm10;
    /**
    * SO2浓度
    */
    private BigDecimal so2;
    /**
    * NO2浓度
    */
    private BigDecimal no2;
    /**
    * PM2.5浓度
    */
    @TableField("PM2_5")
    private BigDecimal pm25;
    /**
    * O3浓度
    */
    private BigDecimal o3;
    /**
    * O3_8浓度
    */
    @TableField("O3_8")
    private BigDecimal o38;
    /**
    * CO浓度
    */
    private BigDecimal co;
    /**
    * AQI指标
    */
    private BigDecimal aqi;
    /**
    * 首要污染物
    */
    @TableField("primarypollutant")
    private String primaryPollutant;
    /**
    * PM10分指数
    */
    private BigDecimal ipm10;
    /**
    * SO2分指数
    */
    private BigDecimal iso2;
    /**
    * NO2分指数
    */
    private BigDecimal ino2;
    /**
    * PM2.5分指数
    */
    @TableField("IPM2_5")
    private BigDecimal ipm25;
    /**
    * O3分指数
    */
    private BigDecimal io3;
    /**
    * O3_8分指数
    */
    @TableField("IO3_8")
    private BigDecimal io38;
    /**
    * CO分指数
    */
    private BigDecimal ico;
    /**
    * AQI级别颜色
    */
    private String color;
    /**
    * AQI级别编码
    */
    @TableField("CODE_AQILEVEL")
    private String codeAqiLevel;
    /**
    * AQI级别名称
    */
    @TableField("AQILEVELNAME")
    private String aqiLevelName;
    /**
    * AQI级别编码2
    */
    @TableField("CODE_AQISTATION")
    private String codeAqiStation;
    /**
    * AQI级别名称2
    */
    @TableField("AQISTATIONNAME")
    private String aqiStationName;
    /**
    * 更新时间
    */
    @TableField("UPDATETIME")
    private Date updateTime;
    /**
    * 创建时间
    */

    private Date createTime;
    /**
    * 创建人
    */
    private String createUser;
    /**
    * 更新人
    */
    private String updateUser;
    /**
    * 删除标识符(0未删除，1已删除)
    */
    private Integer deleteFlag;


    public Date getMonitorTime() {
        return monitorTime;
    }

    public void setMonitorTime(Date monitorTime) {
        this.monitorTime = monitorTime;
    }

    public String getCodeRegion() {
        return codeRegion;
    }

    public void setCodeRegion(String codeRegion) {
        this.codeRegion = codeRegion;
    }

    public String getRegionName() {
        return regionName;
    }

    public void setRegionName(String regionName) {
        this.regionName = regionName;
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

    public BigDecimal getPm25() {
        return pm25;
    }

    public void setPm25(BigDecimal pm25) {
        this.pm25 = pm25;
    }

    public BigDecimal getO3() {
        return o3;
    }

    public void setO3(BigDecimal o3) {
        this.o3 = o3;
    }

    public BigDecimal getO38() {
        return o38;
    }

    public void setO38(BigDecimal o38) {
        this.o38 = o38;
    }

    public BigDecimal getCo() {
        return co;
    }

    public void setCo(BigDecimal co) {
        this.co = co;
    }

    public BigDecimal getAqi() {
        return aqi;
    }

    public void setAqi(BigDecimal aqi) {
        this.aqi = aqi;
    }

    public String getPrimaryPollutant() {
        return primaryPollutant;
    }

    public void setPrimaryPollutant(String primaryPollutant) {
        this.primaryPollutant = primaryPollutant;
    }

    public BigDecimal getIpm10() {
        return ipm10;
    }

    public void setIpm10(BigDecimal ipm10) {
        this.ipm10 = ipm10;
    }

    public BigDecimal getIso2() {
        return iso2;
    }

    public void setIso2(BigDecimal iso2) {
        this.iso2 = iso2;
    }

    public BigDecimal getIno2() {
        return ino2;
    }

    public void setIno2(BigDecimal ino2) {
        this.ino2 = ino2;
    }

    public BigDecimal getIpm25() {
        return ipm25;
    }

    public void setIpm25(BigDecimal ipm25) {
        this.ipm25 = ipm25;
    }

    public BigDecimal getIo3() {
        return io3;
    }

    public void setIo3(BigDecimal io3) {
        this.io3 = io3;
    }

    public BigDecimal getIo38() {
        return io38;
    }

    public void setIo38(BigDecimal io38) {
        this.io38 = io38;
    }

    public BigDecimal getIco() {
        return ico;
    }

    public void setIco(BigDecimal ico) {
        this.ico = ico;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getCodeAqiLevel() {
        return codeAqiLevel;
    }

    public void setCodeAqiLevel(String codeAqiLevel) {
        this.codeAqiLevel = codeAqiLevel;
    }

    public String getAqiLevelName() {
        return aqiLevelName;
    }

    public void setAqiLevelName(String aqiLevelName) {
        this.aqiLevelName = aqiLevelName;
    }

    public String getCodeAqiStation() {
        return codeAqiStation;
    }

    public void setCodeAqiStation(String codeAqiStation) {
        this.codeAqiStation = codeAqiStation;
    }

    public String getAqiStationName() {
        return aqiStationName;
    }

    public void setAqiStationName(String aqiStationName) {
        this.aqiStationName = aqiStationName;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public String getCreateUser() {
        return createUser;
    }

    public void setCreateUser(String createUser) {
        this.createUser = createUser;
    }

    public String getUpdateUser() {
        return updateUser;
    }

    public void setUpdateUser(String updateUser) {
        this.updateUser = updateUser;
    }

    public Integer getDeleteFlag() {
        return deleteFlag;
    }

    public void setDeleteFlag(Integer deleteFlag) {
        this.deleteFlag = deleteFlag;
    }

}
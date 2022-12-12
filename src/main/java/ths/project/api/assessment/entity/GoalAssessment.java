package ths.project.api.assessment.entity;

import java.math.BigDecimal;

/**
 * 目标考核实体类
 */
public class GoalAssessment {
    /**
     * 目标优良率
     */
    private BigDecimal goodRate;
    /**
     * 上期优良率
     */
    private Integer oldExcellentRate;
    /**
     * 实际优良率
     */
    private Integer excellentRate;
    /**
     * 优良率上升或者下降
     */
    private Integer goodRateRiseOrFall;
    /**
     * pm25目标值
     */
    private BigDecimal pm25Upper;
    /**
     * 实际pm25平均值
     */
    private BigDecimal pm25;

    /**
     * 上期pm25
     */
    private BigDecimal oldPm25;

    /**
     * o3目标值
     */
    private BigDecimal o3upper;
    /**
     * o3实际值
     */
    private BigDecimal o3;
    /**
     * 上期o3
     */
    private BigDecimal oldO3;

    /**
     * 同比上期上升
     */
    private BigDecimal pm25Rise;

    /**
     * 同比上期下降
     */
    private BigDecimal pm25Fall;


    /**
     * 同比上季度上升O3
     */
    private BigDecimal o3Rise;


    /**
     * 同比上季度上升O3
     */
    private BigDecimal o3Fall;

    /**
     * 监测时间
     * @return
     */

    private String monitorDate;

    public Integer getOldExcellentRate() {
        return oldExcellentRate;
    }

    public void setOldExcellentRate(Integer oldExcellentRate) {
        this.oldExcellentRate = oldExcellentRate;
    }

    public BigDecimal getO3Fall() {
        return o3Fall;
    }

    public void setO3Fall(BigDecimal o3Fall) {
        this.o3Fall = o3Fall;
    }

    public BigDecimal getGoodRate() {
        return goodRate;
    }

    public void setGoodRate(BigDecimal goodRate) {
        this.goodRate = goodRate;
    }

    public Integer getExcellentRate() {
        return excellentRate;
    }

    public void setExcellentRate(Integer excellentRate) {
        this.excellentRate = excellentRate;
    }

    public Integer getGoodRateRiseOrFall() {
        return goodRateRiseOrFall;
    }

    public void setGoodRateRiseOrFall(Integer goodRateRiseOrFall) {
        this.goodRateRiseOrFall = goodRateRiseOrFall;
    }

    public BigDecimal getPm25Upper() {
        return pm25Upper;
    }

    public void setPm25Upper(BigDecimal pm25Upper) {
        this.pm25Upper = pm25Upper;
    }

    public BigDecimal getPm25() {
        return pm25;
    }

    public void setPm25(BigDecimal pm25) {
        this.pm25 = pm25;
    }

    public BigDecimal getOldPm25() {
        return oldPm25;
    }

    public void setOldPm25(BigDecimal oldPm25) {
        this.oldPm25 = oldPm25;
    }

    public BigDecimal getO3upper() {
        return o3upper;
    }

    public void setO3upper(BigDecimal o3upper) {
        this.o3upper = o3upper;
    }

    public BigDecimal getO3() {
        return o3;
    }

    public void setO3(BigDecimal o3) {
        this.o3 = o3;
    }

    public BigDecimal getOldO3() {
        return oldO3;
    }

    public void setOldO3(BigDecimal oldO3) {
        this.oldO3 = oldO3;
    }

    public BigDecimal getPm25Rise() {
        return pm25Rise;
    }

    public void setPm25Rise(BigDecimal pm25Rise) {
        this.pm25Rise = pm25Rise;
    }

    public BigDecimal getPm25Fall() {
        return pm25Fall;
    }

    public void setPm25Fall(BigDecimal pm25Fall) {
        this.pm25Fall = pm25Fall;
    }

    public BigDecimal getO3Rise() {
        return o3Rise;
    }

    public void setO3Rise(BigDecimal o3Rise) {
        this.o3Rise = o3Rise;
    }

    public String getMonitorDate() {
        return monitorDate;
    }

    public void setMonitorDate(String monitorDate) {
        this.monitorDate = monitorDate;
    }
}

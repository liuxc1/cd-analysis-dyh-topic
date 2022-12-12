package ths.project.api.env_emergency.vo;

public class RiskSourceStatisticalVo {

    /**
     * 风险源总数
     */
    private Integer riskTotal;

    /**
     * 一般
     */
    private Integer riskNormal;

    /**
     * 较大
     */
    private Integer riskMore;

    /**
     * 重大
     */
    private Integer riskMajor;

    /**
     * 特别重大
     */
    private Integer riskMaxMajor;

    /**
     * 未定义
     */
    private Integer riskOther;

    /**
     * 水敏感点
     */
    private Integer water;

    /**
     * 气敏感点
     */
    private Integer air;

    public RiskSourceStatisticalVo() {
    }

    public Integer getRiskTotal() {
        return riskTotal;
    }

    public void setRiskTotal(Integer riskTotal) {
        this.riskTotal = riskTotal;
    }

    public Integer getRiskNormal() {
        return riskNormal;
    }

    public void setRiskNormal(Integer riskNormal) {
        this.riskNormal = riskNormal;
    }

    public Integer getRiskMore() {
        return riskMore;
    }

    public void setRiskMore(Integer riskMore) {
        this.riskMore = riskMore;
    }

    public Integer getRiskMajor() {
        return riskMajor;
    }

    public void setRiskMajor(Integer riskMajor) {
        this.riskMajor = riskMajor;
    }

    public Integer getRiskMaxMajor() {
        return riskMaxMajor;
    }

    public void setRiskMaxMajor(Integer riskMaxMajor) {
        this.riskMaxMajor = riskMaxMajor;
    }

    public Integer getRiskOther() {
        return riskOther;
    }

    public void setRiskOther(Integer riskOther) {
        this.riskOther = riskOther;
    }

    public Integer getWater() {
        return water;
    }

    public void setWater(Integer water) {
        this.water = water;
    }

    public Integer getAir() {
        return air;
    }

    public void setAir(Integer air) {
        this.air = air;
    }

    public RiskSourceStatisticalVo(Integer riskTotal, Integer riskNormal, Integer riskMore, Integer riskMajor, Integer riskMaxMajor, Integer riskOther, Integer water, Integer air) {
        this.riskTotal = riskTotal;
        this.riskNormal = riskNormal;
        this.riskMore = riskMore;
        this.riskMajor = riskMajor;
        this.riskMaxMajor = riskMaxMajor;
        this.riskOther = riskOther;
        this.water = water;
        this.air = air;
    }
}

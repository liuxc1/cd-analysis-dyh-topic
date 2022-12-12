package ths.project.api.rankingEvaluation.entity;


public class RankingEvaluation {
    /**
     * 排名范围
     */
    private String regionName;
    /**
     * 综合指数
     */
    private float compositeIndex;
    /**
     * 综合指数上升或者下降
     */
    private float compositeIndexL;
    /**
     * PM2.5
     */
    private float pm25;
    /**
     * PM10
     */
    private float pm10;
    /**
     * SO2
     */
    private float so2;
    /**
     * NO2
     */
    private float no2;
    /**
     * O3
     */
    private float o3;
    /**
     * CO
     */
    private float co;

    /**
     * pm25上升或者下降
     */
    private float pm25L;

    /**
     * pm10上升或者下降
     */
    private float pm10L;

    /**
     * so2 上升或者下降
     */
    private float so2L;

    /**
     * no2 上升或者下降
     */
    private float no2L;

    /**
     * o3 上升或者下降
     */
    private float o3L;

    /**
     * co 上升或者下降
     */
    private float coL;

    public String getRegionName() {
        return regionName;
    }

    public void setRegionName(String regionName) {
        this.regionName = regionName;
    }

    public float getCompositeIndex() {
        return compositeIndex;
    }

    public void setCompositeIndex(float compositeIndex) {
        this.compositeIndex = compositeIndex;
    }

    public float getCompositeIndexL() {
        return compositeIndexL;
    }

    public void setCompositeIndexL(float compositeIndexL) {
        this.compositeIndexL = compositeIndexL;
    }

    public float getPm25() {
        return pm25;
    }

    public void setPm25(float pm25) {
        this.pm25 = pm25;
    }

    public float getPm10() {
        return pm10;
    }

    public void setPm10(float pm10) {
        this.pm10 = pm10;
    }

    public float getSo2() {
        return so2;
    }

    public void setSo2(float so2) {
        this.so2 = so2;
    }

    public float getNo2() {
        return no2;
    }

    public void setNo2(float no2) {
        this.no2 = no2;
    }

    public float getO3() {
        return o3;
    }

    public void setO3(float o3) {
        this.o3 = o3;
    }

    public float getCo() {
        return co;
    }

    public void setCo(float co) {
        this.co = co;
    }

    public float getPm25L() {
        return pm25L;
    }

    public void setPm25L(float pm25L) {
        this.pm25L = pm25L;
    }

    public float getPm10L() {
        return pm10L;
    }

    public void setPm10L(float pm10L) {
        this.pm10L = pm10L;
    }

    public float getSo2L() {
        return so2L;
    }

    public void setSo2L(float so2L) {
        this.so2L = so2L;
    }

    public float getNo2L() {
        return no2L;
    }

    public void setNo2L(float no2L) {
        this.no2L = no2L;
    }

    public float getO3L() {
        return o3L;
    }

    public void setO3L(float o3L) {
        this.o3L = o3L;
    }

    public float getCoL() {
        return coL;
    }

    public void setCoL(float coL) {
        this.coL = coL;
    }
}

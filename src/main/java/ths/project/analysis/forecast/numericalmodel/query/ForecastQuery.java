package ths.project.analysis.forecast.numericalmodel.query;

import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

/**
 * @author lx
 * @date 2021年06月18日 13:21
 */
public class ForecastQuery {
    /**
     * 查询开始时间
     */
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "GMT+8")
    private Date startTime;
    /**
     * 查询结束时间
     */
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "GMT+8")
    private Date endTime;
    /**
     * 行政区编码
     */
    private String regionCode;
    /**
     * 站点编码
     */
    private String pointCode;
    /**
     * 模式
     */
    private String model;
    /**
     * 查询类型 zero:0时，twelve：12时
     */
    private String queryType;

    /**
     * 查询城市数量
     */
    private Integer cityNums;

    /**
     * 预报时长
     */
    private Integer step;    /**
     * 预报时长
     */
    private Integer startStep;

    /**
     * 模型时间
     */
    private String modelTime;
    /**
     * 上一天模型时间
     */
    private String oldModelTime;
    /**
     * PM25组分 展示类型(heap:堆积，percent：百分堆积)
     */
    private String showType;
    /**
     * 风速风向 数据类型（hour,day）
     */
    private String dataType;
    /**
     * 气象元素类型下标（0-10小数数据，10风速风向，11逆温，12水汽分布，13气象多要素）
     */
    private String targetIndex;
    /**
     * 导出excel名称
     */
    private String excelName;

    /**
     * 1：预评估；2：后评估
     * @return
     */
    private String assessType;

    /**
     * 污染物
     */
    private String pollutant;


    public String getAssessType() {
        return assessType;
    }

    public void setAssessType(String assessType) {
        this.assessType = assessType;
    }

    public String getQueryType() {
        return queryType;
    }

    public void setQueryType(String queryType) {
        this.queryType = queryType;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public Integer getStep() {
        return step;
    }

    public void setStep(Integer step) {
        this.step = step;
    }

    public Date getStartTime() {
        return startTime;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public Date getEndTime() {
        return endTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    public String getRegionCode() {
        return regionCode;
    }

    public void setRegionCode(String regionCode) {
        this.regionCode = regionCode;
    }

    public String getPointCode() {
        return pointCode;
    }

    public void setPointCode(String pointCode) {
        this.pointCode = pointCode;
    }

    public String getModelTime() {
        return modelTime;
    }

    public void setModelTime(String modelTime) {
        this.modelTime = modelTime;
    }

    public String getOldModelTime() {
        return oldModelTime;
    }

    public void setOldModelTime(String oldModelTime) {
        this.oldModelTime = oldModelTime;
    }

    public String getExcelName() {
        return excelName;
    }

    public void setExcelName(String excelName) {
        this.excelName = excelName;
    }

    public String getShowType() {
        return showType;
    }

    public void setShowType(String showType) {
        this.showType = showType;
    }

    public String getDataType() {
        return dataType;
    }

    public void setDataType(String dataType) {
        this.dataType = dataType;
    }

    public String getTargetIndex() {
        return targetIndex;
    }

    public void setTargetIndex(String targetIndex) {
        this.targetIndex = targetIndex;
    }

    public Integer getCityNums() {
        return cityNums;
    }

    public void setCityNums(Integer cityNums) {
        this.cityNums = cityNums;
    }



    public Integer getStartStep() {
        return startStep;
    }

    public void setStartStep(Integer startStep) {
        this.startStep = startStep;
    }

    public String getPollutant() {
        return pollutant;
    }

    public void setPollutant(String pollutant) {
        this.pollutant = pollutant;
    }
}

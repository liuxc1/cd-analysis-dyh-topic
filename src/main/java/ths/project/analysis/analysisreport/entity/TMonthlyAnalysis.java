package ths.project.analysis.analysisreport.entity;


import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.format.annotation.DateTimeFormat;
import ths.project.common.entity.BaseEntity;

import java.util.Date;

/**
 * 月数据实体类
 */
@TableName(value = "T_MONTHLY_ANALYSIS", schema = "AIR_ANALYSISREPORT")
public class TMonthlyAnalysis extends BaseEntity {
    /**
     * 主键id
     */
    @TableId
    private String reportId;
    /**
     * 图片类型1
     */
    private String ascriptionType;
    /**
     * 图片类型2
     */
    private String ascriptionTypeTwo;
    /**
     * 图片类型3
     */
    private String ascriptionTypeThree;
    /**
     * 图片类型4
     */
    private String ascriptionTypeFour;
    /**
     * 图片类型5
     */
    private String ascriptionTypeFive;
    /**
     * 图片类型6
     */
    private String ascriptionTypeSix;
    /**
     * 图片类型7
     */
    private String ascriptionTypeSeven;
    /**
     * 报告批次号
     */
    private String reportBatch;
    /**
     * 报告名称
     */
    private String reportName;
    /**
     * 报告日期
     */
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "GMT+8")
    private Date reportTime;
    /**
     * 报告频率
     */
    private String reportRate;
    /**
     * 报告所在频度(如：第1周)
     */
    private String reportFrequency;
    /**
     * 报告类型
     */
    private String reportType;
    /**
     * 重要提示
     */
    private String reportTip;
    /**
     * 备注
     */
    private String remark;
    /**
     * 落款
     */
    private String reportInscribe;
    /**
     * 状态
     */
    private String state;
    /**
     * 是否为主要提交预报
     */
    private Integer isMain;
    /**
     * 报告人code
     */
    private String reportUserCode;
    /**
     * 报告人
     */
    private String reportUserName;
    /**
     * 实验室观测数据质量分析生成内容
     */
    private String generateContentQuality;
    /**
     * 实验室观测数据质量分析编辑内容
     */
    private String editContentQuality;
    /**
     * 污染过程分析生成内容
     */
    private String generateContentAnalysis;
    /**
     * 污染过程分析编辑内容
     */
    private String editContentAnalysis;
    /**
     * 静稳高湿加快二次组分转化进一步推高颗粒物浓度生成内容
     */
    private String generateContentConcentration;
    /**
     * 静稳高湿加快二次组分转化进一步推高颗粒物浓度编辑内容
     */
    private String editContentConcentration;
    /**
     * 排放体量偏大，以移动源与溶剂源影响为主生成内容
     */
    private String generateContentSolvent;
    /**
     * 排放体量偏大，以移动源与溶剂源影响为主编辑内容
     */
    private String editContentSolvent;
    /**
     * 小结生成内容
     */
    private String generateContentSummary;
    /**
     * 小结编辑内容
     */
    private String editContentSummary;
    /**
     * 默认数据
     */
    private String defaultDate;
    /**
     * 编辑时间
     */
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "GMT+8")
    private Date editTime;
    /**
     * 编辑人
     */
    private String editUser;
    /**
     * 图片id
     */
    private String imageId;

    //实验室观测数据质量分析
    /**
     * 状态(良好、一般、较差)
     */
    private String qualityState;
    /**
     * 实验室观测数据质量百分比
     */
    private String qualityPercentage;

    //污染过程分析
    /**
     * 污染时间范围
     */
    private String analysisTimeLimit;
    /**
     * 污染季(春、夏、秋、东)
     */
    private String analysisSeasons;
    /**
     * 时间范围内的优良时间
     */
    private String analysisGoodSky;
    /**
     * 优或者良
     */
    private String analysisExcellent;
    /**
     * 轻度污染时间范围
     */
    private String analysisLightPollutionTimeRange;
    /**
     * 轻度污染天数
     */
    private String analysisDaysWithLightPollution;
    /**
     * 轻度污染
     */
    private String analysisLightPollution;
    /**
     * 中度污染时间范围
     */
    private String analysisModeratePollutionTimeRange;
    /**
     * 中度污染
     */
    private String analysisModeratelyPolluted;
    /**
     * 重度污染时间范围
     */
    private String analysisSeverePollutionTimeRange;
    /**
     * 重度污染
     */
    private String analysisHeavyPollution;
    /**
     * 污染结束时间
     */
    private String analysisContaminationEndTime;


    //（1）静稳高湿加快二次组分转化进一步推高颗粒物浓度
    /**
     * 静稳高湿的气象条件
     */
    private String concentrationWeatherCondition;
    /**
     * 污染等级(重度污染，中度污染，轻度污染)
     */
    private String concentrationPollutionLevel;
    /**
     * 后期时间范围
     */
    private String concentrationLateTimeRange;
    /**
     * 前期时间范围
     */
    private String concentrationEarlyTimeRange;
    /**
     * 连续时间
     */
    private String concentrationContinuousTime;
    /**
     * 指数
     */
    private String concentrationIndex;
    /**
     * 原因
     */
    private String concentrationReason;
    /**
     * 污染等级
     */
    private String concentrationPollution;
    /**
     * 污染等级+（由某个污染等级->另一个污染等级）
     */
    private String concentrationPollutionPlus;
    /**
     * NOR浓度
     */
    private String concentrationNor;
    /**
     * SOR浓度
     */
    private String concentrationSor;
    /**
     * 占比（百分比）
     */
    private String concentrationPercentage;


    //（2）排放体量偏大，以移动源与溶剂源影响为主
    /**
     * NO平均浓度
     */
    private String solventNo;
    /**
     * NO上升浓度
     */
    private String solventNoRise;
    /**
     * VOCS平均浓度
     */
    private String solventVocs;
    /**
     * VOCS上升浓度
     */
    private String solventVocsRise;
    /**
     * VOC上升元素
     */
    private String solventVoc;
    /**
     * 影响原因1
     */
    private String solventCauseOfImpactOne;
    /**
     * 影响原因2
     */
    private String solventCauseOfImpactTwo;
    /**
     * SO2上升比例
     */
    private String solventSo2RisePercentage;
    /**
     * 颗粒物浓度升高元素
     */
    private String solventElement;
    /**
     * 污染源影响
     */
    private String solventInfluence;


    //小结
    /**
     * 时间范围
     */
    private String summaryTimeLimit;
    /**
     * 季节（春、夏、秋、东）
     */
    private String summarySeason;

    //第一段模板
    /**
     * 优良天数
     */
    private Integer excellentandGood;
    /**
     * 优秀天数
     */
    private Integer excellent;
    /**
     * 良天数
     */
    private Integer good;
    /**
     * 优良天数比例
     */
    private String correctRate;
    /**
     * 污染天数
     */
    private Integer contaminationDays;
    /**
     * 轻度污染
     */
    private Integer lightPollution;
    /**
     * 中度污染
     */
    private Integer moderatelyPolluted;
    /**
     * 重度污染
     */
    private Integer heavyPollution;
    /**
     * 这个月六项污染物 PM10 PM25 NO2 SO2 O3 CO
     */
    private Double pm10;
    private Double pm25;
    private Double no2;
    private Double so2;
    private Double o3;
    private Double co;
    /**
     * 与去年同期相比（上升或下降比例，百分比值）
     */
    private String pm10RiseOrDecline;
    private String pm10Percentage;
    private String pm25RiseOrDecline;
    private String pm25Percentage;
    private String no2RiseOrDecline;
    private String no2Percentage;
    private String so2RiseOrDecline;
    private String so2Percentage;
    private String o38RiseOrDecline;
    private String o38Percentage;
    private String coRiseOrDecline;
    private String coPercentage;

    /**
     * 首要污染物 PRIMARY_POLLUTANT
     */
    private String primaryPollutant;

    /**
     * 默认数据
     */
    private String defaultData;

    public TMonthlyAnalysis() {
    }

    public String getDefaultData() {
        return defaultData;
    }

    public void setDefaultData(String defaultData) {
        this.defaultData = defaultData;
    }

    public String getReportId() {
        return reportId;
    }

    public void setReportId(String reportId) {
        this.reportId = reportId;
    }

    public String getAscriptionType() {
        return ascriptionType;
    }

    public void setAscriptionType(String ascriptionType) {
        this.ascriptionType = ascriptionType;
    }

    public String getAscriptionTypeTwo() {
        return ascriptionTypeTwo;
    }

    public void setAscriptionTypeTwo(String ascriptionTypeTwo) {
        this.ascriptionTypeTwo = ascriptionTypeTwo;
    }

    public String getAscriptionTypeThree() {
        return ascriptionTypeThree;
    }

    public void setAscriptionTypeThree(String ascriptionTypeThree) {
        this.ascriptionTypeThree = ascriptionTypeThree;
    }

    public String getAscriptionTypeFour() {
        return ascriptionTypeFour;
    }

    public void setAscriptionTypeFour(String ascriptionTypeFour) {
        this.ascriptionTypeFour = ascriptionTypeFour;
    }

    public String getAscriptionTypeFive() {
        return ascriptionTypeFive;
    }

    public void setAscriptionTypeFive(String ascriptionTypeFive) {
        this.ascriptionTypeFive = ascriptionTypeFive;
    }

    public String getAscriptionTypeSix() {
        return ascriptionTypeSix;
    }

    public void setAscriptionTypeSix(String ascriptionTypeSix) {
        this.ascriptionTypeSix = ascriptionTypeSix;
    }

    public String getAscriptionTypeSeven() {
        return ascriptionTypeSeven;
    }

    public void setAscriptionTypeSeven(String ascriptionTypeSeven) {
        this.ascriptionTypeSeven = ascriptionTypeSeven;
    }

    public String getReportBatch() {
        return reportBatch;
    }

    public void setReportBatch(String reportBatch) {
        this.reportBatch = reportBatch;
    }

    public String getReportName() {
        return reportName;
    }

    public void setReportName(String reportName) {
        this.reportName = reportName;
    }

    public Date getReportTime() {
        return reportTime;
    }

    public void setReportTime(Date reportTime) {
        this.reportTime = reportTime;
    }

    public String getReportRate() {
        return reportRate;
    }

    public void setReportRate(String reportRate) {
        this.reportRate = reportRate;
    }

    public String getReportFrequency() {
        return reportFrequency;
    }

    public void setReportFrequency(String reportFrequency) {
        this.reportFrequency = reportFrequency;
    }

    public String getReportType() {
        return reportType;
    }

    public void setReportType(String reportType) {
        this.reportType = reportType;
    }

    public String getReportTip() {
        return reportTip;
    }

    public void setReportTip(String reportTip) {
        this.reportTip = reportTip;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public String getReportInscribe() {
        return reportInscribe;
    }

    public void setReportInscribe(String reportInscribe) {
        this.reportInscribe = reportInscribe;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public Integer getIsMain() {
        return isMain;
    }

    public void setIsMain(Integer isMain) {
        this.isMain = isMain;
    }

    public String getReportUserCode() {
        return reportUserCode;
    }

    public void setReportUserCode(String reportUserCode) {
        this.reportUserCode = reportUserCode;
    }

    public String getReportUserName() {
        return reportUserName;
    }

    public void setReportUserName(String reportUserName) {
        this.reportUserName = reportUserName;
    }

    public String getGenerateContentQuality() {
        return generateContentQuality;
    }

    public void setGenerateContentQuality(String generateContentQuality) {
        this.generateContentQuality = generateContentQuality;
    }

    public String getEditContentQuality() {
        return editContentQuality;
    }

    public void setEditContentQuality(String editContentQuality) {
        this.editContentQuality = editContentQuality;
    }

    public String getGenerateContentAnalysis() {
        return generateContentAnalysis;
    }

    public void setGenerateContentAnalysis(String generateContentAnalysis) {
        this.generateContentAnalysis = generateContentAnalysis;
    }

    public String getEditContentAnalysis() {
        return editContentAnalysis;
    }

    public void setEditContentAnalysis(String editContentAnalysis) {
        this.editContentAnalysis = editContentAnalysis;
    }

    public String getGenerateContentConcentration() {
        return generateContentConcentration;
    }

    public void setGenerateContentConcentration(String generateContentConcentration) {
        this.generateContentConcentration = generateContentConcentration;
    }

    public String getEditContentConcentration() {
        return editContentConcentration;
    }

    public void setEditContentConcentration(String editContentConcentration) {
        this.editContentConcentration = editContentConcentration;
    }

    public String getGenerateContentSolvent() {
        return generateContentSolvent;
    }

    public void setGenerateContentSolvent(String generateContentSolvent) {
        this.generateContentSolvent = generateContentSolvent;
    }

    public String getEditContentSolvent() {
        return editContentSolvent;
    }

    public void setEditContentSolvent(String editContentSolvent) {
        this.editContentSolvent = editContentSolvent;
    }

    public String getGenerateContentSummary() {
        return generateContentSummary;
    }

    public void setGenerateContentSummary(String generateContentSummary) {
        this.generateContentSummary = generateContentSummary;
    }

    public String getEditContentSummary() {
        return editContentSummary;
    }

    public void setEditContentSummary(String editContentSummary) {
        this.editContentSummary = editContentSummary;
    }

    public String getDefaultDate() {
        return defaultDate;
    }

    public void setDefaultDate(String defaultDate) {
        this.defaultDate = defaultDate;
    }

    public Date getEditTime() {
        return editTime;
    }

    public void setEditTime(Date editTime) {
        this.editTime = editTime;
    }

    public String getEditUser() {
        return editUser;
    }

    public void setEditUser(String editUser) {
        this.editUser = editUser;
    }

    public String getImageId() {
        return imageId;
    }

    public void setImageId(String imageId) {
        this.imageId = imageId;
    }

    public String getQualityState() {
        return qualityState;
    }

    public void setQualityState(String qualityState) {
        this.qualityState = qualityState;
    }

    public String getQualityPercentage() {
        return qualityPercentage;
    }

    public void setQualityPercentage(String qualityPercentage) {
        this.qualityPercentage = qualityPercentage;
    }

    public String getAnalysisTimeLimit() {
        return analysisTimeLimit;
    }

    public void setAnalysisTimeLimit(String analysisTimeLimit) {
        this.analysisTimeLimit = analysisTimeLimit;
    }

    public String getAnalysisSeasons() {
        return analysisSeasons;
    }

    public void setAnalysisSeasons(String analysisSeasons) {
        this.analysisSeasons = analysisSeasons;
    }

    public String getAnalysisGoodSky() {
        return analysisGoodSky;
    }

    public void setAnalysisGoodSky(String analysisGoodSky) {
        this.analysisGoodSky = analysisGoodSky;
    }

    public String getAnalysisExcellent() {
        return analysisExcellent;
    }

    public void setAnalysisExcellent(String analysisExcellent) {
        this.analysisExcellent = analysisExcellent;
    }

    public String getAnalysisLightPollutionTimeRange() {
        return analysisLightPollutionTimeRange;
    }

    public void setAnalysisLightPollutionTimeRange(String analysisLightPollutionTimeRange) {
        this.analysisLightPollutionTimeRange = analysisLightPollutionTimeRange;
    }

    public String getAnalysisDaysWithLightPollution() {
        return analysisDaysWithLightPollution;
    }

    public void setAnalysisDaysWithLightPollution(String analysisDaysWithLightPollution) {
        this.analysisDaysWithLightPollution = analysisDaysWithLightPollution;
    }

    public String getAnalysisLightPollution() {
        return analysisLightPollution;
    }

    public void setAnalysisLightPollution(String analysisLightPollution) {
        this.analysisLightPollution = analysisLightPollution;
    }

    public String getAnalysisModeratePollutionTimeRange() {
        return analysisModeratePollutionTimeRange;
    }

    public void setAnalysisModeratePollutionTimeRange(String analysisModeratePollutionTimeRange) {
        this.analysisModeratePollutionTimeRange = analysisModeratePollutionTimeRange;
    }

    public String getAnalysisModeratelyPolluted() {
        return analysisModeratelyPolluted;
    }

    public void setAnalysisModeratelyPolluted(String analysisModeratelyPolluted) {
        this.analysisModeratelyPolluted = analysisModeratelyPolluted;
    }

    public String getAnalysisSeverePollutionTimeRange() {
        return analysisSeverePollutionTimeRange;
    }

    public void setAnalysisSeverePollutionTimeRange(String analysisSeverePollutionTimeRange) {
        this.analysisSeverePollutionTimeRange = analysisSeverePollutionTimeRange;
    }

    public String getAnalysisHeavyPollution() {
        return analysisHeavyPollution;
    }

    public void setAnalysisHeavyPollution(String analysisHeavyPollution) {
        this.analysisHeavyPollution = analysisHeavyPollution;
    }

    public String getAnalysisContaminationEndTime() {
        return analysisContaminationEndTime;
    }

    public void setAnalysisContaminationEndTime(String analysisContaminationEndTime) {
        this.analysisContaminationEndTime = analysisContaminationEndTime;
    }

    public String getConcentrationWeatherCondition() {
        return concentrationWeatherCondition;
    }

    public void setConcentrationWeatherCondition(String concentrationWeatherCondition) {
        this.concentrationWeatherCondition = concentrationWeatherCondition;
    }

    public String getConcentrationPollutionLevel() {
        return concentrationPollutionLevel;
    }

    public void setConcentrationPollutionLevel(String concentrationPollutionLevel) {
        this.concentrationPollutionLevel = concentrationPollutionLevel;
    }

    public String getConcentrationLateTimeRange() {
        return concentrationLateTimeRange;
    }

    public void setConcentrationLateTimeRange(String concentrationLateTimeRange) {
        this.concentrationLateTimeRange = concentrationLateTimeRange;
    }

    public String getConcentrationEarlyTimeRange() {
        return concentrationEarlyTimeRange;
    }

    public void setConcentrationEarlyTimeRange(String concentrationEarlyTimeRange) {
        this.concentrationEarlyTimeRange = concentrationEarlyTimeRange;
    }

    public String getConcentrationContinuousTime() {
        return concentrationContinuousTime;
    }

    public void setConcentrationContinuousTime(String concentrationContinuousTime) {
        this.concentrationContinuousTime = concentrationContinuousTime;
    }

    public String getConcentrationIndex() {
        return concentrationIndex;
    }

    public void setConcentrationIndex(String concentrationIndex) {
        this.concentrationIndex = concentrationIndex;
    }

    public String getConcentrationReason() {
        return concentrationReason;
    }

    public void setConcentrationReason(String concentrationReason) {
        this.concentrationReason = concentrationReason;
    }

    public String getConcentrationPollution() {
        return concentrationPollution;
    }

    public void setConcentrationPollution(String concentrationPollution) {
        this.concentrationPollution = concentrationPollution;
    }

    public String getConcentrationPollutionPlus() {
        return concentrationPollutionPlus;
    }

    public void setConcentrationPollutionPlus(String concentrationPollutionPlus) {
        this.concentrationPollutionPlus = concentrationPollutionPlus;
    }

    public String getConcentrationNor() {
        return concentrationNor;
    }

    public void setConcentrationNor(String concentrationNor) {
        this.concentrationNor = concentrationNor;
    }

    public String getConcentrationSor() {
        return concentrationSor;
    }

    public void setConcentrationSor(String concentrationSor) {
        this.concentrationSor = concentrationSor;
    }

    public String getConcentrationPercentage() {
        return concentrationPercentage;
    }

    public void setConcentrationPercentage(String concentrationPercentage) {
        this.concentrationPercentage = concentrationPercentage;
    }

    public String getSolventNo() {
        return solventNo;
    }

    public void setSolventNo(String solventNo) {
        this.solventNo = solventNo;
    }

    public String getSolventNoRise() {
        return solventNoRise;
    }

    public void setSolventNoRise(String solventNoRise) {
        this.solventNoRise = solventNoRise;
    }

    public String getSolventVocs() {
        return solventVocs;
    }

    public void setSolventVocs(String solventVocs) {
        this.solventVocs = solventVocs;
    }

    public String getSolventVocsRise() {
        return solventVocsRise;
    }

    public void setSolventVocsRise(String solventVocsRise) {
        this.solventVocsRise = solventVocsRise;
    }

    public String getSolventVoc() {
        return solventVoc;
    }

    public void setSolventVoc(String solventVoc) {
        this.solventVoc = solventVoc;
    }

    public String getSolventCauseOfImpactOne() {
        return solventCauseOfImpactOne;
    }

    public void setSolventCauseOfImpactOne(String solventCauseOfImpactOne) {
        this.solventCauseOfImpactOne = solventCauseOfImpactOne;
    }

    public String getSolventCauseOfImpactTwo() {
        return solventCauseOfImpactTwo;
    }

    public void setSolventCauseOfImpactTwo(String solventCauseOfImpactTwo) {
        this.solventCauseOfImpactTwo = solventCauseOfImpactTwo;
    }

    public String getSolventSo2RisePercentage() {
        return solventSo2RisePercentage;
    }

    public void setSolventSo2RisePercentage(String solventSo2RisePercentage) {
        this.solventSo2RisePercentage = solventSo2RisePercentage;
    }

    public String getSolventElement() {
        return solventElement;
    }

    public void setSolventElement(String solventElement) {
        this.solventElement = solventElement;
    }

    public String getSolventInfluence() {
        return solventInfluence;
    }

    public void setSolventInfluence(String solventInfluence) {
        this.solventInfluence = solventInfluence;
    }

    public String getSummaryTimeLimit() {
        return summaryTimeLimit;
    }

    public void setSummaryTimeLimit(String summaryTimeLimit) {
        this.summaryTimeLimit = summaryTimeLimit;
    }

    public String getSummarySeason() {
        return summarySeason;
    }

    public void setSummarySeason(String summarySeason) {
        this.summarySeason = summarySeason;
    }

    public Integer getExcellentandGood() {
        return excellentandGood;
    }

    public void setExcellentandGood(Integer excellentandGood) {
        this.excellentandGood = excellentandGood;
    }

    public Integer getExcellent() {
        return excellent;
    }

    public void setExcellent(Integer excellent) {
        this.excellent = excellent;
    }

    public Integer getGood() {
        return good;
    }

    public void setGood(Integer good) {
        this.good = good;
    }

    public String getCorrectRate() {
        return correctRate;
    }

    public void setCorrectRate(String correctRate) {
        this.correctRate = correctRate;
    }

    public Integer getContaminationDays() {
        return contaminationDays;
    }

    public void setContaminationDays(Integer contaminationDays) {
        this.contaminationDays = contaminationDays;
    }

    public Integer getLightPollution() {
        return lightPollution;
    }

    public void setLightPollution(Integer lightPollution) {
        this.lightPollution = lightPollution;
    }

    public Integer getModeratelyPolluted() {
        return moderatelyPolluted;
    }

    public void setModeratelyPolluted(Integer moderatelyPolluted) {
        this.moderatelyPolluted = moderatelyPolluted;
    }

    public Integer getHeavyPollution() {
        return heavyPollution;
    }

    public void setHeavyPollution(Integer heavyPollution) {
        this.heavyPollution = heavyPollution;
    }

    public Double getPm10() {
        return pm10;
    }

    public void setPm10(Double pm10) {
        this.pm10 = pm10;
    }

    public Double getPm25() {
        return pm25;
    }

    public void setPm25(Double pm25) {
        this.pm25 = pm25;
    }

    public Double getNo2() {
        return no2;
    }

    public void setNo2(Double no2) {
        this.no2 = no2;
    }

    public Double getSo2() {
        return so2;
    }

    public void setSo2(Double so2) {
        this.so2 = so2;
    }

    public Double getO3() {
        return o3;
    }

    public void setO3(Double o3) {
        this.o3 = o3;
    }

    public Double getCo() {
        return co;
    }

    public void setCo(Double co) {
        this.co = co;
    }

    public String getPm10RiseOrDecline() {
        return pm10RiseOrDecline;
    }

    public void setPm10RiseOrDecline(String pm10RiseOrDecline) {
        this.pm10RiseOrDecline = pm10RiseOrDecline;
    }

    public String getPm10Percentage() {
        return pm10Percentage;
    }

    public void setPm10Percentage(String pm10Percentage) {
        this.pm10Percentage = pm10Percentage;
    }

    public String getPm25RiseOrDecline() {
        return pm25RiseOrDecline;
    }

    public void setPm25RiseOrDecline(String pm25RiseOrDecline) {
        this.pm25RiseOrDecline = pm25RiseOrDecline;
    }

    public String getPm25Percentage() {
        return pm25Percentage;
    }

    public void setPm25Percentage(String pm25Percentage) {
        this.pm25Percentage = pm25Percentage;
    }

    public String getNo2RiseOrDecline() {
        return no2RiseOrDecline;
    }

    public void setNo2RiseOrDecline(String no2RiseOrDecline) {
        this.no2RiseOrDecline = no2RiseOrDecline;
    }

    public String getNo2Percentage() {
        return no2Percentage;
    }

    public void setNo2Percentage(String no2Percentage) {
        this.no2Percentage = no2Percentage;
    }

    public String getSo2RiseOrDecline() {
        return so2RiseOrDecline;
    }

    public void setSo2RiseOrDecline(String so2RiseOrDecline) {
        this.so2RiseOrDecline = so2RiseOrDecline;
    }

    public String getSo2Percentage() {
        return so2Percentage;
    }

    public void setSo2Percentage(String so2Percentage) {
        this.so2Percentage = so2Percentage;
    }

    public String getO38RiseOrDecline() {
        return o38RiseOrDecline;
    }

    public void setO38RiseOrDecline(String o38RiseOrDecline) {
        this.o38RiseOrDecline = o38RiseOrDecline;
    }

    public String getO38Percentage() {
        return o38Percentage;
    }

    public void setO38Percentage(String o38Percentage) {
        this.o38Percentage = o38Percentage;
    }

    public String getCoRiseOrDecline() {
        return coRiseOrDecline;
    }

    public void setCoRiseOrDecline(String coRiseOrDecline) {
        this.coRiseOrDecline = coRiseOrDecline;
    }

    public String getCoPercentage() {
        return coPercentage;
    }

    public void setCoPercentage(String coPercentage) {
        this.coPercentage = coPercentage;
    }

    public String getPrimaryPollutant() {
        return primaryPollutant;
    }

    public void setPrimaryPollutant(String primaryPollutant) {
        this.primaryPollutant = primaryPollutant;
    }
}

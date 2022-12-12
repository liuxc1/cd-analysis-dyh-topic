package ths.project.analysis.analysisreport.entity;


import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.format.annotation.DateTimeFormat;
import ths.project.common.entity.BaseEntity;

import java.util.Date;

@TableName(value = "T_NEWSLETTER_ANALYSIS", schema = "AIR_ANALYSISREPORT")
public class TNewsletterAnalysis extends BaseEntity {
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
     * 编辑内容第一段
     */
    private String editContentOne;
    /**
     * 生成内容第一段
     */
    private String generateContentOne;
    /**
     * 编辑内容第二段
     */
    private String editContentTwo;
    /**
     * 生成内容第二段
     */
    private String generateContentTwo;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "GMT+8")
    private Date editTime;

    private String editUser;

    /**
     * 图片id
     */
    private String imageId;

    //前一天污染情况
    /**
     * 污染月
     */
    private String pollutionMoon;
    /**
     * 污染准确天数
     */
    private String pollutionDay;
    /**
     * 边界层高度区间
     */
    private String pollutionBoundaryLayerHeightInterval;
    /**
     * 污染风速
     */
    private String pollutionWindSpeed;
    /**
     * 扩散条件（较好/一般/较差）
     */
    private String pollutionDiffusionConditions;
    /**
     * 平均比例
     */
    private String pollutionAverageRatio;
    /**
     * 超标小时
     */
    private String pollutionConsecutiveHours;
    /**
     * 巅峰浓度
     */
    private String pollutionPeakConcentration;
    /**
     * 污染等级（优、良、轻度污染、中度污染、重度污染）
     */
    private String pollutionLevel;


    //次日污染情况
    /**
     * 次日污染日期
     */
    private String nextDayPollutionDay;
    /**
     * 次日污染天气情况
     */
    private String nextDayPollutionWeatherConditions;
    /**
     * 次日污染边界层高度
     */
    private String nextDayPollutionBoundaryLayerHeight;
    /**
     * 次日污染风速
     */
    private String nextDayPollutionWindSpeed;
    /**
     * 次日污染扩散条件（好/与前日相当/差）
     */
    private String nextDayPollutionDiffusionConditions;
    /**
     * 次日污染速率
     */
    private String nextDayPollutionRate;
    /**
     * 次日污染pm25超标浓度
     */
    private String nextDayPollutionPm25ExcessiveConcentration;
    /**
     * 次日污染No2平均浓度
     */
    private String nextDayPollutionNo2AverageConcentration;
    /**
     * 次日污染下降比例
     */
    private String nextDayPollutionDecreaseRatio;
    /**
     * 次日污染VOC浓度
     */
    private String nextDayPollutionVocConcentration;
    /**
     * 次日污染OFP浓度
     */
    private String nextDayPollutionOfpConcentration;
    /**
     * 次日污染VOC浓度下降比例
     */
    private String nextDayPollutionVocDecreaseRatio;
    /**
     * 次日污染OFP浓度下降比例
     */
    private String nextDayPollutionOfpDecreaseRatio;
    /**
     * 次日污染OFP 贡献前五物种（主物种）
     */
    private String nextDayPollutionOfpSpecies;
    /**
     * 次日污染OFP 污染源
     */
    private String nextDayPollutionOfpSource;
    /**
     * 次日污染NO2、O1D、甲醛和 HONO 的光解速率和辐射强度较前日明显（降低、升高）
     */
    private String nextDayPollutionCompare;
    /**
     * 次日污染pm25浓度
     */
    private String nextDayPollutionPm25Concentration;
    /**
     * 次日污染o3浓度
     */
    private String nextDayPollutionO3Concentration;
    /**
     * 次日污染等级
     */
    private String nextDayPollutionLevel;
    /**
     * 次日污染AQI
     */
    private String nextDayPollutionAqi;
    /**
     * 次日污染主要污染物
     */
    private String nextDayPollutionPrimaryPollutant;

    public TNewsletterAnalysis() {
    }

    public TNewsletterAnalysis(String reportId, String ascriptionType, String ascriptionTypeTwo, String ascriptionTypeThree, String ascriptionTypeFour, String ascriptionTypeFive, String reportBatch, String reportName, Date reportTime, String reportRate, String reportFrequency, String reportType, String reportTip, String remark, String reportInscribe, String state, Integer isMain, String reportUserCode, String reportUserName, String editContentOne, String generateContentOne, String editContentTwo, String generateContentTwo, Date editTime, String editUser, String imageId, String pollutionMoon, String pollutionDay, String pollutionBoundaryLayerHeightInterval, String pollutionWindSpeed, String pollutionDiffusionConditions, String pollutionAverageRatio, String pollutionConsecutiveHours, String pollutionPeakConcentration, String pollutionLevel, String nextDayPollutionDay, String nextDayPollutionWeatherConditions, String nextDayPollutionBoundaryLayerHeight, String nextDayPollutionWindSpeed, String nextDayPollutionDiffusionConditions, String nextDayPollutionRate, String nextDayPollutionPm25ExcessiveConcentration, String nextDayPollutionNo2AverageConcentration, String nextDayPollutionDecreaseRatio, String nextDayPollutionVocConcentration, String nextDayPollutionOfpConcentration, String nextDayPollutionVocDecreaseRatio, String nextDayPollutionOfpDecreaseRatio, String nextDayPollutionOfpSpecies, String nextDayPollutionOfpSource, String nextDayPollutionCompare, String nextDayPollutionPm25Concentration, String nextDayPollutionO3Concentration, String nextDayPollutionLevel, String nextDayPollutionAqi, String nextDayPollutionPrimaryPollutant) {
        this.reportId = reportId;
        this.ascriptionType = ascriptionType;
        this.ascriptionTypeTwo = ascriptionTypeTwo;
        this.ascriptionTypeThree = ascriptionTypeThree;
        this.ascriptionTypeFour = ascriptionTypeFour;
        this.ascriptionTypeFive = ascriptionTypeFive;
        this.reportBatch = reportBatch;
        this.reportName = reportName;
        this.reportTime = reportTime;
        this.reportRate = reportRate;
        this.reportFrequency = reportFrequency;
        this.reportType = reportType;
        this.reportTip = reportTip;
        this.remark = remark;
        this.reportInscribe = reportInscribe;
        this.state = state;
        this.isMain = isMain;
        this.reportUserCode = reportUserCode;
        this.reportUserName = reportUserName;
        this.editContentOne = editContentOne;
        this.generateContentOne = generateContentOne;
        this.editContentTwo = editContentTwo;
        this.generateContentTwo = generateContentTwo;
        this.editTime = editTime;
        this.editUser = editUser;
        this.imageId = imageId;
        this.pollutionMoon = pollutionMoon;
        this.pollutionDay = pollutionDay;
        this.pollutionBoundaryLayerHeightInterval = pollutionBoundaryLayerHeightInterval;
        this.pollutionWindSpeed = pollutionWindSpeed;
        this.pollutionDiffusionConditions = pollutionDiffusionConditions;
        this.pollutionAverageRatio = pollutionAverageRatio;
        this.pollutionConsecutiveHours = pollutionConsecutiveHours;
        this.pollutionPeakConcentration = pollutionPeakConcentration;
        this.pollutionLevel = pollutionLevel;
        this.nextDayPollutionDay = nextDayPollutionDay;
        this.nextDayPollutionWeatherConditions = nextDayPollutionWeatherConditions;
        this.nextDayPollutionBoundaryLayerHeight = nextDayPollutionBoundaryLayerHeight;
        this.nextDayPollutionWindSpeed = nextDayPollutionWindSpeed;
        this.nextDayPollutionDiffusionConditions = nextDayPollutionDiffusionConditions;
        this.nextDayPollutionRate = nextDayPollutionRate;
        this.nextDayPollutionPm25ExcessiveConcentration = nextDayPollutionPm25ExcessiveConcentration;
        this.nextDayPollutionNo2AverageConcentration = nextDayPollutionNo2AverageConcentration;
        this.nextDayPollutionDecreaseRatio = nextDayPollutionDecreaseRatio;
        this.nextDayPollutionVocConcentration = nextDayPollutionVocConcentration;
        this.nextDayPollutionOfpConcentration = nextDayPollutionOfpConcentration;
        this.nextDayPollutionVocDecreaseRatio = nextDayPollutionVocDecreaseRatio;
        this.nextDayPollutionOfpDecreaseRatio = nextDayPollutionOfpDecreaseRatio;
        this.nextDayPollutionOfpSpecies = nextDayPollutionOfpSpecies;
        this.nextDayPollutionOfpSource = nextDayPollutionOfpSource;
        this.nextDayPollutionCompare = nextDayPollutionCompare;
        this.nextDayPollutionPm25Concentration = nextDayPollutionPm25Concentration;
        this.nextDayPollutionO3Concentration = nextDayPollutionO3Concentration;
        this.nextDayPollutionLevel = nextDayPollutionLevel;
        this.nextDayPollutionAqi = nextDayPollutionAqi;
        this.nextDayPollutionPrimaryPollutant = nextDayPollutionPrimaryPollutant;
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

    public String getEditContentOne() {
        return editContentOne;
    }

    public void setEditContentOne(String editContentOne) {
        this.editContentOne = editContentOne;
    }

    public String getGenerateContentOne() {
        return generateContentOne;
    }

    public void setGenerateContentOne(String generateContentOne) {
        this.generateContentOne = generateContentOne;
    }

    public String getEditContentTwo() {
        return editContentTwo;
    }

    public void setEditContentTwo(String editContentTwo) {
        this.editContentTwo = editContentTwo;
    }

    public String getGenerateContentTwo() {
        return generateContentTwo;
    }

    public void setGenerateContentTwo(String generateContentTwo) {
        this.generateContentTwo = generateContentTwo;
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

    public String getPollutionMoon() {
        return pollutionMoon;
    }

    public void setPollutionMoon(String pollutionMoon) {
        this.pollutionMoon = pollutionMoon;
    }

    public String getPollutionDay() {
        return pollutionDay;
    }

    public void setPollutionDay(String pollutionDay) {
        this.pollutionDay = pollutionDay;
    }

    public String getPollutionBoundaryLayerHeightInterval() {
        return pollutionBoundaryLayerHeightInterval;
    }

    public void setPollutionBoundaryLayerHeightInterval(String pollutionBoundaryLayerHeightInterval) {
        this.pollutionBoundaryLayerHeightInterval = pollutionBoundaryLayerHeightInterval;
    }

    public String getPollutionWindSpeed() {
        return pollutionWindSpeed;
    }

    public void setPollutionWindSpeed(String pollutionWindSpeed) {
        this.pollutionWindSpeed = pollutionWindSpeed;
    }

    public String getPollutionDiffusionConditions() {
        return pollutionDiffusionConditions;
    }

    public void setPollutionDiffusionConditions(String pollutionDiffusionConditions) {
        this.pollutionDiffusionConditions = pollutionDiffusionConditions;
    }

    public String getPollutionAverageRatio() {
        return pollutionAverageRatio;
    }

    public void setPollutionAverageRatio(String pollutionAverageRatio) {
        this.pollutionAverageRatio = pollutionAverageRatio;
    }

    public String getPollutionConsecutiveHours() {
        return pollutionConsecutiveHours;
    }

    public void setPollutionConsecutiveHours(String pollutionConsecutiveHours) {
        this.pollutionConsecutiveHours = pollutionConsecutiveHours;
    }

    public String getPollutionPeakConcentration() {
        return pollutionPeakConcentration;
    }

    public void setPollutionPeakConcentration(String pollutionPeakConcentration) {
        this.pollutionPeakConcentration = pollutionPeakConcentration;
    }

    public String getPollutionLevel() {
        return pollutionLevel;
    }

    public void setPollutionLevel(String pollutionLevel) {
        this.pollutionLevel = pollutionLevel;
    }

    public String getNextDayPollutionDay() {
        return nextDayPollutionDay;
    }

    public void setNextDayPollutionDay(String nextDayPollutionDay) {
        this.nextDayPollutionDay = nextDayPollutionDay;
    }

    public String getNextDayPollutionWeatherConditions() {
        return nextDayPollutionWeatherConditions;
    }

    public void setNextDayPollutionWeatherConditions(String nextDayPollutionWeatherConditions) {
        this.nextDayPollutionWeatherConditions = nextDayPollutionWeatherConditions;
    }

    public String getNextDayPollutionBoundaryLayerHeight() {
        return nextDayPollutionBoundaryLayerHeight;
    }

    public void setNextDayPollutionBoundaryLayerHeight(String nextDayPollutionBoundaryLayerHeight) {
        this.nextDayPollutionBoundaryLayerHeight = nextDayPollutionBoundaryLayerHeight;
    }

    public String getNextDayPollutionWindSpeed() {
        return nextDayPollutionWindSpeed;
    }

    public void setNextDayPollutionWindSpeed(String nextDayPollutionWindSpeed) {
        this.nextDayPollutionWindSpeed = nextDayPollutionWindSpeed;
    }

    public String getNextDayPollutionDiffusionConditions() {
        return nextDayPollutionDiffusionConditions;
    }

    public void setNextDayPollutionDiffusionConditions(String nextDayPollutionDiffusionConditions) {
        this.nextDayPollutionDiffusionConditions = nextDayPollutionDiffusionConditions;
    }

    public String getNextDayPollutionRate() {
        return nextDayPollutionRate;
    }

    public void setNextDayPollutionRate(String nextDayPollutionRate) {
        this.nextDayPollutionRate = nextDayPollutionRate;
    }

    public String getNextDayPollutionPm25ExcessiveConcentration() {
        return nextDayPollutionPm25ExcessiveConcentration;
    }

    public void setNextDayPollutionPm25ExcessiveConcentration(String nextDayPollutionPm25ExcessiveConcentration) {
        this.nextDayPollutionPm25ExcessiveConcentration = nextDayPollutionPm25ExcessiveConcentration;
    }

    public String getNextDayPollutionNo2AverageConcentration() {
        return nextDayPollutionNo2AverageConcentration;
    }

    public void setNextDayPollutionNo2AverageConcentration(String nextDayPollutionNo2AverageConcentration) {
        this.nextDayPollutionNo2AverageConcentration = nextDayPollutionNo2AverageConcentration;
    }

    public String getNextDayPollutionDecreaseRatio() {
        return nextDayPollutionDecreaseRatio;
    }

    public void setNextDayPollutionDecreaseRatio(String nextDayPollutionDecreaseRatio) {
        this.nextDayPollutionDecreaseRatio = nextDayPollutionDecreaseRatio;
    }

    public String getNextDayPollutionVocConcentration() {
        return nextDayPollutionVocConcentration;
    }

    public void setNextDayPollutionVocConcentration(String nextDayPollutionVocConcentration) {
        this.nextDayPollutionVocConcentration = nextDayPollutionVocConcentration;
    }

    public String getNextDayPollutionOfpConcentration() {
        return nextDayPollutionOfpConcentration;
    }

    public void setNextDayPollutionOfpConcentration(String nextDayPollutionOfpConcentration) {
        this.nextDayPollutionOfpConcentration = nextDayPollutionOfpConcentration;
    }

    public String getNextDayPollutionVocDecreaseRatio() {
        return nextDayPollutionVocDecreaseRatio;
    }

    public void setNextDayPollutionVocDecreaseRatio(String nextDayPollutionVocDecreaseRatio) {
        this.nextDayPollutionVocDecreaseRatio = nextDayPollutionVocDecreaseRatio;
    }

    public String getNextDayPollutionOfpDecreaseRatio() {
        return nextDayPollutionOfpDecreaseRatio;
    }

    public void setNextDayPollutionOfpDecreaseRatio(String nextDayPollutionOfpDecreaseRatio) {
        this.nextDayPollutionOfpDecreaseRatio = nextDayPollutionOfpDecreaseRatio;
    }

    public String getNextDayPollutionOfpSpecies() {
        return nextDayPollutionOfpSpecies;
    }

    public void setNextDayPollutionOfpSpecies(String nextDayPollutionOfpSpecies) {
        this.nextDayPollutionOfpSpecies = nextDayPollutionOfpSpecies;
    }

    public String getNextDayPollutionOfpSource() {
        return nextDayPollutionOfpSource;
    }

    public void setNextDayPollutionOfpSource(String nextDayPollutionOfpSource) {
        this.nextDayPollutionOfpSource = nextDayPollutionOfpSource;
    }

    public String getNextDayPollutionCompare() {
        return nextDayPollutionCompare;
    }

    public void setNextDayPollutionCompare(String nextDayPollutionCompare) {
        this.nextDayPollutionCompare = nextDayPollutionCompare;
    }

    public String getNextDayPollutionPm25Concentration() {
        return nextDayPollutionPm25Concentration;
    }

    public void setNextDayPollutionPm25Concentration(String nextDayPollutionPm25Concentration) {
        this.nextDayPollutionPm25Concentration = nextDayPollutionPm25Concentration;
    }

    public String getNextDayPollutionO3Concentration() {
        return nextDayPollutionO3Concentration;
    }

    public void setNextDayPollutionO3Concentration(String nextDayPollutionO3Concentration) {
        this.nextDayPollutionO3Concentration = nextDayPollutionO3Concentration;
    }

    public String getNextDayPollutionLevel() {
        return nextDayPollutionLevel;
    }

    public void setNextDayPollutionLevel(String nextDayPollutionLevel) {
        this.nextDayPollutionLevel = nextDayPollutionLevel;
    }

    public String getNextDayPollutionAqi() {
        return nextDayPollutionAqi;
    }

    public void setNextDayPollutionAqi(String nextDayPollutionAqi) {
        this.nextDayPollutionAqi = nextDayPollutionAqi;
    }

    public String getNextDayPollutionPrimaryPollutant() {
        return nextDayPollutionPrimaryPollutant;
    }

    public void setNextDayPollutionPrimaryPollutant(String nextDayPollutionPrimaryPollutant) {
        this.nextDayPollutionPrimaryPollutant = nextDayPollutionPrimaryPollutant;
    }
}

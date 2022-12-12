package ths.project.analysis.analysisreport.entity;


import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

/**
 * 冬季快报实体类
 */
@TableName(value = "T_WINTER_EXPRESS", schema = "AIR_ANALYSISREPORT")
public class WinterExpress {

    @TableId
    /**
     * 报告id
     */
    private String reportId;
    /**
     * 归属类型
     */
    private String ascriptionType;
    /**
     * 报告名称
     */
    private String reportName;
    /**
     * 报告时间
     */
    @DateTimeFormat(pattern = "yyyy-MM-dd HH")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH", timezone = "GMT+8")
    private Date reportTime;
    /**
     *  报告频率
     */
    private String reportFrequency;
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
     * 创建时间
     */
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "GMT+8")
    private Date createTime;
    /**
     * 创建人
     */
    private String createUser;
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
     * 修改时间
     */
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "GMT+8")
    private Date updateTime;
    /**
     * 修改人
     */
    private String updateUser;
    /**
     * 删除标识
     */
    private long deleteFlag;
    /**
     * 生成内容第一段
     */
    private String generateContentOne;
    /**
     * 生成内容第二段
     */
    private String generateContentTwo;

    /**
     * 污染前一天
     */
    private String pollutionTheDayBefore;
    /**
     * 污染天气情况
     */
    private String pollutionWeatherConditions;
    /**
     * 影响因素
     */
    private String pollutionInfluencingFactors;
    /**
     * 影响因素增加或减少
     */
    private String pollutionInfluencingFactorsIncreaseOrDecrease;
    /**
     * 边界层（上升/下降）
     */
    private String pollutionInBoundary;
    /**
     * 边界层高度
     */
    private String pollutionInBoundaryLayer;
    /**
     * 污染物积累速度
     */
    private String pollutionAccumulationSpeed;
    /**
     * 污染连续小时
     */
    private String pollutionConsecutiveHours;
    /**
     * 污染等级
     */
    private String pollutionLevel;
    /**
     * 午后天气状况
     */
    private String pollutionAfternoonSkyConditions;
    /**
     * 湿度情况
     */
    private String pollutionHumidity;
    /**
     * 午后边界层状况
     */
    private String pollutionBoundaryLayerCondition;
    /**
     * 垂直扩散条件状况
     */
    private String pollutionVerticalDiffusionConditions;
    /**
     * 空气质量等级
     */
    private String pollutionAirQualityLevel;
    /**
     * 夜间边界层情况
     */
    private String pollutionNocturnalBoundaryLayer;
    /**
     * 夜间空气质量时间
     */
    private String pollutionNightAirQualityTime;
    /**
     * 夜间空气质量等级
     */
    private String pollutionNightAirQualityLevel;
    /**
     * 全体空气质量等级
     */
    private String pollutionAirQualityThroughoutTheDay;
    /**
     * AQI
     */
    private String pollutantAqi;
    /**
     * 首要污染物
     */
    private String pollutantPrimary;
    /**
     * 污染区县
     */
    private String pollutantDistrict;
    /**
     * 区县污染等级
     */
    private String pollutionCountyPollutionLevel;
    /**
     * 其余县污染等级
     */
    private String pollutionLevelOfOtherCounties;
    /**
     * 污染情况
     */
    private String pollutionCondition;
    /**
     * 污染当天
     */
    private String pollutionThatDay;
    /**
     * 逆温温度
     */
    private String pollutionInversion;
    /**
     * 污染当天空气质量转换时间
     */
    private String pollutionConversionTime;
    /**
     * 污染当天空气质量等级
     */
    private String pollutionThatDayGrade;
    /**
     * 站点空气质量情况
     */
    private String pollutionSiteSituation;
    /**
     * 区县空气质量情况
     */
    private String pollutionCountySituation;
    /**
     * 区域污染情况
     */
    private String pollutionRegional;

    public WinterExpress() {
    }

    public WinterExpress(String reportId, String ascriptionType, String reportName, Date reportTime, String reportFrequency, String reportTip, String remark, String reportInscribe, String state, Date createTime, String createUser, Date editTime, String editUser, Date updateTime, String updateUser, long deleteFlag, String generateContentOne, String generateContentTwo, String pollutionTheDayBefore, String pollutionWeatherConditions, String pollutionInfluencingFactors, String pollutionInfluencingFactorsIncreaseOrDecrease, String pollutionInBoundary, String pollutionInBoundaryLayer, String pollutionAccumulationSpeed, String pollutionConsecutiveHours, String pollutionLevel, String pollutionAfternoonSkyConditions, String pollutionHumidity, String pollutionBoundaryLayerCondition, String pollutionVerticalDiffusionConditions, String pollutionAirQualityLevel, String pollutionNocturnalBoundaryLayer, String pollutionNightAirQualityTime, String pollutionNightAirQualityLevel, String pollutionAirQualityThroughoutTheDay, String pollutantAqi, String pollutantPrimary, String pollutantDistrict, String pollutionCountyPollutionLevel, String pollutionLevelOfOtherCounties, String pollutionCondition, String pollutionThatDay, String pollutionInversion, String pollutionConversionTime, String pollutionThatDayGrade, String pollutionSiteSituation, String pollutionCountySituation, String pollutionRegional) {
        this.reportId = reportId;
        this.ascriptionType = ascriptionType;
        this.reportName = reportName;
        this.reportTime = reportTime;
        this.reportFrequency = reportFrequency;
        this.reportTip = reportTip;
        this.remark = remark;
        this.reportInscribe = reportInscribe;
        this.state = state;
        this.createTime = createTime;
        this.createUser = createUser;
        this.editTime = editTime;
        this.editUser = editUser;
        this.updateTime = updateTime;
        this.updateUser = updateUser;
        this.deleteFlag = deleteFlag;
        this.generateContentOne = generateContentOne;
        this.generateContentTwo = generateContentTwo;
        this.pollutionTheDayBefore = pollutionTheDayBefore;
        this.pollutionWeatherConditions = pollutionWeatherConditions;
        this.pollutionInfluencingFactors = pollutionInfluencingFactors;
        this.pollutionInfluencingFactorsIncreaseOrDecrease = pollutionInfluencingFactorsIncreaseOrDecrease;
        this.pollutionInBoundary = pollutionInBoundary;
        this.pollutionInBoundaryLayer = pollutionInBoundaryLayer;
        this.pollutionAccumulationSpeed = pollutionAccumulationSpeed;
        this.pollutionConsecutiveHours = pollutionConsecutiveHours;
        this.pollutionLevel = pollutionLevel;
        this.pollutionAfternoonSkyConditions = pollutionAfternoonSkyConditions;
        this.pollutionHumidity = pollutionHumidity;
        this.pollutionBoundaryLayerCondition = pollutionBoundaryLayerCondition;
        this.pollutionVerticalDiffusionConditions = pollutionVerticalDiffusionConditions;
        this.pollutionAirQualityLevel = pollutionAirQualityLevel;
        this.pollutionNocturnalBoundaryLayer = pollutionNocturnalBoundaryLayer;
        this.pollutionNightAirQualityTime = pollutionNightAirQualityTime;
        this.pollutionNightAirQualityLevel = pollutionNightAirQualityLevel;
        this.pollutionAirQualityThroughoutTheDay = pollutionAirQualityThroughoutTheDay;
        this.pollutantAqi = pollutantAqi;
        this.pollutantPrimary = pollutantPrimary;
        this.pollutantDistrict = pollutantDistrict;
        this.pollutionCountyPollutionLevel = pollutionCountyPollutionLevel;
        this.pollutionLevelOfOtherCounties = pollutionLevelOfOtherCounties;
        this.pollutionCondition = pollutionCondition;
        this.pollutionThatDay = pollutionThatDay;
        this.pollutionInversion = pollutionInversion;
        this.pollutionConversionTime = pollutionConversionTime;
        this.pollutionThatDayGrade = pollutionThatDayGrade;
        this.pollutionSiteSituation = pollutionSiteSituation;
        this.pollutionCountySituation = pollutionCountySituation;
        this.pollutionRegional = pollutionRegional;
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

    public String getReportFrequency() {
        return reportFrequency;
    }

    public void setReportFrequency(String reportFrequency) {
        this.reportFrequency = reportFrequency;
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

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    public String getUpdateUser() {
        return updateUser;
    }

    public void setUpdateUser(String updateUser) {
        this.updateUser = updateUser;
    }

    public long getDeleteFlag() {
        return deleteFlag;
    }

    public void setDeleteFlag(long deleteFlag) {
        this.deleteFlag = deleteFlag;
    }

    public String getGenerateContentOne() {
        return generateContentOne;
    }

    public void setGenerateContentOne(String generateContentOne) {
        this.generateContentOne = generateContentOne;
    }

    public String getGenerateContentTwo() {
        return generateContentTwo;
    }

    public void setGenerateContentTwo(String generateContentTwo) {
        this.generateContentTwo = generateContentTwo;
    }

    public String getPollutionTheDayBefore() {
        return pollutionTheDayBefore;
    }

    public void setPollutionTheDayBefore(String pollutionTheDayBefore) {
        this.pollutionTheDayBefore = pollutionTheDayBefore;
    }

    public String getPollutionWeatherConditions() {
        return pollutionWeatherConditions;
    }

    public void setPollutionWeatherConditions(String pollutionWeatherConditions) {
        this.pollutionWeatherConditions = pollutionWeatherConditions;
    }

    public String getPollutionInfluencingFactors() {
        return pollutionInfluencingFactors;
    }

    public void setPollutionInfluencingFactors(String pollutionInfluencingFactors) {
        this.pollutionInfluencingFactors = pollutionInfluencingFactors;
    }

    public String getPollutionInfluencingFactorsIncreaseOrDecrease() {
        return pollutionInfluencingFactorsIncreaseOrDecrease;
    }

    public void setPollutionInfluencingFactorsIncreaseOrDecrease(String pollutionInfluencingFactorsIncreaseOrDecrease) {
        this.pollutionInfluencingFactorsIncreaseOrDecrease = pollutionInfluencingFactorsIncreaseOrDecrease;
    }

    public String getPollutionInBoundary() {
        return pollutionInBoundary;
    }

    public void setPollutionInBoundary(String pollutionInBoundary) {
        this.pollutionInBoundary = pollutionInBoundary;
    }

    public String getPollutionInBoundaryLayer() {
        return pollutionInBoundaryLayer;
    }

    public void setPollutionInBoundaryLayer(String pollutionInBoundaryLayer) {
        this.pollutionInBoundaryLayer = pollutionInBoundaryLayer;
    }

    public String getPollutionAccumulationSpeed() {
        return pollutionAccumulationSpeed;
    }

    public void setPollutionAccumulationSpeed(String pollutionAccumulationSpeed) {
        this.pollutionAccumulationSpeed = pollutionAccumulationSpeed;
    }

    public String getPollutionConsecutiveHours() {
        return pollutionConsecutiveHours;
    }

    public void setPollutionConsecutiveHours(String pollutionConsecutiveHours) {
        this.pollutionConsecutiveHours = pollutionConsecutiveHours;
    }

    public String getPollutionLevel() {
        return pollutionLevel;
    }

    public void setPollutionLevel(String pollutionLevel) {
        this.pollutionLevel = pollutionLevel;
    }

    public String getPollutionAfternoonSkyConditions() {
        return pollutionAfternoonSkyConditions;
    }

    public void setPollutionAfternoonSkyConditions(String pollutionAfternoonSkyConditions) {
        this.pollutionAfternoonSkyConditions = pollutionAfternoonSkyConditions;
    }

    public String getPollutionHumidity() {
        return pollutionHumidity;
    }

    public void setPollutionHumidity(String pollutionHumidity) {
        this.pollutionHumidity = pollutionHumidity;
    }

    public String getPollutionBoundaryLayerCondition() {
        return pollutionBoundaryLayerCondition;
    }

    public void setPollutionBoundaryLayerCondition(String pollutionBoundaryLayerCondition) {
        this.pollutionBoundaryLayerCondition = pollutionBoundaryLayerCondition;
    }

    public String getPollutionVerticalDiffusionConditions() {
        return pollutionVerticalDiffusionConditions;
    }

    public void setPollutionVerticalDiffusionConditions(String pollutionVerticalDiffusionConditions) {
        this.pollutionVerticalDiffusionConditions = pollutionVerticalDiffusionConditions;
    }

    public String getPollutionAirQualityLevel() {
        return pollutionAirQualityLevel;
    }

    public void setPollutionAirQualityLevel(String pollutionAirQualityLevel) {
        this.pollutionAirQualityLevel = pollutionAirQualityLevel;
    }

    public String getPollutionNocturnalBoundaryLayer() {
        return pollutionNocturnalBoundaryLayer;
    }

    public void setPollutionNocturnalBoundaryLayer(String pollutionNocturnalBoundaryLayer) {
        this.pollutionNocturnalBoundaryLayer = pollutionNocturnalBoundaryLayer;
    }

    public String getPollutionNightAirQualityTime() {
        return pollutionNightAirQualityTime;
    }

    public void setPollutionNightAirQualityTime(String pollutionNightAirQualityTime) {
        this.pollutionNightAirQualityTime = pollutionNightAirQualityTime;
    }

    public String getPollutionNightAirQualityLevel() {
        return pollutionNightAirQualityLevel;
    }

    public void setPollutionNightAirQualityLevel(String pollutionNightAirQualityLevel) {
        this.pollutionNightAirQualityLevel = pollutionNightAirQualityLevel;
    }

    public String getPollutionAirQualityThroughoutTheDay() {
        return pollutionAirQualityThroughoutTheDay;
    }

    public void setPollutionAirQualityThroughoutTheDay(String pollutionAirQualityThroughoutTheDay) {
        this.pollutionAirQualityThroughoutTheDay = pollutionAirQualityThroughoutTheDay;
    }

    public String getPollutantAqi() {
        return pollutantAqi;
    }

    public void setPollutantAqi(String pollutantAqi) {
        this.pollutantAqi = pollutantAqi;
    }

    public String getPollutantPrimary() {
        return pollutantPrimary;
    }

    public void setPollutantPrimary(String pollutantPrimary) {
        this.pollutantPrimary = pollutantPrimary;
    }

    public String getPollutantDistrict() {
        return pollutantDistrict;
    }

    public void setPollutantDistrict(String pollutantDistrict) {
        this.pollutantDistrict = pollutantDistrict;
    }

    public String getPollutionCountyPollutionLevel() {
        return pollutionCountyPollutionLevel;
    }

    public void setPollutionCountyPollutionLevel(String pollutionCountyPollutionLevel) {
        this.pollutionCountyPollutionLevel = pollutionCountyPollutionLevel;
    }

    public String getPollutionLevelOfOtherCounties() {
        return pollutionLevelOfOtherCounties;
    }

    public void setPollutionLevelOfOtherCounties(String pollutionLevelOfOtherCounties) {
        this.pollutionLevelOfOtherCounties = pollutionLevelOfOtherCounties;
    }

    public String getPollutionCondition() {
        return pollutionCondition;
    }

    public void setPollutionCondition(String pollutionCondition) {
        this.pollutionCondition = pollutionCondition;
    }

    public String getPollutionThatDay() {
        return pollutionThatDay;
    }

    public void setPollutionThatDay(String pollutionThatDay) {
        this.pollutionThatDay = pollutionThatDay;
    }

    public String getPollutionInversion() {
        return pollutionInversion;
    }

    public void setPollutionInversion(String pollutionInversion) {
        this.pollutionInversion = pollutionInversion;
    }

    public String getPollutionConversionTime() {
        return pollutionConversionTime;
    }

    public void setPollutionConversionTime(String pollutionConversionTime) {
        this.pollutionConversionTime = pollutionConversionTime;
    }

    public String getPollutionThatDayGrade() {
        return pollutionThatDayGrade;
    }

    public void setPollutionThatDayGrade(String pollutionThatDayGrade) {
        this.pollutionThatDayGrade = pollutionThatDayGrade;
    }

    public String getPollutionSiteSituation() {
        return pollutionSiteSituation;
    }

    public void setPollutionSiteSituation(String pollutionSiteSituation) {
        this.pollutionSiteSituation = pollutionSiteSituation;
    }

    public String getPollutionCountySituation() {
        return pollutionCountySituation;
    }

    public void setPollutionCountySituation(String pollutionCountySituation) {
        this.pollutionCountySituation = pollutionCountySituation;
    }

    public String getPollutionRegional() {
        return pollutionRegional;
    }

    public void setPollutionRegional(String pollutionRegional) {
        this.pollutionRegional = pollutionRegional;
    }
}

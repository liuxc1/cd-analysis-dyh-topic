package ths.project.analysis.forecast.airforecastcity.entity;


import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

/**
 * @Description  
 * @Author  Hunter
 * @Date 2021-06-15 
 */

@TableName("T_ANS_FLOW_INFO" )
public class AnsFlowInfo{

	/**
	 * 预报主键
	 */
   	@TableId
	private String infoId;

	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm")
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm", timezone = "GMT+8")
	private Date reportTime;

	/**
	 * 状态
	 */
	private Integer flowState;

	/**
	 * 未来7天城市
	 */
	private String cityOpinion;

	/**
	 * 7天重要提示
	 */
	@TableField(value = "IMPORTANT_HINTS_7DAY")
	private String importantHintsDay7;

	/**
	 * 未来7天国控
	 */
	private String countryOpinion;

	/**
	 * 未来3天城市
	 */
	@TableField(value = "CITY_OPINION_3DAY")
	private String cityOpinionDay3;

	/**
	 * 未来3天国控
	 */
	@TableField(value = "COUNTRY_OPINION_3DAY")
	private String countryOpinionDay3;

	/**
	 * 3天重要提示
	 */
	private String importantHints;

	/**
	 * 落款
	 */
	private String inscribe;

	/**
	 * 创建时间
	 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm")
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm", timezone = "GMT+8")
	private Date createTime;

	/**
	 * 创建人
	 */
	private String createUser;

	/**
	 * 修改时间
	 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm")
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm", timezone = "GMT+8")
	private Date editTime;

	/**
	 * 气象条件类型（1：臭氧污染气象条件2：气象扩散条件）
	 */
	private Integer weatherConditionsType;
	/**
	 * 修改人
	 */
	private String editUser;

	/**
	 * 是否推送省站
	 */
	private  Integer isSend;

	public String getInfoId() {
		return infoId;
	}

	public void setInfoId(String infoId) {
		this.infoId = infoId;
	}

	public Date getReportTime() {
		return reportTime;
	}

	public void setReportTime(Date reportTime) {
		this.reportTime = reportTime;
	}

	public Integer getFlowState() {
		return flowState;
	}

	public void setFlowState(Integer flowState) {
		this.flowState = flowState;
	}

	public String getCityOpinion() {
		return cityOpinion;
	}

	public void setCityOpinion(String cityOpinion) {
		this.cityOpinion = cityOpinion;
	}

	public String getCountryOpinion() {
		return countryOpinion;
	}

	public void setCountryOpinion(String countryOpinion) {
		this.countryOpinion = countryOpinion;
	}

	public String getImportantHintsDay7() {
		return importantHintsDay7;
	}

	public void setImportantHintsDay7(String importantHintsDay7) {
		this.importantHintsDay7 = importantHintsDay7;
	}

	public String getCityOpinionDay3() {
		return cityOpinionDay3;
	}

	public void setCityOpinionDay3(String cityOpinionDay3) {
		this.cityOpinionDay3 = cityOpinionDay3;
	}

	public String getCountryOpinionDay3() {
		return countryOpinionDay3;
	}

	public void setCountryOpinionDay3(String countryOpinionDay3) {
		this.countryOpinionDay3 = countryOpinionDay3;
	}

	public String getImportantHints() {
		return importantHints;
	}

	public void setImportantHints(String importantHints) {
		this.importantHints = importantHints;
	}

	public String getInscribe() {
		return inscribe;
	}

	public void setInscribe(String inscribe) {
		this.inscribe = inscribe;
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

	public Integer getWeatherConditionsType() {
		return weatherConditionsType;
	}

	public void setWeatherConditionsType(Integer weatherConditionsType) {
		this.weatherConditionsType = weatherConditionsType;
	}

	public Integer getIsSend() {
		return isSend;
	}

	public void setIsSend(Integer isSend) {
		this.isSend = isSend;
	}
}

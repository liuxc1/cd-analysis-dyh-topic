package ths.project.analysis.forecast.airforecastcity.entity;

import com.baomidou.mybatisplus.annotation.*;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

/**
 * @Description  
 * @Author  Hunter
 * @Date 2021-06-15 
 */

@TableName("T_ANS_FLOW_WQ_ROW" )
public class AnsFlowWqRow {


	/**
	 * 污染物信息主键
	 */
   	@TableId(type = IdType.AUTO)
	private Long pkid;

	/**
	 * 创建时间
	 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm")
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm", timezone = "GMT+8")
	private Date createTime;

	/**
	 * 结束时间
	 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm")
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm", timezone = "GMT+8")
	private Date resultTime;

	/**
	 * 城市编码
	 */
	private String pointCode;

	/**
	 * 城市名称
	 */
	private String pointName;

	/**
	 * AQI范围
	 */
	private String aqi;

	/**
	 * AQI等级
	 */
	private String aqiLevel;

	/**
	 * 首要污染物
	 */
	private String primPollute;

	/**
	 * 气象趋势
	 */
	private String weatherTrend;

	/**
	 * 气象扩散条件
	 */
	private String weatherLevel;

	/**
	 * 外键，对应调整信息表的PKID
	 */
	private String infoId;

	/**
	 * 控制目标
	 */
	private String controlTarget;

	private String pm25;

	private String o3;

	private Integer aqiMedian;
	private Integer pm25Median;
	private Integer o3Median;
	private Integer aqiMin;
	private Integer aqiMax;
	private Integer pm25Min;
	private Integer pm25Max;
	private Integer o3Min;
	private Integer o3Max;
	private Integer pm25Iaqi;
	private Integer pm25MinIaqi;
	private Integer pm25MaxIaqi;
	private Integer o3Iaqi;
	private Integer o3MinIaqi;
	private Integer o3MaxIaqi;


	public Long getPkid() {
		return pkid;
	}

	public void setPkid(Long pkid) {
		this.pkid = pkid;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
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

	public String getAqi() {
		return aqi;
	}

	public void setAqi(String aqi) {
		this.aqi = aqi;
	}

	public String getAqiLevel() {
		return aqiLevel;
	}

	public void setAqiLevel(String aqiLevel) {
		this.aqiLevel = aqiLevel;
	}

	public String getPrimPollute() {
		return primPollute;
	}

	public void setPrimPollute(String primPollute) {
		this.primPollute = primPollute;
	}

	public String getWeatherTrend() {
		return weatherTrend;
	}

	public void setWeatherTrend(String weatherTrend) {
		this.weatherTrend = weatherTrend;
	}

	public String getWeatherLevel() {
		return weatherLevel;
	}

	public void setWeatherLevel(String weatherLevel) {
		this.weatherLevel = weatherLevel;
	}

	public String getInfoId() {
		return infoId;
	}

	public void setInfoId(String infoId) {
		this.infoId = infoId;
	}

	public String getControlTarget() {
		return controlTarget;
	}

	public void setControlTarget(String controlTarget) {
		this.controlTarget = controlTarget;
	}

	public String getPm25() {
		return pm25;
	}

	public void setPm25(String pm25) {
		this.pm25 = pm25;
	}

	public String getO3() {
		return o3;
	}

	public void setO3(String o3) {
		this.o3 = o3;
	}

	public Integer getAqiMedian() {
		return aqiMedian;
	}

	public void setAqiMedian(Integer aqiMedian) {
		this.aqiMedian = aqiMedian;
	}

	public Integer getPm25Median() {
		return pm25Median;
	}

	public void setPm25Median(Integer pm25Median) {
		this.pm25Median = pm25Median;
	}

	public Integer getO3Median() {
		return o3Median;
	}

	public void setO3Median(Integer o3Median) {
		this.o3Median = o3Median;
	}

	public Integer getAqiMin() {
		return aqiMin;
	}

	public void setAqiMin(Integer aqiMin) {
		this.aqiMin = aqiMin;
	}

	public Integer getAqiMax() {
		return aqiMax;
	}

	public void setAqiMax(Integer aqiMax) {
		this.aqiMax = aqiMax;
	}

	public Integer getPm25Min() {
		return pm25Min;
	}

	public void setPm25Min(Integer pm25Min) {
		this.pm25Min = pm25Min;
	}

	public Integer getPm25Max() {
		return pm25Max;
	}

	public void setPm25Max(Integer pm25Max) {
		this.pm25Max = pm25Max;
	}

	public Integer getO3Min() {
		return o3Min;
	}

	public void setO3Min(Integer o3Min) {
		this.o3Min = o3Min;
	}

	public Integer getO3Max() {
		return o3Max;
	}

	public void setO3Max(Integer o3Max) {
		this.o3Max = o3Max;
	}

	public Integer getPm25Iaqi() {
		return pm25Iaqi;
	}

	public void setPm25Iaqi(Integer pm25Iaqi) {
		this.pm25Iaqi = pm25Iaqi;
	}

	public Integer getPm25MinIaqi() {
		return pm25MinIaqi;
	}

	public void setPm25MinIaqi(Integer pm25MinIaqi) {
		this.pm25MinIaqi = pm25MinIaqi;
	}

	public Integer getPm25MaxIaqi() {
		return pm25MaxIaqi;
	}

	public void setPm25MaxIaqi(Integer pm25MaxIaqi) {
		this.pm25MaxIaqi = pm25MaxIaqi;
	}

	public Integer getO3Iaqi() {
		return o3Iaqi;
	}

	public void setO3Iaqi(Integer o3Iaqi) {
		this.o3Iaqi = o3Iaqi;
	}

	public Integer getO3MinIaqi() {
		return o3MinIaqi;
	}

	public void setO3MinIaqi(Integer o3MinIaqi) {
		this.o3MinIaqi = o3MinIaqi;
	}

	public Integer getO3MaxIaqi() {
		return o3MaxIaqi;
	}

	public void setO3MaxIaqi(Integer o3MaxIaqi) {
		this.o3MaxIaqi = o3MaxIaqi;
	}
}

package ths.project.analysis.forecast.airforecasthour.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;


@TableName(value = "T_BAS_MODELWQ_HOUR_ROW ",schema="AIR_FORECAST")
public class ModelwqHourRow {
	private String model;
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm")
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm", timezone = "GMT+8")
	private Date modeltime;
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm")
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm", timezone = "GMT+8")
	private Date resulttime;
	private String regioncode;
	private String regionname;
	private String pointcode;
	private String pointname;
	private Integer pointtype;
	private Integer backtype;
	private Integer pm25;
	private Integer o3;
	private String aqi;
	private Integer step;
	private String userName;
	public String getModel() {
		return model;
	}
	public void setModel(String model) {
		this.model = model;
	}
	public Date getModeltime() {
		return modeltime;
	}
	public void setModeltime(Date modeltime) {
		this.modeltime = modeltime;
	}
	public Date getResulttime() {
		return resulttime;
	}
	public void setResulttime(Date resulttime) {
		this.resulttime = resulttime;
	}
	public String getRegioncode() {
		return regioncode;
	}
	public void setRegioncode(String regioncode) {
		this.regioncode = regioncode;
	}
	public String getRegionname() {
		return regionname;
	}
	public void setRegionname(String regionname) {
		this.regionname = regionname;
	}
	public String getPointcode() {
		return pointcode;
	}
	public void setPointcode(String pointcode) {
		this.pointcode = pointcode;
	}
	public String getPointname() {
		return pointname;
	}
	public void setPointname(String pointname) {
		this.pointname = pointname;
	}
	public Integer getPointtype() {
		return pointtype;
	}
	public void setPointtype(Integer pointtype) {
		this.pointtype = pointtype;
	}
	public Integer getBacktype() {
		return backtype;
	}
	public void setBacktype(Integer backtype) {
		this.backtype = backtype;
	}
	public Integer getPm25() {
		return pm25;
	}
	public void setPm25(Integer pm25) {
		this.pm25 = pm25;
	}
	public Integer getO3() {
		return o3;
	} 
	public void setO3(Integer o3) {
		this.o3 = o3;
	}
	public String getAqi() {
		return aqi;
	}
	public void setAqi(String aqi) {
		this.aqi = aqi;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}

	public Integer getStep() {
		return step;
	}

	public void setStep(Integer step) {
		this.step = step;
	}

	public ModelwqHourRow() {
	}

	public ModelwqHourRow(String model, Date modeltime, Date resulttime, String regioncode, String regionname, String pointcode, String pointname, Integer pointtype, Integer backtype, Integer pm25, Integer o3, String userName,Integer step) {
		this.model = model;
		this.modeltime = modeltime;
		this.resulttime = resulttime;
		this.regioncode = regioncode;
		this.regionname = regionname;
		this.pointcode = pointcode;
		this.pointname = pointname;
		this.pointtype = pointtype;
		this.backtype = backtype;
		this.pm25 = pm25;
		this.o3 = o3;
		this.userName = userName;
		this.step=step;
	}
}

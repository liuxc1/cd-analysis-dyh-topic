package ths.project.warnreport.dailyreport.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

@TableName(value="T_BAS_MANAGEMENT" ,schema="DAILY" )
public class Management {

  @TableId
  private String id;
  private String regionCode;
  private String regionName;
  private String dataType;
  @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm")
  @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm", timezone = "GMT+8")
  private Date dataTime;
  private long peopleNumber;
  private long industrialInspection;
  private long industrialLimitStop;
  private long industrialIllegal;
  private long siteInspection;
  private long dealNonRoadMovingMachinery;
  private long nonRoadMovingMachinerySpotCheck;
  private long nonRoadMovingMachinerySpotCheckExceeding;
  private long heavyDieselTruckSpotCheck;
  private long heavyDieselTruckSpotCheckExceeding;
  private String other;
  private String qx;


  public String getId() {
    return id;
  }

  public void setId(String id) {
    this.id = id;
  }


  public String getRegionCode() {
    return regionCode;
  }

  public void setRegionCode(String regionCode) {
    this.regionCode = regionCode;
  }


  public String getRegionName() {
    return regionName;
  }

  public void setRegionName(String regionName) {
    this.regionName = regionName;
  }


  public String getDataType() {
    return dataType;
  }

  public void setDataType(String dataType) {
    this.dataType = dataType;
  }


  public Date getDataTime() {
    return dataTime;
  }

  public void setDataTime(Date dataTime) {
    this.dataTime = dataTime;
  }


  public long getPeopleNumber() {
    return peopleNumber;
  }

  public void setPeopleNumber(long peopleNumber) {
    this.peopleNumber = peopleNumber;
  }


  public long getIndustrialInspection() {
    return industrialInspection;
  }

  public void setIndustrialInspection(long industrialInspection) {
    this.industrialInspection = industrialInspection;
  }


  public long getIndustrialLimitStop() {
    return industrialLimitStop;
  }

  public void setIndustrialLimitStop(long industrialLimitStop) {
    this.industrialLimitStop = industrialLimitStop;
  }


  public long getIndustrialIllegal() {
    return industrialIllegal;
  }

  public void setIndustrialIllegal(long industrialIllegal) {
    this.industrialIllegal = industrialIllegal;
  }


  public long getSiteInspection() {
    return siteInspection;
  }

  public void setSiteInspection(long siteInspection) {
    this.siteInspection = siteInspection;
  }


  public long getDealNonRoadMovingMachinery() {
    return dealNonRoadMovingMachinery;
  }

  public void setDealNonRoadMovingMachinery(long dealNonRoadMovingMachinery) {
    this.dealNonRoadMovingMachinery = dealNonRoadMovingMachinery;
  }


  public long getNonRoadMovingMachinerySpotCheck() {
    return nonRoadMovingMachinerySpotCheck;
  }

  public void setNonRoadMovingMachinerySpotCheck(long nonRoadMovingMachinerySpotCheck) {
    this.nonRoadMovingMachinerySpotCheck = nonRoadMovingMachinerySpotCheck;
  }


  public long getNonRoadMovingMachinerySpotCheckExceeding() {
    return nonRoadMovingMachinerySpotCheckExceeding;
  }

  public void setNonRoadMovingMachinerySpotCheckExceeding(long nonRoadMovingMachinerySpotCheckExceeding) {
    this.nonRoadMovingMachinerySpotCheckExceeding = nonRoadMovingMachinerySpotCheckExceeding;
  }


  public long getHeavyDieselTruckSpotCheck() {
    return heavyDieselTruckSpotCheck;
  }

  public void setHeavyDieselTruckSpotCheck(long heavyDieselTruckSpotCheck) {
    this.heavyDieselTruckSpotCheck = heavyDieselTruckSpotCheck;
  }


  public long getHeavyDieselTruckSpotCheckExceeding() {
    return heavyDieselTruckSpotCheckExceeding;
  }

  public void setHeavyDieselTruckSpotCheckExceeding(long heavyDieselTruckSpotCheckExceeding) {
    this.heavyDieselTruckSpotCheckExceeding = heavyDieselTruckSpotCheckExceeding;
  }


  public String getOther() {
    return other;
  }

  public void setOther(String other) {
    this.other = other;
  }


  public String getQx() {
    return qx;
  }

  public void setQx(String qx) {
    this.qx = qx;
  }

}

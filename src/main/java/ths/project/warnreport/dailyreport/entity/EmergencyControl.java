package ths.project.warnreport.dailyreport.entity;


import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;
@TableName(value="T_BAS_EMERGENCY_CONTROL" ,schema="DAILY" )
public class EmergencyControl {

  @TableId
  private String id;
  private String typeCode;
  private String typeName;
  @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm")
  @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm", timezone = "GMT+8")
  private Date dataTime;
  private String peopleNumber;
  private String siteInspection;
  private String dealIllegalConstructionSite;
  private String dealIllegalConstructionSiteVocs;
  private String dealIllegalConstructionSiteVocsArea;
  private String dealIllegalConstructionSiteEarthwork;
  private String dealIllegalConstructionSiteEarthworkArea;
  private String dealIllegalConstructionNonRoadMobileMachinery;
  private String dealIllegalConstructionSiteVocsTimes;
  private String industrialInspection;
  private String industrialIllegal;
  private String inspectGarage;
  private String illegalSprayingInspectGarage;
  private String inspectConcreteMixingStation;
  private String illegalConcreteMixingStation;
  private String inspectAsphaltMixingStation;
  private String illegalAsphaltMixingStation;
  private String dealGasStation;
  private String illegalGasStation;
  private String dealOilDepot;
  private String illegalOilDepot;
  private String dealIllegalSlagTruck;
  private String dealIllegalCementTanker;
  private String dealIllegalAsphaltTanker;
  private String busFrequency;
  private String busNum;
  private String subwayPassengerVolume;
  private String subwayRunningTrain;
  private String totalVehicleFlow;
  private String banOutdoorBarbecueStalls;
  private String dealWithOpenBurning;
  private String illegalPruningPesticideSprayingOperations;
  private String roadWateringDustRemoval;
  private String supplementaryMatters;
  @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm")
  @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm", timezone = "GMT+8")
  private Date createTime;


  public String getId() {
    return id;
  }

  public void setId(String id) {
    this.id = id;
  }


  public String getTypeCode() {
    return typeCode;
  }

  public void setTypeCode(String typeCode) {
    this.typeCode = typeCode;
  }


  public String getTypeName() {
    return typeName;
  }

  public void setTypeName(String typeName) {
    this.typeName = typeName;
  }


  public Date getDataTime() {
    return dataTime;
  }

  public void setDataTime(Date dataTime) {
    this.dataTime = dataTime;
  }


  public String getPeopleNumber() {
    return peopleNumber;
  }

  public void setPeopleNumber(String peopleNumber) {
    this.peopleNumber = peopleNumber;
  }


  public String getSiteInspection() {
    return siteInspection;
  }

  public void setSiteInspection(String siteInspection) {
    this.siteInspection = siteInspection;
  }


  public String getDealIllegalConstructionSite() {
    return dealIllegalConstructionSite;
  }

  public void setDealIllegalConstructionSite(String dealIllegalConstructionSite) {
    this.dealIllegalConstructionSite = dealIllegalConstructionSite;
  }


  public String getDealIllegalConstructionSiteVocs() {
    return dealIllegalConstructionSiteVocs;
  }

  public void setDealIllegalConstructionSiteVocs(String dealIllegalConstructionSiteVocs) {
    this.dealIllegalConstructionSiteVocs = dealIllegalConstructionSiteVocs;
  }


  public String getDealIllegalConstructionSiteVocsArea() {
    return dealIllegalConstructionSiteVocsArea;
  }

  public void setDealIllegalConstructionSiteVocsArea(String dealIllegalConstructionSiteVocsArea) {
    this.dealIllegalConstructionSiteVocsArea = dealIllegalConstructionSiteVocsArea;
  }


  public String getDealIllegalConstructionSiteEarthwork() {
    return dealIllegalConstructionSiteEarthwork;
  }

  public void setDealIllegalConstructionSiteEarthwork(String dealIllegalConstructionSiteEarthwork) {
    this.dealIllegalConstructionSiteEarthwork = dealIllegalConstructionSiteEarthwork;
  }


  public String getDealIllegalConstructionSiteEarthworkArea() {
    return dealIllegalConstructionSiteEarthworkArea;
  }

  public void setDealIllegalConstructionSiteEarthworkArea(String dealIllegalConstructionSiteEarthworkArea) {
    this.dealIllegalConstructionSiteEarthworkArea = dealIllegalConstructionSiteEarthworkArea;
  }


  public String getDealIllegalConstructionNonRoadMobileMachinery() {
    return dealIllegalConstructionNonRoadMobileMachinery;
  }

  public void setDealIllegalConstructionNonRoadMobileMachinery(String dealIllegalConstructionNonRoadMobileMachinery) {
    this.dealIllegalConstructionNonRoadMobileMachinery = dealIllegalConstructionNonRoadMobileMachinery;
  }


  public String getDealIllegalConstructionSiteVocsTimes() {
    return dealIllegalConstructionSiteVocsTimes;
  }

  public void setDealIllegalConstructionSiteVocsTimes(String dealIllegalConstructionSiteVocsTimes) {
    this.dealIllegalConstructionSiteVocsTimes = dealIllegalConstructionSiteVocsTimes;
  }


  public String getIndustrialInspection() {
    return industrialInspection;
  }

  public void setIndustrialInspection(String industrialInspection) {
    this.industrialInspection = industrialInspection;
  }


  public String getIndustrialIllegal() {
    return industrialIllegal;
  }

  public void setIndustrialIllegal(String industrialIllegal) {
    this.industrialIllegal = industrialIllegal;
  }


  public String getInspectGarage() {
    return inspectGarage;
  }

  public void setInspectGarage(String inspectGarage) {
    this.inspectGarage = inspectGarage;
  }


  public String getIllegalSprayingInspectGarage() {
    return illegalSprayingInspectGarage;
  }

  public void setIllegalSprayingInspectGarage(String illegalSprayingInspectGarage) {
    this.illegalSprayingInspectGarage = illegalSprayingInspectGarage;
  }


  public String getInspectConcreteMixingStation() {
    return inspectConcreteMixingStation;
  }

  public void setInspectConcreteMixingStation(String inspectConcreteMixingStation) {
    this.inspectConcreteMixingStation = inspectConcreteMixingStation;
  }


  public String getIllegalConcreteMixingStation() {
    return illegalConcreteMixingStation;
  }

  public void setIllegalConcreteMixingStation(String illegalConcreteMixingStation) {
    this.illegalConcreteMixingStation = illegalConcreteMixingStation;
  }


  public String getInspectAsphaltMixingStation() {
    return inspectAsphaltMixingStation;
  }

  public void setInspectAsphaltMixingStation(String inspectAsphaltMixingStation) {
    this.inspectAsphaltMixingStation = inspectAsphaltMixingStation;
  }


  public String getIllegalAsphaltMixingStation() {
    return illegalAsphaltMixingStation;
  }

  public void setIllegalAsphaltMixingStation(String illegalAsphaltMixingStation) {
    this.illegalAsphaltMixingStation = illegalAsphaltMixingStation;
  }


  public String getDealGasStation() {
    return dealGasStation;
  }

  public void setDealGasStation(String dealGasStation) {
    this.dealGasStation = dealGasStation;
  }


  public String getIllegalGasStation() {
    return illegalGasStation;
  }

  public void setIllegalGasStation(String illegalGasStation) {
    this.illegalGasStation = illegalGasStation;
  }


  public String getDealOilDepot() {
    return dealOilDepot;
  }

  public void setDealOilDepot(String dealOilDepot) {
    this.dealOilDepot = dealOilDepot;
  }


  public String getIllegalOilDepot() {
    return illegalOilDepot;
  }

  public void setIllegalOilDepot(String illegalOilDepot) {
    this.illegalOilDepot = illegalOilDepot;
  }


  public String getDealIllegalSlagTruck() {
    return dealIllegalSlagTruck;
  }

  public void setDealIllegalSlagTruck(String dealIllegalSlagTruck) {
    this.dealIllegalSlagTruck = dealIllegalSlagTruck;
  }


  public String getDealIllegalCementTanker() {
    return dealIllegalCementTanker;
  }

  public void setDealIllegalCementTanker(String dealIllegalCementTanker) {
    this.dealIllegalCementTanker = dealIllegalCementTanker;
  }


  public String getDealIllegalAsphaltTanker() {
    return dealIllegalAsphaltTanker;
  }

  public void setDealIllegalAsphaltTanker(String dealIllegalAsphaltTanker) {
    this.dealIllegalAsphaltTanker = dealIllegalAsphaltTanker;
  }


  public String getBusFrequency() {
    return busFrequency;
  }

  public void setBusFrequency(String busFrequency) {
    this.busFrequency = busFrequency;
  }


  public String getBusNum() {
    return busNum;
  }

  public void setBusNum(String busNum) {
    this.busNum = busNum;
  }


  public String getSubwayPassengerVolume() {
    return subwayPassengerVolume;
  }

  public void setSubwayPassengerVolume(String subwayPassengerVolume) {
    this.subwayPassengerVolume = subwayPassengerVolume;
  }


  public String getSubwayRunningTrain() {
    return subwayRunningTrain;
  }

  public void setSubwayRunningTrain(String subwayRunningTrain) {
    this.subwayRunningTrain = subwayRunningTrain;
  }


  public String getTotalVehicleFlow() {
    return totalVehicleFlow;
  }

  public void setTotalVehicleFlow(String totalVehicleFlow) {
    this.totalVehicleFlow = totalVehicleFlow;
  }


  public String getBanOutdoorBarbecueStalls() {
    return banOutdoorBarbecueStalls;
  }

  public void setBanOutdoorBarbecueStalls(String banOutdoorBarbecueStalls) {
    this.banOutdoorBarbecueStalls = banOutdoorBarbecueStalls;
  }


  public String getDealWithOpenBurning() {
    return dealWithOpenBurning;
  }

  public void setDealWithOpenBurning(String dealWithOpenBurning) {
    this.dealWithOpenBurning = dealWithOpenBurning;
  }


  public String getIllegalPruningPesticideSprayingOperations() {
    return illegalPruningPesticideSprayingOperations;
  }

  public void setIllegalPruningPesticideSprayingOperations(String illegalPruningPesticideSprayingOperations) {
    this.illegalPruningPesticideSprayingOperations = illegalPruningPesticideSprayingOperations;
  }


  public String getRoadWateringDustRemoval() {
    return roadWateringDustRemoval;
  }

  public void setRoadWateringDustRemoval(String roadWateringDustRemoval) {
    this.roadWateringDustRemoval = roadWateringDustRemoval;
  }


  public String getSupplementaryMatters() {
    return supplementaryMatters;
  }

  public void setSupplementaryMatters(String supplementaryMatters) {
    this.supplementaryMatters = supplementaryMatters;
  }


  public Date getCreateTime() {
    return createTime;
  }

  public void setCreateTime(Date createTime) {
    this.createTime = createTime;
  }

}

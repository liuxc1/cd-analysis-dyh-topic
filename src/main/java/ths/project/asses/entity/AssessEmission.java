package ths.project.asses.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import ths.project.common.entity.BaseEntity;

@TableName("T_ASSESS_EMISSION" )
public class AssessEmission extends BaseEntity {

  @TableId
  private String emissionId;
  private String sceneId;
  private String emissionType;
  private String emissionName;
  private Integer emissionBigType;
  private String emissionCompanyType;
  private String emissionCompanyName;
  private String alertLevel;
  private String alertLevelType;
  private String pm10;
  private String pm25;
  private String so2;
  private String nox;
  private String vocs;



  public String getEmissionId() {
    return emissionId;
  }

  public void setEmissionId(String emissionId) {
    this.emissionId = emissionId;
  }


  public String getSceneId() {
    return sceneId;
  }

  public void setSceneId(String sceneId) {
    this.sceneId = sceneId;
  }


  public String getEmissionType() {
    return emissionType;
  }

  public void setEmissionType(String emissionType) {
    this.emissionType = emissionType;
  }


  public String getEmissionName() {
    return emissionName;
  }

  public void setEmissionName(String emissionName) {
    this.emissionName = emissionName;
  }


  public Integer getEmissionBigType() {
    return emissionBigType;
  }

  public void setEmissionBigType(Integer emissionBigType) {
    this.emissionBigType = emissionBigType;
  }


  public String getEmissionCompanyType() {
    return emissionCompanyType;
  }

  public void setEmissionCompanyType(String emissionCompanyType) {
    this.emissionCompanyType = emissionCompanyType;
  }


  public String getEmissionCompanyName() {
    return emissionCompanyName;
  }

  public void setEmissionCompanyName(String emissionCompanyName) {
    this.emissionCompanyName = emissionCompanyName;
  }


  public String getAlertLevel() {
    return alertLevel;
  }

  public void setAlertLevel(String alertLevel) {
    this.alertLevel = alertLevel;
  }


  public String getPm10() {
    return pm10;
  }

  public void setPm10(String pm10) {
    this.pm10 = pm10;
  }


  public String getPm25() {
    return pm25;
  }

  public void setPm25(String pm25) {
    this.pm25 = pm25;
  }


  public String getSo2() {
    return so2;
  }

  public void setSo2(String so2) {
    this.so2 = so2;
  }


  public String getNox() {
    return nox;
  }

  public void setNox(String nox) {
    this.nox = nox;
  }


  public String getVocs() {
    return vocs;
  }

  public void setVocs(String vocs) {
    this.vocs = vocs;
  }

  public String getAlertLevelType() {
    return alertLevelType;
  }

  public void setAlertLevelType(String alertLevelType) {
    this.alertLevelType = alertLevelType;
  }
}

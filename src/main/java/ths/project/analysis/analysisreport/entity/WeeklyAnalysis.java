package ths.project.analysis.analysisreport.entity;


import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

@TableName(value = "T_WEEKLY_ANALYSIS", schema = "AIR_ANALYSISREPORT")
public class WeeklyAnalysis {

  @TableId
  private String reportId;
  private String ascriptionType;
  private String reportName;
  @DateTimeFormat(pattern = "yyyy-MM-dd")
  @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "GMT+8")
  private Date reportTime;
  private String reportTip;
  private String state;
  private String reportNum;
  @DateTimeFormat(pattern = "yyyy-MM-dd")
  @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "GMT+8")
  private Date stratTime;
  private String text1;
  private String text2;
  private String text3;
  private String text4;
  @DateTimeFormat(pattern = "yyyy-MM-dd")
  @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "GMT+8")
  private Date earlyTime;
  private String earlyTextSd;
  private String earlyText;
  private String earlyWaether;
  private String earlyTransformRate;
  private String earlyProportion;
  private String earlyActivity;
  private String earlySummary;
  @DateTimeFormat(pattern = "yyyy-MM-dd")
  @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "GMT+8")
  private Date laterTime;
  private String laterTextSd;
  private String laterText;
  private String laterWaether;
  private String laterTransformRate;
  private String laterProportion;
  private String laterActivity;
  private String laterSummary;
  private String weekEarlyText;
  private String weekLaterText;
  private String advAdvise;
  @DateTimeFormat(pattern = "yyyy-MM-dd")
  @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "GMT+8")
  private Date createTime;
  private String createUser;
  @DateTimeFormat(pattern = "yyyy-MM-dd")
  @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "GMT+8")
  private Date editTime;
  private String editUser;
  @DateTimeFormat(pattern = "yyyy-MM-dd")
  @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "GMT+8")
  private Date updateTime;
  private String updateUser;
  private long deleteFlag;
  @DateTimeFormat(pattern = "yyyy-MM-dd")
  @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "GMT+8")
  private Date endTime;
  private String earlyHumidity;
  private String laterHumidity;
  private String earlyHeightStart;
  private String earlyHeightEnd;
  private String laterHeightStart;
  private String laterHeightEnd;
  private String text5;
  private String text6;
  private String text7;
  private String text8;
  private String ynum;
  private String lnum;
  private String qdnum;
  private String zdnum;
  private String zzdnum;
  private String pm25;
  private String pm10;
  private String so2;
  private String no2;
  private String o3;
  private String co;
  private String txtynum2;
  private String txtlnum2;
  private String txtqdnum2;
  private String txtzdnum2;
  private String txtthisyear2;
  private String isAdd;
  private String addNum;
  private String txtpm252;
  private String txtpm102;
  private String ratepm25;
  private String ratepm10;
  private String datavalidity;
  private String spm25;
  private String yjz;
  private String dqys;
  private String xsg;
  private String lsg;
  private String aglz;
  private String pams56;
  private String wlys;
  private String yst;
  private String llz;
  private String xt;
  private String wt;
  private String fxt;
  private String rateIsAdd;
  private String rankingO3;
  private String rankingPm25;
  private String rankingPm10;
  private String rankingNo2;
  private String rankingSo2;
  private String rankingCo;
  private String bz;
  private String sg;
  private String qf;
  private String ztc;
  private String zs;
  private String nor;
  private String sor;
  private String laterProportionRate;
  private String ofp;
  private String enor;
  private String esor;
  private String eofp;
  private String earlyProportionRate;
  private String yznum;
  private String numpm25;
  private String numpm10;
  private String numso2;
  private String numo3;
  private String numno2;
  private String numco;
  private String isaddpm25;

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


  public String getReportTip() {
    return reportTip;
  }

  public void setReportTip(String reportTip) {
    this.reportTip = reportTip;
  }


  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
  }


  public String getReportNum() {
    return reportNum;
  }

  public void setReportNum(String reportNum) {
    this.reportNum = reportNum;
  }


  public Date getStratTime() {
    return stratTime;
  }

  public void setStratTime(Date stratTime) {
    this.stratTime = stratTime;
  }


  public String getText1() {
    return text1;
  }

  public void setText1(String text1) {
    this.text1 = text1;
  }


  public String getText2() {
    return text2;
  }

  public void setText2(String text2) {
    this.text2 = text2;
  }


  public String getText3() {
    return text3;
  }

  public void setText3(String text3) {
    this.text3 = text3;
  }


  public String getText4() {
    return text4;
  }

  public void setText4(String text4) {
    this.text4 = text4;
  }


  public Date getEarlyTime() {
    return earlyTime;
  }

  public void setEarlyTime(Date earlyTime) {
    this.earlyTime = earlyTime;
  }


  public String getEarlyTextSd() {
    return earlyTextSd;
  }

  public void setEarlyTextSd(String earlyTextSd) {
    this.earlyTextSd = earlyTextSd;
  }


  public String getEarlyText() {
    return earlyText;
  }

  public void setEarlyText(String earlyText) {
    this.earlyText = earlyText;
  }


  public String getEarlyWaether() {
    return earlyWaether;
  }

  public void setEarlyWaether(String earlyWaether) {
    this.earlyWaether = earlyWaether;
  }


  public String getEarlyTransformRate() {
    return earlyTransformRate;
  }

  public void setEarlyTransformRate(String earlyTransformRate) {
    this.earlyTransformRate = earlyTransformRate;
  }


  public String getEarlyProportion() {
    return earlyProportion;
  }

  public void setEarlyProportion(String earlyProportion) {
    this.earlyProportion = earlyProportion;
  }


  public String getEarlyActivity() {
    return earlyActivity;
  }

  public void setEarlyActivity(String earlyActivity) {
    this.earlyActivity = earlyActivity;
  }


  public String getEarlySummary() {
    return earlySummary;
  }

  public void setEarlySummary(String earlySummary) {
    this.earlySummary = earlySummary;
  }





  public Date getLaterTime() {
    return laterTime;
  }

  public void setLaterTime(Date laterTime) {
    this.laterTime = laterTime;
  }


  public String getLaterTextSd() {
    return laterTextSd;
  }

  public void setLaterTextSd(String laterTextSd) {
    this.laterTextSd = laterTextSd;
  }


  public String getLaterText() {
    return laterText;
  }

  public void setLaterText(String laterText) {
    this.laterText = laterText;
  }


  public String getLaterWaether() {
    return laterWaether;
  }

  public void setLaterWaether(String laterWaether) {
    this.laterWaether = laterWaether;
  }


  public String getLaterTransformRate() {
    return laterTransformRate;
  }

  public void setLaterTransformRate(String laterTransformRate) {
    this.laterTransformRate = laterTransformRate;
  }


  public String getLaterProportion() {
    return laterProportion;
  }

  public void setLaterProportion(String laterProportion) {
    this.laterProportion = laterProportion;
  }


  public String getLaterActivity() {
    return laterActivity;
  }

  public void setLaterActivity(String laterActivity) {
    this.laterActivity = laterActivity;
  }


  public String getLaterSummary() {
    return laterSummary;
  }

  public void setLaterSummary(String laterSummary) {
    this.laterSummary = laterSummary;
  }


  public String getWeekEarlyText() {
    return weekEarlyText;
  }

  public void setWeekEarlyText(String weekEarlyText) {
    this.weekEarlyText = weekEarlyText;
  }


  public String getWeekLaterText() {
    return weekLaterText;
  }

  public void setWeekLaterText(String weekLaterText) {
    this.weekLaterText = weekLaterText;
  }


  public String getAdvAdvise() {
    return advAdvise;
  }

  public void setAdvAdvise(String advAdvise) {
    this.advAdvise = advAdvise;
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


  public Date getEndTime() {
    return endTime;
  }

  public void setEndTime(Date endTime) {
    this.endTime = endTime;
  }

  public String getEarlyHumidity() {
    return earlyHumidity;
  }

  public void setEarlyHumidity(String earlyHumidity) {
    this.earlyHumidity = earlyHumidity;
  }


  public String getLaterHumidity() {
    return laterHumidity;
  }

  public void setLaterHumidity(String laterHumidity) {
    this.laterHumidity = laterHumidity;
  }


  public String getEarlyHeightStart() {
    return earlyHeightStart;
  }

  public void setEarlyHeightStart(String earlyHeightStart) {
    this.earlyHeightStart = earlyHeightStart;
  }


  public String getEarlyHeightEnd() {
    return earlyHeightEnd;
  }

  public void setEarlyHeightEnd(String earlyHeightEnd) {
    this.earlyHeightEnd = earlyHeightEnd;
  }


  public String getLaterHeightStart() {
    return laterHeightStart;
  }

  public void setLaterHeightStart(String laterHeightStart) {
    this.laterHeightStart = laterHeightStart;
  }


  public String getLaterHeightEnd() {
    return laterHeightEnd;
  }

  public void setLaterHeightEnd(String laterHeightEnd) {
    this.laterHeightEnd = laterHeightEnd;
  }


  public String getText5() {
    return text5;
  }

  public void setText5(String text5) {
    this.text5 = text5;
  }


  public String getText6() {
    return text6;
  }

  public void setText6(String text6) {
    this.text6 = text6;
  }


  public String getText7() {
    return text7;
  }

  public void setText7(String text7) {
    this.text7 = text7;
  }


  public String getText8() {
    return text8;
  }

  public void setText8(String text8) {
    this.text8 = text8;
  }

  public String getYnum() {
    return ynum;
  }

  public void setYnum(String ynum) {
    this.ynum = ynum;
  }

  public String getLnum() {
    return lnum;
  }

  public void setLnum(String lnum) {
    this.lnum = lnum;
  }

  public String getQdnum() {
    return qdnum;
  }

  public void setQdnum(String qdnum) {
    this.qdnum = qdnum;
  }

  public String getPm25() {
    return pm25;
  }

  public void setPm25(String pm25) {
    this.pm25 = pm25;
  }

  public String getPm10() {
    return pm10;
  }

  public void setPm10(String pm10) {
    this.pm10 = pm10;
  }

  public String getSo2() {
    return so2;
  }

  public void setSo2(String so2) {
    this.so2 = so2;
  }

  public String getNo2() {
    return no2;
  }

  public void setNo2(String no2) {
    this.no2 = no2;
  }

  public String getO3() {
    return o3;
  }

  public void setO3(String o3) {
    this.o3 = o3;
  }

  public String getCo() {
    return co;
  }

  public void setCo(String co) {
    this.co = co;
  }



  public String getIsAdd() {
    return isAdd;
  }

  public void setIsAdd(String isAdd) {
    this.isAdd = isAdd;
  }

  public String getZdnum() {
    return zdnum;
  }

  public void setZdnum(String zdnum) {
    this.zdnum = zdnum;
  }

  public String getZzdnum() {
    return zzdnum;
  }

  public void setZzdnum(String zzdnum) {
    this.zzdnum = zzdnum;
  }

  public String getTxtynum2() {
    return txtynum2;
  }

  public void setTxtynum2(String txtynum2) {
    this.txtynum2 = txtynum2;
  }

  public String getTxtlnum2() {
    return txtlnum2;
  }

  public void setTxtlnum2(String txtlnum2) {
    this.txtlnum2 = txtlnum2;
  }

  public String getTxtqdnum2() {
    return txtqdnum2;
  }

  public void setTxtqdnum2(String txtqdnum2) {
    this.txtqdnum2 = txtqdnum2;
  }

  public String getTxtzdnum2() {
    return txtzdnum2;
  }

  public void setTxtzdnum2(String txtzdnum2) {
    this.txtzdnum2 = txtzdnum2;
  }

  public String getTxtthisyear2() {
    return txtthisyear2;
  }

  public void setTxtthisyear2(String txtthisyear2) {
    this.txtthisyear2 = txtthisyear2;
  }

  public String getAddNum() {
    return addNum;
  }

  public void setAddNum(String addNum) {
    this.addNum = addNum;
  }

  public String getTxtpm252() {
    return txtpm252;
  }

  public void setTxtpm252(String txtpm252) {
    this.txtpm252 = txtpm252;
  }

  public String getTxtpm102() {
    return txtpm102;
  }

  public void setTxtpm102(String txtpm102) {
    this.txtpm102 = txtpm102;
  }

  public String getRatepm25() {
    return ratepm25;
  }

  public void setRatepm25(String ratepm25) {
    this.ratepm25 = ratepm25;
  }

  public String getRatepm10() {
    return ratepm10;
  }

  public void setRatepm10(String ratepm10) {
    this.ratepm10 = ratepm10;
  }

  public String getDatavalidity() {
    return datavalidity;
  }

  public void setDatavalidity(String datavalidity) {
    this.datavalidity = datavalidity;
  }

  public String getSpm25() {
    return spm25;
  }

  public void setSpm25(String spm25) {
    this.spm25 = spm25;
  }

  public String getYjz() {
    return yjz;
  }

  public void setYjz(String yjz) {
    this.yjz = yjz;
  }

  public String getDqys() {
    return dqys;
  }

  public void setDqys(String dqys) {
    this.dqys = dqys;
  }

  public String getXsg() {
    return xsg;
  }

  public void setXsg(String xsg) {
    this.xsg = xsg;
  }

  public String getLsg() {
    return lsg;
  }

  public void setLsg(String lsg) {
    this.lsg = lsg;
  }

  public String getAglz() {
    return aglz;
  }

  public void setAglz(String aglz) {
    this.aglz = aglz;
  }

  public String getPams56() {
    return pams56;
  }

  public void setPams56(String pams56) {
    this.pams56 = pams56;
  }

  public String getWlys() {
    return wlys;
  }

  public void setWlys(String wlys) {
    this.wlys = wlys;
  }

  public String getYst() {
    return yst;
  }

  public void setYst(String yst) {
    this.yst = yst;
  }

  public String getLlz() {
    return llz;
  }

  public void setLlz(String llz) {
    this.llz = llz;
  }

  public String getXt() {
    return xt;
  }

  public void setXt(String xt) {
    this.xt = xt;
  }

  public String getWt() {
    return wt;
  }

  public void setWt(String wt) {
    this.wt = wt;
  }

  public String getFxt() {
    return fxt;
  }

  public void setFxt(String fxt) {
    this.fxt = fxt;
  }

  public String getRateIsAdd() {
    return rateIsAdd;
  }

  public void setRateIsAdd(String rateIsAdd) {
    this.rateIsAdd = rateIsAdd;
  }

  public String getRankingO3() {
    return rankingO3;
  }

  public void setRankingO3(String rankingO3) {
    this.rankingO3 = rankingO3;
  }

  public String getRankingPm25() {
    return rankingPm25;
  }

  public void setRankingPm25(String rankingPm25) {
    this.rankingPm25 = rankingPm25;
  }

  public String getRankingPm10() {
    return rankingPm10;
  }

  public void setRankingPm10(String rankingPm10) {
    this.rankingPm10 = rankingPm10;
  }

  public String getRankingNo2() {
    return rankingNo2;
  }

  public void setRankingNo2(String rankingNo2) {
    this.rankingNo2 = rankingNo2;
  }

  public String getRankingSo2() {
    return rankingSo2;
  }

  public void setRankingSo2(String rankingSo2) {
    this.rankingSo2 = rankingSo2;
  }

  public String getRankingCo() {
    return rankingCo;
  }

  public void setRankingCo(String rankingCo) {
    this.rankingCo = rankingCo;
  }

  public String getBz() {
    return bz;
  }

  public void setBz(String bz) {
    this.bz = bz;
  }

  public String getSg() {
    return sg;
  }

  public void setSg(String sg) {
    this.sg = sg;
  }

  public String getQf() {
    return qf;
  }

  public void setQf(String qf) {
    this.qf = qf;
  }

  public String getZtc() {
    return ztc;
  }

  public void setZtc(String ztc) {
    this.ztc = ztc;
  }

  public String getZs() {
    return zs;
  }

  public void setZs(String zs) {
    this.zs = zs;
  }

  public String getNor() {
    return nor;
  }

  public void setNor(String nor) {
    this.nor = nor;
  }

  public String getSor() {
    return sor;
  }

  public void setSor(String sor) {
    this.sor = sor;
  }

  public String getLaterProportionRate() {
    return laterProportionRate;
  }

  public void setLaterProportionRate(String laterProportionRate) {
    this.laterProportionRate = laterProportionRate;
  }

  public String getOfp() {
    return ofp;
  }

  public void setOfp(String ofp) {
    this.ofp = ofp;
  }

  public String getEnor() {
    return enor;
  }

  public void setEnor(String enor) {
    this.enor = enor;
  }

  public String getEsor() {
    return esor;
  }

  public void setEsor(String esor) {
    this.esor = esor;
  }

  public String getEofp() {
    return eofp;
  }

  public void setEofp(String eofp) {
    this.eofp = eofp;
  }

  public String getEarlyProportionRate() {
    return earlyProportionRate;
  }

  public void setEarlyProportionRate(String earlyProportionRate) {
    this.earlyProportionRate = earlyProportionRate;
  }

  public String getYznum() {
    return yznum;
  }

  public void setYznum(String yznum) {
    this.yznum = yznum;
  }

  public String getNumpm25() {
    return numpm25;
  }

  public void setNumpm25(String numpm25) {
    this.numpm25 = numpm25;
  }

  public String getNumpm10() {
    return numpm10;
  }

  public void setNumpm10(String numpm10) {
    this.numpm10 = numpm10;
  }

  public String getNumso2() {
    return numso2;
  }

  public void setNumso2(String numso2) {
    this.numso2 = numso2;
  }

  public String getNumo3() {
    return numo3;
  }

  public void setNumo3(String numo3) {
    this.numo3 = numo3;
  }

  public String getNumno2() {
    return numno2;
  }

  public void setNumno2(String numno2) {
    this.numno2 = numno2;
  }

  public String getNumco() {
    return numco;
  }

  public void setNumco(String numco) {
    this.numco = numco;
  }

  public String getIsaddpm25() {
    return isaddpm25;
  }

  public void setIsaddpm25(String isaddpm25) {
    this.isaddpm25 = isaddpm25;
  }
}

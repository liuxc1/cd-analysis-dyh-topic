package ths.project.analysis.forecast.airforecastmonth.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;
import java.util.Objects;

@TableName(value = "T_ANS_MONTH_FORECAST ", schema = "dbo")
public class TAnsMonthForecast {
    @TableId
    private String forecastId;
    private String ascriptionType;
    private String ascriptionId;
    private String cityCode;
    private String cityName;
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm", timezone = "GMT+8")
    private Date modelTime;
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm", timezone = "GMT+8")
    private Date resultTime1;
    private String level1;
    private String level2;
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm", timezone = "GMT+8")
    private Date resultTime2;
    private String level3;
    private String level4;
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm", timezone = "GMT+8")
    private Date resultTime3;
    private String level5;
    private String level6;
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm", timezone = "GMT+8")
    private Date createTime;
    private String createDept;
    private String createUser;
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm", timezone = "GMT+8")
    private Date editTime;
    private String editUser;

    public String getForecastId() {
        return forecastId;
    }

    public String getAscriptionType() {
        return ascriptionType;
    }

    public String getAscriptionId() {
        return ascriptionId;
    }

    public String getCityCode() {
        return cityCode;
    }

    public String getCityName() {
        return cityName;
    }

    public Date getModelTime() {
        return modelTime;
    }

    public Date getResultTime1() {
        return resultTime1;
    }

    public String getLevel1() {
        return level1;
    }

    public String getLevel2() {
        return level2;
    }

    public Date getResultTime2() {
        return resultTime2;
    }

    public String getLevel3() {
        return level3;
    }

    public String getLevel4() {
        return level4;
    }

    public Date getResultTime3() {
        return resultTime3;
    }

    public String getLevel5() {
        return level5;
    }

    public String getLevel6() {
        return level6;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public String getCreateDept() {
        return createDept;
    }

    public String getCreateUser() {
        return createUser;
    }

    public Date getEditTime() {
        return editTime;
    }

    public String getEditUser() {
        return editUser;
    }

    public void setForecastId(String forecastId) {
        this.forecastId = forecastId;
    }

    public void setAscriptionType(String ascriptionType) {
        this.ascriptionType = ascriptionType;
    }

    public void setAscriptionId(String ascriptionId) {
        this.ascriptionId = ascriptionId;
    }

    public void setCityCode(String cityCode) {
        this.cityCode = cityCode;
    }

    public void setCityName(String cityName) {
        this.cityName = cityName;
    }

    public void setModelTime(Date modelTime) {
        this.modelTime = modelTime;
    }

    public void setResultTime1(Date resultTime1) {
        this.resultTime1 = resultTime1;
    }

    public void setLevel1(String level1) {
        this.level1 = level1;
    }

    public void setLevel2(String level2) {
        this.level2 = level2;
    }

    public void setResultTime2(Date resultTime2) {
        this.resultTime2 = resultTime2;
    }

    public void setLevel3(String level3) {
        this.level3 = level3;
    }

    public void setLevel4(String level4) {
        this.level4 = level4;
    }

    public void setResultTime3(Date resultTime3) {
        this.resultTime3 = resultTime3;
    }

    public void setLevel5(String level5) {
        this.level5 = level5;
    }

    public void setLevel6(String level6) {
        this.level6 = level6;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public void setCreateDept(String createDept) {
        this.createDept = createDept;
    }

    public void setCreateUser(String createUser) {
        this.createUser = createUser;
    }

    public void setEditTime(Date editTime) {
        this.editTime = editTime;
    }

    public TAnsMonthForecast() {
    }

    public void setEditUser(String editUser) {
        this.editUser = editUser;
    }

    public TAnsMonthForecast(String forecastId, String ascriptionType, String ascriptionId, String cityCode, String cityName, Date modelTime, Date resultTime1, String level1, String level2, Date resultTime2, String level3, String level4, Date resultTime3, String level5, String level6, Date createTime, String createDept, String createUser, Date editTime, String editUser) {
        this.forecastId = forecastId;
        this.ascriptionType = ascriptionType;
        this.ascriptionId = ascriptionId;
        this.cityCode = cityCode;
        this.cityName = cityName;
        this.modelTime = modelTime;
        this.resultTime1 = resultTime1;
        this.level1 = level1;
        this.level2 = level2;
        this.resultTime2 = resultTime2;
        this.level3 = level3;
        this.level4 = level4;
        this.resultTime3 = resultTime3;
        this.level5 = level5;
        this.level6 = level6;
        this.createTime = createTime;
        this.createDept = createDept;
        this.createUser = createUser;
        this.editTime = editTime;
        this.editUser = editUser;
    }

    @Override
    public String toString() {
        return "TAnsMonthForecast{" +
                "forecastId='" + forecastId + '\'' +
                ", ascriptionType='" + ascriptionType + '\'' +
                ", ascriptionId='" + ascriptionId + '\'' +
                ", cityCode='" + cityCode + '\'' +
                ", cityName='" + cityName + '\'' +
                ", modelTime=" + modelTime +
                ", resultTime1=" + resultTime1 +
                ", level1='" + level1 + '\'' +
                ", level2='" + level2 + '\'' +
                ", resultTime2=" + resultTime2 +
                ", level3='" + level3 + '\'' +
                ", level4='" + level4 + '\'' +
                ", resultTime3=" + resultTime3 +
                ", level5='" + level5 + '\'' +
                ", level6='" + level6 + '\'' +
                ", createTime=" + createTime +
                ", createDept='" + createDept + '\'' +
                ", createUser='" + createUser + '\'' +
                ", editTime=" + editTime +
                ", editUser='" + editUser + '\'' +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        TAnsMonthForecast that = (TAnsMonthForecast) o;
        return Objects.equals(forecastId, that.forecastId) &&
                Objects.equals(ascriptionType, that.ascriptionType) &&
                Objects.equals(ascriptionId, that.ascriptionId) &&
                Objects.equals(cityCode, that.cityCode) &&
                Objects.equals(cityName, that.cityName) &&
                Objects.equals(modelTime, that.modelTime) &&
                Objects.equals(resultTime1, that.resultTime1) &&
                Objects.equals(level1, that.level1) &&
                Objects.equals(level2, that.level2) &&
                Objects.equals(resultTime2, that.resultTime2) &&
                Objects.equals(level3, that.level3) &&
                Objects.equals(level4, that.level4) &&
                Objects.equals(resultTime3, that.resultTime3) &&
                Objects.equals(level5, that.level5) &&
                Objects.equals(level6, that.level6) &&
                Objects.equals(createTime, that.createTime) &&
                Objects.equals(createDept, that.createDept) &&
                Objects.equals(createUser, that.createUser) &&
                Objects.equals(editTime, that.editTime) &&
                Objects.equals(editUser, that.editUser);
    }

    @Override
    public int hashCode() {
        return Objects.hash(forecastId, ascriptionType, ascriptionId, cityCode, cityName, modelTime, resultTime1, level1, level2, resultTime2, level3, level4, resultTime3, level5, level6, createTime, createDept, createUser, editTime, editUser);
    }
}

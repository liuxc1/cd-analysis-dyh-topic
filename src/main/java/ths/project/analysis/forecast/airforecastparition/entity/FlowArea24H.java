package ths.project.analysis.forecast.airforecastparition.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

@TableName(value = "T_ANS_FLOW_AREA_24H")
public class FlowArea24H {
    //主键
    @TableId
    private String pkid;
    //分区预报主键
    private String areaPkid;
    //类型编码
    private String typecode;
    //类型名称
    private String typename;
    //区域编码
    private String regioncode;
    //区域名称
    private String regionname;
    //最小AQI
    private String aqiStart;
    //最大AQI
    private String aqiEnd;
    //AQI等级
    private String aqiLevel;
    //首污
    private String pullname;

    public String getPkid() {
        return pkid;
    }

    public void setPkid(String pkid) {
        this.pkid = pkid;
    }

    public String getAreaPkid() {
        return areaPkid;
    }

    public void setAreaPkid(String areaPkid) {
        this.areaPkid = areaPkid;
    }

    public String getTypecode() {
        return typecode;
    }

    public void setTypecode(String typecode) {
        this.typecode = typecode;
    }

    public String getTypename() {
        return typename;
    }

    public void setTypename(String typename) {
        this.typename = typename;
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

    public String getAqiStart() {
        return aqiStart;
    }

    public void setAqiStart(String aqiStart) {
        this.aqiStart = aqiStart;
    }

    public String getAqiEnd() {
        return aqiEnd;
    }

    public void setAqiEnd(String aqiEnd) {
        this.aqiEnd = aqiEnd;
    }

    public String getAqiLevel() {
        return aqiLevel;
    }

    public void setAqiLevel(String aqiLevel) {
        this.aqiLevel = aqiLevel;
    }

    public String getPullname() {
        return pullname;
    }

    public void setPullname(String pullname) {
        this.pullname = pullname;
    }
}

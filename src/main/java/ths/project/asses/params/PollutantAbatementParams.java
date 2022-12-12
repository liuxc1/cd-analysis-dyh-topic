package ths.project.asses.params;

import java.util.List;

public class PollutantAbatementParams {

    private String id;
    /**
     * 减排类型(建筑扬尘减排1,工业减排2,,机动车减排3,其它减排4,全社会减排6)
     */
    private String emissionsType;
    /**
     * 减排的颜色等级(red:红,orange:橙,yellow:黄)
     */
    private String warningColor;
    /**
     * 减排的类型(类型:1吨,2比列)
     */
    private String warningType;
    /**
     * 质量改善信息(1:PM10,2:PM25,3:NO2)
     */
    private String dataType;
    private List<String> list;

    public String getDataType() {
        return dataType;
    }

    public void setDataType(String dataType) {
        this.dataType = dataType;
    }

    public String getEmissionsType() {
        return emissionsType;
    }

    public void setEmissionsType(String emissionsType) {
        this.emissionsType = emissionsType;
    }

    public String getWarningColor() {
        return warningColor;
    }

    public void setWarningColor(String warningColor) {
        this.warningColor = warningColor;
    }

    public String getWarningType() {
        return warningType;
    }

    public void setWarningType(String warningType) {
        this.warningType = warningType;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public List<String> getList() {
        return list;
    }

    public void setList(List<String> list) {
        this.list = list;
    }
}

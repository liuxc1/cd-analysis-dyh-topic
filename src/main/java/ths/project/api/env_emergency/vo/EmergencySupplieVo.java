package ths.project.api.env_emergency.vo;

public class EmergencySupplieVo {

    /**
     * 政务或者企业ID
     */
    private String id;

    /**
     * 政府/企业名称
     */
    private String governmentName;

    /**
     * 类型
     */
    private String materialType;

    /**
     * 物资
     */
    private String materialName;

    /**
     * 距离
     */
    private Integer distance;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getGovernmentName() {
        return governmentName;
    }

    public void setGovernmentName(String governmentName) {
        this.governmentName = governmentName;
    }

    public String getMaterialType() {
        return materialType;
    }

    public void setMaterialType(String materialType) {
        this.materialType = materialType;
    }

    public String getMaterialName() {
        return materialName;
    }

    public void setMaterialName(String materialName) {
        this.materialName = materialName;
    }

    public Integer getDistance() {
        return distance;
    }

    public void setDistance(Integer distance) {
        this.distance = distance;
    }

    public EmergencySupplieVo(String id, String governmentName, String materialType, String materialName, Integer distance) {
        this.id = id;
        this.governmentName = governmentName;
        this.materialType = materialType;
        this.materialName = materialName;
        this.distance = distance;
    }

    public EmergencySupplieVo() {
    }
}

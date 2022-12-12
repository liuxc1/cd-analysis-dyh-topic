package ths.project.api.env_emergency.vo;

public class EmergencySupportTeamVo {

    /**
     * 管理人员
     */
    private Integer managementPerson;

    /**
     * 专家组
     */
    private Integer panel;

    /**
     * 相关单位
     */
    private Integer relevantUnits;

    /**
     * 救援队伍
     */
    private Integer rescueTeams;

    /**
     * 环境监测站
     */
    private Integer environmentalMonitorStation;

    /**
     * 值班人员
     */
    private Integer dutyperson;

    public EmergencySupportTeamVo() {
    }

    public Integer getManagementPerson() {
        return managementPerson;
    }

    public void setManagementPerson(Integer managementPerson) {
        this.managementPerson = managementPerson;
    }

    public Integer getPanel() {
        return panel;
    }

    public void setPanel(Integer panel) {
        this.panel = panel;
    }

    public Integer getRelevantUnits() {
        return relevantUnits;
    }

    public void setRelevantUnits(Integer relevantUnits) {
        this.relevantUnits = relevantUnits;
    }

    public Integer getRescueTeams() {
        return rescueTeams;
    }

    public void setRescueTeams(Integer rescueTeams) {
        this.rescueTeams = rescueTeams;
    }

    public Integer getenvironmentalMonitorStation() {
        return environmentalMonitorStation;
    }

    public void setenvironmentalMonitorStation(Integer environmentalMonitorStation) {
        this.environmentalMonitorStation = environmentalMonitorStation;
    }

    public Integer getDutyperson() {
        return dutyperson;
    }

    public void setDutyperson(Integer dutyperson) {
        this.dutyperson = dutyperson;
    }

    public EmergencySupportTeamVo(Integer managementPerson, Integer panel, Integer relevantUnits, Integer rescueTeams, Integer environmentalMonitorStation, Integer dutyperson) {
        this.managementPerson = managementPerson;
        this.panel = panel;
        this.relevantUnits = relevantUnits;
        this.rescueTeams = rescueTeams;
        this.environmentalMonitorStation = environmentalMonitorStation;
        this.dutyperson = dutyperson;
    }
}

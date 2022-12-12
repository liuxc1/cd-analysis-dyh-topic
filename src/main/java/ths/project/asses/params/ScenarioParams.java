package ths.project.asses.params;

import java.util.List;

public class ScenarioParams {
    /**
     * 场景名称
     */
    private String sceneId;
    private String mainId;
    private String sceneName;
    private Integer deleteFlag;
    /**
     * 返回时使用,是否激活当前面板
     */
    private boolean active;
    /**
     * 是否隐藏删除按钮
     */
    private boolean ariaHidden;
    /**
     * 当前面板位置
     */
    private Integer index;
    /**
     * 污染物减排信息
     */
    private List<PollutantAbatementParams> pollutantList;

    private List<PollutantAbatementParams> quality;



    public boolean isAriaHidden() {
        return ariaHidden;
    }

    public void setAriaHidden(boolean ariaHidden) {
        this.ariaHidden = ariaHidden;
    }


    public List<PollutantAbatementParams> getPollutantList() {
        return pollutantList;
    }

    public void setPollutantList(List<PollutantAbatementParams> pollutantList) {
        this.pollutantList = pollutantList;
    }

    public List<PollutantAbatementParams> getQuality() {
        return quality;
    }

    public void setQuality(List<PollutantAbatementParams> quality) {
        this.quality = quality;
    }


    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public Integer getIndex() {
        return index;
    }

    public void setIndex(Integer index) {
        this.index = index;
    }

    public String getSceneId() {
        return sceneId;
    }

    public void setSceneId(String sceneId) {
        this.sceneId = sceneId;
    }

    public String getMainId() {
        return mainId;
    }

    public void setMainId(String mainId) {
        this.mainId = mainId;
    }

    public String getSceneName() {
        return sceneName;
    }

    public void setSceneName(String sceneName) {
        this.sceneName = sceneName;
    }

    public Integer getDeleteFlag() {
        return deleteFlag;
    }

    public void setDeleteFlag(Integer deleteFlag) {
        this.deleteFlag = deleteFlag;
    }
}

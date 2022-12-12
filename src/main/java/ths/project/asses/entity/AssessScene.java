package ths.project.asses.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import ths.project.common.entity.BaseEntity;

@TableName("T_ASSESS_SCENE" )
public class AssessScene extends BaseEntity {

  @TableId
  private String sceneId;
  private String mainId;
  private String sceneName;



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


}

package ths.project.api.personnelManagement.entity;


import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

@TableName(value = "JDP_OU_USER_STATE",schema="dbo")
public class PersonnelManagement {
    /**
     * 用户id
     */
    @TableId
    private String userId;
    /**
     * 是否为主要负责人
     */
    private Integer isMain;
    /**
     * 是否当值
     */
    private Integer duty;

    public PersonnelManagement() {
    }

    public PersonnelManagement(String userId, Integer isMain, Integer duty) {
        this.userId = userId;
        this.isMain = isMain;
        this.duty = duty;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public Integer getIsMain() {
        return isMain;
    }

    public void setIsMain(Integer isMain) {
        this.isMain = isMain;
    }

    public Integer getDuty() {
        return duty;
    }

    public void setDuty(Integer duty) {
        this.duty = duty;
    }
}

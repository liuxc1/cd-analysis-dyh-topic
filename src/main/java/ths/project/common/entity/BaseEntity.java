package ths.project.common.entity;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.fasterxml.jackson.annotation.JsonFormat;

/**
 * 实体公共属性类
 */
public abstract class BaseEntity {
    /**
     * 逻辑删除标识(0未删除，1已删除)
     */
    @TableField(select = false)
    @TableLogic()
    private Integer deleteFlag;
    /**
     * 创建时间
     */
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm", timezone = "GMT+8")
    private Date createTime;
    /**
     * 创建人
     */
    private String createUser;
    /**
     * 修改时间
     */
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm", timezone = "GMT+8")
    private Date updateTime;
    /**
     * 修改人
     */
    private String updateUser;

    public BaseEntity() {
    }

    public BaseEntity(Integer deleteFlag, Date createTime, String createUser, Date updateTime, String updateUser) {
        this.deleteFlag = deleteFlag;
        this.createTime = createTime;
        this.createUser = createUser;
        this.updateTime = updateTime;
        this.updateUser = updateUser;
    }

    public Integer getDeleteFlag() {
        return deleteFlag;
    }

    public void setDeleteFlag(Integer deleteFlag) {
        this.deleteFlag = deleteFlag;
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

    /**
     * 为部分属性设置默认值（用于创建数据时）
     *
     * @param userName 用户名
     */
    public void resolveCreate(String userName) {
        this.resolveUpdate(userName);
        this.setDeleteFlag(0);
        this.setCreateTime(this.getUpdateTime());
        this.setCreateUser(userName);
    }

    /**
     * 为部分属性设置默认值（用于修改数据时）
     *
     * @param userName 用户名
     */
    public void resolveUpdate(String userName) {
        Date date = new Date();
        this.setUpdateTime(date);
        this.setUpdateUser(userName);
    }

    @Override
    public String toString() {
        return "BaseEntity{" +
                "deleteFlag=" + deleteFlag +
                ", createTime=" + createTime +
                ", createUser='" + createUser + '\'' +
                ", updateTime=" + updateTime +
                ", updateUser='" + updateUser + '\'' +
                "}," + super.toString();
    }
}

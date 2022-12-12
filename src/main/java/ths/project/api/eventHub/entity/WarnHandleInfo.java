package ths.project.api.eventHub.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import ths.project.common.constant.SchemaConstants;

/**
 * @Description 事件枢纽-预警处置信息查询
 * @Author duanzm
 * @Date 2022/9/5 上午10:59
 * @Version 1.0
 **/
@TableName(value = "T_DD_WARN_HANDLE_INFO", schema = SchemaConstants.DEFAULT)
public class WarnHandleInfo {
    private String pkid;
    private String operationDate;
    private String userName;
    private String leaderPos;
    private String groupName;
    private String operationContent;
    private String flowNo;
    private String groupNameOut;
    private String status;

    public WarnHandleInfo() {
    }

    public WarnHandleInfo(String pkid, String operationDate, String userName, String leaderPos, String groupName, String operationContent, String flowNo, String groupNameOut, String status) {
        this.pkid = pkid;
        this.operationDate = operationDate;
        this.userName = userName;
        this.leaderPos = leaderPos;
        this.groupName = groupName;
        this.operationContent = operationContent;
        this.flowNo = flowNo;
        this.groupNameOut = groupNameOut;
        this.status = status;
    }

    public String getPkid() {
        return pkid;
    }

    public void setPkid(String pkid) {
        this.pkid = pkid;
    }

    public String getOperationDate() {
        return operationDate;
    }

    public void setOperationDate(String operationDate) {
        this.operationDate = operationDate;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getLeaderPos() {
        return leaderPos;
    }

    public void setLeaderPos(String leaderPos) {
        this.leaderPos = leaderPos;
    }

    public String getGroupName() {
        return groupName;
    }

    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }

    public String getOperationContent() {
        return operationContent;
    }

    public void setOperationContent(String operationContent) {
        this.operationContent = operationContent;
    }

    public String getFlowNo() {
        return flowNo;
    }

    public void setFlowNo(String flowNo) {
        this.flowNo = flowNo;
    }

    public String getGroupNameOut() {
        return groupNameOut;
    }

    public void setGroupNameOut(String groupNameOut) {
        this.groupNameOut = groupNameOut;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}

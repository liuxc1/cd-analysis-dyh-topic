package ths.project.system.message.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import ths.project.system.message.enums.MessageTypeEnum;
import ths.project.system.message.enums.SendStateEnum;
import ths.project.system.message.enums.SendTypeEnum;

import java.util.Date;

/**
 * 推送日志
 */
@TableName(value = "T_ANS_SEND_LOG")
public class SendLog {
    @TableId
    private String sendId;
    private String ascriptionType;
    private String ascriptionId;
    private String sendType;
    private String messageType;
    private String fileId;
    private String sendAddr;
    private String sendState;
    private String sendContent;
    private String responseContent;
    private String autoSend;
    private Integer sendFrequency;
    private String state;
    private Date createTime;
    private Date sendTime;
    private String sendUser;
    private String remark;

    private String ext1;
    private String ext2;
    private String ext3;
    private String ext4;

    public SendLog() {

    }

    /**
     * 封装推送日志数据
     *
     * @param ascriptionType  归属类型
     * @param ascriptionId    归属ID
     * @param sendType        推送类型
     * @param messageType     消息类型，参考MessageTypeEnum
     * @param fileId          文件ID，可为空
     * @param sendAddr        推送地址
     * @param sendState       推送状态，参考SendStateEnum
     * @param sendContent     推送内容
     * @param responseContent 响应结果
     * @param autoSend        是否自动发送（Y/N）
     * @param sendUser        推送人，可为空
     * @param sendFrequency   重试次数
     * @param state           状态，可为空
     * @param remark          备注，可为空
     */
    public SendLog(String ascriptionType, String ascriptionId, SendTypeEnum sendType, MessageTypeEnum messageType
            , String fileId, String sendAddr, SendStateEnum sendState, String sendContent, String responseContent
            , String autoSend, Integer sendFrequency, String state, Date sendTime, String sendUser, String remark) {
        this.ascriptionType = ascriptionType;
        this.ascriptionId = ascriptionId;
        this.sendType = sendType.name();
        this.messageType = messageType.name();
        this.fileId = fileId;
        this.sendAddr = sendAddr;
        this.sendState = sendState.name();
        this.sendContent = sendContent;
        this.responseContent = responseContent;
        this.autoSend = autoSend;
        this.sendFrequency = sendFrequency;
        this.state = state;
        this.sendTime = sendTime;
        this.sendUser = sendUser;
        this.remark = remark;
    }

    public String getSendId() {
        return sendId;
    }

    public void setSendId(String sendId) {
        this.sendId = sendId;
    }

    public String getAscriptionType() {
        return ascriptionType;
    }

    public void setAscriptionType(String ascriptionType) {
        this.ascriptionType = ascriptionType;
    }

    public String getAscriptionId() {
        return ascriptionId;
    }

    public void setAscriptionId(String ascriptionId) {
        this.ascriptionId = ascriptionId;
    }

    public String getSendType() {
        return sendType;
    }

    public void setSendType(String sendType) {
        this.sendType = sendType;
    }

    public String getMessageType() {
        return messageType;
    }

    public void setMessageType(String messageType) {
        this.messageType = messageType;
    }

    public String getFileId() {
        return fileId;
    }

    public void setFileId(String fileId) {
        this.fileId = fileId;
    }

    public String getSendAddr() {
        return sendAddr;
    }

    public void setSendAddr(String sendAddr) {
        this.sendAddr = sendAddr;
    }

    public String getSendState() {
        return sendState;
    }

    public void setSendState(String sendState) {
        this.sendState = sendState;
    }

    public String getSendContent() {
        return sendContent;
    }

    public void setSendContent(String sendContent) {
        this.sendContent = sendContent;
    }

    public String getResponseContent() {
        return responseContent;
    }

    public void setResponseContent(String responseContent) {
        this.responseContent = responseContent;
    }

    public String getAutoSend() {
        return autoSend;
    }

    public void setAutoSend(String autoSend) {
        this.autoSend = autoSend;
    }

    public Integer getSendFrequency() {
        return sendFrequency;
    }

    public void setSendFrequency(Integer sendFrequency) {
        this.sendFrequency = sendFrequency;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public Date getSendTime() {
        return sendTime;
    }

    public void setSendTime(Date sendTime) {
        this.sendTime = sendTime;
    }

    public String getSendUser() {
        return sendUser;
    }

    public void setSendUser(String sendUser) {
        this.sendUser = sendUser;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public String getExt1() {
        return ext1;
    }

    public void setExt1(String ext1) {
        this.ext1 = ext1;
    }

    public String getExt2() {
        return ext2;
    }

    public void setExt2(String ext2) {
        this.ext2 = ext2;
    }

    public String getExt3() {
        return ext3;
    }

    public void setExt3(String ext3) {
        this.ext3 = ext3;
    }

    public String getExt4() {
        return ext4;
    }

    public void setExt4(String ext4) {
        this.ext4 = ext4;
    }
}

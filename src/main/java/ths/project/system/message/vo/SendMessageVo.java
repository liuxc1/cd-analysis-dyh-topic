package ths.project.system.message.vo;

public class SendMessageVo {
    String ascriptionId;
    String ascriptionType;
    String sendType;
    String sendUser;
    String context;
    String sendPhones;

    public String getAscriptionId() {
        return ascriptionId;
    }

    public void setAscriptionId(String ascriptionId) {
        this.ascriptionId = ascriptionId;
    }

    public String getAscriptionType() {
        return ascriptionType;
    }

    public void setAscriptionType(String ascriptionType) {
        this.ascriptionType = ascriptionType;
    }

    public String getSendType() {
        return sendType;
    }

    public void setSendType(String sendType) {
        this.sendType = sendType;
    }

    public String getSendUser() {
        return sendUser;
    }

    public void setSendUser(String sendUser) {
        this.sendUser = sendUser;
    }

    public String getContext() {
        return context;
    }

    public void setContext(String context) {
        this.context = context;
    }

    public String getSendPhones() {
        return sendPhones;
    }

    public void setSendPhones(String sendPhones) {
        this.sendPhones = sendPhones;
    }
}

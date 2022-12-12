package ths.project.system.message.service;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import ths.project.common.uid.SnowflakeIdGenerator;
import ths.project.system.message.entity.SendLog;
import ths.project.system.message.enums.MessageTypeEnum;
import ths.project.system.message.enums.SendStateEnum;
import ths.project.system.message.enums.SendTypeEnum;
import ths.project.system.message.mapper.SendLogMapper;

import java.util.Date;

@Service
public class SendLogService {

    @Autowired
    private SendLogMapper sendLogMapper;
    @Autowired
    private SnowflakeIdGenerator idGenerator;

    /**
     * 封装推送日志数据
     *
     * @param sendId          推送日志ID，可为空
     * @param ascriptionType  归属类型
     * @param ascriptionId    归属ID
     * @param sendType        推送类型
     * @param messageType     消息类型，参考MessageTypeEnum
     * @param fileId          文件ID，可为空
     * @param sendAddr        推送地址
     * @param sendState       推送状态
     * @param sendContent     推送内容
     * @param responseContent 响应结果
     * @param sendUser        推送人，可为空
     * @param sendFrequency   重试次数
     * @param state           状态，可为空
     * @param remark          备注，可为空
     * @param sendParentId    推送日志父ID
     */
    @Transactional(rollbackFor = Exception.class)
    public void insertSendLog(String sendId, String ascriptionType, String ascriptionId,
                              SendTypeEnum sendType, MessageTypeEnum messageType, String fileId, String sendAddr, SendStateEnum sendState, String sendContent,
                              String responseContent, String sendUser, Integer sendFrequency, String state, String remark) {
        SendLog sendLog = new SendLog(ascriptionType, ascriptionId, sendType, messageType, fileId, sendAddr, sendState, sendContent, responseContent, "N", sendFrequency, state, new Date(), sendUser, remark);
        sendLog.setSendId(sendId);
        insertSendLog(sendLog);
    }

    @Transactional(rollbackFor = Exception.class)
    public String insertSendLog(SendLog sendLog) {
        if (StringUtils.isBlank(sendLog.getSendId())) {
            sendLog.setSendId(idGenerator.getUniqueId());
        }
        if (sendLog.getCreateTime() == null) {
            sendLog.setCreateTime(new Date());
        }
        sendLogMapper.insert(sendLog);
        return sendLog.getSendId();
    }

    @Transactional(rollbackFor = Exception.class, propagation = Propagation.REQUIRES_NEW)
    public int updateSendLog(SendLog sendLog) {
        return sendLogMapper.updateById(sendLog);
    }

    /**
     * 修改推送状态
     *
     * @param sendId    推送日志ID
     * @param sendState 推送状态
     */
    @Transactional(rollbackFor = Exception.class, propagation = Propagation.REQUIRES_NEW)
    public void updateSendState(String sendId, SendStateEnum sendState) {
        SendLog sendLog = new SendLog();
        sendLog.setSendId(sendId);
        sendLog.setSendState(sendState.name());
        sendLogMapper.updateById(sendLog);
    }
}

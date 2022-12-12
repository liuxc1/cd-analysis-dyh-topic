package ths.project.system.message.service;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.DisposableBean;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.scheduling.concurrent.ThreadPoolTaskScheduler;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import ths.jdp.core.context.PropertyConfigure;
import ths.jdp.core.service.base.BaseService;
import ths.project.common.exception.CtThsException;
import ths.project.common.factory.CustomThreadFactory;
import ths.project.common.util.JsonUtil;
import ths.project.system.message.entity.SendLog;
import ths.project.system.message.enums.MessageTypeEnum;
import ths.project.system.message.enums.SendStateEnum;
import ths.project.system.message.enums.SendTypeEnum;
import ths.project.system.message.vo.SendMessageVo;

import javax.annotation.Resource;
import java.util.Collections;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ThreadPoolExecutor;

/**
 * 推送短信-服务层 新短信平台
 *
 * @author liangdl
 */
@Service("sendMessageService")
public class SendMessageService extends BaseService implements InitializingBean, DisposableBean {

    /**
     * 推送地址。默认短信平台
     */
    private final static String SEND_ADDR = "MESSAGE";

    @Resource
    private SendLogService sendLogService;
    @Resource
    private RestTemplate restTemplate;

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    private final String sendMessageSwitch = (String) PropertyConfigure.getProperty("send.message.switch");
    private final String messageCenterHost = (String) PropertyConfigure.getProperty("send.message.host");
    /**
     * 异步线程池，详情参考spring-thread.xml
     */
    private ThreadPoolTaskScheduler messageThreadPoolTaskScheduler;
    /**
     *
     */
    private final ConcurrentHashMap<String, Integer> refreshCache = new ConcurrentHashMap<>();

    /**
     * 推送短信
     *
     * @param context        短信上下文
     * @param sendTypeEnum   短信推送类型。
     * @param ascriptionType 归属类型
     * @param ascriptionId   归属ID
     * @param sendUser       发送人
     * @param sendPhones     呈送人
     */
    public void sendMessage(String context, SendTypeEnum sendTypeEnum, String ascriptionType, String ascriptionId, String sendUser, String... sendPhones) {
        if (StringUtils.isBlank(context)) {
            throw new CtThsException("短信内容不能为空，请确认！");
        }
        if (sendPhones == null || sendPhones.length == 0) {
            throw new CtThsException("目标电话号码不能为空，请确认！");
        }

        SendLog sendLog = new SendLog(ascriptionType, ascriptionId, sendTypeEnum, MessageTypeEnum.TEXT
                , null, SEND_ADDR, SendStateEnum.SENDING, context, null, "N", 1
                , "UPLOAD", null, sendUser, StringUtils.join(sendPhones, ","));
        sendLogService.insertSendLog(sendLog);

        // 获取Message发送开关
        if (!"on".equals(sendMessageSwitch)) {
            logger.warn("推送开关未打开，如需推送，则打开context.properties文件的send.message.switch配置。");
            return;
        }

        SendMessageVo sendMessageVo = new SendMessageVo();
        sendMessageVo.setAscriptionId(ascriptionId);
        sendMessageVo.setAscriptionType(ascriptionType);
        sendMessageVo.setSendType(sendTypeEnum.name());
        sendMessageVo.setContext(context);
        sendMessageVo.setSendUser(sendUser);
        sendMessageVo.setSendPhones(StringUtils.join(sendPhones, ","));

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON_UTF8);
        headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));
        HttpEntity<String> formEntity = new HttpEntity<>(JsonUtil.toJson(sendMessageVo), headers);
        String result = restTemplate.postForObject(messageCenterHost + "/message/sendMessage", formEntity, String.class);
        Map<String, Object> resultMap = JsonUtil.toMap(result);
        if (resultMap.get("code").equals(200)) {
            @SuppressWarnings("unchecked")
            String sendId = ((Map<String, Object>) resultMap.get("data")).get("sendId").toString();
            sendLog.setSendId(sendId);
            refreshCache.put(sendId, 10);
        }
    }

    /**
     * s短信
     */
    private void refreshMessageInfo() {
        for (Map.Entry<String, Integer> entry : refreshCache.entrySet()) {
            String sendId = entry.getKey();
            try {
                SendLog sendLogOld = restTemplate.getForObject(messageCenterHost + "/message/getInfo?sendId=" + sendId, SendLog.class);
                if (sendLogOld != null && SendStateEnum.SUCCESS.name().equals(sendLogOld.getState())
                        && SendStateEnum.FAILURE.name().equals(sendLogOld.getState())) {
                    SendLog sendLog = new SendLog();
                    sendLog.setSendId(sendId);
                    sendLog.setSendTime(sendLog.getSendTime());
                    sendLog.setSendState(sendLog.getSendState());
                    sendLog.setResponseContent(sendLog.getResponseContent());
                    int i = sendLogService.updateSendLog(sendLog);
                    if (i == 0) {
                        logger.error("推送日志未成功修改：" + JsonUtil.toJson(sendLog));
                    }

                    //直接走后续的接收流程
                    entry.setValue(1);
                }
            } catch (Exception e) {
                logger.error("推送日志更新出错：" + JsonUtil.toJson(sendId), e);
            }
            entry.setValue(entry.getValue() - 1);

            if (entry.getValue() <= 0) {
                refreshCache.remove(sendId);
            }
        }
    }

    @Override
    public void destroy() throws Exception {
        messageThreadPoolTaskScheduler.destroy();
    }

    @Override
    public void afterPropertiesSet() throws Exception {
        messageThreadPoolTaskScheduler = new ThreadPoolTaskScheduler();
        messageThreadPoolTaskScheduler.setPoolSize(1);
        messageThreadPoolTaskScheduler.setRejectedExecutionHandler(new ThreadPoolExecutor.CallerRunsPolicy());
        messageThreadPoolTaskScheduler.setThreadFactory(new CustomThreadFactory("customThreadFactory_0", false));
        messageThreadPoolTaskScheduler.initialize();

        messageThreadPoolTaskScheduler.scheduleAtFixedRate(this::refreshMessageInfo, 30 * 1000);
    }
}

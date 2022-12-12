package ths.project.system.email.service;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import ths.jdp.core.context.PropertyConfigure;
import ths.jdp.core.service.base.BaseService;
import ths.project.system.email.entity.MailFile;
import ths.project.system.message.enums.MessageTypeEnum;
import ths.project.system.message.enums.SendStateEnum;
import ths.project.system.message.enums.SendTypeEnum;
import ths.project.system.message.service.SendLogService;

import javax.annotation.Resource;
import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import java.io.File;

/**
 * 发送邮件-服务层
 *
 * @author liangdl
 */
@Service
public class SendMailService extends BaseService {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Resource
    private JavaMailSender javaMailSender;

    @Resource
    private SendLogService sendLogService;
    /**
     * 编码
     */
    private final static String ENCODING = "UTF-8";

    /**
     * 发送带附件的邮件
     *
     * @param tos            接收人数组
     * @param from           发送人
     * @param subject        主题
     * @param text           文本内容（可为空）
     * @param isHtml         文本内容是否是html
     * @param mailFiles      附件列表（可为空）
     * @param ascriptionType 归属类型
     * @param ascriptionId   归属类型ID
     * @param sendUser       发送人，可为空
     */
    public void sendAttachmentMail(String[] tos, String from, String subject, String text, Boolean isHtml, MailFile[] mailFiles, String ascriptionType,
                                   String ascriptionId, String sendUser) {
        sendMail(tos, from, subject, text, isHtml, mailFiles, ascriptionType, ascriptionId, sendUser);
    }

    /**
     * 发送带附件的邮件
     *
     * @param tos            接收人数组
     * @param from           发送人
     * @param subject        主题
     * @param text           文本内容（可为空）
     * @param isHtml         文本内容是否是html
     * @param mailFiles      附件列表（可为空）
     * @param ascriptionType 归属类型
     * @param ascriptionId   归属类型ID
     * @param sendUser       发送人，可为空
     */
    public void sendMail(String[] tos, String from, String subject, String text, Boolean isHtml, MailFile[] mailFiles, String ascriptionType, String ascriptionId, String sendUser) {
        SendStateEnum sendState2 = SendStateEnum.FAILURE;
        String responseContent = null;
        StringBuilder remarkBuilder = new StringBuilder(200);
        remarkBuilder.append(from).append("；");
        try {
            // 获取Mail发送开关
            String sendMailSwitch = (String) PropertyConfigure.getProperty("send.mail.switch");
            if (!"on".equals(sendMailSwitch)) {
                logger.warn("推送开关未打开，如需推送，则打开context.properties文件的send.mail.switch配置。");
                return;
            }
            if (tos == null || tos.length == 0) {
                logger.warn("缺失收件人。");
                return;
            }

            MimeMessage mimeMessage = javaMailSender.createMimeMessage();
            MimeMessageHelper mimeMessageHelper = new MimeMessageHelper(mimeMessage, true, ENCODING);
            mimeMessageHelper.setTo(tos);
            mimeMessageHelper.setFrom(from);
            mimeMessageHelper.setSubject(subject);
            if (StringUtils.isNotBlank(text)) {
                mimeMessageHelper.setText(text, isHtml);
            }
            if (mailFiles != null && mailFiles.length > 0) {
                for (MailFile mailFile : mailFiles) {
                    File file = new File(mailFile.getFilePath());
                    if (file.exists() && file.isFile()) {
                        mimeMessageHelper.addAttachment(mailFile.getFileName(), file);
                        remarkBuilder.append(mailFile.toString());
                    } else {
                        remarkBuilder.append("文件【").append(mailFile.getFilePath()).append("】不存在。");
                    }
                }
            }
            javaMailSender.send(mimeMessage);

            sendState2 = SendStateEnum.SUCCESS;
        } catch (MessagingException e) {
            logger.error("", e);

            responseContent = e.getMessage();
        } finally {
            MessageTypeEnum messageType = isHtml ? MessageTypeEnum.HTML : MessageTypeEnum.TEXT;
            String sendContent = getSendContent(subject, text);

            sendLogService.insertSendLog(null, ascriptionType, ascriptionId, SendTypeEnum.MAIL, messageType, null,
                    StringUtils.join(tos, ","), sendState2, sendContent, responseContent, sendUser, 1, null, remarkBuilder.toString());
        }
    }

    /**
     * 获取发送内容
     *
     * @param subject 主题
     * @param text    内容
     * @return 发送内容
     */
    private String getSendContent(String subject, String text) {
        return "主题：" + subject + "#内容：" + text;
    }
}

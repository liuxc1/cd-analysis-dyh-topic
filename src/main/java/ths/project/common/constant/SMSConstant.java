package ths.project.common.constant;

import ths.jdp.core.context.PropertyConfigure;

public class SMSConstant {
    // 短信IP
    public static final String SMS_DEV_IP = (String) PropertyConfigure.getProperty("SMS_DEV_IP");
    // 获取token地址
    public static final String SMS_TOKEN_URL = (String) PropertyConfigure.getProperty("SMS_TOKEN_URL");
    //发送短信地址
    public static final String SEND_SMS_URL = (String) PropertyConfigure.getProperty("SEND_SMS_URL");
    // 用户名
    public static final String SMS_USER = (String) PropertyConfigure.getProperty("SMS_USER");
    // 密码
    public static final String SMS_PASSWORD = (String) PropertyConfigure.getProperty("SMS_PASSWORD");
}

package ths.project.common.wemeet;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.squareup.okhttp.Interceptor;
import com.squareup.okhttp.Response;
import com.tencentcloudapi.wemeet.client.MeetingClient;
import com.tencentcloudapi.wemeet.client.UserClient;
import com.tencentcloudapi.wemeet.common.RequestSender;
import com.tencentcloudapi.wemeet.common.constants.InstanceEnum;
import com.tencentcloudapi.wemeet.common.exception.WemeetSdkException;
import com.tencentcloudapi.wemeet.common.profile.HttpProfile;
import com.tencentcloudapi.wemeet.models.BaseResponse;
import com.tencentcloudapi.wemeet.models.meeting.CancelMeetingRequest;
import com.tencentcloudapi.wemeet.models.meeting.CreateMeetingRequest;
import com.tencentcloudapi.wemeet.models.meeting.QueryMeetingByIdRequest;
import com.tencentcloudapi.wemeet.models.meeting.QueryMeetingDetailResponse;
import com.tencentcloudapi.wemeet.models.user.QueryUsersRequest;
import com.tencentcloudapi.wemeet.models.user.QueryUsersResponse;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import ths.jdp.core.context.PropertyConfigure;
import ths.project.common.util.MapUtil;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

/**
 * <p>会议请求</p>
 * 企业内部应用鉴权方式
 * 1.企业管理员登录腾讯会议官网（https://meeting.tencent.com/），
 * 单击右上角【用户中心】，在左侧菜单栏中的【企业管理】>【高级】>【restApi】中进行查看。
 * 2.支持两种方式实例化请求代理对象
 * 1）全局代理对象：设置全局HttpProfile，在项目启动时进行初始化，并构造RequestSender对象，所有客户端请求可共用一套配置；
 * 2）局部代理对象：也可以针对具体某个接口单独实例化HttpProfile，并通过此对象构造RequestSender对象
 * 3.构造具体client，参考client包，例如MeetingClient，通过构造方法传入RequestSender实例，初始化client
 * 4.通过client调用具体方法即可发起请求，
 * eg：QueryMeetingDetailResponse response = client.createMeeting(request);
 * <p>
 * 第三方应用鉴权（OAuth2.0）
 * 1.参考官网文档（https://cloud.tencent.com/document/product/1095/51257）获取AccessToken和OpenId
 * 2.参考【企业内部应用鉴权方式】第2步，初始化代理实例
 * 3.构造请求体，并添加第1部申请到的参数到请求Header中
 * eg:
 * CreateMeetingRequest request = new CreateMeetingRequest();
 * request.setUserId("test_user");
 * request.setInstanceId(InstanceEnum.INSTANCE_MAC.getInstanceID());
 * request.setSubject("sdk 创建会议");
 * request.setType(0);
 * request.setStartTime("1619733600");
 * request.setEndTime("1619737200");
 * // 设置Header
 * request.addHeader(ReqHeaderConstants.ACCESS_TOKEN, "111111");
 * request.addHeader(ReqHeaderConstants.OPEN_ID, "2222");
 * 4.通过client发起请求
 *
 * @author tencent
 * @date 2021/4/29
 */
public class MeetingRequest {
    private static final Log log = LogFactory.getLog(MeetingRequest.class);
    // 初始化全局client
    /**
     * 初始化全局会议client
     */
    private static final MeetingClient MEETING_CLIENT;
    /**
     * 初始化全局用户client
     */
    private static final UserClient USER_CLIENT;
    private static final Gson GSON = new GsonBuilder().excludeFieldsWithoutExposeAnnotation().create();
    private static String appId = PropertyConfigure.getProperty("appId").toString();
    private static String sdkId = PropertyConfigure.getProperty("sdkId").toString();
    private static String host = PropertyConfigure.getProperty("host").toString();
    private static String secretKey = PropertyConfigure.getProperty("secretKey").toString();
    private static String secretId = PropertyConfigure.getProperty("secretId").toString();
    private static String userId = PropertyConfigure.getProperty("userId").toString();
    static {
        HttpProfile profile = new HttpProfile();
        // 腾讯会议分配给三方开发应用的 App ID。企业管理员可以登录 腾讯会议官网，单击右上角【用户中心】
        // 在左侧菜单栏中的【企业管理】>【高级】>【restApi】中进行查看。
        profile.setAppId(appId);
        // 用户子账号或开发的应用 ID，企业管理员可以登录 腾讯会议官网，单击右上角【用户中心】
        // 在左侧菜单栏中的【企业管理】>【高级】>【restApi】中进行查看（如存在 SdkId 则必须填写，早期申请 API 且未分配 SdkId 的客户可不填写）。
        profile.setSdkId(sdkId);
        // 请求域名
        profile.setHost(host);
        // 申请的安全凭证密钥对中的 SecretId，传入请求header，对应X-TC-Key
        profile.setSecretId(secretId);
        // 申请的安全凭证密钥对中的 Secretkey，用户签名计算
        profile.setSecretKey(secretKey);
        // 是否开启请求日志，开启后会打印请求和返回的详细日志
        profile.setDebug(true);
        // 设置请求超时时间，单位s
        profile.setReadTimeout(3);
        // 设置获取连接超时时间，单位s
        profile.setConnTimeout(1);

        // 初始化全局sender，也可以方法级别实例化
        RequestSender sender = new RequestSender(profile);
        // 自定义拦截器，可以忽略
       /* sender.addInterceptors(new Interceptor() {
            @Override
            public Response intercept(Chain chain) {
                // TODO return null; 用户自定义实现
            }
        });*/
        // 实例化client
        MEETING_CLIENT = new MeetingClient(sender);
        USER_CLIENT = new UserClient(sender);
        // ...
    }



    /**
     * 新建会议
     * @param param
     * @return
     * @throws WemeetSdkException
     * @throws ParseException
     */
    public static String createMeeting(Map<String,Object> param) throws WemeetSdkException, ParseException {
        CreateMeetingRequest request = new CreateMeetingRequest();
        request.setUserId(userId);
        request.setInstanceId(InstanceEnum.INSTANCE_PC.getInstanceID());
        request.setSubject(MapUtil.getString(param,"CONSULT_THEME"));
        request.setType(MapUtil.getInteger(param,"type"));
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        request.setStartTime(dateToStamp(MapUtil.getString(param,"CONSULT_TIME"),sdf));
        request.setEndTime(dateToStamp(MapUtil.getString(param,"CONSULT_TIME_END"),sdf));
        QueryMeetingDetailResponse response = MEETING_CLIENT.createMeeting(request);
        return  GSON.toJson(response);
    }


    /**
     * 根据会议id查询会议
     * @param param
     * @return
     * @throws WemeetSdkException
     * @throws ParseException
     */
    public static String queryMeetingByID(Map<String,Object> param) throws WemeetSdkException, ParseException {
        QueryMeetingByIdRequest request = new QueryMeetingByIdRequest();
        request.setMeetingId(MapUtil.getString(param,"MEETING_ID"));
        request.setUserId(userId);
        request.setInstanceId(1);
        QueryMeetingDetailResponse response = MEETING_CLIENT.queryMeetingById(request);
        return  GSON.toJson(response);
    }

    /**
     * 取消会议
     * @param meetingId
     * @return
     * @throws WemeetSdkException
     */
    public static String cancel(String meetingId) throws WemeetSdkException {
        CancelMeetingRequest request =new CancelMeetingRequest();
        request.setUserId(userId);
        request.setMeetingId(meetingId);
        request.setInstanceId(1);
        request.setReasonCode(0);
        BaseResponse response = MEETING_CLIENT.cancelMeeting(request);
        return  GSON.toJson(response);
    }


    /**
     * 时间转时间戳
     * @param s
     * @return
     * @throws ParseException
     */
    public static String dateToStamp(String s,SimpleDateFormat sdf) throws ParseException{
        String res;
        Date date = sdf.parse(s);
        long ts = date.getTime()/1000;
        res = String.valueOf(ts);
        return res;
    }



}

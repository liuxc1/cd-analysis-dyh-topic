package ths.project.api.dyh.consultation.service;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.tencentcloudapi.wemeet.common.exception.WemeetSdkException;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ths.jdp.core.dao.base.Paging;
import ths.jdp.core.service.base.BaseService;
import ths.jdp.util.Tool;
import ths.project.analysis.forecast.report.enums.AscriptionTypeEnum;
import ths.project.common.exception.CtThsException;
import ths.project.common.util.DateUtil;
import ths.project.common.util.MapUtil;
import ths.project.common.wemeet.MeetingRequest;
import ths.project.system.file.entity.CommFile;
import ths.project.system.file.service.CommFileService;
import ths.project.system.message.enums.SendTypeEnum;
import ths.project.system.message.service.SendMessageService;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * @ClassName ConsultationService
 * @Description TODO
 * @Author ZT
 * @Date 2021/9/29 10:12
 * @Version 1.0
 **/
@Service
public class ConsultationService extends BaseService {

    private final String sqlPackage = "ths.project.dyh.consultation.mapper.ConsultationMapper.";
    private final CommFileService commFileService;
    private SendMessageService sendMessageService;

    @Autowired
    public ConsultationService(CommFileService commFileService, SendMessageService sendMessageService) {
        this.commFileService = commFileService;
        this.sendMessageService = sendMessageService;
    }

    /**
     * @return ths.jdp.core.dao.base.Paging<java.util.Map < java.lang.String, java.lang.Object>>
     * @Author ZT
     * @Description 查询会商列表
     * @Date 15:52 2021/9/29
     * @Param [params, pageInfo]
     **/
    public Paging<Map<String, Object>> listConsultationInfo(Map<String, Object> params, Paging pageInfo) {
        return dao.list(pageInfo, params, sqlPackage + "listConsultationInfo");
    }

    /**
     * @return void
     * @Author ZT
     * @Description 保存会商信息
     * @Date 10:34 2021/10/8
     * @Param [multipartFiles, params]
     **/
    @Transactional
    public void saveInfo(Map<String, Object> params) throws WemeetSdkException, ParseException {
        CommFile[] commFiles = null;
        params.put("PKID", MapUtil.getString(params, "PKID", UUID.randomUUID().toString()));
        saveConsultationInfo(params);
    }

    /**
     * @return int
     * @Author ZT
     * @Description 新增/修改会商信息
     * @Date 13:51 2021/10/8
     * @Param [params]
     **/
    public Map saveConsultationInfo(Map<String, Object> params) throws WemeetSdkException, ParseException {
        //填写会议纪要
        if (params.containsKey("CONSULT_EXPERT")) {
            dao.insert(params, sqlPackage + "saveConsultationInfo");
            return null;
        }
        //拼接发送短信的电话
        if (params.containsKey("CONSULT_DEPT_CODES_STR") && StringUtils.isNotBlank(MapUtils.getString(params, "CONSULT_STATUS")) && (MapUtils.getString(params, "CONSULT_STATUS").equals("1") || MapUtils.getString(params, "CONSULT_STATUS").equals("2"))) {
            String deptCode = MapUtil.getString(params, "CONSULT_DEPT_CODES_STR");
            String[] dateArr = deptCode.split(",");
            ArrayList<String> deptList = new ArrayList<String>(Arrays.asList(dateArr));
            params.put("deptList", deptList);
            List<Map<String, Object>> list = dao.list(params, sqlPackage + "getPhoneList");
            StringBuilder phones = new StringBuilder();
            StringBuilder users = new StringBuilder();
            for (Map<String, Object> map : list) {
                phones.append(MapUtil.getString(map, "PHONES")).append(",");
                users.append(MapUtil.getString(map, "USERS")).append(",");
            }
            params.put("PHONES", phones.toString());
            params.put("USERS", users.toString());
        }
        params.put("type", 0);//预约会议
        if (MapUtils.getString(params, "CONSULT_STATUS").equals("1") || MapUtils.getString(params, "CONSULT_STATUS").equals("2")) {
            String response = MeetingRequest.createMeeting(params);
            Map<String, Object> map = (Map<String, Object>) JSONArray.parse(response);
            if (map.containsKey("meeting_info_list")) {
                JSONArray infoList = (JSONArray) map.get("meeting_info_list");
                List<Map> list = JSONObject.parseArray(infoList.toString(), Map.class);
                Map<String, Object> meetingInfo = list.get(0);
                params.put("MEETING_ID", MapUtils.getString(meetingInfo, "meeting_id"));
                params.put("MEETING_URL", MapUtils.getString(meetingInfo, "join_url"));
                params.put("MEETING_CODE", MapUtils.getString(meetingInfo, "meeting_code"));
            }
            String s = MeetingRequest.queryMeetingByID(params);
            try {
                sendMessg(params);
            } catch (CtThsException e) {
                MeetingRequest.cancel(MapUtils.getString(params, "MEETING_ID"));
                throw new CtThsException("目标电话号码不能为空，请确认！");
            }
        }
        int flag = dao.insert(params, sqlPackage + "saveConsultationInfo");

        return params;
    }

    /**
     * 会议发送短信
     *
     * @param param
     */
    public void sendMessg(Map<String, Object> param) {
        String messageContent = "";
        messageContent += "会议主题：" + MapUtils.getString(param, "CONSULT_THEME") + ",";
        messageContent += "会议编码：" + MapUtils.getString(param, "MEETING_CODE") + ",";
        messageContent += "开始时间：" + MapUtils.getString(param, "CONSULT_TIME") + ",";
        messageContent += "结束时间：" + MapUtils.getString(param, "CONSULT_TIME_END") + ",";
        messageContent += "进入连接：" + MapUtils.getString(param, "MEETING_URL") + "。";
        String meetingId = MapUtils.getString(param, "MEETING_ID");
        String phones = MapUtils.getString(param, "PHONES");
        if (StringUtils.isBlank(phones)) {
            throw new CtThsException("目标电话号码不能为空，请确认！");
        }
        String[] phoneArr = phones.split(",");
        // 发送短信
        sendMessageService.sendMessage(messageContent, SendTypeEnum.MEETING, AscriptionTypeEnum.MEETING.getValue(),
                meetingId, null, phoneArr);
    }

    /**
     * @return java.util.Map<java.lang.String, java.lang.Object>
     * @Author ZT
     * @Description 获取基本信息
     * @Date 17:32 2021/10/8
     * @Param [params]
     **/
    public Map<String, Object> getBaseInfo(Map<String, Object> params) {
        return dao.get(params, sqlPackage + "getBaseInfo");
    }

    /**
     * @return java.util.List<java.util.Map < java.lang.String, java.lang.Object>>
     * @Author ZT
     * @Description 查询部门列表
     * @Date 11:36 2021/10/11
     * @Param [params]
     **/
    public List<Map<String, Object>> listDepts(Map<String, Object> params) {
        return dao.list(params, sqlPackage + "listDepts");
    }


    /**
     * 快速会议
     *
     * @param depts
     * @param deptNames
     * @return
     * @throws WemeetSdkException
     * @throws ParseException
     */
    public Map<String, Object> fastMeeting(String depts, String deptNames) throws WemeetSdkException, ParseException {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("CREATE_TIME", new Date());
        params.put("CONSULT_THEME", DateUtil.getNowDateTime().substring(0, 16) + "快速视频会商");
        params.put("type", 1);
        params.put("CONSULT_TIME", DateUtil.getNowDateTime().substring(0, 16));
        params.put("CONSULT_TIME_END", twoHour());
        params.put("CONSULT_STATUS", 2);
        params.put("CONSULT_TYPE_CODE", "FAST_MEETING");
        params.put("CONSULT_TYPE_NAME", "快速视频会商");
        params.put("CONSULT_DEPT_CODES_STR", depts);
        params.put("CONSULT_DEPT_NAMES", deptNames);
        params.put("CONSULT_SYNOPSIS", "");
        params.put("PKID", Tool.getUUID());
        return saveConsultationInfo(params);
    }

    /**
     * 当前时间两个小时后的时间戳
     *
     * @return
     * @throws ParseException
     */
    public String twoHour() throws ParseException {
        String s = DateUtil.getNowDateTime().substring(0, 16);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        Date date = sdf.parse(s);
        date.setHours(date.getHours() + 2);
        String dateString = sdf.format(date);
        return dateString;
    }

    /**
     * 取消会议
     *
     * @param id
     * @param meetingId
     * @return
     * @throws WemeetSdkException
     */
    public Boolean cancel(String id, String meetingId) throws WemeetSdkException, ParseException {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("MEETING_ID", meetingId);
        MeetingRequest.cancel(meetingId);
        params.put("pkid", id);
        dao.update(params, sqlPackage + "deleteMeeting");
        return true;
    }

    public List<Map<String, Object>> cheakTime(Map<String, Object> params) {
        return dao.list(params, sqlPackage + "cheakTime");
    }
}

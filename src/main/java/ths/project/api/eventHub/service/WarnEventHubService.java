package ths.project.api.eventHub.service;

import com.alibaba.fastjson.JSON;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.collections.MapUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import ths.jdp.core.context.PropertyConfigure;
import ths.jdp.util.DateUtils;
import ths.project.analysis.decisionmeasure.entity.WarnControlInfo;
import ths.project.analysis.decisionmeasure.mapper.DecisionMeasureMapper;
import ths.project.api.eventHub.entity.WarnHandleInfo;
import ths.project.api.eventHub.mapper.WarnEventHubMapper;
import ths.project.api.eventHub.mapper.WarnHandleInfoMapper;
import ths.project.api.eventHub.vo.WarnEventHubPushVo;
import ths.project.common.uid.SnowflakeIdGenerator;
import ths.project.common.util.BeanUtil;
import ths.project.common.util.DateUtil;
import ths.project.common.util.JsonUtil;
import ths.project.common.util.MapUtil;
import ths.project.common.watch.MybatisMapperWatch;
import ths.project.system.base.util.BatchSqlSessionUtil;

import java.util.*;

/**
 * @Description 事件枢纽推送-预警事件-业务层
 * @Author duanzm
 * @Date 2022/8/18 上午9:51
 * @Version 1.0
 **/
@Service
public class WarnEventHubService {

    private final Logger logger = LoggerFactory.getLogger(WarnEventHubService.class);

    private final WarnEventHubMapper warnEventHubMapper;
    private final RestTemplate restTemplate;
    private final DecisionMeasureMapper decisionMeasureMapper;
    private final WarnHandleInfoMapper warnHandleInfoMapper;
    private final SnowflakeIdGenerator snowflakeIdGenerator;

    public WarnEventHubService(WarnEventHubMapper warnEventHubMapper, RestTemplate restTemplate, DecisionMeasureMapper decisionMeasureMapper,
                               WarnHandleInfoMapper warnHandleInfoMapper, SnowflakeIdGenerator snowflakeIdGenerator) {
        this.warnEventHubMapper = warnEventHubMapper;
        this.restTemplate = restTemplate;
        this.decisionMeasureMapper = decisionMeasureMapper;
        this.warnHandleInfoMapper = warnHandleInfoMapper;
        this.snowflakeIdGenerator = snowflakeIdGenerator;
    }

    /**
     * 事件枢纽 appkey，事件枢纽提供
     */
    private final String APP_KEY = "634483563802132480";

    /**
     * 事件枢纽账户名，事件枢纽提供
     */
    private final String USER_NAME = "stkd";

    /**
     * 事件枢纽密码，事件枢纽提供
     */
    private final String PASSWORD = "MTIzNDU2";

    /**
     * 预警标识,0产生新预警
     */
    private final String ADD_ALERT_FLAG = "0";

    /**
     * 预警标识,1关闭已有预警
     */
    private final String CLOSE_ALERT_FLAG = "1";

    /**
     * 处置单位标识 (为0时需传disposal_list,为1时需传预警模板名字)
     */
    private final String CHUZHI_FLAG = "1";

    /**
     * 预警模板名
     */
    private final String WARN_TEMPLATE = "重污染天气预警(黄色预警)";

    /**
     * 预警类型
     */
    private final String ALERT_TYPE = "重污染天气预警";

    /**
     * 预警等级
     */
    private final String ALERT_LEVEL = "黄色";

    private final String DEPARTMENT_ID = (String)PropertyConfigure.getProperty("shengtai.huanjingju.id");

    private final String TYSHXYDM = (String)PropertyConfigure.getProperty("shengtai.huanjingju.tyshxydm");

    /**
     * 报送预警
     */
    private final String EVENT_HUB_PUSH_URL = (String)PropertyConfigure.getProperty("event.hub.push.url");

    /**
     * 查询预警处置信息
     */
    private final String EVENT_HUB_WARN_HANDLE_INFO = (String)PropertyConfigure.getProperty("event.hub.warn.handle.info");

    /**
     * 预警事件开始
     */
    public void pushStartWarn() {
        /**--------------- 查询预警开始时推送的数据 -------------------**/
        Map<String, Object> param = new HashMap<>();
        param.put("yesterdayTime", DateUtil.addDay(new Date(), -1));
        param.put("queryType", "start");
        List<Map<String, Object>> warnInfoList = warnEventHubMapper.queryWarnInfo(param);
        /**---------------- 依次推送 -------------**/
        for(Map<String, Object> warnInfoMap : warnInfoList) {
            // 拼接参数
            WarnEventHubPushVo warnEventHubPushVo = queryPushStartParam(warnInfoMap);
            String dataJson = JSON.toJSONString(warnEventHubPushVo);
            // 向事件枢纽发送请求
            String resultStr = requestWarnEvent(dataJson, EVENT_HUB_PUSH_URL);
            // 是否推送成功
            Integer eventHubStartPushSuccessFlag = 0;
            // 事件枢纽工单号
            String flowNo = "";
            Map<String, Object> resultMap = JsonUtil.toMap(resultStr);
            if("200".equals(MapUtils.getString(resultMap, "code"))){
                // 推送成功
                eventHubStartPushSuccessFlag = 1;
                flowNo = MapUtils.getString(resultMap, "data");
            }
            decisionMeasureMapper.update(null, Wrappers.lambdaUpdate(WarnControlInfo.class)
                    .eq(WarnControlInfo::getWarnControlId, MapUtils.getString(warnInfoMap, "WARN_CONTROL_ID"))
                    .set(WarnControlInfo::getEventHubStartPushSuccessFlag, eventHubStartPushSuccessFlag)
                    .set(WarnControlInfo::getFlowNo, flowNo));
        }
    }

    /**
     * 拼接预警开始参数
     * @param warnInfoMap
     * @return
     */
    public WarnEventHubPushVo queryPushStartParam(Map<String, Object> warnInfoMap) {
        WarnEventHubPushVo warnEventHubPushVo = new WarnEventHubPushVo(
                USER_NAME,
                PASSWORD,
                MapUtils.getString(warnInfoMap, "CONTROL_NAME"),
                MapUtils.getString(warnInfoMap, "REPORT_TIP"),
                ALERT_TYPE,
                ALERT_LEVEL,
                DEPARTMENT_ID,
                MapUtils.getString(warnInfoMap, "WARN_START_TIME"),
                "",
                ADD_ALERT_FLAG,
                "",
                CHUZHI_FLAG,
                WARN_TEMPLATE
                );
        return warnEventHubPushVo;
    }

    /**
     * 预警事件结束
     */
    public void pushEndtWarn() {
        /**--------------- 查询预警结束时推送的数据 -------------------**/
        Map<String, Object> param = new HashMap<>();
        param.put("yesterdayTime", DateUtil.addDay(new Date(), -1));
        param.put("queryType", "end");
        List<Map<String, Object>> warnInfoList = warnEventHubMapper.queryWarnInfo(param);
        /**---------------- 依次推送 -------------**/
        for(Map<String, Object> warnInfoMap : warnInfoList) {
            // 拼接预警结束参数
            WarnEventHubPushVo warnEventHubPushVo = queryPushEndParam(warnInfoMap);
            String dataJson = JSON.toJSONString(warnEventHubPushVo);
            // 向事件枢纽发送请求
            String resultStr = requestWarnEvent(dataJson, EVENT_HUB_PUSH_URL);
            // 是否推送成功
            Integer eventHubEndPushSuccessFlag = 0;
            Map<String, Object> resultMap = JsonUtil.toMap(resultStr);
            if("200".equals(MapUtils.getString(resultMap, "code"))){
                // 推送成功
                eventHubEndPushSuccessFlag = 1;
            }
            decisionMeasureMapper.update(null, Wrappers.lambdaUpdate(WarnControlInfo.class)
                    .eq(WarnControlInfo::getWarnControlId, MapUtils.getString(warnInfoMap, "WARN_CONTROL_ID"))
                    .set(WarnControlInfo::getEventHubEndPushSuccessFlag, eventHubEndPushSuccessFlag));
        }
    }

    /**
     * 拼接预警结束参数
     * @param warnInfoMap
     * @return
     */
    private WarnEventHubPushVo queryPushEndParam(Map<String, Object> warnInfoMap) {
        WarnEventHubPushVo warnEventHubPushVo = new WarnEventHubPushVo(
                USER_NAME,
                PASSWORD,
                MapUtils.getString(warnInfoMap, "CONTROL_NAME"),
                MapUtils.getString(warnInfoMap, "REPORT_TIP"),
                ALERT_TYPE,
                ALERT_LEVEL,
                DEPARTMENT_ID,
                MapUtils.getString(warnInfoMap, "WARN_START_TIME"),
                MapUtils.getString(warnInfoMap, "WARN_END_TIME"),
                CLOSE_ALERT_FLAG,
                MapUtils.getString(warnInfoMap, "FLOW_NO"),
                CHUZHI_FLAG,
                WARN_TEMPLATE
        );
        return warnEventHubPushVo;
    }

    /**
     * 查询预警处置信息
     */
    public void queryWarnHandleInfo() {
        /**--------------- 查询预警结束前的工单号 -------------------**/
        Map<String, Object> param = new HashMap<>();
        param.put("nowTime", DateUtils.now());
        List<Map<String, Object>> warnInfoList = warnEventHubMapper.queryWarnHandleInfo(param);
        /*Map<String, Object> map = new HashMap<>();
        map.put("FLOW_NO", "20220905463500394");
        List<Map<String, Object>> warnInfoList = new ArrayList<Map<String, Object>>();
        warnInfoList.add(map);*/
        /**---------------- 依次推送 -------------**/
        for(Map<String, Object> warnInfoMap : warnInfoList) {
            // 拼接预警结束参数
            Map<String, Object> bodyMap = new HashMap<>();
            bodyMap.put("flowNo", MapUtils.getString(warnInfoMap, "FLOW_NO"));
            bodyMap.put("username", USER_NAME);
            bodyMap.put("password", PASSWORD);
            String dataJson = JSON.toJSONString(bodyMap);
            // 向事件枢纽发送请求
            String resultStr = requestWarnEvent(dataJson, EVENT_HUB_WARN_HANDLE_INFO);
            Map<String, Object> resultMap = JsonUtil.toMap(resultStr);
            if("200".equals(MapUtils.getString(resultMap, "code"))){
                // 先删除后添加
                warnHandleInfoMapper.delete(Wrappers.lambdaUpdate(WarnHandleInfo.class).eq(WarnHandleInfo::getFlowNo, MapUtils.getString(warnInfoMap, "FLOW_NO")));
                // 查询成功
                List<WarnHandleInfo> warnHandleInfoList = new ArrayList<WarnHandleInfo>();
                Map<String, Object> resultDataMap = MapUtils.getMap(resultMap, "data");
                Map<String, Object> alertMsgMap = (Map<String, Object>) resultDataMap.get("alertMsg");
                // 处置状态
                String status = MapUtils.getString(alertMsgMap, "status");
                List<Map<String, Object>> resultList = (List<Map<String, Object>>) resultDataMap.get("chuzhixinxi");
                for(Map<String, Object> result : resultList) {
                    String groupNameOut = MapUtils.getString(result, "groupName");
                    List<Map<String, Object>> lingdaopishiList = (List<Map<String, Object>>) result.get("lingdaopishi");
                    if(lingdaopishiList != null && !lingdaopishiList.isEmpty()){
                        // 领导批示不为空
                        for(Map<String, Object> lingdaopishiMap : lingdaopishiList) {
                            WarnHandleInfo warnHandleInfo = MapUtil.toBeanByUpperName(lingdaopishiMap, new WarnHandleInfo());
                            warnHandleInfo.setGroupNameOut(groupNameOut);
                            warnHandleInfo.setFlowNo(MapUtils.getString(warnInfoMap, "FLOW_NO"));
                            warnHandleInfo.setPkid(snowflakeIdGenerator.getUniqueId());
                            warnHandleInfo.setStatus(status);
                            warnHandleInfoList.add(warnHandleInfo);
                        }
                    }
                    List<Map<String, Object>> xubaoneirongList = (List<Map<String, Object>>) result.get("xubaoneirong");
                    if(xubaoneirongList != null && !xubaoneirongList.isEmpty()){
                        // 处置续报内容信息不为空
                        for(Map<String, Object> xubaoneirongMap : xubaoneirongList) {
                            WarnHandleInfo warnHandleInfo = MapUtil.toBean(xubaoneirongMap, new WarnHandleInfo());
                            warnHandleInfo.setGroupNameOut(groupNameOut);
                            warnHandleInfo.setFlowNo(MapUtils.getString(warnInfoMap, "FLOW_NO"));
                            warnHandleInfo.setPkid(snowflakeIdGenerator.getUniqueId());
                            warnHandleInfo.setStatus(status);
                            warnHandleInfoList.add(warnHandleInfo);
                        }
                    }
                }
                if(warnHandleInfoList.size() > 0) {
                    BatchSqlSessionUtil.insertBatch(warnHandleInfoMapper, warnHandleInfoList);
                }
            }
        }
    }


    /**
     * 向事件枢纽发送请求
     * @param dataJson
     * @return
     */
    public String requestWarnEvent(String dataJson, String url) {
        // 发送请求
        HttpHeaders httpHeaders = new HttpHeaders();
        httpHeaders.add("Content-Type", "application/x-www-form-urlencoded");
        httpHeaders.add("appkey", APP_KEY);
        MultiValueMap<String, Object> paramMap = new LinkedMultiValueMap<>();
        paramMap.add("jsonData", dataJson);
        HttpEntity<MultiValueMap<String, Object>> httpEntity = new HttpEntity<>(paramMap, httpHeaders);
        String resultStr = restTemplate.postForObject(url, httpEntity, String.class);
        return resultStr;
    }
}

package ths.project.api.eventHub.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import ths.project.api.eventHub.service.WarnEventHubService;
import ths.project.common.util.DateUtil;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * @Description 事件枢纽推送-预警事件-控制层
 * @Author duanzm
 * @Date 2022/8/18 上午9:50
 * @Version 1.0
 **/
@Controller
@RequestMapping("/api/warn/eventHub")
public class WarnEventHubController {

    private final WarnEventHubService warnEventHubService;

    public WarnEventHubController(WarnEventHubService warnEventHubService) {
        this.warnEventHubService = warnEventHubService;
    }

    /**
     * 预警事件开始
     */
    @ResponseBody
    @RequestMapping("/pushStartWarn")
    public void pushStartWarn(){
        warnEventHubService.pushStartWarn();
    }

    /**
     * 预警事件结束
     */
    @ResponseBody
    @RequestMapping("/pushEndtWarn")
    public void pushEndtWarn(){
        warnEventHubService.pushEndtWarn();
    }

    /**
     * 查询预警处置信息
     */
    @ResponseBody
    @RequestMapping("/queryWarnHandleInfo")
    public void queryWarnHandleInfo(){
        warnEventHubService.queryWarnHandleInfo();
    }
}

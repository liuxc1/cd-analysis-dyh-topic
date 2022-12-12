package ths.project.system.log.web;

import org.apache.commons.collections.MapUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import ths.jdp.core.dao.base.Paging;
import ths.project.common.aspect.log.annotation.LogOperation;
import ths.project.common.data.DataResult;
import ths.project.system.log.service.CmdLogService;
import ths.project.system.log.vo.LogQueryVo;
import ths.project.system.log.vo.LogVo;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/system/log/cmdLog/")
public class CmdLogController {

    @Autowired
    private CmdLogService cmdLogService;

    /**
     * 首页
     *
     * @param model
     * @return
     */
    @RequestMapping("/index")
    @LogOperation(module = "日志管理", operation = "首页")
    public String getIndex(Model model) {
        Map<String, Object> dateMap = cmdLogService.getDefaultTime(null);
        model.addAttribute("START_TIME", MapUtils.getString(dateMap, "START_TIME"));
        model.addAttribute("END_TIME", MapUtils.getString(dateMap, "END_TIME"));
        return "/system/log/log_index";
    }

    /**
     * 获取指定时间内 各平台访问次数 响应状态次数
     *
     * @param logQueryVo 查询条件
     * @return
     */
    @ResponseBody
    @RequestMapping("/getVisitStaList")
    @LogOperation(module = "日志管理", operation = "查询访问统计")
    public DataResult getVisitStaList(LogQueryVo logQueryVo) {
        Map<String, List<Map<String, Object>>> map = cmdLogService.getVisitStaList(logQueryVo);
        if (map != null && map.size() > 0) {
            return DataResult.success(map);
        } else {
            return DataResult.failure();
        }
    }

    /**
     * 获取系统访问日志列表
     *
     * @param logQueryVo 查询条件
     * @param paging     分页信息
     * @return
     */
    @ResponseBody
    @RequestMapping("/getVisitLogList")
    @LogOperation(module = "日志管理", operation = "查询系统访问日志列表")
    public DataResult getVisitLogList(LogQueryVo logQueryVo, Paging<LogVo> paging) {
        Paging<LogVo> pagings = cmdLogService.getVisitLogList(logQueryVo, paging);
        if (pagings != null) {
            return DataResult.success(pagings);
        } else {
            return DataResult.failure();
        }
    }
}

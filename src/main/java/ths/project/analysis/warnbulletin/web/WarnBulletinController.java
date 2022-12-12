package ths.project.analysis.warnbulletin.web;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import ths.jdp.core.dao.base.Paging;
import ths.project.analysis.commonreport.vo.CommonReportVo;
import ths.project.analysis.forecast.report.entity.GeneralReport;
import ths.project.analysis.warnbulletin.service.WarnBulletinService;
import ths.project.common.data.DataResult;
import ths.project.common.uid.SnowflakeIdGenerator;

import java.util.Map;

/**
 * 预警快报-控制器
 * @date 2021年11月22日 9:22
 */
@Controller
@RequestMapping("/analysis/warnbulletin")
public class WarnBulletinController {

    @Autowired
    private WarnBulletinService warnBulletinService;

    /**
     * 雪花ID
     */
    @Autowired
    private SnowflakeIdGenerator idGenerator;

    /**
     * 预览首页
     * @param model
     * @param paramMap
     * @return
     * url： http://localhost:7090/dyh_analysis/analysis/warnbulletin/index.vm?type=xxx&menuName=aaa
     */
    @RequestMapping("/index")
    public String index(Model model, @RequestParam Map<String, Object> paramMap ){
        model.addAttribute("ascriptionType", String.valueOf(paramMap.get("type")));
        model.addAttribute("menuName", String.valueOf(paramMap.get("menuName")));
        model.addAttribute("reportId", String.valueOf(paramMap.get("reportId")));
        return "/analysis/warnbulletin/index";
    }

    /**
     * 获取文件信息
     * @return
     */
    @RequestMapping("/getFileInfoByAscriptionType")
    @ResponseBody
    public DataResult getFileInfoByAscriptionType(@RequestParam Map<String, Object> paramMap){
        if (paramMap != null || StringUtils.isNotBlank((String) paramMap.get("ascriptionType"))) {
            Map<String, Object> resultMap = warnBulletinService.getFileInfoByAscriptionType(paramMap);
            if (resultMap != null) {
                return  DataResult.success(resultMap);
            } else {
                return  DataResult.failure("暂无数据！");
            }
        } else {
            return DataResult.failure("请求参数错误，可能值为空或包含非法字符！");
        }
    }

    /**
     * 列表页面
     * @param model
     * @param paramMap
     * @return
     */
    @RequestMapping("list")
    public String list(Model model, @RequestParam Map<String, Object> paramMap ){
        model.addAttribute("ascriptionType", String.valueOf(paramMap.get("ascriptionType")));
        model.addAttribute("menuName", String.valueOf(paramMap.get("menuName")));
        return "/analysis/warnbulletin/list";
    }

    /**
     * 查询列表
     */
    @RequestMapping("/queryReportListByAscriptionType")
    @ResponseBody
    public DataResult queryReportListByAscriptionType(@RequestParam Map<String, Object> paramMap, Paging<CommonReportVo> pageInfo) {
        // 归属类型不能为空
        if (StringUtils.isBlank((String) paramMap.get("ascriptionType"))) {
            return DataResult.failure("请求参数错误，可能值为空或包含非法字符。");
        }
        Paging<CommonReportVo> paging = warnBulletinService.queryReportListByAscriptionType(paramMap, pageInfo);
        return DataResult.success(paging);
    }
    /**
     * 新增、编辑页面
     * @param model
     * @param paramMap
     * @return
     */
    @RequestMapping("add")
    public String save(Model model, @RequestParam Map<String, Object> paramMap ){
        model.addAttribute("ascriptionType", String.valueOf(paramMap.get("ascriptionType")));
        model.addAttribute("menuName", String.valueOf(paramMap.get("menuName")));
        model.addAttribute("state",String.valueOf(paramMap.get("state")));

        //是否新增
        String reportId = String.valueOf(paramMap.get("reportId"));
        String isAdd="0";
        if (StringUtils.isBlank(reportId)){
            reportId=idGenerator.getUniqueId();
            isAdd="1";
        }
        model.addAttribute("isAdd", isAdd);
        model.addAttribute("reportId", reportId);
        return "/analysis/warnbulletin/add";
    }

    /**
     * 保存
     * @param generalReport
     * @return
     */
    @RequestMapping("save")
    @ResponseBody
    public DataResult save(GeneralReport generalReport,String isAdd){
        warnBulletinService.saveReport(generalReport,isAdd);
        return DataResult.success();
    }
    /**
     * 提交
     * @param reportId
     * @return
     */
    @RequestMapping("submit")
    @ResponseBody
    public DataResult submit(String reportId){
        warnBulletinService.submitReport(reportId);
        return DataResult.success();
    }

    /**
     * 最新年
     * @param paramMap
     * @return
     */
    @RequestMapping("getNewestDate")
    @ResponseBody
    public DataResult getNewestDate(@RequestParam Map<String, Object> paramMap){
        return DataResult.success(warnBulletinService.getNewestDate(paramMap));
    }
}

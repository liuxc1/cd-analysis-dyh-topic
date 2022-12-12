package ths.project.analysis.commonreport.web;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import ths.jdp.core.dao.base.Paging;
import ths.jdp.core.model.LoginUserModel;
import ths.jdp.core.web.LoginCache;
import ths.project.analysis.commonreport.service.CommonReportService;
import ths.project.analysis.commonreport.vo.CommonReportVo;
import ths.project.analysis.forecast.report.entity.GeneralReport;
import ths.project.common.data.DataResult;
import ths.project.common.uid.SnowflakeIdGenerator;

import java.util.Map;

/**
 * 公共报告模块
 *
 * @date 2021年11月22日 9:22
 */
@Controller
@RequestMapping("/analysis/commonReport")
public class CommonReportController {

    @Autowired
    private CommonReportService commonReportService;

    @Autowired
    private ThreadPoolTaskExecutor reportThreadPoolTaskExecutor;
    /**
     * 雪花ID
     */
    @Autowired
    private SnowflakeIdGenerator idGenerator;

    /**
     * 预览首页
     *
     * @param model
     * @param paramMap
     * @return url： http://localhost:7090/dyh_analysis/analysis/commonReport/index.vm?type=xxx&menuName=aaa
     */
    @RequestMapping("/index")
    public String index(Model model, @RequestParam Map<String, Object> paramMap) {
        model.addAttribute("ascriptionType", paramMap.get("type"));
        model.addAttribute("menuName", paramMap.get("menuName"));
        model.addAttribute("reportId", paramMap.get("reportId"));
        model.addAttribute("isSmallType", paramMap.get("isSmallType"));
        return "/analysis/commonreport/index";
    }

    /**
     * 获取文件信息
     *
     * @return
     */
    @RequestMapping("/getFileInfoByAscriptionType")
    @ResponseBody
    public DataResult getFileInfoByAscriptionType(@RequestParam Map<String, Object> paramMap) {
        if (paramMap == null || StringUtils.isBlank((String) paramMap.get("ascriptionType"))) {
            return DataResult.failure("请求参数错误，可能值为空或包含非法字符！");
        } else {
            Map<String, Object> resultMap = commonReportService.getFileInfoByAscriptionType(paramMap);
            if (resultMap != null) {
                return DataResult.success(resultMap);
            } else {
                return DataResult.failure("暂无数据！");
            }
        }
    }

    /**
     * 列表页面
     *
     * @param model
     * @param paramMap
     * @return
     */
    @RequestMapping("list")
    public String list(Model model, @RequestParam Map<String, Object> paramMap) {
        model.addAttribute("ascriptionType", paramMap.get("ascriptionType"));
        model.addAttribute("menuName", paramMap.get("menuName"));
        model.addAttribute("isSmallType", paramMap.get("isSmallType"));
        return "/analysis/commonreport/list";
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
        Paging<CommonReportVo> paging = commonReportService.queryReportListByAscriptionType(paramMap, pageInfo);
        return DataResult.success(paging);
    }

    /**
     * 新增、编辑页面
     *
     * @param model
     * @param paramMap
     * @return
     */
    @RequestMapping("add")
    public String save(Model model, @RequestParam Map<String, Object> paramMap) {
        model.addAttribute("ascriptionType", paramMap.get("ascriptionType"));
        model.addAttribute("menuName", paramMap.get("menuName"));
        model.addAttribute("isSmallType", paramMap.get("isSmallType"));

        //是否新增
        String reportId = (String) paramMap.get("reportId");
        String isAdd = "0";
        if (StringUtils.isBlank(reportId)) {
            reportId = idGenerator.getUniqueId();
            isAdd = "1";
        }
        model.addAttribute("isAdd", isAdd);
        model.addAttribute("reportId", reportId);

        return "/analysis/commonreport/add";
    }

    /**
     * 保存
     *
     * @param generalReport
     * @return
     */
    @RequestMapping("save")
    @ResponseBody
    public DataResult add(GeneralReport generalReport) {
        LoginUserModel loginUser = LoginCache.getLoginUser();
        commonReportService.saveReport(generalReport, loginUser);
        return DataResult.success();
    }

    /**
     * 最新年
     *
     * @param paramMap
     * @return
     */
    @RequestMapping("getNewestDate")
    @ResponseBody
    public DataResult getNewestDate(@RequestParam Map<String, Object> paramMap) {
        return DataResult.success(commonReportService.getNewestDate(paramMap));
    }

    /**
     * 获取所有小类
     *
     * @return
     */
    @RequestMapping("/getSamllType")
    @ResponseBody
    public DataResult getSamllType(@RequestParam Map<String, Object> paramMap) {
        return DataResult.success(commonReportService.getSamllType(paramMap));
    }
}

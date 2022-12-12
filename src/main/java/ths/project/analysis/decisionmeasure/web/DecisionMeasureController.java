package ths.project.analysis.decisionmeasure.web;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import ths.jdp.core.dao.base.Paging;
import ths.jdp.core.web.LoginCache;
import ths.project.analysis.decisionmeasure.entity.WarnControlInfo;
import ths.project.analysis.decisionmeasure.service.DecisionMeasureService;
import ths.project.analysis.decisionmeasure.vo.WarnControlVo;
import ths.project.analysis.forecast.report.entity.GeneralReport;
import ths.project.common.aspect.log.annotation.LogOperation;
import ths.project.common.data.DataResult;
import ths.project.common.uid.SnowflakeIdGenerator;

import java.util.Map;

/**
 * 决策措施
 *
 * @date 2021年11月22日 9:22
 */
@Controller
@RequestMapping("/analysis/decisionMeasure")
public class DecisionMeasureController {

    @Autowired
    private DecisionMeasureService decisionMeasureService;

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
     * @return url： http://localhost:7090/dyh_analysis/analysis/decisionMeasure/index.vm?menuName=测试&type=TEST&reportId=&isShowControl=0&fileTypes=TEST_FILE_1,TEST_FILE_2,TEST_FILE_3&fileTypeNames=测试文件1,测试文件2,测试文件3&imageTypes=TEST_IMAGE_1,TEST_IMAGE_2&imageTypeNames=测试图片1,测试图片2
     */
    @RequestMapping("/index")
    public String index(Model model, @RequestParam Map<String, Object> paramMap) {
        model.addAttribute("ascriptionType", paramMap.get("type"));
        model.addAttribute("menuName", paramMap.get("menuName"));
        model.addAttribute("reportId", paramMap.get("reportId"));
        model.addAttribute("isShowControl", paramMap.get("isShowControl"));
        //文件、图片归属类型及名称，字符串 ',' 分隔
        model.addAttribute("fileTypes", paramMap.get("fileTypes"));
        model.addAttribute("fileTypeNames", paramMap.get("fileTypeNames"));
        model.addAttribute("imageTypes", paramMap.get("imageTypes"));
        model.addAttribute("imageTypeNames", paramMap.get("imageTypeNames"));
        return "/analysis/decisionmeasure/index";
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
            Map<String, Object> resultMap = decisionMeasureService.getFileInfoByAscriptionType(paramMap);
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
        //是否展示预警管控相关信息
        model.addAttribute("isShowControl", paramMap.get("isShowControl"));
        //文件、图片归属类型及名称，字符串 ',' 分隔
        model.addAttribute("fileTypes", paramMap.get("fileTypes"));
        model.addAttribute("fileTypeNames", paramMap.get("fileTypeNames"));
        model.addAttribute("imageTypes", paramMap.get("imageTypes"));
        model.addAttribute("imageTypeNames", paramMap.get("imageTypeNames"));
        return "/analysis/decisionmeasure/list";
    }

    /**
     * 查询列表
     */

    @RequestMapping("/queryReportListByAscriptionType")
    @ResponseBody
    public DataResult queryReportListByAscriptionType(@RequestParam Map<String, Object> paramMap, Paging<WarnControlVo> pageInfo) {
        // 归属类型不能为空
        if (StringUtils.isBlank((String) paramMap.get("ascriptionType"))) {
            return DataResult.failure("请求参数错误，可能值为空或包含非法字符。");
        }
        Paging<WarnControlVo> paging = decisionMeasureService.queryReportListByAscriptionType(paramMap, pageInfo);
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
        //是否展示预警管控相关信息
        model.addAttribute("isShowControl", paramMap.get("isShowControl"));
        //文件、图片归属类型及名称，字符串 ',' 分隔
        model.addAttribute("fileTypes", paramMap.get("fileTypes"));
        model.addAttribute("fileTypeNames", paramMap.get("fileTypeNames"));
        model.addAttribute("imageTypes", paramMap.get("imageTypes"));
        model.addAttribute("imageTypeNames", paramMap.get("imageTypeNames"));
        //是否新增
        String reportId = (String) paramMap.get("reportId");
        String isAdd = "0";
        if (StringUtils.isBlank(reportId)) {
            reportId = idGenerator.getUniqueId();
            isAdd = "1";
        }
        model.addAttribute("isAdd", isAdd);
        model.addAttribute("reportId", reportId);

        return "/analysis/decisionmeasure/add";
    }

    /**
     * 保存
     *
     * @param generalReport
     * @return
     */
    @RequestMapping("save")
    @ResponseBody
    public DataResult add(GeneralReport generalReport, WarnControlInfo warnControlInfo, String isAdd, String isShowControl) {
        decisionMeasureService.saveReport(generalReport, warnControlInfo, isAdd, isShowControl);
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
        return DataResult.success(decisionMeasureService.getNewestDate(paramMap));
    }

    /**
     * 启用/停用
     *
     * @param warnControlInfo 管控信息VO
     * @return ResponseVo
     */
    @RequestMapping("/updateWarnState")
    @ResponseBody
    @LogOperation(module = "预警管控", operation = "修改预警状态")
    public DataResult updateWarnState(WarnControlInfo warnControlInfo) {
        // 获取当前登录用户
        String userName = LoginCache.getLoginUser().getUserName();
        int i = decisionMeasureService.updateWarnState(warnControlInfo, userName);
        if (i > 0) {
            return DataResult.success();
        } else {
            return DataResult.failure();
        }
    }

    /**
     * 删除
     *
     * @param reportId
     * @return ResponseVo
     */
    @RequestMapping("/deleteById")
    @ResponseBody
    @LogOperation(module = "预警管控", operation = "修改预警状态")
    public DataResult deleteById(String reportId) {
        int i = decisionMeasureService.deleteById(reportId);
        if (i > 0) {
            return DataResult.success();
        } else {
            return DataResult.failure();
        }
    }
}

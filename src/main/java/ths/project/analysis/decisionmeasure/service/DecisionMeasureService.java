package ths.project.analysis.decisionmeasure.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ths.jdp.core.dao.base.Paging;
import ths.jdp.core.model.LoginUserModel;
import ths.jdp.core.web.LoginCache;
import ths.project.analysis.decisionmeasure.entity.WarnControlInfo;
import ths.project.analysis.decisionmeasure.mapper.DecisionMeasureMapper;
import ths.project.analysis.decisionmeasure.vo.WarnControlVo;
import ths.project.analysis.forecast.report.entity.GeneralReport;
import ths.project.analysis.forecast.report.service.GeneralReportService;
import ths.project.system.base.util.PageSelectUtil;
import ths.project.system.file.service.CommFileService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @date 2021年11月22日 9:28
 */
@Service
public class DecisionMeasureService {

    @Autowired
    private DecisionMeasureMapper decisionMeasureMapper;

    @Autowired
    private CommFileService fileService;

    @Autowired
    private GeneralReportService generalReportService;

    /**
     * 查询文件信息
     *
     * @param paramMap
     * @return
     */
    public Map<String, Object> getFileInfoByAscriptionType(Map<String, Object> paramMap) {
        Map<String, Object> resultMap = decisionMeasureMapper.getReportInfoByAscriptionType(paramMap);
        if (resultMap != null) {
            // 查询文件
            List<Map<String, Object>> fileList = fileService.queryFileListByAscription((String) resultMap.get("REPORT_ID"));
            resultMap.put("fileList", fileList);
        }
        return resultMap;
    }

    /**
     * 保存报告表格
     * isAdd 是否为新增
     * isShowControl 是否展示管控信息
     *
     * @param generalReport
     */
    @Transactional
    public void saveReport(GeneralReport generalReport, WarnControlInfo warnControlInfo, String isAdd, String isShowControl) {
        generalReport.setState("UPLOAD");
        generalReportService.saveReport(generalReport);
        String warnControlId = warnControlInfo.getWarnControlId();
        if ("1".equals(isShowControl)) {
            warnControlInfo.setControlName(generalReport.getReportName());

            LoginUserModel loginUser = LoginCache.getLoginUser();
            WarnControlInfo oldWarnInfo = decisionMeasureMapper.selectById(warnControlId);
            if ("1".equals(isAdd) || oldWarnInfo == null) {
                //新增
                warnControlInfo.resolveCreate(loginUser.getUserName());
                decisionMeasureMapper.insert(warnControlInfo);
            } else {
                //修改
                warnControlInfo.resolveUpdate(loginUser.getUserName());
                decisionMeasureMapper.updateById(warnControlInfo);
            }
        }
    }

    public Map<String, String> getNewestDate(Map<String, Object> paramMap) {
        return decisionMeasureMapper.getNewestDate(paramMap);
    }

    /**
     * 查询列表数据
     *
     * @param paramMap
     * @param pageInfo
     * @return
     */
    public Paging<WarnControlVo> queryReportListByAscriptionType(Map<String, Object> paramMap, Paging<WarnControlVo> pageInfo) {
        return PageSelectUtil.selectListPage1(decisionMeasureMapper, pageInfo, DecisionMeasureMapper::queryReportList, paramMap);
    }

    /**
     * 停用、启用
     *
     * @param warnControlInfo
     * @param userName
     * @return
     */
    public int updateWarnState(WarnControlInfo warnControlInfo, String userName) {
        warnControlInfo.resolveUpdate(userName);
        return decisionMeasureMapper.updateById(warnControlInfo);
    }

    /**
     * 删除
     *
     * @param reportId
     * @return
     */
    public int deleteById(String reportId) {
        if (reportId == null || "".equals(reportId)) {
            return -1;
        }
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("reportId", reportId);
        int i = generalReportService.deleteReportById(paramMap);
        WarnControlInfo warnControlInfo = decisionMeasureMapper.selectById(reportId);
        if (warnControlInfo != null) {
            i += decisionMeasureMapper.deleteById(reportId);
        }
        return i;
    }
}

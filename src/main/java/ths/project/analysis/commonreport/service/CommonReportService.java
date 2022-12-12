package ths.project.analysis.commonreport.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ths.jdp.core.dao.base.Paging;
import ths.jdp.core.model.LoginUserModel;
import ths.project.analysis.commonreport.mapper.CommonReportMapper;
import ths.project.analysis.commonreport.vo.CommonReportVo;
import ths.project.analysis.commonreport.vo.SamllTypeVo;
import ths.project.analysis.forecast.report.entity.GeneralReport;
import ths.project.analysis.forecast.report.service.GeneralReportService;
import ths.project.system.base.util.PageSelectUtil;
import ths.project.system.file.service.CommFileService;

import java.util.List;
import java.util.Map;

/**
 * 公共报告模块
 *
 * @date 2021年11月22日 9:28
 */
@Service
public class CommonReportService {

    @Autowired
    private CommonReportMapper commonReportMapper;

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
        Map<String, Object> resultMap = commonReportMapper.getReportInfoByAscriptionType(paramMap);
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
    public void saveReport(GeneralReport generalReport, LoginUserModel loginUser) {
        generalReportService.saveReport(generalReport, loginUser);
    }


    public Map<String, String> getNewestDate(Map<String, Object> paramMap) {
        return commonReportMapper.getNewestDate(paramMap);
    }

    /**
     * 查询列表数据
     *
     * @param paramMap
     * @param pageInfo
     * @return
     */
    public Paging<CommonReportVo> queryReportListByAscriptionType(Map<String, Object> paramMap, Paging<CommonReportVo> pageInfo) {
        return PageSelectUtil.selectListPage1(commonReportMapper, pageInfo, CommonReportMapper::queryReportList, paramMap);
    }


    /**
     * 获取所有小类
     *
     * @return
     */
    public List<SamllTypeVo> getSamllType(Map<String, Object> paramMap) {
        return commonReportMapper.getSmallType(paramMap);
    }
}

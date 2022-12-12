package ths.project.analysis.analysisreport.service;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ths.jdp.core.web.LoginCache;
import ths.jdp.core.web.RequestHelper;
import ths.jdp.eform.service.components.word.DocumentPage;
import ths.project.analysis.analysisreport.entity.WinterExpress;
import ths.project.analysis.analysisreport.mapper.WinterExpressMapper;
import ths.project.analysis.forecast.airforecastmonth.entity.EnvAirdataRegionDay;
import ths.project.analysis.forecast.airforecastmonth.mapper.EnvAirdataRegionDayMapper;
import ths.project.analysis.forecast.report.entity.GeneralReport;
import ths.project.analysis.forecast.report.mapper.GeneralReportMapper;
import ths.project.analysis.forecast.report.service.GeneralReportService;
import ths.project.common.uid.SnowflakeIdGenerator;
import ths.project.common.util.DateUtil;
import ths.project.system.file.entity.CommFile;
import ths.project.system.file.service.CommFileService;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 冬季快报Service
 */
@Service
public class WinterExpressService {

    @Autowired
    private WinterExpressMapper winterExpressMapepr;
    @Autowired
    private GeneralReportService generalReportService;
    @Autowired
    private GeneralReportMapper generalReportMapper;
    @Autowired
    private CommFileService commFileService;
    @Autowired
    private SnowflakeIdGenerator idGenerator;
    @Autowired
    private EnvAirdataRegionDayMapper envAirdataRegionDayMapper;

    /**
     * 按月查询预测列表
     *
     * @return 预报列表
     */
    public List<Map<String, Object>> queryForecastListByMonth(String reportTime, String ascriptionType) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("reportTime", reportTime);
        map.put("ascriptionType", ascriptionType);
        List<Map<String, Object>> resultList = generalReportService.queryDayRecordListByReportTime(map);
        if (resultList != null && resultList.size() > 0) {
            for (Map<String, Object> resultMap : resultList) {
                List<Map<String, Object>> fileList = commFileService.queryFileListByAscription((String) resultMap.get("REPORT_ID"), ascriptionType);
                resultMap.put("fileList", fileList);
            }
        }
        return resultList;
    }

    /**
     * 删除报告
     *
     * @param
     * @return
     */
    public void deleteReportById(String reportId) {
        if (StringUtils.isNotBlank(reportId)) {
            generalReportMapper.deleteById(reportId);
            winterExpressMapepr.deleteById(reportId);
        }
    }

    /**
     * 保存日报文档数据
     *
     * @param winterExpres
     */
    @Transactional
    public void saveWinterExpress(WinterExpress winterExpres) {
        deleteReportById(winterExpres.getReportId());
        winterExpres.setReportId(idGenerator.getUniqueId());
        winterExpres.setCreateTime(new Date());
        winterExpres.setEditTime(new Date());
        winterExpres.setEditUser(LoginCache.getLoginUser().getUserName());
        winterExpres.setCreateUser(LoginCache.getLoginUser().getLoginName());
        winterExpres.setReportName(DateUtil.format(winterExpres.getReportTime(), "yyyyMMdd") + "冬季快报");
        winterExpressMapepr.insert(winterExpres);
        addGeneralReport(winterExpres);
        createFile(winterExpres);
    }

    /**
     * 创建word和转为pdf
     *
     * @param winterExpres
     */
    public void createFile(WinterExpress winterExpres) {
        String ascriptionId = winterExpres.getReportId();
        String templatePath = RequestHelper.getRequest().getServletContext().getRealPath("/assets/template/winterExpress.docx");
        String ascriptionType = winterExpres.getAscriptionType();
        Map<String, Object> param = new HashMap<String, Object>();
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH");
        String DateString = formatter.format(winterExpres.getReportTime());
        param.put("YEAR", DateString.substring(0, 4));
        param.put("MOON", DateString.substring(5, 7));
        param.put("DAY", DateString.substring(8, 10));
        param.put("HOUR", DateString.substring(11, 13));
        param.put("TEXT1", winterExpres.getGenerateContentOne());
        param.put("TEXT2", winterExpres.getGenerateContentTwo());
        DocumentPage page = new DocumentPage();
        page.setParamMap(param);
        CommFile commFile = commFileService.saveGenerateWordFile(page, null, null, templatePath,
                winterExpres.getReportName(), winterExpres.getAscriptionType());
        commFileService.deleteFileByAscription(ascriptionId, ascriptionType);
        commFileService.saveFileInfo(commFile, ascriptionId, ascriptionType, (String) param.get("createUser"), winterExpres.getState());
    }

    /**
     * 添加报告基本数据
     *
     * @param winterExpres
     */
    public void addGeneralReport(WinterExpress winterExpres) {
        GeneralReport generalReport = new GeneralReport();
        generalReport.setReportId(winterExpres.getReportId());
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        String DateString = formatter.format(winterExpres.getReportTime());
        Date reportTime = DateUtil.parseDate(DateString);
        generalReport.setReportTime(reportTime);
        generalReport.setReportName(winterExpres.getReportName());
        generalReport.setIsMain(0);
        generalReport.setReportRate("DAY");
        generalReport.setState(winterExpres.getState());
        generalReport.setAscriptionType(winterExpres.getAscriptionType());
        generalReport.setReportTip(winterExpres.getReportTip());
        generalReportService.saveReport(generalReport);
    }


    /**
     * 查询报告文档数据
     */
    public WinterExpress queryDayGeneralReportByIdAndFileSource(String ascriptionType, String reportTime, String reportId) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("ascriptionType", ascriptionType);
        map.put("reportTime", reportTime);
        List<Map<String, Object>> maps = generalReportService.queryDayRecordListByReportTime(map);
        if (maps != null && maps.size() > 0) {
            reportId = MapUtils.getString(maps.get(0), "REPORT_ID");
        }
        return winterExpressMapepr.selectById(reportId);
    }

    /**
     * 查询空气质量数据
     *
     * @param reportTime
     */
    public List<EnvAirdataRegionDay> getRegionPoint(String reportTime) {
        List<EnvAirdataRegionDay> airData = envAirdataRegionDayMapper.selectList(Wrappers.lambdaQuery(EnvAirdataRegionDay.class)
                .eq(EnvAirdataRegionDay::getMonitorTime, reportTime).eq(EnvAirdataRegionDay::getCodeRegion, "510100000000"));
        return airData;
    }
}

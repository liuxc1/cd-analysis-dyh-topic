package ths.project.analysis.forecast.report.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.service.IService;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import ths.jdp.core.dao.base.Paging;
import ths.jdp.core.model.LoginUserModel;
import ths.jdp.core.web.LoginCache;
import ths.project.analysis.forecast.numericalmodel.entity.WrfDataDay;
import ths.project.analysis.forecast.numericalmodel.mapper.WeatherElementChangeDayMapper;
import ths.project.analysis.forecast.report.enums.AnalysisStateEnum;
import ths.project.analysis.forecast.report.entity.GeneralReport;
import ths.project.analysis.forecast.report.mapper.GeneralReportMapper;
import ths.project.asses.entity.AssessMain;
import ths.project.common.uid.SnowflakeIdGenerator;
import ths.project.common.util.BeanUtil;
import ths.project.common.util.DateUtil;
import ths.project.common.util.LocalDateTimeUtil;
import ths.project.common.util.MapUtil;
import ths.project.system.base.util.PageSelectUtil;
import ths.project.system.file.entity.CommFile;
import ths.project.system.file.service.CommFileService;

import java.io.Serializable;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.DayOfWeek;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.*;

/**
 * 普通报告-服务层
 */
@Service("generalReportService")
public class GeneralReportService implements IService<GeneralReport> {

    private final GeneralReportMapper generalReportMapper;
    private final CommFileService commFileService;
    private final SnowflakeIdGenerator idGenerator;

    @Autowired
    public GeneralReportService(GeneralReportMapper generalReportMapper, CommFileService commFileService, SnowflakeIdGenerator idGenerator) {
        this.generalReportMapper = generalReportMapper;
        this.commFileService = commFileService;
        this.idGenerator = idGenerator;
    }

    @Override
    public BaseMapper<GeneralReport> getBaseMapper() {
        return generalReportMapper;
    }

    /**
     * 根据归属类型查询最大报告日期(不存在，则返回当前日期)（yyyy-MM-dd）
     */
    private String queyMaxReportTime(String ascriptionType, String reportRate) {
        QueryWrapper<GeneralReport> queryWrapper = Wrappers.query();
        String fieldName = BeanUtil.getFieldNameWithUpper(GeneralReport::getReportTime);
        GeneralReport generalReport = generalReportMapper.selectOne(queryWrapper.select("MAX(" + fieldName + ") " + fieldName)
                .eq(BeanUtil.getFieldNameWithUpper(GeneralReport::getAscriptionType), ascriptionType)
                .eq(StringUtils.isNotBlank(reportRate), BeanUtil.getFieldNameWithUpper(GeneralReport::getReportRate), reportRate));
        String maxReportTime;
        if (generalReport != null) {
            maxReportTime = DateUtil.formatDate(generalReport.getReportTime());
        } else {
            maxReportTime = DateUtil.formatDate(new Date());
        }
        return maxReportTime;
    }

    /**
     * 根据月份，查询频率为日的时间轴列表
     *
     * @param paramMap 参数
     * @return 频率为日的时间轴列表
     */
    public List<Map<String, Object>> queryDayTimeAxisListByMonth(Map<String, Object> paramMap) {
        paramMap.put("reportRate", "DAY");

        String month = (String) paramMap.get("month");
        // 判断是否传递时间，没有则读取数据库最大时间，如果数据库没有，则使用当前时间
        if (StringUtils.isBlank(month)) {
            String maxReportTime = queyMaxReportTime((String) paramMap.get("ascriptionType"), (String) paramMap.get("reportRate"));
            paramMap.put("month", maxReportTime.substring(0, 7));
        }
        return generalReportMapper.queryDayTimeAxisListByMonth(paramMap);
    }

    /**
     * 根据月份，查询频率为周的时间轴列表
     *
     * @param paramMap 参数
     * @return 频率为日的时间轴列表
     */
    public List<Map<String, Object>> queryWeekTimeAxisListByMonth(Map<String, Object> paramMap) {
        paramMap.put("reportRate", "WEEK");

        String month = (String) paramMap.get("month");
        // 判断是否传递时间，没有则读取数据库最大时间，如果数据库没有，则使用当前时间
        if (StringUtils.isBlank(month)) {
            String maxReportTime = queyMaxReportTime((String) paramMap.get("ascriptionType"), (String) paramMap.get("reportRate"));
            paramMap.put("month", maxReportTime.substring(0, 7));
        }
        return generalReportMapper.queryWeekTimeAxisListByMonth(paramMap);
    }

    /**
     * 查询周最大月份
     *
     * @param paramMap 参数
     * @return 周最大月份
     */
    public String queryWeekMaxMonth(Map<String, Object> paramMap) {
        paramMap.put("reportRate", "WEEK");
        String month = (String) paramMap.get("month");
        // 判断是否传递时间，没有则读取数据库最大时间，如果数据库没有，则使用当前时间
        if (StringUtils.isBlank(month)) {
            String maxReportTime = queyMaxReportTime((String) paramMap.get("ascriptionType"), (String) paramMap.get("reportRate"));
            month = maxReportTime.substring(0, 7);
        }
        return month;
    }

    /**
     * 根据年份，查询频率为月的时间轴列表
     *
     * @param paramMap 参数
     * @return 频率为月的时间轴列表
     */
    public List<Map<String, Object>> queryMonthTimeAxisListByYear(Map<String, Object> paramMap) {
        paramMap.put("reportRate", "MONTH");

        String year = (String) paramMap.get("year");
        // 判断是否传递时间，没有则读取数据库最大时间，如果数据库没有，则使用当前时间
        if (StringUtils.isBlank(year)) {
            String maxReportTime = queyMaxReportTime((String) paramMap.get("ascriptionType"), (String) paramMap.get("reportRate"));
            paramMap.put("year", maxReportTime.substring(0, 4));
        }
        return generalReportMapper.queryMonthTimeAxisListByYear(paramMap);
    }

    public List<Map<String, Object>> getRecordListByReportTime(String ascriptionType, Date startReportTime, Date endReportTime, String reportRate) {
        List<GeneralReport> reportList = generalReportMapper.selectList(Wrappers.lambdaQuery(GeneralReport.class)
                .eq(GeneralReport::getAscriptionType, ascriptionType)
                .eq(StringUtils.isNotBlank(reportRate), GeneralReport::getReportRate, reportRate)
                .ge(GeneralReport::getReportTime, startReportTime)
                .lt(GeneralReport::getReportTime, endReportTime)
                .orderByAsc(GeneralReport::getCreateTime));
        List<Map<String, Object>> reportMapList = new ArrayList<>(reportList.size());
        for (GeneralReport generalReport : reportList) {
            Map<String, Object> map = BeanUtil.toMapWithUpperName(new HashMap<>(), generalReport);
            reportMapList.add(map);
        }
        return reportMapList;
    }

    /**
     * 根据报告时间查询频率为日的记录列表
     *
     * @param paramMap 参数
     * @return 频率为日的记录列表
     */
    public List<Map<String, Object>> queryDayRecordListByReportTime(Map<String, Object> paramMap) {
        String ascriptionType = (String) paramMap.get("ascriptionType");
        Date startReportTime = DateUtil.parseDate((String) paramMap.get("reportTime"));
        Date endReportTime = DateUtil.addDay(startReportTime, 1);
        return getRecordListByReportTime(ascriptionType, startReportTime, endReportTime, null);
    }


    /**
     * 根据报告时间查询频率为周的记录列表
     *
     * @param paramMap 参数
     * @return 频率为日的记录列表
     */
    public List<Map<String, Object>> queryWeekRecordListByReportTime(Map<String, Object> paramMap) {
        String ascriptionType = (String) paramMap.get("ascriptionType");
        int weekOfYear = Integer.parseInt((String) paramMap.get("reportTime"));
        String month = (String) paramMap.get("month");


        LocalDateTime localDateTime = LocalDateTimeUtil.parseDateTime(month.substring(0, 4)+"-01-01 00:00:00").plusDays(7L * weekOfYear - 1);
        int compare = localDateTime.getDayOfWeek().compareTo(DayOfWeek.MONDAY);
        if (compare != 0) {
            localDateTime = localDateTime.plusDays(-compare);
        }
        Date startReportTime = Date.from(localDateTime.atZone(ZoneId.systemDefault()).toInstant());
        Date endReportTime = Date.from(localDateTime.plusDays(8).atZone(ZoneId.systemDefault()).toInstant());

        return getRecordListByReportTime(ascriptionType, startReportTime, endReportTime, "WEEK");
    }

    /**
     * 根据报告时间查询频率为月的记录列表
     *
     * @param paramMap 参数
     * @return 频率为月的记录列表
     */
    public List<Map<String, Object>> queryMonthRecordListByReportTime(Map<String, Object> paramMap) {
        String ascriptionType = (String) paramMap.get("ascriptionType");
        Date startReportTime = DateUtil.parseDate(paramMap.get("reportTime") + "-01");
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date endReportTime = getFirstDayOfNextMonth(sdf.format(startReportTime), -1);
        return getRecordListByReportTime(ascriptionType, startReportTime, endReportTime, "MONTH");
    }

    /**
     * 根据ID，查询报告信息（不含文件信息）
     *
     * @param paramMap 参数
     * @return 报告信息
     */
    public Map<String, Object> queryGeneralReportById(Map<String, Object> paramMap) {
        GeneralReport generalReport = generalReportMapper.selectById((Serializable) paramMap.get("reportId"));
        return BeanUtil.toMapWithUpperName(new HashMap<>(), generalReport);
    }

    /**
     * 根据报告ID和文件来源（可选）查询频率为日的报告内容
     *
     * @param paramMap 参数
     * @return 报告内容
     */
    public Map<String, Object> queryDayGeneralReportByIdAndFileSource(Map<String, Object> paramMap) {
        // 查询基本信息
        Map<String, Object> reportMap = queryGeneralReportById(paramMap);
        if (reportMap != null && reportMap.size() > 0) {
            String[] fileSources = null;
            if (StringUtils.isNotBlank((String) paramMap.get("fileSources"))) {
                fileSources = ((String) paramMap.get("fileSources")).split(",");
            }
            // 查询文件
            List<Map<String, Object>> fileList = commFileService.queryFileListByFileSources((String) paramMap.get("reportId"), fileSources);
            reportMap.put("fileList", fileList);
        }
        return reportMap;
    }

    /**
     * 查询特定状态记录数
     *
     * @param paramMap 参数
     * @return 特定状态记录数
     */
    public Map<String, Object> queryStateNumber(Map<String, Object> paramMap) {
        return generalReportMapper.queryStateNumber(paramMap);
    }


    /**
     * 根据报告时间范围和状态查询报告列表
     *
     * @param startTime 开始时间
     * @param endTime   结束时间
     * @param state     状态
     * @return 报告列表
     */
    public List<Map<String, Object>> queryGeneralReportByTimeAndState(String ascriptionType, String startTime, String endTime, String state) {
        @SuppressWarnings("unchecked")
        List<GeneralReport> reportList = generalReportMapper.selectList(Wrappers.lambdaQuery(GeneralReport.class)
                .eq(GeneralReport::getAscriptionType, ascriptionType)
                .eq(GeneralReport::getState, state)
                .ge(GeneralReport::getReportTime, startTime)
                .le(GeneralReport::getReportTime, endTime)
                .orderByAsc(GeneralReport::getReportTime, GeneralReport::getReportId));

        List<Map<String, Object>> reportMapList = new ArrayList<>(reportList.size());
        for (GeneralReport generalReport : reportList) {
            Map<String, Object> map = BeanUtil.toMapWithUpperName(new HashMap<>(), generalReport);
            reportMapList.add(map);
        }
        return reportMapList;
    }

    /**
     * 根据归属类型查询最大月份
     *
     * @param ascriptionType 归属类型
     * @return 最大月份
     */
    public String queryMaxMonthByAscriptionType(String ascriptionType) {
        String maxReportTime = queyMaxReportTime(ascriptionType, null);
        return maxReportTime.substring(0, 7);
    }

    /**
     * 保存报告
     *
     * @param paramMap       参数
     * @param multipartFiles 文件
     * @param remarks        文件备注(可选)
     * @return 保存的记录ID
     */
    @Transactional(rollbackFor = Exception.class)
    public String saveReport(Map<String, Object> paramMap, MultipartFile[] multipartFiles, String... remarks) {
        CommFile[] commFiles = null;
        if (multipartFiles != null && multipartFiles.length > 0) {
            commFiles = commFileService.saveUploadFileToDisk(multipartFiles);
            boolean isTransform = true;
            if (StringUtils.isNotBlank((String) paramMap.get("isTransform"))) {
                isTransform = Boolean.parseBoolean((String) paramMap.get("isTransform"));
            }
            for (CommFile commFile : commFiles) {
                commFile.setFileSource(AnalysisStateEnum.UPLOAD.getValue());
                commFile.setIsTransform(isTransform ? 1 : 0);
            }
            if (remarks != null && remarks.length > 0) {
                for (int i = 0; i < Math.min(remarks.length, commFiles.length); i++) {
                    commFiles[i].setRemark(remarks[i]);
                }
            }
        }
        GeneralReport report = saveReport(paramMap);
        if (commFiles != null) {
            commFileService.saveFileInfo(commFiles, report.getReportId(), report.getAscriptionType(), LoginCache.getLoginUser().getLoginName(),"Y","UPLOAD");
        }
        String deleteFileIdStr = (String) paramMap.get("deleteFileIds");
        if (StringUtils.isNotBlank(deleteFileIdStr)) {
            String[] deleteFileIds = deleteFileIdStr.split(",");
            // 删除前台删除的文件
            commFileService.deleteFileByFileIds(deleteFileIds);
        }

        return report.getReportId();
    }

    /**
     * 保存报告
     */
    public GeneralReport saveReport(Map<String, Object> paramMap) {
        GeneralReport report = new GeneralReport();
        MapUtil.toBeanByUpperName(paramMap, report);
        MapUtil.toBean(paramMap, report);
        return saveReport(report);
    }

    /**
     * 保存报告
     *
     * @param report         参数
     * @param multipartFiles 文件
     * @param remarks        文件备注(可选)
     * @return 保存的记录ID
     */
    @Transactional(rollbackFor = Exception.class)
    public String saveReport(GeneralReport report, MultipartFile[] multipartFiles, String deleteFileIds, String... remarks) {
        CommFile[] commFiles = null;
        if (multipartFiles != null && multipartFiles.length > 0) {
            commFiles = commFileService.saveUploadFileToDisk(multipartFiles);
            for (CommFile commFile : commFiles) {
                commFile.setFileSource(AnalysisStateEnum.UPLOAD.getValue());
            }
            if (remarks != null && remarks.length > 0) {
                for (int i = 0; i < Math.min(remarks.length, commFiles.length); i++) {
                    commFiles[i].setRemark(remarks[i]);
                }
            }
        }
        report = saveReport(report);
        if (commFiles != null) {
            LoginUserModel loginUser = LoginCache.getLoginUser();
            if (loginUser==null){
                loginUser = new LoginUserModel();
            }
            commFileService.saveFileInfo(commFiles, report.getReportId(), report.getAscriptionType(), loginUser.getLoginName());
        }
        if (StringUtils.isNotBlank(deleteFileIds)) {
            String[] ids = deleteFileIds.split(",");
            commFileService.deleteFileByFileIds(ids);
        }

        return report.getReportId();
    }

    public GeneralReport saveReport(GeneralReport report) {
        LoginUserModel loginUser = LoginCache.getLoginUser();
        return saveReport(report,loginUser);
    }

    /**
     * 保存报告
     */
    public GeneralReport saveReport(GeneralReport report,LoginUserModel loginUser) {
        GeneralReport oldReport = null;
        // 如果ID为空,则生成ID
        String reportId = report.getReportId();
        if (StringUtils.isNotBlank(reportId)) {
            oldReport = generalReportMapper.selectById(reportId);
        }
        //LoginUserModel loginUser = LoginCache.getLoginUser();
        if (loginUser==null){
            loginUser = new LoginUserModel();
        }
        if (oldReport == null) {
            report.resolveCreate(loginUser.getUserName());
            report.setReportId(StringUtils.isNotBlank(reportId) ? reportId : idGenerator.getUniqueId());
            report.setCreateDept(loginUser.getRegionCode());
            report.setReportUserCode(loginUser.getUserId());
            report.setReportUserName(loginUser.getUserName());
            report.setCreateDept(loginUser.getDeptName());

            generalReportMapper.insert(report);
        } else {
            report.resolveUpdate(loginUser.getUserName());
            generalReportMapper.updateById(report);
        }
        return report;
    }



    /**
     * 修改报告状态
     *
     * @param paramMap 参数
     * @return 修改的记录条数
     */
    @Transactional(rollbackFor = Exception.class)
    public Integer updateReportState(Map<String, Object> paramMap) {
        String reportId = (String) paramMap.get("reportId");
        String state = (String) paramMap.get("state");
        Object isMain = paramMap.get("IS_MAIN");
        return generalReportMapper.update(null, Wrappers.lambdaUpdate(GeneralReport.class)
                .set(GeneralReport::getState, state)
                .set(isMain != null && !"".equals(isMain), GeneralReport::getIsMain, isMain)
                .eq(GeneralReport::getReportId, reportId));
    }

    /**
     * 根据报告ID删除报告
     *
     * @param paramMap 参数
     * @return 删除的条数
     */
    @Transactional(rollbackFor = Exception.class)
    public Integer deleteReportById(Map<String, Object> paramMap) {
        String reportId = (String) paramMap.get("reportId");
        if (reportId == null || "".equals(reportId)) {
            return -1;
        }
        // 删除记录
        int deleteReportNumber = generalReportMapper.deleteById(reportId);
        return deleteReportNumber;
    }

    /**
     * 根据时间、状态查询数据
     *
     * @param ascriptionType
     * @param reportTime
     * @param state
     * @return List<GeneralReport>
     */
    public List<GeneralReport> queryDataByTimeAndState(String ascriptionType, String reportTime, String state) {
        LambdaQueryWrapper<GeneralReport> queryWrapper = Wrappers.lambdaQuery();
        queryWrapper.eq(GeneralReport::getReportTime, reportTime)
                .eq(GeneralReport::getAscriptionType, ascriptionType)
                .eq(GeneralReport::getState, state);
        return generalReportMapper.selectList(queryWrapper);
    }

    public static Date getFirstDayOfNextMonth(String dateStr, int offerSet) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        try {
            Date date = sdf.parse(dateStr);
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(date);
            calendar.set(Calendar.DAY_OF_MONTH, 1);
            calendar.add(Calendar.MONTH, 1);
            DateUtil.addDay(calendar.getTime(), offerSet);
            return calendar.getTime();
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Map<String, Object> queryReport(Map<String, Object> paramMap) {
        paramMap.put("reportTime", paramMap.get("reportTime").toString().substring(0, 8) + "%");
        return generalReportMapper.queryReport(paramMap);
    }

    //查询状态为UPLOAD的最新数据
    public List<GeneralReport> getGeneralReportListDesc(String state, int isMain, String ascriptionType) {
        LambdaQueryWrapper<GeneralReport> queryReportInfoWrapper = Wrappers.lambdaQuery();
        queryReportInfoWrapper.eq(GeneralReport::getState, state)
                .eq(GeneralReport::getIsMain, isMain)
                .eq(GeneralReport::getAscriptionType, ascriptionType)
                .orderByDesc(GeneralReport::getReportTime);
        List<GeneralReport> generalReports = generalReportMapper.selectList(queryReportInfoWrapper);
        return generalReports;
    }

    /**
     * 查询列表数据
     * @param paramMap
     * @param pageInfo
     * @return
     */
    public Paging<GeneralReport> queryReportListByAscriptionType(Map<String, Object> paramMap, Paging<GeneralReport> pageInfo) {
        Date startTime = null;
        Date endTime = null;
        if ( paramMap.get("startTime") !=null &&  paramMap.get("startTime") !=""){
            startTime = DateUtil.parseDate(paramMap.get("startTime").toString());
        }
        if ( paramMap.get("endTime") !=null &&  paramMap.get("endTime") !=""){
            endTime = DateUtil.parseDate(paramMap.get("endTime").toString());
        }
        LambdaQueryWrapper<GeneralReport> queryWrapper = Wrappers.lambdaQuery();
        queryWrapper.eq(GeneralReport::getAscriptionType, paramMap.get("ascriptionType").toString())
                .ge(startTime!=null,GeneralReport::getReportTime, startTime)
                .le(endTime != null,GeneralReport::getReportTime, endTime)
                .eq(GeneralReport::getDeleteFlag,0)
                .orderByDesc(GeneralReport::getReportTime)
                .orderByDesc(GeneralReport::getCreateTime);
        return PageSelectUtil.selectListPage1(generalReportMapper, pageInfo, GeneralReportMapper::selectList, queryWrapper);
    }
}

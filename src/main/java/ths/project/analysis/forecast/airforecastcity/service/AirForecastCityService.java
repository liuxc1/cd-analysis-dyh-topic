package ths.project.analysis.forecast.airforecastcity.service;

import com.alibaba.fastjson.JSONArray;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ths.jdp.core.context.PropertyConfigure;
import ths.jdp.core.service.base.BaseService;
import ths.jdp.core.web.LoginCache;
import ths.jdp.core.web.RequestHelper;
import ths.jdp.eform.service.components.word.DocImage;
import ths.jdp.eform.service.components.word.DocSuperAndSub;
import ths.jdp.eform.service.components.word.DocumentPage;
import ths.project.analysis.forecast.airforecastcity.entity.AnsFlowInfo;
import ths.project.analysis.forecast.airforecastcity.entity.AnsFlowWqRow;
import ths.project.analysis.forecast.airforecastcity.mapper.AirForecastCityMapper;
import ths.project.analysis.forecast.airforecastcity.mapper.AnsFlowWqRowMapper;
import ths.project.analysis.forecast.report.entity.GeneralReport;
import ths.project.analysis.forecast.report.enums.AnalysisStateEnum;
import ths.project.analysis.forecast.report.enums.AscriptionTypeEnum;
import ths.project.analysis.forecast.report.service.GeneralReportService;
import ths.project.common.uid.SnowflakeIdGenerator;
import ths.project.common.util.*;
import ths.project.system.email.entity.MailFile;
import ths.project.system.email.service.SendMailService;
import ths.project.system.file.entity.CommFile;
import ths.project.system.file.service.CommFileService;
import ths.project.system.message.enums.SendTypeEnum;
import ths.project.system.message.service.SendMessageService;

import java.io.File;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@Service
public class AirForecastCityService extends BaseService {

    private final AirForecastCityMapper airForecastCityMapper;
    private final AnsFlowWqRowMapper ansFlowWqRowMapper;
    /**
     * 通用文件-服务层
     */
    private final CommFileService commFileService;

    private final GeneralReportService generalReportService;
    /**
     * 雪花ID
     */
    private final SnowflakeIdGenerator idGenerator;

    /**
     * 推送邮件-服务层
     */
    private final SendMailService sendMailService;

    private final SendMessageService sendMessageService;

    @Autowired
    public AirForecastCityService(AirForecastCityMapper airForecastCityMapper, AnsFlowWqRowMapper ansFlowWqRowMapper
            , CommFileService commFileService, GeneralReportService generalReportService
            , SnowflakeIdGenerator idGenerator, SendMailService sendMailService
            , SendMessageService sendMessageService) {
        this.airForecastCityMapper = airForecastCityMapper;
        this.ansFlowWqRowMapper = ansFlowWqRowMapper;
        this.commFileService = commFileService;
        this.generalReportService = generalReportService;
        this.idGenerator = idGenerator;
        this.sendMailService = sendMailService;
        this.sendMessageService = sendMessageService;
    }

    /**
     * 根据月份，查询频率为日的时间轴列表
     *
     * @param paramMap 参数
     * @return 频率为日的时间轴列表
     */
    public List<Map<String, Object>> queryDayTimeAxisListByMonth(Map<String, Object> paramMap) {
        return generalReportService.queryDayTimeAxisListByMonth(paramMap);
    }

    /**
     * 根据报告ID，查询城市预报信息
     *
     * @param paramMap 参数
     * @return 城市预报信息
     */
    @Transactional(rollbackFor = Exception.class)
    public Map<String, Object> queryCityForecastByReportId(Map<String, Object> paramMap) {
        // 1、查询基本信息
        Map<String, Object> cityForecastMap = getForecastFlowInfo(paramMap);
        if (cityForecastMap == null || cityForecastMap.size() == 0) {
            return null;
        }
        // 2、查询预报AQI信息
        LambdaQueryWrapper<AnsFlowWqRow> queryWqWrapper = Wrappers.lambdaQuery();
        queryWqWrapper.eq(AnsFlowWqRow::getInfoId, paramMap.get("reportId"))
                .orderByAsc(AnsFlowWqRow::getResultTime);
        List<Map<String, Object>> cityForecastAqiList = ansFlowWqRowMapper.selectMaps(queryWqWrapper);
        // 3、查询文件列表信息
        List<Map<String, Object>> fileList = commFileService.queryFileListByFileSources((String) paramMap.get("reportId"), AnalysisStateEnum.GENERATE.getValue());
        for (int i = fileList.size() - 1; i >= 0; i--) {
            String removeFileName = "24、48、72";
            if (MapUtils.getString(fileList.get(i), "FILE_NAME").contains(removeFileName)) {
                //删除24、48、72未来小时预报
                fileList.remove(i);
            }
        }
        cityForecastMap.put("CITY_FORECAST_AQI_LIST", cityForecastAqiList);
        cityForecastMap.put("FILES", fileList);
        return cityForecastMap;
    }

    /**
     * 根据报告ID，查询基本预报信息
     *
     * @param paramMap 参数
     * @return 城市预报信息基本信息
     */
    @Transactional(rollbackFor = Exception.class)
    public Map<String, Object> getForecastFlowInfo(Map<String, Object> paramMap) {
        LambdaQueryWrapper<AnsFlowInfo> queryInfoWrapper = Wrappers.lambdaQuery();
        queryInfoWrapper.eq(AnsFlowInfo::getInfoId, paramMap.get("reportId"));
        List<Map<String, Object>> ansFlowInfoList = airForecastCityMapper.selectMaps(queryInfoWrapper);
        Map<String, Object> map = new HashMap<>();
        if (ansFlowInfoList != null && ansFlowInfoList.size() != 0) {
            map = ansFlowInfoList.get(0);
        }
        return map;
    }

    /**
     * 查询最新基本预报信息
     *
     * @return 城市预报信息基本信息
     */
    public Map<String, Object> getNewForecastFlowInfo() {
        List<GeneralReport> generalReports = generalReportService.getGeneralReportListDesc("UPLOAD", 1, AscriptionTypeEnum.CITY_FORECAST.getValue());
        Map<String, Object> forecastFlowInfo = new HashMap<>();
        if (generalReports != null && generalReports.size() != 0) {
            String reportId = generalReports.get(0).getReportId();
            HashMap<String, Object> queryMap = new HashMap<>();
            queryMap.put("reportId", reportId);
            forecastFlowInfo = getForecastFlowInfo(queryMap);
        }
        return forecastFlowInfo;
    }

    /**
     * 获取AQI、首要污染物等具体信息
     *
     * @param paramMap 参数
     * @return 获取AQI、首要污染物等具体信息
     */
    @Transactional(rollbackFor = Exception.class)
    public List<Map<String, Object>> getForecastValueList(Map<String, Object> paramMap) {
        return airForecastCityMapper.getForecastValueList(paramMap);
    }

    /**
     * 根据ID查询图片
     *
     * @param paramMap 请求参数
     * @return
     */
    @Transactional(rollbackFor = Exception.class)
    public Map<String, Object> cityForecastInfoById(Map<String, Object> paramMap) {
        Map<String, Object> consultMap = new HashMap<String, Object>();
        // 根据会商ID，查询文件列表
        List<Map<String, Object>> fileList = commFileService.queryFileListByAscription((String) paramMap.get("reportId"), AnalysisStateEnum.UPLOAD.getValue());
        consultMap.put("FILES", fileList != null && fileList.size() > 0 ? fileList : null);
        return consultMap;
    }

    /**
     * 根据报告ID，预报的AQI详情
     *
     * @param reportId 报告ID
     * @return 预报的AQI详情
     */
    public List<AnsFlowWqRow> queryCityForecastAqiByReportId(String reportId) {
        LambdaQueryWrapper<AnsFlowWqRow> queryWrapper = Wrappers.lambdaQuery();
        queryWrapper.eq(AnsFlowWqRow::getInfoId, reportId)
                .orderByAsc(AnsFlowWqRow::getResultTime);
        return ansFlowWqRowMapper.selectList(queryWrapper);
    }

    /**
     * 根据报告ID，解析意见
     *
     * @param reportId 报告ID
     * @return 未来3天城市预报解析意见
     */
    public Map<String, Object> queryJudgeInfoByPkId(String reportId) {
        HashMap<String, Object> queryMap = new HashMap<>();
        queryMap.put("reportId", reportId);
        return getForecastFlowInfo(queryMap);
    }


    /**
     * @return
     * @Title: addForecastFlowInfo
     * @Description: 写入城市预报列表数据
     */
    @Transactional
    public void addForecastFlowInfo(Map<String, Object> paramMap) {
        //新增flowInfo
        AnsFlowInfo ansFlowInfo = MapUtil.toBeanByUpperName(paramMap, new AnsFlowInfo());
        ansFlowInfo.setInfoId(paramMap.get("reportId").toString());
        ansFlowInfo.setReportTime(DateUtil.parseDate(paramMap.get("datetime").toString()));
        ansFlowInfo.setCreateTime(new Date());
        ansFlowInfo.setEditTime(new Date());
        ansFlowInfo.setWeatherConditionsType(MapUtils.getInteger(paramMap, "weatherConditionsType"));
        airForecastCityMapper.insert(ansFlowInfo);
        //更新report
        GeneralReport generalReport = new GeneralReport();
        generalReport.setReportId(paramMap.get("reportId").toString());
        generalReport.setReportTime(DateUtil.parseDate(paramMap.get("datetime").toString()));
        String reportName = DateUtil.format(DateUtil.parseDate((String) paramMap.get("datetime")), "yyyyMMdd") + "城市预报";
        generalReport.setReportName(reportName);
        generalReport.setIsMain((Integer) paramMap.get("IS_MAIN"));
        generalReport.setReportRate("DAY");
        generalReport.setState((String) paramMap.get("STATE"));
        generalReport.setAscriptionType("CITY_FORECAST");
        generalReport.setReportTip(paramMap.get("IMPORTANT_HINTS_DAY7").toString());
        generalReport.setField1(paramMap.get("IMPORTANT_HINTS_DAY7").toString());
        generalReportService.saveReport(generalReport);
    }

    /**
     * 保存AQI、首要污染物等具体信息
     */
    @Transactional
    public void saveForecastValues(Map<String, Object> paramMap, Map<String, Object> paramMap1) throws Exception {
        // 根据预报填报ID判断是否是新增
        boolean isAdd = "1".equals(paramMap1.get("isAdd"));
        // 获取预报ID
        String consultId = (String) paramMap1.get("FORECAST_ID");
        // 所属类型
        paramMap.put("ASCRIPTION_TYPE", AscriptionTypeEnum.CITY_FORECAST.getValue());
        paramMap.put("reportId", consultId);
        if (isAdd) {
            paramMap.put("CREATE_USER", LoginCache.getLoginUser().getUserName());
            paramMap.put("EDIT_USER", LoginCache.getLoginUser().getUserName());
            addForecastFlowInfo(paramMap);// 新增主信息
            // 判断是否有上一次的归属id，如果有，进行文件的copy
            if (paramMap1.get("oldAscriptionId") != null && !"".equals(paramMap1.get("oldAscriptionId"))) {
                copyFileInfo(paramMap1, consultId);
            }
        } else {
            paramMap.put("EDIT_USER", LoginCache.getLoginUser().getUserName());
            updateForecastFlowInfo(paramMap);// 修改主信息
        }
        //如果提交预报，则修改当天其他人的所有预报数据状态为提交
        if ("UPLOAD".equals(paramMap.get("STATE").toString())) {
            updateAllState(paramMap);
        }
        // 处理从表
        List<Map<String, Object>> tableListMap = (List<Map<String, Object>>) JSONArray.parse((String) paramMap1.get("TableList"));

        ansFlowWqRowMapper.delete(Wrappers.lambdaQuery(AnsFlowWqRow.class).eq(AnsFlowWqRow::getInfoId, consultId).eq(AnsFlowWqRow::getCreateTime, tableListMap.get(0).get("CREATE_TIME")));
        for (Map<String, Object> map : tableListMap) {
            map.put("INFO_ID", consultId);
            System.out.println(map.get("PRIM_POLLUTE"));
            if (map.get("PRIM_POLLUTE") != null) {
                String a = map.get("PRIM_POLLUTE").toString().replace("\"", "").replace("[", "").replace("]", "");
                map.put("PRIM_POLLUTE", a);
            }
            AnsFlowWqRow ansFlowWqRow = MapUtil.toBeanByUpperName(map, new AnsFlowWqRow());
            ansFlowWqRowMapper.insert(ansFlowWqRow);
        }
        String userName = LoginCache.getLoginUser().getUserName();
        export72HourForecastWord(paramMap, userName);
        export7DaysForecastWord(paramMap, userName);

        Calendar calendar = Calendar.getInstance();
        int currentHour = calendar.get(Calendar.HOUR_OF_DAY);
        String currentDateStr = DateUtil.formatDate(calendar.getTime());
        // 16点之后提交会发送短信
        if (paramMap.get("STATE") != null && "UPLOAD".equals(paramMap.get("STATE").toString())
                && currentHour >= 16 && currentDateStr.equals(paramMap.get("datetime").toString())) {
            this.sendMessageByReportId(SendTypeEnum.CITY_FORECAST_7DAY, consultId);
        }

        if (paramMap.get("STATE") != null && "UPLOAD".equals(paramMap.get("STATE").toString())) {
            String[] tos = PropertyConfigure.getProperty("mail.tos.3day").toString().split(",");
            this.sendMailByReportId(null, 3, consultId, tos, currentDateStr);
            tos = PropertyConfigure.getProperty("mail.tos.7day").toString().split(",");
            this.sendMailByReportId(null, 7, consultId, tos, currentDateStr);
        }
    }

    /**
     *
     */
    @Transactional
    public void copyFileInfo(Map<String, Object> paramMap1, String consultId) {
        String deleteFileIds = String.valueOf(paramMap1.get("DELETE_FILE_IDS"));
        List<Map<String, Object>> list = commFileService.queryFileListByFileSources((String) paramMap1.get("oldAscriptionId"), "UPLOAD");
        //存放文件对象信息
        List<CommFile> commFileList = new ArrayList<>();
        for (Map<String, Object> map : list) {
            if (deleteFileIds.contains((CharSequence) map.get("FILE_ID"))) {
                continue;
            }

            String fileId = idGenerator.getUniqueId();
            map.put("FILE_ID", fileId);
            map.put("ASCRIPTION_ID", consultId);
            CommFile commFile = MapUtil.toBeanByUpperName(map, new CommFile());
            commFile.resolveCreate(LoginCache.getLoginUser().getUserName());
            commFileList.add(commFile);
        }
        // 数据库插入文件信息
        commFileService.saveFileInfo(commFileList);
    }

    /**
     * 删除AQI、首要污染物等具体信息
     */
    @Transactional
    public void deleteForecastFlowValues(Map<String, Object> paramMap) {
        LambdaQueryWrapper<AnsFlowWqRow> deleteWrapper = Wrappers.lambdaQuery();
        deleteWrapper.eq(AnsFlowWqRow::getInfoId, paramMap.get("reportId"));
        ansFlowWqRowMapper.delete(deleteWrapper);
    }

    /**
     * 更新城市预报列表数据
     */
    @Transactional
    public void updateForecastFlowInfo(Map<String, Object> paramMap) {
        //更新flowInfo
        AnsFlowInfo ansFlowInfo = MapUtil.toBeanByUpperName(paramMap, new AnsFlowInfo());
        ansFlowInfo.setEditTime(new Date());
        ansFlowInfo.setInfoId(paramMap.get("reportId").toString());
        ansFlowInfo.setWeatherConditionsType(MapUtils.getInteger(paramMap, "weatherConditionsType"));
        airForecastCityMapper.updateById(ansFlowInfo);
        //更新report
        GeneralReport generalReport = new GeneralReport();
        generalReport.setReportId(paramMap.get("reportId").toString());
        generalReport.setReportTip(paramMap.get("IMPORTANT_HINTS_DAY7").toString());
        generalReport.setField1(paramMap.get("IMPORTANT_HINTS_DAY7").toString());
        generalReport.setIsMain(Integer.parseInt(paramMap.get("IS_MAIN").toString()));
        generalReportService.saveReport(generalReport);
    }


    /**
     * 主要污染物格式化
     *
     * @param page
     */
    private void setPrimPolluteSub(DocumentPage page) {
        DocSuperAndSub docSub = new DocSuperAndSub();
        docSub.setAllWord("PM2.5");
        docSub.setBaseWord("PM");
        docSub.setSubscript("2.5");
        page.getSuperAndSubs().add(docSub);
        docSub = new DocSuperAndSub();
        docSub.setAllWord("SO2");
        docSub.setBaseWord("SO");
        docSub.setSubscript("2");
        page.getSuperAndSubs().add(docSub);
        docSub = new DocSuperAndSub();
        docSub.setAllWord("NO2");
        docSub.setBaseWord("NO");
        docSub.setSubscript("2");
        page.getSuperAndSubs().add(docSub);
        docSub = new DocSuperAndSub();
        docSub.setAllWord("PM10");
        docSub.setBaseWord("PM");
        docSub.setSubscript("10");
        page.getSuperAndSubs().add(docSub);
        docSub = new DocSuperAndSub();
        docSub.setAllWord("O3");
        docSub.setBaseWord("O");
        docSub.setSubscript("3");
        page.getSuperAndSubs().add(docSub);
    }

    /**
     * 导出未来3天预报信息
     */
    @Transactional(rollbackFor = Exception.class)
    public void export72HourForecastWord(Map<String, Object> paramMap, String userName) {
        Map<String, Object> flowInfo = this.getForecastFlowInfo(paramMap);// 查询对应的预报信息
        String datetime = ParamUtils.getString(paramMap, "datetime");// 返回什么格式
        // 定义模板路径和名称
        String fileName = "成都市区未来24、48、72小时空气质量预报-" + datetime.replaceAll("-", "");
        String templatePath = RequestHelper.getRequest().getServletContext().getRealPath("/assets/template/cityForecast72HoursModel.docx");
        DocumentPage page = new DocumentPage();
        Map<String, Object> pMap = new HashMap<String, Object>();
        // 定义时间格式
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat dateFormatCh = new SimpleDateFormat("yyyy年M月d日");
        SimpleDateFormat dateFormatMd = new SimpleDateFormat("M月d日");
        List<Map<String, Object>> list = this.getForecastValueList(paramMap);// 获取aqi、污染物等具体信息
        StringBuilder builder = new StringBuilder();
        if (ParamUtils.getString(flowInfo, "CITY_OPINION_3DAY") != null && !"".equals(ParamUtils.getString(flowInfo, "CITY_OPINION_3DAY"))) {
            String str = ParamUtils.getString(flowInfo, "CITY_OPINION_3DAY").trim();
            if (!str.endsWith("。")) {
                str += "。";
            }
            builder.append(str);
            builder.append("\r\n");
        }
        /*
         * if (ParamUtils.getString(flowInfo, "COUNTRY_OPINION_3DAY") != null && !"".equals(ParamUtils.getString(flowInfo, "COUNTRY_OPINION_3DAY"))) { String str = ParamUtils.getString(flowInfo, "COUNTRY_OPINION_3DAY").trim(); if (!str.endsWith("。")) { str+="。"; } builder.append(str); builder.append("\r\n"); }
         */
        String weatherConditionsTypeName = MapUtils.getInteger(flowInfo, "WEATHER_CONDITIONS_TYPE") == 1 ? "臭氧污染气象条件" : "气象扩散条件";
        for (int i = 0; i < 3; i++) {
            Map<String, Object> map = list.get(i);
            try {
                builder.append(dateFormatMd.format(dateFormat.parse(map.get("RESULT_TIME").toString())));
            } catch (ParseException e) {
                throw new RuntimeException(e);
            }
            builder.append("，" + weatherConditionsTypeName + "为");
            builder.append(map.get("WEATHER_LEVEL") == null ? "--" : map.get("WEATHER_LEVEL").toString().replace(":", "，"));
            builder.append("，预计AQI为");
            builder.append(map.get("AQI") == null ? "--" : map.get("AQI").toString().replace("~", "-"));
            builder.append("，空气质量等级为");
            builder.append(map.get("AQI_LEVEL") == null ? "--" : map.get("AQI_LEVEL").toString().replace("-", "至"));
            if (map.get("PRIM_POLLUTE") != null && !"".equals(map.get("PRIM_POLLUTE"))) {
                builder.append("，首要污染物为");
                builder.append(map.get("PRIM_POLLUTE").toString().replace(",", "、"));
            }
            if (i == 2) {
                builder.append("。\r\n");
            } else {
                builder.append("；\r\n");
            }
        }
        if (ParamUtils.getString(flowInfo, "IMPORTANT_HINTS") != null && !"".equals(ParamUtils.getString(flowInfo, "IMPORTANT_HINTS"))) {
            String str = "重要提示：" + ParamUtils.getString(flowInfo, "IMPORTANT_HINTS").trim();
            if (!str.endsWith("。")) {
                str += "。";
            }
            builder.append(str);
            builder.append("\r\n");
        }
        pMap.put("FORECAST_STR", builder.toString());
        try {
            pMap.put("RESULT_TIME_RANGE", dateFormatMd.format(dateFormat.parse(list.get(0).get("RESULT_TIME").toString())) + "-" + list.get(2).get("RESULT_TIME").toString().substring(8, 10) + "日");
        } catch (ParseException e1) {
            throw new RuntimeException(e1);
        }
        if (ParamUtils.getString(flowInfo, "INSCRIBE") != null && !"".equals(ParamUtils.getString(flowInfo, "INSCRIBE"))) {
            pMap.put("INSCRIBE", ParamUtils.getString(flowInfo, "INSCRIBE"));
        } else {
            pMap.put("INSCRIBE", "");
        }
        try {
            pMap.put("CREATE_TIME_CH", dateFormatCh.format(dateFormat.parse(datetime)));
        } catch (ParseException e) {
            throw new RuntimeException(e);
        }

        page.setParamMap(pMap);

        // 封装文档体中需要插入的图片，集合中存放的是图片对象
//        Map<String, Object> imgParamMap = new HashMap<String, Object>();
//        imgParamMap.put("FK_PKID", ParamUtils.getString(flowInfo, "PKID"));
//        imgParamMap.put("BUSINESS_TYPE", "城市预报填报");
        List<CommFile> imgResultList = commFileService.queryFileList((String) paramMap.get("reportId"), "UPLOAD_IMAGE");
        setImage(imgResultList, page, "OLE_LINK100");
        this.setPrimPolluteSub(page);

        CommFile commFile = commFileService.saveGenerateWordFile(page, null, null, templatePath, fileName, "CITY_FORECAST");
        String ascriptionId = paramMap.get("reportId").toString();
        String ascriptionType = "CITY_FORECAST_3";
        commFileService.deleteFileByAscription(ascriptionId, ascriptionType);
        commFileService.saveFileInfo(commFile, ascriptionId, ascriptionType, userName, AnalysisStateEnum.GENERATE.getValue());
    }

    /**
     * 导出7天未来预报
     */
    @Transactional(rollbackFor = Exception.class)
    public void export7DaysForecastWord(Map<String, Object> paramMap, String userName) {
        Map<String, Object> flowInfo = this.getForecastFlowInfo(paramMap);

        String datetime = ParamUtils.getString(paramMap, "datetime");
        // 定义模板路径和名称
        String fileName = "成都市区未来7天空气质量预报-" + datetime.replaceAll("-", "");
        String templatePath = RequestHelper.getRequest().getServletContext().getRealPath("/assets/template/cityForecast7DaysModel.docx");

        DocumentPage page = new DocumentPage();

        Map<String, Object> pMap = new HashMap<String, Object>();

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat dateFormatCh = new SimpleDateFormat("yyyy年M月d日");
        SimpleDateFormat dateFormatMd = new SimpleDateFormat("M月d日");
        List<Map<String, Object>> list = this.getForecastValueList(paramMap);
        // 导出数据
        StringBuilder builder = new StringBuilder();
        if (ParamUtils.getString(flowInfo, "CITY_OPINION") != null && !"".equals(ParamUtils.getString(flowInfo, "CITY_OPINION"))) {
            String str = ParamUtils.getString(flowInfo, "CITY_OPINION").trim();
            if (!str.endsWith("。")) {
                str += "。";
            }
            builder.append(str);
            builder.append("\r\n");
        }
        /*
         * if (ParamUtils.getString(flowInfo, "COUNTRY_OPINION") != null && !"".equals(ParamUtils.getString(flowInfo, "COUNTRY_OPINION"))) { String str = ParamUtils.getString(flowInfo, "COUNTRY_OPINION").trim(); if (!str.endsWith("。")) { str+="。"; } builder.append(str); builder.append("\r\n"); }
         */
        String weatherConditionsTypeName = MapUtils.getInteger(flowInfo, "WEATHER_CONDITIONS_TYPE") == 1 ? "臭氧污染气象条件" : "气象扩散条件";
        for (int i = 0; i < list.size(); i++) {
            Map<String, Object> map = list.get(i);
            builder.append(dateFormatMd.format(DateUtil.parse(map.get("RESULT_TIME").toString(), dateFormat)));
            builder.append("，" + weatherConditionsTypeName + "为");
            builder.append(map.get("WEATHER_LEVEL") == null ? "--" : map.get("WEATHER_LEVEL").toString().replace(":", "，"));
            builder.append("，预计AQI为");
            builder.append(map.get("AQI") == null ? "--" : map.get("AQI").toString().replace("~", "-"));
            builder.append("，空气质量等级为");
            builder.append(map.get("AQI_LEVEL") == null ? "--" : map.get("AQI_LEVEL").toString().replace("-", "至"));
            if (map.get("PRIM_POLLUTE") != null && !"".equals(map.get("PRIM_POLLUTE"))) {
                builder.append("，首要污染物为");
                builder.append(map.get("PRIM_POLLUTE").toString().replace(",", "、"));
            }
            if (i == list.size() - 1) {
                builder.append("。\r\n");
            } else {
                builder.append("；\r\n");
            }
        }

        if (ParamUtils.getString(flowInfo, "IMPORTANT_HINTS_SEVEN") != null && !"".equals(ParamUtils.getString(flowInfo, "IMPORTANT_HINTS_SEVEN"))) {
            String str = "重要提示：" + ParamUtils.getString(flowInfo, "IMPORTANT_HINTS_SEVEN").trim();
            if (!str.endsWith("。")) {
                str += "。";
            }
            builder.append(str);
            builder.append("\r\n");
        }
        pMap.put("FORECAST_STR", builder.toString());

        if (ParamUtils.getString(flowInfo, "INSCRIBE") != null && !"".equals(ParamUtils.getString(flowInfo, "INSCRIBE"))) {
            pMap.put("INSCRIBE", ParamUtils.getString(flowInfo, "INSCRIBE"));
        } else {
            pMap.put("INSCRIBE", "");
        }

        pMap.put("CREATE_TIME_CH", dateFormatCh.format(DateUtil.parse(datetime, dateFormat)));

        page.setParamMap(pMap);

//        Map<String, Object> imgParamMap = new HashMap<String, Object>();
//        imgParamMap.put("FK_PKID", ParamUtils.getString(flowInfo, "PKID"));
//        imgParamMap.put("BUSINESS_TYPE", "城市预报填报");
        List<CommFile> imgResultList = commFileService.queryFileList((String) paramMap.get("reportId"), "UPLOAD_IMAGE");
        setImage(imgResultList, page, "OLE_LINK100");
        this.setPrimPolluteSub(page);
        CommFile commFile = commFileService.saveGenerateWordFile(page, null, null, templatePath, fileName, "CITY_FORECAST");
        String ascriptionId = paramMap.get("reportId").toString();
        String ascriptionType = "CITY_FORECAST";
        commFileService.deleteFileByAscription(ascriptionId, ascriptionType);
        commFileService.saveFileInfo(commFile, ascriptionId, ascriptionType, userName, AnalysisStateEnum.GENERATE.getValue());
    }

    /**
     * 设置图片
     */
    @Transactional(rollbackFor = Exception.class)
    public void setImage(List<CommFile> imgResultList, DocumentPage page, String label) {
        List<DocImage> imageList = new ArrayList<DocImage>();
        for (int i = 0; i < imgResultList.size(); i++) {
            String imgPath = commFileService.getFileFullPath(imgResultList.get(i), false);
            // String imgPath = ParamUtils.getString(imgResultList.get(i), "FILE_SAVE_PATH");
            String imgName = imgResultList.get(i).getFileFullName().replace(".jpg", "").replace(".gif", "").replace(".png", "");
            File file = new File(imgPath);
            if (file.exists()) {
                // 图片对象构造方法有多个重载，本例中使用的构造方法有3个参数，分别为图片路径，长，宽
                DocImage img = new DocImage(imgPath, null, null);
                img.setLegendContent("图" + (i + 1) + " " + imgName);
                imageList.add(img);
            }
        }
        page.getImages().put(label, imageList);
    }

    /**
     * 修改报告状态
     */
    @Transactional(rollbackFor = Exception.class)
    public int updateForecastState(Map<String, Object> paramMap) {
        generalReportService.updateReportState(paramMap);
        AnsFlowInfo ansFlowInfo = new AnsFlowInfo();
        ansFlowInfo.setInfoId(paramMap.get("reportId").toString());
        ansFlowInfo.setFlowState(Integer.parseInt(paramMap.get("FLOW_STATE").toString()));
        int resultforecast = airForecastCityMapper.updateById(ansFlowInfo);
        //如果提交预报，则修改当天其他人的所有预报数据状态为提交
        paramMap.put("STATE", paramMap.get("state"));
        updateAllState(paramMap);
        // 16点之后提交会发送短信
        Map<String, Object> remap = getNewDate();
        int currentHour = Integer.parseInt((String) remap.get("HOUR"));
        String currentDateStr = remap.get("DATE").toString();
        if (paramMap.get("STATE") != null && "UPLOAD".equals(paramMap.get("STATE").toString()) && currentHour >= 16
                && currentDateStr.equals(paramMap.get("datetime").toString())
        ) {
//            this.sendMessageByReportId(SendTypeEnum.CITY_FORECAST_3DAY, paramMap.get("reportId").toString());
            this.sendMessageByReportId(SendTypeEnum.CITY_FORECAST_7DAY, paramMap.get("reportId").toString());
        }
        String[] tos = PropertyConfigure.getProperty("mail.tos.3day").toString().split(",");
        this.sendMailByReportId(null, 3, paramMap.get("reportId").toString(), tos, currentDateStr);
        tos = PropertyConfigure.getProperty("mail.tos.7day").toString().split(",");
        this.sendMailByReportId(null, 7, paramMap.get("reportId").toString(), tos, currentDateStr);
        return resultforecast;
    }

    /**
     * 根据报告ID删除报告
     *
     * @param paramMap 参数
     * @return 删除的条数
     */
    @Transactional(rollbackFor = Exception.class)
    public Integer deleteForecastById(Map<String, Object> paramMap) {
        //删除report表
        generalReportService.deleteReportById(paramMap);
        //删除value
        deleteForecastFlowValues(paramMap);
        //删除info
        LambdaQueryWrapper<AnsFlowInfo> deleteWrapper = Wrappers.lambdaQuery();
        deleteWrapper.eq(AnsFlowInfo::getInfoId, paramMap.get("reportId"));
        int resultforecast = airForecastCityMapper.delete(deleteWrapper);
        return resultforecast;
    }

    /**
     * 获取当前时间
     *
     * @return
     */
    public Map<String, Object> getNewDate() {
        Map<String, Object> reMap = new HashMap<String, Object>();
        String newDate = DateUtil.format(new Date(), "yyyy-MM-dd HH");
        reMap.put("DATE", newDate.substring(0, 10));
        reMap.put("HOUR", newDate.substring(11, 13));
        return reMap;
    }


    /**
     * 一条预报数据提交，修改当天所有预报为已提交
     */
    @Transactional
    public void updateAllState(Map<String, Object> paramMap) {
        AnsFlowInfo ansFlowInfo = new AnsFlowInfo();
        ansFlowInfo.setFlowState(Integer.parseInt(paramMap.get("FLOW_STATE").toString()));
        LambdaQueryWrapper<AnsFlowInfo> flowInfoWrapper = Wrappers.lambdaQuery();
        flowInfoWrapper.eq(AnsFlowInfo::getReportTime, DateUtil.parseDate(paramMap.get("datetime").toString()));
        airForecastCityMapper.update(ansFlowInfo, flowInfoWrapper);

        generalReportService.update(Wrappers.lambdaUpdate(GeneralReport.class)
                .set(GeneralReport::getState, paramMap.get("STATE"))
                .eq(GeneralReport::getReportTime, DateUtil.parseDate(paramMap.get("datetime").toString()))
                .eq(GeneralReport::getAscriptionType, "CITY_FORECAST"));
    }

    /**
     * 通过指标中值查询该指标的iaqi范围
     *
     * @param type
     * @param numMedian
     * @return
     */
    public Map<String, Object> getpollutantRange(String type, int numMedian) {
        return airForecastCityMapper.getpollutantRange(type, numMedian);
    }


    /**
     * 根据报告ID发送邮件
     *
     * @param subject  主题
     * @param step     步长，3天/7天。
     * @param reportId 报告ID
     * @param tos      发送目标邮箱，如要发给张三，则传递张三的邮箱地址。
     */
    public void sendMailByReportId(String subject, Integer step, String reportId, String[] tos, String reportDateStr) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("reportId", reportId);
        // 根据ID，查询报告信息（不含文件信息）
        Map<String, Object> generalReportMap = generalReportService.queryGeneralReportById(paramMap);
        // 判断状态
        String state = (String) generalReportMap.get("STATE");
        if (!AnalysisStateEnum.UPLOAD.getValue().equals(state)) {
            System.out.println("报告状态不是提交状态，不能发送邮件！");
            return;
        }
        // 2、循环得到每条已提交的主任务信息，得到每条的ID
        String from = (String) PropertyConfigure.getProperty("mail.username");
        // 获取主题
        subject = handelManualSendSubject(subject, step, reportDateStr);
        // 5、获取需要邮件发送的文件
        MailFile[] mailFiles = getMailFiles(reportId, step);

        // 6、发送邮件
        sendMailService.sendAttachmentMail(tos, from, subject, "", false, mailFiles, AscriptionTypeEnum.CITY_FORECAST.getValue(), reportId, null);
    }

    /**
     * 3天预报主题模板
     */
    public static final String TEMPLATE_SUBJECT_3DAY = "成都市区未来24、48、72小时空气质量预报";
    /**
     * 7天预报主题模板
     */
    public static final String TEMPLATE_SUBJECT_7DAY = "成都市区未来7天空气质量预报";

    /**
     * 处理手动发送邮件主题
     *
     * @param subject 主题
     * @param step    步长
     */
    private String handelManualSendSubject(String subject, Integer step, String currentDateStr) {
        if (step == 7) {
            // 如果是7天，则主题设置为7天的主题
            subject = OtherUtil.nullToReplace(subject, TEMPLATE_SUBJECT_7DAY);
        } else {
            // 如果没有主题，则默认设置为3天的主题
            subject = OtherUtil.nullToReplace(subject, TEMPLATE_SUBJECT_3DAY);
        }
        if (StringUtils.isNotBlank(currentDateStr)) {
            return subject + "-" + currentDateStr;
        }
        return subject;
    }

    /**
     * 3天文件名称模板
     */
    public static final String TEMPLATE_FILE_NAME_3DAY = "成都市区未来24、48、72小时空气质量预报";
    /**
     * 7天文件名称模板
     */
    public static final String TEMPLATE_FILE_NAME_7DAY = "成都市区未来7天空气质量预报";

    /**
     * 获取需要邮件发送的文件
     *
     * @param reportId 报告ID
     * @param step     步长
     * @return 需要邮件发送的文件集合
     */
    private MailFile[] getMailFiles(String reportId, Integer step) {
        String ascriptionType = AscriptionTypeEnum.CITY_FORECAST.getValue() + (3 == step ? "_3" : "");
        List<CommFile> fileList = commFileService.queryFileList(reportId, ascriptionType);

        if (fileList != null && fileList.size() > 0) {
            MailFile[] mailFiles = new MailFile[1];
            for (CommFile fileMap : fileList) {
                String fileFullName = fileMap.getFileFullName();
                String fileFullPath = commFileService.getFileFullPath(fileMap, false);
                if (step == 3 && fileFullName.contains(TEMPLATE_FILE_NAME_3DAY)) {
                    mailFiles[0] = new MailFile(fileFullName, fileFullPath);
                    return mailFiles;
                } else if (step == 7 && fileFullName.contains(TEMPLATE_FILE_NAME_7DAY)) {
                    mailFiles[0] = new MailFile(fileFullName, fileFullPath);
                    return mailFiles;
                }
            }
        }
        return null;
    }


    /**
     * 短信模板-3天预报
     */
    private static final String TEMPLATE_3DAY = "成都市区未来24、48、72小时空气质量预报\n#cityOption3Day#\n#forecastAqi#。\n重要提示：#reportTip#";
    /**
     * 短信模板-7天预报
     */
    private static final String TEMPLATE_7DAY = "成都市区未来7天空气质量预报\n#forecastAqi#。\n重要提示：#reportTip#\n成都市环境保护科学研究院\n成都平原经济区环境气象中心";

    /**
     * 根据报告ID发送短信
     *
     * @param sendTypeEnum 短信推送类型。和第三方（力鼎）约定，每增加一个，都需要和力鼎对接，第三方根据该类型将短信推送给不同的人员。
     * @param reportId     报告ID
     */
    public void sendMessageByReportId(SendTypeEnum sendTypeEnum, String reportId) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("reportId", reportId);
        // 根据ID，查询报告信息（不含文件信息）
        Map<String, Object> generalReportMap = generalReportService.queryGeneralReportById(paramMap);
        // 判断状态
        String state = (String) generalReportMap.get("STATE");
        if (!AnalysisStateEnum.UPLOAD.getValue().equals(state)) {
            System.out.println("报告状态不是提交状态，不能发送短信！");
            return;
        }

        // 1、根据每条的ID查询预报详情数据
        List<AnsFlowWqRow> aqiList = this.queryCityForecastAqiByReportId(reportId);
        if (aqiList == null || aqiList.size() == 0) {
            System.out.println("预报详情数据为空，不能发送短信！");
            return;
        }

        // 根据报告ID，解析意见
        Map<String, Object> judgeInfoMap = this.queryJudgeInfoByPkId(reportId);
        // 判断模板
        String template = sendTypeEnum.CITY_FORECAST_3DAY.equals(sendTypeEnum) ? TEMPLATE_3DAY : TEMPLATE_7DAY;
        // 步长
        int step = sendTypeEnum.CITY_FORECAST_3DAY.equals(sendTypeEnum) ? 3 : 7;
        // 2、拼接短信内容
        String messageContent = getContent(sendTypeEnum, generalReportMap, judgeInfoMap, aqiList, step, template);

        // 获取电话号码
        Map<String, Object> map = new HashMap<>();
        map.put("SEND_TYPE_ENUM", sendTypeEnum);

        String phones = this.queryUserPhone(map);

        // 发送短信
        sendMessageService.sendMessage(messageContent, sendTypeEnum, AscriptionTypeEnum.CITY_FORECAST.getValue(),
                reportId, null, phones);
    }

    public String queryUserPhone(Map<String, Object> paramMap) {
        List<Map<String, Object>> list = airForecastCityMapper.queryUserPhone(paramMap);
        // 收件人联系方式，多个联系方式通过','分隔
        StringBuilder phones = new StringBuilder();
        for (int i = 0; i < list.size(); i++) {
            Map<String, Object> map = list.get(i);
            // 最后一个联系人后不需要加','
            if (i == list.size() - 1) {
                phones.append(ParamUtils.getString(map, "tel", ""));
            } else {
                phones.append(ParamUtils.getString(map, "tel", "")).append(",");
            }
        }
        return phones.toString();
    }

    /**
     * 预报AQI模板
     */
    private static final String TEMPLATE_FORECAST_AQI = "#reportTimeZh#，#weatherConditionsTypeName#为#weatherLevel#，预计AQI为#aqi#，空气质量等级为#aqiLevel##primPollute#；\n";

    /**
     * 获取短信内容
     *
     * @param SendTypeEnum 短信推送类型。和第三方（力鼎）约定，每增加一个，都需要和力鼎对接，第三方根据该类型将短信推送给不同的人员。
     * @param reportMap    报告信息
     * @param aqiList      AQI预报信息
     * @param step         步长
     */
    private String getContent(SendTypeEnum SendTypeEnum, Map<String, Object> reportMap,
                              Map<String, Object> judgeInfoMap, List<AnsFlowWqRow> aqiList, Integer step, String template) {
        // 重要提示
        String reportTip = getReportTip(SendTypeEnum, reportMap);
        // 未来3天城市预报解析意见
        String cityOption3Day = getCityOption3Day(judgeInfoMap);
        // 扩散条件类型
        String weatherConditionsTypeName = MapUtils.getInteger(judgeInfoMap, "WEATHER_CONDITIONS_TYPE") == 1 ? "臭氧污染气象条件" : "气象扩散条件";
        // 预报AQI
        String forecastAqi = "";
        if (aqiList != null && aqiList.size() > 0) {
            StringBuilder forecastAqiBuilder = new StringBuilder();
            for (int i = 0, size = aqiList.size(); i < size; i++) {
                if (step > 0 && i >= step) {
                    break;
                }
                AnsFlowWqRow aqiMap = aqiList.get(i);
                // 时间
                String reportTimeZh = DateUtil.format(aqiMap.getResultTime(), "MM月dd日");
                // 扩散条件
                String weatherLevel = OtherUtil.nullToReplace(aqiMap.getWeatherLevel(), "--");
                // AQI范围
                String aqi = OtherUtil.nullToReplace(aqiMap.getAqi(), "--");
                // AQI等级
                String aqiLevel = OtherUtil.nullToReplace(aqiMap.getAqiLevel(), "--");
                // 首要污染物
                String primPollute = OtherUtil.nullToReplace(aqiMap.getPrimPollute(), "");
                if (!"".equals(primPollute)) {
                    primPollute = "，首要污染物为" + primPollute;
                }
                // 替换预报AQI模板，并将替换的结果追加到Builder
                forecastAqiBuilder.append(TEMPLATE_FORECAST_AQI.replaceAll("#weatherConditionsTypeName#",weatherConditionsTypeName)
                        .replaceAll("#reportTimeZh#", reportTimeZh)
                        .replaceAll("#weatherLevel#", weatherLevel).replaceAll("#aqi#", aqi)
                        .replaceAll("#aqiLevel#", aqiLevel).replaceAll("#primPollute#", primPollute));
            }
            // 将最后一个分号替换为逗号
            // forecastAqi = forecastAqiBuilder.deleteCharAt(forecastAqiBuilder.length() 1).toString();
            forecastAqi = forecastAqiBuilder.delete(forecastAqiBuilder.lastIndexOf("；"), forecastAqiBuilder.length())
                    .toString();
        }
        // 替换模板，获得短信发送文本内容
        if ("".equals(cityOption3Day)) {
            if ("".equals(reportTip)) {
                return template.replaceAll("\n#cityOption3Day#", "").replaceAll("#reportTip#", reportTip)
                        .replaceAll("#forecastAqi#", forecastAqi).replaceAll("\n重要提示：", "");
            }
            return template.replaceAll("\n#cityOption3Day#", "").replaceAll("#reportTip#", reportTip)
                    .replaceAll("#forecastAqi#", forecastAqi);
        } else {
            if ("".equals(reportTip)) {
                return template.replaceAll("#cityOption3Day#", cityOption3Day).replaceAll("#reportTip#", reportTip)
                        .replaceAll("#forecastAqi#", forecastAqi).replaceAll("\n重要提示：", "");
            }
            return template.replaceAll("#cityOption3Day#", cityOption3Day).replaceAll("#reportTip#", reportTip)
                    .replaceAll("#forecastAqi#", forecastAqi);
        }
    }

    /**
     * 获取重要提示
     *
     * @param SendTypeEnum 短信推送类型。和第三方（力鼎）约定，每增加一个，都需要和力鼎对接，第三方根据该类型将短信推送给不同的人员。
     * @param reportMap    报告信息
     * @return 重要提示
     */
    private String getReportTip(SendTypeEnum SendTypeEnum, Map<String, Object> reportMap) {
        String reportTip;
        if (SendTypeEnum.equals(SendTypeEnum.CITY_FORECAST_7DAY)) {
            reportTip = OtherUtil.nullToReplace((String) reportMap.get("FIELD1"), "");
        } else {
            reportTip = OtherUtil.nullToReplace((String) reportMap.get("REPORT_TIP"), "");
        }
        if (!"".equals(reportTip) && !reportTip.endsWith("。")) {
            reportTip += "。";
        }
        return reportTip;
    }

    /**
     * 获取重要提示
     *
     * @return 重要提示
     */
    private String getCityOption3Day(Map<String, Object> judgeInfoMap) {
        String cityOption3Day = OtherUtil.nullToReplace((String) judgeInfoMap.get("CITY_OPINION_3DAY"), "");
        if (!"".equals(cityOption3Day) && !cityOption3Day.endsWith("。")) {
            cityOption3Day += "。";
        }
        return cityOption3Day;
    }

    /**
     * 撤回记录
     *
     * @param paramMap
     * @return
     */
    public boolean revocationReportById(Map<String, Object> paramMap) {
        Map<String, Object> generalReportMap = generalReportService.queryGeneralReportById(paramMap);
        Date reportTime = null;
        if (generalReportMap != null) {
            reportTime = (Date) generalReportMap.get("REPORT_TIME");
        }
        boolean flag = false;
        if (reportTime != null) {
            AnsFlowInfo ansFlowInfo = new AnsFlowInfo();
            ansFlowInfo.setFlowState(0);
            ansFlowInfo.setIsSend(0);
            LambdaQueryWrapper<AnsFlowInfo> flowInfoWrapper = Wrappers.lambdaQuery();
            flowInfoWrapper.eq(AnsFlowInfo::getReportTime, reportTime);
            airForecastCityMapper.update(ansFlowInfo, flowInfoWrapper);
            flag = generalReportService.update(Wrappers.lambdaUpdate(GeneralReport.class)
                    .set(GeneralReport::getState, "TEMP")
                    .set(GeneralReport::getIsMain, 0)
                    .eq(GeneralReport::getReportTime, reportTime)
                    .eq(GeneralReport::getAscriptionType, "CITY_FORECAST"));
        }
        return flag;
    }
    /**
     * 推送成功后 - 修改推送状态
     */
    public void updateIsSend(String infoId){
        AnsFlowInfo ansFlowInfo = new AnsFlowInfo();
        ansFlowInfo.setInfoId(infoId);
        ansFlowInfo.setIsSend(1);
        airForecastCityMapper.updateById(ansFlowInfo);
    }

    /**
     * 推送省站
     *
     * @param paramMap
     * @return
     */
    public String pushData(Map<String, String> paramMap) {
        String infoId = MapUtils.getString(paramMap,"infoId");
        paramMap.remove("infoId");
        String url = "http://www.scnewair.cn:6114/forcast/addForcastUser";
        String result = HttpClientUtil.sendHttpPost(url, paramMap);
        Map<String, Object> resultMap = JsonUtil.toMap(result);
        if (Integer.parseInt(resultMap.get("code").toString()) == 0){
            updateIsSend(infoId);
            return infoId;
        }
        return null;
    }
}

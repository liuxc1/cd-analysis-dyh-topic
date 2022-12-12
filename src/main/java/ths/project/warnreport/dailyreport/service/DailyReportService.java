package ths.project.warnreport.dailyreport.service;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.lang.StringUtils;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import ths.jdp.core.model.LoginUserModel;
import ths.jdp.core.web.RequestHelper;
import ths.jdp.eform.service.components.word.DocumentPage;
import ths.project.analysis.forecast.report.entity.GeneralReport;
import ths.project.analysis.forecast.report.enums.AnalysisStateEnum;
import ths.project.analysis.forecast.report.mapper.GeneralReportMapper;
import ths.project.analysis.forecast.report.service.GeneralReportService;
import ths.project.common.uid.SnowflakeIdGenerator;
import ths.project.common.util.DateUtil;
import ths.project.common.util.ExcelUtil;
import ths.project.common.util.UUIDUtil;
import ths.project.system.file.entity.CommFile;
import ths.project.system.file.service.CommFileService;
import ths.project.warnreport.dailyreport.entity.EmergencyControl;
import ths.project.warnreport.dailyreport.mapper.EmergencyControlMapper;
import ths.project.warnreport.dailyreport.mapper.ManagementMapper;

import java.io.OutputStream;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.*;

/**
 * 夏季臭氧报警日报Service
 */
@Service
public class DailyReportService {

    private final EmergencyControlMapper emergencyControlMapper;
    private final ManagementMapper managementMapper;
    private final CommFileService commFileService;
    private final GeneralReportService generalReportService;
    private final GeneralReportMapper generalReportMapper;
    private final SnowflakeIdGenerator idGenerator;

    @Autowired
    public DailyReportService(EmergencyControlMapper emergencyControlMapper, ManagementMapper managementMapper, CommFileService commFileService, GeneralReportService generalReportService, SnowflakeIdGenerator idGenerator, GeneralReportMapper generalReportMapper) {
        this.emergencyControlMapper = emergencyControlMapper;
        this.managementMapper = managementMapper;
        this.commFileService = commFileService;
        this.generalReportService = generalReportService;
        this.idGenerator = idGenerator;
        this.generalReportMapper = generalReportMapper;
    }

    /**
     * 查询臭氧重污染天气应急管控工作日报表
     *
     * @param dateTime
     * @return
     * @throws InvocationTargetException
     * @throws IllegalAccessException
     * @throws NoSuchMethodException
     */
    public List<LinkedHashMap<String, Object>> dailyReportEmergencyControlList(String dateTime) throws InvocationTargetException, IllegalAccessException, NoSuchMethodException {
        String[] col = {"经信部门", "公安部门", "规划和自然资源部门", "生态环境部门", "住建部门", "城管部门", "交通运输部门", "水务部门", "公园城市部门", "农业农村部门", "市场监管部门", "气象部门", "教育部门", "卫健部门"};
        String[] methodArr = {"getPeopleNumber", "getSiteInspection", "getDealIllegalConstructionSite", "getDealIllegalConstructionSiteVocs", "getDealIllegalConstructionSiteVocsArea"
                , "getDealIllegalConstructionSiteEarthwork", "getDealIllegalConstructionSiteEarthworkArea", "getDealIllegalConstructionNonRoadMobileMachinery",
                "getDealIllegalConstructionSiteVocsTimes", "getIndustrialInspection", "getIndustrialIllegal", "getInspectGarage", "getIllegalSprayingInspectGarage",
                "getInspectConcreteMixingStation", "getIllegalConcreteMixingStation", "getInspectAsphaltMixingStation", "getIllegalAsphaltMixingStation", "getDealGasStation",
                "getIllegalGasStation", "getDealOilDepot", "getIllegalOilDepot", "getDealIllegalSlagTruck", "getDealIllegalCementTanker", "getDealIllegalAsphaltTanker",
                "getBusFrequency", "getBusNum", "getSubwayPassengerVolume", "getSubwayRunningTrain", "getTotalVehicleFlow", "getBanOutdoorBarbecueStalls",
                "getDealWithOpenBurning", "getIllegalPruningPesticideSprayingOperations", "getRoadWateringDustRemoval"};
        //,"getSupplementaryMatters"
        List<EmergencyControl> emergencyControlList = emergencyControlMapper.selectAllBydata();
        List<LinkedHashMap<String, Object>> list = new ArrayList<LinkedHashMap<String, Object>>();
        String other = "";
        for (int i = 0; i < methodArr.length; i++) {
            LinkedHashMap<String, Object> map = new LinkedHashMap<String, Object>();
            Method method = EmergencyControl.class.getMethod(methodArr[i]);
            /* if(i < methodArr.length -1){*/
            for (int j = 0; j < emergencyControlList.size() - 3; j++) {
                Object invoke = method.invoke(emergencyControlList.get(j));
                map.put(col[j], invoke);
            }
            /*}*/
            //后三个部门，只有备注信息
            list.add(map);
        }
        LinkedHashMap<String, Object> map = new LinkedHashMap<String, Object>();
        Method method = EmergencyControl.class.getMethod("getSupplementaryMatters");
        for (int k = emergencyControlList.size() - 3; k < emergencyControlList.size(); k++) {
            Object invoke = method.invoke(emergencyControlList.get(k));
            if ("气象部门".equals(col[k]) || "教育部门".equals(col[k]) || "卫健部门".equals(col[k])) {
                if (StringUtils.isNotBlank((String) invoke)) {
                    other = col[k] + ":" + invoke + ".";
                }
            }
        }
        map.put("补充事项", other);
        list.add(map);
        return list;
    }

    /**
     * 查询一天分别按照行政和类型分别统计
     *
     * @param dateTime
     * @return
     */
    public List<LinkedHashMap<String, Object>> exportStDailyReportExcel(String dateTime) {
        if (StringUtils.isBlank(dateTime)) {
            dateTime = DateUtil.formatDate(DateUtil.addDay(new Date(), -1));
        }
        List<LinkedHashMap<String, Object>> DataListForRegion = managementMapper.getDataListForRegion(dateTime);
        List<LinkedHashMap<String, Object>> DataListForDataType = managementMapper.getDataListForDataType(dateTime);
        DataListForRegion.addAll(DataListForDataType);
        return DataListForRegion;
    }

    /**
     * 查询监测数据和预报数据
     *
     * @param param
     * @return
     */
    public Map<String, Object> getAirDataAndForecast(@RequestParam Map<String, Object> param) {
        Map<String, Object> result = new HashMap<String, Object>();
        List<Map<String, Object>> airDataList = managementMapper.getAirData(param);
        List<Map<String, Object>> forecastList = managementMapper.getForecast(param);
        result.put("airDataList", airDataList);
        result.put("forecastList", forecastList);
        return result;
    }

    /**
     * 保存报告数据
     *
     * @param paramMap
     */
    public void addGeneralReport(Map<String, Object> paramMap) {
        GeneralReport generalReport = new GeneralReport();
        generalReport.setReportId(paramMap.get("reportId").toString());
        generalReport.setReportTime(DateUtil.parseDate(paramMap.get("endDateTime").toString()));
        String reportName = DateUtil.format(DateUtil.parseDate((String) paramMap.get("endDateTime")), "yyyyMMdd") + "应急管控工作日报表";
        generalReport.setReportName(reportName);
        generalReport.setIsMain(0);
        generalReport.setReportRate("DAY");
        generalReport.setState("UPLOAD");
        generalReport.setAscriptionType("WARN_DAILY_REPORT");
        generalReport.setReportTip(paramMap.get("hint").toString());
        generalReportService.saveReport(generalReport);
    }

    /**
     * 保存日报和数据
     *
     * @param param
     * @return
     */
    @Transactional
    public Map<String, Object> saveWarnDailyReport(Map<String, Object> param) {
        String ascriptionId = UUIDUtil.getUniqueId();
        String templatePath = RequestHelper.getRequest().getServletContext().getRealPath("/assets/template/warnDaliyReport.docx");
        String ascriptionType = "WARN_DAILY_REPORT";
        param.put("reportId", ascriptionId);
        addGeneralReport(param);
        DocumentPage page = new DocumentPage();
        param.putAll(dailyReportEmergencyControlMap(param));
        page.setParamMap(param);
        CommFile commFile = commFileService.saveGenerateWordFile(page, null, null, templatePath,
                param.get("endDateTime").toString() + "应急管控工作日报表", "WARN_DAILY_REPORT");
        commFileService.deleteFileByAscription(ascriptionId, ascriptionType);
        commFileService.saveFileInfo(commFile, ascriptionId, ascriptionType, (String) param.get("createUser"), AnalysisStateEnum.GENERATE.getValue());
        return null;
    }


    /**
     * 拼接表格数据返回map
     *
     * @return
     */
    public Map<String, Object> dailyReportEmergencyControlMap(Map<String, Object> param) {
        String[] col = {"经信部门", "公安部门", "规划和自然资源部门", "生态环境部门", "住建部门", "城管部门", "交通运输部门", "水务部门", "公园城市部门", "农业农村部门", "市场监管部门", "气象部门", "教育部门", "卫健部门"};
        String[] col2 = {"JX", "GA", "GH", "ST", "ZJ", "CG", "JT", "SW", "GY", "NY", "SC"};
        Map<String, Object> map = new HashMap<String, Object>();
        List<LinkedHashMap<String, Object>> emergencyControlList = emergencyControlMapper.selectAllBydataMap(param);
        //将部门数据，转成map数据
        for (int i = 0; i < emergencyControlList.size() - 3; i++) {
            LinkedHashMap<String, Object> a = emergencyControlList.get(i);
            Set<Map.Entry<String, Object>> entries = a.entrySet();
            int k = 0;
            for (Map.Entry<String, Object> entry : a.entrySet()) {
                map.put(col2[i] + k, entry.getValue() == null ? 0 : entry.getValue());
                k++;
            }
        }
        //拼接备注信息
        String other = "";
        for (int i = emergencyControlList.size() - 3; i < emergencyControlList.size(); i++) {
            LinkedHashMap<String, Object> a = emergencyControlList.get(i);
            String supplementaryMatters = (String) a.get("SUPPLEMENTARY_MATTERS");
            if (StringUtils.isNotBlank(supplementaryMatters)) {
                other += col[i] + ":" + supplementaryMatters;
            }
        }
        map.put("BCSX", other);
        return map;
    }

    /**
     * 根据时间和类型查询当天的报告情况
     *
     * @param param
     * @return
     */
    public List<Map<String, Object>> queryDayRecordListByReportTime(Map<String, Object> param) {
        return generalReportService.queryDayRecordListByReportTime(param);
    }

    /**
     * 根据ASCRIPTION_ID查询文件信息
     *
     * @param param
     * @return
     */
    public Map<String, Object> getFile(Map<String, Object> param) {
        param.put("fileSources", "GENERATE");
        param.put("PKID", param.get("reportId").toString());
        return generalReportService.queryDayGeneralReportByIdAndFileSource(param);
    }

    /**
     * 保存日报和数据
     *
     * @param dateTime
     * @return
     */
    @Transactional
    public String saveDailyReportExcel(String dateTime, LoginUserModel loginUser) {
        String reportName = "重污染天气应急管控工作日报表-";
        if (StringUtils.isNotBlank(dateTime)) {
            reportName += dateTime.replaceAll("-", "");
        } else {
            dateTime = DateUtil.formatDate(DateUtil.addDay(new Date(), -1));
            reportName += DateUtil.formatDate(DateUtil.addDay(new Date(), -1)).replaceAll("-", "");
        }
        GeneralReport generalReport = generalReportMapper.selectOne(Wrappers.lambdaQuery(GeneralReport.class)
                .eq(GeneralReport::getAscriptionType, "WARN_DAILY_REPORT")
                .eq(GeneralReport::getReportTime, dateTime));
        if (generalReport == null) {
            List<LinkedHashMap<String, Object>> dataList = managementMapper.getDataListForRegion(dateTime);
            List<LinkedHashMap<String, Object>> dataListForDataType = managementMapper.getDataListForDataType(dateTime);
            if ((dataList != null && dataList.size() > 0) || (dataListForDataType != null && dataListForDataType.size() > 0)) {
                dataList.addAll(dataListForDataType);
                // 获取文件MultipartFile
                MultipartFile multipartFile = ExcelUtil.getMultipartFileByTemp07("STHJJ.xlsx", reportName + ".xlsx", 0, 2, 0, dataList, null);
                //保存报告和文件
                generalReport = new GeneralReport();
                generalReport.setReportId(idGenerator.getUniqueId());
                generalReport.setAscriptionType("WARN_DAILY_REPORT");
                generalReport.setReportName(reportName);
                generalReport.setReportRate("DAY");
                generalReport.setReportTime(DateUtil.parseDate(dateTime));
                MultipartFile[] multipartFiles = {multipartFile};
                generalReportService.saveReport(generalReport, multipartFiles, null);
                return generalReport.getReportId();
            } else {
                return dateTime + "数据未同步";
            }
        } else {
            return generalReport.getReportId() + "已存在";
        }
    }
}

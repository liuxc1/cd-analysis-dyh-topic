package ths.project.analysis.forecast.airforecastmonth.service;

import com.alibaba.fastjson.JSON;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import ths.jdp.core.model.LoginUserModel;
import ths.jdp.core.service.base.BaseService;
import ths.jdp.core.web.LoginCache;
import ths.project.analysis.forecast.airforecastmonth.entity.TAnsMonthForecast;
import ths.project.analysis.forecast.airforecastmonth.entity.EnvAirdataRegionDay;
import ths.project.analysis.forecast.airforecastmonth.mapper.MonthTrendMapper;
import ths.project.analysis.forecast.report.enums.AscriptionTypeEnum;
import ths.project.analysis.forecast.report.service.GeneralReportService;
import ths.project.common.util.JsonUtil;
import ths.project.common.util.UUIDUtil;

import java.text.ParseException;
import java.util.*;
import java.text.SimpleDateFormat;

@Service
public class MonthTrendService extends BaseService {

    @Autowired
    private GeneralReportService generalReportService;
    @Autowired
    private MonthTrendMapper monthTrendMapper;

    @Autowired
    private AirdataRegionDayService EnvAirdataRegionDayService;

    private final String sqlPackage = "ths.project.analysis.common.mapper.GeneralReportMapper";

    /**
     * 根据报告ID，查询趋势预报信息
     *
     * @param paramMap 参数
     * @return 城市预报信息
     */
    public Map<String, Object> queryMonthForecastByReportId(Map<String, Object> paramMap) {
        paramMap.put("fileSources", "UPLOAD");
        Map<String, Object> cityForecastMap = generalReportService.queryDayGeneralReportByIdAndFileSource(paramMap);
        // 2、查询预报AQI信息
        List<Map<String, Object>> cityForecastAqiList = monthTrendMapper.getForecastValues(paramMap);
        cityForecastMap.put("CITY_FORECAST_AQI_LIST", cityForecastAqiList);

        return cityForecastMap;
    }

    /**
     * 根据报告ID，查询趋势预报信息
     *
     * @param reportId 报告ID
     * @return 趋势预报信息
     */
    public List<Map<String, Object>> queryMonthForecastByReportId(String reportId) {
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("reportId", reportId);
        return monthTrendMapper.queryMonthForecastByReportId(paramMap);
    }

    /**
     * 查询aqi、首要污染物等具体信息
     *
     * @param paMap
     * @return
     */
    public List<Map<String, Object>> getForecastValues(Map<String, Object> paMap) {
        return monthTrendMapper.getForecastValues(paMap);
    }

    /**
     * 保存趋势预报信息
     *
     * @param multipartFiles
     * @param paramMap1
     */
    @SuppressWarnings("unchecked")
    @Transactional(rollbackFor = RuntimeException.class)
    public void saveMonthTrendInfo(MultipartFile[] multipartFiles, Map<String, Object> paramMap1) throws ParseException {
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("reportId", paramMap1.get("MONTHTREND_ID").toString());
        paramMap.put("ascriptionType", AscriptionTypeEnum.MONTH_FORECAST.getValue());
        paramMap.put("reportBatch", "");
        paramMap.put("reportName", paramMap1.get("MONTHTREND_NAME").toString());
        paramMap.put("reportRate", "MONTH");
        paramMap.put("reportType", "");
        paramMap.put("reportTip", paramMap1.get("HINT").toString());
        paramMap.put("remark", "");
        paramMap.put("field1", "");
        paramMap.put("field2", "");
        paramMap.put("field3", "");
        paramMap.put("field4", "");
        paramMap.put("reportInscribe", "");
        paramMap.put("state", paramMap1.get("STATE").toString());
        paramMap.put("deleteFileIds", paramMap1.get("deleteFileIds").toString());
        // 根据ID判断是否是新增
        boolean isAdd = paramMap.get("reportId") == null || "".equals(paramMap.get("reportId"));
        String consultId;
        if (isAdd) {
            paramMap.put("reportTime", paramMap1.get("FORECAST_TIME").toString());
            Calendar cal = Calendar.getInstance();
            int month = cal.get(Calendar.MONTH) + 1;
            paramMap.put("reportFrequency", month + "月");
            consultId = generalReportService.saveReport(paramMap, multipartFiles, "");
        } else {
            consultId = paramMap.get("reportId").toString();
            generalReportService.saveReport(paramMap, multipartFiles, "");
        }

        //处理从表
        Map<String, Object> tableListMap = JsonUtil.toMap((String) paramMap1.get("TableList"));
        List<Map<String, Object>> jsonArray = JsonUtil.toList(JsonUtil.toJson(tableListMap.get("list")));

        if (jsonArray.size() > 0) {
            deleteForecastFlowValues(paramMap);//删除
            LoginUserModel loginUser = LoginCache.getLoginUser();
            String createDept = loginUser.getDeptName();
            String createUser = loginUser.getUserName();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            for (Map<String, Object> item : jsonArray) {
                TAnsMonthForecast information = JSON.parseObject(JSON.toJSONString(item), TAnsMonthForecast.class);
                information.setForecastId(UUIDUtil.getUniqueId());
                information.setAscriptionId(consultId);
                information.setAscriptionType(AscriptionTypeEnum.MONTH_FORECAST.getValue());
                information.setCityCode(loginUser.getRegionCode());
                information.setCityName(loginUser.getRegionName());
                information.setModelTime(sdf.parse(paramMap1.get("FORECAST_TIME").toString()));
                information.setCreateDept(createDept);
                information.setCreateUser(createUser);
                information.setCreateTime(sdf.parse(paramMap1.get("FORECAST_TIME").toString()));
                information.setEditTime(sdf.parse(paramMap1.get("FORECAST_TIME").toString()));
                information.setEditUser(createUser);
                monthTrendMapper.insert(information);
            }
        }
    }

    /**
     * @return
     * @Title: deleteForecastFlowValues
     * @Description: 删除AQI、首要污染物等具体信息
     */
    @Transactional
    public void deleteForecastFlowValues(Map<String, Object> paramMap) {
        monthTrendMapper.deleteForecastValues(paramMap);
    }

    /**
     * 根据报告ID删除报告
     *
     * @param paramMap 参数
     * @return 删除的条数
     */
    @Transactional(rollbackFor = Exception.class)
    public Integer deleteForecastById(Map<String, Object> paramMap) {
        deleteForecastFlowValues(paramMap);
        int result = generalReportService.deleteReportById(paramMap);
        return result;
    }

    /**
     * 查询excel模板导入的数据
     *
     * @param paramMap
     */
    public List<Map<String, Object>> queryExcel(Map<String, Object> paramMap) {
        paramMap.put("LOGINNAME", LoginCache.getLoginUser().getLoginName());
        return monthTrendMapper.queryExcel(paramMap);
    }

    /**
     * @return
     * @Title: deleteForecastTempById
     * @Description: 删除导入Excel的临时表数据
     */
    public int deleteForecastTempById(Map<String, Object> paramMap) {
        return monthTrendMapper.deleteForecastTempById(paramMap);
    }

    /**
     * 根据报告时间查询频率为月的记录列表
     *
     * @param paramMap 参数
     * @return 频率为月的记录列表
     */
    public Map<String, Object> queryMonthRecordListByReportTime(Map<String, Object> paramMap) throws ParseException {

        Map<String, Object> result = new HashMap<String, Object>();

        //获取上一个月日期
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM");
        Date date = df.parse((String) paramMap.get("reportTime"));
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        cal.add(Calendar.MONTH, -1);

        //2.查询成都市上一个月空气质量逐日情况
        List<EnvAirdataRegionDay> airdataRegionDayList = EnvAirdataRegionDayService.queryMonthById(df.format(cal.getTime()), "510100000000");

        //处理数据
        List<Map<String, Object>> aqiMonthList = new ArrayList<Map<String, Object>>();

        for (int i = 0; i < airdataRegionDayList.size(); i++) {
            Map<String, Object> map = new HashMap<String, Object>();
            cal.setTime(airdataRegionDayList.get(i).getMonitorTime());
            map.put("month", cal.get(Calendar.MONTH) + 1);
            map.put("day", cal.get(Calendar.DAY_OF_MONTH));
            //获取星期几   星期天~星期一 分别对应  0~6
            map.put("weekday", cal.get(Calendar.DAY_OF_WEEK) - 1);
            map.put("primaryPollutant", airdataRegionDayList.get(i).getPrimaryPollutant());
            map.put("codeAqiLevel", airdataRegionDayList.get(i).getCodeAqiLevel());
            map.put("aqi", airdataRegionDayList.get(i).getAqi());
            aqiMonthList.add(map);
        }

        result.put("aqiMonthList", aqiMonthList);
        result.put("date", cal.get(Calendar.YEAR) + "年" + (cal.get(Calendar.MONTH) + 1) + "月");
        return result;
    }
    /**
     * 导出
     *
     * @param paramMap
     */
    public List<LinkedHashMap<String,Object>> exportExcel(Map<String, Object> paramMap) {
        return monthTrendMapper.getForecastValuesExecl(paramMap);
    }
}

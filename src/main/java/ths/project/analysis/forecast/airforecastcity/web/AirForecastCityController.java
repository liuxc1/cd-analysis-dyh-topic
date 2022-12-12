package ths.project.analysis.forecast.airforecastcity.web;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import ths.jdp.core.web.LoginCache;
import ths.jdp.core.web.base.BaseController;
import ths.jdp.util.DateUtils;
import ths.project.analysis.forecast.airforecastcity.service.AirForecastCityService;
import ths.project.analysis.forecast.report.enums.AnalysisStateEnum;
import ths.project.common.data.DataResult;
import ths.project.common.uid.SnowflakeIdGenerator;
import ths.project.common.util.OtherUtil;
import ths.project.common.util.ParamUtils;
import ths.project.common.vo.ResponseVo;

import java.io.IOException;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * @author lx
 */
@Controller
@RequestMapping("/analysis/forecastflow/forecastflowcity")
public class AirForecastCityController extends BaseController {

    @Autowired
    private AirForecastCityService airForecastCityService;
    /**
     * 雪花ID
     */
    @Autowired
    private SnowflakeIdGenerator idGenerator;

    /**
     * 跳转到列表页面
     *
     * @return
     */
    @RequestMapping("/cityForecastList")
    public String cityForecastList(Model model, String showFlag) {
        model.addAttribute("showFlag", showFlag);
        return "analysis/forecast/airforecastcity/cityForecastList";
    }

    /**
     * 根据月份，查询频率为日的时间轴列表
     *
     * @param paramMap 参数
     * @return 频率为日的时间轴列表
     */
    @RequestMapping("/queryDayTimeAxisListByMonth")
    @ResponseBody
    public ResponseVo queryDayTimeAxisListByMonth(@RequestParam Map<String, Object> paramMap) {
        ResponseVo responseVo = new ResponseVo();
        // 验证
        String ascriptionType = (String) paramMap.get("ascriptionType");
        if (StringUtils.isNotBlank(ascriptionType)) {
            // 时间
            // 文本
            // 是否有数据
            // 是否有重要提示
            List<Map<String, Object>> resultList = airForecastCityService.queryDayTimeAxisListByMonth(paramMap);
            if (resultList != null && resultList.size() > 0) {
                responseVo.success(resultList);
            } else {
                responseVo.failure("暂无数据！");
            }
        } else {
            responseVo.failure("请求参数错误，可能值为空或包含非法字符！");
        }
        return responseVo;
    }

    /**
     * 根据报告ID，查询城市预报信息
     *
     * @param paramMap 参数
     * @return 城市预报信息
     */
    @RequestMapping("/queryCityForecastByReportId")
    @ResponseBody
    public ResponseVo queryCityForecastByReportId(@RequestParam Map<String, Object> paramMap) {
        ResponseVo responseVo = new ResponseVo();
        // 报告ID
        String reportId = (String) paramMap.get("reportId");
        // 验证
        if (StringUtils.isNotBlank(reportId)) {
            // 根据报告时间查询频率为日的记录列表
            Map<String, Object> resultMap = airForecastCityService.queryCityForecastByReportId(paramMap);
            if (resultMap != null && resultMap.size() > 0) {
                responseVo.success(resultMap);
            } else {
                responseVo.failure("暂无数据！");
            }
        } else {
            responseVo.failure("请求参数错误，可能值为空或包含非法字符！");
        }
        return responseVo;
    }

    /**
     * 跳转到城市预报显示页面
     *
     * @return 列表页面
     */
    @RequestMapping("/cityForecastView")
    public String cityForecastView(Model model, @RequestParam Map<String, Object> paramMap) {
        model.addAllAttributes(paramMap);
        return "analysis/forecast/airforecastcity/cityForecastView";
    }

    /**
     * @return String
     * @Title: cityForecastIndex
     * @Description: 城市预报编辑、查看页面
     */
    @RequestMapping("/cityForecastIndex")
    public String cityForecastIndex(@RequestParam Map<String, Object> paramMap, Model model, String isShowReturn) {
        if (paramMap.get("datetime") == null || StringUtils.isBlank(paramMap.get("datetime").toString())) {
            Calendar calendar = Calendar.getInstance();
            paramMap.put("datetime", DateUtils.convertDate2String(calendar.getTime(), "yyyy-MM-dd"));
            model.addAttribute("datetime2", DateUtils.convertDate2String(calendar.getTime(), "yyyyMMdd"));
        }
        Map<String, Object> forecastFlowInfo = airForecastCityService.getForecastFlowInfo(paramMap);
        // 获取传入日期的数据
        if (ParamUtils.getString(paramMap, "isRead") != null) {
            model.addAttribute("isRead", ParamUtils.getString(paramMap, "isRead"));
        } else {
            if (ParamUtils.getString(forecastFlowInfo, "FLOW_STATE") != null) {
                model.addAttribute("isRead", ParamUtils.getString(forecastFlowInfo, "FLOW_STATE"));
            } else {
                model.addAttribute("isRead", 0);
            }
        }
        // isRead判断是查看还是编辑
        if (ParamUtils.getString(forecastFlowInfo, "INFO_ID") != null) {
            model.addAttribute("INFO_ID", ParamUtils.getString(forecastFlowInfo, "INFO_ID"));
        } else {
            model.addAttribute("INFO_ID", UUID.randomUUID().toString());
        }
        // 没有当前日期记录时传UUID，存在时传已存在的PKID
        if (ParamUtils.getString(forecastFlowInfo, "CREATE_TIME") != null) {
            model.addAttribute("datetime2", ParamUtils.getString(forecastFlowInfo, "CREATE_TIME").toString().replaceAll("-", ""));
        }
        String reportId = String.valueOf(paramMap.get("reportId"));
        if (StringUtils.isBlank(reportId) || "null".equals(reportId)) {
            paramMap.put("isAdd", 1);
            paramMap.put("reportId", idGenerator.getUniqueId());
        } else {
            paramMap.put("isAdd", 0);
        }
        paramMap.put("isShowReturn", isShowReturn);
        model.addAllAttributes(paramMap);
        return "/analysis/forecast/airforecastcity/cityForecastIndex";
    }

    /**
     * @return String
     * @Title: getCityForecastInfo
     * @Description: 获取AQI、首要污染物等具体信息
     */
    @RequestMapping("/getCityForecastInfo")
    @ResponseBody
    public Map<String, Object> getCityForecastInfo(@RequestParam Map<String, Object> paramMap) {
        Map<String, Object> rMap = new HashMap<String, Object>();
        // 获取传入ID的数据
        Map<String, Object> forecastFlowInfo = airForecastCityService.getForecastFlowInfo(paramMap);
        if (forecastFlowInfo.size() > 0) {
            forecastFlowInfo.put("CITY_OPINION_3DAY", MapUtils.getString(forecastFlowInfo, "cityOpinionDay3"));
            forecastFlowInfo.put("COUNTRY_OPINION_3DAY", MapUtils.getString(forecastFlowInfo, "countryOpinionDay3"));
            forecastFlowInfo.put("IMPORTANT_HINTS_SEVEN", MapUtils.getString(forecastFlowInfo, "importantHintsDay7"));
            paramMap.put("datetime", forecastFlowInfo.get("REPORT_TIME"));
        } else {
            // 查询最新已经发布一次预报记录
            Map<String, Object> newForecastFlowInfo = airForecastCityService.getNewForecastFlowInfo();
            paramMap.put("datetime", paramMap.get("newdatetime"));
            forecastFlowInfo.put("REPORT_TIME", paramMap.get("newdatetime"));
            if (newForecastFlowInfo.size() > 0) {
                paramMap.put("reportId", newForecastFlowInfo.get("INFO_ID"));
                String newDateTime = paramMap.get("newdatetime").toString();
                // 如果是同一天
                if (newDateTime.equals(newForecastFlowInfo.get("REPORT_TIME").toString())) {
                    forecastFlowInfo.put("CITY_OPINION_3DAY", OtherUtil.mapValueNullToReplace(newForecastFlowInfo, "CITY_OPINION_3DAY", ""));
                    forecastFlowInfo.put("COUNTRY_OPINION_3DAY", OtherUtil.mapValueNullToReplace(newForecastFlowInfo, "COUNTRY_OPINION_3DAY", ""));
                    forecastFlowInfo.put("CITY_OPINION", OtherUtil.mapValueNullToReplace(newForecastFlowInfo, "CITY_OPINION", ""));
                    forecastFlowInfo.put("COUNTRY_OPINION", OtherUtil.mapValueNullToReplace(newForecastFlowInfo, "COUNTRY_OPINION", ""));
                    forecastFlowInfo.put("IMPORTANT_HINTS", OtherUtil.mapValueNullToReplace(newForecastFlowInfo, "IMPORTANT_HINTS", ""));
                    forecastFlowInfo.put("IMPORTANT_HINTS_SEVEN", OtherUtil.mapValueNullToReplace(newForecastFlowInfo, "IMPORTANT_HINTS_7DAY", ""));
                    forecastFlowInfo.put("INSCRIBE", OtherUtil.mapValueNullToReplace(newForecastFlowInfo, "INSCRIBE", ""));
                    forecastFlowInfo.put("INFO_ID", OtherUtil.mapValueNullToReplace(newForecastFlowInfo, "INFO_ID", ""));
                } else {
                    forecastFlowInfo.put("CITY_OPINION_3DAY", OtherUtil.mapValueNullToReplace(newForecastFlowInfo, "CITY_OPINION_3DAY", ""));
                    forecastFlowInfo.put("COUNTRY_OPINION_3DAY", "");
                    forecastFlowInfo.put("CITY_OPINION", "");
                    forecastFlowInfo.put("COUNTRY_OPINION", "");
                    forecastFlowInfo.put("IMPORTANT_HINTS", "");
                    forecastFlowInfo.put("IMPORTANT_HINTS_SEVEN", "");
                    forecastFlowInfo.put("INSCRIBE", "");
                }
            } else {
                forecastFlowInfo.put("CITY_OPINION_3DAY", "");
                forecastFlowInfo.put("COUNTRY_OPINION_3DAY", "");
                forecastFlowInfo.put("CITY_OPINION", "");
                forecastFlowInfo.put("COUNTRY_OPINION", "");
                forecastFlowInfo.put("IMPORTANT_HINTS", "");
                forecastFlowInfo.put("IMPORTANT_HINTS_SEVEN", "");
                forecastFlowInfo.put("INSCRIBE", "");
            }
        }
        List<Map<String, Object>> forecastValueList = airForecastCityService.getForecastValueList(paramMap);
        // 获取AQI、首要污染物等具体信息
        rMap.put("success", true);
        rMap.put("info", forecastFlowInfo);
        rMap.put("dataList", forecastValueList);
        return rMap;
    }

    /**
     * @return String
     * @throws IOException
     * @throws JsonMappingException
     * @throws JsonParseException
     * @Title: saveCityForecastInfo
     * @Description: 保存城市预报信息
     */
    @RequestMapping("/saveCityForecastInfo")
    @ResponseBody
    public ResponseVo saveCityForecastInfo(@RequestParam Map<String, Object> paramMap1) throws Exception {
        ResponseVo responseVo = new ResponseVo();
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("datetime", paramMap1.get("FORECAST_TIME").toString());
        paramMap.put("SAVE_USER", LoginCache.getLoginUser().getUserName());
        paramMap.put("CREATE_DEPT", LoginCache.getLoginUser().getDeptName());
        paramMap.put("STATE", paramMap1.get("STATE").toString());
        //是否为主提交数据
        paramMap.put("IS_MAIN", paramMap1.get("STATE").toString().equals("UPLOAD") ? 1 : 0);
        paramMap.put("FLOW_STATE", paramMap1.get("STATE").toString().equals("UPLOAD") ? 1 : 0);
        paramMap.put("CITY_OPINION", paramMap1.get("FORECAST_SEVEN_CITY").toString().equals("") ? "" : paramMap1.get("FORECAST_SEVEN_CITY").toString());
        paramMap.put("AREA_OPINION", "");
        paramMap.put("COUNTRY_OPINION", paramMap1.get("FORECAST_SEVEN").toString());
        paramMap.put("CITY_OPINION_DAY3", paramMap1.get("FORECAST_THREE_CITY").toString());
        paramMap.put("COUNTRY_OPINION_DAY3", paramMap1.get("FORECAST_THREE").toString());
        paramMap.put("IMPORTANT_HINTS", paramMap1.get("HINT").toString());
        paramMap.put("IMPORTANT_HINTS_DAY7", paramMap1.get("HINT_7DAY").toString());
        paramMap.put("INSCRIBE", paramMap1.get("INSCRIBE").toString());
        paramMap.put("weatherConditionsType", paramMap1.get("weatherConditionsType").toString());
        // 写入AQI、首要污染物登具体信息，从表
        airForecastCityService.saveForecastValues(paramMap, paramMap1);
        responseVo.success("保存成功！");
        return responseVo;
    }


    /**
     * 查询城市填报信息,根据ID
     *
     * @param paramMap 请求参数
     */
    @RequestMapping("/cityForecastInfoById")
    @ResponseBody
    public Object cityForecasInfoById(@RequestParam Map<String, Object> paramMap) {
        ResponseVo responseVo = new ResponseVo();
        // 验证请求参数是否合法
        if (paramMap.get("reportId") == null || "".equals(paramMap.get("reportId"))) {
            return responseVo.failure("请求参数错误，可能值为空或包含非法字符。");
        }

        return responseVo.success(airForecastCityService.cityForecastInfoById(paramMap));
    }

    /**
     * 修改预报状态
     *
     * @param paramMap 参数
     * @return 修改的记录条数
     */
    @RequestMapping("/updateForecastState")
    @ResponseBody
    public ResponseVo updateForecastState(@RequestParam Map<String, Object> paramMap) {
        ResponseVo responseVo = new ResponseVo();
        // 报告ID不能为空
        if (StringUtils.isBlank((String) paramMap.get("reportId"))) {
            responseVo.failure("请求参数错误，可能值为空或包含非法字符。");
            return responseVo;
        }
        // 如果状态为空，则使用上报的状态作为默认值
        if (StringUtils.isBlank((String) paramMap.get("state"))) {
            paramMap.put("state", AnalysisStateEnum.UPLOAD.getValue());
        }
        //是否为主要提交数据
        paramMap.put("IS_MAIN", 1);
        paramMap.put("FLOW_STATE", paramMap.get("state").toString().equals("UPLOAD") ? 1 : 0);
        int result = airForecastCityService.updateForecastState(paramMap);
        String userName = LoginCache.getLoginUser().getUserName();
        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("result", result);
        resultMap.put("userName", userName);
        responseVo.success(resultMap);
        return responseVo;
    }

    /**
     * 根据报告ID删除预报
     *
     * @param paramMap 参数
     * @return 删除的条数
     */
    @RequestMapping("/deleteForecastById")
    @ResponseBody
    public ResponseVo deleteForecastById(@RequestParam Map<String, Object> paramMap) {
        ResponseVo responseVo = new ResponseVo();
        int result = airForecastCityService.deleteForecastById(paramMap);
        responseVo.success(result);
        return responseVo;
    }

    /**
     * 获取当前时间
     *
     * @param paramMap
     * @return
     */
    @RequestMapping("/getNewDate")
    @ResponseBody
    public ResponseVo getNewDate(@RequestParam Map<String, Object> paramMap) {
        ResponseVo responseVo = new ResponseVo();
        Map<String, Object> reMap = airForecastCityService.getNewDate();
        responseVo.success(reMap);
        return responseVo;
    }

    /**
     * 通过指标中值查询该指标的iaqi范围
     *
     * @param type      指标类型
     * @param numMedian 当前中值
     * @return
     */
    @RequestMapping("/getpollutantRange")
    @ResponseBody
    public DataResult getpollutantRange(String type, int numMedian) {
        Map<String, Object> range = airForecastCityService.getpollutantRange(type, numMedian);
        return DataResult.success(range);
    }

    /**
     * 根据报告ID撤回报告
     *
     * @param paramMap 参数
     * @return 删除的条数
     */
    @RequestMapping("/revocationReportById")
    @ResponseBody
    public ResponseVo revocationReportById(@RequestParam Map<String, Object> paramMap) {
        ResponseVo responseVo = new ResponseVo();
        boolean result = airForecastCityService.revocationReportById(paramMap);
        responseVo.success(result);
        return responseVo;
    }

    /**
     * 推送至省站
     *
     * @param paramMap 参数
     * @return
     */
    @RequestMapping("/pushData")
    @ResponseBody
    public DataResult pushData(@RequestBody Map<String, String> paramMap) {
        if (paramMap.isEmpty()) {
            return DataResult.success("推送数据不能为空！");
        }
        String infoId = airForecastCityService.pushData(paramMap);
        if (infoId != null) {
            return DataResult.success(infoId);
        }
        return DataResult.failure();
    }
}

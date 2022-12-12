package ths.project.analysis.forecastcaselibrary.service;

import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.deepoove.poi.XWPFTemplate;
import com.deepoove.poi.config.Configure;
import com.deepoove.poi.plugin.table.LoopRowTableRenderPolicy;
import com.deepoove.poi.util.PoitlIOUtils;
import org.apache.commons.collections.MapUtils;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import ths.jdp.core.dao.base.Paging;
import ths.jdp.core.service.base.BaseService;
import ths.jdp.core.web.LoginCache;
import ths.jdp.core.web.RequestHelper;
import ths.jdp.eform.service.components.word.DocumentPage;
import ths.project.analysis.forecastcaselibrary.vo.FactorAnalysis;
import ths.project.common.util.DateUtil;
import ths.project.common.util.ExcelUtil;
import ths.project.common.util.MapUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ForecastCaseLibraryService extends BaseService {
    private static final String sqlPackage = "ths.project.analysis.forecastcaselibrary.service.ForecastCaseLibraryMapper";

    /**
     * 获取字典项
     *
     * @param treeCode defualt
     * @return List<Map < String, Object>>
     */

    @Cacheable(key = "#treeCode")
    public List<Map<String, Object>> queryDictionaryListByCode(String treeCode) {
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("treeCode", treeCode);

        return dao.list(paramMap, sqlPackage + ".queryDictionaryListByCode");
    }

    /**
     * 查询案例列表
     *
     * @param paging   分页对象
     * @param paramMap 请求参数
     * @return Paging<Map < String, Object>>
     */
    public Paging<Map<String, Object>> queryCastList(Paging<Map<String, Object>> paging, Map<String, Object> paramMap) {
        String weatherCodes = MapUtil.getString(paramMap, "weatherCodes");
        if (StringUtils.isNotBlank(weatherCodes)) {
            paramMap.put("weatherArray", weatherCodes.split(","));
        }
        String polluteCodes = MapUtil.getString(paramMap, "polluteCodes");
        if (StringUtils.isNotBlank(polluteCodes)) {
            paramMap.put("polluteArray", polluteCodes.split(","));
        }

        return dao.list(paging, paramMap, sqlPackage + ".queryCastList");
    }

    /**
     * 计算表格数据
     *
     * @param paramMap 查询参数
     * @return List<Map < String, Object>>
     */
    public List<Map<String, Object>> queryCalculationDataList(Map<String, Object> paramMap) {

        return dao.list(paramMap, sqlPackage + ".queryCalculationDataList");
    }

    public int save(Map<String, Object> paramMap) {
        paramMap.put("userName", LoginCache.getLoginUser().getUserName());

        return dao.insert(paramMap, sqlPackage + ".save");
    }

    public int delete(Map<String, Object> paramMap) {

        return dao.delete(paramMap, sqlPackage + ".delete");
    }

    public List<Map<String, Object>> queryCastById(Map<String, Object> paramMap) {

        return dao.list(paramMap, sqlPackage + ".queryCastList");
    }

    public List<Map<String, Object>> queryPollutionAnalysisCharts(Map<String, Object> paramMap) {

        return dao.list(paramMap, sqlPackage + ".queryPollutionAnalysisCharts");
    }

    public String queryPollutionAnalysisText(Map<String, Object> paramMap) {
        Map<String, Object> resultMap = dao.get(paramMap, sqlPackage + ".queryPollutionAnalysisText");
        StringBuilder stringBuilder = new StringBuilder("案例时间发生时间为");
        //案例时间发生时间为2020年1月20日-23日，污染4天，其中轻度污染*天，中度污染*天，重度污染*天，严重污染*天，PM2.5小时最大值为*μg/m3，最大小时增幅为*μg/m3。O3小时最大值为*μg/m3，最大小时增幅为*μg/m3。
        String startTime = DateUtil.stringFormatZh2(MapUtil.getString(paramMap, "startTime"), "yyyy-MM-dd", "yyyy年MM月dd日");
        String endTime = DateUtil.stringFormatZh2(MapUtil.getString(paramMap, "endTime"), "yyyy-MM-dd", "yyyy年MM月dd日");
        stringBuilder.append(startTime).append("至").append(endTime).append("，污染").append(MapUtils.getString(resultMap, "POLLUTE_NUM")).append("天，");
        stringBuilder.append("其中轻度污染").append(MapUtils.getString(resultMap, "QDWR")).append("天，");
        stringBuilder.append("中度污染").append(MapUtils.getString(resultMap, "ZDWR")).append("天，");
        stringBuilder.append("重度污染").append(MapUtils.getString(resultMap, "ZZDWR")).append("天，");
        stringBuilder.append("严重污染").append(MapUtils.getString(resultMap, "YZWR")).append("天。");
        stringBuilder.append("PM2.5最大值为").append(MapUtils.getString(resultMap, "MAX_PM25")).append("μg/m3，");
        stringBuilder.append("最大增幅为").append(MapUtils.getString(resultMap, "ZF_PM25")).append("μg/m3。");
        stringBuilder.append("O3小时最大值为").append(MapUtils.getString(resultMap, "MAX_O3")).append("μg/m3，");
        stringBuilder.append("最大增幅为").append(MapUtils.getString(resultMap, "ZF_O3")).append("μg/m3。");
        return stringBuilder.toString();
    }

    public int updatePollutionAnalysisText(Map<String, Object> paramMap) {

        return dao.update(paramMap, sqlPackage + ".updatePollutionAnalysisText");
    }

    public int updateForcastRef(Map<String, Object> paramMap) {

        return dao.update(paramMap, sqlPackage + ".updateForcastRef");
    }

    public Paging<Map<String, Object>> querywaterList(Map<String, Object> paramMap, Paging<Map<String, Object>> paging) {
        return dao.list(paging, paramMap, sqlPackage + ".querywaterList");
    }

    public int updateWaterAnalysis(Map<String, Object> paramMap) {
        return dao.update(paramMap, sqlPackage + ".updateWaterAnalysis");
    }

    public void exportForcast(Map<String, Object> params, HttpServletRequest request, HttpServletResponse response) {
        List<Map<String, Object>> list = dao.list(params, sqlPackage + ".queryCastList");
        String fileName = "预报案列分析.xlsx";
        String sheetName = "预报案列";
        String title[] = {"W_START_TIME:开始时间", "W_END_TIME:结束时间", "WEATHER_TYPE_NAME:影响类型", "POLLUTE_NAME:污染类型", "POLLUTE_NUM:污染天数", "MAX_PM25:PM2.5(最大)", "MAX_O3:O3(最大)"
                , "AVG_PM25:PM2.5(平均)", "AVG_PM10:PM10(平均)", "AVG_SO2:SO2(平均)", "AVG_NO2:NO2(平均)", "AVG_CO:CO(平均)", "AVG_O3:O3(平均)"
                , "TEMPERATURE:平均气温", "PRECIPITATION:降水量", "WIND_SPEED:平均风速", "WIND_FREQUENCY:静风频率"};
        if (list != null) {
            ExcelUtil.exportSimpleExcel07(response, fileName, sheetName, title, list, "0:15", "1:15", "2:20");
        }
    }

    public void exportForcastDetailWord(Map<String, Object> params, HttpServletRequest request, HttpServletResponse response) throws IOException {
        List<Map<String, Object>> list = dao.list(params, sqlPackage + ".queryCastList");//基本信息
        if (list == null || list.size() <= 0) {
            throw new IllegalArgumentException("基本信息不存在");
        }
        Map<String, Object> map = list.get(0);

        Map<String, Object> parameter = new HashMap<>();
        //一
        String pollute_name = MapUtils.getString(map, "POLLUTE_NAME", "暂无");
        String w_start_time = MapUtils.getString(map, "W_START_TIME", "");
        String w_end_time = MapUtils.getString(map, "W_END_TIME", "");
        //时间段
        params.put("startTime", w_start_time);
        params.put("endTime", w_end_time);
        params.remove("id");
        List<Map<String, Object>> listAll = dao.list(params, sqlPackage + ".querywaterList");

        parameter.put("name", MapUtils.getString(map, "WEATHER_TYPE_NAME", "新建标题").concat("-").concat(pollute_name));
        parameter.put("date", w_start_time.concat("~").concat(w_end_time));
        parameter.put("startDate", w_start_time);
        parameter.put("endDate", w_end_time);
        parameter.put("weatherType", MapUtils.getString(map, "WEATHER_TYPE_NAME", ""));
        parameter.put("polluteName", pollute_name);
        parameter.put("polluteNum", MapUtils.getString(map, "POLLUTE_NUM", "-"));
        parameter.put("max_pm25", MapUtils.getString(map, "MAX_PM25", "-"));
        parameter.put("max_o3", MapUtils.getString(map, "MAX_O3", "-"));
        parameter.put("avg_pm25", MapUtils.getString(map, "AVG_PM25", "-"));
        parameter.put("avg_pm10", MapUtils.getString(map, "AVG_PM10", "-"));
        parameter.put("avg_so2", MapUtils.getString(map, "AVG_SO2", "-"));
        parameter.put("avg_no2", MapUtils.getString(map, "AVG_NO2", "-"));
        parameter.put("avg_co", MapUtils.getString(map, "AVG_CO", "-"));
        parameter.put("avg_o3", MapUtils.getString(map, "AVG_O3", "-"));
        parameter.put("temperature", MapUtils.getString(map, "TEMPERATURE", "-"));
        parameter.put("precipitation", MapUtils.getString(map, "PRECIPITATION", "-"));
        parameter.put("wind_speed", MapUtils.getString(map, "WIND_SPEED", "-"));
        parameter.put("wind_frequency", MapUtils.getString(map, "WIND_FREQUENCY", "-"));
        //二
        parameter.put("analysisConclusion", MapUtils.getString(map, "ANALYSIS_CONCLUSION", "-"));
        //三
        List<FactorAnalysis> factorAnalysisList = new ArrayList<>();
        listAll.stream().forEach(maps -> {
            String monitortime = MapUtils.getString(maps, "MONITORTIME", "-");
            String pm25 = MapUtils.getString(maps, "PM25", "-");
            String temperature = MapUtils.getString(maps, "TEMPERATURE", "-");
            String rhu = MapUtils.getString(maps, "RHU", "-");
            String rainfal = MapUtils.getString(maps, "RAINFAL", "-");
            String wind_speed = MapUtils.getString(maps, "WIND_SPEED", "-");
            String wind_frequency = MapUtils.getString(maps, "WIND_FREQUENCY", "-");
            String temp_inversion08 = MapUtils.getString(maps, "TEMP_INVERSION08", "-");
            String temp_inversion20 = MapUtils.getString(maps, "TEMP_INVERSION20", "-");
            factorAnalysisList.add(FactorAnalysis.build()
                    .monitortime(monitortime)
                    .pm25(pm25)
                    .temperature(temperature)
                    .rhu(rhu)
                    .rainfal(rainfal)
                    .windSpeed(wind_speed)
                    .windFrequency(wind_frequency)
                    .tempInversion08(temp_inversion08)
                    .tempInversion20(temp_inversion20));
        });
        parameter.put("list", factorAnalysisList);
        //四
        parameter.put("forecastRef", MapUtils.getString(map, "FORECAST_REF", "-"));
        File file = new File(getFilePath("ForeCast.docx"));
        //循环行(hang)插件
        LoopRowTableRenderPolicy policy = new LoopRowTableRenderPolicy();
        Configure config = Configure.builder()
                .bind("list", policy).build();
        //设置配置信息
        XWPFTemplate template = XWPFTemplate.compile(file, config).render(parameter);
        //设置导出头信息,以及流信息
        response.setContentType("application/octet-stream");
        String attachName = new String(("案列预案分析.docx").getBytes(), "ISO-8859-1");
        response.setHeader("Content-disposition", "attachment;filename="+attachName);

        OutputStream out = response.getOutputStream();
        BufferedOutputStream bos = new BufferedOutputStream(out);
        template.write(bos);
        bos.flush();
        out.flush();
        PoitlIOUtils.closeQuietlyMulti(template, bos, out);
    }

    private static String getFilePath(String fileName) throws UnsupportedEncodingException {
        String root = ExcelUtil.class.getResource("/").getPath();
        if (root.indexOf("target") >= 0) {
            root = root.substring(1, root.indexOf("target"));
            root = root.replaceAll("/", "\\\\");
            root = root + "src\\main\\webapp" + File.separator + "assets" + File.separator + "template" + File.separator + fileName;
        } else {
            root = root.substring(1, root.indexOf("WEB-INF"));
            root = root.replaceAll("/", "\\\\");
            root = root + "assets" + File.separator + "template" + File.separator + fileName;
        }

        return URLDecoder.decode(root, "GBK");
    }
}

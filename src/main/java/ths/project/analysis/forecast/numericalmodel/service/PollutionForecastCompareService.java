package ths.project.analysis.forecast.numericalmodel.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ths.project.analysis.forecast.numericalmodel.mapper.ModelwqDayRowMapper;
import ths.project.analysis.forecast.numericalmodel.query.ForecastQuery;
import ths.project.common.util.*;

import javax.servlet.http.HttpServletResponse;
import java.util.*;

/**
 * 近期污染物浓度预报比较
 */
@Service
public class PollutionForecastCompareService {

    @Autowired
    private ModelwqDayRowMapper modelwqDayRowMapper;

    /**
     * 查询最大时间
     */
    public Map<String, String> queryMaxDate(ForecastQuery query) {
        //查询成都市最新预报时间为默认时间
        Map<String, Object> maxDateMap = modelwqDayRowMapper.queryMaxResultDate(query);
        HashMap<String, String> dateMap = new HashMap<>(2);
        if (maxDateMap != null && maxDateMap.get("END_DATE") != null && !"".equals(maxDateMap.get("END_DATE"))) {
            dateMap.put("startDate", String.valueOf(maxDateMap.get("START_DATE")).substring(0, 10));
            dateMap.put("endDate", String.valueOf(maxDateMap.get("END_DATE")).substring(0, 10));
        } else {
            dateMap.put("startDate", DateUtil.history("yyyy-MM-dd", -14));
            dateMap.put("endDate", DateUtil.history("yyyy-MM-dd", 0));
        }
        return dateMap;
    }

    /**
     * 获取预报数据
     *
     * @param query 查询条件
     * @return
     */
    public Map<String, List> queryForecastData(ForecastQuery query) {
        //12时数据
        query.setQueryType("twelve");
        List<Map<String, Object>> forecastDate12 = modelwqDayRowMapper.getForecastData(query);
        //0时数据
        query.setQueryType("zero");
        List<Map<String, Object>> forecastDate0 = modelwqDayRowMapper.getForecastData(query);
        HashMap<String, List> resultMap = new HashMap<>(2);
        resultMap.put("twelve", forecastDate12);
        resultMap.put("zero", forecastDate0);
        return resultMap;
    }

    /**
     * 导出预报数据
     *
     * @param query    查询条件
     * @param response
     */
    public void exportExcel(ForecastQuery query, HttpServletResponse response) {
        ArrayList<List<LinkedHashMap<String, Object>>> dataList = new ArrayList<>();
        //0时数据
        query.setQueryType("zero");
        List<LinkedHashMap<String, Object>> forecastDate0 = modelwqDayRowMapper.getForecastExportData(query);
        //替换首要污染物上下标
        replacePollute(forecastDate0);
        dataList.add(forecastDate0);
        String[] modelArr = {"CMA","CFS"};
        String tempFileName = "pollutionForecastCompare/pollutionForecastCompare0-12.xlsx";
        if (Arrays.asList(modelArr).contains(query.getModel())){
            tempFileName = "pollutionForecastCompare/pollutionForecastCompare.xlsx";
            ExcelUtil.exportMultiSheetExcelByTemp07(response, tempFileName, query.getExcelName(), new Integer[]{1}, new Integer[]{0}, dataList);
        } else {
            //12时数据
            query.setQueryType("twelve");
            List<LinkedHashMap<String, Object>> forecastDate12 = modelwqDayRowMapper.getForecastExportData(query);
            //替换首要污染物上下标
            replacePollute(forecastDate12);
            dataList.add(forecastDate12);
            ExcelUtil.exportMultiSheetExcelByTemp07(response, tempFileName, query.getExcelName(), new Integer[]{1,1}, new Integer[]{0,0}, dataList);

        }
    }
    /**
     * 替换首要污染物
     */
    public void replacePollute(List<LinkedHashMap<String, Object>> forecastData){
        if (forecastData!=null && forecastData.size()>0){
            for (LinkedHashMap<String, Object> map:forecastData) {
                String pollute = MapUtil.getString(map, "PRIMPOLLUTE", "");
                if (Objects.equals(pollute, "PM2.5")) {
                    map.put("PRIMPOLLUTE","PM₂.₅");
                } else if (Objects.equals(pollute, "O3_8")) {
                    map.put("PRIMPOLLUTE","O₃_8");
                } else if (Objects.equals(pollute, "NO2")) {
                    map.put("PRIMPOLLUTE","NO₂");
                } else if (Objects.equals(pollute, "SO2")) {
                    map.put("PRIMPOLLUTE","SO₂");
                } else if (Objects.equals(pollute, "PM10")) {
                    map.put("PRIMPOLLUTE","PM₁₀");
                } else if (Objects.equals(pollute, "O3")) {
                    map.put("PRIMPOLLUTE","O₃");
                }
            }
        }
    }
}

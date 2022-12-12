package ths.project.analysis.forecast.fourteendayforecastcalendar.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ths.project.analysis.forecast.fourteendayforecastcalendar.entity.TBasModelwqDayRow;
import ths.project.analysis.forecast.fourteendayforecastcalendar.mapper.PlainForecastCalendarMapper;
import ths.project.analysis.forecast.numericalmodel.query.ForecastQuery;
import ths.project.common.util.ExcelUtil;

import javax.servlet.http.HttpServletResponse;
import java.util.*;
@Service
public class PlainForecastCalendarService {

    @Autowired
    private PlainForecastCalendarMapper plainForecastCalendarMapper;

    /**
     * 获取该月日数据
     *
     */
    public Map<String, Object> getDayList(ForecastQuery query) {
        HashMap<String, Object> map = new HashMap<>();
        query.setQueryType("zero");
        List<TBasModelwqDayRow> list0 = plainForecastCalendarMapper.getCalendarList(query);
        query.setQueryType("twelve");
        List<TBasModelwqDayRow> list12 = plainForecastCalendarMapper.getCalendarList(query);
        map.put("list0", list0);
        map.put("list12", list12);
        return map;
    }

    /**
     * 导出
     * @param query
     * @param response
     */
    public void exportExcel(ForecastQuery query, HttpServletResponse response) {
        ArrayList<List<LinkedHashMap<String, Object>>> dataList = new ArrayList<>();
        //0时数据
        query.setQueryType("zero");
        List<LinkedHashMap<String, Object>> forecastDate0 = plainForecastCalendarMapper.getForecastExportData(query);
        dataList.add(forecastDate0);
        String[] modelArr = {"CMA","CFS"};
        String tempFileName = "plainForecastCalendar/calendarForecast0-12.xlsx";
        if (Arrays.asList(modelArr).contains(query.getModel())){
            tempFileName = "plainForecastCalendar/calendarForecast.xlsx";
            ExcelUtil.exportMultiSheetExcelByTemp07(response, tempFileName, query.getExcelName(), new Integer[]{1}, new Integer[]{0}, dataList);
        } else {
            //12时数据
            query.setQueryType("twelve");
            List<LinkedHashMap<String, Object>> forecastDate12 = plainForecastCalendarMapper.getForecastExportData(query);
            dataList.add(forecastDate12);
            ExcelUtil.exportMultiSheetExcelByTemp07(response, tempFileName, query.getExcelName(), new Integer[]{1,1}, new Integer[]{0,0}, dataList);

        }
    }
}

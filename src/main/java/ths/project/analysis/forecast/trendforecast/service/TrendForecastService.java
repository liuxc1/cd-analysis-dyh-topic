package ths.project.analysis.forecast.trendforecast.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ths.jdp.core.dao.base.Paging;
import ths.project.analysis.forecast.numericalmodel.query.ForecastQuery;
import ths.project.analysis.forecast.trendforecast.entity.TBasModelwqHourRow;
import ths.project.analysis.forecast.trendforecast.mapper.TrendForecastMapper;
import ths.project.common.util.ExcelUtil;
import ths.project.system.base.util.PageSelectUtil;

import javax.servlet.http.HttpServletResponse;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@Service
public class TrendForecastService {

    @Autowired
    private TrendForecastMapper trendForecastMapper;

    private static final String ZERO = "zero";

    private static final String TWELVE = "twelve";

    /**
     * 获取小时数据
     *
     * @param modelTime 模型时间
     * @param pointCode 点码
     * @return
     */
    public Map<String, Object> getHourList(String modelTime, String pointCode) {
        String futureTime = modelTime;
        futureTime = delayDays(futureTime, 15);
        HashMap<String, Object> map = new HashMap<>();
        List<TBasModelwqHourRow> hours0 = trendForecastMapper.getHourDate(modelTime, pointCode, ZERO);
        removeListRedundant(hours0, modelTime, futureTime);
        List<TBasModelwqHourRow> hours12 = trendForecastMapper.getHourDate(modelTime, pointCode, TWELVE);
        removeListRedundant(hours12, modelTime, futureTime);
        map.put("hours0", hours0);
        map.put("hours12", hours12);
        return map;
    }

    /**
     * 导出excel
     *
     * @param query    查询条件
     * @param response
     */
    public void exportExcel(ForecastQuery query, HttpServletResponse response) {
        String futureTime = query.getModelTime();
        futureTime = delayDays(futureTime, 15);
        ArrayList<List<LinkedHashMap<String, Object>>> dataList = new ArrayList<>();
        //0时数据
        query.setQueryType(ZERO);
        List<LinkedHashMap<String, Object>> forecastDate0 = trendForecastMapper.getForecastExportData(query);
        removeExportRedundant(forecastDate0, query.getModelTime(), futureTime);
        //12时数据
        query.setQueryType(TWELVE);
        List<LinkedHashMap<String, Object>> forecastDate12 = trendForecastMapper.getForecastExportData(query);
        removeExportRedundant(forecastDate12, query.getModelTime(), futureTime);
        dataList.add(forecastDate0);
        dataList.add(forecastDate12);
        Integer[] startRows = {1, 1};
        Integer[] startCells = {0, 0};
        ExcelUtil.exportMultiSheetExcelByTemp07(response, "weatherTrends.xlsx", query.getExcelName(), startRows, startCells, dataList);
    }

    /**
     * 获取分页数据
     *
     * @param paramMap
     * @param paging
     * @return
     */
    public HashMap<String, Paging<TBasModelwqHourRow>> getPagingHourData(Map<String, Object> paramMap, Paging<TBasModelwqHourRow> paging) {
        Object modelTime = paramMap.get("modelTime");
        paramMap.put("startTime", modelTime.toString() + " 23:00:00");
        paramMap.put("endTime", delayDays(modelTime.toString(), 15) + " 00:00:00");
        HashMap<String, Paging<TBasModelwqHourRow>> pagings = new HashMap<>();
        Paging<TBasModelwqHourRow> pagingData0 = PageSelectUtil.selectListPage1(trendForecastMapper, paging, TrendForecastMapper::queryTBasModelwqHourRowZeroPageList, paramMap);
        Paging<TBasModelwqHourRow> pagingData12 = PageSelectUtil.selectListPage1(trendForecastMapper, paging, TrendForecastMapper::queryTBasModelwqHourRowTwelvePageList, paramMap);
        pagings.put("pagingData0", pagingData0);
        pagings.put("pagingData12", pagingData12);
        return pagings;
    }

    /**
     * 删除导出多余信息
     *
     * @param data
     * @param modelTime
     * @param futureTime
     */
    public static void removeExportRedundant(List<LinkedHashMap<String, Object>> data, String modelTime, String futureTime) {
        for (int i = data.size() - 1; i >= 0; i--) {
            String resultTime = data.get(i).get("RESULTTIME").toString().substring(0, 10);
            if (resultTime.equals(modelTime) || resultTime.equals(futureTime)) {
                data.remove(data.get(i));
            }
        }
    }

    /**
     * 删除多余数据
     *
     * @param data
     * @param modelTime
     * @param futureTime
     */
    public static void removeListRedundant(List<TBasModelwqHourRow> data, String modelTime, String futureTime) {
        for (int i = data.size() - 1; i >= 0; i--) {
            String resultTime = data.get(i).getResultTime().substring(0, 10);
            if (resultTime.equals(modelTime) || resultTime.equals(futureTime)) {
                data.remove(data.get(i));
            }
        }
    }

    /**
     * 未来时间
     *
     * @param futureTime
     * @param day
     * @return
     */
    public static String delayDays(String futureTime, int day) {
        Date date = null;
        try {
            date = new SimpleDateFormat("yyyy-MM-dd").parse(futureTime);
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(date);
            calendar.add(calendar.DATE, day);
            date = calendar.getTime();
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return new SimpleDateFormat("yyyy-MM-dd").format(date);
    }
}

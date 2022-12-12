package ths.project.analysis.forecast.numericalmodel.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ths.project.analysis.forecast.numericalmodel.mapper.ComponentsMapper;
import ths.project.analysis.forecast.numericalmodel.query.ForecastQuery;
import ths.project.common.util.ExcelUtil;

import javax.servlet.http.HttpServletResponse;
import java.util.*;

/**
 * PM25组分预报
 * @date 2021年06月22日 15:35
 */
@Service
public class ComponentsForecastService {
    @Autowired
    private ComponentsMapper componentsMapper;

    /**
     * 查询数据
     * @param query
     * @return
     */
    public Map<String, Object> getComponentsData(ForecastQuery query) {
        String queryTime=query.getModelTime();
        //12时
        query.setModelTime(queryTime+" 12:00:00");
        List<Map<String, Object>> resultList_12=componentsMapper.queryComponentsData(query);
        //00时
        query.setModelTime(queryTime+" 00:00:00");
        List<Map<String, Object>> resultList_0=componentsMapper.queryComponentsData(query);
        HashMap<String, Object> resultMap = new HashMap<>();
        resultMap.put("twelve",resultList_12);
        resultMap.put("zero",resultList_0);
        return resultMap;
    }

    /**
     * 导出数据
     * @param query
     * @param response
     */
    public void exportExcel(ForecastQuery query, HttpServletResponse response) {
        String queryTime=query.getModelTime();
        //12时
        query.setModelTime(queryTime+" 12:00:00");
        List<LinkedHashMap<String, Object>> resultList_12=componentsMapper.getComponentsExportData(query);
        //00时
        query.setModelTime(queryTime+" 00:00:00");
        List<LinkedHashMap<String, Object>> resultList_0=componentsMapper.getComponentsExportData(query);
        ArrayList<List<LinkedHashMap<String, Object>>> dataList = new ArrayList<>();
        dataList.add(resultList_0);
        dataList.add(resultList_12);
        Integer[] startRows = {1, 1};
        Integer[] startCells = {0, 0};
        String tempFileName="Pm25ComponentsForecastHeap.xlsx";
        if (!"heap".equals(query.getShowType())){
            tempFileName = "Pm25ComponentsForecastPercent.xlsx";
        }
        ExcelUtil.exportMultiSheetExcelByTemp07(response, tempFileName, query.getExcelName(), startRows, startCells, dataList);

    }
}

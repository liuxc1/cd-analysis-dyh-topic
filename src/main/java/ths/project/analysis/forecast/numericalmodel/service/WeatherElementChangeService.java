package ths.project.analysis.forecast.numericalmodel.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ths.jdp.core.dao.base.Paging;
import ths.project.analysis.forecast.numericalmodel.entity.WrfDataDay;
import ths.project.analysis.forecast.numericalmodel.entity.WrfDataHour;
import ths.project.analysis.forecast.numericalmodel.entity.WrfDataHourNw;
import ths.project.analysis.forecast.numericalmodel.mapper.WeatherElementChangeDayMapper;
import ths.project.analysis.forecast.numericalmodel.mapper.WeatherElementChangeHourMapper;
import ths.project.analysis.forecast.numericalmodel.mapper.WeatherElementChangeNwMapper;
import ths.project.analysis.forecast.numericalmodel.query.ForecastQuery;
import ths.project.common.util.ExcelUtil;
import ths.project.system.base.util.PageSelectUtil;

import javax.servlet.http.HttpServletResponse;
import java.util.*;

/**
 * 气象要素变化
 *
 * @date 2021年06月23日 14:05
 */
@Service
public class WeatherElementChangeService {
    @Autowired
    private WeatherElementChangeHourMapper weatherElementChangeHourMapper;
    @Autowired
    private WeatherElementChangeDayMapper weatherElementChangeDayMapper;
    @Autowired
    private WeatherElementChangeNwMapper weatherElementChangeNwMapper;

    /**
     * 获取气象数据
     *
     * @param query
     * @return
     */
    public Map<String, Object> getWeatherData(ForecastQuery query) {
        String targetIndex = query.getTargetIndex();
        HashMap<String, Object> resultMap = new HashMap<>();
        //日期
        String modelTime = query.getModelTime();
        String oldModelTime = query.getOldModelTime();
        //风速风向日数据
        if ("10".equals(targetIndex) && "day".equals(query.getDataType())) {
            query.setModelTime(modelTime + " 12:00:00");
            resultMap.put("twelve", getWrfDataDay(query, 1));
            //当天00时
            query.setModelTime(modelTime + " 00:00:00");
            resultMap.put("zero", getWrfDataDay(query, 1));
            //上一天12时
            query.setModelTime(oldModelTime + " 12:00:00");
            resultMap.put("oldTwelve", getWrfDataDay(query, 2));
            //上一天00时
            query.setModelTime(oldModelTime + " 00:00:00");
            resultMap.put("oldZero", getWrfDataDay(query, 2));
            //逆温 todo
        } else if ("11".equals(targetIndex)) {

            //水汽分布 todo
        } else if ("12".equals(targetIndex)) {

        } else {
            query.setModelTime(modelTime + " 12:00:00");
            resultMap.put("twelve", getWrfDataHour(query, 1));
            //当天00时
            query.setModelTime(modelTime + " 00:00:00");
            resultMap.put("zero", getWrfDataHour(query, 1));
            //上一天12时
            query.setModelTime(oldModelTime + " 12:00:00");
            resultMap.put("oldTwelve", getWrfDataHour(query, 2));
            //上一天00时
            query.setModelTime(oldModelTime + " 00:00:00");
            resultMap.put("oldZero", getWrfDataHour(query, 2));
        }
        return resultMap;
    }

    /**
     * 获取气象数据
     *
     * @param query
     * @return
     */
    public Map<String, Object> getWeatherData2(ForecastQuery query) {
        String targetIndex = query.getTargetIndex();
        HashMap<String, Object> resultMap = new HashMap<>();
        //日期
        String modelTime = query.getModelTime();
        String oldModelTime = query.getOldModelTime();
        //风速风向日数据
        if ("10".equals(targetIndex) && "day".equals(query.getDataType())) {
            query.setModelTime(modelTime + " 12:00:00");
            resultMap.put("twelve", getWrfDataDay2(query, 1));
            //当天00时
            query.setModelTime(modelTime + " 00:00:00");
            resultMap.put("zero", getWrfDataDay2(query, 1));
          /*  //上一天12时
            query.setModelTime(oldModelTime + " 12:00:00");
            resultMap.put("oldTwelve", getWrfDataDay2(query, 2));
            //上一天00时
            query.setModelTime(oldModelTime + " 00:00:00");
            resultMap.put("oldZero", getWrfDataDay2(query, 2));*/
            //逆温 todo
        } else if ("11".equals(targetIndex)) {

            //水汽分布 todo
        } else if ("12".equals(targetIndex)) {

        } else {
            query.setModelTime(modelTime + " 12:00:00");
            resultMap.put("twelve", getWrfDataHour2(query, 1));
            //当天00时
            query.setModelTime(modelTime + " 00:00:00");
            resultMap.put("zero", getWrfDataHour2(query, 1));
          /*  //上一天12时
            query.setModelTime(oldModelTime + " 12:00:00");
            resultMap.put("oldTwelve", getWrfDataHour2(query, 2));
            //上一天00时
            query.setModelTime(oldModelTime + " 00:00:00");
            resultMap.put("oldZero", getWrfDataHour2(query, 2));*/
        }
        return resultMap;
    }

    /**
     * 查询小时数据
     *
     * @param query
     * @param pageInfo
     * @return
     */
    public Map<String, Object> queryWeatherDataList(ForecastQuery query, Paging<WrfDataHour> pageInfo) {
        HashMap<String, Object> resultMap = new HashMap<>();
        LambdaQueryWrapper<WrfDataHour> queryWrapper = Wrappers.lambdaQuery();
        String modelTime = query.getModelTime();
        //当天12时
        queryWrapper.eq(WrfDataHour::getModelTime, modelTime + " 12:00:00")
                .eq(WrfDataHour::getModel, query.getModel())
                .eq(WrfDataHour::getPointCode, query.getPointCode())
                .between(WrfDataHour::getStep, 1, query.getStep() == null ? 14 : query.getStep())
                .orderByAsc(WrfDataHour::getResultTime);
        resultMap.put("twelve", PageSelectUtil.selectListPage1(weatherElementChangeHourMapper, pageInfo, WeatherElementChangeHourMapper::selectList, queryWrapper));
        //当天00时
        queryWrapper.clear();
        queryWrapper.eq(WrfDataHour::getModelTime, modelTime + " 00:00:00")
                .eq(WrfDataHour::getModel, query.getModel())
                .eq(WrfDataHour::getPointCode, query.getPointCode())
                .between(WrfDataHour::getStep, 1, query.getStep() == null ? 14 : query.getStep())
                .orderByAsc(WrfDataHour::getResultTime);
        resultMap.put("zero", PageSelectUtil.selectListPage1(weatherElementChangeHourMapper, pageInfo, WeatherElementChangeHourMapper::selectList, queryWrapper));
        return resultMap;
    }

    /**
     * 查询气象小时数据
     *
     * @param query
     * @return
     */
    public List<WrfDataHour> getWrfDataHour(ForecastQuery query, Integer step) {
        LambdaQueryWrapper<WrfDataHour> queryWrapper = Wrappers.lambdaQuery();
        queryWrapper.eq(WrfDataHour::getModelTime, query.getModelTime())
                .eq(WrfDataHour::getModel, query.getModel())
                .eq(WrfDataHour::getPointCode, query.getPointCode())
                .between(WrfDataHour::getStep, step, query.getStep() == null ? 14 : query.getStep())
                .orderByAsc(WrfDataHour::getResultTime);
        return weatherElementChangeHourMapper.selectList(queryWrapper);
    }

    public List<WrfDataHour> getWrfDataHour2(ForecastQuery query, Integer step) {
        LambdaQueryWrapper<WrfDataHour> queryWrapper = Wrappers.lambdaQuery();
        queryWrapper.eq(WrfDataHour::getModelTime, query.getModelTime())
                .eq(WrfDataHour::getPointCode, query.getPointCode())
                .between(WrfDataHour::getStep, step, query.getStep() == null ? 14 : query.getStep())
                .orderByAsc(WrfDataHour::getResultTime);
        return weatherElementChangeHourMapper.selectList(queryWrapper);
    }

    /**
     * 查询风速风向 日数据(分页)
     *
     * @param query
     * @param pageInfo
     * @return
     */
    public Map<String, Object> getWeatherDayDataPage(ForecastQuery query, Paging<WrfDataDay> pageInfo) {
        HashMap<String, Object> resultMap = new HashMap<>();
        LambdaQueryWrapper<WrfDataDay> queryWrapper = Wrappers.lambdaQuery();
        String modelTime = query.getModelTime();
        //当天12时
        queryWrapper.eq(WrfDataDay::getModelTime, modelTime + " 12:00:00")
                .eq(WrfDataDay::getModel, query.getModel())
                .eq(WrfDataDay::getPointCode, query.getPointCode())
                .between(WrfDataDay::getStep, 1, query.getStep() == null ? 14 : query.getStep())
                .orderByAsc(WrfDataDay::getResultTime);
        resultMap.put("twelve", PageSelectUtil.selectListPage1(weatherElementChangeDayMapper, pageInfo, WeatherElementChangeDayMapper::selectList, queryWrapper));
        //当天00时
        queryWrapper.clear();
        queryWrapper.eq(WrfDataDay::getModelTime, modelTime + " 00:00:00")
                .eq(WrfDataDay::getModel, query.getModel())
                .eq(WrfDataDay::getPointCode, query.getPointCode())
                .between(WrfDataDay::getStep, 1, query.getStep() == null ? 14 : query.getStep())
                .orderByAsc(WrfDataDay::getResultTime);
        resultMap.put("zero", PageSelectUtil.selectListPage1(weatherElementChangeDayMapper, pageInfo, WeatherElementChangeDayMapper::selectList, queryWrapper));
        return resultMap;
    }

    /**
     * 查询气象风速风向日数据
     *
     * @param query
     * @return
     */
    public List<WrfDataDay> getWrfDataDay(ForecastQuery query, Integer step) {
        LambdaQueryWrapper<WrfDataDay> queryWrapper = Wrappers.lambdaQuery();
        queryWrapper.eq(WrfDataDay::getModelTime, query.getModelTime())
                .eq(WrfDataDay::getModel, query.getModel())
                .eq(WrfDataDay::getPointCode, query.getPointCode())
                .between(WrfDataDay::getStep, step, query.getStep() == null ? 14 : query.getStep())
                .orderByAsc(WrfDataDay::getResultTime);
        return weatherElementChangeDayMapper.selectList(queryWrapper);
    }

    public List<WrfDataDay> getWrfDataDay2(ForecastQuery query, Integer step) {
        LambdaQueryWrapper<WrfDataDay> queryWrapper = Wrappers.lambdaQuery();
        queryWrapper.eq(WrfDataDay::getModelTime, query.getModelTime())
                .eq(WrfDataDay::getPointCode, query.getPointCode())
                .between(WrfDataDay::getStep, step, query.getStep() == null ? 14 : query.getStep())
                .orderByAsc(WrfDataDay::getResultTime);
        return weatherElementChangeDayMapper.selectList(queryWrapper);
    }

    /**
     * 导出
     *
     * @param query
     * @param response
     */
    public void exportExcel(ForecastQuery query, HttpServletResponse response) {
        String queryTime = query.getModelTime();
        String targetIndex = query.getTargetIndex();
        List<LinkedHashMap<String, Object>> resultList_12 = null;
        List<LinkedHashMap<String, Object>> resultList_0 = null;
        String tempFileName = "weatherCommon.xlsx";
        Integer[] startRows = {1, 1};
        Integer[] startCells = {0, 0};
        //风向风速数据
        if ("10".equals(targetIndex)) {
            tempFileName = "weatherWind.xlsx";
            query.setModelTime(queryTime + " 12:00:00");
            resultList_12 = weatherElementChangeDayMapper.getWrfDataWindExportData(query);
            //00时
            query.setModelTime(queryTime + " 00:00:00");
            resultList_0 = weatherElementChangeDayMapper.getWrfDataWindExportData(query);
            //逆温
        } else if ("11".equals(targetIndex)) {
            tempFileName = "weatherNw.xlsx";
            startRows = new Integer[]{2, 2};
            query.setModelTime(queryTime + " 12:00:00");
            resultList_12 = weatherElementChangeNwMapper.getWrfDataHourNwList(query);
            //00时
            query.setModelTime(queryTime + " 00:00:00");
            resultList_0 = weatherElementChangeNwMapper.getWrfDataHourNwList(query);
            //水汽分布 todo
        } else if ("12".equals(targetIndex)) {
            tempFileName = "weatherDys.xlsx";


            //气象多要素
        } else if ("13".equals(targetIndex)) {
            tempFileName = "weatherDys.xlsx";
            //12时
            query.setModelTime(queryTime + " 12:00:00");
            resultList_12 = weatherElementChangeHourMapper.getWrfDataHourYsExportData(query);
            //00时
            query.setModelTime(queryTime + " 00:00:00");
            resultList_0 = weatherElementChangeHourMapper.getWrfDataHourYsExportData(query);
        } else {
            //12时
            query.setModelTime(queryTime + " 12:00:00");
            resultList_12 = weatherElementChangeHourMapper.getWrfDataHourExportData(query);
            //00时
            query.setModelTime(queryTime + " 00:00:00");
            resultList_0 = weatherElementChangeHourMapper.getWrfDataHourExportData(query);
        }
        ArrayList<List<LinkedHashMap<String, Object>>> dataList = new ArrayList<>();
        dataList.add(resultList_0);
        dataList.add(resultList_12);
        //导出
        ExcelUtil.exportMultiSheetExcelByTemp07(response, tempFileName, query.getExcelName(), startRows, startCells, dataList);

    }

    /**
     * 获取逆温分页数据
     *
     * @param query
     * @param pageInfo
     * @return
     */
    public Map<String, Object> queryWeatherDataNwList(ForecastQuery query, Paging<LinkedHashMap<String, Object>> pageInfo) {
        HashMap<String, Object> resultMap = new HashMap<>();
        String modelTime = query.getModelTime();
        //当天12时
        query.setModelTime(modelTime + " 12:00:00");
        resultMap.put("twelve", PageSelectUtil.selectListPage1(weatherElementChangeNwMapper, pageInfo, WeatherElementChangeNwMapper::getWrfDataHourNwList, query));
        //0点
        query.setModelTime(modelTime + " 00:00:00");
        resultMap.put("zero", PageSelectUtil.selectListPage1(weatherElementChangeNwMapper, pageInfo, WeatherElementChangeNwMapper::getWrfDataHourNwList, query));
        return resultMap;
    }

    /**
     * 获取水汽分布分页数据
     *
     * @param query
     * @param pageInfo
     * @return
     */
    public Map<String, Object> queryWeatherDataSqList(ForecastQuery query, Paging<WrfDataHourNw> pageInfo) {
        return null;
    }
}

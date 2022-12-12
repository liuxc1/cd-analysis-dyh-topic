package ths.project.analysis.forecast.airforecasthour.service;


import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ths.jdp.core.model.LoginUserModel;
import ths.project.analysis.forecast.airforecasthour.entity.ModelwqHourRow;
import ths.project.analysis.forecast.airforecasthour.mapper.AirForecastHourMapper;
import ths.project.analysis.forecast.report.entity.GeneralReport;
import ths.project.analysis.forecast.report.enums.AscriptionTypeEnum;
import ths.project.analysis.forecast.report.service.GeneralReportService;
import ths.project.common.uid.SnowflakeIdGenerator;
import ths.project.common.util.DateUtil;
import ths.project.common.util.ExcelUtil;

import javax.servlet.http.HttpServletResponse;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 科研平台-逐小时预报
 *
 * @author qsx
 */
@Service
public class AirForecastHourService {

    @Autowired
    private AirForecastHourMapper airForecastHourMapper;
    @Autowired
    private GeneralReportService generalReportService;
    @Autowired
    private SnowflakeIdGenerator idGenerator;


    /**
     * 获取预报类型和用户
     *
     * @return
     */
    public List<ModelwqHourRow> getForecastTypeAndUser(String modelTime) {
        return airForecastHourMapper.getForecastTypeAndUser(modelTime);
    }

    /**
     * 表格数据
     *
     * @param param
     * @return
     */
    public List<Map<String, Object>> getTableData(Map<String, Object> param) {
        String models = MapUtils.getString(param, "models");
        String[] modelArr = models.split(",");
        List<Map<String, Object>> paramList = new ArrayList<Map<String, Object>>();
        Map<String, Object> model = null;
        for (String string : modelArr) {
            model = new HashMap<>();
            model.put("model", string);
            model.put("o3", string + "_o3");
            model.put("pm25", string + "_pm25");
            paramList.add(model);
        }
        List<String> hour = new ArrayList<String>();
        for (int i = 0; i < 24; i++) {
            if (i < 10) {
                hour.add("0" + i);
            } else {
                hour.add(Integer.toString(i));
            }
        }
        param.put("hour", hour);
        param.put("paramList", paramList);
        List<Map<String, Object>> list = airForecastHourMapper.getTableData(param);
        return list;
    }


    /**
     * 获取该月日数据
     *
     * @param param
     * @return
     */
    public List<Map<String, Object>> getDayList(Map<String, Object> param) {
        String month = (String) param.get("month");
        if (StringUtils.isBlank(month)) {
            Map<String, Object> maxMonthMap = airForecastHourMapper.getMonth(param);
            if (maxMonthMap != null && maxMonthMap.get("MAX_DATE") != null && !"".equals(maxMonthMap.get("MAX_DATE"))) {
                param.put("month", String.valueOf(maxMonthMap.get("MAX_DATE")).substring(0, 7));
                param.put("maxDate", maxMonthMap.get("MAX_DATE"));
            } else {
                param.put("month", DateUtil.history("yyyy-MM", 0));
            }
        }
        return airForecastHourMapper.getDayList(param);
    }

    /**
     * 保存数据
     */
    @Transactional
    public void save(List<Map<String, Object>> paramList, LoginUserModel loginUser) throws ParseException {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String timeStr = ((String) paramList.get(0).get("resultTime")).split(" ")[0];
        //reportTime
        Date reportTime = sdf.parse(timeStr + " 00:00:00");
        //modelTime
        Date modelTime = new Date(reportTime.getTime() - 24 * 60 * 60 * 1000);
        Integer isCommit = (Integer) paramList.get(0).get("isCommit");
        //新增保存report表
        Map<String, Object> param = null;
        //查询预报数据是否存在
        LambdaQueryWrapper<GeneralReport> queryWrapper = Wrappers.lambdaQuery();
        queryWrapper.eq(GeneralReport::getAscriptionType, AscriptionTypeEnum.FORECAST_HOUR.getValue());
        queryWrapper.eq(GeneralReport::getReportUserCode, loginUser.getLoginName());
        queryWrapper.eq(GeneralReport::getReportTime, reportTime);
        GeneralReport generalReport = generalReportService.getOne(queryWrapper);
        if (generalReport == null) {
            generalReport = new GeneralReport();
            generalReport.setReportId(idGenerator.getUniqueId());
            generalReport.setAscriptionType(AscriptionTypeEnum.FORECAST_HOUR.getValue());
            SimpleDateFormat sdf1 = new SimpleDateFormat("yyyyMMdd");
            generalReport.setReportName(sdf1.format(reportTime) + "逐小时预报");
            generalReport.setReportTime(reportTime);
            generalReport.setState("TEMP");
            generalReport.setIsMain(0);
            if (isCommit == 1) {
                generalReport.setIsMain(1);
            }
            generalReport.setReportUserCode(loginUser.getLoginName());
            generalReport.setReportUserName(loginUser.getUserName());
            generalReport.resolveCreate(loginUser.getUserName());
            generalReportService.save(generalReport);
            //model
            for (Map<String, Object> paramMap : paramList) {
                Integer o3 = null;
                Integer pm25 = null;
                if (paramMap.get(loginUser.getLoginName() + "_pm25") != null) {
                    pm25 = Integer.parseInt(MapUtils.getString(paramMap, loginUser.getLoginName() + "_pm25"));
                }
                if (paramMap.get(loginUser.getLoginName() + "_o3") != null) {
                    o3 = Integer.parseInt(MapUtils.getString(paramMap, loginUser.getLoginName() + "_o3"));
                }

                ModelwqHourRow modelwqHourRow = new ModelwqHourRow(loginUser.getLoginName(), modelTime, sdf.parse(paramMap.get("resultTime") + ":00:00"),
                        "510100000000", "成都市", "510100000000", "成都市", 0, 0, pm25, o3, loginUser.getUserName(), 1);
                airForecastHourMapper.insert(modelwqHourRow);
            }
        } else {
            //修改report表
            generalReport.resolveUpdate(loginUser.getUserName());
            generalReport.setIsMain(0);
            if (isCommit == 1) {
                generalReport.setIsMain(1);
            }
            generalReportService.updateById(generalReport);
            //model
            for (Map<String, Object> paramMap : paramList) {
                param = new HashMap<String, Object>();
                param.put("resultTime", sdf.parse(paramMap.get("resultTime") + ":00:00"));
                param.put("modelTime", modelTime);
                param.put("userId", loginUser.getLoginName());
                param.put("o3", paramMap.get(loginUser.getLoginName() + "_o3"));
                param.put("pm25", paramMap.get(loginUser.getLoginName() + "_pm25"));
                airForecastHourMapper.updateByUser(param);
            }
        }
        //提交--修改当天所有数据状态
        if (isCommit == 1) {
            LambdaQueryWrapper<GeneralReport> updateWrapper = Wrappers.lambdaQuery();
            updateWrapper.eq(GeneralReport::getAscriptionType, AscriptionTypeEnum.FORECAST_HOUR.getValue());
            updateWrapper.eq(GeneralReport::getReportTime, reportTime);
            GeneralReport newReport = new GeneralReport();
            newReport.setState("UPLOAD");
            generalReportService.update(newReport, updateWrapper);

        }
    }

    /**
     * 导出表格
     *
     * @param response
     * @param param
     * @return
     */
    public void exportExcel(HttpServletResponse response, Map<String, Object> param) {
        String models = MapUtils.getString(param, "models");
        String[] modelArr = models.split(",");
        String titleStr = "resultTime:预报时间,";
        ArrayList<String> colList = new ArrayList<>();
        colList.add("resultTime");
        for (String title : modelArr) {
            if ("shishi".equals(title)) {
                titleStr += "shishi" + "_pm25" + ":" + "实时" + "_PM₂.₅(μg/m³),";
                titleStr += "shishi" + "_o3" + ":" + "实时" + "_O₃(μg/m³),";
            } else {
                titleStr += title + "_pm25" + ":" + title + "_PM₂.₅(μg/m³),";
                titleStr += title + "_o3" + ":" + title + "_O₃(μg/m³),";
            }
            colList.add(title + "_pm25");
            colList.add(title + "_o3");
        }
        //标题
        List<String[]> titleList = new ArrayList<>();
        titleStr = titleStr.substring(0, titleStr.lastIndexOf(","));
        String[] titleArr = titleStr.split(",");
        titleList.add(titleArr);
        //数据
        List<Map<String, Object>> tableDataList = getTableData(param);
        List<List<Map<String, Object>>> dataList = new ArrayList<>();
        dataList.add(tableDataList);
        //列宽
        List<String[]> cellWidthList = new ArrayList<>();
        String[] cellArr = new String[titleArr.length];
        for (int i = 0; i < titleArr.length; i++) {
            cellArr[i] = i + ":30";
        }
        cellWidthList.add(cellArr);
        //导出
        String modelTime = param.get("modeltime").toString();
        String[] split = modelTime.split("-");
        modelTime = split[0] + "年" + split[1] + "月" + split[2] + "日";
        ExcelUtil.exportMultiSheetExcel07(response, modelTime + "逐小时预报.xlsx", titleList, dataList, cellWidthList);
    }


}

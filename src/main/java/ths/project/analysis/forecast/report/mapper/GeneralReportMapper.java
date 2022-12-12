package ths.project.analysis.forecast.report.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import ths.project.analysis.forecast.report.entity.GeneralReport;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface GeneralReportMapper extends BaseMapper<GeneralReport> {

    List<Map<String, Object>> queryDayTimeAxisListByMonth(Map<String, Object> paramMap);
    List<Map<String, Object>> queryWeekTimeAxisListByMonth(Map<String, Object> paramMap);
    List<Map<String, Object>> queryMonthTimeAxisListByYear(Map<String, Object> paramMap);

    Map<String, Object> queryStateNumber(Map<String, Object> paramMap);

    HashMap queryReport(Map<String, Object> paramMap);
}

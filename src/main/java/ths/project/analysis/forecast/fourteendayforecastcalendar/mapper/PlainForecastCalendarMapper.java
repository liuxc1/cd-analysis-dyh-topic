package ths.project.analysis.forecast.fourteendayforecastcalendar.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import ths.project.analysis.forecast.fourteendayforecastcalendar.entity.TBasModelwqDayRow;
import ths.project.analysis.forecast.numericalmodel.query.ForecastQuery;

import java.util.LinkedHashMap;
import java.util.List;

public interface PlainForecastCalendarMapper extends BaseMapper<TBasModelwqDayRow> {
    /**
     * 查询列表数据
     */
    List<TBasModelwqDayRow> getCalendarList(ForecastQuery query);
    /**
     * 查询预报excel数据
     */
    List<LinkedHashMap<String, Object>> getForecastExportData(ForecastQuery query);
}

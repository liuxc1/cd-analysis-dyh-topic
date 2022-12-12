package ths.project.analysis.forecast.numericalmodel.service;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ths.project.analysis.forecast.numericalmodel.entity.ModelwqDayRow;
import ths.project.analysis.forecast.numericalmodel.query.ForecastQuery;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * 未来14天预报service
 */
@Service
public class FourteenDaysForecastService {
    @Autowired
    private ModelwqDayRowService modelwqDayRowService;

    /**
     * 查询14天预报的echarts图
     * @param modelwqDayRowQuery
     * @return
     */
    public Map<String, Object> getEchartsData(ForecastQuery modelwqDayRowQuery) {
        Map<String,Object> result = new HashMap<String,Object>();
        modelwqDayRowQuery.setModelTime(modelwqDayRowQuery.getModelTime().substring(0,10)+" 00:00:00");
        List<ModelwqDayRow> list0 = modelwqDayRowService.getDateFromModelAndModelTime(modelwqDayRowQuery);
        modelwqDayRowQuery.setModelTime(modelwqDayRowQuery.getModelTime().substring(0,10)+" 12:00:00");
        List<ModelwqDayRow> list12 = modelwqDayRowService.getDateFromModelAndModelTime(modelwqDayRowQuery);
        result.put("list0",list0);
        result.put("list12",list12);
        return result;
    }
}

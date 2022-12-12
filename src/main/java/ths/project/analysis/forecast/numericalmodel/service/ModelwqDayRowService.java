package ths.project.analysis.forecast.numericalmodel.service;


import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ths.project.analysis.forecast.numericalmodel.entity.ModelwqDayRow;
import ths.project.analysis.forecast.numericalmodel.mapper.ModelwqDayRowMapper;
import ths.project.analysis.forecast.numericalmodel.query.ForecastQuery;
import ths.project.common.util.DateUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * 未来14天预报service
 */
@Service
public class ModelwqDayRowService {

    @Autowired
    private ModelwqDayRowMapper modelwqDayRowMapper;


    /**
     * 查询模型最大时间
     *
     * @return
     */
    public Map<String, Object> getMaxDate() {
        Map<String, Object> maxMonthMap = modelwqDayRowMapper.maxDate("CDAQS_MT", "510100000000", null);
        if (maxMonthMap != null && maxMonthMap.get("MAX_DATE") != null && !"".equals(maxMonthMap.get("MAX_DATE"))) {
            return maxMonthMap;
        }
        return null;
    }

    /**
     * 查询日期
     *
     * @return
     */
    public List<Map<String, Object>> getDayList(String month, String model) {
        if (StringUtils.isBlank(model)) {
            model = "CDAQS_MT";
        }
        Map<String, Object> maxMonthMap = modelwqDayRowMapper.maxDate(model, "510100000000", month);
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("pointCode", "510100000000");
        param.put("model", model);
        if (maxMonthMap != null && maxMonthMap.get("MAX_DATE") != null && !"".equals(maxMonthMap.get("MAX_DATE"))) {
            param.put("month", String.valueOf(maxMonthMap.get("MAX_DATE")).substring(0, 7));
            param.put("maxDate", maxMonthMap.get("MAX_DATE").toString().substring(0, 10));
        } else {
            param.put("month", month);
        }
        return modelwqDayRowMapper.getDayList(param);
    }

    /**
     * 通过时间，模型，行政区，站点，进行查询
     *
     * @param modelwqDayRowQuery
     * @return
     */
    public List<ModelwqDayRow> getDateFromModelAndModelTime(ForecastQuery modelwqDayRowQuery) {
        LambdaQueryWrapper<ModelwqDayRow> lambdaQueryWrapper = Wrappers.lambdaQuery();
        if (StringUtils.isNotBlank(modelwqDayRowQuery.getModel())) {
            lambdaQueryWrapper.eq(ModelwqDayRow::getModel, modelwqDayRowQuery.getModel());
        }
        if (StringUtils.isNotBlank(modelwqDayRowQuery.getModelTime())) {
            lambdaQueryWrapper.eq(ModelwqDayRow::getModeltime, modelwqDayRowQuery.getModelTime());
            lambdaQueryWrapper.gt(ModelwqDayRow::getResulttime, modelwqDayRowQuery.getModelTime());
            lambdaQueryWrapper.le(ModelwqDayRow::getResulttime, DateUtil.addDay(DateUtil.parse(modelwqDayRowQuery.getModelTime(), "yyyy-MM-dd"), modelwqDayRowQuery.getStep() == null ? 14 : modelwqDayRowQuery.getStep()));
        }
        if (StringUtils.isNotBlank(modelwqDayRowQuery.getPointCode())) {
            lambdaQueryWrapper.eq(ModelwqDayRow::getPointcode, modelwqDayRowQuery.getPointCode());
        }
        if (StringUtils.isNotBlank(modelwqDayRowQuery.getRegionCode())) {
            lambdaQueryWrapper.eq(ModelwqDayRow::getRegioncode, modelwqDayRowQuery.getRegionCode());
        }

        lambdaQueryWrapper.orderByAsc(ModelwqDayRow::getResulttime);
        return modelwqDayRowMapper.selectList(lambdaQueryWrapper);
    }

    /**
     * 获取行政区和点位数据
     *
     * @return
     */
    public Map<String, Object> getRegionAndPoint() {
        Map<String, Object> result = new HashMap<String, Object>();
        List<Map<String, Object>> region = modelwqDayRowMapper.getRegionPointList("1");
        List<Map<String, Object>> point = modelwqDayRowMapper.getRegionPointList("2");
        result.put("REGION", region);
        result.put("POINT", point);
        return result;
    }

}

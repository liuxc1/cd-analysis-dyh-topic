package ths.project.analysis.forecast.numericalmodel.service;

import com.baomidou.mybatisplus.core.conditions.AbstractLambdaWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ths.jdp.core.dao.base.Paging;
import ths.project.analysis.forecast.numericalmodel.entity.ForecastLog;
import ths.project.analysis.forecast.numericalmodel.mapper.ForecastLogMapper;
import ths.project.common.util.DateUtil;
import ths.project.system.base.util.PageSelectUtil;

import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;


/**
 * P预报日志
 * @date 2021年06月22日 15:35
 */
@Service
public class ForecastLogService {
    @Autowired
    private ForecastLogMapper forecastLogMapper;

    /**
     * 通过时间查询
     * @param logTimeStart
     * @param logTimeEnd
     * @return
     */
    public Paging<ForecastLog> getForecastLogFormLogTime(String logTimeStart, String logTimeEnd, Paging pageInfo) {
        AbstractLambdaWrapper wrappers = Wrappers.lambdaQuery(ForecastLog.class).ge(ForecastLog::getLogTime,logTimeStart).
                le(ForecastLog::getLogTime,logTimeEnd+" 23:59:59")
                .orderByDesc(ForecastLog::getLogTime);
        return PageSelectUtil.selectListPage(forecastLogMapper,pageInfo,wrappers);
    }

    /**
     * 查询数据最大时间
     * @return
     */
    public Map<String,Object> queryMaxLogTime() {
        return forecastLogMapper.queryMaxLogTime();
    }

    /**
     * 查询导出数据
     * @param forecastTimeStart
     * @param forecastTimeEnd
     * @return
     */
    public List<LinkedHashMap<String, Object>> getExportForecastLogFormLogTime(String forecastTimeStart, String forecastTimeEnd) {
        return forecastLogMapper.getExportForecastLogFormLogTime(forecastTimeStart,forecastTimeEnd);
    }
}

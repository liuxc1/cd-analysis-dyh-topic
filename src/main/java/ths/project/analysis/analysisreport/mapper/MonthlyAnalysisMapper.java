package ths.project.analysis.analysisreport.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import ths.project.analysis.analysisreport.entity.TMonthlyAnalysis;

import java.util.HashMap;

public interface MonthlyAnalysisMapper extends BaseMapper<TMonthlyAnalysis> {
    //获取去年指定时间数据
    TMonthlyAnalysis getLastYearData(HashMap yearDate);
    //获取指定时间数据
    TMonthlyAnalysis querySpecifiedTime(HashMap<String, Object> timeMap);
}

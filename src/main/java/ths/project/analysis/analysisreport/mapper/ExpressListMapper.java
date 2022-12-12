package ths.project.analysis.analysisreport.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;
import ths.project.analysis.analysisreport.entity.TNewsletterAnalysis;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface ExpressListMapper extends BaseMapper<TNewsletterAnalysis> {

    TNewsletterAnalysis selectOneByType(String ascriptionType);

    Map<String, Object> queryStateNumber(Map<String, Object> paramMap);

    List<Map<String, Object>> queryForecastListByMonth(Map<String, Object> paramMap);

    void updateReportState(Map<String, Object> paramMap);

    HashMap queryYesterdayData(@Param("yesterdayStartTime") String yesterdayStartTime, @Param("yesterdayEndTime") String yesterdayEndTime);

    HashMap queryReportTimeData(@Param("reportStartTime")String reportStartTime,@Param("reportEndTime")String reportEndTime);
}

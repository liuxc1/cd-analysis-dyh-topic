package ths.project.analysis.forecast.airforecastcity.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;
import ths.project.analysis.forecast.airforecastcity.entity.AnsFlowInfo;

import java.util.List;
import java.util.Map;

/**
 * @author lx
 * @date 2021年06月15日 14:10
 */
public interface AirForecastCityMapper extends BaseMapper<AnsFlowInfo> {
    /**
     *  获取value数据
     */

    List<Map<String, Object>> getForecastValueList(Map<String, Object> paramMap);


    Map<String, Object> getpollutantRange(@Param("type") String type, @Param("numMedian") int numMedian);

    List<Map<String, Object>> queryUserPhone(Map<String, Object> paramMap);
}

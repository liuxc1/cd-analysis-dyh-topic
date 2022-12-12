package ths.project.analysis.forecast.airforecastparition.mapper;



import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import ths.project.analysis.forecast.airforecastparition.entity.FlowArea24H;

import java.util.List;
import java.util.Map;


/**
 *
 */
public interface FlowArea24hMapper extends BaseMapper<FlowArea24H> {

    List<Map<String, Object>> getArea24hData(Map<String, Object> map);
}

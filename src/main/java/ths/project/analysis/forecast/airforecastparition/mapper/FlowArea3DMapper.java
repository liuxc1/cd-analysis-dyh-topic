package ths.project.analysis.forecast.airforecastparition.mapper;



import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import ths.project.analysis.forecast.airforecastparition.entity.FlowArea24H;
import ths.project.analysis.forecast.airforecastparition.entity.FlowArea3D;

import java.util.List;
import java.util.Map;


/**
 *
 */
public interface FlowArea3DMapper extends BaseMapper<FlowArea3D> {

    /**
     * 分区预报3天列表
     * @param map
     * @return
     */
    List<Map<String, Object>> getArea3DData(Map<String, Object> map);

    List<Map<String, Object>> list(Map<String, Object> paramMap);
}

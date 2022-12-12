package ths.project.analysis.forecast.airforecastparition.mapper;



import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import ths.project.analysis.forecast.airforecastparition.entity.FlowAreaInfo;

import java.util.List;
import java.util.Map;


/**
 *
 */
public interface FlowAreaInfoMapper extends BaseMapper<FlowAreaInfo> {

    /**
     * 获取成都市区县
     * @return
     */
    List<Map<String, Object>> getcountrys();

    /**
     * 获取用户
     * @return
     */
    List<Map<String, Object>> getCreateUser();

    /**
     * 分区预报信息
     * @param paramMap
     * @return
     */
    Map<String, Object> getForecastFlowInfo(Map<String, Object> paramMap);

    List<Map<String, Object>> getAreaTipsData(Map<String, Object> map);
}

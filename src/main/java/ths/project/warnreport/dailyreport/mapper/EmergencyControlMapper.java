package ths.project.warnreport.dailyreport.mapper;


import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import ths.project.warnreport.dailyreport.entity.EmergencyControl;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public interface EmergencyControlMapper extends BaseMapper<EmergencyControl> {

    /**
     * 查询日报数据，返回对象
     * @return
     */
    List<EmergencyControl> selectAllBydata();

    /**
     * 查询日报数据，返回map
     * @param param
     * @return
     */
    List<LinkedHashMap<String,Object>> selectAllBydataMap(Map<String, Object> param);
}

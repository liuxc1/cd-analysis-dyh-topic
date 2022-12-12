package ths.project.warnreport.dailyreport.mapper;


import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;
import ths.project.warnreport.dailyreport.entity.Management;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public interface ManagementMapper extends BaseMapper<Management> {

    /**
     * 根据行政区分类进行统计
     * @return
     */
    List<LinkedHashMap<String, Object>> getDataListForRegion(String dateTime);
    /**
     * 根据数据类型分类进行统计
     * @return
     */
    List<LinkedHashMap<String, Object>> getDataListForDataType(String dateTime);

    /**
     * 查询监测日数据
     * @param param
     * @return
     */
    List<Map<String, Object>> getAirData(Map<String,Object> param);

    /**
     * 查询三天预报数据
     * @param param
     * @return
     */
    List<Map<String, Object>> getForecast(Map<String,Object> param);
}

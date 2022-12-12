package ths.project.analysis.forecast.airforecastcheck.mapper;


import org.apache.ibatis.annotations.Param;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 城市预报核对
 */
public interface AirForecastCheakMapper {
    /**
     * 获取最新监测时间
     */
    Map<String, Object> queryMaxTime(@Param("isCd") String isCd);

    /**
     * 获取专家预报核对数据
     */
    List<Map<String, Object>> queryHumanForecastCheckData(Map<String, Object> paramMap);

    /**
     * 获取模型预报核对数据
     */
    List<Map<String, Object>> queryModelForecastCheckData(Map<String, Object> paramMap);

    /**
     * 获取个人预报核对数据
     */
    List<Map<String, Object>> queryPersonForecastCheckData(Map<String, Object> paramMap);

    /**
     * 根据step查询预报以及实测的平均值(专家、个人)
     *
     * @param paramMap
     * @return
     */
    List<Map<String, Object>> queryPersonAvgData(Map<String, Object> paramMap);

    /**
     * 专家评估--平均每天（step）预报人数
     *
     * @param paramMap
     * @return
     */
    List<Map<String, Object>> queryAvgPerson(Map<String, Object> paramMap);

    /**
     * 获取专家预报表格数据
     */
    List<Map<String, Object>> queryHumanForecastTableData(Map<String, Object> paramMap);

    /**
     * 根据step查询预报以及实测的平均值(模型预报)
     *
     * @param paramMap
     * @return
     */
    List<Map<String, Object>> queryModelAvgData(Map<String, Object> paramMap);
    /**
     * 获取模型预报表格数据
     */
    List<Map<String, Object>> queryModelForecastTableData(Map<String, Object> paramMap);

    /**
     * 获取个人预报表格数据
     */
    List<Map<String, Object>> queryPersonForecastTableData(Map<String, Object> paramMap);


    /**
     * 获取预报模式类型
     */
    List<Map<String, Object>> getForecastModel();

    /**
     * 查询用户
     *
     * @deprecated 可用GeneralReportService根据归属id和类型代替查询
     */
    List<Map<String, Object>> getForecastUser(Map<String, Object> map);


    /**
     * 区县预报
     * @param param
     * @return
     */
    List<LinkedHashMap<String, Object>> getForecastCountyTableData(Map<String, Object> param);
}

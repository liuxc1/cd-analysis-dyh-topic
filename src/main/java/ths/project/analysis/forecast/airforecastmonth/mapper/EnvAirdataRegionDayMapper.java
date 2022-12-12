package ths.project.analysis.forecast.airforecastmonth.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;
import ths.project.analysis.forecast.airforecastmonth.entity.EnvAirdataRegionDay;

import java.util.List;
import java.util.Map;

/**
 * 监测数据_区域日报数据表(EnvAirdataRegionDay)表数据库访问层
 *
 * @author makejava
 * @since 2021-04-12 14:26:56
 */
public interface EnvAirdataRegionDayMapper extends BaseMapper<EnvAirdataRegionDay> {

    /**
     * 通过ID查询单条数据
     *
     * @param monitorTime 主键
     * @return 实例对象
     */
    List<EnvAirdataRegionDay> queryMonthById(@Param("monitorTime") String monitorTime,@Param("codeRegion") String codeRegion);

    /**
     * 新增数据
     *
     * @param EnvAirdataRegionDay 实例对象
     * @return 影响行数
     */
    int insert(EnvAirdataRegionDay EnvAirdataRegionDay);

    /**
     * 修改数据
     *
     * @param EnvAirdataRegionDay 实例对象
     * @return 影响行数
     */
    int update(EnvAirdataRegionDay EnvAirdataRegionDay);

    /**
     * 通过主键删除数据
     *
     * @param monitortime 主键
     * @return 影响行数
     */
    int deleteById(String monitortime,String codeRegion);

    Map<String, Object> countNumAndAvg( @Param("startTime") String startTime, @Param("endTime")String endTime);

    List<EnvAirdataRegionDay> selectListByTime(@Param("startTime") String startTime, @Param("endTime")String endTime);
}
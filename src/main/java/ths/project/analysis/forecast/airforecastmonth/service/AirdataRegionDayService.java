package ths.project.analysis.forecast.airforecastmonth.service;

import ths.project.analysis.forecast.airforecastmonth.mapper.EnvAirdataRegionDayMapper;
import ths.project.analysis.forecast.airforecastmonth.entity.EnvAirdataRegionDay;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.List;

/**
 * 监测数据_区域日报数据表(AirdataRegionDay)表服务实现类
 *
 * @author makejava
 * @since 2021-04-12 14:34:56
 */
@Service("AirdataRegionDayService")
public class AirdataRegionDayService {
    @Resource
    private EnvAirdataRegionDayMapper envAirdataRegionDayMapper;

    /**
     * 通过ID查询当月单条数据
     *
     * @param monitorTime 主键
     * @return 实例对象
     */
    public List<EnvAirdataRegionDay> queryMonthById(String  monitorTime,String codeRegion) {
        return this.envAirdataRegionDayMapper.queryMonthById(monitorTime,codeRegion);
    }

    /**
     * 新增数据
     *
     * @param envAirdataRegionDay 实例对象
     * @return 实例对象
     */
    public EnvAirdataRegionDay insert(EnvAirdataRegionDay envAirdataRegionDay) {
        this.envAirdataRegionDayMapper.insert(envAirdataRegionDay);
        return envAirdataRegionDay;
    }

    /**
     * 修改数据
     *
     * @param envAirdataRegionDay 实例对象
     * @return 实例对象
     */
    public EnvAirdataRegionDay update(EnvAirdataRegionDay envAirdataRegionDay) {
        this.envAirdataRegionDayMapper.update(envAirdataRegionDay);
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        return this.queryMonthById(format.format(envAirdataRegionDay.getMonitorTime()),envAirdataRegionDay.getCodeRegion()).get(0);
    }

    /**
     * 通过主键删除数据
     *
     * @param monitortime 主键
     * @return 是否成功
     */
    public boolean deleteById(String monitortime,String codeRegion) {
        return this.envAirdataRegionDayMapper.deleteById(monitortime,codeRegion) > 0;
    }
}
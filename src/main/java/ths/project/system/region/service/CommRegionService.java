package ths.project.system.region.service;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import ths.project.system.region.entity.CommRegion;
import ths.project.system.region.mapper.CommRegionMapper;

import java.util.List;

@Service
public class CommRegionService {

    @Autowired
    private CommRegionMapper commRegionMapper;

    @Cacheable("JDP.PROJECT")
    public CommRegion getRegion(String regionCode) {
        CommRegion commRegion = commRegionMapper.selectById(regionCode);
        return commRegion;
    }

    /**
     * 查询当前区县所属部门
     */
    public List<CommRegion> getRegionList(String regionType,String parentCode) {
        return  commRegionMapper.selectList(Wrappers.lambdaQuery(CommRegion.class)
                .eq( CommRegion::getRegionType,regionType)
                .eq(CommRegion::getParentCode,parentCode)
        );
    }


}

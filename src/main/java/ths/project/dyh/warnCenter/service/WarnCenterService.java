package ths.project.dyh.warnCenter.service;

import org.springframework.stereotype.Service;
import ths.jdp.core.service.base.BaseService;

import java.util.List;
import java.util.Map;

/**
 * @ClassName WarnCenterService
 * @Description TODO
 * @Author ZT
 * @Date 2021/10/12 11:06
 * @Version 1.0
 **/
@Service
public class WarnCenterService extends BaseService {
    private final String sqlPackage = "ths.project.dyh.consultation.mapper.WarnCenterMapper.";

    /**
     * @Author ZT
     * @Description 查询列表数据
     * @Date 11:15 2021/10/12
     * @Param [paramMap]
     * @return java.util.List<java.util.Map<java.lang.String,java.lang.Object>>
     **/
    public List<Map<String ,Object>> listTable(Map<String ,Object> paramMap){
        return dao.list(paramMap,sqlPackage+"listTable");
    }
}

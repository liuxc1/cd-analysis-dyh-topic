package ths.project.asses.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;
import ths.project.analysis.forecast.airforecastcity.entity.AnsFlowInfo;
import ths.project.asses.entity.AssessEmission;

import java.util.List;
import java.util.Map;


public interface AssessEmissionMapper extends BaseMapper<AssessEmission> {
    Map<String, Object> getRate(AssessEmission assessEmission);
}

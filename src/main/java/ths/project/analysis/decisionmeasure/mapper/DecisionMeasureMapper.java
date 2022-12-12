package ths.project.analysis.decisionmeasure.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import ths.project.analysis.decisionmeasure.entity.WarnControlInfo;
import ths.project.analysis.decisionmeasure.vo.WarnControlVo;

import java.util.List;
import java.util.Map;

/**
 * @author lx
 * @date 2021年11月22日 10:12
 */
public interface DecisionMeasureMapper extends BaseMapper<WarnControlInfo> {
    /**
     * 查询报告信息
     * @param paramMap
     * @return
     */
    Map<String, Object> getReportInfoByAscriptionType(Map<String, Object> paramMap);

    /**
     * 查询最新年份
     * @param paramMap
     * @return
     */
    Map<String, String> getNewestDate(Map<String, Object> paramMap);

    List<WarnControlVo>  queryReportList(Map<String, Object> paramMap);
}

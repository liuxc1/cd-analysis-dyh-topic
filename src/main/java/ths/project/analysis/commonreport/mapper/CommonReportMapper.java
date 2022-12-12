package ths.project.analysis.commonreport.mapper;

import ths.project.analysis.commonreport.vo.SamllTypeVo;
import ths.project.analysis.commonreport.vo.CommonReportVo;

import java.util.List;
import java.util.Map;

/**
 * @author lx
 * @date 2021年11月22日 10:12
 */
public interface CommonReportMapper {
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

    /**
     * 获取报告列表
     * @param paramMap
     * @return
     */
    List<CommonReportVo>  queryReportList(Map<String, Object> paramMap);

    /**
     * 获取所有小类
     * @return
     */
    List<SamllTypeVo> getSmallType(Map<String, Object> paramMap);
}

package ths.project.analysis.forecast.airforecastcity.mapper;

import java.util.List;
import java.util.Map;

/**
 * 分析平台短信发送
 */
public interface AnalysisSendMessageMapper {
    /**
     * 根据类型获取短信联系人信息
     *
     * @param paramMap 类型参数
     * @return 短信联系人信息
     */
    List<Map<String, Object>> queryUserPhone(Map<String, Object> paramMap);
}

package ths.project.api.eventHub.mapper;

import java.util.List;
import java.util.Map;

public interface WarnEventHubMapper {

    /**
     * 查询预警开始/结束时推送的数据
     * @param param
     * @return
     */
    List<Map<String, Object>> queryWarnInfo(Map<String, Object> param);

    /**
     * 查询预警结束前的工单号
     * @param param
     * @return
     */
    List<Map<String, Object>> queryWarnHandleInfo(Map<String, Object> param);
}

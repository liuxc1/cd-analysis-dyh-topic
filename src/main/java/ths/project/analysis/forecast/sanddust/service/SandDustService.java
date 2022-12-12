package ths.project.analysis.forecast.sanddust.service;

import org.springframework.stereotype.Service;
import ths.project.analysis.forecast.sanddust.mapper.ISandDustMapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class SandDustService {

    private final ISandDustMapper sandDustMapper;

    public SandDustService(ISandDustMapper sandDustMapper) {
        this.sandDustMapper = sandDustMapper;
    }

    public List<Map<String, Object>> getForecastDateList(String month) {
        Map<String, Object> maxDate = this.sandDustMapper.getMaxDate(month);
        if (null == maxDate || maxDate.isEmpty()) {
            maxDate = new HashMap<>();
            maxDate.put("MAX_MONTH", month);
        }
        return this.sandDustMapper.getForecastDateList(maxDate);
    }


    public Map<String, Object> getRegionList() {
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("REGION", sandDustMapper.getRegionList());
        return resultMap;
    }

    public List<Map<String, Object>> getDustForecastDataList(Map<String, Object> queryParam) {

        return sandDustMapper.getDustForecastDataList(queryParam);
    }

}

package ths.project.analysis.airqualitystatus.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ths.project.analysis.airqualitystatus.mapper.AirQualityStatusMapper;

import java.util.Map;

/**
 * 空气质量现状
 *
 * @date 2021年09月09日 11:40
 */
@Service
public class AirQualityStatusService {

    @Autowired
    private AirQualityStatusMapper airQualityStatusMapper;

    /**
     * 查询实况数据最新时间
     *
     * @return
     */
    public Map<String, String> getMaxDate() {
        return airQualityStatusMapper.queryMaxDate();
    }
}

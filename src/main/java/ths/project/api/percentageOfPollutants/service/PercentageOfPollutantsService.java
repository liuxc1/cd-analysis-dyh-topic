package ths.project.api.percentageOfPollutants.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ths.project.api.percentageOfPollutants.entity.PercentageOfPollutants;
import ths.project.api.percentageOfPollutants.entity.PercentageOfPollutantsNumber;
import ths.project.api.percentageOfPollutants.mapper.PercentageOfPollutantsMapper;

import java.util.List;
import java.util.Map;

@Service
public class PercentageOfPollutantsService {

    @Autowired
    private PercentageOfPollutantsMapper percentageOfPollutantsMapper;

    public List<PercentageOfPollutants> queryPercentageOfPollutants(Map<String, Object> param) {
        return percentageOfPollutantsMapper.queryPercentageOfPollutants(param);
    }

    public List<PercentageOfPollutantsNumber> queryPercentageOfPollutantsNumber(Map<String, Object> param) {
        return percentageOfPollutantsMapper.queryPercentageOfPollutantsNumber(param);
    }

    public List<PercentageOfPollutants> queryExceededDays(Map<String, Object> param) {
        return percentageOfPollutantsMapper.queryExceededDays(param);
    }
}

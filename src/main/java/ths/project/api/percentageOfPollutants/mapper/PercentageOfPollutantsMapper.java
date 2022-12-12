package ths.project.api.percentageOfPollutants.mapper;

import ths.project.api.percentageOfPollutants.entity.PercentageOfPollutants;
import ths.project.api.percentageOfPollutants.entity.PercentageOfPollutantsNumber;

import java.util.List;
import java.util.Map;

public interface PercentageOfPollutantsMapper {

    List<PercentageOfPollutants> queryPercentageOfPollutants(Map<String, Object> param);

    List<PercentageOfPollutantsNumber> queryPercentageOfPollutantsNumber(Map<String, Object> param);

    List<PercentageOfPollutants> queryExceededDays(Map<String, Object> param);
}

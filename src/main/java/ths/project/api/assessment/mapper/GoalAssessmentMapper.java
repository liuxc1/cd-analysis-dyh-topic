package ths.project.api.assessment.mapper;

import ths.project.api.assessment.entity.GoalAssessment;

import java.util.List;
import java.util.Map;

public interface GoalAssessmentMapper {
    /**
     * 本季度优良率
     * @return
     */
    List<GoalAssessment> queryQuarterlyGoalAssessment(Map<String,Object> param);
    /**
     * 本年优良率
     * @return
     */
    List<GoalAssessment> queryYearGoalAssessment();

    /**
     * 本月优良率
     * @return
     */
    List<GoalAssessment> queryMonthGoalAssessment();
}

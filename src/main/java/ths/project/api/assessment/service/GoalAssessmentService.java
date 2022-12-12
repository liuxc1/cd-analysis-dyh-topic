package ths.project.api.assessment.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ths.project.api.assessment.entity.GoalAssessment;
import ths.project.api.assessment.mapper.GoalAssessmentMapper;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * 查询本月、本季度、本年和去年的优良率对比
 */
@Service
public class GoalAssessmentService {

    @Autowired
    private GoalAssessmentMapper goalAssessmentMapper;

    /**
     * 计算季度数据
     *
     * @return
     */
    public List<GoalAssessment> queryQuarterlyGoalAssessment(Map<String, Object> param) {
        List<GoalAssessment> goalAssessments = goalAssessmentMapper.queryQuarterlyGoalAssessment(param);
        calculateRiseOrFall(goalAssessments);
        return goalAssessments;
    }



    /**
     * 计算季度数据
     *
     * @return
     */
    public List<GoalAssessment> queryYearGoalAssessment() {
        List<GoalAssessment> goalAssessments = goalAssessmentMapper.queryYearGoalAssessment();
        calculateRiseOrFall(goalAssessments);
        return goalAssessments;
    }

    /**
     * 计算季度数据
     *
     * @return
     */
    public List<GoalAssessment> queryMonthGoalAssessment() {
        List<GoalAssessment> goalAssessments = goalAssessmentMapper.queryMonthGoalAssessment();
        calculateRiseOrFall(goalAssessments);
        return goalAssessments;
    }


    /**
     * 计算上升或者下降率
     */
    private static void calculateRiseOrFall(List<GoalAssessment> goalAssessments) {
        /**
         * 如果b>a,上升的百分数=[(b-a)/a]*100%;
         * 如果a>b,下降的百分数=[(a-b)/a]*100%.
         */
        //计算年pm25&o3上升或者下降
        GoalAssessment goalAssessment = goalAssessments.get(0);
        //计算季度pm25&o3上升或者下降
        if (goalAssessment.getPm25().compareTo(goalAssessment.getOldPm25()) > -1) {
            goalAssessment.setPm25Rise((goalAssessment.getPm25().subtract(goalAssessment.getOldPm25()).divide(BigDecimal.valueOf(1), 2, BigDecimal.ROUND_HALF_DOWN)));
        } else if (goalAssessment.getPm25().compareTo(goalAssessment.getOldPm25()) == -1) {
            goalAssessment.setPm25Fall(goalAssessment.getOldPm25().subtract(goalAssessment.getPm25()).divide(BigDecimal.valueOf(1), 2, BigDecimal.ROUND_HALF_DOWN));
        }
        if (goalAssessment.getO3().compareTo(goalAssessment.getOldO3()) > -1) {
            goalAssessment.setO3Rise(goalAssessment.getO3().subtract(goalAssessment.getOldO3()).divide(BigDecimal.valueOf(1), 2, BigDecimal.ROUND_HALF_DOWN));
        } else if (goalAssessment.getO3().compareTo(goalAssessment.getOldO3()) == -1) {
            goalAssessment.setO3Fall(goalAssessment.getOldO3().subtract(goalAssessment.getO3()).divide(BigDecimal.valueOf(1), 2, BigDecimal.ROUND_HALF_DOWN));
        }
    }
}

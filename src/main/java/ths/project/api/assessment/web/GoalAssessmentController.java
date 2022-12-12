package ths.project.api.assessment.web;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import ths.project.api.assessment.service.GoalAssessmentService;
import ths.project.common.data.DataResult;

import java.util.Map;

/**
 * 目标评估
 */
@RequestMapping("/api/goalAssessment")
@Controller
public class GoalAssessmentController {

    @Autowired
    private GoalAssessmentService goalAssessmentService;

    /**
     * 查询本季度的评估
     *
     * @param param String QUARTERLY 本季度 2021-1(2021年1季度)
     *              String OLDQUARTERLY 去年本季度 2020-1(2020年1季度)
     * @return DataResult
     */
    @RequestMapping("/queryQuarterlyGoalAssessment")
    @ResponseBody
    public DataResult queryQuarterlyGoalAssessment(@RequestParam Map<String, Object> param) {
        return DataResult.success(goalAssessmentService.queryQuarterlyGoalAssessment(param));
    }

    /**
     * 查询本年的目标考核
     *
     * @return DataResult
     */
    @RequestMapping("/queryYearGoalAssessment")
    @ResponseBody
    public DataResult queryYearGoalAssessment() {
        return DataResult.success(goalAssessmentService.queryYearGoalAssessment());
    }

    /**
     * 查询本年的目标考核
     *
     * @return DataResult
     */
    @RequestMapping("/queryMonthGoalAssessment")
    @ResponseBody
    public DataResult queryMonthGoalAssessment() {


        return DataResult.success(goalAssessmentService.queryMonthGoalAssessment());
    }

    public static class Demo {
        public static void main(String[] args) {
            Thread t=new Thread(){
                public void run(){
                    pong();
                }
            };
            t.run();
            System.out.println("ping");
        }

        public static void pong(){
            System.out.println("pong");
        }

    }

}

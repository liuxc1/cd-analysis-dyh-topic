package ths.project.api.rankingEvaluation.web;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import ths.project.common.data.DataResult;
import ths.project.api.rankingEvaluation.service.RankingEvaluationService;

import java.util.Map;

@RequestMapping("/api/rankingEvaluation")
@Controller
public class RankingEvaluationController {

    @Autowired
    private RankingEvaluationService rankingEvaluationService;

    /**
     * 成都市全国排名
     */
    @RequestMapping("/queryRankingEvaluationInCd")
    @ResponseBody
    public DataResult queryRankingEvaluationInCd(@RequestParam Map<String, Object> param) {
        return DataResult.success(rankingEvaluationService.queryRankingEvaluationInCd(param));
    }


    /**
     * 重点区域排名
     *
     * @param param QUERYTYPE （ACC_MONTH查询年、CUR_MONTH查询月、CUR_QUARTERLY查询季度）
     * @return DataResult
     */
    @RequestMapping("/queryRankingEvaluation")
    @ResponseBody
    public DataResult queryRankingEvaluation(@RequestParam Map<String, Object> param) {
        return DataResult.success(rankingEvaluationService.queryRankingEvaluation(param));
    }



    /**
     * 区县排名
     * @param param QUERYTYPE （ACC_MONTH查询年、CUR_MONTH查询月、CUR_QUARTERLY查询季度）
     * @return DataResult
     */
    @RequestMapping("/queryDistrictRankingEvaluation")
    @ResponseBody
    public DataResult queryDistrictRankingEvaluation(@RequestParam Map<String, Object> param) {
        return DataResult.success(rankingEvaluationService.queryDistrictRankingEvaluation(param));
    }
}

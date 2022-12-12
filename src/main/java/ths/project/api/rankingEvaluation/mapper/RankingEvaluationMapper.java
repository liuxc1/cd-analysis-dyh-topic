package ths.project.api.rankingEvaluation.mapper;

import ths.project.api.rankingEvaluation.entity.RankingEvaluation;

import java.util.List;
import java.util.Map;

public interface RankingEvaluationMapper {
    /**
     * 重点区域排名
     *
     * @param param
     * @return
     */
    List<RankingEvaluation> queryRankingEvaluation(Map<String, Object> param);


    /**
     * 区县排名
     *
     * @param param
     * @return
     */
    List<RankingEvaluation> queryDistrictRankingEvaluation(Map<String, Object> param);

    /**
     * 成都全国排名
     * @param param
     * @return
     */
    List<RankingEvaluation> queryRankingEvaluationInCd(Map<String, Object> param);
}


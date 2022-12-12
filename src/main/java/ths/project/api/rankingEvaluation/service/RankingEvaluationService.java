package ths.project.api.rankingEvaluation.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ths.project.api.rankingEvaluation.entity.RankingEvaluation;
import ths.project.api.rankingEvaluation.mapper.RankingEvaluationMapper;

import java.util.List;
import java.util.Map;

@Service
public class RankingEvaluationService {

    @Autowired
    private RankingEvaluationMapper rankingEvaluationMapper;

    /**
     * 成都市排名、重点区域排名
     *
     * @param param
     * @return
     */
    public List<RankingEvaluation> queryRankingEvaluation(Map<String, Object> param) {
        return rankingEvaluationMapper.queryRankingEvaluation(param);
    }

    /**
     * 区县排名
     *
     * @param param
     * @return
     */
    public List<RankingEvaluation> queryDistrictRankingEvaluation(Map<String, Object> param) {
        return rankingEvaluationMapper.queryDistrictRankingEvaluation(param);
    }

    public List<RankingEvaluation> queryRankingEvaluationInCd(Map<String, Object> param) {
        return rankingEvaluationMapper.queryRankingEvaluationInCd(param);
    }
}

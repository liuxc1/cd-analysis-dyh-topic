package ths.project.analysis.forecast.ensembleprediction.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import ths.project.analysis.forecast.ensembleprediction.service.EnsemblePredictionService;
import ths.project.service.common.vo.DataResult;

import java.util.Map;

/**
 * 集合预报
 */
@Controller
@RequestMapping("/analysis/air/ensemblePrediction")
public class EnsemblePredictionController {

    private final EnsemblePredictionService ensemblePredictionService;

    public EnsemblePredictionController(EnsemblePredictionService ensemblePredictionService) {
        this.ensemblePredictionService = ensemblePredictionService;
    }

    @RequestMapping("/index")
    public String index() {

        return "/analysis/forecast/ensembleprediction/ensemblePrediction_index";
    }

    @ResponseBody
    @RequestMapping("/getForecastDataList")
    public DataResult<Map<String, Object>> getForecastDataList(@RequestParam Map<String, Object> paramMap) {

        return new DataResult<Map<String, Object>>().success(ensemblePredictionService.getForecastDataList(paramMap));
    }
}

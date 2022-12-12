package ths.project.api.analysissanddustforecast.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import ths.project.api.analysissanddustforecast.service.AnalysisSandDustForecastService;
import ths.project.common.data.DataResult;

/**
 * 沙尘预报解析接口
 */
@Controller
@RequestMapping("/api/analysisSandDustForecast")
public class AnalysisSandDustForecastController {

    private final AnalysisSandDustForecastService analysisSandDustForecastService;

    public AnalysisSandDustForecastController(AnalysisSandDustForecastService analysisSandDustForecastService) {
        this.analysisSandDustForecastService = analysisSandDustForecastService;
    }

    @ResponseBody
    @RequestMapping("/analysis")
    public DataResult analysis(String modelTime) {
        try {
            this.analysisSandDustForecastService.parsingStart(modelTime);
            return DataResult.success();
        } catch (InterruptedException e) {
            e.printStackTrace();
            return DataResult.failure();
        }
    }

}

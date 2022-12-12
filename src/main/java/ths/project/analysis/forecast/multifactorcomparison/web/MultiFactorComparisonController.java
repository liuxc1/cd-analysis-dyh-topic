package ths.project.analysis.forecast.multifactorcomparison.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import ths.project.analysis.forecast.multifactorcomparison.service.MultiFactorComparisonService;
import ths.project.analysis.forecast.numericalmodel.query.ForecastQuery;
import ths.project.common.vo.ResponseVo;

/**
 * 预报多要素对比
 */
@Controller
@RequestMapping("/analysis/forecast/multiFactorComparison")
public class MultiFactorComparisonController {

    private final MultiFactorComparisonService multiFactorComparisonService;

    public MultiFactorComparisonController(MultiFactorComparisonService multiFactorComparisonService) {
        this.multiFactorComparisonService = multiFactorComparisonService;
    }

    @RequestMapping("/index")
    public String index() {

        return "/analysis/forecast/multifactorcomparison/multifactorcomparison_index";
    }

    /**
     * 获取污染信息
     */
    @RequestMapping("/getPollutes")
    @ResponseBody
    public ResponseVo getPollutes() {
        ResponseVo responseVo = new ResponseVo();

        return responseVo.success(multiFactorComparisonService.getPollutes());
    }

    /**
     * 查询模型预报数据
     */
    @ResponseBody
    @RequestMapping("/getModelForcatsData")
    public ResponseVo getModelForcatsData(ForecastQuery forecastQuery) {
        ResponseVo responseVo = new ResponseVo();

        return responseVo.success(multiFactorComparisonService.getModelForcatsData(forecastQuery));
    }


}

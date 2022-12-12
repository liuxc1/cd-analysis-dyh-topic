package ths.project.api.percentageOfPollutants.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import ths.project.common.data.DataResult;
import ths.project.api.percentageOfPollutants.service.PercentageOfPollutantsService;

import java.util.Map;

/**
 * 首页-污染物占比（成都市）
 */
@RequestMapping("/api/percentageOfPollutants")
@Controller
public class PercentageOfPollutantsController {

    @Autowired
    private PercentageOfPollutantsService percentageOfPollutantsService;

    /**
     * 综合指数占比
     *
     * @param param QUERYTYPE （year查询年、month查询月、quarterly查询季度）
     * @return DataResult
     */
    @RequestMapping("/queryPercentageOfPollutants")
    @ResponseBody
    public DataResult queryPercentageOfPollutants(@RequestParam Map<String, Object> param) {
        return DataResult.success(percentageOfPollutantsService.queryPercentageOfPollutants(param));
    }

    /**
     * 综合指数占比值
     */
    @RequestMapping("/queryPercentageOfPollutantsNumber")
    @ResponseBody
    public DataResult queryPercentageOfPollutantsNumber(@RequestParam Map<String, Object> param) {
        return DataResult.success(percentageOfPollutantsService.queryPercentageOfPollutantsNumber(param));
    }


    /**
     * 超标天数占比
     * @param param QUERYTYPE （year查询年、month查询月、quarterly查询季度）
     * @return DataResult
     */
    @RequestMapping("/queryExceededDays")
    @ResponseBody
    public DataResult queryExceededDays(@RequestParam Map<String, Object> param) {
        return DataResult.success(percentageOfPollutantsService.queryExceededDays(param));
    }
}

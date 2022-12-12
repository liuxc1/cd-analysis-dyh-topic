package ths.project.analysis.forecast.sanddust.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import ths.project.analysis.forecast.sanddust.service.SandDustService;
import ths.project.service.common.vo.DataResult;

import java.util.List;
import java.util.Map;

/**
 * 沙尘预报趋势图
 */
@Controller
@RequestMapping("/analysis/air/sandDust")
public class SandDustController {

    private final SandDustService sandDustService;

    public SandDustController(SandDustService sandDustService) {
        this.sandDustService = sandDustService;
    }

    @RequestMapping("/index")
    public String index() {

        return "/analysis/forecast/sanddust/sanddust_index";
    }

    @RequestMapping("/integration")
    public String integration() {

        return "/analysis/forecast/sanddust/sanddust_integration";
    }

    @ResponseBody
    @RequestMapping("/getForecastDateList")
    public DataResult<List<Map<String, Object>>> getForecastDateList(String month) {

        return new DataResult<List<Map<String, Object>>>().success(sandDustService.getForecastDateList(month));
    }

    @ResponseBody
    @RequestMapping("/getRegionList")
    public DataResult<Map<String, Object>> getRegionList() {

        return new DataResult<Map<String, Object>>().success(sandDustService.getRegionList());
    }

    @ResponseBody
    @RequestMapping("/getDustForecastDataList")
    public DataResult<List<Map<String, Object>>> getDustForecastDataList(@RequestParam Map<String, Object> paramMap) {

        return new DataResult<List<Map<String, Object>>>().success(sandDustService.getDustForecastDataList(paramMap));
    }

}

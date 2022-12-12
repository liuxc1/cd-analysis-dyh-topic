package ths.project.analysis.forecast.numericalmodel.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import ths.project.analysis.forecast.numericalmodel.service.ModelwqDayRowService;
import ths.project.common.data.DataResult;

@Controller
@RequestMapping("/analysis/air/modelwqDayRow")
public class ModelwqDayRowController {

    @Autowired
    private ModelwqDayRowService modelwqDayRowService;
    /**
     * 查询14天预报页面的最新月的每天数据情况
     * @return
     */
    @RequestMapping("/getDayList")
    @ResponseBody
    public DataResult getDayList(String  month,String model) {
        return DataResult.success(modelwqDayRowService.getDayList(month,model));
    }


    /**
     * 获取行政区和点位数据
     * @return
     */
    @RequestMapping("/getRegionAndPoint")
    @ResponseBody
    public DataResult getRegionAndpoint() {
        return DataResult.success(modelwqDayRowService.getRegionAndPoint());
    }
}

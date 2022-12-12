package ths.project.api.digitalModel.web;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import ths.project.common.data.DataResult;
import ths.project.api.digitalModel.service.DigitalModelService;


@RequestMapping("/api/digitalModel")
@Controller
public class DigitalModelController {

    @Autowired
    private DigitalModelService digitalModelService;

    /**
     * 科学分析平台首页-数字模型预报
     * @return DataResult
     */
    @RequestMapping("/queryDigitalModel")
    @ResponseBody
    public DataResult queryRankingEvaluation() {
        return DataResult.success(digitalModelService.queryDigitalModel());
    }
}

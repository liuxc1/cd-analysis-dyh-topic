package ths.project.api.satelliteRemoteSensing.web;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import ths.project.common.data.DataResult;
import ths.project.api.satelliteRemoteSensing.service.SatelliteRemoteSensingService;

@RequestMapping("/api/satelliteRemoteSensing")
@Controller
public class SatelliteRemoteSensingController {

    @Autowired
    private SatelliteRemoteSensingService satelliteRemoteSensingService;

    /**
     * 科学分析平台首页-卫星遥感监测&沙尘预报S
    */
    @RequestMapping("/querySatelliteRemoteSensing")
    @ResponseBody
    public DataResult queryRankingEvaluation() {
        return DataResult.success(satelliteRemoteSensingService.querySatelliteRemoteSensing());
    }
}

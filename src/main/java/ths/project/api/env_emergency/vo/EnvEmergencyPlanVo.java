package ths.project.api.env_emergency.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * @author:Toledo
 * @date:2021/3/22 16:28
 * @descripthion:
 **/
@Data
@ApiModel("应急预案统计")
public class EnvEmergencyPlanVo {

    @ApiModelProperty("企业应急预案总数 ")
    private double enterprise;

    @ApiModelProperty("自然灾害事件")
    private double naturalDisasters;
    @ApiModelProperty("事故灾害事件")
    private double accidentDisasters;
    @ApiModelProperty("公共卫生事件")
    private double publicDisasters;
    @ApiModelProperty("社会安全事件")
    private double socialDisasters;

    @ApiModelProperty("综合")
    private double comprehensive;
    @ApiModelProperty("土壤污染事件")
    private double soilPollution;
    @ApiModelProperty("火灾爆炸事故")
    private double fireExplosion;
    @ApiModelProperty("交通事故")
    private double  trafficAccident;
    @ApiModelProperty("饮用水源保护区污染事件")
    private double drinkingWater;

}

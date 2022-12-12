package ths.project.api.env_emergency.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * @author:Toledo
 * @date:2021/3/22 16:24
 * @descripthion:
 **/
@Data
@ApiModel("应急基础")
public class EnvEmergencyPlanBase {

    @ApiModelProperty("自然灾害事件")
    private double naturalDisasters;
    @ApiModelProperty("事故灾害事件")
    private double accidentDisasters;
    @ApiModelProperty("公共卫生事件")
    private double publicDisasters;
    @ApiModelProperty("社会安全事件")
    private double socialDisasters;

}

package ths.project.api.env_emergency.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * @author:Toledo
 * @date:2021/3/22 16:43
 * @descripthion:
 **/
@Data
@ApiModel("近污染应急事件统计")
public class EnvBeforEmergencyVo   {

    @ApiModelProperty(value = "近五年总事件")
    private Integer total;
    @ApiModelProperty(value = "今年总事件")
    private Integer nowTotal;

    @ApiModelProperty("自然灾害事件")
    private double naturalDisasters;
    @ApiModelProperty("事故灾害事件")
    private double accidentDisasters;
    @ApiModelProperty("公共卫生事件")
    private double publicDisasters;
    @ApiModelProperty("社会安全事件")
    private double socialDisasters;

    public EnvBeforEmergencyVo(Integer total, Integer nowTotal, double naturalDisasters, double accidentDisasters, double publicDisasters, double socialDisasters) {
        this.total = total;
        this.nowTotal = nowTotal;
        this.naturalDisasters = naturalDisasters;
        this.accidentDisasters = accidentDisasters;
        this.publicDisasters = publicDisasters;
        this.socialDisasters = socialDisasters;
    }
}

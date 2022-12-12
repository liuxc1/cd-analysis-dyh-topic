package ths.project.api.env_emergency.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * @author:Toledo
 * @date:2021/3/9 10:21
 * @descripthion:
 **/
@ApiModel(value = "风险企业统计")
@Data
public class EnvRiseVo {

    @ApiModelProperty(value = "总数")
    private Integer allTotal;
    @ApiModelProperty(value = "一般")
    private Integer fourThLevel;
    @ApiModelProperty(value = "较大")
    private Integer thirdLevel;
    @ApiModelProperty(value = "重大")
    private Integer secondLevel;
    @ApiModelProperty(value = "特别重大")
    private Integer firstLevel;

    @ApiModelProperty(value = "涉气数量")
    private Integer gasNum;
    @ApiModelProperty(value = "涉水数量")
    private Integer waterNum;
    @ApiModelProperty(value = "同时涉气和涉水数量")
    private Integer unAll;
}

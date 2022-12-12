package ths.project.api.env_emergency.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.math.BigDecimal;

/**
 * @author:Toledo
 * @date:2021/3/9 14:35
 * @descripthion:
 **/
@ApiModel(value = "物资占比")
@Data
public class EnvSuppliesVo {

    @ApiModelProperty(value = "安全物资占比")
    private BigDecimal safe;

    @ApiModelProperty(value = "污染源切断")
    private BigDecimal pollutionCut;

    @ApiModelProperty(value = "污染源控制")
    private BigDecimal pollutionCtr;

    @ApiModelProperty(value = "污染源收集")
    private BigDecimal pollutionCollect;

    @ApiModelProperty(value = "污染物降解")
    private BigDecimal pollutionDegradation;

    @ApiModelProperty(value = "应急通信和指挥")
    private BigDecimal communicationsCommand;

    @ApiModelProperty(value = "环境监测")
    private BigDecimal environmentalMonitoring;

    @ApiModelProperty(value = "总共数量")
    private BigDecimal BigDecimal;
}

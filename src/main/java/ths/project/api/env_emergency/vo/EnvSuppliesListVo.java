package ths.project.api.env_emergency.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * @author:Toledo
 * @date:2021/3/22 19:47
 * @descripthion:
 **/
@Data
@ApiModel("应急物资列表")
public class EnvSuppliesListVo {
    @ApiModelProperty("序号")
    private String index;
    @ApiModelProperty("物资名称")
    private String name;
    @ApiModelProperty("应急类型")
    private String type;
    @ApiModelProperty("数量")
    private String num;
    @ApiModelProperty("物资类型")
    private String suppliesType;
}

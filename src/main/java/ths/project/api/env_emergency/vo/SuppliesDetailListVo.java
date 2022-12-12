package ths.project.api.env_emergency.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * @author:Toledo
 * @date:2021/3/22 17:32
 * @descripthion:
 **/
@Data
@ApiModel("应急物资详情列表")
public class SuppliesDetailListVo {
    @ApiModelProperty("物资类型")
    private String name;
    @ApiModelProperty("物资名称")
    private String materialName;
    @ApiModelProperty("数量")
    private String nums;
}


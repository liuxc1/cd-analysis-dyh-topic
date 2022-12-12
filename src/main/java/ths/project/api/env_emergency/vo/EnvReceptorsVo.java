package ths.project.api.env_emergency.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * @author:Toledo
 * @date:2021/3/9 10:21
 * @descripthion:
 **/
@ApiModel(value = "环境受体统计")
@Data
public class EnvReceptorsVo {

    @ApiModelProperty(value = "类型编码")
    private String typeCode;
    @ApiModelProperty(value = "类型")
    private String type;
    @ApiModelProperty(value = "数量")
    private Integer total;
    @ApiModelProperty(value = "涉水涉气")
    private String monType;
}

package ths.project.api.env_emergency.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * @author:Toledo
 * @date:2021/4/23 18:21
 * @descripthion:
 **/
@Data
@ApiModel("敏感点列表")
public class SensitiveListVo {
    @ApiModelProperty("敏感点名称")
    private String name;
    @ApiModelProperty("敏感点类型")
    private String type;
    @ApiModelProperty("敏感点code")
    private String code;
}

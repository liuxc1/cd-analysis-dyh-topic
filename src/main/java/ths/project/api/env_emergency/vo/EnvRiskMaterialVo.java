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
@ApiModel("环境风险物质存放情况")
public class EnvRiskMaterialVo {
    @ApiModelProperty("风险物质名称")
    private String name;
    @ApiModelProperty("数量")
    private String num;

    public EnvRiskMaterialVo name(String name) {
        this.name = name;
        return this;
    }

    public EnvRiskMaterialVo num(String num) {
        this.num = num;
        return this;
    }

    public static EnvRiskMaterialVo getInstance() {
        return new EnvRiskMaterialVo();
    }
}


package ths.project.api.env_emergency.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
@ApiModel("化学品")
public class ChemicalsVo {

    @ApiModelProperty("唯一编码")
    private String code;
    @ApiModelProperty("中文名称")
    private String name;
    @ApiModelProperty("英文名称")
    private String english;
    @ApiModelProperty("分子式")
    private String molecular;
    @ApiModelProperty("CAS号")
    private String casNum;
}

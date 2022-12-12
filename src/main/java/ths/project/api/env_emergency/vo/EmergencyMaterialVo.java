package ths.project.api.env_emergency.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * @ClassName EmergencyMaterialVo
 * @Description TODO
 * @Author ZT
 * @Date 2021/4/20 14:38
 * @Version 1.0
 **/
@ApiModel(value = "应急物质")
@Data
public class EmergencyMaterialVo {

    @ApiModelProperty(value = "单位编码")
    String entCode;
    @ApiModelProperty(value = "单位名称")
    String entName;
    @ApiModelProperty(value = "单位类型")
    String entType;
    @ApiModelProperty(value = "物质类型")
    String materialType;
    @ApiModelProperty(value = "物质名称")
    String materialName;
    @ApiModelProperty(value = "物质数量")
    String materialNum;

}

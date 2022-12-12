package ths.project.api.env_emergency.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * @author:Toledo
 * @date:2021/3/22 20:03
 * @descripthion:
 **/
@Data
@ApiModel("敏感点详情")
public class EnvSensitiveVo {

    @ApiModelProperty("受体名称")
    private String name;
    @ApiModelProperty("经度")
    private String longitude;
    @ApiModelProperty("纬度")
    private String latitude;
    @ApiModelProperty("所属街道")
    private String street;
    @ApiModelProperty("面积")
    private String area;

    // 大气：受体名称、经度、纬度、所属街道、面积（km2）,  人口数量或流动人口数、 受体类型、
    @ApiModelProperty("人口数量或流动人口数")
    private String people;
    @ApiModelProperty("受体类型")
    private String type;

    //水：受体名称、经度、纬度、所属街道、水域面积（km²）、   规模、水资源量（万m³）、长度（km）、水质类别
    @ApiModelProperty("规模")
    private String scale;
    @ApiModelProperty("水资源量")
    private String quantity;
    @ApiModelProperty("长度")
    private String length;
    @ApiModelProperty("水质类别")
    private String waterLevel;



}

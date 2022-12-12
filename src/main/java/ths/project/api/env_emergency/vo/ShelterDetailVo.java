package ths.project.api.env_emergency.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * @author:Toledo
 * @date:2021/5/25 15:55
 * @descripthion:
 **/
@Data
@ApiModel("应急避难场所详情")
public class ShelterDetailVo {

    @ApiModelProperty("避难所编码")
    private String code;
    @ApiModelProperty("避难所名称")
    private String name;
    @ApiModelProperty("街道")
    private String street;
    @ApiModelProperty("位置")
    private String address;
    @ApiModelProperty("场所类型")
    private String type;
    @ApiModelProperty("联系人")
    private String contact;
    @ApiModelProperty("电话")
    private String mobile;

    @ApiModelProperty("人数")
    private String nums;
    @ApiModelProperty("面积")
    private String area;

}

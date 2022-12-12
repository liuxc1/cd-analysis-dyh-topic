package ths.project.api.env_emergency.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * @author:Toledo
 * @date:2021/3/22 19:36
 * @descripthion:
 **/
@Data
@ApiModel("应急物资详情")
public class EvnNsuppliesDetail {

    @ApiModelProperty("企业名称")
    private String name;
    @ApiModelProperty("经度")
    private String longitude;
    @ApiModelProperty("纬度")
    private String latitude;
    @ApiModelProperty("联系人")
    private String concatMan;
    @ApiModelProperty("联系方式")
    private String concatMobile;
    @ApiModelProperty("企业地址")
    private String address;
    @ApiModelProperty("环境支持单位")
    private String unit;
}

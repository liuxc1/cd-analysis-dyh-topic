package ths.project.api.env_emergency.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * @author:Toledo
 * @date:2021/3/22 17:18
 * @descripthion:
 **/
@Data
@ApiModel("风险企业详情")
public class EnvRiskDetailsVo {

    @ApiModelProperty("id")
    private String pkid;
    @ApiModelProperty("企业名称")
    private String enterpriseName;
    @ApiModelProperty("行业代码")
    private String industryCode;
    @ApiModelProperty("行业类别")
    private String industryName;
    @ApiModelProperty("社区")
    private String community;
    @ApiModelProperty("街道")
    private String street;
    @ApiModelProperty("工业区名称")
    private String industrialPark;
    @ApiModelProperty("工业园名称")
    private String industrialZone;
    @ApiModelProperty("经度")
    private String longitude;
    @ApiModelProperty("纬度")
    private String latitude;
    @ApiModelProperty("企业类型")
    private String type;
    @ApiModelProperty("是否已备案")
    private String record;
    @ApiModelProperty("企业环境风险等级")
    private String riskLevel;
    @ApiModelProperty("污染物排放去向")
    private String sewageEmissions;
    @ApiModelProperty("环境风险物质种类")
    private String riskSubstanceType;
    @ApiModelProperty("可能造成的突发环境风险事件类型")
    private String emergentRiskType;
    @ApiModelProperty("应急物资类型")
    private String suppliesType;
    @ApiModelProperty("涉水")
    private String involveWaterRiskEnterprise;
    @ApiModelProperty("涉气")
    private String involveAirRiskEnterprise;
    @ApiModelProperty("支持单位")
    private String supportUnit;

    @ApiModelProperty("风险类型")
    private String riskType;
    @ApiModelProperty("风险等级")
    private String environmentalEnterprise;

}

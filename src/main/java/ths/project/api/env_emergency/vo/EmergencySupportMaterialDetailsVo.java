package ths.project.api.env_emergency.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.util.List;

/**
 * @author:Toledo
 * @date:2021/4/25 10:49
 * @descripthion:
 **/
@Data
@ApiModel("应急物质详情")
public class EmergencySupportMaterialDetailsVo {

    @ApiModelProperty("企业名称")
    private String name;
    @ApiModelProperty("经度")
    private String longitude;
    @ApiModelProperty("纬度")
    private String latitude;
    @ApiModelProperty("联系人姓名")
    private String concatMan;
    @ApiModelProperty("联系人电话")
    private String concatMobile;
    @ApiModelProperty("企业地址")
    private String address;
    @ApiModelProperty("列表数据")
    private List<DetailsE> list;

    @Data
    @ApiModel
    public static class DetailsE {
        @ApiModelProperty("物资名称")
        private String name;
        @ApiModelProperty("物资数量")
        private String nums;
    }
}

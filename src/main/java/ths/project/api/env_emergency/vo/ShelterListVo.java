package ths.project.api.env_emergency.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * @author:Toledo
 * @date:2021/5/25 15:44
 * @descripthion:
 **/
@Data
@ApiModel("应急避难场所列表")
public class ShelterListVo {

    @ApiModelProperty("唯一值")
    private String code;
        @ApiModelProperty("场所名称")
    private String name;
    @ApiModelProperty("场所类型")
    private String type;
    @ApiModelProperty("可容纳人数")
    private String nums;
    @ApiModelProperty("面积")
    private String area;

}

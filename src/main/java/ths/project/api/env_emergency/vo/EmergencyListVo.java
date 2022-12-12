package ths.project.api.env_emergency.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * @author:Toledo
 * @date:2021/4/23 18:01
 * @descripthion:
 **/
@Data
@ApiModel("应急预案列表")
public class EmergencyListVo {
    @ApiModelProperty("单位名称")
    private String name;
    @ApiModelProperty("预案类型")
    private String type;
    @ApiModelProperty("应急数量")
    private String nums;
    @ApiModelProperty("预案code")
    private String code;

    public EmergencyListVo(String name, String type, String code, String nums) {
        this.name = name;
        this.type = type;
        this.code = code;
        this.nums = nums;
    }
}

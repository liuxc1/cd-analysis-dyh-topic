package ths.project.api.env_emergency.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * @author:Toledo
 * @date:2021/3/22 20:17
 * @descripthion:
 **/
@Data
@ApiModel("应急事件分析列表")
public class EnvEventsListVo {

    @ApiModelProperty("序号")
    private Integer index;
    @ApiModelProperty("事件名称")
    private String evenName;
    @ApiModelProperty("事件编码")
    private String evenCode;
    @ApiModelProperty("事件类型")
    private String type;

    @ApiModelProperty("事件等级")
    private String level;
    @ApiModelProperty("行政区")
    private String region;
    @ApiModelProperty("事发时间")
    private String time;
    @ApiModelProperty("涉及化学用品")
    private String chemicalInvolvement;
}

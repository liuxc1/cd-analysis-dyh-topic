package ths.project.api.env_emergency.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
@ApiModel("应急事件列表")
public class EmergencyEventsListVo {

    @ApiModelProperty("唯一主键")
    private String id;
    @ApiModelProperty("事件名称")
    private String name;
    @ApiModelProperty("事发时间")
    private String time;
    @ApiModelProperty("涉及化学品")
    private String chemicals;
    @ApiModelProperty("事件等级")
    private String level;
    @ApiModelProperty("行政区域")
    private String region;
}

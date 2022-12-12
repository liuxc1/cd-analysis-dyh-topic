package ths.project.service.common.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * @ClassName MaxTimeVo
 * @Description TODO
 * @Author ZT
 * @Date 2021/4/19 17:44
 * @Version 1.0
 **/
@ApiModel(value = "最大时间")
@Data
public class MaxTimeVo {
    @ApiModelProperty(value = "小时开始时间")
    String startTime;
    @ApiModelProperty(value = "小时结束时间时间")
    String endTime;
    @ApiModelProperty(value = "日开始时间")
    String startDay;
    @ApiModelProperty(value = "日结束时间时间")
    String endDay;
}

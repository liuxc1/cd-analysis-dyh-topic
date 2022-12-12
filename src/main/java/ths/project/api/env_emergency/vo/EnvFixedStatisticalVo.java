package ths.project.api.env_emergency.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * @author:Toledo
 * @date:2021/3/22 15:27
 * @descripthion:
 **/
@Data
@ApiModel("首页固定源统计")
public class EnvFixedStatisticalVo {

    @ApiModelProperty(value = "名称")
    private String monName;
    @ApiModelProperty(value = "总数")
    private double total;
    @ApiModelProperty(value = "已匹配")
    private double match;
    @ApiModelProperty(value = "时间")
    private String monTime;
    @ApiModelProperty(value = "来源编码")
    private double dataSource;

    public EnvFixedStatisticalVo(String monName, double total, double match, String monTime, double dataSource) {
        this.monName = monName;
        this.total = total;
        this.match = match;
        this.monTime = monTime;
        this.dataSource = dataSource;
    }
}

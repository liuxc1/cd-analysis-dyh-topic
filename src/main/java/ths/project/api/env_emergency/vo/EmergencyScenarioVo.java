package ths.project.api.env_emergency.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
@ApiModel("典型突发事件情景分析列表")
public class EmergencyScenarioVo {

    @ApiModelProperty("唯一主键")
    private String id;
    @ApiModelProperty("典型突发事件名称")
    private String name;

    @ApiModelProperty("事故源")
    private String accidentSource;

    @ApiModelProperty("源强计算")
    private String calculation;

    @ApiModelProperty("释放环境风险物资")
    private String equipmentAnalysis;
    @ApiModelProperty("应急措施和应急")
    private String materialAnalysis;

    @ApiModelProperty("结果分析")
    private String resultAnalysis;

}

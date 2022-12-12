package ths.project.api.env_emergency.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * @author:Toledo
 * @date:2021/3/22 15:36
 * @descripthion:
 **/
@Data
@ApiModel("首页环境应急")
public class EvnStatisticalVo {

    @ApiModelProperty("风险企业")
    private Integer riskEnterprise;
    @ApiModelProperty("敏感点")
    private Integer sensitive;
    @ApiModelProperty("近5年应急事件")
    private Integer fiveYear;
    @ApiModelProperty("政府应急物资")
    private Integer government;
    @ApiModelProperty("企业应急物资")
    private Integer enterprise;
    @ApiModelProperty("政府应急预案")
    private Integer governmentPlan;
    @ApiModelProperty("企业应急预案")
    private Integer enterprisePlan;

    public EvnStatisticalVo() {
    }

    public EvnStatisticalVo(Integer riskEnterprise, Integer sensitive, Integer fiveYear, Integer government, Integer enterprise, Integer governmentPlan, Integer enterprisePlan) {
        this.riskEnterprise = riskEnterprise;
        this.sensitive = sensitive;
        this.fiveYear = fiveYear;
        this.government = government;
        this.enterprise = enterprise;
        this.governmentPlan = governmentPlan;
        this.enterprisePlan = enterprisePlan;
    }
}

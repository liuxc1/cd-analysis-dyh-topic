package ths.project.api.env_emergency.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * @author:duanzm
 * @date:2021/11/12 14:47
 * @descripthion:
 **/
@Data
@ApiModel("物资统计")
public class MaterialStatisticsVo {
    @ApiModelProperty("企业名称")
    private String name;
    @ApiModelProperty("企业编码")
    private Integer emergencyEnterpriseDefaultPkid;
    @ApiModelProperty("查询类型")
    private String emergencyEnterpriseDefaultType;
    @ApiModelProperty("物资数量")
    private Integer materialNum;
}
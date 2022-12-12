package ths.project.api.env_emergency.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * @author:Toledo
 * @date:2021/5/25 14:58
 * @descripthion:
 **/
@Data
@ApiModel("获取联系人个数")
public class ContactNumsVo {

    @ApiModelProperty("管理人员")
    private Integer management;
    @ApiModelProperty("专家")
    private Integer experts;
    @ApiModelProperty("公司")
    private Integer company;
    @ApiModelProperty("救援队伍数量")
    private Integer rescue;
    @ApiModelProperty("环境监测数量")
    private Integer environment;

}

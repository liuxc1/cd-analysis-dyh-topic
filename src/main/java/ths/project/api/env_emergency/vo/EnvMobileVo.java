package ths.project.api.env_emergency.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * @author:Toledo
 * @date:2021/3/9 10:40
 * @descripthion:
 **/
@ApiModel(value = "管理,专家,公司联系方式")
@Data
public class EnvMobileVo {

    @ApiModelProperty(value = "管理人员")
    private List<Concat> management;
    @ApiModelProperty(value = "专家组")
    private List<Concat> experts;
    @ApiModelProperty(value = "相关公司")
    private List<Concat> company;
    @ApiModelProperty(value = "应急救援队伍")
    private List<Concat> rescue;
    @ApiModelProperty(value = "自动环境监测站")
    private List<ConcatE> environment;

    public List<Concat> getManagement() {
        management = Optional.ofNullable(management).orElse(new ArrayList<>());
        return management;
    }

    public List<Concat> getExperts() {
        experts = Optional.ofNullable(experts).orElse(new ArrayList<>());
        return experts;
    }

    public List<Concat> getCompany() {
        company = Optional.ofNullable(company).orElse(new ArrayList<>());
        return company;
    }

    public List<Concat> getRescue() {
        rescue = Optional.ofNullable(rescue).orElse(new ArrayList<>());
        return rescue;
    }

    public List<ConcatE> getEnvironment() {
        environment = Optional.ofNullable(environment).orElse(new ArrayList<>());
        return environment;
    }

    @Data
    @ApiModel("应急救援队伍")
    public static class ConcatR {
        @ApiModelProperty(value = "名称(应急救援队伍)")
        private String organization;

        @ApiModelProperty(value = "负责人(应急救援队伍)")
        private String name;

        @ApiModelProperty(value = "值班电话(应急救援队伍)")
        private String fixedMobile;

        @ApiModelProperty(value = "联络方式(应急救援队伍)")
        private String mobile;

        @ApiModelProperty(value = "类型,1:管理组,2:专家组,3:公司组4:救援队伍,5:环境监测")
        private String monType;
    }

    @Data
    @ApiModel("自动环境监测站")
    public static class ConcatE {
        @ApiModelProperty(value = "点位名称")
        private String pointName;

        @ApiModelProperty(value = "监测类型")
        private String type;

        @ApiModelProperty(value = "站房地址")
        private String address;

        @ApiModelProperty(value = "监测项目")
        private String project;

        @ApiModelProperty(value = "类型,1:管理组,2:专家组,3:公司组4:救援队伍,5:环境监测")
        private String monType;
    }

    @Data
    @ApiModel
    public static class Concat {
        @ApiModelProperty(value = "组织")
        private String organization;

        @ApiModelProperty(value = "名称")
        private String name;

        @ApiModelProperty(value = "固定电话")
        private String fixedMobile;

        @ApiModelProperty(value = "手机")
        private String mobile;

        @ApiModelProperty(value = "类型,1:管理组,2:专家组,3:公司组,4:救援队伍,5:环境监测")
        private String monType;
    }


}

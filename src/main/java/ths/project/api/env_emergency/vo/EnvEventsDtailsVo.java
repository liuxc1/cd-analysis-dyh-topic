package ths.project.api.env_emergency.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import ths.project.service.common.vo.drowDown.DropDownVo;

import java.util.List;

/**
 * @author:Toledo
 * @date:2021/3/22 20:51
 * @descripthion:
 **/
@Data
@ApiModel("应急事件分析详情")
public class EnvEventsDtailsVo {

    @ApiModelProperty("应急事件名称")
    private String name;
    @ApiModelProperty("经度")
    private String longitude;
    @ApiModelProperty("纬度")
    private String latitude;
    @ApiModelProperty("事件类型")
    private String eventType;
    @ApiModelProperty("涉及风险物质")
    private String material;

    @ApiModelProperty("涉及风险源")
    private List<Compare> source;
    @ApiModelProperty("应急预案")
    private List<DropDownVo> plan;


    @ApiModelProperty("敏感点")
    private List<Compare> sensitive;
    @ApiModelProperty("风险源")
    private List<Compare> sourceRisk;

    @ApiModelProperty("应急物资")
    private List<Compare> supplies;
    @ApiModelProperty("应急保障")
    private List<Compare> safeguard;
    @ApiModelProperty("应急避难场所")
    private List<Compare> shelter;

    public EnvEventsDtailsVo(String name, String longitude, String latitude, String eventType, String material, List<Compare> source, List<DropDownVo> plan, List<Compare> sensitive, List<Compare> sourceRisk,
                             List<Compare> supplies, List<Compare> safeguard, List<Compare> shelter) {
        this.name = name;
        this.longitude = longitude;
        this.latitude = latitude;
        this.eventType = eventType;
        this.material = material;
        this.source = source;
        this.plan = plan;
        this.sensitive = sensitive;
        this.sourceRisk = sourceRisk;

        this.supplies = supplies;
        this.safeguard = safeguard;
        this.shelter = shelter;
    }

    @Data
    public static class Compare {
        @ApiModelProperty("经度")
        private String longitude;
        @ApiModelProperty("纬度")
        private String latitude;
        @ApiModelProperty("公司code")
        private String code;
        @ApiModelProperty("公司名字")
        private String name;
        @ApiModelProperty("1政府类型的，2还是企业类型的")
        private String type;
        public Compare(String longitude, String latitude, String code, String name,String type) {
            this.longitude = longitude;
            this.latitude = latitude;
            this.code = code;
            this.name = name;
            this.type = type;
        }
    }

}

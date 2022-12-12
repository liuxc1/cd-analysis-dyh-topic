package ths.project.api.env_emergency.vo;


import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.util.Optional;

@Data
@ApiModel("化学产品详情")
public class ChemicalsDetailsVo {

    @ApiModelProperty("化学产品信息")
    private Info info;
    @ApiModelProperty("处置方法")
    private Way way;
    @ApiModelProperty("人员防护信息")
    private Safe safe;

    public Info getInfo() {
        info = Optional.ofNullable(info).orElse(new Info());
        return info;
    }

    public Way getWay() {
        way = Optional.ofNullable(way).orElse(new Way());
        return way;
    }

    public Safe getSafe() {
        safe = Optional.ofNullable(safe).orElse(new Safe());
        return safe;
    }

    @Data
    @ApiModel
    public static class Info {
        @ApiModelProperty("cas号")
        private String casNum;
        @ApiModelProperty("un号")
        private String unNum;
        @ApiModelProperty("retcs号")
        private String retcsNum;

        @ApiModelProperty("化学名")
        private String name;
        @ApiModelProperty("中文别名")
        private String nameAlias;
        @ApiModelProperty("分子式")
        private String molecular;
        @ApiModelProperty("分子量")
        private String molecularWeight;
        @ApiModelProperty("英文名称")
        private String english;
        @ApiModelProperty("英文别名称")
        private String englishAlias;

        @ApiModelProperty("相对密度")
        private String relativeDensity;
        @ApiModelProperty("气体相对密度")
        private String GasRelativeDensity;
        @ApiModelProperty("沸点")
        private String boilingPoint;
        @ApiModelProperty("熔点")
        private String meltingPoint;

        @ApiModelProperty("闪点")
        private String flashPoint;
        @ApiModelProperty("蒸汽压")
        private String vaporPressure;
        @ApiModelProperty("化学品类型")
        private String typeChemical;
        @ApiModelProperty("物理状态")
        private String physicalState;

        @ApiModelProperty("稳定性和危险性")
        private String stabilityAndRisk;
        @ApiModelProperty("溶解性")
        private String solubility;
        @ApiModelProperty("水中允许极限")
        private String permissibleLimitInWater;

    }

    @Data
    @ApiModel
    public static class Way {
        @ApiModelProperty("环境标准")
        private String environmentalStandards;
        @ApiModelProperty("环境检测方法")
        private String environmentalTesting;
        @ApiModelProperty("消防方法")
        private String fireControl;
        @ApiModelProperty("泄露处置")
        private String outOfTheDisposal;

    }

    @Data
    @ApiModel
    public static class Safe {
        @ApiModelProperty("毒理学资料")
        private String toxicologicalData;
        @ApiModelProperty("急救措施")
        private String firstAidMeasures;
        @ApiModelProperty("急救措施(备用字段)")
        private String firstAidMeasuresR;
    }
}

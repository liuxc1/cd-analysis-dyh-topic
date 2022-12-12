package ths.project.service.common.vo;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.io.Serializable;

/**
 * @version 1.0
 * @ClassName: SimpleGeneralVo.java
 * @Description: TODO
 * @Author ZT
 * @Date 2021年3月4日
 */
@Api(value = "简单echart通用返回")
@Data
public class SimpleGeneralVo implements Serializable{

	private static final long serialVersionUID = -8902732116216447531L;

	@ApiModelProperty(value = "名称", example = "")
    private String monName;

    @ApiModelProperty(value = "值", example = "")
    private double monValue;

    @ApiModelProperty(value = "辅助值(去年的值,同比值)", example = "")
    private double monValueLast;

    @ApiModelProperty(value = "备用值字符串", example = "")
    private String spare;

    public SimpleGeneralVo monName(String monName) {
        this.monName = monName;
        return this;
    }

    public SimpleGeneralVo monValue(double monValue) {
        this.monValue = monValue;
        return this;
    }

    public SimpleGeneralVo monValueLast(double monValueLast) {
        this.monValueLast = monValueLast;
        return this;
    }

    public static SimpleGeneralVo build() {
        return new SimpleGeneralVo();
    }

    public SimpleGeneralVo() {
    }

    public SimpleGeneralVo(String monName, double monValue) {
        this.monName = monName;
        this.monValue = monValue;
    }

    public SimpleGeneralVo(String monName, double monValue, double monValueLast) {
        this.monName = monName;
        this.monValue = monValue;
        this.monValueLast = monValueLast;
    }
}

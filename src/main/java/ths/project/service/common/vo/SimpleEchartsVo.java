package ths.project.service.common.vo;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.io.Serializable;

/**
 * @version 1.0
 * @ClassName: SimpleEchartsVo.java
 * @Description: TODO
 * @Author ZT
 * @Date 2021年3月4日
 */
@Api(value = "简单echart返回")
@Data
public class SimpleEchartsVo implements Serializable{

    @ApiModelProperty(value = "街道编码", example = "")
    private String streetCode;

	@ApiModelProperty(value = "名称", example = "")
    private String monName;

    @ApiModelProperty(value = "值", example = "")
    private double monValue;

    public SimpleEchartsVo() {
    }

    public SimpleEchartsVo(String monName, double monValue) {
        this.monName = monName;
        this.monValue = monValue;
    }
}

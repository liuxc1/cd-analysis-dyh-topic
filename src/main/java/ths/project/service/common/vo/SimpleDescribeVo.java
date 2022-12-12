package ths.project.service.common.vo;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * @version 1.0
 * @ClassName: SimpleGeneralVo.java
 * @Description: TODO
 * @Author ZT
 * @Date 2021年3月4日
 */
@SuppressWarnings("hiding")
@Api(value = "文字+数据通用返回")
@Data
public class SimpleDescribeVo<T> implements Serializable{

	private static final long serialVersionUID = -7118188612552545215L;

	@ApiModelProperty(value = "描述", example = "")
    private String description;

    @ApiModelProperty(value = "值", example = "")
    private List<T> monList;
    
    public List<T> getMonList() {
        monList = Optional.ofNullable(monList).orElse(new ArrayList<>());
        return monList;
    }
    
}

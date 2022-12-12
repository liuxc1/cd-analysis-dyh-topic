package ths.project.api.env_emergency.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
@ApiModel("应急预案详情")
public class EmergencyDetailVo {

    private String name;
    @ApiModelProperty("事件id")
    private String id;
    private String url;

    public EmergencyDetailVo() {
    }

    public EmergencyDetailVo(String name, String id) {


        this.name = name;
        this.id = id;
    }
}

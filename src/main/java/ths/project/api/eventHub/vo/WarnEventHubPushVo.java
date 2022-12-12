package ths.project.api.eventHub.vo;

import java.util.List;

/**
 * @Description 预警事件枢纽推送参数
 * @Author duanzm
 * @Date 2022/8/18 上午10:12
 * @Version 1.0
 **/
public class WarnEventHubPushVo {

    /**
     * 账户名，事件枢纽提供
     */
    private String username;

    /**
     * 密码，事件枢纽提供
     */
    private String password;

    /**
     * 预警标题
     */
    private String alert_title;

    /**
     * 预警描述
     */
    private String alert_description;

    /**
     * 预警类型。需要各业务部门提供预警类型字典表
     */
    private String alert_type;

    /**
     * 预警等级。需要各业务部门提供预警等级字典表
     */
    private String alert_level;

    /**
     * 发起部门ID（详见事件组织机构。后续将调整为统一社会信用代码）
     */
    private String departmentid;

    /**
     * 预警开始时间
     */
    private String alert_start_time;

    /**
     * 预警结束时间（如设置结束时间，事件枢纽将在该时间自动结束）
     */
    private String alert_end_time;

    /**
     * 预警标识（0产生新预警，1关闭已有预警）
     */
    private String alert_flag;

    /**
     * 事件枢纽工单号（预警标识为1时必传）
     */
    private String flowno;

    /**
     * 处置单位标识 (为0时需传disposal_list,为1时需传预警模板名字)
     */
    private String chuzhi_flag;

    /**
     * 预警模板名(处置单位标识为1时必传)
     */
    private String alert_name;

    public String getUsername() {
        return username;
    }

    public WarnEventHubPushVo() {
    }

    public WarnEventHubPushVo(String username, String password, String alert_title, String alert_description, String alert_type, String alert_level, String departmentid, String alert_start_time, String alert_end_time, String alert_flag, String flowno, String chuzhi_flag, String alert_name) {
        this.username = username;
        this.password = password;
        this.alert_title = alert_title;
        this.alert_description = alert_description;
        this.alert_type = alert_type;
        this.alert_level = alert_level;
        this.departmentid = departmentid;
        this.alert_start_time = alert_start_time;
        this.alert_end_time = alert_end_time;
        this.alert_flag = alert_flag;
        this.flowno = flowno;
        this.chuzhi_flag = chuzhi_flag;
        this.alert_name = alert_name;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getAlert_title() {
        return alert_title;
    }

    public void setAlert_title(String alert_title) {
        this.alert_title = alert_title;
    }

    public String getAlert_description() {
        return alert_description;
    }

    public void setAlert_description(String alert_description) {
        this.alert_description = alert_description;
    }

    public String getAlert_type() {
        return alert_type;
    }

    public void setAlert_type(String alert_type) {
        this.alert_type = alert_type;
    }

    public String getAlert_level() {
        return alert_level;
    }

    public void setAlert_level(String alert_level) {
        this.alert_level = alert_level;
    }

    public String getDepartmentid() {
        return departmentid;
    }

    public void setDepartmentid(String departmentid) {
        this.departmentid = departmentid;
    }

    public String getAlert_start_time() {
        return alert_start_time;
    }

    public void setAlert_start_time(String alert_start_time) {
        this.alert_start_time = alert_start_time;
    }

    public String getAlert_end_time() {
        return alert_end_time;
    }

    public void setAlert_end_time(String alert_end_time) {
        this.alert_end_time = alert_end_time;
    }

    public String getAlert_flag() {
        return alert_flag;
    }

    public void setAlert_flag(String alert_flag) {
        this.alert_flag = alert_flag;
    }

    public String getFlowno() {
        return flowno;
    }

    public void setFlowno(String flowno) {
        this.flowno = flowno;
    }

    public String getChuzhi_flag() {
        return chuzhi_flag;
    }

    public void setChuzhi_flag(String chuzhi_flag) {
        this.chuzhi_flag = chuzhi_flag;
    }

    public String getAlert_name() {
        return alert_name;
    }

    public void setAlert_name(String alert_name) {
        this.alert_name = alert_name;
    }
}

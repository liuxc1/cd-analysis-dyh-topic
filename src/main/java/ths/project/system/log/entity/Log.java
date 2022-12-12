package ths.project.system.log.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import ths.project.common.constant.SchemaConstants;

@TableName(value = "T_COMM_SYSTEM_LOG", schema = SchemaConstants.DEFAULT)
public class Log {
	/**
	 * 日志ID
	 */
	@TableId
	private String logId;
	/** 组1. 基础参数 **/
	/** 子系统，中文 **/
	private String system;
	/** 模块，中文 **/
	private String module;
	/** 操作，中文 **/
	private String operation;
	/** 用户名 **/
	private String userName;
	/** 备注 **/
	private String remark;

	/** 组2. 时间参数 **/
	/** 时间，格式：yyyy-MM-dd HH:mm:ss **/
	private String dateTime;
	/** 时长，单位：ms **/
	private Integer duration;

	/** 3. 请求参数 **/
	/** ip **/
	private String ip;
	/** 来源referer **/
	private String referer;
	/** 访问url **/
	private String url;
	/** 请求头部信息 **/
	private String header;
	/** 请求参数 **/
	private String args;

	/** 4. 类参数 **/
	/** 全限定名 **/
	private String qualiedName;
	/** 方法名 **/
	private String method;

	/** 5. 响应参数 **/
	/** 结果数据 **/
	private String result;
	/** HTTP状态码 **/
	private Integer status;

	/** 6. 异常参数 **/
	/** 异常信息 **/
	private String exception;

	public Log(){

	}

	public Log(String logId, String system, String module, String operation, String userName, String remark, String dateTime, Integer duration, String ip, String referer, String url, String header, String args, String qualiedName, String method, String result, Integer status, String exception) {
		this.logId = logId;
		this.system = system;
		this.module = module;
		this.operation = operation;
		this.userName = userName;
		this.remark = remark;
		this.dateTime = dateTime;
		this.duration = duration;
		this.ip = ip;
		this.referer = referer;
		this.url = url;
		this.header = header;
		this.args = args;
		this.qualiedName = qualiedName;
		this.method = method;
		this.result = result;
		this.status = status;
		this.exception = exception;
	}

	public String getSystem() {
		return system;
	}

	public String getModule() {
		return module;
	}

	public String getOperation() {
		return operation;
	}

	public String getUserName() {
		return userName;
	}

	public String getRemark() {
		return remark;
	}

	public String getDateTime() {
		return dateTime;
	}

	public Integer getDuration() {
		return duration;
	}

	public String getIp() {
		return ip;
	}

	public String getReferer() {
		return referer;
	}

	public String getUrl() {
		return url;
	}

	public String getHeader() {
		return header;
	}

	public String getArgs() {
		return args;
	}

	public String getQualiedName() {
		return qualiedName;
	}

	public String getMethod() {
		return method;
	}

	public String getResult() {
		return result;
	}

	public Integer getStatus() {
		return status;
	}

	public String getException() {
		return exception;
	}

	public void setSystem(String system) {
		this.system = system;
	}

	public void setModule(String module) {
		this.module = module;
	}

	public void setOperation(String operation) {
		this.operation = operation;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public void setDateTime(String dateTime) {
		this.dateTime = dateTime;
	}

	public void setDuration(Integer duration) {
		this.duration = duration;
	}

	public void setIp(String ip) {
		this.ip = ip;
	}

	public void setReferer(String referer) {
		this.referer = referer;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public void setHeader(String header) {
		this.header = header;
	}

	public void setArgs(String args) {
		this.args = args;
	}

	public void setQualiedName(String qualiedName) {
		this.qualiedName = qualiedName;
	}

	public void setMethod(String method) {
		this.method = method;
	}

	public void setResult(String result) {
		this.result = result;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public void setException(String exception) {
		this.exception = exception;
	}

	public String getLogId() {
		return logId;
	}

	public void setLogId(String logId) {
		this.logId = logId;
	}

	@Override
	public String toString() {
		return "Log [logId=" + logId + ", system=" + system + ", module=" + module + ", operation=" + operation
				+ ", userName=" + userName + ", remark=" + remark + ", dateTime=" + dateTime + ", duration=" + duration
				+ ", ip=" + ip + ", referer=" + referer + ", url=" + url + ", header=" + header + ", args=" + args
				+ ", qualiedName=" + qualiedName + ", method=" + method + ", result=" + result + ", status=" + status
				+ ", exception=" + exception + "]";
	}
}

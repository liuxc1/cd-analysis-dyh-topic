package ths.project.system.log.vo;

/**
 * 日志审查返回结果对象
 * 
 * @author zl
 *
 */
public class LogVo {
	/**
	 * 操作人
	 */
	private String userName;
	/**
	 * ip
	 */
	private String ip;
	/**
	 * 地址
	 */
	private String url;
	/**
	 * 时间
	 */
	private String visitTime;
	/**
	 * 系统名称
	 */
	private String platformName;
	/**
	 * 状态
	 */
	private String status;
	/**
	 * 模块
	 */
	private String module;
	/**
	 * 操作
	 */
	private String operation;

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getIp() {
		return ip;
	}

	public void setIp(String ip) {
		this.ip = ip;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getVisitTime() {
		return visitTime;
	}

	public void setVisitTime(String visitTime) {
		this.visitTime = visitTime;
	}

	public String getPlatformName() {
		return platformName;
	}

	public void setPlatformName(String platformName) {
		this.platformName = platformName;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getModule() {
		return module;
	}

	public void setModule(String module) {
		this.module = module;
	}

	public String getOperation() {
		return operation;
	}

	public void setOperation(String operation) {
		this.operation = operation;
	}
}

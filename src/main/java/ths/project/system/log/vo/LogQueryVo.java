package ths.project.system.log.vo;

/**
 * 日志审查查小小条件
 * 
 * @author zl
 *
 */
public class LogQueryVo {
	/**
	 * 起报开始时间
	 */
	private String startTime;
	/**
	 * 起报结束时间
	 */
	private String endTime;
	/**
	 * 响应状态
	 */
	private Integer status;

	private String systemName;

	public String getStartTime() {
		return startTime;
	}

	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

	public String getEndTime() {
		return endTime;
	}

	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public String getSystemName() {
		return systemName;
	}

	public void setSystemName(String systemName) {
		this.systemName = systemName;
	}
}

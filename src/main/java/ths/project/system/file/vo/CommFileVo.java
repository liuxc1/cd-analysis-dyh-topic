package ths.project.system.file.vo;

import ths.project.system.file.entity.CommFile;

/**
 * 通用文件实体类
 * 
 * @author zl
 *
 */
public class CommFileVo extends CommFile {
	/** 是否转换 **/
	private String transform;
	/** 转换类型 **/
	private String transformType;
	/** 文件来源 **/
	private String fileSource;
	
	/** 上次更新时间 **/
	private Long lastUpdateTime;
	/**
	 * 文件来源集合
	 */
	private String[] fileSources;
	/**
	 * 文件url
	 */
	private String fileUrl;
	/**
	 * 文件id集合
	 */
	private String[] fileIds;
	/**
	 * 归属id集合
	 */
	private String[] ascriptionIds;

	public CommFileVo() {
		super();
	}

	

	public String getTransform() {
		return transform;
	}

	public void setTransform(String transform) {
		this.transform = transform;
	}

	public String getTransformType() {
		return transformType;
	}

	public void setTransformType(String transformType) {
		this.transformType = transformType;
	}

	public String getFileSource() {
		return fileSource;
	}

	public void setFileSource(String fileSource) {
		this.fileSource = fileSource;
	}


	public Long getLastUpdateTime() {
		return lastUpdateTime;
	}

	public void setLastUpdateTime(Long lastUpdateTime) {
		this.lastUpdateTime = lastUpdateTime;
	}

	public String[] getFileSources() {
		return fileSources;
	}

	public void setFileSources(String[] fileSources) {
		this.fileSources = fileSources;
	}

	public String getFileUrl() {
		return fileUrl;
	}

	public void setFileUrl(String fileUrl) {
		this.fileUrl = fileUrl;
	}

	public String[] getFileIds() {
		return fileIds;
	}

	public void setFileIds(String[] fileIds) {
		this.fileIds = fileIds;
	}

	public String[] getAscriptionIds() {
		return ascriptionIds;
	}

	public void setAscriptionIds(String[] ascriptionIds) {
		this.ascriptionIds = ascriptionIds;
	}

}

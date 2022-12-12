package ths.project.common.enums;

public enum TransformFileEnum {
	/**
	 * doc
	 */
	DOC("doc", "application/msword", "pdf"),
	/**
	 * docx
	 */
	DOCX("docx", "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "pdf");
	/**
	 * 文件类型
	 */
	private String fileType;
	/**
	 * 文件内容类型
	 */
	private String contentType;
	/**
	 * 转换文件类型
	 */
	private String transformType;

	private TransformFileEnum(String fileType, String contentType, String transformType) {
		this.fileType = fileType;
		this.contentType = contentType;
		this.transformType = transformType;
	}

	public String getFileType() {
		return fileType;
	}

	public String getContentType() {
		return contentType;
	}

	public String getTransformType() {
		return transformType;
	}

}

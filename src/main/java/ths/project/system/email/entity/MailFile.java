package ths.project.system.email.entity;

/**
 * 邮件附件文件类
 * @author liangdl
 *
 */
public class MailFile {
	/** 文件名称 **/
	private String fileName;
	/** 文件路径 **/
	private String filePath;

	public MailFile() {
	}

	public MailFile(String fileName, String filePath) {
		this.fileName = fileName;
		this.filePath = filePath;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	@Override
	public String toString() {
		return "MailFile [fileName=" + fileName + ", filePath=" + filePath + "]";
	}
}

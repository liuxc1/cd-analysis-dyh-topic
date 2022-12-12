package ths.project.system.file.vo;

import org.springframework.web.multipart.MultipartFile;
import ths.project.system.file.entity.CommFile;

public class CommImageVo extends CommFile {
	/**
	 * 文件url
	 */
	private String fileUrl;

	/**
	 * 上传的文件
	 */
	MultipartFile[] files;

	public MultipartFile[] getFiles() {
		return files;
	}

	public void setFiles(MultipartFile[] files) {
		this.files = files;
	}

	public String getFileUrl() {
		return fileUrl;
	}

	public void setFileUrl(String fileUrl) {
		this.fileUrl = fileUrl;
	}
	
}

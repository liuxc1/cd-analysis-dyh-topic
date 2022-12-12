package ths.project.common.service;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import ths.jdp.core.context.PropertyConfigure;
import ths.jdp.core.service.base.BaseService;
import ths.jdp.core.web.LoginCache;
import ths.jdp.eform.service.components.word.DocDynamicTable;
import ths.jdp.eform.service.components.word.DocumentPage;
import ths.jdp.eform.service.components.word.RepDocTemplate;
import ths.project.analysis.forecast.report.enums.AnalysisStateEnum;
import ths.project.common.enums.TransformFileEnum;
import ths.project.common.util.DateUtil;
import ths.project.common.util.UUIDUtil;
import ths.project.system.file.entity.CommFile;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.text.DecimalFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 通用文件-服务层
 * 
 * @author liangdl
 *
 */
@Service("fileService")
public class FileService extends BaseService {
	/** 通用文件-命名空间 **/
	private final String sqlPackage = "ths.air.mapper.common.FileMapper";
	/** 文件保存路径 **/
	public final static String FILE_PIC_PATH = (String) PropertyConfigure.getProperty("FILE_ROOT_PATH");
	/** 文件映射路径 **/
	private final static String FILE_PIC_URL = (String) PropertyConfigure.getProperty("FILE_ROOT_URL");

	/**
	 * 根据文件ID，查询文件信息
	 * 
	 * @param fileId
	 *            文件ID
	 * @return 文件信息。包含文件ID、文件名称、文件类型等，详情参考T_COMM_FILE表的字段说明
	 */
	public Map<String, Object> queryFileByFileId(String fileId) {
		return dao.get(fileId, sqlPackage + ".queryFileByFileId");
	}

	/**
	 * 根据归属ID，查询文件列表
	 * 
	 * @param ascriptionId
	 *            归属ID
	 * @param analysisStateEnums
	 *            分析状态枚举（可选）
	 * @return 文件列表
	 */
	public List<Map<String, Object>> queryFileListByAscriptionId(String ascriptionId, AnalysisStateEnum... analysisStateEnums) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("ascriptionId", ascriptionId);
		if (analysisStateEnums != null && analysisStateEnums.length > 0) {
			String[] fileSources = new String[analysisStateEnums.length];
			for (int i = 0; i < analysisStateEnums.length; i++) {
				fileSources[i] = analysisStateEnums[i].getValue();
			}
			paramMap.put("fileSources", fileSources);
		}
		List<Map<String, Object>> fileList = dao.list(paramMap, sqlPackage + ".queryFileListByAscriptionId");
		if (fileList != null && fileList.size() > 0) {
			for (Map<String, Object> fileMap : fileList) {
				String transform = (String) fileMap.get("TRANSFORM");
				// 如果有转换的类型，则使用转换的类型，如果没有转换，则使用原始类型
				String fileType = "Y".equals(transform) ? (String) fileMap.get("TRANSFORM_TYPE") : (String) fileMap.get("FILE_TYPE");
				String savePath = (String) fileMap.get("FILE_SAVE_PATH");
				String fileUrl = FILE_PIC_URL + savePath.substring(0, savePath.lastIndexOf(".") + 1).replaceAll("\\\\", "/") + fileType;
				if (savePath.endsWith("/") || savePath.endsWith("\\")) {
					fileUrl=getFileFullUrl((String) fileMap.get("FILE_SAVE_PATH"), (String) fileMap.get("FILE_ID"), fileType);
				}
				fileMap.put("FILE_URL", fileUrl);
			}
		}
		return fileList;
	}

	/**
	 * 根据归属ID，查询文件列表
	 * 
	 * @param ascriptionId
	 *            归属ID
	 * @param fileSources
	 *            文件来源
	 * @return 文件列表
	 */
	public List<Map<String, Object>> queryFileListByAscriptionId(String ascriptionId, String[] fileSources) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("ascriptionId", ascriptionId);
		if (fileSources != null && fileSources.length > 0) {
			paramMap.put("fileSources", fileSources);
		}
		List<Map<String, Object>> fileList = dao.list(paramMap, sqlPackage + ".queryFileListByAscriptionId");
		if (fileList != null && fileList.size() > 0) {
			for (Map<String, Object> fileMap : fileList) {
				String transform = (String) fileMap.get("TRANSFORM");
				// 如果有转换的类型，则使用转换的类型，如果没有转换，则使用原始类型
				String fileType = "Y".equals(transform) ? (String) fileMap.get("TRANSFORM_TYPE") : (String) fileMap.get("FILE_TYPE");
				String savePath = (String) fileMap.get("FILE_SAVE_PATH");
				String fileUrl = FILE_PIC_URL + savePath.substring(0, savePath.lastIndexOf(".") + 1).replaceAll("\\\\", "/") + fileType;
				if (savePath.endsWith("/") || savePath.endsWith("\\")) {
					fileUrl=getFileFullUrl((String) fileMap.get("FILE_SAVE_PATH"), (String) fileMap.get("FILE_ID"), fileType);
				}
				fileMap.put("FILE_URL", fileUrl);
			}
		}
		return fileList;
	}

	public List<Map<String, Object>> queryFileListByAscriptionIds(String[] ascriptionIds) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("ASCRIPTION_IDS", ascriptionIds);

		List<Map<String, Object>> fileList = dao.list(paramMap, sqlPackage + ".queryFileListByAscriptionIds");

		if (fileList != null && fileList.size() > 0) {
			for (Map<String, Object> fileMap : fileList) {
				String transform = (String) fileMap.get("TRANSFORM");
				// 如果有转换的类型，则使用转换的类型，如果没有转换，则使用原始类型
				String fileType = "Y".equals(transform) ? (String) fileMap.get("TRANSFORM_TYPE") : (String) fileMap.get("FILE_TYPE");
				String savePath = (String) fileMap.get("FILE_SAVE_PATH");
				String fileUrl = FILE_PIC_URL + savePath.substring(0, savePath.lastIndexOf(".") + 1).replaceAll("\\\\", "/") + fileType;
				if (savePath.endsWith("/") || savePath.endsWith("\\")) {
					fileUrl=getFileFullUrl((String) fileMap.get("FILE_SAVE_PATH"), (String) fileMap.get("FILE_ID"), fileType);
				}
				fileMap.put("FILE_URL", fileUrl);
			}
		}
		return fileList;
	}

	/**
	 * 获取文件全路径
	 * 
	 * @param fileMap
	 *            文件信息。包含文件ID、文件名称、文件类型等，详情参考T_COMM_FILE表的字段说明
	 * @return 文件全路径
	 */
	public String getFileFullPath(Map<String, Object> fileMap) {
		String fileAlias = (String) fileMap.get("FILE_ALIAS");
		String fileSavePath = (String) fileMap.get("FILE_SAVE_PATH");
		return getFileFullPath(fileSavePath, fileAlias);
	}
	
	/**
	 * 获取文件全路径
	 * 
	 * @param fileSavePath
	 *            文件相对路径
	 * @param fileId
	 *            文件ID
	 * @param fileType
	 *            文件类型
	 * @return 文件全路径
	 */
	public String getFileFullPath(String fileSavePath, String fileAlias) {
		return FILE_PIC_PATH + fileSavePath + fileAlias;
	}

	/**
	 * 获取文件映射URL
	 * 
	 * @param fileSavePath
	 *            文件相对路径
	 * @param fileId
	 *            文件ID
	 * @param fileType
	 *            文件类型
	 * @return 文件映射URL
	 */
	public String getFileFullUrl(String fileSavePath, String fileId, String fileType) {
		return FILE_PIC_URL + fileSavePath.replaceAll("\\\\", "/") + fileId + "." + fileType;
	}

	/**
	 * 处理文件名
	 * 
	 * @param request
	 *            请求对象
	 * @param fileName
	 *            原始文件名
	 * @return 处理后的文件名
	 */
	public String handleFileName(HttpServletRequest request, String fileName) {
		try {
			// 判断是否是微软IE浏览器
			boolean isMSIE = validateMSIE(request);
			// 转换文件名编码格式，避免前台乱码
			if (isMSIE) {
				fileName = URLEncoder.encode(fileName, "UTF-8");
			} else {
				fileName = new String(fileName.getBytes("UTF-8"), "ISO-8859-1");
			}
		} catch (UnsupportedEncodingException e1) {
			e1.printStackTrace();
		}
		return fileName;
	}

	/**
	 * 验证是否是微软IE浏览器
	 * 
	 * @param request
	 *            请求对象
	 * @return 是否是微软IE浏览器。True： 是，False：否
	 */
	private boolean validateMSIE(HttpServletRequest request) {
		boolean isMSIE = false;
		String[] ieBrowserSignals = { "MSIE", "Trident", "Edge" };
		String userAgent = request.getHeader("User-Agent");
		for (String signal : ieBrowserSignals) {
			if (userAgent.contains(signal)) {
				isMSIE = true;
				break;
			}
		}
		return isMSIE;
	}

	/**
	 * 插入上传的文件信息
	 * 
	 * @param multipartFiles
	 *            文件列表
	 * @param ascriptionType
	 *            归属类型，不能重复
	 * @param ascriptionId
	 *            归属ID
	 * @param remarks
	 *            备注，可选，如果需要添加备注，则必须给所有文件都添加备注
	 * @return 保存的文件数量
	 */
	@Transactional(rollbackFor = Exception.class)
	public Integer saveUploadFile(MultipartFile[] multipartFiles, String ascriptionType, String ascriptionId, String... remarks) {
		return saveUploadFile(multipartFiles, ascriptionType, ascriptionId, true, remarks);
	}

	/**
	 * 插入上传的文件信息
	 * 
	 * @param multipartFiles
	 *            文件列表
	 * @param ascriptionType
	 *            归属类型，不能重复
	 * @param ascriptionId
	 *            归属ID
	 * @param isTransform
	 *            是否转化文件类型
	 * @param remarks
	 *            备注，可选，如果需要添加备注，则必须给所有文件都添加备注
	 * @return 保存的文件数量
	 */
	@Transactional(rollbackFor = Exception.class)
	public Integer saveUploadFile(MultipartFile[] multipartFiles, String ascriptionType, String ascriptionId, Boolean isTransform, String... remarks) {
		if (multipartFiles == null || multipartFiles.length == 0) {
			return -1;
		}
		if (StringUtils.isBlank(ascriptionType) || StringUtils.isBlank(ascriptionId)) {
			return -1;
		}
		int fileLength = multipartFiles.length;
		int fileSaveNumber = 0;
		// 文件保存路径（目录）
		// String fileSavePath = getFileSavePath(null, ascriptionType);
		String userName = LoginCache.getLoginUser().getUserName();
		for (int i = 0; i < fileLength; i++) {
			MultipartFile multipartFile = multipartFiles[i];
			// 根据文件名，获取转换枚举
			TransformFileEnum transformFileEnum = isTransform ? getTransformFileEnum(multipartFile.getOriginalFilename()) : null;
			// 备注
			String remark = (remarks != null && remarks.length == multipartFiles.length) ? remarks[i] : null;
			if (remarks.length > 0 && "priority".equals(remarks[0])) {
				remark = remarks[0];
			}
			// String remark = (remarks.length >0) ? remarks[i] : null;
			// 获取文件实体对象
			CommFile commFile = getCommFile(multipartFile, ascriptionType, ascriptionId, remark, userName, transformFileEnum, AnalysisStateEnum.UPLOAD);

			// 1、将文件信息插入到数据库
			int insertDataNumber = insertFileInfo(commFile);
			// 如果数据保存失败，则跳过该文件
			if (insertDataNumber != 1) {
				break;
			}
			// 2、将文件保存到磁盘
			String filePath = getFileFullPath(commFile.getFileSavePath(), commFile.getFileId()+"."+commFile.getFileType());
			String transformFilePath = getFileFullPath(commFile.getFileSavePath(), commFile.getFileId()+"."+commFile.getTransformType());
			int saveDiskFileNumber = saveUploadFileToDisk(multipartFile, filePath);
			// 插入和保存文件数量不同步，则删除文件。（这里的数量只可能是1）
			if (insertDataNumber != saveDiskFileNumber) {
				// 删除文件
				deleteFile(commFile.getFileId(), filePath, transformFileEnum != null, transformFilePath);
				break;
			}
			// 转换文件
			transformFile(transformFileEnum, filePath, transformFilePath);
			fileSaveNumber++;
		}
		return fileSaveNumber;
	}

	/**
	 * 转换文件
	 * 
	 * @param transformFileEnum
	 *            文件转换枚举
	 * @param filePath
	 *            文件路径
	 * @param transformFilePath
	 *            转换后的文件保存路径
	 */
	private void transformFile(TransformFileEnum transformFileEnum, String filePath, String transformFilePath) {
		if (transformFileEnum != null) {
			RepDocTemplate repDocTemplate = new RepDocTemplate();
			// 根据类型转换文件
			switch (transformFileEnum) {
			case DOC:
				// docToPdf(filePath, transformFilePath);
				repDocTemplate.wordToPdf(filePath, transformFilePath);
				break;
			case DOCX:
				// docToPdf(filePath, transformFilePath);
				repDocTemplate.wordToPdf(filePath, transformFilePath);
				break;
			default:
				// docToPdf(filePath, transformFilePath);
				repDocTemplate.wordToPdf(filePath, transformFilePath);
				break;
			}
		}
	}

	/**
	 * 插入生成的Word文件信息
	 * 
	 * @param documentPage
	 *            文档体参数对象
	 * @param paramDynamicTableMap
	 *            动态表Map
	 * @param bookmarks
	 *            循环表格书签集合
	 * @param fileName
	 *            下载显示的名称（不含后缀）
	 * @param templatePath
	 *            模板地址
	 * @param ascriptionType
	 *            归属类型，不能重复
	 * @param ascriptionId
	 *            归属ID
	 * @param remark
	 *            备注
	 * @return 保存的文件数量
	 */
	@Transactional(rollbackFor = Exception.class)
	public Integer saveGenerateWordFile(DocumentPage documentPage, Map<String, DocDynamicTable> paramDynamicTableMap, List<String> bookmarks, String fileName, String templatePath, String ascriptionType, String ascriptionId, String remark) {
		if (StringUtils.isBlank(ascriptionType) || StringUtils.isBlank(ascriptionId)) {
			return -1;
		}
		// 删除历史数据
		deleteFileByAscriptionIdAndFileName(ascriptionId, fileName);
		String userName = LoginCache.getLoginUser().getUserName();
		TransformFileEnum transformFileEnum = TransformFileEnum.DOCX;
		// 获取文件实体对象（不包含文件大小）
		CommFile commFile = getCommFile(ascriptionType, ascriptionId, fileName, remark, userName, transformFileEnum, AnalysisStateEnum.GENERATE);
		// 文件相对路径
		String fileSavePath = FILE_PIC_PATH + commFile.getFileSavePath();
		try {
			// 根据模板生成word文件
			RepDocTemplate repDocTemplate = new RepDocTemplate();
			repDocTemplate.saveWord(documentPage, paramDynamicTableMap, bookmarks, commFile.getFileId(), templatePath, false, fileSavePath);
			// 获取文件的真实路径
			String fileFullPath = getFileFullPath(commFile.getFileSavePath(), commFile.getFileId()+"."+commFile.getFileType());
			File file = new File(fileFullPath);
			if (file.exists() && file.isFile()) {
				long fileSize = file.length();
				// 设置文件大小
				commFile.setFileSize(fileSize);
				commFile.setFileFormatSize(formetFileSize(fileSize));

				// 1、将文件信息插入到数据库
				int insertDataNumber = insertFileInfo(commFile);
				// 如果数据保存失败，则跳过该文件
				if (insertDataNumber != 1) {
					return -1;
				}
				String transformFilePath = getFileFullPath(commFile.getFileSavePath(), commFile.getFileId()+"."+commFile.getTransformType());
				// 转换文件
				transformFile(transformFileEnum, fileFullPath, transformFilePath);
			} else {
				return -1;
			}
		} catch (Exception e) {
			e.printStackTrace();
			return -1;
		}
		return 1;
	}

	/**
	 * 根据归属ID和文件名称删除文件
	 * 
	 * @param ascriptionId
	 *            归属ID
	 * @param fileName
	 *            文件名称
	 * @return 删除的文件个数
	 */
	private Integer deleteFileByAscriptionIdAndFileName(String ascriptionId, String fileName) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("ascriptionId", ascriptionId);
		paramMap.put("fileName", fileName);
		Map<String, Object> resultMap = dao.get(paramMap, sqlPackage + ".queryFileByAscriptionIdAndFileName");
		if (resultMap == null || resultMap.size() == 0) {
			return 0;
		}
		return deleteFileByFileIds((String) resultMap.get("FILE_ID"));
	}

	/**
	 * 将文件信息插入到数据库
	 * 
	 * @param commFile
	 *            文件实体对象
	 * @return 插入的条数
	 */
	public Integer insertFileInfo(CommFile commFile) {
		Map<String, Object> map = new HashMap<String, Object>(2);
		map.put("commFile", commFile);
		return dao.insert(map, sqlPackage + ".insertFileInfo");
	}

	/**
	 * 将文件信息插入到数据库
	 * 
	 * @param commFile
	 *            文件实体对象
	 * @return 插入的条数
	 * @throws IOException
	 */
	@Transactional
	public Integer insertFileInfo(CommFile commFile, File tempFile, String savePath) throws IOException {
		commFile.setFileSavePath(savePath);
		int i = this.insertFileInfo(commFile);

		File destFile = new File(FILE_PIC_PATH + savePath + File.separator + commFile.getFileAlias());
		FileUtils.moveFile(tempFile, destFile);

		return i;
	}

	/**
	 * 获取文件实体对象
	 * 
	 * @param multipartFile
	 *            文件
	 * @param ascriptionType
	 *            归属类型(配合字典)
	 * @param ascriptionId
	 *            归属id
	 * @param remark
	 *            备注
	 * @param loginName
	 *            登录名
	 * @param transformFileEnum
	 *            转换文件枚举
	 * @param analysisStateEnum
	 *            分析状态枚举
	 * @return
	 */
	private CommFile getCommFile(MultipartFile multipartFile, String ascriptionType, String ascriptionId, String remark, String loginName, TransformFileEnum transformFileEnum, AnalysisStateEnum analysisStateEnum) {
		CommFile commFile = new CommFile();
		commFile.setFileId(UUIDUtil.randomUUID());
		commFile.setAscriptionType(ascriptionType);
		commFile.setAscriptionId(ascriptionId);
		String fileFullName = multipartFile.getOriginalFilename();
		commFile.setFileFullName(fileFullName);
		commFile.setFileName(fileFullName.substring(0, fileFullName.lastIndexOf(".")));
		commFile.setFileType(fileFullName.substring(fileFullName.lastIndexOf(".") + 1));
		commFile.setFileAlias(commFile.getFileId() + "." + commFile.getFileType());
		long fileSize = multipartFile.getSize();
		commFile.setFileSize(fileSize);
		commFile.setFileFormatSize(this.formetFileSize(fileSize));
		commFile.setFileSavePath(File.separator + ascriptionType + File.separator);
		commFile.setTransform(transformFileEnum != null ? "Y" : "N");
		commFile.setTransformType(transformFileEnum != null ? transformFileEnum.getTransformType() : null);
		commFile.setFileSource(analysisStateEnum.getValue());
		commFile.setRemark(remark);
		commFile.setCreateTime(DateUtil.history2("yyyy-MM-dd HH:mm:ss:SSS", 0));
		commFile.setCreateUser(loginName);
		return commFile;
	}

	/**
	 * 获取文件实体对象
	 * 
	 * @param ascriptionType
	 *            归属类型(配合字典)
	 * @param ascriptionId
	 *            归属id
	 * @param fileName
	 *            文件名（不含后缀）
	 * @param remark
	 *            备注
	 * @param loginName
	 *            登录名
	 * @param transformFileEnum
	 *            转换文件枚举
	 * @param analysisStateEnum
	 *            分析状态枚举
	 * @return
	 */
	private CommFile getCommFile(String ascriptionType, String ascriptionId, String fileName, String remark, String loginName, TransformFileEnum transformFileEnum, AnalysisStateEnum analysisStateEnum) {
		CommFile commFile = new CommFile();
		commFile.setFileId(UUIDUtil.randomUUID());
		commFile.setAscriptionType(ascriptionType);
		commFile.setAscriptionId(ascriptionId);
		String fileFullName = fileName + "." + transformFileEnum.getFileType();
		commFile.setFileFullName(fileFullName);
		commFile.setFileName(fileName);
		commFile.setFileType(transformFileEnum.getFileType());
		commFile.setFileAlias(commFile.getFileId() + "." + commFile.getFileType());
		commFile.setFileSavePath(File.separator + ascriptionType + File.separator);
		commFile.setTransform(transformFileEnum != null ? "Y" : "N");
		commFile.setTransformType(transformFileEnum != null ? transformFileEnum.getTransformType() : null);
		commFile.setFileSource(analysisStateEnum.getValue());
		commFile.setRemark(remark);
		commFile.setCreateTime(DateUtil.history2("yyyy-MM-dd HH:mm:ss:SSS", 0));
		commFile.setCreateUser(loginName);
		return commFile;
	}

	/**
	 * 保存文件到磁盘
	 * 
	 * @param multipartFile
	 *            文件
	 * @param filePath
	 *            文件全路径
	 * @param fileSavePath
	 *            文件保存路径
	 * @return 保存的文件条数
	 */
	private Integer saveUploadFileToDisk(MultipartFile multipartFile, String filePath) {
		// 文件不存在直接返回
		if (multipartFile.isEmpty()) {
			return 0;
		}
		File file = new File(filePath);
		try {
			// 如果文件不存在或不是文件，则创建文件
			if (!file.exists() || !file.isFile()) {
				// 判断文件父目录是否存在
				if (!file.getParentFile().exists() || !file.getParentFile().isDirectory()) {
					file.getParentFile().mkdirs();
				}
				// 创建文件
				file.createNewFile();
			}
			// 将上传的文件转换到本地资源存储
			multipartFile.transferTo(file);
		} catch (IOException e) {
			e.printStackTrace();
			return 0;
		}
		return 1;
	}

	/**
	 * 格式化文件大小
	 * 
	 * @param fileSize
	 *            需要格式化的文件大小
	 * @return 格式化后的文件大小
	 */
	public String formetFileSize(Long fileSize) {
		DecimalFormat df = new DecimalFormat("#.00");
		String fileSizeString = "";
		int b = 1024;
		int kb = b * b;
		int mb = b * b * b;
		if (fileSize < b) {
			fileSizeString = df.format((double) fileSize) + " B";
		} else if (fileSize < kb) {
			fileSizeString = df.format((double) fileSize / b) + " KB";
		} else if (fileSize < mb) {
			fileSizeString = df.format((double) fileSize / kb) + " MB";
		} else {
			fileSizeString = df.format((double) fileSize / mb) + " GB";
		}
		return fileSizeString;
	}

	/**
	 * 根据文件ID列表删除文件
	 * 
	 * @param fileIds
	 *            文件ID列表
	 * @return 删除文件数量
	 */
	public Integer deleteFileByFileIds(String... fileIds) {
		if (fileIds == null || fileIds.length == 0) {
			return 0;
		}
		Map<String, Object> paramMap = new HashMap<String, Object>(2);
		paramMap.put("fileIds", fileIds);
		// 查询文件信息
		List<Map<String, Object>> resultList = dao.list(paramMap, sqlPackage + ".queryFileByFileIds");
		int deleteFileNumber = 0;
		if (resultList != null && resultList.size() > 0) {
			for (Map<String, Object> fileMap : resultList) {
				// 文件ID
				String fileId = (String) fileMap.get("FILE_ID");
				String fileSavePath = (String) fileMap.get("FILE_SAVE_PATH");
				String fileType = (String) fileMap.get("FILE_TYPE");
				String transform = (String) fileMap.get("TRANSFORM");
				String transformType = (String) fileMap.get("TRANSFORM_TYPE");
				String filePath = getFileFullPath(fileSavePath, fileId+fileType);
				String transformFilePath = getFileFullPath(fileSavePath, fileId+"."+transformType);
				// 删除文件
				deleteFileNumber += deleteFile(fileId, filePath, "Y".equals(transform), transformFilePath);
			}
		}
		return deleteFileNumber;
	}

	/**
	 * 根据归属ID删除文件
	 * 
	 * @param ascriptionId
	 *            归属ID
	 * @return 删除文件数量
	 */
	public Integer deleteFilesByAscriptionId(String ascriptionId, AnalysisStateEnum... analysisStateEnums) {
		// 根据归属ID查询文件列表
		List<Map<String, Object>> fileList = queryFileListByAscriptionId(ascriptionId, analysisStateEnums);
		int deleteFileNumber = 0;
		if (fileList != null && fileList.size() > 0) {
			for (Map<String, Object> fileMap : fileList) {
				// 文件ID
				String fileId = (String) fileMap.get("FILE_ID");
				String fileSavePath = (String) fileMap.get("FILE_SAVE_PATH");
				String fileType = (String) fileMap.get("FILE_TYPE");
				String transform = (String) fileMap.get("TRANSFORM");
				String transformType = (String) fileMap.get("TRANSFORM_TYPE");
				String filePath = getFileFullPath(fileSavePath, fileId+"."+fileType);
				String transformFilePath = getFileFullPath(fileSavePath, fileId+"."+transformType);
				// 删除文件
				deleteFileNumber += deleteFile(fileId, filePath, "Y".equals(transform), transformFilePath);
			}
		}
		return deleteFileNumber;
	}

	/**
	 * 删除文件
	 * 
	 * @param fileId
	 *            文件ID
	 * @param filePath
	 *            文件全路径
	 * @param transform
	 *            是否转换
	 * @param transformFilePath
	 *            转换文件路径
	 * @return 删除的文件数
	 */
	private Integer deleteFile(String fileId, String filePath, Boolean transform, String transformFilePath) {
		// 删除数据库中的文件记录
		int deleteDataNumber = dao.delete(fileId, sqlPackage + ".deleteFileByFileId");
		if (deleteDataNumber != 1) {
			return 0;
		}
		File file = new File(filePath);
		// 删除文件
		boolean isDeleteFile = deleteDiskFile(file);
		// 如果是需要转换的文件，同时需要删除转换的文件
		if (transform) {
			File transformFile = new File(transformFilePath);
			deleteDiskFile(transformFile);
		}
		// 反向递归删除空文件夹
		deleteDir(file.getParentFile());
		if (isDeleteFile) {
			return 1;
		}
		return 0;
	}

	/**
	 * 删除磁盘文件
	 * 
	 * @param file
	 *            文件
	 * @return 是否删除成功
	 */
	private Boolean deleteDiskFile(File file) {
		if (file.exists() && file.isFile()) {
			return file.delete();
		}
		return false;
	}

	/**
	 * 反向递归删除空文件夹
	 * 
	 * @param dir
	 *            文件夹
	 * @return 是否删除成功
	 */
	private void deleteDir(File dir) {
		if (dir.exists() && dir.isDirectory()) {
			String[] files = dir.list();
			// 如果文件夹为空，则不删除
			if (files != null && files.length > 0) {
				return;
			}
			if (dir.delete()) {
				// 反向递归调用
				deleteDir(dir.getParentFile());
			}
		}
	}

	/**
	 * 根据文件名，获取转换枚举
	 * 
	 * @param fileName
	 *            文件名
	 * @return 转换枚举，如果不是需要转换的文件类型，则返回空
	 */
	private TransformFileEnum getTransformFileEnum(String fileName) {
		for (TransformFileEnum transformFileEnum : TransformFileEnum.values()) {
			if (fileName.endsWith("." + transformFileEnum.getFileType())) {
				return transformFileEnum;
			}
		}
		return null;
	}

	/**
	 * 根据Id获取是否有用户上传的报告
	 * 
	 * @Title: getPriorityFileByAscriptionId
	 * @Description: TODO
	 * @param queryMap
	 * @return
	 */
	public Integer getPriorityFileByAscriptionId(Map<String, Object> queryMap) {
		List<Map<String, Object>> list = dao.list(queryMap, sqlPackage + ".getPriorityFileByAscriptionId");
		return list.size();
	}
}

package ths.project.analysis.sourceAnalysis.service;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import ths.jdp.core.context.PropertyConfigure;
import ths.jdp.core.service.base.BaseService;
import ths.project.analysis.forecast.report.enums.AscriptionTypeEnum;
import ths.project.common.service.FileService;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("DistinctSourceResolveService")
public class DistinctSourceResolveService extends BaseService{
	//该服务层是区县源解析服务层
	private final String sqlPackage = "ths.air.web.analysis.sourceanalysis.distinctSourceResolveMapper";
	@Autowired
	private FileService fileService;
	/** 文件映射路径 **/
	private final static String FILE_PIC_URL = (String) PropertyConfigure.getProperty("FILE_ROOT_URL");


	/**
	 * 插入上传文件信息到公共文件表中
	 * @param map
	 */
	@Transactional(rollbackFor = Exception.class)
	public void insertFile(Map<String, Object> map) {
		dao.insert(map, sqlPackage+".insertFile");
	}
	
	/**
	 * 导入时插入报告表的信息
	 * @param map
	 */
	@Transactional(rollbackFor = Exception.class)
	public void addReportInfos(Map<String, Object> map) {
		dao.insert(map, sqlPackage+".addReportInfos");
	}
	
	/**
	 * 提交时更新T_ANS_GENERAL_REPORT预留字段
	 * @param map
	 */
	@Transactional(rollbackFor = Exception.class)
	public Integer updateReportInfosBySubmit(Map<String, Object> map) {
		return dao.update(map, sqlPackage+".updateReportInfosBySubmit");
	}
	
	/**
	 * 保存上传文件
	 * @param multipartFiles 文件列表
	 * @param paramMap 参数
	 * @return 
	 */
	@Transactional(rollbackFor = Exception.class)
	public boolean save(MultipartFile[] multipartFiles, Map<String, Object> paramMap) {
		//更新报告表预留信息
		String deleteFileIdStr = (String) paramMap.get("deleteFileIds");
		if (StringUtils.isNotBlank(deleteFileIdStr)) {
			String[] deleteFileIds = deleteFileIdStr.split(",");
			// 删除前台删除的文件
			fileService.deleteFileByFileIds(deleteFileIds);
		}
		fileService.saveUploadFile(multipartFiles, AscriptionTypeEnum.DISTINCTSOURCE_ANALYSIS.toString(), String.valueOf(paramMap.get("REPORT_ID")), false, "");
		return dao.update(paramMap, sqlPackage+".updateReportInfos")>0;
	}
	/**
	 * 根据报告id得到相应的报告字段信息
	 * @param paramsMap
	 * @return
	 */
	public Map<String, Object> getReportInfoById(Map<String, Object> paramsMap){
		return dao.get(paramsMap, sqlPackage+".getReportInfoById");
	}
	
	/**
	 * 根据报告id得到相应的上传文件信息
	 * @param paramsMap
	 * @return
	 */
	public List<Map<String, Object>> getUploadFileInfoById(Map<String, Object> paramsMap){
		return dao.list(paramsMap, sqlPackage+".getUploadFileInfoById");
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
				fileMap.put("FILE_URL", fileUrl);			}
		}
		return fileList;
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
	 * 根据填报年份得到所有文件信息
	 * @param paramsMap
	 * @return
	 */
	public List<Map<String, Object>> queryReportInfosByYear(Map<String, Object> paramsMap){
		return dao.list(paramsMap, sqlPackage+".queryReportInfosByYear");
	}
	
	/**
	 * 查询各个区县的冬季、不同污染颗粒组分占比
	 * @param paramsMap
	 * @return
	 */
	public List<Map<String, Object>> queryCountyInWinter(Map<String, Object> paramsMap){
		return dao.list(paramsMap, sqlPackage+".queryCountyInWinter");
	}
	/**
	 * 查询各个区县的夏季、不同污染颗粒组分占比
	 * @param paramsMap
	 * @return
	 */
	public List<Map<String, Object>> queryCountyInSummer(Map<String, Object> paramsMap){
		return dao.list(paramsMap, sqlPackage+".queryCountyInSummer");
	}
	
	/**
	 * 删除文件
	 * @param paramsMap
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public Boolean deletefile(Map<String, Object> paramsMap) {
		
		String path = fileService.getFileFullPath(paramsMap);
		
		Boolean flag = false;
		File file = new File(path);	
		try {
			if(file.exists()) {
				//删除T_COMM_FILE相应的记录
				int i = dao.delete(paramsMap, sqlPackage+".deletefile");
				//删除主表T_ANS_GENERAL_REPORT
				dao.delete(paramsMap, sqlPackage+".deleteGeneralReportById");
				//删除EXCEL中SHEET相对应的表记录：T_ANS_SOURCECOUNTY
				dao.delete(paramsMap, sqlPackage+".deleteSourceCountyById");
				file.delete();
				flag = i>0;
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		return flag;
	}
}

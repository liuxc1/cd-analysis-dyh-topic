package ths.project.analysis.sourceAnalysis.service;

import org.apache.commons.io.FileUtils;
import org.springframework.stereotype.Component;

import ths.jdp.core.model.LoginUserModel;
import ths.jdp.core.web.LoginCache;
import ths.jdp.eform.service.components.excel.ExcelProp;
import ths.jdp.eform.service.components.excel.model.ImportCallbackProp;
import ths.project.analysis.forecast.report.enums.AscriptionTypeEnum;
import ths.project.common.service.FileService;
import ths.project.common.util.DateUtil;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.Map;

/**
 * 源解析辅助类
 * @author 杨京承
 *
 */
@Component
public class HandlerExcelSourceResolveToolService {
	
	
	/**
	 * 添加报告Report信息到T_ANS_GENERAL_REPORT表
	 * @param variables
	 * @param object
	 * @return 
	 */
	public Map<String, Object> addreportInfos(Map<String, Object> variables,AscriptionTypeEnum sourceResolveType) {
		LoginUserModel loginUser = LoginCache.getLoginUser();
		Map<String, Object> infosMap = new HashMap<>();
		infosMap.put("REPORT_ID", variables.get("ASCRIPTION_ID"));
		infosMap.put("ASCRIPTION_TYPE",  sourceResolveType);
		infosMap.put("REPORT_NAME", variables.get("REPORT_NAME"));
		infosMap.put("REPORT_TIME", variables.get("YEARS"));
		infosMap.put("REPORT_RATE", "YEAR");
		infosMap.put("REPORT_TYPE",  sourceResolveType);
		infosMap.put("STATE",  "TEMP");
		
		infosMap.put("CREATE_TIME", DateUtil.nowHMS());
		infosMap.put("CREATE_DEPT", loginUser.getDeptName());
		infosMap.put("CREATE_USER", loginUser.getUserName());
		infosMap.put("EDIT_TIME", DateUtil.nowHMS());
		infosMap.put("EDIT_USER", loginUser.getUserName());
		return infosMap;
		
	}
	
	/**
	 * 封装公共文件参数
	 * @param variables
	 * @param props
	 * @param file
	 * @param loginUser
	 * @return
	 */
	public Map<String, Object> packageCommonFileParameter(Map<String, Object> variables, ExcelProp props, File file, LoginUserModel loginUser,AscriptionTypeEnum sourceResolveType){
		
		Map<String,Object> paramMap = new HashMap<String,Object>();
		//文件ID
		paramMap.put("FILE_ID", variables.get("ASCRIPTION_ID"));
		
		//归属类型(*)
		paramMap.put("ASCRIPTION_TYPE", sourceResolveType);
		//归属类型(*)
		paramMap.put("ASCRIPTION_ID", variables.get("ASCRIPTION_ID"));
		
		String excelName = String.valueOf(props.getSheetList().get(0).get("EXCELNAME"));
		//文件全名
		paramMap.put("FILE_FULL_NAME", excelName);
		String[] arr = excelName.split("\\.");
		//文件名称(无后缀)
		paramMap.put("FILE_NAME",arr[0]);
		String filePath = file.getPath();
		String fileAlias = filePath.substring(filePath.lastIndexOf("\\")+1,filePath.length());
		//文件别名
		paramMap.put("FILE_ALIAS",fileAlias);
		//文件类型
		paramMap.put("FILE_TYPE",arr[1]);
		//文件大小
		paramMap.put("FILE_SIZE",file.length());
		//文件格式化大小(如5MB)
		paramMap.put("FILE_FORMAT_SIZE", String.format("%.2f", ((double)file.length()/1024))+"KB");
		//磁盘路径
		paramMap.put("FILE_SAVE_PATH",File.separator+sourceResolveType+File.separator);
		//是否转换
		paramMap.put("TRANSFORM",'N');
		//转换类型
		paramMap.put("FILE_SOURCE", "UPLOAD");
		paramMap.put("CREATE_USER", loginUser.getUserName());
		paramMap.put("CREATE_TIME", DateUtil.nowHMS());
		paramMap.put("YEARS", variables.get("YEARS"));
		try {
			paramMap.put("REPORT_NAME", URLDecoder.decode((String) variables.get("REPORT_NAME"),"UTF-8"));
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return paramMap;
	}
	
	/**
	 * 复制文件到公共文件夹
	 * @param variables
	 * @param file
	 * @param props
	 */
	public void copyFileToCommonDir(Map<String, Object> variables,File file, ExcelProp props,AscriptionTypeEnum sourceResolveType) {
		String excelName = String.valueOf(props.getSheetList().get(0).get("EXCELNAME"));
		String[] arr = excelName.split("\\.");
		//将文件移到公共目录
		StringBuilder commFilePath = new StringBuilder();
		//重新拼接文件路径名
		commFilePath.append(FileService.FILE_PIC_PATH).append(File.separator).append(sourceResolveType)
		.append(File.separator).append(variables.get("ASCRIPTION_ID")).append(".").append(arr[1]);
			System.out.println(commFilePath.toString());
		try {
			FileUtils.copyFile(file, new File(commFilePath.toString()));
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 前置参数
	 * @param callbackProp
	 */
	public void forebackParameter(ImportCallbackProp callbackProp, AscriptionTypeEnum sourceResolveType) {
		Map<String, Object> variables = callbackProp.getVariables();
		
		LoginUserModel loginUser = LoginCache.getLoginUser();
		
		variables.put("CREATE_TIME", DateUtil.nowHMS());
		variables.put("CREATE_DEPT", loginUser.getDeptName());
		variables.put("CREATE_USER", loginUser.getUserName());
		variables.put("EDIT_TIME", DateUtil.nowHMS());
		variables.put("EDIT_USER", loginUser.getUserName());
		variables.put("ASCRIPTION_TYPE", sourceResolveType);
	}
	
}

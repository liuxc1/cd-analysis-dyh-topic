package ths.project.analysis.sourceAnalysis.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ths.jdp.core.model.LoginUserModel;
import ths.jdp.core.web.LoginCache;
import ths.jdp.eform.service.components.excel.ExcelImportCallbackInterface;
import ths.jdp.eform.service.components.excel.ExcelProp;
import ths.jdp.eform.service.components.excel.model.ImportCallbackProp;
import ths.project.analysis.forecast.report.enums.AscriptionTypeEnum;

import java.io.File;
import java.util.Map;

@Service("HandleSourceResolveService")
public class HandleSourceResolveService implements ExcelImportCallbackInterface{
	@Autowired
	private SourceResolveService sourceResolveService;
	@Autowired
	private HandlerExcelSourceResolveToolService handlerExcelSourceResolveToolService;
	@Override
	public ImportCallbackProp beforeCallback(ImportCallbackProp callbackProp) throws Exception {
		return null;
	}

	@Override
	public ImportCallbackProp afterCallback(ImportCallbackProp callbackProp) throws Exception {
			
		try {
			ExcelProp props = callbackProp.getExcelProp();
			Map<String, Object> variables = callbackProp.getVariables();
		
			sourceResolveService.updatefields(variables);
			
			LoginUserModel loginUser = LoginCache.getLoginUser();
			String filePath = String.valueOf(variables.get("excelFilePath"));
			File file = new File(filePath);
		
			if(file.exists()){
				Map<String, Object> paramMap = handlerExcelSourceResolveToolService.packageCommonFileParameter(variables,props,file,loginUser, AscriptionTypeEnum.SOURCE_ANALYSIS);
				//插入文件信息
				sourceResolveService.insertFile(paramMap);
				//暂时插入报表内容
				Map<String, Object> infosMap = handlerExcelSourceResolveToolService.addreportInfos(paramMap,AscriptionTypeEnum.SOURCE_ANALYSIS);
				sourceResolveService.addReportInfos(infosMap);
				//复制文件到文件夹
				handlerExcelSourceResolveToolService.copyFileToCommonDir(variables, file, props,AscriptionTypeEnum.SOURCE_ANALYSIS);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return callbackProp;
	}
	
	
	public void forefrontCallback(ImportCallbackProp callbackProp){
		
		handlerExcelSourceResolveToolService.forebackParameter(callbackProp,AscriptionTypeEnum.SOURCE_ANALYSIS);
	}

}

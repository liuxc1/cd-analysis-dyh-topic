package ths.project.analysis.forecast.airforecastparition.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import ths.jdp.core.service.base.BaseService;
import ths.jdp.core.web.LoginCache;
import ths.jdp.eform.service.components.excel.ExcelImportCallbackInterface;
import ths.jdp.eform.service.components.excel.model.ImportCallbackProp;

@Service
@Component("ExcelHandleService")
public class ExcelHandleService extends BaseService implements ExcelImportCallbackInterface{
	private final String sqlPackage = "ths.project.analysis.air.partition.service.mapper.ExcelHandleMapper";
	@Override
	public ImportCallbackProp beforeCallback(ImportCallbackProp callbackProp)
			throws Exception {
		Map<String, Object> paramMap=new HashMap<String, Object>();
		paramMap.put("LOGINNAME",LoginCache.getLoginUser().getLoginName());
		dao.delete(paramMap, sqlPackage+".delete");
		return callbackProp;
	}

	@Override
	public ImportCallbackProp afterCallback(ImportCallbackProp callbackProp)
			throws Exception {
		return callbackProp;
	}
}

package ths.project.analysis.forecast.airforecastmonth.service;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import ths.jdp.core.service.base.BaseService;
import ths.jdp.core.web.LoginCache;
import ths.jdp.eform.service.components.excel.ExcelImportCallbackInterface;
import ths.jdp.eform.service.components.excel.model.ImportCallbackProp;

/**
 * @ClassName: MonthTrendExcelHandleService
 * @Description: 月趋势预报Excel导入处理
 * @author D
 * @date 2019年2月28日 下午1:18:55
 */
@Service
@Component("MonthTrendExcelHandleService")
public class MonthTrendExcelHandleService extends BaseService implements ExcelImportCallbackInterface {
	
	
	@Resource
	private MonthTrendService monthTrendService;
	
	@Override
	public ImportCallbackProp beforeCallback(ImportCallbackProp callbackProp) throws Exception {
		// 删除临时表数据
		Map<String, Object> paramMap=new HashMap<String, Object>();
		paramMap.put("LOGINNAME",LoginCache.getLoginUser().getLoginName());
		monthTrendService.deleteForecastTempById(paramMap);
		return callbackProp;
	}
	
	@Override
	public ImportCallbackProp afterCallback(ImportCallbackProp callbackProp) throws Exception {
		return callbackProp;
	}	
}
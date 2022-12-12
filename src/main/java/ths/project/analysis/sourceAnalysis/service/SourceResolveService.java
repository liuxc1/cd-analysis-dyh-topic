package ths.project.analysis.sourceAnalysis.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ths.jdp.core.service.base.BaseService;
import ths.project.common.service.FileService;

import java.io.File;
import java.util.List;
import java.util.Map;

@Service("SourceResolveService")
public class SourceResolveService extends BaseService{

	private final String sqlPackage = "ths.air.web.analysis.sourceanalysis.SourceResolveMapper";
	@Autowired
	private FileService fileService;
	
	/**
	 * 更新T_ANS_SOURCE_SEQUENTIAL 
	 * T_ANS_SOURCE_COMPREHENSIVE
	 * T_ANS_SOURCE_CALENDAR_YEAR
	 */
	public void updatefields(Map<String, Object> map) {
		dao.update(map, sqlPackage+".updatecitySequential");
		dao.update(map, sqlPackage+".updatecityComprehensive");
		dao.update(map, sqlPackage+".updateSourceTypeCode");
		dao.update(map, sqlPackage+".updateCityCalendarYear");
	}
	
	/**
	 * 插入上传文件信息到公共文件表中
	 * @param map
	 */
	public void insertFile(Map<String, Object> map) {
		dao.insert(map, sqlPackage+".insertFile");
	}
	
	/**
	 * 导入时插入报告表的信息
	 * @param map
	 */
	public void addReportInfos(Map<String, Object> map) {
		dao.insert(map, sqlPackage+".addReportInfos");
	}
	
	
	/**
	 * 更新T_ANS_GENERAL_REPORT预留字段
	 * @param map
	 */
	public Integer updateReportInfos(Map<String, Object> map) {
		return dao.update(map, sqlPackage+".updateReportInfos");
	}
	
	/**
	 * 提交时更新T_ANS_GENERAL_REPORT预留字段
	 * @param map
	 */
	public Integer updateReportInfosBySubmit(Map<String, Object> map) {
		return dao.update(map, sqlPackage+".updateReportInfosBySubmit");
	}
	
	/**
	 * 删除文件
	 * @param paramsMap
	 * @return
	 */
	@Transactional
	public Boolean deletefile(Map<String, Object> paramsMap) {
		
		String path = fileService.getFileFullPath(paramsMap);
		
		Boolean flag = false;
		File file = new File(path);	
		try {
			if(file.exists()) {
				file.delete();
			}
			int i = dao.delete(paramsMap, sqlPackage+".deletefile");
			//删除EXCEL中SHEET相对应的表记录：T_ANS_SOURCE_CALENDAR_YEAR、T_ANS_SOURCE_COMPREHENSIVE、T_ANS_SOURCE_SEQUENTIAL
			//删除主表T_ANS_GENERAL_REPORT
			dao.delete(paramsMap, sqlPackage+".deleteGeneralReportById");
			dao.delete(paramsMap, sqlPackage+".deleteSourceSequentialById");
			dao.delete(paramsMap, sqlPackage+".deleteSourceComprehensiveById");
			dao.delete(paramsMap, sqlPackage+".deleteCalendarYearById");
			flag = i > 0;
		}catch (Exception e) {
			e.printStackTrace();
		}
		return flag;
	}
	
	/**
	 * 根据填报年份得到相对应的报告文件
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> queryReportListByYear(Map<String, Object> map){
		return dao.list(map, sqlPackage+".queryReportListByYear");
	}
	
	/**
	 * 根据报告id得到相对应的报告文件
	 * @param map
	 * @return
	 */
	public Map<String, Object> queryReportListById(Map<String, Object> map){
		return dao.get(map, sqlPackage+".queryReportListById");
	}

	/**
	 * 根据报告文件得到浓度时序信息
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> querySourceSequential(Map<String, Object> map){
		return dao.list(map, sqlPackage+".querySourceSequential");
	}
	/**
	 * 根据报告文件得到中心城区解析 (第一个图)
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> querySourceComprehensive1(Map<String, Object> map){
		return dao.list(map, sqlPackage+".querySourceComprehensive1");
	}
	/**
	 * 根据报告文件得到中心城区解析 (第二个图)
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> querySourceComprehensive2(Map<String, Object> map){
		return dao.list(map, sqlPackage+".querySourceComprehensive2");
	}
	/**
	 * 根据报告文件得到历年源解析
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> querySourceCalendarYear(Map<String, Object> map){
		return dao.list(map, sqlPackage+".querySourceCalendarYear");
	}
	
	
	

}

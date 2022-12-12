package ths.project.analysis.sourceAnalysis.web;

import org.apache.commons.collections.MapUtils;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import ths.jdp.core.model.LoginUserModel;
import ths.jdp.core.web.LoginCache;
import ths.jdp.core.web.RequestHelper;
import ths.jdp.core.web.base.BaseController;
import ths.jdp.custom.util.res.Path;
import ths.jdp.eform.service.components.excel.ExcelTemplateService;
import ths.jdp.util.Tool;
import ths.project.analysis.sourceAnalysis.service.SourceResolveService;
import ths.project.common.util.DateUtil;
import ths.project.common.vo.ResponseVo;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@RequestMapping("/analysis/sourceanalysis")
public class SourceResolveController extends BaseController {
	
	/**
	 * 源解析服务层
	 */
	@Resource
	private SourceResolveService sourceResolveService;



	@RequestMapping("/index")
	public ModelAndView index(@RequestParam Map<String, Object> paramsMap) {
		ModelAndView mView = new ModelAndView("/analysis/sourceanalysis/sourceResolveIndex");
		mView.addObject("showTitle", paramsMap.get("showTitle"));
		return mView;
	}
	
	@RequestMapping("/edit")
	public ModelAndView addPage(@RequestParam Map<String, Object> paramsMap) {
		String rid = String.valueOf(paramsMap.get("reportId"));
		//表示当前是添加页面
		if(paramsMap.get("reportId") == null || org.apache.commons.lang.StringUtils.isBlank(rid)) {
			rid = UUID.randomUUID().toString().replaceAll("-", "");
		}
		ModelAndView mView = new ModelAndView("/analysis/sourceanalysis/sourceResolveAdd");
		paramsMap.put("REPORT_ID", rid);
		mView.addObject("paramsMap", paramsMap);
		return mView;
	}
	
	@RequestMapping("/save")
	@ResponseBody
	public ResponseVo save(@RequestParam Map<String, Object> paramsMap) {
		ResponseVo responseVo = new ResponseVo();
		try {
			LoginUserModel loginUser = LoginCache.getLoginUser();
			paramsMap.put("EDIT_TIME", DateUtil.nowHMS());
			paramsMap.put("EDIT_USER", loginUser.getUserName());
			responseVo.success(sourceResolveService.updateReportInfos(paramsMap));
		} catch (Exception e) {
			e.printStackTrace();
			responseVo.failure("系统繁忙！");
		}
		return responseVo;
	}
	
	@RequestMapping("/submit")
	@ResponseBody
	public ResponseVo submit(@RequestParam Map<String, Object> paramsMap) {
		ResponseVo responseVo = new ResponseVo();
		try {
			LoginUserModel loginUser = LoginCache.getLoginUser();
			paramsMap.put("EDIT_TIME", DateUtil.nowHMS());
			paramsMap.put("EDIT_USER", loginUser.getUserName());
			responseVo.success(sourceResolveService.updateReportInfosBySubmit(paramsMap));
		} catch (Exception e) {
			e.printStackTrace();
			responseVo.failure("系统繁忙！");
		}
		return responseVo;
	}
	
	/**
	 * 删除对应的报告文件及记录
	 * @param paramsMap
	 * @return
	 */
	@RequestMapping("/delete")
	@ResponseBody
	public ResponseVo delete(@RequestParam Map<String, Object> paramsMap) {
		ResponseVo responseVo = new ResponseVo();
		try {
			responseVo.success(sourceResolveService.deletefile(paramsMap));
		} catch (Exception e) {
			e.printStackTrace();
			responseVo.failure("系统繁忙！");
		}
		return responseVo;
	}
	
	
	
	/**
	 * 根据填报年份，查询列表
	 * @param paramMap 参数
	 * @return 
	 */
	@RequestMapping("/queryReportListByYear")
	@ResponseBody
	public ResponseVo queryReportListByYear(@RequestParam Map<String, Object> paramMap) {
		ResponseVo responseVo = new ResponseVo();
		try {
				List<Map<String, Object>> resultList = sourceResolveService.queryReportListByYear(paramMap);
				if (resultList != null && resultList.size() > 0) {
					responseVo.success(resultList);
				} else {
					responseVo.failure("暂无数据！");
				}
		} catch (Exception e) {
			e.printStackTrace();
			responseVo.failure("服务器繁忙，请稍后重试！");
		}
		return responseVo;
	}
	/**
	 * 根据报告id查询对应文件
	 * @param paramMap 参数
	 * @return 
	 */
	@RequestMapping("/queryReportListById")
	@ResponseBody
	public ResponseVo queryReportListById(@RequestParam Map<String, Object> paramMap) {
		ResponseVo responseVo = new ResponseVo();
		try {
			Map<String, Object> map = sourceResolveService.queryReportListById(paramMap);
			if (map != null) {
				responseVo.success(map);
			} else {
				responseVo.failure("暂无数据！");
			}
		} catch (Exception e) {
			e.printStackTrace();
			responseVo.failure("服务器繁忙，请稍后重试！");
		}
		return responseVo;
	}

	
	/**
	 * 根据报告文件查询时序图
	 * @param paramMap
	 * @return
	 */
	@RequestMapping("/querySourceSequential")
	@ResponseBody
	public ResponseVo querySourceSequential(@RequestParam Map<String, Object> paramMap) {
		ResponseVo responseVo = new ResponseVo();
		try {
			List<Map<String, Object>> resultList = sourceResolveService.querySourceSequential(paramMap);
			if (resultList != null && resultList.size() > 0) {
				responseVo.success(resultList);
			} else {
				responseVo.failure("暂无数据！");
			}
		} catch (Exception e) {
			e.printStackTrace();
			responseVo.failure("服务器繁忙，请稍后重试！");
		}
		return responseVo;
	}
	/**
	 * 根据报告文件查询中心城区综合解析
	 * @param paramMap
	 * @return
	 */
	@RequestMapping("/querySourceComprehensive")
	@ResponseBody
	public ResponseVo querySourceComprehensive(@RequestParam Map<String, Object> paramMap) {
		ResponseVo responseVo = new ResponseVo();
		try {
			List<Map<String, Object>> resultList1 = sourceResolveService.querySourceComprehensive1(paramMap);
			List<Map<String, Object>> resultList2 = sourceResolveService.querySourceComprehensive2(paramMap);
			List<List<Map<String, Object>>> resultList = new ArrayList<>();
			resultList.add(resultList1);
			resultList.add(resultList2);
			if (resultList != null && resultList.size() > 0) {
				responseVo.success(resultList);
			} else {
				responseVo.failure("暂无数据！");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			responseVo.failure("服务器繁忙，请稍后重试！");
		}
		return responseVo;
	}
	
	/**
	 * 根据报告文件查询时序图
	 * @param paramMap
	 * @return
	 */
	@RequestMapping("/querySourceCalendarYear")
	@ResponseBody
	public ResponseVo querySourceCalendarYear(@RequestParam Map<String, Object> paramMap) {
		ResponseVo responseVo = new ResponseVo();
		try {
			List<Map<String, Object>> resultList = sourceResolveService.querySourceCalendarYear(paramMap);
			if (resultList != null && resultList.size() > 0) {
				responseVo.success(resultList);
			} else {
				responseVo.failure("暂无数据！");
			}
		} catch (Exception e) {
			e.printStackTrace();
			responseVo.failure("服务器繁忙，请稍后重试！");
		}
		return responseVo;
	}


	/**
	 *  模版下载
	 */
	@RequestMapping("/templateDownload")
	public void templateDownload(HttpServletResponse response, @RequestParam Map<String, Object> paramMap) throws Exception {
		InputStream input = null;
		OutputStream ouputStream = null;
		StringBuilder path = new StringBuilder("/template/SourceResolve.xlsx");
		SimpleDateFormat sDateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Date date = sDateFormat.parse(MapUtils.getString(paramMap, "datetime", DateUtil.getNowDateTime()));
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);

		try {
			input = new FileInputStream(RequestHelper.getSession().getServletContext().getRealPath(path.toString()));
			String monthName = "成都市源解析";
			monthName = new String(monthName.getBytes("gbk"), "iso8859-1");
			response.setHeader("Content-Length", String.valueOf(input.available()));
			response.setContentType("application/vnd.ms-excel;charset=utf-8");
			response.setHeader("Content-disposition", "attachment;filename="+monthName+".xlsx");

			ouputStream = response.getOutputStream();
			byte[] b = new byte[1024];
			int len;
			while ((len = input.read(b)) > 0) {
				ouputStream.write(b, 0, len);
			}
		} finally {
			if (input != null) {
				try {
					input.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			if (ouputStream != null) {
				try {
					ouputStream.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}



	
	
	
}

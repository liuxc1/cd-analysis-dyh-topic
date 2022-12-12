package ths.project.analysis.sourceAnalysis.web;


import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import ths.jdp.core.model.LoginUserModel;
import ths.jdp.core.web.LoginCache;
import ths.jdp.core.web.base.BaseController;
import ths.project.analysis.sourceAnalysis.service.DistinctSourceResolveService;
import ths.project.common.service.FileService;
import ths.project.common.util.DateUtil;
import ths.project.common.vo.ResponseVo;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Controller
@RequestMapping("/analysis/sourceanalysis/distinctSourceResolve")
public class DistinctSourceResolveController extends BaseController {
	
	/**
	 * 区县源解析服务层
	  */
	@Resource
	private DistinctSourceResolveService distinctSourceResolveService;
	@Resource
	private FileService fileService;

	@RequestMapping("/index")
	public String index() {
		return "/analysis/sourceanalysis/distinctSourceResolveIndex";
	}
	
	
	@RequestMapping("/edit")
	public ModelAndView edit(@RequestParam Map<String, Object> paramsMap) {
		String rid = String.valueOf(paramsMap.get("reportId"));
		//表示当前是添加页面
		if(paramsMap.get("reportId") == null || org.apache.commons.lang.StringUtils.isBlank(rid)) {
			rid = UUID.randomUUID().toString().replaceAll("-", "");
		}
		ModelAndView mView = new ModelAndView("/analysis/sourceanalysis/distinctSourceResolveAdd");
		paramsMap.put("REPORT_ID", rid);
		mView.addObject("paramsMap", paramsMap);
		return mView;
	}
	
	
	/**
	 * 保存文件图片到报告表中
	 * @param multipartFiles 文件列表
	 * @param paramMap 参数
	 * @return 无
	 */
	@RequestMapping("/saveFilesToReport")
	@ResponseBody
	public ResponseVo saveFilesToReport(@RequestParam(value = "FILES", required = false) MultipartFile[] multipartFiles, @RequestParam Map<String, Object> paramMap) {
		ResponseVo responseVo = new ResponseVo();
		try {
			LoginUserModel loginUser = LoginCache.getLoginUser();
			paramMap.put("EDIT_TIME", DateUtil.nowHMS());
			paramMap.put("EDIT_USER", loginUser.getUserName());
			if (distinctSourceResolveService.save(multipartFiles, paramMap)) {
				responseVo.success(true);
			}else {
				responseVo.failure();
			}
		} catch (Exception e) {
			e.printStackTrace();
			responseVo.failure("系统繁忙，请稍后重试！");
		}
		return responseVo;
	}
	
	/**
	 * 根据报告id查询对应文件
	 * @param paramMap 参数
	 * @return 
	 */
	@RequestMapping("/getReportInfoById")
	@ResponseBody
	public ResponseVo getReportInfoById(@RequestParam Map<String, Object> paramMap) {
		ResponseVo responseVo = new ResponseVo();
		try {
			Map<String, Object> map = distinctSourceResolveService.getReportInfoById(paramMap);
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
	 * 根据报告id查询对应上传文件信息
	 * @param paramMap 参数
	 * @return 
	 */
	@RequestMapping("/getUploadFileInfoById")
	@ResponseBody
	public ResponseVo getUploadFileInfoById(@RequestParam Map<String, Object> paramMap) {
		ResponseVo responseVo = new ResponseVo();
		try {
			List<Map<String, Object>> list = distinctSourceResolveService.getUploadFileInfoById(paramMap);
			if (list != null) {
				responseVo.success(list);
			} else {
				responseVo.failure("暂无数据！");
			}
		} catch (Exception e) {
			e.printStackTrace();
			responseVo.failure("服务器繁忙，请稍后重试！");
		}
		return responseVo;
	}
	
	//根据归属ID，查询文件列表
	@RequestMapping("/queryFileListByAscriptionId")
	@ResponseBody
	public ResponseVo queryFileListByAscriptionId(@RequestParam Map<String, Object> paramMap) {
		ResponseVo responseVo = new ResponseVo();
		try {
			// 报告ID不能为空
			if (StringUtils.isBlank((String) paramMap.get("REPORT_ID"))) {
				responseVo.failure("请求参数错误，可能值为空或包含非法字符。");
				return responseVo;
			}
			String reportId = String.valueOf(paramMap.get("REPORT_ID"));
			String[] fileSources = null;
			List<Map<String, Object>> list = distinctSourceResolveService.queryFileListByAscriptionId(reportId,fileSources);
			if (list != null) {
				responseVo.success(list);
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
	 * 根据填报年份查询对应文件信息
	 * @param paramMap 参数
	 * @return 
	 */
	@RequestMapping("/queryReportInfosByYear")
	@ResponseBody
	public ResponseVo queryReportInfosByYear(@RequestParam Map<String, Object> paramMap) {
		ResponseVo responseVo = new ResponseVo();
		try {
			List<Map<String, Object>> list = distinctSourceResolveService.queryReportInfosByYear(paramMap);
			if (list != null && list.size() > 0) {
				responseVo.success(list);
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
	 * 查询区县组分特征占比
	 * @param paramMap 参数
	 * @return 
	 */
	@RequestMapping("/queryCounty")
	@ResponseBody
	public ResponseVo queryCounty(@RequestParam Map<String, Object> paramMap) {
		ResponseVo responseVo = new ResponseVo();
		try {
			List<Map<String, Object>> list1 = distinctSourceResolveService.queryCountyInSummer(paramMap);
			List<Map<String, Object>> list2 = distinctSourceResolveService.queryCountyInWinter(paramMap);
			List<List<Map<String, Object>>> list = new ArrayList<>();
			list.add(list1);
			list.add(list2);
			if (list != null && list.size() > 0) {
				responseVo.success(list);
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
	 * 首页点击提交
	 * @param paramsMap
	 * @return
	 */
	@RequestMapping("/submit")
	@ResponseBody
	public ResponseVo submit(@RequestParam Map<String, Object> paramsMap) {
		ResponseVo responseVo = new ResponseVo();
		try {
			LoginUserModel loginUser = LoginCache.getLoginUser();
			paramsMap.put("EDIT_TIME", DateUtil.nowHMS());
			paramsMap.put("EDIT_USER", loginUser.getUserName());
			responseVo.success(distinctSourceResolveService.updateReportInfosBySubmit(paramsMap));
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
			responseVo.success(distinctSourceResolveService.deletefile(paramsMap));
		} catch (Exception e) {
			e.printStackTrace();
			responseVo.failure("系统繁忙！");
		}
		return responseVo;
	}
	
	
}

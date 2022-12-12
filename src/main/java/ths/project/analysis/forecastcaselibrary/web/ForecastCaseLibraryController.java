package ths.project.analysis.forecastcaselibrary.web;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import ths.jdp.core.context.PropertyConfigure;
import ths.jdp.core.dao.base.Paging;
import ths.project.analysis.forecastcaselibrary.service.ForecastCaseLibraryService;
import ths.project.common.data.DataResult;
import ths.project.common.util.ExcelUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;


@Controller
@RequestMapping("/analysis/forecastCastLibrary")
public class ForecastCaseLibraryController {

    @Autowired
    private ForecastCaseLibraryService forecastCaseService;


    /**
     * 跳转页面
     */
    @RequestMapping("/index")
    public String index() {
    	
        return "analysis/forecastcaselibrary/index";
    }

    /**
     * 跳转添加页面
     */
    @RequestMapping("/add")
    public String add() {

        return "analysis/forecastcaselibrary/add";
    }

    /**
     * 跳转添加页面
     */
    @RequestMapping("/view")
    public String view(String id, Model model) {
        model.addAttribute("id", id);
        return "analysis/forecastcaselibrary/view";
    }

    /**
     * 保存案例
     */
    @ResponseBody
    @RequestMapping("/save")
    public DataResult save(@RequestParam Map<String, Object> paramMap) {

        return DataResult.success(forecastCaseService.save(paramMap));
    }

    /**
     * 删除案例
     */
    @ResponseBody
    @RequestMapping("/delete")
    public DataResult delete(@RequestParam Map<String, Object> paramMap) {

        return DataResult.success(forecastCaseService.delete(paramMap));
    }

    /**
     * 案例列表查询
     */
    @ResponseBody
    @RequestMapping("/queryCastList")
    public DataResult queryCastList(@RequestParam Map<String, Object> paramMap, Paging<Map<String, Object>> paging) {

        return DataResult.success(forecastCaseService.queryCastList(paging, paramMap));
    }

    /**
     * 计算列表
     */
    @ResponseBody
    @RequestMapping("/queryCalculationDataList")
    public DataResult queryCalculationDataList(@RequestParam Map<String, Object> paramMap) {

        return DataResult.success(forecastCaseService.queryCalculationDataList(paramMap));
    }

    /**
     * 更据id查询记录
     */
    @ResponseBody
    @RequestMapping("/queryCastById")
    public DataResult queryCastById(@RequestParam Map<String, Object> paramMap) {
        return DataResult.success(forecastCaseService.queryCastById(paramMap));
    }

    /**
     * 污染过程分析
     */
    @ResponseBody
    @RequestMapping("/queryPollutionAnalysisCharts")
    public DataResult queryPollutionAnalysisCharts(@RequestParam Map<String, Object> paramMap) {

        return DataResult.success(forecastCaseService.queryPollutionAnalysisCharts(paramMap));
    }

    /**
     * 污染过程分析文字描述
     */
    @ResponseBody
    @RequestMapping("/queryPollutionAnalysisText")
    public DataResult queryPollutionAnalysisText(@RequestParam Map<String, Object> paramMap) {

        return DataResult.success(forecastCaseService.queryPollutionAnalysisText(paramMap));
    }

    /**
     * 修改污染过程分析文字描述
     */
    @ResponseBody
    @RequestMapping("/updatePollutionAnalysisText")
    public DataResult updatePollutionAnalysisText(@RequestParam Map<String, Object> paramMap) {

        return DataResult.success(forecastCaseService.updatePollutionAnalysisText(paramMap));
    }

    /**
     * 修改预报引用信息
     */
    @ResponseBody
    @RequestMapping("/updateForcastRef")
    public DataResult updateForcastRef(@RequestParam Map<String, Object> paramMap) {

        return DataResult.success(forecastCaseService.updateForcastRef(paramMap));
    }

    /**
     * 修改气象分析结论
     */
    @ResponseBody
    @RequestMapping("/updateWaterAnalysis")
    public DataResult updateWaterAnalysis(@RequestParam Map<String, Object> paramMap) {

        return DataResult.success(forecastCaseService.updateWaterAnalysis(paramMap));
    }


    /**
     * 查询气象条件数据分页
     */
    @ResponseBody
    @RequestMapping("/querywaterList")
    public DataResult querywaterList(@RequestParam Map<String, Object> paramMap, Paging<Map<String, Object>> paging) {
        return DataResult.success(forecastCaseService.querywaterList(paramMap, paging));
    }

    /**
     * 查询字典项
     */
    @ResponseBody
    @RequestMapping("/queryDictionaryListByCode")
    public DataResult queryDictionaryListByCode(String treeCode) {
        return DataResult.success(forecastCaseService.queryDictionaryListByCode(treeCode));
    }

    /**
     * 导出预报案列(excel)
     *
     * @param
     */
    @RequestMapping("/exportForcastExcel")
    public void exportForcast(HttpServletRequest request, HttpServletResponse response,
                              String startTime, String endTime, String weatherCodes, String polluteCodes) {
        Map<String, Object> params = new HashMap<>();
        params.put("startTime", startTime);
        params.put("endTime", endTime);
        params.put("weatherCodes", weatherCodes);
        params.put("polluteCodes", polluteCodes);
        forecastCaseService.exportForcast(params, request, response);

    }

    /**
     * 导出指定案列详情
     *
     * @param castId
     */
    @RequestMapping("/exportForcastDetailWord")
    public void exportForcastDetailWord(HttpServletRequest request, HttpServletResponse response,
                                        String castId) throws IOException {
        if (StringUtils.isBlank(castId)) {
            throw new IllegalArgumentException("参数无效");
        }
        Map<String, Object> params = new HashMap<>();
        params.put("id", castId);
        forecastCaseService.exportForcastDetailWord(params,request,response);
    }


}

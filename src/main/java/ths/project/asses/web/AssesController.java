package ths.project.asses.web;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import ths.jdp.core.context.PropertyConfigure;
import ths.jdp.core.dao.base.Paging;
import ths.jdp.core.model.FormModel;
import ths.jdp.core.model.LoginUserModel;
import ths.jdp.core.web.LoginCache;
import ths.project.analysis.forecast.numericalmodel.query.ForecastQuery;
import ths.project.analysis.forecast.report.enums.AnalysisStateEnum;
import ths.project.analysis.forecast.report.enums.AscriptionTypeEnum;
import ths.project.asses.entity.AssessEmission;
import ths.project.asses.entity.AssessMain;
import ths.project.asses.entity.AssessScene;
import ths.project.asses.params.AddOrEditAfterAssesParams;
import ths.project.asses.service.AssessService;
import ths.project.common.data.DataResult;
import ths.project.common.util.ExcelUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/asses")
public class AssesController {

    @Autowired
    private AssessService aService;
    private final Logger logger = LoggerFactory.getLogger(this.getClass());


    /**
     * 跳转后分析列表页面
     *
     * @param model ascriptionType 归属类型
     *              fileSources 文件来源
     * @return
     */
    @RequestMapping("/assesList")
    public String dayAnalysisReportList(Model model) {

        String ascriptionType = AscriptionTypeEnum.WINTER_EXPRESS.getValue();
        model.addAttribute("ascriptionType", ascriptionType);
        model.addAttribute("fileSources", AnalysisStateEnum.UPLOAD.getValue());
        return "/asses/assesList";
    }

    /**
     * 跳转到编辑或者新增页面
     *
     * @param model
     * @return
     */
    @RequestMapping("/assesAddOrEdit")
    public String assesAddOrEdit(Model model, String id) {
        String ascriptionType = AscriptionTypeEnum.WINTER_EXPRESS.getValue();
        model.addAttribute("ascriptionType", ascriptionType);
        model.addAttribute("fileSources", AnalysisStateEnum.UPLOAD.getValue());
        model.addAttribute("id", id);
        return "/asses/assesAddOrEdit";
    }


    /**
     * 添加或者编辑后评估方案丶场景丶数据
     *
     * @param params
     * @return
     */
    @RequestMapping(value = "/addOrEditAsses", method = RequestMethod.POST)
    @ResponseBody
    public DataResult addOrEditAfterAsses(@RequestBody AddOrEditAfterAssesParams params) throws InvocationTargetException, IllegalAccessException {
        LoginUserModel loginUser = LoginCache.getLoginUser();
        aService.addOrEditAfterAsses(params,loginUser);
        return DataResult.success();
    }

    /**
     * 跳转查看页面
     *
     * @param assessMain
     * @return
     */
    @RequestMapping("/show")
    public ModelAndView show(AssessMain assessMain) {
        ModelAndView mv = new ModelAndView("/asses/asses_show");
        mv.addObject("assessMain", assessMain);
        return mv;
    }


    /**
     * 获取方案名称分页信息
     *
     * @param query
     * @param pageInfo
     * @return
     */
    @RequestMapping("/getPlanNamePage")
    @ResponseBody
    public DataResult getWeatherDayDataPage(ForecastQuery query, Paging<AssessMain> pageInfo) {
        return DataResult.success(aService.getWeatherDayDataPage(query, pageInfo));
    }

    /**
     * 删除或者编辑方案
     *
     * @param assessMain
     * @return
     */
    @RequestMapping("/deleteAssessMain")
    @ResponseBody
    public DataResult deleteAssessMain(AssessMain assessMain) {
        aService.editAssessMain(assessMain);
        return DataResult.success();
    }

    /**
     * 导出污染物减排,质量改善信息
     *
     * @param request
     * @param response
     * @param formModel
     */
    @RequestMapping("/exportTemplate")
    public void exportTemplate(HttpServletRequest request, HttpServletResponse response, FormModel formModel) {
        ExcelUtil.exportExcelByTemp07(response, "pollutionReduction.xlsx", "后分析模板.xlsx", null);
    }

    /**
     * 根据方案id 获取场景以及数据
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/afterAssesById", method = RequestMethod.POST)
    @ResponseBody
    public DataResult getAfterAssesById(@RequestBody Map<String, Object> param) {
        AddOrEditAfterAssesParams result = aService.getAfterAssesById(param);
        return DataResult.success(result);
    }

    /**
     * 删除或者编辑场景
     *
     * @param assessScene
     * @return
     */
    @RequestMapping("/deleteAssessScene")
    @ResponseBody
    public DataResult deleteAssessScene(@RequestBody AssessScene assessScene) {
        aService.editAssessScene(assessScene);
        return DataResult.success();
    }

    public DataResult getAssessEmission() {
        return DataResult.failureNoData();
    }


    @ResponseBody
    @RequestMapping({"/getScenebyAssessId"})
    public DataResult getScenebyAssessId(String assessId, Integer emissionBigType) {
        List result = new ArrayList();
        List<AssessScene> list = this.aService.getSceneby(assessId);
        AssessEmission assessEmission = new AssessEmission();
        // assessEmission.setEmissionBigType(emissionBigType);
        /*if (emissionBigType == null) {
            assessEmission.setEmissionBigType(1);
        }*/
        if ((list != null) && (list.size() > 0)) {
            Map map = null;
            for (AssessScene assessScene : list) {
                map = new HashMap();
                map.put("info", assessScene);
                assessEmission.setSceneId(assessScene.getSceneId());
                List assessEmissionlist = this.aService.getAssessEmission(assessEmission);
                map.put("list", assessEmissionlist);
                List list2 = this.aService.getRate(assessEmission);
                map.put("list2", list2);
                result.add(map);
            }
            return DataResult.success(result);
        }
        return DataResult.failureNoData();
    }

    @ResponseBody
    @RequestMapping({"/getAssessEmissionByassessId"})
    public DataResult getAssessEmissionBySceneIds(String sceneIds, Integer emissionBigType) {
        List result = new ArrayList();
        AssessEmission assessEmission = new AssessEmission();
        assessEmission.setEmissionBigType(emissionBigType);
        String[] sceneIdArr = sceneIds.split(",");
        for (String sceneId : sceneIdArr) {
            assessEmission.setSceneId(sceneId);
            List list = this.aService.getAssessEmission(assessEmission);
            result.add(list);
        }
        if ((result != null) && (result.size() > 0)) {
            return DataResult.success(result);
        }
        return DataResult.failureNoData();
    }

    /**
     * 导出某个场景的数据
     *
     * @param id
     * @param index
     * @param response
     */
    @RequestMapping("exportExcel")
    public void exportExcel(String id, String index, HttpServletResponse response) throws IOException {
        Map<String, Object> param = new HashMap() {{
            put("id", id);
            put("index", index);
        }};
        aService.exportExcel(param, response);
    }

    /**
     * 获取配置文件
     *
     * @param a
     * @return
     */
    @ResponseBody
    @RequestMapping({"/getProperties"})
    public DataResult getProperties(String a) {
        return DataResult.success("info", PropertyConfigure.getProperty(a).toString());
    }
}

package ths.project.analysis.forecast.airforecastparition.web;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.type.CollectionType;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import ths.jdp.core.web.LoginCache;
import ths.project.analysis.forecast.airforecastparition.service.PartitionService;
import ths.project.analysis.forecast.report.enums.AnalysisStateEnum;
import ths.project.common.data.DataResult;
import ths.project.common.util.DateUtil;
import ths.project.common.util.JsonUtil;
import ths.project.common.util.ParamUtils;
import ths.project.common.vo.ResponseVo;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Controller
@RequestMapping("/analysis/air/partition")
public class PartitionController {
    @Autowired
    private PartitionService partitionService;

    /**
     * 跳转到列表页面
     */
    @RequestMapping("/partitionList")
    public String cityForecastList() {
        return "analysis/forecast/airforecastparition/partitionList";
    }


    /**
     * 根据报告ID，查询分区预报所有信息
     *
     * @param paramMap 参数
     * @return 月趋势预报信息
     */
    @RequestMapping("/queryPartitionForecastByReportId")
    @ResponseBody
    public ResponseVo queryPartitionForecastByReportId(@RequestParam Map<String, Object> paramMap) {
        ResponseVo responseVo = new ResponseVo();
        try {
            // 报告ID
            String reportId = (String) paramMap.get("reportId");
            // 验证
            if (StringUtils.isNotBlank(reportId)) {
                Map<String, Object> resultMap = partitionService.queryPartitionForecastByReportId(paramMap);
                if (resultMap != null && resultMap.size() > 0) {
                    responseVo.success(resultMap);
                } else {
                    responseVo.failure("暂无数据！");
                }
            } else {
                responseVo.failure("请求参数错误，可能值为空或包含非法字符！");
            }
        } catch (Exception e) {
            e.printStackTrace();
            responseVo.failure("服务器繁忙，请稍后重试！");
        }
        return responseVo;
    }

    /**
     * 跳转到城市预报显示页面
     *
     * @return 列表页面
     */
    @RequestMapping("/partitionView")
    public String partition(Model model, @RequestParam Map<String, Object> paramMap) {
        model.addAllAttributes(paramMap);
        return "analysis/forecast/airforecastparition/partitionView";
    }

    /**
     * 编辑和添加页面跳转
     */
    @RequestMapping("/partitionEditOrAdd")
    public String editOrAdd(Model model, @RequestParam Map<String, Object> paramMap) {
        paramMap.put("LOGINNAME", LoginCache.getLoginUser().getLoginName());
        model.addAllAttributes(paramMap);
        return "/analysis/forecast/airforecastparition/partitionEditOrAdd";
    }

    /**
     * 查询数据
     */
    @RequestMapping("/query")
    @ResponseBody
    public ResponseVo query(@RequestParam Map<String, Object> form) {
        ResponseVo responseVo = new ResponseVo();
        Map<String, Object> reMap = new HashMap<String, Object>();
        try {
            List<Map<String, Object>> countrys = partitionService.getcountrys();
            reMap.put("countrys", countrys);
            reMap.put("userlist", partitionService.getCreateUser());
            form.put("PKID", ParamUtils.getString(form, "PKID", UUID.randomUUID().toString()));
            Map<String, Object> resultMap = partitionService.getForecastFlowInfo(form);
            List<Map<String, Object>> fileList = partitionService.queryDayGeneralReportByIdAndFileSource(form);
            reMap.put("fileList", fileList);

            //无记录需要封装重要提示列表默认记录
            List<Map<String, Object>> formTipsList = new ArrayList<Map<String, Object>>();
            Map<String, Object> mapTips = new HashMap<String, Object>();
            mapTips.put("REGION_CODE", "");
            mapTips.put("REGION_NAME", "");
            mapTips.put("IMPORTANT_HINTS", "");
            formTipsList.add(mapTips);
            if (resultMap == null) {
                resultMap = new HashMap<String, Object>();
                String strDate = form.get("FORECAST_TIME").toString();
                resultMap.put("CREATE_TIME", strDate);
                String formt = "yyyy-MM-dd";
                Date forecastTime = DateUtil.parse(strDate, formt);
                String oneday = DateUtil.format(DateUtil.addDay(forecastTime, 1), formt);
                String twoday = DateUtil.format(DateUtil.addDay(forecastTime, 2), formt);
                String threeday = DateUtil.format(DateUtil.addDay(forecastTime, 3), formt);
                resultMap.put("ONEDAY", oneday);
                resultMap.put("TWODAY", twoday);
                resultMap.put("THREEDAY", threeday);
                //业务新建操作，先不设置PKID，获取前一天结果
                List<Map<String, Object>> form3d = partitionService.getArea3DData(resultMap);
                resultMap.put("PKID", UUID.randomUUID().toString());
                List<Map<String, Object>> form24h = new ArrayList<Map<String, Object>>();
                String[] areas = {"平坝区", "丘陵区", "西部沿山北区", "西部沿山南区"};
                for (String string : areas) {
                    Map<String, Object> map = new HashMap<String, Object>();
                    map.put("TYPECODE", 0);
                    map.put("REGIONNAME", string);
                    form24h.add(map);
                }
                if (form3d.size() == 0) {
                    form3d = new ArrayList<Map<String, Object>>();
                    for (Map<String, Object> country : countrys) {
                        Map<String, Object> map = new HashMap<String, Object>();
                        map.put("REGIONNAME", country.get("REGIONNAME"));
                        form3d.add(map);
                    }
                }
                reMap.put("form", resultMap);
                reMap.put("form24h", form24h);
                reMap.put("form3d", form3d);
                reMap.put("formTips", formTipsList);
            } else {
                reMap.put("PKID", ParamUtils.getString(resultMap, "PKID"));
                reMap.put("form", resultMap);
                reMap.put("form24h", partitionService.getArea24hData(form));
                reMap.put("form3d", partitionService.getArea3DData(form));
                List<Map<String, Object>> listTips = partitionService.getAreaTipsData(form);
                reMap.put("formTips", (listTips == null || listTips.size() == 0) ? formTipsList : listTips);
            }
            responseVo.success(reMap);
        } catch (Exception e) {
            e.printStackTrace();
            responseVo.failure("服务器繁忙，请稍后重试！");
        }
        return responseVo;
    }

    /**
     * 保存分区预报信息
     */
    @RequestMapping("/saveForecastInfo")
    @ResponseBody
    public ResponseVo saveForecastInfo(@RequestParam Map<String, Object> form
            , @RequestParam(value = "FILES", required = false) MultipartFile[] multipartFiles) {
        ResponseVo responseVo = new ResponseVo();
        form.put("CREATE_USER", LoginCache.getLoginUser().getUserName());
        form.put("SAVE_USER", LoginCache.getLoginUser().getUserName());

        List<Map<String, Object>> areas = JsonUtil.toList(form.get("AREAS").toString());
        List<Map<String, Object>> countrys3d = JsonUtil.toList(form.get("COUNTRYS3D").toString());
        try {
            Map<String, Object> reMap = partitionService.addForecastFlowInfo(form, areas, countrys3d, multipartFiles);
            List<Map<String, Object>> countrysTips = JsonUtil.toList((String) reMap.get("COUNTRYS_TIPS"));
            // 导出word
            partitionService.buildWord(reMap, false, null);
            // 导出zip
            partitionService.buildWord2(reMap, false, null, countrysTips);
            responseVo.success("保存成功！");
        } catch (Exception e) {
            e.printStackTrace();
            responseVo.failure("服务器繁忙，请稍后重试！");
        }
        return responseVo;
    }

    /**
     * 修改预报状态
     *
     * @param paramMap 参数
     * @return 修改的记录条数
     */
    @RequestMapping("/updateForecastState")
    @ResponseBody
    public ResponseVo updateForecastState(@RequestParam Map<String, Object> paramMap) {
        ResponseVo responseVo = new ResponseVo();
        try {
            // 报告ID不能为空
            if (StringUtils.isBlank((String) paramMap.get("reportId"))) {
                responseVo.failure("请求参数错误，可能值为空或包含非法字符。");
                return responseVo;
            }
            // 如果状态为空，则使用上报的状态作为默认值
            if (StringUtils.isBlank((String) paramMap.get("state"))) {
                paramMap.put("state", AnalysisStateEnum.UPLOAD.getValue());
            }
            paramMap.put("FLOW_STATE", paramMap.get("state").toString().equals("UPLOAD") ? 1 : 0);
            int result = partitionService.updateForecastState(paramMap);
            String userName = LoginCache.getLoginUser().getUserName();
            Map<String, Object> resultMap = new HashMap<String, Object>();
            resultMap.put("result", result);
            resultMap.put("userName", userName);
            responseVo.success(resultMap);
        } catch (Exception e) {
            e.printStackTrace();
            responseVo.failure("系统繁忙，请稍后重试！");
        }
        return responseVo;
    }

    /**
     * 根据报告ID删除预报
     *
     * @param paramMap 参数
     * @return 删除的条数
     */
    @RequestMapping("/deleteForecastById")
    @ResponseBody
    public ResponseVo deleteForecastById(@RequestParam Map<String, Object> paramMap) {
        ResponseVo responseVo = new ResponseVo();
        try {
            int result = partitionService.deleteForecastById(paramMap);
            responseVo.success(result);
        } catch (Exception e) {
            e.printStackTrace();
            responseVo.failure("系统繁忙，请稍后重试！");
        }
        return responseVo;
    }

    /**
     * 查询excel模板导入的数据
     */
    @RequestMapping("/queryExcel")
    @ResponseBody
    public ResponseVo queryExcel(@RequestParam Map<String, Object> paramMap) {
        ResponseVo responseVo = new ResponseVo();
        try {
            List<Map<String, Object>> relist = partitionService.queryExcel(paramMap);
            responseVo.success(relist);
        } catch (Exception e) {
            e.printStackTrace();
            responseVo.failure("系统繁忙，请稍后重试！");
        }
        return responseVo;
    }
}

/*
 * Copyright(C) 2000-2011 THS Technology Limited Company, http://www.ths.com.cn
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package ths.project.dyh.dataquery.web;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import ths.jdp.core.dao.base.Paging;
import ths.jdp.core.model.FormModel;
import ths.jdp.core.web.base.BaseController;
import ths.project.common.util.DateUtil;
import ths.project.common.util.JsonUtil;
import ths.project.common.util.ParamUtils;
import ths.project.dyh.dataquery.service.AirMonitorService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

/**
 * @author ZT
 * @since 2018-8-15
 */
@Controller
@RequestMapping({"/dyh/dataquery/airMonitor"})
public class AirMonitorController extends BaseController {

    @Autowired
    private AirMonitorService airMonitorService;

    @RequestMapping("/countryMonitor")
    public ModelAndView countryMonitor(FormModel formModel) throws Exception {
        Map<String, Object> form = formModel.getForm();
        //默认首个为灵岩寺
        String sname = ParamUtils.getString(form, "SNAME", "灵岩寺");
        String REGION = ParamUtils.getString(form, "REGION", "全部");
        form.put("REGION", REGION);
        form.put("REGIONS", REGION.split(","));
        form.put("SNAME", sname);
        form.put("SNAMES", sname.split(","));
        //查询小数据最大时间
        String endhour = airMonitorService.getMaxTime(form, "小时报").get("MAXTIME").toString().substring(0, 13);
        String starthour = DateUtil.format(DateUtil.addDay(DateUtil.parse(endhour, "yyyy-MM-dd HH"), -1), "yyyy-MM-dd HH");
        form.put("beginHour", starthour);
        form.put("endHour", endhour);
        form.put("PULL", ParamUtils.getString(form, "PULL", "AQI,PM25,PM10,NO2,SO2,O3,CO"));

        ModelAndView result = new ModelAndView("/dyh/airMonitor/airMonitor_stationMonitor");
        result.addObject("form", form);
        result.addObject("showTitle", ParamUtils.getString(form, "showTitle", "true"));
        return result;
    }

    /**
     * 获取对应站点、微站
     *
     * @param formModel
     * @return
     */
    @RequestMapping("/getStationList")
    @ResponseBody
    public List<Map<String, Object>> getStationList(FormModel formModel) {
        Map<String, Object> form = formModel.getForm();
        String REGION = ParamUtils.getString(form, "REGION", "全部");
        String[] REGIONS = REGION.split(",");
        form.put("REGION", REGION);
        form.put("REGIONS", REGIONS);

        String STATIONTYPE = ParamUtils.getString(form, "STATIONTYPE", "全部");
        String[] STATIONTYPES = STATIONTYPE.split(",");
        form.put("STATIONTYPES", STATIONTYPES);
        form.put("STATIONTYPE", STATIONTYPE);
        List<Map<String, Object>> list = airMonitorService.getStationName(form);
        return list;
    }

    /**
     * 获取附近站点
     *
     * @param formModel
     * @return
     */
    @RequestMapping("/getNearStationList")
    @ResponseBody
    public Map<String, List> getNearStationList(FormModel formModel) {
        Map<String, Object> form = formModel.getForm();
        String sname = ParamUtils.getString(form, "SNAME", "灵岩寺");
        String[] sNames = sname.split(",");
        return airMonitorService.getNearStationList(sNames);
    }

    /**
     * 获取区县名称
     *
     * @param formModel
     * @return
     */
    @RequestMapping("/getRegionList")
    @ResponseBody
    public List<Map<String, Object>> getRegionList(FormModel formModel) {
        Map<String, Object> form = formModel.getForm();
        List<Map<String, Object>> list = airMonitorService.getRegionName(form);
        return list;
    }

    @RequestMapping("/getEchartDatas")
    public ModelAndView getEchartDatas(FormModel formModel) {
        ModelAndView result = new ModelAndView("/dyh/airMonitor/airMonitor_echartsData");
        Map<String, Object> form = formModel.getForm();
        String nearSName = airMonitorService.assembleNearStationName(form);
        String sName = form.get("SNAME").toString();
        if (StringUtils.isNotBlank(nearSName)) {
            sName = sName + "," + nearSName;
        }
        form.put("NOWSNAME", form.get("SNAME").toString());
        form.put("NEARSNAME", nearSName);
        form.put("SNAME", sName);
        form.put("SNAMES", sName.split(","));
        String json = JsonUtil.toJson(airMonitorService.getAirMonitorDatas(form));
        result.addObject("list", json);
        result.addObject("form", form);
        return result;
    }

    @RequestMapping("/getTableDatas")
    public ModelAndView getTableDatas(FormModel formModel, Paging<Map<String, Object>> pageInfo) {
        ModelAndView result = new ModelAndView("/dyh/airMonitor/airMonitor_tableData");
        Map<String, Object> form = formModel.getForm();
        String nearSName = airMonitorService.assembleNearStationName(form);
        String sName = form.get("SNAME").toString();
        if (StringUtils.isNotBlank(nearSName)) {
            sName = sName + "," + nearSName;
        }
        form.put("SNAME", sName);
        form.put("SNAMES", sName.split(","));
        result.addObject("pageInfo", airMonitorService.list(pageInfo, form));
        result.addObject("form", form);
        return result;
    }

    @RequestMapping("/exportTable")
    public void exportTable(HttpServletRequest request, HttpServletResponse response, FormModel formModel) {
        try {
            Map<String, Object> form = formModel.getForm();
            String nearSName = airMonitorService.assembleNearStationName(form);
            String sName = form.get("SNAME").toString();
            if (StringUtils.isNotBlank(nearSName)) {
                sName = sName + "," + nearSName;
            }
            form.put("SNAME", sName);
            form.put("SNAMES", sName.split(","));
            airMonitorService.exportTable(request, response, form);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}

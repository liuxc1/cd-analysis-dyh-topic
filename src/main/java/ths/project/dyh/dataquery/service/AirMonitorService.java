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
package ths.project.dyh.dataquery.service;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ths.jdp.core.dao.base.Paging;
import ths.jdp.core.service.base.BaseService;
import ths.project.analysis.forecast.trendforecast.mapper.TrendForecastMapper;
import ths.project.dyh.dataquery.mapper.AirMonitorMapper;
import ths.project.system.base.util.PageSelectUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * @author ZT
 * @since 2018-8-15
 */
@Service
public class AirMonitorService extends BaseService {

    @Autowired
    private AirMonitorMapper airMonitorMapper;

    /**
     * 行政区监测数据-小时数据
     *
     * @param queryParam
     * @return
     */
    public List<Map<String, Object>> getAirMonitorDatas(Map<String, Object> queryParam) {
        return airMonitorMapper.getAirMonitorDatas(queryParam);
    }

    /**
     * 行政区监测数据-小时数据-表格数据
     *
     * @param pageInfo
     * @param queryMap
     * @return
     */
    public Paging<Map<String, Object>> list(Paging<Map<String, Object>> pageInfo, Map<String, Object> queryMap) {
        return  PageSelectUtil.selectListPage1(airMonitorMapper, pageInfo, AirMonitorMapper::getAirMonitorDatas1, queryMap);
    }


    /**
     * 获取站点
     *
     * @return
     */
    public List<Map<String, Object>> getStationName(Map<String, Object> querymap) {
        String oldType = querymap.get("STATIONTYPE").toString();
        //将原有指标国控、省控、市控（0、1、2）改为（6、7、8）
        String newType = oldType.replace('0', '6').replace('1', '7').replace('2', '8');
        String[] newTypes = newType.split(",");
        querymap.put("STATIONTYPE", newType);
        querymap.put("STATIONTYPES", newTypes);
        return airMonitorMapper.getStationName(querymap);
    }

    /**
     * 获取区县list
     *
     * @param querymap
     * @return
     */
    public List<Map<String, Object>> getRegionName(Map<String, Object> querymap) {
        return airMonitorMapper.getRegionName(querymap);
    }

    /**
     * 获取最大时间
     *
     * @param querymap
     * @return
     */
    public Map<String, Object> getMaxTime(Map<String, Object> querymap, String timetype) {
        querymap.put("TIMECODE", timetype);
        return airMonitorMapper.getMaxTime(querymap);
    }

    @SuppressWarnings("unchecked")
    public void exportTable(HttpServletRequest request, HttpServletResponse response, Map<String, Object> map) {
        String fileName = "国省市控站点数据.xlsx";
        //获取title
        LinkedList<String> list = new LinkedList<>();
        list.add("MONDATE:时间");
        String title = "";
        String[] snames = String.valueOf(map.get("SNAME")).split(",");
        for (int i = 0; i < snames.length; i++) {
            title = snames[i] + ":" + snames[i];
            list.add(title);
        }
        String[] titles = list.toArray(new String[list.size()]);
        //获取数据
        List<Map<String, Object>> data = airMonitorMapper.getAirMonitorDatas2(map);
        //导出
        ths.project.common.util.ExcelUtil.exportSimpleExcel07(response, fileName, titles, data);
    }

    /**
     * 获取附近站点
     *
     * @param sNameArr
     * @return
     */
    public Map<String, List> getNearStationList(String[] sNameArr) {
        HashMap<String, List> resultMap = new HashMap<>();
        for (int i = 0; i < sNameArr.length; i++) {
            HashMap<String, String> nameMap = new HashMap<>();
            nameMap.put("sName", sNameArr[i]);
            resultMap.put(sNameArr[i], airMonitorMapper.getNearStationList(nameMap));
        }
        return resultMap;
    }

    /**
     * 组装附近站点名称
     *
     * @param form
     * @return
     */
    public String assembleNearStationName(Map<String, Object> form) {
        String nearSName = String.valueOf(form.get("NEARSNAME"));
        String newName = "";
        if (StringUtils.isNotBlank(nearSName)) {
            String[] nearSNameArray = nearSName.split(",");
            Set<String> nearSNameSet = new HashSet<>(Arrays.asList(nearSNameArray));
            for (String nearName : nearSNameSet) {
                newName += nearName + ",";
            }
            newName = newName.substring(0, newName.lastIndexOf(","));
        }
        return newName;
    }
}

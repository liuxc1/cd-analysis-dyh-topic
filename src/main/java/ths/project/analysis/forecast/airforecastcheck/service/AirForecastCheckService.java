package ths.project.analysis.forecast.airforecastcheck.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ths.jdp.core.context.PropertyConfigure;
import ths.project.analysis.forecast.airforecastcheck.mapper.AirForecastCheakMapper;

import java.util.*;


/**
 * 人工预报核对模块
 */
@Service
public class AirForecastCheckService {

    @Autowired
    private AirForecastCheakMapper airForecastCheakMapper;

    /**
     * 获取最大预报核对日期
     */
    public Map<String, Object> queryMaxTime(String isCd) {
        return airForecastCheakMapper.queryMaxTime(isCd);

    }

    /**
     * 获取预报核对Echarts
     *
     * @return
     */
    public List<Map<String, Object>> getForecastEchartsData(Map<String, Object> paramMap) {
        // 响应集合Map
        List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> forecastCheckList = null;
        // 获取人工预报核对数据
        if ("ZJPG".equals(paramMap.get("type"))) {
            forecastCheckList = airForecastCheakMapper.queryHumanForecastCheckData(paramMap);
        } else if ("MSPG".equals(paramMap.get("type"))) {
            paramMap.put("pointCode", PropertyConfigure.getProperty("regioncode"));
            forecastCheckList = airForecastCheakMapper.queryModelForecastCheckData(paramMap);
        } else if ("GRPG".equals(paramMap.get("type"))) {
            forecastCheckList = airForecastCheakMapper.queryPersonForecastCheckData(paramMap);
        }
        resultList.add(getKEchartsData(forecastCheckList, "SKAQI", "AQIC", "MINAQI", "MAXAQI", "AVGAQI"));
        resultList.add(getKEchartsData(forecastCheckList, "SKPM25", "PM25C", "MINPM25", "MAXPM25", "AVGPM25"));
        resultList.add(getKEchartsData(forecastCheckList, "SKO3", "O3C", "MINO3", "MAXO3", "AVGO3"));
        return resultList;
    }

    /**
     * 获取表格数据
     */
    public HashMap<String, Object> queryForecastTableData(Map<String, Object> paramMap) {
        List<Map<String, Object>> result = new ArrayList<>();
        List<Map<String, Object>> avgPersonList;
        if ("ZJPG".equals(paramMap.get("type"))) {
            //查询step对应预报、实测平均数（专家）
            paramMap.put("avgDataList", airForecastCheakMapper.queryPersonAvgData(paramMap));
            //查询表格数据
            result = airForecastCheakMapper.queryHumanForecastTableData(paramMap);
            //查询step对应平均预报人数
            avgPersonList = airForecastCheakMapper.queryAvgPerson(paramMap);
            //组装人数与表格数据
            for (Map<String, Object> map : result) {
                for (Map<String, Object> personMap : avgPersonList) {
                    if (map.get("STEP").equals(personMap.get("STEP"))) {
                        map.put("YBRS", personMap.get("YBRS"));
                        break;
                    }
                }
            }
        } else if ("MSPG".equals(paramMap.get("type"))) {
            paramMap.put("pointCode", PropertyConfigure.getProperty("regioncode"));
            //查询step对应预报、实测平均数（模型预报）
            paramMap.put("avgDataList", airForecastCheakMapper.queryModelAvgData(paramMap));
            //查询模型预报表格数据
            result = airForecastCheakMapper.queryModelForecastTableData(paramMap);
        } else if ("GRPG".equals(paramMap.get("type"))) {
            //查询step对应预报、实测平均数（个人评估）
            paramMap.put("avgDataList", airForecastCheakMapper.queryPersonAvgData(paramMap));
            //查询个人评估表格数据
            result = airForecastCheakMapper.queryPersonForecastTableData(paramMap);
        }
        //查询核对数据
        HashMap<String, Object> map = new HashMap<>();
        map.put("data", result);
        if (result.size() > 0) {
            Object[] colArr = result.get(0).keySet().toArray();
            map.put("col", colArr);
        }
        return map;

    }


    /**
     * 获取模式预报类型
     */
    public List<Map<String, Object>> getForecastModel() {
        return airForecastCheakMapper.getForecastModel();
    }

    /**
     * 获取预报的用户
     */
    public List<Map<String, Object>> getForecastUser() {
        Map<String, Object> map = airForecastCheakMapper.queryMaxTime(null);
        return airForecastCheakMapper.getForecastUser(map);
    }

    /**
     * 屏接预报准确的K线图
     */
    public Map<String, Object> getKEchartsData(List<Map<String, Object>> forecastCheckList, String skType, String typeC, String min, String max, String avgType) {
        Map<String, Object> responseMap = new HashMap<String, Object>();
        /* 组织 Echarts 数据 */
        // 基础列表
        // 显示最小值，对应柱状图上白色的最小值高度
        List<Object> baseList = new ArrayList<Object>();
        // 对应柱状图上的叠加值，和最小值之间的高度表示预报范围
        List<Object> forcastTrueList = new ArrayList<Object>();
        List<Object> forcastFalseList = new ArrayList<Object>();
        List<Object> forcastUpList = new ArrayList<Object>();
        List<Object> forcastNoneList = new ArrayList<Object>();
        List<Object> forcastDownList = new ArrayList<Object>();
        // 折线图
        List<Object> monitorList = new ArrayList<Object>();
        // xAxis
        List<Object> xAxisList = new ArrayList<Object>();
        // 遍历数据库人工预报核对数据结果集
        for (Map<String, Object> forMap : forecastCheckList) {
            monitorList.add(forMap.get(skType) == null ? '-' : forMap.get(skType));
            xAxisList.add(forMap.get("RESULT_TIME"));
            if (forMap.get(typeC) == null) {
                forcastTrueList.add("-");
                if (forMap.get(skType) == null) {
                    forcastDownList.add("-");
                    forcastUpList.add("-");
                    if (forMap.get(min) == null) {
                        baseList.add("-");
                        forcastNoneList.add("-");
                    } else {
                        baseList.add(forMap.get(min));
                        forcastNoneList.add(minorCalculate(forMap.get(max), forMap.get(min), "-"));
                    }
                } else {
                    if (forMap.get(min) == null) {
                        baseList.add("-");
                        forcastFalseList.add("-");
                        forcastUpList.add("-");
                        forcastDownList.add("-");
                        forcastNoneList.add("-");
                    } else {
                        baseList.add(forMap.get(min));
                        forcastTrueList.add("-");
                        forcastNoneList.add("-");
                        if ("up".equals(upAndDown(forMap.get(max), forMap.get(min), forMap.get(skType)))) {
                            forcastUpList.add(minorCalculate(forMap.get(max), forMap.get(min), "-"));
                            forcastDownList.add("-");
                        } else {
                            forcastDownList.add(minorCalculate(forMap.get(max), forMap.get(min), "-"));
                            forcastUpList.add("-");
                        }
                        forcastFalseList.add(minorCalculate(forMap.get(max), forMap.get(min), "-"));
                    }
                }
            } else if ("1".equals(forMap.get(typeC))) {
                baseList.add(forMap.get(min));
                forcastTrueList.add(minorCalculate(forMap.get(max), forMap.get(min), "-"));
                forcastFalseList.add("-");
                forcastUpList.add("-");
                forcastDownList.add("-");
                forcastNoneList.add("-");
            } else if ("0".equals(forMap.get(typeC))) {
                baseList.add(forMap.get(min));
                forcastTrueList.add("-");
                forcastNoneList.add("-");
                if ("up".equals(upAndDown(forMap.get(max), forMap.get(min), forMap.get(skType)))) {
                    forcastUpList.add(minorCalculate(forMap.get(max), forMap.get(min), "-"));
                    forcastDownList.add("-");
                } else if ("down".equals(upAndDown(forMap.get(max), forMap.get(min), forMap.get(skType)))) {
                    forcastDownList.add(minorCalculate(forMap.get(max), forMap.get(min), "-"));
                    forcastUpList.add("-");
                }
                forcastFalseList.add(minorCalculate(forMap.get(max), forMap.get(min), "-"));
            }
        }
        // 封装响应结果集responseMap
        responseMap.put("xAxisData", xAxisList);
        responseMap.put("baseList", baseList);
        responseMap.put("forcastTrueList", forcastTrueList);
        responseMap.put("forcastDownList", forcastDownList);
        responseMap.put("forcastUpList", forcastUpList);
        responseMap.put("forcastNoneList", forcastNoneList);
        responseMap.put("forcastFalseList", forcastFalseList);
        responseMap.put("monitorList", monitorList);
        responseMap.put("forecastCheckList", forecastCheckList);
        responseMap.put("scatterPlot", getScatterPlot(forecastCheckList, skType, avgType));
        return responseMap;
    }

    /**
     * 拼接污染物屏接散点图的数据
     *
     * @return
     */
    public Object getScatterPlot(List<Map<String, Object>> list, String skType, String avgType) {
        Map<String, Object> resultMap = new HashMap<String, Object>();
        List<List<Object>> aqiList = new ArrayList<List<Object>>();
        List<Object> aqiStringList = null;
        double aqiMax = 0;
        for (Map<String, Object> map : list) {
            aqiStringList = new ArrayList<Object>();
            aqiStringList.add(map.get(avgType) == null ? 0 : map.get(avgType));
            aqiMax = Math.max(aqiMax, Double.valueOf(String.valueOf(map.get(avgType) == null ? 0 : map.get(avgType))));
            aqiStringList.add(map.get(skType) == null ? 0 : map.get(skType));
            aqiMax = Math.max(aqiMax, Double.valueOf(String.valueOf(map.get(skType) == null ? 0 : map.get(skType))));
            aqiList.add(aqiStringList);
        }
        resultMap.put("list", aqiList);
        resultMap.put("max", new Double(aqiMax * 1.3).intValue());
        return resultMap;
    }


    /**
     * @param max
     * @param min
     * @param num
     * @return
     */
    private String upAndDown(Object max, Object min, Object num) {
        String result = null;
        Long maxL = Long.parseLong(String.valueOf(max));
        Long minL = Long.parseLong(String.valueOf(min));
        Long num3 = Long.parseLong(String.valueOf(num));
        if (num3 > maxL) {
            result = "down";
        } else if (num3 < minL) {
            result = "up";
        }
        return result;
    }

    /**
     * 微型计算器
     *
     * @param numA
     * @param numB
     * @param option 操作类型
     * @return
     */
    private Object minorCalculate(Object numA, Object numB, String option) {
        Long result = null;
        Long num1 = Long.parseLong(String.valueOf(numA));
        Long num2 = Long.parseLong(String.valueOf(numB));
        switch (option) {
            case "+":
                result = num1 + num2;
                break;
            case "-":
                result = num1 - num2;
                break;
            case "*":
                result = num1 * num2;
                break;
            case "/":
                result = num1 / num2;
                break;
            default:
        }
        return result;
    }

    /**
     * 区县预报准确率
     *
     * @param param
     * @return
     */
    public List<LinkedHashMap<String, Object>> getForecastCountyTableData(Map<String, Object> param) {
        return airForecastCheakMapper.getForecastCountyTableData(param);
    }
}

package ths.project.api.digitalModel.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ths.project.api.digitalModel.mapper.DigitalModelMapper;

import java.util.HashMap;
import java.util.Map;

@Service
public class DigitalModelService {

    @Autowired
    private DigitalModelMapper digitalModelMapper;

    /**
     * 查询模型表中的最大数据，拼接出最大时间图片并返回
     * @return
     */
    public Map<String, Object> queryDigitalModel() {
        HashMap<String, Object> map = new HashMap<>();
        map.put("model", "CDAQS_MT");
        map.put("regionCode", "510100000000");
        HashMap<String, Object> hashMap = digitalModelMapper.queryDigitalModel(map);
        return this.splicing(hashMap);
    }

    private Map<String, Object> splicing(HashMap<String, Object> hashMap) {
        HashMap<String, Object> imageMap = new HashMap<>();
        String time = (String) hashMap.get("TIME");
        if (time != null) {
            //小时风场
            imageMap.put("windField", "/dyh_forecastPic/" + time + "/00/NCPLOTS/windws_015.png");
            //pm25
            imageMap.put("pm25", "/dyh_forecastPic/" + time + "/00/NCPLOTS/daily_pm25_day1.png");
            //o3
            imageMap.put("o3", "/dyh_forecastPic/" + time + "/00/NCPLOTS/daily_o3m_day1.png");
            //no2
            imageMap.put("no2", "/dyh_forecastPic/" + time + "/00/NCPLOTS/daily_no2_day1.png");
        }
        return imageMap;
    }
}

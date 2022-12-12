package ths.project.api.warnreport;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import ths.jdp.core.web.LoginCache;
import ths.project.common.data.DataResult;
import ths.project.common.util.DateUtil;
import ths.project.warnreport.dailyreport.service.DailyReportService;

import java.util.Date;

/**
 * @author lx
 * @date 2022年03月22日 18:33
 */
@RequestMapping("/api/warnReport")
@Controller
public class WarnReportController {
    @Autowired
    private DailyReportService dailyReportService;
    /**
     * 生成、保存生态环境局日报
     * @param dateTime
     * http://localhost:7090/dyh_analysis/api/warnReport/saveDailyReportExcel.vm
     */
    @RequestMapping("/saveDailyReportExcel")
    @ResponseBody
    public DataResult saveDailyReportExcel(String dateTime) {
        String reportId = "";
        if (StringUtils.isNotBlank(dateTime)){
            int days = DateUtil.daysBetween(DateUtil.parseDate(dateTime),new Date());
            String newDate;
            for (int i = 0; i < days; i++) {
                newDate = DateUtil.formatDate(DateUtil.addDay(DateUtil.parseDate(dateTime), i));
                reportId += dailyReportService.saveDailyReportExcel(newDate, LoginCache.getLoginUser())+",";
            }
        }else {
            reportId += dailyReportService.saveDailyReportExcel(dateTime, LoginCache.getLoginUser())+",";
        }
        return DataResult.success(reportId);
    }
}

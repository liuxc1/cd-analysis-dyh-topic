package ths.project.analysis.analysisreport.service;


import com.deepoove.poi.XWPFTemplate;
import com.deepoove.poi.data.PictureRenderData;
import com.deepoove.poi.xwpf.WidthScalePattern;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ths.jdp.core.context.PropertyConfigure;
import ths.jdp.core.web.LoginCache;
import ths.jdp.core.web.RequestHelper;
import ths.jdp.eform.service.components.word.DocumentPage;
import ths.project.analysis.analysisreport.entity.TMonthlyAnalysis;
import ths.project.analysis.analysisreport.mapper.MonthlyAnalysisMapper;
import ths.project.analysis.forecast.report.entity.GeneralReport;
import ths.project.analysis.forecast.report.enums.AnalysisStateEnum;
import ths.project.analysis.forecast.report.enums.AscriptionTypeEnum;
import ths.project.analysis.forecast.report.mapper.GeneralReportMapper;
import ths.project.analysis.forecast.report.service.GeneralReportService;
import ths.project.common.enums.TransformFileEnum;
import ths.project.common.util.DateUtil;
import ths.project.system.file.entity.CommFile;
import ths.project.system.file.entity.CommImage;
import ths.project.system.file.service.CommFileService;
import ths.project.system.file.service.CommImageService;

import javax.swing.*;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.Serializable;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@Service
public class MonthlyAnalysisService {

    @Autowired
    private MonthlyAnalysisMapper monthlyAnalysisMapper;
    @Autowired
    private CommFileService commFileService;
    @Autowired
    private GeneralReportService generalReportService;
    @Autowired
    private CommImageService commImageService;
    @Autowired
    private GeneralReportMapper generalReportMapper;
    /**
     * 文件保存路径
     **/
    public final static String FILE_PATH = CommFileService.FILE_ROOT_PATH;
    /**
     * 文件映射路径
     **/
    private final static String IMAGE_PATH = CommImageService.TASK_IMG_PATH;

    /**
     * 保存预报总方法
     */
    @Transactional
    public void saveForecast(TMonthlyAnalysis tMonthlyAnalysis) {
        TMonthlyAnalysis monthlyAnalysis = monthlyAnalysisMapper.selectById(tMonthlyAnalysis.getReportId());
        tMonthlyAnalysis.setCreateTime(new Date());
        tMonthlyAnalysis.setEditTime(new Date());
        tMonthlyAnalysis.setEditUser(LoginCache.getLoginUser().getUserName());
        tMonthlyAnalysis.setCreateUser(LoginCache.getLoginUser().getLoginName());
        if (monthlyAnalysis != null) {
            monthlyAnalysisMapper.updateById(tMonthlyAnalysis);
            GeneralReport generalReport = generalReportMapper.selectById(monthlyAnalysis.getReportId());
            generalReport.setState(tMonthlyAnalysis.getState());
            generalReport.setReportTip(tMonthlyAnalysis.getReportTip());
            generalReport.setUpdateTime(new Date());
            generalReport.setUpdateUser(LoginCache.getLoginUser().getLoginName());
            generalReportMapper.updateById(generalReport);
        } else {
            tMonthlyAnalysis.setDeleteFlag(0);
            addGeneralReport(tMonthlyAnalysis);
            monthlyAnalysisMapper.insert(tMonthlyAnalysis);
        }
        String[] ascriptionTypes =
                {"MONTHLY_ANALYSIS",
                        "MONTHLY_ANALYSIS_TWO",
                        "MONTHLY_ANALYSIS_THREE",
                        "MONTHLY_ANALYSIS_FOUR",
                        "MONTHLY_ANALYSIS_FIVE",
                        "MONTHLY_ANALYSIS_SIX",
                        "MONTHLY_ANALYSIS_SEVEN"};
        List<CommImage> commImages = commImageService.queryImageListFromAscriptionTypes(tMonthlyAnalysis.getReportId(), ascriptionTypes);
        this.splicingWorld(commImages, tMonthlyAnalysis);
    }

    /**
     * 保存报告数据 GeneralReport
     *
     * @param tNewsletterAnalysis
     */
    public void addGeneralReport(TMonthlyAnalysis tNewsletterAnalysis) {
        GeneralReport generalReport = new GeneralReport();
        generalReport.setReportId(tNewsletterAnalysis.getReportId());
        generalReport.setReportTime(tNewsletterAnalysis.getReportTime());
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        String reportName = formatter.format(tNewsletterAnalysis.getReportTime()) + "月报";
        generalReport.setReportName(reportName);
        generalReport.setIsMain(0);
        generalReport.setReportRate("MONTH");
        generalReport.setReportTip(tNewsletterAnalysis.getReportTip());
        generalReport.setState(tNewsletterAnalysis.getState());
        generalReport.setAscriptionType(tNewsletterAnalysis.getAscriptionType());
        generalReportService.saveReport(generalReport);
    }

    /**
     * 生成快报文件
     *
     * @param commImages
     * @param tNewsletterAnalysis
     */
    private void splicingWorld(List<CommImage> commImages, TMonthlyAnalysis tNewsletterAnalysis) {
        if (tNewsletterAnalysis != null) {
            String templatePath = RequestHelper.getRequest().getServletContext().getRealPath("/assets/template/monthlyAnalysis.docx");
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
            String fileName = formatter.format(tNewsletterAnalysis.getReportTime()).substring(0, 7) + "月报";
            Map<String, Object> docParamMap = new HashMap<>();
            DocumentPage documentPage = new DocumentPage();
            documentPage.setParamMap(docParamMap);
            CommFile commFile = commFileService.saveGenerateWordFile(documentPage, null, null, templatePath, fileName, AscriptionTypeEnum.MONTHLY_ANALYSIS.getValue());
            String filePath = FILE_PATH + commFile.getFileSavePath();
            this.insetImageAndText(commImages, filePath, tNewsletterAnalysis);
            commFileService.deleteFileByAscription(tNewsletterAnalysis.getReportId(), AscriptionTypeEnum.MONTHLY_ANALYSIS.getValue());
            commFileService.saveFileInfo(commFile, tNewsletterAnalysis.getReportId(), AscriptionTypeEnum.MONTHLY_ANALYSIS.getValue(), LoginCache.getLoginUser().getUserName(), AnalysisStateEnum.UPLOAD.getValue());
        }
    }

    /**
     * 插入图片和信息
     *
     * @param images
     * @param filePath
     * @param tNewsletterAnalysis
     */
    private void insetImageAndText(List<CommImage> images, String filePath, TMonthlyAnalysis tNewsletterAnalysis) {
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        String DateString = formatter.format(tNewsletterAnalysis.getReportTime());
        HashMap<String, Object> hashMap = new HashMap<String, Object>() {
            {
                put("YEAR", DateString.substring(0, 4));
                put("NUMBER", tNewsletterAnalysis.getReportBatch());
                put("MOON", DateString.substring(5, 7));
                put("DAY", DateString.substring(8, 10));
                put("tNewsletterAnalysis", tNewsletterAnalysis);
                put("TEXT1", tNewsletterAnalysis.getDefaultDate());
                put("TEXT2", tNewsletterAnalysis.getGenerateContentQuality());
                put("TEXT3", tNewsletterAnalysis.getGenerateContentAnalysis());
                put("TEXT4", tNewsletterAnalysis.getGenerateContentConcentration());
                put("TEXT5", tNewsletterAnalysis.getGenerateContentSolvent());
                put("TEXT6", tNewsletterAnalysis.getGenerateContentSummary());
            }
        };
        if (images.size() > 0) {
            int[] num = {1, 1, 1, 1, 1, 1, 1};
            //拼接图片信息
            images.forEach(con ->
            {
                ImageIcon imageIcon = new ImageIcon(IMAGE_PATH + con.getImageSavePath());
                PictureRenderData pictureRenderData = new PictureRenderData(imageIcon.getIconWidth(), imageIcon.getIconHeight(), IMAGE_PATH + con.getImageSavePath());
                pictureRenderData.getPictureStyle().setScalePattern(WidthScalePattern.FIT);
                if (con.getAscriptionType().equals("MONTHLY_ANALYSIS")) {
                    hashMap.put("image1" + num[0], pictureRenderData);
                    num[0]++;
                } else if (con.getAscriptionType().equals("MONTHLY_ANALYSIS_TWO")) {
                    hashMap.put("image2" + num[1], pictureRenderData);
                    num[1]++;
                } else if (con.getAscriptionType().equals("MONTHLY_ANALYSIS_THREE")) {
                    hashMap.put("image3" + num[2], pictureRenderData);
                    num[2]++;
                } else if (con.getAscriptionType().equals("MONTHLY_ANALYSIS_FOUR")) {
                    hashMap.put("image4" + num[3], pictureRenderData);
                    num[3]++;
                } else if (con.getAscriptionType().equals("MONTHLY_ANALYSIS_FIVE")) {
                    hashMap.put("image5" + num[4], pictureRenderData);
                    num[4]++;
                } else if (con.getAscriptionType().equals("MONTHLY_ANALYSIS_SIX")) {
                    hashMap.put("image6" + num[5], pictureRenderData);
                    num[5]++;
                } else if (con.getAscriptionType().equals("MONTHLY_ANALYSIS_SEVEN")) {
                    hashMap.put("image7" + num[6], pictureRenderData);
                    num[6]++;
                }
            });
        }
        XWPFTemplate template = XWPFTemplate.compile(RequestHelper.getRequest().getServletContext().getRealPath("/assets/template/monthlyAnalysis.docx")).render(hashMap);
        FileOutputStream out;
        try {
            out = new FileOutputStream(filePath);
            template.write(out);
            // 转换文件
            commFileService.transformFile(TransformFileEnum.DOCX, filePath, filePath.replace(".docx", ".pdf"));
            out.flush();
            out.close();
            template.close();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * 查询月数据
     *
     * @param
     * @return
     */
    public Map<String, Object> queryMonthGeneralReportByIdAndFileSource(String ascriptionType, String reportTime) {
        HashMap<String, Object> map = new HashMap<>();
        Map<String, Object> reportMap = new HashMap<>();
        map.put("ascriptionType", ascriptionType);
        map.put("reportTime", reportTime);
        List<Map<String, Object>> maps = generalReportService.queryMonthRecordListByReportTime(map);
        if (maps != null && maps.size() > 0) {
            reportMap.put("report", monthlyAnalysisMapper.selectById((Serializable) maps.get(0).get("REPORT_ID")));
            return reportMap;
        }
        return null;
    }

    /**
     * 获取默认数据，通过时间进行查询
     *
     * @param startMonth
     * @return
     * @throws ParseException
     */
    public Map queryDefaultData(String startMonth) throws ParseException {
        if (!StringUtils.equals(startMonth, "")) {
            HashMap<String, Object> newTimeMap = new HashMap<>();
            HashMap<Object, Object> oldTimeMap = new HashMap<>();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String startTime = sdf.format(DateUtil.parseDate(startMonth.substring(0, 7) + "-01"));
            String endTime = sdf.format(GeneralReportService.getFirstDayOfNextMonth(startTime, 1));
            newTimeMap.put("startTime", startTime);
            newTimeMap.put("endTime", endTime);
            TMonthlyAnalysis newMonthlyAnalysis = monthlyAnalysisMapper.querySpecifiedTime(newTimeMap);
            String oldStartTime = DateUtil.yearAddNum(startTime, -1);
            String oldEndTime = DateUtil.yearAddNum(endTime, -1);
            oldTimeMap.put("oldStartTime", oldStartTime);
            oldTimeMap.put("oldEndTime", oldEndTime);
            TMonthlyAnalysis oldMonthlyAnalysis = monthlyAnalysisMapper.getLastYearData(oldTimeMap);
            return stitchingData(newMonthlyAnalysis, oldMonthlyAnalysis);
        }
        return null;
    }

    /**
     * 拼接数据
     */
    private Map stitchingData(TMonthlyAnalysis newMonthlyAnalysis, TMonthlyAnalysis oldMonthlyAnalysis) {
        if (newMonthlyAnalysis != null && oldMonthlyAnalysis != null) {
            String primary;
            if(newMonthlyAnalysis.getPrimaryPollutant() == null){
                return null;
            }
            String[] pollutants = newMonthlyAnalysis.getPrimaryPollutant().split(",");
            HashSet<String> hashSet = new HashSet<>();
            if (pollutants.length > 0) {
                for (int i = pollutants.length - 1; i >= 0; i--) {
                    hashSet.add(pollutants[i]);
                }
            }
            StringBuilder primaryPollutant = new StringBuilder();
            for (String set : hashSet) {
                if (hashSet.size() == 1) {
                    primaryPollutant.append(set);
                } else {
                    primaryPollutant.append(set).append(",");
                }
            }
            if (primaryPollutant.substring(primaryPollutant.length() - 1).equals(",")) {
                primary = primaryPollutant.substring(0, primaryPollutant.length() - 1);
            } else {
                primary = primaryPollutant.toString();
            }
            String[] strings = primary.split(",");
            StringBuilder stringBuilder = new StringBuilder();
            for (int i = 0; i < strings.length; i++) {
                if (strings[i].equals("NO2")) {
                    strings[i] = "NO₂";
                    stringBuilder.append(strings[i]).append(",");
                }
                if (strings[i].equals("O3_8")) {
                    strings[i] = "O₃";
                    stringBuilder.append(strings[i]).append(",");
                }
                if (strings[i].equals("PM10")) {
                    strings[i] = "PM₁₀";
                    stringBuilder.append(strings[i]).append(",");
                }
                if (strings[i].equals("PM25")) {
                    strings[i] = "PM₂.₅";
                    stringBuilder.append(strings[i]).append(",");
                }
                if (strings[i].equals("SO2")) {
                    strings[i] = "SO₂";
                    stringBuilder.append(strings[i]).append(",");
                }
            }
            newMonthlyAnalysis.setPrimaryPollutant(stringBuilder.substring(0, stringBuilder.length() - 1));
            return getPercentage(newMonthlyAnalysis, oldMonthlyAnalysis);
        } else {
            return null;
        }

    }

    /**
     * 获取今年和去年同比百分比（升高、降低、持平）
     *
     * @param
     * @param
     * @return
     */
    private HashMap getPercentage(TMonthlyAnalysis newMonthlyAnalysis, TMonthlyAnalysis oldMonthlyAnalysis) {

        //pm10
        String pm10Percentage;
        if (newMonthlyAnalysis.getPm10() > oldMonthlyAnalysis.getPm10()) {
            pm10Percentage = String.valueOf((newMonthlyAnalysis.getPm10() - oldMonthlyAnalysis.getPm10()) / oldMonthlyAnalysis.getPm10() * 100);
            newMonthlyAnalysis.setPm10Percentage(pm10Percentage.substring(0, 4) + "%");
            newMonthlyAnalysis.setPm10RiseOrDecline("升高");
        } else if (newMonthlyAnalysis.getPm10() < oldMonthlyAnalysis.getPm10()) {
            pm10Percentage = String.valueOf((oldMonthlyAnalysis.getPm10() - newMonthlyAnalysis.getPm10()) / oldMonthlyAnalysis.getPm10() * 100);
            newMonthlyAnalysis.setPm10Percentage(pm10Percentage.substring(0, 4) + "%");
            newMonthlyAnalysis.setPm10RiseOrDecline("降低");
        } else {
            newMonthlyAnalysis.setPm10Percentage("");
            newMonthlyAnalysis.setPm10RiseOrDecline("持平");
        }

        //pm25
        String pm25Percentage;
        if (newMonthlyAnalysis.getPm25() > oldMonthlyAnalysis.getPm25()) {
            pm25Percentage = String.valueOf((newMonthlyAnalysis.getPm25() - oldMonthlyAnalysis.getPm25()) / oldMonthlyAnalysis.getPm25() * 100);
            newMonthlyAnalysis.setPm25Percentage(pm25Percentage.substring(0, 4) + "%");
            newMonthlyAnalysis.setPm25RiseOrDecline("升高");
        } else if (newMonthlyAnalysis.getPm25() < oldMonthlyAnalysis.getPm25()) {
            pm25Percentage = String.valueOf((oldMonthlyAnalysis.getPm25() - newMonthlyAnalysis.getPm25()) / oldMonthlyAnalysis.getPm25() * 100);
            newMonthlyAnalysis.setPm25Percentage(pm25Percentage.substring(0, 4) + "%");
            newMonthlyAnalysis.setPm25RiseOrDecline("降低");
        } else {
            newMonthlyAnalysis.setPm25Percentage("");
            newMonthlyAnalysis.setPm25RiseOrDecline("持平");
        }

        //NO2
        String no2Percentage;
        if (newMonthlyAnalysis.getNo2() > oldMonthlyAnalysis.getNo2()) {
            no2Percentage = String.valueOf((newMonthlyAnalysis.getNo2() - oldMonthlyAnalysis.getNo2()) / oldMonthlyAnalysis.getNo2() * 100);
            newMonthlyAnalysis.setNo2Percentage(no2Percentage.substring(0, 4) + "%");
            newMonthlyAnalysis.setNo2RiseOrDecline("升高");
        } else if (newMonthlyAnalysis.getNo2() < oldMonthlyAnalysis.getNo2()) {
            no2Percentage = String.valueOf((oldMonthlyAnalysis.getNo2() - newMonthlyAnalysis.getNo2()) / oldMonthlyAnalysis.getNo2() * 100);
            newMonthlyAnalysis.setNo2Percentage(no2Percentage.substring(0, 4) + "%");
            newMonthlyAnalysis.setNo2RiseOrDecline("降低");
        } else {
            newMonthlyAnalysis.setNo2Percentage("");
            newMonthlyAnalysis.setNo2RiseOrDecline("降低");
        }

        //SO2
        String so2Percentage;
        if (newMonthlyAnalysis.getSo2() > oldMonthlyAnalysis.getSo2()) {
            so2Percentage = String.valueOf((newMonthlyAnalysis.getSo2() - oldMonthlyAnalysis.getSo2()) / oldMonthlyAnalysis.getSo2() * 100);
            newMonthlyAnalysis.setSo2Percentage(so2Percentage.substring(0, 4) + "%");
            newMonthlyAnalysis.setSo2RiseOrDecline("升高");
        } else if (newMonthlyAnalysis.getSo2() < oldMonthlyAnalysis.getSo2()) {
            so2Percentage = String.valueOf((oldMonthlyAnalysis.getSo2() - newMonthlyAnalysis.getSo2()) / oldMonthlyAnalysis.getSo2() * 100);
            newMonthlyAnalysis.setSo2Percentage(so2Percentage.substring(0, 4) + "%");
            newMonthlyAnalysis.setSo2RiseOrDecline("降低");
        } else {
            newMonthlyAnalysis.setSo2Percentage("");
            newMonthlyAnalysis.setSo2RiseOrDecline("持平");
        }

        //O3_8
        String o38Percentage;
        if (newMonthlyAnalysis.getO3() > oldMonthlyAnalysis.getO3()) {
            o38Percentage = String.valueOf((newMonthlyAnalysis.getO3() - oldMonthlyAnalysis.getO3()) / oldMonthlyAnalysis.getO3() * 100);
            newMonthlyAnalysis.setO38Percentage(o38Percentage.substring(0, 4) + "%");
            newMonthlyAnalysis.setO38RiseOrDecline("升高");
        } else if (newMonthlyAnalysis.getO3() < oldMonthlyAnalysis.getO3()) {
            o38Percentage = String.valueOf((oldMonthlyAnalysis.getO3() - newMonthlyAnalysis.getO3()) / oldMonthlyAnalysis.getO3() * 100);
            newMonthlyAnalysis.setO38Percentage(o38Percentage.substring(0, 4) + "%");
            newMonthlyAnalysis.setO38RiseOrDecline("降低");
        } else {
            newMonthlyAnalysis.setO38Percentage("");
            newMonthlyAnalysis.setO38RiseOrDecline("持平");
        }

        //co
        String coPercentage;
        if (newMonthlyAnalysis.getCo() > oldMonthlyAnalysis.getCo()) {
            coPercentage = String.valueOf((newMonthlyAnalysis.getCo() - oldMonthlyAnalysis.getCo()) / oldMonthlyAnalysis.getCo() * 100);
            newMonthlyAnalysis.setCoPercentage(coPercentage.substring(0, 4) + "%");
            newMonthlyAnalysis.setCoRiseOrDecline("升高");
        } else if (newMonthlyAnalysis.getCo() < oldMonthlyAnalysis.getCo()) {
            coPercentage = String.valueOf((oldMonthlyAnalysis.getCo() - newMonthlyAnalysis.getCo()) / oldMonthlyAnalysis.getCo() * 100);
            newMonthlyAnalysis.setCoPercentage(coPercentage.substring(0, 4) + "%");
            newMonthlyAnalysis.setCoRiseOrDecline("降低");
        } else {
            newMonthlyAnalysis.setCoPercentage("");
            newMonthlyAnalysis.setCoRiseOrDecline("持平");
        }
        HashMap<String, TMonthlyAnalysis> hashMap = new HashMap<>();
        hashMap.put("newMonthlyAnalysis", newMonthlyAnalysis);
        return hashMap;
    }
}



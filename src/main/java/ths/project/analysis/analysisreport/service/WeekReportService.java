package ths.project.analysis.analysisreport.service;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.deepoove.poi.XWPFTemplate;
import com.deepoove.poi.data.CellRenderData;
import com.deepoove.poi.data.Cells;
import com.deepoove.poi.data.Paragraphs;
import com.deepoove.poi.data.PictureRenderData;
import com.deepoove.poi.data.RowRenderData;
import com.deepoove.poi.data.Rows;
import com.deepoove.poi.data.TableRenderData;
import com.deepoove.poi.data.Tables;
import com.deepoove.poi.data.Texts;
import com.deepoove.poi.xwpf.WidthScalePattern;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ths.jdp.core.web.LoginCache;
import ths.jdp.core.web.RequestHelper;
import ths.jdp.eform.service.components.word.DocumentPage;
import ths.project.analysis.analysisreport.entity.WeeklyAnalysis;
import ths.project.analysis.analysisreport.entity.WeeklyAnalysisAttach2;
import ths.project.analysis.analysisreport.mapper.WeekReporAttchtMapper;
import ths.project.analysis.analysisreport.mapper.WeekReportMapper;
import ths.project.analysis.forecast.airforecastmonth.mapper.EnvAirdataRegionDayMapper;
import ths.project.analysis.forecast.report.entity.GeneralReport;
import ths.project.analysis.forecast.report.enums.AnalysisStateEnum;
import ths.project.analysis.forecast.report.enums.AscriptionTypeEnum;
import ths.project.analysis.forecast.report.mapper.GeneralReportMapper;
import ths.project.analysis.forecast.report.service.GeneralReportService;
import ths.project.common.enums.TransformFileEnum;
import ths.project.common.util.BeanUtil;
import ths.project.common.util.UUIDUtil;
import ths.project.system.file.entity.CommFile;
import ths.project.system.file.entity.CommImage;
import ths.project.system.file.service.CommFileService;
import ths.project.system.file.service.CommImageService;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class WeekReportService {
    @Autowired
    private CommFileService commFileService;
    @Autowired
    private WeekReportMapper weekReportMapper;
    @Autowired
    private GeneralReportService generalReportService;
    @Autowired
    private CommImageService commImageService;
    @Autowired
    private GeneralReportMapper generalReportMapper;
    @Autowired
    private EnvAirdataRegionDayMapper envAirdataRegionDayMapper;
    @Autowired
    private WeekReporAttchtMapper weekReporAttchtMapper;
    /**
     * 文件保存路径
     **/
    public final static String FILE_PATH = CommFileService.FILE_ROOT_PATH;
    /**
     * 文件映射路径
     **/
    private final static String IMAGE_PATH = CommImageService.TASK_IMG_PATH;

    private final static SimpleDateFormat FORMATTER = new SimpleDateFormat("yyyy-MM-dd");

    /**
     * 保存周报信息并且生成文件
     *
     * @param weeklyAnalysis
     */
    @Transactional
    public void save(WeeklyAnalysis weeklyAnalysis) {
        WeeklyAnalysis weeklyAnalysisOdl = weekReportMapper.selectById(weeklyAnalysis.getReportId());
        weeklyAnalysis.setReportId(weeklyAnalysis.getReportId());
        weeklyAnalysis.setCreateTime(new Date());
        weeklyAnalysis.setEditTime(new Date());
        weeklyAnalysis.setEditUser(LoginCache.getLoginUser().getUserName());
        weeklyAnalysis.setCreateUser(LoginCache.getLoginUser().getLoginName());
        if (weeklyAnalysisOdl != null) {
         /*   Map param = new HashMap();
            param.put("reportId",weeklyAnalysis.getReportId());
            param.put("ascriptionType",weeklyAnalysis.getAscriptionType());*/
            weekReportMapper.updateById(weeklyAnalysis);
            GeneralReport generalReport = generalReportMapper.selectById(weeklyAnalysis.getReportId());
            generalReport.setState(weeklyAnalysis.getState());
            generalReport.setReportTip(weeklyAnalysis.getReportTip());
            generalReport.setUpdateTime(new Date());
            generalReport.setUpdateUser(LoginCache.getLoginUser().getLoginName());
            generalReportMapper.updateById(generalReport);
        } else {
            saveGeneralReport(weeklyAnalysis);
            weekReportMapper.insert(weeklyAnalysis);
        }
        String[] ascriptionTypes = {"WEEK_REPORT", "WEEK_REPORT_TWO", "WEEK_REPORT_THREE", "WEEK_REPORT_FOUR", "WEEK_REPORT_FIVE"};
        List<CommImage> commImages = commImageService.queryImageListFromAscriptionTypes(weeklyAnalysis.getReportId(), ascriptionTypes);
        this.splicingWorld(commImages, weeklyAnalysis);
    }


    /**
     * 生成文件 插入数据时调用insetImageAndText方法
     *
     * @param commImages     图片信息
     * @param weeklyAnalysis 其他报告信息
     */
    private void splicingWorld(List<CommImage> commImages, WeeklyAnalysis weeklyAnalysis) {
        if (weeklyAnalysis != null) {
            String templatePath = RequestHelper.getRequest().getServletContext().getRealPath("/assets/template/weekReport.docx");
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
            String fileName = formatter.format(weeklyAnalysis.getReportTime()) + "周报";
            Map<String, Object> docParamMap = new HashMap<>();
            DocumentPage documentPage = new DocumentPage();
            documentPage.setParamMap(docParamMap);
            //先生成快报文件
            CommFile commFile = commFileService.saveGenerateWordFile(documentPage, null, null, templatePath, fileName, AscriptionTypeEnum.FAST_ANALYSIS_REPORT.getValue());
            String filePath = FILE_PATH + commFile.getFileSavePath();
            //往快报文件插入图片和其他信息
            this.insetImageAndText(commImages, filePath, weeklyAnalysis);
            commFileService.deleteFileByAscription(weeklyAnalysis.getReportId(), AscriptionTypeEnum.FAST_ANALYSIS_REPORT.getValue());
            commFileService.saveFileInfo(commFile, weeklyAnalysis.getReportId(), AscriptionTypeEnum.FAST_ANALYSIS_REPORT.getValue(), LoginCache.getLoginUser().getUserName(), AnalysisStateEnum.GENERATE.getValue());
        }
    }

    /**
     * 生成该文件详细代码。插入图片和信息的拼接
     *
     * @param images
     * @param filePath
     * @param
     */
    private void insetImageAndText(List<CommImage> images, String filePath, WeeklyAnalysis weeklyAnalysis) {

        String DateString = FORMATTER.format(weeklyAnalysis.getReportTime());
        String startTime = FORMATTER.format(weeklyAnalysis.getStratTime());
        String endTime = FORMATTER.format(weeklyAnalysis.getEndTime());
        List weeklyAnalysisAttachList = getWeeklyAnalysisAttach2(startTime, endTime);
        HashMap<String, Object> hashMap = new HashMap<String, Object>();
        BeanUtil.toMap(hashMap, weeklyAnalysis);
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(weeklyAnalysis.getReportTime());
        int weekOfYear = calendar.get(Calendar.WEEK_OF_YEAR);
        hashMap.put("WEEK_NUM", weekOfYear);
        hashMap.put("YEAR", DateString.substring(0, 4));
        hashMap.put("START_TIME", startTime.substring(5, 7) + "月" + startTime.substring(8, 10) + "日");
        hashMap.put("REPORT_TIME", DateString.substring(0, 4) + "年" + DateString.substring(5, 7) + "月" + DateString.substring(8, 10) + "日");
        hashMap.put("END_TIME", endTime.substring(5, 7) + "月" + endTime.substring(8, 10) + "日");
        hashMap.put("text11", weeklyAnalysis.getText1().substring(0, weeklyAnalysis.getText1().indexOf("轻度污染") + 4));
        hashMap.put("text21", weeklyAnalysis.getText2().substring(0, weeklyAnalysis.getText2().indexOf("天。") + 2));
        hashMap.put("text51", weeklyAnalysis.getText5().substring(0, weeklyAnalysis.getText5().indexOf("首要污染物")));
        hashMap.put("text52", weeklyAnalysis.getText5().substring(weeklyAnalysis.getText5().indexOf("前期")));
        hashMap.put("text61", weeklyAnalysis.getText6().substring(0, weeklyAnalysis.getText6().indexOf("OFP为")));
        hashMap.put("text71", weeklyAnalysis.getText7().substring(0, weeklyAnalysis.getText7().indexOf("OFP为")));
        hashMap.put("table", getTable(weeklyAnalysisAttachList));
        //拼接图片信息
        images.forEach(con -> {
            try {
                BufferedImage image = ImageIO.read(new File(IMAGE_PATH + con.getImageSavePath()));
                PictureRenderData pictureRenderData = new PictureRenderData(image.getWidth(), image.getHeight(), IMAGE_PATH + con.getImageSavePath());
                pictureRenderData.getPictureStyle().setScalePattern(WidthScalePattern.FIT);

                if (con.getAscriptionType().equals("WEEK_REPORT")) {
                    hashMap.put("image1", pictureRenderData);
                } else if (con.getAscriptionType().equals("WEEK_REPORT_TWO")) {
                    hashMap.put("image2", pictureRenderData);
                } else if (con.getAscriptionType().equals("WEEK_REPORT_THREE")) {
                    hashMap.put("image3", pictureRenderData);
                } else if (con.getAscriptionType().equals("WEEK_REPORT_FOUR")) {
                    hashMap.put("image4", pictureRenderData);
                } else if (con.getAscriptionType().equals("WEEK_REPORT_FIVE")) {
                    hashMap.put("image5", pictureRenderData);
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        });
        String templateFilePath = RequestHelper.getRequest().getServletContext().getRealPath("/assets/template/weekReport.docx");

        try (XWPFTemplate template = XWPFTemplate.compile(templateFilePath).render(hashMap);
             FileOutputStream out = new FileOutputStream(filePath)) {
            template.write(out);
            // 转换文件
            commFileService.transformFile(TransformFileEnum.DOCX, filePath, filePath.replace(".docx", ".pdf"));
            out.flush();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * word生成表格数据
     *
     * @param list
     * @return
     */
    public TableRenderData getTable(List<Map<String, Object>> list) {
        String[] nameArr = new String[8];
        CellRenderData[] aqiArr = new CellRenderData[8];
        CellRenderData[] primaryPollutantArr = new CellRenderData[8];
        CellRenderData[] o3 = new CellRenderData[8];
        CellRenderData[] pm25 = new CellRenderData[8];
        CellRenderData[] pm10 = new CellRenderData[8];
        //表头
        nameArr[0] = "日期及指标";
        aqiArr[0] = Cells.of("AQI").center().create();
        primaryPollutantArr[0] = Cells.of("首要污染物").create();
        o3[0] = Cells.of().addParagraph(Paragraphs.of().addText(Texts.of("0").create()).addText(Texts.of("3").sub().create()).addText(Texts.of("浓度").create()).create()).create();
        pm25[0] = Cells.of().addParagraph(Paragraphs.of().addText(Texts.of("PM").create()).addText(Texts.of("2.5").sub().create()).addText(Texts.of("浓度").create()).create()).create();
        pm10[0] = Cells.of().addParagraph(Paragraphs.of().addText(Texts.of("PM").create()).addText(Texts.of("10").sub().create()).addText(Texts.of("浓度").create()).create()).create();
        //拼接表格数据
        for (int i = 0; i < list.size(); i++) {
            Map<String, Object> object = new HashMap<>();
            BeanUtil.toMap(object, list.get(i));
            String day = FORMATTER.format(object.get("monitorTime")).substring(8, 10) + "日";
            nameArr[i + 1] = day;
            aqiArr[i + 1] = Cells.of(MapUtils.getString(object, "aqi")).center().bgColor(getColor(MapUtils.getString(object, "aqi"))).create();
            String primaryPollutant = MapUtils.getString(object, "primaryPollutant");
            if (StringUtils.isNotBlank(primaryPollutant) && !"co".equals(primaryPollutant.toLowerCase())) {
                String[] text = getSub(primaryPollutant);
                primaryPollutantArr[i + 1] = Cells.of().addParagraph(Paragraphs.of().addText(Texts.of(text[0]).create()).addText(Texts.of(text[1]).sub().create()).create()).create();
            } else if (StringUtils.isNotBlank(primaryPollutant) && "co".equals(primaryPollutant.toLowerCase())) {
                primaryPollutantArr[i + 1] = Cells.of().addParagraph("CO").center().create();
            }
            o3[i + 1] = Cells.of(MapUtils.getString(object, "o38")).create();
            pm25[i + 1] = Cells.of(MapUtils.getString(object, "pm25")).create();
            pm10[i + 1] = Cells.of(MapUtils.getString(object, "pm10")).create();
        }
        RowRenderData rowRenderData1 = Rows.of(nameArr).center().create();
        RowRenderData rowRenderData2 = Rows.of(aqiArr).center().create();
        RowRenderData rowRenderData3 = Rows.of(primaryPollutantArr).center().create();
        RowRenderData rowRenderData4 = Rows.of(o3).center().create();
        RowRenderData rowRenderData5 = Rows.of(pm25).center().create();
        RowRenderData rowRenderData6 = Rows.of(pm10).center().create();
        return Tables.create(rowRenderData1, rowRenderData2, rowRenderData3, rowRenderData4, rowRenderData5, rowRenderData6);
    }

    /**
     * @param str
     * @return
     */
    public String[] getSub(String str) {
        String[] text = new String[2];
        if ("pm25".equals(str.toLowerCase()) || "pm2.5".equals(str.toLowerCase())) {
            text[0] = "PM";
            text[1] = "2.5";
        } else if ("pm10".equals(str.toLowerCase())) {
            text[0] = "PM";
            text[1] = "10";
        } else if ("so2".equals(str.toLowerCase())) {
            text[0] = "SO";
            text[1] = "2";
        } else if ("no2".equals(str.toLowerCase())) {
            text[0] = "NO";
            text[1] = "2";
        } else if ("o3".equals(str.toLowerCase()) || "o3_8".equals(str.toLowerCase())) {
            text[0] = "O";
            text[1] = "3";
        }
        return text;
    }

    /**
     * 保存到GeneralReport表
     *
     * @param weeklyAnalysis
     */
    public void saveGeneralReport(WeeklyAnalysis weeklyAnalysis) {
        GeneralReport generalReport = new GeneralReport();
        generalReport.setReportId(weeklyAnalysis.getReportId());
        generalReport.setReportTime(weeklyAnalysis.getReportTime());
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        String reportName = formatter.format(weeklyAnalysis.getReportTime()) + "周报";
        generalReport.setReportName(reportName);
        generalReport.setIsMain(0);
        generalReport.setReportRate("WEEK");
        generalReport.setReportTip(weeklyAnalysis.getReportTip());
        generalReport.setState(weeklyAnalysis.getState());
        generalReport.setAscriptionType(weeklyAnalysis.getAscriptionType());
        generalReportService.saveReport(generalReport);
    }

    /**
     * 查询周报内容
     *
     * @param paramMap
     * @return
     */
    public Map<String, Object> queryReportInfo(Map<String, Object> paramMap) {
        Map<String, Object> reportMap = new HashMap<>();
        String reportId = null;
        if (paramMap.containsKey("reportId") && StringUtils.isNotBlank(MapUtils.getString(paramMap, "reportId"))) {
            reportId = MapUtils.getString(paramMap, "reportId");
        } else {
            List<Map<String, Object>> maps = generalReportService.queryWeekRecordListByReportTime(paramMap);
            if (maps != null && maps.size() > 0) {
                reportId = MapUtils.getString(maps.get(0), "REPORT_ID");
            }
        }
        WeeklyAnalysis weeklyAnalysis = weekReportMapper.selectById(reportId);
        reportMap.put("reportInfo", weeklyAnalysis);
        String startTime = null;
        String endTime = null;
        if (weeklyAnalysis != null) {
            startTime = FORMATTER.format(weeklyAnalysis.getStratTime());
            endTime = FORMATTER.format(weeklyAnalysis.getEndTime());
        } else {
            startTime = MapUtils.getString(paramMap, "startTime");
            endTime = MapUtils.getString(paramMap, "endTime");
        }
        reportMap.put("list", getWeeklyAnalysisAttach2(startTime, endTime));
        return reportMap;
    }

    /**
     * 查询周报告数据
     *
     * @param paramMap
     * @return
     */
    public List<Map<String, Object>> queryForecastListByWeek(Map<String, Object> paramMap) {
        List<Map<String, Object>> resultList = generalReportService.queryWeekRecordListByReportTime(paramMap);
        String[] ascriptionTypes = null;
        if (resultList != null && resultList.size() > 0) {
            for (Map<String, Object> resultMap : resultList) {
                if (StringUtils.isNotBlank((String) paramMap.get("ascriptionTypes"))) {
                    ascriptionTypes = ((String) paramMap.get("ascriptionTypes")).split(",");
                }
                List<Map<String, Object>> fileList = commFileService.queryFileListByAscription((String) resultMap.get("REPORT_ID"), ascriptionTypes);
                resultMap.put("fileList", fileList);
            }
        }
        return resultList;
    }

    /**
     * 查询本周监测数据
     *
     * @param startTime
     * @param endTime
     * @return
     */
    public Map<String, Object> getAirData(String startTime, String endTime) {
        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("text1", envAirdataRegionDayMapper.countNumAndAvg(startTime, endTime));
        startTime = startTime.substring(0, 4) + "-01-01";
        resultMap.put("text2", envAirdataRegionDayMapper.countNumAndAvg(startTime, endTime));
        return resultMap;
    }


    /**
     * 获取当前周的监测数据
     *
     * @param startTime
     * @param endTime
     * @return
     */
    public List getWeeklyAnalysisAttach2(String startTime, String endTime) {
        List list = null;
        if (StringUtils.isNotBlank(startTime) && StringUtils.isNotBlank(endTime)) {
            list = weekReporAttchtMapper.selectList(Wrappers.lambdaQuery(WeeklyAnalysisAttach2.class).ge(WeeklyAnalysisAttach2::getMonitorTime, startTime)
                    .le(WeeklyAnalysisAttach2::getMonitorTime, endTime)
                    .orderByAsc(WeeklyAnalysisAttach2::getMonitorTime));
            if (list == null || list.size() == 0) {
                list = envAirdataRegionDayMapper.selectListByTime(startTime, endTime);
            }
        }
        return list;
    }

    /**
     * 保存当前周的监测数据到附表2
     *
     * @param list
     */
    @Transactional
    public void saveWeekReportAttach2(List<WeeklyAnalysisAttach2> list) {
        weekReporAttchtMapper.delete(Wrappers.lambdaQuery(WeeklyAnalysisAttach2.class).eq(WeeklyAnalysisAttach2::getReportId, list.get(0).getReportId()));
        for (WeeklyAnalysisAttach2 weeklyAnalysisAttach2 : list) {
            System.out.println(weeklyAnalysisAttach2.toString());
            weeklyAnalysisAttach2.setId(UUIDUtil.getUniqueId());
            weekReporAttchtMapper.insert(weeklyAnalysisAttach2);
        }
    }

    /**
     * 删除报告
     *
     * @param paramMap
     */
    @Transactional
    public void deleteReportById(Map<String, Object> paramMap) {
        if (StringUtils.isNotBlank(MapUtils.getString(paramMap, "reportId"))) {
            generalReportMapper.deleteById(MapUtils.getString(paramMap, "reportId"));
            weekReporAttchtMapper.delete(Wrappers.lambdaQuery(WeeklyAnalysisAttach2.class).eq(WeeklyAnalysisAttach2::getReportId, MapUtils.getString(paramMap, "reportId")));
        }
    }

    /**
     * 根据aqi返回背景颜色
     *
     * @param aqiStr
     * @return
     */
    public String getColor(String aqiStr) {
        String color = null;
        if (StringUtils.isBlank(aqiStr)) {
            return color;
        }
        int aqi = Integer.parseInt(aqiStr);
        if (aqi > 0 && aqi <= 50) {
            color = "00E400";
        } else if (aqi > 50 && aqi <= 100) {
            color = "FFFF00";
        } else if (aqi > 100 && aqi <= 150) {
            color = "FF7E00";
        } else if (aqi > 150 && aqi <= 200) {
            color = "FF0000";
        } else if (aqi > 200 && aqi <= 300) {
            color = "99004C";
        } else if (aqi > 300) {
            color = "7E0023";
        }
        return color;
    }
}

package ths.project.analysis.analysisreport.service;


import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.deepoove.poi.XWPFTemplate;
import com.deepoove.poi.data.PictureRenderData;
import com.deepoove.poi.xwpf.WidthScalePattern;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ths.jdp.core.context.PropertyConfigure;
import ths.jdp.core.web.LoginCache;
import ths.jdp.core.web.RequestHelper;
import ths.jdp.eform.service.components.word.DocumentPage;
import ths.project.analysis.analysisreport.entity.TNewsletterAnalysis;
import ths.project.analysis.analysisreport.mapper.ExpressListMapper;
import ths.project.analysis.forecast.report.entity.GeneralReport;
import ths.project.analysis.forecast.report.enums.AnalysisStateEnum;
import ths.project.analysis.forecast.report.enums.AscriptionTypeEnum;
import ths.project.analysis.forecast.report.mapper.GeneralReportMapper;
import ths.project.analysis.forecast.report.service.GeneralReportService;
import ths.project.common.enums.TransformFileEnum;
import ths.project.common.util.DateUtil;
import ths.project.system.file.entity.CommFile;
import ths.project.system.file.entity.CommImage;
import ths.project.system.file.mapper.CommImageMapper;
import ths.project.system.file.service.CommFileService;
import ths.project.system.file.service.CommImageService;

import javax.imageio.ImageIO;
import javax.swing.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ExpressListService {

    @Autowired
    private ExpressListMapper expressListMapper;
    @Autowired
    private CommImageMapper commImageMapper;
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
     * /**
     * 根据月份查询预报列表
     *
     * @param
     * @return 预报列表
     */
    public List<Map<String, Object>> queryForecastListByMonth(String ascriptionType, String startMonth, String endMonth, String reportTime) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("ascriptionType", ascriptionType);
        map.put("startMonth", startMonth);
        map.put("endMonth", endMonth);
        map.put("reportTime", reportTime);
        List<Map<String, Object>> resultList = generalReportService.queryDayRecordListByReportTime(map);
        if (resultList != null && resultList.size() > 0) {
            for (Map<String, Object> resultMap : resultList) {
                List<Map<String, Object>> fileList = commFileService.queryFileListByAscription((String) resultMap.get("REPORT_ID"), ascriptionType);
                resultMap.put("fileList", fileList);
            }
        }
        return resultList;
    }

    /**
     * 保存预报总方法
     */
    @Transactional
    public void saveForecast(TNewsletterAnalysis tNewsletterAnalysis) {
        TNewsletterAnalysis newsletterAnalysis = expressListMapper.selectById(tNewsletterAnalysis.getReportId());

        tNewsletterAnalysis.setCreateTime(new Date());
        tNewsletterAnalysis.setEditTime(new Date());
        tNewsletterAnalysis.setEditUser(LoginCache.getLoginUser().getUserName());
        tNewsletterAnalysis.setCreateUser(LoginCache.getLoginUser().getLoginName());
        //更新generalReport表和
        if (newsletterAnalysis != null) {
            expressListMapper.updateById(tNewsletterAnalysis);
            GeneralReport generalReport = generalReportMapper.selectById(newsletterAnalysis.getReportId());
            generalReport.setState(tNewsletterAnalysis.getState());
            generalReport.setReportTip(tNewsletterAnalysis.getReportTip());
            generalReport.setUpdateTime(new Date());
            generalReport.setUpdateUser(LoginCache.getLoginUser().getLoginName());
            generalReportMapper.updateById(generalReport);
        } else {
            addGeneralReport(tNewsletterAnalysis);
            expressListMapper.insert(tNewsletterAnalysis);
        }
        String[] ascriptionTypes = {
                "EXPRESS_NEWS",
                "EXPRESS_NEWS_TWO",
                "EXPRESS_NEWS_THREE",
                "EXPRESS_NEWS_FOUR",
                "EXPRESS_NEWS_FIVE"};
        List<CommImage> commImages = commImageService.queryImageListFromAscriptionTypes(tNewsletterAnalysis.getReportId(), ascriptionTypes);

        this.splicingWorld(commImages, tNewsletterAnalysis);
    }

    /**
     * 保存报告数据 GeneralReport
     *
     * @param tNewsletterAnalysis
     */
    public void addGeneralReport(TNewsletterAnalysis tNewsletterAnalysis) {
        GeneralReport generalReport = new GeneralReport();
        generalReport.setReportId(tNewsletterAnalysis.getReportId());
        generalReport.setReportTime(tNewsletterAnalysis.getReportTime());
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        String reportName = formatter.format(tNewsletterAnalysis.getReportTime()) + "快报";
        generalReport.setReportName(reportName);
        generalReport.setIsMain(0);
        generalReport.setReportRate("DAY");
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
    private void splicingWorld(List<CommImage> commImages, TNewsletterAnalysis tNewsletterAnalysis) {
        if (tNewsletterAnalysis != null) {
            String templatePath = RequestHelper.getRequest().getServletContext().getRealPath("/assets/template/wallbBulletin.docx");
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
            String fileName = formatter.format(tNewsletterAnalysis.getReportTime()) + "快报";
            Map<String, Object> docParamMap = new HashMap<>();
            DocumentPage documentPage = new DocumentPage();
            documentPage.setParamMap(docParamMap);
            //先生成快报文件
            CommFile commFile = commFileService.saveGenerateWordFile(documentPage, null, null, templatePath, fileName, AscriptionTypeEnum.EXPRESS_NEWS.getValue());
            String filePath = FILE_PATH + commFile.getFileSavePath();
            //往快报文件插入图片和其他信息
            this.insetImageAndText(commImages, filePath, tNewsletterAnalysis);
            commFileService.deleteFileByAscription(tNewsletterAnalysis.getReportId(), AscriptionTypeEnum.EXPRESS_NEWS.getValue());
            commFileService.saveFileInfo(commFile, tNewsletterAnalysis.getReportId(), AscriptionTypeEnum.EXPRESS_NEWS.getValue(), LoginCache.getLoginUser().getUserName(), AnalysisStateEnum.UPLOAD.getValue());
        }
    }

    /**
     * 插入图片和信息
     *
     * @param images
     * @param filePath
     * @param tNewsletterAnalysis
     */
    private void insetImageAndText(List<CommImage> images, String filePath, TNewsletterAnalysis tNewsletterAnalysis) {
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        String DateString = formatter.format(tNewsletterAnalysis.getReportTime());
        HashMap<String, Object> hashMap = new HashMap<String, Object>() {{
            put("YEAR", DateString.substring(0, 4));
            put("NUMBER", tNewsletterAnalysis.getReportBatch());
            put("MOON", DateString.substring(5, 7));
            put("DAY", DateString.substring(8, 10));
            put("tNewsletterAnalysis", tNewsletterAnalysis);
        }};
        int[] num = {1, 1, 1, 1, 1};
        //拼接图片信息
        images.forEach(con -> {
            try {
                BufferedImage image = ImageIO.read(new File(IMAGE_PATH + con.getImageSavePath()));
                PictureRenderData pictureRenderData = new PictureRenderData(image.getWidth(), image.getHeight(), IMAGE_PATH + con.getImageSavePath());
                pictureRenderData.getPictureStyle().setScalePattern(WidthScalePattern.FIT);

                if (con.getAscriptionType().equals("EXPRESS_NEWS")) {
                    hashMap.put("image1" + num[0], pictureRenderData);
                    num[0]++;
                } else if (con.getAscriptionType().equals("EXPRESS_NEWS_TWO")) {
                    hashMap.put("image2" + num[1], pictureRenderData);
                    num[1]++;
                } else if (con.getAscriptionType().equals("EXPRESS_NEWS_THREE")) {
                    hashMap.put("image3" + num[2], pictureRenderData);
                    num[2]++;
                } else if (con.getAscriptionType().equals("EXPRESS_NEWS_FOUR")) {
                    hashMap.put("image4" + num[3], pictureRenderData);
                    num[3]++;
                } else if (con.getAscriptionType().equals("EXPRESS_NEWS_FIVE")) {
                    hashMap.put("image5" + num[4], pictureRenderData);
                    num[4]++;
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        });

        String templateFilePath = RequestHelper.getRequest().getServletContext().getRealPath("/assets/template/wallbBulletin.docx");
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
     * 删除报告
     *
     * @param reportId
     * @return
     */
    @Transactional
    public Integer deleteReportById(String reportId) {
        if (reportId == null || "".equals(reportId)) {
            return -1;
        }
        HashMap<String, Object> map = new HashMap<>();
        map.put("reportId", reportId);
        TNewsletterAnalysis tNewsletterAnalysis = expressListMapper.selectById(reportId);
        LambdaQueryWrapper<CommImage> queryWrapper = Wrappers.lambdaQuery();
        queryWrapper.eq(CommImage::getAscriptionId, tNewsletterAnalysis.getImageId());
        commImageMapper.delete(queryWrapper);
        generalReportService.deleteReportById(map);
        return expressListMapper.deleteById(reportId);
    }

    /**
     * 新增时暂存数据回显
     *
     * @param ascriptionType reportTime
     *                       reportId
     * @return
     */
    public Map<String, Object> queryDayGeneralReportByIdAndFileSource(String ascriptionType, String reportTime, String reportId) {
        Map<String, Object> reportMap = new HashMap<>();
        HashMap<String, Object> map = new HashMap<>();
        map.put("ascriptionType", ascriptionType);
        map.put("reportTime", reportTime);
        List<Map<String, Object>> maps = generalReportService.queryDayRecordListByReportTime(map);
        if (maps != null && maps.size() > 0) {
            reportId = MapUtils.getString(maps.get(0), "REPORT_ID");
        }
        if (StringUtils.isNotBlank(reportId)) {
            reportMap.put("report", expressListMapper.selectById(reportId));
            return reportMap;
        }
        return null;
    }

    /**
     * 查询超标数据
     *
     * @param reportTime
     * @return
     */
    public HashMap queryOverStandard(String reportTime) throws ParseException {
        if (StringUtils.isNotBlank(reportTime)) {
            HashMap<Object, String> map = new HashMap<>();
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
            String yesterdayTime = simpleDateFormat.format(DateUtil.addDay(simpleDateFormat.parse(reportTime), -1));
            HashMap yesterdayDataMap = expressListMapper.queryYesterdayData(yesterdayTime + " 01:00:00.000", yesterdayTime + " 11:00:00.000");
            HashMap reportTimeMap = expressListMapper.queryReportTimeData(reportTime + " 01:00:00.000", reportTime + " 11:00:00.000");
            if (yesterdayDataMap != null && reportTimeMap != null) {
                double pm25AverageConcentration = (int) yesterdayDataMap.get("PM25AVERAGE_CONCENTRATION");
                double pm10AverageConcentration = (int) yesterdayDataMap.get("PM10AVERAGE_CONCENTRATION");
                map.put("averageRatio", String.valueOf(pm25AverageConcentration / pm10AverageConcentration).substring(0, 3));
                map.put("concentrationExceededHours", String.valueOf(reportTimeMap.get("CONCENTRATION_EXCEEDED_HOURS")));
                double reportTimeNo2 = (int) reportTimeMap.get("NO2AVERAGE_CONCENTRATION");
                double yesterdayNo2 = (int) yesterdayDataMap.get("NO2AVERAGE_CONCENTRATION");
                String no2Percentage;
                if (reportTimeNo2 > yesterdayNo2) {
                    no2Percentage = String.valueOf((reportTimeNo2 - yesterdayNo2) / yesterdayNo2 * 100);
                    map.put("no2Percentage", no2Percentage.substring(0, 4) + "%");
                    map.put("no2RiseOrDecline", "上升");
                } else if (reportTimeNo2 < yesterdayNo2) {
                    no2Percentage = String.valueOf((yesterdayNo2 - reportTimeNo2) / yesterdayNo2 * 100);
                    map.put("no2Percentage", no2Percentage.substring(0, 4) + "%");
                    map.put("no2RiseOrDecline", "下降");
                } else {
                    map.put("no2Percentage", "");
                    map.put("no2RiseOrDecline", "持平");
                }
                map.put("no2averageConcentration", String.valueOf(reportTimeMap.get("NO2AVERAGE_CONCENTRATION")));
            }
            return map;
        } else {
            return null;
        }
    }
}



package ths.project.analysis.warnbulletin.service;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ths.jdp.core.context.PropertyConfigure;
import ths.jdp.core.dao.base.Paging;
import ths.jdp.core.web.LoginCache;
import ths.jdp.eform.service.components.word.DocImage;
import ths.jdp.eform.service.components.word.DocumentPage;
import ths.project.analysis.commonreport.mapper.CommonReportMapper;
import ths.project.analysis.commonreport.vo.CommonReportVo;
import ths.project.analysis.forecast.airforecastcity.mapper.AnalysisSendMessageMapper;
import ths.project.analysis.forecast.report.entity.GeneralReport;
import ths.project.analysis.forecast.report.enums.AnalysisStateEnum;
import ths.project.analysis.forecast.report.mapper.GeneralReportMapper;
import ths.project.analysis.forecast.report.service.GeneralReportService;
import ths.project.common.util.DateUtil;
import ths.project.common.util.FileUtil;
import ths.project.common.util.ParamUtils;
import ths.project.system.base.util.PageSelectUtil;
import ths.project.system.file.entity.CommFile;
import ths.project.system.file.service.CommFileService;
import ths.project.system.message.enums.SendTypeEnum;
import ths.project.system.message.service.SendMessageService;

import javax.annotation.Resource;
import java.io.UnsupportedEncodingException;
import java.util.*;

/**
 * 预警快报-服务层
 *
 * @date 2021年11月22日 9:28
 */
@Service
public class WarnBulletinService {

    @Autowired
    private CommonReportMapper commonReportMapper;
    @Autowired
    private GeneralReportMapper generalReportMapper;

    @Autowired
    private CommFileService fileService;

    @Autowired
    private GeneralReportService generalReportService;
    /**
     * 发送邮件服务层
     */
    @Resource
    private SendMessageService sendMessageService;
    @Autowired
    private AnalysisSendMessageMapper analysisSendMessageMapper;
    /**
     * 异步线程池，详情参考spring-thread.xml
     */
    @Resource
    private ThreadPoolTaskExecutor threadPoolTaskExecutor;
    /**
     * 短信模板
     */
    private final static String TEMPLATE_MESSAGE = "【#reportName#】#context#【#reportInscribe#， #editTimeZh#】";
    /**
     * 报告频率
     */
    private final static String REPORT_RATE = "DAY";
    /**
     * 模板文件名称
     */
    private final static String TEMPLATE_FILE_NAME = "warnBulletinModel.docx";
    /**
     * 图片在模板文件中的书签名称
     */
    private final static String IMAGE_LABEL = "imageLabel";
    /***
     * 图片图例前缀
     */
    private final static String LEGEND_CONTENT_PREFIX = "图";

    /**
     * 查询文件信息
     *
     * @param paramMap
     * @return
     */
    public Map<String, Object> getFileInfoByAscriptionType(Map<String, Object> paramMap) {
        Map<String, Object> resultMap = commonReportMapper.getReportInfoByAscriptionType(paramMap);
        if (resultMap != null) {
            // 查询文件
            List<Map<String, Object>> fileList = fileService.queryFileListByAscription((String) resultMap.get("REPORT_ID"));
            resultMap.put("fileList", fileList);
        }
        return resultMap;
    }

    /**
     * 保存报告表格
     * isAdd 是否为新增
     * isShowControl 是否展示管控信息
     *
     * @param generalReport
     */
    @Transactional
    public void saveReport(GeneralReport generalReport, String isAdd) {
        GeneralReport report = generalReportService.saveReport(generalReport);
        // 生成Word文件（含转换pdf）
        generateWord(report, isAdd);
        //发送短信
        sendReportMessage(report.getReportId());
    }

    /**
     * 提交报告
     * isAdd 是否为新增
     * isShowControl 是否展示管控信息
     *
     * @param reportId
     */
    @Transactional
    public void submitReport(String reportId) {
        generalReportMapper.update(null, Wrappers.lambdaUpdate(GeneralReport.class)
                .set(GeneralReport::getState, "UPLOAD")
                .eq(GeneralReport::getReportId, reportId));
        //发送短信
        sendReportMessage(reportId);
    }

    public Map<String, String> getNewestDate(Map<String, Object> paramMap) {
        return commonReportMapper.getNewestDate(paramMap);
    }

    /**
     * 查询列表数据
     *
     * @param paramMap
     * @param pageInfo
     * @return
     */
    public Paging<CommonReportVo> queryReportListByAscriptionType(Map<String, Object> paramMap, Paging<CommonReportVo> pageInfo) {
        return PageSelectUtil.selectListPage1(commonReportMapper, pageInfo, CommonReportMapper::queryReportList, paramMap);
    }

    /**
     * 提交后发送短信
     *
     * @param reportId
     * @return
     */
    private void sendReportMessage(String reportId) {
        GeneralReport report = generalReportMapper.selectById(reportId);

        if (AnalysisStateEnum.UPLOAD.getValue().equals(report.getState())) {
            //归属类型
            String ascriptionType = report.getAscriptionType();
            // 报告名称
            String reportName = report.getReportName();
            // 内容
            String context = report.getRemark();
            // 落款
            String reportInscribe = report.getReportInscribe();
            // 报告时间
            Date reportTime = report.getReportTime();
            // 获取短信内容
            context = getMessageContext(reportName, context, reportInscribe, DateUtil.formatDate(reportTime));
            // 发送内容、落款、报告时间时间不能为空
            if (StringUtils.isNotBlank(context) && StringUtils.isNotBlank(reportInscribe)
                    && reportTime != null) {
                // 发送短信
                sendMessage(context, reportId, ascriptionType);
            }
        }
    }

    /**
     * 发送短信
     *
     * @param context        快报内容
     * @param reportId       报告ID
     * @param ascriptionType 归属类型
     */
    private void sendMessage(final String context, final String reportId, final String ascriptionType) {
        // 获取短信发送开关
        String sendMessageSwitch = (String) PropertyConfigure.getProperty("send.message.switch");
        if ("on".equals(sendMessageSwitch)) {
            // 登录用户名
            final String userName = LoginCache.getLoginUser().getUserName();
            // 获取电话号码
            Map<String, Object> paramMap = new HashMap<>();
            paramMap.put("SEND_TYPE_ENUM", ascriptionType);
            List<Map<String, Object>> phoneList = analysisSendMessageMapper.queryUserPhone(paramMap);
            // 收件人联系方式，多个联系方式通过','分隔
            String phones = "";
            for (int i = 0; i < phoneList.size(); i++) {
                Map<String, Object> map = phoneList.get(i);
                // 最后一个联系人后不需要加','
                if (i == phoneList.size() - 1) {
                    phones = phones + ParamUtils.getString(map, "tel", "");
                } else {
                    phones = phones + ParamUtils.getString(map, "tel", "") + ",";
                }
            }

            String finalPhones = phones;
            threadPoolTaskExecutor.execute(new Runnable() {
                @Override
                public void run() {
                    // 发送短信
                    sendMessageService.sendMessage(context, SendTypeEnum.WARN_BULLETIN, ascriptionType, reportId, userName, finalPhones);
                }
            });
        }
    }

    /**
     * 获取短信内容
     *
     * @param reportName     报告名称
     * @param context        短信原始内容
     * @param reportInscribe 落款
     * @param reportTime     报告时间
     * @return 短信发送内容
     */
    private String getMessageContext(String reportName, String context, String reportInscribe, String reportTime) {
        return TEMPLATE_MESSAGE.replaceAll("#reportName#", reportName).replaceAll("#context#", context)
                .replaceAll("#reportInscribe#", reportInscribe).replaceAll("#editTimeZh#",
                        DateUtil.stringFormatZh2(reportTime, "yyyy-MM-dd", "yyyy年MM月dd日"));
    }

    /**
     * 生成Word文件（含转换pdf）
     */
    private void generateWord(GeneralReport report, String isAdd) {
        // 查询处理后的剩余的文件列表
//        List<CommFile> fileList = fileService.queryFileList(report.getReportId(), report.getAscriptionType());
        // 根据参数获取文档体参数对象(封装word参数)
        DocumentPage documentPage = getDocumentPage(null, report);
        // 模板路径
        String templatePath = null;
        try {
            templatePath = FileUtil.getTemplateFilePath(TEMPLATE_FILE_NAME);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        // 报告名称
        String reportName = report.getReportName();
        // 报告频率
        report.setReportRate(REPORT_RATE);
        Date reportTime = report.getReportTime();
        String reportTimeDay = DateUtil.format(reportTime, "yyyy-MM-dd");
        // 报告所在频度
        report.setReportFrequency(reportTimeDay.split("-")[2]);
        // 报告时间中文
        // paramMap.put("reportTimeZh", DateUtil.stringFormatZh2(reportTime, "yyyy-MM-dd
        // HH:mm:ss", "yyyy年MM月dd日HH时"));
        if (!"1".equals(isAdd)) {
            // 编辑
            // 删除之前生成的文件
            fileService.deleteFileByAscription(report.getReportId(), report.getAscriptionType());
        }
        List<CommFile> fileList = fileService.queryFileList(report.getReportId(), report.getAscriptionType());
        if (fileList != null && fileList.size() > 0) {
            CommFile commFile = fileService.saveGenerateWordFile(documentPage, null, null, templatePath, reportName, null);
            fileService.saveFileInfo(commFile, report.getReportId(), report.getAscriptionType(), LoginCache.getLoginUser().getUserName());
        }
    }

    /**
     * 根据参数获取文档体参数对象
     *
     * @param fileList 文件列表
     * @param report   参数
     * @return 文档体参数对象
     */
    private DocumentPage getDocumentPage(List<CommFile> fileList, GeneralReport report) {
        // 文档参数Map(文字部分)
        Map<String, Object> docParamMap = new HashMap<String, Object>();
        // 1、报告名称
        docParamMap.put("reportName", report.getReportName());
        // 2、快报内容(必填)
        docParamMap.put("warnBulletionContent", (report.getRemark()).replaceAll("\n", "\r\n"));
        // 3、重要提示(选填)
        // String reportTip = (String) paramMap.get("reportTip");
        // docParamMap.put("reportTip", StringUtils.isNotBlank(reportTip) ?
        // reportTip.replaceAll("\n","\r\n") : "无。");
        // 4、落款(必填)
        docParamMap.put("reportInscribe", report.getReportInscribe());
        // 5、时间(必填,js中内置)
        Date reportTime = report.getReportTime();
        // 报告时间中文
        docParamMap.put("reportTimeZh", DateUtil.format(reportTime, "yyyy年MM月dd日HH时"));
        // 6、图片(必填,以防万一,需要判断是否有文件)
        List<DocImage> imageList = new ArrayList<DocImage>();
        if (fileList != null && fileList.size() > 0) {
            for (int i = 0; i < fileList.size(); i++) {
                String imagePath = fileService.getFileFullPath(fileList.get(i), true);
                // 分别为图片路径，长，宽
                DocImage docImage = new DocImage(imagePath, null, null);
                String legendContent = LEGEND_CONTENT_PREFIX + (i + 1) + " " + fileList.get(i).getFileName();
                docImage.setLegendContent(legendContent);
                imageList.add(docImage);
            }
        }

        // 文档体参数对象
        DocumentPage documentPage = new DocumentPage();
        // 将文本插入到文档中
        documentPage.setParamMap(docParamMap);
        // 将图片插入到文档中
        documentPage.getImages().put(IMAGE_LABEL, imageList);
        return documentPage;
    }
}

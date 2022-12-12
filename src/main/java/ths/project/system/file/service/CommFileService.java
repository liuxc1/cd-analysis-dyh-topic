package ths.project.system.file.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import ths.jdp.core.context.PropertyConfigure;
import ths.jdp.eform.service.components.word.DocDynamicTable;
import ths.jdp.eform.service.components.word.DocumentPage;
import ths.jdp.eform.service.components.word.RepDocTemplate;
import ths.project.common.data.DiskMultipartFile;
import ths.project.common.enums.TransformFileEnum;
import ths.project.common.uid.SnowflakeIdGenerator;
import ths.project.common.util.BeanUtil;
import ths.project.common.util.DateUtil;
import ths.project.system.base.util.BatchSqlSessionUtil;
import ths.project.system.file.entity.CommFile;
import ths.project.system.file.mapper.CommFileMapper;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 通用文件-服务层
 *
 * @author zl
 */
@Service
public class CommFileService {

    @Autowired
    private CommFileMapper commFileMapper;
    @Autowired
    SnowflakeIdGenerator idGenerator;

    /**
     * 文件保存路径
     **/
    public static final String FILE_ROOT_PATH = (String) PropertyConfigure.getProperty("FILE_ROOT_PATH");
    public static final String FILE_ROOT_TEMP_PATH = (String) PropertyConfigure.getProperty("FILE_ROOT_TEMP_PATH");
    public static final String FILE_ROOT_URL = (String) PropertyConfigure.getProperty("FILE_ROOT_URL");

    private final Logger logger = LoggerFactory.getLogger(CommFileService.class);

    /**
     * 根据文件ID，查询文件信息
     *
     * @param fileId 文件ID
     * @return 文件信息
     */
    public CommFile queryFileByFileId(String fileId) {
        return commFileMapper.selectById(fileId);
    }

    /**
     * 根据文件ID，查询文件信息
     *
     * @param fileIds 文件ID
     * @return 文件信息
     */
    public List<CommFile> queryFileByFileIds(String[] fileIds) {
        return commFileMapper.selectBatchIds(Arrays.asList(fileIds));
    }

    /**
     * 根据归属id和归属类型查询文件列表
     *
     * @param ascriptionId   归属ID
     * @param ascriptionType 归属类型
     * @return 文件信息集合
     */
    public List<CommFile> queryFileList(String ascriptionId, String ascriptionType) {
        String[] ids = ascriptionId.split(",");
        LambdaQueryWrapper<CommFile> queryWrapper = Wrappers.lambdaQuery();
        queryWrapper.in(CommFile::getAscriptionId, Arrays.asList(ids));
        queryWrapper.eq(StringUtils.isNotBlank(ascriptionType), CommFile::getAscriptionType, ascriptionType);
        queryWrapper.orderByAsc(CommFile::getAscriptionType);
        queryWrapper.orderByAsc(CommFile::getCreateTime);
        return commFileMapper.selectList(queryWrapper);
    }

    /**
     * 获取文件全路径
     *
     * @return 文件全路径
     */
    public String getFileFullPath(CommFile commFile, boolean checkTransform) {
        String fileSavePath = commFile.getFileSavePath();
        String fileType = commFile.getFileType();
        String fileFullPath;
        if (fileSavePath.endsWith("/") || fileSavePath.endsWith("\\")) {
            fileFullPath = FILE_ROOT_PATH + fileSavePath.replaceAll("\\\\", "/") + commFile.getFileId() + "." + fileType;
        } else {
            fileFullPath = FILE_ROOT_PATH + fileSavePath;
        }
        if (checkTransform && 1 == commFile.getIsTransform()) {
            fileFullPath = fileFullPath.substring(0, fileFullPath.lastIndexOf(".")) + ".pdf";
        }
        return fileFullPath.replace("/", File.separator);
    }

    /**
     * 获取文件全路径
     *
     * @return 文件全路径
     */
    public String getFileFullURL(CommFile commFile, boolean checkTransform) {
        String fileSavePath = commFile.getFileSavePath();
        String fileType = commFile.getFileType();
        String fileFullUrl;
        if (fileSavePath.endsWith("/") || fileSavePath.endsWith("\\")) {
            fileFullUrl = FILE_ROOT_URL + fileSavePath.replaceAll("\\\\", "/") + commFile.getFileId() + "." + fileType;
        } else {
            fileFullUrl = FILE_ROOT_URL + fileSavePath;
        }
        if (checkTransform && 1 == commFile.getIsTransform()) {
            fileFullUrl = fileFullUrl.substring(0, fileFullUrl.lastIndexOf(".")) + ".pdf";
        }
        return fileFullUrl;
    }

    /**
     * 处理文件名
     *
     * @param request  请求对象
     * @param fileName 原始文件名
     * @return 处理后的文件名
     */
    public String handleFileName(HttpServletRequest request, String fileName) {
        try {
            // 判断是否是微软IE浏览器
            boolean isMSIE = validateMSIE(request);
            // 转换文件名编码格式，避免前台乱码
            if (isMSIE) {
                fileName = URLEncoder.encode(fileName, StandardCharsets.UTF_8.name());
            } else {
                fileName = new String(fileName.getBytes(StandardCharsets.UTF_8), StandardCharsets.ISO_8859_1);
            }
        } catch (UnsupportedEncodingException ignored) {
        }
        return fileName;
    }

    /**
     * 验证是否是微软IE浏览器
     *
     * @param request 请求对象
     * @return 是否是微软IE浏览器。True： 是，False：否
     */
    private boolean validateMSIE(HttpServletRequest request) {
        boolean isMSIE = false;
        String[] ieBrowserSignals = {"MSIE", "Trident", "Edge"};
        String userAgent = request.getHeader("User-Agent");
        for (String signal : ieBrowserSignals) {
            if (userAgent.contains(signal)) {
                isMSIE = true;
                break;
            }
        }
        return isMSIE;
    }

    /**
     * 保存文件信息
     *
     * @param commFile 文件信息
     * @return 保存条数
     */
    @Transactional
    public int saveFileInfo(CommFile commFile) {
        return commFileMapper.insert(commFile);
    }

    /**
     * 保存文件信息
     *
     * @param commFileList 文件信息集合
     * @return 保存条数
     */
    @Transactional
    public int saveFileInfo(List<CommFile> commFileList) {
        return BatchSqlSessionUtil.insertBatch(commFileMapper, commFileList);
    }

    /**
     * 保存文件信息
     *
     * @param commFiles      文件信息列表
     * @param ascriptionId   归属ID
     * @param ascriptionType 归属类型
     * @param userName       操作用户名
     * @return 保存的文件数量
     */
    @Transactional(rollbackFor = Exception.class)
    public int saveFileInfo(CommFile[] commFiles, String ascriptionId, String ascriptionType, String userName) {
        for (CommFile commFile : commFiles) {
            commFile.resolveCreate(userName);
            commFile.setFileId(idGenerator.getUniqueId());
            commFile.setAscriptionId(ascriptionId);
            commFile.setAscriptionType(ascriptionType);

        }
        int fileSaveNumber = BatchSqlSessionUtil.insertBatch(commFileMapper, Arrays.asList(commFiles));
        return fileSaveNumber;
    }

    /**
     * 保存文件信息
     *
     * @param commFiles      文件信息列表
     * @param ascriptionId   归属ID
     * @param ascriptionType 归属类型
     * @param userName       操作用户名
     * @return 保存的文件数量
     */
    @Transactional(rollbackFor = Exception.class)
    public int saveFileInfo(CommFile[] commFiles, String ascriptionId, String ascriptionType, String userName, String isTransform, String fileSource) {
        for (CommFile commFile : commFiles) {
            commFile.resolveCreate(userName);
            commFile.setFileId(idGenerator.getUniqueId());
            commFile.setAscriptionId(ascriptionId);
            commFile.setAscriptionType(ascriptionType);
            commFile.setFileSource(fileSource);
            //转换pdf
            commFile.setTransformType("pdf");
            commFile.setIsTransform(1);
            commFile.setTransform("Y");
            String fileFullPath = getFileFullPath(commFile, false);
            String transformFilePath = getFileFullPath(commFile, true);
            // 转换文件
            transformFile(TransformFileEnum.DOCX, fileFullPath, transformFilePath);
        }
        int fileSaveNumber = BatchSqlSessionUtil.insertBatch(commFileMapper, Arrays.asList(commFiles));
        return fileSaveNumber;
    }


    /**
     * 保存文件信息
     *
     * @param commFiles      文件信息列表
     * @param ascriptionId   归属ID
     * @param ascriptionType 归属类型
     * @param userName       操作用户名
     * @param fileSource     文件来源
     * @return 保存的文件数量
     */
    @Transactional(rollbackFor = Exception.class)
    public int saveFileInfo(CommFile[] commFiles, String ascriptionId, String ascriptionType, String userName, String fileSource) {
        for (CommFile commFile : commFiles) {
            commFile.resolveCreate(userName);
            commFile.setFileId(idGenerator.getUniqueId());
            commFile.setAscriptionId(ascriptionId);
            commFile.setAscriptionType(ascriptionType);
            commFile.setFileSource(fileSource);
        }
        int fileSaveNumber = BatchSqlSessionUtil.insertBatch(commFileMapper, Arrays.asList(commFiles));
        return fileSaveNumber;
    }

    /**
     * 保存文件信息
     *
     * @param commFile       文件信息
     * @param ascriptionId   归属ID
     * @param ascriptionType 归属类型
     * @param userName       操作用户名
     * @return 保存的文件数量
     */
    @Transactional(rollbackFor = Exception.class)
    public String saveFileInfo(CommFile commFile, String ascriptionId, String ascriptionType, String userName) {
        commFile.resolveCreate(userName);
        commFile.setFileId(idGenerator.getUniqueId());
        commFile.setAscriptionId(ascriptionId);
        commFile.setAscriptionType(ascriptionType);
        commFileMapper.insert(commFile);
        return commFile.getFileId();
    }

    /**
     * 保存文件信息
     *
     * @param commFile       文件信息
     * @param ascriptionId   归属ID
     * @param ascriptionType 归属类型
     * @param userName       操作用户名
     * @return 保存的文件数量
     */
    @Transactional(rollbackFor = Exception.class)
    public String saveFileInfo(CommFile commFile, String ascriptionId, String ascriptionType, String userName, String fileSource) {
        commFile.resolveCreate(userName);
        commFile.setFileId(idGenerator.getUniqueId());
        commFile.setAscriptionId(ascriptionId);
        commFile.setAscriptionType(ascriptionType);
        commFile.setFileSource(fileSource);
        commFileMapper.insert(commFile);
        return commFile.getFileId();
    }

    /**
     * 删除文件
     *
     * @param fileId 文件ID
     * @return 删除的文件数
     */
    public int deleteFile(String fileId) {
        // 删除数据库中的文件记录
        int i = commFileMapper.deleteById(fileId);
        return i;
    }

    /**
     * 根据文件ID列表删除文件
     *
     * @param fileIds 文件ID列表
     * @return 删除文件数量
     */
    @Transactional(rollbackFor = Exception.class)
    public int deleteFileByFileIds(String... fileIds) {
        return commFileMapper.deleteBatchIds(Arrays.asList(fileIds));
    }

    /**
     * 根据文件ID列表删除文件
     *
     * @return 删除文件数量
     */
    @Transactional(rollbackFor = Exception.class)
    public int deleteFileByAscription(String ascriptionId, String... ascriptionType) {
        Object[] ascriptionTypes = ascriptionType;
        return commFileMapper.delete(Wrappers.lambdaQuery(CommFile.class)
                .eq(CommFile::getAscriptionId, ascriptionId)
                .in(ascriptionType != null && ascriptionType.length > 0, CommFile::getAscriptionType, ascriptionTypes));
    }

    /**
     * 根据文件ID列表删除文件
     *
     * @return 删除文件数量
     */
    @Transactional(rollbackFor = Exception.class)
    public int deleteFileByFileSource(String ascriptionId, String... fileSource) {
        Object[] ascriptionTypes = fileSource;
        return commFileMapper.delete(Wrappers.lambdaQuery(CommFile.class)
                .eq(CommFile::getFileSource, ascriptionId)
                .in(fileSource != null && fileSource.length > 0, CommFile::getAscriptionType, ascriptionTypes));
    }

    /**
     * 根据文件ID列表删除文件
     *
     * @param fileIdList 文件ID列表
     * @return 删除文件数量
     */
    @Transactional(rollbackFor = Exception.class)
    public Integer deleteFileByFileIds(List<String> fileIdList) {
        int deleteFileNumber = commFileMapper.deleteBatchIds(fileIdList);
        return deleteFileNumber;
    }

    /**
     * 保存上传的文件
     *
     * @param multipartFiles 上传的文件集合
     * @return 保存的文件数量
     */
    public CommFile[] saveUploadFileToDisk(MultipartFile[] multipartFiles) {
        CommFile[] commFiles = new CommFile[multipartFiles.length];
        for (int i = 0; i < multipartFiles.length; i++) {
            CommFile commFile = saveUploadFileToDisk(multipartFiles[i]);
            commFiles[i] = commFile;
        }
        return commFiles;
    }

    /**
     * 保存上传的文件
     *
     * @param multipartFile 上传的文件
     * @return 保存的文件信息
     */
    public CommFile saveUploadFileToDisk(MultipartFile multipartFile) {
        String fileFullName = multipartFile.getOriginalFilename();
        String fileType = FilenameUtils.getExtension(fileFullName);
        String fileAliasName = idGenerator.getUniqueId() + "." + fileType;
        String fileSavePath = "/" + DateUtil.formatDate(new Date()).replace("-", "/") + "/" + fileAliasName;

        int flag = saveFileToDisk(multipartFile, FILE_ROOT_PATH + fileSavePath);
        if (flag > 0) {
            CommFile commFile = new CommFile();
            commFile.setFileFullName(fileFullName);
            commFile.setFileName(FilenameUtils.getBaseName(fileFullName));
            commFile.setFileType(fileType);
            commFile.setFileSavePath(fileSavePath);
            commFile.setFileSize(multipartFile.getSize());
            commFile.setDeleteFlag(0);
            return commFile;
        }
        return null;
    }

    /**
     * 保存文件到磁盘
     *
     * @param multipartFile 文件
     * @param filePath      文件全路径
     * @return 保存的文件条数
     */
    private int saveFileToDisk(MultipartFile multipartFile, String filePath) {
        // 文件不存在直接返回
        if (multipartFile.isEmpty()) {
            return 0;
        }
        try {
            filePath = filePath.replace("/", File.separator).replace("\\", File.separator);
            File file = new File(filePath);
            // 如果文件不存在或不是文件，则创建文件
            if (!file.exists() || !file.isFile()) {
                File parentFile = file.getParentFile();
                // 判断文件父目录是否存在
                if (!parentFile.exists() || !parentFile.isDirectory()) {
                    boolean b = file.getParentFile().mkdirs();
                    if (!b) {
                        throw new IOException("文件创建失败");
                    }
                }
                // 创建文件
                boolean b = file.createNewFile();
                if (!b) {
                    throw new IOException("文件创建失败");
                }
            }
            // 将上传的文件转换到本地资源存储
            multipartFile.transferTo(file);
        } catch (Exception e) {
            logger.error("文件保存异常", e);
            return 0;
        }
        return 1;
    }

    /**
     * 格式化文件大小
     *
     * @param fileSize 需要格式化的文件大小
     * @return 格式化后的文件大小
     */
    public String formetFileSize(long fileSize) {
        DecimalFormat df = new DecimalFormat("#.00");
        String fileSizeString;
        int b = 1024;
        int kb = b * b;
        int mb = b * b * b;
        if (fileSize < b) {
            fileSizeString = df.format(fileSize * 1.0) + "B";
        } else if (fileSize < kb) {
            fileSizeString = df.format(fileSize * 1.0 / b) + "KB";
        } else if (fileSize < mb) {
            fileSizeString = df.format(fileSize * 1.0 / kb) + "MB";
        } else {
            fileSizeString = df.format(fileSize * 1.0 / mb) + "GB";
        }
        return fileSizeString;
    }

    public CommFile copyCommFile(CommFile toCommFile, CommFile fromCommFile) {
        return BeanUtil.copyProperties(toCommFile, fromCommFile, CommFile::getAscriptionType
                , CommFile::getFileFullName, CommFile::getFileName
                , CommFile::getFileSavePath, CommFile::getFileSize, CommFile::getFileType);
    }

    public CommFile copyCommFile(CommFile toCommFile, CommFile fromCommFile, String userName, String ascriptionId, String ascriptionType) {
        toCommFile = this.copyCommFile(toCommFile, fromCommFile);
        toCommFile.resolveCreate(userName);
        toCommFile.setFileId(idGenerator.getUniqueId());
        toCommFile.setAscriptionId(ascriptionId);
        toCommFile.setAscriptionType(ascriptionType);
        return toCommFile;
    }

    /**
     * @param transformFileEnum 转换类型
     * @param filePath          原文件路径
     * @param transformFilePath 新文件路径
     */
    public void transformFile(TransformFileEnum transformFileEnum, String filePath, String transformFilePath) {
        if (transformFileEnum != null) {
            RepDocTemplate repDocTemplate = new RepDocTemplate();
            // 根据类型转换文件
            switch (transformFileEnum) {
                case DOC:
                    repDocTemplate.wordToPdf(filePath, transformFilePath);
                    break;
                case DOCX:
                    repDocTemplate.wordToPdf(filePath, transformFilePath);
                    break;
                default:
                    repDocTemplate.wordToPdf(filePath, transformFilePath);
                    break;
            }
        }
    }

    public void updateFileInfo(CommFile commFile) {
        commFileMapper.updateById(commFile);
    }

    /**
     * 根据归属类型和来源查询（兼容旧版）
     */
    public List<Map<String, Object>> queryFileListByAscription(String ascriptionId, String... ascriptionTypes) {
        List<CommFile> commFileList = commFileMapper.selectList(Wrappers.lambdaQuery(CommFile.class)
                .eq(CommFile::getAscriptionId, ascriptionId)
                .in(ascriptionTypes != null && ascriptionTypes.length > 0, CommFile::getAscriptionType, ascriptionTypes == null ? null : Arrays.asList(ascriptionTypes)));
        List<Map<String, Object>> list = new ArrayList<>();
        for (CommFile commFile : commFileList) {
            Map<String, Object> fileMap = BeanUtil.toMapWithUpperName(new HashMap<>(), commFile);
            String transform = commFile.getTransform();
            // 如果有转换的类型，则使用转换的类型，如果没有转换，则使用原始类型
            String fileType = "Y".equals(transform) ? commFile.getTransformType() : commFile.getFileType();
            String savePath = commFile.getFileSavePath();
            String fileUrl;
            if (savePath.endsWith("/") || savePath.endsWith("\\")) {
                fileUrl = FILE_ROOT_URL + savePath.replaceAll("\\\\", "/") + commFile.getFileId() + "." + fileType;
            } else {
                fileUrl = FILE_ROOT_URL + savePath.substring(0, savePath.lastIndexOf(".") + 1).replaceAll("\\\\", "/") + fileType;
            }
            fileMap.put("FILE_URL", fileUrl);

            list.add(fileMap);
        }
        return list;
    }

    /**
     * 根据归属ID和来源查询（兼容旧版）
     */
    public List<Map<String, Object>> queryFileListByFileSources(String reportId, String... fileSources) {
        List<CommFile> commFileList = commFileMapper.selectList(Wrappers.lambdaQuery(CommFile.class)
                .eq(CommFile::getAscriptionId, reportId)
                .in(fileSources != null && fileSources.length > 0, CommFile::getFileSource, fileSources == null ? null : Arrays.asList(fileSources)));
        List<Map<String, Object>> list = new ArrayList<>();
        for (CommFile commFile : commFileList) {
            Map<String, Object> fileMap = BeanUtil.toMapWithUpperName(new HashMap<>(), commFile);
            String transform = commFile.getTransform();
            // 如果有转换的类型，则使用转换的类型，如果没有转换，则使用原始类型
            String fileType = "Y".equals(transform) ? commFile.getTransformType() : commFile.getFileType();
            String savePath = commFile.getFileSavePath();
            String fileUrl;
            if (savePath.endsWith("/") || savePath.endsWith("\\")) {
                fileUrl = FILE_ROOT_URL + savePath.replaceAll("\\\\", "/") + commFile.getFileId() + "." + fileType;
            } else {
                fileUrl = FILE_ROOT_URL + savePath.substring(0, savePath.lastIndexOf(".") + 1).replaceAll("\\\\", "/") + fileType;
            }
            fileMap.put("FILE_URL", fileUrl);

            list.add(fileMap);
        }
        return list;
    }

    /**
     * 插入生成的Word文件信息
     *
     * @param documentPage         文档体参数对象
     * @param paramDynamicTableMap 动态表Map
     * @param bookmarks            循环表格书签集合
     * @param templatePath         模板地址
     * @param fileName             下载显示的名称（不含后缀）
     * @param remark               备注
     * @return 保存的文件数量
     */
    public CommFile saveGenerateWordFile(DocumentPage documentPage, Map<String, DocDynamicTable> paramDynamicTableMap, List<String> bookmarks, String templatePath, String fileName, String remark) {
        try {
            File tempFile = File.createTempFile("zxzxxzzc", ".docx");
            // 根据模板生成word文件
            RepDocTemplate repDocTemplate = new RepDocTemplate();
            repDocTemplate.saveWord(documentPage, paramDynamicTableMap, bookmarks
                    , tempFile.getName().substring(0, tempFile.getName().length() - 5), templatePath
                    , false, tempFile.getParentFile().getAbsolutePath());
            CommFile commFile = saveUploadFileToDisk(new DiskMultipartFile(fileName, fileName + ".docx", tempFile));

            commFile.setTransformType("pdf");
            commFile.setIsTransform(1);
            commFile.setTransform("Y");

            String fileFullPath = getFileFullPath(commFile, false);
            String transformFilePath = getFileFullPath(commFile, true);
            // 转换文件
            transformFile(TransformFileEnum.DOCX, fileFullPath, transformFilePath);

            return commFile;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}

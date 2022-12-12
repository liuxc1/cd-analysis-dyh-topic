package ths.project.system.file.web;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import ths.jdp.core.web.LoginCache;
import ths.jdp.core.web.base.BaseController;
import ths.project.common.aspect.log.annotation.LogOperation;
import ths.project.common.data.DataResult;
import ths.project.system.file.entity.CommFile;
import ths.project.system.file.entity.CommImage;
import ths.project.system.file.service.CommFileService;
import ths.project.system.file.vo.CommImageVo;

import javax.activation.MimetypesFileTypeMap;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * 通用文件-控制器
 *
 * @author zl
 */
@Controller
@RequestMapping("/system/file/file")
public class FileController extends BaseController {

    @Resource
    private CommFileService commFileService;

    /**
     * 查询文件信息
     *
     * @param fileId 文件ID
     * @return 文件信息
     */
    @RequestMapping("/queryFile")
    @ResponseBody
    @LogOperation(module = "文件管理", operation = "查询文件信息")
    public DataResult queryFile(@RequestParam(name = "fileId") String fileId) {
        if (StringUtils.isBlank(fileId)) {
            return DataResult.failure("请求参数错误，可能值为空或包含非法字符。");
        }
        CommFile commFile = commFileService.queryFileByFileId(fileId);
        if (commFile == null) {
            return DataResult.failure("文件不存在！");
        }
        return DataResult.success(commFile);
    }

    /**
     * 根据归属id和归属类型查询文件列表
     *
     * @param commFile 参数
     * @return 响应结果
     */
    @RequestMapping("/queryFileList")
    @ResponseBody
    @LogOperation(module = "文件管理", operation = "查询文件列表")
    public DataResult queryFileList(CommFile commFile) {
        List<CommFile> commFileList = commFileService.queryFileList(commFile.getAscriptionId(), commFile.getAscriptionType());
        if (CollectionUtils.isNotEmpty(commFileList)) {
            return DataResult.success(commFileList);
        }
        return DataResult.failureNoData();
    }

    /**
     * 下载文件
     *
     * @param request  请求
     * @param response 响应
     * @param commFile 参数
     */
    @RequestMapping("/downloadFile")
    @LogOperation(module = "文件管理", operation = "下载文件")
    public void downloadFile(HttpServletRequest request, HttpServletResponse response, CommFile commFile) {
        if (StringUtils.isNotBlank(commFile.getFileId())) {
            commFile = commFileService.queryFileByFileId(commFile.getFileId());
        }
        // 获取文件全路径
        String filePath = commFileService.getFileFullPath(commFile, false);
        // 获取编码后的文件名
        String fileName = commFileService.handleFileName(request, commFile.getFileFullName());
        // 设置文件MIME类型
        response.setContentType(new MimetypesFileTypeMap().getContentType(filePath));
        // 设置Content-Disposition
        response.setHeader("Content-Disposition", "attachment;filename=\"" + fileName + "\"");
        BufferedInputStream buffIn = null;
        BufferedOutputStream buffOut = null;
        try {
            // 读取目标文件
            buffIn = new BufferedInputStream(new FileInputStream(filePath));
            // 通过response将目标文件写到客户端
            buffOut = new BufferedOutputStream(response.getOutputStream());
            // 定义缓冲区大小
            byte[] buff = new byte[4096];
            int readLength;
            // 循环写入到前台
            while (((readLength = buffIn.read(buff)) != -1)) {
                buffOut.write(buff, 0, readLength);
            }
            // 刷新缓冲区
            buffOut.flush();
        } catch (IOException e) {
            log.error("", e);
        } finally {
            // 关闭流
            IOUtils.closeQuietly(buffOut);
            IOUtils.closeQuietly(buffIn);
        }
    }

    /**
     * 根据文件ID列表删除文件
     *
     * @param fileIds 文件ID列表
     * @return 删除文件数量
     */
    @RequestMapping("/deleteFileByFileIds")
    @ResponseBody
    @LogOperation(module = "文件管理", operation = "删除文件")
    public DataResult deleteFileByFileIds(@RequestParam(value = "fileIds") String[] fileIds) {
        int deleteFileNumber = commFileService.deleteFileByFileIds(fileIds);
        if (deleteFileNumber > 0) {
            DataResult.success(deleteFileNumber);
        }
        return DataResult.failure();
    }


    /**
     * @Author ZT
     * @Description 上传文件
     * @Date 16:11 2021/10/8
     * @Param [multipartFiles, params]
     * @return ths.project.common.data.DataResult
     **/
    @ResponseBody
    @RequestMapping("/uploadFile")
    @LogOperation(module = "文件管理", operation = "上传文件")
    public DataResult uploadFile(@RequestParam(value = "files", required = false) MultipartFile[] multipartFiles,
                                 @RequestParam Map<String, Object> params) {
        if (multipartFiles != null && multipartFiles.length > 0) {
            CommFile[] commFiles = commFileService.saveUploadFileToDisk(multipartFiles);
            int fileSaveNumber=0;
            if ("Y".equals(params.get("isTransform").toString())){
                fileSaveNumber = commFileService.saveFileInfo(commFiles,params.get("ascriptionId").toString(), params.get("ascriptionType").toString(), LoginCache.getLoginUser().getLoginName(),params.get("isTransform").toString(),params.get("fileSource").toString());
            }else {
                fileSaveNumber = commFileService.saveFileInfo(commFiles,params.get("ascriptionId").toString(), params.get("ascriptionType").toString(), LoginCache.getLoginUser().getLoginName());
            }
            return DataResult.success(fileSaveNumber);
        }
        return DataResult.failure();
    }

    @RequestMapping("/deleteFile")
    @ResponseBody
    @LogOperation(module = "文件管理", operation = "删除文件")
    public DataResult deleteFile(@RequestParam(value = "fileId") String fileId) {
        int deleteFileNumber = commFileService.deleteFile(fileId);
        if (deleteFileNumber > 0) {
            return DataResult.success(deleteFileNumber);
        }
        return DataResult.failure();
    }

}

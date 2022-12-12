package ths.project.system.file.web;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import ths.jdp.core.web.LoginCache;
import ths.project.common.aspect.log.annotation.LogOperation;
import ths.project.common.data.DataResult;
import ths.project.system.file.entity.CommImage;
import ths.project.system.file.service.CommImageService;
import ths.project.system.file.vo.CommImageVo;

import java.util.List;

/**
 * 图片操作-控制器
 *
 * @author zl
 */
@Controller
@RequestMapping("/system/file/image")
public class ImageController {
    @Autowired
    private CommImageService commImageService;

    /**
     * 根据归属id和归属类型查询图片列表
     *
     * @param commImage 请求参数
     * @return 结果
     */
    @RequestMapping("/queryImageList")
    @ResponseBody
    @LogOperation(module = "图片管理", operation = "查询图片列表")
    public DataResult queryFileList(CommImage commImage) {
        List<CommImage> commImageList = commImageService.queryImageList(commImage.getAscriptionId(),
                commImage.getAscriptionType());
        if (CollectionUtils.isNotEmpty(commImageList)) {
            return DataResult.success(commImageList);
        }
        return DataResult.failureNoData();
    }

    /**
     * 视频查看页面
     */
    @RequestMapping("/showvideo")
    @LogOperation(module = "视频管理", operation = "查看视频页面")
    public String showVideo(Model model, @RequestParam String url) {
        model.addAttribute("videourl", url);
        return "/system/file/videoShow";
    }


    /**
     * 上传文件
     *
     * @param commFileVo 请求
     */
    @ResponseBody
    @RequestMapping("/uploadFile")
    @LogOperation(module = "图片管理", operation = "上传文件")
    public DataResult uploadFile(CommImageVo commFileVo) {
        if (commFileVo.getFiles() != null && commFileVo.getFiles().length > 0) {
            CommImage[] commFiles = commImageService.saveUploadFileToDisk(commFileVo.getFiles());
            commFiles = commImageService.saveImageInfo(commFiles, commFileVo.getAscriptionId(), commFileVo.getAscriptionType(), LoginCache.getLoginUser().getLoginName());
            return DataResult.success(commFiles);
        }
        return DataResult.failure();
    }

    /**
     * 根据文件ID列表删除文件
     *
     * @param fileId 文件ID列表
     * @return 删除文件数量
     */
    @RequestMapping("/deleteFile")
    @ResponseBody
    @LogOperation(module = "图片管理", operation = "删除文件")
    public DataResult deleteFile(@RequestParam(value = "fileId") String fileId) {
        int deleteFileNumber = commImageService.deleteImageById(fileId);
        if (deleteFileNumber > 0) {
            return DataResult.success(deleteFileNumber);
        }
        return DataResult.failure();
    }
}

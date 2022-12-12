package ths.project.system.file.service;

import java.io.File;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.atomic.AtomicReference;

import javax.annotation.Resource;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;

import ths.jdp.core.context.PropertyConfigure;
import ths.project.common.uid.SnowflakeIdGenerator;
import ths.project.common.util.BeanUtil;
import ths.project.common.util.DateUtil;
import ths.project.system.base.util.BatchSqlSessionUtil;
import ths.project.system.file.entity.CommImage;
import ths.project.system.file.mapper.CommImageMapper;

/**
 * 图片操作-服务层
 *
 * @author zl
 */
@Service
public class CommImageService {

    public static final String TASK_IMG_PATH = (String) PropertyConfigure.getProperty("TASK_IMG_PATH");

    /**
     * 图片操作-数据层
     */
    @Autowired
    private CommImageMapper commImageMapper;

    /**
     * 主键生成器
     */
    @Autowired
    private SnowflakeIdGenerator idGenerator;

    /**
     * 异步线程池
     */
    @Resource
    private ThreadPoolTaskExecutor threadPoolTaskExecutor;

    /**
     * 查询图片列表
     *
     * @param ascriptionId   归属id
     * @param ascriptionType 归属类型
     * @return 图片信息列表
     */
    public List<CommImage> queryImageList(String ascriptionId, String ascriptionType) {
        LambdaQueryWrapper<CommImage> queryWrapper = Wrappers.lambdaQuery();
        queryWrapper.in(CommImage::getAscriptionId, ascriptionId);
        queryWrapper.eq(StringUtils.isNotBlank(ascriptionType), CommImage::getAscriptionType, ascriptionType);
        queryWrapper.orderByAsc(CommImage::getCreateTime);
        return commImageMapper.selectList(queryWrapper);
    }

    /**
     * 查询图片列表
     *
     * @param ascriptionId   归属id集合
     * @param ascriptionType 归属类型
     * @return 图片信息列表
     */
    public List<CommImage> queryImageListbyAscriptionIdList(List<String> ascriptionId, String ascriptionType) {
        LambdaQueryWrapper<CommImage> queryWrapper = Wrappers.lambdaQuery();
        queryWrapper.in(CommImage::getAscriptionId, ascriptionId);
        queryWrapper.eq(StringUtils.isNotBlank(ascriptionType), CommImage::getAscriptionType, ascriptionType);
        queryWrapper.orderByAsc(CommImage::getCreateTime);
        return commImageMapper.selectList(queryWrapper);
    }



    /**
     * 根据图片ID，查询图片信息
     *
     * @param imageIds 图片ID
     * @return 图片信息
     */
    public List<CommImage> queryImageByImageIds(String[] imageIds) {
        return commImageMapper.selectBatchIds(Arrays.asList(imageIds));
    }

    /**
     * 保存文件信息
     *
     * @param commImage 文件信息
     * @return 保存条数
     */
    @Transactional
    public int saveImageInfo(CommImage commImage) {
        return commImageMapper.insert(commImage);
    }

    /**
     * 保存文件信息
     *
     * @param commImageList 文件信息集合
     * @return 保存条数
     */
    @Transactional
    public int saveImageInfo(List<CommImage> commImageList) {
        return BatchSqlSessionUtil.insertBatch(commImageMapper, commImageList);
    }

    /**
     * 保存图片信息
     *
     * @param commImage      图片信息
     * @param ascriptionId   归属ID
     * @param ascriptionType 归属类型
     * @param userName       操作用户名
     * @return 保存的文件数量
     */
    @Transactional(rollbackFor = Exception.class)
    public String saveImageInfo(CommImage commImage, String ascriptionId, String ascriptionType, String userName) {
        commImage.resolveCreate(userName);
        commImage.setImageId(idGenerator.getUniqueId());
        commImage.setAscriptionId(ascriptionId);
        commImage.setAscriptionType(ascriptionType);
        commImageMapper.insert(commImage);
        return commImage.getImageId();
    }



    /**
     * 保存图片信息
     *
     * @param commImages      图片信息
     * @param ascriptionId   归属ID
     * @param ascriptionType 归属类型
     * @param userName       操作用户名
     * @return 保存的文件数量
     */
    @Transactional(rollbackFor = Exception.class)
    public CommImage[] saveImageInfo(CommImage[] commImages, String ascriptionId, String ascriptionType, String userName) {
        for (CommImage commImage : commImages) {
            commImage.resolveCreate(userName);
            commImage.setImageId(idGenerator.getUniqueId());
            commImage.setAscriptionId(ascriptionId);
            commImage.setAscriptionType(ascriptionType);
        }
        BatchSqlSessionUtil.insertBatch(commImageMapper, Arrays.asList(commImages));
        return commImages;
    }

    /***
     * 根据id删除图片
     *
     * @param id
     *            图片id
     * @return 删除条数
     */
    @Transactional
    public int deleteImageById(String id) {
        int deletenum = commImageMapper.deleteById(id);
        return deletenum;
    }

    /**
     * 根据文件ID列表删除文件
     *
     * @param fileIds 文件ID列表
     * @return 删除文件数量
     */
    @Transactional(rollbackFor = Exception.class)
    public int deleteImageByAscription(String ascriptionId, String... fileIds) {
        return commImageMapper.delete(Wrappers.lambdaQuery(CommImage.class)
                .in(CommImage::getImageId, Arrays.asList(fileIds)).eq(CommImage::getAscriptionId, ascriptionId));
    }

    /**
     * 根据文件ID列表删除文件
     *
     * @param fileIds 文件ID列表
     * @return 删除文件数量
     */
    @Transactional(rollbackFor = Exception.class)
    public int deleteImageByAscriptions(List<String> ascriptionIdList, String... imageIds) {
        return commImageMapper.delete(Wrappers.lambdaQuery(CommImage.class)
                .in(CommImage::getImageId, Arrays.asList(imageIds)).in(CommImage::getAscriptionId, ascriptionIdList));
    }

    /**
     * 保存上传的文件信息
     *
     * @param multipartFiles 上传的文件集合
     * @return 保存的文件数量
     */
    public CommImage[] saveUploadFileToDisk(MultipartFile[] multipartFiles) {
        CommImage[] commImages = new CommImage[multipartFiles.length];
        for (int i = 0; i < multipartFiles.length; i++) {
            CommImage commImage = saveUploadFileToDisk(multipartFiles[i]);
            commImages[i] = commImage;
        }
        return commImages;
    }

    /**
     * 保存上传的文件信息
     *
     * @param multipartFile 上传的文件
     * @return 保存的文件信息
     */
    public CommImage saveUploadFileToDisk(MultipartFile multipartFile) {
        String imageId = idGenerator.getUniqueId();
        String imageName = multipartFile.getOriginalFilename();
        String fileExtName = FilenameUtils.getExtension(imageName);
        String fileAliasName = imageId + "." + fileExtName;
        String format = DateUtil.formatDate(new Date()).replace("-", "/");
        String relativePath = "/" + format + "/" + fileAliasName;
        String previewPath = "/PREVIEW/" + format + "/" + imageId + ".png";

        CommImage commImage = new CommImage();
        commImage.setImageName(imageName);
        commImage.setImageType(fileExtName);
        commImage.setImageSize(multipartFile.getSize());
        commImage.setImageSavePath(relativePath);
        commImage.setPreviewSavePath(previewPath);
        commImage.setFileAliasName(fileAliasName);

        // 主线程等待子线程计数器
        AtomicReference<Exception> atomicReference = new AtomicReference<>();
        CountDownLatch countDownLatch = new CountDownLatch(1);
        threadPoolTaskExecutor.execute(() -> {
            try {
                String filePath = (TASK_IMG_PATH + relativePath).replace("/", File.separator);
                File file = new File(filePath);
                File parentFile = file.getParentFile();
                if (!parentFile.exists() && !parentFile.mkdirs()) {
                    throw new RuntimeException("无法创建父级文件夹！" + parentFile.getAbsolutePath());
                }
                multipartFile.transferTo(file);

                String previewFilePath = (TASK_IMG_PATH + previewPath).replace("/", File.separator);
                boolean flag = false;
                //TODO
//                if ("mp4".equalsIgnoreCase(fileExtName)) {
//                    flag = FFmpegUtil.createPreviewImageForVideo(file, previewFilePath);
//                } else {
//                    flag = FFmpegUtil.createPreviewImage(file, previewFilePath);
//                }
                if (!flag) {
                    commImage.setPreviewSavePath("/no_preview_picture.png");
                }
            } catch (Exception e) {
                atomicReference.set(e);
            } finally {
                countDownLatch.countDown();
            }
        });
        try {
            countDownLatch.await();
        } catch (InterruptedException e) {
            atomicReference.set(e);
        }
        if (atomicReference.get() != null) {
            throw new RuntimeException(atomicReference.get());
        }
        return commImage;
    }

    /**
     * 复制图片信息
     *
     * @param toCommImage   目标图片信息
     * @param fromCommImage 来源图片信息
     * @return 目标图片信息
     */
    public CommImage copyCommImage(CommImage toCommImage, CommImage fromCommImage) {
        return BeanUtil.copyProperties(toCommImage, fromCommImage, CommImage::getAscriptionType,
                CommImage::getFileAliasName, CommImage::getImageName, CommImage::getImageSavePath,
                CommImage::getImageSize, CommImage::getImageType, CommImage::getPreviewSavePath, CommImage::getRemark);
    }

    /**
     * 复制图片信息
     *
     * @param toCommImage    目标图片信息
     * @param fromCommImage  来源图片信息
     * @param userName       操作用户名
     * @param ascriptionId   所属ID
     * @param ascriptionType 所属类型
     * @return 目标图片信息
     */
    public CommImage copyCommImage(CommImage toCommImage, CommImage fromCommImage, String userName, String ascriptionId,
                                   String ascriptionType) {
        toCommImage = this.copyCommImage(toCommImage, fromCommImage);
        toCommImage.resolveCreate(userName);
        toCommImage.setImageId(idGenerator.getUniqueId());
        toCommImage.setAscriptionId(ascriptionId);
        toCommImage.setAscriptionType(ascriptionType);
        return toCommImage;
    }

    @Transactional
    public int updateImageInfo(CommImage commImage) {
        return commImageMapper.updateById(commImage);
    }

    /**
     * 根据归属id和类型删除图片
     *
     * @param ascriptionId
     * @param ascriptionType
     * @return
     */
    public int deleteImagesByAscriptionId(String ascriptionId, String ascriptionType) {
        LambdaQueryWrapper<CommImage> queryWrapper = Wrappers.lambdaQuery();
        queryWrapper.eq(CommImage::getAscriptionId, ascriptionId);
        queryWrapper.eq(StringUtils.isNotBlank(ascriptionType), CommImage::getAscriptionType, ascriptionType);
        int deleteFileNumber = commImageMapper.delete(queryWrapper);
        return deleteFileNumber;
    }

    /**
     * 根据归属id和多类型查询图片
     * @param ascriptionId
     * @param ascriptionTypes
     * @return
     */
    public List<CommImage> queryImageListFromAscriptionTypes(String ascriptionId, String[] ascriptionTypes) {
        LambdaQueryWrapper<CommImage> queryWrapper = Wrappers.lambdaQuery();
        queryWrapper.in(CommImage::getAscriptionId, ascriptionId);
        queryWrapper.in( CommImage::getAscriptionType, ascriptionTypes);
        queryWrapper.orderByAsc(CommImage::getCreateTime);
        return commImageMapper.selectList(queryWrapper);
    }
}

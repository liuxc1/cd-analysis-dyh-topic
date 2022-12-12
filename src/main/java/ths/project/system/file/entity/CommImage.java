package ths.project.system.file.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import ths.project.common.constant.SchemaConstants;
import ths.project.common.entity.BaseEntity;

@TableName(value = "T_COMM_IMAGE", schema = SchemaConstants.DEFAULT)
public class CommImage extends BaseEntity {
    /**
     * 图片id
     */
    @TableId
    private String imageId;
    /**
     * 归属id
     */
    private String ascriptionId;
    /**
     * 归属类型
     */
    private String ascriptionType;
    /**
     * 图片名称
     */
    private String imageName;
    /**
     * 图片类型
     */
    private String imageType;
    /**
     * 图片大小
     */
    private Long imageSize;
    /**
     * 图片保存相对地址
     */
    private String imageSavePath;
    /**
     * 预览图保存地址
     */
    private String previewSavePath;
    /**
     * 图片描述
     */
    private String remark;
    /**
     * 图片别名
     */
    private String fileAliasName;

    /**
     * 来源url
     */
    private String originUrl;

    public String getImageId() {
        return imageId;
    }

    public void setImageId(String imageId) {
        this.imageId = imageId;
    }

    public String getAscriptionId() {
        return ascriptionId;
    }

    public void setAscriptionId(String ascriptionId) {
        this.ascriptionId = ascriptionId;
    }

    public String getAscriptionType() {
        return ascriptionType;
    }

    public void setAscriptionType(String ascriptionType) {
        this.ascriptionType = ascriptionType;
    }

    public String getImageName() {
        return imageName;
    }

    public void setImageName(String imageName) {
        this.imageName = imageName;
    }

    public String getImageType() {
        return imageType;
    }

    public void setImageType(String imageType) {
        this.imageType = imageType;
    }

    public Long getImageSize() {
        return imageSize;
    }

    public void setImageSize(Long imageSize) {
        this.imageSize = imageSize;
    }

    public String getImageSavePath() {
        return imageSavePath;
    }

    public void setImageSavePath(String imageSavePath) {
        this.imageSavePath = imageSavePath;
    }

    public String getPreviewSavePath() {
        return previewSavePath;
    }

    public void setPreviewSavePath(String previewSavePath) {
        this.previewSavePath = previewSavePath;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public String getFileAliasName() {
        return fileAliasName;
    }

    public void setFileAliasName(String fileAliasName) {
        this.fileAliasName = fileAliasName;
    }

    public String getOriginUrl() {
        return originUrl;
    }

    public void setOriginUrl(String originUrl) {
        this.originUrl = originUrl;
    }

}

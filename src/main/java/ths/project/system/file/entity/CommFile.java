package ths.project.system.file.entity;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import ths.project.common.constant.SchemaConstants;
import ths.project.common.entity.BaseEntity;

/**
 * 通用文件实体类
 *
 * @author zl
 */
@TableName(value = "T_COMM_FILE", schema = SchemaConstants.DEFAULT)
public class CommFile extends BaseEntity {
    /**
     * 文件ID
     **/
    @TableId
    private String fileId;
    /**
     * 归属id
     **/
    private String ascriptionId;
    /**
     * 归属类型(配合字典)
     **/
    private String ascriptionType;
    /**
     * 文件来源
     **/
    private String fileSource;
    /**
     * 文件全名
     **/
    private String fileFullName;
    /**
     * 文件名称(无后缀)
     **/
    private String fileName;
    /**
     * 文件类型(如docx)
     **/
    private String fileType;
    /**
     * 文件大小
     **/
    private Long fileSize;
    /**
     * 格式化文件大小
     */
    private String fileFormatSize;
    /**
     * 文件磁盘路径（相对路径）
     **/
    private String fileSavePath;
    /**
     * 来源url
     */
    private String originUrl;
    /**
     * 是否转换(1\0)
     */
    private Integer isTransform;
    /**
     * 是否转换(一期 Y\N)
     */
    private String transform;
    /**
     * 转换类型
     */
    private String transformType;
    /**
     * 文件别名
     */
    private String fileAlias;
    /**
     * 备注
     */
    private String remark;

    public Integer getSort() {
        return sort;
    }

    public void setSort(Integer sort) {
        this.sort = sort;
    }

    /** 排序 **/
    private Integer sort;

    public String getFileId() {
        return fileId;
    }

    public void setFileId(String fileId) {
        this.fileId = fileId;
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

    public String getFileSource() {
        return fileSource;
    }

    public void setFileSource(String fileSource) {
        this.fileSource = fileSource;
    }

    public String getFileFullName() {
        return fileFullName;
    }

    public void setFileFullName(String fileFullName) {
        this.fileFullName = fileFullName;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFileType() {
        return fileType;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }

    public Long getFileSize() {
        return fileSize;
    }

    public void setFileSize(Long fileSize) {
        this.fileSize = fileSize;
    }

    public String getFileSavePath() {
        return fileSavePath;
    }

    public void setFileSavePath(String fileSavePath) {
        this.fileSavePath = fileSavePath;
    }

    public String getOriginUrl() {
        return originUrl;
    }

    public void setOriginUrl(String originUrl) {
        this.originUrl = originUrl;
    }

    public String getTransformType() {
        return transformType;
    }

    public void setTransformType(String transformType) {
        this.transformType = transformType;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public String getRemark() {
        return remark;
    }

    public void setIsTransform(Integer isTransform) {
        this.isTransform = isTransform;
    }

    public Integer getIsTransform() {
        return isTransform;
    }

    public String getTransform() {
        return transform;
    }

    public void setTransform(String transform) {
        this.transform = transform;
    }

    public String getFileAlias() {
        return fileAlias;
    }

    public void setFileAlias(String fileAlias) {
        this.fileAlias = fileAlias;
    }

    public String getFileFormatSize() {
        return fileFormatSize;
    }

    public void setFileFormatSize(String fileFormatSize) {
        this.fileFormatSize = fileFormatSize;
    }

    @Override
    public void resolveCreate(String userName) {
        super.resolveCreate(userName);
        this.setIsTransform(0);
    }
}

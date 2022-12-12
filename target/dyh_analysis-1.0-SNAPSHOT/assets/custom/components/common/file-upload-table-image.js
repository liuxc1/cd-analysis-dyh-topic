/**
 * 文件上传表格组件-图片上传扩展逻辑js
 */
/**
 * 组件属性配置-构造函数
 * @param template 模版对象
 * @returns vue组件配置
 * @constructor
 */
function ImageFileUploadTableComponentOption(template) {
    var option = {
        extends: new FileUploadTableComponentOption(template),
        data: function () {
            return {
                taskImgUrl: window.taskImgUrl,
            };
        },
        props: {
            allowFileTypes: {
                type: [String, Object],
                default: 'png,jpg,jpeg,gif',
            },
        },
        updated: function () {
            var _this = this;
            this.$nextTick(function () {
                _this.jq_fileListTableBody.viewer('destroy');
                _this.jq_fileListTableBody.viewer({url: "data-original"});
            })
        },
        methods: {
            /**
             * 依据参数刷新文件列表
             */
            refreshFileList: function () {
                var _this = this;
                _this.tempFileList = [];
                if (_this.fileList && _this.fileList.length > 0) {
                    _this.resolveTempFileList(_this.fileList);
                } else if (_this.ascriptionId) {
                    AjaxUtil.sendAjax(ctx + '/system/file/image/queryImageList.vm', {
                        'ascriptionId': _this.ascriptionId,
                        'ascriptionType': _this.ascriptionType
                    }, function (result) {
                        var fileInfoList = [];
                        for (let i = 0; i < result.data.length; i++) {
                            let info = result.data[i];
                            fileInfoList.push({
                                fileId: info.imageId,
                                fileName: info.imageName,
                                fileUrl: window.taskImgUrl + info.imageSavePath,
                                fileType: info.imageType,
                                fileSize: info.imageSize,
                                fileDesc: info.remark,
                                createTime: info.createTime,
                                previewSavePath: info.previewSavePath
                            });
                        }
                        _this.resolveTempFileList(fileInfoList);
                    }, function () {
                    }, function () {
                    });
                }
            },
            /**
             * 自定义文件上传事件
             */
            addFileInfo: function () {
                var _this = this;
                let files = _this.jq_fileSelectInput[0].files;
                var flag = this.fileUploadUtil.checkFileUpload(files, this.tempFileList);
                if (flag) {
                    if (_this.ascriptionId) {
                        var url = ctx + "/system/file/image/uploadFile.vm";
                        var formData = new FormData();
                        for (let i = 0; i < files.length; i++) {
                            formData.append("files", files[i]);
                        }
                        formData.append("ascriptionId", _this.ascriptionId);
                        formData.append("ascriptionType", _this.ascriptionType);

                        AjaxUtil.sendAjaxMultipart(url, formData, function (result) {
                            _this.refreshFileList();
                        }, null, null);
                    } else {
                        // 验证通过，将文件加入到列表中
                        var fileInfoList = [];
                        for (let i = 0; i < files.length; i++) {
                            let fileInfo = this.fileUploadUtil.handleFileInfo(files[i]);
                            fileInfo.fileUrl = URL.createObjectURL(files[i]);
                            fileInfoList.push(fileInfo);
                            this.tempFileList.push(fileInfo);
                        }
                        _this.$emit('addFileInfo', fileInfoList);
                    }
                }
                //清空input内容以防change事件失效
                _this.jq_fileSelectInput.val('');
            },
            downloadFile: function (fileInfo) {
                window.open(fileInfo.fileUrl, '_blank');
            },
            deleteFileInfo: function (index) {
                var _this = this;
                DialogUtil.showConfirmDialog("删除选中的图片，请确认！", function () {
                    var fileInfo = _this.tempFileList[index];
                    if (_this.ascriptionId) {
                        AjaxUtil.sendAjax(ctx + "/system/file/image/deleteFile.vm", {
                            'fileId': fileInfo.fileId,
                        }, function (result) {
                            _this.refreshFileList();
                        }, null, null);
                    } else {
                        _this.tempFileList.splice(index, 1);
                        //触发自定义事件（删除文件）
                        _this.$emit('deleteFileInfo', fileInfo, index);
                        //兼容旧版删除
                        if (fileInfo.fileId != null && _this.deleteFileIds != null) {
                            _this.deleteFileIds.push(fileInfo.fileId);
                        }
                    }
                }, null);
            },
            showvideo: function (url) {
                var s = dialog({
                    title: '视频查看',
                    width: 980,
                    height: 440,
                    url: ctx + '/system/file/image/showvideo.vm?url=' + url
                });
                s.showModal();
            }
        },
    };
    return option;
}

(function () {
    var templateId = 'vue-template-image-upload-table';
    var template = document.getElementById(templateId);
    if (template != null) {
        var option = new ImageFileUploadTableComponentOption(template);
        Vue.component('image-upload-table', option);
    }
})();

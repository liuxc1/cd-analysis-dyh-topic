/**
 * 文件上传表格组件-逻辑js
 */

/**
 * 组件属性配置-构造函数
 * @param template 模版对象
 * @returns vue组件配置
 * @constructor
 */
function FileUploadTableComponentOption(template) {
    var option = {
        template: template,
        /**
         * 外部接收的参数
         */
        props: {
            // 是否转换pdf
            isTransform: {
                type: String,
                default: '',
            },
            // 文件来源
            fileSource: {
                type: String,
                default: '',
            },
            // 所属ID
            ascriptionId: {
                type: String,
                default: '',
            },

            // 所属类型
            ascriptionType: {
                type: String,
                default: '',
            },
            // 最大文件大小
            maxFileSize: {
                type: Number,
                // 默认大小为5 MB
                default: 5 * 1024 * 1024
            },
            // 允许文件类型对象
            allowFileTypes: [String, Object],
            // 最小文件个数
            minFileNumber: {
                type: Number,
                default: 0
            },
            // 最大文件个数
            maxFileNumber: {
                type: Number,
                default: 9
            },
            // 是否允许下载
            allowDownload: {
                type: Boolean,
                default: true
            },
            // 是否显示上传按钮
            allowUpload: {
                type: Boolean,
                default: true
            },
            // 是否显示删除按钮
            allowDelete: {
                type: Boolean,
                default: true
            },
            // 是否显示文件描述输入框
            showFileDesc: {
                type: Boolean,
                default: false
            },
            //提示信息
            titles: {
                type: String,
                default: "",
            },
            downloadUrl: {
                type: String,
                default: ctx + FileDownloadUtil.fileDownloadUrl,
            },
            downloadIdName: {
                type: String,
                default: 'id',
            },
            downloadParams: {
                type: Object,
                default: function () {
                    return {};
                },
            },
            /**
             * 以下已废弃
             */
            // 文件列表(和外键ID冲突，请选用其一)
            fileList: {
                type: Array,
            },
            // 删除的文件ID列表
            deleteFileIds: {
                type: Array,
            },
        },
        /**
         * 数据
         */
        data: function () {
            return {
                // 文件工具类，交给Vue托管
                fileUploadUtil: null,
                fileDownloadUtil: null,
                jq_fileSelectInput: null,
                jq_fileListTableBody: null,
                tempFileList: [],
            }
        },
        /**
         * 挂载开始之前被调用
         */
        beforeMount: function () {
            this.fileUploadUtil = new FileUploadUtil(this.maxFileSize, this.allowFileTypes, this.maxFileNumber);
            this.fileDownloadUtil = FileDownloadUtil;
        },
        mounted: function () {
            this.jq_fileSelectInput = $(this.$refs['fileSelectInput']);
            this.jq_fileListTableBody = $(this.$refs['fileListTableBody']);
            this.refreshFileList();
        },
        watch: {
            ascriptionId: function () {
                this.refreshFileList();
            },
            fileList: function () {
                this.refreshFileList();
            }
        },
        /**
         * 组件所有方法
         */
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
                    AjaxUtil.sendAjax(ctx + '/system/file/file/queryFileList.vm', {
                        'ascriptionId': _this.ascriptionId,
                        'ascriptionType': _this.ascriptionType
                    }, function (resultData) {
                        _this.resolveTempFileList(resultData.data);
                    }, function () {
                    }, function () {
                    });
                } else {
                    _this.resolveTempFileList([]);
                }
            },
            /**
             * 配置本组件实例的文件信息列表
             * @param {Object[]} fileInfoList 外界传入的文件信息列表
             */
            resolveTempFileList: function (fileInfoList) {
                var tempFileList = [];
                for (let i = 0; i < fileInfoList.length; i++) {
                    tempFileList.push(fileInfoList[i]);
                }
                this.tempFileList = tempFileList;
            },
            /**
             * 获取文件大小（格式化后的）
             * @param {Integer} fileSize 文件真实大小
             * @returns {string} 格式化后的大小
             */
            getFormatFileSize: function (fileSize) {
                if (!fileSize || !fileSize instanceof Number) {
                    return '--';
                }
                if (fileSize < 1000 * 1024) {
                    return (fileSize / 1024.0).toFixed(2) + 'KB';
                }
                if (fileSize < 1000 * 1024 * 1024) {
                    return (fileSize / (1024.0 * 1024.0)).toFixed(2) + "MB";
                }
                return (fileSize / (1024.0 * 1024.0 * 1024.0)).toFixed(2) + "GB";
            },
            /**
             * 打开文件上传选择框
             */
            openFileSelect: function () {
                var _this = this;
                _this.jq_fileSelectInput.trigger('click');
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
                        var url = ctx + "/system/file/file/uploadFile.vm";
                        var formData = new FormData();
                        for (let i = 0; i < files.length; i++) {
                            formData.append("files", files[i]);
                        }
                        formData.append("ascriptionId", _this.ascriptionId);
                        formData.append("ascriptionType", _this.ascriptionType);
                        formData.append("isTransform", _this.isTransform);
                        formData.append("fileSource", _this.fileSource);

                        AjaxUtil.sendAjaxMultipart(url, formData, function (result) {
                            _this.refreshFileList();
                            _this.$emit('addFileInfo', fileInfoList);
                        }, null, null);
                    } else {
                        // 验证通过，将文件加入到列表中
                        var fileInfoList = [];
                        for (let i = 0; i < files.length; i++) {
                            let fileInfo = this.fileUploadUtil.handleFileInfo(files[i]);
                            fileInfoList.push(fileInfo);
                            this.tempFileList.push(fileInfo);
                        }
                        _this.$emit('addFileInfo', fileInfoList);
                    }
                }
                //清空input内容以防change事件失效
                _this.jq_fileSelectInput.val('');
            },
            /**
             * 获取当前的文件信息列表
             * @returns {Object[]} 文件信息列表
             */
            getFileInfoList: function () {
                return this.tempFileList;
            },
            /**
             * 获取文件表单数据对象
             * @param {FormData} formData 表单数据对象
             * @param {String} key 后台接收文件的Key
             * @returns {FormData} 文件表单数据对象
             */
            getFileFormData: function (formData, key) {
                var thisFileList = this.tempFileList;
                // 校验文件个数
                if (thisFileList.length < this.minFileNumber) {
                    DialogUtil.showTipDialog("文件不能少于" + this.minFileNumber + "个，请确认。", null);
                    return null;
                }
                if (thisFileList.length > this.maxFileNumber) {
                    DialogUtil.showTipDialog("文件不能多于" + this.maxFileNumber + "个，请确认。", null);
                    return null;
                }
                return this.fileUploadUtil.getFileFormData(formData, thisFileList, key);
            },
            downloadFile: function (file) {
                var _this = this;
                var url = _this.downloadUrl;
                var params = {
                    fileId: file.fileId,
                };
                $.extend(true, params, _this.downloadParams);
                _this.fileDownloadUtil.downloadFile(url, params);
            },
            deleteFileInfo: function (index) {
                var _this = this;
                DialogUtil.showConfirmDialog("删除选中的文件，请确认！", function () {
                    var fileInfo = _this.tempFileList[index];
                    if (_this.ascriptionId) {
                        AjaxUtil.sendAjax(ctx + "/system/file/file/deleteFile.vm", {
                            'fileId': fileInfo.fileId
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
            }
        },
        /**
         * 计算属性（带缓存）
         */
        computed: {
            /**
             * 获取允许的文件原始（真实）类型字符串
             * @returns {string} 允许的文件原始（真实）类型字符串
             */
            getAllowRawTypeStr: function () {
                return this.fileUploadUtil.getAllowRawTypeStr();
            },
            /**
             * 获取允许的文件类型字符串
             * @returns {string} 允许的文件类型字符串
             */
            getAllowFileTypeStr: function () {
                var types = this.fileUploadUtil.allowFileTypes;
                var arr = [];
                for (var i = 0; i < types.length; i++) {
                    arr.push(types[i].fileType);
                }
                return arr.join("/");
            },
            /**
             * 获取最大文件大小显示的文本
             * @returns {string} 格式化后的最大文件大小
             */
            getMaxFileSizeShowText: function () {
                return this.fileUploadUtil.maxFileSizeShowText;
            },
            /**
             * 获取上传最少文件个数
             * @returns 上传最大文件个数
             */
            getMinFileNumber: function () {
                return this.minFileNumber;
            },
            /**
             * 获取上传最多文件个数
             * @returns 上传最大文件个数
             */
            getMaxFileNumber: function () {
                return this.fileUploadUtil.maxFileNumber;
            },
        },
    };
    return option;
}

(function () {
    var templateId = 'vue-template-file-upload-table';
    var template = document.getElementById(templateId);
    if (template != null) {
        var option = new FileUploadTableComponentOption(template);
        Vue.component('file-upload-table', option);
    }
})();

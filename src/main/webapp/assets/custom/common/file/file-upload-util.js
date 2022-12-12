/**
 * 定义一个MyFormData类，用于存放表单数据
 * @returns
 */
function MyFormData () {
    this.formData = new FormData();
    this.values = new Array();
    this.append = function (key, value) {
        this.formData.append(key, value);
        this.values.push({'key': key, 'value': value});
    }
}

/**
 * 文件上传工具类
 *
 * @param maxFileSize 最大文件大小
 * @param allowFileTypes 允许的文件类型
 * @param maxFileNumber 最大允许上传文件个数
 */
function FileUploadUtil(maxFileSize, allowFileTypes, maxFileNumber) {
    /**
     * 文件类型
     */
    this.fileTypes = [{
        rawType: 'application/msword',
        fileType: 'doc'
    }, {
        rawType: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        fileType: 'docx'
    }, {
        rawType: 'image/jpeg',
        fileType: 'jpg'
    }, {
        rawType: 'image/png',
        fileType: 'png'
    }, {
        rawType: 'image/gif',
        fileType: 'gif'
    }, {
        rawType: 'image/bmp',
        fileType: 'bmp'
    }, {
        rawType: 'application/vnd.ms-powerpoint',
        fileType: 'ppt'
    }, {
        rawType: 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
        fileType: 'pptx'
    }, {
        rawType: 'application/vnd.ms-excel',
        fileType: 'xls'
    }, {
        rawType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        fileType: 'xlsx'
    }, {
        rawType: 'application/vnd.ms-excel',
        fileType: 'csv'
    }, {
        rawType: 'application/pdf',
        fileType: 'pdf'
    }];

    /**
     * 格式化文件大小
     *
     * @param value 需要格式化的数字
     * @return {string} 格式化后的文件大小
     */
    this.renderSize = function (value) {
        if (value == null || value === '') {
            return '0 Bytes';
        }
        var unitArr = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
        var index, srcsize = parseFloat(value);
        index = Math.floor(Math.log(srcsize) / Math.log(1024));
        // 保留的小数位数
        var size = srcsize / Math.pow(1024, index);
        size = size.toFixed(2);
        return size + ' ' + unitArr[index];
    };

    /**
     * 去掉字符串前后空格
     *
     * @param str 字符串
     * @return string
     */
    this.myTrim = function (str) {
        return str.replace(/^\s+|\s+$/gm, '');
    };

    /**
     * 获取允许的文件类型
     */
    this.initAllowFileTypes = function (allowFileTypes) {
        var types = null;
        if (typeof allowFileTypes === 'object') {
            // 如果外部传递的是对象，则使用外部传递的参数作为文件类型
            return allowFileTypes;
        } else if (typeof allowFileTypes === 'string') {
            // 如果外部传递的是字符串，则使用外部传递的参数作为文件类型
            types = allowFileTypes.split(",");
        } else {
            // 默认使用doc和docx
            types = ['doc', 'docx'];
        }
        var arr = [];
        for (var i = 0; i < this.fileTypes.length; i++) {
            var fileType = this.fileTypes[i];
            for (var j = 0; j < types.length; j++) {
                if (fileType.fileType === this.myTrim(types[j])) {
                    arr.push(fileType);
                }
            }
        }
        return arr;
    };

    /**
     * 获取允许的文件类型字符串
     */
    this.getAllowFileTypeStr = function () {
        var types = [];
        if (this.allowFileTypes != null && this.allowFileTypes.length > 0) {
            for (var i = 0; i < this.allowFileTypes.length; i++) {
                types.push(this.allowFileTypes[i].fileType);
            }
        }
        return types.join("/");
    };

    /**
     * 最大文件大小（默认为5MB）
     */
    this.maxFileSize = maxFileSize || 5 * 1024 * 1024;

    /**
     * 最大文件大小显示的文本（默认为5MB）
     */
    this.maxFileSizeShowText = this.renderSize(this.maxFileSize);

    /**
     * 允许的文件类型（默认为word文件）
     */
    this.allowFileTypes = this.initAllowFileTypes(allowFileTypes);

    /**
     * 允许的文件类型字符串
     */
    this.allowFileTypeStr = this.getAllowFileTypeStr();

    /**
     * 最大允许上传文件个数
     */
    this.maxFileNumber = maxFileNumber || 10;

    /**
     * 获取文件原始（真实）类型字符串
     */
    this.getAllowRawTypeStr = function () {
        var rawTypes = [];
        for (var i = 0; i < this.allowFileTypes.length; i++) {
            rawTypes.push(this.allowFileTypes[i].rawType);
        }
        return rawTypes.join();
    };

    /**
     * 获取文件类型
     *
     * @param {File} file 文件
     * @returns {String} 文件类型
     */
    this.getFileType = function (file) {
        var rawType = file.type;
        if (rawType) {
            for (var i = 0; i < this.allowFileTypes.length; i++) {
                if (this.allowFileTypes[i].rawType === rawType) {
                    return this.allowFileTypes[i].fileType;
                }
            }
        } else {
            var fileNameSplits = file.name.toLowerCase().split('.');
            if (fileNameSplits.length > 1) {
                rawType = fileNameSplits[fileNameSplits.length - 1];
            } else {
                rawType = '--';
            }
        }
        return rawType;
    };

    /**
     * 验证是否是大文件
     *
     * @param fileSize 文件大小
     * @returns boolean
     */
    this.validateBigFile = function (fileSize) {

        return fileSize > this.maxFileSize;
    };

    /**
     * 验证是否是为空白文件
     *
     * @param fileSize 文件大小
     * @returns boolean
     */
    this.validateBlankFile = function (fileSize) {

        return fileSize<= 0;
    };
    /**
     * 验证文件类型是否为允许文件类型
     *
     * @param rawType 文件原始类型
     * @param fileName 文件名称（含后缀）
     * @returns boolean
     */
    this.validateFileType = function (rawType, fileName) {
        for (var i = 0; i < this.allowFileTypes.length; i++) {
            if (this.allowFileTypes[i].rawType === rawType || this.endWith(fileName.toLowerCase(), "." + this.allowFileTypes[i].fileType)) {
                return true;
            }
        }
        return false;
    };

    /**
     * 判断是否以特定字符串结尾
     *
     * @param value 需要验证的字符串
     * @param end 验证规则字符串
     * @returns boolean|boolean
     */
    this.endWith = function (value, end) {
        var length = value.length - end.length;
        return (length >= 0 && value.lastIndexOf(end) === length);
    };

    /**
     * 验证是否为重复文件
     *
     * @param fileList 文件列表
     * @param file 需要验证的文件
     * @returns boolean
     */
    this.validateRepeatFile = function (fileList, file) {
        if (fileList != null && fileList.length > 0) {
            // 当文件列表中的文件大于1个的时候，需要判断是否有重复文件（当文件列表中仅一个文件时，不需要判断是否重复）
            for (var i = 0; i < fileList.length; i++) {
                if (file.name === fileList[i].fileName) {
                    return true;
                }
            }
        }
        return false;
    };

    /**
     * 是否超过最大文件个数
     *
     * @param currentFileNumber 当前选中上传的文件个数
     * @param fileList 文件列表
     * @param maxFileNumber 最大文件个数限制
     * @returns boolean
     */
    this.isExceedMaxFileNumber = function (currentFileNumber,fileList, maxFileNumber) {
        return fileList != null && fileList.length >=0 && maxFileNumber > 0 && (fileList.length + currentFileNumber) > maxFileNumber;
    };

    /**
     * 处理文件，得到规范的文件信息，方便加入到文件列表中
     * @param file 文件对象
     * @returns {{file: File, size: Integer, name: String, type: String, uploadTime: string, fileId: null}}
     */
    this.handleFileInfo = function (file) {
        return {
            file: file,
            fileId: null,
            fileFullName: file.name,
            fileName: file.name,
            fileType: this.getFileType(file),
            fileSize: file.size,
        };
    };

    /**
     * 自定义文件上传验证
     *
     * @param {File[]} files 文件上传组件返回的文件对象列表
     * @param {Object[]} fileList 要保存到的目标文件列表
     */
    this.checkFileUpload = function (files, fileList) {
        for (let i = 0; i < files.length; i++) {
            let file = files[i];
            let rawType = file.type;
            let fileName = file.name;
            // 验证文件类型是否为允许文件类型，若是允许的文件类型，还需要进行文件大小和文件重复性校验。若不是允许的文件类型，直接移除文件即可。
            if (!this.validateFileType(rawType, fileName)) {
                DialogUtil.showTipDialog('只能上传' + this.allowFileTypeStr + '文件，请确认！', null);
                return false;
            }
            // 验证是否是大文件
            if (this.validateBigFile(file.size)) {
                DialogUtil.showTipDialog('单个文件不超过' + this.maxFileSizeShowText + '，请确认！', null);
                return false;
            }else if(this.validateBlankFile(file.size)){
                DialogUtil.showTipDialog('不能选择空白文件，请确认！', null);
                return false;
            } else if (this.validateRepeatFile(fileList, file)) {
                // 验证是否是重复文件
                DialogUtil.showTipDialog('不能选择重复文件，请确认！', null);
                return false;
            } else if (this.isExceedMaxFileNumber(files.length,fileList, this.maxFileNumber)) {
                DialogUtil.showTipDialog('最多允许上传' + this.maxFileNumber + '个文件，请确认！', null);
                return false;
            }
        }
        return true;
    };

    /**
     * 删除文件
     *
     * @param fileList 文件列表（和java一样，引用传递）
     * @param index 文件索引
     * @param deleteFileIds 删除文件列表ID集合，用于记录被删除的文件ID
     */
    this.deleteFile = function (fileList, index, deleteFileIds) {
        DialogUtil.showConfirmDialog("删除选中的文件，请确认！", function () {
            if (deleteFileIds && fileList[index].fileId != null && fileList[index].file == null) {
                deleteFileIds.push(fileList[index].fileId);
            }
            fileList.splice(index, 1);
        }, null);
    };

    /**
     * 获取文件表单数据对象
     *
     * @param {FormData} formData 表单数据对象
     * @param {Object[]} fileList 文件列表
     * @param {String} key 后台接收文件的Key
     * @returns {FormData} 文件表单数据对象（FormData）
     */
    this.getFileFormData = function (formData, fileList, key) {
        key = key || 'FILES';
        // var formData = formData || new FormData(form);
        var formData = formData || new MyFormData();
        if (fileList != null && fileList.length > 0) {
            for (var i = 0; i < fileList.length; i++) {
                // 去掉已经存在的文件，仅上传新添加的文件
                if (fileList[i].file != null && fileList[i].fileId == null) {
                    formData.append(key, fileList[i].file);
                }
            }
        }
        return formData;
    };
}
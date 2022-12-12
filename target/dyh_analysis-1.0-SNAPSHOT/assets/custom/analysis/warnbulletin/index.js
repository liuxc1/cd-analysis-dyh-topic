/** 决策措施列表 **/
var vue = new Vue({
    el: '#main-container',
    data: {
        // 该功能调用的所有url列表
        urls: {
            // 根据归属类型最新文件信息
            queryFileInfo: ctx + '/analysis/warnbulletin/getFileInfoByAscriptionType.vm',
            //列表页面
            listUrl: ctx + '/analysis/warnbulletin/list.vm',
            // 查询文件是否存在
            queryFile: ctx + '/system/file/file/queryFile.vm',
            // pdf查看页面
            viewer: ctx + '/assets/components/pdfjs-2.0.943-dist/web/viewer.html',
        },
        // 菜单名称
        menuName:menuName,
        // 归属类型
        ascriptionType: ascriptionType,
        // 报告Id
        reportId:(reportId&&reportId!='null')?reportId:'',

        showClose:showClose,

        // 记录列表
        records: null,
        // 提交记录数限制，不做限制，则为-1
        uploadLimit: -1,
        // 记录信息
        record: null,
        // 文件记录列表
        fileRecords: null,
        // 选中的文件ID
        selectedFileId: null,
        // pdf的URL
        pdfUrl: null,
        // 没有数据的文本
        noDataText: null,
        // 页面的dialog
        pageDialog: null,
    },
    /**
     * 页面加载完后执行
     */
    mounted: function () {
        var _this = this;
        // 根据最大月份搜索
        _this.searchFileInfoByAscriptionType();
        //初始加载文件内容
        // 当页面改变的时候，动态改变弹出层的高度和宽度（添加和编辑页面打开时有效）
        $(window).on('resize', function() {
            if (_this.pageDialog) {
                _this.pageDialog.width($(window).width());
                _this.pageDialog.height($(window).height());
            }
        });
    },
    /**
     * 所有方法
     */
    methods: {
        search:function (){
            this.searchFileInfoByAscriptionType();
        },
        /**
         * 搜索
         */
        searchFileInfoByAscriptionType: function () {
            var _this = this;
            AjaxUtil.sendAjaxRequest(_this.urls.queryFileInfo, null, {
                ascriptionType: _this.ascriptionType,
                reportId: _this.reportId,
            }, function (json) {
                var data = json.data;
                var records = [];
                if (data){
                    records.push({
                        key: data.REPORT_ID,
                        text: data.REPORT_NAME + '（' + data.CREATE_USER + '）',
                        selected: false,
                        reportId: data.REPORT_ID,
                        ascriptionType: data.ASCRIPTION_TYPE,
                        reportName: data.REPORT_NAME,
                        reportTime: data.REPORT_TIME,
                        reportTip: data.REPORT_TIP === '' ? '--' : data.REPORT_TIP,
                        state: data.STATE,
                        createTime: data.CREATE_TIME,
                        createUser: data.CREATE_USER,
                        // 根据后台查询的文件列表，获取文件记录列表
                        fileList: _this.getFileRecordsByFileList(data.fileList)
                    });
                }
                // 选中最新一次会商
                records[records.length - 1].selected = true;
                _this.records = records;
                _this.noDataText = null;
            }, function (json) {
                _this.noData();
            });
        },
        /**
         * 根据后台查询的文件列表，获取文件记录列表
         */
        getFileRecordsByFileList: function (fileList) {
            var fileRecords = [];
            if (this.validateArray(fileList)) {
                for (var i = 0; i < fileList.length; i++) {
                    var file = fileList[i];
                    fileRecords.push({
                        key: file.FILE_ID,
                        text: this.getFileName(file.FILE_FULL_NAME, file.FILE_SIZE),
                        selected: false,
                        fileUrl: file.FILE_URL,
                        fileName: file.FILE_FULL_NAME,
                        fileType: file.FILE_TYPE
                    });
                }
                fileRecords[0].selected = true;
            }
            return fileRecords;
        },
        /**
         * 记录列表点击事件
         * @param record 点击的记录列表元素包含的信息
         */
        recordClick: function (record) {
            this.record = record;
            this.fileRecords = record.fileList;
        },
        /**
         * 文件记录列表点击事件
         * @param record 点击的文件记录列表元素包含的信息
         */
        fileRecordClick: function (record) {
            var _this = this;
            // pdf
            AjaxUtil.sendAjaxRequest(_this.urls.queryFile, null, {
                fileId: record.key
            }, function (json) {
                // 获取选中文件的ID
                _this.selectedFileId = record.key;
                // 获取pdf的URL
                _this.pdfUrl = _this.urls.viewer + '?file=' + record.fileUrl;
            }, function (json) {
                _this.selectedFileId = null;
                _this.pdfUrl = null;
                DialogUtil.showTipDialog(json.meta.message);
            });
        },
        /**
         * 没有数据
         */
        noData: function () {
            this.records = null;
            this.record = null;
            this.noDataText = '暂无数据！';
            // 没有文件
            this.noFile();
        },
        /**
         * 没有文件
         */
        noFile: function () {
            this.fileRecords = null;
            this.selectedFileId = null;
            this.pdfUrl = null;
        },
        /**
         * 验证数组是否为空
         * @param {Array} array 需要验证的数组
         * @returns 是否为空。True：为空，False：不为空
         */
        validateArray: function (array) {
            return array != null && array.length > 0;
        },
        /**
         * 获取文件名称
         * @param fileName 文件名称
         * @param fileFormatSize 文件格式化后的大小
         * @returns 文件名称
         */
        getFileName: function (fileName, fileSize) {
            //四舍五入保留两位小数
            return fileName + '（' + Math.round(fileSize / 1024.0 * 100) / 100 + 'KB）';
        },
        /**
         * 列表页面
         */
        goList:function (){
            let url=this.urls.listUrl +'?ascriptionType='+this.ascriptionType+'&menuName='+this.menuName;
            this.pageDialog = DialogUtil.showFullScreenDialog(url);
            $('body').css('overflow-y', 'hidden');
        },
        /**
         * 文件下载
         */
        downloadFile: function () {
            if (this.selectedFileId) {
                // 下载文件
                FileDownloadUtil.downloadFile(this.selectedFileId);
            }
        },
        /**
         * 取消
         * @param {boolean} isParentRefresh 是否父页面刷新
         */
        cancel: function (isParentRefresh) {
            if (window.parent && window.parent.vue.closePageDialog) {
                if (isParentRefresh != true && isParentRefresh != false) {
                    isParentRefresh = false;
                }
                // 调用父页面的关闭方法
                window.parent.vue.closePageDialog(isParentRefresh);
            } else {
                window.history.go(-1);
            }
        },
        /**
         * 关闭页面弹框
         * @param {boolean} isRefresh 是否刷新
         */
        closePageDialog: function (isRefresh) {
            $('body').css('overflow-y', 'auto');
            // 关闭弹框
            if (this.pageDialog) {
                this.pageDialog.close().remove();
                this.pageDialog = null;
            }
            if (isRefresh) {
                this.search();
            }
        },
        /**
         * 预览界面
         * 新开页面
         */
        openFullScreen:function (){
            window.open(this.pdfUrl)
        }
    }
});
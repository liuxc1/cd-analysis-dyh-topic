/** 快报分析报告-列表逻辑js **/
var vue = new Vue({
    el: '#main-container',
    data: {
        // 该功能调用的所有url列表
        urls: {
            // 根据周份，查询频率为周的时间轴列表（周份 可为空）
            queryWeekTimeAxisListByYear: ctx + '/analysis/report/generalReport/queryWeekTimeAxisListByMonth.vm',
            // 添加页面
            editAndAddUrl: ctx + '/analysis/analysisreport/weekReport/weekReportEdit.vm',
            // 删除
            deleteReportById: ctx + '/analysis/analysisreport/weekReport/deleteReportById.vm',
            // 查询文件是否存在
            queryFile: ctx + '/system/file/file/queryFile.vm',
            // pdf查看页面
            viewer: ctx + '/assets/components/pdfjs-2.0.943-dist/web/viewer.html',
            // 修改报告状态
            updateReportState: ctx + '/analysis/report/generalReport/updateReportState.vm',
            queryForecastListByWeek:ctx + '/analysis/analysisreport/weekReport/queryForecastListByWeek.vm',
        },
        yearMonth:null,
        timeAxis: {
            prev: {
                limit: '',
                title: '上一月',
                isShow: true
            },
            next: {
                limit: '',
                title: '下一月',
                isShow: true
            },
            list: null
        },
        // 归属类型
        ascriptionType: '',
        // 文件来源
        fileSources: '',
        // 开始填报月份
        startMonth: '',
        // 结束填报月份
        endMonth: '',
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
        reportTip:'',
    },
    /**
     * 页面加载完后执行
     */
    mounted: function () {
        var _this = this;
        // 归属类型
        _this.ascriptionType = $('#ascription-type').val();
        // 文件来源
        _this.fileSources = $('#file-sources').val();
        // 文件来源
        _this.year = $('#year').val();
        // 根据最大月份搜索
       // _this.searchByMaxMonth();
        _this.monthClick();
        // 当页面改变的时候，动态改变弹出层的高度和宽度（添加和编辑页面打开时有效）
        $(window).on('resize', function () {
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
        /**
         * 月份点击
         *
         * @param month
         *            月份
         */
        monthClick: function (yearMonth) {
            var _this = this;
            // 防止重复点击
            if (yearMonth != null && yearMonth === _this.yearMonth) {
                return;
            }
            AjaxUtil.sendAjaxRequest(_this.urls.queryWeekTimeAxisListByYear, null, {
                ascriptionType: _this.ascriptionType,
                month: yearMonth
            }, function (json) {
                var dataList = json.data;
                var data = dataList;
                // 填报年份月份
                _this.yearMonth = dataList.month;
                // 当传递的月份为空时，重新赋予最大月份的值
                if (yearMonth == null) {
                    _this.timeAxis.next.limit = _this.yearMonth;
                }
                var list = [];
                // 记录选中的索引
                var selectedIndex = -1;
                for (var i = 0; i < dataList.resultList.length; i++) {
                    data = dataList.resultList[i];
                    // 是否禁用。True:禁用，False:不禁用
                    var disabled = data.IS_DISABLED != 'Y';
                    // 如果有数据，则将当日标记为选中，直到选中有数据的最后一天
                    if (data.IS_DATA === 'Y') {
                        selectedIndex = i;
                    }
                    list.push({
                        key: data.REPORT_TIME,
                        text: data.SHOW_TEXT,
                        disabled: disabled,
                        selected: false,
                        isTip: data.IS_TIP === 'Y',
                        hasData: data.IS_DATA === 'Y'
                    });
                }
                // 选中有数据的最后一天
                if (selectedIndex >= 0) {
                    list[selectedIndex].selected = true;
                    _this.noDataText = null;
                } else {
                    _this.noData();
                }
                // 给时间轴赋值
                _this.timeAxis.list = list;
            });
        },
        /**
         * @param prev
         * 上一月按钮包含的数据
         */
        prevClick: function (prev) {
            var month = DateTimeUtil.addMonth(this.yearMonth, -1);
            this.monthClick(month);
        },
        /**
         * 下一月点击事件
         * @param next
         */
        nextClick: function (next) {
            var month = DateTimeUtil.addMonth(this.yearMonth, 1);
            this.monthClick(month);
        },
        /**
         * 时间轴列表点击事件
         * @param 点击的时间轴列表元素包含的信息
         */
        timeAxisListClick: function (data) {
            var _this = this;
            AjaxUtil.sendAjaxRequest(_this.urls.queryForecastListByWeek, null, {
                ascriptionType: _this.ascriptionType,
                month: _this.yearMonth,
                reportTime:parseInt(data.key)-1
            }, function (json) {
                var dataList = json.data;
                _this.reportTip =  dataList[0].REPORT_TIP === '' ? '--' : dataList[0].REPORT_TIP;
                var records = [];
                for (var i = 0; i < dataList.length; i++) {
                    var data = dataList[i];
                    records.push({
                        key: data.REPORT_ID,
                        text: _this.getRecordText(data),
                        selected: false,
                        reportId: data.REPORT_ID,
                        ascriptionType: data.ASCRIPTION_TYPE,
                        reportBatch: data.REPORT_BATCH,
                        reportName: data.REPORT_NAME,
                        reportTime: data.REPORT_TIME,
                        reportRate: data.REPORT_RATE,
                        reportFrequency: data.REPORT_FREQUENCY,
                        reportType: data.REPORT_TYPE,
                        fileRecords: data.REPORT_TIP === '' ? '--' : data.REPORT_TIP,
                        remark: data.REMARK,
                        field1: data.FIELD1,
                        field2: data.FIELD2,
                        field3: data.FIELD3,
                        field4: data.FIELD4,
                        reportInscribe: data.REPORT_INSCRIBE,
                        state: data.STATE,
                        createTime: data.CREATE_TIME,
                        createDept: data.CREATE_DEPT,
                        createUser: data.CREATE_USER,
                        editTime: data.EDIT_TIME,
                        editUser: data.EDIT_USER,
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
                        text: this.getFileName(file.FILE_FULL_NAME, file.FILE_FORMAT_SIZE),
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
         * 获取记录文本
         * @param data 数据
         * @returns 记录文本
         */
        getRecordText: function (data) {
            if (data.STATE === 'UPLOAD') {
                return data.REPORT_NAME + '（' + data.CREATE_USER + '-已提交）';
            }
            return data.REPORT_NAME + '（' + data.CREATE_USER + '）';
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
        getFileName: function (fileName, fileFormatSize) {
            return fileName
            // + '（' + fileFormatSize + '）';
        },
        /**
         * 日期选择插件
         */
        startWdatePicker: function () {
            var _this = this;
            WdatePicker({
                // 回显数据的对象ID
                el: 'start-wdate-picker',
                // 时间格式
                dateFmt: 'yyyy-MM',
                // 是否显示清除按钮
                isShowClear: true,
                // 是否显示今天按钮
                isShowToday: false,
                // 只读
                readOnly: true,
                // 限制时间
                 maxDate:'%y-%M',
               // maxDate: '#F{$dp.$D(\'end-wdate-picker\')||\'%y-%M\'}',
                onpicked: function (dp) {
                    // 防止重复点击当月
                    var month = dp.cal.getNewDateStr();
                    if (month === _this.yearMonth) {
                        return;
                    }
                    _this.monthClick(month);
                },
                oncleared: function (dp) {
                    _this.yearMonth = '';
                }
            });
        },

        /**
         * 提交按钮点击
         */
        uploadClick: function () {
            var _this = this;
            if (_this.uploadLimit > 0) {
                AjaxUtil.sendAjaxRequest(_this.urls.queryStateNumber, null, {
                    ascriptionType: _this.ascriptionType,
                    reportTime: _this.record.createTime
                }, function (json) {
                    if (json.data.STATE_NUMBER >= _this.uploadLimit) {
                        DialogUtil.showTipDialog("今日已有记录提交，不能重复提交！");
                        return false;
                    }
                    _this.uploadReport();
                });
            } else {
                _this.uploadReport();
            }
        },
        /**
         * 提交报告
         */
        uploadReport: function () {
            var _this = this;
            DialogUtil.showConfirmDialog("提交选中的记录，提交成功后将不能编辑和删除，请确认！", function () {
                AjaxUtil.sendAjaxRequest(_this.urls.updateReportState, null, {
                    reportId: _this.record.reportId
                }, function (json) {
                    DialogUtil.showTipDialog("提交成功");
                    _this.$refs.record.refresh(_this.record.reportName + '（' + json.data.userName + '-已提交）');
                    _this.record.state = 'UPLOAD';
                });
            });
        },
        /**
         * 到添加页面
         */
        goAdd: function () {
            this.pageDialog = DialogUtil.showFullScreenDialog(this.urls.editAndAddUrl );
            $('body').css('overflow-y', 'hidden');
        },
        /**
         * 到编辑页面
         */
        goEdit: function () {
            var reportId = this.record.reportId;
            this.pageDialog = DialogUtil.showFullScreenDialog(this.urls.editAndAddUrl + '?reportId=' + reportId);
            $('body').css('overflow-y', 'hidden');
        },
        /**
         * 删除数据
         */
        deleteData: function () {
            var _this = this;
            DialogUtil.showDeleteDialog(null, function () {
                // 当前选中的会商
                var reportId = _this.record.reportId;
                AjaxUtil.sendAjaxRequest(_this.urls.deleteReportById, null, {
                    reportId: reportId,
                    ascriptionType: _this.ascriptionType,
                }, function (json) {
                    DialogUtil.showTipDialog("删除成功！", function () {
                        // 刷新页面
                        _this.monthClick();
                    }, function () {
                        _this.monthClick();
                    });
                });
            });
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
                this.monthClick();
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
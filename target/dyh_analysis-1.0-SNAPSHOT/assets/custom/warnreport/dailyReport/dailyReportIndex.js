
var vue = new Vue({
    el: '#main-container',
    data: {
        // 该功能调用的所有url列表
        urls: {
            // 根据月份，查询频率为日的时间轴列表（月份 可为空）
            queryDayTimeAxisListByMonth: ctx + '/analysis/report/generalReport/queryDayTimeAxisListByMonth.vm',
            exportDailyReport: ctx + '/warnreport/dailyReport/exportExcel.vm',
            exportStDailyReport:ctx + '/warnreport/dailyReport/exportStDailyReportExcel.vm',
            queryDayRecordListByReportTime:ctx + '/warnreport/dailyReport/queryDayRecordListByReportTime.vm',
            addWarnDailyReport:ctx + '/warnreport/dailyReport/addWarnDailyReport.vm',
            viewer: ctx + '/assets/components/pdfjs-2.0.943-dist/web/viewer.html',
            getFile:ctx + '/warnreport/dailyReport/getFile.vm',
        },
        // 归属类型
        ascriptionType: 'WARN_DAILY_REPORT',
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
        // 记录列表
        records: null,
        // 记录信息
        record: null,
        // 文件记录列表
        fileRecords: null,
        pdfUrl:'',
        // 没有数据的文本
        noDataText: null,
    },
    /**
     * 页面加载完后调用
     */
    mounted: function () {
        var _this = this;
        _this.monthClick();
        // 当页面改变的时候，动态改变弹出层的高度和宽度（添加和编辑页面打开时有效）
        $(window).on('resize', function () {
            if (_this.pageDialog) {
                _this.pageDialog.width($(window).width());
                _this.pageDialog.height($(window).height());
            }
        });
    },
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
            AjaxUtil.sendAjaxRequest(_this.urls.queryDayTimeAxisListByMonth, null, {
                ascriptionType: _this.ascriptionType,
                month: yearMonth
            }, function (json) {
                var dataList = json.data;
                var data = dataList[0];
                // 填报年份月份
                _this.yearMonth = data.REPORT_TIME.substring(0, 7);
                // 当传递的月份为空时，重新赋予最大月份的值
                if (yearMonth == null) {
                    _this.timeAxis.next.limit = _this.yearMonth;
                }
                var list = [];
                // 记录选中的索引
                var selectedIndex = -1;
                for (var i = 0; i < dataList.length; i++) {
                    data = dataList[i];
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
            AjaxUtil.sendAjaxRequest(_this.urls.queryDayRecordListByReportTime, null, {
                    reportTime: data.key,
                    ascriptionType: _this.ascriptionType
                }, function (json) {
                    if(json.data.length > 0){
                        var dataList = json.data;
                        var records = [];
                        for (var i = 0; i < dataList.length; i++) {
                            records.push({
                                key: dataList[i].REPORT_ID,
                                reportName: dataList[i].REPORT_NAME,
                                text: _this.getRecordText(dataList[i]),
                                selected: false
                            });
                        }
                        // 选中最新一次会商
                        records[records.length-1].selected = true;
                        _this.records = records;
                    }else{
                        _this.noData();
                    }
                }
            )
        },
        /**
         * 记录列表点击事件
         * @param record 点击的记录列表元素包含的信息
         *
         */
        recordClick: function (record) {
            var _this = this;
            AjaxUtil.sendAjaxRequest(_this.urls.getFile, null, {
                reportId: record.key
            }, function (json) {
                var data = json.data;
                var recordTemp = {
                    pkid: data.REPORT_ID,
                    createTime: data.REPORT_TIME,
                    flowState: data.STATE,
                    reportName: data.REPORT_NAME,
                    importantHints: data.REPORT_TIP,
                    cityForecastAqiList: null
                }
                _this.record = recordTemp;

                _this.form3d = data.form3d;
                var fileRecords = [];
                if (_this.validateArray(data.fileList)) {
                    for (var i = 0; i < data.fileList.length; i++) {
                        var file = data.fileList[i];
                        fileRecords.push({
                            key: file.FILE_ID,
                            text: _this.getFileName(file.FILE_FULL_NAME, file.FILE_FORMAT_SIZE),
                            selected: false,
                            fileUrl: file.FILE_URL,
                            fileName: file.FILE_FULL_NAME,
                            fileType: file.FILE_TYPE
                        });
                    }
                    fileRecords[0].selected = true;
                    _this.fileRecords = fileRecords;
                } else {
                    _this.noFile();
                }
            });
        },
        /**
         * 文件记录列表点击事件
         * @param record 点击的文件记录列表元素包含的信息
         *
         */
        fileRecordClick: function (record) {
            var _this = this;
            _this.selectedFileId = record.key;
            // 获取pdf的URL
            _this.pdfUrl = _this.urls.viewer + '?file=' + record.fileUrl;
            // pdf
            /*AjaxUtil.sendAjaxRequest(_this.urls.getfile, null, {
                fileId: record.key
            }, function (json) {
                // 获取选中文件的ID
                _this.selectedFileId = record.key;
                // 获取pdf的URL
                _this.pdfUrl = _this.urls.viewer + '?file=' + record.fileUrl;
            }, function (json) {
                _this.selectedFileId = null;
                _this.pdfUrl = null;
                DialogUtil.showTipDialog(json.message);
            });*/
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
         * 没有数据
         */
        noData: function () {
            this.records = null;
            this.record = null;
            this.noDataText = '暂无数据！';
            // 没有文件
            this.noFile();
            this.form3d = null;
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
         * 日报excel导出
         */
        exportDailyReportFile:function(){
            let _this = this;
            let url = _this.urls.exportDailyReport;
            let params = {

            };
            FileDownloadUtil.createSubmitTempForm(url, params);
        },
        /**
         * 生态环境数据导出
         */
        exportStDailyReportFile:function(){
            let _this = this;
            let url = _this.urls.exportStDailyReport;
            let params = {

            };
            FileDownloadUtil.createSubmitTempForm(url, params);
        },
        /**
         * 到添加页面
         */
        goAdd: function () {
            this.pageDialog = DialogUtil.showFullScreenDialog(this.urls.addWarnDailyReport);
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
         * 日期选择插件
         */
        wdatePicker: function () {
            var _this = this;
            WdatePicker({
                // 回显数据的对象ID
                el: 'wdate-picker',
                // 时间格式
                dateFmt: 'yyyy-MM',
                // 是否显示清除按钮
                isShowClear: false,
                // 是否显示今天按钮
                isShowToday: false,
                // 只读
                readOnly: true,
                // 限制最大时间
                maxDate: '%y-%M',
                onpicked: function (dp) {
                    // 防止重复点击当月
                    var yearMonth = dp.cal.getNewDateStr();
                    if (yearMonth === _this.yearMonth) {
                        return;
                    }
                    _this.monthClick(yearMonth);
                    _this.yearMonth = yearMonth;
                }
            });
        },
        /**
         * 关闭页面弹框
         *
         * @param {boolean}
 *            isRefresh 是否刷新
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
         * 验证数组是否为空
         *
         * @param {Array}
         *            array 需要验证的数组
         * @returns 是否为空。True：为空，False：不为空
         */
        validateArray: function (array) {
            return array != null && array.length > 0;
        },
        /**
         * 获取文件名称
         *
         * @param fileName
         *            文件名称
         * @param fileFormatSize
         *            文件格式化后的大小
         * @returns string
         */
        getFileName: function (fileName, fileFormatSize) {
            if (fileFormatSize) {
                return fileName + '（' + fileFormatSize + '）';
            } else {
                return fileName;
            }
        },

    }
});





/** 月趋势-列表逻辑js **/
var vue = new Vue({
    el: '#main-container',
    data: {
        // 该功能调用的所有url列表
        urls: {
            // 根据月份，查询频率为日的时间轴列表（月份 可为空）
            queryMonthTimeAxisListByYear: ctx + '/analysis/report/generalReport/queryMonthTimeAxisListByYear.vm',
            // 根据报告时间查询频率为日的记录列表
            queryMonthRecordListByReportTime: ctx + '/analysis/report/generalReport/queryMonthRecordListByReportTime.vm',
            //查询时间模块独立
            monthlyRecordList: ctx + '/analysis/forecastflow/monthtrend/monthlyRecordList.vm',
            // 根据报告ID，查询城市预报信息
            queryMonthForecastByReportId: ctx + '/analysis/forecastflow/monthtrend/queryMonthForecastByReportId.vm',
            // 添加页面
            cityForecastAdd: ctx + '/analysis/forecastflow/monthtrend/trendEditOrAdd.vm',
            // 编辑页面
            cityForecastEdit: ctx + '/analysis/forecastflow/monthtrend/trendEditOrAdd.vm',
            // 删除
            deleteReportById: ctx + '/analysis/forecastflow/monthtrend/deleteForecastById.vm',
            // 查询文件是否存在
            queryFile: ctx + '/system/file/file/queryFile.vm',
            // pdf查看页面
            viewer: ctx + '/assets/components/pdfjs-2.0.943-dist/web/viewer.html',
            // 报告是否有提交记录
            queryStateNumber: ctx + '/analysis/report/generalReport/queryStateNumber.vm',
            // 修改报告状态
            updateReportState: ctx + '/analysis/report/generalReport/updateReportState.vm',
            //导出
            exportExcel: ctx + '/analysis/forecastflow/monthtrend/exportExcel.vm'
        },
        // 归属类型
        ascriptionType: 'MONTH_FORECAST',
        // 填报年份
        year: null,
        // 时间轴
        timeAxis: {
            prev: {
                limit: '',
                title: '上一年',
                isShow: true
            },
            next: {
                limit: '',
                title: '下一年',
                isShow: true
            },
            list: null
        },
        //上一月
        lastMonthData: {
            list:[],
            date:''
        },
        //预报时间
        reportTime: '',
        // 记录列表
        records: null,
        // 提交记录数限制，不做限制，则为-1
        uploadLimit: -1,
        // 记录信息
        record: {
            cityForecastAqiList: [],
            createTime:""
        },
        // 文件记录列表
        fileRecords: null,
        // 选中的文件ID
        selectedFileId: null,
        // pdf的URL
        pdfUrl: null,
        // 没有预报数据的文本
        noForecastDataText: null,
        //没有上月数据的文本
        noLastMonthDataText: null,
        // 页面的dialog
        pageDialog: null
    },
    /**
     * 页面加载完后执行
     */
    mounted: function () {
        var _this = this;
        _this.yearClick();
        // 当页面改变的时候，动态改变弹出层的高度和宽度（添加和编辑页面打开时有效）
        $(window).on('resize', function() {
            if (_this.pageDialog) {
                _this.pageDialog.width($(window).width());
                _this.pageDialog.height($(window).height());
            }
        });
    },
    /**
     * 计算属性
     * */
    computed: {
        /**
         * 上月大气日历表
         * */
        calTabList: function(){
            var _this = this;
            var list = _this.lastMonthData.list;
            var dates = _this.getMonthDay(_this.lastMonthData.date);
            let colors=["white",'#01E901', '#FFFF01', '#FFA501', '#FF0101', '#810181', '#800101'];
            var j = 0;
            var  dateLen = dates[1];
            var rowList = [];
            //列索引
            var colIndex = dates[0];
            //行索引
            var rowIndex = 0;
            if(list.length == 0){
                return null;
            }

            rowList[0] = new Array();
            for(let i = 0;i<colIndex;i++){
                var tdObj = {};
                tdObj["style"] = {
                    "background-color" : colors[0]
                };
                rowList[0][i] = tdObj;
            }
            for(var i = 1 ;i <= dateLen; i++ ){
                if((dates[0] + i) % 7 == 0){
                    rowList[(dates[0] + i) / 7] = new Array();
                }
                var tdObj = {};
                tdObj["dateTime"] = list[0].month + " 月 " + i + " 日";
                //如果该日存在数据
                if(j < list.length && list[j].day == i){
                    tdObj["style"] = {
                        "background-color": colors[(!isNaN(list[j].codeAqiLevel) ? parseInt(list[j].codeAqiLevel) : 0)]
                    };
                    tdObj["aqi"] = list[j].aqi != null ? list[j].aqi : "";
                    tdObj["primaryPollutant"] = list[j].primaryPollutant != null ? _this.getPrimPolluteHtml(list[j].primaryPollutant) : "";
                    j++;
                }else{
                    tdObj["style"] = {
                        "background-color" : colors[0]
                    };
                }
                //修改值
                rowList[rowIndex][colIndex] = tdObj;
                //更新坐标
                colIndex = (colIndex + 1) % 7;
                rowIndex = parseInt((dates[0] + i)/7);
            }
            return rowList;
        },
        /**
         * 当前月填色图数据列表
         * */
        clrTabList: function(){
            var _this = this;
            var list = _this.record.cityForecastAqiList;
            var forecastDataList = [];
            var dayNum = _this.getMonthDay(_this.record.createTime)[1];
            let colors=["white",'#01E901', '#FFFF01', '#FFA501', '#FF0101', '#810181', '#800101'];
            //数据为空
            if(list.length == 0){
                return null;
            }

            //处理月预报列表
            var n =0;
            for(var i= 0; i<list.length;i++){
                if("" != list[i].RESULT_TIME1 && null != list[i].RESULT_TIME1){
                    var obj = new Object();
                    obj.RESULT_TIME =list[i].RESULT_TIME1;
                    obj.LEVEL1 = list[i].LEVEL1;
                    obj.LEVEL2 = list[i].LEVEL2;
                    forecastDataList[n] = obj;
                    n++;
                }
                if("" != list[i].RESULT_TIME2 && null != list[i].RESULT_TIME2){
                    var obj = new Object();
                    obj.RESULT_TIME =list[i].RESULT_TIME2;
                    obj.LEVEL1 = list[i].LEVEL3;
                    obj.LEVEL2 = list[i].LEVEL4;
                    forecastDataList[n] = obj;
                    n++;
                }
                if("" != list[i].RESULT_TIME3 && null != list[i].RESULT_TIME3){
                    var obj = new Object();
                    obj.RESULT_TIME =list[i].RESULT_TIME3;
                    obj.LEVEL1 = list[i].LEVEL5;
                    obj.LEVEL2 = list[i].LEVEL6;
                    forecastDataList[n] = obj;
                    n++;
                }
            }
            //按照日期升序
            forecastDataList.sort(function(a,b){
                return new Date(a.RESULT_TIME).getDate() - new Date(b.RESULT_TIME).getDate();
            });
            var colIndex = 0;
            var rowIndex = 0;
            var index = 0; //月预报数据集 索引
            var rowList =[];
            for(var i =0 ;i<3;i++){
                rowList[i] = new Array();
            }

            //填入颜色和数据
            for(var i = 1 ;i <= dayNum ; i ++){
                var dayObj ={};
                dayObj["tdDay"] = i + "日";
                if(index < forecastDataList.length){
                    //如果有当日的数据就渲染上去
                    if(i == new Date(forecastDataList[index].RESULT_TIME).getDate()){
                        var c1 = 0;	//背景色默认白色
                        var c2 = 0;
                        if(forecastDataList[index].LEVEL1 == "优") {c1 = 1;}
                        if(forecastDataList[index].LEVEL1 == "良") {c1 = 2;}
                        if(forecastDataList[index].LEVEL1 == "轻度污染") {c1 = 3;}
                        if(forecastDataList[index].LEVEL1 == "中度污染") {c1 = 4;}
                        if(forecastDataList[index].LEVEL1 == "重度污染") {c1 = 5;}
                        if(forecastDataList[index].LEVEL2 == "优") {c2 = 1;}
                        if(forecastDataList[index].LEVEL2 == "良") {c2 = 2;}
                        if(forecastDataList[index].LEVEL2 == "轻度污染") {c2 = 3;}
                        if(forecastDataList[index].LEVEL2 == "中度污染") {c2 = 4;}
                        if(forecastDataList[index].LEVEL2 == "重度污染") {c2 = 5;}
                        dayObj["style"] = {
                            "background-image" : "linear-gradient(to right,"+ colors[c1] + "," + colors[c2]
                        };
                        index++;
                    }
                }
                rowList[rowIndex][colIndex] = dayObj;
                //更新索引
                if(i == 30 && dayNum == 31){
                    colIndex ++;
                    continue;
                }
                colIndex = i % 10;
                if(i % 10 == 0) {
                    rowIndex ++;
                }
            }
            return  rowList;
        }
    },
    /**
     * 所有方法
     */
    methods: {
        /**
         * 年份点击
         * @param year 年份
         */
        yearClick: function (year) {
            var _this = this;
            _this.noForecastDataText=null;
            _this.noLastMonthDataText=null;
            // 防止重复点击
            if (year != null && year === _this.year) {
                return;
            }

            AjaxUtil.sendAjaxRequest(_this.urls.queryMonthTimeAxisListByYear, null, {
                ascriptionType: _this.ascriptionType,
                year: year
            }, function (json) {
                var dataList = json.data;
                var data = dataList[0];
                // 填报年份
                _this.year = data.REPORT_TIME.substring(0, 4);
                // 当传递的月份为空时，重新赋予最大月份的值
                if (year == null) {
                    _this.timeAxis.next.limit = _this.year;
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
                    _this.noForecastDataText = null;
                    _this.noLastMonthDataText = null;
                } else {
                    _this.noForecastData();
                    _this.noLastMonthData();
                }

                // 给时间轴赋值
                _this.timeAxis.list = list;
                _this.$nextTick(function () {
                    $('.time-axis li').width(50);
                });
            });
        },
        /**
         * 上一年点击事件
         * @param prev 上一月按钮包含的数据
         */
        prevClick: function (prev) {
            var year = DateTimeUtil.addYear(this.year, -1);
            this.yearClick(year);
        },
        /**
         * 下一月点击事件
         * @param next 下一月按钮包含的数据
         */
        nextClick: function (next) {
            var year = DateTimeUtil.addYear(this.year, 1);
            this.yearClick(year);
        },
        /**
         * 时间轴列表点击事件
         * @param 点击的时间轴列表元素包含的信息
         */
        timeAxisListClick: function (data) {
            var _this = this;
            _this.noForecastDataText=null;
            _this.noLastMonthDataText=null;
            AjaxUtil.sendAjaxRequest(_this.urls.queryMonthRecordListByReportTime, null, {
                reportTime: data.key,
                ascriptionType: _this.ascriptionType
            }, function (json) {
                var dataList = json.data;
                var records = [];
                for (var i = 0; i < dataList.length; i++) {
                    records.push({
                        key: dataList[i].REPORT_ID,
                        text: _this.getRecordText(dataList[i]),
                        selected: false
                    });
                }
                // 选中最新一次会商
                records[records.length - 1].selected = true;
                _this.records = records;
                $('.time-axis li').width(50);
            },function (error) {
                //DialogUtil.showTipDialog(error.message);
                _this.noForecastData();
            });

            AjaxUtil.sendAjaxRequest(_this.urls.monthlyRecordList, null, {
                reportTime: data.key,
                ascriptionType: _this.ascriptionType
            }, function (json) {
                _this.lastMonthData.date = json.data.date;
                _this.lastMonthData.list = json.data.aqiMonthList;
            });
        },

        /**
         * 获取上月天数和1号为周几
         * @param dateStr 日期字符串:yyyy年mm月  yyyy-mm
         * @return arr 返回结果集
         */
        getMonthDay : function(dateStr){
            if(dateStr.indexOf("年") > 0){
                dateStr = dateStr.replace("年","-").replace("月","")
            }
            let date = dateStr.split("-");
            var firstDay = new Date(date[0],date[1] - 1, 1).getDay();
            var dayNum = new Date(date[0],date[1],0).getDate();
            var  arr = new Array(firstDay,dayNum);
            return arr;
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
            var _this = this;
            AjaxUtil.sendAjaxRequest(_this.urls.queryMonthForecastByReportId, null, {
                reportId: record.key
            }, function (json) {
                var data = json.data;
                _this.record = {
                    cityForecastAqiList: data.CITY_FORECAST_AQI_LIST,
                    pkid: data.REPORT_ID,
                    createTime: data.REPORT_TIME,
                    flowState: data.STATE,
                    reportName: data.REPORT_NAME,
                    importantHints: data.REPORT_TIP
                }

                var dates = _this.getMonthDay(_this.lastMonthData.date);
                //渲染填色图数据
                // _this.showColorTabData(dates[1]);

                var date2 =  new Date(data.REPORT_TIME);
                _this.reportTime = date2.getFullYear() + "年" + (date2.getMonth() + 1) + "月";

                var fileRecords = [];
                if (_this.validateArray(data.fileList)) {
                    for (var i = 0; i < data.fileList.length; i++) {
                        var file = data.fileList[i];
                        fileRecords.push({
                            key: file.FILE_ID,
                            text: _this.getFileName(file.FILE_FULL_NAME, file.FILE_SIZE),
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
         * 没有预报数据
         */
        noForecastData: function () {
            this.records = null;
            this.record = null;
            this.noForecastDataText = '暂无数据！';
            // 没有文件
            this.noFile();
        },
        /**
         * 没有上月质量数据
         * */
        noLastMonthData: function(){
            this.lastMonthData.list=[];
            this.lastMonthData.date='';
            this.noLastMonthDataText = "暂无数据";
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
         * @param fileSize 文件大小（字节数）
         * @returns 文件名称
         */
        getFileName: function (fileName, fileSize) {
            //四舍五入保留两位小数
            return fileName + '（' + Math.round(fileSize/1024.0 *100)/100 + 'KB）';
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
                dateFmt: 'yyyy',
                // 是否显示清除按钮
                isShowClear: false,
                // 是否显示今天按钮
                isShowToday: false,
                // 只读
                readOnly: true,
                // 限制最大时间
                maxDate:'%y-%M',
                onpicked: function(dp) {
                    // 防止重复点击当月
                    var year = dp.cal.getNewDateStr();
                    if (year === _this.year) {
                        return;
                    }
                    _this.yearClick(year);
                    _this.year = year;
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
                    reportId: _this.record.pkid
                }, function (json) {
                    DialogUtil.showTipDialog("提交成功");
                    _this.$refs.record.refresh(_this.record.reportName + '（' + json.data.userName + '-已提交）');
                });
            });
        },
        /**
         * 到添加页面
         */
        goAdd: function () {
            this.pageDialog = DialogUtil.showFullScreenDialog(this.urls.cityForecastAdd);
            $('body').css('overflow-y', 'hidden');
        },
        /**
         * 到编辑页面
         */
        goEdit: function () {
            var reportId = this.record.pkid;
            this.pageDialog = DialogUtil.showFullScreenDialog(this.urls.cityForecastEdit + '?reportId=' + reportId);
            $('body').css('overflow-y', 'hidden');
        },
        /**
         * 删除数据
         */
        deleteData: function () {
            var _this = this;
            DialogUtil.showDeleteDialog(null, function () {
                // 当前选中的会商
                var reportId = _this.record.pkid;
                AjaxUtil.sendAjaxRequest(_this.urls.deleteReportById, null, {
                    reportId: reportId
                }, function (json) {
                    DialogUtil.showTipDialog("删除成功！", function () {
                        // 刷新页面
                        _this.yearClick();
                    }, function () {
                        _this.yearClick();
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
                this.yearClick();
            }
        },
        /**
         * 获取首要污染物的Html格式
         */
        getPrimPolluteHtml: function (primPollute) {
            if (!primPollute || primPollute === '') {
                return '--';
            }
            return primPollute.replace(/PM2.5/g, 'PM<sub>2.5</sub>')
                .replace(/PM10/g, 'PM<sub>10</sub>')
                .replace(/O3/g, 'O<sub>3</sub>')
                .replace(/SO2/g, 'SO<sub>2</sub>')
                .replace(/NO2/g, 'NO<sub>2</sub>');
        },
        exportExcel: function () {
            let _this = this;
            let url = _this.urls.exportExcel;
            var reportId = _this.record.pkid;
            let params = {
                reportId:reportId,
                reportTime:_this.reportTime,
            };
            FileDownloadUtil.createSubmitTempForm(url, params);

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
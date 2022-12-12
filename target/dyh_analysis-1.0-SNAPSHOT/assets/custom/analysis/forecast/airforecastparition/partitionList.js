var cdRegionJson = [{name: '锦江区', code: '510104000000', location: [104.090989, 30.617689]},
    {name: '青羊区', code: '510105000000', location: [103.923499, 30.705406]},
    {name: '金牛区', code: '510106000000', location: [104.012236, 30.735359]},
    {name: '武侯区', code: '510107000000', location: [103.97039, 30.641982]},
    {name: '成华区', code: '510108000000', location: [104.111255, 30.715122]},
    {name: '高新区', code: '510109000000', location: [104.020637, 30.592008]},
    {name: '龙泉驿区', code: '510112000000', location: [104.280632, 30.615507]},
    {name: '青白江区', code: '510113000000', location: [104.300877, 30.823681]},
    {name: '新都区', code: '510114000000', location: [104.138705, 30.843499]},
    {name: '温江区', code: '510115000000', location: [103.786646, 30.742203]},
    {name: '天府新区', code: '510116000000', location: [104.094786, 30.421692]},
    {name: '金堂县', code: '510121000000', location: [104.602005, 30.742017]},
    {name: '双流区', code: '510122000000', location: [103.933863, 30.545199]},
    {name: '郫都区', code: '510124000000', location: [103.85789, 30.858575]},
    {name: '大邑县', code: '510129000000', location: [103.381875, 30.652269]},
    {name: '蒲江县', code: '510131000000', location: [103.486498, 30.276789]},
    {name: '新津区', code: '510132000000', location: [103.791345, 30.420222]},
    {name: '都江堰市', code: '510181000000', location: [103.621912, 31.008435]},
    {name: '彭州市', code: '510182000000', location: [103.868013, 31.140165]},
    {name: '邛崃市', code: '510183000000', location: [103.384156, 30.430275]},
    {name: '崇州市', code: '510184000000', location: [103.583001, 30.740122]},
    {name: '简阳市', code: '512081000000', location: [104.526773, 30.430754]}];

/** 重污染会商-列表逻辑js * */
var vue = new Vue({
    el: '#main-container',
    data: {
        // 该功能调用的所有url列表
        urls: {
            // 根据月份，查询频率为日的时间轴列表（月份 可为空）
            queryDayTimeAxisListByMonth: ctx + '/analysis/report/generalReport/queryDayTimeAxisListByMonth.vm',
            // 根据报告时间查询频率为日的记录列表
            queryDayRecordListByReportTime: ctx + '/analysis/report/generalReport/queryDayRecordListByReportTime.vm',
            // 根据报告ID，查询城市预报信息
            queryPartitionForecastByReportId: ctx + '/analysis/air/partition/queryPartitionForecastByReportId.vm',
            // 添加页面
            cityForecastAdd: ctx + '/analysis/air/partition/partitionEditOrAdd.vm',
            // 编辑页面
            cityForecastEdit: ctx + '/analysis/air/partition/partitionEditOrAdd.vm',
            // 删除
            deleteReportById: ctx + '/analysis/air/partition/deleteForecastById.vm',
            // 查询文件是否存在
            queryFile: ctx + '/system/file/file/queryFile.vm',
            // pdf查看页面
            viewer: ctx + '/assets/components/pdfjs-2.0.943-dist/web/viewer.html',
            // 报告是否有提交记录
            queryStateNumber: ctx + '/analysis/report/generalReport/queryStateNumber.vm',
            // 修改报告状态
            updateReportState: ctx + '/analysis/air/partition/updateForecastState.vm',
            //分区预报填色表url
            partitionColrPicUrl: ctx + '/analysis/air/partition/partitionForecastColorPic.vm',
        },
        // 归属类型
        ascriptionType: 'PARTITION_FORECAST',
        // 填报年份月份（会商年份月份）
        yearMonth: null,
        // 时间轴
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
        // 压缩包zip的url
        zipFileId: null,
        // 没有数据的文本
        noDataText: null,
        // 页面的dialog
        pageDialog: null,
        form3d: [{}],
        ybdList: [{select: "checked", value: 1}, {select: "", value: 2}, {select: "", value: 3}],
        day: 1,
        myChart: {},
        //是否隐藏
        isHidden:window.isHidden == 1

        // form24h:[{}],
    },
    /**
     * 页面加载完后执行
     */
    mounted: function () {
        var _this = this;
        $(window).on('resize', function () {
            var width = $("#mainContainer1").width()
            var height = width * 0.6;
            $("#cdMap").css("width", width);
            $("#cdMap").css("height", height);
            _this.getMapEchartData();
        })
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
        stepTo(num) {
            this.day = num;
            for (let i = 0; i < this.ybdList.length; i++) {
                if (num == this.ybdList[i].value) {
                    this.ybdList[i].select = "checked";
                } else {
                    this.ybdList[i].select = "";
                }
            }
            this.getMapEchartData();
        },
        /**
         * 上一月点击事件
         *
         * @param prev
         *            上一月按钮包含的数据
         */
        prevClick: function (prev) {
            var month = DateTimeUtil.addMonth(this.yearMonth, -1);
            this.monthClick(month);
        },
        /**
         * 下一月点击事件
         *
         * @param next
         *            下一月按钮包含的数据
         */
        nextClick: function (next) {
            var month = DateTimeUtil.addMonth(this.yearMonth, 1);
            this.monthClick(month);
        },
        /**
         * 时间轴列表点击事件
         *
         * @param 点击的时间轴列表元素包含的信息
         */
        timeAxisListClick: function (data) {
            var _this = this;
            _this.noDataText = null;
            AjaxUtil.sendAjaxRequest(_this.urls.queryDayRecordListByReportTime, null, {
                reportTime: data.key,
                ascriptionType: _this.ascriptionType
            }, function (json) {
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
                records[records.length - 1].selected = true;
                _this.records = records;
                //如果选择填色图，则返回列表页面
                if (document.getElementById('picId').getAttribute("class")=='active'){
                    document.getElementById('tableId').classList.add("active");
                    document.getElementById('data-table').classList.add("in");
                    document.getElementById('data-table').classList.add("active");
                    //移除填色图
                    document.getElementById('picId').classList.remove("active");
                    document.getElementById('color-pic').classList.remove("in");
                    document.getElementById('color-pic').classList.remove("active");
                }
            },function(error){
                DialogUtil.showTipDialog(error.message);
                _this.noData();
                if (document.getElementById('picId').getAttribute("class")=='active'){
                    document.getElementById('tableId').classList.add("active");
                    document.getElementById('data-table').classList.add("in");
                    document.getElementById('data-table').classList.add("active");
                    //移除填色图
                    document.getElementById('picId').classList.remove("active");
                    document.getElementById('color-pic').classList.remove("in");
                    document.getElementById('color-pic').classList.remove("active");
                }
            });
        },
        /**
         * 获取记录文本
         *
         * @param data
         *            数据
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
         *
         * @param record
         *            点击的记录列表元素包含的信息
         */
        recordClick: function (record) {
            var _this = this;
            AjaxUtil.sendAjaxRequest(_this.urls.queryPartitionForecastByReportId, null, {
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
                if (data.zipFileInfo.length > 0) {
                    _this.zipFileId = data.zipFileInfo[0].FILE_ID;
                }
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
         * 地图的数据拼装
         */
        getMapEchartData: function () {
            let _this = this;
            let start = "AQI_START" + _this.day;
            let end = "AQI_END" + _this.day;
            var dataList = [];
            if (_this.form3d != null && _this.form3d.length > 0) {
                for (let i = 0; i < _this.form3d.length; i++) {
                    var temp = {};
                    temp.name = _this.form3d[i].REGIONNAME;
                    temp.code = _this.form3d[i].REGIONCODE;
                    temp.value = (parseInt(_this.form3d[i][start]) + parseInt(_this.form3d[i][end])) / 2;
                    temp.valueStart = _this.form3d[i][start];
                    temp.valueEnd = _this.form3d[i][end];
                    temp.itemStyle = {normal: '#D3D3D3'};
                    //temp.label={textStyle:{fontSize:17}};
                    dataList.push(temp);
                }
                let fd = '';
                if (_this.day == 1) {
                    fd = _this.form3d[0].FORECAST_DATE1;

                } else if (_this.day == 2) {
                    fd = _this.form3d[0].FORECAST_DATE2;
                } else if (_this.day == 3) {
                    fd = _this.form3d[0].FORECAST_DATE3;
                }
                let foreCastDate = fd.substring(0, 4) + '年' + parseInt(fd.substring(5, 7)) + '月' + parseInt(fd.substring(8, 10)) + '日';
                _this.getMapEchartsInit(dataList, foreCastDate);
            }else{
                _this.myChart.dispose();
                _this.getMapEchartsInit(dataList, '');
            }
        },


        /**
         * 地图展示
         */
        getMapEchartsInit: function (dataList, foreCastDate) {
            initMap(); //加载地图
            var myChart = echarts.init(document.getElementById("cdMap"));
            var option = {
                color: ['#01E901', '#FFFF01', '#FFA501', '#FF0101', '#810181', '#800101'],
                title:[ {
                    top: '70',
                    left: '60%',
                    text: foreCastDate,
                    textStyle:{
                        fontSize:20
                    },
                    show: true
                },{
                    top:'bottom',
                    left: 'center',
                    text: '成都市区（市）县未来3天空气质量预报',
                    textStyle:{
                        fontSize:28
                    },
                    show: true
                }],
                tooltip: {
                    show: true,
                    formatter(params) {
                        if (params.seriesName != '232') {
                            return params.data.name + 'AQI预报值：' + params.data.valueStart + "~" + params.data.valueEnd + "</br>" +
                                "AQI预报中值：" + (parseInt(params.data.valueEnd) + parseInt(params.data.valueStart)) / 2;
                        }
                    }
                },
                toolbox: {
                    right:50,
                    feature: {
                        saveAsImage: {}
                    }
                },
                legend: {
                    selectedMode: false,
                    orient: 'vertical',
                    left: '60%',
                    top: 100,
                    textStyle: {
                        color: '#000',
                        fontSize: '16'
                    },
                    data: ['优：0-50', '良：50-100', '轻度污染：100-150', '中度污染：150-200', '重度污染：200-300', '严重污染：300以上'],
                    show: true
                },
                geo: {
                    map: 'cd',
                    roam: false, //不开启缩放和平移
                    zoom: 1.23, //视角缩放比例
                    label: {
                        normal: {
                            show: true,
                            fontSize: '16',
                            color: 'rgba(5,0,0,0.7)'
                        }
                    },
                    itemStyle: {
                        normal: {
                            borderColor: 'rgba(0, 0, 0, 0.2)'
                        },
                        emphasis: {
                            areaColor: '#696969',//鼠标选择区域颜色
                            shadowOffsetX: 0,
                            shadowOffsetY: 0,
                            shadowBlur: 20,
                            borderWidth: 0,
                            shadowColor: 'rgba(0, 0, 0, 0.5)'
                        }
                    }
                },
                series: [
                    {
                        name: '分区预报',
                        type: 'map',
                        geoIndex: 0,
                        data: dataList,
                    }
                ]
            };
            //第一次加载
            myChart.setOption(option);
            //加载完地图后第二次加载
            myChart.setOption({
                series: [{
                    name: '信息量',
                    type: 'map',
                    geoIndex: 0,
                    data: dataList,
                },
                    {
                        hoverAnimation: false,
                        avoidLabelOverlap: false,
                        coordinateSystem: 'map',
                        label: {
                            normal: {
                                show: false
                            }
                        },
                        data: [
                            {value: 0, name: '优：0-50'},
                            {value: 0, name: '良：50-100'},
                            {value: 0, name: '轻度污染：100-150'},
                            {value: 0, name: '中度污染：150-200'},
                            {value: 0, name: '重度污染：200-300'},
                            {value: 0, name: '严重污染：300以上'}
                        ],
                        name: '232',
                        radius: '0px',
                        type: 'pie',

                    }],
                graphic:
                    this.initMapEcharts(myChart, dataList)
            });
            this.myChart = myChart;
        },
        /*
         * 初始化地图后，第二次加载的拼接
         */
        initMapEcharts: function (eChart, dataList) {
            var graphic = [];
            for (let i = 0; i < cdRegionJson.length; i++) {
                for (let j = 0; j < dataList.length; j++) {
                    if (dataList[j].name == cdRegionJson[i].name) {

                        var center = eChart.convertToPixel({
                            seriesIndex: 0
                        }, [cdRegionJson[i].location[0],30.707 + (cdRegionJson[i].location[1] - 30.707) * 0.866]);
                        //地图上的echarts饼图
                        let tempAfter = {
                            type: 'text',
                            left: center[0] - 20,
                            top: center[1] + 2,
                            z: 200,
                            style: {
                                text: dataList[j].valueStart,
                            },
                        }
                        graphic.push(tempAfter);
                        let temp = {
                            type: 'rect',
                            left: center[0],
                            top: center[1],
                            z: 100,
                            shape: {
                                width: 30,
                                height: 15
                            },
                            style: {
                                fill: this.mapEchartsData(dataList[j], '')
                            },

                        }
                        graphic.push(temp);
                        let tempBefore = {
                            type: 'text',
                            left: center[0] + 35,
                            top: center[1] + 2,
                            z: 200,
                            style: {
                                text: dataList[j].valueEnd,
                            },
                        }
                        graphic.push(tempBefore);
                    }
                }
            }
            return graphic;
        },
        /**
         * 判断地图上的echarts数据是一个还是两个
         */
        mapEchartsData: function (dataList, type) {
            var offset1 = "";
            var offset2 = "";
            if (this.cheakLevel(dataList.valueStart) == this.cheakLevel(dataList.valueEnd)) {
                if (this.cheakLevel(dataList.valueStart) == 1) {
                    offset1 = "#01E901";
                    offset2 = "#01E901";
                } else if (this.cheakLevel(dataList.valueStart) == 2) {
                    offset1 = "#FFFF01";
                    offset2 = "#FFFF01";
                } else if (this.cheakLevel(dataList.valueStart) == 3) {
                    offset1 = "#FFA501";
                    offset2 = "#FFA501";
                } else if (this.cheakLevel(dataList.valueStart) == 4) {
                    offset1 = "#FF0101";
                    offset2 = "#FF0101";
                } else if (this.cheakLevel(dataList.valueStart) == 5) {
                    offset1 = "#810181";
                    offset2 = "#810181";
                } else if (this.cheakLevel(dataList.valueStart) == 6) {
                    offset1 = "#800101";
                    offset2 = "#800101";
                } else if (this.cheakLevel(dataList.valueStart) == 0) {
                    offset1 = "rgba(0, 0, 0, 0.5)";
                    offset2 = "rgba(0, 0, 0, 0.5)";
                }
            } else {
                if (this.cheakLevel(dataList.valueStart) == 1) {
                    offset1 = "#01E901";
                    offset2 = "#FFFF01";
                } else if (this.cheakLevel(dataList.valueStart) == 2) {
                    offset1 = "#FFFF01";
                    offset2 = "#FFA501";
                } else if (this.cheakLevel(dataList.valueStart) == 3) {
                    offset1 = "#FFA501";
                    offset2 = "#FF0101";
                } else if (this.cheakLevel(dataList.valueStart) == 4) {
                    offset1 = "#FF0101";
                    offset2 = "#800101";
                } else if (this.cheakLevel(dataList.valueStart) == 5) {
                    offset1 = "#800101";
                    offset2 = "#800101";
                }
            }
            var color = new echarts.graphic.LinearGradient(
                0, 0, 1, 0,
                [
                    {offset: 0, color: offset1},
                    {offset: 0.1, color: offset1},
                    {offset: 0.7, color: offset2},
                    {offset: 1, color: offset2}
                ]
            )

            return color;
        },
        /**
         * 根据值判断等级
         */
        cheakLevel: function (num) {

            let level = 0;
            if (300 < num) {
                level = 6;
            } else if (300 >= num && num > 200) {
                level = 5;
            } else if (200 >= num && num > 150) {
                level = 4;
            } else if (150 >= num && num > 100) {
                level = 3;
            } else if (100 >= num && num > 50) {
                level = 2;
            } else if (50 >= num && num > 0) {
                level = 1;
            } else {
                level = 0;
            }
            return level;
        },
        /**
         * 文件记录列表点击事件
         *
         * @param record
         *            点击的文件记录列表元素包含的信息
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
                DialogUtil.showTipDialog(json.message);
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
                    reportId: _this.record.pkid, FORECAST_TIME: _this.record.createTime
                }, function (json) {
                    DialogUtil.showTipDialog("提交成功");
                    for (let i = 0; i < _this.records.length; i++) {
                        _this.$refs.record.records[i].text = _this.records[i].reportName + '（' + json.data.userName + '-已提交）';

                    }
                    _this.$refs.record.refresh();

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
         * zip下载
         */
        downloadZipFile: function () {
            if (this.zipFileId) {
                // 下载zip文件
                FileDownloadUtil.downloadFile(this.zipFileId);
            }
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
         * 获取首要污染物的Html格式
         */
        getPrimPolluteHtml: function (primPollute) {
            if (!primPollute || primPollute === '') {
                return '--';
            }
            return primPollute.replace(/PM2.5/g, 'PM<sub>2.5</sub>').replace(/PM10/g, 'PM<sub>10</sub>').replace(/O3/g, 'O<sub>3</sub>').replace(/SO2/g, 'SO<sub>2</sub>').replace(/NO2/g, 'NO<sub>2</sub>');
        },
        /**
         * 切换窗口
         */
        switchingWindow: function () {
            setTimeout(function () {
                $(window).trigger("resize");
            }, 500);
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
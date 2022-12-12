var vue = new Vue({
    el: '#main-container',
    data: {
        //分页插件
        measureObj0: {
            pageNum: 1,
            pageSize: 20,
            list: []
        },
        measureObj12: {
            pageNum: 1,
            pageSize: 20,
            list: []
        },
        url: {
            getDayList: ctx + '/analysis/air/modelwqDayRow/getDayList.vm',
            getRegionAndPoint: ctx + '/analysis/air/modelwqDayRow/getRegionAndPoint.vm',
            getEchartsData: ctx + '/analysis/forecast/trend/getEchartsData.vm',
            exportExcel: ctx + '/analysis/forecast/trend/exportExcel.vm',
            getPagingData: ctx + '/analysis/forecast/trend/getPagingDataList.vm'
        },
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
            list: null,
            tempList: null,
        },
        table0: [],
        table12: [],
        code:'510100000000',
        name:'成都市',
        month: '',
        thisYMD: '',
        regionAndPointList: {},
        marquee: null,
        defaultDataType:'REGION'

    },
    /**
     * 页面加载完后调用
     */
    mounted: function () {
        // 注册表单验证
        $('#mainForm').validationEngine({
            // 屏幕自动滚动到第一个验证不通过的位置。必须设置，因为Toolbar position为Fixed
            scrollOffset: 98,
            // 提示框位置为下左
            promptPosition: 'bottomLeft',
            // 自动隐藏提示框
            autoHidePrompt: true,
            // 不可见字段验证
            validateNonVisibleFields: true
        });
        this.monthClick();
        this.getRegionAndPointData();
    },
    methods: {
        /**
         * 月份切换
         * @param month
         */
        monthClick: function (month) {
            var _this = this;
            AjaxUtil.sendAjaxRequest(_this.url.getDayList, null, {
                ascriptionType: _this.ascriptionType,
                month: month
            }, function (json) {
                var dataList = json.data;
                var data = dataList[0];
                // 填报月份
                _this.month = data.MODELTIME.substring(0, 7);
                // 当传递的月份为空时，重新赋予最大月份的值
                if (month == null) {
                    _this.timeAxis.next.limit = _this.month;
                }
                var list = [];
                // 记录选中的索引
                var selectedIndex = -1;
                for (var i = 0; i < dataList.length; i++) {
                    data = dataList[i];
                    // 是否禁用。True:禁用，False:不禁用
                    var disabled = data.IS_DISABLED != 'Y';
                    // 如果有数据，则将当日标记为选中，直到选中有数据的最后一天
                    if (data.IS_MAX_DATE == 'Y') {
                        selectedIndex = i;
                    }
                    list.push({
                        key: data.MODELTIME,
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
                    list[0].selected = true;
                    list[0].disabled = false;
                }
                // 给时间轴赋值
                _this.timeAxis.list = list;
            });
        },
        queryListByPointCode: function () {
            let _this = this;
            if (_this.code == '' || _this.code == null || _this.code == undefined) {
                _this.showMessageDialog("请选择一个行政区或者站点");
            }
            _this.getAllEchartsData();
            _this.getPagingDataList();
        },
        cge: function () {
            let _this = this;
            var sel = document.getElementById("sel");
            _this.marquee = sel[sel.selectedIndex].value;
        },
        /**
         *
         */
        getRegionAndPointData: function () {
            let _this = this;
            AjaxUtil.sendAjaxRequest(_this.url.getRegionAndPoint, null, {}, function (json) {
                _this.regionAndPointList = json.data;
            });
        },
        /**
         *时间日期切换
         * @param data
         */
        timeAxisListClick: function (data) {
            let _this = this;
            for (let i = 0; i < this.timeAxis.list.length; i++) {
                if (this.timeAxis.list[i].text == data.text) {
                    this.timeAxis.list[i].selected = true;
                } else {
                    this.timeAxis.list[i].selected = false;
                }
            }
            _this.thisYMD = data.key;
            _this.getAllEchartsData();
            _this.getPagingDataList()
        },
        //获取分页数据
        getPagingDataList: function () {
            var _this = this;
            AjaxUtil.sendAjaxRequest(_this.url.getPagingData, null, {
                    pageNum: _this.measureObj0.pageNum,
                    pageSize: _this.measureObj0.pageSize,
                    modelTime: _this.thisYMD,
                    pointCode: _this.code
                }, function (json) {
                    if(json.data.pagingData0.list.length <= 0 && json.data.pagingData12.list.length <= 0 ){
                        DialogUtil.showTipDialog("暂无数据！");
                    }
                    _this.measureObj0 = json.data.pagingData0;
                    _this.measureObj12 = json.data.pagingData12;
                }, function () {
                    DialogUtil.showTipDialog("暂无数据！", null);
                    _this.measureObj.list = [];
                }, null
            );
        },

        /**
         * 点击翻页时调用此方法
         */
        handlecurrentchange: function () {
            this.getPagingDataList();
        },

        /**
         * 选择行政区和点位
         */
        cheakRegionAndPoint: function () {
            var _this = this;
            $.dataChoose({
                title: '行政区或者站点',
                single: true,
                dataTypes: ['REGION', 'POINT'],
                dataTypeNames: ['行政区', '站点'],
                defaultDataType:  _this.defaultDataType,
                dataCodes: '',
                data: _this.regionAndPointList,
                callback: function (dataType, nodeArray) {
                    _this.defaultDataType = dataType;
                    _this.code = nodeArray[0].CODE;
                    _this.name = nodeArray[0].NAME;
                }
            });
        },
        exportExcel: function () {
            let _this = this;
            let url = _this.url.exportExcel;
            let params = {
                modelTime: _this.thisYMD,
                model: 'CDAQS_MT',
                pointCode: _this.code,
                excelName: "未来14天污染物浓度预报变化趋势.xlsx"
            };
            FileDownloadUtil.createSubmitTempForm(url, params);
        },

        /**
         * 查询所有echarts的数据
         */
        getAllEchartsData: function () {
            let _this = this;
            AjaxUtil.sendAjaxRequest(_this.url.getEchartsData, null, {
                modelTime: _this.thisYMD,
                pointCode: _this.code,
            }, function (json) {
                _this.table0 = json.data.hours0;
                _this.table12 = json.data.hours12;
                _this.splicingEchartsdata();
            });
        },

        /**
         *拼接echarts的数据
         */
        splicingEchartsdata: function () {
            let _this = this;
            var name = null;
            var table0 = _this.table0;
            var table12 = _this.table12;
            var value = this.marquee;
            let key = "trendLayer";
            let xdate = []; //x轴时间
            let ydate0 = [];//y轴0点数据
            let ydate12 = [];//y轴12点数据
            for (var i = 0; i < table0.length; i++) {
                xdate.push(table0[i].resultTime.substring(0, 16));
            }
            for (let i = 0; i < table0.length; i++) {
                if (value == "SO2") {
                    ydate0.push(table0[i].so2);
                } else if (value == "CO") {
                    ydate0.push(table0[i].co);
                } else if (value == "O3") {
                    ydate0.push(table0[i].o3);
                } else if (value == "PM10") {
                    ydate0.push(table0[i].pm10);
                } else if (value == "PM2.5") {
                    ydate0.push(table0[i].pm25);
                } else if (value == "VOCs") {
                    ydate0.push(table0[i].vocs);
                } else {
                    ydate0.push(table0[i].no2);
                }
            }
            if (xdate.length === 0) {
                for (var i = 0; i < table12.length; i++) {
                    xdate.push(table12[i].resultTime.substring(0, 16));
                }
            }
            for (let i = 0; i < table12.length; i++) {
                if (value == "SO2") {
                    ydate12.push(table12[i].so2);
                } else if (value == "CO") {
                    ydate12.push(table12[i].co);
                } else if (value == "O3") {
                    ydate12.push(table12[i].o3);
                } else if (value == "PM10") {
                    ydate12.push(table12[i].pm10);
                } else if (value == "PM2.5") {
                    ydate12.push(table12[i].pm25);
                } else if (value == "VOCs") {
                    ydate12.push(table12[i].vocs);
                } else {
                    ydate12.push(table12[i].no2);
                }
                if (value == null || value =="NO2") {
                    name = "NO₂( μg / m³ )";
                } else if (value == "SO2") {
                    name = "SO₂( μg / m³ )";
                } else if (value == "O3") {
                    name = "O₃( μg / m³ )";
                } else if (value == "PM10") {
                    name = "PM₁₀( μg / m³ )";
                } else if (value == "PM2.5") {
                    name = "PM₂.₅( μg / m³ )";
                } else if (value == "VOCs") {
                    name = "VOCs( μg / m³)";
                } else if (value == "CO") {
                    name = "CO(mg/m³)";
                }
            }
            _this.initEcharts(key, xdate, ydate0, ydate12, name);
        },
        /**
         * echarts初始化
         */
        initEcharts: function (id, xdate, ydate0, ydate12, name) {
            var option = {
                tooltip: {
                    trigger: 'axis'
                },
                legend: {
                    data: ['12时', '0时'],
                    right: 80,
                    top: '3%',
                    color: 'black'
                },
                grid: {
                    left: '3%',
                    right: '1%',
                    bottom: '3%',
                    containLabel: true
                },
                toolbox: {
                    right:20,
                    feature: {
                        saveAsImage: {}
                    }
                },
                xAxis: {
                    type: 'category',
                    boundaryGap: false,
                    axisLabel: {
                        rotate: 45,
                    },
                    data: xdate
                },
                yAxis: {
                    name: name,
                    type: 'value'
                },
                dataZoom: [
                    {
                        bottom: 5,//下滑块距离x轴底部的距离
                        height: 10,//下滑块手柄的高度调节
                        type: 'slider',//类型,滑动块插件
                        show: true,//是否显示下滑块
                        xAxisIndex: [0],//选择的x轴
                        start: 0, //初始数据显示多少
                        end: 10,    //初始数据最多显示多少
                        left: 50,

                    }
                ],
                series: [
                    {
                        color: "#ED7D31",
                        name: '0时',
                        type: 'line',
                        data: ydate0
                    },
                    {
                        color: "#4472C4",
                        name: '12时',
                        type: 'line',
                        data: ydate12
                    }
                ]
            };
            var myChart = echarts.init(document.getElementById(id));
            myChart.setOption(option);
        },
        /**
         * 上一月
         * @param prev
         */
        prevClick: function (prev) {
            var month = DateTimeUtil.addMonth(this.month, -1);
            this.monthClick(month);
        },
        /**
         * 下一月
         * @param next
         */
        nextClick: function (next) {
            var month = DateTimeUtil.addMonth(this.month, 1);
            this.monthClick(month);
        },


        /**
         * 时间处理
         * @param dateTime
         * @returns {string}
         */
        substringDate: function (dateTime) {
            return dateTime.substring(0, 13);
        },

        /**
         * 日期选择插件
         */
        wdatePicker: function () {
            var _this = this;
            WdatePicker({
                // 回显数据的对象ID
                el: 'txtDateStart',
                // 时间格式
                dateFmt: 'yyyy-MM',
                // 是否显示清除按钮
                isShowClear: false,
                // 只读
                readOnly: true,
                // 最大时间限制，参考：http://www.my97.net/demo/index.htm
                maxDate: '%y-%M',
                onpicked: function (dp) {
                    // 确认按钮点击事件
                    _this.monthClick(dp.cal.getNewDateStr());
                }
            });
        },
    }
});

var vue = new Vue({
    el: '#main-container',
    data: {
        url: {
            getDayList: ctx + '/analysis/air/modelwqDayRow/getDayList.vm',
            getRegionAndPoint: ctx + '/analysis/air/modelwqDayRow/getRegionAndPoint.vm',
            getEchartsData: ctx + '/analysis/air/fourteenDaysForecast/getEchartsData.vm',
            exportExcel: ctx + '/analysis/air/pollutionForecastCompare/exportExcel.vm',
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
        code: '510100000000',
        name: '成都市',
        /* pointCode:'',
         pointName:'',*/
        month: '',
        thisYMD: '',
        regionAndPointList: {},
        //默认点位类型
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
                    if (data.IS_DATA === 'Y') {
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
        query: function () {
            let _this = this;
            if (_this.code == '' || _this.code == null || _this.code == undefined) {
                _this.showMessageDialog("请选择一个行政区或者站点");
            }
            _this.getAllEchartsData();
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
         * 选择行政区和点位
         */
        cheakRegionAndPoint: function () {
            var _this = this;
            $.dataChoose({
                title: '行政区或者站点',
                single: true,
                dataTypes: ['REGION', 'POINT'],
                dataTypeNames: ['行政区', '站点'],
                isCheckParent: true, // 是否可选父节点
                isShowLeaf:false, //是否显示叶子节点
                defaultDataType: _this.defaultDataType,
                dataCodes: _this.code,
                data: _this.regionAndPointList,
                callback: function (dataType, nodeArray) {
                    if(nodeArray.length > 0){
                        _this.defaultDataType = dataType;
                        _this.code = nodeArray[0].CODE;
                        _this.name = nodeArray[0].NAME;
                    }
                    _this.query();
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
                excelName: "未来14天预报.xlsx"
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
                //pointCode: _this.pointCode,
            }, function (json) {
                if(json.data == null  || ( json.data.list12.length <= 0 && json.data.list0.length <= 0 )){
                    _this.showMessageDialog("暂无数据！");
                }
                _this.table12 = json.data.list12
                for (var i = 0; i < _this.table12.length; i++) {
                    var tableElement = _this.table12[i].primpollute;
                    if (tableElement == "PM2.5") {
                        _this.table12[i].primpollute = "PM₂.₅"
                    } else if (tableElement == "O3_8") {
                        _this.table12[i].primpollute = "O₃_8";
                    } else if (tableElement == "NO2") {
                        _this.table12[i].primpollute = "NO₂";
                    } else if (tableElement == "SO2") {
                        _this.table12[i].primpollute = "SO₂";
                    } else if (tableElement == "PM10") {
                        _this.table12[i].primpollute = "PM₁₀";
                    } else if (tableElement == "O3") {
                        _this.table12[i].primpollute = "O₃";
                    }
                }
                _this.table0 = json.data.list0;
                for (var i = 0; i < _this.table0.length; i++) {
                    var tableElement = _this.table0[i].primpollute;
                    if (tableElement == "PM2.5") {
                        _this.table0[i].primpollute = "PM₂.₅"
                    } else if (tableElement == "O3_8") {
                        _this.table0[i].primpollute = "O₃_8";
                    } else if (tableElement == "NO2") {
                        _this.table0[i].primpollute = "NO₂";
                    } else if (tableElement == "SO2") {
                        _this.table0[i].primpollute = "SO₂";
                    } else if (tableElement == "PM10") {
                        _this.table0[i].primpollute = "PM₁₀";
                    } else if (tableElement == "O3") {
                        _this.table0[i].primpollute = "O₃";
                    }
                }
                _this.splicingEchartsdata();
                _this.initEchartsAqi();
            });
        },
        /**
         *拼接echarts的数据
         */
        splicingEchartsdata: function () {
            var _this = this;
            var key = ["so2", "no2", "pm10", "co", "o3", "o38", "pm25"];
            var names = ["SO₂（μg/m³）", "NO₂（μg/m³）", "PM₁₀（μg/m³）", "CO（mg/m³）", "O₃（μg/m³）", "O₃_8（μg/m³）", "PM₂.₅（μg/m³）"];
            var list0 = _this.table0;
            var list12 = _this.table12;
            for (let j = 0; j < key.length; j++) {
                var ydate0 = [];
                var ydate12 = [];
                var xdate = [];
                var max = 0;
                for (let i = 0; i < list0.length; i++) {
                    ydate0.push(list0[i][key[j]]);
                    xdate.push(list0[i].resulttime.substring(0, 10));
                    max = max > parseFloat(list0[i][key[j]]) ? max : list0[i][key[j]];
                }
                for (let i = 0; i < list12.length; i++) {
                    ydate12.push(list12[i][key[j]]);
                    max = max > parseFloat(list12[i][key[j]]) ? max : list12[i][key[j]];
                    if (list0.length == 0) {
                        xdate.push(list12[i].resulttime.substring(0, 10));
                    }
                }
                _this.initEcharts(key[j], xdate, ydate0, ydate12, names[j], max * 1.2);
            }
        },
        primpolluteColor: function (primpollute) {
            var temp = {
                'background-color': '#fff'
            };
            if (primpollute == 'SO₂') {
                temp = {
                    'background-color': '#E1EA00'
                };
            } else if (primpollute == 'NO₂') {
                temp = {
                    'background-color': '#3549BD'
                };
            } else if (primpollute == 'PM₁₀') {
                temp = {
                    'background-color': '#C63500'
                };
            } else if (primpollute == 'CO') {
                temp = {
                    'background-color': '#DA70D6'
                };
            } else if (primpollute == 'O₃') {
                temp = {
                    'background-color': '#87CEFA'
                };
            } else if (primpollute == 'O₃_8') {
                temp = {
                    'background-color': '#87CEFA'
                };
            } else if (primpollute == 'PM₂.₅') {
                temp = {
                    'background-color': '#7F5000'
                };
            }
            return temp;
        },
        /**
         * 数据是一个还是两个
         */
        getTwoColor: function (min, max) {
            let _this = this;
            var offset1, offset2;
            if (_this.cheakLevel(min) == _this.cheakLevel(max)) {
                if (_this.cheakLevel(min) == 1) {
                    offset1 = "#01E901";
                    offset2 = "#01E901";
                } else if (_this.cheakLevel(min) == 2) {
                    offset1 = "#FFFF01";
                    offset2 = "#FFFF01";
                } else if (_this.cheakLevel(min) == 3) {
                    offset1 = "#FFA501";
                    offset2 = "#FFA501";
                } else if (_this.cheakLevel(min) == 4) {
                    offset1 = "#FF0101";
                    offset2 = "#FF0101";
                } else if (_this.cheakLevel(min) == 5) {
                    offset1 = "#810181";
                    offset2 = "#810181";
                } else if (_this.cheakLevel(min) == 6) {
                    offset1 = "#800101";
                    offset2 = "#800101";
                } else if (_this.cheakLevel(min) == 0) {
                    offset1 = "rgba(0, 0, 0, 0.5)";
                    offset2 = "rgba(0, 0, 0, 0.5)";
                }
            } else {
                if (_this.cheakLevel(min) == 1) {
                    offset1 = "#01E901";
                    offset2 = "#FFFF01";
                } else if (_this.cheakLevel(min) == 2) {
                    offset1 = "#FFFF01";
                    offset2 = "#FFA501";
                } else if (_this.cheakLevel(min) == 3) {
                    offset1 = "#FFA501";
                    offset2 = "#FF0101";
                } else if (_this.cheakLevel(min) == 4) {
                    offset1 = "#FF0101";
                    offset2 = "#800101";
                } else if (_this.cheakLevel(min) == 5) {
                    offset1 = "#800101";
                    offset2 = "#800101";
                }
            }

            var temp = {
                background: '-webkit-linear-gradient(left, ' + offset2 + ', ' + offset1 + ')',
                background: '-o-linear-gradient(left, ' + offset2 + ', ' + offset1 + ')',
                background: '-moz-linear-gradient(left, ' + offset2 + ',' + offset1 + ')',
                background: 'linear-gradient(to left,' + offset2 + ' , ' + offset1 + ')'
            };
            return temp
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
         * aqi的echarts初始化
         */
        initEchartsAqi: function () {
            let _this = this;
            var list0 = _this.table0;
            var list12 = _this.table12;
            var ydate0Min = [];
            var ydate0Max = [];
            var ydate12Min = [];
            var ydate12Max = [];
            var xdate = [];
            for (let i = 0; i < list0.length; i++) {
                ydate0Min.push(list0[i].aqiMin);
                ydate0Max.push(30);
                xdate.push(list0[i].resulttime.substring(0, 10))

            }
            for (let i = 0; i < list12.length; i++) {
                ydate12Min.push(list12[i].aqiMin);
                ydate12Max.push(30);
                if (list0.length == 0) {
                    xdate.push(list12[i].resulttime.substring(0, 10))
                }
            }
            option = {
                tooltip: {
                    show: true,
                    trigger: 'axis',
                    formatter(params) {
                        if (params.length == 4) {
                            return params[0].axisValue + '<br>' +
                                '00时:' + params[0].data + '~' + (parseInt(params[0].data) + parseInt(params[1].data)) + '<br>' +
                                '12时:' + params[2].data + '~' + (parseInt(params[2].data) + parseInt(params[3].data)) + '<br>';
                        } else if (params.length == 2) {
                            return params[0].axisValue + '<br>' +
                                params[0].seriesName + ":" + params[0].data + '~' + (parseInt(params[0].data) + parseInt(params[1].data)) + '<br>';
                        }
                    }
                },
                toolbox: {
                    right:20,
                    feature: {
                        saveAsImage: {show: true}
                    }
                },
                xAxis: {
                    type: 'category',
                    data: xdate
                },
                legend: {
                    data: ['00时', '12时'],
                    icon: 'rect',
                    right: '12%',
                    top: '20%'
                },
                grid: {
                    left: '8%',
                    right: '10%',
                    bottom: '3%',
                    containLabel: true,
                    show: 'true',
                    borderWidth: '2',
                    borderColor: '#333'
                },
                yAxis: {
                    type: 'value',
                    name: '预报AQI'
                },
                series: [{
                    name: '00时',
                    data: ydate0Min,
                    type: 'line',
                    stack: 'zero',
                    color: '#FED1D1'
                }, {
                    name: '00时',
                    data: ydate0Max,
                    areaStyle: {},
                    type: 'line',
                    stack: 'zero',
                    color: '#FED1D1'
                }, {
                    name: '12时',
                    data: ydate12Min,
                    type: 'line',
                    stack: 'lb',
                    color: '#B1CBE5'
                }, {
                    name: '12时',
                    data: ydate12Max,
                    areaStyle: {},
                    type: 'line',
                    stack: 'lb',
                    color: '#B1CBE5'
                }]
            };
            var myChart = echarts.init(document.getElementById("aqi"));
            myChart.setOption(option);
        },

        /**
         * echarts初始化
         */
        initEcharts: function (id, xdate, ydate0, ydate12, name, max) {
            option = {
                tooltip: {
                    trigger: 'axis'
                },
                legend: {
                    data: ['00时', '12时'],
                    right: '12%',
                    top: '20%'
                },
                toolbox: {
                    right:20,
                    feature: {
                        saveAsImage: {show: true}
                    }
                },
                grid: {
                    left: '9%',
                    right: '10%',
                    bottom: '3%',
                    containLabel: true,
                    show: 'true',
                    borderWidth: '2',
                    borderColor: '#333'
                },
                xAxis: {
                    type: 'category',
                    boundaryGap: false,
                    data: xdate,
                    name: '日期',
                },
                yAxis: {
                    type: 'value',
                    name: name,
                    max: parseInt(max) + 1,
                },
                series: [
                    {
                        name: '00时',
                        type: 'line',
                        data: ydate0
                    },
                    {
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
         * 提示
         * @param msg
         */
        showMessageDialog: function (msg) {
            var s = dialog({
                id: "msg-show-dialog",
                title: '提示',
                content: msg,
                okValue: '确定',
                ok: function () {
                    s.close().remove();
                }
            });
            s.showModal();
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

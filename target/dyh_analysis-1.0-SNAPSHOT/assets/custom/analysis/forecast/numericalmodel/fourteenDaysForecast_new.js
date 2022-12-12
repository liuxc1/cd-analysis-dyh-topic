let vue = new Vue({
    el: '#main-container',
    data: {
        url: {
            //获取模型列表
            getModelList:ctx + '/analysis/forecast/airforecastcheck/airForecastCheck/getForecastModel.vm',
            //时间列表
            getDayList: ctx + '/analysis/air/modelwqDayRow/getDayList.vm',
            //区县站点信息
            getRegionAndPoint: ctx + '/analysis/air/modelwqDayRow/getRegionAndPoint.vm',
            //预报天数据-echart
            getEchartsData: ctx + '/analysis/air/fourteenDaysForecast/getEchartsData.vm',
            //预报天数据-导出
            exportExcel: ctx + '/analysis/air/pollutionForecastCompare/exportExcel.vm',
            //污染物对比
            getPollutionCompareDataUrl: ctx + '/analysis/air/pollutionForecastCompare/getEchartsData.vm',
            //气象要素
            getWeatherData: ctx + '/analysis/air/weatherElementChange/getWeatherData.vm',
            //分页数据
            //小时数据
            getWeatherDataPage: ctx + '/analysis/air/weatherElementChange/getWeatherDataPage.vm',
            //日数据
            getWeatherDayDataPage: ctx + '/analysis/air/weatherElementChange/getWeatherDayDataPage.vm',
            //逆温
            getWeatherDataNwPage: ctx + '/analysis/air/weatherElementChange/getWeatherDataNwPage.vm',
            //水汽分布
            getWeatherDataSqPage: ctx + '/analysis/air/weatherElementChange/getWeatherDataSqPage.vm',
        },
        //预报时长
        stepDay:'14',
        //模式信息列表
        modelList:[],
        //查询条件
        queryParams: {
            month: '',
            modelTime: '',
            oldModelTime: '',
            model: (model=='null' || !model)?'GFS':model,
            //点位
            pointCode: (pointCode=='null' || !pointCode)?'510100000000':pointCode,
            pointName:  (pointName=='null'|| !pointName)?'成都市':pointName,
            //展示指标
            targetIndex: '0',
            //数据类型
            dataType: 'hour'
        },
        //时间轴
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
        //表格1
        table0: [],
        table12: [],

        //区县、点位列表
        regionAndPointList: {},
        //数据类型
        dataTypeList: [
            {
                typeCode: 'hour',
                typeName: '小时数据',
            }, {
                typeCode: 'day',
                typeName: '日数据',
            }
        ],
        //展示指标类型
        targetTypeList: [
            {
                targetIndex: '0',
                targetCode: 'temperature',
                targetName: '2m气温',
                unit: '℃'
            }, {
                targetIndex: '1',
                targetCode: 'dewPointSpread',
                targetName: '2m露点差',
                unit: '℃'
            }, {
                targetIndex: '2',
                targetCode: 'boundingLayer',
                targetName: '边界层高度',
                unit: 'm'
            }, {
                targetIndex: '3',
                targetCode: 'rainfall',
                targetName: '小时降水',
                unit: 'mm'
            }, {
                targetIndex: '4',
                targetCode: 'pressure',
                targetName: '气压',
                unit: 'Pa'
            }, {
                targetIndex: '5',
                targetCode: 'radiation',
                targetName: '辐射强度',
                unit: ''
            }, {
                targetIndex: '6',
                targetCode: 'humidity',
                targetName: '相对湿度',
                unit: '%RH'
            }, {
                targetIndex: '7',
                targetCode: 'ventilationCoefficient',
                targetName: '通风系数',
                unit: ''
            }, {
                targetIndex: '8',
                targetCode: 'compositeIndex',
                targetName: '气象综合指数',
                unit: ''
            }, {
                targetIndex: '9',
                targetCode: 'cloudCover',
                targetName: '云覆盖率',
                unit: '%'
            }, {
                targetIndex: '10',
                targetCode: 'windDirection,windSpeed',
                targetName: '风速风向',
                unit: 'm/s'
            }, /*{
                targetIndex: '11',
                targetCode: '',
                targetName: '逆温',
                unit: ''
            }, {
                targetIndex: '12',
                targetCode: '',
                targetName: '水汽分布',
                unit: ''
            }, */{
                targetIndex: '13',
                targetCode: 'temperature,windSpeed,rainfall',
                targetName: '气象多要素',
                unit: ''
            },
        ],
        //当天数据
        tableWeather12: {
            total: 0,
            pageNum: 1,
            pageSize: 10,
            list: [],
        },
        tableWeather0: {
            total: 0,
            pageNum: 1,
            pageSize: 10,
            list: [],
        },
        myChart_12: null,
        myChart_0: null,
        myChart_pm25_12: null,
        myChart_pm25_0: null,
        myChart_o3_12: null,
        myChart_o3_0: null,
        //选中时间
        chooseMonitorTime:(modelTime=='null' || !modelTime)?'':modelTime,
        //剖面图
        met_vert_12:'',
        met_vert_00:'',
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
        let month= null;
        let chooseDayIndex='';
        if (this.chooseMonitorTime){
            month = this.chooseMonitorTime.substring(0,7);
            chooseDayIndex = this.chooseMonitorTime.substring(8,10);
        }
        this.getModelList();
        this.monthClick(month,chooseDayIndex);
        this.getRegionAndPointData();

    },
    methods: {
        /**
         * 获取模型信息
         */
        getModelList: async function  (){
            let _this = this;
            await AjaxUtil.sendAjaxRequest(_this.url.getModelList, null, {}, function (json) {
                for (let i = 0; i < json.data.length; i++) {
                    if (json.data[i]['code'] === _this.queryParams.model) {
                        _this.stepDay = json.data[i]['step'];
                        //break;
                    }
                    if (json.data[i]['code'] === 'GFS_NEWSNOW') {
                        json.data[i] = {};
                    }
                }
                _this.modelList = json.data;
            });
        },
        /**
         * 获取模型名称
         * @returns {string|*}
         */
        getModelName:function (){
           let _this = this;
            for (let i = 0; i < _this.modelList.length; i++) {
                if (_this.modelList[i]['code'] == _this.queryParams.model){
                    return _this.modelList[i]['name'];
                }
            }
            return '';
        },
        /**
         * 时长切换
         */
        changeStep:function(){
            let _this=this;
            if (_this.stepDay == '8'){
                _this.queryParams.model = 'CMA';
            }else if (_this.stepDay == '14'){
                _this.queryParams.model = 'GFS';
            } if (_this.stepDay == '35'){
                _this.queryParams.model = 'CFS';
            }
            _this.changeModel();
        },
        /**
         * 模型切换
         */
        changeModel:function (){
            let _this = this;
            let month= null;
            let chooseDayIndex='';
            if (_this.queryParams.modelTime){
                month = _this.queryParams.modelTime.substring(0,7);
                chooseDayIndex = _this.queryParams.modelTime.substring(8,10);
            }
            _this.monthClick(month,chooseDayIndex);
        },
        /**
         * 月份切换
         * @param month
         */
        monthClick: function (month,chooseDayIndex) {
            let _this = this;
            AjaxUtil.sendAjaxRequest(_this.url.getDayList, null, {
                month: month,
                model:_this.queryParams.model
            }, function (json) {

                let dataList = json.data;
                let data = dataList[0];
                // 填报月份
                _this.queryParams.month = data.MODELTIME.substring(0, 7);
                // 当传递的月份为空时，重新赋予最大月份的值
                _this.timeAxis.next.limit = DateTimeUtil.getNowDate().substring(0,7);
                let list = [];
                // 记录选中的索引
                let selectedIndex = -1;
                for (let i = 0; i < dataList.length; i++) {
                    data = dataList[i];
                    // 是否禁用。True:禁用，False:不禁用
                    let disabled = data.IS_DISABLED != 'Y';
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
                //默认选中日期下标
                if (chooseDayIndex){
                    selectedIndex = parseInt(chooseDayIndex) - 1;
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
        /**
         * 查询
         */
        query: function () {
            let _this = this;
            if (_this.queryParams.pointCode == '' || _this.queryParams.pointCode == null || _this.queryParams.pointCode == undefined) {
                _this.showMessageDialog("请选择一个行政区或者站点");
            }
            _this.getFourTeenEchartsData();
            _this.getPollutionCompareData();
            _this.getWeatherData();
            _this.getImageUrl();
        },
        /**
         * 获取区县、站点信息
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
            let _this = this;
            $.dataChoose({
                title: '行政区或者站点',
                single: true,
                dataTypes: ['REGION', 'POINT'],
                dataTypeNames: ['行政区', '站点'],
                isCheckParent: true, // 是否可选父节点
                isShowLeaf:false, //是否显示叶子节点
                defaultDataType: _this.defaultDataType,
                dataCodes: _this.queryParams.pointCode,
                data: _this.regionAndPointList,
                callback: function (dataType, nodeArray) {
                    if(nodeArray.length > 0){
                        _this.defaultDataType = dataType;
                        _this.queryParams.pointCode = nodeArray[0].CODE;
                        _this.queryParams.pointName = nodeArray[0].NAME;
                    }
                    _this.query();
                }
            });
        },
        /**
         * 导出
         */
        exportExcel: function () {
            let _this = this;
            let url = _this.url.exportExcel;
            let params = {
                modelTime: _this.queryParams.modelTime,
                model: _this.queryParams.model,
                pointCode: _this.queryParams.pointCode,
                excelName: _this.getModelName() + "预报数据-" + _this.queryParams.model + ".xlsx"
            };
            FileDownloadUtil.createSubmitTempForm(url, params);

        },
        /**
         * 查询所有echarts的数据
         */
        getFourTeenEchartsData: function () {
            let _this = this;
            AjaxUtil.sendAjaxRequest(_this.url.getEchartsData, null, {
                modelTime: _this.queryParams.modelTime,
                pointCode: _this.queryParams.pointCode,
                model:_this.queryParams.model,
                step:_this.stepDay
            }, function (json) {
                _this.table12 = json.data.list12
                for (let i = 0; i < _this.table12.length; i++) {
                    let tableElement = _this.table12[i].primpollute;
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
                for (let i = 0; i < _this.table0.length; i++) {
                    let tableElement = _this.table0[i].primpollute;
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
            let _this = this;
            let key = ["so2", "no2", "pm10", "co", "o3", "o38", "pm25"];
            let names = ["SO₂（μg/m³）", "NO₂（μg/m³）", "PM₁₀（μg/m³）", "CO（mg/m³）", "O₃（μg/m³）", "O₃_8（μg/m³）", "PM₂.₅（μg/m³）"];
            let list0 = _this.table0;
            let list12 = _this.table12;
            for (let j = 0; j < key.length; j++) {
                let ydate0 = [];
                let ydate12 = [];
                let xdate = [];
                let max = 0;
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
        /**
         * 首要污染物颜色
         * @param primpollute
         * @returns {{"background-color": string}}
         */
        primpolluteColor: function (primpollute) {
            let temp = {
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
            let offset1, offset2;
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

            let temp = {
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
            let list0 = _this.table0;
            let list12 = _this.table12;
            let ydate0Min = [];
            let ydate0Max = [];
            let ydate12Min = [];
            let ydate12Max = [];
            let xdate = [];
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
            let legendData = ['00时'];
            if (_this.queryParams.model != 'CFS' && _this.queryParams.model != 'CMA' ){
                legendData =['00时', '12时'];
            }
            let option = {
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
                    right: 20,
                    feature: {
                        saveAsImage: {show: true}
                    }
                },
                xAxis: {
                    type: 'category',
                    data: xdate
                },
                legend: {
                    data: legendData,
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
            let myChart = echarts.init(document.getElementById("aqi"));
            myChart.setOption(option);
        },

        /**
         * echarts初始化
         */
        initEcharts: function (id, xdate, ydate0, ydate12, name, max) {
            let _this = this;
            let legendData = ['00时'];
            if (_this.queryParams.model != 'CFS' && _this.queryParams.model != 'CMA' ){
                legendData =['00时', '12时'];
            }
            let option = {
                color:['#9a60b4', '#ea7ccc'],
                tooltip: {
                    trigger: 'axis'
                },
                legend: {
                    data: legendData,
                    right: '12%',
                    top: '20%'
                },
                toolbox: {
                    right: 20,
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
            let myChart = echarts.init(document.getElementById(id));
            myChart.setOption(option);
        },
        /**
         * 上一月
         * @param prev
         */
        prevClick: function (prev) {
            let month = DateTimeUtil.addMonth(this.queryParams.month, -1);
            this.monthClick(month);
        },
        /**
         * 下一月
         * @param next
         */
        nextClick: function (next) {
            let month = DateTimeUtil.addMonth(this.queryParams.month, 1);
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
            _this.queryParams.modelTime = data.key;
            _this.queryParams.oldModelTime = _this.formatDayTime(new Date(_this.queryParams.modelTime).getTime() - 24 * 60 * 60 * 1000);
            _this.getFourTeenEchartsData();
            _this.getPollutionCompareData();
            _this.getWeatherData();
            _this.getImageUrl();
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
            let s = dialog({
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
            let _this = this;
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
        /*------------------------近期污染物浓度预报比较---------------------------*/
        /**
         * 查询污染物对比数据
         */
        getPollutionCompareData: function () {
            let _this = this;
            AjaxUtil.sendAjaxRequest(_this.url.getPollutionCompareDataUrl, null, {
                startTime: _this.queryParams.modelTime,
                endTime: DateTimeUtil.addDate(_this.queryParams.modelTime,parseInt(_this.stepDay)),
                model: _this.queryParams.model,
                pointCode: _this.queryParams.pointCode,
                step:_this.stepDay
            }, function (result) {
                let option_12_pm25=_this.loadPollutionCompareEcharts(result.data.twelve, '近期PM₂.₅浓度预报结果',  'PM25', 'PM₂.₅Concentration(μg/m³)');
                let option_00_pm25=_this.loadPollutionCompareEcharts(result.data.zero, '近期PM₂.₅浓度预报结果', 'PM25', 'PM₂.₅Concentration(μg/m³)');
                let option_12_o3=_this.loadPollutionCompareEcharts(result.data.twelve, '近期O₃8小时滑动最大浓度预报结果',  'O3_8', 'O₃8Max Concentration(μg/m³)');
                let option_00_o3=_this.loadPollutionCompareEcharts(result.data.zero, '近期O₃8小时滑动最大浓度预报结果', 'O3_8', 'O₃8Max Concentration(μg/m³)' );
                _this.drawPollutionCompareChart(option_12_pm25,option_00_pm25,option_12_o3,option_00_o3);
            });
        },
        /**
         * 绘制污染物对比ECharts图
         */
        drawPollutionCompareChart(option_12_pm25, option_00_pm25,option_12_o3,option_00_o3) {
            let _this = this;
            //销毁
            if (_this.myChart_pm25_12) {
                _this.myChart_pm25_12.dispose()
            }
            if (_this.myChart_pm25_0) {
                _this.myChart_pm25_0.dispose()
            }
            if (_this.myChart_o3_12) {
                _this.myChart_o3_12.dispose()
            }
            if (_this.myChart_o3_0) {
                _this.myChart_o3_0.dispose()
            }
            _this.myChart_pm25_0 = echarts.init(document.getElementById('pm25_0'));
            _this.myChart_o3_0 = echarts.init(document.getElementById('o3_8_0'));
            // 为echarts对象加载数据
            _this.myChart_pm25_0.setOption(option_00_pm25);
            _this.myChart_o3_0.setOption(option_00_o3);
            // 为echarts对象加载数据
            if (_this.queryParams.model != 'CFS' && _this.queryParams.model != 'CMA' ){
                _this.myChart_pm25_12 = echarts.init(document.getElementById('pm25_12'));
                _this.myChart_o3_12 = echarts.init(document.getElementById('o3_8_12'));
                _this.myChart_pm25_12.setOption(option_12_pm25);
                _this.myChart_o3_12.setOption(option_12_o3);
                //页面宽度变化的时候resize
                window.addEventListener("resize", function () {
                    _this.myChart_pm25_12.resize();
                    _this.myChart_pm25_0.resize();
                    _this.myChart_o3_12.resize();
                    _this.myChart_o3_0.resize();
                });
            }else {
                //页面宽度变化的时候resize
                window.addEventListener("resize", function () {
                    _this.myChart_pm25_0.resize();
                    _this.myChart_o3_0.resize();
                });
            }

        },
        /**
         * 加载污染物对比echarts
         */
        loadPollutionCompareEcharts: function (data, title, dataType, yName) {
            let modelTimeList = [];
            let resultTimeList = [];
            let sData = [];
            for (let i = 0; i < data.length; i++) {
                if (data[i + 1] == null || data[i].MODELTIME !== data[i + 1].MODELTIME) {
                    modelTimeList.push(data[i].MODELTIME.substring(5,10));
                }
                if (data[i] == null || resultTimeList.indexOf(data[i].RESULTTIME) === -1) {
                    resultTimeList.push(data[i].RESULTTIME);
                }
            }
            for (let m = 0; m < modelTimeList.length; m++) {
                let slData = [];
                for (let n = 0; n < data.length; n++) {
                    if (data[n].MODELTIME.substring(5,10) === modelTimeList[m]) {
                        slData.push(data[n][dataType]);
                    }
                }
                let obj = {
                    name: modelTimeList[m],
                    type: 'bar',
                    data: slData,
                };
                sData.push(obj);
            }
            let option = {
                title: {
                    left: '8%',
                    top: '2%',
                    text: title,
                },
                tooltip: {
                    trigger: 'axis',
                    axisPointer: {
                        type: 'shadow'
                    },
                    formatter:(v)=>{
                        let res = "<div style='width: 200px'></div><p>" + v[0].axisValue + "</p>";
                        $.each(v, function (i, param) {
                            if (i % 2 == 0) {
                                res += '<p>'
                                res += '<span style="display:inline-block;width: 10px;height: 10px;border-radius:20%;background-color:' + param.color + '"></span>'
                                res += "<span style='text-align:right;width: 45px;display: inline-block'>" + param.seriesName + "</span><span style='text-align:left;width: 60px;display: inline-block'>：" + (param.value ? param.value : '--') + '</span>';
                            } else {
                                res += '<span style="display:inline-block;width: 10px;height: 10px;border-radius:20%;background-color:' + param.color + '"></span>'
                                res += "<span style='text-align:right;width: 45px;display: inline-block'>" + param.seriesName + "</span><span style='text-align:left;width: 60px;display: inline-block'>：" + (param.value ? param.value : '--') + '</span>';
                                res += '</p>'
                            }
                            if ((v.length - 1 == i) && (v.length - 1) % 2 != 0) {
                                res += '</p>'
                            }
                        });
                        res += '</div>'
                        return res;
                    },
                },
                //下载配置
                toolbox: {
                    right:20,
                    feature: {
                        saveAsImage: {}
                    }
                },
                grid: {
                    top: '25%',
                    bottom: '10%',
                    right: '50',
                    left: '80',
                    show: 'true',
                    borderWidth: '2',
                    borderColor: '#D3D3D3',
                },
                legend: {
                    itemWidth: 15,
                    itemHeight: 15,
                    padding:[0,90,0,50],
                    // align: 'left',
                    // orient: 'vertical',
                    // x: 'right',
                    top: '10%',
                    textStyle: {
                        fontSize: 13
                    },
                    data: modelTimeList,

                },
                xAxis: [
                    {
                        name:'日期',
                        type: 'category',
                        data: resultTimeList,
                        splitLine: {show: true},
                    }
                ],
                yAxis: [
                    {
                        name: yName,
                        nameLocation: 'middle',
                        nameGap: '40',
                        nameTextStyle: {
                            fontSize: 14,
                        },
                        type: 'value',
                        min: 0,
                        splitLine: {show: true},

                    }
                ],
                series: sData
            };
            return option;
        },

        /*--------------------------气象要素--------------------------*/
        /**
         * 气象要素 - 切换展示指标
         */
        changeTarget: function () {
            let _this = this;
            _this.queryParams.dataType = 'hour';
            _this.getWeatherData();
        },
        /**
         * 查询气象要素数据
         */
        getWeatherData: function () {
            let _this = this;
            _this.tableWeather0 = {
                total: 0,
                pageNum: 1,
                pageSize: 10,
                list: [],
            };
            _this.tableWeather12 = {
                total: 0,
                pageNum: 1,
                pageSize: 10,
                list: [],
            };
            _this.queryWeatherList();
            _this.queryWeatherPageInfo();

        },
        /**
         * 分页数据
         */
        queryWeatherPageInfo: function () {
            let _this = this;
            let url = _this.url.getWeatherDataPage;
            if (_this.queryParams.targetIndex == 10 && _this.queryParams.dataType == 'day') {
                url = _this.url.getWeatherDayDataPage;
            } else if (_this.queryParams.targetIndex == 11) {
                url = _this.url.getWeatherDataNwPage;
            } else if (_this.queryParams.targetIndex == 12) {
                url = _this.url.getWeatherDataSqPage;
            }
            AjaxUtil.sendAjaxRequest(url, null, {
                pageNum: _this.tableWeather0.pageNum,
                pageSize: _this.tableWeather0.pageSize,
                modelTime: _this.queryParams.modelTime,
                model:_this.queryParams.model,
                pointCode: _this.queryParams.pointCode,
                step:_this.stepDay
            }, function (result) {
                if (result.data) {
                    if(result.data.zero.list.length<=0 && result.data.twelve.length<=0){
                        _this.showMessageDialog("暂无数据！");
                    }
                    //当天数据
                    _this.tableWeather0 = result.data.zero;
                    _this.tableWeather12 = result.data.twelve;
                }
            });
        },
        /**
         * echarts数据
         */
        queryWeatherList: function () {
            let _this = this;
            let param = _this.queryParams;
            param.step = _this.stepDay;
            AjaxUtil.sendAjaxRequest(_this.url.getWeatherData, null, param, function (result) {
                //当天数据
                let weatherDataList_00 = result.data.zero;
                let weatherDataList_12 = result.data.twelve;
                //上一天数据
                let oldWeatherDataList_00 = result.data.oldZero;
                let oldWeatherDataList_12 = result.data.oldTwelve;
                let option_12 = {};
                let option_00 = {};
                //风速、风向
                if (_this.queryParams.targetIndex == 10) {
                    option_12 = _this.loadWindEcharts("12", weatherDataList_12, oldWeatherDataList_12);
                    option_00 = _this.loadWindEcharts("00", weatherDataList_00, oldWeatherDataList_00);
                    //气象多要素
                } else if (_this.queryParams.targetIndex == 13) {
                    option_12 = _this.loadMultiFactorsEcharts("12", weatherDataList_12);
                    option_00 = _this.loadMultiFactorsEcharts("00", weatherDataList_00);
                    //其它
                } else {
                    option_12 = _this.loadCommonEcharts("12", weatherDataList_12, oldWeatherDataList_12);
                    option_00 = _this.loadCommonEcharts("00", weatherDataList_00, oldWeatherDataList_00);
                }
                _this.drawWeatherChart(option_12, option_00)
            });
        },

        /**
         * 绘制ECharts图
         */
        drawWeatherChart(option_12, option_00) {
            let _this = this;
            //销毁
            if (_this.myChart_12) {
                _this.myChart_12.dispose()
            }
            if (_this.myChart_0) {
                _this.myChart_0.dispose()
            }
            _this.myChart_0 = echarts.init(document.getElementById('echarts_00'));
            _this.myChart_0.setOption(option_00);
            // 为echarts对象加载数据
            if (this.queryParams.model != 'CFS' && _this.queryParams.model != 'CMA' ){
                _this.myChart_12 = echarts.init(document.getElementById('echarts_12'));
                _this.myChart_12.setOption(option_12);
            }

            if (_this.myChart_0  && _this.myChart_12){
                //联动配置
                echarts.connect([_this.myChart_12, _this.myChart_0]);
                //页面宽度变化的时候resize
                window.addEventListener("resize", function () {
                    _this.myChart_12.resize();
                    _this.myChart_0.resize();
                });
            }else {
                //页面宽度变化的时候resize
                window.addEventListener("resize", function () {
                    _this.myChart_0.resize();
                });
            }


        },
        /**
         * 加载echarts--通用
         */
        loadCommonEcharts: function (type, data, oldData) {
            let _this = this;
            let targetIndex = _this.queryParams.targetIndex;
            //获取title等属性
            let result = _this.getCommonEchartsData(type, data, oldData);
            let weatherData = [];
            if (data && data.length != 0) {
                for (let n = 0; n < data.length; n++) {
                    weatherData.push(data[n][_this.targetTypeList[targetIndex].targetCode]);
                }
            }
            let oldWeatherData = [];
            if (oldData && oldData.length != 0) {
                for (let n = 0; n < oldData.length; n++) {
                    oldWeatherData.push(oldData[n][_this.targetTypeList[targetIndex].targetCode]);
                }
            }
            let option = {
                color: ['rgb(63, 177, 227)', 'rgb(107, 230, 193)'],
                title: [{
                    left: 'center',
                    top: '5',
                    text: result.mainTitle,
                    textStyle: {
                        fontSize: '20'
                    }
                }, {
                    left: 'center',
                    top: '30',
                    text: result.subTitle,
                    textStyle: {
                        fontSize: '18',
                        fontWeight: 'normal'
                    }
                }],
                tooltip: {
                    trigger: 'axis',
                    axisPointer: {
                        type: 'shadow'
                    }
                },
                //下载配置
                toolbox: {
                    right:20,
                    feature: {
                        saveAsImage: {}
                    }
                },
                grid: {
                    top: '65',
                    bottom: '130',
                    right: '50',
                    left: '90',
                },
                legend: {
                    align: 'left',
                    bottom: '0',
                    textStyle: {
                        fontSize: 14
                    },
                    data: result.modelTimeList,
                    show: true

                },
                xAxis: [
                    {
                        name: '时间',
                        type: 'category',
                        data: result.resultTimeList,
                        axisLabel: {
                            margin: 45,
                            rotate: 30
                        },
                    }
                ],
                yAxis: [
                    {
                        type: 'value',
                        min:_this.queryParams.targetIndex == 4?950:0,
                        name: result.yName,
                    }
                ],
                // 缩放
                dataZoom: [{
                    type: 'slider',
                    bottom: 98,
                    showDetail: false,
                    // start:0,
                    // end:24
                }],
                series: [
                    {
                        name: result.modelTimeList[0],
                        type: 'line',
                        symbol: 'circle', //设定为实心点
                        symbolSize: 6, //设定实心点的大小
                        data: weatherData,
                    }, {
                        name: result.modelTimeList[1],
                        type: 'line',
                        symbol: 'circle',
                        symbolSize: 6,
                        data: oldWeatherData,
                    },

                ]
            };
            return option;
        },

        /**
         * 加载echarts--风速、风向
         */
        loadWindEcharts: function (type, data, oldData) {
            let _this = this;
            //获取title等属性
            let result = _this.getCommonEchartsData(type, data, oldData);
            let weatherData = [];
            if (data && data.length !== 0) {
                for (let n = 0; n < data.length; n++) {
                    let windSpeed = Math.ceil(data[n].windSpeed / 0.514);
                    let windDirection = data[n].windDirection;
                    let symbol = '';
                    if (windSpeed < 11) {
                        symbol = 'image://data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAYAAAAfSC3RAAAACXBIWXMAAAsTAAALEwEAmpwYAAAF0WlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4gPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iQWRvYmUgWE1QIENvcmUgNS42LWMxNDUgNzkuMTYzNDk5LCAyMDE4LzA4LzEzLTE2OjQwOjIyICAgICAgICAiPiA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPiA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtbG5zOnhtcE1NPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvbW0vIiB4bWxuczpzdEV2dD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL3NUeXBlL1Jlc291cmNlRXZlbnQjIiB4bWxuczpkYz0iaHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8iIHhtbG5zOnBob3Rvc2hvcD0iaHR0cDovL25zLmFkb2JlLmNvbS9waG90b3Nob3AvMS4wLyIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ0MgMjAxOSAoV2luZG93cykiIHhtcDpDcmVhdGVEYXRlPSIyMDIxLTA2LTI0VDExOjE3OjUxKzA4OjAwIiB4bXA6TWV0YWRhdGFEYXRlPSIyMDIxLTA2LTI0VDExOjE3OjUxKzA4OjAwIiB4bXA6TW9kaWZ5RGF0ZT0iMjAyMS0wNi0yNFQxMToxNzo1MSswODowMCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoxOGZlNmYzYy1jNWRiLTgzNDAtYjU0NC1kYTA5NzA3MjFmMTgiIHhtcE1NOkRvY3VtZW50SUQ9ImFkb2JlOmRvY2lkOnBob3Rvc2hvcDpmNmFjZWVjMy1mY2ZhLTlmNGMtYmRmOC1hMDFiM2JkYmQyMzkiIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDpmM2MxOTZjYy1lODE4LTA1NDctOWNiNC1iMzNmN2ZkZjU0ZWIiIGRjOmZvcm1hdD0iaW1hZ2UvcG5nIiBwaG90b3Nob3A6Q29sb3JNb2RlPSIzIj4gPHhtcE1NOkhpc3Rvcnk+IDxyZGY6U2VxPiA8cmRmOmxpIHN0RXZ0OmFjdGlvbj0iY3JlYXRlZCIgc3RFdnQ6aW5zdGFuY2VJRD0ieG1wLmlpZDpmM2MxOTZjYy1lODE4LTA1NDctOWNiNC1iMzNmN2ZkZjU0ZWIiIHN0RXZ0OndoZW49IjIwMjEtMDYtMjRUMTE6MTc6NTErMDg6MDAiIHN0RXZ0OnNvZnR3YXJlQWdlbnQ9IkFkb2JlIFBob3Rvc2hvcCBDQyAyMDE5IChXaW5kb3dzKSIvPiA8cmRmOmxpIHN0RXZ0OmFjdGlvbj0ic2F2ZWQiIHN0RXZ0Omluc3RhbmNlSUQ9InhtcC5paWQ6MThmZTZmM2MtYzVkYi04MzQwLWI1NDQtZGEwOTcwNzIxZjE4IiBzdEV2dDp3aGVuPSIyMDIxLTA2LTI0VDExOjE3OjUxKzA4OjAwIiBzdEV2dDpzb2Z0d2FyZUFnZW50PSJBZG9iZSBQaG90b3Nob3AgQ0MgMjAxOSAoV2luZG93cykiIHN0RXZ0OmNoYW5nZWQ9Ii8iLz4gPC9yZGY6U2VxPiA8L3htcE1NOkhpc3Rvcnk+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+CCbEzAAAAE1JREFUKJFj/P//PwM5gIksXXg1JibWMyQm1pOmEaKhgYGBoQGXZkyNCE0wgFUzqkZMTTg1M+IM1cREiMT8+YzEOZVIMBI04g5VWtkIALZVGRmvb0gyAAAAAElFTkSuQmCC';
                    } else if (windSpeed >= 11 && windSpeed < 17) {
                        symbol = 'image://data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAYAAAAfSC3RAAAACXBIWXMAAAsTAAALEwEAmpwYAAAF0WlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4gPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iQWRvYmUgWE1QIENvcmUgNS42LWMxNDUgNzkuMTYzNDk5LCAyMDE4LzA4LzEzLTE2OjQwOjIyICAgICAgICAiPiA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPiA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtbG5zOnhtcE1NPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvbW0vIiB4bWxuczpzdEV2dD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL3NUeXBlL1Jlc291cmNlRXZlbnQjIiB4bWxuczpkYz0iaHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8iIHhtbG5zOnBob3Rvc2hvcD0iaHR0cDovL25zLmFkb2JlLmNvbS9waG90b3Nob3AvMS4wLyIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ0MgMjAxOSAoV2luZG93cykiIHhtcDpDcmVhdGVEYXRlPSIyMDIxLTA2LTI0VDExOjE4OjE4KzA4OjAwIiB4bXA6TWV0YWRhdGFEYXRlPSIyMDIxLTA2LTI0VDExOjE4OjE4KzA4OjAwIiB4bXA6TW9kaWZ5RGF0ZT0iMjAyMS0wNi0yNFQxMToxODoxOCswODowMCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDo3NDNlYWI5Yi0yYWYwLTA4NGQtOWIwMy0yZmE0MWNlYzFiZGQiIHhtcE1NOkRvY3VtZW50SUQ9ImFkb2JlOmRvY2lkOnBob3Rvc2hvcDoyNDQxYzIxYy1iZDk1LTJlNDUtODlhNS1mYzQyMmE0MTQwMzgiIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDozMGJlMThiMy0yNTEwLTc2NDAtOTEwZS05NzFiMzgyNDBhYzMiIGRjOmZvcm1hdD0iaW1hZ2UvcG5nIiBwaG90b3Nob3A6Q29sb3JNb2RlPSIzIj4gPHhtcE1NOkhpc3Rvcnk+IDxyZGY6U2VxPiA8cmRmOmxpIHN0RXZ0OmFjdGlvbj0iY3JlYXRlZCIgc3RFdnQ6aW5zdGFuY2VJRD0ieG1wLmlpZDozMGJlMThiMy0yNTEwLTc2NDAtOTEwZS05NzFiMzgyNDBhYzMiIHN0RXZ0OndoZW49IjIwMjEtMDYtMjRUMTE6MTg6MTgrMDg6MDAiIHN0RXZ0OnNvZnR3YXJlQWdlbnQ9IkFkb2JlIFBob3Rvc2hvcCBDQyAyMDE5IChXaW5kb3dzKSIvPiA8cmRmOmxpIHN0RXZ0OmFjdGlvbj0ic2F2ZWQiIHN0RXZ0Omluc3RhbmNlSUQ9InhtcC5paWQ6NzQzZWFiOWItMmFmMC0wODRkLTliMDMtMmZhNDFjZWMxYmRkIiBzdEV2dDp3aGVuPSIyMDIxLTA2LTI0VDExOjE4OjE4KzA4OjAwIiBzdEV2dDpzb2Z0d2FyZUFnZW50PSJBZG9iZSBQaG90b3Nob3AgQ0MgMjAxOSAoV2luZG93cykiIHN0RXZ0OmNoYW5nZWQ9Ii8iLz4gPC9yZGY6U2VxPiA8L3htcE1NOkhpc3Rvcnk+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+LzPsAQAAAGpJREFUKJHVkkEOgCAMBAfjrzz7LuFdnn0XHmyQ1Lbp1U04EBi62aX03gHg2klpOwFYcre/isBDlqk1gOq0b5mJGqrWZA1qyIW11TbZkrgpxkOUUcesp5oXlAoiq2n9CPQ+ADhpjkMz1YRugmIWlM+/Np0AAAAASUVORK5CYII=';
                    } else {
                        symbol = 'image://data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAYAAAAfSC3RAAAACXBIWXMAAAsTAAALEwEAmpwYAAAF0WlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4gPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iQWRvYmUgWE1QIENvcmUgNS42LWMxNDUgNzkuMTYzNDk5LCAyMDE4LzA4LzEzLTE2OjQwOjIyICAgICAgICAiPiA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPiA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtbG5zOnhtcE1NPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvbW0vIiB4bWxuczpzdEV2dD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL3NUeXBlL1Jlc291cmNlRXZlbnQjIiB4bWxuczpkYz0iaHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8iIHhtbG5zOnBob3Rvc2hvcD0iaHR0cDovL25zLmFkb2JlLmNvbS9waG90b3Nob3AvMS4wLyIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ0MgMjAxOSAoV2luZG93cykiIHhtcDpDcmVhdGVEYXRlPSIyMDIxLTA2LTI0VDExOjE4OjA4KzA4OjAwIiB4bXA6TWV0YWRhdGFEYXRlPSIyMDIxLTA2LTI0VDExOjE4OjA4KzA4OjAwIiB4bXA6TW9kaWZ5RGF0ZT0iMjAyMS0wNi0yNFQxMToxODowOCswODowMCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDozYmNjYjc2NC1lMmM0LTYwNGEtYmU1ZC1hNDNlNDE1MzVjYTUiIHhtcE1NOkRvY3VtZW50SUQ9ImFkb2JlOmRvY2lkOnBob3Rvc2hvcDphZTE2MGUxNi1lZGY5LWRlNDQtOGZiMi1hYWJlNDExZjc3NmYiIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDphODE1NzBmYi01Nzg2LWEwNGItODJjMy05MTQzZjNiY2RjYmMiIGRjOmZvcm1hdD0iaW1hZ2UvcG5nIiBwaG90b3Nob3A6Q29sb3JNb2RlPSIzIj4gPHhtcE1NOkhpc3Rvcnk+IDxyZGY6U2VxPiA8cmRmOmxpIHN0RXZ0OmFjdGlvbj0iY3JlYXRlZCIgc3RFdnQ6aW5zdGFuY2VJRD0ieG1wLmlpZDphODE1NzBmYi01Nzg2LWEwNGItODJjMy05MTQzZjNiY2RjYmMiIHN0RXZ0OndoZW49IjIwMjEtMDYtMjRUMTE6MTg6MDgrMDg6MDAiIHN0RXZ0OnNvZnR3YXJlQWdlbnQ9IkFkb2JlIFBob3Rvc2hvcCBDQyAyMDE5IChXaW5kb3dzKSIvPiA8cmRmOmxpIHN0RXZ0OmFjdGlvbj0ic2F2ZWQiIHN0RXZ0Omluc3RhbmNlSUQ9InhtcC5paWQ6M2JjY2I3NjQtZTJjNC02MDRhLWJlNWQtYTQzZTQxNTM1Y2E1IiBzdEV2dDp3aGVuPSIyMDIxLTA2LTI0VDExOjE4OjA4KzA4OjAwIiBzdEV2dDpzb2Z0d2FyZUFnZW50PSJBZG9iZSBQaG90b3Nob3AgQ0MgMjAxOSAoV2luZG93cykiIHN0RXZ0OmNoYW5nZWQ9Ii8iLz4gPC9yZGY6U2VxPiA8L3htcE1NOkhpc3Rvcnk+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+hKBUbQAAAFRJREFUKJFj/P//PwM5gIksXfg0Wp5Jq7c8k1ZPkkaohgYGBoYGXJoxNCJpggGsmlE0YtGEUzMjrlC1PJP2n4GBgeG4ySxGopxKLBgJGnGGKs1sBAAqAx9hc4nt9gAAAABJRU5ErkJggg==';
                    }
                    let temp = {
                        value: data[n].windSpeed,
                        symbol: symbol,
                        symbolSize: 20,
                        symbolRotate: windDirection + 180,
                        windDirection: windDirection,
                        modelTime: data[n].modelTime.substring(0, 13),
                        resultTime: data[n].resultTime.substring(0, 13),
                        windSpeed: data[n].windSpeed
                    }
                    weatherData.push(temp)
                }
            }
            let oldWeatherData = [];
            if (oldData && oldData.length !== 0) {
                for (let n = 0; n < oldData.length; n++) {
                    let windSpeed = Math.ceil(oldData[n].windSpeed / 0.514);
                    let windDirection = oldData[n].windDirection;
                    let symbol = '';
                    if (windSpeed < 11) {
                        symbol = 'image://data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAYAAAAfSC3RAAAACXBIWXMAAAsTAAALEwEAmpwYAAAF0WlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4gPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iQWRvYmUgWE1QIENvcmUgNS42LWMxNDUgNzkuMTYzNDk5LCAyMDE4LzA4LzEzLTE2OjQwOjIyICAgICAgICAiPiA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPiA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtbG5zOnhtcE1NPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvbW0vIiB4bWxuczpzdEV2dD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL3NUeXBlL1Jlc291cmNlRXZlbnQjIiB4bWxuczpkYz0iaHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8iIHhtbG5zOnBob3Rvc2hvcD0iaHR0cDovL25zLmFkb2JlLmNvbS9waG90b3Nob3AvMS4wLyIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ0MgMjAxOSAoV2luZG93cykiIHhtcDpDcmVhdGVEYXRlPSIyMDIxLTA2LTI0VDExOjE3OjUxKzA4OjAwIiB4bXA6TWV0YWRhdGFEYXRlPSIyMDIxLTA2LTI0VDExOjE3OjUxKzA4OjAwIiB4bXA6TW9kaWZ5RGF0ZT0iMjAyMS0wNi0yNFQxMToxNzo1MSswODowMCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoxOGZlNmYzYy1jNWRiLTgzNDAtYjU0NC1kYTA5NzA3MjFmMTgiIHhtcE1NOkRvY3VtZW50SUQ9ImFkb2JlOmRvY2lkOnBob3Rvc2hvcDpmNmFjZWVjMy1mY2ZhLTlmNGMtYmRmOC1hMDFiM2JkYmQyMzkiIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDpmM2MxOTZjYy1lODE4LTA1NDctOWNiNC1iMzNmN2ZkZjU0ZWIiIGRjOmZvcm1hdD0iaW1hZ2UvcG5nIiBwaG90b3Nob3A6Q29sb3JNb2RlPSIzIj4gPHhtcE1NOkhpc3Rvcnk+IDxyZGY6U2VxPiA8cmRmOmxpIHN0RXZ0OmFjdGlvbj0iY3JlYXRlZCIgc3RFdnQ6aW5zdGFuY2VJRD0ieG1wLmlpZDpmM2MxOTZjYy1lODE4LTA1NDctOWNiNC1iMzNmN2ZkZjU0ZWIiIHN0RXZ0OndoZW49IjIwMjEtMDYtMjRUMTE6MTc6NTErMDg6MDAiIHN0RXZ0OnNvZnR3YXJlQWdlbnQ9IkFkb2JlIFBob3Rvc2hvcCBDQyAyMDE5IChXaW5kb3dzKSIvPiA8cmRmOmxpIHN0RXZ0OmFjdGlvbj0ic2F2ZWQiIHN0RXZ0Omluc3RhbmNlSUQ9InhtcC5paWQ6MThmZTZmM2MtYzVkYi04MzQwLWI1NDQtZGEwOTcwNzIxZjE4IiBzdEV2dDp3aGVuPSIyMDIxLTA2LTI0VDExOjE3OjUxKzA4OjAwIiBzdEV2dDpzb2Z0d2FyZUFnZW50PSJBZG9iZSBQaG90b3Nob3AgQ0MgMjAxOSAoV2luZG93cykiIHN0RXZ0OmNoYW5nZWQ9Ii8iLz4gPC9yZGY6U2VxPiA8L3htcE1NOkhpc3Rvcnk+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+CCbEzAAAAE1JREFUKJFj/P//PwM5gIksXXg1JibWMyQm1pOmEaKhgYGBoQGXZkyNCE0wgFUzqkZMTTg1M+IM1cREiMT8+YzEOZVIMBI04g5VWtkIALZVGRmvb0gyAAAAAElFTkSuQmCC';
                    } else if (windSpeed >= 11 && windSpeed < 17) {
                        symbol = 'image://data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAYAAAAfSC3RAAAACXBIWXMAAAsTAAALEwEAmpwYAAAF0WlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4gPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iQWRvYmUgWE1QIENvcmUgNS42LWMxNDUgNzkuMTYzNDk5LCAyMDE4LzA4LzEzLTE2OjQwOjIyICAgICAgICAiPiA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPiA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtbG5zOnhtcE1NPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvbW0vIiB4bWxuczpzdEV2dD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL3NUeXBlL1Jlc291cmNlRXZlbnQjIiB4bWxuczpkYz0iaHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8iIHhtbG5zOnBob3Rvc2hvcD0iaHR0cDovL25zLmFkb2JlLmNvbS9waG90b3Nob3AvMS4wLyIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ0MgMjAxOSAoV2luZG93cykiIHhtcDpDcmVhdGVEYXRlPSIyMDIxLTA2LTI0VDExOjE4OjE4KzA4OjAwIiB4bXA6TWV0YWRhdGFEYXRlPSIyMDIxLTA2LTI0VDExOjE4OjE4KzA4OjAwIiB4bXA6TW9kaWZ5RGF0ZT0iMjAyMS0wNi0yNFQxMToxODoxOCswODowMCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDo3NDNlYWI5Yi0yYWYwLTA4NGQtOWIwMy0yZmE0MWNlYzFiZGQiIHhtcE1NOkRvY3VtZW50SUQ9ImFkb2JlOmRvY2lkOnBob3Rvc2hvcDoyNDQxYzIxYy1iZDk1LTJlNDUtODlhNS1mYzQyMmE0MTQwMzgiIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDozMGJlMThiMy0yNTEwLTc2NDAtOTEwZS05NzFiMzgyNDBhYzMiIGRjOmZvcm1hdD0iaW1hZ2UvcG5nIiBwaG90b3Nob3A6Q29sb3JNb2RlPSIzIj4gPHhtcE1NOkhpc3Rvcnk+IDxyZGY6U2VxPiA8cmRmOmxpIHN0RXZ0OmFjdGlvbj0iY3JlYXRlZCIgc3RFdnQ6aW5zdGFuY2VJRD0ieG1wLmlpZDozMGJlMThiMy0yNTEwLTc2NDAtOTEwZS05NzFiMzgyNDBhYzMiIHN0RXZ0OndoZW49IjIwMjEtMDYtMjRUMTE6MTg6MTgrMDg6MDAiIHN0RXZ0OnNvZnR3YXJlQWdlbnQ9IkFkb2JlIFBob3Rvc2hvcCBDQyAyMDE5IChXaW5kb3dzKSIvPiA8cmRmOmxpIHN0RXZ0OmFjdGlvbj0ic2F2ZWQiIHN0RXZ0Omluc3RhbmNlSUQ9InhtcC5paWQ6NzQzZWFiOWItMmFmMC0wODRkLTliMDMtMmZhNDFjZWMxYmRkIiBzdEV2dDp3aGVuPSIyMDIxLTA2LTI0VDExOjE4OjE4KzA4OjAwIiBzdEV2dDpzb2Z0d2FyZUFnZW50PSJBZG9iZSBQaG90b3Nob3AgQ0MgMjAxOSAoV2luZG93cykiIHN0RXZ0OmNoYW5nZWQ9Ii8iLz4gPC9yZGY6U2VxPiA8L3htcE1NOkhpc3Rvcnk+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+LzPsAQAAAGpJREFUKJHVkkEOgCAMBAfjrzz7LuFdnn0XHmyQ1Lbp1U04EBi62aX03gHg2klpOwFYcre/isBDlqk1gOq0b5mJGqrWZA1qyIW11TbZkrgpxkOUUcesp5oXlAoiq2n9CPQ+ADhpjkMz1YRugmIWlM+/Np0AAAAASUVORK5CYII=';
                    } else {
                        symbol = 'image://data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAYAAAAfSC3RAAAACXBIWXMAAAsTAAALEwEAmpwYAAAF0WlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4gPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iQWRvYmUgWE1QIENvcmUgNS42LWMxNDUgNzkuMTYzNDk5LCAyMDE4LzA4LzEzLTE2OjQwOjIyICAgICAgICAiPiA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPiA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtbG5zOnhtcE1NPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvbW0vIiB4bWxuczpzdEV2dD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL3NUeXBlL1Jlc291cmNlRXZlbnQjIiB4bWxuczpkYz0iaHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8iIHhtbG5zOnBob3Rvc2hvcD0iaHR0cDovL25zLmFkb2JlLmNvbS9waG90b3Nob3AvMS4wLyIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ0MgMjAxOSAoV2luZG93cykiIHhtcDpDcmVhdGVEYXRlPSIyMDIxLTA2LTI0VDExOjE4OjA4KzA4OjAwIiB4bXA6TWV0YWRhdGFEYXRlPSIyMDIxLTA2LTI0VDExOjE4OjA4KzA4OjAwIiB4bXA6TW9kaWZ5RGF0ZT0iMjAyMS0wNi0yNFQxMToxODowOCswODowMCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDozYmNjYjc2NC1lMmM0LTYwNGEtYmU1ZC1hNDNlNDE1MzVjYTUiIHhtcE1NOkRvY3VtZW50SUQ9ImFkb2JlOmRvY2lkOnBob3Rvc2hvcDphZTE2MGUxNi1lZGY5LWRlNDQtOGZiMi1hYWJlNDExZjc3NmYiIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDphODE1NzBmYi01Nzg2LWEwNGItODJjMy05MTQzZjNiY2RjYmMiIGRjOmZvcm1hdD0iaW1hZ2UvcG5nIiBwaG90b3Nob3A6Q29sb3JNb2RlPSIzIj4gPHhtcE1NOkhpc3Rvcnk+IDxyZGY6U2VxPiA8cmRmOmxpIHN0RXZ0OmFjdGlvbj0iY3JlYXRlZCIgc3RFdnQ6aW5zdGFuY2VJRD0ieG1wLmlpZDphODE1NzBmYi01Nzg2LWEwNGItODJjMy05MTQzZjNiY2RjYmMiIHN0RXZ0OndoZW49IjIwMjEtMDYtMjRUMTE6MTg6MDgrMDg6MDAiIHN0RXZ0OnNvZnR3YXJlQWdlbnQ9IkFkb2JlIFBob3Rvc2hvcCBDQyAyMDE5IChXaW5kb3dzKSIvPiA8cmRmOmxpIHN0RXZ0OmFjdGlvbj0ic2F2ZWQiIHN0RXZ0Omluc3RhbmNlSUQ9InhtcC5paWQ6M2JjY2I3NjQtZTJjNC02MDRhLWJlNWQtYTQzZTQxNTM1Y2E1IiBzdEV2dDp3aGVuPSIyMDIxLTA2LTI0VDExOjE4OjA4KzA4OjAwIiBzdEV2dDpzb2Z0d2FyZUFnZW50PSJBZG9iZSBQaG90b3Nob3AgQ0MgMjAxOSAoV2luZG93cykiIHN0RXZ0OmNoYW5nZWQ9Ii8iLz4gPC9yZGY6U2VxPiA8L3htcE1NOkhpc3Rvcnk+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+hKBUbQAAAFRJREFUKJFj/P//PwM5gIksXfg0Wp5Jq7c8k1ZPkkaohgYGBoYGXJoxNCJpggGsmlE0YtGEUzMjrlC1PJP2n4GBgeG4ySxGopxKLBgJGnGGKs1sBAAqAx9hc4nt9gAAAABJRU5ErkJggg==';
                    }
                    let temp = {
                        value: oldData[n].windSpeed,
                        symbol: symbol,
                        symbolSize: 20,
                        symbolRotate: windDirection + 180,
                        windDirection: windDirection,
                        modelTime: oldData[n].modelTime.substring(0, 13),
                        resultTime: oldData[n].resultTime.substring(0, 13),
                        windSpeed: oldData[n].windSpeed
                    }
                    oldWeatherData.push(temp)
                }
            }
            let option = {
                color: ['rgb(63, 177, 227)', 'rgb(107, 230, 193)'],
                title: [{
                    left: 'center',
                    top: '5',
                    text: result.mainTitle,
                    textStyle: {
                        fontSize: '20'
                    }
                }, {
                    left: 'center',
                    top: '30',
                    text: result.subTitle,
                    textStyle: {
                        fontSize: '18',
                        fontWeight: 'normal'
                    }
                }],
                tooltip: {
                    trigger: 'axis',
                    axisPointer: {
                        type: 'shadow'
                    },
                    formatter: function (params) {
                        let modelTime = '';
                        let windSpeed = '';
                        let windDirection = '';
                        if (params && params[0]) {
                            modelTime = params[0].data.modelTime;
                            windSpeed = '\xa0风速：' + params[0].data.windSpeed;
                            windDirection = '\xa0风向：' + params[0].data.windDirection;
                        }
                        let oldModelTime = '';
                        let oldWindSpeed = '';
                        let oldWindDirection = '';
                        if (params && params[1]) {
                            oldModelTime = params[1].data.modelTime;
                            oldWindSpeed = '\xa0风速：' + params[1].data.windSpeed;
                            oldWindDirection = '\xa0风向：' + params[1].data.windDirection;
                        }
                        return [
                            modelTime,
                            windSpeed,
                            windDirection,
                            oldModelTime,
                            oldWindSpeed,
                            oldWindDirection,
                        ].join('<br>');
                    }
                },
                //下载配置
                toolbox: {
                    feature: {
                        saveAsImage: {}
                    }
                },
                grid: {
                    top: '65',
                    bottom: '130',
                    right: '50',
                    left: '90',
                },
                legend: {
                    align: 'left',
                    bottom: '0',
                    textStyle: {
                        fontSize: 14
                    },
                    data: result.modelTimeList,
                    show: false

                },
                xAxis: [
                    {
                        name: _this.queryParams.dataType == 'day' ? '日期' : '时间',
                        type: 'category',
                        data: result.resultTimeList,
                        axisLabel: {
                            margin: 45,
                            rotate: 30
                        },
                    }
                ],
                yAxis: [
                    {
                        type: 'value',
                        min: 0,
                        name: '风速（m/s）',
                        nameLocation: 'middle',
                        nameGap: 35,
                    }
                ],
                // 缩放
                dataZoom: [{
                    type: 'slider',
                    bottom: 98,
                    // start: 0,
                    // end: 24
                }],
                series: [
                    {
                        name: result.modelTimeList[0],
                        type: 'line',
                        data: weatherData,
                    }, {
                        name: result.modelTimeList[1],
                        type: 'line',
                        data: oldWeatherData,
                    },

                ],

                graphic: [
                    {
                        type: 'rect',
                        left: '21%',
                        // left: '215',
                        bottom: '0',
                        z: 215,
                        shape: {
                            width: 30,
                            height: 15
                        },
                        style: {
                            fill: '#D33C3E'
                        }

                    },
                    {
                        type: 'text',
                        z: 100,
                        left: '25%',
                        // left: '250',
                        bottom: '0',
                        style: {
                            text: [
                                // '微风（小于 11 节）'
                                '微风（< 5.654m/s）'
                            ].join('\n'),
                            font: '14px Microsoft YaHei'
                        }
                    },
                    {
                        type: 'rect',
                        left: '42%',
                        // left: '385',
                        bottom: '0',
                        z: 100,
                        shape: {
                            width: 30,
                            height: 15
                        },
                        style: {
                            fill: '#f4e9a3'
                        }
                    },
                    {
                        type: 'text',
                        z: 100,
                        left: '46%',
                        // left: '415',
                        bottom: '0',
                        style: {
                            text: [
                                // '中风（11  ~ 17 节）'
                                '中风（5.654m/s ~ 8.738m/s）'
                            ].join('\n'),
                            font: '14px Microsoft YaHei'
                        }
                    },
                    {
                        type: 'rect',
                        left: '71%',
                        // left: '550',
                        bottom: '0',
                        z: 100,
                        shape: {
                            width: 30,
                            height: 15
                        },
                        style: {
                            fill: '#18BF12'
                        }

                    },
                    {
                        type: 'text',
                        z: 100,
                        left: '75%',
                        // left: '585',
                        bottom: '0',
                        style: {
                            text: [
                                // '大风（>=17节）'
                                '大风（≥ 8.738m/s）'
                            ].join('\n'),
                            font: '14px Microsoft YaHei'
                        }
                    },

                ],
            };
            return option;

        },
        /**
         * 加载echarts--气象多要素(temperature,windSpeed,rainfall)
         */
        loadMultiFactorsEcharts: function (type, data) {
            let _this = this;
            //获取title等属性
            let result = _this.getCommonEchartsData(type, data);
            let temperatureData = [];
            let windSpeedData = [];
            let rainfallData = [];
            if (data && data.length != 0) {
                for (let n = 0; n < data.length; n++) {
                    temperatureData.push(data[n].temperature);
                    windSpeedData.push(data[n].windSpeed);
                    rainfallData.push(data[n].rainfall);
                }
            }
            let option = {
                color: ['#4472C4', '#ED7D31', '#00B050'],
                title: [{
                    left: 'center',
                    top: '5',
                    text: result.mainTitle,
                    textStyle: {
                        fontSize: '20'
                    }
                }, {
                    left: 'center',
                    top: '30',
                    text: result.subTitle,
                    textStyle: {
                        fontSize: '18',
                        fontWeight: 'normal'
                    }
                }],
                tooltip: {
                    trigger: 'axis',
                    axisPointer: {
                        type: 'shadow'
                    }
                },
                //下载配置
                toolbox: {
                    feature: {
                        saveAsImage: {}
                    }
                },
                grid: {
                    top: '65',
                    bottom: '130',
                    right: '5',
                    left: '90',
                },
                legend: {
                    align: 'left',
                    bottom: '0',
                    textStyle: {
                        fontSize: 14
                    },
                    data: ['温度', '风速', '降水'],
                    show: true

                },
                xAxis: [
                    {
                        type: 'category',
                        data: result.resultTimeList,
                        axisLabel: {
                            margin: 45,
                            rotate: 30
                        },
                    }
                ],
                yAxis: [
                    {
                        type: 'value',
                        min: 0,
                        name: result.yName,
                    }
                ],
                // 缩放
                dataZoom: [{
                    type: 'slider',
                    bottom: 98,
                    // start:0,
                    // end:24
                    showDetail: false
                }],
                series: [
                    {
                        name: '温度',
                        type: 'line',
                        symbol: 'circle', //设定为实心点
                        symbolSize: 6, //设定实心点的大小
                        data: temperatureData,
                    }, {
                        name: '风速',
                        type: 'line',
                        symbol: 'circle',
                        symbolSize: 6,
                        data: windSpeedData,
                    }, {
                        name: '降水',
                        type: 'line',
                        symbol: 'circle',
                        symbolSize: 6,
                        data: rainfallData,
                    },

                ]
            };
            return option;
        },
        /**
         * title，resultTimeList,modelTimeList,yName
         */
        getCommonEchartsData: function (type, data, oldData) {
            let _this = this;
            //let targetIndex = _this.queryParams.targetIndex;
            let targetIndex = _this.queryParams.targetIndex >10 ?  _this.queryParams.targetIndex-2 : _this.queryParams.targetIndex;

            //title
            let mainTitle = _this.targetTypeList[targetIndex].targetName + '预报结果';
            let subTitle = '';
            //起报时间
            let modelTimeList = [];
            //预报时间
            let resultTimeList = [];
            if (data && data.length != 0) {
                subTitle = '（' + type + '时起报，' + data[0].resultTime.substring(0, 10) + '~' + data[data.length - 1].resultTime.substring(0, 10) + '，' + data[0].pointName + '）';
                modelTimeList.push(data[0].modelTime.substring(0, 10));
                for (let i = 0; i < data.length; i++) {
                    if (data[i] == null || resultTimeList.indexOf(data[i].resultTime) === -1) {
                        resultTimeList.push(data[i].resultTime);
                    }
                }
            }
            if (oldData && oldData.length != 0) {
                modelTimeList.push(oldData[0].modelTime.substring(0, 10));
            }
            //y轴名称
            let unit = '';
            if (_this.targetTypeList[targetIndex].unit) {
                unit = '(' + _this.targetTypeList[targetIndex].unit + ')';
            }
            let yName = _this.targetTypeList[targetIndex].targetName + unit;
            let result = {
                mainTitle: mainTitle,
                subTitle: subTitle,
                modelTimeList: modelTimeList,
                resultTimeList: resultTimeList,
                yName: yName
            }
            return result;
        },
        /**
         * 解析时间
         */
        formatDayTime: function (val) {
            if (val) {
                let date = new Date(val)
                let Y = date.getFullYear();
                let M = date.getMonth() + 1;
                let D = date.getDate();

                if (M < 10) {
                    M = '0' + M;
                }
                if (D < 10) {
                    D = '0' + D;
                }

                return Y + '-' + M + '-' + D;
            } else {
                return '';
            }
        },
        /**
         * 剖面图获取URL
         */
        getImageUrl:function (){
            let _this = this;
            let dateTime =  _this.queryParams.modelTime;
            _this.met_vert_00 = wrfImagePth +'/cutawayPic/'+ (dateTime.replace(/-/g, "")) + "_00.png";
            _this.met_vert_12 = wrfImagePth +'/cutawayPic/'+ (dateTime.replace(/-/g, "")) + "_12.png";
        },
    }
});
let errorImg = null;
function onError (id) {
    errorImg = document.getElementById("errorImg");
    if (!errorImg) {
        return;
    }
    let img = document.getElementById(id);
    img.src = errorImg.src;
}

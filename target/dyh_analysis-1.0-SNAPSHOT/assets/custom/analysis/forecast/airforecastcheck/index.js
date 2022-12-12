/** vue实例表格-1 * */
var vue = new Vue(
    {
        el: '#main-container',
        data(){
            return{
                myChart: '',
                mychartpm25: '',
                mycharto3: '',
                ybdList: [{select: "checked", value: 1}, {select: "", value: 2}, {select: "", value: 3},
                    {select: "",value: 4 }, {select: "", value: 5}, {select: "", value: 6}, {select: "", value: 7}],
                type:'MSPG',
                modelList:[
                    {
                        name:'',
                        code:''
                    }
                ],
                personList:[
                    {
                        userName:''
                    }
                ],
                //查询条件
                params:{
                    startTime:startTime,
                    endTime:endTime,
                    //时次
                    timeType:'0',
                    timeStep:'1',
                    modelName:'',
                    userName:'',
                    userNames:'',
                    //预报步长
                    days:'14'
                },
                echartData:[],
                tableList:[],
                colArr:[],
            }
        },
        mounted: function () {
            var _this = this;
            this.init();
            $(window).resize(function () {
                _this.myChart.resize();
                _this.mychartpm25.resize();
                _this.mycharto3.resize();
            });
        },
        filters: {
            /**
             * 通用内容格式器（无效值用返回--）
             * @param val 值
             * @returns {string|*} 格式化后的值
             */
            resultFormat: function (val) {
                if (val || val === 0) {
                    return val;
                } else {
                    return '-';
                }
            },
        },
        methods: {

            /**
             * 初始化
             */
            init: function () {
                //查询最大时间
                let _this = this;
                AjaxUtil.sendAjax("getMaxTime.vm", null,function (result){
                    _this.params.startTime=result.data.START_TIME;
                    _this.params.endTime=result.data.END_TIME;
                  //  _this.doSearch();
                    _this.queryModelList();
                },null,null)
            },
            getAqiColor: function (aqi) {
                if (!aqi) {
                    return "#999"
                }
                if (aqi >= 0 && aqi <= 50) {
                    return '#93CE07';
                } else if (aqi > 50 && aqi <= 100) {
                    return '#FBDB0F'
                } else if (aqi > 100 && aqi <= 150) {
                    return '#FC7D02'
                } else if (aqi > 150 && aqi <= 200) {
                    return '#FD0100'
                } else if (aqi > 200 && aqi <= 300) {
                    return '#AA069F'
                } else {
                    return '#AC3B2A';
                }
            },
            stepTo(num) {
                this.params.timeStep = num;
                $("#selTimeStep").val(num);
                this.doSearch();
                for (let i = 0; i < this.ybdList.length; i++) {
                    if (num == this.ybdList[i].value) {
                        this.ybdList[i].select = "checked";
                    } else {
                        this.ybdList[i].select = "";
                    }
                }
            },
            /**
             * 根据type修改id
             * @param type
             */
            chooseAssessType: function (type) {
                var _this = this;
                _this.type = type;
                _this.params.timeStep = _this.$options.data().params.timeStep;
                $(".assess-type").attr('id', '');
                if (type == 'ZJPG') {
                    $('.assess-type').attr('id', 'zj-assess');
                    _this.ybdList = _this.$options.data().ybdList;
                    _this.clearData();
                    _this.doSearch();
                } else if (type == 'MSPG') {
                    $('.assess-type').attr('id', 'ms-assess');
                    _this.clearData();
                    _this.queryModelList();
                } else if (type == 'GRPG') {
                    $('.assess-type').attr('id', 'gr-assess');
                    _this.ybdList = _this.$options.data().ybdList;
                    _this.clearData();
                    _this.queryPersonList();
                }
            },
            /**
             * 切换时，清除数据
             */
            clearData:function (){
              let _this=this;
              _this.myChart='';
              _this.mychartpm25='';
              _this.mycharto3='';
              _this.echartData=[];
              _this.tableList=[];
              _this.colArr=[];
            },
            /**
             * 获取model列表
             */
            queryModelList:function (){
                let _this = this;
                AjaxUtil.sendAjax("getForecastModel.vm",null,function (result){
                  _this.modelList=result.data;
                  _this.params.modelName=_this.modelList[0].code;
                  _this.params.days=_this.modelList[0].step;
                  _this.getYbdList();
              },null,null)
            },
            /**
             * 配置ybdList
             */
            getYbdList:function (){
                let _this = this;
                let temp = [];
                for (let i = 0; i < _this.params.days; i++) {
                    if (i === 0){
                        temp.push({select: "checked", value: i+1});
                    }else {
                        temp.push({select: "", value: i+1});
                    }
                }
                _this.ybdList = temp;
                _this.doSearch();
            },
            /**
             * 模型切换
             */
            changeModel:function (){
                let _this = this;
                if (_this.params.modelName == 'CFS' || _this.params.modelName == 'CMA'){
                   _this.params.timeType = '0';
                }
                if (_this.params.modelName == 'CFS'){
                    _this.params.days = 35;
                } else  if(_this.params.modelName == 'CMA'){
                    _this.params.days = 8;
                }else {
                    _this.params.days = 14;
                }
                _this.getYbdList();
            },
            /**
             * 多选回调
             */
            changeCheckBox: function () {
                var data =this.personList;
                var names = [];
                $.each(data, function (index, item) {
                    if (item.checked) {
                        names.push(item.userName);
                    }
                });
                this.params.userNames = names.join(",");
                this.doSearch()
            },
            /**
             * 获取预报人员列表
             */
            queryPersonList:function (){
                let _this = this;
                AjaxUtil.sendAjax("getForecastUser.vm",null,function (result){
                   _this.personList=result.data;
                   _this.personList[0].checked=true;
                   _this.params.userNames=_this.personList[0].userName;
                   _this.params.userName=_this.personList[0].userName;
                   _this.doSearch();
                },null,null)
            },

            /**
             * 查询
             */
            doSearch:function (){
                const _this = this;
                _this.loadEcharts();
                _this.loadTableInfo();
            },

            // 加载Echats组件
            loadEcharts: function () {
                var _this = this;
                var data = {
                    START_TIME: _this.params.startTime,
                    END_TIME: _this.params.endTime,
                    TIME_STEP: _this.params.timeStep,
                    modelName:_this.params.modelName,
                    userNames:_this.params.userNames,
                    userName:_this.params.userName,
                    type:_this.type,
                    timeType: _this.params.timeType
                };
                $.ajax({
                    url: 'getForecastCheckEchartsData.vm',
                    isShowLoader: true,
                    type: 'post',
                    data: data,
                    dataType: 'json',
                    success: function (result) {
                        if (result.code == 200 && result.data) {
                            _this.echartData=result.data;
                            // 使用刚指定的配置项和数据显示图表。
                            _this.myChart = echarts.init(document.getElementById('mychart'));
                            _this.myChart.setOption(_this.getEchartsOption(_this.echartData[0], 'AQI'), true);
                            _this.mychartpm25 = echarts.init(document.getElementById('mychartpm25'));
                            _this.mychartpm25.setOption(_this.getEchartsOption(_this.echartData[1], 'PM₂.₅'), true);
                            _this.mycharto3 = echarts.init(document.getElementById('mycharto3'));
                            _this.mycharto3.setOption(_this.getEchartsOption(_this.echartData[2], 'O₃'), true);
                            _this.yubaoshuju(_this.echartData[0].forecastCheckList);
                            $(window).resize(function () {
                                _this.mychartpm25.resize();
                                _this.myChart.resize();
                                _this.mycharto3.resize();
                            });
                            _this.getScatterPlotEcharts(_this.echartData[0].scatterPlot, "mycharts",'AQI');
                            _this.getScatterPlotEcharts(_this.echartData[1].scatterPlot, "mychartpm25s",'PM₂.₅');
                            _this.getScatterPlotEcharts(_this.echartData[2].scatterPlot, "mycharto3s",'O₃');
                        }
                    },
                    error: function () {
                        showMessageDialog('网络连接失败！');
                    },
                });
            },
            // 组织Echarts配置参数
            getScatterPlotEcharts: function (data, id,pType) {
                let list = [];
                for (let i = 0; i < data.list.length; i++) {
                    if (data.list[i][0] && data.list[i][1]){
                        list.push(data.list[i]);
                    }
                }
                var myChart = echarts.init(document.getElementById(id));
                var markLineOpt = {
                    animation: false,

                    lineStyle: {
                        type: 'solid'
                    },
                    data: [
                        [{
                            label: {
                                formatter: '实测值=0.5*预报值',
                                align: 'right'
                            },
                            tooltip: {
                                formatter: '实测值=0.5*预报值'
                            },
                            coord: [0, 0],
                            symbol: 'none'
                        }, {
                            coord: [data.max, data.max * 0.5],
                            symbol: 'none'
                        }], [{
                            label: {
                                formatter: '实测值=2*预报值',
                                align: 'right'
                            },
                            tooltip: {
                                formatter: '实测值=2*预报值'
                            },
                            coord: [0, 0],
                            symbol: 'none'
                        }, {
                            coord: [data.max * 0.5, data.max],
                            symbol: 'none'
                        }], [{
                            label: {
                                formatter: '实测值=预报值',
                                align: 'right'
                            },
                            tooltip: {
                                formatter: '实测值=预报值'
                            },
                            coord: [0, 0],
                            symbol: 'none'
                        }, {
                            coord: [data.max, data.max],
                            symbol: 'none'
                        }]]
                };
                let option = {
                    color:["#5470c6"],
                    tooltip: {
                        formatter: '类型：' + pType + '<br/>' + '数据：' + '{c}'
                    },
                    xAxis: {gridIndex: 0, min: 0, max: data.max, name: '预测'},
                    yAxis: {gridIndex: 0, min: 0, max: data.max, name: '实测'},
                    series: [{
                        symbolSize: 20,
                        data: list,
                        markLine: markLineOpt,
                        type: 'scatter'
                    }]
                };
                myChart.setOption(option, true);
                $(window).resize(function () {
                    myChart.resize();
                });
            },
            getEchartsOption: function (data, titleName) {
                let _this = this;
                // 指定图表的配置项和数据
                var option = {
                    title: {
                        text: titleName + ' 预报实测对比图',
                        x: 'center'
                    },
                    color: ['#91cc75', '#ee6666', '#73c0de', 'grey', 'black'],
                    tooltip: {
                        trigger: 'axis',
                        axisPointer: { // 坐标轴指示器，坐标轴触发有效
                            type: 'shadow' // 默认为直线，可选为：'line' | 'shadow'
                        },
                        formatter: function (params) {
                            var tar;
                            if (params[1].value != '-') {
                                tar = parseInt(params[1].value) + parseInt(params[0].value);
                            } else if (params[2].value != '-') {
                                tar = parseInt(params[2].value) + parseInt(params[0].value);
                            } else if (params[3].value != '-') {
                                tar = parseInt(params[3].value) + parseInt(params[0].value);
                            } else if (params[4].value != '-') {
                                tar = parseInt(params[4].value) + parseInt(params[0].value);
                            } else {
                                tar = '-';
                            }

                            return params[0].name + '<br/>' + params[0].seriesName
                                + ' : ' + params[0].value + '~' + tar + '<br/>'
                                + params[5].seriesName + ' : '
                                + params[5].value;
                        }

                    },
                    legend: {
                        data: ['预报正确', '高于实测', '低于实测', '无实时数据', '实况'],
                        top: "7%",
                    },
                    grid: [
                        {left: '5%', width: '90%'}
                    ],
                    xAxis: {
                        type: 'category',
                        splitLine: {
                            show: false
                        },
                        data: data.xAxisData
                    },
                    yAxis: {
                        name: titleName != 'AQI' ? (titleName + '(μg/m³)') : titleName,
                        type: 'value',
                    },
                    dataZoom: [{
                        type: 'slider',

                    }],
                    series: [
                        {
                            name: titleName,
                            type: 'bar',
                            stack: '总量',
                            barMaxWidth: 30,// 柱图最大宽度
                            itemStyle: {
                                normal: {
                                    barBorderColor: 'rgba(0,0,0,0)',
                                    color: 'rgba(0,0,0,0)'
                                },
                                emphasis: {
                                    barBorderColor: 'rgba(0,0,0,0)',
                                    color: 'rgba(0,0,0,0)'
                                }
                            },
                            data: data.baseList
                        },
                        {
                            name: '预报正确',
                            type: 'bar',
                            stack: '总量',
                            data: data.forcastTrueList,
                            itemStyle: {
                                opacity: 0.5,
                                borderRadius: [34, 34, 34, 34]
                            }
                        },
                        {
                            name: '高于实测',
                            type: 'bar',
                            stack: '总量',
                            data: data.forcastUpList,
                            itemStyle: {
                                opacity: 0.5,
                                borderRadius: [34, 34, 34, 34]
                            }
                        },
                        {
                            name: '低于实测',
                            type: 'bar',
                            stack: '总量',
                            data: data.forcastDownList,
                            itemStyle: {
                                opacity: 0.5,
                                borderRadius: [34, 34, 34, 34]
                            }
                        },
                        {
                            name: '无实时数据',
                            type: 'bar',
                            stack: '总量',
                            data: data.forcastNoneList,
                            itemStyle: {
                                opacity: 0.5,
                                borderRadius: [34, 34, 34, 34]
                            }
                        },
                        {
                            name: '实况',
                            type: 'line',
                            smooth: true,
                            label: {
                                normal: {
                                    show: true,
                                    position: 'inside',
                                    color: 'black',
                                    position: 'top'
                                }
                            },
                            data: data.monitorList
                        },
                        ]
                };

                return option;
            },
            //污染物预测--等级预测
            yubaoshuju: function (data) {
                var _this = this;
                var pulls = ["PM2.5", "PM10", "CO", "SO2", "NO2", "O3_8", "无"];
                var aqiLevel = ["优", "良", "轻度污染", "中度污染", "重度污染", "严重污染", "无数据"];
                var xdata = [];
                var pullSeries = [];
                var aqiSeries = [];
                //封装x轴时间
                for (let i = 0; i < data.length; i++) {
                    xdata.push(data[i].RESULT_TIME);
                }
                //遍历主要污染物
                for (let m = 0; m < pulls.length; m++) {
                    var ybPullData = [];
                    var scPullData = [];
                    var ybAqiData = [];
                    var scAqiData = [];
                    for (let i = 0; i < data.length; i++) {
                        //封装主要污染源预报数据
                        if (pulls[m] == '无' && (data[i].PRIM_POLLUTE == null || data[i].PRIM_POLLUTE == '' || data[i].PRIM_POLLUTE == '--')) {
                            ybPullData.push(10);
                        } else if (pulls[m] != '无' && data[i].PRIM_POLLUTE && pulls[m].indexOf(data[i].PRIM_POLLUTE) >= 0) {
                            ybPullData.push(10);
                        } else {
                            ybPullData.push(0);
                        }
                        //封装主要污染源实况数据
                        if (pulls[m] == '无' && (data[i].SPRIMPOLLUTE == null || data[i].SPRIMPOLLUTE == '' || data[i].SPRIMPOLLUTE == '--')) {
                            scPullData.push(10);
                        } else if (pulls[m] != '无' && data[i].SPRIMPOLLUTE != null && data[i].SPRIMPOLLUTE.indexOf(pulls[m]) >= 0) {
                            scPullData.push(10);
                        } else {
                            scPullData.push(0);
                        }
                        //封装空气质量等级预测数据
                        if (aqiLevel[m] == '无数据' && (data[i].AQI_LEVEL == null || data[i].AQI_LEVEL == '')) {
                            ybAqiData.push(10);
                        } else if (aqiLevel[m] != '无' && data[i].AQI_LEVEL != null && data[i].AQI_LEVEL.indexOf(aqiLevel[m].replace('污染','')) >= 0) {
                            ybAqiData.push(10);
                        } else {
                            ybAqiData.push(0);
                        }
                        //封装空气质量等级实况数据
                        if (aqiLevel[m] == '无数据' && (data[i].AQILEVELSTATE == null || data[i].AQILEVELSTATE == '')) {
                            scAqiData.push(10);
                        } else if (aqiLevel[m] != '无' && data[i].AQILEVELSTATE != null && data[i].AQILEVELSTATE.indexOf(aqiLevel[m].replace('污染','')) >= 0) {
                            scAqiData.push(10);
                        } else {
                            scAqiData.push(0);
                        }
                    }
                    pullSeries.push({
                        data: ybPullData,
                        name: pulls[m],
                        stack: "预计",
                        type: "bar",
                        xAxisIndex: "1",
                        yAxisIndex: "1",
                    });
                    pullSeries.push({
                        data: scPullData,
                        name: pulls[m],
                        stack: "实际",
                        type: "bar",
                    });
                    aqiSeries.push({
                        data: ybAqiData,
                        name: aqiLevel[m],
                        stack: "预计",
                        type: "bar",
                        xAxisIndex: "1",
                        yAxisIndex: "1",
                    });
                    aqiSeries.push({
                        data: scAqiData,
                        name: aqiLevel[m],
                        stack: "实际",
                        type: "bar",
                    });
                }
                var pfChart = echarts.init(document.getElementById('pollutant-forecast'));
                var lfChart = echarts.init(document.getElementById('level-forecast'));
                var pfOption = {
                    title: {
                        text: '主要污染物预测',
                        left: 80
                    },
                    tooltip: {
                        trigger: 'axis',
                        axisPointer: {            // 坐标轴指示器，坐标轴触发有效
                            type: 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                        },
                        formatter: function (params) {
                            var forecast = new Array(), actual = new Array();
                            for (var i = 0; i < params.length; i++) {
                                if (params[i].axisIndex == 0 && params[i].value == 10) {
                                    actual.push(_this.getSub(params[i].seriesName))
                                } else if (params[i].axisIndex == 1 && params[i].value == 10) {
                                    forecast.push(_this.getSub(params[i].seriesName))
                                }
                            }
                            return params[0].name + "<br>预测污染物：" + forecast + "<br>实测污染物：" + actual;
                        }
                    },
                    legend: {
                        formatter: function (name) {
                            return _this.getSub(name);
                        },
                        data: pulls,
                        top: 20
                    },
                    grid: [
                        {left: '7.5%', width: '85%'},
                        {left: '7.5%', width: '85%'}
                    ],
                    xAxis: [
                        {
                            type: 'category',
                            data: xdata,
                            name: '实测',
                            nameLocation: 'start',
                            nameTextStyle: {
                                padding: [0, 0, 50, 0]
                            }
                        },
                        {
                            type: 'category',
                            data: xdata,
                            name: '预测',
                            nameLocation: 'start',
                            nameTextStyle: {
                                padding: [0, 0, 200, 0]
                            },
                            axisLabel: {
                                show: false
                            }
                        }
                    ],
                    yAxis: [
                        {
                            type: 'value',
                            max: 50,
                            axisTick: {
                                show: false
                            },
                            axisLabel: {
                                show: false
                            }
                        },
                        {
                            type: 'value',
                            max: 50,
                            inverse: true,
                            axisTick: {
                                show: false
                            },
                            axisLabel: {
                                show: false
                            }
                        }
                    ],
                    color: ['#E17F50', '#C63500', '#DA70D6', '#E1EA00', '#3549BD', '#87CEFA', '#AAAAAA'],
                    dataZoom: [
                        {
                            id: 'test',
                            type: 'slider',
                            show: false,
                            xAxisIndex: [0, 1]
                        }
                    ],
                    series: pullSeries
                };
                pfChart.setOption(pfOption);
                var lfOption = {
                    title: {
                        text: '空气质量等级预测',
                        left: 80
                    },
                    tooltip: {
                        trigger: 'axis',
                        axisPointer: {            // 坐标轴指示器，坐标轴触发有效
                            type: 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                        },
                        formatter: function (params) {
                            var forecast = new Array(), actual = new Array();
                            for (var i = 0; i < params.length; i++) {
                                if (params[i].axisIndex == 0 && params[i].value == 10) {
                                    actual.push(params[i].seriesName)
                                } else if (params[i].axisIndex == 1 && params[i].value == 10) {
                                    forecast.push(params[i].seriesName)
                                }
                            }
                            return params[0].name + "<br>预测空气质量等级：" + forecast + "<br>实测空气质量等级：" + actual;
                        }
                    },
                    legend: {
                        data: aqiLevel,
                        top: 20
                    },
                    grid: [
                        {left: '7.5%', width: '85%'},
                        {left: '7.5%', width: '85%'}
                    ],
                    xAxis: [
                        {
                            type: 'category',
                            data: xdata,
                            name: '实测',
                            nameLocation: 'start',
                            nameTextStyle: {
                                padding: [0, 0, 50, 0]
                            }
                        },
                        {
                            type: 'category',
                            data: xdata,
                            name: '预测',
                            nameLocation: 'start',
                            nameTextStyle: {
                                padding: [0, 0, 200, 0]
                            },
                            axisLabel: {
                                show: false
                            }
                        }
                    ],
                    yAxis: [
                        {
                            type: 'value',
                            max: 50,
                            axisTick: {
                                show: false
                            },
                            axisLabel: {
                                show: false
                            }
                        },
                        {
                            type: 'value',
                            max: 50,
                            inverse: true,
                            axisTick: {
                                show: false
                            },
                            axisLabel: {
                                show: false
                            }
                        }
                    ],
                    color: ['rgb(0,228,0)', 'rgb(255,255,0)', 'rgb(255,126,0)', 'rgb(255,0,0)', 'rgb(153,0,76)', 'rgb(126,0,35)', '#AAAAAA'],
                    dataZoom: [
                        {
                            id: 'test',
                            type: 'slider',
                            show: true,
                            xAxisIndex: [0, 1]
                        }
                    ],
                    series: aqiSeries
                };
                lfChart.setOption(lfOption);
                echarts.connect([pfChart, lfChart]);
                //图表随窗口大小的变化而变化
                $(window).resize(function () {
                    pfChart.resize();
                    lfChart.resize();
                });
            },
            getSub: function (d) {
                if (d == "PM2.5") {
                    return "PM₂.₅"
                } else if (d == "PM10") {
                    return "PM₁₀"
                } else if (d == "O3" || d == "O3-1小时") {
                    return "O₃"
                } else if (d == "O3_8") {
                    return "O₃-8h"
                } else if (d == "NO2") {
                    return "NO₂"
                } else if (d == "SO2") {
                    return "SO₂"
                } else if (d == "PM25") {
                    return "PM₂.₅"
                } else if (d == undefined) {
                    return "-"
                } else {
                    return d
                }
            },
            // 加载列表数据
            loadTableInfo : function() {
                var _this = this;
                var data = {
                    START_TIME: _this.params.startTime,
                    END_TIME: _this.params.endTime,
                    TIME_STEP: _this.params.timeStep,
                    modelName:_this.params.modelName,
                    userNames:_this.params.userNames,
                    userName:_this.params.userName,
                    type:_this.type,
                    timeType: _this.params.timeType,
                    //预报时长
                    days:_this.params.days,
                };
                $.ajax({
                    url : 'getForecastTableData.vm',
                    isShowLoader : true,
                    type : 'post',
                   // async : false,
                    data : data,
                    dataType : 'json',
                    success : function(result) {
                        _this.tableList=result.data.data;
                        _this.colArr=result.data.col;

                    },
                    error : function() {
                        showMessageDialog('网络连接失败！');
                    },
                });
            },
            /**
             * 时间开始
             */
            queryTimeStart : function(){
                var _this = this;
                WdatePicker({
                    dateFmt : 'yyyy-MM-dd',
                    el : 'queryTimeStart',
                    maxDate : '#F{$dp.$D(\'queryTimeEnd\')}',
                    isShowClear : true,
                    onpicking:function(dp){
                        _this.params.startTime=dp.cal.getNewDateStr();
                    },
                    onclearing:function(){
                        _this.params.startTime='';
                    },
                    readOnly : true
                });
            },
            /**
             * 结束时间
             */
            queryTimeEnd : function(){
                var _this = this;
                WdatePicker({
                    dateFmt : 'yyyy-MM-dd',
                    el : 'queryTimeEnd',
                    minDate : '#F{$dp.$D(\'queryTimeStart\')}',
                    isShowClear : true,
                    onpicking:function(dp){
                        _this.params.endTime=dp.cal.getNewDateStr();
                    },
                    onclearing:function(){
                        _this.params.endTime='';
                    },
                    readOnly : true
                });
            },
        }
    });

// 公共提示框
function showMessageDialog(msg) {
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
}

// 公共提示框
function showTimeoutMessageDialog(msg, time) {
    var d = dialog({
        icon: "fa-warning",
        wraperstyle: 'alert-warning',
        title: "警告",
        content: "<b>" + msg + "</b>"
    });
    d.showModal();
    setTimeout(function () {
        d.close().remove();
    }, time);
}


var vue = new Vue({
    el: '#main-container',
    data: {
        url: {
            //获取模型列表
            getModelList:ctx + '/analysis/forecast/airforecastcheck/airForecastCheck/getForecastModel.vm',
            getDayList: ctx + '/analysis/air/modelwqDayRow/getDayList.vm',
            getRegionAndPoint: ctx+'/analysis/air/modelwqDayRow/getRegionAndPoint.vm',
            getEchartsData: ctx + '/analysis/calendar/forecast/getEchartsData.vm',
            exportExcel: ctx + '/analysis/calendar/forecast/exportExcel.vm',
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
        month: '',
        thisYMD: '',
        regionAndPointList: {},
        myChart_0: null,
        myChart_12: null,
        cityNums:cityNums,
        modelList:[],
        model:'GFS'

    },
    /**
     * 页面加载完后调用
     */
    mounted: function () {
        // 注册表单验证
        $('#mainForm').validationEngine({
            scrollOffset: 98,
            // 提示框位置为下左
            promptPosition: 'bottomLeft',
            // 自动隐藏提示框
            autoHidePrompt: true,
            // 不可见字段验证
            validateNonVisibleFields: true
        });
        this.getModelList();
        this.monthClick();
        this.getRegionAndPointData();

    },
    methods: {

        changeModel:function (){
            let _this = this;
            let month= null;
            let chooseDayIndex='';
            if (_this.thisYMD){
                month = _this.thisYMD.substring(0,7);
                chooseDayIndex = _this.thisYMD.substring(8,10);
            }
            _this.monthClick(month,chooseDayIndex);
        },
        /**
         * 获取模型信息
         */
        getModelList:function (){
            let _this = this;
            AjaxUtil.sendAjaxRequest(_this.url.getModelList, null, {
            }, function (json) {
                _this.modelList = json.data;
            });
        },
        /**
         * 月份切换
         * @param month
         */
        monthClick: function (month,chooseDayIndex) {
            var _this = this;
            AjaxUtil.sendAjaxRequest(_this.url.getDayList, null, {
                model: _this.model,
                month: month
            }, function (json) {
                var dataList = json.data;
                var data = dataList[0];
                // 填报月份
                _this.month = data.MODELTIME.substring(0, 7);
                // 当传递的月份为空时，重新赋予最大月份的值
                _this.timeAxis.next.limit = DateTimeUtil.getNowDate().substring(0,7);
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
         * 查询区县、点位信息
         */
        getRegionAndPointData: function () {
            let _this = this;
            AjaxUtil.sendAjaxRequest(_this.url.getRegionAndPoint, null, {}, function (json) {
                _this.regionAndPointList = json.data;
            });
        },
        /**
         * 获取模型名称
         * @returns {string|*}
         */
        getModelName:function (){
            let _this = this;
            for (let i = 0; i < _this.modelList.length; i++) {
                if (_this.modelList[i]['code'] == _this.model){
                    return _this.modelList[i]['name'];
                }
            }
            return '';
        },
        /**
         * 导出
         */
        exportExcel: function () {
            let _this = this;
            let url = _this.url.exportExcel;
            let params = {
                modelTime: _this.thisYMD,
                model: _this.model,
                cityNums:_this.cityNums,
                excelName: (_this.cityNums == 4 ? '成德眉资都市圈' : '成都平原八市') + _this.getModelName() + "预报日历-" + _this.thisYMD + ".xlsx"
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
                cityNums:_this.cityNums,
                model: _this.model,
            }, function (json) {
                if(json.data.list12.length <= 0 && json.data.list0.length <= 0){
                    _this.showMessageDialog("暂无数据！");
                }
                _this.table12 = json.data.list12
                _this.table0 = json.data.list0
                _this.splicingEchartsdata();
            });
        },
        /**
         *拼接echarts的数据
         */
        splicingEchartsdata: function () {
            const _this = this;
            let key = ["twelve", "zero"];
            let arr = [_this.table12, _this.table0];
            if (_this.myChart_0) {
                _this.myChart_0.dispose()
            }
            if (_this.myChart_12) {
                _this.myChart_12.dispose()
            }
            if (_this.model == 'CFS' || _this.model == 'CMA'){
                key = ["zero"];
                arr = [_this.table0];
            }
            for (let i = 0; i < key.length; ++i) {
                _this.initEcharts(key[i], _this.getMapDate(arr[i]));
            }
        },
        getMapDate: function (data) {
            let forecastTime = []; //时间
            let addressName = [];//地点
            let ThermalData = [];
            let ScatteredData = [];
            let name = '预报时次：';
            data.map(function (item) {
                forecastTime.push(item.resulttime);
                addressName.push(item.regionName);
                ThermalData.push([item.resulttime, item.regionName, item.aqiMin]);
                ScatteredData.push([item.resulttime, item.regionName, item.aqiMax]);

            })
            if (data.length > 0) {
                name += data[0].modeltime + '时';
            } else {
                name += '暂无此类数据';
            }
            forecastTime = Array.from(new Set(forecastTime));
            addressName = Array.from(new Set(addressName));
            return {
                forecastTime, addressName, ThermalData, ScatteredData, name
            }
        },
        /**
         * echarts初始化
         */
        initEcharts: function (id, {forecastTime, addressName, ThermalData, ScatteredData, name}) {
            const option = {
                grid: {
                    height: '70%',
                    top: '10%',
                    show: 'true',
                },
                //下载配置
                toolbox: {
                    top: 30,
                    right: 50,
                    feature: {
                        saveAsImage: {}
                    }
                },
                xAxis: {
                    type: 'category',
                    axisLabel: {
                        rotate: 45,
                    },
                    data: forecastTime,
                    splitArea: {
                        show: true
                    },
                    splitLine: {
                        show: true,
                        lineStyle: {
                            color: ['#B3B3B3'],
                            width: '5',
                            type: 'solid'
                        }
                    }
                },
                yAxis: {
                    name: name,
                    nameTextStyle: {
                        padding: [0, 0, 0, 158]    // 四个数字分别为上右下左与原位置距离
                    },
                    type: 'category',
                    data: addressName,
                    splitArea: {
                        show: true
                    },
                    splitLine: {
                        show: true,
                        lineStyle: {
                            color: ['#B3B3B3'],
                            width: '5',
                            type: 'solid'
                        }
                    },
                    triggerEvent: true
                },
                visualMap: {
                    left: 80,
                    bottom: 50,
                    realtime: false,
                    show: false,
                    pieces: [
                        {gt: 0, lte: 50},
                        {gt: 50, lte: 100},
                        {gt: 100, lte: 150},
                        {gt: 150, lte: 200},
                        {gt: 200, lte: 300},
                        {gt: 300}
                    ],
                    inRange: {
                        color: ['rgb(0,228,0)', 'rgb(255,255,0)', 'rgb(255,126,0)', 'rgb(255,0,0)', 'rgb(153,0,76)', 'rgb(126,0,35)']
                    },
                    outOfRange: {
                        color: ['#fff'],
                    },
                },
                series: [{
                    name: '外层',
                    type: 'heatmap',
                    data: ThermalData,
                    label: {
                        show: false
                    },
                    emphasis: {
                        itemStyle: {
                            shadowBlur: 10,
                            shadowColor: 'rgba(0, 0, 0, 0.5)'
                        }
                    }
                }, {
                    name: '内层',
                    type: 'scatter',
                    data: ScatteredData,
                    symbol: 'rect',
                    symbolSize: 20,
                    label: {
                        show: false
                    },
                    emphasis: {
                        itemStyle: {
                            shadowBlur: 10,
                            shadowColor: 'rgba(0, 0, 0, 0.5)'
                        }
                    }
                }]
            };
            let _this = this;
            if (id == 'zero'){
                _this.myChart_0 = echarts.init(document.getElementById(id));
                _this.myChart_0.on("click", function (param) {
                    if (param.value && typeof(param.value) =='string'){
                        _this.openForecastPage(param)
                    }
                })
                _this.myChart_0.setOption(option);
            }else {
                _this.myChart_12 = echarts.init(document.getElementById(id));
                _this.myChart_12.on("click", function (param) {
                    if (param.value && typeof(param.value) =='string'){
                        _this.openForecastPage(param)
                    }
                })
                _this.myChart_12.setOption(option);
            }
        },
        /**
         * 打开14天预报页面
         */
        openForecastPage:function (param){
            let _this = this;
            let regionList = _this.regionAndPointList['REGION'];
            let regionCode = '';
            for (let i = 0; i < regionList.length; i++) {
                if (regionList[i]['NAME'] === param.value){
                    regionCode = regionList[i]['CODE'];
                }
            }
            let model = _this.model;
            let modelTime = _this.thisYMD;
            let url = '/dyh_analysis/analysis/air/fourteenDaysForecast/toFourteenDaysForecastNew.vm?model='+model+'&modelTime='+modelTime+'&pointCode='+regionCode+'&pointName='+param.value;
            window.open(url);
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

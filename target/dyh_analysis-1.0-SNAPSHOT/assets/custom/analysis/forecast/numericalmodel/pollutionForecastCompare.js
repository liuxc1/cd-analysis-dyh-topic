let vue = new Vue({
    el: '#main-container',
    data: {
        url: {
            getMaxDate: ctx + '/analysis/air/pollutionForecastCompare/getMaxDate.vm',
            getEchartsData: ctx + '/analysis/air/pollutionForecastCompare/getEchartsData.vm',
            exportExcel: ctx + '/analysis/air/pollutionForecastCompare/exportExcel.vm',
            getRegionAndPoint: ctx + '/analysis/air/modelwqDayRow/getRegionAndPoint.vm',
        },
        queryParams: {
            forecastTimeStart: '',
            forecastTimeEnd: '',
            model: 'CDAQS_MT',
            pointName: '成都市',
            pointCode: '510100000000'

        },
        regionAndPointList: [],
        defaultDataType : 'REGION'
    },
    /**
     * 页面加载完后调用
     */
    mounted: function () {
        this.getMaxDate();
        this.getRegionAndPointData();

    },
    methods: {
        /**
         * 查询成都市最新时间
         */
        getMaxDate: function () {
            let _this = this;
            AjaxUtil.sendAjaxRequest(_this.url.getMaxDate, null, {
                model: _this.queryParams.model,
                regionCode: _this.queryParams.regionCode
            }, function (result) {
                _this.queryParams.forecastTimeStart = result.data.startDate;
                _this.queryParams.forecastTimeEnd = result.data.endDate;
                _this.doSearch();
            }, function () {
            }, function () {
            })
        },
        /**
         * 查询站点
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
        checkRegionAndPoint: function () {
            var _this = this;
            $.dataChoose({
                title: '行政区或者站点',
                single: true,
                dataTypes: ['REGION', 'POINT'],
                dataTypeNames: ['行政区', '站点'],
                isCheckParent: true, // 是否可选父节点
                defaultDataType:  _this.defaultDataType,
                dataCodes: _this.queryParams.pointCode,
                data: _this.regionAndPointList,
                callback: function (dataType, nodeArray) {
                    _this.defaultDataType = dataType;
                    _this.queryParams.pointCode = nodeArray[0].CODE;
                    _this.queryParams.pointName = nodeArray[0].NAME;
                }
            });
        },
        /**
         * 查询所有echarts的数据
         */
        doSearch: function () {
            let _this = this;
            let days = parseInt((new Date(_this.queryParams.forecastTimeEnd).getTime() / 1000 - new Date(_this.queryParams.forecastTimeStart).getTime() / 1000) / 60 / 60 / 24);
            if (days > 14) {
                DialogUtil.showTipDialog("预报日期范围必须≤14天，请重新选择预报日期！");
                return;
            }
            AjaxUtil.sendAjaxRequest(_this.url.getEchartsData, null, {
                startTime: _this.queryParams.forecastTimeStart,
                endTime: _this.queryParams.forecastTimeEnd,
                model: _this.queryParams.model,
                pointCode: _this.queryParams.pointCode
            }, function (result) {
                let option_12_pm25=_this.loadEcharts(result.data.twelve, '近期PM₂.₅浓度预报结果',  'PM25', 'PM₂.₅Concentration(μg/m³)');
                let option_00_pm25=_this.loadEcharts(result.data.zero, '近期PM₂.₅浓度预报结果', 'PM25', 'PM₂.₅Concentration(μg/m³)');
                let option_12_o3=_this.loadEcharts(result.data.twelve, '近期O₃8小时滑动最大浓度预报结果',  'O3_8', 'O₃8Max Concentration(μg/m³)');
                let option_00_o3=_this.loadEcharts(result.data.zero, '近期O₃8小时滑动最大浓度预报结果', 'O3_8', 'O₃8Max Concentration(μg/m³)' );
                _this.drawChart(option_12_pm25,option_00_pm25,option_12_o3,option_00_o3);
            });
        },
        /**
         * 绘制ECharts图
         */
        drawChart(option_12_pm25, option_00_pm25,option_12_o3,option_00_o3) {
            let myChart_pm25_12 = echarts.init(document.getElementById('pm25_12'));
            let myChart_pm25_0 = echarts.init(document.getElementById('pm25_0'));
            let myChart_o3_12 = echarts.init(document.getElementById('o3_8_12'));
            let myChart_o3_0 = echarts.init(document.getElementById('o3_8_0'));

            // 为echarts对象加载数据
            myChart_pm25_12.setOption(option_12_pm25);
            myChart_pm25_0.setOption(option_00_pm25);
            myChart_o3_12.setOption(option_12_o3);
            myChart_o3_0.setOption(option_00_o3);

            //页面宽度变化的时候resize
            window.addEventListener("resize", function () {
                myChart_pm25_12.resize();
                myChart_pm25_0.resize();
                myChart_o3_12.resize();
                myChart_o3_0.resize();
            });
        },
        /**
         * 加载echarts
         */
        loadEcharts: function (data, title, dataType, yName) {
            let modelTimeList = [];
            let resultTimeList = [];
            let sData = [];
            for (let i = 0; i < data.length; i++) {
                if (data[i + 1] == null || data[i].MODELTIME !== data[i + 1].MODELTIME) {
                    modelTimeList.push(data[i].MODELTIME);
                }
                if (data[i] == null || resultTimeList.indexOf(data[i].RESULTTIME) === -1) {
                    resultTimeList.push(data[i].RESULTTIME);
                }
            }
            for (let m = 0; m < modelTimeList.length; m++) {
                let slData = [];
                for (let n = 0; n < data.length; n++) {
                    if (data[n].MODELTIME === modelTimeList[m]) {
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
                    top: '10%',
                    bottom: '10%',
                    right: '16%',
                    left: '8%',
                    show: 'true',
                    borderWidth: '2',
                    borderColor: '#D3D3D3',
                },
                legend: {
                    itemWidth: 15,
                    itemHeight: 15,
                    align: 'left',
                    orient: 'vertical',
                    x: 'right',
                    top: 40,
                    textStyle: {
                        fontSize: 14
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
        /**
         * 导出
         * @returns {string}
         */
        exportExcel: function () {
            let _this = this;
            let url = 'exportExcel.vm';
            let params = {
                startTime: _this.queryParams.forecastTimeStart,
                endTime: _this.queryParams.forecastTimeEnd,
                model: _this.queryParams.model,
                pointCode: _this.queryParams.pointCode,
                excelName: "近期污染物预报比较.xlsx"
            };
            FileDownloadUtil.createSubmitTempForm(url, params);
        },

        /**
         * 预报开始时间
         */
        forecastTimeStart: function () {
            let _this = this;
            WdatePicker({
                // 回显数据的对象ID
                el: 'forecastTimeStart',
                // 时间格式
                dateFmt: 'yyyy-MM-dd',
                // 是否显示清除按钮
                isShowClear: false,
                // 只读
                readOnly: true,
                // 最大时间限制，参考：http://www.my97.net/demo/index.htm
                maxDate: '#F{$dp.$D(\'forecastTimeEnd\')}',
                onpicking: function (dp) {
                    _this.queryParams.forecastTimeStart = dp.cal.getNewDateStr();
                },
                onclearing: function () {
                    _this.queryParams.forecastTimeStart = '';
                }
            });
        },
        /**
         * 预报结束时间
         */
        forecastTimeEnd: function () {
            let _this = this;
            WdatePicker({
                // 回显数据的对象ID
                el: 'forecastTimeEnd',
                // 时间格式
                dateFmt: 'yyyy-MM-dd',
                // 是否显示清除按钮
                isShowClear: false,
                // 只读
                readOnly: true,
                // 最大时间限制，参考：http://www.my97.net/demo/index.htm
                minDate: '#F{$dp.$D(\'forecastTimeStart\')}',
                onpicking: function (dp) {
                    _this.queryParams.forecastTimeEnd = dp.cal.getNewDateStr();
                },
                onclearing: function () {
                    _this.queryParams.forecastTimeEnd = '';
                }
            });
        },
    }
});
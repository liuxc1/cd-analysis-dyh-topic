var vue = new Vue({
    el: '#main-container',
    data: {
        url: {
            getDayList: ctx + '/analysis/air/modelwqDayRow/getDayList.vm',
            getRegionAndPoint: ctx + '/analysis/air/modelwqDayRow/getRegionAndPoint.vm',
            //echarts-小时数据
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
            //导出
            exportExcel: ctx + '/analysis/air/weatherElementChange/exportExcel.vm',
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
        queryParams: {
            month: '',
            modelTime: '',
            oldModelTime: '',
            model: 'CDAQS_MT',
            pointName: '成都市',
            pointCode: '510100000000',
            //展示指标
            targetIndex: '0',
            //数据类型
            dataType: 'hour'
        },
        regionAndPointList: [],

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
                unit: 'km'
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
            }, {
                targetIndex: '11',
                targetCode: '',
                targetName: '逆温',
                unit: ''
            }, {
                targetIndex: '12',
                targetCode: '',
                targetName: '水汽分布',
                unit: ''
            }, {
                targetIndex: '13',
                targetCode: 'temperature,windSpeed,rainfall',
                targetName: '气象多要素',
                unit: ''
            },
        ],
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
        //当天数据
        table12: {
            total: 0,
            pageNum: 1,
            pageSize: 10,
            list: [],
        },
        table0: {
            total: 0,
            pageNum: 1,
            pageSize: 10,
            list: [],
        },
        myChart_12: null,
        myChart_0: null,
        defaultDataType:'REGION'
    },
    /**
     * 页面加载完后调用
     */
    mounted: function () {
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
                _this.queryParams.month = data.MODELTIME.substring(0, 7);
                // 当传递的月份为空时，重新赋予最大月份的值
                if (month == null) {
                    _this.timeAxis.next.limit = _this.queryParams.month;
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
        /**
         * 上一月
         * @param prev
         */
        prevClick: function (prev) {
            var month = DateTimeUtil.addMonth(this.queryParams.month, -1);
            this.monthClick(month);
        },
        /**
         * 下一月
         * @param next
         */
        nextClick: function (next) {
            var month = DateTimeUtil.addMonth(this.queryParams.month, 1);
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
            _this.doSearch();
        },
        /**
         * 获取行政区、站点
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
         * 切换展示指标
         */
        changeTarget: function () {
            let _this = this;
            _this.queryParams.dataType = 'hour';
            _this.doSearch();
        },
        /**
         * 查询组分数据
         */
        doSearch: function () {
            let _this = this;
            _this.table0 = {
                total: 0,
                pageNum: 1,
                pageSize: 10,
                list: [],
            };
            _this.table12 = {
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
                pageNum: _this.table12.pageNum,
                pageSize: _this.table12.pageSize,
                modelTime: _this.queryParams.modelTime,
                model: _this.queryParams.model,
                pointCode: _this.queryParams.pointCode
            }, function (result) {
                if (result.data) {
                    if(result.data.zero.list<=0 && result.data.twelve.list<=0){
                        _this.showMessageDialog("暂无数据！");
                    }
                    //当天数据
                    _this.table0 = result.data.zero;
                    _this.table12 = result.data.twelve;
                }
            });
        },
        /**
         * echarts数据
         */
        queryWeatherList: function () {
            let _this = this;
            AjaxUtil.sendAjaxRequest(_this.url.getWeatherData, null, _this.queryParams, function (result) {
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
                _this.drawChart(option_12, option_00)
            });
        },

        /**
         * 绘制ECharts图
         */
        drawChart(option_12, option_00) {
            let _this = this;
            //销毁
            if (_this.myChart_12) {
                _this.myChart_12.dispose()
            }
            if (_this.myChart_0) {
                _this.myChart_0.dispose()
            }
            _this.myChart_12 = echarts.init(document.getElementById('echarts_12'));
            _this.myChart_0 = echarts.init(document.getElementById('echarts_00'));
            // 为echarts对象加载数据
            _this.myChart_12.setOption(option_12);
            _this.myChart_0.setOption(option_00);
            //联动配置
            echarts.connect([_this.myChart_12, _this.myChart_0]);
            //页面宽度变化的时候resize
            window.addEventListener("resize", function () {
                _this.myChart_12.resize();
                _this.myChart_0.resize();
            });
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
                color: ['#4472C4', '#9DC3E6'],
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
                        value: windSpeed,
                        symbol: symbol,
                        symbolSize: 20,
                        symbolRotate: windDirection + 180,
                        windDirection: windDirection,
                        modelTime: data[n].modelTime.substring(0, 13),
                        resultTime: data[n].resultTime.substring(0, 13),
                        windSpeed: windSpeed
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
                        value: windSpeed,
                        symbol: symbol,
                        symbolSize: 20,
                        symbolRotate: windDirection + 180,
                        windDirection: windDirection,
                        modelTime: oldData[n].modelTime.substring(0, 13),
                        resultTime: oldData[n].resultTime.substring(0, 13),
                        windSpeed: windSpeed
                    }
                    oldWeatherData.push(temp)
                }
            }
            let option = {
                color: ['#4472C4', '#9DC3E6'],
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
                        name: '风速（节）',
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
                        left: '24%',
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
                        left: '28%',
                        // left: '250',
                        bottom: '0',
                        style: {
                            text: [
                                '微风（小于 11 节）'
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
                                '中风（11  ~ 17 节）'
                            ].join('\n'),
                            font: '14px Microsoft YaHei'
                        }
                    },
                    {
                        type: 'rect',
                        left: '61%',
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
                        left: '65%',
                        // left: '585',
                        bottom: '0',
                        style: {
                            text: [
                                '大风（>=17节）'
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
            let targetIndex = _this.queryParams.targetIndex;
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
            if (_this.targetTypeList[_this.queryParams.targetIndex].unit) {
                unit = '(' + _this.targetTypeList[_this.queryParams.targetIndex].unit + ')';
            }
            let yName = _this.targetTypeList[_this.queryParams.targetIndex].targetName + unit;
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
         * 导出
         */
        exportExcel: function () {
            let _this = this;
            let index = _this.queryParams.targetIndex;
            let excelName = '未来14天预报气象指标时间变化趋势';
            if (index == 10 && _this.queryParams.dataType == 'hour') {
                excelName = excelName + '(风速风向)小时数据.xlsx'
            } else if (index == 10 && _this.queryParams.dataType == 'day') {
                excelName = excelName + '(风速风向)日数据.xlsx'
            } else if (index >= 11) {
                excelName = excelName + '(' + _this.targetTypeList[index].targetName + ').xlsx'
            } else {
                excelName = excelName + '.xlsx'
            }
            let url = _this.url.exportExcel;
            let params = {
                modelTime: _this.queryParams.modelTime,
                model: _this.queryParams.model,
                pointCode: _this.queryParams.pointCode,
                excelName: excelName,
                dataType: _this.queryParams.dataType,
                targetIndex: _this.queryParams.targetIndex
            };
            FileDownloadUtil.createSubmitTempForm(url, params);

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

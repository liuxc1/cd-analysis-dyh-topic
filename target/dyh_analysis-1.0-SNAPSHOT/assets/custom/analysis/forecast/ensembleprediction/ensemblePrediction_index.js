let vue = new Vue({
    el: '#main-container',
    data: {
        url: {
            //时间列表
            getDayList: ctx + '/analysis/air/modelwqDayRow/getDayList.vm',
            //区县站点信息
            getRegionAndPoint: ctx + '/analysis/air/modelwqDayRow/getRegionAndPoint.vm',
            //图形数据
            getDustForecastDataList: ctx + '/analysis/air/ensemblePrediction/getForecastDataList.vm',
        },
        polluteKey: [
            {targetCode: "AQI", targetName: 'AQI', unit: ''},
            {targetCode: "PM25", targetName: 'PM₂.₅', unit: 'PM₂.₅（μg/m³）'},
            {targetCode: "PM10", targetName: 'PM₁₀', unit: 'PM₁₀（μg/m³）'},
            {targetCode: "CO", targetName: 'CO', unit: 'CO（mg/m³）'},
            {targetCode: "O3", targetName: 'O', unit: 'O₃（μg/m³）'},
            {targetCode: "O3_8", targetName: '_8', unit: 'O₃_8（μg/m³）'},
            {targetCode: "SO2", targetName: 'SO₂', unit: 'SO₂（μg/m³）'},
            {targetCode: "NO2", targetName: 'NO₂', unit: 'NO₂（μg/m³）'}
        ],
        weatherKey: [
            {targetCode: 'TEMPERATURE', targetName: '2m气温', unit: '2m气温（℃）'},
            {targetCode: 'DEW_POINT_SPREAD', targetName: '2m露点差', unit: '2m露点差（℃）'},
            {targetCode: 'BOUNDING_LAYER', targetName: '边界层高度', unit: '边界层高度（m）'},
            {targetCode: 'RAINFALL', targetName: '降水', unit: '降水（mm）'},
            {targetCode: 'PRESSURE', targetName: '气压', unit: '气压（Pa）'},
            {targetCode: 'RADIATION', targetName: '辐射强度', unit: '辐射强度'},
            {targetCode: 'HUMIDITY', targetName: '相对湿度', unit: '相对湿度（%RH）'},
            {targetCode: 'VENTILATION_COEFFICIENT', targetName: '通风系数', unit: '通风系数'},
            {targetCode: 'COMPOSITE_INDEX', targetName: '气象综合指数', unit: '气象综合指数'},
            {targetCode: 'CLOUD_COVER', targetName: '云覆盖率', unit: '云覆盖率（%）'},
            {targetCode: 'WIND_SPEED', targetName: '风速', unit: '风速（m/s）'},
            {targetCode: 'WIND_DIRECTION', targetName: '风向', unit: '风向（°）'}
        ],
        //查询条件
        queryParams: {
            month: '',
            modelTime: '',
            //点位
            pointCode: '510100000000',
            pointName: '成都市'
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
        myChart_0: null,
        defaultDataType: 'REGION'
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
        monthClick: function (month, chooseDayIndex) {
            let _this = this;
            AjaxUtil.sendAjaxRequest(_this.url.getDayList, null, {
                month: month,
                model: 'JIHE_Q01'
            }, function (json) {

                let dataList = json.data;
                let data = dataList[0];
                // 填报月份
                _this.queryParams.month = data.MODELTIME.substring(0, 7);
                // 当传递的月份为空时，重新赋予最大月份的值
                _this.timeAxis.next.limit = DateTimeUtil.getNowDate().substring(0, 7);
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
                if (chooseDayIndex) {
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
            if (!_this.queryParams.pointCode) {
                _this.showMessageDialog("请选择一个行政区或者站点");
                return;
            }

            AjaxUtil.sendAjaxRequest(this.url.getDustForecastDataList, null, this.queryParams, function (result) {
                //空气图形
                let airLineData = _this.assemblyData(result.data["forecastAirDataData"], result.data["legend"], _this.polluteKey);
                _this.loadAQIEcharts(airLineData);
                for (let i = 1; i < _this.polluteKey.length; i++) {
                    _this.loadPollutantEcharts(airLineData, _this.polluteKey[i]);
                }
                //气象图形
                let waterLineData = _this.assemblyData(result.data["forecastWaterData"], result.data["legend"], _this.weatherKey);
                for (let i = 0; i < _this.weatherKey.length; i++) {
                    _this.loadPollutantEcharts(waterLineData, _this.weatherKey[i]);
                }
            });
        },
        /**
         * 组装数据
         */
        assemblyData: function (data, legend, key) {
            let resultList = [];
            let lineData = {};
            let modelArray = legend;
            let modelData = data;
            for (let i = 0; i < modelArray.length; i++) {
                //生成所有数据容器
                let tempObj = {};
                for (let m = 0; m < key.length; m++) {
                    tempObj[key[m].targetCode] = []
                }

                //装数据
                for (let j = 0; j < modelData.length; j++) {
                    if (modelData[j]["MODEL"] === modelArray[i]["MODEL"]) {
                        for (let n = 0; n < key.length; n++) {
                            tempObj[key[n].targetCode].push(modelData[j][key[n].targetCode]);
                        }
                    }
                    //装x轴
                    if (i === 0 && modelData[j]["MODEL"] === 'JIHE') {
                        resultList.push(modelData[j]["RESULT_TIME"]);
                    }
                }
                lineData[modelArray[i]["MODEL"]] = tempObj;
            }
            lineData.resultList = resultList;
            lineData.modelList = modelArray;
            return lineData;
        },
        /**
         * 绘制AQI图
         */
        loadAQIEcharts: function (data) {
            let _this = this;
            let resultList = data.resultList;
            let option = {
                color: ['#5470c6', '#91cc75', '#fac858', '#ee6666', '#73c0de', '#3ba272', '#fc8452'],
                title: [{
                    left: 'center',
                    top: '5',
                    text: this.queryParams.pointName + "AQI预报",
                    textStyle: {
                        fontSize: '20'
                    }
                }, {
                    left: 'center',
                    top: '30',
                    text: resultList && resultList[0] ? "（00时起报" + resultList[0] + "~" + resultList[resultList.length - 1] + "）" : "",
                    textStyle: {
                        fontSize: '18',
                        fontWeight: 'normal'
                    }
                }
                ],
                tooltip: {
                    trigger: 'axis',
                    axisPointer: {
                        type: 'shadow'
                    }
                },
                //下载配置
                toolbox: {
                    right: 20,
                    feature: {
                        saveAsImage: {}
                    }
                },
                grid: {
                    top: '65',
                    bottom: '100',
                    right: '70',
                    left: '70',

                },
                legend: {
                    align: 'left',
                    bottom: '0',
                    textStyle: {
                        fontSize: 14
                    },
                    data: data.modelList.map((v, i, array) => {
                        return v.MODEL_NAME
                    }),
                    show: true

                },
                xAxis: [
                    {
                        name: '时间',
                        type: 'category',
                        data: resultList,
                        axisLabel: {
                            margin: 25,
                            rotate: 30
                        },
                    }
                ],
                yAxis: [
                    {
                        type: 'value',
                        name: "AQI",
                        nameLocation: 'middle',
                        nameGap: 35,
                        position: "left"
                    }
                ],
                series: [
                    {
                        name: '集合预报最小值',
                        type: 'line',
                        data: data["JIHE"]["AQI"].map((v) => {
                            if (v && v - 15 > 0) {
                                return v - 15;
                            } else {
                                return 0;
                            }
                        }),
                        smooth: true,
                        lineStyle: {
                            type: "dashed",
                            width: 0
                        },
                        symbol: "circle",
                        symbolSize: 12,
                        itemStyle: {
                            normal: {
                                color: function (params) {
                                    return _this.getAqiColor(params.data);
                                }
                            }
                        },
                    },
                    {
                        name: '集合预报最大值',
                        type: 'line',
                        data: data["JIHE"]["AQI"].map((v) => {
                            return v + 15;
                        }),
                        smooth: true,
                        lineStyle: {
                            type: "dashed",
                            width: 0
                        },
                        symbol: "circle",
                        symbolSize: 12,
                        itemStyle: {
                            normal: {
                                color: function (params) {
                                    return _this.getAqiColor(params.data);
                                }
                            }
                        },
                    },
                    {
                        name: '集合预报_Q01',
                        type: 'line',
                        data: data["JIHE_Q01"]["AQI"],
                        smooth: true,
                        lineStyle: {
                            type: "dashed",
                            color: "rgba(255, 0, 68, 1)",
                            width: 1.5
                        },

                    },
                    {
                        name: '集合预报_Q02',
                        type: 'line',
                        data: data["JIHE_Q02"]["AQI"],
                        smooth: true,
                        lineStyle: {
                            type: "dashed",
                            color: "rgba(0, 255, 212, 1)",
                            width: 1.5
                        },
                    },
                    {
                        name: '集合预报_Q03',
                        type: 'line',
                        data: data["JIHE_Q03"]["AQI"],
                        smooth: true,
                        lineStyle: {
                            type: "dashed",
                            color: "rgba(162, 0, 255, 1)",
                            width: 1.5
                        },
                    },
                    {
                        name: '集合预报_Q04',
                        type: 'line',
                        data: data["JIHE_Q04"]["AQI"],
                        smooth: true,
                        lineStyle: {
                            type: "dashed",
                            color: "rgba(0, 247, 255, 1)",
                            width: 1.5
                        },
                    },
                    {
                        type: 'boxplot',
                        data: this.mergeArray("AQI", data["JIHE_Q01"]["AQI"], data["JIHE_Q02"]["AQI"], data["JIHE_Q03"]["AQI"], data["JIHE_Q04"]["AQI"], data["JIHE"]["AQI"]),
                        colorBy: "series",
                        itemStyle: {
                            borderColor: "rgba(23, 0, 0, 1)",
                            color: "rgba(247, 246, 246, 1)"
                        },
                        boxWidth: ["7", 20]

                    }
                ]
            };

            //销毁
            if (this.myChart_0) {
                this.myChart_0.dispose()
            }
            this.myChart_0 = echarts.init(document.getElementById('AQI'));
            this.myChart_0.setOption(option);
        },
        /**
         * 绘制图形数据
         */
        loadPollutantEcharts: function (data, keyObj) {
            let _this = this;
            let resultList = data.resultList;
            let option = {
                title: [{
                    left: 'center',
                    top: '5',
                    text: this.queryParams.pointName + keyObj.targetName + "预报",
                    textStyle: {
                        fontSize: '20'
                    }
                }, {
                    left: 'center',
                    top: '30',
                    text: resultList && resultList[0] ? "（00时起报" + resultList[0] + "~" + resultList[resultList.length - 1] + "）" : "",
                    textStyle: {
                        fontSize: '18',
                        fontWeight: 'normal'
                    }
                }
                ],
                tooltip: {
                    trigger: 'axis',
                    axisPointer: {
                        type: 'shadow'
                    }
                },
                //下载配置
                toolbox: {
                    right: 20,
                    feature: {
                        saveAsImage: {}
                    }
                },
                grid: {
                    top: '65',
                    bottom: '100',
                    right: '70',
                    left: '70',

                },
                legend: {
                    align: 'left',
                    bottom: '0',
                    textStyle: {
                        fontSize: 14
                    },
                    data: data.modelList.map((v, i, array) => {
                        return v.MODELNAME
                    }),
                    show: false
                },
                xAxis: [
                    {
                        name: '时间',
                        type: 'category',
                        data: resultList,
                        axisLabel: {
                            margin: 25,
                            rotate: 30
                        },
                    }
                ],
                yAxis: [
                    {
                        type: 'value',
                        name: keyObj.unit,
                        nameLocation: 'middle',
                        nameGap: 35,
                        position: "left"
                    }
                ],
                series: [
                    {
                        name: '集合预报',
                        type: 'line',
                        data: data["JIHE"][keyObj.targetCode],
                        smooth: true,

                    },
                    {
                        name: '集合预报_Q01',
                        type: 'line',
                        data: data["JIHE_Q01"][keyObj.targetCode],
                        smooth: true,
                        lineStyle: {
                            type: "dashed",
                            color: "rgba(255, 0, 68, 1)",
                            width: 1.5
                        },

                    },
                    {
                        name: '集合预报_Q02',
                        type: 'line',
                        data: data["JIHE_Q02"][keyObj.targetCode],
                        smooth: true,
                        lineStyle: {
                            type: "dashed",
                            color: "rgba(0, 255, 212, 1)",
                            width: 1.5
                        },
                    },
                    {
                        name: '集合预报_Q03',
                        type: 'line',
                        data: data["JIHE_Q03"][keyObj.targetCode],
                        smooth: true,
                        lineStyle: {
                            type: "dashed",
                            color: "rgba(162, 0, 255, 1)",
                            width: 1.5
                        },
                    },
                    {
                        name: '集合预报_Q04',
                        type: 'line',
                        data: data["JIHE_Q04"][keyObj.targetCode],
                        smooth: true,
                        lineStyle: {
                            type: "dashed",
                            color: "rgba(0, 247, 255, 1)",
                            width: 1.5
                        },
                    },
                    {
                        type: 'boxplot',
                        data: this.mergeArray(keyObj.targetCode, data["JIHE_Q01"][keyObj.targetCode], data["JIHE_Q02"][keyObj.targetCode], data["JIHE_Q03"][keyObj.targetCode], data["JIHE_Q04"][keyObj.targetCode], data["JIHE"][keyObj.targetCode]),
                        colorBy: "series",
                        itemStyle: {
                            borderColor: "rgba(23, 0, 0, 1)",
                            color: "rgba(247, 246, 246, 1)"
                        },
                        boxWidth: ["7", 20]
                    }
                ]
            };
            let myChart = echarts.init(document.getElementById(keyObj.targetCode));
            myChart.setOption(option);
        },
        mergeArray: function (type, arr1, arr2, arr3, arr4, arr5) {
            let result = [];
            for (let i = 0; i < arr1.length; i++) {
                let temp = [arr1[i] ? arr1[i] : 0, arr2[i] ? arr2[i] : 0, arr3[i] ? arr3[i] : 0, arr4[i] ? arr4[i] : 0];
                if ("AQI" === type) {
                    if (arr5[i] && arr5[i] - 15 >= 0) {
                        temp.push(arr5[i] - 15)
                    } else {
                        temp.push(0)
                    }
                    temp.push(arr5[i] + 15)
                } else {
                    temp.push(arr5[i])
                }
                result.push(temp)
            }
            return echarts.dataTool.prepareBoxplotData(result).boxData;
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
                title: '行政区',
                single: true,
                dataTypes: ['REGION'],
                dataTypeNames: ['行政区'],
                isCheckParent: true, // 是否可选父节点
                isShowLeaf: false, //是否显示叶子节点
                defaultDataType: _this.defaultDataType,
                dataCodes: _this.queryParams.pointCode,
                data: _this.regionAndPointList,
                callback: function (dataType, nodeArray) {
                    if (nodeArray.length > 0) {
                        _this.defaultDataType = dataType;
                        _this.queryParams.pointCode = nodeArray[0].CODE;
                        _this.queryParams.pointName = nodeArray[0].NAME;
                    }
                    _this.query();
                }
            });
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
            for (let i = 0; i < this.timeAxis.list.length; i++) {
                if (this.timeAxis.list[i].text === data.text) {
                    this.timeAxis.list[i].selected = true;
                } else {
                    this.timeAxis.list[i].selected = false;
                }
            }
            this.queryParams.modelTime = data.key;
            this.query();
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
        getPolluteUnit: function (pollute) {
            if ('AQI' === pollute) {
                return {name: "AQI", unit: ""};
            } else if ("PM25" === pollute) {
                return {name: "PM₂.₅", unit: "PM₂.₅（μg/m³）"};
            } else if ("PM10" === pollute) {
                return {name: "PM₁₀", unit: "PM₁₀（μg/m³）"};
            } else if ("CO" === pollute) {
                return {name: "CO", unit: "CO（mg/m³）"};
            } else if ("O3" === pollute) {
                return {name: "O₃", unit: "O₃（μg/m³）"};
            } else if ("O3_8" === pollute) {
                return {name: "O₃_8", unit: "O₃_8（μg/m³）"};
            } else if ("SO2" === pollute) {
                return {name: "SO₂", unit: "SO₂（μg/m³）"};
            } else if ("NO2" === pollute) {
                return {name: "NO₂", unit: "NO₂（μg/m³）"};
            }
        }
    }
});




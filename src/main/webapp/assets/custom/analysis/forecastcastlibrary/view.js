var vue = new Vue({
    el: '#main-container',
    data: {
        defaultLiIndex: 0,
        id: params.id,
        dataList: [{W_START_TIME: '', W_END_TIME: '', FORECAST_REF: "", ANALYSIS_CONCLUSION: "", WATER_ANALYSIS: ""}],
        analysisText: "",
        waterAnalysisText: "",
        forcastRef: "",
        chartsData: [],
        waterObj: {
            total: 0,
            pageNum: 1,
            pageSize: 5,
            list: []
        },
        param:{
            dateType:'hour',
            startTime:'',
            endTime:'',
            startDate:'',
            endDate:''
        },
    },
    mounted: function () {
        this.queryCastList();
    },
    methods: {
        activeLiMethod: function (index) {
            if (index !== this.defaultLiIndex) {
                this.defaultLiIndex = index;
                if (index === 1) {
                    this.queryPollutionAnalysisCharts();
                    if (!this.analysisText) {
                        this.queryPollutionAnalysisText();
                    }
                } else if (index === 2) {
                    this.querywaterList();
                    this.queryPollutionAnalysisCharts();
                }
            }
        },
        /**
         * 查询案例列表
         */
        queryCastList: function () {
            let _this = this;
            AjaxUtil.sendPostAjaxRequest(ctx + '/analysis/forecastCastLibrary/queryCastById.vm',
                {
                    id: this.id
                },
                function (json) {
                    _this.dataList = json.data;
                    _this.forcastRef = _this.dataList[0].FORECAST_REF;
                    _this.analysisText = _this.dataList[0].ANALYSIS_CONCLUSION;
                    _this.waterAnalysisText = _this.dataList[0].WATER_ANALYSIS;
                    _this.param.startTime=_this.dataList[0].W_START_TIME+' 00:00';
                    _this.param.endTime=_this.dataList[0].W_END_TIME+' 00:00';
                    _this.param.startDate=_this.dataList[0].W_START_TIME;
                    _this.param.endDate=_this.dataList[0].W_END_TIME;

                }, null, null);
        },
        /**
         * 污染过程分析
         */
        queryPollutionAnalysisCharts: function () {
            let _this = this;
            let params={}
            if (_this.param.dateType!='hour'){
                params={
                    dateType:'day',
                    startTime:_this.param.startDate,
                    endTime:_this.param.endDate
                }
            }else{
                    params={
                        dateType:'hour',
                        startTime:_this.param.startTime,
                        endTime:_this.param.endTime
                    }
                }
            AjaxUtil.sendPostAjaxRequest(ctx + '/analysis/forecastCastLibrary/queryPollutionAnalysisCharts.vm',
                params,
                /*{
                    startTime: this.dataList[0].W_START_TIME,
                    endTime: this.dataList[0].W_END_TIME
                    /!*startTime: '2021-01-01',
                    endTime: '2021-06-01'*!/
                }*/
                function (json) {
                    _this.chartsData = json.data;
                    if (_this.defaultLiIndex === 1) {
                        _this.drawPolluteCharts(_this.chartsData);
                    } else if (_this.defaultLiIndex === 2) {
                        _this.drawWaterCharts(_this.chartsData);
                    }
                }, null, null);
        },
        /**
         * 绘制污染分析echarts图
         */
        drawPolluteCharts: function (data) {
            let legendArray = ['PM2.5', 'PM10', 'SO2', 'NO2', 'CO', 'O3'];
            let keyArray = ['PM25', 'PM10', 'SO2', 'NO2', 'CO', 'O3'];
            let xAxisArray = [];
            let seriesArray = [];
            for (let j = 0; j < keyArray.length; j++) {
                let tempArray = [];
                for (let i = 0; i < data.length; i++) {
                    let obj = data[i];
                    if (j === 0) {
                        xAxisArray.push(obj.MONITORTIME);
                    }
                    tempArray.push(obj[keyArray[j]]);
                }
                seriesArray.push({
                    name: legendArray[j],
                    type: 'line',
                    smooth: true,
                    data: tempArray,
                    yAxisIndex: legendArray[j] === 'CO' ? 1 : 0,
                    symbol: "circle",
                    symbolSize: 8
                })
            }
            let option = {
                title: {
                    left: 'center',
                    align: 'right',
                    text: '主要污染物浓度变化图'
                },
                tooltip: {
                    trigger: 'axis'
                },
                legend: {
                    top: '6%',
                    data: legendArray
                },
                grid: {
                    left: '3%',
                    right: '5%',
                    bottom: '3%',
                    containLabel: true
                },
                toolbox: {
                    right: '2%',
                    feature: {
                        saveAsImage: {}
                    }
                },
                xAxis: {
                    name: '时间',
                    type: 'category',
                    boundaryGap: false,
                    data: xAxisArray
                },
                yAxis: [
                    {
                        name: 'μg/m3',
                        type: 'value',
                        axisLine: {
                            show: true
                        }
                    },
                    {
                        name: 'mg/m3',
                        type: 'value',
                        axisLine: {
                            show: true
                        }
                    }
                ],
                series: seriesArray
            };
            let myChart = echarts.init(document.getElementById('pollutionAnalysisCharts'));
            myChart.setOption(option);
        },
        /**
         * 绘制气象echarts图
         */
        drawWaterCharts: function (data) {
            let legendArray = ['PBL', 'TEM', 'TEM-G', 'Irradiance', 'O3', 'PM2.5', 'PRE', 'RHU', 'CLOC'];
            let keyArray = [
                {key: 'PBL', yindex: 0, symbol: "triangle", width: 0, symbolSize: 9},
                {key: 'TEMPERATURE', yindex: 1, symbol: "none", width: 2},
                {key: 'TEM_G', yindex: 1, symbol: "", width: 2, symbolSize: 9},
                {
                    key: 'IRRADIANCE', yindex: 2,
                    symbol: "path://M512,85.9000015258789l110.79998779296875,318.7000045776367l337.20001220703125,6.79998779296875l-268.79998779296875,203.80001831054688l97.70001220703125,322.89996337890625L512,745.4000244140625L235.10000610351562,938.0999755859375l97.69998168945312,-322.89996337890625L64,411.3999938964844l337.20001220703125,-6.79998779296875Z",
                    width: 2,
                    symbolSize: 14
                },
                {key: 'O3', yindex: 3, symbol: "rect", width: 2, symbolSize: 9},
                {key: 'PM25', yindex: 3, symbol: "circle", width: 2, symbolSize: 9},
                {key: 'RAINFALL', yindex: 3},
                {key: 'RHU', yindex: 4, symbol: "circle", width: 2, symbolSize: 9},
                {key: 'CLOC', yindex: 4, symbol: "circle", width: 0, symbolSize: 9}];
            let xAxisArray = [];
            let seriesArray = [];
            for (let j = 0; j < keyArray.length; j++) {
                let tempArray = [];
                for (let i = 0; i < data.length; i++) {
                    let obj = data[i];
                    if (j === 0) {
                        xAxisArray.push(obj.MONITORTIME);
                    }
                    tempArray.push(obj[keyArray[j].key]);
                }
                let seriesObj = null;
                if ("TEM-G" === legendArray[j] || 'PRE' === legendArray[j]) {
                    seriesObj = {
                        name: legendArray[j],
                        type: 'bar',
                        data: tempArray,
                        yAxisIndex: keyArray[j].yindex,
                        barWidth: 10
                    }
                } else {
                    seriesObj = {
                        name: legendArray[j],
                        type: 'line',
                        smooth: true,
                        data: tempArray,
                        yAxisIndex: keyArray[j].yindex,
                        symbol: keyArray[j].symbol,
                        symbolSize: keyArray[j].symbolSize,
                        lineStyle: {
                            width: keyArray[j].width
                        }
                    };
                }
                seriesArray.push(seriesObj);

            }
            let option = {
                color: ['#000000',
                    'rgba(228, 44, 44, 1)',
                    'rgba(228, 44, 44, 1)',
                    "rgba(245, 242, 94, 1)",
                    'rgba(118, 87, 89, 1)', 'rgba(118, 87, 89, 1)', 'rgba(118, 87, 89, 1)', '#228B22', '#228B22'],
                title: {
                    left: 'center',
                    align: 'right',
                    text: '主要污染物浓度变化图'
                },
                tooltip: {
                    trigger: 'axis'
                },
                legend: {
                    top: '6%',
                    data: legendArray
                },
                grid: {
                    left: '3%',
                    right: '10%',
                    bottom: '5%',
                    containLabel: true
                },
                toolbox: {
                    right: '2%',
                    feature: {
                        saveAsImage: {}
                    }
                },
                xAxis: {
                    name: '时间',
                    type: 'category',
                    boundaryGap: true,
                    data: xAxisArray,
                    nameLocation: "middle",
                    nameGap: 25,
                    nameTextStyle: {
                        color: "rgba(7, 7, 7, 1)",
                        fontWeight: "bold",
                        fontSize: 13
                    },
                    axisLine: {
                        show: true,
                        lineStyle: {
                            width: 1.5,
                            color: "rgba(7, 7, 7, 1)"
                        }
                    },
                    axisLabel: {
                        fontWeight: 'bold',
                        color: "rgba(7, 7, 7, 1)",
                    },
                    axisTick: {
                        show: true,  //不显示坐标轴刻度
                        length: 7,
                        lineStyle: {
                            color: "rgba(7, 7, 7, 1)",
                            width: 1.5
                        }
                    }
                },
                yAxis: [
                    {
                        name: 'PBL(m)',
                        nameLocation: "middle",
                        nameRotate: 90,
                        nameGap: 35,
                        nameTextStyle: {
                            color: "rgba(7, 7, 7, 1)",
                            fontWeight: "bold",
                            fontSize: 13
                        },
                        type: 'value',
                        position: 'left',
                        axisLine: {
                            show: true,
                            lineStyle: {
                                width: 1.5,
                                color: "rgba(7, 7, 7, 1)"
                            }
                        },
                        axisLabel: {
                            fontWeight: 'bold',
                            color: "rgba(7, 7, 7, 1)",
                        },
                        axisTick: {
                            show: true,  //不显示坐标轴刻度
                            length: 7,
                            lineStyle: {
                                color: "rgba(7, 7, 7, 1)",
                                width: 1.5
                            }
                        }
                    },
                    {
                        name: 'TEM/TEM-G(°C)',
                        nameLocation: "middle",
                        nameRotate: 90,
                        nameGap: 35,
                        nameTextStyle: {
                            color: "rgba(228, 44, 44, 1)",
                            fontWeight: "bold",
                            fontSize: 13
                        },
                        type: 'value',
                        position: 'right',
                        axisLine: {
                            show: true,
                            lineStyle: {
                                width: 1.5,
                                color: "rgba(228, 44, 44, 1)"
                            }
                        },
                        axisLabel: {
                            fontWeight: 'bold',
                            color: "rgba(228, 44, 44, 1)",
                        },
                        axisTick: {
                            show: true,  //不显示坐标轴刻度
                            length: 7,
                            inside: true,
                            lineStyle: {
                                color: "rgba(228, 44, 44, 1)",
                                width: 1.5
                            }
                        }
                    },
                    {
                        name: 'Irradiance(10*W/m2)',
                        nameLocation: "middle",
                        nameRotate: 90,
                        nameGap: 35,
                        nameTextStyle: {
                            color: "rgba(245, 242, 94, 1)",
                            fontWeight: "bold",
                            fontSize: 13
                        },
                        type: 'value',
                        position: 'right',
                        offset: 60,
                        axisLine: {
                            show: true,
                            lineStyle: {
                                width: 1.5,
                                color: "rgba(245, 242, 94, 1)"
                            }
                        },
                        axisLabel: {
                            fontWeight: 'bold',
                            color: "rgba(245, 242, 94, 1)",
                        },
                        axisTick: {
                            show: true,  //不显示坐标轴刻度
                            length: 7,
                            inside: true,
                            lineStyle: {
                                color: "rgba(245, 242, 94, 1)",
                                width: 1.5
                            }
                        }
                    },
                    {
                        name: 'PRE(mm)/O3(10*μg/m3)/PM2.5(10*μg/m3)',
                        nameLocation: "middle",
                        nameRotate: 90,
                        nameGap: 35,
                        nameTextStyle: {
                            color: "rgba(118, 87, 89, 1)",
                            fontWeight: "bold",
                            fontSize: 13
                        },
                        offset: 120,
                        type: 'value',
                        position: 'right',
                        axisLine: {
                            show: true,
                            lineStyle: {
                                width: 1.5,
                                color: "rgba(118, 87, 89, 1)"
                            }
                        },
                        axisLabel: {
                            fontWeight: 'bold',
                            color: "rgba(118, 87, 89, 1)",
                        },
                        axisTick: {
                            show: true,  //不显示坐标轴刻度
                            length: 7,
                            inside: true,
                            lineStyle: {
                                color: "rgba(118, 87, 89, 1)",
                                width: 1.5
                            }
                        }
                    },
                    {
                        name: 'RHU(%)/CLOC(%)',
                        nameLocation: "middle",
                        nameRotate: 90,
                        nameGap: 35,
                        nameTextStyle: {
                            color: "#228B22",
                            fontWeight: "bold",
                            fontSize: 13
                        },
                        offset: 180,
                        type: 'value',
                        position: 'right',
                        axisLine: {
                            show: true,
                            lineStyle: {
                                width: 1.5,
                                color: "#228B22"
                            }
                        },
                        axisLabel: {
                            fontWeight: 'bold',
                            color: "#228B22",
                        },
                        axisTick: {
                            show: true,  //不显示坐标轴刻度
                            length: 7,
                            inside: true,
                            lineStyle: {
                                color: "#228B22",
                                width: 1.5
                            }
                        }
                    }
                ],
                series: seriesArray
            };
            let myChart = echarts.init(document.getElementById('waterCharts'));
            myChart.setOption(option);
        },
        queryPollutionAnalysisText: function () {
            let _this = this;
            AjaxUtil.sendPostAjaxRequest(ctx + '/analysis/forecastCastLibrary/queryPollutionAnalysisText.vm',
                {
                    startTime: this.dataList[0].W_START_TIME,
                    endTime: this.dataList[0].W_END_TIME
                    /*  startTime: '2021-01-01',
                      endTime: '2021-06-01'*/
                },
                function (json) {
                    _this.analysisText = json.data;
                }, null, null);
        },
        updatePollutionAnalysisText: function () {
            let _this = this;
            AjaxUtil.sendPostAjaxRequest(ctx + '/analysis/forecastCastLibrary/updatePollutionAnalysisText.vm',
                {
                    id: this.id,
                    text: this.analysisText
                },
                function (json) {
                    DialogUtil.showTipDialog("保存成功！", null);
                }, null, null);
        },
        /**
         * 修改预报引用信息
         */
        updateForcastRef: function () {
            let _this = this;
            AjaxUtil.sendPostAjaxRequest(ctx + '/analysis/forecastCastLibrary/updateForcastRef.vm',
                {
                    id: this.id,
                    forcastRef: this.forcastRef
                },
                function (json) {
                    DialogUtil.showTipDialog("保存成功！", null);
                }, null, null);
        },
        /**
         * 修改气象分析结论
         */
        updateWaterAnalysis: function () {
            let _this = this;
            AjaxUtil.sendPostAjaxRequest(ctx + '/analysis/forecastCastLibrary/updateWaterAnalysis.vm',
                {
                    id: this.id,
                    waterAnalysisText: this.waterAnalysisText
                },
                function (json) {
                    DialogUtil.showTipDialog("保存成功！", null);
                }, null, null);
        },
        /**
         * 查询气象条件数据分页
         */
        querywaterList: function () {
            let _this = this;
            AjaxUtil.sendPostAjaxRequest(ctx + '/analysis/forecastCastLibrary/querywaterList.vm',
                {
                    startTime: this.dataList[0].W_START_TIME,
                    endTime: this.dataList[0].W_END_TIME,
                    pageNum: this.waterObj.pageNum,
                    pageSize: this.waterObj.pageSize
                },
                function (json) {
                    _this.waterObj = json.data;
                }, null, null);
        },
        cancel: function (isParentRefresh) {
            if (window.parent && window.parent.vue.closePageDialog) {
                // 调用父页面的关闭方法
                window.parent.vue.closePageDialog(isParentRefresh);
            } else {
                window.history.go(-1);
            }
        },
        /**
         * 导出word
         */
        downloadWord: function () {
            const _this = this;
            let url = ctx + '/analysis/forecastCastLibrary/exportForcastDetailWord.vm?castId=' + _this.id;
            let a = document.createElement("a");
            a.setAttribute("download", "");
            a.setAttribute("href", url)
            a.click();
            a.remove();
        },
        changeDateType:function (type) {
            if (this.param.dateType !== type){
                this.param.dateType = type;
            }
        },
        /**
         * 小时
         */
        queryStartTime: function () {
            let _this = this;
            let minDate = _this.dataList[0].W_START_TIME + ' 00:00';
            WdatePicker({
                dateFmt: 'yyyy-MM-dd HH:00',
                el: 'startTime',
                minDate: minDate,
                maxDate: '#F{$dp.$D(\'endTime\')}',
                isShowClear: false,
                isShowToday:false,
                onpicking: function (dp) {
                    _this.param.startTime = dp.cal.getNewDateStr();
                },
                onclearing: function () {
                    _this.param.startTime = '';
                },
                readOnly: true
            });
        },
        queryEndTime: function () {
            var _this = this;
            let maxDate = _this.dataList[0].W_END_TIME + ' 00:00';
            WdatePicker({
                dateFmt: 'yyyy-MM-dd HH:00',
                el: 'endTime',
                maxDate: maxDate,
                minDate: '#F{$dp.$D(\'startTime\')}',
                isShowClear: false,
                isShowToday:false,
                onpicking: function (dp) {
                    _this.param.endTime = dp.cal.getNewDateStr();
                },
                onclearing: function () {
                    _this.param.endTime = '';
                },
                readOnly: true
            });
        },
        /**
         * 日期
         */
        queryStartDate: function () {
            let _this = this;
            let minDate = _this.dataList[0].W_START_TIME;
            WdatePicker({
                dateFmt: 'yyyy-MM-dd',
                el: 'startDate',
                minDate: minDate,
                maxDate: '#F{$dp.$D(\'endDate\')}',
                isShowClear: false,
                isShowToday:false,
                onpicking: function (dp) {
                    _this.param.startDate = dp.cal.getNewDateStr();
                },
                onclearing: function () {
                    _this.param.startDate = '';
                },
                readOnly: true
            });
        },
        queryEndDate: function () {
            var _this = this;
            let maxDate = _this.dataList[0].W_END_TIME;
            WdatePicker({
                dateFmt: 'yyyy-MM-dd',
                el: 'endDate',
                maxDate: maxDate,
                minDate: '#F{$dp.$D(\'startDate\')}',
                isShowClear: false,
                isShowToday:false,
                onpicking: function (dp) {
                    _this.param.endDate = dp.cal.getNewDateStr();
                },
                onclearing: function () {
                    _this.param.endDate = '';
                },
                readOnly: true
            });
        }
    }
});


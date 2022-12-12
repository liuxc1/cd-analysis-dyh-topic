var vue = new Vue({
    el: '#main-container',
    data: {
        url: {
            getDayList: ctx + '/analysis/air/modelwqDayRow/getDayList.vm',
            getRegionAndPoint: ctx + '/analysis/air/modelwqDayRow/getRegionAndPoint.vm',
            getComponentsData: ctx + '/analysis/air/componentsForecast/getComponentsData.vm',
            exportExcel: ctx + '/analysis/air/componentsForecast/exportExcel.vm',
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
            thisYMD: '',
            model: 'CDAQS_MT',
            pointName: '成都市',
            pointCode: '510100000000',
            showType: 'heap',

        },
        regionAndPointList: [],
        myChart_12:null,
        myChart_0:null,
        //默认点位类型
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
            _this.queryParams.thisYMD = data.key;
            _this.doSearch(_this.queryParams.showType);
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
                defaultDataType: _this.defaultDataType,
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
         * 查询组分数据
         */
        doSearch: function (showType) {
            let _this = this;
            if (showType) {
                _this.queryParams.showType = showType;
                let yName='';
                $(".showType").css("cssText", "");
                if (showType == 'heap') {

                    $("#heap").css("cssText", "background-color:#4F99C6 !important;color: white !important");
                } else {
                    $("#percent").css("cssText", "background-color:#4F99C6 !important;color: white !important");
                }
            }
            AjaxUtil.sendAjaxRequest(_this.url.getComponentsData, null, {
                modelTime: _this.queryParams.thisYMD,
                showType: _this.queryParams.showType,
                model: _this.queryParams.model,
                pointCode: _this.queryParams.pointCode
            }, function (result) {
                if(result.data.twelve.length <= 0 && result.data.zero.length <= 0){
                    _this.showMessageDialog("暂无数据！");
                }
                _this.drawChart(_this.assembleEchartsData(result.data.twelve), _this.assembleEchartsData(result.data.zero));
            });
        },
        /**
         * 绘制ECharts图
         */
        drawChart(option_12, option_0) {
            let _this=this;
            //销毁
            if (_this.myChart_12){
                _this.myChart_12.dispose()
            }
            if (_this.myChart_0){
                _this.myChart_0.dispose()
            }
            _this.myChart_12= echarts.init(document.getElementById('pm25_12'));
            _this.myChart_0= echarts.init(document.getElementById('pm25_0'));
            // 为echarts对象加载数据
            _this.myChart_12.setOption(option_12);
            _this.myChart_0.setOption(option_0);
            //联动配置
            echarts.connect([_this.myChart_12, _this.myChart_0]);
            //页面宽度变化的时候resize
            window.addEventListener("resize", function () {
                _this.myChart_12.resize();
                _this.myChart_0.resize();
            });
        },
        /**
         * 组装echarts数据
         * @param data
         * @returns option
         */
        assembleEchartsData: function (data) {
            let resultTimeList = [];
            let pollList = ['硫酸盐', '铵盐', '硝酸盐', '有机碳', '元素碳', '其它'];
            for (let i = 0; i < data.length; i++) {
                if (data[i] == null || resultTimeList.indexOf(data[i].RESULT_TIME) === -1) {
                    resultTimeList.push(data[i].RESULT_TIME);
                }
            }
            let so4Data = [];
            let nh4Data = [];
            let no3Data = [];
            let ocData = [];
            let ecData = [];
            let otherData = [];
            for (let n = 0; n < data.length; n++) {
                so4Data.push(data[n]['PM25_SO4']);
                nh4Data.push(data[n]['PM25_NH4']);
                no3Data.push(data[n]['PM25_NO3']);
                ocData.push(data[n]['PM25_OC']);
                ecData.push(data[n]['PM25_EC']);
                otherData.push(data[n]['PM25_OTHER']);
            }
            let option = {
                color: ['#F564E3', '#619CFF', '#00BFC4', '#00BA38', '#B79F00', '#F8766D'],
                title: {
                    left: '8%',
                    top: '2%',
                    text: 'PM2.5组分预报',
                    show: false
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
                    top: '30',
                    bottom: '120',
                    right: '8%',
                    left: '8%',
                    show: 'true',
                    borderWidth: '2',
                    borderColor: '#D3D3D3',
                },
                legend: {
                    icon: 'rect',
                    itemWidth: 40,
                    itemHeight: 20,
                    align: 'left',
                    orient: 'vertical',
                    x: 'right',
                    top: '15%',
                    textStyle: {
                        fontSize: 14
                    },
                    data: pollList,
                    show: true

                },
                xAxis: [
                    {
                        name:'时间',
                        axisLabel: {
                            margin: 50,
                            rotate: 30
                        },
                        type: 'category',
                        boundaryGap: false,
                        data: resultTimeList,
                        splitLine: {show: true},
                    }
                ],
                yAxis: [
                    {
                        name:this.queryParams.showType=='heap'?'μg/m³':'%',
                        type: 'value',
                        min: 0,
                        splitLine: {show: true},
                        axisLabel: {
                            show: true,
                            interval: 'auto',
                            formatter: this.queryParams.showType == 'heap' ? '{value}' : '{value}%'
                        },

                    }
                ],
                // 缩放
                dataZoom: [{
                    type: 'slider',
                    bottom: 85,
                    showDetail: false
                }],
                series: [
                    {
                        name: pollList[5],
                        type: 'line',
                        smooth: true,
                        stack: 'PM2.5组分',
                        areaStyle: {},
                        showSymbol: false,
                        emphasis: {
                            focus: 'series'
                        },
                        data: otherData,
                    },
                    {
                        name: pollList[4],
                        type: 'line',
                        smooth: true,
                        stack: 'PM2.5组分',
                        areaStyle: {},
                        showSymbol: false,
                        emphasis: {
                            focus: 'series'
                        },
                        data: ecData,
                    },
                    {
                        name: pollList[3],
                        type: 'line',
                        smooth: true,
                        stack: 'PM2.5组分',
                        areaStyle: {},
                        showSymbol: false,
                        emphasis: {
                            focus: 'series'
                        },
                        data: ocData,
                    },
                    {
                        name: pollList[2],
                        type: 'line',
                        smooth: true,
                        stack: 'PM2.5组分',
                        areaStyle: {},
                        showSymbol: false,
                        emphasis: {
                            focus: 'series'
                        },
                        data: no3Data,
                    },
                    {
                        name: pollList[1],
                        type: 'line',
                        smooth: true,
                        stack: 'PM2.5组分',
                        areaStyle: {},
                        showSymbol: false,
                        emphasis: {
                            focus: 'series'
                        },
                        data: nh4Data,
                    },
                    {
                        name: pollList[0],
                        type: 'line',
                        smooth: true,
                        stack: 'PM2.5组分',
                        areaStyle: {},
                        showSymbol: false,
                        emphasis: {
                            focus: 'series'
                        },
                        data: so4Data,
                    },
                ]
            };
            return option;
        },

        /**
         * 导出
         */
        exportExcel: function () {
            let _this = this;
            let url = _this.url.exportExcel;
            let params = {
                modelTime: _this.queryParams.thisYMD,
                model: _this.queryParams.model,
                pointCode: _this.queryParams.pointCode,
                showType: _this.queryParams.showType,
                excelName: "PM2.5组分预报.xlsx"
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

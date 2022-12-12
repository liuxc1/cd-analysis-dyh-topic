let vue = new Vue({
    el: '#main-container',
    data: {
        url: {
            //时间列表
            getDayList: ctx + '/analysis/air/sandDust/getForecastDateList.vm',
            //区县站点信息
            getRegionAndPoint: ctx + '/analysis/air/sandDust/getRegionList.vm',
            //图形数据
            getDustForecastDataList: ctx + '/analysis/air/sandDust/getDustForecastDataList.vm',
        },
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
        this.query();
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
                model: _this.queryParams.model
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
                _this.loadEcharts(result.data);

            });
        },
        /**
         * 绘制图形数据
         */
        loadEcharts: function (data) {
            //沙尘：PM10（柱状图）、风速（折线图）、降水（柱状图）城市结果显示三个要素就行了
            let xAxisArray = [];
            let PM10Array = [];
            let windSpeedArray = [];
            let rainArray = [];

            for (let i = 0; i < data.length; i++) {
                xAxisArray.push(data[i].RESULT_TIME);
                PM10Array.push(data[i]["PM10"]);
                windSpeedArray.push(data[i]["WSPD"]);
                rainArray.push(data[i]["PCPN"]);
            }

            let option = {
                title: [{
                    left: 'center',
                    top: '5',
                    text: this.queryParams.pointName + "沙尘预报",
                    textStyle: {
                        fontSize: '20'
                    }
                },{
                    left: 'center',
                    top: '30',
                    text: xAxisArray&&xAxisArray[0]?"（00时起报"+xAxisArray[0]+"~" + xAxisArray[xAxisArray.length-1]+"）":"",
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
                    bottom: '130',
                    right: '100',
                    left: '90',
                },
                legend: {
                    align: 'left',
                    bottom: '0',
                    textStyle: {
                        fontSize: 14
                    },
                    data: ["PM₁₀", "风速", "降水"],
                    show: true

                },
                xAxis: [
                    {
                        name: '时间',
                        type: 'category',
                        data: xAxisArray,
                        axisLabel: {
                            margin: 45,
                            rotate: 30
                        },
                    }
                ],
                yAxis: [
                    {
                        type: 'value',
                        name: "PM₁₀（μg/m³）",
                        nameLocation: 'middle',
                        nameGap: 35,
                        position:"left"
                    },
                    {
                        type: 'value',
                        name: '风速（m/s）',
                        nameLocation: 'middle',
                        nameGap: 35,
                        position:"right"
                    },
                    {
                        type: 'value',
                        name: "降水（mm）",
                        nameLocation: 'middle',
                        nameGap: 35,
                        position:"right",
                        offset:45
                    },
                ],
                series: [
                    {
                        name: 'PM₁₀',
                        type: 'bar',
                        data: PM10Array,
                        yAxisIndex:0
                    },
                    {
                        name: '风速',
                        type: 'line',
                        symbol: 'circle',
                        symbolSize: 6,
                        data: windSpeedArray,
                        yAxisIndex:1
                    }, {
                        name: '降水',
                        type: 'bar',
                        data: rainArray,
                        yAxisIndex:2
                    },
                ]
            };


            //销毁
            if (this.myChart_0) {
                this.myChart_0.dispose()
            }
            this.myChart_0 = echarts.init(document.getElementById('echarts00'));
            this.myChart_0.setOption(option);
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
    }
});




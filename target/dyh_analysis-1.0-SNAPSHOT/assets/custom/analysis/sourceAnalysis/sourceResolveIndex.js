// vue实列化
var vue = new Vue({
    el: '#index-app',

    /**
     * 基本数据
     */
    data: function () {
        return {
            param: {
                REPORT_YEAR: '2020',
                PM: 'PM25'
            },
            urls: {
                addUrl: ctx + "/analysis/sourceanalysis/edit.vm"
            },
            // 记录列表
            records: [{
                text: '',
                //默认设置为未选中
                selected: false
            }],
            // 提交记录数限制，不做限制，则为-1
            uploadLimit: -1,
            // 记录信息
            record: '',
            //设置当前report文件状态
            state: '',
            //初始当前report文件id
            ascriptionId: '',
            field1: '',
            field2: '',
            field3: '',
            field4: '',
            field5: '',
            field6: '',
            //用于形成文件的真实路径
            fileType: '',
            fileSavePath: '',
            reportName: '',
            polluteinfo1: '',
            polluteinfo2: '',
            polluteinfo3: ''

        }
    },
    /**
     * 页面加载完成后执行
     */
    mounted: function () {
        this.initData();
    },
    filters: {
        contentFormat: function (value) {
            if (value == '') {
                return '--';
            } else {
                return value;
            }
        }
    },
    /**
     * 局部过滤器
     */
    filters: {
        fontFilter: function (value) {
            if (value == '') {
                return '--';
            } else {
                return value;
            }
        }
    },
    /**
     * 所有方法
     */
    methods: {

        initData: function () {
            var _this = this;
            _this.queryReportListByYear();
        },

        /*
        *根据填报年份查询报告文件
        */
        queryReportListByYear: function () {
            var _this = this;
            $.ajax({
                url: 'queryReportListByYear.vm',
                type: 'post',
                data: {
                    REPORT_TIME: _this.param.REPORT_YEAR,
                },
                dataType: 'json',
                isShowLoader: true, // 加载动画，参考ths-jquery-ajax-loader.js
                success: function (json) {
                    var dataList = json.data;
                    if (!dataList) {
                        // DialogUtil.showTipDialog("暂无数据!");
                        _this.records = [];
                        _this.record = 0;
                        //初始化
                        _this.ascriptionId = '';
                    } else {
                        var flag = false;
                        var index = 0;
                        for (var i = 0; i < dataList.length; i++) {
                            if (_this.ascriptionId == dataList[i].REPORT_ID) {
                                flag = true;
                                dataList[i].selected = true;
                                index = i;
                            } else {
                                dataList[i].selected = false;
                            }
                        }
                        _this.records = dataList;
                        if (flag) {
                            _this.field1 = _this.records[index].FIELD1;
                            _this.field2 = _this.records[index].FIELD2;
                            _this.field3 = _this.records[index].FIELD3;
                            _this.field4 = _this.records[index].FIELD4;
                            _this.field5 = _this.records[index].FIELD5;
                            _this.field6 = _this.records[index].FIELD6;
                            _this.reportName = _this.records[index].REPORT_NAME;
                            _this.fileType = _this.records[index].FILE_TYPE,
                                _this.fileSavePath = _this.records[index].FILE_SAVE_PATH,
                                _this.ascriptionId = _this.records[index].REPORT_ID;
                            _this.record = 1;
                        }
                        _this.field1 = _this.records[0].FIELD1;
                        _this.field2 = _this.records[0].FIELD2;
                        _this.field3 = _this.records[0].FIELD3;
                        _this.field4 = _this.records[0].FIELD4;
                        _this.field5 = _this.records[0].FIELD5;
                        _this.field6 = _this.records[0].FIELD6;
                        _this.reportName = _this.records[0].REPORT_NAME;
                        _this.fileType = _this.records[0].FILE_TYPE,
                            _this.fileSavePath = _this.records[0].FILE_SAVE_PATH,
                            //初始化归属id
                            _this.ascriptionId = _this.records[0].REPORT_ID;
                        _this.record = 1;
                        //页面加载时就进行查询图表信息
                        _this.queryEcharts();
                    }
                },
                error: function () {
                    DialogUtil.showTipDialog('系统繁忙，请稍后重试！');
                }
            });
        },
        findByReportYear: function () {
            _this = this;
            WdatePicker({
                dateFmt: 'yyyy',
                el: 'reportYear',
                maxDate: '#now',
                isShowClear: true,
                onpicking: function (dp) {
                    _this.param.REPORT_YEAR = dp.cal.getNewDateStr();
                },
                onclearing: function () {
                    _this.param.REPORT_YEAR = '';
                },
                readOnly: true
            });
        },
        //进入添加页面
        goAdd: function () {
            this.pageDialog = DialogUtil.showFullScreenDialog(this.urls.addUrl);
            $('body').css('overflow-y', 'hidden');
        },
        //提交记录
        submit: function () {
            _this = this;
            DialogUtil.showConfirmDialog("确认要提交吗？", function () {
                AjaxUtil.sendAjaxRequest("submit.vm", null,
                    {
                        "FIELD1": _this.field1,
                        "FIELD2": _this.field2,
                        "FIELD3": _this.field3,
                        "FIELD4": _this.field4,
                        "FIELD5": _this.field5,
                        "FIELD6": _this.field6,
                        "REPORT_NAME": _this.reportName,
                        "REPORT_ID": _this.ascriptionId
                    },
                    function (json) {
                        //返回的是受影响行数
                        if (json.data > 0) {
                            DialogUtil.showTipDialog("提交成功！", function () {
                                _this.initData();
                            });
                        }
                    })
            });
        },
        //进入编辑页面
        goEdit: function () {
            var _this = this;
            this.pageDialog = DialogUtil.showFullScreenDialog(_this.urls.addUrl + "?reportId=" + _this.ascriptionId + "&state=TEMP");
            $('body').css('overflow-y', 'hidden');
        },
        //删除报告文件
        deleteReportFile: function () {
            var _this = this;
            DialogUtil.showDeleteDialog('删除选中的数据，请确认！', function () {
                AjaxUtil.sendAjaxRequest("delete.vm", null,
                    {
                        "FILE_ID": _this.ascriptionId,
                        "FILE_TYPE": _this.fileType,
                        "FILE_SAVE_PATH": _this.fileSavePath
                    },
                    function (json) {
                        if (json.data == true) {
                            DialogUtil.showTipDialog('删除成功！', function () {
                                _this.initData();
                            });
                        } else {
                            DialogUtil.showTipDialog('删除失败！');
                        }
                    })
            });
        },
        pm_concentration: function (obj) {
            var myChart = echarts.init(document.getElementById('echart_1'));
            var option = new Object();
            var xPolluteArr = new Array();
            var data = new Array();
            var len = obj.length;
            var titleName = (this.param.PM == 'PM25') ? 'PM₂.₅' : 'PM₁₀ ';
            for (var i = 0; i < len; i++) {
                if (obj[i].POLLUTE == 'NH4+') {
                    data[i] = 'NH₄⁺';
                } else if (obj[i].POLLUTE == 'NO3-') {
                    data[i] = 'NO₃⁻';
                } else if (obj[i].POLLUTE == 'SO42-') {
                    data[i] = 'SO₄²⁻';
                } else {
                    data[i] = obj[i].POLLUTE;
                }
                xPolluteArr.push(data[i]);
            }
            var season = ['冬季', '春季', '夏季', '秋季', '全年'];
            var color = [];
            option = {
                title: {
                    text: titleName + '浓度时序变化图',
                    textStyle: {fontSize: 14},
                    bottom: 0,
                    left: 'center'
                },
                backgroundColor: {
                    type: 'pattern',
                    image: canvas,
                    repeat: 'repeat'
                },
                tooltip: {
                    trigger: 'axis',
                    formatter: function (params) {
                        var result = '';
                        params.forEach(function (item) {
                            result += item.marker + " " + item.seriesName + " : " + item.value + "%<br/>";
                        });
                        return params[0].name + "<br/>" + result;
                    }
                },
                legend: {
                    data: season
                },
                grid: {
                    containLabel: true,
                    show: true,
                    left: 24,
                    top: 30,
                    bottom: 30
                },
                xAxis: [
                    {
                        type: 'category',
                        name: '主要组分',
                        data: xPolluteArr,
                        axisLine: {axisTick: {show: false}}
                    }
                ],
                yAxis: [
                    {
                        type: 'value',
                        name: '主要成分占比(%)',
                        scale: false,
                        splitLine: {
                            show: false
                        },
                        show: true
                    }
                ],
                series: [
                    {
                        name: '冬季', type: 'bar', barWidth: 10,
                        itemStyle: {normal: {color: '#2ec7c9'}}, data: (function () {
                            var res = [];
                            for (var i = 0; i < len; i++) {
                                res.push(obj[i].WINTER_ZB);
                            }
                            return res;
                        })()
                    },
                    {
                        name: '春季', type: 'bar', barWidth: 10,
                        itemStyle: {normal: {color: '#b6a2de'}}, data: (function () {
                            var res = [];
                            for (var i = 0; i < len; i++) {
                                res.push(obj[i].SPRING_ZB);
                            }
                            return res;
                        })()
                    },
                    {
                        name: '夏季', type: 'bar', barWidth: 10,
                        itemStyle: {normal: {color: '#5ab1ef'}}, data: (function () {
                            var res = [];
                            for (var i = 0; i < len; i++) {
                                res.push(obj[i].SUMMER_ZB);
                            }
                            return res;
                        })()
                    },
                    {
                        name: '秋季', type: 'bar', barWidth: 10,
                        itemStyle: {normal: {color: '#ffb980'}}, data: (function () {
                            var res = [];
                            for (var i = 0; i < len; i++) {
                                res.push(obj[i].AUTUMN_ZB);
                            }
                            return res;
                        })()
                    },
                    {
                        name: '全年', type: 'bar', barWidth: 10,
                        itemStyle: {normal: {color: '#d87a80'}}, data: (function () {
                            var res = [];
                            for (var i = 0; i < len; i++) {
                                res.push(obj[i].ANNUAL_ZB);
                            }
                            return res;
                        })()
                    },
                ]
            };
            if (option && typeof option === "object") {
                myChart.setOption(option, true);
            }
            myChart.setOption(option);
        },

        sourcecomprehensive: function (obj) {
            var myChart = echarts.init(document.getElementById('echart_2'));
            var option = new Object();
            var colors = ['#2ec7c9', '#b6a2de', '#5ab1ef', '#ffb980', '#d87a80'];
            var fieldsName = (this.param.PM == 'PM25') ? 'PM25' : 'PM10';
            var titleName = (this.param.PM == 'PM25') ? 'PM₂.₅' : 'PM₁₀ ';
            var len0 = obj[0].length;
            var len1 = obj[1].length;
            var data0Arr = new Array();
            var data1Arr = new Array();
            for (var i = 0; i < len0; i++) {
                data0Arr.push({
                    name: obj[0][i].SOURCE_TYPE_NAME,
                    value: (fieldsName == 'PM25') ? obj[0][i].PM25 : obj[0][i].PM10,
                    itemStyle: {normal: {color: colors[i]}}
                });
            }
            for (var i = 0; i < len1; i++) {
                data1Arr.push({
                    name: obj[1][i].SOURCE_TYPE_NAME,
                    value: (fieldsName == 'PM25') ? obj[1][i].PM25 : obj[1][i].PM10,
                    itemStyle: {normal: {color: colors[i]}}
                });
            }
            option = {
                title: {
                    text: this.param.REPORT_YEAR + '年中心城区' + titleName + '综合源解析结果',
                    textStyle: {
                        fontSize: 14
                    },
                    left: 'center'
                },
                backgroundColor: {
                    type: 'pattern',
                    image: canvas,
                    repeat: 'repeat'
                },
                tooltip: {
                    trigger: 'item',
                    //formatter:'{b}：{d}%',
                    formatter: function (data) {
                        return data.name + ':' + data.percent.toFixed(1) + "%";
                    }
                },
                series: [
                    {
                        type: 'pie',
                        center: ['20%', '50%'],
                        radius: [0, '63%'],
                        data: data0Arr,
                        startAngle: 120,
                        labelLine: {
                            length: 2
                        },
                        label: {
                            position: 'inside',
                            //formatter:'{b}: {d}%',
                            formatter: function (data) {
                                return data.name + ':' + data.percent.toFixed(1) + "%";
                            }
                        }
                    }, {
                        type: 'pie',
                        center: ['69%', '50%'],
                        radius: [0, '50%'],
                        data: data1Arr,
                        labelLine: {
                            length: 4
                        },
                        label: {
                            //formatter:'{b}: {d}%'
                            formatter: function (data) {
                                return data.name + ':' + data.percent.toFixed(1) + "%";
                            }
                        }
                    }

                ]
            }
            if (option && typeof option === "object") {
                myChart.setOption(option, true);
            }
            myChart.setOption(option);
        },

        sourcecalendaryear: function (obj) {
            var myChart = echarts.init(document.getElementById('echart_3'));
            var option = new Object();
            var len = obj.length;
            var colors = ['#2ec7c9', '#b6a2de', '#5ab1ef', '#ffb980', '#d87a80'];
            var xYearArr = new Array();
            var dataArr = new Array();
            var dataArr1 = new Array();
            var dataArr2 = new Array();
            var dataArr3 = new Array();
            var dataArr4 = new Array();
            var dataArr5 = new Array();

            for (var i = 0; i < len; i++) {
                xYearArr.push(obj[i].YEARS);
                dataArr.push(obj[i].MOBILE);
                dataArr1.push(obj[i].INDUSTRIAL);
                dataArr2.push(obj[i].DUST);
                dataArr3.push(obj[i].RESIDENT_LIFE);
                dataArr4.push(obj[i].OTHER);
                dataArr5.push(obj[i].CONC);
            }
            var text = '';
            if (obj[0].YEARS == obj[len - 1].YEARS) {
                text = obj[0].YEARS + '年源解析';
            } else {
                text = obj[0].YEARS + '年-' + obj[len - 1].YEARS + '年历年源解析';
            }
            option = {
                /*title:{
                    text:text,
                    textStyle:{
                        fontSize:14
                        },
                    left:'center'
                },*/
                tooltip: {
                    trigger: 'axis',
                    formatter: function (params) {
                        var result = '';
                        params.forEach(function (item) {
                            if (item.seriesIndex <= 4) {
                                result += item.marker + " " + item.seriesName + " : " + item.value + "%<br/>";
                            } else {
                                result += item.marker + " " + item.seriesName + " : " + item.value + "μg/m³<br/>";
                            }
                        });
                        return params[0].name + "<br/>" + result;
                    },
                },
                backgroundColor: {
                    type: 'pattern',
                    image: canvas,
                    repeat: 'repeat'
                },
                legend: {
                    // data:['移动源','工业源','扬尘','居民生活','其他','浓度'],
                    data: ['移动源', '工业源', '扬尘', '居民生活', '其他'],
                    y: 'bottom'
                },
                yAxis: [
                    {
                        type: 'value',
                        name: '占比',
                        axisLabel: {
                            formatter: '{value}%'
                        },
                        max: 100,
                        splitLine: {
                            show: false
                        }
                    }, {
                        type: 'value',
                        name: '浓度(μg/m³)',
                        splitLine: {
                            show: false
                        }

                    }],
                xAxis: {
                    type: 'category',
                    data: xYearArr,
                },
                series: [
                    {
                        type: 'bar',
                        name: '移动源',
                        stack: '类别',
                        barWidth: 30,
                        itemStyle: {
                            normal: {color: colors[0]},
                            label: {
                                normal: {
                                    position: 'insideTop'
                                },
                                formatter: '{b}\n{c}%'
                            }
                        },
                        data: dataArr,
                        yAxisIndex: 0,
                    },
                    {
                        type: 'bar', name: '工业源', stack: '类别',
                        barWidth: 30,
                        itemStyle: {
                            normal: {color: colors[1]},
                            label: {
                                normal: {
                                    position: 'insideTop'
                                },
                                formatter: '{b}\n{c}%'
                            }
                        },
                        data: dataArr1,
                        yAxisIndex: 0
                    },
                    {
                        type: 'bar', name: '扬尘', stack: '类别',
                        barWidth: 30,
                        itemStyle: {
                            normal: {color: colors[2]},
                            label: {
                                normal: {
                                    position: 'insideTop'
                                },
                                formatter: '{d}%'
                            }
                        },
                        data: dataArr2,
                        yAxisIndex: 0
                    },
                    {
                        type: 'bar', name: '居民生活', stack: '类别',
                        barWidth: 30,
                        itemStyle: {
                            normal: {color: colors[3]},
                            label: {
                                normal: {
                                    position: 'insideTop'
                                },
                                formatter: '{b}\n{c}%'
                            }
                        },
                        data: dataArr3,
                        yAxisIndex: 0
                    },
                    {
                        type: 'bar', name: '其他', stack: '类别',
                        barWidth: 30,
                        itemStyle: {
                            normal: {color: colors[4]},
                            label: {
                                normal: {
                                    position: 'insideTop'
                                },
                                formatter: '{b}\n{c}%'
                            }
                        },
                        data: dataArr4,
                        yAxisIndex: 0
                    },
                    // {
                    //     type: 'line',
                    //     name: '浓度',
                    //     data: dataArr5,
                    //     yAxisIndex: 1
                    // }
                ]
            }
            if (option && typeof option === "object") {
                myChart.setOption(option, true);
            }
            myChart.setOption(option);

        },

        /**
         * 记录列表点击事件
         * @param record 点击的记录列表元素包含的信息
         */
        recordClick: function (record) {
            var _this = this;
            _this.state = record.STATE;
            _this.ascriptionId = record.REPORT_ID;
            _this.field1 = record.FIELD1;
            _this.field2 = record.FIELD2;
            _this.field3 = record.FIELD3;
            _this.field4 = record.FIELD4;
            _this.field5 = record.FIELD5;
            _this.field6 = record.FIELD6;
            _this.reportName = record.REPORT_NAME;
            _this.fileType = record.FILE_TYPE;
            _this.fileSavePath = record.FILE_SAVE_PATH;
            if (_this.param.PM == 'PM25') {
                _this.polluteinfo1 = record.FIELD1;
                _this.polluteinfo2 = record.FIELD2;
                _this.polluteinfo3 = record.FIELD3;
            } else {
                _this.polluteinfo1 = record.FIELD4;
                _this.polluteinfo2 = record.FIELD5;
                _this.polluteinfo3 = record.FIELD6;
            }
            _this.reportName = record.REPORT_NAME;
            _this.queryEcharts();

        },
        changePollute: function (polluteName) {
            var _this = this;
            _this.param.PM = polluteName;
        },
        /**
         * 点击查询按钮发出请求获取数据
         */
        querySourceAnalysis: function () {
            var _this = this;
            _this.queryReportListByYear();
            //表示当前年份没有报告文件和数据
            if (_this.ascriptionId == '') {
                return;
            }
        },
        //发送ajax请求查询所有图表
        queryEcharts: function () {
            var _this = this;
            //1.浓度时序图查询
            $.ajax({
                url: 'querySourceSequential.vm',
                type: 'post',
                data: {
                    POLLUTE_TYPE: _this.param.PM,
                    ASCRIPTION_ID: _this.ascriptionId
                },
                dataType: 'json',
                isShowLoader: true, // 加载动画，参考ths-jquery-ajax-loader.js
                success: function (json) {
                    var dataList = json.data;
                    if (!dataList) {
                        // DialogUtil.showTipDialog("暂无数据!");
                    } else {
                        _this.pm_concentration(dataList);
                    }
                },
                error: function () {
                    DialogUtil.showTipDialog('系统繁忙，请稍后重试！');
                }
            });
            //2.中心城区综合源解析
            $.ajax({
                url: 'querySourceComprehensive.vm',
                type: 'post',
                data: {
                    ASCRIPTION_ID: _this.ascriptionId
                },
                dataType: 'json',
                isShowLoader: true, // 加载动画，参考ths-jquery-ajax-loader.js
                success: function (json) {
                    var dataList = json.data;
                    if (!dataList) {
                        // DialogUtil.showTipDialog("暂无数据!");

                    } else {
                        _this.sourcecomprehensive(dataList);
                    }
                },
                error: function () {
                    DialogUtil.showTipDialog('系统繁忙，请稍后重试！');
                }
            });
            //3.历年源解析
            $.ajax({
                url: 'querySourceCalendarYear.vm',
                type: 'post',
                data: {
                    ASCRIPTION_ID: _this.ascriptionId,
                    POLLUTE_TYPE: _this.param.PM,
                },
                dataType: 'json',
                isShowLoader: true, // 加载动画，参考ths-jquery-ajax-loader.js
                success: function (json) {
                    var dataList = json.data;
                    if (!dataList) {
                        // DialogUtil.showTipDialog("暂无数据!");

                    } else {
                        _this.sourcecalendaryear(dataList);
                    }
                },
                error: function () {
                    DialogUtil.showTipDialog('系统繁忙，请稍后重试！');
                }
            });
        },
        /**
         * 关闭页面弹框
         * @param {boolean} isRefresh 是否刷新
         */
        closePageDialog: function (isRefresh) {
            $('body').css('overflow-y', 'auto');
            // 关闭弹框
            if (this.pageDialog) {
                this.pageDialog.close().remove();
                this.pageDialog = null;
            }
            if (isRefresh) {
                this.initData();
            }
        }
    }

})

/**
 * 表格数据格式化
 * @param val 参数
 * @returns 格式化后的参数
 */
Vue.filter('result-format', function (val) {
    if (val || val == 0) {
        return val;
    } else {
        return '--';
    }
});


//关闭dialog
function closeDialog(id) {
    vue.getDataList();
    dialog.get(id).close().remove();
}

$(window).resize(function () {          //当浏览器大小变化时
    if (vue.pageDialog) {
        vue.pageDialog.width($(window).width());
        vue.pageDialog.height($(window).height());
    }
});



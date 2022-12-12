////注册
//Vue.filter('getdate', function (date) {
//	if(date){
//		return date.replace("-","").replace("-","");
//	}
//})
var sourceDoalog = null;
//var vue=null;
var countryTipsRegions = [];
//function init() {
var vue = new Vue({
    el: '#main-container',
    data: {
        // 该功能调用的所有url列表
        urls: {
            saveWarnDailyReport: ctx + '/warnreport/dailyReport/saveWarnDailyReport.vm',
            // 报告是否有提交记录
            queryStateNumber: ctx + '/analysis/report/generalReport/queryStateNumber.vm',
            getAirDataAndForecast:ctx + '/warnreport/dailyReport/getAirDataAndForecast.vm',
        },
        reportId: reportId,
        dailyNum:201129,
        resultData: {
            // 预报ID
            STATE: '',
            FORECAST_ID: '',
            FORECAST_TIME: '',
            AREA_OPINION: '',
            HINT: '',
            INSCRIBE: '',
            DELETE_FILE_IDS: []
        },
        // 归属类型
        ascriptionType: 'WARN_DAILY_REPORT',
        txt1:{
            reDate:'2021-07-27',
            startDate:'2021-07-29',
            end_time:'2021-07-30',
            cxNum:3,
        },
        airData:[],
        forecastList:[],
    },
    created: function () {
        var _this = this;

    },
    /**
     * 页面加载完后调用
     */
    mounted: function () {
        var _this = this;
        this.$nextTick(function () {
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
            _this.queryDataIsUpload();

            _this.initEvents();
        });
    },
    methods: {

        /**
         * 查询,初始化数据
         */
        queryForecastInfo: function (opt) {
            var _this = this;
            $.ajax({
                url:_this.urls.getAirDataAndForecast,
                type: 'post',
                data: {
                    start_time: _this.txt1.startDate,
                    reportTime: _this.resultData.FORECAST_TIME
                },
                dataType: 'json',
                success: function (result) {
                    if(result.code == 200){
                        _this.airData = result.data.airDataList;
                        _this.forecastList = result.data.forecastList;
                    }
                }
            });
        },

        /**
         * 取消
         * @param {boolean} isParentRefresh 是否父页面刷新
         */
        cancel: function (isParentRefresh) {  //暂不管
            if (window.parent && window.parent.vue.closePageDialog) {
                if (isParentRefresh != true && isParentRefresh != false) {
                    isParentRefresh = false;
                }
                // 调用父页面的关闭方法
                window.parent.vue.closePageDialog(isParentRefresh);
            } else {
                window.history.go(-1);
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
                dateFmt: 'yyyy-MM-dd',
                // 是否显示清除按钮
                isShowClear: false,
                // 只读
                readOnly: true,
                // 最大时间限制，参考：http://www.my97.net/demo/index.htm
                //maxDate:'%y-%M-%d',
                onpicked: function (dp) {
                    // 确认按钮点击事件
                    _this.resultData.FORECAST_TIME = dp.cal.getNewDateStr();
                    //查询当天数据是否已提交
                    AjaxUtil.sendAjaxRequest(_this.urls.queryStateNumber, null, {
                        ascriptionType: _this.ascriptionType,
                        reportTime: _this.resultData.FORECAST_TIME
                    }, function (result) {
                        if (result.data.STATE_NUMBER > 0) {
                            DialogUtil.showTipDialog(_this.resultData.FORECAST_TIME + "的预报数据已提交，请重新选择填报日期！");
                            //if (_this.resultData.FORECAST_TIME == DateTimeUtil.getNowDate()) {
                                _this.resultData.FORECAST_TIME = '';
                                _this.airData = [];
                                _this.forecastList =[];
                           // }
                        }
                        if (_this.resultData.FORECAST_TIME != '') {
                            _this.queryForecastInfo('mounted');
                            _this.initEvents();
                            //初始化区县数据
                            $("#districtTable").children("tbody").find("tr").each(function (i, e) {
                                if (i == 0)
                                    $(e).find(".selectpicker").selectpicker('val', '');
                                else
                                    $(e).remove();
                            });
                        }
                    });
                    return _this.resultData.FORECAST_TIME;
                }
            });
        },
        /**
         *
         */
        reDatedatePicker: function () {
            var _this = this;
            WdatePicker({
                // 回显数据的对象ID
                el: 'reDate',
                // 时间格式
                dateFmt: 'yyyy-MM-dd',
                // 是否显示清除按钮
                isShowClear: false,
                // 只读
                readOnly: true,
                //maxDate:'%y-%M-%d',
                onpicked: function (dp) {
                     _this.txt1.reDate = dp.cal.getNewDateStr();
                }
            });
        },
        startDatedatePicker:function(){
            var _this = this;
            WdatePicker({
                // 回显数据的对象ID
                el: 'startDate',
                // 时间格式
                dateFmt: 'yyyy-MM-dd',
                // 是否显示清除按钮
                isShowClear: false,
                // 只读
                readOnly: true,
                // 最大时间限制，参考：http://www.my97.net/demo/index.htm
                onpicked: function (dp) {
                     _this.txt1.startDate = dp.cal.getNewDateStr();
                }
            });
        },
        /**
         * 将数组拼装好
         */
        getText:function(){
            let _this = this;
            var param = {};
            param.hint = _this.resultData.HINT;
            param.cxNum = _this.txt1.cxNum;
            param.endDateTime = _this.resultData.FORECAST_TIME;
            param.endDateHasYear = _this.getYear(_this.resultData.FORECAST_TIME)+'年'+_this.getMonth(_this.resultData.FORECAST_TIME)+'月'+_this.getDay(_this.resultData.FORECAST_TIME)+'日';
            param.dailyNum = _this.dailyNum;
            param.reDate = _this.getMonth(_this.txt1.reDate)+'月'+_this.getDay(_this.txt1.reDate)+'日';
            param.startDate = _this.getMonth(_this.txt1.startDate)+'月'+_this.getDay(_this.txt1.startDate)+'日';
            param.endDate = _this.getMonth(_this.resultData.FORECAST_TIME)+'月'+_this.getDay(_this.resultData.FORECAST_TIME)+'日';
            param.airData = "我市";
            for(let i=0;i<_this.airData.length ;i++){
                param.airData +=this.getMonth(_this.airData[i].MONITORTIME)+'月'+_this.getDay(_this.airData[i].MONITORTIME) +"日空气质量为"+_this.airData[i].AQISTATIONNAME+
                    "AQI为"+_this.airData[i].AQI+"，O3为"+_this.airData[i].O3_8+"微克/立方米"+(i == _this.airData.length-1?"。":";");
            }
            param.forecastDate = "";
            for(let i=0;i<_this.forecastList.length ;i++){
                if(_this.forecastList[i].AQI_LEVEL != '优' && (_this.forecastList[i].PRIM_POLLUTE == '' || _this.forecastList[i].PRIM_POLLUTE == null )){
                    DialogUtil.showTipDialog("当污染级别不是优时，必须选择首要污染物！");
                    return false;
                }
                param.forecastDate +=this.getMonth(_this.forecastList[i].RESULT_TIME)+'月'+_this.getDay(_this.forecastList[i].RESULT_TIME) +
                    '气象扩散条件为'+_this.forecastList[i].WEATHER_LEVEL+'，预计AQI为'+_this.forecastList[i].AQI+'，空气质量等级为' +
                _this.forecastList[i].AQI_LEVEL+'，首要污染物为'+_this.forecastList[i].PRIM_POLLUTE+(i == _this.forecastList.length-1?"。":";");
            }
            return param;
        },
        /**
         * 保存
         */
        saveData: function (code) {
            var _this = this;
            // 验证表单
            var flag = $('#mainForm').validationEngine('validate');
            if (!flag) {
//				// 验证不通过，不提交
                return;
            }
            var param = _this.getText();
            if(param == false){
                return;
            }
            var tipMessage=_this.getSaveTipMessage();
            DialogUtil.showConfirmDialog(tipMessage.confirmMessage, function () {
                AjaxUtil.sendAjax(_this.urls.saveWarnDailyReport, param, function () {
                    DialogUtil.showTipDialog(tipMessage.successMessage, function () {
                        _this.cancel(true);
                    }, function () {
                        _this.cancel(true);
                    });
                });
            });
        },
        getstate: function (str1, str2) {
            if (str1 == null || str1 == '') {
                return -1;
            }
            return str1.indexOf(str2);
        },
        /**
         * 获取天
         * @param str
         * @returns {string}
         */
       getDay:function(str){
          return  str.substring(8,10);
       },
        /**
         *获取月
         * @param str
         * @returns {string}
         */
       getMonth:function(str){
           return  str.substring(5,7);
       },
        /**
         * 获取年
         * @param str
         * @returns {string}
         */
       getYear:function(str){
           return  str.substring(0,4);
       },
        /**
         * 查询数据是否提交
         */
        queryDataIsUpload: function () {
            let _this = this;
            let nowDate = DateTimeUtil.getNowDate();
            AjaxUtil.sendAjaxRequest(_this.urls.queryStateNumber, null, {
                ascriptionType: _this.ascriptionType,
                reportTime: nowDate
            }, function (result) {
                if (result.data.STATE_NUMBER == 0) {
                    _this.resultData.FORECAST_TIME = nowDate;
                    _this.queryForecastInfo('mounted');
                } else {
                    _this.resultData.FORECAST_TIME = '';
                }
            })
        },
        /**
         * 获取保存提示信息
         */
        getSaveTipMessage: function () {
            var tipMessage = null;
            tipMessage = {
                confirmMessage: '提交选中的数据，提交成功后将不能编辑和删除，请确认！',
                successMessage: '提交成功！'
            }
            return tipMessage;
        },
        /**
         * 将基础数据添加到表单数据中
         * @param {FormData} formData 表单数据对象
         * @returns {FormData} formData 表单数据对象
         */
        appendBaseDataToForm: function (formData) {
            for (var key in this.resultData) {
                formData.append(key, this.resultData[key]);
            }
            return formData;
        },
        /**
         * 获取污染源等级
         */
        getlevel: function (value) {
            var result = "";
            if (0 <= value && value <= 50) {
                result = "优";
            } else if (50 < value && value <= 100) {
                result = "良";
            } else if (100 < value && value <= 150) {
                result = "轻度污染";
            } else if (150 < value && value <= 200) {
                result = "中度污染";
            } else if (200 < value && value <= 300) {
                result = "重度污染";
            } else if (300 < value) {
                result = "严重污染";
            } else {
                result = "无";
            }
            return result
        },
        cancelDialog: function () {
            sourceDoalog.close().remove();
        },
        //判断是否是选中的城市
        getIsSelect: function (regioncode, regioncodes) {
            if (regioncodes) {
                var array = regioncodes.split(',');
                if (array.indexOf(regioncode) >= 0) {
                    return true;
                }
                return false;
            }
            return false;
        },
        showCommonSubTaskDialog: function (callback) {
            sourceDoalog = dialog({
                id: "sourceSelection",
                title: '批量选择首要污染物',
                width: $(window).width() * 0.4,
                height: $(window).height() > 100 ? 100 : $(window).height(),
                content: document.getElementById('sourceSelection'),
            });
            sourceDoalog.showModal();
        },

        /**
         * 用jquery,初始化一些点击事件
         */
        initEvents: function () {
            var _this = this;
            $(".open_modal").on("click", function () {
                var pulltype = $(this).attr("pulltype");
                _this.showCommonSubTaskDialog(function (subTaskList) {

                });
                //	$('#myModal').modal('show');
                $('#sourceSelection').attr("pulltype", pulltype);
            })
            $(".pull_modal").on("click", function () {
                var pulltype = $('#sourceSelection').attr("pulltype");
                var select = ".selectpull" + pulltype;
                var pulls = new Array();
                $("input[name=pull]:checked").each(function (i, e) {
                    pulls.push($(this).val())
                });
                $(select).selectpicker('val', pulls);
                //$('#myModal').modal('hide');
                sourceDoalog.close().remove();

            });
            $("input[name=pull]").on("change", function () {
                var length = $("input[name=pull]:checked").length
                if (length > 2) {
                    $(".modal_label").text("*最多选择2项!")
                    this.checked = false;
                } else {
                    $(".modal_label").text("")
                }
            })
        },
        exportData: function () {
            ths.submitFormAjax({
                url: ctx + '/eform/exceltemplate/checkdownload.vm',// any URL you want
                                                                   // to submit
                data: $("#formhidden").serialize(),
                success: function (response) {
                    if (response.returnMessage == 'OK') {
                        $("#formhidden").submit();
                    } else {
                        dialog({
                            title: '信息',
                            content: response.returnMessage,
                            ok: function () {
                            }
                        }).showModal();
                    }
                }
            });
        }
    }
});
//}
//关闭dialog
function closeDialog(id, mess) {
    if (mess == 'success') {
        vue.doSearch();
    }
    dialog.get(id).close().remove();
}

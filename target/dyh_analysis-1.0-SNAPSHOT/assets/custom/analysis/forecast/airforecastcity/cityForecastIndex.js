/*var health_level = ['', '优', '优-良', '良', '良-轻度污染', '轻度污染', '轻度-中度污染', '中度污染', '中度-重度污染', '重度污染', '重度-严重污染', '严重污染'];
var primpollutes = ['PM2.5', 'PM10', 'O3', 'NO2', 'SO2', 'CO'];
var primpollutes2 = ['PM₂.₅', 'PM₁₀', 'O₃', 'NO₂', 'SO₂', 'CO'];*/
/*var aqiValArr = [-1, 50, 100, 150, 200, 300];
var aqiTextArr = ['优', '良', '轻度污染', '中度污染', '重度污染', '严重污染'];
var levelNameArr = ['好', '较好', '中等偏好', '中等', '中等偏差', '较差', '差', '极差'];
var levelInfoArr = ['非常有利于空气污染物稀释、扩散和清除', '较有利于空气污染物稀释、扩散和清除', '对空气污染物稀释、扩散和清除无明显影响',
    '对空气污染物稀释、扩散和清除无明显影响', '对空气污染物稀释、扩散和清除无明显影响', '不利于空气污染物稀释、扩散和清除',
    '很不利于空气污染物稀释、扩散和清除', '极不利于空气污染物稀释、扩散和清除'];
var flowState = 0;*/
var vue = new Vue({
    el: '#main-container',
    data: {
        // 该功能调用的所有url列表
        urls: {
            cityForecastInfoById: ctx + '/analysis/forecastflow/forecastflowcity/cityForecastInfoById.vm',
            saveCityForecastInfo: ctx + '/analysis/forecastflow/forecastflowcity/saveCityForecastInfo.vm',
            // 报告是否有提交记录
            queryStateNumber: ctx + '/analysis/report/generalReport/queryStateNumber.vm',
        },
        reportId: reportId,
        isAdd: isAdd,
        primpollutes: [{code: 'PM2.5', name: 'PM₂.₅'}, {code: 'PM10', name: 'PM₁₀'}, {
            code: 'O3',
            name: 'O₃'
        }, {code: 'NO2', name: 'NO₂'}, {code: 'SO2', name: 'SO₂'}, {code: 'CO', name: 'CO'}],
        levelNameArr: ['1级', '1-2级', '2级', '2-3级', '3级', '3-4级', '4级', '4-5级', '5级', '5-6级', '6级'],
        weatherConditionsTypeArr: [{code: '1', name: '臭氧污染气象条件'}, {code: '2', name: '气象扩散条件'}],
        showFlag: showFlag,
        // 城市预报对应的主信息
        resultData: {
            // 预报ID
            STATE: '',
            FORECAST_ID: '',
            FORECAST_TIME: '',
            FORECAST_THREE_CITY: '',
            FORECAST_THREE: '',
            FORECAST_SEVEN_CITY: '',
            FORECAST_SEVEN: '',
            HINT: '',
            HINT_7DAY: '',
            INSCRIBE: '',
            //上一次的文件归属id
            oldAscriptionId: '',
            DELETE_FILE_IDS: [],
            //气象条件类型（1：臭氧污染气象条件2：气象扩散条件）
            weatherConditionsType:1,
        },
        sevenDaysTable: [],
        fileList: [],
        //3天预报和7天预报的选中状态
        threeday: false,
        sevenday: false,
        // 归属类型
        ascriptionType: 'CITY_FORECAST',
        uploadAscriptionType: 'UPLOAD',
    },
    watch: {
        sevenDaysTable: {
            handler(list) {
                for (let i = 0; i < list.length; i++) {
                    if (list[i].AQI_LEVEL == '优') {
                        list[i].PRIM_POLLUTE = ''
                    }
                }
            },
            // 这里是关键，代表递归监听 demo 的变化
            deep: true
        }
    },
    /**
     * 页面加载完后调用
     */
    mounted: function () {
        // 将回调延迟到下次 DOM 更新循环之后执行。在修改数据之后立即使用它，然后等待 DOM 更新
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
            // 初始化会商时间（通过计算属性获取当前时间）

            //新增，设置为默认时间
            this.queryDataIsUpload();
        });
    },
    methods: {
        /**
         * 查询数据是否提交
         */
        queryDataIsUpload: function () {
            let _this = this;
            var param = {};
            if (_this.isAdd!=1) {
                param = {
                    ascriptionType: _this.ascriptionType,
                    reportId: reportId
                }
            } else {
                param = {
                    ascriptionType: _this.ascriptionType,
                    reportTime: DateTimeUtil.getNowDate()
                }
            }
            AjaxUtil.sendAjaxRequest(_this.urls.queryStateNumber, null, param, function (result) {
                if (result.data.STATE_NUMBER == 0) {
                    _this.resultData.FORECAST_TIME = DateTimeUtil.getNowDate();
                    _this.queryForecastInfo();
                    // _this.initEvents();
                } else {
                    _this.resultData.FORECAST_TIME = '';
                }
            })
        },
        getAqiLevel: function (val) {
            for (var i = aqiValArr.length - 1; i >= 0; i--) {
                if (val > aqiValArr[i]) {
                    return i + 1;
                }
            }
        },
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
        /**
         * 获取数值~之前的值
         * @param str
         * @returns {null|*|string}
         */
        getBefore: function (str) {
            if (str) {
                return str.split("~")[0];
            }
            return 0;
        },
        /**
         * 获取数值~之后的值
         * @param str
         * @returns {null|*|string}
         */
        getAfter: function (str) {
            if (str) {
                return str.split("~")[1];
            }
            return 0;
        },
        /**
         * 根据中值计算空气级别
         */
        getAqilevel: function (numMedian) {
            let _this = this;
            var before = _this.getlevel((numMedian - 15) < 0 ? 0 : (numMedian - 15));
            var after = _this.getlevel(numMedian + 15);
            if (before == after) {
                result = before;
            } else {
                if (before == "优") {
                    result = before + "或" + after;
                } else if (before == "良") {
                    result = before + "至" + after;
                } else {
                    result = before.substring(0, 2) + "至" + after;
                }
            }
            return result
        },
        /**
         * 修改PM25或O3
         */
        changePm25OrO3: function (index, type) {
            let _this = this;
            let numMedian = parseInt(_this.sevenDaysTable[index][type + '_MEDIAN']);
            if (numMedian >= 0 && numMedian != undefined && numMedian != '' && numMedian != null && !isNaN(numMedian)) {
                //获取IAQI
                _this.getpollutantRange(type, numMedian, index);
            }
        },
        /**
         * 修改AQI
         */
        changeAqi: function (index) {
            let _this = this;
            let maxValue = _this.sevenDaysTable[index].O3_IAQI;
            if (_this.sevenDaysTable[index].PM25_IAQI > _this.sevenDaysTable[index].O3_IAQI) {
                maxValue = _this.sevenDaysTable[index].PM25_IAQI;
            }
            let numMedian = parseInt(_this.sevenDaysTable[index].AQI_MEDIAN);
            if (numMedian < maxValue) {
                DialogUtil.showTipDialog("AQI必须≥" + maxValue)
                _this.sevenDaysTable[index].AQI = ''
                _this.sevenDaysTable[index].AQI_MEDIAN = ''
                _this.sevenDaysTable[index].AQI_MAX = ''
                _this.sevenDaysTable[index].AQI_MIN = ''
                _this.sevenDaysTable[index].AQI_LEVEL = ''
            } else {
                _this.sevenDaysTable[index].AQI = ((numMedian - 15) < 0 ? 0 : (numMedian - 15)) + '~' + (numMedian + 15);
                _this.sevenDaysTable[index].AQI_MIN = (numMedian - 15) < 0 ? 0 : (numMedian - 15);
                _this.sevenDaysTable[index].AQI_MAX = numMedian + 15;
                _this.sevenDaysTable[index].AQI_LEVEL = _this.getAqilevel(numMedian);
            }
        },
        /**
         * 修改POLLUTE
         */
        changePollute: function (index) {
            let _this = this;

            if (_this.sevenDaysTable[index].PRIM_POLLUTE == 'PM2.5' || _this.sevenDaysTable[index].PRIM_POLLUTE == 'O3') {
                if (_this.sevenDaysTable[index].PM25_IAQI && _this.sevenDaysTable[index].O3_IAQI) {
                    if (_this.sevenDaysTable[index].PM25_IAQI > _this.sevenDaysTable[index].O3_IAQI) {
                        _this.sevenDaysTable[index].PRIM_POLLUTE = 'PM2.5';
                        _this.assignmentAqi(index, 'PM25')
                    } else if (_this.sevenDaysTable[index].PM25_IAQI < _this.sevenDaysTable[index].O3_IAQI) {
                        _this.sevenDaysTable[index].PRIM_POLLUTE = 'O3';
                        _this.assignmentAqi(index, 'O3')
                    }
                }
            }
        },
        /**
         * 为AQI赋值
         * @param type
         */
        assignmentAqi: function (index, type) {
            let _this = this;
            _this.sevenDaysTable[index].AQI = _this.sevenDaysTable[index][type + '_MIN_IAQI'] + '~' + _this.sevenDaysTable[index][type + '_MAX_IAQI'];
            _this.sevenDaysTable[index].AQI_MEDIAN = parseInt(_this.sevenDaysTable[index][type + '_IAQI']) < 15 ? ((0 + parseInt(_this.sevenDaysTable[index][type + '_MAX_IAQI'])) / 2) : (parseInt(_this.sevenDaysTable[index][type + '_MIN_IAQI']) + parseInt(_this.sevenDaysTable[index][type + '_MAX_IAQI'])) / 2;
            _this.sevenDaysTable[index].AQI_LEVEL = _this.getAqilevel(_this.sevenDaysTable[index].AQI_MEDIAN);
            _this.sevenDaysTable[index].AQI_MIN = _this.sevenDaysTable[index][type + '_MIN_IAQI'];
            _this.sevenDaysTable[index].AQI_MAX = _this.sevenDaysTable[index][type + '_MAX_IAQI'];
        },
        /**
         * 通过类型和中值，查询范围和iaqi的范围
         */
        getpollutantRange: function (type, numMedian, index) {
            var _this = this;
            $.ajax({
                url: 'getpollutantRange.vm',
                type: 'post',
                data: {
                    type: type == 'O3' ? 'O3_8' : type,
                    numMedian: numMedian
                },
                dataType: 'json',
                success: function (json) {
                    if (json.data) {
                        _this.sevenDaysTable[index][type] = json.data.minNum + '~' + json.data.maxNum;
                        _this.sevenDaysTable[index][type + '_MIN'] = json.data.minNum;
                        _this.sevenDaysTable[index][type + '_MAX'] = json.data.maxNum;
                        _this.sevenDaysTable[index][type + '_MIN_IAQI'] = json.data.minMedian;
                        _this.sevenDaysTable[index][type + '_MAX_IAQI'] = json.data.maxMedian;
                        _this.sevenDaysTable[index][type + '_IAQI'] = json.data.iAqi;
                        let maxValue = _this.sevenDaysTable[index].O3_IAQI;
                        if (_this.sevenDaysTable[index].PM25_IAQI >= _this.sevenDaysTable[index].O3_IAQI) {
                            maxValue = _this.sevenDaysTable[index].PM25_IAQI;
                        }
                        if (maxValue >= _this.sevenDaysTable[index].AQI_MEDIAN) {
                            _this.sevenDaysTable[index].PRIM_POLLUTE = type == 'PM25' ? 'PM2.5' : type;
                        }
                        if (_this.sevenDaysTable[index].PRIM_POLLUTE == 'O3' || _this.sevenDaysTable[index].PRIM_POLLUTE == 'PM2.5'
                            || _this.sevenDaysTable[index].PRIM_POLLUTE == '' || _this.sevenDaysTable[index].PRIM_POLLUTE == null) {
                            if (_this.sevenDaysTable[index].PM25_IAQI >= _this.sevenDaysTable[index].O3_IAQI) {
                                _this.assignmentAqi(index, 'PM25')
                                if (_this.getAqilevel(_this.sevenDaysTable[index].PM25_IAQI) != '优' && _this.sevenDaysTable[index].PM25_IAQI >= _this.sevenDaysTable[index].AQI_MEDIAN) {
                                    _this.sevenDaysTable[index].PRIM_POLLUTE = 'PM2.5'
                                } else {
                                    _this.sevenDaysTable[index].PRIM_POLLUTE = null
                                }
                            } else {
                                _this.assignmentAqi(index, 'O3')
                                if (_this.getAqilevel(_this.sevenDaysTable[index].O3_IAQI) != '优' && _this.sevenDaysTable[index].O3_IAQI >= _this.sevenDaysTable[index].AQI_MEDIAN) {
                                    _this.sevenDaysTable[index].PRIM_POLLUTE = 'O3'
                                } else {
                                    _this.sevenDaysTable[index].PRIM_POLLUTE = null
                                }
                            }
                        }
                    }
                },
                error: function () {
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
         * 判断污染级别和首污的必填是否对应
         * @returns {boolean}
         */
        cheakAqiLevel: function () {
            let _this = this;
            for (let i = 0; i < _this.sevenDaysTable.length; i++) {
                if (_this.sevenDaysTable[i].AQI_LEVEL != '优' && (_this.sevenDaysTable[i].PRIM_POLLUTE == null || _this.sevenDaysTable[i].PRIM_POLLUTE == "")) {
                    DialogUtil.showTipDialog("当污染级别不是优时，必须选择首要污染物！");
                    return false;
                } else if (_this.sevenDaysTable[i].AQI_LEVEL == '优' && _this.sevenDaysTable[i].PRIM_POLLUTE != null && _this.sevenDaysTable[i].PRIM_POLLUTE != "") {
                    DialogUtil.showTipDialog("污染级别为优时不存在首要污染物！");
                    return false;
                }
            }
            return true;
        },
        /**
         * 保存
         */
        saveData: function (btnType) {
            var _this = this;
            // 验证表单
            var flag = $('#mainForm').validationEngine('validate');
            if (!flag || !_this.cheakAqiLevel()) {
                return;
            }
            // 验证表格
            var param = {};
            param.flow_state = '0';
            param = _this.sevenDaysTable;
            if (!param) {
                return;
            }
            // 将文件添加到表单数据中
            var formData = new MyFormData();
            if (formData == null) {
                return;
            }
            // 将基础数据添加到表单数据中
            _this.resultData.STATE = btnType;
            formData = _this.appendBaseDataToForm(formData);
            formData.append("weatherConditionsType", _this.resultData.weatherConditionsType);
            formData.append("TableList", JSON.stringify(param));
            formData.append("isAdd", _this.isAdd);
            //获取当前时间
            var newDate = _this.getNewDate();
            var tipMessage = _this.getSaveTipMessage(btnType);
            if (btnType == 'UPLOAD' && parseInt(newDate.HOUR) >= 16 && _this.resultData.FORECAST_TIME == newDate.DATE) {
                //把3天预报和7天预报的勾选状态追加上
                var s = dialog({
                    id: "divmessdialog",
                    title: '提示',
                    width: $(window).width() * 0.5,
                    height: 150,
                    content: document.getElementById('divmessdialog'),
                    okValue: '确定',
                    ok: function () {
                        formData.append("THREESTATE", _this.threeday);
                        formData.append("SEVENSTATE", _this.sevenday);
                        AjaxUtil.sendFileUploadAjaxRequest(_this.urls.saveCityForecastInfo, formData, function () {
                            DialogUtil.showDeleteDialog(tipMessage.successMessage, function () {
                                //推送数据至省站
                                _this.pushData();
                            }, function () {
                                _this.cancel(true);
                            });
                        });
                    },
                    cancelValue: '取消',
                    cancel: function () {
                        s.close().remove();
                    }
                });
                s.showModal();
            } else {
                DialogUtil.showConfirmDialog(tipMessage.confirmMessage, function () {
                    AjaxUtil.sendFileUploadAjaxRequest(_this.urls.saveCityForecastInfo, formData, function () {
                        if (btnType == 'UPLOAD') {
                            DialogUtil.showDeleteDialog(tipMessage.successMessage, function () {
                                //推送数据至省站
                                _this.pushData();
                            }, function () {
                                _this.cancel(true);
                            });
                        } else {
                            DialogUtil.showTipDialog(tipMessage.successMessage, function () {
                                _this.cancel(true);
                            });
                        }
                    });
                });
            }
        },

        /**
         * 推送数据至省站
         */
        pushData:async function (){
            const _this = this;
            //获取数据
            let forecastInfo = await AjaxUtil.sendAjax('queryCityForecastByReportId.vm',{
                reportId: _this.reportId
            });
            let userName = '';
            let forecastTime = '';
            let dataList = [];
            if (forecastInfo && forecastInfo.data){
                userName = forecastInfo.data['EDIT_USER'];
                forecastTime = forecastInfo.data['REPORT_TIME'].split(" ")[0];
                dataList = forecastInfo.data['CITY_FORECAST_AQI_LIST'];
            }
            //获取省站对应用户信息
            let userId = "";
            for (let i = 0; i <userInfo.length; i++) {
                if (userName === userInfo[i].userName){
                    userId = userInfo[i].userId;
                    break;
                }
            }
            if (!userId){
                userName = userInfo[0].userName;
                userId = userInfo[0].userId;
            }
            let paramMap = assembleData(forecastTime, dataList, userName);
            Vue.set(paramMap, "userId", userId);
            Vue.set(paramMap, "infoId", forecastInfo.data["INFO_ID"]);
            await AjaxUtil.sendAjaxJson("pushData.vm",paramMap,function (result) {
                DialogUtil.showTipDialog("推送成功！");
                _this.cancel(true);
            },function (result) {
                DialogUtil.showTipDialog("数据推送省站失败！");
            },function (result) {
                DialogUtil.showTipDialog("数据推送省站失败！");
            })
        },

        /**
         * 从后台获取当前时间
         */
        getNewDate: function () {
            var _this = this;
            var newDate = {};
            $.ajax({
                url: ctx + '/analysis/forecastflow/forecastflowcity/getNewDate.vm',
                isShowLoader: true,
                type: 'post',
                async: false,
                data: '',
                dataType: 'json',
                success: function (resultData) {
                    newDate = resultData.data;
                },
                error: function () {
                    _this.showMessageDialog('网络连接失败！');
                },
            });
            return newDate;
        },
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
         * 获取保存提示信息
         */
        getSaveTipMessage: function (state) {
            var tipMessage = null;
            if (state === 'UPLOAD') {
                tipMessage = {
                    confirmMessage: '提交选中的数据，提交成功后将不能编辑和删除，请确认！',
                    successMessage: '提交成功，是否推送数据至省站？'
                }
            } else {
                tipMessage = {
                    confirmMessage: '暂存数据，请确认！',
                    successMessage: '暂存成功！'
                }
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
                maxDate: '%y-%M-%d',
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
                            _this.resultData.FORECAST_TIME = '';
                            /*if (_this.resultData.FORECAST_TIME == DateTimeUtil.getNowDate()) {
                                _this.resultData.FORECAST_TIME = '';
                            } else {
                                _this.resultData.FORECAST_TIME = DateTimeUtil.getNowDate();
                            }*/

                        }
                        if (_this.resultData.FORECAST_TIME != '') {
                            _this.queryForecastInfo();
                            // _this.initEvents();
                        }

                    })
                }
            });
        },
        queryForecastInfo: function () {
            var _this = this;
            $.ajax({
                url: 'getCityForecastInfo.vm',
                type: 'post',
                data: {
                    reportId: _this.isAdd==1?'':$('#reportIdInput').val(),
                    newdatetime: _this.resultData.FORECAST_TIME
                },
                dataType: 'json',
                success: function (result) {
                    if (result.success) {
                        //首污多选回显拼接
                        /* for (let i = 0; i < result.dataList.length; i++) {
                             var primPollutes =  result.dataList[i].PRIM_POLLUTE;
                             if(primPollutes != null ){
                                 var primPolluteArr = primPollutes.split(",");
                                 result.dataList[i].PRIM_POLLUTE = primPolluteArr;
                             }
                         }*/
                        _this.sevenDaysTable = result.dataList;
                        //当前月份
                        let month = parseInt(_this.resultData.FORECAST_TIME.substring(5,7));
                        var data = {
                            // 预报ID
                            FORECAST_ID: $('#reportIdInput').val(),
                            FORECAST_TIME: result.info.REPORT_TIME.substr(0, 10),
                            FORECAST_THREE_CITY: result.info.CITY_OPINION_3DAY,
                            FORECAST_THREE: result.info.COUNTRY_OPINION_3DAY,
                            FORECAST_SEVEN_CITY: result.info.CITY_OPINION,
                            FORECAST_SEVEN: result.info.COUNTRY_OPINION,
                            HINT: result.info.IMPORTANT_HINTS,
                            HINT_7DAY: result.info.IMPORTANT_HINTS_SEVEN,
                            INSCRIBE: result.info.INSCRIBE,
                            oldAscriptionId: '',
                            // weatherConditionsType: result.info.WEATHER_CONDITIONS_TYPE != undefined ? result.info.WEATHER_CONDITIONS_TYPE : 1
                            weatherConditionsType: (month >= 5 && month <= 9)? 1 : 2
                        }
                        _this.resultData = data;
                        if (result.info.INFO_ID) {
                            _this.resultData.oldAscriptionId = result.info.INFO_ID;
                        }
                        if (_this.resultData.INSCRIBE == '') {
                            _this.resultData.INSCRIBE = '成都市环境保护科学研究院、成都平原经济区环境气象中心';
                        }
                    } else {
                        alert(result.msg);
                    }
                }
            });
        },
    }
});

function setSpecialSelectorVal(obj) {
    $(obj).next().val($(obj).val());
    $(obj).blur();
}



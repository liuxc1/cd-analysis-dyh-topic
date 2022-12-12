/** 冬季快报分析报告-编辑逻辑js **/
new Vue({
    el: '#main-container',
    data: {
        urls: {
            queryDayGeneralReportByIdAndFileSourceUrl: ctx + '/analysis/analysisreport/winterExpress/queryDayGeneralReportByIdAndFileSource.vm',
            saveForecastUrl: ctx + '/analysis/analysisreport/winterExpress/saveWinterExpress.vm',
            queryStateNumber: ctx + '/analysis/report/generalReport/queryStateNumber.vm',
            getRegionPoint: ctx + '/analysis/analysisreport/winterExpress/getRegionPoint.vm',
        },
        yearMonthDayHour: '',
        report: {
            // 图片类型
            ascriptionType: '',
            // 报告时间（填报时间）
            reportTime: '',
            // 重要提示
            reportTip: '',
            // 状态
            state: '',
            generateContentOne: '',
            generateContentTwo: '',

            //污染过程

            //污染前一天
            pollutionTheDayBefore: '',
            //污染天气情况
            pollutionWeatherConditions: '',
            //影响因素
            pollutionInfluencingFactors: '',
            //影响因素增加或减少
            pollutionInfluencingFactorsIncreaseOrDecrease: '',
            //边界层（上升/下降）
            pollutionInBoundary: '',
            //边界层高度
            pollutionInBoundaryLayer: '',
            //污染物积累速度
            pollutionAccumulationSpeed: '',
            //污染连续小时
            pollutionConsecutiveHours: '',
            //污染等级
            pollutionLevel: '',
            //午后天气状况
            pollutionAfternoonSkyConditions: '',
            //湿度情况
            pollutionHumidity: '',
            //午后边界层状况
            pollutionBoundaryLayerCondition: '',
            //垂直扩散条件状况
            pollutionVerticalDiffusionConditions: '',
            //空气质量等级
            pollutionAirQualityLevel: '',
            //夜间边界层情况
            pollutionNocturnalBoundaryLayer: '',
            //夜间空气质量时间
            pollutionNightAirQualityTime: '',
            //夜间空气质量等级
            pollutionNightAirQualityLevel: '',
            //全体空气质量等级
            pollutionAirQualityThroughoutTheDay: '',
            //AQI
            pollutantAqi: '',
            //首要污染物
            pollutantPrimary: '',
            //污染区县
            pollutantDistrict: '',
            //区县污染等级
            pollutionCountyPollutionLevel: '',
            //其余县污染等级
            pollutionLevelOfOtherCounties: '',
            //污染情况
            pollutionCondition: '',
            //污染当天
            pollutionThatDay: '',
            //逆温温度
            pollutionInversion: '',
            //污染当天空气质量转换时间
            pollutionConversionTime: '',
            //污染当天空气质量等级
            pollutionThatDayGrade: '',
            //站点空气质量情况
            pollutionSiteSituation: '',
            //区县空气质量情况
            pollutionCountySituation: '',
            //区域污染情况
            pollutionRegional: ''
        },
    },
    // 页面加载完后调用
    mounted: function () {
        // 将回调延迟到下次 DOM 更新循环之后执行。在修改数据之后立即使用它，然后等待 DOM 更新
        this.$nextTick(function () {
            // // 归属类型
            this.report.ascriptionType = $('#ascription-type').val();
            this.initData();
            // 注册表单验证
            $('#mainForm').validationEngine({
                scrollOffset: 98, // 屏幕自动滚动到第一个验证不通过的位置。必须设置，因为Toolbar position为Fixed
                promptPosition: 'bottomLeft', // 提示框位置为下左
                autoHidePrompt: true, // 自动隐藏提示框
                validateNonVisibleFields: true // 不可见字段验证
            });
        });
    },
    methods: {
        /**
         * 初始化数据，获取全部数据，包括图片信息
         */
        initData: function () {
            var _this = this;
            let nowDate = DateTimeUtil.getNowTimeHour();
            var param = {};
            if (reportId != null && reportId != undefined && reportId != '') {
                param = {
                    ascriptionType: _this.report.ascriptionType,
                    reportId: reportId
                }
            } else {
                param = {
                    ascriptionType: _this.report.ascriptionType,
                    reportTime: nowDate.substring(0, 10)
                }
            }
            AjaxUtil.sendAjaxRequest(_this.urls.queryStateNumber, null, param, function (json) {
                if (json.data.STATE_NUMBER == 0) {
                    _this.yearMonthDayHour = nowDate;
                    _this.initReportData();
                } else {
                    DialogUtil.showTipDialog(nowDate.substring(0, 10) + "数据已提交，请重新选择填报日期！");
                    _this.noData();
                }
            });
        },
        getDate: function (strDate) {
            var _this = this;
            var date = eval('new Date(' + strDate.replace(/\d+(?=-[^-]+$)/,
                function (a) {
                    return parseInt(a, 10) - 1;
                }).match(/\d+/g) + ')');

            yesterday = +date - (1000 * 60 * 60 * 24);
            yesterday = new Date(yesterday);
            //判断是月的第一天，显示月份
            //污染前一天
            _this.report.pollutionThatDay = date.getDate();
            //污染当天
            _this.report.pollutionTheDayBefore = yesterday.getDate();
            if (date.getDate() == 1) {
                _this.report.pollutionThatDay = date.getMonth() + 1 + '月' + date.getDate();
                _this.report.pollutionTheDayBefore = yesterday.getMonth() + 1 + '月' + yesterday.getDate();
            }
            //判断是当前第一个月的第一天，显示年月日
            if ((date.getMonth() + 1) == 1 && date.getDate() == 1) {
                _this.report.pollutionThatDay = date.getFullYear() + '年' + (date.getMonth() + 1) + '月' + date.getDate();
                _this.report.pollutionTheDayBefore = yesterday.getFullYear() + '年' + (yesterday.getMonth() + 1) + '月' + yesterday.getDate();
            }

        },
        /**
         * 查询选中天的监测数据。
         */
        getRegionPoint: function () {
            var _this = this;
            AjaxUtil.sendAjaxRequest(_this.urls.getRegionPoint, null, {
                reportTime: _this.yearMonthDayHour.substring(0, 10)
            }, function (json) {
                if (json.data && json.data.length > 0) {
                    _this.report.pollutantAqi = json.data[0].aqi;
                    _this.report.pollutantPrimary = json.data[0].primaryPollutant == null ? '--' : json.data[0].primaryPollutant;
                } else {
                    _this.report.pollutantAqi = '';
                    _this.report.pollutantPrimary = '';
                }
            });
        },
        /**
         * 初始化数据
         */
        initReportData: function () {
            var _this = this;
            AjaxUtil.sendAjaxRequest(_this.urls.queryDayGeneralReportByIdAndFileSourceUrl, null, {
                ascriptionType: _this.report.ascriptionType,
                reportTime: _this.yearMonthDayHour.substring(0, 10),
                reportId: $('#report-id').val()
            }, function (json) {
                _this.report = json.data;
                _this.yearMonthDayHour = json.data.reportTime;
            }, function () {
                _this.getRegionPoint();
                _this.report.reportTime = '';
                _this.report.reportTip = '';
                _this.report.state = '';
                _this.report.generateContentOne = '';
                _this.report.generateContentTwo = '';
                _this.removeDefaultDate();
                _this.getDate(_this.yearMonthDayHour);
            });
        },
        /**
         * 无数据
         */
        noData: function () {
            let _this = this;
            _this.yearMonthDayHour = '';
            _this.report.reportTime = '';
            _this.report.reportTip = '';
            _this.report.state = '';
            _this.report.generateContentOne = '';
            _this.report.generateContentTwo = '';
            _this.removeDefaultDate();
        },
        /**
         * 删除默认数据
         */
        removeDefaultDate: function () {
            var _this = this;
            _this.report.pollutionTheDayBefore = '',
                _this.report.pollutionWeatherConditions = '',
                _this.report.pollutionInfluencingFactors = '',
                _this.report.pollutionInfluencingFactorsIncreaseOrDecrease = '',
                _this.report.pollutionInBoundary = '',
                _this.report.pollutionInBoundaryLayer = '',
                _this.report.pollutionAccumulationSpeed = '',
                _this.report.pollutionConsecutiveHours = '',
                _this.report.pollutionLevel = '',
                _this.report.pollutionAfternoonSkyConditions = '',
                _this.report.pollutionHumidity = '',
                _this.report.pollutionBoundaryLayerCondition = '',
                _this.report.pollutionVerticalDiffusionConditions = '',
                _this.report.pollutionAirQualityLevel = '',
                _this.report.pollutionNocturnalBoundaryLayer = '',
                _this.report.pollutionNightAirQualityTime = '',
                _this.report.pollutionNightAirQualityLevel = '',
                _this.report.pollutionAirQualityThroughoutTheDay = '',
                _this.report.pollutantAqi = '',
                _this.report.pollutantPrimary = '',
                _this.report.pollutantDistrict = '',
                _this.report.pollutionCountyPollutionLevel = '',
                _this.report.pollutionLevelOfOtherCounties = '',
                _this.report.pollutionCondition = '',
                _this.report.pollutionThatDay = '',
                _this.report.pollutionInversion = '',
                _this.report.pollutionConversionTime = '',
                _this.report.pollutionThatDayGrade = '',
                _this.report.pollutionSiteSituation = '',
                _this.report.pollutionCountySituation = '',
                _this.report.pollutionRegional = ''
        },
        /**
         * 取消
         * @param {boolean} isParentRefresh 是否父页面刷新
         */
        cancel: function (isParentRefresh) {
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
         * 保存
         */
        saveData: function (state) {
            var _this = this;
            _this.report.reportTime = _this.yearMonthDayHour;
            var flag = $('#mainForm').validationEngine('validate');
            if (!flag) {
                return;
            }
            var tipMessage = _this.getSaveTipMessage(state);
            _this.generateOne();
            _this.report.generateContentTwo = "    " + _this.report.generateContentTwo;
            DialogUtil.showConfirmDialog(tipMessage.confirmMessage, function () {
                _this.report.state = state;
                AjaxUtil.sendPostAjaxRequest(_this.urls.saveForecastUrl, _this.report, function () {
                    DialogUtil.showTipDialog(tipMessage.successMessage, function () {
                        _this.cancel(true);
                    }, function () {
                        _this.cancel(true);
                    });
                });
            });
        },
        /**
         * 日期选择插件
         */
        wdatePicker: function () {
            var _this = this;
            WdatePicker({
                // 回显数据的对象ID
                el: 'wdate-picker',
                // 时间格式
                dateFmt: 'yyyy-MM-dd HH',
                // 是否显示清除按钮
                isShowClear: false,
                // 是否显示今天按钮
                isShowToday: false,
                // 只读
                readOnly: true,
                // 限制最大时间
                maxDate: '%y-%M-%d %H',
                onpicked: function (dp) {
                    // 防止重复点击当月
                    var yearMonthDayHour = dp.cal.getNewDateStr();
                    if (yearMonthDayHour === _this.yearMonthDayHour) {
                        return;
                    }
                    _this.yearMonthDayHour = yearMonthDayHour;
                    _this.getDate(yearMonthDayHour);
                    _this.report.reportTime = yearMonthDayHour;
                    AjaxUtil.sendAjaxRequest(_this.urls.queryStateNumber, null, {
                        ascriptionType: _this.report.ascriptionType,
                        reportTime: _this.yearMonthDayHour.substring(0, 10)
                    }, function (json) {
                        if (json.data.STATE_NUMBER == 0) {
                            _this.initReportData();

                        } else {
                            DialogUtil.showTipDialog(_this.report.reportTime.substring(0, 10) + "数据已提交，请重新选择填报日期！");
                            _this.noData();

                        }
                    });
                }
            });
        },
        /**
         * 获取保存提示信息
         */
        getSaveTipMessage: function (state) {
            var tipMessage = null;
            if (state === 'UPLOAD') {
                tipMessage = {
                    confirmMessage: '提交选中的数据，提交成功后将不能编辑和删除，请确认！',
                    successMessage: '提交成功！'
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
            for (var key in this.report) {
                formData.append(key, this.report[key]);
            }
            return formData;
        },
        /**
         * 获取报告频度
         */
        getReportFrequency: function (reportTime) {
            return parseInt(reportTime.split("-")[2]);
        },
        /**
         * 拼接数据
         */
        generateOne: function () {
            let _this = this;
            _this.report.generateContentOne =
                "    "
                + _this.report.pollutionTheDayBefore + "日早晨"
                + _this.report.pollutionWeatherConditions + "，"
                + _this.report.pollutionInfluencingFactors
                + _this.report.pollutionInfluencingFactorsIncreaseOrDecrease + "，边界层高度"
                + _this.report.pollutionInBoundary + "至"
                + _this.report.pollutionInBoundaryLayer + "米左右，污染累积速度"
                + _this.report.pollutionAccumulationSpeed + "，国控均值出现连续"
                + _this.report.pollutionConsecutiveHours + "小时"
                + _this.report.pollutionLevel + "，午后天空状况"
                + _this.report.pollutionAfternoonSkyConditions + "，湿度"
                + _this.report.pollutionHumidity + "，边界层逐渐"
                + _this.report.pollutionBoundaryLayerCondition + "，垂直扩散条件"
                + _this.report.pollutionVerticalDiffusionConditions + "，空气质量逐渐改善至"
                + _this.report.pollutionAirQualityLevel + "，夜间边界层"
                + _this.report.pollutionNocturnalBoundaryLayer + "，空气质量于"
                + _this.report.pollutionNightAirQualityTime + "时又转为"
                + _this.report.pollutionNightAirQualityLevel + "并维持，全天空气质量为"
                + _this.report.pollutionAirQualityThroughoutTheDay + ",AQI为"
                + _this.report.pollutantAqi + "，首要污染物为"
                + _this.report.pollutantPrimary + "。全市"
                + _this.report.pollutantDistrict + "为"
                + _this.report.pollutionCountyPollutionLevel + "，其余均为"
                + _this.report.pollutionLevelOfOtherCounties + "；"
                + _this.report.pollutionCondition + "。"
                + _this.report.pollutionThatDay + "日早晨出现"
                + _this.report.pollutionInversion + "强逆温，边界层持续下压，湿度较大，污染累积加快，空气质量于"
                + _this.report.pollutionConversionTime + "时再次转为"
                + _this.report.pollutionThatDayGrade + "，国控站点中，"
                + _this.report.pollutionSiteSituation
                + _this.report.pollutionCountySituation
                + _this.report.pollutionRegional + "。"
        }
    }
});
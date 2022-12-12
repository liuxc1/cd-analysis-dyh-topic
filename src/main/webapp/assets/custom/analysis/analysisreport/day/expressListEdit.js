/** 快报分析报告-编辑逻辑js **/
new Vue({
    el: '#main-container',
    data: {
        urls: {
            queryDayGeneralReportByIdAndFileSourceUrl: ctx + '/analysis/express/newsletterAnalysis/queryDayGeneralReportByIdAndFileSource.vm',
            saveForecastUrl: ctx + '/analysis/express/newsletterAnalysis/saveForecast.vm',
            getUuidUrl: ctx + '/analysis/express/newsletterAnalysis/getUuid.vm',
            queryStateNumber: ctx + '/analysis/report/generalReport/queryStateNumber.vm',
            getRegionPoint: ctx + '/analysis/analysisreport/winterExpress/getRegionPoint.vm',
            queryOverStandard: ctx + '/analysis/express/newsletterAnalysis/queryOverStandard.vm'
        },
        // 报告数据
        report: {
            reportTime: null,
            // 报告ID
            // 图片类型一
            ascriptionType: '',
            // 图片类型二
            ascriptionTypeTwo: 'EXPRESS_NEWS_TWO',
            // 图片类型三
            ascriptionTypeThree: 'EXPRESS_NEWS_THREE',
            // 图片类型四
            ascriptionTypeFour: 'EXPRESS_NEWS_FOUR',
            // 图片类型五
            ascriptionTypeFive: 'EXPRESS_NEWS_FIVE',
            // 文件来源
            fileSources: '',
            // 报告名称
            reportName: '',
            // 报告频率
            reportRate: '',
            // 报告频度
            reportFrequency: null,
            // 重要提示
            reportTip: '',
            // 状态
            state: '',
            imageList: [],
            deleteImageIds: [],
            generateContentOne: '',
            editContentOne: '',
            generateContentTwo: '',
            editContentTwo: '',
            imageId: '',
            year: '',
            currentYear: '',
            //期数
            reportBatch: '',

            //前一天污染情况
            //污染月
            pollutionMoon: '',
            //污染准确天数
            pollutionDay: '',
            //边界层高度区间
            pollutionBoundaryLayerHeightInterval: '',
            //污染风速
            pollutionWindSpeed: '',
            //扩散条件（较好/一般/较差）
            pollutionDiffusionConditions: '',
            //平均比例
            pollutionAverageRatio: '',
            //超标小时
            pollutionConsecutiveHours: '',
            //巅峰浓度
            pollutionPeakConcentration: '',
            //污染等级（优、良、轻度污染、中度污染、重度污染）
            pollutionLevel: '',


            //次日污染情况
            //次日污染日期
            nextDayPollutionDay: '',
            //次日污染天气情况
            nextDayPollutionWeatherConditions: '',
            //次日污染边界层高度
            nextDayPollutionBoundaryLayerHeight: '',
            //次日污染风速
            nextDayPollutionWindSpeed: '',
            //次日污染扩散条件（好/与前日相当/差）
            nextDayPollutionDiffusionConditions: '',
            //次日污染速率
            nextDayPollutionRate: '',
            //次日污染pm25超标浓度
            nextDayPollutionPm25ExcessiveConcentration: '',
            //次日污染No2平均浓度
            nextDayPollutionNo2AverageConcentration: '',
            //次日污染下降比例
            nextDayPollutionDecreaseRatio: '',
            //次日污染VOC浓度
            nextDayPollutionVocConcentration: '',
            //次日污染OFP浓度
            nextDayPollutionOfpConcentration: '',
            //次日污染VOC浓度下降比例
            nextDayPollutionVocDecreaseRatio: '',
            //次日污染OFP浓度下降比例
            nextDayPollutionOfpDecreaseRatio: '',
            //次日污染OFP 贡献前五物种（主物种）
            nextDayPollutionOfpSpecies: '',
            //次日污染OFP 污染源
            nextDayPollutionOfpSource: '',
            //次日污染NO2、O1D、甲醛和 HONO 的光解速率和辐射强度较前日明显（降低、升高）
            nextDayPollutionCompare: '',
            //次日污染pm25浓度
            nextDayPollutionPm25Concentration: '',
            //次日污染o3浓度
            nextDayPollutionO3Concentration: '',
            //次日污染等级
            nextDayPollutionLevel: '',
            //次日污染AQI
            nextDayPollutionAqi: '',
            //次日污染主要污染物
            nextDayPollutionPrimaryPollutant: '',
            //下降/上升/持平
            riseAndFallFlat: '',
        },
    },
    // 页面加载完后调用
    mounted: function () {
        // 将回调延迟到下次 DOM 更新循环之后执行。在修改数据之后立即使用它，然后等待 DOM 更新
        this.$nextTick(function () {
            // // 归属类型
            this.report.ascriptionType = $('#ascription-type').val();
            // 报告频率
            this.report.reportRate = $('#report-rate').val();
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
            let nowDate = DateTimeUtil.getNowDate();
            var param = {};
            if (reportId != null && reportId != undefined && reportId != '') {
                param = {
                    ascriptionType: _this.report.ascriptionType,
                    reportId: reportId
                }
            } else {
                param = {
                    ascriptionType: _this.report.ascriptionType,
                    reportTime: nowDate
                }
            }
            AjaxUtil.sendAjaxRequest(_this.urls.queryStateNumber, null, param, function (json) {
                if (json.data.STATE_NUMBER == 0) {
                    _this.report.reportTime = nowDate;
                    _this.initReportData();
                } else {
                    _this.report.reportTime = '';
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
                reportTime: _this.report.reportTime,
                reportId: $('#report-id').val()
            }, function (json) {
                var data = json.data;
                _this.report.reportTime = data.report.reportTime;
                _this.report.year = data.report.reportTime.substring(0, 4);
                _this.report.reportId = data.report.reportId;
                _this.report.reportName = data.report.reportName;
                // 报告频度
                _this.report.reportFrequency = _this.getReportFrequency(data.report.reportTime);
                _this.report.reportTip = data.report.reportTip;
                _this.report.reportBatch = data.report.reportBatch;
                _this.report.generateContentOne = data.report.generateContentOne;
                _this.report.generateContentTwo = data.report.generateContentTwo;
                //当天污染情况
                _this.report.pollutionMoon = data.report.reportTime.substring(6, 7);
                _this.report.pollutionDay = data.report.pollutionDay;
                _this.report.pollutionBoundaryLayerHeightInterval = data.report.pollutionBoundaryLayerHeightInterval;
                _this.report.pollutionWindSpeed = data.report.pollutionWindSpeed;
                _this.report.pollutionDiffusionConditions = data.report.pollutionDiffusionConditions;
                _this.report.pollutionConsecutiveHours = data.report.pollutionConsecutiveHours;
                _this.report.pollutionPeakConcentration = data.report.pollutionPeakConcentration;
                _this.report.pollutionLevel = data.report.pollutionLevel;
                //次日污染情况
                _this.report.nextDayPollutionDay = data.report.nextDayPollutionDay;
                _this.report.nextDayPollutionWeatherConditions = data.report.nextDayPollutionWeatherConditions;
                _this.report.nextDayPollutionBoundaryLayerHeight = data.report.nextDayPollutionBoundaryLayerHeight;
                _this.report.nextDayPollutionWindSpeed = data.report.nextDayPollutionWindSpeed;
                _this.report.nextDayPollutionDiffusionConditions = data.report.nextDayPollutionDiffusionConditions;
                _this.report.nextDayPollutionRate = data.report.nextDayPollutionRate;
                _this.report.nextDayPollutionVocConcentration = data.report.nextDayPollutionVocConcentration;
                _this.report.nextDayPollutionOfpConcentration = data.report.nextDayPollutionOfpConcentration;
                _this.report.nextDayPollutionVocDecreaseRatio = data.report.nextDayPollutionVocDecreaseRatio;
                _this.report.nextDayPollutionOfpDecreaseRatio = data.report.nextDayPollutionOfpDecreaseRatio;
                _this.report.nextDayPollutionOfpSpecies = data.report.nextDayPollutionOfpSpecies;
                _this.report.nextDayPollutionOfpSource = data.report.nextDayPollutionOfpSource;
                _this.report.nextDayPollutionCompare = data.report.nextDayPollutionCompare;
                _this.report.nextDayPollutionPm25Concentration = data.report.nextDayPollutionPm25Concentration;
                _this.report.nextDayPollutionO3Concentration = data.report.nextDayPollutionO3Concentration;
                _this.report.nextDayPollutionLevel = data.report.nextDayPollutionLevel;
                _this.report.nextDayPollutionAqi = data.report.nextDayPollutionAqi;
                _this.report.nextDayPollutionPrimaryPollutant = data.report.nextDayPollutionPrimaryPollutant;
                _this.report.pollutionAverageRatio = data.report.pollutionAverageRatio;
                _this.report.nextDayPollutionPm25ExcessiveConcentration = data.report.nextDayPollutionPm25ExcessiveConcentration;
                _this.report.nextDayPollutionNo2AverageConcentration = data.report.nextDayPollutionNo2AverageConcentration;
                _this.report.nextDayPollutionDecreaseRatio = data.report.nextDayPollutionDecreaseRatio;
                _this.report.currentYear = data.report.reportTime.substring(0, 4);
                AjaxUtil.sendAjaxRequest(_this.urls.queryOverStandard, null, {
                    reportTime: _this.report.reportTime
                }, function (json) {
                    var data = json.data;
                    _this.report.riseAndFallFlat = data.no2RiseOrDecline == null ? '下降' : data.no2RiseOrDecline;
                });
            }, function () {
                _this.getUuid();
                _this.noData();
                _this.getRegionPoint();
                _this.queryOverStandard();
                _this.report.pollutionMoon = _this.report.reportTime.substring(6, 7);
                _this.report.currentYear = _this.report.reportTime.substring(0, 4);
            });
        },
        /**
         * 查询超标指数
         */
        queryOverStandard: function () {
            var _this = this;
            AjaxUtil.sendAjaxRequest(_this.urls.queryOverStandard, null, {
                reportTime: _this.report.reportTime
            }, function (json) {
                var data = json.data;
                _this.report.pollutionAverageRatio = data.averageRatio == null ? '' : data.averageRatio;
                _this.report.nextDayPollutionPm25ExcessiveConcentration = data.concentrationExceededHours == null ? '' : data.concentrationExceededHours;
                _this.report.nextDayPollutionNo2AverageConcentration = data.no2averageConcentration == null ? '' : data.no2averageConcentration;
                _this.report.nextDayPollutionDecreaseRatio = data.no2Percentage == null ? '' : data.no2Percentage;
                _this.report.riseAndFallFlat = data.no2RiseOrDecline == null ? '下降' : data.no2RiseOrDecline;
            });
        },
        /**
         * 清空数据
         */
        noData: function () {
            let _this = this;
            _this.report.reportName = null;
            _this.report.reportTip = '';
            _this.report.state = '';
            _this.report.imageList = [];
            _this.report.year = '';
            _this.report.reportBatch = '';
            _this.report.generateContentOne = '';
            _this.report.generateContentTwo = '';
            _this.report.reportId = '';
            //前一天污染情况
            _this.report.pollutionMoon = '';
            _this.report.pollutionDay = '';
            _this.report.pollutionBoundaryLayerHeightInterval = '';
            _this.report.pollutionWindSpeed = '';
            _this.report.pollutionDiffusionConditions = '';
            _this.report.pollutionAverageRatio = '';
            _this.report.pollutionConsecutiveHours = '';
            _this.report.pollutionPeakConcentration = '';
            _this.report.pollutionLevel = '';
            //次日污染情况
            _this.report.nextDayPollutionDay = '';
            _this.report.nextDayPollutionWeatherConditions = '';
            _this.report.nextDayPollutionBoundaryLayerHeight = '';
            _this.report.nextDayPollutionWindSpeed = '';
            _this.report.nextDayPollutionDiffusionConditions = '';
            _this.report.nextDayPollutionRate = '';
            _this.report.nextDayPollutionPm25ExcessiveConcentration = '';
            _this.report.nextDayPollutionNo2AverageConcentration = '';
            _this.report.nextDayPollutionDecreaseRatio = '';
            _this.report.nextDayPollutionVocConcentration = '';
            _this.report.nextDayPollutionOfpConcentration = '';
            _this.report.nextDayPollutionVocDecreaseRatio = '';
            _this.report.nextDayPollutionOfpDecreaseRatio = '';
            _this.report.nextDayPollutionOfpSpecies = '';
            _this.report.nextDayPollutionOfpSource = '';
            _this.report.nextDayPollutionCompare = '';
            _this.report.nextDayPollutionPm25Concentration = '';
            _this.report.nextDayPollutionO3Concentration = '';
            _this.report.nextDayPollutionLevel = '';
            _this.report.nextDayPollutionAqi = '';
            _this.report.nextDayPollutionPrimaryPollutant = '';
        },
        /**
         * 获取uuid
         */
        getUuid: function () {
            var _this = this;
            AjaxUtil.sendAjaxRequest(_this.urls.getUuidUrl, null, null, function (json) {
                Vue.set(_this.report,'reportId',json.data)
            });
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
            var flag = $('#mainForm').validationEngine('validate');
            if (!flag) {
                return;
            }
            _this.generatePollution();
            _this.generateNextDayPollution();
            var tipMessage = _this.getSaveTipMessage(state);
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
        wdatePicker1: function () {
            var _this = this;
            WdatePicker({
                // 回显数据的对象ID
                el: 'txtDate',
                // 时间格式
                dateFmt: 'yyyy-MM-dd',
                // 是否显示清除按钮
                isShowClear: false,
                // 是否显示今天按钮
                isShowToday: false,
                // 只读
                readOnly: true,
                // 限制最大时间
                maxDate: '%y-%M-%d',
                onpicked: function (dp) {
                    // 防止重复点击当月
                    var yearMonthDay = dp.cal.getNewDateStr();
                    if (yearMonthDay === _this.report.reportTime) {
                        return;
                    }
                    _this.report.reportTime = yearMonthDay;
                    _this.report.year = yearMonthDay.substring(0, 4);
                    _this.report.currentYear = yearMonthDay.substring(0, 4);
                    AjaxUtil.sendAjaxRequest(_this.urls.queryStateNumber, null, {
                        ascriptionType: _this.report.ascriptionType,
                        reportTime: _this.report.reportTime
                    }, function (json) {
                        if (json.data.STATE_NUMBER == 0) {
                            _this.initReportData();
                        } else {
                            DialogUtil.showTipDialog(_this.report.reportTime + "数据已提交，请重新选择填报日期！");
                            _this.noData();
                            _this.getUuid();
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
         * 拼接前一天污染情况
         */
        generatePollution: function () {
            this.report.generateContentOne =
                this.report.pollutionMoon + "月"
                + this.report.pollutionDay + "日，边界层高度在 "
                + this.report.pollutionBoundaryLayerHeightInterval + "米之间，平均风速"
                + this.report.pollutionWindSpeed + "米每秒，扩散条件"
                + this.report.pollutionDiffusionConditions + "。激光雷达反演显示浮尘传输和近地面扬尘排放影响持续，PM₂.₅/PM₁₀ 平均比值低至"
                + this.report.pollutionAverageRatio + "。此外，由于光化学反应前期 VOC 浓度及活性偏大，午后辐射强，臭氧生成速率快，出现 "
                + this.report.pollutionConsecutiveHours + " 小时臭氧超标（峰值浓度达 "
                + this.report.pollutionPeakConcentration + "µg/m³），当天空气质量为"
                + this.report.pollutionLevel + "。"
            this.report.editContentOne = this.report.generateContentOne;
        },
        /**
         * 拼接日期选择器选择当天情况
         */
        generateNextDayPollution: function () {
            this.report.generateContentTwo =
                this.report.nextDayPollutionDay + "日上午"
                + this.report.nextDayPollutionWeatherConditions + "，边界层高度在 "
                + this.report.nextDayPollutionBoundaryLayerHeight + "米左右波动变化，风速较"
                + this.report.nextDayPollutionWindSpeed + "，扩散条件"
                + this.report.nextDayPollutionDiffusionConditions + ",高空仍有轻微浮尘传输，同时， 二次颗粒物转化速率"
                + this.report.nextDayPollutionRate + "， PM₂.₅ 累积升高出现"
                + this.report.nextDayPollutionPm25ExcessiveConcentration + "小时浓度超标；臭氧前体物NO₂ 平均浓度达"
                + this.report.nextDayPollutionNo2AverageConcentration + "μg/m³，较前日同期" + this.report.riseAndFallFlat
                + this.report.nextDayPollutionDecreaseRatio + "，0-10时光化学主站 VOC 数据由于仪器校准，数据无效，暂不加入本日分析。光化学南站 VOC 浓度和 OFP分别为"
                + this.report.nextDayPollutionVocConcentration + "μg/m³、"
                + this.report.nextDayPollutionOfpConcentration + "μg/m³， 环比下降 "
                + this.report.nextDayPollutionVocDecreaseRatio + "、"
                + this.report.nextDayPollutionOfpDecreaseRatio + "，OFP贡献前五物种以"
                + this.report.nextDayPollutionOfpSpecies + "为主，指示"
                + this.report.nextDayPollutionOfpSource + "影响显著。今日 NO₂、O1D、甲醛和 HONO 的光解速率和辐射强度较前日明显"
                + this.report.nextDayPollutionCompare + "， 截止 11 时，PM₂.₅ 和 O₃ 浓度分别为"
                + this.report.nextDayPollutionPm25Concentration + "µg/m³、和"
                + this.report.nextDayPollutionO3Concentration + "µg/m³，空气质量为"
                + this.report.nextDayPollutionLevel + "（AQI "
                + this.report.nextDayPollutionAqi + "），首要污染物为"
                + this.report.nextDayPollutionPrimaryPollutant + "。"
            this.report.editContentTwo = this.report.generateContentTwo;
        },
        /**
         * 查询选中天的监测数据。
         */
        getRegionPoint: function () {
            var _this = this;
            AjaxUtil.sendAjaxRequest(_this.urls.getRegionPoint, null, {
                reportTime: _this.report.reportTime
            }, function (json) {
                if (json.data && json.data.length > 0) {
                    _this.report.nextDayPollutionAqi = json.data[0].aqi;
                    _this.report.nextDayPollutionPrimaryPollutant = json.data[0].primaryPollutant == null ? '--' : json.data[0].primaryPollutant;
                } else {
                    _this.report.nextDayPollutionAqi = '';
                    _this.report.nextDayPollutionPrimaryPollutant = '';
                }
            });
        }
    }
});
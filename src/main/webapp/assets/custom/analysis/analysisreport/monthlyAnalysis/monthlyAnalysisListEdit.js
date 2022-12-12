/** 月报分析-编辑逻辑js **/
new Vue({
    el: '#main-container',
    data: {
        urls: {
            queryDayGeneralReportByIdAndFileSourceUrl: ctx + '/analysis/analysisreport/monthlyAnalysis/queryMonthGeneralReportByIdAndFileSource.vm',
            saveForecastUrl: ctx + '/analysis/analysisreport/monthlyAnalysis/saveForecast.vm',
            getUuidUrl: ctx + '/analysis/express/newsletterAnalysis/getUuid.vm',
            queryStateNumber: ctx + '/analysis/report/generalReport/queryStateNumber.vm',
            queryStateNumberByTime: ctx + '/analysis/report/generalReport/queryStateNumberByTime.vm',
            queryDefaultData: ctx + '/analysis/analysisreport/monthlyAnalysis/queryDefaultData.vm'
        },
        // 报告数据
        report: {
            reportTime: null,
            // 报告ID
            // 图片类型一
            ascriptionType: '',
            // 图片类型二
            ascriptionTypeTwo: 'MONTHLY_ANALYSIS_TWO',
            // 图片类型三
            ascriptionTypeThree: 'MONTHLY_ANALYSIS_THREE',
            // 图片类型四
            ascriptionTypeFour: 'MONTHLY_ANALYSIS_FOUR',
            // 图片类型五
            ascriptionTypeFive: 'MONTHLY_ANALYSIS_FIVE',
            // 图片类型六
            ascriptionTypeSix: 'MONTHLY_ANALYSIS_SIX',
            // 图片类型七
            ascriptionTypeSeven: 'MONTHLY_ANALYSIS_SEVEN',
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
            //实验室观测数据质量分析
            generateContentQuality: '',
            editContentQuality: '',
            //污染过程分析
            generateContentAnalysis: '',
            editContentAnalysis: '',
            //（1）静稳高湿加快二次组分转化进一步推高颗粒物浓度
            generateContentConcentration: '',
            editContentConcentration: '',
            //（2）排放体量偏大，以移动源与溶剂源影响为主
            generateContentSolvent: '',
            editContentSolvent: '',
            //小结
            generateContentSummary: '',
            editContentSummary: '',
            imageId: '',
            year: '',
            defaultYear: '',
            month: '',
            //初始化时间
            initializationTime: '',
            //填报期数
            reportBatch: '',
            //实验室观测数据质量分析
            //状态(良好、一般、较差)
            qualityState: '',
            //实验室观测数据质量百分比
            qualityPercentage: '',
            //污染过程分析
            //污染时间范围
            analysisTimeLimit: '',
            //污染季(春、夏、秋、东)
            analysisSeasons: '',
            //时间范围内的优良时间
            analysisGoodSky: '',
            //优或者良
            analysisExcellent: '',
            //轻度污染时间范围
            analysisLightPollutionTimeRange: '',
            //轻度污染天数
            analysisDaysWithLightPollution: '',
            //轻度污染
            analysisLightPollution: '',
            //中度污染时间范围
            analysisModeratePollutionTimeRange: '',
            //中度污染
            analysisModeratelyPolluted: '',
            //重度污染时间范围
            analysisSeverePollutionTimeRange: '',
            //重度污染
            analysisHeavyPollution: '',
            //污染结束时间
            analysisContaminationEndTime: '',
            //（1）静稳高湿加快二次组分转化进一步推高颗粒物浓度
            //静稳高湿的气象条件
            concentrationWeatherCondition: '',
            //污染等级(重度污染，中度污染，轻度污染)
            concentrationPollutionLevel: '',
            //后期时间范围
            concentrationLateTimeRange: '',
            //前期时间范围
            concentrationEarlyTimeRange: '',
            //连续时间
            concentrationContinuousTime: '',
            //指数
            concentrationIndex: '',
            //原因
            concentrationReason: '',
            //污染等级
            concentrationPollution: '',
            //污染等级+（由某个污染等级->另一个污染等级）
            concentrationPollutionPlus: '',
            //NOR浓度
            concentrationNor: '',
            //SOR浓度
            concentrationSor: '',
            //占比（百分比）
            concentrationPercentage: '',
            //（2）排放体量偏大，以移动源与溶剂源影响为主
            //NO平均浓度
            solventNo: '',
            //NO上升浓度
            solventNoRise: '',
            //VOCS平均浓度
            solventVocs: '',
            //VOCS上升浓度
            solventVocsRise: '',
            //VOC上升元素
            solventVoc: '',
            //影响原因1
            solventCauseOfImpactOne: '',
            //影响原因2
            solventCauseOfImpactTwo: '',
            //SO2上升比例
            solventSo2RisePercentage: '',
            //颗粒物浓度升高元素
            solventElement: '',
            //污染源影响
            solventInfluence: '',
            //小结
            //时间范围
            summaryTimeLimit: '',
            //季节（春、夏、秋、东）
            summarySeason: '',


            /**
             * 优良天数
             */
            excellentandGood: "",
            /**
             * 优秀天数
             */
            excellent: "",
            /**
             * 良天数
             */
            good: "",
            /**
             * 优良天数比例
             */
            correctRate: "",
            /**
             * 污染天数
             */
            contaminationDays: "",
            /**
             * 轻度污染
             */
            lightPollution: "",
            /**
             * 中度污染
             */
            moderatelyPolluted: "",
            /**
             * 重度污染
             */
            heavyPollution: "",
            /**
             * 这个月六项污染物 PM10 PM25 NO2 SO2 O3 CO
             */
            pm10: "",
            pm25: "",
            no2: "",
            so2: "",
            o3: "",
            co: "",
            /**
             * 与去年同期相比（上升或下降比例，百分比值）
             */
            pm10RiseOrDecline: "",
            pm10Percentage: "",
            pm25RiseOrDecline: "",
            pm25Percentage: "",
            no2RiseOrDecline: "",
            no2Percentage: "",
            so2RiseOrDecline: "",
            so2Percentage: "",
            o38RiseOrDecline: "",
            o38Percentage: "",
            coRiseOrDecline: "",
            coPercentage: "",
            //默认数据
            defaultData: '',
        }
    },
// 页面加载完后调用
    mounted: function () {
        // 将回调延迟到下次 DOM 更新循环之后执行。在修改数据之后立即使用它，然后等待 DOM 更新
        this.$nextTick(function () {
            // // 归属类型
            this.report.ascriptionType = $('#ascription-type').val();
            // 报告频率
            this.report.reportRate = $('#report-rate').val();
            // 报告频率
            this.positionTime = $('#report-time').val();
            this.initData();
            // 注册表单验证
            $('#mainForm').validationEngine({
                scrollOffset: 98, // 屏幕自动滚动到第一个验证不通过的位置。必须设置，因为Toolbar position为Fixed
                promptPosition: 'bottomLeft', // 提示框位置为下左
                autoHidePrompt: true, // 自动隐藏提示框
                validateNonVisibleFields: true // 不可见字段验证
            });
        });
    }
    ,
    methods: {
        /**
         * 初始化数据，获取全部数据，包括图片信息
         */
        initData: function () {
            var _this = this;
            let nowDate = DateTimeUtil.getNowDate();
            if (_this.positionTime != null) {
                nowDate = _this.positionTime;
            }
            AjaxUtil.sendAjaxRequest(_this.urls.queryStateNumber, null, {
                ascriptionType: _this.report.ascriptionType,
                reportTime: nowDate
            }, function (json) {
                if (json.data.STATE_NUMBER == 0) {
                    _this.report.reportTime = nowDate;
                    _this.report.year = nowDate.substring(0, 4);
                    _this.report.month = parseInt(nowDate.substring(5, 7));
                    _this.report.defaultYear = nowDate.substring(0, 4);
                    _this.initReportData();
                } else {
                    _this.report.reportTime = '';
                }
            });
        }
        ,
        queryDefaultData: function () {
            var _this = this;
            AjaxUtil.sendAjaxRequest(_this.urls.queryDefaultData, null, {
                startMonth: _this.report.reportTime
            }, function (json) {
                if (json.data != null) {
                    var data = json.data.newMonthlyAnalysis;
                    _this.report.excellentandGood = data.excellentandGood == null ? "" : data.excellentandGood;
                    _this.report.excellent = data.excellent == null ? "" : data.excellent;
                    _this.report.good = data.good == null ? "" : data.good;
                    _this.report.correctRate = data.correctRate == null ? "" : data.correctRate;
                    _this.report.contaminationDays = data.contaminationDays == null ? "" : data.contaminationDays;
                    _this.report.lightPollution = data.lightPollution == null ? "" : data.lightPollution;
                    _this.report.moderatelyPolluted = data.moderatelyPolluted == null ? "" : data.moderatelyPolluted;
                    _this.report.heavyPollution = data.heavyPollution == null ? "" : data.heavyPollution;
                    _this.report.primaryPollutant = data.primaryPollutant == null ? "" : data.primaryPollutant
                    _this.report.pm10 = data.pm10 == null ? "" : data.pm10;
                    _this.report.pm25 = data.pm25 == null ? "" : data.pm25;
                    _this.report.no2 = data.no2 == null ? "" : data.no2;
                    _this.report.so2 = data.so2 == null ? "" : data.so2;
                    _this.report.o3 = data.o3 == null ? "" : data.o3;
                    _this.report.co = data.co == null ? "" : data.co;
                    _this.report.pm10RiseOrDecline = data.pm10RiseOrDecline == null ? "" : data.pm10RiseOrDecline;
                    _this.report.pm10Percentage = data.pm10Percentage == null ? "" : data.pm10Percentage;
                    _this.report.pm25RiseOrDecline = data.pm25RiseOrDecline == null ? "" : data.pm25RiseOrDecline;
                    _this.report.pm25Percentage = data.pm25Percentage == null ? "" : data.pm25Percentage;
                    _this.report.no2RiseOrDecline = data.no2RiseOrDecline == null ? "" : data.no2RiseOrDecline;
                    _this.report.no2Percentage = data.no2Percentage == null ? "" : data.no2Percentage;
                    _this.report.so2RiseOrDecline = data.so2RiseOrDecline == null ? "" : data.so2RiseOrDecline;
                    _this.report.so2Percentage = data.so2Percentage == null ? "" : data.so2Percentage;
                    _this.report.o38RiseOrDecline = data.o38RiseOrDecline == null ? "" : data.o38RiseOrDecline;
                    _this.report.o38Percentage = data.o38Percentage == null ? "" : data.o38Percentage;
                    _this.report.coRiseOrDecline = data.coRiseOrDecline == null ? "" : data.coRiseOrDecline;
                    _this.report.coPercentage = data.coPercentage == null ? "" : data.coPercentage;
                }
            });
        },
        initReportData: function () {
            var _this = this;
            AjaxUtil.sendAjaxRequest(_this.urls.queryDayGeneralReportByIdAndFileSourceUrl, null, {
                ascriptionType: _this.report.ascriptionType,
                reportTime: _this.report.reportTime
            }, function (json) {
                var data = json.data;
                if (data.report != null) {
                    _this.report.reportId = data.report.reportId;
                    _this.report.reportName = data.report.reportName;
                    // 报告频度
                    _this.report.reportFrequency = _this.getReportFrequency(data.report.reportTime);
                    _this.report.reportTip = data.report.reportTip;
                    _this.report.reportBatch = data.report.reportBatch;
                    _this.report.generateContentQuality = data.report.generateContentQuality;
                    _this.report.generateContentAnalysis = data.report.generateContentAnalysis;
                    _this.report.generateContentConcentration = data.report.generateContentConcentration;
                    _this.report.generateContentSolvent = data.report.generateContentSolvent;
                    _this.report.generateContentSummary = data.report.generateContentSummary;
                    _this.report.qualityState = data.report.qualityState;
                    _this.report.qualityPercentage = data.report.qualityPercentage;
                    _this.report.analysisTimeLimit = data.report.analysisTimeLimit;
                    _this.report.analysisSeasons = data.report.analysisSeasons;
                    _this.report.analysisGoodSky = data.report.analysisGoodSky;
                    _this.report.analysisExcellent = data.report.analysisExcellent;
                    _this.report.analysisLightPollutionTimeRange = data.report.analysisLightPollutionTimeRange;
                    _this.report.analysisDaysWithLightPollution = data.report.analysisDaysWithLightPollution;
                    _this.report.analysisLightPollution = data.report.analysisLightPollution;
                    _this.report.analysisModeratePollutionTimeRange = data.report.analysisModeratePollutionTimeRange;
                    _this.report.analysisModeratelyPolluted = data.report.analysisModeratelyPolluted;
                    _this.report.analysisSeverePollutionTimeRange = data.report.analysisSeverePollutionTimeRange;
                    _this.report.analysisHeavyPollution = data.report.analysisHeavyPollution;
                    _this.report.analysisContaminationEndTime = data.report.analysisContaminationEndTime;
                    _this.report.concentrationWeatherCondition = data.report.concentrationWeatherCondition;
                    _this.report.concentrationPollutionLevel = data.report.concentrationPollutionLevel;
                    _this.report.concentrationLateTimeRange = data.report.concentrationLateTimeRange;
                    _this.report.concentrationEarlyTimeRange = data.report.concentrationEarlyTimeRange;
                    _this.report.concentrationContinuousTime = data.report.concentrationContinuousTime;
                    _this.report.concentrationIndex = data.report.concentrationIndex;
                    _this.report.concentrationReason = data.report.concentrationReason;
                    _this.report.concentrationPollution = data.report.concentrationPollution;
                    _this.report.concentrationPollutionPlus = data.report.concentrationPollutionPlus;
                    _this.report.concentrationNor = data.report.concentrationNor;
                    _this.report.concentrationSor = data.report.concentrationSor;
                    _this.report.concentrationPercentage = data.report.concentrationPercentage;
                    _this.report.solventNo = data.report.solventNo;
                    _this.report.solventNoRise = data.report.solventNoRise;
                    _this.report.solventVocs = data.report.solventVocs;
                    _this.report.solventVocsRise = data.report.solventVocsRise;
                    _this.report.solventVoc = data.report.solventVoc;
                    _this.report.solventCauseOfImpactOne = data.report.solventCauseOfImpactOne;
                    _this.report.solventCauseOfImpactTwo = data.report.solventCauseOfImpactTwo;
                    _this.report.solventSo2RisePercentage = data.report.solventSo2RisePercentage;
                    _this.report.solventElement = data.report.solventElement;
                    _this.report.solventInfluence = data.report.solventInfluence;
                    _this.report.summaryTimeLimit = data.report.summaryTimeLimit;
                    _this.report.summarySeason = data.report.summarySeason;
                    _this.initializationTime = data.report.reportTime;
                    _this.report.excellentandGood = data.report.excellentandGood == null ? "" : data.report.excellentandGood;
                    _this.report.excellent = data.report.excellent == null ? "" : data.report.excellent;
                    _this.report.good = data.report.good == null ? "" : data.report.good;
                    _this.report.correctRate = data.report.correctRate == null ? "" : data.report.correctRate;
                    _this.report.contaminationDays = data.report.contaminationDays == null ? "" : data.report.contaminationDays;
                    _this.report.lightPollution = data.report.lightPollution == null ? "" : data.report.lightPollution;
                    _this.report.moderatelyPolluted = data.report.moderatelyPolluted == null ? "" : data.report.moderatelyPolluted;
                    _this.report.heavyPollution = data.report.heavyPollution == null ? "" : data.report.heavyPollution;
                    _this.report.primaryPollutant = data.report.primaryPollutant == null ? "" : data.report.primaryPollutant
                    _this.report.pm10 = data.report.pm10 == null ? "" : data.report.pm10;
                    _this.report.pm25 = data.report.pm25 == null ? "" : data.report.pm25;
                    _this.report.no2 = data.report.no2 == null ? "" : data.report.no2;
                    _this.report.so2 = data.report.so2 == null ? "" : data.report.so2;
                    _this.report.o3 = data.report.o3 == null ? "" : data.report.o3;
                    _this.report.co = data.report.co == null ? "" : data.report.co;
                    _this.report.pm10RiseOrDecline = data.report.pm10RiseOrDecline == null ? "" : data.report.pm10RiseOrDecline;
                    _this.report.pm10Percentage = data.report.pm10Percentage == null ? "" : data.report.pm10Percentage;
                    _this.report.pm25RiseOrDecline = data.report.pm25RiseOrDecline == null ? "" : data.report.pm25RiseOrDecline;
                    _this.report.pm25Percentage = data.report.pm25Percentage == null ? "" : data.report.pm25Percentage;
                    _this.report.no2RiseOrDecline = data.report.no2RiseOrDecline == null ? "" : data.report.no2RiseOrDecline;
                    _this.report.no2Percentage = data.report.no2Percentage == null ? "" : data.report.no2Percentage;
                    _this.report.so2RiseOrDecline = data.report.so2RiseOrDecline == null ? "" : data.report.so2RiseOrDecline;
                    _this.report.so2Percentage = data.report.so2Percentage == null ? "" : data.report.so2Percentage;
                    _this.report.o38RiseOrDecline = data.report.o38RiseOrDecline == null ? "" : data.report.o38RiseOrDecline;
                    _this.report.o38Percentage = data.report.o38Percentage == null ? "" : data.report.o38Percentage;
                    _this.report.coRiseOrDecline = data.report.coRiseOrDecline == null ? "" : data.report.coRiseOrDecline;
                    _this.report.coPercentage = data.report.coPercentage == null ? "" : data.report.coPercentage;
                }
            }, function () {
                _this.getUuid();
                _this.report.ascriptionType = 'MONTHLY_ANALYSIS';
                _this.queryDefaultData();
            });
        }
        ,
        /**
         * 获取uuid
         */
        getUuid: function () {
            var _this = this;
            AjaxUtil.sendAjaxRequest(_this.urls.getUuidUrl, null, null, function (json) {
                Vue.set(_this.report, 'reportId', json.data);
            });
        }
        ,
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
        }
        ,
        /**
         * 保存
         */
        saveData: function (state) {
            var _this = this;
            var flag = $('#mainForm').validationEngine('validate');
            if (!flag) {
                return;
            }
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

        }
        ,
        /**
         * 日期选择插件
         */
        wdatePicker1:

            function () {
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
                        AjaxUtil.sendAjaxRequest(_this.urls.queryStateNumberByTime, null, {
                            ascriptionType: _this.report.ascriptionType,
                            reportTime: _this.report.reportTime
                        }, function (json) {
                            if (json.data.STATE_NUMBER == 0) {
                                _this.removeDate();
                                _this.initReportData();
                                _this.queryDefaultData();
                                _this.report.year = _this.report.reportTime.substring(0, 4);
                                _this.report.month = parseInt(_this.report.reportTime.substring(5,7));
                                _this.report.defaultYear = _this.report.reportTime.substring(0, 4);
                            } else {
                                DialogUtil.showTipDialog(_this.report.reportTime.substring(0, 7) + "数据已暂存或已提交，无法选择当前月份日期，如需重新选择填报时间，请删除后进行重新填写！");
                                _this.report.reportTime = _this.initializationTime;
                            }
                        });
                    }
                });
            }

        ,
        /**
         * 清空数据
         */
        removeDate: function () {
            var _this = this;
            _this.report.reportId = '';
            _this.report.reportTip = '';
            _this.report.reportBatch = '';
            _this.report.generateContentQuality = '';
            _this.report.generateContentAnalysis = '';
            _this.report.generateContentConcentration = '';
            _this.report.generateContentSolvent = '';
            _this.report.generateContentSummary = '';
        }
        ,
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
        }
        ,
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
        }
        ,
        /**
         * 获取报告频度
         */
        getReportFrequency: function (reportTime) {
            return parseInt(reportTime.split("-")[2]);
        }
        ,

        generateContentQuality: function () {
            var _this = this;
            _this.report.generateContentQuality =
                _this.report.defaultYear + '年'
                + _this.report.month + '月，大气科研分析实验室在线监测系统整体运行'
                + _this.report.qualityState + '，除设备配件更换、故障维修以及数据校准致数据有所缺失外，仪器设备数据有效率在'
                + _this.report.qualityPercentage + '以上。';
            _this.report.editContentQuality = this.report.generateContentQuality;
        }
        ,
        /**
         * 拼接数据
         */
        generateContentAnalysis: function () {
            var _this = this;
            _this.report.generateContentAnalysis =
                _this.report.month + '月'
                + _this.report.analysisTimeLimit + '日，出现了今年'
                + _this.report.analysisSeasons + ' 季最长的一次污染过程也是近两年唯一出现的颗粒物重度污染的过程，持续性静稳天气叠加本地排放，污染物浓度持续升高，其中'
                + _this.report.analysisGoodSky + '日为高位'
                + _this.report.analysisExcellent + ' ，'
                + _this.report.analysisLightPollutionTimeRange + '日为'
                + _this.report.analysisDaysWithLightPollution + '天'
                + _this.report.analysisLightPollution + '，'
                + _this.report.analysisModeratePollutionTimeRange + '日为'
                + _this.report.analysisModeratelyPolluted + '，'
                + _this.report.analysisSeverePollutionTimeRange + '日为'
                + _this.report.analysisHeavyPollution + '。'
                + _this.report.analysisContaminationEndTime + '日，冷空气入境，扩散条件好转空气质量改善为良，污染过程结束。'
            _this.report.editContentAnalysis = this.report.generateContentAnalysis;
        }
        ,
        /**
         * 拼接数据
         */
        generateConcentration: function () {
            var _this = this;
            _this.report.generateContentConcentration =
                _this.report.concentrationWeatherCondition + ' ，是本次污染物累积上升并达'
                + _this.report.concentrationPollutionLevel + ' ， 的主要外因。尤其是过程中后期（'
                + _this.report.concentrationLateTimeRange + '日），边界层高度整体偏低，其中'
                + _this.report.concentrationEarlyTimeRange + '日边界层昼夜差异消失且连续'
                + _this.report.concentrationContinuousTime + '个小时在'
                + _this.report.concentrationIndex + 'm以下，'
                + _this.report.concentrationReason + '，扩散条件明显弱于今年 以往过程，随着污染累积，空气质量由'
                + _this.report.concentrationPollution + '上升至'
                + _this.report.concentrationPollutionPlus + ' 。过程期间，NOx、SO₂浓度保持在较高水平，且二次组分转化明显加快，NOR和SOR呈上升趋势，最高达'
                + _this.report.concentrationNor + '、'
                + _this.report.concentrationSor + '； 硝酸根、硫酸根及铵根等占比在'
                + _this.report.concentrationPercentage + '左右，是颗粒物浓度保持高位并逐日升高的主要贡献组分。'
            _this.report.editContentConcentration = this.report.generateContentConcentration;
        }
        ,
        /**
         * 拼接数据
         */
        generateSolvent: function () {
            var _this = this;
            _this.report.generateContentSolvent =
                '在不利气象控制下，污染排放持续累积，其中与机动排放相关得污染物累积尤其明显，其中NO平均浓度达'
                + _this.report.solventNo + 'µg/m³，较污染前上升'
                + _this.report.solventNoRise + ' ，VOCS平均浓度达'
                + _this.report.solventVocs + 'µg/m³， 较污染前上升'
                + _this.report.solventVocsRise + '，尤其是VOC中'
                + _this.report.solventVoc + '等上升最为明显，结合T/B（甲苯 /苯）比值结果（见图7）判断，污染时段以'
                + _this.report.solventCauseOfImpactOne + '与'
                + _this.report.solventCauseOfImpactTwo + '共同影响为主。此外，SO₂的整体浓度也较污染前上涨'
                + _this.report.solventSo2RisePercentage + '，颗粒物中'
                + _this.report.solventElement + '，出现小时浓度及占比偏高情况，周边或存在'
                + _this.report.solventInfluence + ' 排放影响。可见，整个过程除气象外因影响外， 本地较大排放的影响也不容忽视。'
            _this.report.editContentSolvent = this.report.generateContentSolvent;
        }
        ,
        /**
         * 拼接数据
         */
        generateSummary: function () {
            var _this = this;
            _this.report.generateContentSummary =
                ' 小结：本月'
                + _this.report.summaryTimeLimit + '日间，我市出现'
                + _this.report.summarySeason + '季以来最长的一次污染过程，也出现了近两年以来第一次颗粒物重度污染天。静稳高湿的不利天气条件，尤其是极低的边界层高度，是本次污染的主要外因，由于本地大气污染物排放体量大，强度高，一旦出现静稳高湿等气象条件不利，出现中度及以上污染的风险将非常高。'
            _this.report.editContentSummary = _this.report.generateContentSummary;
        }
    }
})
;
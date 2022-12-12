/** 预警快报-编辑逻辑js **/
var vue = new Vue({
    el: '#main-container',
    data: {
        // 该功能调用的所有url列表
        urls: {
            // 根据报告ID和文件来源查询信息
            queryGeneralReportById: ctx + '/analysis/decisionMeasure/getFileInfoByAscriptionType.vm',
            // 保存数据
            saveUrl: ctx + "/analysis/decisionMeasure/save.vm"
        },
        isAdd: isAdd,
        // 报告数据
        report: {
            //是否为添加数据
            isAdd: isAdd,
            //是否显示预警管控信息
            isShowControl: isShowControl,

            /*-------------报表-------------*/
            // 报告ID
            reportId: reportId,
            // 归属类型
            ascriptionType: ascriptionType,
            // 报告时间
            reportTime: '',
            // 报告名称
            reportName: '',
            // 重要提示
            reportTip: '',

            /*-------------预警管控信息-------------*/
            //管控ID
            warnControlId: reportId,
            //管控名称
            controlName: '',
            //预警级别
            warnLevel: '',
            warnLevelName: '',
            //管控开始时间
            warnStartTime: '',
            //管控结束时间
            warnEndTime: '',
            //发文日期
            pushDate: '',
            //文件名称
            fileName: '',
            //文号
            fileId: '',
            //首要污染物
            pollute: '',
            //是否添加预警管控
            isWarmControl: 0,
            //状态 0 停用 1 启用
            state: 0
        },
        //预警级别
        levelOptions: [
            {name: "蓝色预警", code: "0"},
            {name: "黄色预警", code: "1"},
            {name: "橙色预警", code: "2"},
            {name: "红色预警", code: "3"}
        ],
        //污染物
        pollutes: [
            {code: "NO2", name: "NO₂"},
            {code: "SO2", name: "SO₂"},
            {code: "CO", name: "CO"},
            {code: "O3", name: "O₃"},
            {code: "PM10", name: "PM₁₀"},
            {code: "PM25", name: "PM₂.₅"}
        ],
        //文件
        fileTypes: (fileTypes && fileTypes != 'null') ? fileTypes.split(",") : [],
        fileTypeNames: (fileTypeNames && fileTypeNames != 'null') ? fileTypeNames.split(",") : [],
        //图片
        imageTypes: (imageTypes && imageTypes != 'null') ? imageTypes.split(",") : [],
        imageTypeNames: (imageTypeNames && imageTypeNames != 'null') ? imageTypeNames.split(",") : [],
    },
    // 页面加载完后调用
    mounted: function () {
        // 如果是编辑,则加载初始化数据
        // 初始化数据
        if (this.isAdd == '0') {
            this.initData();
        } else {
            this.report.reportTime = DateTimeUtil.getNowDate();
        }
        // 注册表单验证
        $('#mainForm').validationEngine({
            scrollOffset: 98, // 屏幕自动滚动到第一个验证不通过的位置。必须设置，因为Toolbar position为Fixed
            promptPosition: 'bottomLeft', // 提示框位置为下左
            autoHidePrompt: true, // 自动隐藏提示框
            validateNonVisibleFields: true // 不可见字段验证
        });
    },
    methods: {
        /**
         * 编辑，回显数据
         */
        initData: function () {
            var _this = this;
            AjaxUtil.sendAjaxRequest(_this.urls.queryGeneralReportById, null, {
                reportId: _this.report.reportId,
                ascriptionType: _this.report.ascriptionType,
            }, function (json) {
                var data = json.data;
                _this.report.reportTime = data.REPORT_TIME;
                _this.report.reportName = data.REPORT_NAME;
                _this.report.reportTip = data.REPORT_TIP;

                if (data.IS_WARM_CONTROL) {
                    //--------管控信息-------
                    //管控名称
                    _this.report.controlName = data.CONTROL_NAME;
                    //预警级别
                    _this.report.warnLevel = data.WARN_LEVEL;
                    _this.report.warnLevelName = data.WARN_LEVEL_NAME;
                    //管控开始时间
                    _this.report.warnStartTime = data.WARN_START_TIME;
                    //管控结束时间
                    _this.report.warnEndTime = data.WARN_END_TIME;
                    //发文日期
                    _this.report.pushDate = data.PUSH_DATE;
                    //文件名称
                    _this.report.fileName = data.FILE_NAME;
                    //文号
                    _this.report.fileId = data.FILE_ID;
                    //是否添加预警管控
                    _this.report.isWarmControl = data.IS_WARM_CONTROL;
                }
            });
        },
        /**
         * 保存
         */
        saveData: function () {
            var _this = this;
            // 验证表单
            var flag = $('#mainForm').validationEngine('validate');
            if (!flag) {
                // 验证不通过，不提交
                return;
            }
            if (_this.report.isWarmControl == 1) {
                if (_this.report.ascriptionType == 'WINTER_CAMPAIGN' || _this.report.ascriptionType == 'SUMMER_CAMPAIGN') {
                    if (!_this.report.warnLevel) {
                        DialogUtil.showTipDialog("预警级别不能为空！");
                        return;
                    }
                    //预警级别名称
                    let warnLevelName = '';
                    for (let i = 0; i < _this.levelOptions.length; i++) {
                        if (_this.levelOptions[i].code == _this.report.warnLevel) {
                            warnLevelName = _this.levelOptions[i].name;
                        }
                    }
                    _this.report.warnLevelName = warnLevelName;
                }
            }

            // 验证通过，
            var tipMessage = {
                confirmMessage: '保存数据，请确认！',
                successMessage: '保存成功！'
            };
            DialogUtil.showConfirmDialog(tipMessage.confirmMessage, function () {
                // 将基础数据添加到表单数据中
                AjaxUtil.sendAjaxRequest(_this.urls.saveUrl, 'post', _this.report, function () {
                    DialogUtil.showTipDialog(tipMessage.successMessage, function () {
                        _this.cancel(true);
                    }, function () {
                        _this.cancel(true);
                    });
                });
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
                isShowClear: true,
                // 只读
                readOnly: true,
                maxDate: '%y-%M-%d',
                onpicked: function (dp) {
                    // 确认按钮点击事件
                    _this.report.reportTime = dp.cal.getNewDateStr();
                },
                onclearing: function () {
                    _this.report.reportTime = '';
                },
            });
        },
        /**
         * 管控开始时间
         */
        queryControlStartTime: function () {
            var _this = this;
            WdatePicker({
                // 回显数据的对象ID
                el: 'warnStartTime',
                // 时间格式
                dateFmt: 'yyyy-MM-dd HH:00:00',
                // 是否显示清除按钮
                isShowClear: true,
                // 只读
                readOnly: true,
                maxDate: '#F{$dp.$D(\'warnEndTime\')}',
                onpicked: function (dp) {
                    // 确认按钮点击事件
                    _this.report.warnStartTime = dp.cal.getNewDateStr();
                },
                onclearing: function () {
                    _this.report.warnStartTime = '';
                },
            });
        },
        /**
         * 管控结束时间
         */
        queryControlEndTime: function () {
            var _this = this;
            WdatePicker({
                // 回显数据的对象ID
                el: 'warnEndTime',
                // 时间格式
                dateFmt: 'yyyy-MM-dd HH:00:00',
                // 是否显示清除按钮
                isShowClear: true,
                // 只读
                readOnly: true,
                minDate: '#F{$dp.$D(\'warnStartTime\')}',
                onpicked: function (dp) {
                    // 确认按钮点击事件
                    _this.report.warnEndTime = dp.cal.getNewDateStr();
                },
                onclearing: function () {
                    _this.report.warnEndTime = '';
                },
            });
        },
        /**
         * 发文时间
         */
        queryPublishTime: function () {
            var _this = this;
            WdatePicker({
                // 回显数据的对象ID
                el: 'pushDate',
                // 时间格式
                dateFmt: 'yyyy-MM-dd HH:mm:ss',
                // 是否显示清除按钮
                isShowClear: false,
                // 只读
                readOnly: true,
                maxDate: '%y-%M-%d',
                onpicked: function (dp) {
                    // 确认按钮点击事件
                    _this.report.pushDate = dp.cal.getNewDateStr();
                },
                onclearing: function () {
                    _this.report.pushDate = '';
                },
            });
        },
    }
});
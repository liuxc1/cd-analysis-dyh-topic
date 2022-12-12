/** 预警快报-编辑逻辑js **/
var vue =new Vue({
    el: '#main-container',
    data: {
        // 该功能调用的所有url列表
        urls: {
            // 根据报告ID和文件来源查询信息
            queryGeneralReportById: ctx + '/analysis/warnbulletin/getFileInfoByAscriptionType.vm',
            // 保存数据
            saveUrl: ctx + "/analysis/warnbulletin/save.vm",
            //提交数据
            submitUrl: ctx+"/analysis/warnbulletin/submit.vm"
        },
        isAdd:isAdd,
        // 报告数据
        report: {
            //是否为添加数据
            isAdd:isAdd,
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
            //预警快报内容
            remark: '',
            //落款
            reportInscribe: '成都市环境保护科学研究院',
            // 状态
            state: '',
        },
    },
    // 页面加载完后调用
    mounted: function () {
        // 如果是编辑,则加载初始化数据
        // 初始化数据
        if (this.isAdd == '0') {
            this.initData();
        }else {
            this.report.reportTime=DateTimeUtil.getNowDate();
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
                _this.report.remark = data.REMARK;
                _this.report.reportInscribe = data.REPORT_INSCRIBE;
            });
        },
        /**
         * 保存、提交
         */
        saveData: function (state) {
            var _this = this;
            // 验证表单
            var flag = $('#mainForm').validationEngine('validate');
            if (!flag) {
                // 验证不通过，不提交
                return;
            }
            // 验证通过，
            var tipMessage = {
                confirmMessage: '保存数据，请确认！',
                successMessage: '保存成功！',
                submitMessage: '提交数据，请确认！',
                submitSuccessMessage: '提交成功！'
            };
            //暂存、提交
            _this.report.state = state;
            DialogUtil.showConfirmDialog(('UPLOAD'.indexOf(state)===0?tipMessage.submitMessage:tipMessage.confirmMessage), function () {
                // 将基础数据添加到表单数据中
                AjaxUtil.sendAjaxRequest(_this.urls.saveUrl, 'post',_this.report, function () {
                    DialogUtil.showTipDialog(('UPLOAD'.indexOf(state)===0?tipMessage.submitSuccessMessage:tipMessage.successMessage), function () {
                        _this.cancel(true);
                    }, function () {
                        _this.cancel(true);
                    })
                });
            })
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
                dateFmt: 'yyyy-MM-dd HH:mm:ss',
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
                dateFmt: 'yyyy-MM-dd HH:mm:ss',
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
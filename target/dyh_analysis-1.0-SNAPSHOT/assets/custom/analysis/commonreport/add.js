/** 预警快报-编辑逻辑js **/
var vue =new Vue({
    el: '#main-container',
    data: {
        // 该功能调用的所有url列表
        urls: {
            // 根据报告ID和文件来源查询信息
            queryGeneralReportById: ctx + '/analysis/commonReport/getFileInfoByAscriptionType.vm',
            // 保存数据
            saveUrl: ctx + "/analysis/commonReport/save.vm",
            //获取小类
            getSamllTypes:ctx+'/analysis/commonReport/getSamllType.vm'
        },
        isAdd:isAdd,
        isSmallType:isSmallType,
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
            //小类
            samllType:'',
            // 重要提示
            reportTip: '',
            // 状态
            state: "UPLOAD",
            //管控时间
            controlStartTime:'',
            controlEndTime:'',
        },
        //返回的小类
        samllTypes:[],
        //是否显示时间段
        isShowTimeHorizon:0,
        //显示时间段的类型
        showTimeHorizon:['SPECIAL_ACTIONS'],

    },
    // 页面加载完后调用
    mounted: function () {
        // 如果是编辑,则加载初始化数据
        // 初始化数据
        if (this.isAdd == '0') {
            this.initData();
            this.getSamllType();
        }else {
            this.report.reportTime=DateTimeUtil.getNowDate();
            this.report.controlStartTime=DateTimeUtil.getNowTime();
            this.getSamllType();
        }
        if (this.report.ascriptionType.indexOf(this.showTimeHorizon) > -1) {
            this.isShowTimeHorizon = 1
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
                _this.report.samllType = data.SAMLL_TYPE;
                _this.report.controlStartTime = data.CONTROL_START_TIME;
                _this.report.controlEndTime = data.CONTROL_END_TIME;
            });
        },
        /**
         * 获取小类
         */
        getSamllType: function () {
            let _this = this;
            AjaxUtil.sendAjaxRequest(_this.urls.getSamllTypes,'post',{
                    ascriptionType: _this.report.ascriptionType,
                },
                function (result) {
                    if (result.data){
                        _this.samllTypes = result.data;
                    }else{
                        _this.samllTypes=[];
                    }
                },
                function (){
                    _this.samllTypes=[];
                }
            )
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
            if (!_this.report.samllType && _this.isSmallType==1){
                DialogUtil.showTipDialog("小类不能为空！");
                return;
            }
            // 验证通过，
            var tipMessage = {
                confirmMessage: '保存数据，请确认！',
                successMessage: '保存成功！'
            };
            DialogUtil.showConfirmDialog(tipMessage.confirmMessage, function () {
                // 将基础数据添加到表单数据中
                AjaxUtil.sendAjaxRequest(_this.urls.saveUrl, 'post',_this.report, function () {
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
                el: 'controlStartTime',
                // 时间格式
                dateFmt: 'yyyy-MM-dd HH:00:00',
                // 是否显示清除按钮
                isShowClear: true,
                // 只读
                readOnly: true,
                maxDate: '#F{$dp.$D(\'controlEndTime\')}',
                onpicked: function (dp) {
                    // 确认按钮点击事件
                    _this.report.controlStartTime = dp.cal.getNewDateStr();
                    _this.report.reportTime = dp.cal.getNewDateStr();
                },
                onclearing: function () {
                    _this.report.controlStartTime = '';
                    _this.report.reportTime = "";
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
                el: 'controlEndTime',
                // 时间格式
                dateFmt: 'yyyy-MM-dd HH:00:00',
                // 是否显示清除按钮
                isShowClear: true,
                // 只读
                readOnly: true,
                minDate: '#F{$dp.$D(\'controlStartTime\')}',
                onpicked: function (dp) {
                    // 确认按钮点击事件
                    _this.report.controlEndTime = dp.cal.getNewDateStr();
                },
                onclearing: function () {
                    _this.report.controlEndTime = '';
                },
            });
        },
    }
});
/** 预警快报-编辑逻辑js **/
var vue = new Vue({
    el: '#main-container',
    data: {
        // 该功能调用的所有url列表
        urls: {
            //最新时间
            queryNewDateUrl: ctx + '/analysis/commonReport/getNewestDate.vm',
            // 列表数据
            queryReportListByAscriptionType: ctx + '/analysis/commonReport/queryReportListByAscriptionType.vm',
            //获取小类
            getSamllTypes:ctx+'/analysis/commonReport/getSamllType.vm',
            //查看页面
            viewUrl: ctx + '/analysis/commonReport/index.vm',
            // 编辑页面
            editUrl: ctx + '/analysis/commonReport/add.vm',
            // 删除
            deleteReportById: ctx + '/analysis/report/generalReport/deleteReportById.vm',

        },
        // 报告数据
        param: {
            // 归属类型
            ascriptionType: ascriptionType,
            // 报告时间
            startTime: '',
            endTime: '',
            //小类
            samllType:''
        },
        //返回的小类
        samllTypes:[],
        menuName: menuName,
        isSmallType:isSmallType,
        listObj: {
            total: 0,
            pageNum: 1,
            pageSize: 10,
            list: [],
        },
    },
    // 页面加载完后调用
    mounted: function () {
        this.initData();
        this.getSamllType();
    },
    methods: {
        /**
         * 最新时间
         */
        initData: function () {
            let _this = this;
            AjaxUtil.sendAjaxRequest(_this.urls.queryNewDateUrl, 'post', _this.param,
                function (result) {
                    if (result.data) {
                        _this.param.startTime = result.data.startTime;
                        _this.param.endTime = result.data.endTime;
                        _this.doSearch();
                    } else {
                        _this.param.startTime = '';
                        _this.param.endTime = '';
                    }
                },
                function () {
                    _this.param.startTime = '';
                    _this.param.endTime = '';
                });
        },
        /**
         * 查询列表数据
         */
        doSearch: function () {
            let _this = this;
            _this.param.pageNum=_this.listObj.pageNum;
            _this.param.pageSize=_this.listObj.pageSize;
            AjaxUtil.sendAjaxRequest(_this.urls.queryReportListByAscriptionType, 'post', _this.param,
                function (result) {
                    if (result.data) {
                        _this.listObj = result.data;
                    } else {
                        _this.listObj.list = [];
                    }
                },
                function () {
                    _this.listObj.list = [];
                });
        },
        /**
         * 获取小类
         */
        getSamllType: function () {
          let _this = this;
          AjaxUtil.sendAjaxRequest(_this.urls.getSamllTypes,'post',{
                  ascriptionType: _this.param.ascriptionType,
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
         * 添加
         */
        toAdd: function (reportId) {
            let url = this.urls.editUrl + '?reportId=' + reportId + '&ascriptionType=' + this.param.ascriptionType + '&menuName=' + this.menuName+'&isSmallType='+isSmallType;
            this.pageDialog = DialogUtil.showDialog(url, 0.7, 0.6);
        },
        /**
         * 查看
         */
        view: function (reportId) {
            let url = this.urls.viewUrl + '?showClose=1&reportId=' + reportId + '&type=' + this.param.ascriptionType + '&menuName=' + this.menuName;
            this.pageDialog = DialogUtil.showDialog(url, 0.8, 0.8);
        },
        /**
         * 删除数据
         */
        deleteById: function (reportId) {
            var _this = this;
            DialogUtil.showDeleteDialog(null, function () {
                // 当前选中
                AjaxUtil.sendAjaxRequest(_this.urls.deleteReportById, null, {
                    reportId: reportId
                }, function (json) {
                    DialogUtil.showTipDialog("删除成功！", function () {
                        // 刷新页面
                        _this.doSearch();
                    }, function () {
                        _this.doSearch();
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
                this.doSearch();
                this.getSamllType();
            }
        },
        /**
         * 日期选择插件
         */
        queryStartTime: function () {
            var _this = this;
            WdatePicker({
                // 回显数据的对象ID
                el: 'queryStartTime',
                // 时间格式
                dateFmt: 'yyyy-MM-dd',
                // 是否显示清除按钮
                isShowClear: true,
                // 只读
                readOnly: true,
                maxDate: '#F{$dp.$D(\'queryEndTime\')}',
                onpicked: function (dp) {
                    // 确认按钮点击事件
                    _this.param.startTime = dp.cal.getNewDateStr();
                },
                onclearing: function () {
                    _this.param.startTime = '';
                }
            });
        },
        /**
         * 日期选择插件
         */
        queryEndTime: function () {
            var _this = this;
            WdatePicker({
                // 回显数据的对象ID
                el: 'queryEndTime',
                // 时间格式
                dateFmt: 'yyyy-MM-dd',
                // 是否显示清除按钮
                isShowClear: true,
                // 只读
                readOnly: true,
                minDate: '#F{$dp.$D(\'queryStartTime\')}',
                onpicked: function (dp) {
                    // 确认按钮点击事件
                    _this.param.endTime = dp.cal.getNewDateStr();
                },
                onclearing: function () {
                    _this.param.endTime = '';
                }
            });
        },
    }
});
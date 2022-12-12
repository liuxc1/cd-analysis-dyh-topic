var vue = new Vue({
    el: '#main-container',
    data: {
        urls: {
            getPlanNamePage: ctx + '/asses/getPlanNamePage.vm',
            deleteAssessMain: ctx + '/asses/deleteAssessMain.vm',//删除方案
        },
        queryParams: {
            startTime: '',
            endTime: '',
            assessType: type
        },
        forecastPage: {
            total: 0,
            pageNum: 1,
            pageSize: 10,
            list: [],
        },
        pageDialog: null,
        //2:后评估 1:预评估
        type:type,
        //全局状态属性
        globalStatus: {
            //是否全选
            checkedAll: false,
        },
    },
    /**
     * 页面加载完后调用
     */
    mounted: function () {
        this.queryForecastLogData();
    },
    filters: {
        startDateFormat: function (val) {
            if (val) {
                return val.split("~")[0];
            } else {
                return '--';
            }
        },
        endDateFormat: function (val) {
            if (val) {
                return val.split("~")[1];
            } else {
                return '--';
            }
        },
    },
    methods: {
        queryForecastLogData: function () {
            const _this = this;
            AjaxUtil.sendAjaxRequest(_this.urls.getPlanNamePage, null,
                {
                    startTime: _this.queryParams.startTime,
                    endTime: _this.queryParams.endTime,
                    pageNum: _this.forecastPage.pageNum,
                    pageSize: _this.forecastPage.pageSize,
                    assessType:_this.queryParams.assessType
                },
                function (json) {
                    _this.forecastPage = json.data.data;
                });
        },
        doSearch: function () {
            this.globalStatus.checkedAll = false;
            this.queryForecastLogData();
        },
        /**
         * 表格数据选择变动处理（单个与全局的互相影响）
         * @param {Object} item 单个元素
         */
        checkTableData: function (item) {
            let itemList = this.forecastPage.list;
            if (item) {
                let check = item['checked'];
                if (check) {
                    for (let i = 0; i < itemList.length; i++) {
                        if (itemList[i]['checked'] !== check) {
                            check = false;
                            break;
                        }
                    }
                }
                Vue.set(this.globalStatus, 'checkedAll', check);
            } else {
                let check = this.globalStatus['checkedAll'];
                for (let i = 0; i < itemList.length; i++) {
                    Vue.set(itemList[i], 'checked', check);
                }
            }
        },
        /**
         * 预报开始时间
         */
        forecastTimeStart: function () {
            let _this = this;
            WdatePicker({
                // 回显数据的对象ID
                el: 'forecastTimeStart',
                // 时间格式
                dateFmt: 'yyyy-MM-dd',
                // 是否显示清除按钮
                isShowClear: true,
                // 只读
                readOnly: true,
                // 最大时间限制，参考：http://www.my97.net/demo/index.htm
                maxDate: '#F{$dp.$D(\'forecastTimeEnd\')}',
                onpicking: function (dp) {
                    _this.queryParams.startTime = dp.cal.getNewDateStr();
                },
                onclearing: function () {
                    _this.queryParams.startTime = '';
                }
            });
        },
        /**
         * 预报结束时间
         */
        forecastTimeEnd: function () {
            let _this = this;
            WdatePicker({
                // 回显数据的对象ID
                el: 'forecastTimeEnd',
                // 时间格式
                dateFmt: 'yyyy-MM-dd',
                // 是否显示清除按钮
                isShowClear: true,
                // 只读
                readOnly: true,
                // 最大时间限制，参考：http://www.my97.net/demo/index.htm
                minDate: '#F{$dp.$D(\'forecastTimeStart\')}',
                onpicking: function (dp) {
                    _this.queryParams.endTime = dp.cal.getNewDateStr();
                },
                onclearing: function () {
                    _this.queryParams.endTime = '';
                }
            });
        },
        /**
         * 时间处理
         * @param dateTime
         * @returns {string}
         */
        substringDate: function (dateTime) {
            return dateTime.substring(0, 13);
        },
        /**
         * 添加页面
         */
        toAdd: function (id) {
            var url = ctx + '/asses/assesAddOrEdit.vm?id=' + id+'&type='+this.type;
            this.pageDialog = DialogUtil.showFullScreenDialog(url);
        },
        /**
         * 跳转查看
         */
        toShow:function(data){
            var url = ctx + '/asses/show.vm?date='+data.date+'&pkid='+data.pkid+'&type='+this.type;
            this.pageDialog = DialogUtil.showFullScreenDialog(url);
        },
        /**
         * 提示
         * @param msg
         */
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
            }
        },
        /**
         * 删除方案
         */
        deleteMain: function (pkid) {
            if (!pkid) {
                DialogUtil.showTipDialog('请选择要删除的方案');
                return;
            }
            const _this = this;
            DialogUtil.showConfirmDialog('确定删除方案?', function () {
                $axios.get(_this.urls.deleteAssessMain, {pkid: pkid,deleteFlag:1})
                    .then(res => {
                        if (res.code == 200) {
                            _this.doSearch();
                        }else{
                            DialogUtil.showTipDialog(res.message);
                        }
                    });
            })
        },
        /**
         * 批量删除
         */
        bachDelete: function () {
            const _this = this;
            let pkIds = [];
            let  itemList = _this.forecastPage.list;
            for (let i = 0; i < itemList.length; i++) {
                if (itemList[i]['checked']) {
                    pkIds.push(itemList[i]['pkid']);
                }
            }
            _this.deleteMain(pkIds.join(","));
        }
    }
});





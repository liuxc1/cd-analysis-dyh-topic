var vue = new Vue({
    el: '#main-container',
    data: {
        pageDialog: null,//弹框对象
        //主要天气影响
        weatherTypeList: [],
        //主要污染物影响
        pollutantList: [],
        param: {
            startTime: "",
            endTime: "",
            weatherCodes: [],
            polluteCodes: []
        },
        pageObj: {
            total: 0,
            pageNum: 1,
            pageSize: 10,
            list: [],
        }
    },
    mounted: function () {
        //气象条件
        this.initDictionaryList('TQXSLX');
        //污染物类型
        this.initDictionaryList('KLWLX');
        this.queryCastList();
    },
    methods: {
        /**
         * 查询案例列表
         */
        queryCastList: function () {
            let _this = this;
            AjaxUtil.sendPostAjaxRequest(ctx + '/analysis/forecastCastLibrary/queryCastList.vm',
                {
                    startTime: this.param.startTime,
                    endTime: this.param.endTime,
                    weatherCodes: this.param.weatherCodes.join(","),
                    polluteCodes: this.param.polluteCodes.join(","),
                    pageNum: this.pageObj.pageNum,
                    pageSize: this.pageObj.pageSize
                },
                function (json) {
                    _this.pageObj = json.data;
                }, null, null);
        },
        /**
         * 加载天气类型
         */
        initDictionaryList: function (treeCode) {
            let _this = this;
            AjaxUtil.sendPostAjaxRequest(ctx + '/analysis/forecastCastLibrary/queryDictionaryListByCode.vm',
                {
                    treeCode: treeCode
                },
                function (json) {
                    if (treeCode == "TQXSLX") {
                        _this.weatherTypeList = json.data;
                    } else {
                        _this.pollutantList = json.data;
                    }
                }, null, null);
        },
        /**
         *
         * 开始时间
         */
        distributeTimeStart: function () {
            var _this = this;
            WdatePicker({
                dateFmt: 'yyyy-MM-dd',
                el: 'distributeTimeStart',
                maxDate: '#F{$dp.$D(\'distributeTimeEnd\')}',
                isShowClear: true,
                onpicking: function (dp) {
                    _this.param.startTime = dp.cal.getNewDateStr();
                },
                onclearing: function () {
                    _this.param.startTime = '';
                },
                readOnly: true
            });
        },
        /**
         *结束时间
         */
        distributeTimeEnd: function () {
            const _this = this;
            WdatePicker({
                dateFmt: 'yyyy-MM-dd',
                el: 'distributeTimeEnd',
                minDate: '#F{$dp.$D(\'distributeTimeStart\')}',
                isShowClear: true,
                onpicking: function (dp) {
                    _this.param.endTime = dp.cal.getNewDateStr();
                },
                onclearing: function () {
                    _this.param.endTime = '';
                },
                readOnly: true
            });
        },
        /**
         * 添加
         */
        caseAddIndex: function () {
            let _this = this;
            this.pageDialog = DialogUtil.showFullScreenDialog(ctx + "/analysis/forecastCastLibrary/add.vm");
        },
        /**
         * 删除
         * @param id
         */
        deleteById: function (id) {
            let _this = this;
            DialogUtil.showConfirmDialog("确认要删除该案例吗？", function () {
                AjaxUtil.sendPostAjaxRequest(ctx + '/analysis/forecastCastLibrary/delete.vm',
                    {id: id},
                    function (json) {
                        DialogUtil.showTipDialog("删除成功！", function () {
                            _this.queryCastList();
                        });

                    }, null, null);
            }, function () {
            });
        },
        /**
         * 查看
         * @param id
         */
        view: function (id) {
            let _this = this;
            this.pageDialog = DialogUtil.showFullScreenDialog(ctx + "/analysis/forecastCastLibrary/view.vm?id=" + id);
        },
        closePageDialog: function (isRefresh) {
            // 关闭弹框
            if (this.pageDialog) {
                this.pageDialog.close().remove();
                this.pageDialog = null;
            }
            //刷新列表
            if (isRefresh) {
                this.queryCastList();
            }
        },
        /**
         * 导出案列excel
         */
        exportForcast: function () {
            const _this = this;
            let url = ctx + '/analysis/forecastCastLibrary/exportForcastExcel.vm?' +
                'startTime=' + _this.param.startTime +
                '&endTime=' + _this.param.endTime +
                '&weatherCodes=' + _this.param.weatherCodes.join(',') +
                '&polluteCodes=' + _this.param.polluteCodes.join(',');
            let a = document.createElement("a");
            a.setAttribute("download", "");
            a.setAttribute("href", url);
            a.click();
            a.remove();
        },
        /**
         * 导出word
         */
        exportWord: function (pkid) {
            const _this = this;
            let url = ctx + '/analysis/forecastCastLibrary/exportForcastDetailWord.vm?castId='+pkid;
            let a = document.createElement("a");
            a.setAttribute("download", "");
            a.setAttribute("href", url)
            console.log(url);
            a.click();
            a.remove();
        }
    }
});

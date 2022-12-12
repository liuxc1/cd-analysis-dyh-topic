var vue = new Vue({
    el: '#main-container',
    data: {
        url: {
            getForecastLogData: ctx + '/analysis/air/ForecastProcess/getForecastLog.vm',
            queryMaxLogTime: ctx + '/analysis/air/ForecastProcess/queryMaxLogTime.vm',
            exportExcel: ctx + '/analysis/air/ForecastProcess/exportExcel.vm',

        },
        queryParams: {
            forecastTimeStart:'',
            forecastTimeEnd:'',
        },
        forecastPage: {
            total: 0,
            pageNum: 1,
            pageSize: 10,
            list: [],
        },
    },
    /**
     * 页面加载完后调用
     */
    mounted: function () {
        this.queryMaxLogTime();
    },
    methods: {
        queryMaxLogTime:function(){
            let _this = this;
            AjaxUtil.sendAjaxRequest(_this.url.queryMaxLogTime, null,{},function (json) {
                _this.queryParams.forecastTimeStart = json.data.forecastTimeStart.substring(0,10);
                _this.queryParams.forecastTimeEnd = json.data.forecastTimeEnd.substring(0,10);
                _this.queryForecastLogData();
                });
        },
        queryForecastLogData:function(){
            let _this = this;
            AjaxUtil.sendAjaxRequest(_this.url.getForecastLogData, null,
                {
                    forecastTimeStart:_this.queryParams.forecastTimeStart,
                    forecastTimeEnd:_this.queryParams.forecastTimeEnd,
                    pageNum:_this.forecastPage.pageNum,
                    pageSize:_this.forecastPage.pageSize,
                },
                function (json) {
                _this.forecastPage = json.data;
            });
        },
        doSearch:function(){
            this.queryForecastLogData();
        },
        exportExcel:function(){
            let _this = this;
            let url = _this.url.exportExcel;
            let params = {
                forecastTimeStart:_this.queryParams.forecastTimeStart,
                forecastTimeEnd:_this.queryParams.forecastTimeEnd,
            };
            FileDownloadUtil.createSubmitTempForm(url, params);
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
                isShowClear: false,
                // 只读
                readOnly: true,
                // 最大时间限制，参考：http://www.my97.net/demo/index.htm
                maxDate: '#F{$dp.$D(\'forecastTimeEnd\')}',
                onpicking: function (dp) {
                    _this.queryParams.forecastTimeStart = dp.cal.getNewDateStr();
                },
                onclearing: function () {
                    _this.queryParams.forecastTimeStart = '';
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
                isShowClear: false,
                // 只读
                readOnly: true,
                // 最大时间限制，参考：http://www.my97.net/demo/index.htm
                minDate: '#F{$dp.$D(\'forecastTimeStart\')}',
                onpicking: function (dp) {
                    _this.queryParams.forecastTimeEnd = dp.cal.getNewDateStr();
                },
                onclearing: function () {
                    _this.queryParams.forecastTimeEnd = '';
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
    }
});

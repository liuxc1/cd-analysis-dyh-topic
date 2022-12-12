/** vue实例表格-1 * */
var vue = new Vue(
    {
        el: '#main-container',
        data: {
            tableList:[],
            //查询条件
            params:{
                startTime:null,
                endTime:null,
            },
        },
        mounted: function () {
            var _this = this;
            this.init();

        },
        filters: {
            /**
             * 通用内容格式器（无效值用返回--）
             * @param val 值
             * @returns {string|*} 格式化后的值
             */
            resultFormat: function (val) {
                if (val || val === 0) {
                    return val;
                } else {
                    return '-';
                }
            },
        },
        methods: {
            /**
             * 初始化
             */
            init: function () {
                let _this = this;
                AjaxUtil.sendAjax("getMaxTime.vm", {'isCd':'no'},function (result){
                    _this.params.startTime=result.data.START_TIME;
                    _this.params.endTime=result.data.END_TIME;
                    _this.doSearch();
                },null,null)

            },
            /**
             * 查询
             */
            doSearch:function(){
                let _this = this;
                AjaxUtil.sendAjax("getForecastCountyTableData.vm", {
                    startTime:_this.params.startTime,
                    endTime:_this.params.endTime
                },function (result){
                    _this.tableList = result.data;
                    //_this.export();
                },null,null)
            },
            /**
             * 导出
             */
            exportFile:function(){
                let _this = this;
                let params = {
                    startTime:_this.params.startTime,
                    endTime:_this.params.endTime
                };
                FileDownloadUtil.createSubmitTempForm("exportExcel.vm", params);
            },
            /**
             * 时间开始
             */
            queryTimeStart : function(){
                var _this = this;
                WdatePicker({
                    dateFmt : 'yyyy-MM-dd',
                    el : 'queryTimeStart',
                    maxDate : '#F{$dp.$D(\'queryTimeEnd\')}',
                    isShowClear : true,
                    onpicking:function(dp){
                        _this.params.startTime=dp.cal.getNewDateStr();
                    },
                    onclearing:function(){
                        _this.params.startTime='';
                    },
                    readOnly : true
                });
            },
            /**
             * 结束时间
             */
            queryTimeEnd : function(){
                var _this = this;
                WdatePicker({
                    dateFmt : 'yyyy-MM-dd',
                    el : 'queryTimeEnd',
                    minDate : '#F{$dp.$D(\'queryTimeStart\')}',
                    isShowClear : true,
                    onpicking:function(dp){
                        _this.params.endTime=dp.cal.getNewDateStr();
                    },
                    onclearing:function(){
                        _this.params.endTime='';
                    },
                    readOnly : true
                });
            },

        },

    });

// 公共提示框
function showMessageDialog(msg) {
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
}

// 公共提示框
function showTimeoutMessageDialog(msg, time) {
    var d = dialog({
        icon: "fa-warning",
        wraperstyle: 'alert-warning',
        title: "警告",
        content: "<b>" + msg + "</b>"
    });
    d.showModal();
    setTimeout(function () {
        d.close().remove();
    }, time);
}


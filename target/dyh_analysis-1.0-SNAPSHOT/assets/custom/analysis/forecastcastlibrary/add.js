var vue = new Vue({
    el: '#main-container',
    data: {
        //主要天气影响
        weatherTypeList: [],
        //主要污染物影响
        pollutantList: [],
        dataList:[],
        param: {
            startTime: "",
            endTime: "",
            weatherCode: "",
            polluteCode: ""
        }
    },
    mounted: function () {
        // 注册表单验证
        $('#formList').validationEngine({
            // 屏幕自动滚动到第一个验证不通过的位置。必须设置，因为Toolbar position为Fixed
            scrollOffset: 98,
            // 提示框位置为下左
            promptPosition: 'bottomLeft',
            // 自动隐藏提示框
            autoHidePrompt: true,
            // 不可见字段验证
            validateNonVisibleFields: true
        });
        //气象条件
        this.initDictionaryList('TQXSLX');
        //污染物类型
        this.initDictionaryList('KLWLX');
    },

    methods: {
        /**
         * 保存
         */
        save:function(){
            // 验证表单
            let flag = $('#formList').validationEngine('validate');
            if (!flag ) {
                return null;
            }
            if (this.dataList.length <= 0 || !this.dataList[0].POLLUTE_NUM) {
                DialogUtil.showTipDialog("未查询到污染过程数据！", null);
                return null;
            }
            let _this = this;
            AjaxUtil.sendPostAjaxRequest(ctx + '/analysis/forecastCastLibrary/save.vm',
                {
                    startTime: this.param.startTime,
                    endTime: this.param.endTime,
                    weatherCode: this.param.weatherCode,
                    polluteCode: this.param.polluteCode,
                    weatherName: this.bulidNameByCode(this.weatherTypeList,this.param.weatherCode),
                    polluteName: this.bulidNameByCode(this.pollutantList,this.param.polluteCode),
                },
                function (json) {
                   if(json.code ===200){
                    //跳转到列表页面
                        _this.cancel(true);
                   }
                }, null, null);
        },
        /**
         * 查询表数据
         */
        queryCalculationDataList: function () {
            if (this.param.startTime && this.param.endTime) {
                let _this = this;
                AjaxUtil.sendPostAjaxRequest(ctx + '/analysis/forecastCastLibrary/queryCalculationDataList.vm',
                    {
                        startTime: this.param.startTime,
                        endTime: this.param.endTime
                    },
                    function (json) {
                        _this.dataList =[];
                        if(json.data && json.data[0].POLLUTE_NUM){
                            _this.dataList = json.data;
                        }
                    }, null, null);
            }
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
         * 开始时间
         */
        distributeTimeStart : function(){
            let _this = this;
            WdatePicker({
                dateFmt : 'yyyy-MM-dd',
                el : 'distributeTimeStart',
                maxDate : '#F{$dp.$D(\'distributeTimeEnd\')}',
                isShowClear : true,
                onpicking:function(dp){
                    _this.param.startTime=dp.cal.getNewDateStr();
                    _this.queryCalculationDataList();
                },
                onclearing : function(){
                    _this.param.startTime = '';
                },
                readOnly : true
            });
        },
        /**
         *结束时间
         */
        distributeTimeEnd : function(){
            let _this = this;
            WdatePicker({
                dateFmt : 'yyyy-MM-dd',
                el : 'distributeTimeEnd',
                minDate : '#F{$dp.$D(\'distributeTimeStart\')}',
                isShowClear : true,
                onpicking:function(dp){
                    _this.param.endTime=dp.cal.getNewDateStr();
                    _this.queryCalculationDataList();
                },
                onclearing : function(){
                    _this.param.endTime = '';
                },
                readOnly : true
            });
        },
        bulidNameByCode:function(dataArray,code){
            let resultStr = "";
            for (let i = 0; i <dataArray.length; i++) {
                if(dataArray[i].DICTIONARY_CODE === code){
                    resultStr =  dataArray[i].DICTIONARY_NAME;
                    return resultStr;
                }
            }
            return resultStr;
        },
        cancel: function (isParentRefresh) {
            if (window.parent && window.parent.vue.closePageDialog) {
                // 调用父页面的关闭方法
                window.parent.vue.closePageDialog(isParentRefresh);
            } else {
                window.history.go(-1);
            }
        },
    }
});
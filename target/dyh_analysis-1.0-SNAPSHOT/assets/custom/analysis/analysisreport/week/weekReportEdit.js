/** 快报分析报告-编辑逻辑js **/
new Vue({
    el: '#main-container',
    data: {
        urls: {
            queryReportInfo: ctx + '/analysis/analysisreport/weekReport/queryReportInfo.vm',
            saveWeekReport: ctx + '/analysis/analysisreport/weekReport/saveWeekReport.vm',
            saveWeekReportAttach2: ctx + '/analysis/analysisreport/weekReport/saveWeekReportAttach2.vm',
            getAirData: ctx + '/analysis/analysisreport/weekReport/getAirData.vm',
            getUuidUrl: ctx + '/analysis/express/newsletterAnalysis/getUuid.vm',
            queryStateNumber: ctx + '/analysis/report/generalReport/queryStateNumber.vm',
        },
        ascriptionType: '',
        // 图片类型二
        ascriptionTypeTwo: 'WEEK_REPORT_TWO',
        // 图片类型三
        ascriptionTypeThree: 'WEEK_REPORT_THREE',
        // 图片类型四
        ascriptionTypeFour: 'WEEK_REPORT_FOUR',
        // 图片类型五
        ascriptionTypeFive: 'WEEK_REPORT_FIVE',
        stratTime:'',
        endTime:'',
        // 报告数据
        report: {},
        tableList:[],

    },
    // 页面加载完后调用
    mounted: function () {
        // 将回调延迟到下次 DOM 更新循环之后执行。在修改数据之后立即使用它，然后等待 DOM 更新
        this.$nextTick(function () {
            // // 归属类型
            this.ascriptionType = $('#ascription-type').val();
            this.report.ascriptionType = $('#ascription-type').val();
            // 报告频率
            this.report.reportRate = $('#report-rate').val();
            this.initData();
            // 注册表单验证
            $('#mainForm').validationEngine({
                scrollOffset: 98, // 屏幕自动滚动到第一个验证不通过的位置。必须设置，因为Toolbar position为Fixed
                promptPosition: 'bottomLeft', // 提示框位置为下左
                autoHidePrompt: true, // 自动隐藏提示框
                validateNonVisibleFields: true // 不可见字段验证
            });
        });
    },
    methods: {
        /**
         * 初始化数据，获取全部数据，包括图片信息
         */
        initData: function () {
            var _this = this;
            let toDay = DateTimeUtil.getNowDate();
            var weekNum = DateTimeUtil.getWeekNum(toDay);
            var dataTime = new Date();
            dataTime = dataTime.setDate(dataTime.getDate()+(5-weekNum));
            dataTime = new Date(dataTime)
            var nowDate = dataTime.getFullYear()+'-'+DateTimeUtil.beforeCompleZero(dataTime.getMonth() + 1)+'-'+DateTimeUtil.beforeCompleZero(dataTime.getDate());
            var param = {};
            if (reportId != null && reportId != undefined && reportId != '') {
                param = {
                    ascriptionType: _this.report.ascriptionType,
                    reportId: reportId
                }
            } else {
                param = {
                    ascriptionType: _this.report.ascriptionType,
                    reportTime: nowDate
                }
            }
            //查询当天是否已经提交报告，已提交就不能修改了
            AjaxUtil.sendAjaxRequest(_this.urls.queryStateNumber, null, param, function (json) {
                if (json.data.STATE_NUMBER == 0) {
                    _this.report.reportTime = nowDate;
                    _this.getStartEndTime(nowDate)
                    _this.initReportData();
                } else {
                    DialogUtil.showTipDialog(nowDate + "数据已提交，请重新选择填报日期！");
                    _this.report.reportTime = '';
                }
            });
        },
        //查询暂存的数据，
        initReportData:function(){
            var _this = this;
            var week = DateTimeUtil.getWeek(this.report.reportTime);
            _this.getStartEndTime(_this.report.reportTime)
            AjaxUtil.sendAjaxRequest(_this.urls.queryReportInfo, null, {
                reportTime:parseInt(week)-1,
                ascriptionType: _this.ascriptionType,
                month:  _this.report.reportTime,
                startTime: _this.stratTime,
                endTime:  _this.endTime,
                reportId: $('#report-id').val()
            }, function (json) {
                _this.tableList = json.data.list;
                if(json.data != null && json.data.reportInfo != null  ){
                    _this.report = json.data.reportInfo;
                    _this.tableList = json.data.list;
                }else{
                    //新数据报告
                    _this.noData();
                    _this.getUuid();
                    _this.getAirData();
                }
            });
        },

        /**
         * 查询该周的监测数据
         */
        getAirData:function(){
            var _this = this;
            AjaxUtil.sendAjaxRequest(_this.urls.getAirData, null, {
                startTime: _this.stratTime,
                endTime:  _this.endTime
            }, function (json) {
                _this.initAirData(json.data);
            },function(){

            });
        },
        initAirData:function(data){
            var _this = this;
            var report={};
            report.endTime = _this.report.endTime;
            report.reportId = _this.report.reportId;
            report.reportTime =  _this.report.reportTime;
            report.stratTime = _this.report.stratTime;
            report.ynum = data.text1.YNUM;
            report.lnum = data.text1.LNUM;
            report.qdnum = data.text1.QDNUM;
            report.zdnum = data.text1.ZDNUM;
            report.zzdnum = data.text1.ZZDNUM;
            report.yznum = data.text1.YZNUM;
            report.numno2 = data.text1.NUMNO2;
            report.numo3 = data.text1.NUMO3;
            report.numpm10 = data.text1.NUMPM10;
            report.numpm25 = data.text1.NUMPM25;
            report.numso2 = data.text1.NUMSO2;
            report.numco = data.text1.NUMCO;
            report.pm25 = data.text1.AVGPM25;
            report.pm10 = data.text1.AVGPM10;
            report.so2 = data.text1.AVGSO2;
            report.no2 = data.text1.AVGNO2;
            report.o3 = data.text1.AVGO3;
            report.co = data.text1.AVGCO;
            report.txtynum2 = data.text2.YNUM;
            report.txtlnum2 = data.text2.LNUM;
            report.txtqdnum2 = data.text2.QDNUM;
            report.txtzdnum2 = data.text2.ZDNUM;
            report.txtthisyear2 = data.text2.THISYEAR;
            report.isAdd = (data.text2.LASTYEARYNUM+data.text2.LASTYEARLNUM)>(data.text2.YNUM+data.text2.LNUM)?"减少":'增加';
            report.addNum = Math.abs((data.text2.LASTYEARYNUM+data.text2.LASTYEARLNUM)-(data.text2.YNUM+data.text2.LNUM));
            report.isaddpm25 = data.text2.AVGPM25>data.text2.LASTYEARAVGPM25?"上升":'降低'  ;
            report.ratepm25 =  (Math.abs((data.text2.AVGPM25-data.text2.LASTYEARAVGPM25)/data.text2.LASTYEARAVGPM25*1.0)*100).toFixed(2);
            report.ratepm10 =  (Math.abs((data.text2.AVGPM10-data.text2.LASTYEARAVGPM10)/data.text2.LASTYEARAVGPM10*1.0)*100).toFixed(2);
            report.txtpm252 = data.text2.AVGPM25;
            report.txtpm102 = data.text2.AVGPM10;
            _this.report=report;
        },
        getText1:function(){
            var _this = this;
            var text1= _this.report.reportTime.substring(0,4)+"年"+_this.replaceNull(_this.geMonthDay(_this.report.stratTime))+"-"+_this.replaceNull(_this.geMonthDay(_this.report.endTime))+
                "，我市空气质量为"+_this.replaceNull(_this.report.ynum)+"天优，"+_this.replaceNull(_this.report.lnum)+"天良，"+_this.replaceNull(_this.report.qdnum)+"天轻度污染；PM₂.₅、PM₁₀、SO₂、NO₂、O₃ 及 CO 平均浓度分别为"+
                _this.replaceNull(_this.report.pm25)+"μg/m³、"+_this.replaceNull(_this.report.pm10)+"μg/m³、"+_this.replaceNull(_this.report.so2)+"μg/m³、"+_this.replaceNull(_this.report.no2)+"μg/m³、"+_this.replaceNull(_this.report.o3)+"μg/m³、"+
                _this.replaceNull(_this.report.co)+"mg/m³。";
            Vue.set(_this.report,"text1",text1);
        },
        //拼接text2
        getText2:function(){
            var _this = this;
            var text2=_this.getYear(_this.report.reportTime).substring(0,4)+"年(1月1日至"+_this.geMonthDay(_this.report.endTime)+
                "），中心城区空气质量为"+_this.replaceNull(_this.report.txtynum2)+"天优，"+_this.replaceNull(_this.report.txtlnum2)+"天良，"+_this.replaceNull(_this.report.txtqdnum2)+"天轻度污染，"+
                _this.report.txtzdnum2+"天中度污染，优良率"+_this.report.txtthisyear2+"%，与去年相比，优良天数"+_this.report.isAdd+_this.report.addNum+
                "天。PM₁₀、PM₂.₅平均浓度分别为"+_this.replaceNull(_this.report.txtpm252)+"μg/m³和"+_this.replaceNull(_this.report.txtpm102)+"μg/m³，较去年同期分别"+
                _this.replaceNull(_this.report.isaddpm25)+_this.replaceNull(_this.report.ratepm25)+"%、"+_this.replaceNull(_this.report.ratepm10)+"%。(注： 数据未经国家复核，以国家最终下发数据为准)"
            Vue.set(_this.report,"text2",text2);
        },
        //拼接text3
        getText3:function(){
            var _this = this;
            var text3="本周"+_this.geMonthDay(_this.report.stratTime)+"-"+_this.geMonthDay(_this.report.endTime)+"，除停电无数据外，设备均运行正常，数据有效性"+
                _this.replaceNull(_this.report.datavalidity) + "%以上，期间设备数据有效率详见附表。";
            Vue.set(_this.report,"text3",text3);
        },
        //拼接text4
        getText4:function(){
            var _this = this;
            var text4="根据实验室监测结果，观测期间 PM₂.₅ 平均浓度为"+_this.replaceNull(_this.report.spm25)+"μg/m³，其中有机质、地壳元素、硝酸根、硫酸根和铵根离子浓度分别为"+
                _this.replaceNull(_this.report.yjz)+"μg/m³、"+_this.replaceNull(_this.report.dqys)+"μg/m³、"+_this.replaceNull(_this.report.xsg)+"μg/m³、"+_this.replaceNull(_this.report.lsg)+"μg/m³、"+_this.replaceNull(_this.report.aglz)+
                "μg/m³；总挥发性有机污染物（PAMS56）浓度为"+_this.replaceNull(_this.report.pams56)+"μg/m³，详见表 1。";
            Vue.set(_this.report,"text4",text4);
        },
        //拼接text5
        getText5:function(){

            var _this = this;
            var text5="本周（"+_this.geMonthDay(_this.report.stratTime)+"-"+_this.geMonthDay(_this.report.endTime)+"）气温升高，我市空气质量为"+
                _this.replaceNull(_this.report.ynum)+'天优'+'、'+  _this.replaceNull(_this.report.lnum)+'天良'+'、'+ _this.replaceNull(_this.report.qdnum)+'天轻度污染'+'、'+  _this.replaceNull(_this.report.zdnum)+'天中度污染'+
                '、'+ _this.replaceNull(_this.report.zzdnum)+'天重度污染'+'、'+ _this.replaceNull(_this.report.yznum)+'天严重污染'+'，首要污染物为'+'(PM₂.₅：'+_this.replaceNull(_this.report.numpm25)+'天)'+'(PM₁₀：'+_this.replaceNull(_this.report.numpm10)+'天)'+
                '(SO₂：'+_this.replaceNull(_this.report.numso2)+'天)'+'(O₃：'+_this.replaceNull(_this.report.numo3)+'天)'+'(NO₂：'+_this.replaceNull(_this.report.numno2)+'天)'+'(CO：'+_this.replaceNull(_this.report.numco)+'天)'+
                "：前期（"+_this.geMonthDay(_this.report.stratTime)+"-"+_this.geMonthDay(_this.report.earlyTime)+")"+_this.replaceNull(_this.report.earlyText)+
                "。后期（"+_this.geMonthDay(_this.report.laterTime)+"-"+_this.geMonthDay(_this.report.endTime)+")"+_this.replaceNull(_this.report.laterText);
            Vue.set(_this.report,"text5",text5);
            /*    if(_this.report.ynum > 0){
                    _this.report.text5= _this.report.text5 + _this.report.ynum+' 天优';
                }
                if(_this.report.lnum > 0){
                    _this.report.text5= _this.report.text5 + '、'+  _this.report.lnum+' 天良';
                }*/
            /*_this.report.lnum > 0?'、'+  _this.report.lnum+' 天良':''+ _this.report.qdnum > 0? '、'+ _this.report.qdnum+' 天轻度污染':''+'、'+
         _this.report.zdnum > 0?'、'+  _this.report.zdnum+' 天中度污染':''+_this.report.zzdnum > 0? '、'+ _this.report.zzdnum+' 天重度污染':''+
         _this.report.yznum > 0? '、'+ _this.report.yznum+' 天严重污染':''+'，首要污染物为'+_this.report.numpm25>0?'(PM₂.₅'+_this.report.numpm25+'天)':''+
         _this.report.numpm10>0?'(PM₁₀'+_this.report.numpm10+'天)':''+ _this.report.numso2>0?'(SO₂'+_this.report.numso2+'天)':''+
         _this.report.numo3>0?'(O₃'+_this.report.numo3+'天)':''+ _this.report.numno2>0?'(NO₂'+_this.report.numno2+'天)':''+*/

        },
        //拼接text6
        getText6:function(){
            var _this = this;
            var text6="前期（"+_this.replaceNull(_this.report.earlyTextSd)+"时段）（"+_this.geMonthDay(_this.report.stratTime)+"-"+_this.geMonthDay(_this.report.earlyTime)+" )：天气"+_this.replaceNull(_this.report.earlyWaether)+"，边界层高度维持在"+
            _this.replaceNull(_this.report.earlyHeightStart)+"-"+_this.replaceNull(_this.report.earlyHeightEnd)+"米之间，空气湿度"+_this.replaceNull(_this.report.earlyHumidity)+"%，二次颗粒物转化速率"+_this.replaceNull(_this.report.earlyTransformRate)+"（NOR为"+
                _this.replaceNull(_this.report.enor)+ "，SOR为"+_this.replaceNull(_this.report.esor)+"），二次无机组分占比"+_this.replaceNull(_this.report.earlyProportion)+"（"+_this.replaceNull(_this.report.earlyProportionRate)+" %），前体物活性"+_this.replaceNull(_this.report.earlyActivity)+"（0-10 时VOCs 的平均OFP为"+
                _this.replaceNull(_this.report.eofp)+"μg/m³）。"+_this.replaceNull(_this.report.earlySummary);
            Vue.set(_this.report,"text6",text6);
        },
        //拼接text7
        getText7:function(){
            var _this = this;
            var text7="后期（"+_this.replaceNull(_this.report.laterTextSd)+"时段）（"+_this.geMonthDay(_this.report.laterTime)+"-"+_this.geMonthDay(_this.report.endTime)+")：天气"+_this.replaceNull(_this.report.laterWaether)+"，边界层高度维持在"+
                _this.replaceNull(_this.report.laterHeightStart)+"-"+_this.replaceNull(_this.report.laterHeightEnd)+"米之间，空气湿度"+_this.replaceNull(_this.report.laterHumidity)+"%，二次颗粒物转化速率"+_this.replaceNull(_this.report.laterTransformRate)+"（NOR为"+
                _this.replaceNull(_this.report.nor)+ "，SOR为"+_this.replaceNull(_this.report.sor)+"），二次无机组分占比"+_this.replaceNull(_this.report.laterProportion)+"（"+_this.replaceNull(_this.report.laterProportionRate)+" %），前体物活性"+_this.replaceNull(_this.report.laterActivity)+"（0-10 时VOCs 的平均OFP为"+
                _this.replaceNull(_this.report.ofp)+"μg/m³）。"+_this.replaceNull(_this.report.laterSummary);
            Vue.set(_this.report,"text7",text7);
        },
        //拼接text8
        getText8:function(){
            var _this = this;
            var text8=  "本周我市空气质量为"+_this.replaceNull(_this.report.ynum)+"天优，"+_this.replaceNull(_this.report.lnum)+" 天良，"+_this.replaceNull(_this.report.qdnum)+"天轻度污染、"+
                _this.replaceNull(_this.report.zdnum)+"天中度污染、"+_this.replaceNull(_this.report.zzdnum)+"天重度污染、"+_this.replaceNull(_this.report.yznum)+"天严重污染，本周前期"+_this.replaceNull(_this.report.weekEarlyText)+"。周后期，"+_this.replaceNull(_this.report.weekLaterText)+"。建议"+ _this.replaceNull(_this.report.advAdvise);
            Vue.set(_this.report,"text8",text8);
        },
        replaceNull:function(str){
            if(str == null || str == undefined ){
                return '--';
            }
            return str;
        },
        /**
         * 将yyyy-MM-dd转成 MM月dd日
         * @param str
         * @returns {string}
         */
        geMonthDay(str){
            if(str != null && str != undefined && str != ""){
                return str.substring(5,7)+'月'+str.substring(8,10)+'日'
            }else{
                return '--';
            }

        },
        /**
         * 获取上午五到这周四的日期
         * @param dateStr
         */
        getStartEndTime(dateStr){
            var _this = this;
            var date = eval('new Date(' + dateStr.replace(/\d+(?=-[^-]+$)/,
                function(a) {
                    return parseInt(a, 10) - 1;
                }).match(/\d+/g) + ')');
            yesterday = +date - (1000*60*60*24);
            lastWeek = +date - (1000*60*60*24*7);
            lastWeek = new Date(lastWeek);
            yesterday = new Date(yesterday);
            _this.report.endTime = yesterday.getFullYear() + "-" + (DateTimeUtil.beforeCompleZero(yesterday.getMonth()+1)) +
                "-" + DateTimeUtil.beforeCompleZero(yesterday.getDate());
            _this.report.stratTime = lastWeek.getFullYear() + "-" + (DateTimeUtil.beforeCompleZero(lastWeek.getMonth()+1)) +
                "-" + DateTimeUtil.beforeCompleZero(lastWeek.getDate()) ;
            _this.endTime = yesterday.getFullYear() + "-" + (DateTimeUtil.beforeCompleZero(yesterday.getMonth()+1)) +
                "-" + DateTimeUtil.beforeCompleZero(yesterday.getDate());
            _this.stratTime = lastWeek.getFullYear() + "-" + (DateTimeUtil.beforeCompleZero(lastWeek.getMonth()+1)) +
                "-" + DateTimeUtil.beforeCompleZero(lastWeek.getDate()) ;
        },
        /**
         * 截取时间的前4未
         * @param str
         * @returns {string}
         */
        getYear:function(str){
            if(str != null && str != undefined && str != ""){
                return str.substring(0,4);
            }else{
                return '--';
            }
        },
        noData:function(){
            var _this = this;
            var a = _this.report.reportTime;
            _this.report = {};
            _this.report.reportTime=a;
            _this.report.stratTime=_this.stratTime;
            _this.report.endTime=_this.endTime;
        },



        getUuid: function () {
            var _this = this;
            AjaxUtil.sendAjaxRequest(_this.urls.getUuidUrl, null, null, function (json) {
                _this.report.reportId = json.data;
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
         * 保存
         */
        saveData: function (state) {
            var _this = this;
            for(var i = 0;i<_this.tableList.length;i++){
                _this.tableList[i]["reportId"] =  _this.report.reportId;
            }
            var flag = $('#mainForm').validationEngine('validate');
            if (!flag) {
                return;
            }
            _this.report.ascriptionType= _this.ascriptionType;
            var tipMessage = _this.getSaveTipMessage(state);
            DialogUtil.showConfirmDialog(tipMessage.confirmMessage, function () {
                _this.report.state = state;
                $.ajax({
                    url :_this.urls.saveWeekReportAttach2,
                    type : 'POST',
                    data : JSON.stringify(_this.tableList),
                    dataType:"json",
                    contentType : 'application/json;charset=utf-8', //设置请求头信息
                    success : function(response) {
                        AjaxUtil.sendPostAjaxRequest(_this.urls.saveWeekReport, _this.report, function () {
                            DialogUtil.showTipDialog(tipMessage.successMessage, function () {
                                _this.cancel(true);
                            }, function () {
                                _this.cancel(true);
                            });
                        })
                    }
                })

            });
        },
        /**
         * 日期选择插件
         */
        wdatePicker1: function () {
            var _this = this;
            WdatePicker({
                // 回显数据的对象ID
                el: 'txtDate',
                //不能选择的周几
                disabledDays: [0, 1,2,3, 4, 6,7],
                // 时间格式
                dateFmt: 'yyyy-MM-dd',
                // 是否显示清除按钮
                isShowClear: false,
                // 是否显示今天按钮
                isShowToday: false,
                // 只读
                readOnly: true,
                // 限制最大时间
                //maxDate: '%y-%M-%d',
                onpicked: function (dp) {
                    // 防止重复点击当月
                    var yearMonthDay = dp.cal.getNewDateStr();
                    if (yearMonthDay === _this.report.reportTime) {
                        return;
                    }
                    _this.report.reportTime = yearMonthDay;
                    _this.getStartEndTime(yearMonthDay)
                    AjaxUtil.sendAjaxRequest(_this.urls.queryStateNumber, null, {
                        ascriptionType: _this.ascriptionType,
                        reportTime: _this.report.reportTime
                    }, function (json) {
                        if (json.data.STATE_NUMBER == 0) {
                            _this.initReportData();
                        } else {
                            DialogUtil.showTipDialog(_this.report.reportTime + "数据已提交，请重新选择填报日期！");
                            _this.noData();
                            _this.getUuid();
                        }
                    });
                }
            });
        },
        earlyTimeClick: function () {
            var _this = this;
            WdatePicker({
                // 回显数据的对象ID
                el: 'earlyTime',
                // 时间格式
                dateFmt: 'yyyy-MM-dd',
                // 只读
                readOnly: true,
                // 限制最大时间
                maxDate: '%y-%M-%d',
                onpicked: function (dp) {
                    // 防止重复点击当月
                    Vue.set(_this.report,"earlyTime",dp.cal.getNewDateStr());
                    //_this.report.earlyTime = dp.cal.getNewDateStr();
                }
            });
        },
        laterTimeClick:function(){
            var _this = this;
            WdatePicker({
                // 回显数据的对象ID
                el: 'laterTime',
                // 时间格式
                dateFmt: 'yyyy-MM-dd',
                // 只读
                readOnly: true,
                // 限制最大时间
                maxDate: '%y-%M-%d',
                onpicked: function (dp) {
                    // 防止重复点击当月
                    Vue.set(_this.report,"laterTime",dp.cal.getNewDateStr());
                   // _this.report.laterTime = dp.cal.getNewDateStr();
                }
            });
        },
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
        },
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
        },
        /**
         * 获取报告频度
         */
        getReportFrequency: function (reportTime) {
            return parseInt(reportTime.split("-")[2]);
        },

    }
});
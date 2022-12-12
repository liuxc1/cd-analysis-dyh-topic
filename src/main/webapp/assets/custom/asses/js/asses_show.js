var asses_show = new Vue({
    el: '#main-container',
    data: {
        url: {
            getScenebyAssessId: ctx + '/asses/getScenebyAssessId.vm',
            getProperties: ctx + '/asses/getProperties.vm',
        },
        date:date,
        cjList:[],
        sceneDivList:[],
        wrfImagePth:'',
        //2:后评估 1:预评估
        type:type

    },
    /**
     * 页面加载完后调用
     */
    mounted: function () {
        this.getScenebyAssessId();
        //player.reset([]).showNext();

    },
   
    methods: {
        /**
         * 查询echarts所需要的数据
         */
        getScenebyAssessId:function(){
            let _this = this;
            AjaxUtil.sendAjaxRequest(_this.url.getScenebyAssessId, null,{
                assessId:pkid
            },function (json) {
                //默认选中前两个
                if(json.data != null && json.data.length > 0 && json.data.length >=2){
                    for (let i = 0; i < 2 ; i++) {
                        json.data[i].info.checked = true;
                    }
                }else if(json.data != null && json.data.length > 0 && json.data.length < 2){
                    json.data[0].info.checked = true;
                }
                _this.cjList=json.data;
                _this.initChecked();

            },function(json){
                console.log(json);
            });
        },
        /**
         * 根据选择初始化污染物减排TAB页的echarts
         */
        initChecked:function(){
            let _this = this;
            _this.sceneDivList=[];
            for(var i=0;i<_this.cjList.length;i++){
                if(_this.cjList[i].info.checked){
                    _this.sceneDivList.push({
                        "id1":"sceneDiv"+_this.cjList[i].info.sceneId+"1",
                        "id2":"sceneDiv"+_this.cjList[i].info.sceneId+"2",
                        "id3":"sceneDiv"+_this.cjList[i].info.sceneId+"3",
                        "id4":"sceneDiv"+_this.cjList[i].info.sceneId+"4",
                        "name":_this.cjList[i].info.sceneName,
                    });
                }
            }
            _this.$nextTick(() => {
                //根据当前选择的情况重新初始化对应的tab页面
               var a = $(".tab-content .active").attr('id');
                var height = document.documentElement.clientHeight;//获取客户端高度
                console.log(height)
                $(".echartsHeight").css("height",height*0.3+ 'px');
                for(var i=0;i<_this.cjList.length;i++){
                    if(_this.cjList[i].info.checked){
                        if(a == 'zj-assess1'){
                            _this.initEcharts(_this.cjList[i]);
                            _this.initEcharts2(_this.cjList[i]);
                        }else if(a == 'zj-assess2'){
                            _this.initEcharts3(_this.cjList[i]);
                        }else if(a == 'zj-assess3'){
                            _this.init();
                        }
                    }
                }
            })
        },
        /**
         * 切换窗口到第二个tab页
         */
        exchangeTab2:function(){
            let _this =this;
            setTimeout(function () {
                $(window).trigger("resize");
                _this.checkList2();
            }, 500);
        },
        /**
         * 切换窗口到第以个tab页
         */
        exchangeTab1:function(){
            let _this =this;
            setTimeout(function () {
                $(window).trigger("resize");
                for (var i = 0; i < _this.cjList.length; i++) {
                    if (_this.cjList[i].info.checked) {
                        _this.initEcharts(_this.cjList[i]);
                        _this.initEcharts2(_this.cjList[i]);
                    }
                }
            }, 500);
        },
        /**
         * 切换窗口到第三个tab页
         */
        exchangeTabWrfb:function(){
            let _this =this;
            AjaxUtil.sendAjaxRequest(_this.url.getProperties, null,{
                a:"wrfUrl"
            },function (json) {
                _this.wrfImagePth= json.data
            },function(json){
                console.log(json);
            });
            _this.$nextTick(() => {
                setTimeout(function () {
                    $(window).trigger("resize");
                    _this.init();
                }, 500);
            });
        },
        /**
         * 根据选择的场景渲染污染物消减清空
         */
        checkList2:function(){
            let _this =this;
            for (var i = 0; i < _this.cjList.length; i++) {
                if (_this.cjList[i].info.checked) {
                    _this.initEcharts3(_this.cjList[i]);
                }
            }
        },
        /***************************第一个tab页数据开始*************************************/
        /**
         * 初始化污染物减排左侧echarts
         * @param data
         */
        initEcharts:function(data){
            let _this =this;
            var xdata=["PM₁₀","PM₂.₅","SO₂","NOₓ","VOCₛ","PM₁₀","PM₂.₅","SO₂","NOₓ","VOCₛ","PM₁₀","PM₂.₅","SO₂","NOₓ","VOCₛ"];
            var series = [];
            var types = ["建筑扬程减排","工业减排","机动车减排","其他减排","全社会减排"]
            for (let i = 0; i < types.length; i++) {
                series.push({
                    name: types[i],
                    type: 'bar',
                    barWidth : 40  ,
                    stack: '堆叠',
                    data: _this.getOnetypeData(data,types[i],1)
                })
            }
            series.push({
                name:'竖线',
                type:'bar',
                markLine:{
                    symbol: "none",
                    itemStyle:{
                        normal:{
                            label:{
                                formatter:'',
                            }
                        },
                    },
                    data: [{
                        silent: false,
                        lineStyle: {
                            type: "solid",
                            color: "#6E7079"
                        },
                        xAxis: 4,
                    }]
                }
            })
            series.push({
                name:'竖线',
                type:'bar',
                markLine:{
                    symbol: "none",
                    itemStyle:{
                        normal:{
                            label:{
                                formatter:'',
                            }
                        },
                    },
                    data: [{
                        silent: false,
                        lineStyle: {
                            type: "solid",
                            color: "#6E7079"
                        },
                        xAxis: 9
                    }]
                }
            })
            option = {
                title:{
                    text: _this.date+"预警管控减排量",
                    left: 'center',
                    top: 0,
                },
                tooltip: {
                    trigger: 'axis',
                    axisPointer: {            // 坐标轴指示器，坐标轴触发有效
                        type: 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                    }
                },
                legend: {
                    data: types,
                    top: '10%'
                },
                toolbox: {
                    right:5,
                    feature: {
                        saveAsImage: {show: true,title:'保存'}
                    }
                },
                grid: {
                    left: '3%',
                    right: '4%',
                    bottom: '8%',
                },
                xAxis:[
                    {
                        type: 'category',
                        data: xdata,
                        offset:-1,
                    }
                ],
                yAxis: [{
                    type: 'value',
                    name:'吨',
                    show:true,
                    axisLine: {show:true},
                    offset: -6,
                     },
                ],
                series:series
            };
            var myChart = echarts.init(document.getElementById("sceneDiv"+data.info.sceneId+"1"));
            myChart.setOption(option);
        },
        /**
         * 拼接污染物减排左侧echarts的数据,根据
         * @param data
         * @param emissionName
         * @param emissionCompanyType
         * @returns {[]}
         */
        getOnetypeData:function(data,emissionName,emissionCompanyType   ){
            var yData =[];
            for (let i = 0; i <data.list.length ; i++) {
                if (data.list[i].emissionName == emissionName && data.list[i].emissionCompanyType == emissionCompanyType && data.list[i].alertLevel == 'yellow') {
                    yData.push(data.list[i].pm10);
                    yData.push(data.list[i].pm25);
                    yData.push(data.list[i].so2);
                    yData.push(data.list[i].nox);
                    yData.push(data.list[i].vocs);
                }
            }
            for (let i = 0; i <data.list.length ; i++) {
                if (data.list[i].emissionName == emissionName && data.list[i].emissionCompanyType == emissionCompanyType && data.list[i].alertLevel == 'orange') {
                    yData.push(data.list[i].pm10);
                    yData.push(data.list[i].pm25);
                    yData.push(data.list[i].so2);
                    yData.push(data.list[i].nox);
                    yData.push(data.list[i].vocs);
                }
            }
            for (let i = 0; i <data.list.length ; i++) {
                if(data.list[i].emissionName == emissionName && data.list[i].emissionCompanyType == emissionCompanyType &&  data.list[i].alertLevel =='red'){
                    yData.push(data.list[i].pm10);
                    yData.push(data.list[i].pm25);
                    yData.push(data.list[i].so2);
                    yData.push(data.list[i].nox);
                    yData.push(data.list[i].vocs);
                }
            }
            return yData;
        },

        /**
         * 拼接污染物减排右侧echarts
         * @param data
         */
        initEcharts2:function(data,emissionCompanyType){
            let _this =this;
            var xdata=["PM₁₀","PM₂.₅","SO₂","NOₓ","VOCₛ"];
            var types = ["黄色预警","橙色预警","红色预警"];
            var color = ["#F2E021","#f59a23","#dc1f36"];
            var series = [];
            var max = 0;
            for( let i =0;i<data.list2.length;i++){
                var ydata=[];
                ydata.push(data.list2[i].RATEPM10==0?null:data.list2[i].RATEPM10);
                ydata.push(data.list2[i].RATEPM25==0?null:data.list2[i].RATEPM25);
                ydata.push(data.list2[i].RATESO2==0?null:data.list2[i].RATESO2);
                ydata.push(data.list2[i].RATENOX==0?null:data.list2[i].RATENOX);
                ydata.push(data.list2[i].RATEVOCS==0?null:data.list2[i].RATEVOCS);
                series.push({
                    name: types[i],
                    type: 'bar',
                    xAxisIndex: i,
                    yAxisIndex: i,
                    color:color[i],
                    data: ydata,
                    itemStyle: {        //上方显示数值
                        normal: {
                            label: {
                                show: true, //开启显示
                                position: 'top', //在上方显示
                                textStyle: { //数值样式
                                    color: 'black',
                                    fontSize: 16
                                }
                            }
                        }
                    }
                })
                 max =  Math.max.apply(null,ydata) > max ? Math.max.apply(null,ydata): max;
            }
            max=Math.round(max*1.5);
            if (max==0 || max>100){
                max=100;
            }
            option = {
                title:{
                    text: _this.date+"预警管控减排比",
                    left: 'center',
                    top: 0,
                },
                tooltip: {
                    trigger: 'axis'
                },
                toolbox: {
                    right:5,
                    feature: {
                        saveAsImage: {show: true,title:'保存'}
                    }
                },
                //图例格式
                legend: {
                    top:'10%'
                },
                //两个不同的布局
                grid: [{
                    left: 50,
                    right: 50,
                    width:"30%",
                    bottom: '8%',
                }, {
                    left:  '36%',
                    right: 50,
                    width:"30%",
                    bottom: '8%',
                },{
                    left:  '66%',
                    right: 50,
                    width:"30%",
                    bottom: '8%',
                }],
                //x轴
                xAxis: [
                    //第一个x轴配置
                    {
                        type: 'category',
                        data:xdata,
                        axisPointer: {
                            type: 'shadow'
                        },
                        axisTick: { show: false }
                    },
                    //第二个x轴配置
                    {
                        //定义使用的grid布局
                        gridIndex: 1,
                        type: 'category',
                        axisPointer: {
                            type: 'shadow'
                        },
                        //设置x轴位置在图表上方
                        data:xdata,
                        axisTick: { show: false }
                    },{
                        //定义使用的grid布局
                        gridIndex: 2,
                        type: 'category',
                        axisPointer: {
                            type: 'shadow'
                        },
                        //设置x轴位置在图表上方
                        data:xdata,
                        axisTick: { show: false }
                    }
                ],
                //y轴
                yAxis: [
                    //第一个y轴配置
                    {
                        name:'%',
                        type: 'value',
                        min: 0,
                        max: max,
                        axisLine: {show:true},
                    },
                    //第二个y轴配置
                    {
                        //同x轴使用第二个grid
                        gridIndex: 1,
                        type: 'value',
                        min: 0,
                        max: max,
                        axisLine: {show:false},
                        axisLabel : {
                            formatter: function(){
                                return "";
                            }
                        }
                    }, {
                        //同x轴使用第三个grid
                        gridIndex: 2,
                        type: 'value',
                        min: 0,
                        max: max,
                        axisLine: {show:false},
                        axisLabel : {
                            formatter: function(){
                                return "";
                            }
                        }

                    }
                ],
                series: series
            };
            var myChart2 = echarts.init(document.getElementById("sceneDiv"+data.info.sceneId+"2"));
            myChart2.setOption(option);
        },
        /***************************第一个tab页数据结束*************************************/
        /***************************第二个tab页数据开始*************************************/
        /**
         *
         * 拼接第二个tab页的echarts数据
         * @param data
         * @param emissionCompanyType
         * @param returnType
         * @returns {[]}
         */
        getTwoData:function(data,emissionCompanyType,returnType) {
            var barArr = [];
            var bar = [];
            for(var i=0;i<data.list.length;i++){
                if (data.list[i].emissionBigType == 2 &&  data.list[i].alertLevel == 'yellow' && data.list[i].emissionCompanyType == emissionCompanyType) {
                    bar.push(data.list[i].pm10);
                    bar.push(data.list[i].pm25);
                    bar.push(data.list[i].nox);
                }
            }
            if(returnType == 'barArr'){
                for(var j=0;j<6;j++){
                    bar.push(0);
                }
            }
            barArr.push(bar);
            if(returnType == 'barArr'){
                bar = [];
                for(var j=0;j<3;j++){
                    bar.push(0);
                }
            }
            for(var i=0;i<data.list.length;i++){
                if (data.list[i].emissionBigType == 2 &&  data.list[i].alertLevel == 'orange' && data.list[i].emissionCompanyType == emissionCompanyType) {
                    bar.push(data.list[i].pm10);
                    bar.push(data.list[i].pm25);
                    bar.push(data.list[i].nox);
                }
            }
            if(returnType == 'barArr'){
                for(var j=0;j<3;j++){
                    bar.push(0);
                }
            }
            barArr.push(bar);
            if(returnType == 'barArr'){
                bar = [];
                for(var j=0;j<6;j++){
                    bar.push(0);
                }
            }
            for(var i=0;i<data.list.length;i++){
                if (data.list[i].emissionBigType == 2 &&  data.list[i].alertLevel == 'red' && data.list[i].emissionCompanyType == emissionCompanyType) {
                    bar.push(data.list[i].pm10);
                    bar.push(data.list[i].pm25);
                    bar.push(data.list[i].nox);
                }
            }
            barArr.push(bar);
            if(returnType == 'barArr'){
                return barArr;
            }else{
                return bar;
            }
        },

        /**
         * 初始化第二个tab也数据（污染物消减）
         * @param data
         */
        initEcharts3:function(data){
            let _this = this;
            var bar = _this.getTwoData(data,1,'barArr');
            var line = _this.getTwoData(data,2,'bar');
            var xData=["PM₁₀","PM₂.₅","NO₂","PM₁₀","PM₂.₅","NO₂","PM₁₀","PM₂.₅","NO₂"];
            var color = ["#F2E021","#f59a23","#dc1f36","#84baf6"];
            var types = ["黄色预警","橙色预警","红色预警"];
            var series = [];
            var max = 0;
            for (let i = 0; i <xData.length ; i++) {
                series.push({
                    name: types[i],
                    type: 'bar',
                    color:color[i],
                    data: bar[i],
                    stack: 'd',
                    /*itemStyle: {        //上方显示数值
                        normal: {
                            label: {
                                show: true, //开启显示
                                position: 'top', //在上方显示
                                textStyle: { //数值样式
                                    color: 'black',
                                    fontSize: 16
                                }
                            }
                        }
                    }*/
                })
                max =  Math.max.apply(null,bar[i]) > max ? Math.max.apply(null,bar[i]): max;
            }

            series.push({
                name: "消减比例",
                type: 'line',
                data: line,
                color:color[3],
                yAxisIndex:1,
                itemStyle: {        //上方显示数值
                    normal: {
                        label: {
                            show: true, //开启显示
                            position: 'top', //在上方显示
                            textStyle: { //数值样式
                                color: 'black',
                                fontSize: 16
                            }
                        }
                    }
                }
            })
            option = {
                title:{
                    text: _this.date+'预警管控消减浓度',
                    left: 'center',
                    top: 0
                },
                tooltip: {
                    trigger: 'axis',
                    formatter:function(param){
                        var temp=  param[0].name+"<br>";
                        for(var i=0;i<param.length;i++){
                            if(param[i].value > 0){
                                temp += param[i].seriesName+":"+param[i].value+"<br>"
                            }
                        }
                        return temp;
                    },
                },
                toolbox: {
                    right:5,
                    feature: {
                        saveAsImage: {show: true,title:'保存'}
                    }
                },
                //图例格式
                legend: {
                    top: '10%'
                },
                //两个不同的布局
                grid: [{
                    left: "5%",
                    right: "5%",
                    width:"90%",
                    bottom: '8%',
                }],
                //x轴
                xAxis: [
                    //第一个x轴配置
                    {
                        type: 'category',
                        data:xData,
                        axisPointer: {
                            type: 'shadow'
                        },
                        axisTick: { show: false }
                    },

                ],
                //y轴
                yAxis: [
                    //第一个y轴配置
                    {
                        name:'消减浓度（ug/m³）',
                        type: 'value',
                        axisLine: {show:true},
                    },
                    {
                        name:'消减比例%',
                        type: 'value',
                        axisLine: {show:true},
                    },
                ],
                series: series
            };
            var myChart3 = echarts.init(document.getElementById("sceneDiv"+data.info.sceneId+"3"));
            myChart3.setOption(option);
        },
        /***************************第二个tab页数据结束*************************************/
        /****************************图片加载以及初始化开始*************************************/
        //
        resize: function () {
            var height = document.documentElement.clientHeight;//获取客户端高度
            $(".picHeight").css("height",height*0.5+ 'px');
        },
        getLocationSearchByName: function (name) {
            var search = decodeURIComponent(window.location.search.substring(1));
            var param = {};
            arr = search.split("&");
            var i, key_value;
            for (i = 0; i < arr.length; i++) {
                key_value = arr[i].split("=");
                param[key_value[0]] = key_value[1];
            }
            return param[name] || null;
        },
        getImgsAndPlay: function () {
            var self = this;
            var list = [];
            var listTimes = [];
            var dateTypes = $('input[name="dateTypes"]:checked').val();
            var types = $('input[name="types"]:checked').val();
            types=types=='o3'?'o3m':types;
            var dateTimeArr=date.split("~");
            var startDate = dateTimeArr[0];
            //dateTime = startDate;
            var endDate = dateTimeArr[1]
            var length = this.datedifference(startDate,endDate);
            var j = 1;
            for (var i = 1; i < length+1; i++) {
                //var dds = this.addDate(startDate, j);
                //listTimes = this.setDayParameters(listTimes, dds, i);
                j++;
                var temp = {};
                // temp.name = listTimes[i - 1];
                temp.name = "第"+i+"天";
                for (var k = 0; k < this.cjList.length; k++){
                    let day = i;
                    if (i>8){
                        day=i%8+1;
                    }
                    day='0'+day;
                    //预评估
                    if (this.type==1){
                        temp["urlBase"] = self.wrfImagePth +'assess/'+dateTypes+ "/before/base/" + 'CMAQ_daily_'+types + '_day'+ day + ".png";
                        temp["urlCase"] = self.wrfImagePth +'assess/'+ dateTypes+ "/before/case/" + 'CMAQ_daily_'+types + '_day'+day + ".png";
                    }else{
                        temp["urlBase"] = self.wrfImagePth +'assess/' + dateTypes+ "/after/base/" + 'CMAQ_daily_'+types + '_day'+day + ".png";
                        temp["urlCase"] = self.wrfImagePth +'assess/' + dateTypes+ "/after/case/" + 'CMAQ_daily_'+types + '_day'+day + ".png";
                        }
                }
                list.push(temp);
            }
            console.log("-----------图片地址------------");
            console.log(list);
            player2.reset(list,self.cjList).showNext();
        },
        //时间加几天
        addDate:function (date, days) {
            var d = new Date(date);
            d.setDate(d.getDate() + days);
            var month = d.getMonth() + 1;
            var day = d.getDate();
            if (month < 10) {
                month = "0" + month;
            }
            if (day < 10) {
                day = "0" + day;
            }
            var val = d.getFullYear() + "" + month + "" + day;
            return val;
        },
        datedifference:function(sDate1, sDate2) {    //sDate1和sDate2是2006-12-18格式
            var dateSpan,
                tempDate,
                iDays;
            sDate1 = Date.parse(sDate1);
            sDate2 = Date.parse(sDate2);
            dateSpan = sDate2 - sDate1;
            dateSpan = Math.abs(dateSpan);
            iDays = Math.floor(dateSpan / (24 * 3600 * 1000));
            return iDays
        },
        setDayParameters: function (listTimes, dds, i) {
            listTimes[i - 1] = dds;
            return listTimes;
        },
        addEventListener: function () {
            var self = this;
            $(document.body).on("click", ".isButton", function (e) {
                var oper = this.getAttribute("data-oper");
                if (oper == "search") {
                    self.getImgsAndPlay();
                }
            });
        },
        formatDate: function (obj, pattern) {
            var date;
            if (obj.constructor === Date) {
                date = obj;
            } else if (typeof obj === "number") {
                date = new Date(obj);
            } else {
                return false;
            }
            var y = date.getFullYear();
            var m = date.getMonth() + 1;
            m = m > 9 ? m : ('0' + m);
            var d = date.getDate();
            d = d > 9 ? d : ('0' + d);
            var h = date.getHours();
            h = h > 9 ? h : ('0' + h);
            var str = '';
            pattern = pattern || 'yyyy-mm-dd';
            return pattern.toLowerCase().replace("yyyy", y).replace("mm", m).replace("dd", d).replace("hh", h);
        },

        getYesterday: function (obj) {
            var date = new Date(), dateArr;
            if (!obj) {
            } else if (typeof obj == "string") {
                dateArr = obj.split(" ")[0].split("-");
                date.setDate(+dateArr[0]);
                date.setMonth(+dateArr[1] - 1);
                date.setDate(+dateArr[2]);
            } else if (typeof obj == "number") {
                date.setDate(obj);
            } else if (date.constructor === Date) {
                date = obj;
            }
            date = new Date(date.getTime() - 8.64e7);
            return date;
        },

        init: function () {
            player2.init(this.cjList);
            this.resize();
            this.getImgsAndPlay();
            this.addEventListener();
        },
        /****************************图片加载以及初始化结束*************************************/

        cancel:function(isParentRefresh){
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
    }
});





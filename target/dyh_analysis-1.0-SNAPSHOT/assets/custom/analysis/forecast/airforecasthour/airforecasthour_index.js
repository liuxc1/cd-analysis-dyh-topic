var defaultCheak = ["CAMX","shishi"];
var vue = new Vue({
    el: '#main-container',
    data: {
    	timeAxis: {
			prev: {
				limit: '',
				title: '上一月',
				isShow: true
			},
			next: {
				limit: '',
				title: '下一月',
				isShow: true
			},
			list: null,
			tempList:null
		},
		month:'',
		thisDay:'',
    	tableList:[],
    	//所有预报类型和用户
    	forecastTypeAndUser:[],
    	//选中的预报类型和用户
    	cheakForecastTypeAndUser:[],
    	cheakForecastTypeAndUserName:[],
		userId:'',
		userName:'',
    	keyList:[],
		showAndEdit:'show',
		//是否新增
		isNew:false,
		//状态
		state:''

    	
    },
    /**
     * 页面加载完后调用
     */
    mounted: function () {
		// 注册表单验证
		$('#mainForm').validationEngine({
			// 屏幕自动滚动到第一个验证不通过的位置。必须设置，因为Toolbar position为Fixed
			scrollOffset: 98,
			// 提示框位置为下左
			promptPosition: 'bottomLeft',
			// 自动隐藏提示框
			autoHidePrompt: true,
			// 不可见字段验证
			validateNonVisibleFields: true
		});
		this.monthClick();
        this.getMaxDateAndUser();

    },
    methods: {
		/**
		 * 月份切换
		 * @param month
		 */
		monthClick: function (month) {
			var _this = this;
			AjaxUtil.sendAjaxRequest(ctx+'/analysis/forecastflow/AirForecastHour/getDayList.vm', null, {
				ascriptionType: _this.ascriptionType,
				month: month
			}, function (json) {
				var dataList = json.data;
				var data = dataList[0];
				// 填报月份
				_this.month = data.MODELTIME.substring(0, 7);
				// 当传递的月份为空时，重新赋予最大月份的值
				if (month == null) {
					_this.timeAxis.next.limit = _this.month;
				}
				var list = [];
				// 记录选中的索引
				var selectedIndex = -1;
				for (var i = 0; i < dataList.length; i++) {
					data = dataList[i];
					// 是否禁用。True:禁用，False:不禁用
					var disabled = data.IS_DISABLED != 'Y';
					// 如果有数据，则将当日标记为选中，直到选中有数据的最后一天
					if (data.IS_MAX_DATE=='Y') {
						selectedIndex = i;
					}
					list.push({
						key: data.MODELTIME,
						text: data.SHOW_TEXT,
						disabled: disabled,
						selected: false,
						isTip: data.IS_TIP === 'Y',
						hasData: data.IS_DATA === 'Y'
					});
				}
				// 选中有数据的最后一天
				if (selectedIndex >= 0) {
					list[selectedIndex].selected = true;
					_this.noDataText = null;
				} else {
					list[0].selected = true;
					list[0].disabled = false;
				}
				// 给时间轴赋值
				_this.timeAxis.list = list;
			});
		},

		/**
		 * 上一月
		 * @param prev
		 */
		prevClick:function(prev){
			var month = DateTimeUtil.addMonth(this.month, -1);
			this.monthClick(month);
		},
		/**
		 * 下一月
		 * @param next
		 */
		nextClick:function(next){
			var month = DateTimeUtil.addMonth(this.month, 1);
			this.monthClick(month);
		},
		/**
		 *时间日期切换
		 * @param data
		 */
		timeAxisListClick:function(data){
        	let _this=this;
			for(let i=0;i<this.timeAxis.list.length;i++){
				if(this.timeAxis.list[i].text == data.text){
					this.timeAxis.list[i].selected= true;
				}else{
					this.timeAxis.list[i].selected= false;
				}
			}
			_this.getForecastTypeAndUser()
			_this.getTableData();
		},
		/**
		 * 时间处理
		 * @param dateTime
		 * @returns {string}
		 */
		substringDate:function(dateTime){
        	return dateTime.substring(0,13);
		},
		/**
		 * 新增编辑
		 */
		add:function(){
			this.isNew=this.cheakForecastTypeAndUser.indexOf(this.userId)>-1?false:true;
			//新增
			if (this.isNew){
				for (let i = 0; i <this.tableList.length ; i++) {
					this.tableList[i][this.userId+'_pm25']=null;
					this.tableList[i][this.userId+'_o3']=null;
				}
			}
        	this.showAndEdit = this.userId;
        	this.timeAxis.tempList=JSON.parse(JSON.stringify(this.timeAxis.list));
			for (let i = 0; i < this.timeAxis.list.length; i++) {
				this.timeAxis.list[i].disabled = false;
			}
        },
		/**
		 * 返回到查看页面
		 */
		back:function(){
			this.showAndEdit = 'show';
			this.isNew=false;
			this.timeAxis.list=this.timeAxis.tempList;
		},
		/**
		 * 保存、提交修改
		 * @param isCommit 是否提交
		 */
		save:function(isCommit){
			let _this = this;
			// 通用表单验证
			if (!$('#mainForm').validationEngine('validate')) {
				return;
			}
			let type='保存';
			if (isCommit==1){
				type='提交';
			}
			_this.tableList[0].isCommit=isCommit;
			$.ajax({
				url: ctx + '/analysis/forecastflow/AirForecastHour/save.vm',
				isShowLoader: true,
				type: 'post',
				contentType : 'application/json;charset=utf-8', //设置请求头信息
				data: JSON.stringify(_this.tableList),
				dataType: 'json',
				success: function (resultData) {
					if (resultData.code==200){
						_this.showMessageDialog(type+'成功！');
					}else{
						_this.showMessageDialog(type+'失败！');
					}
					if (_this.isNew){
						_this.getForecastTypeAndUser();
					}else{
						_this.getTableData();
					}
					_this.back();
				},
				error: function () {
					_this.showMessageDialog('网络连接失败！');
				},
			});

		},
		/**
		 *组装取数据的key值
		 */
		userToKeyList:function(){
			keyList=[];
        	for(let i=0;i<this.forecastTypeAndUser.length;i++){
        		if(this.forecastTypeAndUser[i].checked){
        			var temp = {};
					temp.o3=this.forecastTypeAndUser[i].model+"_o3";
					temp.pm25=this.forecastTypeAndUser[i].model+"_pm25";
					temp.model=this.forecastTypeAndUser[i].model;
					temp.userName=this.forecastTypeAndUser[i].userName;
					keyList.push(temp);
				}
			}
        	this.keyList= keyList;
		},
		/**
		 * 点击用用户切换用户数据
		 */
        changeCheckBox:function () {
			setTimeout(function(){
				vue.userToKeyList();
				vue.getTableData();
			},10);
        },
		/**
		 * echarts屏接数据
		 * @param dataList
		 */
		initEchartsData:function(dataList){
        	var _this = this;
			var xList=[];
        	var o3yList=[];
        	var pm25List=[];
        	var hourList=[];
			for(let i = 0;i<_this.keyList.length;i++){
				let userO3 = [];
				let userPm25 = [];
				var tempseriesO3 = {};
				var tempseriesPm25 = {};
				hourList=[];
				for(let j = 0;j<dataList.length;j++){
					let tempO3 = _this.keyList[i].o3;
					let tempPm25 = _this.keyList[i].pm25;
					userO3.push(dataList[j][tempO3]);
					userPm25.push(dataList[j][tempPm25]);
					hourList.push(dataList[j].resultTime.substring(10,13));
				}
				tempseriesO3.data = userO3;
				tempseriesO3.name = _this.keyList[i].userName;
				tempseriesO3.type='line';
				o3yList.push(tempseriesO3);
				tempseriesPm25.data = userPm25;
				tempseriesPm25.name = _this.keyList[i].userName;
				tempseriesPm25.type='line';
				pm25List.push(tempseriesPm25);
				xList.push(_this.keyList[i].userName);
			}
			_this.initEcharts(hourList,o3yList,xList,'o3','成都市逐时O₃浓度预报结果与实况');
			_this.initEcharts(hourList,pm25List,xList,'pm25','成都市逐时PM₂.₅浓度预报结果与实况');
		},
		/**
		 * echarts
		 * @param xList 横坐标
		 * @param yList 纵坐标
		 * @param userList 图例
		 * @param id
		 */
		initEcharts:function(xList,yList,userList,id,title){
			var myChart = echarts.init(document.getElementById(id));
			option = {
				title: {
					left: 'center',
					text: title
				},
				toolbox: {
					right:15,
					feature: {
						saveAsImage: {show: true}
					}
				},
				tooltip: {
					trigger: 'axis'
				},
				legend: {
					data: userList,
					show: true,
					top:"10%",
				},
				grid: {
					left: '3%',
					right: '4%',
					containLabel: true
				},
				xAxis: {
					type: 'category',
					boundaryGap: false,
					data: xList
				},
				yAxis: {
					type: 'value',
					name:'μg/m³',
				},
				series:yList
			};
			myChart.setOption(option, true);
		},
		/**
		 * 返回当前年月日
		 * @returns {string}
		 */
		getThisMonthDay:function(){
			var _this= this;
			let thisMonthDay='';
			for( let i =0;i<_this.timeAxis.list.length;i++){
				if(_this.timeAxis.list[i].selected){
					thisMonthDay = _this.timeAxis.list[i].key
				}
			}
			if(thisMonthDay == null || thisMonthDay==''){
				return _this.month+'-01';
			}
			thisMonthDay = thisMonthDay.replace(/-/g, "/");
			var date = new Date(thisMonthDay);
			date = date.setDate(date.getDate()+1);
			thisMonthDay=DateTimeUtil.dateFormat('YYYY-mm-dd',date).substring(0,10);
			return thisMonthDay;
		},
        /**
         * 查询有哪些用户何预报类型
         */
        getForecastTypeAndUser:function(){
        	 var _this= this;
        	var modeltime = _this.getThisMonthDay();
        	 $.ajax({
                 url: ctx + '/analysis/forecastflow/AirForecastHour/getForecastTypeAndUser.vm',
                 isShowLoader: true,
                 type: 'post',
                // async: false,
                 data: {
                 	modeltime:modeltime,
				 },
                 dataType: 'json',
                 success: function (resultData) {
                	 if(resultData.code =='200'){
                		 _this.cheakDefaultForecastTypeAndUser(resultData.data);
                		 _this.getTableData();
                	 }else{
                		 _this.showMessageDialog('预报类型和人员查询失败！');
                	 }
                 },
                 error: function () {
                     _this.showMessageDialog('网络连接失败！');
                 },
             });
        },
		/**
		 * 默认展示的用户和预报类型
		 * @param userList
		 */
        cheakDefaultForecastTypeAndUser:function(userList){
        	var _this =this;

        	// if(!defaultCheak.includes(_this.userId)){
        	// 	defaultCheak.push(_this.userId);
        	// }
			let temp1 = {};
			temp1.model='shishi'
			temp1.userName='实况'
			userList.push(temp1);//实时数据
        	_this.keyList=[];
        	for (var i = 0; i < userList.length; i++) {
				// for (var j = 0; j < defaultCheak.length; j++) {
				// 	if(userList[i].model == defaultCheak[j]){
						userList[i].checked = true;
						_this.cheakForecastTypeAndUser.push(userList[i].model);
						_this.cheakForecastTypeAndUserName.push(userList[i].userName);
						var temp ={};
						temp.o3=userList[i].model+"_o3";
						temp.pm25=userList[i].model+"_pm25";
						temp.model=userList[i].model;
						temp.userName=userList[i].userName;
						_this.keyList.push(temp);
					// }
				// }
			}
        	_this.forecastTypeAndUser = userList;
        },
        
        /**
         * 从后台获取当前时间和用户
         */
        getMaxDateAndUser: function () {
            var _this = this;
            var maxModelTime = {};
            $.ajax({
                url: ctx + '/analysis/forecastflow/AirForecastHour/getMaxDateAndUser.vm',
                isShowLoader: true,
                type: 'post',
                //async: false,
                data: '',
                dataType: 'json',
                success: function (resultData) {
                	_this.userId = resultData.data.userId;
                	_this.userName = resultData.data.userName;

                },
                error: function () {
                    _this.showMessageDialog('网络连接失败！');
                },
            });
        },
		/**
		 * 获取表格数据
		 */
        getTableData:function(){
        	var _this =this;
        	_this.cheakForecastTypeAndUser=[];
        	var modeltime = _this.getThisMonthDay();
        	_this.cheakForecastTypeAndUserName=[];
        	for (var i = 0; i < _this.forecastTypeAndUser.length; i++) {
				if(_this.forecastTypeAndUser[i].checked ){
					_this.cheakForecastTypeAndUser.push(_this.forecastTypeAndUser[i].model);
					_this.cheakForecastTypeAndUserName.push(_this.forecastTypeAndUser[i].userName);
				}
			}
        	 $.ajax({
                 url: ctx + '/analysis/forecastflow/AirForecastHour/getTableData.vm',
                 isShowLoader: true,
                 type: 'post',
                 async: true,
                 data: {
                	 	"models":_this.cheakForecastTypeAndUser.join(","),
                	 	"modeltime":modeltime
                	 },
                 dataType: 'json',
                 success: function (resultData) {
                	 if(resultData.code =='200'){
                	 	_this.state=resultData.data[0].STATE;
                		 _this.tableList=resultData.data;
						 _this.initEchartsData(resultData.data);
                	 }

                 },
                 error: function () {
                     _this.showMessageDialog('网络连接失败！');
                 },
             });
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
         * 日期选择插件
         */
        wdatePicker: function () {
            var _this = this;
            WdatePicker({
                // 回显数据的对象ID
                el: 'txtDateStart',
                // 时间格式
                dateFmt: 'yyyy-MM',
                // 是否显示清除按钮
                isShowClear: false,
                // 只读
                readOnly: true,
                // 最大时间限制，参考：http://www.my97.net/demo/index.htm
                maxDate: '%y-%M',
                onpicked: function (dp) {
                    // 确认按钮点击事件
                    _this.monthClick(dp.cal.getNewDateStr());
                }
            });
        },
		exportExcel: function () {
			let _this = this;
			_this.cheakForecastTypeAndUser=[];
			let modeltime = _this.getThisMonthDay();
			for (var i = 0; i < _this.forecastTypeAndUser.length; i++) {
				if(_this.forecastTypeAndUser[i].checked ){
					_this.cheakForecastTypeAndUser.push(_this.forecastTypeAndUser[i].model);
				}
			}
			let url = ctx+'/analysis/forecastflow/AirForecastHour/exportExcel.vm';
			let params = {
				models:_this.cheakForecastTypeAndUser.join(","),
				modeltime:modeltime
			};
			FileDownloadUtil.createSubmitTempForm(url, params);

		},
    }
});
// 数字校验
function checkNumber(obj) {
	var value = obj.val();
	if (value) {
		if ( !(/^(0|[1-9][0-9]*)$/.test(value) ) || value>1000 || value<0) {
			return  '请输入一个[0,1000]的整数！' ;
		}
	}
	return true;
}
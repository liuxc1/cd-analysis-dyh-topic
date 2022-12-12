// vue实列化
var vue = new Vue({
    el:'#index-app',

    /**
     * 基本数据
     */
    data:{
    	// 记录列表
		records: [{
			text:'',
			//默认设置为未选中
			selected:false
		}],
		urls:{
			addUrl:ctx+"/analysis/sourceanalysis/distinctSourceResolve/edit.vm",
		},
		// 记录信息
		record: '',
		report:{
			//设置初始填报年份为2019
			REPORT_YEAR:'2020',
			REPORT_ID:'',
			STATE:'',
			//夏季PM2.5的组分解析
			FIELD1:'',
			//冬季PM2.5的组分解析
			FIELD2:'',
			//夏季PM10的组分解析
			FIELD3:'',
			//冬季PM10的组分解析
			FIELD4:'',
			//区县解析
			FIELD5:'',
    		REPORTNAME:'',
    		// 提交记录数限制，不做限制，则为-1
        	uploadLimit: -1
				
		},
		//文件列表
		fileList:[],
		//用于形成文件的真实路径
		fileType:'',
		fileSavePath:'',
		//污染源
		sourcePollute:{
			//默认为PM2.5
			PM:'PM25'
		},
		//判断污染物信息
		polluteinfo1:'',
		polluteinfo2:''
    },
    /**
     * 页面加载完成后执行
     */
    mounted: function() { 
    	this.initData();
    	// 当页面改变的时候，动态改变弹出层的高度和宽度（添加和编辑页面打开时有效）
		$(window).on('resize', function() {
			if (_this.pageDialog) {
				_this.pageDialog.width($(window).width());
				_this.pageDialog.height($(window).height());
			}
		});
    },
    updated: function () {
  	  this.$nextTick(function () {
  		  $(".thumbnail").viewer();
  	  })
  	},
    /**
     * 所有方法
     */
    methods: {
    	initData:function(){
    		var _this = this;
    		_this.queryReportInfosByYear();
		},
		
		queryReportInfosByYear:function(){
			var _this = this;
			$.ajax({
				url:'queryReportInfosByYear.vm',
				data:{
					'REPORT_TIME':_this.report.REPORT_YEAR
				},
				type:'post',
				dataType:'json',
				isShowLoader: true,
				success:function(json){
					var dataList = json.data;
					if(!dataList){
						DialogUtil.showTipDialog("暂无数据!");
						_this.records = [];
						//初始化
						_this.report.REPORT_ID = '';
						_this.record = 0;
					}else{
						var flag = false;
						var index = 0;
						for(var i = 0 ;i<dataList.length;i++){
							if(_this.report.REPORT_ID == dataList[i].REPORT_ID){
								dataList[i].selected = true;
								flag = true;
								index = i;
							}else{
								dataList[i].selected = false;
								
							}
						}
						_this.records = dataList;
						if(flag){
							//查询选中文件的所有字段
							_this.report.FIELD1 = _this.records[index].FIELD1;
							_this.report.FIELD2 = _this.records[index].FIELD2;
							_this.report.FIELD3 = _this.records[index].FIELD3;
							_this.report.FIELD4 = _this.records[index].FIELD4;
							_this.report.FIELD5 = _this.records[index].FIELD5;
							_this.report.STATE = _this.records[index].STATE;
							_this.report.REPORT_ID = _this.records[index].REPORT_ID;
							_this.report.REPORTNAME = _this.records[index].REPORT_NAME;
							_this.fileType = _this.records[index].FILE_TYPE;
							_this.fileSavePath = _this.records[index].FILE_SAVE_PATH;
							_this.record = 1;
							
						}else{
							//默认取第一个报告文件(初始化)
							_this.report.FIELD1 = _this.records[0].FIELD1;
							_this.report.FIELD2 = _this.records[0].FIELD2;
							_this.report.FIELD3 = _this.records[0].FIELD3;
							_this.report.FIELD4 = _this.records[0].FIELD4;
							_this.report.FIELD5 = _this.records[0].FIELD5;
							_this.report.STATE = _this.records[0].STATE;
							_this.report.REPORT_ID = _this.records[0].REPORT_ID;
							_this.report.REPORTNAME = _this.records[0].REPORT_NAME;
							_this.fileType = _this.records[0].FILE_TYPE;
							_this.fileSavePath = _this.records[0].FILE_SAVE_PATH;
							_this.record = 1;
							
						}
						_this.queryEchart();
						_this.queryFileListByAscriptionId();
					}
				},error:function(){
					DialogUtil.showTipDialog('系统繁忙，请稍后重试！');
				}
				
			})
		},
		//根据归属ID，查询文件列表
		queryFileListByAscriptionId:function(){
			_this = this;
			$.ajax({
				url:'queryFileListByAscriptionId.vm',
				data:{
					'REPORT_ID':this.report.REPORT_ID
				},
				type:'post',
				dataType:'json',
				success:function(json){
					_this.fileList = json.data;
				},error:function(){
					DialogUtil.showTipDialog('系统繁忙，请稍后重试！');
				}
			})
		},
		findByReportYear:function(event) {
    		_this = this;
			WdatePicker({
				dateFmt : 'yyyy',
				el : 'reportYear',
				maxDate : '#now',
				isShowClear : true,
				onpicking : function(dp) {
					_this.report.REPORT_YEAR = dp.cal.getNewDateStr();
				},
				onclearing : function() {
					_this.report.REPORT_YEAR = '';
				},
				readOnly : true
			});
		},
		//去编辑页面
		goEdit:function(){
			this.pageDialog = DialogUtil.showFullScreenDialog(this.urls.addUrl+"?reportId="+this.report.REPORT_ID+"&state=TEMP");
			$('body').css('overflow-y', 'hidden');
		},
		//去添加页面
		goAdd:function(){
			this.pageDialog = DialogUtil.showFullScreenDialog(this.urls.addUrl);
			$('body').css('overflow-y', 'hidden');
		},
		//删除报告文件
		deleteReportFile:function(){
			var _this = this;
			DialogUtil.showDeleteDialog('删除选中的数据，请确认！',function(){
				AjaxUtil.sendAjaxRequest("delete.vm",null,
						{"FILE_ID":_this.report.REPORT_ID,
						"FILE_TYPE":_this.fileType,
						"FILE_SAVE_PATH":_this.fileSavePath
						},
					function(json){
							if(json.data == true){
								DialogUtil.showTipDialog('删除成功！',function(){
									_this.initData();
								});
							}else{
								DialogUtil.showTipDialog('删除失败！');
							}
					})
			});
		},
		//提交记录
		submit:function(){
			_this = this;
			DialogUtil.showConfirmDialog("确认要提交吗？",function(){
					AjaxUtil.sendAjaxRequest("submit.vm",null,
								{
								"FIELD1":_this.report.FIELD1,
								"FIELD2":_this.report.FIELD2,
								"FIELD3":_this.report.FIELD3,
								"FIELD4":_this.report.FIELD4,
								"FIELD5":_this.report.FIELD5,
								"REPORT_NAME":_this.report.REPORTNAME,
								"REPORT_ID":_this.report.REPORT_ID
								},
							function(json){
									//返回的是受影响行数
								if(json.data > 0){
									DialogUtil.showTipDialog("提交成功！",function(){
										_this.initData();
									});
								} 
							})
				});
			},
		recordClick:function(record){
			if(this.sourcePollute.PM == 'PM25'){
				this.polluteinfo1 = record.FIELD1;
				this.polluteinfo2 = record.FIELD2;
			}else{
				this.polluteinfo1 = record.FIELD3;
				this.polluteinfo2 = record.FIELD4	
			}
			_this.report.FIELD1 = record.FIELD1;
			_this.report.FIELD2 = record.FIELD2;
			_this.report.FIELD3 = record.FIELD3;
			_this.report.FIELD4 = record.FIELD4;
			
			this.report.FIELD5 = record.FIELD5;
			this.report.STATE = record.STATE;
			this.report.REPORT_ID = record.REPORT_ID;
			this.report.REPORTNAME = record.REPORT_NAME;
			this.fileSavePath = record.FILE_SAVE_PATH;
			this.queryEchart(); 
			this.queryFileListByAscriptionId();
		},
		changePollute:function(polluteName){
			var _this = this;
			_this.sourcePollute.PM = polluteName;
		},
		queryCounty:function(){
			var _this = this;
			_this.queryReportInfosByYear();
			//延迟执行以下代码
			 this.$nextTick(function () {
				 if(_this.report.REPORT_ID == ''){
					 return;
				 }
		  	  })
		
		},
		
		queryEchart:function(){
			var _this = this;
			$.ajax({
				url:'queryCounty.vm',
				data:{
					'REPORT_ID':_this.report.REPORT_ID,
					'PM':_this.sourcePollute.PM
				},
				type:'post',
				dataType:'json',
				success:function(json){
					var dataList = json.data;
					//夏季结果集
					var summerList = dataList[0];
					//冬季结果集
					var winterList = dataList[1];
					if(summerList.length > 0 && winterList.length > 0){
						_this.summerEchart(summerList);
						_this.winterEchart(winterList);
					}else{
						_this.summerEchart([]);
						_this.winterEchart([]);
					}
				},
				error:function(){
					DialogUtil.showTipDialog('系统繁忙，请稍后重试！');
				}
			})
		},
		summerEchart:function(resultSet){
			var _this = this;
			var myChart = echarts.init(document.getElementById('echart_1'));
			var typeName = (_this.sourcePollute.PM == 'PM25')?'PM₂.₅':'PM₁₀ ';
			var categoryArr = ['Al','Si','K','Ca','Fe','OC','EC','NH₄⁺','NO₃⁻','SO₄²⁻'];
			var keyArr = ['Al','SI','K','CA','FE','OC','EC','NH4','NO3','SO42'];
			var colorArr = ['#CAEACE','#b6a2de','#5ab1ef','#ffb980','#d87a80','#FFD92F','#9CD2BF','#FDB09A'];
		    var seriesArray = [];
		    for (var i = 0; i < resultSet.length; i++) {
		    	 var dataArray = [];
		    	 for (var j = 0; j < keyArr.length; j++) {
		    		 dataArray.push(resultSet[i][keyArr[j]]);
				}
		    	var obj={
		                name: resultSet[i].REGION_NAME,
		                type: 'bar',
		                barGap: 0,
		                data: dataArray,
		                itemStyle:{
		                	color:colorArr[i]
		                	}
		            }
		        seriesArray.push(obj);  
			}
		   
			var option = {
				title:{
					text:_this.report.REPORT_YEAR+'年夏季不同区域'+typeName+'主要化学组分含量',
					textStyle:{fontSize:14},
					bottom:0,
					left:'center'
				},
				backgroundColor: {
					type: 'pattern',
					image: canvas,
					repeat: 'repeat'
				},
				tooltip:{
					trigger:'axis',
					formatter:function(params){
						var result = '';
						params.forEach(function(item){
			        			result+=item.marker +" " +item.seriesName + " : " + item.value + "%<br/>";
			        	});
			        	return params[0].name + "<br/>" + result;
					}
				},
				 grid: {
				        left: '2%',
				        right: '4%',
				        bottom: '12%',
				        top:'10%',
				        containLabel: true
				    },
				yAxis:{
					type:'value',
					name:' 占比（%）',
					left:300,
					/*interval:4,*/
	    	        splitLine:{
	    	            show:false
	    	        },
				},
				xAxis:{
					type:'category',
					data:categoryArr
				},
				series:seriesArray
			}
			//清除原有数据
			myChart.clear();
			myChart.setOption(option);
		},
		winterEchart:function(resultSet){
			var _this = this;
			var myChart = echarts.init(document.getElementById('echart_2'));
			var typeName = (_this.sourcePollute.PM == 'PM25')?'PM₂.₅':'PM₁₀ ';
			var categoryArr = ['Al','Si','K','Ca','Fe','OC','EC','NH₄⁺','NO₃⁻','SO₄²⁻'];
			var keyArr = ['Al','SI','K','CA','FE','OC','EC','NH4','NO3','SO42'];
			var colorArr = ['#CAEACE','#b6a2de','#5ab1ef','#ffb980','#d87a80','#FFD92F','#9CD2BF','#FDB09A'];
		    var seriesArray = [];
		    for (var i = 0; i < resultSet.length; i++) {
		    	 var dataArray = [];
		    	 for (var j = 0; j < keyArr.length; j++) {
		    		 dataArray.push(resultSet[i][keyArr[j]]);
				}
		    	var obj={
		                name: resultSet[i].REGION_NAME,
		                type: 'bar',
		                barGap: 0,
		                data: dataArray,
		                itemStyle:{
		                	color:colorArr[i]
		                	}
		            }
		        seriesArray.push(obj);  
			}
		   
			var option = {
				title:{
					text:_this.report.REPORT_YEAR+'年冬季不同区域'+typeName+'主要化学组分含量',
					textStyle:
					{
						fontSize:14
					},
					bottom:0,
					left:'center'
				},
				backgroundColor: {
					type: 'pattern',
					image: canvas,
					repeat: 'repeat'
				},
				tooltip:{
					trigger:'axis',
					formatter:function(params){
						var result = '';
						params.forEach(function(item){
			        			result+=item.marker +" " +item.seriesName + " : " + item.value + "%<br/>";
			        	});
			        	return params[0].name + "<br/>" + result;
					}
				},
				 grid: {
				        left: '2%',
				        right: '4%',
				        bottom: '12%',
				        top:'10%',
				        containLabel: true
				    },
				yAxis:{
					type:'value',
					name:'占比（%）',
					/*interval:4,*/
	    	        splitLine:{
	    	            show:false
	    	        },
				},
				xAxis:{
					type:'category',
					data:categoryArr
				},
				series:seriesArray
			}
			//清除原有数据
			myChart.clear();
			myChart.setOption(option);
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
				this.initData();
			}
		},
		
    }
})    
    	


/**
 * 表格数据格式化
 * @param val 参数
 * @returns 格式化后的参数
 */
Vue.filter('result-format', function (val) {
	if(val || val==0){
		return val;
	}else{
		return '--';
	}
});




//关闭dialog
function closeDialog(id){
	dialog.get(id).close().remove();
}
$(window).resize(function () {          //当浏览器大小变化时
	if (vue.pageDialog) {
		vue.pageDialog.width($(window).width());
		vue.pageDialog.height($(window).height());
	}
});

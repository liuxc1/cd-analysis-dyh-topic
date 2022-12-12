var health_level = [ '', '优', '优-良', '良', '良-轻度污染', '轻度污染', '轻度-中度污染', '中度污染', '中度-重度污染', '重度污染', '重度-严重污染', '严重污染' ];
var primpollutes = ['PM2.5', 'PM10', 'O3', 'NO2', 'SO2', 'CO' ];
var primpollutes2 = ['PM₂.₅', 'PM₁₀', 'O₃', 'NO₂', 'SO₂', 'CO' ];
var aqiValArr = [ -1, 50, 100, 150, 200, 300 ];
var aqiTextArr = [ '优', '良', '轻度污染', '中度污染', '重度污染', '严重污染' ];
var levelNameArr = ['好','较好','中等偏好','中等','中等偏差','较差','差','极差'];
var levelInfoArr = ['非常有利于空气污染物稀释、扩散和清除','较有利于空气污染物稀释、扩散和清除','对空气污染物稀释、扩散和清除无明显影响',
                    '对空气污染物稀释、扩散和清除无明显影响','对空气污染物稀释、扩散和清除无明显影响','不利于空气污染物稀释、扩散和清除',
                    '很不利于空气污染物稀释、扩散和清除','极不利于空气污染物稀释、扩散和清除'];

vue=new Vue({
	el: '#main-container',
	data: {
		// 该功能调用的所有url列表
		urls: {
			queryMonthTrendInfoById: ctx + '/analysis/report/generalReport/queryDayGeneralReportByIdAndFileSource.vm',
			saveMonthTrendInfoUrl: ctx + '/analysis/forecastflow/monthtrend/saveMonthTrendInfo.vm'
		},
		reportId:reportId,
		// 城市预报对应的主信息
		resultData: {
			// 预报ID
			STATE:'',
			MONTHTREND_ID:'',
			FORECAST_TIME:'',
			MONTHTREND_NAME:'',		
			HINT:'',
			deleteFileIds:[],
		},
		fileList: [],
		forecastValueList: []
	},
	/**
	 * 页面加载完后调用
	 */
	mounted: function () {
		// 将回调延迟到下次 DOM 更新循环之后执行。在修改数据之后立即使用它，然后等待 DOM 更新
		this.$nextTick(function () {
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
			// 初始化会商时间（通过计算属性获取当前时间）
		
				//新增，设置为默认时间
				this.resultData.FORECAST_TIME = DateTimeUtil.getNowDate();
			this.queryForecastInfo(true);
			this.initEvents();
		});
	},
	methods: {
		/**
		 * 日期选择插件
		 */
		wdatePicker: function () {
			var _this = this;
			WdatePicker({
				// 回显数据的对象ID
				el: 'txtDateStart',
				// 时间格式
				dateFmt: 'yyyy-MM-dd',
				// 是否显示清除按钮
				isShowClear: false,
				// 只读
				readOnly: true,
				// 最大时间限制，参考：http://www.my97.net/demo/index.htm
				maxDate:'%y-%M-%d',
				onpicked: function(dp) {
					// 确认按钮点击事件
					_this.resultData.FORECAST_TIME = dp.cal.getNewDateStr();
					_this.queryForecastInfo();
					_this.initEvents();
				}
			});
		},
		getAqiLevel:function(val) {
			for (var i = aqiValArr.length - 1; i >= 0; i--) {
				if (val > aqiValArr[i]) {
					return i + 1;
				}
			}
		},
		getlevel:function(value){
			var result="";
			if (0 <= value && value <= 50) {
				result = "优";
			} else if (50 < value && value <= 100) {
				result = "良";
			} else if (100 < value && value <= 150) {
				result = "轻度污染";
			} else if (150 < value && value <= 200) {
				result = "中度污染";
			} else if (200 < value && value <= 300) {
				result = "重度污染";
			} else if (300 < value) {
				result = "严重污染";
			} else {
				result = "无";
			}
			return result
		},
		initEvents:function()
		{
			var _this = this;
			$(".beforenum").on("input propertychange",function(){
				if($(this).val()==""){
					$($(this).siblings("input")).val("");
					$($(this).parent().next()).text("");
				}else{
					$($(this).siblings("input")).val(parseInt($(this).val())+30);
					var before = _this.getlevel($(this).val());
					var after = _this.getlevel(parseInt($(this).val())+30);
					var result = "";
					if(before == after){
						result =before;
					}else{
						if(before=="优"){
							result = before+"或"+after;
						}else{
							result = before+"至"+after;
						}
					}
					$($(this).parent().next()).text(result);
				}
			})

			$(".afternum").on("input propertychange",function(){
				if($(this).val()==""){
					$($(this).siblings("input")).val("");
					$($(this).parent().next()).text("");
				}else{
					var before = parseInt($(this).val())-30;
					if(before<0){
						before = 0;
					}
					$($(this).siblings("input")).val(before);
					var beforelevel = _this.getlevel(before);
					var afterlevel = _this.getlevel($(this).val());
					var result = "";
					if(beforelevel == afterlevel){
						result =beforelevel;
					}else{
						if(beforelevel=="优"){
							result = beforelevel+"或"+afterlevel
						}else{
							result = beforelevel+"至"+afterlevel
						}
					}
					$($(this).parent().next()).text(result);
				}
			})
		},
	/**
	 * 取消
	 * @param {boolean} isParentRefresh 是否父页面刷新
	 */
	cancel: function (isParentRefresh) {  //暂不管
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
	saveData: function (btnType) {
		var _this = this;
		// 验证表单
		var flag = $('#mainForm').validationEngine('validate');
		if (!flag) {
			return;
		}
		// 验证表格
		var param = {};
		param.flow_state = '0';
		param = _this.getTableData(param);
		if (!param) {
			return;
		}
		// 将文件添加到表单数据中
		var formData = _this.$refs.fileUploadTable.getFileFormData();
		if(formData==null)
			{
			return;
			}
		// 将基础数据添加到表单数据中
		_this.resultData.STATE = btnType;
		formData = _this.appendBaseDataToForm(formData);
		formData.append("TableList",JSON.stringify(param));
		// 验证通过，提交到后台
		var tipMessage = _this.getSaveTipMessage(btnType);
		DialogUtil.showConfirmDialog(tipMessage.confirmMessage, function () {
			AjaxUtil.sendFileUploadAjaxRequest(_this.urls.saveMonthTrendInfoUrl, formData, function () {
				DialogUtil.showTipDialog(tipMessage.successMessage, function () {
					_this.cancel(true);
				}, function () {
					_this.cancel(true);
				});
			});
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
		for (var key in this.resultData) {
			formData.append(key, this.resultData[key]);
		}
		return formData;
	},
	queryForecastInfo:function(flag){
		var _this = this
		$.ajax({
			url : 'getForecastValues.vm',
			type : 'post',
			async : false,
			data : {
				FORECAST_ID:$('#reportId').val(),
				datetime:_this.resultData.FORECAST_TIME
			},
			dataType : 'json',
			success : function(result) {
				if (result.meta.success) {			
					_this.forecastValueList = result.data.forecastValueList;
					_this.setForecastTable(result.data.forecastValueList);
				} else {
					alert(result.msg);
				}
			}
		});
		if($('#reportId').val()!=''&&flag==true)
			{
			AjaxUtil.sendAjaxRequest(_this.urls.queryMonthTrendInfoById, null, {
				reportId: $('#reportId').val(),
				datetime:_this.resultData.FORECAST_TIME
			}, function (json) {
				var data = json.data;
				// 如果文件列表存在，且不为空，则遍历文件列表
				var redata={
				STATE:'',
				MONTHTREND_ID:json.data.REPORT_ID,
				FORECAST_TIME:json.data.REPORT_TIME,
				MONTHTREND_NAME:json.data.REPORT_NAME,		
				HINT:json.data.REPORT_TIP,
				deleteFileIds:[],
				};
				_this.resultData=redata;
				if (data.fileList != null && data.fileList.length > 0) {
					for (var i = 0; i < data.fileList.length; i++) {
						var file = data.fileList[i];
						_this.fileList.push({
							file: null,
							fileId: file.FILE_ID,
							name: file.FILE_FULL_NAME,
							type: file.FILE_TYPE,
							size: file.FILE_FORMAT_SIZE,
							uploadTime: file.CREATE_TIME
						});
					}
				}
			});
			
			}
	},
	setForecastTable:function(dataList)
	{
		if (dataList && dataList instanceof Array) {
			var options = "";
			for (var i = 0; i < levelNameArr.length; i++) {
				options = options + '<option value="' + levelNameArr[i] + '">' + levelNameArr[i] + '</option>';
			}
			var weatherSelect = '<select class="form-control"><option value="">请选择</option>' + options + '</select>';//气象扩散条件下拉

			var options2 = "";
			for (var i = 0; i < primpollutes.length; i++) {
				options2 = options2 + '<option value="' + primpollutes[i] + '">' + primpollutes2[i] + '</option>';
			}

			var pollutesSelect = '<select class="selectpicker form-control" multiple data-max-options="2" title="请选择">' + options2 + '</select>';

			var myObj = $('#forecastValueTbody');
			myObj.empty();
			$.each(dataList, function(index, data) {
				var aqi = data.AQI;
				if (aqi&&aqi.indexOf('~') > 0) {
					aqi = aqi.split('~');
				} else {
					aqi = [ '', '' ]
				}
				var aqiInput = '<input type="text" autocomplete="off" class="beforenum" data-validation-engine="validate[min[0],max[470],custom[integer]]" style="width:30%" value="'+aqi[0]+'"> 至 <input type="text" autocomplete="off" class="afternum" data-validation-engine="validate[min[0],max[500],custom[integer]]" style="width: 30%" value="'+aqi[1]+'">';//aqi输入框

				var html = "<tr>";
				html = html + '<td class="td_date">' + data.RESULT_TIME + '</td>';
				html = html + '<td class="edit aqi_edit">' + aqiInput + '</td>';
				html = html + '<td class="align-left level_last">' + (data.AQI_LEVEL || '') + '</td>';
				html = html + '<td class="edit primpollute_last">' + pollutesSelect + '</td>';
				html = html + '<td class="edit weather_trend_edit">' + weatherSelect + '</td>';
				html = html + '</tr>'

				myObj.append(html);
				myObj.find('.weather_trend_edit select:last').val(data.WEATHER_LEVEL || '');
				if(data.PRIM_POLLUTE){
					myObj.find('.primpollute_last select:last').selectpicker('val',data.PRIM_POLLUTE.split(","));
				}else{
					myObj.find('.primpollute_last select:last').selectpicker('val',"");
				}
			});
		}
	},
	getTableData:function(param) {
		// 先关闭表格中打开的select 和 input
//		closeInputAndSelect();

		if (!param) {
			param = {};
		}
		
		var json = [];
		$('.w-table').find('tbody tr').each(function(i, e) {
			var tr = $(e);
			json.push({
				RESULT_TIME1: tr.find('td').eq(0).html(),
				LEVEL1: tr.find('td').eq(1).find('select option:selected').val() || '',
				LEVEL2: tr.find('td').eq(2).find('select option:selected').val() || '',
				RESULT_TIME2: tr.find('td').eq(3).html(),
				LEVEL3: tr.find('td').eq(4).find('select option:selected').val() || '',
				LEVEL4: tr.find('td').eq(5).find('select option:selected').val() || '',
				RESULT_TIME3: tr.find('td').eq(6).html(),
				LEVEL5: tr.find('td').eq(7).find('select option:selected').val() || '',
				LEVEL6: tr.find('td').eq(8).find('select option:selected').val() || '',
			});
		});
		
		// 未来空气质量预报信息
		param.list = json;
		
		return param;
	},
	importData: function() {
		var _this = this;
		var s = dialog({
			id : "dialog-import",
			title : '导入Excel数据',
			url : ctx + '/eform/exceltemplate/goupload.vm?desigerid=2&callbackClass=MonthTrendExcelHandleService&LOGINNAME=' + loginName,
			width : 400,
			height : 200,
			cancel : function() {
				s.close().remove();
			},
			cancelDisplay : false
		}).showModal();
	},
	templateDownload : function(){
		window.open(ctx + '/analysis/forecastflow/monthtrend/templateDownload.vm?datetime=' + this.resultData.FORECAST_TIME ,'_self');
	},
	doSearch: function() {
		var _this = this;
		$.ajax({
			url : 'queryExcel.vm' ,
			type : 'post',
			async : false,
			dataType : 'json',
			success : function(result) {
				if (result.meta.success) {
					_this.forecastValueList = result.data;
				} else {
					alert(result.meta.message);
				}
			}
		});
	}
	}
});
//关闭dialog
function closeDialog(id, mess) {
	if(mess=='success') {
		vue.doSearch();
	}
	dialog.get(id).close().remove();
}

// 等级1和等级2验证
function ckeck(field, rules, i, options) {
	var tdIndex = field.parent('td').index(), selectedIndex = field.find('option:selected').index();
	if (tdIndex === 2 || tdIndex === 5 || tdIndex === 8) {
		if(selectedIndex!=0){
			if (selectedIndex-field.parent('td').prev().find('select option:selected').index()!=1&&selectedIndex-field.parent('td').prev().find('select option:selected').index()!=0) {
				return '* 等级2不能小于等级1且只能跨一级';
			}
		}
	}
}
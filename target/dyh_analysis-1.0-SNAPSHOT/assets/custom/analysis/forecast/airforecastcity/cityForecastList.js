/** 重污染会商-列表逻辑js **/
var vue = new Vue({
	el: '#main-container',
	data: {
		// 该功能调用的所有url列表
		urls: {
			// 根据月份，查询频率为日的时间轴列表（月份 可为空）
			queryDayTimeAxisListByMonth: ctx + '/analysis/forecastflow/forecastflowcity/queryDayTimeAxisListByMonth.vm',
			// 根据报告时间查询频率为日的记录列表
			queryDayRecordListByReportTime: ctx + '/analysis/report/generalReport/queryDayRecordListByReportTime.vm',
			// 根据报告ID，查询城市预报信息
			queryCityForecastByReportId: ctx + '/analysis/forecastflow/forecastflowcity/queryCityForecastByReportId.vm',
			// 添加页面
			cityForecastAdd: ctx + '/analysis/forecastflow/forecastflowcity/cityForecastIndex.vm?showFlag='+showFlag,
			// 编辑页面
			cityForecastEdit: ctx + '/analysis/forecastflow/forecastflowcity/cityForecastIndex.vm',
			// 删除
			deleteReportById: ctx + '/analysis/forecastflow/forecastflowcity/deleteForecastById.vm',
			// 查询文件是否存在
			queryFile: ctx + '/system/file/file/queryFile.vm',
			// pdf查看页面
			viewer: ctx + '/assets/components/pdfjs-2.0.943-dist/web/viewer.html',
			// 报告是否有提交记录
			queryStateNumber: ctx + '/analysis/report/generalReport/queryStateNumber.vm',
			// 修改报告状态
			updateReportState: ctx + '/analysis/forecastflow/forecastflowcity/updateForecastState.vm',
			// 撤回
			revocationReportById: ctx + '/analysis/forecastflow/forecastflowcity/revocationReportById.vm',
		},
		// 归属类型
		ascriptionType: 'CITY_FORECAST',
		// 填报月份（会商月份）
		month: null,
		showFlag:showFlag,
		//选中的时间day
		selectedIndex:'',
		// 时间轴
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
			list: null
		},
		//气象条件类型（1：臭氧污染气象条件2：气象扩散条件）
		weatherConditionsType:1,
		// 记录列表
		records: null,
		// 提交记录数限制，不做限制，则为-1
		uploadLimit: -1,
		// 记录信息
		record: null,
		// 文件记录列表
		fileRecords: null,
		// 选中的文件ID
		selectedFileId: null,
		// pdf的URL
		pdfUrl: null,
		// 没有数据的文本
		noDataText: null,
		// 页面的dialog
		pageDialog: null,
		//3天预报和7天预报的选中状态
		threeday:false,
		sevenday:false,
		//是否只能查看
		isOnlyRead: window.isOnlyRead && window.isOnlyRead == 1,
	},
	/**
	 * 页面加载完后执行
	 */
	mounted: function () {
		var _this = this;
		_this.monthClick();
		// 当页面改变的时候，动态改变弹出层的高度和宽度（添加和编辑页面打开时有效）
		$(window).on('resize', function() {
			if (_this.pageDialog) {
				_this.pageDialog.width($(window).width());
				_this.pageDialog.height($(window).height());
			}
		});
	},
	/**
	 * 所有方法
	 */
	methods: {
		/**
		 * 月份点击
		 * @param month 月份
		 */
		monthClick: function (month) {
			var _this = this;
			// 防止重复点击
			if (month != null && month === _this.month) {
				return;
			}
			AjaxUtil.sendAjaxRequest(_this.urls.queryDayTimeAxisListByMonth, null, {
				ascriptionType: _this.ascriptionType,
				month: month
			}, function (json) {
				var dataList = json.data;
				var data = dataList[0];
				// 填报月份
				_this.month = data.REPORT_TIME.substring(0, 7);
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

					if ((data.IS_DATA === 'Y')) {
						selectedIndex = i;
					}
					list.push({
						key: data.REPORT_TIME,
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
					_this.noData();
				}
				// 给时间轴赋值
				_this.selectedIndex=selectedIndex+1;
				if (_this.selectedIndex>0&&_this.selectedIndex<=9) {
					_this.selectedIndex='0'+_this.selectedIndex;
				}
				_this.timeAxis.list = list;
			});
		},
		/**
		 * 上一月点击事件
		 * @param prev 上一月按钮包含的数据
		 */
		prevClick: function (prev) {
			var month = DateTimeUtil.addMonth(this.month, -1);
			this.monthClick(month);
		},
		/**
		 * 下一月点击事件
		 * @param next 下一月按钮包含的数据
		 */
		nextClick: function (next) {
			var month = DateTimeUtil.addMonth(this.month, 1);
			this.monthClick(month);
		},
		/**
		 * 时间轴列表点击事件
		 * @param 点击的时间轴列表元素包含的信息
		 */
		timeAxisListClick: function (data) {
			var _this = this;
			AjaxUtil.sendAjaxRequest(_this.urls.queryDayRecordListByReportTime, null, {
				reportTime: data.key,
				ascriptionType: _this.ascriptionType
			}, function (json) {
				_this.selectedIndex=data.key.substring(8,10);
				var dataList = json.data;
				var records = [];
				for (var i = 0; i < dataList.length; i++) {
					records.push({
						key: dataList[i].REPORT_ID,
						reportName:dataList[i].REPORT_NAME,
						text: _this.getRecordText(dataList[i]),
						selected: false
					});
				}
				// 选中最新一次会商
				records[records.length - 1].selected = true;
				_this.records = records;
			},function (error){
				_this.showMessageDialog(error.message)
				_this.noData();
			});
		},
		/**
		 * 获取记录文本
		 * @param data 数据
		 * @returns 记录文本
		 */
		getRecordText: function (data) {
			if (data.STATE === 'UPLOAD') {
				return data.REPORT_NAME + '（' + data.CREATE_USER + '-已提交）';
			}
			return data.REPORT_NAME + '（' + data.CREATE_USER + '）';
		},
		/**
		 * 记录列表点击事件
		 * @param record 点击的记录列表元素包含的信息
		 */
		recordClick: function (record) {
			var _this = this;
			AjaxUtil.sendAjaxRequest(_this.urls.queryCityForecastByReportId, null, {
				reportId: record.key
			}, function (json) {
				var data = json.data;
				_this.weatherConditionsType=data.WEATHER_CONDITIONS_TYPE;
				var recordTemp = {
					pkid: data.INFO_ID,
					reportName: data.REPORT_NAME,
					createTime: data.CREATE_TIME,
					createUser: data.CREATE_USER,
					reportTime:data.REPORT_TIME.substr(0,10),
					saveTime: data.SAVE_TIME,
					saveUser: data.SAVE_USER,
					flowState: data.FLOW_STATE,
					//是否推送省站
					isSend: data.IS_SEND,
					cityOpinion: data.CITY_OPINION,
					areaOpinion: data.AREA_OPINION,
					countryOpinion: data.COUNTRY_OPINION,
					cityOpinion3day: data.cityOpinionDay3,
					countryOpinion3day: data.countryOpinionDay3,
					importantHints: data.IMPORTANT_HINTS,
					importantHints_7day: data.importantHintsDay7,
					inscribe: data.INSCRIBE,

					cityForecastAqiList: null
				}
				_this.record = recordTemp;

				var cityForecastAqiList = [];
				if (_this.validateArray(data.CITY_FORECAST_AQI_LIST)) {
					for (var i = 0; i < data.CITY_FORECAST_AQI_LIST.length; i++) {
						var cityForecastAqi = data.CITY_FORECAST_AQI_LIST[i];
						let pm25MinAqi=cityForecastAqi.PM25_MIN_IAQI==null?'':cityForecastAqi.PM25_MIN_IAQI;
						let pm25MaxAqi=cityForecastAqi.PM25_MAX_IAQI==null?'':cityForecastAqi.PM25_MAX_IAQI;
						let o3MinAqi=cityForecastAqi.O3_MIN_IAQI==null?'':cityForecastAqi.O3_MIN_IAQI;
						let o3MaxAqi=cityForecastAqi.O3_MAX_IAQI==null?'':cityForecastAqi.O3_MAX_IAQI;
						cityForecastAqiList.push({
							pkid: cityForecastAqi.PKID,
							createTime: cityForecastAqi.CREATE_TIME,
							resultTime: cityForecastAqi.RESULT_TIME.substr(0,10),
							pointCode: cityForecastAqi.POINT_CODE,
							pointName: cityForecastAqi.POINT_NAME,
							aqi: cityForecastAqi.AQI,
							aqiLevel: cityForecastAqi.AQI_LEVEL,
							pm25: cityForecastAqi.PM25,
							pm25Iaqi:pm25MinAqi+'~'+pm25MaxAqi,
							o3Iaqi:o3MinAqi+'~'+o3MaxAqi,
							o3: cityForecastAqi.O3,
							primPollute: cityForecastAqi.PRIM_POLLUTE,
							weatherTrend: cityForecastAqi.WEATHER_TREND,
							CONTROL_TARGET: cityForecastAqi.CONTROL_TARGET,
							weatherLevel: cityForecastAqi.WEATHER_LEVEL
						});
					}
					_this.record.cityForecastAqiList = cityForecastAqiList;
				}

				var fileRecords = [];
				if (_this.validateArray(data.FILES)) {
					for (var i = 0; i < data.FILES.length; i++) {
						var file = data.FILES[i];
						fileRecords.push({
							key: file.FILE_ID,
							text: _this.getFileName(file.FILE_FULL_NAME, file.FILE_FORMAT_SIZE),
							selected: false,
							fileUrl: file.FILE_URL,
							fileName: file.FILE_FULL_NAME,
							fileType: file.FILE_TYPE
						});
					}
					fileRecords[0].selected = true;
					_this.fileRecords = fileRecords;
				} else {
					_this.noFile();
				}
			});
		},
		/**
		 * 文件记录列表点击事件
		 * @param record 点击的文件记录列表元素包含的信息
		 */
		fileRecordClick: function (record) {
			var _this = this;
			// pdf
			AjaxUtil.sendAjaxRequest(_this.urls.queryFile, null, {
				fileId: record.key
			}, function (json) {
				// 获取选中文件的ID
				_this.selectedFileId = record.key;
				// 获取pdf的URL
				_this.pdfUrl = _this.urls.viewer + '?file=' + record.fileUrl;
			}, function (json) {
				_this.selectedFileId = null;
				_this.pdfUrl = null;
				DialogUtil.showTipDialog(json.meta.message);
			});
		},
		/**
		 * 没有数据
		 */
		noData: function () {
			this.records = null;
			this.record = null;
			this.noDataText = '暂无数据！';
			// 没有文件
			this.noFile();
		},
		/**
		 * 没有文件
		 */
		noFile: function () {
			this.fileRecords = null;
			this.selectedFileId = null;
			this.pdfUrl = null;
		},
		/**
		 * 验证数组是否为空
		 * @param {Array} array 需要验证的数组
		 * @returns 是否为空。True：为空，False：不为空
		 */
		validateArray: function (array) {
			return array != null && array.length > 0;
		},
		/**
		 * 获取文件名称
		 * @param fileName 文件名称
		 * @param fileFormatSize 文件格式化后的大小
		 * @returns 文件名称
		 */
		getFileName: function (fileName, fileFormatSize) {
			if (fileFormatSize){
				return fileName + '（' + fileFormatSize + '）';
			}else{
				return fileName;
			}

		},
		/**
		 * 日期选择插件
		 */
		wdatePicker: function () {
			var _this = this;
			WdatePicker({
				// 回显数据的对象ID
				el: 'wdate-picker',
				// 时间格式
				dateFmt: 'yyyy-MM',
				// 是否显示清除按钮
				isShowClear: false,
				// 是否显示今天按钮
				isShowToday: false,
				// 只读
				readOnly: true,
				// 限制最大时间
				maxDate:'%y-%M',
				onpicked: function(dp) {
					// 防止重复点击当月
					var month = dp.cal.getNewDateStr();
					if (month === _this.month) {
						return;
					}
					_this.monthClick(month);
					_this.month = month;
				}
			});
		},
		/**
		 * 提交按钮点击
		 */
		uploadClick: function () {
			var _this = this;
			if (_this.uploadLimit > 0) {
				AjaxUtil.sendAjaxRequest(_this.urls.queryStateNumber, null, {
					ascriptionType: _this.ascriptionType,
					reportTime: _this.record.reportTime
				}, function (json) {
					if (json.data.STATE_NUMBER >= _this.uploadLimit) {
						DialogUtil.showTipDialog("今日已有记录提交，不能重复提交！");
						return false;
					}
					_this.uploadReport();
				});
			} else {
				_this.uploadReport();
			}
		},
		/**
		 * 提交报告
		 */
		uploadReport: function () {
			var _this = this;
			var dateTime=_this.month+'-'+_this.selectedIndex;
			var newDate=_this.getNewDate();
			if( parseInt(newDate.HOUR)>=16 && dateTime==newDate.DATE){
				var s = dialog({
					id : "divmessdialog",
					title : '提示',
					width : $(window).width()*0.5,
					height : 150,
					content : document.getElementById('divmessdialog'),
					okValue : '确定',
					ok : function() {
						AjaxUtil.sendAjaxRequest(_this.urls.updateReportState, null, {
							reportId: _this.record.pkid,
							THREESTATE:_this.threeday,
							SEVENSTATE:_this.sevenday,
							datetime:dateTime,

						}, function (json) {
							for (let i = 0; i <_this.records.length; i++) {
								_this.$refs.record.records[i].text=_this.records[i].reportName + '（' + json.data.userName + '-已提交）';
							}
							_this.$refs.record.refresh();
							_this.pushData();
						});
					},
					cancelValue : '取消',
					cancel : function() {
						s.close().remove();
					}
				});
				s.showModal();
			}else{
				DialogUtil.showConfirmDialog("提交选中的记录，提交成功后将不能编辑和删除，请确认！", function () {
					AjaxUtil.sendAjaxRequest(_this.urls.updateReportState, null, {
						reportId: _this.record.pkid,
						datetime:dateTime,
					}, function (json) {
						for (let i = 0; i <_this.records.length; i++) {
							_this.$refs.record.records[i].text=_this.records[i].reportName + '（' + json.data.userName + '-已提交）';
						}
						_this.$refs.record.refresh();
						_this.pushData();
					});
				});
			}
		},


		/**
		 * 推送数据至省站
		 */
		pushData:async function (){
			const _this = this;
			DialogUtil.showConfirmDialog("是否推送数据至省站？", async function () {
				//获取数据
				let forecastInfo = await AjaxUtil.sendAjax('queryCityForecastByReportId.vm', {
					reportId: _this.record.pkid
				});
				let userName = '';
				let forecastTime = '';
				let dataList = [];
				if (forecastInfo && forecastInfo.data) {
					userName = forecastInfo.data['EDIT_USER'];
					forecastTime = forecastInfo.data['REPORT_TIME'].split(" ")[0];
					dataList = forecastInfo.data['CITY_FORECAST_AQI_LIST'];
				}
				//获取省站对应用户信息
				let userId = "";
				for (let i = 0; i <userInfo.length; i++) {
					if (userName === userInfo[i].userName){
						userId = userInfo[i].userId;
						break;
					}
				}
				if (!userId){
					userName = userInfo[0].userName;
					userId = userInfo[0].userId;
				}
				let paramMap = assembleData(forecastTime, dataList, userName);
				Vue.set(paramMap, "userId", userId);
				Vue.set(paramMap, "infoId", forecastInfo.data["INFO_ID"]);
				await AjaxUtil.sendAjaxJson("pushData.vm", paramMap, function (result) {
					DialogUtil.showTipDialog("推送成功",function (){
						_this.$refs.record.refresh();
					});
				}, function (result) {
					DialogUtil.showTipDialog("数据推送省站失败！");
				}, function (result) {
					DialogUtil.showTipDialog("数据推送省站失败！");
				})
			}, function () {
				return;
			});
		},

		/**
		 * 从后台获取当前时间
		 */
		getNewDate:function(){
			var _this=this;
			var newDate={};
			$.ajax({
				url : ctx + '/analysis/forecastflow/forecastflowcity/getNewDate.vm',
				isShowLoader : true,
				type : 'post',
				async:false,
				data :'',
				dataType : 'json',
				success : function(resultData) {
					newDate=resultData.data;
				},
				error : function() {
					_this.showMessageDialog('网络连接失败！');
				},
			});
			return newDate;
		},
		showMessageDialog:function(msg) {
			var s = dialog({
				id : "msg-show-dialog",
				title : '提示',
				content : msg,
				okValue : '确定',
				ok : function() {
					s.close().remove();
				}
			});
			s.showModal();
		},
		/**
		 * 到添加页面
		 */
		goAdd: function () {
			this.pageDialog = DialogUtil.showFullScreenDialog(this.urls.cityForecastAdd);
			$('body').css('overflow-y', 'hidden');
		},
		/**
		 * 到编辑页面
		 */
		goEdit: function () {
			var reportId = this.record.pkid;
			this.pageDialog = DialogUtil.showFullScreenDialog(this.urls.cityForecastEdit + '?reportId=' + reportId+'&showFlag='+showFlag);
			$('body').css('overflow-y', 'hidden');
		},
		/**
		 * 删除数据
		 */
		deleteData: function () {
			var _this = this;
			DialogUtil.showDeleteDialog(null, function () {
				// 当前选中的会商
				var reportId = _this.record.pkid;
				AjaxUtil.sendAjaxRequest(_this.urls.deleteReportById, null, {
					reportId: reportId
				}, function (json) {
					DialogUtil.showTipDialog("删除成功！", function () {
						// 刷新页面
						_this.monthClick();
					}, function () {
						_this.monthClick();
					});
				});
			});
		},
		/**
		 * 文件下载
		 */
		downloadFile: function () {
			if (this.selectedFileId) {
				// 下载文件
				FileDownloadUtil.downloadFile(this.selectedFileId);
			}
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
				this.monthClick();
			}
		},
		/**
		 * 获取首要污染物的Html格式
		 */
		getPrimPolluteHtml: function (primPollute) {
			if (!primPollute || primPollute === '') {
				return '--';
			}
			return primPollute.replace(/PM2.5/g, 'PM<sub>2.5</sub>')
				.replace(/PM10/g, 'PM<sub>10</sub>')
				.replace(/O3/g, 'O<sub>3</sub>')
				.replace(/SO2/g, 'SO<sub>2</sub>')
				.replace(/NO2/g, 'NO<sub>2</sub>');
		},
		/**
		 * 撤回提交
		 */
		revocation:function (){
			var _this = this;
			DialogUtil.showConfirmDialog('是否撤回当前提交记录？', function () {
				// 当前选中的会商
				var reportId = _this.record.pkid;
				AjaxUtil.sendAjaxRequest(_this.urls.revocationReportById, null, {
					reportId: reportId
				}, function (json) {
					DialogUtil.showTipDialog("已撤回！", function () {
						// 刷新页面
						_this.monthClick();
					}, function () {
						_this.monthClick();
					});
				});
			});
		},
		/**
		 * 预览界面
		 * 新开页面
		 */
		openFullScreen:function (){
			window.open(this.pdfUrl)
		}
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
				return '--';
			}
		},
	}
});
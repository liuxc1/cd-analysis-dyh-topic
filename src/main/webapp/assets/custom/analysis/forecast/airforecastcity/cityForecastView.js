/** 重污染会商-列表逻辑js **/
var vue = new Vue({
	el: '#main-container',
	data: {
		// 该功能调用的所有url列表
		urls: {
			// 根据报告ID，查询城市预报信息
			queryCityForecastByReportId: ctx + '/analysis/forecastflow/forecastflowcity/queryCityForecastByReportId.vm',
			// 添加页面
			cityForecastAdd: ctx + '/analysis/forecastflow/forecastflowcity/cityForecastIndex.vm',
			// 编辑页面
			cityForecastEdit: ctx + '/analysis/forecastflow/forecastflowcity/cityForecastIndex.vm',
			// 删除
			deleteReportById: ctx + '/analysis/forecastflow/forecastflowcity/deleteForecastById.vm',
			// 查询文件是否存在
			queryFile: ctx + '/common/file/queryFile.vm',
			// pdf查看页面
			viewer: ctx + '/assets/components/pdfjs-2.0.943-dist/web/viewer.html',
			// 报告是否有提交记录
			queryStateNumber: ctx + '/analysis/report/generalReport/queryStateNumber.vm',
			// 修改报告状态
			updateReportState: ctx + '/analysis/forecastflow/forecastflowcity/updateForecastState.vm'
		},
		// 归属类型
		ascriptionType: 'CITY_FORECAST',
		// 填报月份（会商月份）
		month: null,
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
		pageDialog: null
	},
	/**
	 * 页面加载完后执行
	 */
	mounted: function () {
		var _this = this;
		this.reportId = $('#reportId').val();
		_this.initData();
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
		 * 取消
		 */
		cancel: function () {
			if (window.parent && window.parent.vue.closePageDialog) {
				// 调用父页面的关闭方法
				window.parent.vue.closePageDialog();
			} else {
				window.history.go(-1);
			}
		},
		/**
		 * 记录列表点击事件
		 * @param record 点击的记录列表元素包含的信息
		 */
		initData: function () {
			var _this = this;
			AjaxUtil.sendAjaxRequest(_this.urls.queryCityForecastByReportId, null, {
				reportId: this.reportId,
			}, function (json) {
				var data = json.data;
				var recordTemp = {
					pkid: data.PKID,
					createTime: data.CREATE_TIME,
					createUser: data.CREATE_USER,
					saveTime: data.SAVE_TIME,
					saveUser: data.SAVE_USER,
					flowState: data.FLOW_STATE,
					cityOpinion: data.CITY_OPINION,
					areaOpinion: data.AREA_OPINION,
					countryOpinion: data.COUNTRY_OPINION,
					cityOpinion3day: data.CITY_OPINION_DAY3,
					countryOpinion3day: data.COUNTRY_OPINION_DAY3,
					importantHints: data.IMPORTANT_HINTS,
					inscribe: data.INSCRIBE,
					cityForecastAqiList: null
				}
				_this.record = recordTemp;
				
				var cityForecastAqiList = [];
				if (_this.validateArray(data.CITY_FORECAST_AQI_LIST)) {
					for (var i = 0; i < data.CITY_FORECAST_AQI_LIST.length; i++) {
						var cityForecastAqi = data.CITY_FORECAST_AQI_LIST[i];
						cityForecastAqiList.push({
							pkid: cityForecastAqi.PKID,
							createTime: cityForecastAqi.CREATE_TIME,
							resultTime: cityForecastAqi.RESULT_TIME,
							pointCode: cityForecastAqi.POINT_CODE,
							pointName: cityForecastAqi.POINT_NAME,
							aqi: cityForecastAqi.AQI,
							aqiLevel: cityForecastAqi.AQI_LEVEL,
							primPollute: cityForecastAqi.PRIM_POLLUTE,
							weatherTrend: cityForecastAqi.WEATHER_TREND,
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
			return fileName + '（' + fileFormatSize + '）';
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
		}
	}
});
// vue实列化
var vue = new Vue({
    el:'#index-app',
    /**
     * 外部接收数据
     */
    props: {
    	// 是否允许下载
		isDownload: {
			type: Boolean,
			default: true
		}
    },
    /**
     * 基本数据
     */
    data:{
    		urls:{
    			saveReportUrl:ctx+'/analysis/sourceanalysis/distinctSourceResolve/saveFilesToReport.vm',
    			downloadTemplateUrl:ctx+'/eform/exceltemplate/download.vm',
    			uploadExcelUrl:ctx+'/eform/exceltemplate/goupload.vm'
    		},
    	
        	// 报告数据
    		report: {
    			//填报年份
    			REPORT_YEAR:'2019',
    			//报告名称
    			REPORT_NAME:'',
    			//报告文件主键id,若不是修改页面就生成主键uuid
    			REPORT_ID:id,
    			//对应报告表中的FIELD1
    			FIELD1:'',
    			//对应报告表中的FIELD2
    			FIELD2:'',
    			//对应报告表中的FIELD3
    			FIELD3:'',
    			//对应报告表中的FIELD4
    			FIELD4:'',
    			//对应报告表中的FIELD5
    			FIELD5:'',
    			// 文件来源
    			fileSources: '',
    			// 文件列表
    			fileList: [],
    			// 删除文件ID列表
    			deleteFileIds: [],
    			//记录当前页面状态
    			STATE:state
    		},
    		param:{
    			disable:false
    		}
    },
    /**
     * 页面加载完成后执行
     */
    mounted: function() {
    	this.initData();
    },
    /**
     * 所有方法
     */
    methods: {
    	initData:function(){
    		var _this = this;
        	//如果是添加页面就退出停止执行
        	if(!_this.report.STATE){
        		return;
        	}
        	//初始时发送两次请求
        	$.ajax({
        		url:'getReportInfoById.vm',
        		type:'post',
        		data:{
        			'REPORT_ID':_this.report.REPORT_ID,
        		},
    		dataType: 'json',
    		isShowLoader: true, // 加载动画，参考ths-jquery-ajax-loader.js
    		success:function(json){
    			var datas = json.data;
    				//将结果值绑定
    				_this.param.disable = true;
    				_this.report.REPORT_YEAR = datas.REPORT_TIME;
    				_this.report.REPORT_NAME = datas.REPORT_NAME;
    				_this.report.FIELD1 = datas.FIELD1;
    				_this.report.FIELD2 = datas.FIELD2;
    				_this.report.FIELD3 = datas.FIELD3;
    				_this.report.FIELD4 = datas.FIELD4;
    				_this.report.FIELD5 = datas.FIELD5;
    		},
    		error:function(){
    			DialogUtil.showTipDialog('系统繁忙，请稍后重试！');
    			}
        	}),
        	$.ajax({
        		url:'getUploadFileInfoById.vm',
        		type:'post',
        		data:{
        			'REPORT_ID':_this.report.REPORT_ID,
        		},
    		dataType: 'json',
    		isShowLoader: true, // 加载动画，参考ths-jquery-ajax-loader.js
    		success:function(json){
    			var datas = json.data;
    				//将结果值绑定
    				_this.report.fileList = datas;
    		},
    		error:function(){
    			DialogUtil.showTipDialog('系统繁忙，请稍后重试！');
    			}
        	})
    	},
    	templateDownload:function(){
			window.location.href=this.urls.downloadTemplateUrl+"?desigerid=12,13,14,15"
    	},
    	uploadExcel:function(){
    		if(!this.report.REPORT_YEAR){
				DialogUtil.showTipDialog("请先填写填报年份，再导入数据!");
				return;
			}
			
			if(!this.report.REPORT_NAME){
				DialogUtil.showTipDialog("请先填写源解析名称，再导入数据!");
				return;
			}
			
			dialog({
				id:"dialog-import",
	            title: '导入Excel数据',
	            url: this.urls.uploadExcelUrl+'?desigerid=12,13,14,15&callbackClass=DistinctHandleSourceResolveService&SEASON_S=S&SEASON_W=W&POLLUTE_TYPE_PM25=PM25&POLLUTE_TYPE_PM10=PM10&REPORT_NAME='+encodeURI(encodeURI(this.report.REPORT_NAME))+'&YEARS='+this.report.REPORT_YEAR+'&ASCRIPTION_ID='+this.report.REPORT_ID,
	            height:200,
	           	cancel:function(){
	           	},
	           	cancelDisplay: false
	        }).showModal();
    	},
    		reportYear:function() {
    			WdatePicker({
    				dateFmt : 'yyyy',
    				el : 'reportYear',
    				maxDate : '#now',
    				isShowClear : true,
    				onpicking : function(dp) {
    					vue.report.REPORT_YEAR = dp.cal.getNewDateStr();
    				},
    				onclearing : function() {
    					vue.report.REPORT_YEAR = '';
    				},
    				readOnly : true
    			});
    		},
    		//保存功能
    		saveData:function(state){
    			var _this = this;
    			// 验证表单
    			var flag = $('#formList').validationEngine('validate');
    			if (!flag) {
    				// 验证不通过，不提交
    				return;
    			}
    			if(_this.report.STATE == 'TEMP'){
    				// 将文件添加到表单数据中(含验证)  指代的是jsp文件中的file-upload-table标签对象
    				var formData = _this.$refs.fileUploadTable.getFileFormData();
    				if (!formData) {
    					return;
    				}
    				// 验证通过，提交到后台
    				var tipMessage = _this.getSaveTipMessage(state);
    				DialogUtil.showConfirmDialog(tipMessage.confirmMessage, function () {
    					_this.report.STATE = state;
    					// 将基础数据添加到表单数据中
    					formData = _this.appendBaseDataToForm(formData);
    					AjaxUtil.sendFileUploadAjaxRequest(_this.urls.saveReportUrl,formData, function () {
    						DialogUtil.showTipDialog(tipMessage.successMessage, function () {
    							_this.cancel(true);
    						}, function () {
    							_this.cancel(true);
    						});
    					});
    				});
    			}else{
    				DialogUtil.showTipDialog(_this.getSaveTipMessage(state).sureMessage);
    			}
    		},
    		/**
    		 * 获取保存提示信息
    		 */
    		getSaveTipMessage: function (state) {
    			var tipMessage = null;
    			if (state === 'UPLOAD') {
    				tipMessage = {
    					confirmMessage: '提交选中的数据，提交成功后将不能编辑和删除，请确认！',
    					successMessage: '提交成功！',
    					sureMessage:'请先导入文件，再提交!',
    				}
    			}else{
    				tipMessage = {
    					confirmMessage: '暂存数据，请确认！',
    					successMessage: '暂存成功！',
    					sureMessage:'请先导入文件，再暂存!',
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
    		 * 取消
    		 * 
    		 */
    		cancel:function(isParentRefresh) {
    			if (window.parent && window.parent.vue.closePageDialog) {
    				if (isParentRefresh != true && isParentRefresh != false) {
    					isParentRefresh = false;
    				}
    				// 调用父页面的关闭方法
    				window.parent.vue.closePageDialog(isParentRefresh);
    			} else {
    				window.history.go(-1);
    			}
    		}
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


jQuery(function($) {
	$("#formList").validationEngine({
		scrollOffset : 98,//必须设置，因为Toolbar position为Fixed
		promptPosition : 'bottomLeft',
		autoHidePrompt : true
	});

});

//关闭dialog
function closeDialog(id,state){
	//表示成功导入数据关闭弹窗
	if(state == 'success'){
		vue.report.STATE = 'TEMP';
		vue.param.disable = true;
	}
	
	dialog.get(id).close().remove();
}





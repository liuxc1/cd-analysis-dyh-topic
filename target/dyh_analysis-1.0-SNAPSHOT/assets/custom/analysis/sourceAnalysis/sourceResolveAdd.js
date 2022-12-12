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
    data:function(){
        return {
        	param:{
        		REPORT_YEAR:DateTimeUtil.getNowYear(),
        		REPORT_NAME:'',
        		FIELD1:'',
        		FIELD2:'',
        		FIELD3:'',
        		FIELD4:'',
        		FIELD5:'',
        		FIELD6:'',
        		REPORT_ID:id,
        		STATE:state,
        		disable:false
        	},
        	urls:{
        		downloadTemplateUrl:ctx+'/analysis/sourceanalysis/templateDownload.vm',
        		uploadExcelUrl:ctx+'/eform/exceltemplate/goupload.vm'
        	}
        }
    },
    /**
     * 页面加载完成后执行
     */
    mounted: function() {
    	var _this = this;
    	//如果是添加页面就退出停止执行
    	if(!_this.param.STATE){
    		return;
    	}
    	$.ajax({
    		url:'queryReportListById.vm',
    		type:'post',
    		data:{
    			'REPORT_ID':_this.param.REPORT_ID,
    		},
		dataType: 'json',
		isShowLoader: true, // 加载动画，参考ths-jquery-ajax-loader.js
		success:function(json){
			var datas = json.data;
				//将结果值绑定
				_this.param.disable = true;
				_this.param.REPORT_YEAR = datas.REPORT_TIME;
				_this.param.REPORT_NAME = datas.REPORT_NAME;
				_this.param.FIELD1 = datas.FIELD1;
				_this.param.FIELD2 = datas.FIELD2;
				_this.param.FIELD3 = datas.FIELD3;
				_this.param.FIELD4 = datas.FIELD4;
				_this.param.FIELD5 = datas.FIELD5;
				_this.param.FIELD6 = datas.FIELD6;
		},
		error:function(){
			DialogUtil.showTipDialog('系统繁忙，请稍后重试！');
			}
    	})
    	
    },
    /**
     * 所有方法
     */
    methods: {
    	reportYear:function(event) {
			WdatePicker({
				dateFmt : 'yyyy',
				el : 'reportYear',
				maxDate : '#now',
				isShowClear : true,
				onpicking : function(dp) {
					vue.param.REPORT_YEAR = dp.cal.getNewDateStr();
				},
				onclearing : function() {
					vue.param.REPORT_YEAR = '';
				},
				readOnly : true
			});
		},
		downloadExcel:function(event){
			window.location.href=this.urls.downloadTemplateUrl+"?desigerid=6,7,8,9,10"

		},
		uploadExcel:function(){
			if(!this.param.REPORT_YEAR){
				DialogUtil.showTipDialog("请先填写填报年份，再导入数据!");
				return;
			}
			
			if(!this.param.REPORT_NAME){
				DialogUtil.showTipDialog("请先填写源解析名称，再导入数据!");
				return;
			}
			
			dialog({
				id:"dialog-import",
	            title: '导入Excel数据',
	            url: this.urls.uploadExcelUrl+'?desigerid=6,7,8,9,10&callbackClass=HandleSourceResolveService&POLLUTE_TYPE_PM25=PM25&POLLUTE_TYPE_PM10=PM10&REPORT_NAME='+encodeURI(encodeURI(this.param.REPORT_NAME))+'&YEARS='+this.param.REPORT_YEAR+'&ASCRIPTION_ID='+this.param.REPORT_ID,
	            height:200,
	           	cancel:function(){
	           	},
	           	cancelDisplay: false
	        }).showModal();
		},
		//暂存记录
		save:function(){
			_this = this;
			if($("#formList").validationEngine('validate')){
				if(_this.param.STATE == 'TEMP'){
					DialogUtil.showConfirmDialog("暂存数据，请确认！",function(){
							AjaxUtil.sendAjaxRequest("save.vm",null,
									{"FIELD1":_this.param.FIELD1,
								"FIELD2":_this.param.FIELD2,
								"FIELD3":_this.param.FIELD3,
								"FIELD4":_this.param.FIELD4,
								"FIELD5":_this.param.FIELD5,
								"FIELD6":_this.param.FIELD6,
								"REPORT_ID":_this.param.REPORT_ID,
								"REPORT_NAME":_this.param.REPORT_NAME,
								},
								function(json){
									//返回的是受影响行数
									if(json.data > 0){
										DialogUtil.showTipDialog("暂存成功！",function(){
											_this.cancel(true);
										},function () {
			    							_this.cancel(true);
			    						});
									} 
								});
					});
				}else{
					DialogUtil.showTipDialog('请先导入文件，再暂存!');
					}
				}
			},
		//提交记录
		submit:function(){
			_this = this;
			if($("#formList").validationEngine('validate')){
				if(_this.param.STATE == 'TEMP'){
				DialogUtil.showConfirmDialog("提交选中的数据，提交成功后将不能编辑和删除，请确认！",function(){
						AjaxUtil.sendAjaxRequest("submit.vm",null,
								{"FIELD1":_this.param.FIELD1,
								"FIELD2":_this.param.FIELD2,
								"FIELD3":_this.param.FIELD3,
								"FIELD4":_this.param.FIELD4,
								"FIELD5":_this.param.FIELD5,
								"FIELD6":_this.param.FIELD6,
								"REPORT_NAME":_this.param.REPORT_NAME,
								"REPORT_ID":_this.param.REPORT_ID},
							function(json){
									//返回的是受影响行数
								if(json.data > 0){
									DialogUtil.showTipDialog("提交成功！",function(){
										_this.cancel(true);
									},function () {
		    							_this.cancel(true);
		    						});
								} 
							});
						});
					}else{
						DialogUtil.showTipDialog('请先导入文件，再提交！');
					}
			}
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
	if(state == 'success'){
		vue.param.STATE = 'TEMP';
		vue.param.disable= true;
	}
	
	dialog.get(id).close().remove();
}





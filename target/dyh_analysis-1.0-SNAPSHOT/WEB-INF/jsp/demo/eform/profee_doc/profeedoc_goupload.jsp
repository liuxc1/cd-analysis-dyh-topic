<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
	<head>
		<title></title>
		<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
		<!--页面自定义的CSS，请放在这里 -->
		<style>
			.padding_1 {
				padding-left: 0px;
				padding-right: 0px;
				padding-top: 1px;
				padding-bottom: 1px;
			}
		</style>
		<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
		<script src="${ctx}/assets/js/ace-elements.js?v=20221129015223"></script>
		<script src="${ctx}/assets/components/jquery/dist/jquery.form.js?v=20221129015223"></script>
		<script src="${ctx }/assets/components/jquery/dist/ajaxfileupload.js?v=20221129015223" type="text/javascript"></script>
	</head>
	<body class="no-skin">
				<div>
					<div class="page-toolbar align-right">
					    <button type="button" class="btn btn-xs    btn-xs-ths" id="btnSave" onclick="doExport();">
							<i class="ace-icon fa fa-save"></i> 下载模板
						</button>
						<button type="button" class="btn btn-xs    btn-xs-ths" id="btnSave" onclick="saveFormInfo();">
							<i class="ace-icon fa fa-save"></i> 导入
						</button>
						<button type="button" class="btn btn-xs btn-xs-ths" onclick="window.parent.closeDialog('dialog-import')">
							<i class="ace-icon fa fa-reply"></i> 取消
						</button>
					</div>
				</div>
		<div class="main-container" id="main-container">
			<div class="main-content">
				<div class="main-content-inner padding-page-content">
					<div class="page-content">
						<form class="form-horizontal" role="form" id="formInfo" action="" method="post">
							<div class="row">
								<div class=" col-xs-12" id="formHtml">
									 <div class="form-group">
		                                <div style="width:98%">
		                             		<label style="width:100%">
		                                     	<input type="file" id="excelfile" name="excelfile" data-validation-engine="validate[required]" onchange="changeFile(this)" style="width:100%;height:25px;">
		                              		</label>
		                                </div>
		                            </div>
								</div>
							</div>
						</form>
						<form class="form-horizontal" style="display: none" id="downform" action="${ctx}/eform/exceltemplate/downloaderror.vm" method="post" target="downloadiframe">
							<input id="errorTempFileName" name="errorTempFileName" type="hidden" value="">
							<input id="errorFileName" name="errorFileName" type="hidden" value="">
							<div class="row">
								<div class=" col-xs-12" id="formHtml">
									 <div class="form-group">
		                                <div style="width:98%">
		                             		<label style="width:100%">
		                                     	 <a href="javascript:void(0)" id="errorMessage" onclick="downloadErrorExcel()">
		                                           下载错误文件
		                                       	 </a>
		                              		</label>
		                                </div>
		                            </div>
								</div>
							</div>
						</form>
						<iframe id="downloadiframe" name="downloadiframe" style="display: none"></iframe>
						<!-- /.row -->
					</div>
				</div>
			</div>
		</div>
	
		<!-- 自己写的JS，请放在这里 -->
		<script type="text/javascript">
		function saveFormInfo(){
			var id = "excelfile";
			if($("#formInfo").validationEngine('validate')){
				var variables = JSON.parse('${variables}');
				variables.inputFileId = id;
				$.ajaxFileUpload({
	        			url:'${ctx}/eform/exceltemplate/upload.vm', //用于文件上传的服务器端请求地址
	                   	secureuri: false, //是否需要安全协议，一般设置为false
	                    fileElementId: id, //文件上传域的ID
	                    dataType: 'json', //返回值类型 一般设置为json
	                    data: variables,
	                    type:'post',
	                    success: function (data) {//服务器成功响应处理函数
	                    	if(data.checked == true){
	                    		$("#downform").hide();
	                    		dialog({
		        		            title: '提示',
		        		            content: '数据导入成功',
		        		            wraperstyle:'alert-info',
		        		            ok: function () {window.parent.closeDialog('dialog-import');}
		        		        }).showModal();
	                    	}else{
	                    		$("#downform").show();
	                    		var fileName = $(".ace-file-name").attr("data-title");
	                    		$("#errorFileName").val(fileName.substring(0, fileName.lastIndexOf(".")) + "_错误" + fileName.substring(fileName.lastIndexOf(".")));
	                    		$("#errorTempFileName").val(data.errorTempFileName);
	                    		document.getElementById("errorMessage").innerHTML = data.errorMessage;
								// ajax得这个上传组件 每次上传都会将input[type='file']标签替成自己
								// 创建得无绑定事件元素所以这里重新绑定一下
	                    		$("#excelfile").attr("onchange", "changeFile(this);");
	                    	}
	                    },
	                    error: function (data,e) {//服务器响应失败处理函数
	                    	dialog({
	        		            title: '提示',
	        		            content: '' + e,
	        		            wraperstyle:'alert-info',
	        		            ok: function () {}
	        		        }).showModal();
	                    }
	         	});
			}
		}
		
		function downloadErrorExcel(){
			$("#downform").submit();
		}
		//下载excel模板
		function doExport(){
			window.location.href = "${ctx}/eform/exceltemplate/download.vm?desigerid=2";
		}
		
	 	$("#formInfo").validationEngine({
            scrollOffset: 98,//必须设置，因为Toolbar position为Fixed
            promptPosition: 'bottomLeft',
            autoHidePrompt: true,
            validateNonVisibleFields:true
        });
		$('#excelfile').ace_file_input({
			no_file:'请选择Excel文件...',
			btn_choose:'选择',
			btn_change:'选择',
			droppable:false,
			onchange:null,
			thumbnail:false //| true | large
			//whitelist:'gif|png|jpg|jpeg'
			//blacklist:'exe|php'
			//onchange:''
			//
		});
		//文件名变更，解决ajaxfileupload导致文件名不更新问题
		function changeFile(obj){
			var fileName = $(obj).val();
			$('#excelfile').parent().find("span.ace-file-container").addClass("selected");
			$(obj).parent().find("span.ace-file-name").attr("data-title", fileName.substring(fileName.lastIndexOf("\\") + 1))
		}

		$(function(){
			$('#excelfile').on("input",function (e) {
				var fileName = $('#excelfile').val();
				$('#excelfile').parent().find("span.ace-file-container").addClass("selected");
				$('#excelfile').parent().find("span.ace-file-name").attr("data-title", fileName.substring(fileName.lastIndexOf("\\") + 1))
			})
			$('#excelfile').parent().find("a.remove").on(ace.click_event,function () {
				$('#excelfile').val("");
				$('#excelfile').parent().find("span.ace-file-name").attr("请选择Excel文件...");
			});
		});
		</script>
	</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
	<head>
		<title></title>
		<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
		<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
		<!--页面自定义的CSS，请放在这里 -->
		<style type="text/css">
			html,body{
				width: 100%;
				height: 100%;
			}
			div .page-content {
				padding: 8px 0px 24px;
			}
		</style>
	</head>

	<body class="no-skin"  style="overflow-x: hidden; overflow-y:hidden">
		<div class="main-container" id="main-container">
			<div class="main-content">
				<div class="main-content-inner fixed-page-header" style="display: none;">
		            <div id="breadcrumbs" class="breadcrumbs">
		                <ul class="breadcrumb">
		                    <li class="active">
		                        <h5 class="page-title" >
		                            <i class="fa fa-file-text-o"></i>
									编辑页
		                        </h5>
		                    </li>
		                </ul><!-- /.breadcrumb -->
		            </div>
		        </div>
		      	<div class="main-content-inner padding-page-content">
					<div class="page-content">
						<div class="space-4"></div>
						<div class="row">
							<div class="col-xs-12">
								<c:choose>
									<c:when test="${taskId != null || processDefKey != null}">
										<div id="toolbarDiv">
								           	<script type="text/javascript">
								           		$("#toolbarDiv").load("${ctx }/console/toolbar.vm?taskId=${taskId}&processDefKey=${processDefKey}&_t=" + new Date().getTime());
								           	</script>
								        </div>
									</c:when>
									<c:otherwise>
										<%@ include file="toolbar/listhtml_edit_btn_toolbar.jsp" %>
									</c:otherwise>
								</c:choose>
								<iframe name="eformForm" id="eformForm" style="width: 100%; height: 100%; border: 0px;"></iframe>
								<form action="${ctx }/eform/formdesign/formdesign_main_desgin_formhtml.vm?form_id=${formId}" method="post" target="eformForm" id="iframePostForm">
								</form>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</body>
	
	<script type="text/javascript">
		function resizeIframe() {
			$('#eformForm').height($(window).height() - 100);
		}
	   	document.getElementById('eformForm').onload = resizeIframe;
	   	window.onresize = resizeIframe;
		//客户端表单页面提供saveForm(instanceid)方法，供toolbar.jsp办理任务提交时调用
		function saveForm(instanceid){
			if(instanceid == null || instanceid == ""){
				dialog({
		            title: '提示',
		            content: '流程实例ID不存在，请检查错误原因',
		            wraperstyle:'alert-info',
		            ok: function () {}
		        }).showModal();
				return false;
			}
			var result = false;
			var eformFormWindow = document.getElementById("eformForm").contentWindow;
			if(!eformFormWindow.jdp_eform_getValidate()){
				return false;
			}
			eformFormWindow.jdp_eform_uploadFile(function(uploadResponse){
				$.ajax({
			        url: '${ctx}/eform/formdesign/formdesign_main_desgin_listhtml_save.vm',
			        type: "post",
			        dataType: "text",
			        async: false,
			        data: $(eformFormWindow.document).find("#formInfo").serialize() + "&table[\'${mainTableCode}\'].column[\'INSTANCE_ID\']="+instanceid,
			        success:function (response) {
			        	if(response == "success"){
			        		eformFormWindow.jdp_eform_updateFileBusinessKey(uploadResponse, eformFormWindow.getBusinessKey(), function(){
			        			result = true;
			        		});
			    		}else{
			    			dialog({
								title: '错误',
								icon:'fa-times-circle',
								wraperstyle:'alert-warning',
								content: response,
								ok: function () {}
							}).showModal();
			    		}
					}
			    });
			});
		    return result; //返回true，流程才会继续执行
		}	
	
		//执行工作流相关操作成功后回调
		function processBack(type,activitiCode) {
	        //type，0:暂存；1：提交；2：退回；3：转办；4：阅读；5：撤回；6：终止流程, undifined: 返回
	        //activitiCode:下一节点编码，多个以逗号分隔
	        console.log(type);
	        console.log(activitiCode);
	        parent.doSearch();
		}
		
		//提供流程变量的方法，需要用户根据自己情况返回
		//示例：{"userId": "admin"}
		function processVariables(){
			var params = $(document.getElementById("eformForm").contentWindow.document).find("#formInfo").serializeArray();
			var json = {};
			for(var i = 0; i < params.length; i++){
				json[params[i].name] = params[i].value.replace(/&/g, "");
			}
			console.log(JSON.stringify(json));
			json.PRO_STATUS = 1; //此句是为jialin_process_8流程传递变量
			return json;
		}
		
		//提供流程Title名称
		function processTitle(){
			return "测试标题";
		}
		
		$(function(){
			var formParam = "${formParam}".split("&");
			for(var i = 0; i < formParam.length; i++){
				var my_input = $('<input type="hidden" name="' + formParam[i].split("=")[0] + '" value="' + formParam[i].split("=")[1] + '"/>');  
				$("#iframePostForm").append(my_input);
			}
		    $("#iframePostForm").submit();
		});
	</script>
</html>

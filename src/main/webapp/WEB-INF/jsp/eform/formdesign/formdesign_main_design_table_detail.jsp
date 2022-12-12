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
									详情页
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
								<%@ include file="toolbar/listhtml_edit_btn_toolbar.jsp" %>
								<iframe name="eformForm" id="eformForm" style="width: 100%; height: 94%; border: 0px;"></iframe>
								<form method="post" target="eformForm" id="iframePostForm">
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
	   	document.getElementById('eformForm').onload = changeReadonly;
	   	window.onresize = resizeIframe;
		$(function(){
			$("#btnSave").hide();
			var url = "${ctx }/eform/formdesign/formdesign_main_desgin_formhtml.vm?form_id=${formId}&isDetail=true";
			if("${formParam}" != ""){
				url += "&${formParam}";
			}
			$("#iframePostForm").attr("action", ths.urlEncode4Get(url));
			$("#iframePostForm").submit();
		});
		
		function changeReadonly(){
			resizeIframe();
			$(document.getElementById('eformForm').contentWindow.document).find("select,button,input[type!='text']").prop("disabled",true);
			$(document.getElementById('eformForm').contentWindow.document).find("input[type='text'],textarea").prop("readonly",true);
			$(document.getElementById('eformForm').contentWindow.document).find("input[type='text'],textarea").prop("onclick","");
		}
	</script>
</html>

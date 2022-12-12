<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
	<head>
		<title></title>
		<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
		<!-- webuploader Css -->
		<link rel="stylesheet" type="text/css" href="${ctx}/assets/components/webuploader/webuploader.css?v=20221129015223">
		<link rel="stylesheet" href="${ctx}/assets/js/eform/eform_custom.css?v=20221129015223">
		<!--判断是否加载设计模式 css -->
		<c:if test="${isdesign == true }">
			<link rel="stylesheet" href="${ctx}/assets/js/eform/eform_design.css?v=20221129015223">
		</c:if>
		<!--页面自定义的CSS，请放在这里 -->
		<style>
			.padding_1 {
				padding-left: 0px;
				padding-right: 0px;
				padding-top: 1px;
				padding-bottom: 1px;
			}
			
			.form-group.initrow.selected {
				display: block;
				border: 2px red dashed;
			}
			/* some elements used in demo only */
			.dropdown-preview {
				margin: 0 5px;
				display: inline-block;
				z-index: 999;
			}
			
			.dropdown-preview>.dropdown-menu {
				display: block;
				position: static;
				margin-bottom: 5px;
				min-width: 110px;
				z-index: 999;
			}
			
			.formcell-label {
				text-align: center;
				position: relative;
				z-index: 1;
				padding-left: 12px;
				padding-right: 12px;
			}
			
			.formcell-label :first-child {
				display: inline-block;
				background: #ffffff;
				line-height: 36px;
				font-size: 13px;
			}
			.formcell-label :nth-child(2){
				display: block;
				position: absolute;
				z-index: -1;
				top: 50%;
				left: 12px;
				right: 12px;
				border-top: 1px solid #eeeeee;
			}
			span.padding_1 > label.col-sm-0.control-label{
				display: none;
			}
			
			.tags > .tag > span{
				word-break: keep-all;
			    white-space: nowrap;
			    overflow: hidden;
			    text-overflow: ellipsis;
			    display: block;
			}
			
			.formTable{
				width: 100%; 
				border: 0px;
			}
			
			.formTable .control-label{
				padding-left: 0px;
			}
			
			.formTable .checkbox-inline{
				padding-right: 0px;
			}
			
			.formTable tr.data_tr{
				height: 38px;
			}
			
			.formTable td{
				border: 1px solid #000000;
			}
			
			.formTable td[cell_index] > span > div{
				padding-left: 0px;
				padding-right: 0px;
			}
		</style>
		<style>
			.procedureTable{
				table-layout: fixed;
				width: 100%;
			}
			
			.procedureTable > thead > tr > th{
				text-align: center;
			}
			
			.procedureTable > tbody > tr > td{
				vertical-align: middle;
			}
			
			td > .procedureTable > tbody > tr > td{
				border: none !important;
			}
		</style>
		<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
		<script type="text/javascript" src="${ctx }/assets/components/jquery-ui/jquery-ui.js?v=20221129015223"></script>
		<!--判断是否加载设计模式 js-->
		<c:if test="${isdesign == true }">
			<script type="text/javascript" src="${ctx}/assets/js/eform/eform_design.js?v=20221129015223"></script>
		</c:if>
		<!-- webuploader Js -->
		<script type="text/javascript" src="${ctx}/assets/components/webuploader/webuploader.js?v=20221129015223"></script>
		<script src="${ctx}/assets/js/eform/eform_uploader.js?v=20221129015223"></script>
	</head>

	<body class="no-skin">
	
		<div class="main-container" id="main-container">
			<div class="main-content">
				<div class="main-content-inner padding-page-content">
					<div class="page-content">
						<form class="form-horizontal" role="form" id="formInfo" action="" method="post">
							<div class="row">
								<div class=" col-xs-12" id="formHtml">
									${formHtml}
								</div>
							</div>
						</form>
						<!-- /.row -->
					</div>
				</div>
				<!--/.main-content-inner-->
			</div>
			<!-- /.main-content -->
		</div>
		<!-- /.main-container -->
		<!-- 右键菜单 -->
		<div class="dropdown dropdown-preview" id="mouseRightDiv" style="position: absolute; display: none;">
			<ul class="dropdown-menu">
				<li><a href="javascript: void(0);" onclick="jdp_eform_mouseRightClick(2);" id="select_cell"><i class="fa fa-columns" aria-hidden="true"></i>&nbsp;&nbsp;控件属性</a></li>
				<li><a href="javascript: void(0);" onclick="jdp_eform_mouseRightClick(3);" id="select_cell_table"><i class="fa fa-table" aria-hidden="true"></i>&nbsp;&nbsp;子表属性</a></li>
				<li><a href="javascript: void(0);" onclick="jdp_eform_mouseRightClick(1);" id="select_row"><i class="fa fa-bars" aria-hidden="true"></i>&nbsp;&nbsp;行属性</a></li>
				<!-- 表格右键菜单 -->
				<li><a href="javascript: void(0);" onclick="jdp_eform_mouseRightClick('table_td_merge');" id="table_td_merge">合并单元格</a></li>
				<li><a href="javascript: void(0);" onclick="jdp_eform_mouseRightClick('sub_table_cell');" id="sub_table_cell">列属性</a></li>
				<li><a href="javascript: void(0);" onclick="jdp_eform_mouseRightClick('select_table_td_cell');" id="select_table_td_cell">控件属性</a></li>
				<li><a href="javascript: void(0);" onclick="jdp_eform_mouseRightClick('select_table_td');" id="select_table_td">单元格属性</a></li>
				<li><a href="javascript: void(0);" onclick="jdp_eform_mouseRightClick('table_tr_properties');" id="table_tr_properties">行属性</a></li>
				<li><a href="javascript: void(0);" onclick="jdp_eform_mouseRightClick('select_table');" id="select_table">表格属性</a></li>
			</ul>
		</div>
		<script type="text/javascript" src="${ctx}/assets/js/eform/eform_custom.js?v=20221129015223"></script>
		<!-- 自己写的JS，请放在这里 -->
		<script type="text/javascript">
			//加载load页面
			jdp_eform_initLoadUrl("${form_id}", "${businessKey}");
			
			function getBusinessKey(){
				return "${businessKey}";
			}
		
			function jdp_eform_getValidate(){
				return $("#formInfo").validationEngine('validate');
			}
		
			$(function() {
				//初始化上传控件
			    jdp_eform_initFileWebUploader("${businessKey}");

				var _handleState = '${handleState}';
				//如果是已办任务查看页面，需要将页面设置为不可编辑
				if (_handleState == 'V_JDP_BPM_DONE_TASKS') {
					$("#formHtml").find("select,button,input[type!='text']")
							.prop("disabled", true);
					$("#formHtml").find("input[type='text'],textarea").prop(
							"readonly", true);
					$("#formHtml").find("button,input,select,textarea,a").css(
							"pointer-events", "none");
					//ie9-10下pointer-events样式无效，手工去除onclick事件及validate校验
					$("#formHtml").find("button,input,select,textarea,a")
							.removeAttr("onclick");
					$("#formHtml").find("button,input,select,textarea,a")
							.removeAttr("data-validation-engine");
				}
			});
			
			//去掉页面右键默认菜单 add bylixinda 2017-06-28
			document.oncontextmenu = function() {
				return false;
			};
		</script>
	</body>
</html>
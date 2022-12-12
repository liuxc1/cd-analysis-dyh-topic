<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
	<head>
	    <title>表单导出</title>
		<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
	  	<!--页面自定义的CSS，请放在这里 -->
	    <style type="text/css">
			.profile-info-value{
				padding: 1px !important;
			}
			.profile-info-name{
				text-align: left;
			}
			.profile-info-name1{
				text-align: center;
				background-color: #EDF3F4;
				padding: 6px 10px 6px 4px;
				vertical-align: middle;
			}
			.jsppath{
				border-right: 0px solid;
    			background: #fff !important;
			}
	    </style>
	</head>
	<body class="no-skin">
		<div class="main-container" id="main-container">
		    <div class="main-content">
		        <div class="main-content-inner fixed-page-header fixed-40">
		            <div class="page-toolbar align-right">
		                <button type="button" class="btn btn-xs btn-success btn-xs-ths" id="btnSubmit"  data-self-js="doSubmit()">
		                    <i class="ace-icon fa fa-check"></i>确认
		                </button>
		                <button type="button" class="btn btn-xs btn-danger btn-xs-ths" id="btnReturn" data-self-js="window.parent.closeDialog('dialog-export')">
		                    <i class="ace-icon fa fa-reply"></i>返回
		                </button>
		                <div class="space-2"></div>
		                <hr class="no-margin">
		            </div>
		
		        </div>
		        <div class="main-content-inner padding-page-content">
		            <div class="page-content">
		                <div class="row">
		                    <div class=" col-xs-12">
		                        <form class="" id="formInfo" action="" method="post">
		                        	<input type="hidden" name="id" value="${formId }"/>
		                        	<div class="profile-user-info profile-user-info-striped" style="border-left: 0px; border-right: 0px; border-bottom: 0px; width: 100%;">
										<input type="hidden" name="metaTableId" value="${metaTable.tableId }"/>
										<div class="profile-info-row">
											<div class="profile-info-name">
												<i class="ace-icon fa fa-asterisk red smaller-70"></i>
												工程名：
											</div>
											<div class="profile-info-value">
												<input type="text" id="project" name="project" class="form-control" data-validation-engine="validate[required,funcCall[checkProject]]"
														value="demo" onkeyup="changeClassPath();"/>
											</div>
										</div>
										<div class="profile-info-row">
											<div class="profile-info-name">子包名：</div>
											<div class="profile-info-value">
												<input type="text" id="subPackage" name="subPackage" class="form-control" data-validation-engine="validate[funcCall[checkSubPackage]]"
												 		value="test.test" onkeyup="changeClassPath();"/>
											</div>
										</div>
										<div class="profile-info-row">
											<div class="profile-info-name">
												${metaTable.tableCode }
											</div>
											<div class="profile-info-name1">类路径</div>
										</div>
										<div class="profile-info-row">
											<div class="profile-info-name">
												<i class="ace-icon fa fa-asterisk red smaller-70"></i>
												Controller
											</div>
											<div class="profile-info-value">
												<input type="text" name="controllerClassPackage" class="form-control controller" data-validation-engine="validate[required]"
														value="ths.jdp.airinv.web.test.test.${metaTable.tableState }Controller.java"/>
											</div>
										</div>
										<div class="profile-info-row">
											<div class="profile-info-name">
												<i class="ace-icon fa fa-asterisk red smaller-70"></i>
												Service
											</div>
											<div class="profile-info-value">
												<input type="text" name="serviceClassPackage" class="form-control service" data-validation-engine="validate[required]" 
														value="ths.jdp.airinv.service.test.test.${metaTable.tableState }Service.java"/>
											</div>
										</div>
										<div class="profile-info-row">
											<div class="profile-info-name">
												<i class="ace-icon fa fa-asterisk red smaller-70"></i>
												Model
											</div>
											<div class="profile-info-value">
												<input type="text" name="modelClassPackage" class="form-control model" data-validation-engine="validate[required]" 
														value="ths.jdp.airinv.model.test.test.${metaTable.tableState }.java"/>
											</div>
										</div>
										<div class="profile-info-row">
											<div class="profile-info-name">
												<i class="ace-icon fa fa-asterisk red smaller-70"></i>
												Mapper
											</div>
											<div class="profile-info-value">
												<input type="text" name="mapperClassPackage" class="form-control mapper" data-validation-engine="validate[required]" 
														value="ths.jdp.airinv.mapper.test.test.${metaTable.tableState }Mapper"/>
											</div>
										</div>
										<div class="profile-info-row">
											<div class="profile-info-name">
												<i class="ace-icon fa fa-asterisk red smaller-70"></i>
												Jsp
											</div>
											<div class="profile-info-value">
												<table style="width: 100%;">
													<tr>
														<td style="width: 225px;">
															<input type="text" class="form-control jsppath" readonly="readonly" value="src/main/webapp/WEB-INF/jsp/"/>
														</td>
														<td>
															<input type="text" name="listJsp" class="form-control jsp" data-validation-engine="validate[required]" 
																	value="demo/test/test/${fn:toLowerCase(metaTable.tableState)}_list.jsp"/>
														</td>
													</tr>
													<tr>
														<td>
															<input type="text" class="form-control jsppath" readonly="readonly" value="src/main/webapp/WEB-INF/jsp/"/>
														</td>
														<td>
															<input type="text" name="editJsp" class="form-control jsp" data-validation-engine="validate[required]" 
																	value="demo/test/test/${fn:toLowerCase(metaTable.tableState)}_edit.jsp"/>
														</td>
													</tr>
													<tr>
														<td>
															<input type="text" class="form-control jsppath" readonly="readonly" value="src/main/webapp/WEB-INF/jsp/"/>
														</td>
														<td>
															<input type="text" name="detailJsp" class="form-control jsp" data-validation-engine="validate[required]" 
																	value="demo/test/test/${fn:toLowerCase(metaTable.tableState)}_detail.jsp"/>
														</td>
													</tr>
												</table>
											</div>
										</div>
										<c:if test="${form.bpmProcKey != null }">
											<div class="profile-info-row">
												<div class="profile-info-name">
													<i class="ace-icon fa fa-asterisk red smaller-70"></i>
													BpmJsp
												</div>
												<div class="profile-info-value">
													<table style="width: 100%;">
														<tr>
															<td style="width: 225px;">
																<input type="text" class="form-control jsppath" readonly="readonly" value="src/main/webapp/WEB-INF/jsp/"/>
															</td>
															<td>
																<input type="text" name="bpmListJsp" class="form-control jsp" data-validation-engine="validate[required]" 
																		value="demo/test/test/${fn:toLowerCase(metaTable.tableState)}_bpmlist.jsp"/>
															</td>
														</tr>
														<tr>
															<td>
																<input type="text" class="form-control jsppath" readonly="readonly" value="src/main/webapp/WEB-INF/jsp/"/>
															</td>
															<td>
																<input type="text" name="bpmEditJsp" class="form-control jsp" data-validation-engine="validate[required]" 
																		value="demo/test/test/${fn:toLowerCase(metaTable.tableState)}_bpmedit.jsp"/>
															</td>
														</tr>
														<tr>
															<td>
																<input type="text" class="form-control jsppath" readonly="readonly" value="src/main/webapp/WEB-INF/jsp/"/>
															</td>
															<td>
																<input type="text" name="bpmDetailJsp" class="form-control jsp" data-validation-engine="validate[required]" 
																		value="demo/test/test/${fn:toLowerCase(metaTable.tableState)}_bpmdetail.jsp"/>
															</td>
														</tr>
													</table>
												</div>
											</div>
										</c:if>
										<c:forEach var="item" items="${subMetaTableList }">
											<input type="hidden" name="subInfo['${item.tableId }'].metaTableId" value="${item.tableId }"/>
											<div class="profile-info-row">
												<div class="profile-info-name">
													${item.tableCode }
												</div>
												<div class="profile-info-name1">类路径</div>
											</div>
											<div class="profile-info-row">
												<div class="profile-info-name">
													<i class="ace-icon fa fa-asterisk red smaller-70"></i>
													Service
												</div>
												<div class="profile-info-value">
													<input type="text" name="subInfo['${item.tableId }'].serviceClassPackage" class="form-control service" data-validation-engine="validate[required]" 
															value="ths.jdp.airinv.service.test.test.${item.tableState }Service.java"/>
												</div>
											</div>
											<div class="profile-info-row">
												<div class="profile-info-name">
													<i class="ace-icon fa fa-asterisk red smaller-70"></i>
													Model
												</div>
												<div class="profile-info-value">
													<input type="text" name="subInfo['${item.tableId }'].modelClassPackage" class="form-control model" data-validation-engine="validate[required]" 
															value="ths.jdp.airinv.model.test.test.${item.tableState }.java"/>
												</div>
											</div>
											<div class="profile-info-row">
												<div class="profile-info-name">
													<i class="ace-icon fa fa-asterisk red smaller-70"></i>
													Mapper
												</div>
												<div class="profile-info-value">
													<input type="text" name="subInfo['${item.tableId }'].mapperClassPackage" class="form-control mapper" data-validation-engine="validate[required]" 
															value="ths.jdp.airinv.mapper.test.test.${item.tableState }Mapper"/>
												</div>
											</div>
										</c:forEach>
									</div>
		                        </form>
		                    </div>
		                </div><!-- /.row -->
		            </div>
		        </div><!--/.main-content-inner-->
		    </div><!-- /.main-content -->
		</div><!-- /.main-container -->

		<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
	
		<!-- 自己写的JS，请放在这里 -->
		<script type="text/javascript">
			function doSubmit(){
				if($("#formInfo").validationEngine('validate')){
					window.parent.doExportZip($("#formInfo").serialize());
				}else{
					if($(".formErrorContent").closest(".panel").find(".panel-heading a.accordion-toggle").attr("aria-expanded") == "false"){
						$(".formErrorContent").closest(".panel").find(".panel-heading a.accordion-toggle").click();
						setTimeout(function(){
							$("#formInfo").validationEngine('updatePromptsPosition');
						}, 400);
					}
				}
			}
			$(function(){
				$("#formInfo").validationEngine({
					scrollOffset : 98,//必须设置，因为Toolbar position为Fixed
					promptPosition : 'bottomLeft',
					autoHidePrompt : true,
					validateNonVisibleFields : true
				});
			});
			
			//检测项目名
			function checkProject(){
				var project = $("#project").val();
				var pattern = /^[a-z]+$/;
				if(!pattern.test(project)){
					return "仅支持小写字母！";
				}
			}
			//检测子包名
			function checkSubPackage(){
				var subPackage = $("#subPackage").val();
				var pattern = /^[a-z\.]+$/;
				if(subPackage != "" && !pattern.test(subPackage)){
					return "仅支持小写字母和点！";
				}
			}
			//变更类路径
			function changeClassPath(){
				var project = $("#project").val().replace(/^\.+/g, "").replace(/\.+$/g, "");
				if(project == ""){
					return;
				}
				var subPackage = $("#subPackage").val().replace(/^\.+/g, "").replace(/\.+$/g, "").replace(/\.+/g, ".");
				var webPkg = "ths.project." + project + ".web";
				var servicePkg = "ths.project." + project + ".service";
				var modelPkg = "ths.project." + project + ".model";
				var mapperPkg = "ths.project." + project + ".mapper";
				var jspPkg = "src/main/webapp/WEB-INF/jsp/" + project;
				if(subPackage != ""){
					webPkg += "." + subPackage;
					servicePkg += "." + subPackage;
					modelPkg += "." + subPackage;
					mapperPkg += "." + subPackage;
					jspPkg += "/" + subPackage.replace(/\./g, "/");
				}
				$(".controller").each(function(){
					$(this).val(webPkg + $(this).val().substring($(this).val().replace(/\.java$/, "").lastIndexOf(".")));
				});
				$(".service").each(function(){
					$(this).val(servicePkg + $(this).val().substring($(this).val().replace(/\.java$/, "").lastIndexOf(".")));
				});
				$(".model").each(function(){
					$(this).val(modelPkg + $(this).val().substring($(this).val().replace(/\.java$/, "").lastIndexOf(".")));
				});
				$(".mapper").each(function(){
					$(this).val(mapperPkg + $(this).val().substring($(this).val().replace(/\.java$/, "").lastIndexOf(".")));
				});
				$(".jsp").each(function(){
					$(this).val(jspPkg + $(this).val().substring($(this).val().lastIndexOf("/")));
				});
			}
		</script>
	</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
	<head>
		<title>下一步</title>
		<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
		<!--页面自定义的CSS，请放在这里 -->
		<style type="text/css">
		</style>
	</head>

	<body class="no-skin">
	
		<div class="main-container" id="main-container">
			<div class="main-content">
				<div class="main-content-inner padding-page-content">
					<div class="page-content">
						<div class="space-4"></div>
						<div class="row">
							<div class=" col-xs-12">
								<form class="form-horizontal" role="form" id="formInfo" action=""
									method="post">
									<div class="form-group">
										<label
											class="col-xs-12 control-label no-padding-right blue" style="text-align:left;"><i class="ace-icon fa fa-asterisk red smaller-70"></i> 办理意见</label>
										<div class="col-xs-12 control-group">
											<textarea class="form-control" id="txtWfComment" data-validation-engine="validate[required,maxSize[160]]"
												placeholder="请输入办理意见，160个字符以内" style="height: 66px;"></textarea>
										</div>
									</div>
									<div class="form-group">
										<label
											class="col-xs-12 control-label no-padding-right blue " style="text-align:left;">退回节点</label>
										<div class="col-xs-12">
											    <c:forEach var="node" items="${interaction.nodes}" varStatus="status">
														<label onclick="showAssigneeDiv(this);"> 
															<input name="radio-task" type="radio" class="ace" value="${node.nodeId}" <c:if test="${status.count==1}">checked</c:if>> 
															<span class="lbl"> ${node.nodeName}</span>
														</label>
												</c:forEach>
												<input type="hidden" name="wf-task-id" value="${interaction.taskId}" />
										</div>
									</div>
									<div class="form-group" id="assigneeDiv">
										<label
											class="col-xs-12 control-label no-padding-right blue" style="text-align:left;">节点办理人</label>
										<div class="col-xs-12">
										    <c:forEach var="node" items="${interaction.nodes}" varStatus="nodeStatus">
										    	<div id="assignee_div_${node.nodeId}" <c:if test="${nodeStatus.count!=1}">style="display: none;"</c:if>>
											        <c:forEach var="item" items="${node.candidates}" varStatus="itemStatus">
															<label><input name="radio-user" type="radio" 
																class="ace" value="${item.LOGIN_NAME}" <c:if test="${nodeStatus.count==1 && itemStatus.count==1}">checked</c:if>> <span class="lbl">
																	${item.USER_NAME} </span> </label>
													</c:forEach>
												</div>
											</c:forEach>
										</div>
									</div>
								</form>
							</div>
						</div>
						<!-- /.row -->
					</div>
				</div>
				<!--/.main-content-inner-->
			</div>
			<!-- /.main-content -->
		</div>
		<!-- /.main-container -->
	
		<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
	
		<!-- 自己写的JS，请放在这里 -->
		<script type="text/javascript">
			function showAssigneeDiv(obj){
				$("#assigneeDiv").find("div[id^='assignee_div_']").each(function(){
					$(this).css("display", "none");
					$(this).find("input").each(function(){
						$(this).removeAttr("name");
					});
				});
				$("#assignee_div_" + $(obj).find("input")[0].value).css("display", "");
				$("#assignee_div_" + $(obj).find("input")[0].value).find("input").each(function(i){
					$(this).attr("name", "radio-user");
					if(i == 0){
						$(this).prop("checked", true);
					}
				});
			}
		
			jQuery(function($) {
				$("#formInfo").validationEngine({
					scrollOffset: 98,//必须设置，因为Toolbar position为Fixed
					promptPosition: 'bottomLeft',
					autoHidePrompt: true
				});
			});

			//校验
			function check(){
				return $('#formInfo').validationEngine('validate');
			}
		</script>
	
	</body>
</html>

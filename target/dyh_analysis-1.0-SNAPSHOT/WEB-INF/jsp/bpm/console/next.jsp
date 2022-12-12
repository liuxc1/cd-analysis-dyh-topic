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
							<form class="form-horizontal" role="form" id="form1" action=""
								method="post">
								<div class="form-group">
									<label class="col-xs-12 control-label no-padding-right blue" style="text-align:left;">办理意见</label>
									<div class="col-xs-12 control-group">
										<textarea class="form-control" id="txtWfComment" data-validation-engine="validate[maxSize[160]]"
											placeholder="请输入办理意见，160个字符以内" style="height: 66px;"></textarea>
									</div>
								</div>
								<div class="form-group">
									<label class="col-xs-12 control-label no-padding-right blue" style="text-align:left;">下一节点</label>
									<div class="col-xs-12">
										<div class="control-group">
											<c:set var="firstCheckRadio" value="true"></c:set>
										    <c:forEach var="node" items="${interaction.nodes}" varStatus="status">
										        <!-- 并行网关 -->
										        <c:choose>
											        <c:when test='${node.nodeType == "GatewayParallel" || node.nodeType == "GatewayInclusive" }'>
											        	<div id="gatewayDiv">
															<label> 
																<input name="radio-task" type="radio"  class="ace" value="${node.nodeId}" <c:if test="${status.count==1}">checked</c:if> onlyView="true"> 
																<span class="lbl"> ${node.nodeName}</span>
															</label>
											       			<input type="hidden" id="gatewayParallelInput" value="true"/>
												           	<c:forEach var="task" items="${node.nodes}" varStatus="nodeStatus">
												           		<c:set var="firstCheckRadio" value="false"></c:set>
													           	<div style="margin-left: 20px;" nodeType="${task.nodeType }">
																	<label> 
																		<input name="radio-task" type="checkbox"  class="ace" value="${task.nodeId}" checked disabled="disabled" onlyView="false"> 
																		<span class="lbl"> ${task.nodeName}</span>
																	</label>
																	<c:if test='${task.nodeType == "SubProcess" }'>
															    		<c:set var="parentNodeId" value="${task.nodeId }"></c:set>
															    		<c:set var="task" value="${task.nodes[0] }"></c:set>
															    	</c:if>
															    	<c:set var="isDisable" value=""></c:set>
															    	<c:set var="inputType" value="radio"></c:set>
															    	<c:choose>
															    		<c:when test="${parentNodeId != null }">
															    			<c:set var="inputType" value="checkbox"></c:set>
																	    	<c:set var="isDisable" value=""></c:set>
															    		</c:when>
															    		<c:otherwise>
																	    	<c:if test='${task.handleType == "handleType_DRBL" }'>
																	    		<c:set var="inputType" value="radio"></c:set>
																	    		<c:set var="isDisable" value=""></c:set>
																	    	</c:if>
																	    	<c:if test='${task.handleType == "handleType_JZBL" }'>
																	    		<c:set var="inputType" value="checkbox"></c:set>
																	    		<c:set var="isDisable" value=""></c:set>
																	    		<c:if test='${interaction.nodeType == "UserTaskMuti" }'>
																	    			<c:set var="isDisable" value="checked disabled='disabled'"></c:set>
																	    		</c:if>
																	    	</c:if>
																	    	<c:if test='${task.handleType == "handleType_DRBXBL" }'>
																	    		<c:set var="inputType" value="checkbox"></c:set>
																	    		<c:set var="isDisable" value=""></c:set>
																	    	</c:if>
																	    </c:otherwise>
																	</c:choose>
															    	<div id="candidate_${parentNodeId != null ? parentNodeId : task.nodeId}" style="margin-left: 20px;">
															    		<c:if test="${task.handleUser.showPerson==true || task.handleUser.useVariable==true}">
																	        <c:forEach var="item" items="${task.candidates}" varStatus="itemStatus">
																				<div class=""  >
																					<label><input name="radio-user-${parentNodeId != null ? parentNodeId : task.nodeId}" type="${inputType}" data-usercodes="${item.LOGIN_NAME}" <c:if test="${inputType == 'checkbox' && status.count==1 && isDisable == '' }">data-validation-engine="validate[minCheckbox[1]]"</c:if>
																						class="ace" value="${item.LOGIN_NAME}" ${isDisable} <c:if test="${inputType == 'radio' && itemStatus.count==1}">checked</c:if>> <span <c:if test='${isDisable == null || isDisable == "" || fn:length(task.candidates) != 1}'>class="lbl"</c:if>>
																							${item.USER_NAME} </span> </label>
																				</div>
																			</c:forEach>
																		</c:if>
																		<c:if test="${task.handleUser.showPerson==false && task.handleUser.useVariable==false}">
																	   		<c:if test="${!empty task.handleUser.user}">
																		                    人员：
																		        <c:forEach var="item" items="${task.handleUser.user}" varStatus="itemStatus">
																						<div class="radio-inline" style="vertical-align: inherit;">
																							<label><input name="radio-user-${parentNodeId != null ? parentNodeId : task.nodeId}" type="${inputType}"  data-usercodes="${item.LOGIN_NAME}" <c:if test="${inputType == 'checkbox' && status.count==1 && isDisable == '' }">data-validation-engine="validate[minCheckbox[1]]"</c:if>
																								class="ace" value="${item.LOGIN_NAME}" ${isDisable} <c:if test="${inputType == 'radio' && nodeStatus.count==1 && itemStatus.count==1}">checked</c:if>> <span <c:if test='${isDisable == null || isDisable == "" || fn:length(task.handleUser.user) != 1}'>class="lbl"</c:if>>
																									${item.USER_NAME} </span> 
																						   </label>
																						</div>
																				</c:forEach>
																				 <br/>
																		   </c:if>
																		   <c:if test="${!empty task.handleUser.dept}">
																		                    部门：
																		        <c:forEach var="item" items="${task.handleUser.dept}" varStatus="itemStatus">
																						<div class="radio-inline" style="vertical-align: inherit;">
																							<label><input name="radio-user-${parentNodeId != null ? parentNodeId : task.nodeId}" type="${inputType}"  data-usercodes="${item.usercodes}" <c:if test="${inputType == 'checkbox' && status.count==1 && isDisable == '' }">data-validation-engine="validate[minCheckbox[1]]"</c:if>
																								class="ace" value="${item.id}" ${isDisable} <c:if test="${inputType == 'radio' && nodeStatus.count==1 && itemStatus.count==1}">checked</c:if>> <span <c:if test='${isDisable == null || isDisable == "" || fn:length(task.handleUser.dept) != 1}'>class="lbl"</c:if>>
																									${item.name} </span> 
																						   </label>
																						</div>
																				</c:forEach>
																				 <br/>
																		   </c:if>
																		   <c:if test="${!empty task.handleUser.role}">
																		                     角色：
																		        <c:forEach var="item" items="${task.handleUser.role}" varStatus="itemStatus">
																						<div class="radio-inline" style="vertical-align: inherit;">
																							<label><input name="radio-user-${parentNodeId != null ? parentNodeId : task.nodeId}" type="${inputType}"  data-usercodes="${item.usercodes}" <c:if test="${inputType == 'checkbox' && status.count==1 && isDisable == '' }">data-validation-engine="validate[minCheckbox[1]]"</c:if>
																								class="ace" value="${item.id}" ${isDisable} <c:if test="${inputType == 'radio' && nodeStatus.count==1 && itemStatus.count==1}">checked</c:if>> <span <c:if test='${isDisable == null || isDisable == "" || fn:length(task.handleUser.role) != 1}'>class="lbl"</c:if>>
																									${item.name} </span> 
																						   </label>
																						</div>
																				</c:forEach>
																				 <br/>
																		   </c:if>
																		    <c:if test="${!empty task.handleUser.usergroup}">
																		                     用户组：
																		        <c:forEach var="item" items="${task.handleUser.usergroup}" varStatus="itemStatus">
																						<div class="radio-inline" style="vertical-align: inherit;">
																							<label><input name="radio-user-${parentNodeId != null ? parentNodeId : task.nodeId}" type="${inputType}"  data-usercodes="${item.usercodes}" <c:if test="${inputType == 'checkbox' && status.count==1 && isDisable == '' }">data-validation-engine="validate[minCheckbox[1]]"</c:if>
																								class="ace" value="${item.id}" ${isDisable} <c:if test="${inputType == 'radio' && nodeStatus.count==1 && itemStatus.count==1}">checked</c:if>> <span <c:if test='${isDisable == null || isDisable == "" || fn:length(task.handleUser.usergroup) != 1}'>class="lbl"</c:if>>
																									${item.name} </span> 
																						   </label>
																						</div>
																				</c:forEach>
																				 <br/>
																		   </c:if>
																		    <c:if test="${!empty task.handleUser.position}">
																		                     岗位：
																		        <c:forEach var="item" items="${task.handleUser.position}" varStatus="itemStatus">
																						<div class="radio-inline" style="vertical-align: inherit;">
																							<label><input name="radio-user-${parentNodeId != null ? parentNodeId : task.nodeId}" type="${inputType}" data-usercodes="${item.usercodes}" <c:if test="${inputType == 'checkbox' && status.count==1 && isDisable == '' }">data-validation-engine="validate[minCheckbox[1]]"</c:if>
																								class="ace" value="${item.id}" ${isDisable} <c:if test="${inputType == 'radio' && nodeStatus.count==1 && itemStatus.count==1}">checked</c:if>> <span <c:if test='${isDisable == null || isDisable == "" || fn:length(task.handleUser.position) != 1}'>class="lbl"</c:if>>
																									${item.name} </span> 
																						   </label>
																						</div>
																				</c:forEach>
																				 <br/>
																		   </c:if>
																   		</c:if>
															   		</div>
															   	</div>
												            </c:forEach>
												        </div>
										    	    </c:when>
										    	    <c:otherwise>
										    	    	<!-- 单人任务-->
												       	<c:if test='${node.nodeType == "UserTaskSingle" }'> 
												       	<c:set var="firstCheckRadio" value="false"></c:set>
															<div class="">
																<label> 
																	<input name="radio-task" type="radio"  class="ace" value="${node.nodeId}" <c:if test="${status.count==1}">checked</c:if>> 
																	<span class="lbl"> ${node.nodeName}</span>
																</label>
															</div>
													   	</c:if> 
													  	<!-- 多人任务 -->
													   	<c:if test='${node.nodeType == "UserTaskMuti" }'>
													   	<c:set var="firstCheckRadio" value="false"></c:set> 
															<div class="">
																<label> 
																	<input name="radio-task" type="radio"  class="ace" value="${node.nodeId}" <c:if test="${status.count==1}">checked</c:if>> 
																	<span class="lbl"> ${node.nodeName}</span>
																</label>
															</div>
													   	</c:if> 
													   	<!-- 子流程任务 -->
													   	<c:if test='${node.nodeType == "SubProcess" }'>
													   	<c:set var="firstCheckRadio" value="false"></c:set> 
															<div class="">
																<label> 
																	<input name="radio-task" type="radio"  class="ace" value="${node.nodeId}" <c:if test="${status.count==1}">checked</c:if>> 
																	<span class="lbl"> ${node.nodeName}</span>
																</label>
															</div>
													   	</c:if> 
													   	<!-- 结束节点 -->
													    <c:if test='${node.nodeType == "EndNode" }'> 
													    <c:set var="firstCheckRadio" value="false"></c:set>
															<div class="">
																<label> 
																	<input name="radio-task" type="radio"  class="ace" value="${node.nodeId}" <c:if test="${status.count==1}">checked</c:if>> 
																	<span class="lbl"> ${node.nodeName}</span>
																</label>
															</div>
													   	</c:if> 
													   	<!-- 子流程结束节点 -->
													   	<c:if test='${node.nodeType == "ChildEndNode" }'>
													       	<div class="">
																<label>
																	<input name="radio-task" type="radio" class="ace" value="${node.nodeId}" <c:if test="${firstCheckRadio}">checked</c:if>>  
																	<span class="lbl"> ${node.nodeName}</span>
																</label>
															</div>
											    	    </c:if>
										    	    </c:otherwise>
									    	    </c:choose>
											</c:forEach>
											<input type="hidden" name="wf-task-id" value="${interaction.taskId}" />
										</div>
									</div>
								</div>
								
								<div class="form-group" id="assigneeDiv">
								    <!-- TODO：1、会签结束后，下一节点默认当竞争办理处理-->
									<label class="col-xs-12 control-label no-padding-right blue" style="text-align:left;">下一办理人</label>
									<div class="col-xs-12 control-group">
										<c:set var="assigneeNodes" value='${fn:length(interaction.nodes) > 0 && interaction.nodes[0].nodeType == "ChildEndNode" ? null : interaction.nodes }'></c:set>
									    <c:forEach var="node" items="${assigneeNodes}" varStatus="nodeStatus">
									    	<c:remove var="parentNodeId"/>
									    	<c:if test='${node.nodeType == "SubProcess" }'>
									    		<c:set var="parentNodeId" value="${node.nodeId }"></c:set>
									    		<c:set var="node" value="${node.nodes[0] }"></c:set>
									    	</c:if>
									    	<c:set var="isDisable" value=""></c:set>
									    	<c:set var="inputType" value="radio"></c:set>
									    	<c:choose>
									    		<c:when test="${parentNodeId != null }">
									    			<c:set var="inputType" value="checkbox"></c:set>
											    	<c:set var="isDisable" value=""></c:set>
									    		</c:when>
									    		<c:otherwise>
									    			<c:if test='${node.handleType == "handleType_DRBL" }'>
											    		<c:set var="inputType" value="radio"></c:set>
											    		<c:set var="isDisable" value=""></c:set>
											    	</c:if>
											    	<c:if test='${node.handleType == "handleType_JZBL" }'>
											    		<c:set var="inputType" value="checkbox"></c:set>
											    		<c:set var="isDisable" value=""></c:set>
											    		<c:if test='${interaction.nodeType == "UserTaskMuti" }'>
															<c:set var="isDisable" value="checked disabled='disabled'"></c:set>
														</c:if>
											    	</c:if>
											    	<c:if test='${node.handleType == "handleType_DRBXBL" }'>
											    		<c:set var="inputType" value="checkbox"></c:set>
											    		<c:set var="isDisable" value=""></c:set>
											    	</c:if>
									    		</c:otherwise>
									    	</c:choose>
									    	
									        <div id="candidate_${parentNodeId != null ? parentNodeId : node.nodeId}" isSubProcess="${parentNodeId != null }" <c:if test="${nodeStatus.count!=1}">style="display:none"</c:if>>
									        <c:if test="${node.handleUser.showPerson==true || node.handleUser.useVariable==true}">
										        <c:forEach var="item" items="${node.candidates}" varStatus="itemStatus">
													<div class="radio-inline">
														<label><input name="radio-user-${parentNodeId != null ? parentNodeId : node.nodeId}" type="${inputType}" data-usercodes="${item.LOGIN_NAME}" <c:if test="${inputType == 'checkbox' && isDisable == '' }">data-validation-engine="validate[minCheckbox[1]]"</c:if>
															class="ace" value="${item.LOGIN_NAME}" ${isDisable} <c:if test="${inputType == 'radio' && itemStatus.count==1}">checked</c:if>> <span <c:if test='${isDisable == null || isDisable == "" || fn:length(node.candidates) != 1}'>class="lbl"</c:if>>
																${item.USER_NAME} </span> </label>
													</div>
												</c:forEach>
											</c:if>
											<c:if test="${node.handleUser.showPerson==false && node.handleUser.useVariable==false}">
											   <c:if test="${!empty node.handleUser.user}">
												                    人员：
												        <c:forEach var="item" items="${node.handleUser.user}" varStatus="itemStatus">
																<div class="radio-inline" style="vertical-align: inherit;">
																	<label><input name="radio-user-${parentNodeId != null ? parentNodeId : node.nodeId}" type="${inputType}" data-usercodes="${item.LOGIN_NAME}" <c:if test="${inputType == 'checkbox' && isDisable == '' }">data-validation-engine="validate[minCheckbox[1]]"</c:if>
																		class="ace" value="${item.LOGIN_NAME}" ${isDisable} <c:if test="${inputType == 'radio' && nodeStatus.count==1 && itemStatus.count==1}">checked</c:if>> <span <c:if test='${isDisable == null || isDisable == "" || fn:length(node.handleUser.user) != 1}'>class="lbl"</c:if>>
																			${item.USER_NAME} </span> 
																   </label>
																</div>
														</c:forEach>
														 <br/>
												   </c:if>
											  <c:if test="${!empty node.handleUser.dept}">
											                    部门：
											        <c:forEach var="item" items="${node.handleUser.dept}" varStatus="itemStatus">
															<div class="radio-inline" style="vertical-align: inherit;">
																<label><input name="radio-user-${parentNodeId != null ? parentNodeId : node.nodeId}" type="${inputType}" data-usercodes="${item.usercodes}" <c:if test="${inputType == 'checkbox' && isDisable == '' }">data-validation-engine="validate[minCheckbox[1]]"</c:if>
																	class="ace" value="${item.id}" ${isDisable} <c:if test="${inputType == 'radio' && nodeStatus.count==1 && itemStatus.count==1}">checked</c:if>> <span <c:if test='${isDisable == null || isDisable == "" || fn:length(node.handleUser.dept) != 1}'>class="lbl"</c:if>>
																		${item.name} </span> 
															   </label>
															</div>
													</c:forEach>
													 <br/>
											   </c:if>
											   <c:if test="${!empty node.handleUser.role}">
											                     角色：
											        <c:forEach var="item" items="${node.handleUser.role}" varStatus="itemStatus">
															<div class="radio-inline" style="vertical-align: inherit;">
																<label><input name="radio-user-${parentNodeId != null ? parentNodeId : node.nodeId}" type="${inputType}" data-usercodes="${item.usercodes}" <c:if test="${inputType == 'checkbox' && isDisable == '' }">data-validation-engine="validate[minCheckbox[1]]"</c:if>
																	class="ace" value="${item.id}" ${isDisable} <c:if test="${inputType == 'radio' && nodeStatus.count==1 && itemStatus.count==1}">checked</c:if>> <span <c:if test='${isDisable == null || isDisable == "" || fn:length(node.handleUser.role) != 1}'>class="lbl"</c:if>>
																		${item.name} </span> 
															   </label>
															</div>
													</c:forEach>
													 <br/>
											   </c:if>
											    <c:if test="${!empty node.handleUser.usergroup}">
											                     用户组：
											        <c:forEach var="item" items="${node.handleUser.usergroup}" varStatus="itemStatus">
															<div class="radio-inline" style="vertical-align: inherit;">
																<label><input name="radio-user-${parentNodeId != null ? parentNodeId : node.nodeId}" type="${inputType}" data-usercodes="${item.usercodes}" <c:if test="${inputType == 'checkbox' && isDisable == '' }">data-validation-engine="validate[minCheckbox[1]]"</c:if>
																	class="ace" value="${item.id}" ${isDisable} <c:if test="${inputType == 'radio' && nodeStatus.count==1 && itemStatus.count==1}">checked</c:if>> <span <c:if test='${isDisable == null || isDisable == "" || fn:length(node.handleUser.usergroup) != 1}'>class="lbl"</c:if>>
																		${item.name} </span> 
															   </label>
															</div>
													</c:forEach>
													 <br/>
											   </c:if>
											    <c:if test="${!empty node.handleUser.position}">
											                     岗位：
											        <c:forEach var="item" items="${node.handleUser.position}" varStatus="itemStatus">
															<div class="radio-inline" style="vertical-align: inherit;">
																<label><input name="radio-user-${parentNodeId != null ? parentNodeId : node.nodeId}" type="${inputType}" data-usercodes="${item.usercodes}" <c:if test="${inputType == 'checkbox' && isDisable == '' }">data-validation-engine="validate[minCheckbox[1]]"</c:if>
																	class="ace" value="${item.id}" ${isDisable} <c:if test="${inputType == 'radio' && nodeStatus.count==1 && itemStatus.count==1}">checked</c:if>> <span <c:if test='${isDisable == null || isDisable == "" || fn:length(node.handleUser.position) != 1}'>class="lbl"</c:if>>
																		${item.name} </span> 
															   </label>
															</div>
													</c:forEach>
													 <br/>
											   </c:if>
											</c:if>
											</div>
										</c:forEach>
									</div>
								</div>
								<!-- 抄送人(兼容旧版数据:抄送人项不为空,且选项设置值不是不允许) -->
								<c:if test="${not empty handleOperate.copyto and 'cancopyto_BYX' ne handleOperate.copyto.cancopyto}">
									<input type="hidden" id="readerLoginNames" value=""/>
									<input type="hidden" id="readerUserNames" value=""/>
									<div class="form-group">
										<label class="col-xs-12 control-label no-padding-right blue" style="text-align:left;">抄送人</label>
										<div class="col-xs-12 control-group">
											<c:if test="${fn:length(handleOperate.copyto.copytoUsers) > 0}">
												<c:forEach items="${handleOperate.copyto.copytoUsers}" var="copytoUser">
													<div class="radio-inline" style="vertical-align: inherit;">
														<label>
															<!-- 强制抄送人--选择不可取消 -->
															<input name="radio-user-copyto" type="checkbox" class="ace" onclick="copytoUserChange()"
																   data-loginname="${copytoUser.code}" data-username="${copytoUser.name}" 
																   <c:if test="${'cancopyto_QZCSR' eq handleOperate.copyto.cancopyto}">checked="checked" disabled="disabled"</c:if>>
															<span class="lbl">${copytoUser.name}</span>
														</label>
													</div>
												</c:forEach>
												<hr/>
											</c:if>
										</div>
									</div>
								</c:if>
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
		// 传阅人:此页面作为抄送人使用
		var readerLoginNames = new Array(), readerUserNames = new Array();
		jQuery(function($) {
			$("#form1").validationEngine({
	            scrollOffset: 98,//必须设置，因为Toolbar position为Fixed
	            promptPosition: 'bottomLeft',
	            autoHidePrompt: true
	        });
			
			//当存在多个任务节点供选择时
			if($('input:radio[name="radio-task"]').length>1){
				$('input:radio[name="radio-task"]').change( function(){
			    	$('input:radio[name="radio-task"]').each(function(){
			    		var candidate_div_id=$(this).val();
			    		if($(this).is(':checked')){
			    			if("true" == $(this).attr("onlyView")){
			    				$(this).closest("div#gatewayDiv").find('input:checkbox[name^="radio-user"]').each(function(){
			    					$(this).attr("data-validation-engine", "validate[minCheckbox[1]]");
			    				});
			    			}
			    			$("#candidate_"+candidate_div_id).show();
			    			$("#candidate_"+candidate_div_id).find('input:radio[name^="radio-user"]').each(function(i){
			    				if(i == 0){
			    					$(this).prop("checked", true);
			    				}
			    			});
			    			//如果没有办理人（结束节点），隐藏办理人div
			    			if($("#candidate_"+candidate_div_id).find('input[name^="radio-user"]').size()==0){
			    				$("#assigneeDiv").hide();
			    			}else{
			    				$("#assigneeDiv").show();
			    			}
			    		}else{
			    			if("true" == $(this).attr("onlyView")){
			    				$(this).closest("div#gatewayDiv").find('input:checkbox[name^="radio-user"]').each(function(){
			    					if($(this).attr('data-validation-engine')){
			    						$(this).removeAttr('data-validation-engine');
			    						$(this).validationEngine('hide');
			    					}
			    				});
			    			}
			    			$("#candidate_"+candidate_div_id).hide();
			    		}
			    	})
			    })
			}
			
			//如果没有办理人（结束节点），移除办理人div
            if( $("#assigneeDiv").find("input[name^='radio-user']").size()==0){
            	$("#assigneeDiv").remove();
            }
			
          	//清空已选传阅人用户
			parent.jdp_bpm_read_selectUsers = [];
            $("#btnChooseUserManager").on(ace.click_event,function(){
            	parent.selectUsers = parent.jdp_bpm_read_selectUsers;
    			//dialog的使用，请参考官方文档http://aui.github.io/artDialog/doc/index.html
    			var url = "${ctx}/common/ou/selUserMuti.html?callback=jdp_bpm_read_selectUserMuti&closeCallback=jdp_bpm_readClose";
    			if("${handleOperate.read.canread }" == "canread_BBM"){ //传阅本部门
    				url += "&orgid=${deptId }&showChildOrg=true";
    			}
    			parent.dialog({
    				id:"jdp-bpm-read-dialog-user-muti",
    	            title: '选择',
    	            url: url,
    	            width:500,
    	            height:400,
    	        }).showModal();
    		});
    		$("#btnChooseUserManagerX").on(ace.click_event,function(){
    			parent.jdp_bpm_read_selectUsers = [];
    			$("#manageUserUl").html("");
    			$("#readerLoginNames").val("");
    	 		$("#readerUserNames").val("");
    		});
    		
    		// 抄送人隐藏域的数据初始化
			<c:if test="${'cancopyto_QZCSR' eq handleOperate.copyto.cancopyto}">
				<c:if test="${fn:length(handleOperate.copyto.copytoUsers) > 0}">
					<c:forEach items="${handleOperate.copyto.copytoUsers}" var="copytoUser">
						readerLoginNames.push('${copytoUser.code}');
						readerUserNames.push('${copytoUser.name}');
					</c:forEach>
					$('#readerLoginNames').val(readerLoginNames.join(","));
					$('#readerUserNames').val(readerUserNames.join(","));
				</c:if>
			</c:if>
		});
		
		function removeUser(loginName){
			$.each(parent.jdp_bpm_read_selectUsers,function(i){
		        if(this.loginName == loginName){
		        	parent.jdp_bpm_read_selectUsers.removeAt(i);
		        	return;
		        }
		    });
		}

		/**
		 * 抄送人选择框的变化
		 */
		function copytoUserChange() {
			readerLoginNames = new Array(), readerUserNames = new Array();
			$('input[name="radio-user-copyto"]:checked').each(function(){
				if ($(this).data('loginname')) {
					readerLoginNames.push($(this).data('loginname'));
					readerUserNames.push($(this).data('username'));
				}
			});
			$('#readerLoginNames').val(readerLoginNames.join(","));
			$('#readerUserNames').val(readerUserNames.join(","));
		}
		//校验
		function check(){
			return $('#form1').validationEngine('validate');
		}
	</script>

</body>
</html>

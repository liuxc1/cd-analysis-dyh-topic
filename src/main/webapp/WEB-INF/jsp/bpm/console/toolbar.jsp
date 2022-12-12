<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>

<div class="page-toolbar align-right">
	<c:if test='${(handleOperate == null || handleOperate.save.cansave == "true") && task.isHistory != true && status != "5" && status != "6" }'>
		<button type="button" class="btn btn-xs btn-primary btn-xs-ths"
			id="btnSave" onclick="save()">
			<i class="ace-icon fa fa-save"></i> ${handleOperate == null ? "暂存" : handleOperate.save.showname }
		</button>
	</c:if>
	<c:if test='${(handleOperate == null || handleOperate.submit.cansubmit == "true") && task.isHistory != true && status != "5" && status != "6" }'>
		<button type="button" class="btn btn-xs btn-success btn-xs-ths"
			id="btnSubmit" onclick="submit()">
			<i class="ace-icon fa fa-check"></i> ${handleOperate == null ? "提交" : handleOperate.submit.showname }
		</button>
	</c:if>
	<c:if test='${(handleOperate != null && handleOperate.revocation.canrevocation == "true") && task.isHistory == true && (status == "2" || status == "4")  }'>
		<button type="button" class="btn btn-xs btn-yellow btn-xs-ths"
			id="btnRevocation" onclick="revocation()">
			<i class="ace-icon fa fa-undo"></i> ${handleOperate == null ? "撤回" : handleOperate.revocation.showname }
		</button>
	</c:if>
	<c:if test='${(handleOperate != null && handleOperate.terminate.canterminate == "true") && task.isHistory != true && status != "5" && status != "6" }'>
		<button type="button" class="btn btn-xs btn-danger btn-xs-ths"
			id="btnTerminate" onclick="terminate()">
			<i class="ace-icon fa fa-minus-circle"></i> ${handleOperate == null ? "终止流程" : handleOperate.terminate.showname }
		</button>
	</c:if>
	<c:if test='${(handleOperate != null && handleOperate.reject.canreject != "canreject_BYX") && task.isHistory != true && status != "5" && status != "6" }'>
		<button type="button" class="btn btn-xs btn-inverse btn-xs-ths"
			onclick="reject('${handleOperate.reject.canreject }','${handleOperate.reject.returnnode }')">
			<i class="ace-icon fa fa-arrow-left"></i> ${handleOperate == null ? "退回" : handleOperate.reject.showname }
		</button>
	</c:if>
	<c:if test='${(handleOperate != null && handleOperate.sendto.cansendto != "cansendto_BYX") && task.isHistory != true && status != "5" && status != "6" }'>
		<button type="button" class="btn btn-xs btn-pink btn-xs-ths"
			onclick="sendto('${handleOperate.sendto.cansendto }')">
			<i class="ace-icon fa fa-exchange"></i> ${handleOperate == null ? "转办" : handleOperate.sendto.showname }
		</button>
	</c:if>
	<c:if test='${(handleOperate != null && handleOperate.read.canread != "canread_BYX") && (status == "1" || status == "2" || status == "3")}'>
		<button type="button" class="btn btn-xs btn-grey btn-xs-ths"
			id="btnRevocation" onclick="readto('${handleOperate.read.canread}')">
			<i class="ace-icon fa fa-share-alt"></i> ${handleOperate == null ? "传阅" : handleOperate.read.showname }
		</button>
	</c:if>
	<c:if test='${canread == true && status == "5"}'>
		<button type="button" class="btn btn-xs btn-grey btn-xs-ths"
			onclick="read()">
			<i class="ace-icon fa fa-book"></i> 阅读
		</button>
	</c:if>
	<c:if test='${canread == false && status == "6"}'>
		<button type="button" class="btn btn-xs btn-grey btn-xs-ths"
			onclick="jdp_bpm_readHistory()">
			<i class="ace-icon fa fa-book"></i> 阅读记录
		</button>
	</c:if>
	<c:if test='${task.processInstanceId != null && task.processInstanceId != "" }'>
		<!-- 
		<button type="button" class="btn btn-xs btn-purple btn-xs-ths"
			id="btnDiagram" onclick="JDP_WF_showDiagram()">
			<i class="ace-icon fa fa-transgender-alt"></i> 流程图
		</button>
		 -->
		<button type="button" class="btn btn-xs btn-dark btn-xs-ths"
			id="btnProcess" onclick="JDP_WF_showHistory()">
			<i class="ace-icon fa fa-transgender-alt"></i> 办理过程
		</button>
	</c:if>
	<button type="button" class="btn btn-xs btn-danger btn-xs-ths"
		id="btnReturn" onclick="bpmCallBack()">
		<i class="ace-icon fa fa-reply"></i> 返回
	</button>
	<div class="space-2"></div>
	<div class="hidden">
		<input type="hidden" name="tool_instanceId" value="${task.processInstanceId}" />
		<input type="hidden" name="tool_processDefKey" value="${processDefKey}" />
		<input type="hidden" name="tool_taskId" value="${task.id}" />
		<input type="hidden" name="tool_taskDefinitionKey" value="${task.taskDefinitionKey}" />
		<input type="hidden" name="tool_processDefinitionId" value="${task.processDefinitionId}" />
	</div>
	<hr class="no-margin">
	<!-- 本部门传阅隐藏域 -->
	<input type="hidden" id="selfDeptUserLoginNames"/>  
	<input type="hidden" id="selfDeptUserNames"/>  
	<!-- 流程相关 -->
	<script type="text/javascript">
		var instanceId = '${task.processInstanceId}';
		var processDefKey = '${processDefKey}';
		var taskId = '${task.id}';
		var taskDefinitionKey = '${task.taskDefinitionKey}';
		var variables= null;//流程变量
		var nextTaskKeys="";
		//启动流程
		function startFlow(){
			
			if(processVariables){
				variables=processVariables();
			}
			var title = processTitle();
			if(title == null || typeof(title)=="undefined"){
				title = "";
			}
			ths.submitFormAjax({
				url : '${ctx}/console/start.vm',
				dataType : "json",
				type: "post",
				async: false,
				data : {processDefKey: processDefKey, title: title, processVariables: JSON.stringify(variables)},
				success : function(wfInteraction) {
					instanceId = wfInteraction.instanceId;
					taskId = wfInteraction.taskId;
				}
			});
		}
		//暂存	
		function save(){
			if (instanceId == "") { //未启动流程
				startFlow();
			}
			//保存业务数据
			if(saveForm){
				if(saveForm(instanceId)){
				   bpmCallBack(0,taskDefinitionKey);
				}
			}else{
				alert("未提供保存业务数据的saveForm(instanceId)函数");
			}
			
		}
		//提交
		function submit() {
			//校验业务表单//保存业务数据
			if(!saveForm){
				alert("未提供保存业务数据的saveForm(instanceId)函数");
			}
			
			//如果不存在流程实例id，先启动流程，默认走到第一步，获取流程实例id,第一个节点的任务id，生成业务id。
			if (instanceId == "") {
				startFlow();
			}
			
			if (saveForm(instanceId)) {
				if(processVariables){
					variables=processVariables();
				}
				var flowForm = "instanceId="
					+ instanceId + "&processDefKey="
					+ processDefKey + "&taskId=" + taskId+"&processVariables=" + encodeURI(encodeURI(JSON.stringify(variables)));
				//获取下一节点及办理人
				dialog({
					id : "dialog-jdp-wf-next",
					title : '请选择',
					url : '${ctx}/console/next.vm?'+flowForm,
					width : 600,
					height : 300 > document.documentElement.clientHeight ? document.documentElement.clientHeight
							: 300,
					ok : function() {
						clearDialogIframe("dialog-jdp-wf-next");
						if(document.getElementsByName('dialog-jdp-wf-next')[0].contentWindow.check()){
							excuteProcess();
						}else{
							return false;
						}
					}
				}).showModal();
			}
		}
		//执行流程
		function excuteProcess() {
			var frameDoc = $(window.frames["dialog-jdp-wf-next"].document);
			var wf = {};
			wf.taskId = frameDoc.find("input[name='wf-task-id']").val();
			var destinationIds = null;
			var destinationAssignees = null;
			frameDoc.find("input[name='radio-task']:checked,input[name='check-task']:checked").each(function(){
				var _this_assignees = null;
				if(destinationIds == null){
					if(!$(this).attr("onlyView") || ("false" == $(this).attr("onlyView") && $(this).closest("div#gatewayDiv").find('input:radio[name="radio-task"]').is(':checked'))){
						destinationIds = $(this).val();
						nextTaskKeys= $(this).val();
					}
					if(frameDoc.find("#gatewayParallelInput").length > 0 && $(this).attr("onlyView") == "false" && $(this).closest("div#gatewayDiv").find('input:radio[name="radio-task"]').is(':checked')){
						var nodeType = $(this).closest("div").attr("nodeType");//SubProcess
						$(this).closest("div").find("input[name^='radio-user']:checked").each(function(){
							if($(this).data("usercodes")){
								if(_this_assignees == null){
									_this_assignees = $(this).data("usercodes");
								}else{
									if(nodeType == "SubProcess"){
										_this_assignees += ":" + $(this).data("usercodes");
									}else{
										_this_assignees += "," + $(this).data("usercodes");
									}
								}
							}
						});
						destinationAssignees = _this_assignees == null ? "" : _this_assignees;
					}
				}else{
					if(!$(this).attr("onlyView") || ("false" == $(this).attr("onlyView") && $(this).closest("div#gatewayDiv").find('input:radio[name="radio-task"]').is(':checked'))){
						destinationIds += "|" + $(this).val();
						nextTaskKeys+=","+$(this).val();
					}
					if(frameDoc.find("#gatewayParallelInput").length > 0 && $(this).attr("onlyView") == "false" && $(this).closest("div#gatewayDiv").find('input:radio[name="radio-task"]').is(':checked')){
						var nodeType = $(this).closest("div").attr("nodeType");//SubProcess
						console.log($(this).closest("div"));
						$(this).closest("div").find("input[name^='radio-user']:checked").each(function(){
							if($(this).data("usercodes")){
								if(_this_assignees == null){
									_this_assignees = $(this).data("usercodes");
								}else{
									if(nodeType == "SubProcess"){
										_this_assignees += ":" + $(this).data("usercodes");
									}else{
										_this_assignees += "," + $(this).data("usercodes");
									}
								}
							}
						});
						destinationAssignees += "|" + (_this_assignees == null ? "" : _this_assignees);
					}
				}
			});
			wf.destinationId = destinationIds;
			if(destinationAssignees != null){
				wf.destinationAssignees = destinationAssignees;
			}
			if(wf.destinationId == null || wf.destinationId == ""){
				dialog({
					title : '错误',
					content : "不存在下一节点，请联系管理员",
					ok : function() {
					}
				}).showModal();
				return false;
			}
			//下一节点为单个节点
			if(wf.destinationAssignees == null){
				//获取办理人div中的radio，应对有多个节点选择的情况
				var destinationAssignees_div_id = "candidate_" + wf.destinationId;
				var procUser = "";
				var isSubProcess = frameDoc.find("#" + destinationAssignees_div_id).attr("isSubProcess");
				frameDoc.find("#" + destinationAssignees_div_id).find("input[name^='radio-user']:checked").each(function() {
					if($(this).data("usercodes")){
						if(isSubProcess == "true"){
							procUser = procUser + "|"+$(this).data("usercodes");
						}else{
							procUser = procUser + ","+$(this).data("usercodes");
						}
					}
				});
				wf.destinationAssignees = "";
				if (procUser.length > 1) {
					wf.destinationAssignees = procUser.substr(1);
				}
			}
			wf.taskComment = frameDoc.find("#txtWfComment").val();
			//传阅参数设置
			var readerLoginNames = frameDoc.find("#readerLoginNames").val();
			if(readerLoginNames){
				wf.readerLoginNames = readerLoginNames;
				wf.readerUserNames = frameDoc.find("#readerUserNames").val();
			}
			
			if(processVariables){
				variables=processVariables();
			}
			var flowForm =  $.param(wf)+ "&processVariables=" +JSON.stringify(variables) ;
			ths.submitFormAjax({
				url : "${ctx}/console/submit.vm",
				data : flowForm,
				success : function(response) {
					if (response == "success") {
						bpmCallBack(1,nextTaskKeys);
					} else {
						dialog({
							title : '信息',
							content : response,
							ok : function() {
							}
						}).showModal();
					}
				}
			});
		}
		/*终止流程操作*/
		function terminate(){
			dialog({
	            title: '终止任务',
	            icon:'fa-times-circle',
	            wraperstyle:'alert-warning',
	            content: '确实要终止当前任务吗?<hr/>',
	            ok: function () {
	         	   $.ajax({
	                   	url:"${ctx}/console/terminate.vm",
	                   	data:{'procInstId': instanceId},
	                   	type:"post",
	                   	dataType:"text",
	                   	success:function(data){
	                   		if(data=="success"){
	                   			dialog({
	        						title : '信息',
	        						content : "终止成功",
	        						cancel: false,
	        						ok : function() {
	        							bpmCallBack(6,"");
	        						}
	        					}).showModal();
	               			}else{
	               				dialog({
	        						title : '信息',
	        						content : "终止失败",
	        						ok : function() {
	        						}
	        					}).showModal();
	               			}
	                   	}
	                 })
	            },
	            cancel:function(){}
	        }).showModal();
		}
		
		/*退回操作*/
		function reject(canreject, returnnode){
			console.log(222222222);
			ths.submitFormAjax({
	            url: "${ctx}/console/rejectdetecte.vm",
	            dataType: "json",
	            data:{'taskId': taskId,'canReject': canreject,'returnNode': returnnode,'instanceId': instanceId},
              	type:"post",
	            success:function(wfInteraction){
	        		if(wfInteraction.hasError){
	        			dialog({
							title: '提示',
							width: 550 > document.documentElement.clientWidth ? document.documentElement.clientWidth : 550,
							height: 250 > document.documentElement.clientHeight ? document.documentElement.clientHeight : 250,
							wraperstyle:'',
							content: wfInteraction.message
						}).showModal();
	        			return;
	        		}else{
	        			//显示退回节点及办理人
	        			console.log(encodeURI(encodeURI(JSON.stringify(wfInteraction))));
	    				dialog({
	    					id : "dialog-jdp-wf-reject",
	    					title : '请选择',
	    					url : '${ctx}/console/reject/fromTaskId.vm?taskId=' + wfInteraction.taskId,
	    					width : 650 > document.documentElement.clientWidth ? document.documentElement.clientWidth : 650,
	    					height : 300 > document.documentElement.clientHeight ? document.documentElement.clientHeight : 300,
	    					ok : function() {
								if(document.getElementsByName('dialog-jdp-wf-reject')[0].contentWindow.check()){
									clearDialogIframe("dialog-jdp-wf-reject");
									var frameDoc = $(window.frames["dialog-jdp-wf-reject"].document);
									var wf = {};
									wf.taskId = frameDoc.find("input[name='wf-task-id']").val();
									wf.destinationId = frameDoc.find("input[name='radio-task']:checked").val();
									wf.taskComment = frameDoc.find("#txtWfComment").val();
									var procUser = "";
									frameDoc.find("input[name^='radio-user']:checked").each(function(){
										if(procUser == ""){
											procUser = $(this).val();//向数组中添加元素  
										}else{
											procUser = procUser + "," + $(this).val();//向数组中添加元素  
										}
									});
									if(procUser.length > 0){
										wf.destinationAssignees = procUser;
									}
									ths.submitFormAjax({
										url : "${ctx}/console/reject.vm",
										data : wf,
										success : function(response) {
											if (response == "success") {
												bpmCallBack(2,wf.destinationId);
											} else {
												dialog({
													title : '信息',
													content : response,
													ok : function() {
													}
												}).showModal();
											}
										}
									});
								} else {
									return false;
								}
	    					}
	    				}).showModal();
	        		}
	        	}
			});
		}
		/*撤回操作*/
		function revocation(){
			ths.submitFormAjax({
				url : "${ctx}/console/revocationdetecte.vm",
				data : {"taskId": taskId},
				type: "get",
				dataType: "json",
	        	success:function(wfInteraction){
	        		if(wfInteraction.hasError){
		        		dialog({
							title: '提示',
							width:'550px',
							height:'250px',
							wraperstyle:'',
							content: wfInteraction.message
						}).showModal();
		        		return;
		        	}else{
		        		dialog({
		        			id : "dialog-jdp-wf-revocation-message",
		        			title : '撤回原因',
		        			url : '${ctx}/console/message.vm',
		        			width : 650,
		        			height : 300,
		        			ok : function() {
		        				clearDialogIframe("dialog-jdp-wf-revocation-message");
		        				if(document.getElementsByName('dialog-jdp-wf-revocation-message')[0].contentWindow.check()){
		        					ths.submitFormAjax({
			            				url : "${ctx}/console/revocation.vm",
			            				data : {"taskId": taskId, "message": $(window.frames["dialog-jdp-wf-revocation-message"].document).find("#message").val()},
			            				success:function(response){
			            					if (response == "success") {
		    									bpmCallBack(5,"");
		    								} else {
		    									dialog({
		    										title : '信息',
		    										content : response,
		    										ok : function() {
		    										}
		    									}).showModal();
		    								}
			            				}
			            			});
		        				}else{
		        					return false;
		        				}
		        			}
		        		}).showModal();
		        	}
	        	}
			});
		}
		/*流程图操作*/
		function JDP_WF_showDiagram() {
			dialog({
				id:"dialog-jdp-wf-diagram",
	            title: '流程图',
	            url: '<%=ths.jdp.core.context.PropertyConfigure.getUrlFromNacos("jdp.bpm.api.context").toString() %>/bpm/repository/flowjs/view.vm?processInstanceId=${task.processInstanceId}',
	            width:850,
	            height:500>document.documentElement.clientHeight?document.documentElement.clientHeight:500,
	        }).showModal();
		}
		/*办理过程操作*/
		function JDP_WF_showHistory() {
			dialog({
				id:"dialog-jdp-wf-diagram",
	            title: '办理过程',
	            url: '${ctx}/console/historytask.vm?procInstId=${task.processInstanceId}',
	            width:850,
	            height:500>document.documentElement.clientHeight?document.documentElement.clientHeight-40:500,
	        }).showModal();
		}
		/*阅读操作*/
		function read(){
			dialog({
				id : "dialog-jdp-wf-read-message",
				title : '阅读意见',
				url : '${ctx}/console/message.vm',
				width : 650,
				height : 300,
				ok : function() {
					clearDialogIframe("dialog-jdp-wf-read-message");
					if(document.getElementsByName('dialog-jdp-wf-read-message')[0].contentWindow.check()){
						ths.submitFormAjax({
		    				url : "${ctx}/console/read.vm",
		    				data : {"activityId": taskId, "message": $(window.frames["dialog-jdp-wf-read-message"].document).find("#message").val()},
		    				success : function(response) {
		    					if (response == "success") {
		    						bpmCallBack("4",taskDefinitionKey);
		    					} else {
		    						dialog({
		    							title : '信息',
		    							content : response,
		    							ok : function() {
		    							}
		    						}).showModal();
		    					}
		    				}
		    			});
					}else{
						return false;
					}
				}
			}).showModal();
		}
		/*阅读记录*/
		function jdp_bpm_readHistory(){
			dialog({
				id : "dialog-jdp-wf-read-hi-message",
				title : "阅读记录",
				url : '${ctx}/console/message.vm?taskId=' + taskId,
				width : 650,
				height : 300,
				ok : function() {
				}
			}).showModal();
		}
		
		function bpmCallBack(type,taskkey){
			if(processBack){
				processBack(type,taskkey,instanceId,taskId);
			}else{
				alert("未提供执行结束回调方法processBack");
			}
		}
		
		/*转办页面*/
		function sendto(cansendto){
			dialog({
				id:"jdp-bpm-sendto-dialog",
				title: '选择',
		   		url: "${ctx}/console/sendto.vm?cansendto=" + cansendto,
		   		width:550,
		      	height: 300,
		      	ok : function() {
		      		clearDialogIframe("jdp-bpm-sendto-dialog");
					if(document.getElementsByName('jdp-bpm-sendto-dialog')[0].contentWindow.check()){
						var loginName = $(window.frames["jdp-bpm-sendto-dialog"].document).find("#assignee").val();
						var taskComment = $(window.frames["jdp-bpm-sendto-dialog"].document).find("#txtWfComment").val();
						$.ajax({
		                  	url:"${ctx}/console/sendto.vm",
		                  	data:{'taskId': taskId,'assigneeCode': loginName,'taskComment': taskComment},
		                  	type:"post",
		                  	dataType:"text",
		                  	success:function(data){
		                  		if(data=="success"){
		                  			dialog({
			            				title: '信息',
			            				content: "转办成功",
			            				cancel: false,
			            				ok: function () {
			            					bpmCallBack(3,taskDefinitionKey);
			            				}
			            			}).showModal();
		              			}else{
		              				dialog({
			            				title: '信息',
			            				content: "转办失败，" + data,
			            				ok: function () {}
			            			}).showModal();
		              			}
		                  	}
		                });
					}else{
						return false;
					}
		      	}
		     }).showModal();
		}
		/*转办选择人页面*/
		function jdp_bpm_sentto_selUser(cansendto){
			var url = "${ctx}/common/ou/selUser.html?callback=jdp_bpm_sendto_ok&closeCallback=jdp_bpm_sendtoClose";
			if(cansendto == "cansendto_BBM"){ //转办本部门
				url += "&orgid=${deptId }&showChildOrg=true";
			}
			dialog({
				id:"jdp-bpm-sendto-dialog-user",
	       		title: '选择',
	            url: url,
	            width:550,
	            height:500>document.documentElement.clientHeight?document.documentElement.clientHeight:500,
	        }).showModal();
		}
		
		/*转办操作*/
		function jdp_bpm_sendto_ok(user){
			if(user.loginName){
				clearDialogIframe("jdp-bpm-sendto-dialog");
				$(window.frames["jdp-bpm-sendto-dialog"].document).find("#assignee_thsname").val(user.name);
				$(window.frames["jdp-bpm-sendto-dialog"].document).find("#assignee").val(user.loginName);
			}
		}
		//关闭转办dialog
		function jdp_bpm_sendtoClose(){
			dialog.get("jdp-bpm-sendto-dialog-user").close().remove();
		}
		/*传阅页面*/
		function readto(canread){
			dialog({
				id:"jdp-bpm-toread-dialog",
				title: '选择',
		   		url: "${ctx}/console/readto.vm?canread=" + canread,
		   		width:550,
		      	height: 300,
		      	ok : function() {
		      		clearDialogIframe("jdp-bpm-toread-dialog");
					if(document.getElementsByName('jdp-bpm-toread-dialog')[0].contentWindow.check()){
						var complexUsers = $(window.frames["jdp-bpm-toread-dialog"].document).find("#complexUsers").val();
						var comment = $(window.frames["jdp-bpm-toread-dialog"].document).find("#txtWfComment").val();
						$.ajax({
		                  	url:"${ctx}/console/readto.vm",
		                  	data:{'taskId': taskId,'complexUsers': complexUsers,'comment': comment},
		                  	type:"post",
		                  	dataType:"text",
		                  	success:function(data){
		                  		if(data=="success"){
		                  			dialog({
			            				title: '信息',
			            				content: "传阅成功",
			            				cancel: false,
			            				ok: function () {
			            				}
			            			}).showModal();
		              			}else{
		              				dialog({
			            				title: '信息',
			            				content: "传阅失败，" + data,
			            				ok: function () {}
			            			}).showModal();
		              			}
		                  	}
		                });
					}else{
						return false;
					}
		      	}
		     }).showModal();
		}
		/*清空dialog空iframe*/
		function clearDialogIframe(name){
			//dialog关闭时留下了空的iframe，需要删除
			$("iframe[name='" + name + "']").each(function(){
				if($(this).attr("src") == "about:blank"){
					$(this).remove();
				}
			});
		}
		//选择传阅人回调
		function jdp_bpm_read_complexUserChoose(complexUserObjs){
	        clearDialogIframe("jdp-bpm-toread-dialog");
        	window.frames["jdp-bpm-toread-dialog"].showMutiUserSelected(complexUserObjs);
	    }
		//关闭选择传阅人dialog
		function jdp_bpm_readClose(){
			dialog.get("jdp-bpm-read-dialog-user-muti").close().remove();
		}
		//返回complexUser的值
		function getComplexUserVal(id){
			return $(window.frames["jdp-bpm-toread-dialog"].document).find("#" + id).val();
		}
		
	</script>
</div>
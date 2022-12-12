<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
	<head>
		<title></title>
		<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
		<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
		<link rel="stylesheet" href="${ctx }/assets/components/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">
		<!--[if !IE]> -->
		<script src="${ctx }/assets/components/jquery/dist/jquery.js"></script>
		<!-- <![endif]-->
		
		<!--[if IE]>
		<script src="${ctx }/assets/components/jquery.1x/dist/jquery.js"></script>
		<![endif]-->
		<script src="${ctx }/assets/components/zTree/js/jquery.ztree.all.min.js"></script>
		<style type="text/css">
			table td{
			 	border: 1px solid #dedede;
			 	text-align: center;
			}
			div.tab-pane.fade{
				height: 100%;
			}
			ul.ztree{
				height: 100%;
				overflow: auto;
			}
			.ztree * {
				font-size: 14px;
			}
			.ztree li span.button.dept_org_ico_open,.ztree li span.button.dept_org_ico_close,.ztree li span.button.dept_org_ico_docu{
				display: inline-block;
				font: normal normal normal 14px/1 FontAwesome;
				background-image: none !important;
			}
			.ztree li span.button.dept_org_ico_open:before,.ztree li span.button.dept_org_ico_close:before,.ztree li span.button.dept_org_ico_docu:before{
				content: "\f0e8";
			}
			.ztree li span.button.dept_ico_open,.ztree li span.button.dept_ico_close,.ztree li span.button.dept_ico_docu{
				display: inline-block;
				font: normal normal normal 14px/1 FontAwesome;
				background-image: none !important;
			}
			.ztree li span.button.dept_ico_open:before{
				content: "\f07c";
			}
			.ztree li span.button.dept_ico_close:before,.ztree li span.button.dept_ico_docu:before{
				content: "\f07b";
			}
			.ztree li span.button.role_ico_open,.ztree li span.button.role_ico_close,.ztree li span.button.role_ico_docu{
				display: inline-block;
				font: normal normal normal 14px/1 FontAwesome;
				background-image: none !important;
			}
			.ztree li span.button.role_ico_open:before,.ztree li span.button.role_ico_close:before,.ztree li span.button.role_ico_docu:before{
				content: "\f25d";
			}
			.ztree li span.button.app_ico_open,.ztree li span.button.app_ico_close,.ztree li span.button.app_ico_docu{
				display: inline-block;
				font: normal normal normal 14px/1 FontAwesome;
				background-image: none !important;
			}
			.ztree li span.button.app_ico_open:before,.ztree li span.button.app_ico_close:before,.ztree li span.button.app_ico_docu:before{
				content: "\f12e";
			}
			.ztree li span.button.posi_ico_open,.ztree li span.button.posi_ico_close,.ztree li span.button.posi_ico_docu{
				display: inline-block;
				font: normal normal normal 14px/1 FontAwesome;
				background-image: none !important;
			}
			.ztree li span.button.posi_ico_open:before,.ztree li span.button.posi_ico_close:before,.ztree li span.button.posi_ico_docu:before{
				content: "\f0f2";
			}
			.ztree li span.button.group_ico_open,.ztree li span.button.group_ico_close,.ztree li span.button.group_ico_docu{
				display: inline-block;
				font: normal normal normal 14px/1 FontAwesome;
				background-image: none !important;
			}
			.ztree li span.button.group_ico_open:before,.ztree li span.button.group_ico_close:before,.ztree li span.button.group_ico_docu:before{
				content: "\f0c0";
			}
			.ztree li span.button.user_ico_open,.ztree li span.button.user_ico_close,.ztree li span.button.user_ico_docu{
				display: inline-block;
				font: normal normal normal 14px/1 FontAwesome;
				background-image: none !important;
			}
			.ztree li span.button.user_ico_open:before,.ztree li span.button.user_ico_close:before,.ztree li span.button.user_ico_docu:before{
				content: "\f007";
			}
			.ztree li span.button.folder_ico_open,.ztree li span.button.folder_ico_close,.ztree li span.button.folder_ico_docu{
				display: inline-block;
				font: normal normal normal 14px/1 FontAwesome;
				background-image: none !important;
			}
			.ztree li span.button.folder_ico_open:before{
				content: "\f07c";
			}
			.ztree li span.button.folder_ico_close:before,.ztree li span.button.folder_ico_docu:before{
				content: "\f07b";
			}
		</style>
	</head>
	<body class="no-skin">
		<div class="tabbable">
			<ul class="nav nav-tabs" id="myTab">
				<c:if test='${!fn:contains(paramMap.hideTab, "user") }'>
					<li class="active"><a data-toggle="tab" href="#user">人员</a></li>
				</c:if>
				<c:if test='${!fn:contains(paramMap.hideTab, "dept") }'>
					<li <c:if test='${fn:contains(paramMap.hideTab, "user") }'>class="active"</c:if>><a data-toggle="tab" href="#dept">部门</a></li>
				</c:if>
				<c:if test='${!fn:contains(paramMap.hideTab, "role") }'>
					<li <c:if test='${fn:contains(paramMap.hideTab, "user") && fn:contains(paramMap.hideTab, "dept") }'>class="active"</c:if>><a data-toggle="tab" href="#role">角色</a></li>
				</c:if>
				<c:if test='${!fn:contains(paramMap.hideTab, "position") }'>
					<li <c:if test='${fn:contains(paramMap.hideTab, "user") && fn:contains(paramMap.hideTab, "dept") && fn:contains(paramMap.hideTab, "role") }'>class="active"</c:if>><a data-toggle="tab" href="#position">岗位</a></li>
				</c:if>
				<c:if test='${!fn:contains(paramMap.hideTab, "group") }'>
					<li <c:if test='${fn:contains(paramMap.hideTab, "user") && fn:contains(paramMap.hideTab, "dept") && fn:contains(paramMap.hideTab, "role") && fn:contains(paramMap.hideTab, "group") }'>class="active"</c:if>><a data-toggle="tab" href="#group">群组</a></li>
				</c:if>
			</ul>
			<div class="tab-content" style="height: 375px;">
				<c:if test='${!fn:contains(paramMap.hideTab, "user") }'>
					<div id="user" class="tab-pane fade in active">
						<table style="height: 100%; width: 100%;">
							<tr>
								<td colspan="3" style="height: 36px;">
									<table style="height: 100%; width: 100%;">
										<tr>
											<td style="width: 100%; height: 36px; width: 80px; border: 0px;">
					                     		<div class="radio-inline">
		                                            <label>
		                                                <input name="user_query_type" type="radio" class="ace" value="1" checked="checked" onchange="initUser();">
		                                                <span class="lbl"> 部门</span>
		                                            </label>
		                                        </div>
											</td>
											<td style="border: 0px;">
												<input id="user_query_dept" type="hidden" value="" class="form-control">
												<input id="user_query_dept_name" type="text" value="" class="form-control" readonly="readonly" onclick="showDeptsSelect('user');">
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td colspan="3" style="height: 36px;">
									<table style="height: 100%; width: 100%;">
										<tr>
											<td style="width: 100%; height: 36px; width: 80px; border: 0px;">
												<div class="radio-inline">
		                                            <label>
		                                                <input name="user_query_type" type="radio" class="ace" value="2" onchange="initUser();">
		                                                <span class="lbl"> 角色</span>
		                                            </label>
		                                        </div>
											</td>
											<td style="border: 0px;">
												<input id="user_query_role" type="hidden" value="" class="form-control">
												<input id="user_query_role_name" type="text" value="" class="form-control" readonly="readonly" onclick="showRolesSelect('user');">
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="46%" style="max-width:300px; height: 285px;">
									<ul id="userTreeDiv" class="ztree no-padding"></ul>
								</td>
								<td style="max-width: 8%; width: 6%; height: 285px;">
									<button type="button" class="btn moveall btn-white btn-bold " title="Move all" onclick="add('user');">       
										<i class="fa fa-arrow-right"></i><i class="fa fa-arrow-right"></i>
									</button>
									<br /><br /><br /><br /><br />
									<button type="button" class="btn moveall btn-white btn-bold " title="Move all" onclick="remove('user');">       
										<i class="fa fa-arrow-left"></i><i class="fa fa-arrow-left"></i>
									</button>
								</td>
								<td width="46%" style="max-width: 46%; height: 285px;">
									<select class="form-control" id="userSel" multiple="multiple" style="height: 100%; border: 0px;">
									</select>
								</td>
							</tr>
						</table>
					</div>
				</c:if>
				<c:if test='${!fn:contains(paramMap.hideTab, "dept") }'>
					<div id="dept" class="tab-pane fade <c:if test='${fn:contains(paramMap.hideTab, "user") }'>in active</c:if>">
						<table style="height: 100%; width: 100%;">
							<tr>
								<td width="46%" style="max-width:300px; height: 357px;">
									<ul id="deptTreeDiv" class="ztree no-padding"></ul>
								</td>
								<td style="max-width: 8%; width: 6%; height: 357px;">
									<button type="button" class="btn moveall btn-white btn-bold " title="Move all" onclick="add('dept');">       
										<i class="fa fa-arrow-right"></i><i class="fa fa-arrow-right"></i>
									</button>
									<br /><br /><br /><br /><br />
									<button type="button" class="btn moveall btn-white btn-bold " title="Move all" onclick="remove('dept');">       
										<i class="fa fa-arrow-left"></i><i class="fa fa-arrow-left"></i>
									</button>
								</td>
								<td style="width: 46%; height: 357px;">
									<select class="form-control" id="deptSel" multiple="multiple" style="height: 100%; border: 0px;">
									</select>
								</td>
							</tr>
						</table>
					</div>
				</c:if>
				<c:if test='${!fn:contains(paramMap.hideTab, "role") }'>
					<div id="role" class="tab-pane fade <c:if test='${fn:contains(paramMap.hideTab, "user") && fn:contains(paramMap.hideTab, "dept") }'>in active</c:if>">
						<table style="height: 100%; width: 100%;">
							<tr>
								<td width="46%" style="max-width:300px; height: 357px;">
									<ul id="roleTreeDiv" class="ztree no-padding"></ul>
								</td>
								<td style="max-width: 8%; width: 6%; height: 357px;">
									<button type="button" class="btn moveall btn-white btn-bold " title="Move all" onclick="add('role');">       
										<i class="fa fa-arrow-right"></i><i class="fa fa-arrow-right"></i>
									</button>
									<br /><br /><br /><br /><br />
									<button type="button" class="btn moveall btn-white btn-bold " title="Move all" onclick="remove('role');">       
										<i class="fa fa-arrow-left"></i><i class="fa fa-arrow-left"></i>
									</button>
								</td>
								<td style="width: 46%; height: 357px;">
									<select class="form-control" id="roleSel" multiple="multiple" style="height: 100%; border: 0px;">
									</select>
								</td>
							</tr>
						</table>
					</div>
				</c:if>
				<c:if test='${!fn:contains(paramMap.hideTab, "position") }'>
					<div id="position" class="tab-pane fade <c:if test='${fn:contains(paramMap.hideTab, "user") && fn:contains(paramMap.hideTab, "dept") && fn:contains(paramMap.hideTab, "role") }'>in active</c:if>">
						<table style="height: 100%; width: 100%;">
							<tr>
								<td width="46%" style="max-width:300px; height: 357px;">
									<ul id="positionTreeDiv" class="ztree no-padding"></ul>
								</td>
								<td style="max-width: 8%; width: 6%; height: 357px;">
									<button type="button" class="btn moveall btn-white btn-bold " title="Move all" onclick="add('position');">       
										<i class="fa fa-arrow-right"></i><i class="fa fa-arrow-right"></i>
									</button>
									<br /><br /><br /><br /><br />
									<button type="button" class="btn moveall btn-white btn-bold " title="Move all" onclick="remove('position');">       
										<i class="fa fa-arrow-left"></i><i class="fa fa-arrow-left"></i>
									</button>
								</td>
								<td style="width: 46%; height: 357px;">
									<select class="form-control" id="positionSel" multiple="multiple" style="height: 100%; border: 0px;">
									</select>
								</td>
							</tr>
						</table>
					</div>
				</c:if>
				<c:if test='${!fn:contains(paramMap.hideTab, "group") }'>
					<div id="group" class="tab-pane fade <c:if test='${fn:contains(paramMap.hideTab, "user") && fn:contains(paramMap.hideTab, "dept") && fn:contains(paramMap.hideTab, "role") && fn:contains(paramMap.hideTab, "position") }'>in active</c:if>">
						<table style="height: 100%; width: 100%;">
							<tr>
								<td colspan="3" style="height: 36px;">
									<table style="height: 100%; width: 100%;">
										<tr>
											<td style="width: 100%; height: 36px; width: 80px; border: 0px;">
					                     		部门
											</td>
											<td style="border: 0px;">
												<input id="group_query_dept" type="hidden" value="" class="form-control">
												<input id="group_query_dept_name" type="text" value="" class="form-control" readonly="readonly" onclick="showDeptsSelect('group');">
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="46%" style="max-width:300px; height: 321px;">
									<ul id="groupTreeDiv" class="ztree no-padding"></ul>
								</td>
								<td style="max-width: 8%; width: 6%; height: 321px;">
									<button type="button" class="btn moveall btn-white btn-bold " title="Move all" onclick="add('group');">       
										<i class="fa fa-arrow-right"></i><i class="fa fa-arrow-right"></i>
									</button>
									<br /><br /><br /><br /><br />
									<button type="button" class="btn moveall btn-white btn-bold " title="Move all" onclick="remove('group');">       
										<i class="fa fa-arrow-left"></i><i class="fa fa-arrow-left"></i>
									</button>
								</td>
								<td style="width: 46%; height: 321px;">
									<select class="form-control" id="groupSel" multiple="multiple" style="height: 100%; border: 0px;">
									</select>
								</td>
							</tr>
						</table>
					</div>
				</c:if>
			</div>
			<div style="margin-top: 5px;margin-bottom: 5px; text-align: right;">
				<button type="button" class="btn btn-xs    btn-xs-ths" id="btnOk">
					<i class="ace-icon fa fa-save"></i>保存
				</button>
				<button type="button" class="btn btn-xs btn-xs-ths" id="btnCancel">
                 	<i class="ace-icon fa fa-times"></i>取消
                </button>
			</div>
		</div>
	</body>
	<script type="text/javascript">
		//自定义回调方法-OK操作
		var callbackFun = "${paramMap.callback }";
		//自定义回调方法-关闭操作
		var closeCallbackFun = "${paramMap.closeCallback }";
		//复合用户对象
		var complexUserObj = {};
		//ou url
		var url = "<%=ths.jdp.core.context.PropertyConfigure.getProperty("jdp.ou.api.context").toString()%>";
		//ztree对象集合
		var ztreeObjs = {};
		//ztree配置
		var setting = {
			data: {
				simpleData: {
					enable: true
				}
			},
			view: {
				showLine: false
			}
		};
		//Ajax 请求tree
		function loadTreeAjax(treeDivId, treeUrl, type){
			//$("#" + treeDivId).hide();
			$.ajax( {  
				url: treeUrl,
			 	type:'get',  
			  	cache:false,  
			 	dataType:'jsonp',  
			 	success:function(data) { 
			    	serverNodeArray = data.mapList;
			   		renderTreeAdapter(treeDivId, type);
			  	},  
			  	error : function(msg) {  
			 	}  
			});
		}
		function renderTreeAdapter(treeDivId, type){
			var zNodes =[];
			var nodeMap = {};
			var j  = 0;
			setting.view.showLine = true;
			if(type == "user" || type == "group" || type == "position"){
				setting.view.showLine = false;
			}
			for(var i = 0 ; i < serverNodeArray.length; i++){
				var node_str = JSON.stringify(serverNodeArray[i]);
				node_str = node_str.replace(/\"/g, "~S~");
				var node = {};
				if(type == 'dept'){
					node.id = serverNodeArray[i].DEPT_ID;
		   			node.pId = serverNodeArray[i].PARENT != undefined?serverNodeArray[i].PARENT:"";
		   			node.name = serverNodeArray[i].DEPT_NAME;
		   			node.code = serverNodeArray[i].DEPT_CODE;
		   			if(serverNodeArray[i].DEPT_TYPE == "1"){ //组织
		   				node.iconSkin = "dept_org";
		   			}else{//部门
		   				node.iconSkin = "dept";
		   			}
		   			node.cansel = "true";
				}else if(type == 'role' || type == 'position'){
					node.id = serverNodeArray[i].ID;
		   			node.pId = serverNodeArray[i].PARENT != undefined?serverNodeArray[i].PARENT:"";
		   			node.name = serverNodeArray[i].NAME;
		   			node.code = serverNodeArray[i].ID;
		   			if(type == 'role' && serverNodeArray[i].NODE_TYPE == "3"){ //角色
		   				node.iconSkin = "role";
		   				node.cansel = "true";
		   			}else if(type == 'role' && serverNodeArray[i].NODE_TYPE == "0"){ //应用
		   				node.iconSkin = "app";
		   			}else if(type == 'role' && serverNodeArray[i].NODE_TYPE == "100"){ //分类
		   				node.iconSkin = "folder";
		   			}
		   			if(type == 'position'){
		   				node.iconSkin = "posi";
		   				node.cansel = "true";
		   			}
				}else if(type == 'group'){
					node.id = serverNodeArray[i].GROUP_ID;
		   			node.pId = serverNodeArray[i].PARENT != undefined?serverNodeArray[i].PARENT:"";
		   			node.name = serverNodeArray[i].GROUP_NAME;
		   			node.code = serverNodeArray[i].GROUP_CODE;
		   			node.iconSkin = "group";
		   			node.cansel = "true";
				}else if(type == 'user'){
					node.id = serverNodeArray[i].USER_ID;
		   			node.pId = serverNodeArray[i].PARENT != undefined?serverNodeArray[i].PARENT:"";
		   			node.name = serverNodeArray[i].USER_NAME;
		   			node.code = serverNodeArray[i].LOGIN_NAME;
		   			node.iconSkin = "user";
		   			node.cansel = "true";
				}
				if(nodeMap[node.id]){
					continue;
				}else{
					nodeMap[node.id] = node;
				}
	   			zNodes[j++] =node;
			}
			zTreeObj = $.fn.zTree.init($("#" + treeDivId), setting, zNodes);
			zTreeObj.expandAll(true);
			$("#" + treeDivId).show();
			ztreeObjs[type] = zTreeObj;
		}
		//添加选中值
		function add(type){
			var nodes = ztreeObjs[type].getSelectedNodes();
			if(nodes){
				for(var i = 0; i < nodes.length; i++){
					if(nodes[i].cansel == "true"){
						if($("#" + type + "Sel option[value='" + nodes[i].code + "']").length == 0){
							$("#" + type + "Sel").append("<option value='" + nodes[i].code + "'>" + nodes[i].name + "</option>");
							$("#" + type + "Sel option[value='" + nodes[i].code + "']").attr("tid", nodes[i].id);
						}
					}
				}
			}
		}
		//删除选中值
		function remove(type){
			var values = $("#" + type + "Sel").val();
			if(values){
				for(var i = 0; i < values.length; i++){
					$("#" + type + "Sel option[value='" + values[i] + "']").remove();
				}
			}
		}
		//部门选择dialog
		function showDeptsSelect(type){
			dialog({
				id:"dialog-jdp-eform-" + type + "-dept",
		        title: "选择部门",
		        url: ctx + '/common/ou/treeDept' + (type == 'group' ? "" : "Muti") + '.html?showRadio=1&hiddenId=' + type + '_query_dept&callback=' + type + '_dept_callback&closeCallback=' + type + '_dept_close',
		        width: 280,
		        height: 400
		    }).showModal();
		}
		//群组-部门回调
		function group_dept_callback(dept){
			if(dept){
				$("#group_query_dept").val(dept.code);
				$("#group_query_dept_name").val(dept.name);
				$.ajax( {
					url: url + "/ou/usergroup/listajax.json",
					data:{"DEPT_ID":dept.id,"pageSize":1000},
					type:'get',
					cache:false,
					dataType:'jsonp',
					success:function(data){
						serverNodeArray = data.pageInfo.list;
				   		renderTreeAdapter("groupTreeDiv", "group");
					},
					error : function(msg) {
					}
				});
			}
		}
		//群组-部门关闭回调
		function group_dept_close(){
			dialog.get("dialog-jdp-eform-group-dept").close().remove();
		}
		//用户-部门回调
		function user_dept_callback(depts){
			if(depts){
				var codes = "";
				var names = "";
				for(var i = 0; i < depts.length; i++){
					if(codes == ""){
						codes = depts[i].code;
						names = depts[i].name;
					}else{
						codes += "," + depts[i].code;
						names += "," + depts[i].name;
					}
				}
				$("#user_query_dept").val(codes);
				$("#user_query_dept_name").val(names);
			}
			initUser();
		}
		//用户-部门关闭回调
		function user_dept_close(){
			dialog.get("dialog-jdp-eform-user-dept").close().remove();
		}
		//角色选择dialog
		function showRolesSelect(type){
			dialog({
				id:"dialog-jdp-eform-" + type + "-role",
		        title: "选择部门",
		        url: ctx + '/common/ou/treeRoleMuti.html?hiddenId=' + type + '_query_role&callback=' + type + '_role_callback&closeCallback=' + type + '_role_close',
		        width: 280,
		        height: 400
		    }).showModal();
		}
		//用户-角色回调
		function user_role_callback(roles){
			if(roles){
				var codes = "";
				var names = "";
				for(var i = 0; i < roles.length; i++){
					if(codes == ""){
						codes = roles[i].id;
						names = roles[i].name;
					}else{
						codes += "," + roles[i].id;
						names += "," + roles[i].name;
					}
				}
				$("#user_query_role").val(codes);
				$("#user_query_role_name").val(names);
			}
			initUser();
		}
		//用户-角色关闭回调
		function user_role_close(){
			dialog.get("dialog-jdp-eform-user-role").close().remove();
		}
		//显示用户
		function initUser(){
			if(ztreeObjs['user']){
				ztreeObjs['user'].destroy();
			}
			var type = $("input[name='user_query_type']:checked").val();
			var codes = null;
			if(type == "1" && $("#user_query_dept").val() != ""){ //部门
				codes = $("#user_query_dept").val();
			}else if(type == "2" && $("#user_query_role").val() != ""){//角色
				codes = $("#user_query_role").val();
			}
			if(codes != null){
				$.ajax( {
					url: ctx + "/eform/components/complex/select_user.vm",
					data:{"type": type,"codes": codes},
					type:'post',
					cache: false,
					dataType:'json',
					success:function(data){
						serverNodeArray = data;
				   		renderTreeAdapter("userTreeDiv", "user");
					},
					error : function(msg) {
					}
				});
			}
		}
		//判断父页面是否存在方法
		function parentExistsFun(funName){
			if(funName == null || funName == ""){
				return false;
			}
			var existsFun = false;
			try{
	    		eval("window.parent." + funName);
	    		existsFun = true;
	    	}catch(err) {}
	    	return existsFun;
		}
		//获取结果对象
		function getComplexUserObj(){
			getOptions("user");
			getOptions("dept");
			getOptions("role");
			getOptions("position");
			getOptions("group");
		}
		//获取值
		function getOptions(type){
			complexUserObj[type] = [];
			var options = $("#" + type + "Sel option");
			for(var i = 0; i < options.length; i++){
				complexUserObj[type][i] = {"code": options[i].value, "name": options[i].text, "id": $(options[i]).attr("tid")};
			}
		}
		//初始化
		$(function(){
			loadTreeAjax("deptTreeDiv", url + "/ou/dept/tree.json", "dept");
			loadTreeAjax("roleTreeDiv", url + "/ou/role/tree.json", "role");
			loadTreeAjax("positionTreeDiv", url + "/ou/posi/tree.json", "position");
			$("#btnOk").on(ace.click_event,function(){
				getComplexUserObj();
				if(parentExistsFun(callbackFun) == true){ //存在自定义回调方法，进行调用
		    		eval("window.parent." + callbackFun + "(" + JSON.stringify(complexUserObj) + ")");
		    	}else if(window.parent.complexUserChooseCallBack) {
	                window.parent.complexUserChooseCallBack(complexUserObj);
	            }
		    	if(parentExistsFun(closeCallbackFun) == true){ //存在自定义回调方法，进行调用
		    		eval("window.parent." + closeCallbackFun + "()");
		    	}else if(window.parent.closeComplexUserChooseDialog){
	                window.parent.closeComplexUserChooseDialog();
	            }
			});
			$("#btnCancel").on(ace.click_event,function(){
				if(parentExistsFun(closeCallbackFun) == true){ //存在自定义回调方法，进行调用
		    		eval("window.parent." + closeCallbackFun + "()");
		    	}else if(window.parent.closeComplexUserChooseDialog){
	                window.parent.closeComplexUserChooseDialog();
	            }
			});
			
			//初始化用户
			//hiddenId
			var hiddenId = "${paramMap.hiddenId }";
			if(hiddenId != "" && window.parent.getComplexUserVal){
				var selectValue = window.parent.getComplexUserVal(hiddenId);
				console.log(selectValue);
				if(selectValue && selectValue != "" && selectValue != "undifined"){
					var obj = JSON.parse(selectValue.trim());
					for(var type in obj){
						$.each(obj[type], function(i){
							 $("#" + type + "Sel").append("<option value='" + this.code + "'>" + this.name + "</option>");
						});
					}
				}
			}
		});
		
	</script>
</html>
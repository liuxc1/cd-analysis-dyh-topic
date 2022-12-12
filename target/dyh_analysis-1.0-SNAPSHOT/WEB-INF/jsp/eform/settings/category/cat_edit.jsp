<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
<head>
<title></title>
<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
<!--页面自定义的CSS，请放在这里 -->
<style type="text/css">
</style>
</head>

<body class="no-skin">

	<div class="main-container" id="main-container">
		<div class="main-content">
			<div class="main-content-inner fixed-page-header fixed-82">
				<div class="page-toolbar align-right">
					<button type="button" class="btn btn-xs    btn-xs-ths"
						id="btnSave" data-self-js="save()">
						<i class="ace-icon fa fa-save"></i> 保存
					</button>

					<button type="button" class="btn btn-xs btn-xs-ths"
						id="btnReturn" data-self-js="goBack()">
						<i class="ace-icon fa fa-reply"></i> 返回
					</button>
					<div class="space-2"></div>
					<hr class="no-margin">
				</div>
			</div>
			<div class="main-content-inner padding-page-content">
				<div class="page-content">
					<div class="space-4"></div>
					<div class="row">
						<div class=" col-xs-12">
							<form class="form-horizontal" role="form" id="formInfo" action=""
								method="post">
								<input type="hidden" name="categoryId" id="categoryId" value="${category.categoryId }"/>
								<input type="hidden" name="parentId" id="parentId" value="${category.parentId }"/>
								<input type="hidden" name="categoryPath" id="categoryPath"/>
								<input type="hidden" name="jdpAppCode" id="jdpAppCode" value="<%=ths.jdp.core.context.PropertyConfigure.getProperty("jdp.app.code").toString()%>"/>
								<input type="hidden" name="categoryTypeId" id="categoryTypeId" value="${category.categoryTypeId }"/>
								<div class="form-group">
									<label class="col-sm-2 control-label no-padding-right">
										<i class="ace-icon fa fa-asterisk red smaller-70"></i>分类名称
									</label>
									<div class="col-sm-4">
										 <input type="text"
											class="form-control"
											data-validation-engine="validate[required,maxSize[16]]"
											name="categoryName"
											id="categoryName"
											value="${category.categoryName }" />
									</div>
									<label class="col-sm-2 control-label no-padding-right">
										<i class="ace-icon fa fa-asterisk red smaller-70"></i> 排序
									</label>
									<div class="col-sm-4">
										 <input type="text"
											class="form-control"
											data-validation-engine="validate[required,custom[number]]"
											name="sort"
											value="${category.sort }" />
									</div>
								</div>
								<div class="form-group" <c:if test="${parentId != '-1' }"> style="display: none;"</c:if>>
									<label class="col-sm-2 control-label no-padding-right">
										维护人
									</label>
									<div class="col-sm-4">
	                                	<input type="hidden" name="tenantsCode" id="tenantsCode" value="${category.tenantsCode }"/> 
	                                   	<div class="input-group">
	                                       	<input id="tenantsName" type="text" class="form-control" name="tenantsName"  value="${category.tenantsName}"
	                                              	readonly="readonly"  />
	                                   		<span class="input-group-btn">
	                                   			<button id="btnChooseMutiUserManager" type="button" class="btn btn-white  ">
	                                       			<i class="ace-icon fa fa-search"></i>
	                                   				   选择
	                                   			</button>
	                                       		<button id="btnChooseMutiUserManagerX"  type="button" class="btn btn-white  ">
	                                           		<i class="ace-icon fa fa-remove"></i>
	                                       		</button>
	                                   		</span>
	                                   	</div>
	                                </div>
								</div>
								<div class="form-group">
									<label class="col-sm-2 control-label no-padding-right">
										备注
									</label>
									<div class="col-sm-4">
										<textarea rows="3" class="form-control" name="remark" style="resize:vertical;"
											data-validation-engine="validate[maxSize[60]]">${category.remark }</textarea>
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
		//AJAX保存
		function save() {
			if ($('#formInfo').validationEngine('validate')) {
				//设置节点路径
				var node = window.parent.parent.zTreeObj.getNodeByParam("id", "${category.parentId }");
				$("#categoryPath").val(getPathText(node));
				//表单保存提交
				ths.submitFormAjax({
					url : '${ctx}/eform/settings/category/cat_save.vm',// any URL you want to submit
					data : $("#formInfo").serialize(),
					success : function(response){
						if(response.indexOf("success") > -1){
							var cg_id = $("#categoryId").val();
							var isEdit = true;
							if(cg_id == null || cg_id == ""){
								isEdit = false;
								cg_id = response.split("|")[1];
							}
							//更新修改名称，新增添加树节点
							if(isEdit){
								window.parent.parent.treeNodeChange(cg_id, "edit", $("#categoryName").val());
							}else{
								window.parent.parent.treeNodeChange(cg_id, "add", $("#categoryName").val(), $("#parentId").val());
							}	
							this.callback();
						}else{
							dialog({
								title: '信息',
								content: response,
								ok: function () {}
							}).showModal();
						}
					}
				});
			}
		}
		/*递归获取节点全路径*/
		function getPathText(node){
	        var s = node.id + "/";
	        while(node=node.getParentNode()){
	        	s = node.id + '/' + s;
	        }
	    	return "/" + s;
	    }
		//返回
		function goBack() {
			$("#main-container", window.parent.document).show();
			$("#iframeInfo", window.parent.document).attr("src", "#").hide();
		}
		//多选人变量
		var selUserCodes = "${category.tenantsCode}".split(",");
		var selUserNames = "${category.tenantsName}".split(",");
		var selectUsers = [];
		for(var i = 0; i < selUserCodes.length; i++){
			if(selUserCodes[i].length > 0){
				var selectUser = {loginName:selUserCodes[i], name:selUserNames[i]};
				selectUsers.push(selectUser);
			}
		}
		//多选人回调
		function userSelectMutiCallBack(users){
			//console.log(users);
	        selectUsers = users;//这行代码一定要写，用于二次打开选择人Dialog的已选中数据回显
	        
	        //将选择的用户显示在界面上
	        //注意：这里仅显示，需要在表单提交前，将selectUsers的值写入到Hidden中提交
	        //参考 save(){}方法
	        showMutiUserSelected(selectUsers);
	    }
		//多选人界面显示
		function showMutiUserSelected(users){
			var codes = "";
			var names = "";
			$.each(users,function(i){
	        	codes += this.loginName + ",";
	        	names += this.name + ",";
	        });
			codes = codes.indexOf(",") > -1 ? codes.substring(0, codes.length - 1) : codes;
			names = names.indexOf(",") > -1 ? names.substring(0, names.length - 1) : names;
	        $("#tenantsCode").val(codes);
	        $("#tenantsName").val(names);
		}
		function removeUser(loginName){
			 $.each(selectUsers,function(i){
		        	if(this.loginName == loginName){
		        		selectUsers.removeAt(i);
		        		return;
		        	}
		      });
		}
		//关闭多选人Dialog
	    function closeDialog(){
	     	dialog.get("dialog-user-muti").close().remove();
	    }
		jQuery(function($) {
			//表单验证组件初始化，详细文档请参考http://code.ciaoca.com/jquery/validation-engine/ 或官网文档http://posabsolute.github.io/jQuery-Validation-Engine/
			$("#formInfo").validationEngine({
				scrollOffset : 98,//必须设置，因为Toolbar position为Fixed
				promptPosition : 'bottomLeft',
				autoHidePrompt : true
			});
			
			$("#btnChooseMutiUserManager").on(ace.click_event,function(){
				//dialog的使用，请参考官方文档http://aui.github.io/artDialog/doc/index.html
				dialog({
					id:"dialog-user-muti",
		            title: '选择',
		            url: '${ctx}/common/ou/selUserMuti.html',
		            width:550,
		            height:510>document.documentElement.clientHeight?document.documentElement.clientHeight:510,
		        }).showModal();
			});
			$("#btnChooseMutiUserManagerX").on(ace.click_event,function(){
				selectUsers=[];
				$("#tenantsCode").val("");
		        $("#tenantsName").val("");
			});
		});
	</script>
</body>
</html>

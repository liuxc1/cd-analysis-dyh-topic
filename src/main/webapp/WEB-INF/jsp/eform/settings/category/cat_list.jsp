<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
<head>
<title>流程定义</title>
<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
<!--zTree-->
<link rel="stylesheet"
	href="${ctx}/assets/components/zTree/css/metroStyle/metroStyle.css" />
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
						<div class="col-xs-12">
							<form class="form-horizontal" role="form" id="formList"
								action="#" method="post">
								
								<c:if test="${parentId == '-1'}">
									<div class="form-group">
										<label class="col-sm-1 control-label no-padding-right" for="txtName"> 维护人 </label>
										<div class="col-sm-3">
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
										
										<div class="col-sm-8  align-right">
											<div class="space-4 hidden-lg hidden-md hidden-sm"></div>
											<button type="button"
												class="btn btn-info pull-right"
												data-self-js="doSearch(true)">
												<i class="ace-icon fa fa-search"></i> 搜索
											</button>
										</div>
									</div>
									<hr class="no-margin">
								</c:if>
								<div class="page-toolbar align-right list-toolbar">
									<button type="button" class="btn btn-xs    btn-xs-ths"
										id="btnAdd" data-self-js="doAdd();">
										<i class="ace-icon fa fa-plus"></i> 添加
									</button>
									 <button type="button" class="btn btn-xs btn-xs-ths" data-self-js="doDelete()" id="btnDelete">
                                    <i class="ace-icon fa fa-trash-o"></i>
                                    删除
                                </button>

								</div>
								<table id="listTable" class="table table-bordered table-hover">
									<thead>
										<tr>
											<th class="center" style="width: 30px">
												<label class="pos-rel"> 
													<input type="checkbox" class="ace" />
												<span class="lbl"></span>
												</label>
											</th>
											<th class="" data-sort-col="CATEGORY_NAME" style="min-width:150px">
												<i class="ace-icon fa fa-folder-o"></i> 
												分类 
												<i class="ace-icon fa fa-sort pull-right"></i>
											</th>
											<c:if test="${parentId == '-1'}" >
												<th class=" " style="min-width:150px">
													<i class="ace-icon fa fa-user"></i>
													维护人
												</th>
											</c:if>
											<th class=" " data-sort-col="SORT" style="min-width:150px">
												排序 
												<i class="ace-icon fa fa-sort pull-right"></i>
											</th>
											<th class="align-center " style="width: 80px;min-width:150px">
												<i class="ace-icon fa fa-wrench"></i> 
												操作
											</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="item" items="${pageInfo.list}">
											<tr>
												<td class="center">
													<label class="pos-rel"> 
														<input type="checkbox" class="ace" value="${item.categoryId }" /> <span class="lbl"></span>
													</label>
												</td>
												<td>${item.categoryName }</td>
												<c:if test="${parentId == '-1'}">
													<td class=" ">${item.tenantsName }</td>
												</c:if>
												<td class=" ">${item.sort }</td>
												<td class=" align-center col-op-ths">
													<button type="button"
														class="btn btn-sm  btn-white btn-op-ths" title="编辑"
														data-self-js="doEdit('${item.categoryId }')">
														<i class="ace-icon fa fa-edit"></i>
													</button>
												</td>
											</tr>
										</c:forEach>
									</tbody>
								</table>
							 	<%@ include file="/WEB-INF/jsp/_common/paging.jsp"%> 
							</form>
						</div>
					</div>
				</div>
			</div>
			<!--/.main-content-inner-->
		</div>
		<!-- /.main-content -->
	</div>
	<!-- /.main-container -->

	<iframe id="iframeInfo" name="iframeInfo" class="frmContent" src=""
		style="border: none; display: none" frameborder="0" width="100%"></iframe>

	<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>

	<!-- 自己写的JS，请放在这里 -->
	<script type="text/javascript">
	//设置iframe自动高
	autoHeightIframe("iframeInfo");
	
	//搜索
	function doSearch(){
		if( typeof(arguments[0]) != "undefined" && arguments[0] == true)
			$("#pageNum").val(1);
		$("#orderBy").closest("form").submit();
	}
	
	function doAdd(){
		var url="${ctx}/eform/settings/category/cat_edit.vm?parentId=${treeId}";
		$("#main-container").hide();
        $("#iframeInfo").attr("src",url).show();
	}
	
	function doEdit(id){
		var url="${ctx}/eform/settings/category/cat_edit.vm?categoryId=" + id;
		$("#main-container").hide();
        $("#iframeInfo").attr("src",url).show();
	}
	
	//批量删除
	function doDelete() {
		var _ids="";
        $('#listTable > tbody > tr > td:first-child :checkbox:checked').each(function(){
        	_ids = _ids + $(this).val() + ",";
        });
        _ids = _ids=""?_ids:_ids.substr(0,_ids.length -1 );
        /**
         * 执行数据批量删除
         *  __ids 为英文逗号分隔的ID字符串,也可仅传递一个ID,执行单个删除
         *  serverUrl 服务器端AJAX POST 地址
         *  callBackFn 删除成功的回调函数,无参数,如function(){}
         */
        var hasChildNodes = "";
        for(var i = 0; i < _ids.split(",").length; i++){
        	var node = window.parent.zTreeObj.getNodeByParam("id", _ids.split(",")[i]);
        	if(node != null && node.children != null && node.children.length > 0){
        		hasChildNodes += node.name + "、";	
			}
        }
        if(hasChildNodes == ""){
        	
        	//检查分类下是否存在业务单据
        	$.ajax({
        		url:"${ctx}/eform/settings/category/checkDelete.vm",
        		data:{categoryId:_ids,deleteMode:"true",tableName:"${tableName}",categoryIdField:"CATEGORY_ID"},
        		type:"post",
        		success:function(response){
        			if(response=="success"){
        				//进行分类删除。如果不需要进行分类删除校验，请去掉外层ajax请求，直接执行下列代码。
        				__doDelete(_ids,"${ctx}/eform/settings/category/cat_delete.vm",function(){
        					//刷出之后，刷新列表
        					doSearch();
        					window.parent.treeNodeChange(_ids, 'delete');
        				});
        			}else{
        				dialog({
        					title: '信息',
        					content:response,
        					ok: function () {}
        				}).showModal();
        			}
        		}
        	})
        }else{
        	dialog({
				title: '信息',
				content: hasChildNodes.substring(0, hasChildNodes.length - 1) + '分类下有子分类，请先删除子分类！',
				ok: function () {}
			}).showModal();
        }    
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
	//关闭多选人Dialog
    function closeDialog(){
     	dialog.get("dialog-user-muti").close().remove();
    }
	
	jQuery(function($){
		//初始化表格的事件，如表头排序，列操作等
		__doInitTableEvent("listTable");
		
		$("#btnChooseMutiUserManager").on(ace.click_event,function(){
			//dialog的使用，请参考官方文档http://aui.github.io/artDialog/doc/index.html
			dialog({
				id:"dialog-user-muti",
	            title: '选择',
	            url: '${ctx}/common/ou/selUserMuti.html',
	            width:550,
	            height:510>document.documentElement.clientHeight?document.documentElement.clientHeight-30:510,
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

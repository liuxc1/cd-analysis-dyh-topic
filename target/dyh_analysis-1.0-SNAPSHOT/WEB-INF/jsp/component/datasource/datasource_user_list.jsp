<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
	<head>
	    <title>数据源授权</title>
		<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
	  	<!--页面自定义的CSS，请放在这里 -->
	    <style type="text/css">
	    	table{
				table-layout: fixed;
			}
			td {
	      		white-space:nowrap;
	      		overflow:hidden;
	      		text-overflow: ellipsis;
			}
	    </style>
	</head>
	
	<body class="no-skin">
		<div class="main-container" id="main-container">
		    <div class="main-content">
		        <div class="main-content-inner fixed-page-header fixed-40">
		            <div id="breadcrumbs" class="breadcrumbs">
		                <ul class="breadcrumb">
		                    <li class="active">
		                        <h5 class="page-title" >
		                 			<i class="fa fa-file-text-o"></i>
		                           	数据源[${datasource.datasourceName }]授权用户列表
		                        </h5>
		                    </li>
		                </ul><!-- /.breadcrumb -->
		
		            </div>
		        </div>
		        <div class="main-content-inner padding-page-content">
		            <div class="page-content">
		                <div class="row">
		                    <div class="col-xs-12">
		                        <form class="form-horizontal" role="form" id="formList" action="${ctx}/component/datasource/user/list.vm" method="post">
		                           	<input type="hidden" name="form[DATASOURCE_ID]" value="${form.DATASOURCE_ID }" />
		                            <div class="page-toolbar align-right list-toolbar">
		                                <button type="button" class="btn btn-xs btn-primary btn-xs-ths" id="btnAdd" data-self-js="addUser()">
		                                    <i class="ace-icon fa fa-plus"></i>
											添加人员
		                                </button>
		                                <button type="button" class="btn btn-xs btn-danger btn-xs-ths" data-self-js="doDelete()" id="btnDelete">
		                                    <i class="ace-icon fa fa-trash-o"></i>
											删除人员
		                                </button>
		                                <button type="button" class="btn btn-xs btn-danger btn-xs-ths" id="btnReturn" data-self-js="goBack()">
						                    <i class="ace-icon fa fa-reply"></i>
											返回
						                </button>
		                             </div>  
		                            <table id="listTable" class="table table-bordered table-hover">
		                                <thead>
			                                <tr>
			                                    <th class="center" style="width: 50px;">
			                                        <label class="pos-rel">
			                                            <input type="checkbox" class="ace" />
			                                            <span class="lbl"></span>
			                                        </label>
			                                    </th>
			                                    <th class="align-center" style="width: 300px;">
			                                    	<i class="ace-icon fa fa-file-o"></i>
													姓名
			                                    </th>
			                                    <th class="align-center" style="width: 300px;">
			                                    	<i class="ace-icon fa "></i>
			                              			用户名
			                                    </th>
			                                </tr>
		                                </thead>
		                                <tbody>
			                                <c:forEach var="item" items="${pageInfo.list}">
				                                <tr>
				                                    <td class="center">
				                                        <label class="pos-rel">
				                                            <input type="checkbox" class="ace" value="${item.datasourceUserId}"/>
				                                            <span class="lbl"></span>
				                                        </label>
				                                    </td>
				                                    <td>${item.userName}</td>
				                                    <td>${item.loginName}</td>
				                                </tr>
											</c:forEach>
		                                </tbody>
		                            </table>
									<%@ include file="/WEB-INF/jsp/_common/paging.jsp"%>
		                        </form>
		                    </div>
		                </div>
		            </div>
		        </div><!--/.main-content-inner-->
		    </div><!-- /.main-content -->
		</div><!-- /.main-container -->

		<iframe id="iframeInfo" name="iframeInfo" class="frmContent"
		        src="" style="border: none; display: none" frameborder="0"
		        width="100%"></iframe>
		        
		<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>

		<!-- 自己写的JS，请放在这里 -->
		<script type="text/javascript">
		
			//调整操作按钮高度
			window.onresize = function() {
		       $(".padding-page-content").css("padding-top",$(".fixed-page-header").height()+5)
		    };
			
			//设置iframe自动高
			autoHeightIframe("iframeInfo");
			
			//返回
			function goBack() {
			    $("#main-container",window.parent.document).show();
			    $("#iframeInfo",window.parent.document).attr("src","").hide();
			}
			
			//搜索
			function doSearch(){
				if( typeof(arguments[0]) != "undefined" && arguments[0] == true)
					$("#pageNum").val(1);
				$("#orderBy").closest("form").submit();
			}
			//批量删除
			function doDelete(){
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
				__doDelete(_ids,"${ctx}/component/datasource/user/delete.vm",function(){
					//刷出之后，刷新列表
					doSearch();
				}, "请选择要移除的授权用户！", "确定要移除授权用户？");
			}
			
			jQuery(function($){
				//初始化表格的事件，如表头排序，列操作等
				__doInitTableEvent("listTable");
				//调整标题高度
				$(".padding-page-content").css("padding-top",$(".fixed-page-header").height()+5);
			});
			
			/*---------------添加人员 开始-----------------*/
			function addUser(){
				dialog({
				       id:"dialog-multi-user",
				       title: '选择',
				       url: '${ctx}/common/ou/selUserMuti.html',
				       width: 650,
				       height: 400,
				}).showModal();
			}
			//回调方法
			function userSelectMutiCallBack(users){
				var loginNames = "";
				var userNames = "";
				for(var i = 0; i < users.length; i++){
					if(loginNames == ""){
						loginNames = users[i].loginName;
						userNames = users[i].name;
					}else{
						loginNames += "," + users[i].loginName;
						userNames += "," + users[i].name;
					}
				}
				if(loginNames != ""){
					ths.submitFormAjax({
						url : '${ctx}/component/datasource/user/save.vm',
						data : "datasourceId=${form.DATASOURCE_ID}&loginNames=" + loginNames + "&userNames=" + userNames,
						success : function(response){
							if(response == 'success'){
								doSearch();
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
			//关闭dialog
			function closeSelectMutiUserDialog(){
				dialog.get("dialog-multi-user").close().remove();
			}
			/*---------------添加人员 结束-----------------*/
		</script>
	</body>
</html>

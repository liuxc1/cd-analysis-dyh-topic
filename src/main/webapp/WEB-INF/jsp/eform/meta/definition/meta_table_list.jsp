<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
	<head>
		<title>数据表列表</title>
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
							<div class="col-xs-12">
								<form class="form-horizontal" role="form" id="formList"
									action="#" method="post">
									<div class="form-group">
										<label class="col-sm-1 control-label no-padding-right">表名称</label>
										<div class="col-sm-3">
											<input type="text" class="form-control" name="form['TABLE_CODE']" value="${form.TABLE_CODE}"/>
										</div>
										<div class="col-sm-8  align-right">
											<div class="space-4 hidden-lg hidden-md hidden-sm"></div>
											<button type="button"
												class="btn btn-info btn-default-ths pull-right"
												data-self-js="doSearch(true)">
												<i class="ace-icon fa fa-search"></i> 搜索
											</button>
										</div>
									</div>
									<hr class="no-margin">
									<div class="page-toolbar align-right list-toolbar">
										<!-- <button type="button" class="btn btn-xs btn-primary btn-xs-ths"
											id="btnAdd" data-self-js="showAddPage()">
											<i class="ace-icon fa fa-plus"></i> 新建
										</button> -->
										<button type="button" class="btn btn-xs btn-inverse btn-xs-ths" data-self-js="showImport()" id="btnExport" >
	                                    <i class="ace-icon fa fa-download"></i> 导入
	                                </button>
										<button type="button" class="btn btn-xs btn-danger btn-xs-ths"
											data-self-js="doDelete()" id="btnDelete">
											<i class="ace-icon fa fa-remove"></i> 删除
										</button>
									</div>
									<div style="width: 100%; max-width: 100%; overflow: auto;">
									<table id="listTable" class="table table-bordered table-hover">
										<thead>
											<tr>
												<th class="center" style="width: 30px">
													<label class="pos-rel"> 
														<input type="checkbox" class="ace" />
														<span class="lbl"></span>
													</label>
												</th>
												<th data-sort-col="TABLE_CODE" style="min-width: 200px">
													<i class="ace-icon fa fa-sliders"></i> 
													表名称 
													<i class="ace-icon fa fa-sort pull-right"></i>
												</th>
												<th data-sort-col="TABLE_NAME" style="min-width: 200px">
													<i class="ace-icon fa fa-code"></i> 
													表别名 
													<i class="ace-icon fa fa-sort pull-right"></i>
												</th>
												<th  data-sort-col="TABLE_DATASOURCE" style="min-width: 150px">
													<i class="ace-icon fa fa-folder-o"></i> 
													数据源 
													<i class="ace-icon fa fa-sort pull-right"></i>
												</th>
												<th class="hidden-xs hidden-sm" data-sort-col="TABLE_SCHEMA" style="min-width: 150px">
													<i class="ace-icon fa fa-eye"></i> 
													SCHEMA 
													<i class="ace-icon fa fa-sort pull-right"></i>
												</th>
												<th class="hidden-xs hidden-sm" data-sort-col="CATEGORY_NAME" style="min-width: 150px">
													<i class="ace-icon fa  fa-bars"></i> 
													分类
													<i class="ace-icon fa fa-sort pull-right"></i>
												</th>
												<th class="align-center " style="width: 150px;min-width: 150px">
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
															<input type="checkbox" class="ace" value="${item.TABLE_ID }" /> 
															<span class="lbl"></span>
														</label>
													</td>
													<td>${item.TABLE_CODE }</td>
													<td class=" ">${item.TABLE_NAME }</td>
													<td class=" ">${item.TABLE_DATASOURCE }</td>
													<td class="hidden-xs hidden-sm">
														<c:choose><c:when test="${item.TABLE_SCHEMA != null }">${item.TABLE_SCHEMA}</c:when><c:otherwise>--</c:otherwise></c:choose>
													</td>
													<td class="hidden-xs hidden-sm">${item.CATEGORY_NAME }</td>
													<td class="align-center col-op-ths">
														<button type="button"
															class="btn btn-sm btn-default btn-white btn-op-ths"
															title="编辑" data-self-js="showEditPage('${item.TABLE_ID}')">
															<i class="ace-icon fa fa-pencil"></i>
														</button>
														<button type="button" class="btn btn-sm btn-grey btn-white btn-op-ths"
																title="删除" data-self-js="doDeleteOne('${item.TABLE_ID }')">
															<i class="ace-icon fa fa-trash"></i>
														</button>
														<button type="button" class="btn btn-sm btn-grey btn-white btn-op-ths"
																title="重新导入" data-self-js="showImport('${item.TABLE_ID }')">
															<i class="ace-icon fa fa-refresh"></i>
														</button>
														<%-- <button type="button"
															class="btn btn-sm btn-grey btn-white btn-op-ths"
															title="子表管理" data-self-href="version/list.vm?definitionId=${item.definitionId }">
															<i class="ace-icon fa fa-history"></i>
		
														</button> --%>
													</td>
												</tr>
											</c:forEach>
										</tbody>
									</table>
									</div>
									<%@ include file="/WEB-INF/jsp/_common/paging.jsp"%>
								</form>
								<form action="${ctx}/bpm/definition/version/export.vm" style="display: none;" target="" method="post" id="exportForm">
									<input type="hidden" name="versionId" id="versionId"/>
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
			
			//导出版本
			function exportFlow(versionId){
				if(versionId == null || versionId.trim().length == 0){
					dialog({
		                title: '提示',
		                content: '流程定义没有当前版本，不能导出!<hr/>',
		                wraperstyle:'alert-info',
		                ok: function () {}
		            }).showModal();
					return;
				}
				var form = $("#exportForm");
				$("#versionId").val(versionId);
				form.submit();
			}
			
			//导入数据表
			function showImport(tableId){
				var url = "${ctx }/eform/meta/definition/meta_table_showimport.vm?form[CATEGORY_ID]=${form.CATEGORY_ID }";
				if(tableId){
					url += "&form[TABLE_ID]=" + tableId;
				}
				dialog({
					id:"dialog-import",
		            title: '数据表导入',
		            url: ths.urlEncode4Get(url),
		            width:550,
		            height:400>document.documentElement.clientHeight?document.documentElement.clientHeight:400,
		        }).showModal();
			}
			
			/* function refreshContent(){
				if($("#iframeInfo").css("display") == "none"){
					//刷新当前页
					location.replace(location.href);
				}else{ 
					//刷新iframInfo
					$("#iframeInfo").attr("src", $("#iframeInfo").attr("src"));
				}
			} */
			
			//关闭dialog
			function closeDialog(id){
				dialog.get(id).close().remove();
			}
			
			var designDefVersionJson = {
				categoryId: "${definition.categoryId }",
				categoryName: decodeURI("${definition.categoryName }")
			};
			
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
		        _ids = _ids == "" ? _ids : _ids.substr(0,_ids.length -1 );
		        
		        /**
				 * 执行数据批量删除
				 *  __ids 为英文逗号分隔的ID字符串,也可仅传递一个ID,执行单个删除
				 *  serverUrl 服务器端AJAX POST 地址
				 *  callBackFn 删除成功的回调函数,无参数,如function(){}
				 */
	        	__doDelete(_ids, "deleteTable.vm", function() {
					//刷出之后，刷新列表
	        		dialog({
          		            title: '提示',
          		            content: '删除成功',
          		            wraperstyle:'alert-info',
          		            ok: function () {
          		            	doSearch();
          		            },
          		            cancel:function(){
          		            	doSearch();
          		            },
          		            cancelDisplay: false
          		        }).showModal();
				});
			}
			
			//删除一条数据，可参考此函数
			function doDeleteOne(id){
				__doDelete(id, "deleteTableOne.vm", function() {
					//刷出之后，刷新列表
	        		dialog({
       		            title: '提示',
       		            content: '删除成功',
       		            wraperstyle:'alert-info',
       		            ok: function () {
       		            	doSearch();
       		            },
       		            cancel:function(){
       		            	doSearch();
       		            },
       		            cancelDisplay: false
       		        }).showModal();
				});
			}
			//跳转到新增页面
			function showAddPage()
			{
				dialog({
					id:"dialog-eform-table-edit",
		            title: '元数据新增',
		            url: ths.urlEncode4Get('${ctx }/eform/meta/definition/meta_table_add.vm?form[CATEGORY_ID]=${form.CATEGORY_ID }'),
		            width:800,
		            height:500>document.documentElement.clientHeight?document.documentElement.clientHeight-20:500,
		           	cancel:function()
		           	{
		           		doSearch();
		           	},
		           	cancelDisplay: false
		        }).showModal();
			}
			//跳转到编辑页面
			function showEditPage(tableId)
			{
				dialog({
					id:"dialog-eform-table-edit",
		            title: '元数据编辑',
		            url: '${ctx}/eform/meta/definition/meta_table_edit.vm?tableId='+tableId,
		            width:800,
		            height:500>document.documentElement.clientHeight?document.documentElement.clientHeight-20:500,
		            cancel:function()
		            {
		            	doSearch();
		            },
		            cancelDisplay: false
		        }).showModal();
				
			}
			
			jQuery(function($){
				//初始化表格的事件，如表头排序，列操作等
				__doInitTableEvent("listTable");
			});
		</script>
	</body>
</html>

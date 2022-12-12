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
			<div class="main-content-inner padding-page-content">
				<div class="page-content">
					<div class="space-4"></div>
					<div class="row">
						<div class="col-xs-12">
							<form class="form-horizontal" role="form" id="formList"
								action="list.vm" method="post">
								<input  type="hidden" id="treeid" name="treeid" value="${form.treeid}">
								<div class="page-toolbar align-right list-toolbar">
									<button type="button" class="btn btn-xs    btn-xs-ths"
										data-self-js="doAdd()">
										<i class="ace-icon fa fa-plus"></i> 添加
									</button>
									<button type="button" class="btn btn-xs btn-xs-ths"
										data-self-js="doDelete()" id="btnDelete">
										<i class="ace-icon fa fa-trash-o"></i> 删除
									</button>
								<!-- 	<button type="button" class="btn btn-xs   btn-xs-ths">
										<i class="ace-icon fa fa-file-excel-o"></i> 导出
									</button> -->
								</div>
								<table id="listTable" class="table table-bordered table-hover">
									<thead>
										<tr>
											<th class="center" style="width:50px">
												<label class="pos-rel"> 
													<input type="checkbox" class="ace" /> 
													<span class="lbl"></span>
												</label>
											</th>
											<th class="" data-sort-col="DICTIONARY_CODE" style="min-width:150px">
												条目编码
												<i class="ace-icon fa fa-sort pull-right"></i>
											</th>
											<th class="" data-sort-col="DICTIONARY_NAME" style="min-width:150px">
												条目名称
												<i class="ace-icon fa fa-sort pull-right"></i>
											</th>
											<th class="hidden-xs" style="min-width:150px">
												所属字典
											</th>
											<th class="hidden-xs hidden-sm"  data-sort-col="DICTIONARY_SORT" style="min-width:150px">
												排序 <i class="ace-icon fa fa-sort pull-right"></i>
											</th>
											<th class="align-center" style="width:150px;min-width:80px">
												<i class="ace-icon fa fa-wrench"></i> 
												操作
											</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="item" items="${pageInfo.list}">
											<tr>
												<td class="center"><label class="pos-rel"> <input
														type="checkbox" class="ace" value="${item.DICTIONARY_ID}" />
														<span class="lbl"></span>
												</label></td>
												<td>${item.DICTIONARY_CODE}</td>
												<td>${item.DICTIONARY_NAME}</td>
												<td class="hidden-xs">${item.TREE_NAME}</td>
												<td class="hidden-xs hidden-sm">${item.DICTIONARY_SORT}</td>
												<td class="align-center col-op-ths">
													<button type="button"
														class="btn btn-sm  btn-white btn-op-ths"
														title="编辑"
														data-self-js="doEdit('${item.DICTIONARY_ID}')">
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
		function doSearch() {
			$("#orderBy").closest("form").submit();
		}
		
		function doAdd(){
			var uuid = generateUUID();
			var url="${ctx}/eform/dic/edit.vm?table['JDP_EFORM_DICTIONARY'].key['DICTIONARY_ID']="+uuid+"&dic_tree_id=${form.treeid}";
			$("#main-container").hide();
	        $("#iframeInfo").attr("src", ths.urlEncode4Get(url)).show();
		}
		
		function doEdit(id){
			var url="${ctx}/eform/dic/edit.vm?table['JDP_EFORM_DICTIONARY'].key['DICTIONARY_ID']="+id+"&dic_tree_id=${form.treeid}";
			$("#main-container").hide();
	        $("#iframeInfo").attr("src", ths.urlEncode4Get(url)).show();
		}

		//批量删除
		function doDelete() {
			var _ids = "";
			$('#listTable > tbody > tr > td:first-child :checkbox:checked')
					.each(function() {
						_ids = _ids + $(this).val() + ",";
					});
			_ids = _ids = "" ? _ids : _ids.substr(0, _ids.length - 1);
			/**
			 * 执行数据批量删除
			 *  __ids 为英文逗号分隔的ID字符串,也可仅传递一个ID,执行单个删除
			 *  serverUrl 服务器端AJAX POST 地址
			 *  callBackFn 删除成功的回调函数,无参数,如function(){}
			 */
			__doDelete(_ids, "delete.vm", function() {
				//刷出之后，刷新列表
				doSearch();
			});
		}

		//删除一条数据，可参考此函数
		function doDeleteOne(id) {
			__doDelete(id, "deleteOne.vm", function() {
				//刷出之后，刷新列表
				doSearch();
			});
		}

		jQuery(function($) {
			//初始化表格的事件，如表头排序，列操作等
			__doInitTableEvent("listTable");

		});
	</script>
</body>
</html>

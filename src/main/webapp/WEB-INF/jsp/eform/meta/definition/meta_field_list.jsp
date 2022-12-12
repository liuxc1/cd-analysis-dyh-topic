<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
	<head>
		<title>数据字段列表</title>
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
									<input type="hidden" id="tableId" name="form['TABLE_ID']" value="${form.TABLE_ID }"/>
									<div class="page-toolbar align-right list-toolbar">
										<!-- <button type="button" class="btn btn-xs btn-primary btn-xs-ths"
											id="btnAdd" data-self-js="showAddPage()">
											<i class="ace-icon fa fa-plus"></i> 添加
										</button> -->
										<button type="button" class="btn btn-xs btn-danger btn-xs-ths"
											data-self-js="doDelete()" id="btnDelete">
											<i class="ace-icon fa fa-remove"></i> 删除
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
												<th data-sort-col="FIELD_CODE" style="min-width: 180px">
													<i class="ace-icon fa "></i> 
													字段编码 
													<i class="ace-icon fa fa-sort pull-right"></i>
												</th>
												<th  data-sort-col="FIELD_NAME" style="min-width: 100px">
													<i class="ace-icon fa "></i> 
													别名
													<i class="ace-icon fa fa-sort pull-right"></i>
												</th>
												<th  data-sort-col="FIELD_DATATYPE" style="min-width: 100px">
													<i class="ace-icon fa "></i> 
													数据类型
													<i class="ace-icon fa fa-sort pull-right"></i>
												</th>
												<th class="align-center " style="width: 150px;min-width: 150px">
													<i class="ace-icon fa fa-wrench"></i> 
													操作
												</th>
											</tr>
										</thead>
										<tbody>
											<c:forEach items="${pageInfo.list }" var="item">
											<tr>
												<td class="center">
													<label class="pos-rel"> 
														<input type="checkbox" class="ace" name="fieldId" value="${item.FIELD_ID }" /> 
														<span class="lbl"></span>
													</label>
												</td>
												<td>${item.FIELD_CODE }</td>
												<td class=" ">
													${item.FIELD_NAME}
												</td>
												<td class="">${item.FIELD_DATATYPE}</td>
												<td class=" align-center col-op-ths">
													<button type="button"
														class="btn btn-sm btn-default btn-white btn-op-ths"
														title="编辑" data-self-js="showEditPage('${item.FIELD_ID }','${item.TABLE_ID }')">
														<i class="ace-icon fa fa-pencil"></i>
													</button>
													<button type="button"
														class="btn btn-sm btn-grey btn-white btn-op-ths"
														title="删除" data-self-js="doDeleteOne('${item.FIELD_ID }')">
														<i class="ace-icon fa fa-trash"></i>
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
				</div>
				<!--/.main-content-inner-->
			</div>
			<!-- /.main-content -->
	
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
	        	__doDelete(_ids, "deleteField.vm", function() {
					//刷出之后，刷新列表
	        		dialog({
          		            title: '提示',
          		            content: '删除成功',
          		            wraperstyle:'alert-info',
          		            ok: function () {
          		            	doSearch();
       		            	$(window.parent.document).find("#ifrmrelation").attr("src", ths.urlEncode4Get("${ctx}/eform/meta/definition/meta_relation_list.vm?form[TABLE_ID]="+$("#tableId").val()));
          		            },
          		            cancel:function(){
          		            	doSearch();
       		            	$(window.parent.document).find("#ifrmrelation").attr("src", ths.urlEncode4Get("${ctx}/eform/meta/definition/meta_relation_list.vm?form[TABLE_ID]="+$("#tableId").val()));
          		            },
          		            cancelDisplay: false
          		        }).showModal();
				});
		        
			}
			
			//删除一条数据，可参考此函数
			function doDeleteOne(id){
				
				__doDelete(id, "deleteFieldOne.vm", function() {
					//刷出之后，刷新列表
	        		dialog({
       		            title: '提示',
       		            content: '删除成功',
       		            wraperstyle:'alert-info',
       		            ok: function () {
       		            	doSearch();
    		            	$(window.parent.document).find("#ifrmrelation").attr("src", ths.urlEncode4Get("${ctx}/eform/meta/definition/meta_relation_list.vm?form[TABLE_ID]="+$("#tableId").val()));
       		            },
       		            cancel:function(){
       		            	doSearch();
    		            	$(window.parent.document).find("#ifrmrelation").attr("src", ths.urlEncode4Get("${ctx}/eform/meta/definition/meta_relation_list.vm?form[TABLE_ID]="+$("#tableId").val()));
       		            },
       		            cancelDisplay: false
       		        }).showModal();
				});
			}
			function showAddPage()
			{
				var _tableId=$("#tableId").val();
				if(_tableId==""){
					dialog({
      		            title: '提示',
      		            content: '基本属性未保存，无法添加字段！',
      		            wraperstyle:'alert-info',
      		            ok: function () {}
      		        }).showModal();
					return;
				}	
				window.parent.parent.dialog({
					id:"dialog-eform-field-edit",
		            title: '字段新增',
		            url: '${ctx}/eform/meta/definition/meta_field_edit.vm?tableId='+_tableId,
		            width:800,
		            height:450>document.documentElement.clientHeight?document.documentElement.clientHeight:450
		        }).showModal();
			}
			
			//跳转到编辑页面
			function showEditPage(fieldId,tableId)
			{
				window.parent.parent.dialog({
					id:"dialog-eform-field-edit",
		            title: '字段编辑',
		            url: '${ctx}/eform/meta/definition/meta_field_edit.vm?fieldId='+fieldId+'&tableId='+tableId,
		            width:800,
		            height:450>document.documentElement.clientHeight?document.documentElement.clientHeight:450
		        }).showModal();
				
			}
			
			
			jQuery(function($){
				//初始化表格的事件，如表头排序，列操作等
				__doInitTableEvent("listTable");
			});
		</script>
	</body>
</html>

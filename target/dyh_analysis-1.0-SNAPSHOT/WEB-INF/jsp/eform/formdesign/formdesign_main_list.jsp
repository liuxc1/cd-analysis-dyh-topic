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
											<input type="text" class="form-control" name="form['TABLE_NAME']" value="${form.TABLE_NAME}"/>
										</div>
										<label class="col-sm-1 control-label no-padding-right">表单名称</label>
										<div class="col-sm-3">
											<input type="text" class="form-control" name="form['FORM_NAME']" value="${form.FORM_NAME}"/>
										</div>
										<div class="col-sm-4  align-right">
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
										<button type="button" class="btn btn-xs btn-primary btn-xs-ths"
											id="btnAdd" data-self-js="doEdit('');">
											<i class="ace-icon fa fa-plus"></i> 新建
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
													<label
														class="pos-rel"> <input type="checkbox" class="ace" />
														<span class="lbl"></span>
													</label>
												</th>
												<th data-sort-col="FORM_CODE" style="min-width:150px">
													<i class="ace-icon fa fa-sliders"></i>
													表单编码
													<i class="ace-icon fa fa-sort pull-right"></i>
												</th>
												<th data-sort-col="FORM_NAME" style="min-width:150px">
													<i class="ace-icon fa fa-code"></i> 
													表单名称 
													<i class="ace-icon fa fa-sort pull-right"></i>
												</th>
												<th data-sort-col="TABLE_CODE" style="min-width:150px">
													<i class="ace-icon fa fa-folder-o"></i> 
													表名称 
													<i class="ace-icon fa fa-sort pull-right"></i>
												</th>
												<th class="hidden-sm hidden-xs" data-sort-col="F.MODIFY_TIME" style="min-width:150px">
													<i class="fa fa-spinner" aria-hidden="true"></i> 
													最后修改时间
													<i class="ace-icon fa fa-sort pull-right"></i>
												</th>
												<th class="hidden-sm hidden-xs" data-sort-col="CATEGORY_NAME" style="min-width:100px">
													分类
													<i class="ace-icon fa fa-sort pull-right"></i>
												</th>
												<th class="align-center " style="width: 210px;min-width:210px">
													<i class="ace-icon fa fa-wrench"></i>
													操作
												</th>
											</tr>
										</thead>
										<tbody>
											<c:forEach var="item" items="${pageInfo.list}">
												<tr>
													<td class="center"><label class="pos-rel"> <input
															type="checkbox" class="ace" value="${item.FORM_ID }" /> <span class="lbl"></span>
													</label></td>
													<td>${item.FORM_CODE }</td>
													<td class=" ">${item.FORM_NAME }</td>
													<td class=" ">${item.TABLE_NAME }</td>
													<td class="hidden-sm hidden-xs" >${item.MODIFY_TIME }</td>
													<td class="hidden-sm hidden-xs">${item.CATEGORY_NAME }</td>
													<td class=" align-center col-op-ths">
														<button type="button"
															class="btn btn-sm btn-default btn-white btn-op-ths"
															title="编辑" data-self-js="doEdit('${item.FORM_ID}')">
															<i class="ace-icon fa fa-edit"></i>
														</button>
														<button type="button"
															class="btn btn-sm btn-default btn-white btn-op-ths"
															title="设计表单" data-self-js="doDesign('${item.FORM_ID}')">
															<i class="ace-icon fa fa-wpforms"></i>
														</button>
														<button type="button"
															class="btn btn-sm btn-default btn-white btn-op-ths"
															title="普通列表" data-self-js="doFormList('${item.FORM_ID}','${item.TABLE_ID}')">
															<i class="ace-icon fa fa-bars"></i>
														</button>
														<c:if test="${not empty item.BPM_PROC_KEY }">
															<button type="button"
																class="btn btn-sm btn-default btn-white btn-op-ths"
																title="流程列表" data-self-js="doBpmFormList('${item.FORM_ID}','${item.BPM_PROC_KEY}')">
																<i class="ace-icon fa fa-server"></i>
															</button>
														</c:if>
														<button type="button"
															class="btn btn-sm btn-default btn-white btn-op-ths"
															title="导出" data-self-js="exportZip('${item.FORM_ID}')">
															<i class="ace-icon fa fa-upload"></i>
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
							</div>
						</div>
					</div>
				</div>
				<!--/.main-content-inner-->
			</div>
			<!-- /.main-content -->
		</div>
		<!-- /.main-container -->
		<iframe id="exportIframe" style="width: 0px;height:0px;display:none"></iframe>
	
		<iframe id="iframeInfo" name="iframeInfo" class="frmContent" src=""
			style="border: none; display: none" frameborder="0" width="100%"></iframe>
	
		<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
	
		<!-- 自己写的JS，请放在这里 -->
		<script type="text/javascript">
			//设置iframe自动高
			autoHeightIframe("iframeInfo");
			function doEdit(form_id){
				console.log(!form_id);
				if(!form_id){
					form_id = generateUUID();
				}
				var url="${ctx}/eform/formdesign/formdesign_main_edit.vm?table['JDP_EFORM_FORM'].key['FORM_ID']="+form_id+"&table['JDP_EFORM_FORM'].column['CATEGORY_ID']=${categoryId}";
				$("#main-container").hide();
		        $("#iframeInfo").attr("src", ths.urlEncode4Get(url)).show();
		        autoHeightIframe("iframeInfo");
			}
			//打开表单设计页面
			function doDesign(form_id){
				window.open("${ctx}/eform/formdesign/formdesign_main_desgin.vm?form_id="+form_id);
			}
			//设计普通列表
			function doFormList(form_id,table_id){
				window.open(ths.urlEncode4Get("${ctx}/eform/formdesign/initFormList.vm?form['FORM_ID']="+form_id+"&form['TABLE_ID']="+table_id));
			}
			//设计流程列表
			function doBpmFormList(form_id,bpm_proc_key){
				window.open(ths.urlEncode4Get("${ctx}/eform/formdesign/initFormList.vm?form['FORM_ID']=" + form_id + "&form[TYPE]=1"));
			}			
			//导入数据表
			function showImport(){
				dialog({
					id:"dialog-import",
		            title: '数据表导入',
		            url: ths.urlEncode4Get('${ctx }/eform/meta/definition/meta_table_showimport.vm?form[CATEGORY_ID]=${form.CATEGORY_ID }'),
		            width:550,
		            height:400>document.documentElement.clientHeight?document.documentElement.clientHeight:400,
		        }).showModal();
			}
			
			function refreshContent(){
				if($("#iframeInfo").css("display") == "none"){
					//刷新当前页
					location.replace(location.href);
				}else{ 
					//刷新iframInfo
					$("#iframeInfo").attr("src", $("#iframeInfo").attr("src"));
				}
			}
			
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
		        __doDelete(_ids,"${ctx}/eform/formdesign/formdesign_main_delete.vm",function(){
					//刷出之后，刷新列表
					doSearch();
				});
			}
			//导出zip
			function exportZip(form_id){
				dialog({
					id:"dialog-export",
		            title: '表单导出',
		            url: '${ctx }/eform/formdesign/formdesign_main_export.vm?formId=' + form_id,
		            width: 800 > document.documentElement.clientWidth ? document.documentElement.clientWidth : 800,
		            height: 560 > document.documentElement.clientHeight ? document.documentElement.clientHeight : 560,
		        }).showModal();
			}
			
			function doExportZip(params){
				$("#exportIframe").attr("src", "${ctx}/eform/formexport/export_zip.vm?" + params);
				closeDialog('dialog-export');
			}
			
			jQuery(function($){
				//初始化表格的事件，如表头排序，列操作等
				__doInitTableEvent("listTable");
			});
		</script>
	</body>
</html>

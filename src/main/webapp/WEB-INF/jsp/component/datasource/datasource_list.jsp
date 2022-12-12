<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
	<head>
	    <title>${THS_JDP_RES_DESC }</title>
		<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
	  	<!--页面自定义的CSS，请放在这里 -->
	    <style type="text/css">
	
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
		                           	${THS_JDP_RES_DESC }
		                        </h5>
		                    </li>
		                </ul><!-- /.breadcrumb -->
		
		            </div>
		        </div>
		        <div class="main-content-inner padding-page-content">
		            <div class="page-content">
		            	<div class="space-4"></div>
		                <div class="row">
		                    <div class="col-xs-12">
		                        <form class="form-horizontal" id="formList" action="${ctx}/component/datasource/list.vm" method="post">
		                        	<input type="hidden" name="THS_JDP_RES_DESC" value="${THS_JDP_RES_DESC }"/>
		                        	<div class="form-group">
										<label class="col-sm-1 control-label no-padding-right" for="txtName">数据源CODE</label>
										<div class="col-sm-2">
		                                   	<input type="text" class="form-control" name="form['DATASOURCE_CODE']" value="${form.DATASOURCE_CODE }">
		                                </div>
		                                <label class="col-sm-1 control-label no-padding-right" for="txtName">数据源名称</label>
										<div class="col-sm-2">
		                                   	<input type="text" class="form-control" name="form['DATASOURCE_NAME']" value="${form.DATASOURCE_NAME }">
		                                </div>
		                                <label class="col-sm-1 control-label no-padding-right" for="txtName">适配器</label>
										<div class="col-sm-3">
		                                   	<div class="input-group">
		                                		<input type="hidden" id="adapterId" name="form['ADAPTER_ID']" value="${form.ADAPTER_ID }"> 
					                  			<span class="width-100">
					                        		<input type="text" class="form-control" id="adapterName" name="form['ADAPTER_NAME']" 
					                        				value="${form.ADAPTER_NAME }" readonly="readonly">
					                       		</span>
					                       		<span class="input-group-btn">
				                                	<button type="button" class="btn btn-white btn-default" onclick="selectAdapter()">
														选择
											      	</button>
											      	<button type="button" class="btn btn-white " onclick="clearInfo(this);">
														<i class="ace-icon fa fa-remove"></i>
													</button> 
				                                </span>
			                         		</div>
		                                </div>
										<div class="col-sm-2  align-right">
											<div class="space-4 hidden-lg hidden-md hidden-sm"></div>
											<button type="button" class="btn btn-info btn-default-ths pull-right" data-self-js="doSearch()">
												<i class="ace-icon fa fa-search"></i> 搜索
											</button>
										</div>
									</div>
									<hr class="no-margin">
		                            <div class="page-toolbar align-right list-toolbar">
		                                <button type="button" class="btn btn-xs btn-primary btn-xs-ths"  data-self-href="${ctx}/component/datasource/edit.vm" id="btnAdd">
		                                    <i class="ace-icon fa fa-plus"></i>
											添加
		                                </button>
		                                <button type="button" class="btn btn-xs btn-danger btn-xs-ths" data-self-js="doDelete()" id="btnDelete">
		                                    <i class="ace-icon fa fa-trash-o"></i>
											删除
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
												<th class="" data-sort-col="DATASOURCE_CODE" style="width: 150px; min-width: 150px;">
			                                    	<i class="ace-icon fa fa-database"></i>
													 数据源CODE
			                                        <i class="ace-icon fa fa-sort pull-right"></i>
			                                    </th>
			                                    <th class="" data-sort-col="DATASOURCE_NAME" style="width: 400px; min-width: 150px;">
			                                    	<i class="ace-icon fa fa-file-o"></i>
													 数据源名称
			                                        <i class="ace-icon fa fa-sort pull-right"></i>
			                                    </th>
			                                    <th class="hidden-xs hidden-sm align-center" style="min-width: 150px;">
			                                    	<i class="ace-icon fa "></i>
			                              			 数据源描述
			                                    </th>
			                                    <th class="" data-sort-col="ADAPTER_NAME" style="width: 160px; min-width: 100px;">
			                                    	<i class="ace-icon fa fa-cog"></i>
													 适配器
			                                        <i class="ace-icon fa fa-sort pull-right"></i>
			                                    </th>
			                                    <th class="hidden-xs align-left sort" data-sort-col="DATASOURCE_ORDERBY" style="width: 70px; min-width: 70px;">
			                              			 排序
			                                        <i class="ace-icon fa fa-sort pull-right"></i>
			                                    </th>
			                                    <th class="align-center" style="width: 158px; min-width: 158px;">
			                                    	<i class="ace-icon fa fa-wrench"></i>
													操作
			                                    </th>
			                                </tr>
		                                </thead>
		                                <tbody>
			                                <c:forEach var="item" items="${pageInfo.list}">
				                                <tr>
				                                    <td class="center">
				                                    	<c:if test="${loginUser == null || item.createUser == loginUser.loginName }">
					                                        <label class="pos-rel">
					                                            <input type="checkbox" class="ace" value="${item.datasourceId}"/>
					                                            <span class="lbl"></span>
					                                        </label>
				                                        </c:if>
				                                    </td>
				                                    <td>${item.datasourceCode}</td>
				                                    <td>${item.datasourceName}</td>
				                                    <td class="hidden-xs hidden-sm">${item.datasourceDescription}</td>
				                                    <td>${item.adapter.adapterName}</td>
				                                    <td class="hidden-xs  align-right">${item.datasourceOrderBy}</td>
				                                    <td class="align-center col-op-ths">
				                                    	<c:if test="${loginUser == null || item.createUser == loginUser.loginName }">
					                                        <button type="button" class="btn btn-sm btn-info btn-white btn-op-ths" title="编辑"
					                                                data-self-href="${ctx}/component/datasource/edit.vm?id=${item.datasourceId}">
					                                            <i class="ace-icon fa fa-edit"></i>
					                                        </button>
					                                        <button type="button" class="btn btn-sm btn-info btn-white btn-op-ths" title="授权"
					                                        		data-self-js="doAuthorize('${item.datasourceId}')">
					                                            <i class="ace-icon fa fa-user"></i>
					                                        </button>
				                                        </c:if>
				                                        <button type="button" class="btn btn-sm btn-info btn-white btn-op-ths" title="查看"
					                                			data-self-href="${ctx}/component/datasource/detail.vm?id=${item.datasourceId}">
					                                    	<i class="ace-icon fa fa-eye"></i>
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
		        </div><!--/.main-content-inner-->
		    </div><!-- /.main-content -->
		</div><!-- /.main-container -->

		<iframe id="iframeInfo" name="iframeInfo" class="frmContent"
		        src="" style="border: none; display: none" frameborder="0"
		        width="100%"></iframe>
		        
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
				__doDelete(_ids,"${ctx}/component/datasource/delete.vm",function(){
					//刷出之后，刷新列表
					doSearch();
				}, "请选择要删除的数据源！", "确定要删除数据源？");
			}
			
			//关闭dialog
			function closeDialog(id){
				dialog.get(id).close().remove();
			}
			
			//授权
			function doAuthorize(datasourceId){
				var url = "${ctx}/component/datasource/user/list.vm?form[DATASOURCE_ID]="+datasourceId;
				url = ths.urlEncode4Get(url);
				$("#main-container").hide();
		        $("#iframeInfo").attr("src",url).show();
			}
			jQuery(function($){
				//初始化表格的事件，如表头排序，列操作等
				__doInitTableEvent("listTable");
			});
			
			/*------------------选择适配器 开始-------------------*/
			function selectAdapter(){
				dialog({
					id:"dialog-adapter",
				        title: '选择',
				        url: '${ctx}/eform/components/table/table_choose.vm?selectType=1&sqlpackage=ths.jdp.component.datasource.mapper.AdapterMapper&mapperid=listDic&closeCallback=closeAdapterDialog&callback=adapterCallback&hiddenId=adapterId&textId=adapterName',
				        width:550,
				        height: 450
				}).showModal();
			}
	        function adapterCallback(table){
				if(table){
					$("#adapterId").val(table.CODE);
					$("#adapterName").val(table.NAME);
				}
			}
	        function closeAdapterDialog(){
				dialog.get("dialog-adapter").close().remove();
	        }
	        /*------------------选择适配器 结束-------------------*/
	        //清空单元格值
			function clearInfo(obj){
				$(obj).closest("div").find("input").each(function(){
					$(this).val("");
				});
			}
		</script>
	</body>
</html>

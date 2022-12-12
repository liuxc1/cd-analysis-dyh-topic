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
		                <div class="row">
		                    <div class="col-xs-12">
		                        <form class="form-horizontal" role="form" id="formList" action="${ctx}/component/datasource/settings/adapter/list.vm" method="post">
		                        	<input type="hidden" name="THS_JDP_RES_DESC" value="${THS_JDP_RES_DESC }"/>
		                            <div class="page-toolbar align-right list-toolbar">
		                                <button type="button" class="btn btn-xs btn-primary btn-xs-ths"  data-self-href="${ctx}/component/datasource/settings/adapter/edit.vm" id="btnAdd">
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
			                                    <th class="center" style="width: 50px;min-width:50px;">
			                                        <label class="pos-rel">
			                                            <input type="checkbox" class="ace" />
			                                            <span class="lbl"></span>
			                                        </label>
			                                    </th>
			                                    <th class="" data-sort-col="ADAPTER_NAME" style="width:200px;min-width:200px;">
			                                    	<i class="ace-icon fa fa-cog"></i>
													适配器名称
			                                        <i class="ace-icon fa fa-sort pull-right"></i>
			                                    </th>
			                                    <th class="" data-sort-col="ADAPTER_CLASS" style="width:430px;min-width:430px;">
													适配器实现类
			                                        <i class="ace-icon fa fa-sort pull-right" ></i>
			                                    </th>
			                                    <th class="hidden-sm hidden-xs align-center"  style="min-width:200px;">
			                              			适配器描述
			                                    </th>
			                                    <th class="hidden-sm hidden-xs" data-sort-col="ADAPTER_ORDERBY" style="width:80px;min-width:80px;">
			                              			 排序
			                                        <i class="ace-icon fa fa-sort pull-right"></i>
			                                    </th>
			                                    <th class="align-center" style="width: 114px;min-width:114px;">
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
				                                            <input type="checkbox" class="ace" value="${item.adapterId}"/>
				                                            <span class="lbl"></span>
				                                        </label>
				                                    </td>
				                                    <td>${item.adapterName}</td>
				                                    <td>${item.adapterClass}</td>
				                                    <td class="hidden-sm hidden-xs">${item.adapterDescription}</td>
				                                    <td class="hidden-sm hidden-xs align-right">${item.adapterOrderBy}</td>
				                                    <td class="align-center col-op-ths">
				                                        <button type="button" class="btn btn-sm btn-info btn-white btn-op-ths" title="编辑"
				                                                 data-self-href="${ctx}/component/datasource/settings/adapter/edit.vm?id=${item.adapterId}">
				                                            <i class="ace-icon fa fa-edit"></i>
				                                        </button>
				                                        <button type="button" class="btn btn-sm btn-info btn-white btn-op-ths" title="参数管理"
				                                                 onclick="paramSetting('${item.adapterId}');">
				                                            <i class="ace-icon fa fa-cogs"></i>
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
			
			function paramSetting(adapterId){
				$("#iframeInfo").attr("src", ths.urlEncode4Get("${ctx}/component/datasource/settings/adapter/param/list.vm?form['ADAPTER_ID']=" + adapterId));
				$("#main-container").hide();
				$("#iframeInfo").show();
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
				__doDelete(_ids,"${ctx}/component/datasource/settings/adapter/delete.vm",function(){
					//刷出之后，刷新列表
					doSearch();
				}, "请选择要删除的适配器！", "确定要删除适配器？");
			}
			
			//关闭dialog
			function closeDialog(id){
				dialog.get(id).close().remove();
			}
			
			jQuery(function($){
				//初始化表格的事件，如表头排序，列操作等
				__doInitTableEvent("listTable");
			});
		</script>
	</body>
</html>

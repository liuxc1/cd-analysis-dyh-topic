<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
<head>
    <title>已办工作</title>
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
                            已办工作
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
                        <form class="form-horizontal" role="form" id="formList" action="done.vm" method="post">
                        	<div class="form-group">
								<label class="col-sm-1 control-label no-padding-right">项目名称</label>
								<div class="col-sm-3">
									<input type="text" class="form-control" name="form[PRO_NAME]" value="${form.PRO_NAME }"/>
								</div>
								<label class="col-sm-1 control-label no-padding-right">流程状态</label>
								<div class="col-sm-2">
									<select name="form[PROC_INST_STATUS]">
										<option value="3">全部</option>
										<option value="0" <c:if test="${form.PROC_INST_STATUS == 0 }">selected="selected"</c:if>>未结束</option>
										<option value="1" <c:if test="${form.PROC_INST_STATUS == 1 }">selected="selected"</c:if>>已结束</option>
									</select>
								</div>
								<div class="col-sm-5  align-right">
									<div class="space-4 hidden-lg hidden-md hidden-sm"></div>
									<button type="button"
											class="btn btn-info pull-right"
											data-self-js="doSearch()">
										<i class="ace-icon fa fa-search"></i> 搜索
									</button>
								</div>
							</div>
                            <table id="listTable" class="table table-bordered table-hover">
                                <thead>
                                <tr>
                                    <th class="" data-sort-col="PRO_NAME"><i class="ace-icon fa fa-file-o"></i>
                                        项目名称
                                        <i class="ace-icon fa fa-sort pull-right"></i>
                                    </th>
                                    <th class=""><i class="ace-icon fa fa-file-o"></i>
		                            	流程是否结束
                                    </th>
                                    <th class="align-center hidden-xs"><i class="ace-icon fa fa-wrench"></i>
                                        操作
                                    </th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="item" items="${pageInfo.list}">
                                <tr>
                                    <td>
                                        ${item.PRO_NAME}
                                    </td>
                                    <td>
                                        ${item.PROC_INST_STATUS == 1 ? "已结束" : "未结束"}
                                    </td>
                                    <td class="hidden-xs align-center col-op-ths">
                                        <button type="button" class="btn btn-sm  btn-white btn-op-ths" title="编辑"
                                                data-self-href="${ctx }/flowdemo/edit.vm?id=${item.PRO_ID}&taskId=${item.TASK_ID}&status=2">
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
	
	jQuery(function($){
		//初始化表格的事件，如表头排序，列操作等
		__doInitTableEvent("listTable");
	});
	
	//搜索
	function doSearch(){
		if( typeof(arguments[0]) != "undefined" && arguments[0] == true)
			$("#pageNum").val(1);
		$("#orderBy").closest("form").submit();
	}
</script>
</body>
</html>

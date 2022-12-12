<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
<head>
    <title>链接WebSocket服务的客户端</title>
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
                           链接WebSocket服务的客户端
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
                        <form class="form-horizontal" role="form" id="formList" action="socket_list.vm" method="post">

                            <div class="form-group">
                                <label class="col-sm-1 control-label no-padding-right" for="txtName">
                                    客户端账号
                                </label>
                                <div class="col-sm-3">
                                       <input type="text" class="form-control"  name="form['customCode']"  value="${form.customCode}" />
                                </div>
                                <div class="col-sm-3  align-left">
                                    <div class="space-4 hidden-lg hidden-md hidden-sm"></div>
                                    <button type="button" class="btn btn-info btn-default-ths pull-left"  data-self-js="doSearch(true)">
                                        <i class="ace-icon fa fa-search"></i>
                                        搜索
                                    </button>
                                </div>
                            </div>
                            <hr class="no-margin">
                            <table id="listTable" class="table table-bordered table-hover">
                                <thead>
                                <tr>
                                    <th ><i class="ace-icon fa fa-file-o"></i>
                                        客户端账号
                                    </th>
                                    <th ><i class="ace-icon fa fa-file-o"></i>
                                        最后访问时间
                                    </th>
                                    <th ><i class="ace-icon fa "></i>
                                        客户端个数
                                    </th>
                                    <th class="align-center hidden-xs"><i class="ace-icon fa fa-wrench"></i>
                                        操作
                                    </th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="item" items="${pageInfo.list}">
                                <tr>
                                    <td class="hidden-xs "> ${item.customCode}</td>
                                    <td class="hidden-xs "> ${item.lastTime}</td>
                                    <td class="hidden-xs "> ${item.clientCount}</td>
                                    
                                    <td class="hidden-xs align-center col-op-ths">
                                    	<button type="button" class="btn btn-sm btn-info btn-white btn-op-ths" title="详情"
                                                 data-self-js="doRead('${item.customCode}')">
                                            <i class="ace-icon fa fa-eye"></i>
                                        </button>
                                        <button type="button" class="btn btn-sm btn-info btn-white btn-op-ths" title="发送命令"
                                                 data-self-js="doOperate('${item.customCode}')">
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
		__doDelete(_ids,"delete.vm",function(){
			//刷出之后，刷新列表
			doSearch();
		});
	}
	
	//查看(增、改、查页面如果都是采用调用方法的方式打开，可以采用下面的方式展示)
	function  doRead(customCode){
		var url = "socket_detail.vm?form[customCode]="+customCode;
		url = ths.urlEncode4Get(url);
		$("#main-container").hide();
        $("#iframeInfo").attr("src",url).show();
	}
	//关闭dialog
	function closeDialog(id){
		dialog.get(id).close().remove();
	}
	//删除一条数据，可参考此函数
	function doDeleteOne(id){
		__doDelete(id,"profee_deleteOne.vm",function(){
			//刷出之后，刷新列表
			doSearch();
		});
	}
	//运行脚本
	function doOperate(customCode){
		var url="socket_operate.vm?form[customCode]="+customCode;
		url = ths.urlEncode4Get(url);
		$("#main-container").hide();
        $("#iframeInfo").attr("src",url).show();
	}
	jQuery(function($){
		//初始化表格的事件，如表头排序，列操作等
		__doInitTableEvent("listTable");
		
		  $("#btnDateStart").on(ace.click_event, function () { WdatePicker({el: "txtDateStart"});});
		  $("#btnDateEnd").on(ace.click_event, function () { WdatePicker({el: "txtDateEnd"});});
	});
	function toMenu(){
		window.top.location.href = "${ctx}/index.vm?tomenuid=0d895308-150e-4ad4-a26b-a6b94e00b0e8";
		//window.top.location.href = "${ctx}/index.vm?tomenuid=8c46cf73-3e6f-4535-b7a1-1f994d2c9dc7";
	}
</script>
</body>
</html>

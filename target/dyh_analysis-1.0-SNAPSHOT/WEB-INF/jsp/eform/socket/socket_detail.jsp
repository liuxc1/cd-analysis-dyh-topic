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
                           客户端【${form.customCode }】的链接明细
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
                                <div class="col-sm-12  align-left">
                                    <div class="space-4 hidden-lg hidden-md hidden-sm"></div>
                                    <button type="button" class="btn btn-danger btn-default-ths pull-right"  data-self-js="goBack()">
                                        <i class="ace-icon fa fa-reply"></i>
                                      返回
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
                                        客户端Id
                                    </th>
                                    <th ><i class="ace-icon fa fa-file-o"></i>
                                       创建时间
                                    </th>
                                    <th class="align-center hidden-xs"><i class="ace-icon fa fa-wrench"></i>
                                        操作
                                    </th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="item" items="${returnList}">
                                <tr>
                                    <td class="hidden-xs "> ${item.customCode}</td>
                                    <td class="hidden-xs "> ${item.customId}</td>
                                    <td class="hidden-xs "> ${item.createTime}</td>
                                    <td class="hidden-xs align-center col-op-ths">
                                        <button type="button" class="btn btn-sm btn-info btn-white btn-op-ths" title="发送命令"
                                                 data-self-js="doOperate('${item.customId}','${item.customCode}')">
                                            <i class="ace-icon fa fa-edit"></i>
                                        </button>
                                    </td>
                                </tr>
								</c:forEach>
                                </tbody>
                            </table>
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
	//运行脚本
	function doOperate(customId,customCode){
		var url="socket_operate.vm?form[customId]="+customId+"&form[customCode]="+customCode;
		url = ths.urlEncode4Get(url);
		$("#main-container").hide();
        $("#iframeInfo").attr("src",url).show();
	}
	function goBack(){
		 $("#main-container",window.parent.document).show();
		 $("#iframeInfo",window.parent.document).attr("src","").hide();
	}
	
</script>
</body>
</html>

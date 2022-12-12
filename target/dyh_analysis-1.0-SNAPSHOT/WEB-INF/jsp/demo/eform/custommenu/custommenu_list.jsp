<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
<head>
    <title>项目费用</title>
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
                            自定义菜单
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
                        <form class="form-horizontal" role="form" id="formList" action="list.vm" method="post">
							<h2>
							目前平台提供的自定义菜单样式如下
							</h2>
                            <hr class="no-margin">
                            <div class="page-toolbar align-right list-toolbar">
                               <button type="button" class="btn btn-xs  btn-xs-ths" data-self-js="openWiki()" id="btnExport" >
                                    <i class="ace-icon fa fa-file-excel-o"></i>
                                    打开wiki
                                </button>
                            </div>
                            <table id="listTable" class="table table-bordered table-hover">
                                <thead>
                                <tr>
                                    <th><i class="ace-icon fa fa-file-o"></i>
                                       主题名称
                                    </th>
                                    <th><i class="ace-icon fa "></i>
                                        主题描述
                                    </th>
                                    <th class="align-center hidden-xs"><i class="ace-icon fa fa-wrench"></i>
                                        操作
                                    </th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr>
                                    <td>
                                    default    
                                    </td>
                                    <td class="hidden-xs ">
                    					平台默认菜单样式，按层级向下展开，使用的是平台默认的样式文件
                                    </td>
                                    <td class="hidden-xs align-center col-op-ths">
                                        <button type="button" class="btn btn-sm  btn-white btn-op-ths" title="打开"
                                                 data-self-js="openMenu('default','demo')">
                                            <i class="ace-icon fa fa-edit"></i>
                                        </button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                   		drawer_black_lr    
                                    </td>
                                    <td class="hidden-xs "> 
                                    	黑色自定义菜单，菜单按层级向右悬浮展开，单独写的一套样式文件，样式文件已集成在原型工程里
                                    </td>
                   
                                    <td class="hidden-xs align-center col-op-ths">
                                        <button type="button" class="btn btn-sm  btn-white btn-op-ths" title="打开"
                                                 data-self-js="openMenu('drawer_black_lr','drawer')">
                                            <i class="ace-icon fa fa-edit"></i>
                                        </button>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                             <%--  <%@ include file="/WEB-INF/jsp/_common/paging.jsp"%> --%>
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
	//打开wiki说明
	function openWiki(){
		window.open("http://192.168.0.140:8080/wiki/en/Jdp4.0.release#a_.E8.87.AA.E5.AE.9A.E4.B9.89.E8.8F.9C.E5.8D.95.E7.BB.84.E4.BB.B6")
	}
	
	//打开自定义菜单
	function openMenu(theme,xmlname){
		window.open("${ctx}/menu/main.vm?theme="+theme+"&xmlname="+xmlname);
	}
</script>
</body>
</html>

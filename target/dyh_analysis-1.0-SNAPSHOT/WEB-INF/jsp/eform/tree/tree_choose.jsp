<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!-- //
 	/**
     一、选择部门(单选,多选请使用treeDeptMuti.html)组件调用说明：
     1..在父页面声明函数deptSelectCallBack(dept){},点击树节点后，将调用父页面的deptSelectCallBack函数，
     并将已点击的部门作为dept参数传递过去，
     dept 格式为 {id: "P00AE4DBCF194B7BB7214ED0ED41E979", name: "海淀区环保局", code: "hdq", orgid: "P00AE4DBCF194B7BB7214ED0ED41E979"}
      使用示例如下：
     function deptSelectCallBack(dept){
        //console.log(dept);
        var id = dept.id;
        var name = dept.name;
        alert(name);
     }
     2.在父页面声明函数
     function closeSelectDeptDialog(){
           dialog.get("dialog-ID").close().remove();
     }
     点击树节点后，将调用父页面closeSelectDeptDialog函数，以关闭Dialog。
     帮助？mailto:wangml1@internal.ths.com.cn
     */
     二、参数说明
     treeDept.html?orgid=xxxx-UUID
     则从指定ID为根，列出其下的部门树
     orgid可不传，不传默认从root下构造树
    //  -->
<!DOCTYPE html>
<html lang="zh">
<head>
    <!--浏览器兼容性设置-->
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <meta charset="utf-8"/>
    <title></title>

    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0"/>

    <!-- bootstrap & fontawesome -->
    <link rel="stylesheet" href="${ctx}/assets/css/common/bootstrap.css?v=20221129015223"/>
    <link rel="stylesheet" href="${ctx}/assets/components/font-awesome/css/font-awesome.css?v=20221129015223"/>

    <!-- page plugin css -->
    <!--zTree-->
    <link rel="stylesheet" href="${ctx}/assets/components/zTree/css/metroStyle/metroStyle.css?v=20221129015223"/>

    <!-- ace styles -->
    <link rel="stylesheet" href="${ctx}/assets/css/common/ace.css?v=20221129015223" class="ace-main-stylesheet" id="main-ace-style"/>

    <!--[if lte IE 9]>
    <link rel="stylesheet" href="${ctx}/assets/css/common/ace-part2.css?v=20221129015223" class="ace-main-stylesheet"/>
    <![endif]-->


    <!--[if lte IE 9]>
    <link rel="stylesheet" href="${ctx}/assets/css/common/ace-ie.css?v=20221129015223"/>
    <![endif]-->

    <!--THS CSS 插件-->
    <link rel="stylesheet" href="${ctx}/assets/css/common/ths-custom.css?v=20221129015223"/>

    <!-- 自己写的CSS，请放在这里 -->
    <style type="text/css">
        .widget-box{
            margin: 0px !important;
            margin-top: -3px !important;
        }
        .tab-content {
            border: none !important;
        }
        .widget-box.transparent > .widget-header {
             border-bottom: 1px solid #C5D0DC !important;
         }
        .widget-box.transparent > .widget-header {
            border-bottom: 1px solid #C5D0DC !important;
        }
       @font-face {
	font-family: 'FontAwesome';
	src: url('${ctx}/assets/components/font-awesome/fonts/fontawesome-webfont.eot?v=4.5.0');
	src: url('${ctx}/assets/components/font-awesome/fonts/fontawesome-webfont.eot?#iefix&v=4.5.0')
		format('embedded-opentype'),
		url('${ctx}/assets/components/font-awesome/fonts/fontawesome-webfont.woff2?v=4.5.0')
		format('woff2'),
		url('${ctx}/assets/components/font-awesome/fonts/fontawesome-webfont.woff?v=4.5.0')
		format('woff'),
		url('${ctx}/assets/components/font-awesome/fonts/fontawesome-webfont.ttf?v=4.5.0')
		format('truetype'),
		url('${ctx}/assets/components/font-awesome/fonts/fontawesome-webfont.svg?v=4.5.0#fontawesomeregular')
		format('svg');
	font-weight: normal;
	font-style: normal;
}

.ztree li span.button.org_ico_open,.ztree li span.button.org_ico_close {

}

.ztree li span.button.org_ico_open,
.ztree li span.button.org_ico_close,
.ztree li span.button.org_ico_docu,
.ztree li span.button.ico_open,
.ztree li span.button.ico_close,
.ztree li span.button.ico_docu
	{
	background-image: none !important;
	*background-image: none !important;
}

.ztree li span.button:after,.ztree li span.button:after,.ztree li span.button:after
	{
	width: 1.25em;
	margin-top:3px;
	text-align: center;
	display: inline-block;
	font: normal normal normal 14px/1 FontAwesome;
	font-size: 15px;
	text-rendering: auto;
	-webkit-font-smoothing: antialiased;
	-moz-osx-font-smoothing: grayscale;
}

.ztree li span.button.org_ico_open:after,.ztree li span.button.org_ico_close:after,.ztree li span.button.org_ico_docu:after
	{
	content: "  \f0e8";
}

.ztree li span.button.ico_close:after,.ztree li span.button.ico_docu:after
	{
	content: "  \f114";
}

.ztree li span.button.ico_open:after {
	content: "  \f115";
}
    </style>

    <!-- HTML5shiv and Respond.js for IE8 to support HTML5 elements and media queries -->

    <!--[if lte IE 8]>
    <script src="${ctx}/assets/components/html5shiv/dist/html5shiv.min.js?v=20221129015223"></script>
    <script src="${ctx}/assets/components/respond/dest/respond.min.js?v=20221129015223"></script>
    <![endif]-->
</head>

<body class="no-skin">

<div class="main-container" id="main-container">
    <div class="main-content">
        <div class="main-content-inner padding-page-content">
                <div style="padding-top: 5px">
                    <div class="col-xs-12  padding5">
                           <div class="widget-box transparent">

                               <div id="divTreeWidget" class="widget-body" style="margin-right: -1px;overflow: auto">
                                   <div class="widget-main padding-2">
                                   <i id="loading" class="ace-icon fa fa-spinner fa-spin orange bigger-200"></i>
                                       <ul id="treeDiv" class="ztree no-padding"></ul>
                                   </div>
                               </div>
                           </div>
                    </div>
                </div>
        </div><!--/.main-content-inner-->
    </div><!-- /.main-content -->
</div><!-- /.main-container -->

<%-- <input type="hidden" id="rootid"  value="${rootid}" >
 --%><input type="hidden" id="mapperid"  value="${mapperid}" >
<!-- basic scripts -->

<!--[if !IE]> -->
<script src="${ctx}/assets/components/jquery/dist/jquery.js?v=20221129015223"></script>
<!-- <![endif]-->

<!--[if IE]>
<script src="${ctx}/assets/components/jquery.1x/dist/jquery.js?v=20221129015223"></script>
<![endif]-->
<script type="text/javascript">
    if ('ontouchstart' in document.documentElement) document.write("<script src='${ctx}/assets/components/jquery.mobile.custom/jquery.mobile.custom.js?v=20221129015223'>" + "<" + "/script>");
</script>
<script src="${ctx}/assets/components/bootstrap/dist/js/bootstrap.js?v=20221129015223"></script>

<!-- page specific plugin scripts -->
<!--zTree-->
<script src="${ctx}/assets/components/zTree/js/jquery.ztree.all.min.js?v=20221129015223"></script>

<!--ace script-->
<script src="${ctx}/assets/js/ace.js?v=20221129015223"></script>

<script src="${ctx}/assets/js/ths-util.js?v=20221129015223"></script>

<!-- 自己写的JS，请放在这里 -->
<script type="text/javascript">
		var zTreeObj;
		var serverNodeArray=[];//服务器端返回的节点数组
		// zTree 的参数配置，深入使用请参考 API 文档（setting 配置详解）
		var setting = {
			data: {
				simpleData: {
					enable: true
				}
			}
		};
		//var treeid=ths.getUrlParam("treeid")
		var mapperid=$("#mapperid").val();

		//Ajax 请求tree
		function loadTreeAjax()
		{
			$("#treeDiv").hide();
			$("#loading").show();
			$.ajax( {
	 	        url:'${ctx}/eform/tree/nodes.vm',
	 	        data:${paramMap},
	 	        type:'post',
	 	        cache:false,
	 	        dataType:'json',
	 	        success:function(data) {
	 	        	serverNodeArray = data;
	 	        	renderTreeAdapter();
	 	         },
	 	         error : function() {
	 	        	//console.log("error");
	 	         }
		 	});
		}
		//绘制tree
		function renderTreeAdapter()
		{
			var zNodes =[];var j  = 0;
			for(var i = 0 ; i<serverNodeArray.length;i++)
			{
				var node_str = JSON.stringify(serverNodeArray[i]);
				node_str = node_str.replace(/\"/g, "~S~");
				var node = {};
	   			node.id = serverNodeArray[i].TREE_ID;
	   			node.pId = serverNodeArray[i].TREE_PID != undefined?serverNodeArray[i].TREE_PID:"";
	   			node.name = serverNodeArray[i].TREE_NAME;
	   			node.iconSkin = "";
				node.click= "redirect('" + node_str + "');"
	   			zNodes[j++] =node;
			}
			console.log(zNodes);
			zTreeObj = $.fn.zTree.init($("#treeDiv"), setting, zNodes);
			$("#treeDiv").show();
			$("#loading").hide();
		}

		function redirect(nodeJson)
		{
			nodeJson = nodeJson.replace(/~S~/g, "\"").replace(/\\/g, ".");
			console.log(nodeJson);
			var treeNode = JSON.parse(nodeJson);
			if(window.parent && window.parent.${callback})
			{
				window.parent.${callback}(treeNode);
			}
			if(window.parent && window.parent.closeTreeDialog)
			{
				window.parent.closeTreeDialog();
			}
		}

		jQuery(function ($) {
		    $("#refreshTree").on(ace.click_event,function(){
		    	 loadTreeAjax();
		    });
		    //加载Tree
		    loadTreeAjax();
		});
</script>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>

<!DOCTYPE html>
<html lang="zh">
<head>
	<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>

    <!-- page plugin css -->
    <!--zTree-->
    <link rel="stylesheet" href="${ctx}/assets/components/zTree/css/metroStyle/metroStyle.css"/>

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
    <!-- 自定义tree图标样式文件 -->
	<link rel="stylesheet" href="${ctx}/assets/js/eform/tree_custom.css"/>
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
 --%>
<%--  <input type="hidden" id="mapperid"  value="${mapperid}" >  --%>
<!-- basic scripts -->

<!--[if !IE]> -->
<script src="${ctx}/assets/components/jquery/dist/jquery.js"></script>
<!-- <![endif]-->

<!--[if IE]>
<script src="${ctx}/assets/components/jquery.1x/dist/jquery.js"></script>
<![endif]-->
<script type="text/javascript">
    if ('ontouchstart' in document.documentElement) document.write("<script src='${ctx}/assets/components/jquery.mobile.custom/jquery.mobile.custom.js'>" + "<" + "/script>");
</script>
<script src="${ctx}/assets/components/bootstrap/dist/js/bootstrap.js"></script>

<!-- page specific plugin scripts -->
<!--zTree-->
<script src="${ctx}/assets/components/zTree/js/jquery.ztree.all.min.js"></script>

<!--ace script-->
<script src="${ctx}/assets/js/ace.js"></script>

<script src="${ctx}/assets/js/ths-util.js"></script>

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
	 	        url:'${ctx}/custom/tree/nodes.vm',  
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
	   			if(serverNodeArray[i].ICONSKIN != null){
	   				node.iconSkin = serverNodeArray[i].ICONSKIN;
	   			}
				node.click= "redirect('" + node_str + "');"
	   			zNodes[j++] =node;
			}
			console.log(zNodes);
			zTreeObj = $.fn.zTree.init($("#treeDiv"), setting, zNodes);
			var allnodes=zTreeObj.getNodes();
			if(allnodes.length>0){
				zTreeObj.expandNode(allnodes[0],true,false,true)
			}
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

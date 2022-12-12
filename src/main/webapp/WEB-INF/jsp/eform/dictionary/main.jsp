<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="en">

<head>

<title></title>
<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>

<!--zTree-->
<link rel="stylesheet"
	href="${ctx}/assets/components/zTree/css/metroStyle/metroStyle.css" />

<!-- 自己写的CSS，请放在这里 -->
<style type="text/css">
.widget-box {
	margin: 0px !important;
	margin-top: -3px !important;
}

.tab-content {
	border: none !important;
}

.widget-box.transparent>.widget-header {
	border-bottom: 1px solid #C5D0DC !important;
}

.widget-box.transparent>.widget-header {
	border-bottom: 1px solid #C5D0DC !important;
}

.widget-box.transparent>.widget-body {
	border-right: 1px solid #C5D0DC !important;
}

.tab-content {
	padding: 1px 1px !important;
}

@font-face {
	font-family: 'FontAwesome';
	src: url('${ctx}/assets/ace/font-awesome/fonts/fontawesome-webfont.eot?v=4.5.0');
	src:
		url('${ctx}/assets/components/font-awesome/fonts/fontawesome-webfont.eot?#iefix&v=4.5.0')
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

.ztree li span.button.org_ico_open,.ztree li span.button.org_ico_docu,.ztree li span.button.org_ico_close,.ztree li span.button.ico_open,.ztree li span.button.ico_close,.ztree li span.button.ico_docu
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

.ztree li span.button.org_ico_open:after,
.ztree li span.button.org_ico_close:after,
.ztree li span.button.org_ico_docu:after
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
</head>

<body class="no-skin">

	<div class="main-container" id="main-container">
		<div class="main-content">
			<div class="main-content-inner padding-page-content">
				<div style="padding-top: 5px">
					<div class="col-xs-12 no-padding">
						<div class="col-xs-2 no-padding">
							<div class="widget-box transparent">
								<div class="widget-header">
									<h5 class="widget-title lighter smaller hidden-sm hidden-xs"
										style="margin-left: 5px">字典树</h5>
									<div class="widget-toolbar no-border">
										<a href="#" data-action="reload" id="refreshTree"> <i
											class="ace-icon fa fa-refresh"></i>
										</a>
									</div>
								</div>
								<div id="divTreeWidget" class="widget-body"
									style="margin-right: -1px; overflow: auto">
									<div class="widget-main padding-2">
										<i id="loading"
											class="ace-icon fa fa-spinner fa-spin orange bigger-200"></i>
										<ul id="treeDic" class="ztree no-padding"></ul>
									</div>
								</div>
							</div>

						</div>
						<div class="col-xs-10 tabable no-padding">
							<ul id="myTab" class="nav nav-tabs ">
								<li class="active"><a href="#dictree" data-toggle="tab"> <i
										class=" ace-icon fa fa-sitemap bigger-120"></i> 字典分类
								</a></li>
								<li class=""><a href="#dic" data-toggle="tab"> <i
										class=" ace-icon fa fa-user bigger-120"></i>字典 
								</a></li>

							</ul>

							<div id="tab-content" class="tab-content">
								<div class="tab-pane in active" id="dictree">
									<iframe id="iframeDicTree" name="iframeDicTree" class="frmContent"
										src="${ctx}/eform/dictionarytree/list.vm?treeid=root" style="border: none" frameborder="0" width="100%"></iframe>
								</div>
								<div class="tab-pane" id="dic">
									<iframe id="iframeDic" name="iframeDic" class="frmContent"
										src=""
										style="border: none" frameborder="0" width="100%"></iframe>
								</div>
							</div>
							<iframe id="iframeInfo" name="iframeInfo" class="frmContent"
								src="" style="border: none; display: none" frameborder="0"
								width="100%"></iframe>

						</div>
					</div>
				</div>
			</div>
			<!--/.main-content-inner-->
		</div>
		<!-- /.main-content -->
	</div>
	<!-- /.main-container -->

	<!-- basic scripts -->
	<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>

	<!-- page specific plugin scripts -->
	<!--zTree-->
	<script src="${ctx}/assets/components/zTree/js/jquery.ztree.all.min.js"></script>


	<!-- 自己写的JS，请放在这里 -->
	<script type="text/javascript">
	var browser=navigator.appName;
	function resizeIframe() {
	    var height = document.documentElement.clientHeight;
	    if(browser=="Microsoft Internet Explorer"
	    		&& (navigator.userAgent.indexOf("MSIE 6.0")>0 || navigator.userAgent.indexOf("MSIE 7.0")>0))
	    {
	        alert("请使用IE8+浏览器，推荐Google Chrome。");
	        //TODO: 提示用户升级
	    }
	    else
	    {
	        height -= document.getElementById('tab-content').offsetTop;
	    }
	
	    height -= 11;//边框的高度之和
	    /* whatever you set your body bottom margin/padding to be */
	    document.getElementById('iframeDic').style.height = height + "px";
	    document.getElementById('iframeDicTree').style.height = height + "px";
	    document.getElementById('iframeInfo').style.height = height + "px";
	    document.getElementById('divTreeWidget').style.height = height + "px";
	}
	var frmRole = document.getElementById('iframeDicTree');
	if (frmRole.attachEvent){
		frmRole.attachEvent("onload", function(){
			resizeIframe();
	    });
	} else {
		frmRole.onload = function(){
			resizeIframe();
	    };
	}
	
	window.onresize = resizeIframe;
	
	function showDetail(url)
	{
		$("#tab-content>.active").append($("#iframeInfo"));
		$("#tab-content>.active>iframe").hide();
		$("#iframeInfo").attr("src",url).show();
	}
	function showList(refresh)
	{
		$("#iframeInfo").attr("src","#").hide();
		if(refresh)
			$("#tab-content>.active>iframe")[0].contentWindow.submitForm();
		$("#tab-content>.active>iframe:first").show();
	}
	
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
    var url = "${ctx}/eform/dictionarytree/list.vm";
    var treeid = "root";
    var target = "iframeDicTree";
    
    //Ajax 请求tree
    function loadTreeAjax()
    {
    	$("#treeDic").hide();
    	$("#loading").show();
    	 $.ajax( {  
 	        url:'${ctx}/eform/dictionarytree/tree.vm?filetype=json&treeid=' + treeid,  
 	        type:'get',  
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
   			var node = {};
   			node.id = serverNodeArray[i].TREE_ID;
   			node.pId = serverNodeArray[i].TREE_PID != undefined?serverNodeArray[i].TREE_PID:"";
   			node.name = serverNodeArray[i].TREE_NAME;
   			node.iconSkin = "";
   			node.open =false;
			node.click= "redirect('" + serverNodeArray[i].TREE_ID + "');"
   			zNodes[j++] =node;
   		}
   		zTreeObj = $.fn.zTree.init($("#treeDic"), setting, zNodes);
   		$("#treeDic").show();
   		$("#loading").hide();
   		zTreeObj.selectNode(zTreeObj.getNodeByParam("id", "root"));
   		treeid = "root";
    }

	function redirect(_treeid)
	{
		treeid = _treeid;
		$("#" + target).attr("src",url + "?treeid=" + treeid);
		showList(false);
	}

    
	jQuery(function ($) {
		
	    $('#myTab a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
	
	        switch ($(e.target).attr('href'))
	        {
	            case "#dic":
	            	target = "iframeDic";
	            	url = "${ctx}/eform/dictionary/list.vm";
	                break;
	            case "#dictree":
	            	target = "iframeDicTree";
	            	url = "${ctx}/eform/dictionarytree/list.vm";
	                break;
	            default:
	                alert("无法识别的Tab href");
	                break;
	        }
	        if($("#" + target).attr("src") != url + "?treeid=" + treeid)
	        	$("#" + target).attr("src", url + "?treeid=" + treeid);
	        showList(false);
	    })
	    $("#refreshTree").on(ace.click_event,function(){
	    	 loadTreeAjax();
	    });
	    
	    //加载Tree
	    loadTreeAjax();
	 
	});
</script>
</body>
</html>

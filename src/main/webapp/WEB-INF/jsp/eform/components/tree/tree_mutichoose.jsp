<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>

<!DOCTYPE html>
<html lang="en">
<head>
	<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
	<!--zTree-->
	<link rel="stylesheet" href="${ctx}/assets/components/zTree/css/metroStyle/metroStyle.css"/>

    <!-- 自己写的CSS，请放在这里 -->
    <style type="text/css">
        .widget-box{
            margin: 0px !important;
           /*  margin-top: -3px !important; */
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
        
        .ztree li span.button.chk.checkbox_false_part {background-position: -5px -5px !important;}
		.ztree li span.button.chk.checkbox_false_part_focus {background-position: -5px -26px !important;}
		.ztree li span.button.chk.checkbox_true_part {background-position: -26px -5px !important;}
		.ztree li span.button.chk.checkbox_true_part_focus {background-position: -26px -26px !important;}
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
.ztree li span.button.leaf_ico_docu:after
	{
	content: "  \f1de";
}
.ztree li span.button.ico_open:after {
	content: "  \f115";
}
    </style>
    <!-- 自定义tree图标样式文件 -->
	<link rel="stylesheet" href="${ctx}/assets/js/eform/tree_custom.css"/>

    <!-- HTML5shiv and Respond.js for IE8 to support HTML5 elements and media queries -->

    <!--[if lte IE 8]>
    <script src="${ctx}/assets/components/html5shiv/dist/html5shiv.min.js"></script>
    <script src="${ctx}/assets/components/respond/dest/respond.min.js"></script>
    <![endif]-->
</head>

<body class="no-skin">

	<div class="main-container" id="main-container">
		<div class="main-content">
			<div class="main-content-inner padding-page-content">
				<div style="padding-top: 2px">
					<div class="col-xs-12  padding5">
						<c:if test="${paramMapObj.toolbar!='false'}">
						<div class="widget-box transparent">
							<div class="widget-header">
	                 			<label class="pos-rel" style="line-height: 30px;padding-top: 3px;">
	                       			<input type="checkbox" class="ace treeOption"  id="cbRelatParent" /> 
	                          		<span class="lbl grey">关联父</span>
								</label>
								&nbsp;
								<label class="pos-rel" style="line-height: 30px;padding-top: 3px;">
	                           		<input type="checkbox" class="ace treeOption"  id="cbRelatChild"/> 
	                        		<span class="lbl grey">关联子</span>
								</label>
								<div class="widget-toolbar no-border">
									<button type="button" class="btn btn-xs btn-primary btn-xs-ths" id="btnOK">
										<i class="ace-icon fa fa-check"></i> 确定
									</button>
								</div>
							</div>
						</div>
						</c:if>
						<div id="divTreeWidget" class="widget-body" style="margin-right: -1px; overflow: auto">
							<div class="widget-main padding-2">
								<i id="loading" class="ace-icon fa fa-spinner fa-spin orange bigger-200"></i>
								<ul id="treeDiv" class="ztree no-padding"></ul>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!--/.main-content-inner-->
	</div>
		<!-- /.main-content -->
	<!-- /.main-container -->
	
	
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
		var selectNodes="";
		var zTreeObj;
		var serverNodeArray=[];//服务器端返回的节点数组
		//设置树的同步异步加载机制
		var async=false;
		if(ths.getUrlParam("async")=="true"){
			async=true;
		}
		var paramMap=${paramMap};
		// zTree 的参数配置，深入使用请参考 API 文档（setting 配置详解）
		var setting = {
			data: {
				simpleData: {
					enable: true
				}
			},
			check: {
				enable: true,
				chkStyle: "checkbox",
				chkboxType :{ "Y" : "", "N" : "" }
			},
			async: {
				enable: async,
				url:"${ctx}/eform/tree/nodes.vm",
				autoParam:["id=TREE_PID"],
				otherParam:paramMap,
				dataFilter: datafilter
			},
			callback:{
				onAsyncSuccess:function(event, treeId, treeNode, msg){
					if(treeNode==null){
						$("#treeDiv").show();
						$("#loading").hide();
						//异步加载情况下的初始回调处理
						if(window.parent && window.parent.treeOnReady){
							window.parent.treeOnReady();
						}
					}
					//异步加载情况下的每次加载回调处理
					if(window.parent && window.parent.asyncCallback){
						window.parent.asyncCallback();
					}
				}
			}
		};
		var mapperid=$("#mapperid").val();
		//父页面存放所选值的隐藏域ID
		var hiddenId="${paramMapObj.hiddenId}";
		if(hiddenId){
			selectNodes=$("#"+hiddenId, window.parent.document).val().trim();
		}
		//树展开的层级
		var showLevel=0;
		if(ths.getUrlParam("showLevel")!=null){
			showLevel=parseInt(ths.getUrlParam("showLevel"));
		}
		var hideWidgetHeader = ths.getUrlParam("hideWidgetHeader");
		//Ajax 请求tree
		function loadTreeAjax()
		{
			paramMap.firstRequest = true;
			$("#treeDiv").hide();
			$("#loading").show();
			if(async==true){
				zTreeObj = $.fn.zTree.init($("#treeDiv"), setting);
				return;
			}
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
			paramMap.firstRequest = false;
			//对于异步加载请求，参数中不能携带TREE_PID参数
			delete paramMap["TREE_PID"];
		}
		//绘制tree
		function renderTreeAdapter()
		{
			var zNodes =[];var j  = 0;
			for(var i = 0 ; i<serverNodeArray.length;i++)
			{
				var node = transJsonToNode(serverNodeArray[i]);
	   			zNodes[j++] =node;
			}
			zTreeObj = $.fn.zTree.init($("#treeDiv"), setting, zNodes);
			var allnodes=zTreeObj.transformToArray(zTreeObj.getNodes());
			if(showLevel>0){
				for(var i=0;i<allnodes.length;i++){
					if(allnodes[i].level<=showLevel-1){
						zTreeObj.expandNode(allnodes[i],true);
					}
				}
			}
			$("#treeDiv").show();
			$("#loading").hide();
		}
		//将json数据转换为node节点
		function transJsonToNode(nodeJson){
			var node_str = JSON.stringify(nodeJson);
			node_str = node_str.replace(/\"/g, "~S~");
			var node = {};
   			node.id = nodeJson.TREE_ID;
   			node.pId = nodeJson.TREE_PID != undefined?nodeJson.TREE_PID:"";
   			node.name = nodeJson.TREE_NAME;
   			//设置节点图标
   			if(nodeJson.ICONSKIN != null){
   				node.iconSkin = nodeJson.ICONSKIN;
   			}
   			//设置节点是否是父节点
   			if(nodeJson.ISPARENT != null){
   				node.isParent = nodeJson.ISPARENT;
   			}
   			//默认勾选
   			if((","+selectNodes+",").indexOf(","+node.id+",")>-1){
   				node.checked = true;
   			}
   			//设置单个节点显示或者隐藏checkbox节点
   			if(nodeJson.NOCHECK!=null){
   				node.nocheck=nodeJson.NOCHECK;
   			}
   			//将源数据全部放到node节点中
   			for(var key in nodeJson){
   				node[key] = nodeJson[key];
   			}
   			node.nodeJson=node_str
   			return node;
		}
		//异步加载树时的数据过滤
		function datafilter(treeId, parentNode, childNodes){
			if (!childNodes) return null;
			var zNodes = [];
			for (var i=0, l=childNodes.length; i<l; i++) {
				var node = transJsonToNode(childNodes[i]);
				zNodes[i] = node;
			}
			return zNodes;
		}
		jQuery(function ($) {
		    
		    $("#btnOK").on(ace.click_event,function(){
		    	var nodes = zTreeObj.transformToArray(zTreeObj.getNodes());
		    	var chooseNodes=[];
		    	var i = 0;
		    	var nodeJson;
		    	$.each(nodes,function(){
		    		if(this.checked)
		    		{
		    			nodeJson=this.nodeJson;
		    			nodeJson = nodeJson.replace(/~S~/g, "\"").replace(/\\/g, ".");
		    			chooseNodes[i] =JSON.parse(nodeJson);
		    			i++;
		    		} 
		    	});
		    	if(window.parent && window.parent.${callback})
				{
					window.parent.${callback}(chooseNodes);
				}
		    	if(parentExistsFun("${paramMapObj.closeCallback}")){
					eval("window.parent.${paramMapObj.closeCallback}()");
				}else if(window.parent && window.parent.closeTreeDialog)
				{
					window.parent.closeTreeDialog();
				}
		    });
		    
		    $("#refreshTree").on(ace.click_event,function(){
		    	 loadTreeAjax();
		    });
		    if(window.parent.selectNodes && window.parent.selectNodes!=""){
		    	selectNodes=window.parent.selectNodes;
		    }
		    //加载Tree
		    loadTreeAjax();
		    
		    //隐藏widgetHeader相关选项
		    if(hideWidgetHeader == "true"){
		    	$(".widget-header").find(".pos-rel").hide();
		    }
		});
		
		//判断父页面是否存在方法
		function parentExistsFun(funName){
			if(funName == null || funName == ""){
				return false;
			}
			var existsFun = false;
			try{
	    		eval("window.parent." + funName);
	    		existsFun = true;
	    	}catch(err) {}
	    	return existsFun;
		}
		
		
		$(".treeOption").on(ace.click_event,function(){
			var o = "";
			if($("#cbRelatParent").is(":checked")) o+="p";
			if($("#cbRelatChild").is(":checked")) o+="s";
			zTreeObj.setting.check.chkboxType.Y = zTreeObj.setting.check.chkboxType.N = o;
			//console.log(zTreeObj.setting.check.chkboxType);
		});
</script>
</body>
</html>

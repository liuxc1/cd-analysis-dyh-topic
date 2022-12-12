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
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
    <!--zTree-->
    <link rel="stylesheet" href="${ctx}/assets/components/zTree/css/metroStyle/metroStyle.css?v=20221129015223"/>
    <!-- 自己写的CSS，请放在这里 -->
    <style type="text/css">
        .widget-box{
            margin: 0px !important;
            /* margin-top: -3px !important; */
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
        .ztree li span.button.chk.radio_false_part {background-position: -47px -5px !important;}
		.ztree li span.button.chk.radio_false_part_focus {background-position: -47px -26px !important;}
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
	<link rel="stylesheet" href="${ctx}/assets/js/eform/tree_custom.css?v=20221129015223"/>
</head>

<body class="no-skin">

<div class="main-container" id="main-container">
    <div class="main-content">
        <div class="main-content-inner padding-page-content">
                <div style="padding-top: 5px">
                    <div class="col-xs-12  padding5">
                           <div class="widget-box transparent">
							    <div class="widget-header" id="widgetHeader" style="display:none;">
                                   <div class="widget-toolbar no-border">
									  <button type="button" class="btn btn-xs btn-primary btn-xs-ths"
										  id="btnOK">
										  <i class="ace-icon fa fa-check"></i> 确定
									  </button>
                                   </div>
                               </div>
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
		var selectTree="";
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
						//异步加载情况下的回调处理
						if(window.parent && window.parent.treeOnReady){
							window.parent.treeOnReady();
						}
					}
                    if(window.parent && window.parent.onAsyncCallback){
                        window.parent.onAsyncCallback();
                    }
				}
			}
		};
		//var treeid=ths.getUrlParam("treeid")
		var mapperid=$("#mapperid").val();
		//是否显示单选框
		var showRadio =ths.getUrlParam("showRadio");
		//父页面隐藏域id
		var hiddenId=ths.getUrlParam("hiddenId");
		if(hiddenId){
			selectTree=$("#"+hiddenId, window.parent.document).val().trim();
		}
		//树展开的层级
		var showLevel=0;
		if(ths.getUrlParam("showLevel")!=null){
			showLevel=parseInt(ths.getUrlParam("showLevel"));
		}
		if(showRadio=="1"){
			setting.check={
				enable: true,
				chkStyle: "radio",
				radioType:"all"
			};
			$("#widgetHeader").css("display","block");
		}
		//Ajax 请求tree
		function loadTreeAjax()
		{
			paramMap.firstRequest = true;
			$("#treeDiv").hide();
			$("#loading").show();
			$.ajax( {
	 	        url:'${ctx}/eform/tree/nodes.vm',
	 	        data:paramMap,
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
			zTreeObj = $.fn.zTree.init($("#treeDiv"), setting,zNodes);
			$("#treeDiv").show();
			$("#loading").hide();
			var nodes = zTreeObj.transformToArray(zTreeObj.getNodes());
			if(showLevel>0){
				for(var i=0;i<nodes.length;i++){
					if(nodes[i].level<=showLevel-1){
						zTreeObj.expandNode(nodes[i],true);
					}
				}
			}
			if(window.parent && window.parent.treeOnReady){
				window.parent.treeOnReady();
			}
		}

		//将json数据转换为node节点
		function transJsonToNode(nodeJson){
			var node_str = JSON.stringify(nodeJson);
			node_str = node_str.replace(/\"/g, "~S~");
			var node = {};
   			node.id = nodeJson.TREE_ID;
   			node.pId = nodeJson.TREE_PID != undefined?nodeJson.TREE_PID:"";
   			node.name = nodeJson.TREE_NAME;
   			if(nodeJson.ISPARENT!=null){
   				node.isParent = nodeJson.ISPARENT;
   			}
   			if(nodeJson.ICONSKIN != null){
   				node.iconSkin = nodeJson.ICONSKIN;
   			}
   			if(selectTree==node.id){
   				node.checked=true;
   			}
   			//将源数据全部放到node节点中
   			for(var key in nodeJson){
   				node[key] = nodeJson[key];
   			}
			node.click= "redirect('" + node_str + "');"
			return node;
		}

		//点击树节点时执行的方法
		function redirect(nodeJson)
		{
			nodeJson = nodeJson.replace(/~S~/g, "\"").replace(/\\/g, ".");
			var treeNode = JSON.parse(nodeJson);
			if(window.parent && window.parent.${callback})
			{
				window.parent.${callback}(treeNode);
			}
			if(parentExistsFun("${paramMapObj.closeCallback}")){
				eval("window.parent.${paramMapObj.closeCallback}()");
			}else if(window.parent && window.parent.closeTreeDialog){
				window.parent.closeTreeDialog();
			}
		}

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

		//异步加载树时的数据过滤
		function datafilter(treeId, parentNode, childNodes){
			if (!childNodes) return null;
			var zNodes = [];
			for (var i=0; i<childNodes.length; i++) {
				var node = transJsonToNode(childNodes[i]);
				zNodes[i] = node;
			}
			return zNodes;
		}

		jQuery(function ($) {
			$("#btnOK").on(ace.click_event,function(){
		    	var nodes = zTreeObj.transformToArray(zTreeObj.getNodes());
		    	var treeNode={};
		    	var nodeJson="";
		    	$.each(nodes,function(){
		    		if(this.checked)
		    		{
		    			nodeJson=this.click.substring(10,this.click.length-3).replace(/~S~/g, "\"").replace(/\\/g, ".");
		    			treeNode=JSON.parse(nodeJson);
		    		}
		    	});
		    	if(window.parent && window.parent.${callback})
				{
					window.parent.${callback}(treeNode);
				}
				if(parentExistsFun("${paramMapObj.closeCallback}")){
					eval("window.parent.${paramMapObj.closeCallback}()");
				}else if(window.parent && window.parent.closeTreeDialog){
					window.parent.closeTreeDialog();
				}
		    });
		    $("#refreshTree").on(ace.click_event,function(){
		    	 loadTreeAjax();
		    });
		    //加载Tree
		    loadTreeAjax();
		});
</script>
</body>
</html>

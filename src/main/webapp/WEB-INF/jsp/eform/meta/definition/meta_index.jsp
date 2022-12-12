<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
	<head>
	    <title>元数据管理</title>
		<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
	    <!--zTree-->
	    <link rel="stylesheet" href="${ctx}/assets/components/zTree/css/metroStyle/metroStyle.css"/>
	    <link rel="stylesheet" href="${ctx}/assets/blue/css/proctree.css"/>
	  	<!--页面自定义的CSS，请放在这里 -->
	    <style type="text/css">
	
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
		                                   <h5 class="widget-title lighter smaller hidden-sm hidden-xs" style="margin-left: 5px">元数据分类</h5>
		                                   <div class="widget-toolbar no-border">
		                                       <a href="javascript:void(0)" data-action="reload" id="refreshTree">
		                                           <i class="ace-icon fa fa-refresh"></i>
		                                       </a>
		                                   </div>
		                               </div>
		                               <div id="divTreeWidget" class="widget-body" style="margin-right: -1px;overflow: auto">
		                                   <div class="widget-main padding-2">
		                                       <iframe id="iframeTree" name="iframeTree" width="100%" frameborder="0"
												 	src="${ctx }/eform/tree/window.vm?sqlpackage=ths.jdp.eform.mapper.settings.category.CategoryMapper&mapperid=tree&callback=treeCallback&loginName=<%=request.getAttribute("loginName") == null || ths.jdp.core.web.LoginCache.isSuperAdmin(request.getAttribute("loginName").toString()) ? "" : request.getAttribute("loginName").toString() %>&jdpAppCode=<%=ths.jdp.core.context.PropertyConfigure.getProperty("jdp.app.code").toString()%>&categoryTypeId=EFORM_META"></iframe>
		                                   </div>
		                               </div>
		                           </div>
		
		                       </div>
		                        <div class="col-xs-10 tabable no-padding">
		                            <ul id="myTab" class="nav nav-tabs ">
		                                <li class="active">
		                                    <a href="#frmDef" data-toggle="tab">
		                                        <i class=" ace-icon fa fa-sliders bigger-120"></i>
		                                        元数据管理</a>
		                                </li>
		                                <li>
		                                    <a href="#frmCatefory" data-toggle="tab">
		                                        <i class=" ace-icon fa fa-folder-open-o bigger-120"></i>
		                                        元数据分类</a>
		                                </li>
		                            </ul>
		
		                            <div id="tab-content" class="tab-content" >
		                                <div class="tab-pane in active" id="frmDef">
		                                    <iframe id="ifrmDef" class="frmContent" style="border: none" frameborder="0" width="100%"></iframe>
		                                </div>
		                                <div class="tab-pane" id="frmCatefory">
		                                    <iframe id="ifrmCategory" class="frmContent" style="border: none" frameborder="0" width="100%"></iframe>
		                                </div>
		                            </div>
		
		                        </div>
		                    </div>
		                </div>
		        </div><!--/.main-content-inner-->
		    </div><!-- /.main-content -->
		</div><!-- /.main-container -->
		
		<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
		
		<script type="text/javascript">
			/*统一树节点点击回调事件*/
		    function treeCallback(node){
		    	redirect(node.TREE_ID, node.TREE_NAME);
		    }
		    /*流程树节点子节点分页集合*/
			function redirect(_treeid, _treeName){
				$("#ifrmDef").attr("src", "${ctx }/eform/meta/definition/meta_table_list.vm?categoryId=" + _treeid + "&categoryName=" + encodeURI(encodeURI(_treeName)));
				$("#ifrmCategory").attr("src", "${ctx }/eform/settings/category/cat_list.vm?treeId=" + _treeid+"&tableName=JDP_EFORM_METATABLE");
			}
			/*ztree节点变化*/
			function treeNodeChange(id, type, name, pid){
				if(type == "delete"){
					var ids = id.split(",");
					for(var i = 0; i < ids.length; i++){
						var node = zTreeObj.getNodeByParam("id", ids[i]);
						if(node != null){
							zTreeObj.removeNode(node);
						}
					}
				}else if(type == "deleteOne"){
					var node = zTreeObj.getNodeByParam("id", id);
					if(node != null){
						zTreeObj.removeNode(node);
					}
				}else if(type == "add"){
					var pNode = zTreeObj.getNodeByParam("id", pid);
					var clickStr = "{~S~TREE_ID~S~:~S~" + id + "~S~,~S~TREE_PID~S~:~S~" + pid + "~S~,~S~TREE_NAME~S~:~S~" + name + "~S~}";
					var newNode = {name:name, id:id, click: "redirect('" + clickStr + "');"};
					zTreeObj.addNodes(pNode, newNode);
				}else if(type == "edit"){
					var node = zTreeObj.getNodeByParam("id", id);
					if(node != null){
						node.name = name;
						zTreeObj.updateNode(node);
					}
				}
			}
			/*树加载完成后进行js操作*/
			function treeOnReady(){
				zTreeObj = document.getElementById('iframeTree').contentWindow.zTreeObj;
				var node = zTreeObj.getNodesByFilter(function (node) { return node.level == 0 }, true);
				if(node){
					zTreeObj.selectNode(node);
					zTreeObj.expandNode(node);
					redirect(node.id, node.name);
				}
			}
			
			jQuery(function ($) {
				var offset = document.getElementById('tab-content').offsetTop + 11;
				autoHeightIframe("ifrmDef",offset);
				autoHeightIframe("ifrmCategory",offset);
				autoHeightIframe("divTreeWidget",offset);
				//iframe
				autoHeightIframe("iframeTree",offset + 10);
				
				/*流程树刷新操作*/
			    $("#refreshTree").on(ace.click_event,function(){
			    	$('#iframeTree').attr('src', $('#iframeTree').attr('src'));
			    });
			});
		</script>
	</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
	<head>
	    <title>元数据属性</title>
		<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
		<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
		<style type="text/css">
			html, body{
				width: 100%;
				height: 100%;
				padding: 3px;
			}
		</style>
	</head>
	<body>
		<div class="tabbable col-xs-12 no-padding-left no-padding-right right">
        	<ul id="myTab" class="nav nav-tabs">
            	<li class="active">
              		<a href="#div_meta_unbind" data-toggle="tab">未绑定元数据</a>
            	</li>
              	<li>
                	<a href="#div_meta_binding" data-toggle="tab">已绑定元数据</a>
                </li>
           	</ul>
      		<div class="tab-content" style="height: 100%;">
          		<div class="tab-pane in active" id="div_meta_unbind">
          			<iframe id="iframeMetaUnbind" name="iframeMetaUnbind" width="100%" src="${ctx}/eform/tree/window.vm?sqlpackage=ths.jdp.eform.service.formdesign.designmapper&mapperid=selectMeta&callback=unbindMetaCallBack&FORM_ID=${form_id}&TABLE_STATE=${table_state}&BIND_STATE=UNBIND&TABLE_CODE=${table_code}" style="height: 410px; border: 0px;"></iframe>
           		</div>
           		<div class="tab-pane" id="div_meta_binding">
           			<iframe id="iframeMetaBinding" name="iframeMetaBinding" width="100%" src="${ctx}/eform/tree/window.vm?sqlpackage=ths.jdp.eform.service.formdesign.designmapper&mapperid=selectMeta&callback=bindingMetaCallBack&FORM_ID=${form_id}&TABLE_STATE=${table_state}&BIND_STATE=BINDING&TABLE_CODE=${table_code}" style="height: 410px; border: 0px;"></iframe>
           		</div>
        	</div>
        </div>
		<script type="text/javascript">
			//未绑定回调
			function unbindMetaCallBack(tree){
				//检验表是否有主键
				if(tree && tree.TABLE_STATE && tree.TABLE_STATE == "TABLE" && $("#FORMCELL_TYPECODE", window.parent.document).val() == "TABLE"){
					var checkPrimaryKeyNum = false;
					$.ajax({
						url:"${ctx}/eform/meta/definition/getPrimaryKeyNum.vm?TABLE_ID=" + tree.TREE_ID,
						dataType:"text",
						async:false,
						cache:false,
						success:function(response){
							var num = parseInt(response)
							if(num < 1){
								parent.dialog({
					                title: '提示',
					                content: '该元数据未设置主键，请前往元数据处进行设置！',
					                wraperstyle:'alert-info',
					                ok: function () {}
					            }).showModal();
							}else if(num>1){
								parent.dialog({
					                title: '提示',
					                content: '元数据只能设置一个主键，请前往元数据处进行修改',
					                wraperstyle:'alert-info',
					                ok: function () {}
					            }).showModal();
							}else{
								checkPrimaryKeyNum = true;
							}
						}
					})
					if(!checkPrimaryKeyNum){
						return;
					}
				}
				//自定义回调方法-OK操作
				var callbackFun = "${callback}";
				if(parentExistsFun(callbackFun) == true){ //存在自定义回调方法，进行调用
		    		eval("window.parent." + callbackFun + "(" + JSON.stringify(tree) + ")");
				}else{
					window.parent.metaCallBack(tree);
				}
			}
			//已绑定回调
			function bindingMetaCallBack(tree){
				
			}
			
			var unbindExpandFlag = false;
			var bindingExpandFlag = false;
			/*树加载完成后进行js操作*/
			function treeOnReady(){
				var unbindZTreeObj = document.getElementById('iframeMetaUnbind').contentWindow.zTreeObj;
				if(!unbindExpandFlag && unbindZTreeObj){
					unbindExpandFlag = true;
					var node = unbindZTreeObj.getNodesByFilter(function (node) { return node.level == 0 }, true);
					if(node){
						unbindZTreeObj.selectNode(node);
						unbindZTreeObj.expandNode(node);
					}
				}
				
				var bindingZTreeObj = document.getElementById('iframeMetaBinding').contentWindow.zTreeObj;
				if(!bindingExpandFlag && bindingZTreeObj){
					bindingExpandFlag = true;
					var node = bindingZTreeObj.getNodesByFilter(function (node) { return node.level == 0 }, true);
					if(node){
						bindingZTreeObj.selectNode(node);
						bindingZTreeObj.expandNode(node);
						//firefox下，展开的节点是display:none
						$(document.getElementById('iframeMetaBinding').contentWindow.document.body).find("ul.level0").each(function(){
							$(this).css("display", "block");
						});
					}
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
		</script>
	</body>
</html>

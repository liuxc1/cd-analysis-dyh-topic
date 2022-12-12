<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
<head>
    <!--浏览器兼容性设置-->
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <meta charset="utf-8"/>
    <title>${topBar['default']}</title>
	<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
    <link rel="stylesheet" href="${ctx}/assets/css/common/ths-menu.css"/>
    <!-- 自己写的CSS，请放在这里 -->
    <style type="text/css">
	    <c:if test="${not empty paramMap.menuWidth}">
		    .sidebar{
		    	width:${paramMap.menuWidth}px;
		    }
		    .sidebar + .main-content{
		    	margin-left:${paramMap.menuWidth}px;
		    }
	    </c:if>
    </style>
    <!-- ace settings handler -->
    <script src="${ctx}/assets/js/menu/ace-extra.js"></script>
</head>
<body class="no-skin" style="overflow-y:hidden;">
	<c:if test="${topBar.isShow==true }">
		<div id="topbar" style="${topBar.style}">
		<c:if test="${empty topBar.url }">
			<div id="navbar" class="navbar navbar-default ths-top-menu">
				<div class="navbar-header pull-left">
		        <a href="#" class="navbar-brand navbar-brand-line no-padding" style="line-height: 52px !important;margin-left: 20px!important;">
	        		<small>
	                 <i class="menu-icon fa fa-windows width_34"></i>
	                	<span><c:if test="${empty topBar['default'] }">xxx列表菜单</c:if><c:if test="${!empty topBar['default'] }">${topBar['default']}</c:if></span>
	            	</small>
		        </a>
		        </div>
		    </div>
	    </c:if>
        <c:if test="${!empty topBar.url }">
	       <jsp:include page="${topBar.url}"/>
	    </c:if>
		</div>
	</c:if>
	<div class="main-container" id="main-container">
		<div>
        <div class="col-xs-12 no-padding">
	    <!-- #section:basics/sidebar -->
	    <div id="sidebar" class="sidebar responsive sidebar-fixed">
	    	<ul class="nav nav-list">
	    		<c:set var="showKey" value=",${nodeMap.showKey }," scope="request"/>
	    		<c:set var="openKey" value=",${nodeMap.openKey }," scope="request"/>
	    		<c:set var="editKey" value=",${nodeMap.editKey }," scope="request"/>
	    		<c:set var="define" value="${nodeMap.define }" scope="request"/>
	    		<c:forEach items="${menuXml.caseList}" var="item">
	    			<c:set var="caseKey" value="${item.key}" />
	    			<c:set var="topCard" value="${item.key }" scope="request"/>
	    			<c:if test="${empty nodeMap.showKey or fn:contains(showKey,caseKey)}" >
	    				<c:if test="${item.cardType=='group'}">
			    			<c:choose> 
			    				<c:when test="${fn:contains(openKey,caseKey)}">
			    					<li class="open">
			    				</c:when>
			    				<c:otherwise>
			    					<li class="">
			    				</c:otherwise>
			    			</c:choose>
			    			<a href="#" class="dropdown-toggle">
			    			<i class="menu-icon fa ${item.bgImage}"></i>
			    			<span class="menu-text">${item.name}</span>
			    			<b class="arrow fa fa-angle-down"></b></a><b class="arrow"></b>
			    			<c:if test="${fn:length(item.childElements)>0 }" >
			    				<c:set var="childElements" value="${item.childElements }" scope="request"/>
			    				<c:import url="main_child.jsp" />
			    			</c:if>
		    			</c:if>
		    			<c:if test="${item.cardType!='group'}">
		    				<c:choose> 
			    				<c:when test="${item.key==define}">
			    					<li class="active" name="endLi">
			    				</c:when>
			    				<c:otherwise>
			    					<li class="" name="endLi">
			    				</c:otherwise>
			    			</c:choose>
			    			<a href="#" onclick="getTabInfo('${topCard}','${item.key }')">
			    				<i class="menu-icon fa ${empty item.bgImage?'fa-caret-right':item.bgImage}"></i>
			    				<span class="menu-text">${item.name }</span>
			    				</a><b class="arrow"></b>
		    			</c:if>
	    			</li>
	    			</c:if>
	    		</c:forEach>
	    	</ul>
	        <!-- #section:basics/sidebar.layout.minimize -->
	        <div class="sidebar-toggle sidebar-collapse" id="sidebar-collapse">
	            <i id="sidebar-toggle-icon" class="ace-icon fa fa-angle-double-left "
	               data-icon1="ace-icon fa fa-angle-double-left" data-icon2="ace-icon fa fa-angle-double-right"></i>
	        </div>
	        <!-- /section:basics/sidebar.layout.minimize -->
	    </div>
	    <!-- /section:basics/sidebar -->
	    <div class="main-content">
	        <div class="main-content-inner">
	            <div class="col-xs-10 tabable no-padding" id="tabInfo" style="width:100%;">
					
	       		</div>
	        </div><!--/.main-content-inner-->
	    </div><!-- /.main-content -->
	    </div>
	</div>
	</div><!-- /.main-container -->
	<!-- basic scripts -->

<!--[if !IE]> -->
<script src="../components/jquery/dist/jquery.js"></script>
<!-- <![endif]-->

<!--[if IE]>
<script src="../components/jquery.1x/dist/jquery.js"></script>
<![endif]-->
<script type="text/javascript">
    if ('ontouchstart' in document.documentElement) document.write("<script src='../components/_mod/jquery.mobile.custom/jquery.mobile.custom.js'>" + "<" + "/script>");
</script>
<script src="${ctx}/assets/components/bootstrap/dist/js/bootstrap.js"></script>

<!-- page specific plugin scripts -->

<!-- ace scripts -->
<script src="${ctx}/assets/js/menu/elements.scroller.js"></script>
<script src="${ctx}/assets/js/ace.js"></script>
<script src="${ctx}/assets/js/menu/ace.basics.js"></script>
<script src="${ctx}/assets/js/menu/ace.sidebar.js"></script>
<script src="${ctx}/assets/js/menu/ace.sidebar-scroll-1.js"></script>
<script src="${ctx}/assets/js/menu/ace.submenu-hover.js"></script>

<!--
<script src="${ctx}/assets/js/ace.settings.js"></script>
-->

<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>

<!-- 自己写的JS，请放在这里 -->
<script type="text/javascript">
    function resizeIframe(frameId) {
    	var height = document.documentElement.clientHeight;
        height -=  $("#topbar").height();
        height -= 50;//边框的高度之和
        document.getElementById(frameId).style.height = height + "px";
    }
	
  	//禁止页面输入
    function forbidInput(){
    	/* if(href.indexOf("edit=false")!=-1){
	         var interval=setInterval(function(){
	        	 if($("iframe[name="+target+"]").contents().find("input,select,textarea").length>0){
	        		 $("iframe[name="+target+"]").contents().find("input,select,textarea").prop("disabled",true);
	        		 clearInterval(interval);
	        	 }
	         }, 100)
        } */
    }
  	function getTabInfo(_topCard,_tab){
  		var paramStr="topCard="+_topCard+"&tab="+_tab;
  		<c:forEach items="${paramMap}" var="item">
  			paramStr=paramStr+"&"+"${item.key}=${item.value}";
  		</c:forEach>
  		var editKey='${editKey}';
  		$.ajax({
  			url:"tabInfo.vm",
  			data:paramStr,
  			type:"post",
  			dataType:"json",
  			cache:false,
  			success:function(response){
  				var tabInfo="";
  				if(response.cardType=="tab"){
  					var childElements=response.childElements;
  					tabInfo+="<ul id='myTab' class='nav nav-tabs'>";
  					for(var i=0;i<childElements.length;i++){
  						var bgImage=childElements[i].bgImage;
  						if(!bgImage || bgImage==""){
  							bgImage="fa-sliders";
  						}
  						if(i==0){
  							tabInfo+="<li class='active'>";
  						}else{
  							tabInfo+="<li>";
  						}
  						tabInfo+='<a href="#frm'+childElements[i].key+'" data-toggle="tab">';
  						tabInfo+='<i class=" ace-icon fa '+bgImage+' bigger-120"></i>'+childElements[i].name+'</a></li>';
  					}
  					tabInfo+="</ul>"
  					tabInfo+='<div id="tab-content" class="tab-content">';
  					for(var i=0;i<childElements.length;i++){
  						var url=childElements[i].url;
  						if(editKey.indexOf(childElements[i].key)>-1){
  							if(url.indexOf("?")>-1){
  								url+="&";
  							}else{
  								url+="?";
  							}
  							url+="edit=true";
  						}
  						if(i==0){
  							tabInfo+='<div class="tab-pane in active" id="frm'+childElements[i].key+'">';
  						}else{
  							tabInfo+='<div class="tab-pane" id="frm'+childElements[i].key+'">';
  						}
  						tabInfo+='<iframe id="ifrm'+childElements[i].key+'" src="'+url+'" class="frmContent" style="width:100%;border: none;overflow-x: hidden; overflow-y:auto;" frameborder="0" width="100%" scrolling="auto"></iframe></div>';
  					}
  					tabInfo+='</div>';
  					$("#tabInfo").html(tabInfo);
  				}else{
  					var bgImage=response.bgImage;
  					if(!bgImage || bgImage==""){
							bgImage="fa-sliders";
						}
  					var url = response.url;
  					if(url){
  						tabInfo+="<ul id='myTab' class='nav nav-tabs'>";
  	  					tabInfo+="<li class='active'>";
  	  					tabInfo+='<a href="#frm'+response.key+'" data-toggle="tab">';
  	  					tabInfo+='<i class=" ace-icon fa '+bgImage+' bigger-120"></i>'+response.name+'</a></li>';
  	  					tabInfo+="</ul>"
  						if(editKey.indexOf(response.key)>-1){
  							if(url.indexOf("?")>-1){
  								url+="&";
  							}else{
  								url+="?";
  							}
  							url+="edit=true";
  						}
  	  	  				tabInfo+='<div id="tab-content" class="tab-content">';
  	  	  				tabInfo+='<div class="tab-pane in active" id="frm'+response.key+'">';
  	  	  				tabInfo+='<iframe id="ifrm'+response.key+'" src="'+url+'" class="frmContent" style="width:100%;border: none;overflow-x: hidden; overflow-y:auto;" frameborder="0" width="100%" scrolling="auto"></iframe></div>';
  	  					tabInfo+='</div>';
  	  					$("#tabInfo").html(tabInfo);
  					}else if(response.click){
  						eval(response.click);
  					}
  				}
  				//调整iframe的高度
  				$("iframe").each(function(){
  					resizeIframe($(this).attr("id"));
  				});
  			}
  		})
  	}
    jQuery(function ($) {
        /*
         //隐藏/显示左菜单
         $("#sidebar").removeClass("sidebar").hide();
         window.setTimeout(function () {
         $("#sidebar").addClass("sidebar").show();
         },3000);
         */			
         //默认点击
         if($("#sidebar li[class*='open']").length<=0){
	         if($("#sidebar li[class*='active']").length>0){
	        	 $("#sidebar li[class*='active']:first").parents("li").addClass("open");
	        	 $("#sidebar li[class*='active']:first").find("a").trigger("click");
	         }else{
	        	 $("#sidebar li[name*='endLi']:first").parents("li").addClass("open");
	         	 $("#sidebar li[name*='endLi']:first").find("a").trigger("click");
	         }
         }else{
        	 if($("#sidebar li[class*='open']:first").find("li[class*='active']").length>0){
        	 	$("#sidebar li[class*='open']:first").find("li[class*='active']:first").find("a").trigger("click");
        	 }
        	 else{
        		 $("#sidebar li[class*='open']:first").find("li[name*='endLi']:first").find("a").trigger("click");
        	 }
         }
    });
    
    /**
     * 向iframe发送消息
     */
    function sendMessage(params){
    	$('.frmContent').each(function(){
    		$(this)[0].contentWindow.postMessage(params, '*');
    	});
    }
</script>
</body>
</html>

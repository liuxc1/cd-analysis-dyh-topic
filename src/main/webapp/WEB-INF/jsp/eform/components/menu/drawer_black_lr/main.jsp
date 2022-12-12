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
	 <link rel="stylesheet" href="${ctx}/assets/js/eform/custom_menu/drawer_black/css/child_menu.css"/>
    <link rel="stylesheet" href="${ctx}/assets/js/eform/custom_menu/drawer_black/css/style_lr.css"/>
    <!-- 自己写的CSS，请放在这里 -->
    <style type="text/css">
    </style>
    <!-- ace settings handler -->
    <script src="${ctx}/assets/js/menu/ace-extra.js"></script>
    <script src="${ctx}/assets/components/jquery-nicescroll/jquery.nicescroll.min.js"></script>
    <script src="${ctx}/assets/components/jquery-nicescroll/jquery.nicescroll.plus.js"></script>
    <script src="${ctx}/assets/js/eform/custom_menu/drawer_black/js/custom.js"></script>
    <script src="${ctx}/assets/js/eform/custom_menu/drawer_black/js/google-maps.js"></script>
</head>
<body class="no-skin" style="overflow-y:hidden;">
<!-- 该图片为背景图片，请自行修改 -->
<img src="${topBar.url}" style="width: 100%;height: 100%;position: absolute; z-index: 1;"/>
<div class="l-wrap">
	<div class="l-left l-left-shadow" id="scroll">
		<c:set var="showKey" value=",${nodeMap.showKey }," scope="request"/>
  		<c:set var="openKey" value=",${nodeMap.openKey }," scope="request"/>
  		<c:set var="editKey" value=",${nodeMap.editKey }," scope="request"/>
  		<c:set var="define" value="${nodeMap.define }" scope="request"/>
  		<c:forEach items="${menuXml.caseList}" var="item">
  			<c:set var="caseKey" value="${item.key}" />
  			<c:set var="topCard" value="${item.key }" scope="request"/>
  			<c:if test="${empty nodeMap.showKey or fn:contains(showKey,caseKey)}" >
  			<c:if test="${item.cardType=='group'}">
    			<dl>
					<dt style="background:url(${item.bgImage}) no-repeat left center;">
						<c:if test="${fn:startsWith(item.bgImage,'fa')}">
							<i class="ace-icon fa ${item.bgImage}"></i>
						</c:if>
					</dt>
					<dd>${item.name}</dd>
				</dl>
   			</c:if>
   			<c:if test="${item.cardType!='group'}">
   				<dl onclick="getTabInfo('${topCard}','${item.key }')">
					<dt style="background:url(${item.bgImage}) no-repeat left center;">
						<c:if test="${fn:startsWith(item.bgImage,'fa')}">
							<i class="ace-icon fa ${item.bgImage}"></i>
						</c:if>
					</dt>
					<dd>${item.name}</dd>
				</dl>
   			</c:if>
   			
  			</c:if>
  		</c:forEach>
	</div>
	<c:forEach items="${menuXml.caseList}" var="item">
		<c:set var="caseKey" value="${item.key}" />
		<c:set var="topCard" value="${item.key }" scope="request"/>
		<c:if test="${empty nodeMap.showKey or fn:contains(showKey,caseKey)}" >
			<ul class="vertical-nav vertical-nav-ul red" style="">
			<c:if test="${item.cardType=='group'}">
	   			<c:if test="${fn:length(item.childElements)>0 }" >
	   				<c:set var="childElements" value="${item.childElements }" scope="request"/>
	   					<c:import url="main_child.jsp" />
	   			</c:if>
  			</c:if>  
  			</ul>
		</c:if>
 	</c:forEach>
	<div class="l-right">
		<div class="lr-close"></div>
		<div class="lr-title" id="lr-title">
		
		</div>
		<div id="l-right-main">
				
		</div>
	</div>
</div>
<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>

<!-- 自己写的JS，请放在这里 -->
<script type="text/javascript">
    
    var preTab="";
  	function getTabInfo(_topCard,_tab){
  		//防止左侧菜单一直点击加载
  		if(preTab!=_topCard){
  			preTab=_tab;
  			var editKey='${editKey}';
  	  		var showKey="${showKey}";
	  	  	var paramStr="topCard="+_topCard+"&tab="+_tab;
	  		<c:forEach items="${paramMap}" var="item">
	  			paramStr=paramStr+"&"+"${item.key}=${item.value}";
	  		</c:forEach>
  	  		$.ajax({
  	  			url:"tabInfo.vm",
  	  			data:paramStr,
  	  			type:"post",
  	  			dataType:"json",
  	  			async:false,
  	  			cache:false,
  	  			success:function(response){
  	  				$("#lr-title").html("");
  	  				$("#l-right-main").html("");
  	  				$('.l-wrap').css({'width':"430px"});
  	  	    		$('.l-right').eq(0).css({'left':"-350px"})
  	  				var tabInfo="";
  	  				if(response.cardType=="tab"){
  	  					var childElements=response.childElements;
  	  					for(var i=0;i<childElements.length;i++){
  	  						if(showKey.replace(/,/g,"")=="" || showKey.indexOf(childElements[i].key)>-1){
  	  							var url=childElements[i].url;
  	  							if(url.indexOf("?")<=-1){
  		  								url+="?";
  		  						}
  	  	  						if(editKey.indexOf(childElements[i].key)>-1){
  	  	  							url+="&edit=true";
  	  	  						}
  	  	  						if(i==0){
  	  	  							tabInfo+="<p class='cur' url='"+url+"' onclick='refresh(this)'>";
  	  	  						}else{
  	  	  							tabInfo+="<p url='"+url+"'  onclick='refresh(this)'>";
  	  	  						}
  	  	  						tabInfo+=childElements[i].name+"</p>";
  	  						}
  	  					}
  	  					$("#lr-title").show();
  	  					$("#lr-title").html(tabInfo);
  	  				}else{
  	  					 /* if(showKey.replace(/,/g,"")=="" || showKey.indexOf(response.key)>-1){
  	  						var url=response.url;
  							if(url.indexOf("?")<=-1){
  	  								url+="?";
  	  						}
  	  						if(editKey.indexOf(response.key)>-1){
  	  							url+="&edit=true";
  	  						}
  	  						if(i==0){
  	  							tabInfo+="<p class='cur' url='"+url+"' onclick='refresh(this)'>";
  	  						}else{
  	  							tabInfo+="<p url='"+url+"'  onclick='refresh(this)'>";
  	  						} 
  	  						tabInfo+=response.name+"</p>";
  	  					} */
  	  					if(showKey.replace(/,/g,"")=="" || showKey.indexOf(response.key)>-1){
  	  						var url=response.url;
  	  						if(editKey.indexOf(response.key)>-1){
	  							url+="&edit=true";
	  						}
  	  						$("#lr-title").hide();
  	  						$("#l-right-main").load(url);
  	  					}
  	  				}
  	  				$("#lr-title p:eq(0)").trigger("click");
  	  				var interval=setInterval(function(){
  	  					 if($("#l-right-main").text().trim()!=""){
  	  						clearInterval(interval);
  	  						$('.l-right').eq(0).animate({"left":"92px"},800);
  	  		  	    		$('.l-left').removeClass('l-left-shadow');
  	  					 }
  	  		        }, 50)
  	  	    		
  	  			}
  	  		})
  		}
  	}
  	
  	//刷新tab页
  	function refresh(obj){
  		$(obj).addClass('cur').siblings('p').removeClass('cur');
  		var _url=$(obj).attr("url")+"&_t="+ new Date().getTime();
  		$("#l-right-main").load(_url);
  	}
  	
    jQuery(function ($) {
    	$(".vertical-nav").verticalnav({speed: 400,align: "left"});
    });
    
</script>
</body>
</html>

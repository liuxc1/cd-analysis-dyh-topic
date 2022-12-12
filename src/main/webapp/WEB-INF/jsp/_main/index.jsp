<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
	<head>
	    <title>多尺度空气质量预报预警</title>
		<meta name="renderer" content="webkit">
		<%
			request.setAttribute("THS_SKIN", ths.jdp.project.util.SkinUtils.getSkin());
			request.setAttribute("JDP_APP_ALLOWSKINCHANGE", ths.jdp.core.context.PropertyConfigure.getProperty("jdp.app.allowskinchange"));
			request.setAttribute("THS_USER", ths.jdp.core.web.LoginCache.getLoginUser());
		%>	
		<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
	  	<!--页面自定义的CSS，请放在这里 -->
	    <style type="text/css">
	    	.navbar-toggle{
	    		z-index: 9999;
	    	}
	    </style>
	    
	    <link rel="stylesheet" href="${ctx}/assets/css/common/ths-menu.css"/>
	    <link rel="stylesheet" href="${ctx}/assets/custom/common/common/css/ths-menu-new.css"/>
	    <!-- ace settings handler -->
	    <script src="${ctx}/assets/js/menu/ace-extra.js"></script>
	</head>

	<body class="no-skin body">
		<!--新增条-->
		<!-- <div class="ths-toolbar" id="ths-toolbar">
		    <div class="row">
		        <div class="col-sm-4 hidden-xs">欢迎您，管理员</div>
		        <div class="col-xs-12 col-sm-8 ">
		            <ul class=" pull-right" data-level="top">
		                <li>
		                    <div class="inline pos-rel">
		                        <a href="#" class="dropdown-toggle dropdown-hover" data-toggle="dropdown">
		                            <i class="ace-icon fa fa-windows grey bigger-110" title="常用菜单"></i>
		                        </a>
		                        <ul class="dropdown-menu dropdown-light dropdown-caret dropdown-closer ths-toolbar-quickmenu">
		                            <li> <a href="#" class="grey"><i class="ace-icon fa fa-angle-double-right blue"></i> 常用模块一</a> </li>
		                            <li> <a href="#" class="grey"><i class="ace-icon fa fa-angle-double-right blue"></i> 常用模块二</a> </li>
		                            <li> <a href="#" class="grey"><i class="ace-icon fa fa-angle-double-right blue"></i> 常用模块三</a> </li>
		                            <li> <a href="#" class="grey"><i class="ace-icon fa fa-angle-double-right blue"></i> 常用模块四</a> </li>
		                            <li> <a href="#" class="grey"><i class="ace-icon fa fa-angle-double-right blue"></i> 常用模块五</a> </li>
		                        </ul>
		                    </div>
		
		                </li>
		                <li><i class="ace-icon fa fa-file-o grey bigger-100" title="待办事项"></i><span class="badge badge-warning">99</span></li>
		                <li><i class="ace-icon fa fa-bullhorn grey bigger-110" title="通知"></i><span class="badge badge-success">2</span></li>
		                <li><i class="ace-icon fa fa-envelope-o grey bigger-110" title="未读邮件"></i><span class="badge badge-important">5</span></li>
		
		                <li><i class="ace-icon fa fa-user grey bigger-110" title="我的工作台"></i></li>
		                <li><i class="ace-icon fa fa-search grey bigger-110" title="搜索"></i></li>
		                <li> <i class="ace-icon fa fa-gears grey bigger-110" title="设置"></i></li>
		                <li> <i class="ace-icon fa fa-power-off grey bigger-110" title="注销"></i></li>
		            </ul>
		        </div>
		    </div>
		</div> -->
		<!--新增条-->
		<!-- #section:basics/navbar.layout -->
		<div id="navbar" class="navbar navbar-default ths-top-menu">
		    <div class="navbar-container " id="navbar-container">
		        <!-- #section:basics/sidebar.mobile.toggle 移动端 菜单选项-->
		
		        <button data-target="#sidebarTop" data-toggle="collapse" type="button"
		                class="pull-left navbar-toggle collapsed">
		            <span class="sr-only">菜单</span>
		
		            <i class="ace-icon fa fa-th white bigger-175"></i>
		        </button>
		
		        <button type="button" class="navbar-toggle menu-toggler pull-left" id="menu-toggler" data-target="#sidebar">
		            <span class="sr-only">模块</span>
		
		            <i class="ace-icon fa fa-navicon white bigger-175"></i>
		        </button>
		
		    </div>
		    
		        <!-- /section:basics/sidebar.mobile.toggle -->
		    <div class="navbar-header pull-left">
		        <!-- #section:basics/navbar.layout.brand -->
		        <span class="navbar-brand navbar-brand-line no-padding" style="line-height: 52px !important;margin-left: 20px!important;">
		            <i class="width_38"><img src="${ctx}/assets/blue/images/logo1.png" style="width: 38px;height:38px;margin-bottom: 4px; margin-right:5px"/></i>
		            <span style="padding-top:5px;">${appTitle }</span>
		            
		        </span>
		        <!-- /section:basics/navbar.toggle -->
		    </div>
		
		    <!-- #section:basics/navbar.dropdown -->
		
		    <div class="navbar-buttons navbar-header pull-right" role="navigation">
		   
		    </div>
		    <div id="sidebarTop" class="sidebar h-sidebar navbar-collapse collapse  no-padding ">
		       <ul class="nav nav-list ths-top-menu-ul" >
			   ${topMenuHtml}
			        <div class="dropdown" style="float:right; color:#fff;font-size:12px;display:block; line-height:20px;padding-right:10px;margin-left:16px;margin-top:23px;position:relative;">
						    <span class="hidden-sm hidden-xs" id="ace-settings-btn" style="cursor: pointer;">
							${loginUser.userName}
							<i class="ace-icon fa fa-caret-down" style="margin-right: 2px; margin-left: 3px;"></i>
							</span>	
							<div class="header-info">
								<ul>
									<li>
										<a href="#" onclick="editPassword()"><i class="ace-icon fa fa-unlock-alt"></i>修改密码</a>
									</li>
									<!-- 判断是否允许换肤 -->
									<c:if test="${JDP_APP_ALLOWSKINCHANGE == 'true' }">
										<li>
											<a href="#"><i class="ace-icon fa fa-cog"></i>皮肤设置</a>
											<div class="header-info-content">
												<dl data-skin="no-skin" class="no-skin">
													<dt></dt>
													<dd>经典蓝<i class="ace-icon fa fa-check"></i></dd>
												</dl>
												<dl data-skin="skin-black" class="skin-black">
													<dt></dt>
													<dd>睿智黑<i class="ace-icon fa fa-check"></i></dd>
												</dl>
												<dl data-skin="skin-blue" class="skin-blue">
													<dt></dt>
													<dd>冰寒蓝<i class="ace-icon fa fa-check"></i></dd>
												</dl>
												<dl data-skin="skin-purple" class="skin-purple">
													<dt></dt>
													<dd>木槿紫<i class="ace-icon fa fa-check"></i></dd>
												</dl>
												<dl data-skin="skin-red" class="skin-red">
													<dt></dt>
													<dd>吉祥红<i class="ace-icon fa fa-check"></i></dd>
												</dl>
												<dl data-skin="skin-green" class="skin-green">
													<dt></dt>
													<dd>青枝绿<i class="ace-icon fa fa-check"></i></dd>
												</dl>
												<dl data-skin="skin-ViewUI" class="skin-ViewUI">
													<dt></dt>
													<dd>ViewUI<i class="ace-icon fa fa-check"></i></dd>
												</dl>
											</div>
										</li>
									</c:if>							
									<li>
										<a href="#" onclick="loginOut()"><i class="ace-icon fa fa-power-off"></i>注销</a>
									</li>
								</ul>
							</div>
						
					</div>
		       </ul>
		       <!-- /.nav-list -->
		    </div><!-- .sidebar -->
		    <c:if test="${topFloor == 0}">
			  <%--  <div class="navbar-buttons navbar-header pull-right" role="navigation">
		        <ul class="nav ace-nav">
		              <li class="light-blue dropdown-modal">
		                  <a data-toggle="dropdown" href="#" class="dropdown-toggle">
		                      <img class="nav-user-photo" src="${ctx}/common/ace/avatars/avatar2.png" alt=""/>
		                                  <span class="user-info">
		                                      <small>Hi,</small>
		                                      张三
		                                  </span>
		
		                      <i class="ace-icon fa fa-caret-down"></i>
		                  </a>
		
		                  <ul class="user-menu dropdown-menu-right dropdown-menu dropdown-yellow dropdown-caret dropdown-closer">
		                      <li>
		                          <a href="#">
		                              <i class="ace-icon fa fa-cog"></i>
		                              个人设置
		                          </a>
		                      </li>
		
		                      <li class="divider"></li>
		
		                      <li>
		                          <a href="#">
		                              <i class="ace-icon fa fa-power-off"></i>
		                              注销
		                          </a>
		                      </li>
		                  </ul>
		          </ul>
		    </div> --%>
		    </c:if>
    		<!-- /section:basics/navbar.dropdown -->
		</div><!-- /.navbar-container -->
		<!-- #section:settings.box -->
		<!-- /section:basics/navbar.layout -->
		<div class="main-container" id="main-container">
		    <!-- #section:basics/sidebar -->
		    <div id="sidebar" class="sidebar responsive  sidebar-fixed hidden" >
		         <ul id='nav_menu' class='nav nav-list'>
		        <!-- /.nav-list -->
		           ${leftMenuHtml}
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
		            <iframe id="main-content-iframe" name="main" frameBorder="0"
		                    style="width:100%;border: none;overflow-x: hidden; overflow-y:auto"
		                    scrolling="auto" src=""></iframe>
		        </div><!--/.main-content-inner-->
		    </div><!-- /.main-content -->
		</div><!-- /.main-container -->
		<input type="hidden" value="${topFloor}" id="floor" ></input>
		<!-- basic scripts -->
		<script type="text/javascript">
		    if ('ontouchstart' in document.documentElement) document.write("<script src='${ctx}/assets/components/jquery.mobile.custom/jquery.mobile.custom.js'>" + "<" + "/script>");
		</script>
		<script src="${ctx}/assets/components/bootstrap/dist/js/bootstrap.js"></script>
		
		<!-- page specific plugin scripts -->
		<script src="${ctx}/assets/js/ths-util.js"></script>
		<!-- ace scripts -->
		<script src="${ctx}/assets/js/menu/elements.scroller.js"></script>
		<script src="${ctx}/assets/js/ace.js"></script>
		<script src="${ctx}/assets/js/menu/ace.basics.js"></script>
		<script src="${ctx}/assets/js/menu/ace.sidebar.js"></script>
		<script src="${ctx}/assets/js/menu/ace.sidebar-scroll-1.js"></script>
		<script src="${ctx}/assets/js/menu/ace.submenu-hover.js"></script>

		<!-- 自己写的JS，请放在这里 -->
		<script type="text/javascript">
		window.console = window.console || (function(){ 
			var c = {}; c.log = c.warn = c.debug = c.info = c.error = c.time = c.dir = c.profile = c.clear = c.exception = c.trace = c.assert = function(){}; 
			return c; 
		})(); 
		function resizeIframe() {
			console.log("resizeIframe()")
			var h = $(window).height(),
				barH = $('#navbar').height(),
				iframeH = h-barH-15;//边框的高度之和
			$('#main-content-iframe').height(iframeH);
		}
		
		   document.getElementById('main-content-iframe').onload = resizeIframe;
		   window.onresize = resizeIframe;
		
		
		    jQuery(function ($) {
		         if(${not empty toMenuId}){
		        	 if(${not empty leftMenuHtml}){    		 
			        	 $("#sidebar").removeClass("hidden").addClass("sidebar").show();
		        	 }
		        	 if($("#floor").val()==0){ //无横向导航
			        	 $("#sidebarTop").remove();
		        	 }
		        	 if(${not empty toMenuParams}){
		        		 var menuUrl = $("a[location='true']").attr("menu_url");
		        		 if(menuUrl.indexOf("?")<=-1){
		        			 menuUrl+="?";
		        		 } else {
                            menuUrl += "&";
                         }
		        		 $("a[location='true']").attr("menu_url", menuUrl+"${toMenuParams}");
		        	 }
		        	 $("a[location='true']").click();
		         }else{
			         if($("#floor").val()==0){ //无横向导航
			        	 $("#sidebarTop").remove();
			        	 click_siderbar();
			         }else{
			        	 click_topbar();    //存在横向导航
			         }
		         }
		         
		         //初始化样式
		         initSkin();
		         
			});
		    

		    //样式初始化
		    function initSkin(){
		    	var thsSkin = "<%=ths.jdp.project.util.SkinUtils.getSkin()%>";
		    	if(thsSkin!=""){
		    		$(window.document.body).attr("class", thsSkin);
		    	}
				
				//主页默认选中皮肤
				$(".header-info-content dl").removeClass("selected");
				$(".header-info-content dl[data-skin='" + thsSkin.replace("no-skin ", "") + "']").addClass('selected');
				
				 //liuyan修改选择皮肤效果
				 $("#ace-settings-btn").on("click", function(e){
					 e.stopPropagation();
		        	if($('.header-info').css('display') == 'none') {
						$('.header-info').show();
					} else {
						$('.header-info').hide();
					}
		         });
				 $(".header-info-content dl").on("click", function(){
					 $(".header-info-content dl").removeClass("selected"); 
					 $(this).addClass('selected');
					 ths_skin_setting($(this).attr("data-skin"), "true"); 
				 });
				 $('.header-info li').click(function() {
					$('.header-info').hide();
				});
				$('html').not('.header-info').click(function() {
					$('.header-info').hide();	
				 });
				
			}
		    
		  //皮肤设置
			function ths_skin_setting(skin, flag){
				//设置body皮肤
				var bodySkin = skin;
				if(bodySkin != "no-skin"){
					bodySkin = "no-skin " + bodySkin;
				}
				$(document.body).attr("class", bodySkin);
				
				
				if(flag && flag == "true"){
					//修改session用户对象皮肤
					$.ajax({
						type : 'post',
						async: false,
			    		url : "${ctx}/notice/user/skin/reset.vm",
			    		data : {"skin": skin},
			    		success : function(data) {
			    		},
			    		error : function(error,content,value) {
			    		}
					});
					//修改Ou用户皮肤信息
					$.ajax({
						type : 'get',
						async: false,
						url : "<%=ths.jdp.core.context.PropertyConfigure.getProperty("jdp.ou.api.context").toString()%>/ouapi/api/user/${THS_USER.userId}/skin",
			    		data : {"skin": skin},
			    		dataType:'jsonp',
			    		jsonp:"jsonpCallback", 
			    		success : function(data) {
			    		},
			    		error : function(msg) {
			    		}
					});
					
					//如果浏览器支持html5，当前皮肤样式存储到浏览器的存储中
					var commandMessage='{"messageType":"command","currentSkin": "'+bodySkin+'"}';
					$("iframe").each(function(i){
						window.frames[i].postMessage(commandMessage,'*');
					});
					
				}
			}




		    
		    //顶部菜单加载完成，触发第一个菜单的第一个子节点的点击事件
			function click_topbar(){
				console.log("click_topbar()")
				var siderbar_li_a=find_siderbar_a($(".ths-top-menu-ul").find("li")[0]);
				var clickAttr = $(siderbar_li_a).attr("onclick");
				$(siderbar_li_a).attr("onclick", "return gotoTopPage(this, 'init')");
				$(siderbar_li_a).click();
				$(siderbar_li_a).attr("onclick", clickAttr);
			}
		    
		    //点击顶部菜单触发的操作
		    function gotoTopPage(o, from){
		    	console.log("gotoTopPage()")
		    	var menu=$(o);
		    	var menuid=menu.attr("RES_ID"); //菜单编码
		    	var target=menu.attr("TARGET");// 打开方式
		    	var hasChild=menu.attr("hasChild");// 打开方式
		    	var url=dealUrl(menu);
		    	
		    	if(hasChild=="true"){
		    		loadLeftMenu(menuid);
		    		if(!from){
		    			writeAccessLog(o);
		    		}
		    	}else{
		    		gotoPage(o);
		    		
		    		if(target!="1"){ //不在新页面打开
		    			if($("#floor").val()!=0){ //有横向导航
		        			$("#sidebar").removeClass("sidebar").hide();//隐藏左侧菜单
		        		}
		    		}
		    		
		    	}
		    	return false;
		    }
		    
		    //打开页面，点击左侧菜单也会触发该操作
		    function gotoPage(o, from){
		    	console.log("gotoPage()")
		        var menu=$(o);
		    	var target=menu.attr("TARGET");// 打开方式
		    	var url=dealUrl(menu);
		    	if(!url){
		    		return false;
		    	}
		    	switch(target)
		    	{
			    	case "0":
			    		window.location.href=url;// 当前页打开
					    break;
					case "1":
						window.open(url);	// 新页面打开
					    break;
					case "2":    //在应用区打开
					    if($("#sidebar").find("li").length==0){ //如果左侧菜单为空，隐藏左侧菜单区域，否则显示
							$("#sidebar").removeClass("sidebar").hide();
						}else{
							$("#sidebar").removeClass("hidden").addClass("sidebar").show();
						}
					
						$("#main-content-iframe").attr("src",url);
						break;
					case "3"://在主内容区打开
						if($("#floor").val()==0){ //如果有横向导航,隐藏左侧菜单；否则不隐藏
							$("#sidebar").removeClass("sidebar").hide();//隐藏左侧菜单
						}else{
							$("#sidebar").removeClass("hidden").addClass("sidebar").show();
						}
						
						$("#main-content-iframe").attr("src",url); 
						break;
					default:
						$("#main-content-iframe").attr("src",url);
		    	}
		    	if(!from){
		    		writeAccessLog(o);
		    	}
		    	return false;
		    	
		    }
		    
		    //加载左侧菜单
		    function loadLeftMenu(resid){
		    	console.log("loadLeftMenu()")
		    	var _appcode = ths.getUrlParam("appcode");
		    	console.log(_appcode);
		    	var _url = "${ctx}/leftmenu.vm";
		    	if(_appcode != null && _appcode != "")
		    		_url = _url + "?appcode=" + _appcode;
		    	//发送请求
		    	$.ajax({
		    		type : 'post',
		    		url : _url,
		    		data : {"resid":resid, "menuid": "${menuid}"},
		    		cache : false,
		    		dataType:"html",
		    		success : function(leftMenuHtml) {
		    			console.log("loadLeftMenu() success")
		    			if(leftMenuHtml!=""){
		    				$("#sidebar").removeClass("hidden").addClass("sidebar").show();
		    				if(leftMenuHtml.indexOf('"')==0){
		    					leftMenuHtml=leftMenuHtml.substring(1,leftMenuHtml.length-1);//去掉前后双引号
		    				}
		    				$("#nav_menu").html(leftMenuHtml);
		    				click_siderbar();
		    			}else{
		    				$("#sidebar").removeClass("sidebar").hide();//隐藏左侧菜单
		    			}
		    			console.log("loadLeftMenu() success end")
		    		
		    		},
		    		error : function(error,content,value) {
		    			alert("操作超时，请刷新页面！");
		    		}
		    	});
		    }
		    
		    //左侧菜单加载完成，触发第一个菜单的第一个子节点的点击事件
		    function click_siderbar(){
		    	console.log("click_siderbar()")
		     	var siderbar_li_a=find_siderbar_a($("#nav_menu").find("li")[0]);
		    	var clickAttr = $(siderbar_li_a).attr("onclick");
		    	$(siderbar_li_a).attr("onclick", "return gotoPage(this, 'parent')");
		     	$(siderbar_li_a).click();
		     	$(siderbar_li_a).attr("onclick", clickAttr);
		    }
		    
		    //获取菜单的叶子节点
		    function find_siderbar_a(siderbar_li){
		    	console.log("find_siderbar_a()")
		 	   	var siderbar_li_a;
		 	   	if($(siderbar_li).find("ul").length>0){
		 	   		var siderbar_li_ul=$(siderbar_li).find("ul")[0];
		 	   		if($(siderbar_li_ul).find("li").length>0){
		 	   		    siderbar_li_a=find_siderbar_a($(siderbar_li_ul).find("li")[0])
		 	   		}else{
		 	   			siderbar_li_a= $(siderbar_li_ul).find("a")[0];
		 	   		}
		 	   	}else{
		 	   		siderbar_li_a=$(siderbar_li).find("a")[0];
		 	   	}
		    	   
		 	   	return siderbar_li_a;
		    }

		//处理菜单的url
		function dealUrl(menu){
			console.log("dealUrl()")
			var url=menu.attr("MENU_URL");

			if(!url){
				return "";
			}
			url = url.trim();

			if(url.indexOf("www")==0){
				url = "http://"+url;
			}else if(url.indexOf("http:")==0){
			}else if(url.indexOf("{ctx}")==0){
				url = url.replace("{ctx}","${ctx}");
			}else if(url.indexOf("/")==0){
				url = "${ctx}" + url;
			}
			url += (url.indexOf("?") > -1 ? "&" : "?")
					+ "THS_JDP_RES_DESC=" + encodeURI(encodeURI(menu.attr("res_name")))
					+ "&THS_JDP_RES_ID=" + menu.attr("res_id");
			return url;
		}

		    function loginOut(){
		    	window.location.href="${ctx}/loginout.vm";
		    	//window.location.href="http://192.168.0.186:8802/cas/logout";
		    }
		    
		    function editPassword(){
		    	var loginName = "<%=ths.jdp.project.web.LoginCache.getLoginUser(request).getLoginName()%>";
		    	var url = '/ou/password/edit?loginName='+loginName;

		    	window.open(url);	// 新页面打开
		    }
		    //写访问日志
		    function writeAccessLog(o){
		    	console.log("writeAccessLog()");
		    	var operation = $(o).attr("res_name");
		    	if($(o).attr("menu_name")){
		    		operation = $(o).attr("menu_name");
		    	}
		    	$.ajax({
		    		type : 'post',
		    		url : '${ctx}/project/menu/accesslog/save.vm',
		    		data : {"OPERATION":operation},
		    		cache : false,
		    		success : function(leftMenuHtml) {
		    		
		    		},
		    		error : function(error,content,value) {
		    		}
		    	});
		    }

		    $(function(){
		    	window.addEventListener("message",function(e){
		    		var message = e.data;
					if(message) {
						var messageJson = JSON.parse(message);
						var messageType = messageJson.messageType;
						var resId = messageJson.resId;
						if (resId && messageType === "askBreadcrumbs") {
							$("iframe").each(function (i) {
								window.frames[i].postMessage('{"messageType":"answerBreadcrumbs","menuPath": ' + JSON.stringify(JSON.parse('${menuPath}')[resId]) + '}', '*');
							})
						}
					}
				},false);
			});
		</script>
	</body>
</html>
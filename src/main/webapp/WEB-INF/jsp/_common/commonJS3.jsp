
<script type="text/javascript" src="${ctx}/assets/ths-custom2.js"></script>


<script type="text/javascript">
	//功能操作的权限控制(无权限的隐藏)
	jQuery(function ($) {
		var __isAdmin = '<%=ths.jdp.core.context.PropertyConfigure.getProperty("superadmin")!=null && ths.jdp.core.web.LoginCache.getLoginUser(request) != null && ths.jdp.core.web.LoginCache.isSuperAdmin(ths.jdp.core.web.LoginCache.getLoginUser(request).getLoginName()) %>';
		if(__isAdmin != 'true'){
		 	var __ops = '<%= new ths.jdp.api.OuApi().getNotAllowOperation((String)request.getAttribute("THS_JDP_URL_ADDR")) %>';
		 	if(__ops && __ops != ""){
			 	$(__ops).hide();
		 	}
		}
		
		// 高级搜索事件
		$('.high-search-btn').click(function(){
			$(this).toggleClass('up');
			if ($(this).hasClass('up')) {
				$('.high-search-box').show();
			}else {
				$('.high-search-box').hide();
			}
		});
		
		// 解决面包屑上有滚动条的问题
		$('.main-content-inner', parent.document).removeClass('main-content-inner-shield');
		if ($('.breadcrumbs').length > 0) {
			$('.main-content-inner', parent.document).addClass('main-content-inner-shield');
		}
	});
</script>
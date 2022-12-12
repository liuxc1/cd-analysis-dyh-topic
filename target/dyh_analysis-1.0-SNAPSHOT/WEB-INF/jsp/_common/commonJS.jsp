
<script src="${ctx}/assets/components/bootstrap/dist/js/bootstrap.js?v=20221129015223"></script>

<!-- page specific plugin scripts -->
<script src="${ctx}/assets/components/My97DatePicker/WdatePicker.js?v=20221129015223"></script><!--日期控件-->
<script src="${ctx}/assets/components/artDialog/dist/dialog-plus.js?v=20221129015223"></script><!--artDialog 6.x,源码已改,勿替换-->
<script src="${ctx}/assets/components/jQuery-Validation-Engine/jquery.validationEngine-zh_CN.js?v=20221129015223" type="text/javascript"></script>
<script src="${ctx}/assets/components/jQuery-Validation-Engine/jquery.validationEngine.js?v=20221129015223" type="text/javascript"></script>

<!--ace script-->
<script src="${ctx}/assets/js/ace.js?v=20221129015223"></script>
<!--THS 工具类 script-->
<script src="${ctx}/assets/js/ths-util.js?v=20221129015223"></script>
<!--THS 表单操作 script-->
<script src="${ctx}/assets/js/ths-form.js?v=20221129015223"></script>

<!-- 自定义全局js引入 -->
<!-- ajax遮罩层 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/ths-jquery-ajax-loader.js?v=20221129015223"></script>
<!-- dialog工具-->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/dialog-util.js?v=20221129015223"></script>
<!-- ajax工具-->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/ajax-util.js?v=20221129015223"></script>
<!-- 通用数据弹框选择插件 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/datachoose/jquery.data-dialog-choose.js?v=20221129015223"></script>
<!-- vue -->
<script type="text/javascript" src="${ctx}/assets/components/vue/dist/vue.js?v=20221129015223"></script>
<script type="text/javascript" src="${ctx}/assets/custom/common/vue-common.js?v=20221129015223"></script>
<!--  -->
<script type="text/javascript" src="${ctx}/assets/custom/common/form-validate-function.js?v=20221129015223"></script>

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
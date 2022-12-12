<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<%
	request.setAttribute("IS_CAS_LOGIN", ths.jdp.core.context.PropertyConfigure.getProperty("IS_CAS_LOGIN"));
	request.setAttribute("CAS_LOGOUT_URL",
			ths.jdp.core.context.PropertyConfigure.getProperty("CAS_LOGOUT_URL"));

	Exception ex = (Exception) request.getAttribute("exception");
	if (ex != null) {
		if (ex instanceof ths.jdp.core.exception.ThsException) {
			request.setAttribute("message", ex.getMessage());
		}
	}

	if (request.getAttribute("message") == null) {
		request.setAttribute("message", "对不起，系统访问出错，请检查请求地址和参数！");
	}
%>
<!DOCTYPE html>
<html lang="zh">
<head>
<!--浏览器兼容性设置-->
<meta charset="UTF-8" />
<!-- 标示默认使用内核 -->
<meta name="renderer" content="webkit" />
<meta name="force-rendering" content="webkit" />
<meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1" />
<!-- 为了获得更好的解析效果，请把规定内核的meta标签放在其他meta标签前面。这里放其他meta标签。-->
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />
<!-- 禁止edge浏览器自动标记部分特定内容 -->
<meta name="format-detection" content="telephone=no,email=no,address=no">
<title>访问错误</title>

<!-- bootstrap & fontawesome -->
<link rel="stylesheet" href="${ctx}/assets/css/common/bootstrap.css?v=20221129015223" />
<link rel="stylesheet" href="${ctx}/assets/components/font-awesome/css/font-awesome.css?v=20221129015223" />
<!-- ace styles -->
<link rel="stylesheet" href="${ctx}/assets/css/common/ace.css?v=20221129015223" class="ace-main-stylesheet" id="main-ace-style" />
<!--THS CSS 插件-->
<link rel="stylesheet" href="${ctx}/assets/css/common/ths-custom.css?v=20221129015223" />
<link rel="stylesheet" href="${ctx}/assets/css/custom-jdp.css?v=20221129015223" />

<!--页面自定义的CSS，请放在这里 -->
<style type="text/css">
</style>
</head>
<body class="no-skin">
	<div class="main-container" id="main-container">
		<div class="main-content">
			<div class="main-content-inner padding-page-content fixed-10">
				<div class="page-content">
					<div class="row">
						<div class="center">
							<h1>${message}</h1>
						</div>
						<hr />
						<div class="center">
							<a href="javascript:history.back()" class="btn ">
								<i class="ace-icon fa fa-arrow-left"></i> 后退
							</a>
							<a href="${ctx}/" class="btn     ">
								<i class="ace-icon fa fa-tachometer"></i> 首页
							</a>
							<a href="javascript:loginOut();" class="btn">
								<i class="ace-icon fa fa-power-off"></i> 注销
							</a>
						</div>
					</div>
					<!-- /.row -->
				</div>
			</div>
			<!--/.main-content-inner-->
		</div>
		<!-- /.main-content -->
	</div>
	<!-- /.main-container -->

	<script src="${ctx}/assets/components/jquery/dist/jquery.js?v=20221129015223"></script>
	<script src="${ctx}/assets/components/bootstrap/dist/js/bootstrap.js?v=20221129015223"></script>
	<!--ace script-->
	<script src="${ctx}/assets/js/ace.js?v=20221129015223"></script>
	<script type="text/javascript">
		function loginOut() {
			$.ajax({
				type : 'post',
				url : '${ctx}/loginout.vm',
				data : {},
				cache : false,
				success : function(leftMenuHtml) {
					window.location.href = '${ctx}';
				},
				error : function(error, content, value) {
					window.location.href = '${ctx}';
				}
			});
		}
	</script>

</body>
</html>

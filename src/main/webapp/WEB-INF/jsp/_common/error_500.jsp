<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
<head>
    <title>500 Error</title>
	<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
  	<!--页面自定义的CSS，请放在这里 -->
    <style type="text/css">
    	#main-container{
    		margin-top: 10px;
    	}
		.main-content-inner .page-content{
			padding: 0px !important;
		}
		.error-container .well{
			margin-bottom: 0px;
			margin-top: 40px;
		}
		.well hr{
			margin-top: 2px; 
			margin-bottom: 2px;
		}
		.well .alert{
			width: 100%; 
			overflow: auto;
			max-height: 300px;
			margin-bottom: 10px;
		}
		.error-container{
			margin: 0px;
		}
    </style>
</head>

<body class="no-skin">

<div class="main-container" id="main-container">
    <div class="main-content">
        <div class="main-content-inner fixed-page-header">
            <div id="breadcrumbs" class="breadcrumbs">
                <ul class="breadcrumb">
                    <li class="active">
                        <h5 class="page-title" >
                            <i class="fa fa-edit"></i>
                            500 ERROR
                        </h5>
                    </li>
                </ul><!-- /.breadcrumb -->

            </div>
            <div class="page-toolbar align-right">
               
                <div class="space-2"></div>
                <hr class="no-margin">
            </div>

        </div>
        <div class="main-content-inner padding-page-content fixed-10">
            <div class="page-content">
                <div class="row">
                    <div class=" col-xs-12 form-horizontal">
                      
                      <!-- #section:pages/error -->
								<div class="error-container">
									<div class="well">
										<h1 class="grey lighter smaller">
											<span class="blue bigger-125">
												<i class="ace-icon fa fa-random"></i>
												500
											</span>
											发生错误
										</h1>

										<hr/>
										<h3 class="lighter smaller">
											正在努力修复<i class="ace-icon fa fa-wrench icon-animated-wrench bigger-125"></i>中，
											带来不便，深感抱歉<i class="ace-icon fa fa-coffee  bigger-125"></i>。
											
										</h3>

										<div class="alert alert-block alert-warning" id="message_500">
											<% Exception ex = (Exception)request.getAttribute("exception"); 
												if(ex != null){
											%>
												<%=ex.getCause() == null ? ex.getMessage() : ex.getCause().getMessage() %>
											<% }else{ %>
											${message}
											<% } %>
										</div>
										<hr id="message_500_bottom_hr"/>
										<div class="space-8" id="message_500_bottom_space"></div>
										<div class="center" id="message_500_bottom_btn">
											<a href="javascript:history.back()" class="btn ">
												<i class="ace-icon fa fa-arrow-left"></i>
												后退
											</a>
											<a href="${ctx}/index.vm" class="btn     ">
												<i class="ace-icon fa fa-tachometer"></i>
												首页
											</a>
										</div>
										<script type="text/javascript">
											if($("#message_500").closest("div.alert.ths-dialog-content").length >= 1){
												$("#message_500_bottom_hr").remove();
												$("#message_500_bottom_space").remove();
												$("#message_500_bottom_btn").remove();
												$("#message_500").css("margin-bottom", "0px");
											}
										</script>
									</div>
								</div>

								<!-- /section:pages/error -->
                    </div>
                </div><!-- /.row -->
            </div>
        </div><!--/.main-content-inner-->
    </div><!-- /.main-content -->
</div><!-- /.main-container -->

<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>

</body>
</html>

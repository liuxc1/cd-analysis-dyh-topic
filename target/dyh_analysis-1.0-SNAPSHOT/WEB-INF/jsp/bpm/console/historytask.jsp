<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
	<head>
	    <title>历史</title>
		<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
		<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
	  	<!--页面自定义的CSS，请放在这里 -->
	    <style type="text/css">
	
	    </style>
	</head>
	<body class="no-skin">
		<div class="main-container" id="main-container">
		    <div class="main-content">
		        <div class="main-content-inner padding-page-content">
	                <div style="padding-top: 5px">
                        <div class="col-xs-12 tabable">
							<ul id="myTab" class="nav nav-tabs ">
								<li class="active">
									<a href="#diagram" onclick="diagramFresh()" data-toggle="tab"> 
										<i class=" ace-icon fa fa-sliders bigger-120"></i> 流程图
									</a>
								</li>
								<li>
									<a href="#records" data-toggle="tab"> 
										<i class=" ace-icon fa fa-file-text-o bigger-120"></i> 流转记录 
									</a>
								</li>
								<c:if test='${hideReads == null || hideReads == "false" }'>
									<li>
										<a href="#reads" data-toggle="tab"> 
											<i class=" ace-icon fa fa-file-text-o bigger-120"></i>传阅记录 
										</a>
									</li>
								</c:if>
							</ul>
							<div id="tab-content" class="tab-content" style="overflow: auto;">
			              		<div class="tab-pane  in active" id="diagram">
			                   		<iframe id="diagramIframe" style="width: 100%; height: 420px; border: 5px" src="<%=ths.jdp.core.context.PropertyConfigure.getUrlFromNacos("jdp.bpm.api.context").toString() %>/bpm/repository/flowjs/view.vm?processInstanceId=${procInstId}"></iframe>
			                 	</div>
			                  	<div class="tab-pane" id="records" style="overflow: auto;">
			                   		<form class="form-horizontal" role="form" id="formList" >
										<script type="text/javascript">
						              		$("#formList").load("${ctx }/console/history.vm?procInstId=${procInstId }&executionId=${executionId }&_t=" + new Date().getTime());
						             	</script>
						          	</form>
			                  	</div>
				                <c:if test='${hideReads == null || hideReads == "false" }'>
				                  	<div class="tab-pane" id="reads">
				                  		<iframe id="readsIframe" style="width: 100%; height: 430px; border: 0px" src="${ctx }/console/reads.vm?procInstId=${procInstId }"></iframe>
				                  	</div>
			                  	</c:if>
			             	</div>
			      		</div>
		       		</div>
		        </div><!--/.main-content-inner-->
		    </div><!-- /.main-content -->
		</div><!-- /.main-container -->
		<script type="text/javascript">
			function diagramFresh(){
				$('#diagramIframe').attr('src', $('#diagramIframe').attr('src'));
			}
		    //显示子流程时用这个方法
		    function loadSubList(procInstId, executionId){
				$("#formList").load("${ctx }/console/history.vm?procInstId=" + procInstId + "&executionId=" + executionId+"&_t=" + new Date().getTime());
			}
	    </script>
	</body>
</html>

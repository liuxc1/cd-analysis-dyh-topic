<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
	<head>
		<title>阅读意见</title>
		<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
		<!--页面自定义的CSS，请放在这里 -->
		<style type="text/css">
		
		</style>
	</head>
	<body class="no-skin">
		<div class="main-container" id="main-container">
			<div class="main-content">
				<div class="main-content-inner padding-page-content">
					<div class="page-content">
						<div class="space-4"></div>
						<div class="row">
							<div class=" col-xs-12">
								<form class="form-horizontal" role="form" id="form1" action=""
									method="post">
									<div class="form-group">
										<label
											class="col-xs-12 control-label no-padding-right blue" style="text-align:left;">意见</label>
										<div class="col-xs-12 control-group">
											<textarea class="form-control" id="message" <c:choose><c:when test='${readInfo != null }'>readonly="readonly"</c:when><c:otherwise><c:if test='${readInfo == null }'>data-validation-engine="validate[maxSize[30]]" placeholder="请输入意见，30个字符以内"</c:if></c:otherwise></c:choose> style="height: 66px;">${readInfo.message }</textarea>
										</div>
									</div>
								</form>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
		<!-- 自己写的JS，请放在这里 -->
		<script type="text/javascript">
			$(function(){
				$("#form1").validationEngine({
		            scrollOffset: 98,//必须设置，因为Toolbar position为Fixed
		            promptPosition: 'bottomLeft',
		            autoHidePrompt: true
		        });
			});
			
			function check(){
				return $('#form1').validationEngine('validate');
			}
		</script>
	</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
<head>
<title>填写表单备注</title>
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
							<form class="form-horizontal" role="form" id="formInfo" action=""
								method="post">
								 <input type="hidden"
									name="form['DONE_DATAID']" id="T_WF_done_dataid"
									value="${form.ENTER_ID}" /> <input type="hidden"
									name="form['ENTER_ID']" id="ENTER_ID" value="${form.ENTER_ID}" />
								<input type="hidden" id="butstate" name="form['BUTSTATE']" />
								<div class="form-group">
									<label class="col-sm-2 control-label no-padding-right">
										填报备注 </label>
									<div class="col-sm-10">
										<textarea class="form-control" id="txtarea" maxlength="1300"
											placeholder="可拖动的大文本框" name="form['REMARK']"
											value="${form.REMARK}" style="width: 100%;height: 150px"></textarea>
									</div>

								</div>
								<div class="form-group">
									<div class="page-toolbar align-center">
										<button type="button"
											class="btn btn-xs    btn-xs-ths" id="btnSubmit"
											data-self-js="toSubmit()">
											<i class="ace-icon fa fa-check"></i> 确定
										</button>
										<button type="button" class="btn btn-xs btn-xs-ths"
											id="btnReturn" data-self-js="closeDailog()">
											<i class="ace-icon fa fa-reply"></i> 取消
										</button>
									</div>
								</div>
							</form>
					</div>
					<!-- /.row -->
				</div>
			</div>
			<!--/.main-content-inner-->
		</div>
		<!-- /.main-content -->
	</div>
	<!-- /.main-container -->

	<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>

	<!-- 自己写的JS，请放在这里 -->
	<script type="text/javascript">
	
	jQuery(function ($) {
	    //表单验证组件初始化，详细文档请参考http://code.ciaoca.com/jquery/validation-engine/ 或官网文档http://posabsolute.github.io/jQuery-Validation-Engine/
	    $("#formInfo").validationEngine({
	        scrollOffset: 98,//必须设置，因为Toolbar position为Fixed
	        promptPosition: 'bottomLeft',
	        autoHidePrompt: true
	    });
	    
	});
	
	function toSubmit(){
		var txt = $("#txtarea").val();
		window.parent.toSubmit(txt);
	}
	
	function closeDailog(){
		window.parent.closeRemarkDialog();
	}
</script>
</body>
</html>

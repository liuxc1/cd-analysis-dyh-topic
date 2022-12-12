<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
	<head>
		<title></title>
		<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
		<!--页面自定义的CSS，请放在这里 -->
		<style>
			.padding_1 {
				padding-left: 0px;
				padding-right: 0px;
				padding-top: 1px;
				padding-bottom: 1px;
			}
		</style>
		<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
	</head>
	<body class="no-skin">
				<div>
					<div class="page-toolbar align-right">
						<button type="button" class="btn btn-xs    btn-xs-ths" id="btnSave" onclick="saveFormInfo();">
							<i class="ace-icon fa fa-save"></i> 导出
						</button>
						<button type="button" class="btn btn-xs btn-xs-ths" onclick="window.parent.closeDialog('dialog-import')">
							<i class="ace-icon fa fa-reply"></i> 取消
						</button>
					</div>
				</div>
		<div class="main-container" id="main-container">
			<div class="main-content">
				<div class="main-content-inner padding-page-content">
					<div class="page-content">
						<form class="form-horizontal" role="form" id="formInfo" action="${ctx}/eform/exceltemplate/download.vm" method="post">
							<div class="row">
								<div class=" col-xs-12" id="formHtml">
									<div  class="form-group initrow">
										<span class="col-sm-12 padding_1"  >
											<div class="col-sm-12"  >
												<textarea 
												name="desigerid"
												data-validation-engine="validate[required]"
												maxlength="1000"
												placeholder="模板ID,同一个Excel多个sheet，ID逗号分隔" 
												style="width:100%;height:100"
												></textarea>
											</div>
										</span>
									</div>
								</div>
							</div>
						</form>
						<!-- /.row -->
					</div>
				</div>
			</div>
		</div>
	
		<script type="text/javascript" src="${ ctx }/assets/js/eform/eform_custom.js"></script>
		<!-- 自己写的JS，请放在这里 -->
		<script type="text/javascript">
			
			function saveFormInfo(){
				if($("#formInfo").validationEngine('validate')){
					ths.submitFormAjax({
						url : '${ctx}/eform/exceltemplate/checkdownload.vm',// any URL you want to submit
						data : $("#formInfo").serialize(),
						success : function(response){
							if(response.returnMessage=='OK'){
								$("#formInfo").submit();
							}else{
								dialog({
									title: '信息',
									content: response.returnMessage,
									ok: function () {}
								}).showModal();
							}
						}
					});
				}
			}	
		</script>
	</body>
</html>
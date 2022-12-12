<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
<head>
<title></title>
<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
<!--页面自定义的CSS，请放在这里 -->
<style type="text/css">
</style>
</head>

<body class="no-skin">

	<div class="main-container" id="main-container">
		<div class="main-content">
			<div class="main-content-inner fixed-page-header fixed-82">
				<div class="page-toolbar align-right">
					<button type="button" class="btn btn-xs    btn-xs-ths"
						id="btnSave" data-self-js="save()">
						<i class="ace-icon fa fa-save"></i> 保存
					</button>

					<button type="button" class="btn btn-xs btn-xs-ths"
						id="btnReturn" data-self-js="goBack()">
						<i class="ace-icon fa fa-reply"></i> 返回
					</button>
					<div class="space-2"></div>
					<hr class="no-margin">
				</div>

			</div>
			<div class="main-content-inner padding-page-content">
				<div class="page-content">
					<div class="space-4"></div>
					<div class="row">
						<div class=" col-xs-12">
							<form class="form-horizontal" role="form" id="formInfo" action=""
								method="post">
								<input type="hidden" name="form['DICTIONARY_ID']"
									value="${form.DICTIONARY_ID}" />
								
								<input type="hidden" name="form['DICTIONARY_TREE_ID']"
									value="${form.DICTIONARY_TREE_ID}" />
								<div class="form-group">
									<label class="col-sm-2 control-label no-padding-right">
										<i class="ace-icon fa fa-asterisk red smaller-70"></i> 条目编码
									</label>
									<div class="col-sm-4">
										<span class="input-icon width-100"> <input type="text"
											class="form-control"
											data-validation-engine="validate[required]"
											name="form['DICTIONARY_CODE']"
											value="${form.DICTIONARY_CODE}" />
										</span>
									</div>

									<label class="col-sm-2 control-label no-padding-right">
										<i class="ace-icon fa fa-asterisk red smaller-70"></i> 条目名称
									</label>
									<div class="col-sm-4">
										<span class="input-icon width-100"> <input type="text"
											class="form-control"
											data-validation-engine="validate[required]"
											name="form['DICTIONARY_NAME']"
											value="${form.DICTIONARY_NAME}" />
										</span>
									</div>

								</div>
								
								<div class="form-group">
									<label class="col-sm-2 control-label no-padding-right">
										 所属字典编码
									</label>
									<div class="col-sm-4">
										<span class="input-icon width-100"> <input type="text"
											class="form-control"
											readonly="readonly"
											data-validation-engine="validate[required]"
											value="${form.TREE_CODE}" />
										</span>
									</div>

									<label class="col-sm-2 control-label no-padding-right">
										 所属字典名称
									</label>
									<div class="col-sm-4">
										<span class="input-icon width-100"> <input type="text"
											class="form-control"
											readonly="readonly"
											data-validation-engine="validate[required]"
											value="${form.TREE_NAME}" />
										</span>
									</div>

								</div>
								
								<div class="form-group">
									<label class="col-sm-2 control-label no-padding-right">
										<i class="ace-icon fa fa-asterisk red smaller-70"></i> 排序
									</label>
									<div class="col-sm-4">
										<span class="input-icon width-100"> <input type="text"
											class="form-control"
											data-validation-engine="validate[required,custom[number]]"
											name="form['DICTIONARY_SORT']"
											value="${form.DICTIONARY_SORT}" />
										</span>
									</div>
								<label class="col-sm-2 control-label no-padding-right">
										描述
									</label>
									<div class="col-sm-4">
										<span class="input-icon width-100"> <input type="text"
											class="form-control"
											name="form['DICTIONARY_DESCRIPTION']"
											value="${form.DICTIONARY_DESCRIPTION}" />
										</span>
									</div>

								</div>
								<div class="form-group">
									<label class="col-sm-2 control-label no-padding-right">
										 扩展1
									</label>
									<div class="col-sm-4">
										<span class="input-icon width-100"> <input type="text"
											class="form-control"
											name="form['EXT1']" value="${form.EXT1}" />
										</span>
									</div>
									<label class="col-sm-2 control-label no-padding-right">
										 扩展2
									</label>
									<div class="col-sm-4">
										<span class="input-icon width-100"> <input type="text"
											class="form-control"
											name="form['EXT2']" value="${form.EXT2}" />
										</span>
									</div>
								</div>
								<div class="form-group">
									<label class="col-sm-2 control-label no-padding-right">
										 扩展3
									</label>
									<div class="col-sm-4">
										<span class="input-icon width-100"> <input type="text"
											class="form-control"
											name="form['EXT3']" value="${form.EXT3}" />
										</span>
									</div>
									<label class="col-sm-2 control-label no-padding-right">
										 扩展4
									</label>
									<div class="col-sm-4">
										<span class="input-icon width-100"> <input type="text"
											class="form-control"
											name="form['EXT4']" value="${form.EXT4}" />
										</span>
									</div>
								</div>
							</form>
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

	<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>

	<!-- 自己写的JS，请放在这里 -->
	<script type="text/javascript">
		//AJAX保存
		function save() {
			//提交之前验证表单
			if ($('#formInfo').validationEngine('validate')) {
				ths.submitFormAjax({
					url : 'save.vm',// any URL you want to submit
					data : $("#formInfo").serialize()
				// 如果不需要提交整个表单，可构造JSON提交，如{name:'老王',age:50}
				});
			}
		}
		//返回
		function goBack() {
			$("#main-container", window.parent.document).show();
			$("#iframeInfo", window.parent.document).attr("src", "#").hide();
		}

		jQuery(function($) {

			//表单验证组件初始化，详细文档请参考http://code.ciaoca.com/jquery/validation-engine/ 或官网文档http://posabsolute.github.io/jQuery-Validation-Engine/
			$("#formInfo").validationEngine({
				scrollOffset : 98,//必须设置，因为Toolbar position为Fixed
				promptPosition : 'bottomLeft',
				autoHidePrompt : true
			});

		});
	</script>
</body>
</html>

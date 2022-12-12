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
								<input type="hidden" name="table['JDP_EFORM_DICTIONARYTREE'].key['TREE_ID']"
									value="${table['JDP_EFORM_DICTIONARYTREE'].key['TREE_ID']}" />
								<input type="hidden" name="table['JDP_EFORM_DICTIONARYTREE'].column['JDP_APP_CODE']"
									value="<%=ths.jdp.core.context.PropertyConfigure.getProperty("jdp.app.code").toString()%>" />
								<div class="form-group">
									<label class="col-sm-2 control-label no-padding-right">
										<i class="ace-icon fa fa-asterisk red smaller-70"></i> 字典编码
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control" id="treeCode"
											data-validation-engine="validate[required,custom[onlyFormCode],maxSize[20],funcCall[ajaxCodeRepeated]]"
											placeholder="允许字母、数字、下划线，20个字符以内"
											name="table['JDP_EFORM_DICTIONARYTREE'].column['TREE_CODE']" 
											value="${table['JDP_EFORM_DICTIONARYTREE'].column['TREE_CODE']}" />
									</div>
									<label class="col-sm-2 control-label no-padding-right">
										<i class="ace-icon fa fa-asterisk red smaller-70"></i> 字典名称
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control"
											data-validation-engine="validate[required,maxSize[20]]"
											name="table['JDP_EFORM_DICTIONARYTREE'].column['TREE_NAME']" value="${table['JDP_EFORM_DICTIONARYTREE'].column['TREE_NAME']}" />
									</div>
								</div>
								<div class="form-group">
									<label class="col-sm-2 control-label no-padding-right">
										<i class="ace-icon fa fa-asterisk red smaller-70"></i> 父节点编码
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control" readonly="readonly"
											data-validation-engine="validate[required]" id="tree_pcode"
											name="tree_pcode" value="${dicTree['TREE_CODE']}" />
									</div>

									<label class="col-sm-2 control-label no-padding-right">
										<i class="ace-icon fa fa-asterisk red smaller-70"></i> 父节点
									</label>
									<div class="col-sm-4">
										<div class="input-group">
											<input type="text" class="form-control" placeholder=""
												id="tree_pname" data-validation-engine="validate[required]"
												readonly="readonly" value="${dicTree['TREE_NAME']}" /> <input
												type="hidden" id="tree_pid" name="table['JDP_EFORM_DICTIONARYTREE'].column['TREE_PID']"
												value="${dicTree['TREE_ID']}" /> <span class="input-group-btn">
												<button type="button" class="btn btn-white  "
													id="btnChooseTreeNode">
													<i class="ace-icon fa fa-search"></i> 选择
												</button>
												<button type="button" class="btn btn-white  "
													onclick="removeSingle('tree_pname','tree_pid')">
													<i class="ace-icon fa fa-remove"></i>
												</button>
											</span>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col-sm-2 control-label no-padding-right">
										<i class="ace-icon fa fa-asterisk red smaller-70"></i> 排序
									</label>
									<div class="col-sm-4">
										<input type="text" class="form-control"
											data-validation-engine="validate[required,custom[number]]"
											name="table['JDP_EFORM_DICTIONARYTREE'].column['TREE_SORT']" value="${table['JDP_EFORM_DICTIONARYTREE'].column['TREE_SORT']}" />
									</div>
									<label class="col-sm-2 control-label no-padding-right">
										描述 </label>
									<div class="col-sm-4">
										<input type="text" class="form-control" placeholder="50个字符以内" data-validation-engine="validate[maxSize[50]]"
											name="table['JDP_EFORM_DICTIONARYTREE'].column['TREE_DESCRIPTION']"
											value="${table['JDP_EFORM_DICTIONARYTREE'].column['TREE_DESCRIPTION']}" />
									</div>
								</div>
								<div class="form-group">
									<label class="col-sm-2 control-label no-padding-right">
										扩展1 </label>
									<div class="col-sm-4">
										<input type="text" class="form-control" name="table['JDP_EFORM_DICTIONARYTREE'].column['EXT1']"
											value="${table['JDP_EFORM_DICTIONARYTREE'].column['EXT1']}" data-validation-engine="validate[maxSize[30]]"/>
									</div>
									<label class="col-sm-2 control-label no-padding-right">
										扩展2 </label>
									<div class="col-sm-4">
										<input type="text" class="form-control" name="table['JDP_EFORM_DICTIONARYTREE'].column['EXT2']"
											value="${table['JDP_EFORM_DICTIONARYTREE'].column['EXT2']}" data-validation-engine="validate[maxSize[30]]"/>
									</div>
								</div>
								<div class="form-group">
									<label class="col-sm-2 control-label no-padding-right">
										扩展3 </label>
									<div class="col-sm-4">
										<input type="text" class="form-control" name="table['JDP_EFORM_DICTIONARYTREE'].column['EXT3']"
											value="${table['JDP_EFORM_DICTIONARYTREE'].column['EXT3']}" data-validation-engine="validate[maxSize[30]]"/>
									</div>
									<label class="col-sm-2 control-label no-padding-right">
										扩展4 </label>
									<div class="col-sm-4">
										<input type="text" class="form-control" name="table['JDP_EFORM_DICTIONARYTREE'].column['EXT4']"
											value="${table['JDP_EFORM_DICTIONARYTREE'].column['EXT4']}" data-validation-engine="validate[maxSize[30]]"/>
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
				,success:function(response){
					if(response=="success"){
						if(window.parent.parent.expandNode){
							window.parent.parent.expandNode("${treePid}");
						}
						this.callback();
					}
				}
				});
			} 
		}
		//返回
		function goBack() {
			$("#main-container", window.parent.document).show();
			$("#iframeInfo", window.parent.document).attr("src", "#").hide();
		}

		function removeSingle(name, id) {
			$("#" + name).val("");
			$("#" + id).val("");
		}

		//选择框相关函数begin 
		var treeDialog;
		$("#btnChooseTreeNode").on(
			ace.click_event,
			function(e) {
				e.preventDefault();
				treeDialog = dialog({
					id : "dialog-user-muti",
					title : '选择',
					url : '${ctx}/eform/tree/window.vm?mapperid=dictionary_tree&callback=treeCallBack&jdpAppCode=<%=ths.jdp.core.context.PropertyConfigure.getProperty("jdp.app.code").toString()%>',
					width : 380,
					height : 480 > document.documentElement.clientHeight ? document.documentElement.clientHeight: 480
				}).showModal();
		});
		function closeTreeDialog() {
			treeDialog.close().remove();
		}
		function treeCallBack(node) {
			$("#tree_pname").val(node.TREE_NAME);
			$("#tree_pid").val(node.TREE_ID);
			$("#tree_pcode").val(node.TREE_CODE);
		}
		// 选择框相关函数end
		
		//校验编码是否已被使用,在validate校验中添加funcCall[ajaxCodeRepeated],例如data-validation-engine="validate[required,funcCall[ajaxCodeRepeated]]"
		function ajaxCodeRepeated(){
			var ajaxResult=true;
			$.ajax({
				url:"${ctx}/eform/validation/repeated.vm",
				//{datasource:"数据源(可以不传，不传则使用系统默认数据源)",table:"表名",field:"需要校验的字段名",IgnoreCase:true|false,fieldValue:"该字段表单值",oldValue:"该字段数据库值"}
				//IgnoreCase取值，举例：当fieldValue值为form_info,如果数据库现有的值的FORM_INFO，当IgnoreCase为true时，服务端返回false，代表编号重复，如果IgnoreCase为false，服务端返回true，代表编号可用。
				data:{table:"jdp_eform_dictionarytree",field:"tree_code",IgnoreCase:true,fieldValue:$("#treeCode").val(),oldValue:"${table['JDP_EFORM_DICTIONARYTREE'].column['TREE_CODE']}"},
				type:"post",
				dataType:"text",
				async:false,
				success:function(response){
					if(response=="false")
						ajaxResult=false;
				},
				error:function(response){
					ajaxResult=false; 
				}
			});
			if(ajaxResult==false)
				return "此编码已被其他人使用";
		}
		jQuery(function($) {
					
			$.validationEngineLanguage.allRules.onlyFormCode= {
					 "regex": /^[0-9a-zA-Z\_]+$/,
	                 "alertText": "* 只接受字母、数字、下划线"
		 	};
			
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

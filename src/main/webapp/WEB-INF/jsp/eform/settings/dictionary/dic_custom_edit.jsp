<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
<head>
<title>自定义字典页面</title>
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
						id="btnSave" data-self-js="doDelete()">
						<i class="ace-icon fa fa-trash-o"></i> 清除
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
								<input type="hidden" id="treeId" name="table['JDP_EFORM_DICCUSTOM'].key['DICTIONARY_TREE_ID']"
									value="${table['JDP_EFORM_DICCUSTOM'].key['DICTIONARY_TREE_ID']}" />
								
								<div class="form-group">
									<label class="col-sm-2 control-label no-padding-right">
										<i class="ace-icon fa fa-asterisk red smaller-70"></i>
										数据源
									</label>
									<div class="col-sm-8">
										<select class="form-control" id="dicDataSource" name="table['JDP_EFORM_DICCUSTOM'].column['DIC_DATASOURCE']" onchange="changeDataSource()" data-validation-engine="validate[required]">
	                                       <option value="">---请选择---</option>
	                                       <c:forEach items="${dataSourceIdList}" var="dataSourceId">
	                                       		<option value="${dataSourceId}" <c:if test="${table['JDP_EFORM_DICCUSTOM'].column['DIC_DATASOURCE']==dataSourceId }">selected</c:if>>${dataSourceId }</option>
	                                       </c:forEach>
			                            </select>
									</div>

								</div>
								
								<div class="form-group">
									<label class="col-sm-2 control-label no-padding-right">
										<i class="ace-icon fa fa-asterisk red smaller-70"></i>
										SQL
									</label>
									<div class="col-sm-8">
										<textarea rows="" cols="" name="table['JDP_EFORM_DICCUSTOM'].column['DIC_SQL']" id="dicSql" 
										data-validation-engine="validate[required,maxSize[1200]]" 
										placeholder="约定字段：条目字典必须包含CODE、NAME；树字典必须包含TREE_ID、TREE_NAME、TREE_PID"
										style="width:100%;height:100px;resize: vertical;">${table['JDP_EFORM_DICCUSTOM'].column['DIC_SQL']}</textarea>
									</div>
								</div>
								<div class="form-group">
									<label class="col-sm-2 control-label no-padding-right">
										 扩展1
									</label>
									<div class="col-sm-3">
										 <input type="text"
											class="form-control"
											data-validation-engine="validate[maxSize[30]]" 
											name="table['JDP_EFORM_DICCUSTOM'].column['EXT1']" value="${table['JDP_EFORM_DICCUSTOM'].column['EXT1']}" />
									</div>
									<label class="col-sm-2 control-label no-padding-right">
										 扩展2
									</label>
									<div class="col-sm-3">
										 <input type="text"
											class="form-control"
											data-validation-engine="validate[maxSize[30]]" 
											name="table['JDP_EFORM_DICCUSTOM'].column['EXT2']" value="${table['JDP_EFORM_DICCUSTOM'].column['EXT2']}" />
									</div>
								</div>
								<div class="form-group">
									<label class="col-sm-2 control-label no-padding-right">
										 扩展3
									</label>
									<div class="col-sm-3">
										<input type="text"
											class="form-control"
											data-validation-engine="validate[maxSize[30]]" 
											name="table['JDP_EFORM_DICCUSTOM'].column['EXT3']" value="${table['JDP_EFORM_DICCUSTOM'].column['EXT3']}" />
										
									</div>
									<label class="col-sm-2 control-label no-padding-right">
										 扩展4
									</label>
									<div class="col-sm-3">
										 <input type="text"
											class="form-control"
											data-validation-engine="validate[maxSize[30]]" 
											name="table['JDP_EFORM_DICCUSTOM'].column['EXT4']" value="${table['JDP_EFORM_DICCUSTOM'].column['EXT4']}" />
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
			var dicSql = $("#dicSql").val();
			if(dicSql.trim().toLowerCase().indexOf("select")!=0){
				ths.dialog("SQL必须是以select开始的查询语句");
				return;
			}
			//提交之前验证表单
			if ($('#formInfo').validationEngine('validate')) {
				ths.submitFormAjax({
					url : 'customSave.vm',// any URL you want to submit
					data : $("#formInfo").serialize()// 如果不需要提交整个表单，可构造JSON提交，如{name:'老王',age:50}
					,success:function(data)
					{
						if(data=="success"){
							dialog({
				                title: '提示',
				                content: '保存成功',
				                wraperstyle:'alert-info',
				                ok: function () {}
				            }).showModal();
						}
					}
				});
			}
		}
		//删除
		function doDelete(){
			dialog({
                title: '删除',
                icon:'fa-times-circle',
                wraperstyle:'alert-warning',
                content: '确实要清除当前自定义字典吗?',
                ok: function () {
                    //TODO ajax submit
                	ths.submitFormAjax(
               			{
               				url:'customDelete.vm',
               				data:{'id':$("#treeId").val()},
               				callback: function(){
               					//刷出之后，刷新列表
               					window.location.reload();	
               				}
               			}
               		);
                },
                cancel:function(){}
            }).showModal();
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

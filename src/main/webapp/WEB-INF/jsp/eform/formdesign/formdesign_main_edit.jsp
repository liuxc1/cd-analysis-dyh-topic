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
					<button type="button" class="btn btn-xs btn-primary btn-xs-ths"
						id="btnSave" data-self-js="save()">
						<i class="ace-icon fa fa-save"></i> 保存
					</button>

					<button type="button" class="btn btn-xs btn-danger btn-xs-ths"
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
								<input type="hidden" 
								       name="table['JDP_EFORM_FORM'].key['FORM_ID']"
									   value="${table['JDP_EFORM_FORM'].key['FORM_ID']}" />
								<input type="hidden" name="table['JDP_EFORM_FORM'].column['TABLE_COL_NUM']" value="${table['JDP_EFORM_FORM'].column['TABLE_COL_NUM'] == null ? 1 : table['JDP_EFORM_FORM'].column['TABLE_COL_NUM']}" />
								<div class="form-group">
									<label class="col-sm-2 control-label no-padding-right">
										<i class="ace-icon fa fa-asterisk red smaller-70"></i> 表单编码
									</label>
									<div class="col-sm-4">
										 <input type="text"
											class="form-control" 
											id="FORM_CODE" 
											name="table['JDP_EFORM_FORM'].column['FORM_CODE']"
											data-validation-engine="validate[required,custom[onlyFormCode],maxSize[40],funcCall[ajaxCodeRepeated]]"
											placeholder="允许字母、数字、下划线，40个字符以内"
											oldvalue="${table['JDP_EFORM_FORM'].column['FORM_CODE']}"
											value="${table['JDP_EFORM_FORM'].column['FORM_CODE']}" />
									</div>

									<label class="col-sm-2 control-label no-padding-right">
										<i class="ace-icon fa fa-asterisk red smaller-70"></i> 表单名称
									</label>
									<div class="col-sm-4">
										 <input type="text"
											class="form-control"
											name="table['JDP_EFORM_FORM'].column['FORM_NAME']"
											data-validation-engine="validate[required,maxSize[20]]"
											value="${table['JDP_EFORM_FORM'].column['FORM_NAME']}" />
									</div>
								</div>
								
								<div class="form-group">
								
									<label class="col-sm-2 control-label no-padding-right">
										<i class="ace-icon fa fa-asterisk red smaller-70"></i>
										 数据表名称
									</label>
									 <div class="col-sm-4">
	                                    <div class="input-group">
	                                    	<input type="hidden"  
	                                    	       id="TABLE_ID" 
	                                    	       name="table['JDP_EFORM_FORM'].column['TABLE_ID']"
												   value="${table['JDP_EFORM_FORM'].column['TABLE_ID']}" />
											
	                                        <input type="text" class="form-control" 
	                                               id="TABLE_NAME"
	                                               name="table['JDP_EFORM_FORM'].column['TABLE_NAME']"
	                                               data-validation-engine="validate[required]" readonly="readonly"
	                                               placeholder="" 
											       value="${table['JDP_EFORM_FORM'].column['TABLE_NAME']}"
	                                        />
		                                    <span class="input-group-btn">
			                                    <button type="button" class="btn btn-white btn-default" data-self-js="openMeta()">
			                                        <i class="ace-icon fa fa-search" ></i>
			                                       	 选择
			                                    </button>
		                                        <button type="button" class="btn btn-white btn-default">
		                                            <i class="ace-icon fa fa-remove"></i>
		                                        </button>
		                                    </span>
	                                    </div>
                                	</div>

									<label class="col-sm-2 control-label no-padding-right">
										 所属分类名称
									</label>
									<div class="col-sm-4">
										<input type="hidden" name="table['JDP_EFORM_FORM'].column['CATEGORY_ID']" id="categoryId" value="${categoryMap['CATEGORY_ID']}"/>
										<input type="text"
											class="form-control"
											id="categoryName"
											readonly="readonly"
											data-validation-engine="validate[required]"
											value="${categoryMap['CATEGORY_NAME']}" onclick="showCategorySelect()"/>
									</div>
								</div>
								<div class="form-group">
									<label class="col-sm-2 control-label no-padding-right">
										设计模式
									</label>
									<div class="col-sm-10">
										<select id="DESIGN_MODEL" name="table['JDP_EFORM_FORM'].column['DESIGN_MODEL']" <c:if test="${table['JDP_EFORM_FORM'].column['FORM_ID'] != null }">disabled="disabled"</c:if>>
											<option value="BOOTSRAP" <c:if test="${table['JDP_EFORM_FORM'].column['DESIGN_MODEL'] == 'BOOTSRAP'}">selected="selected"</c:if>>BOOTSRAP</option>
											<option value="TABLE" <c:if test="${table['JDP_EFORM_FORM'].column['DESIGN_MODEL'] == 'TABLE'}">selected="selected"</c:if>>表格</option>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col-sm-2 control-label no-padding-right">
										描述
									</label>
									<div class="col-sm-10">
										 <textarea class="form-control" 
										           id="txtarea" 
										 		   name="table['JDP_EFORM_FORM'].column['FORM_DESCRIPTION']"
										 		   placeholder="600个字符以内"
										 		   data-validation-engine="validate[maxSize[600]]"
	                                               style=" height: 66px;resize: vertical;">${table['JDP_EFORM_FORM'].column['FORM_DESCRIPTION']}</textarea>
									</div>
								</div>
								<div class="form-group">
									<label class="col-sm-2 control-label no-padding-right">
										工作流Key
									</label>
									<div class="col-sm-10">
										<select id="BPM_PROC_KEY" name="table['JDP_EFORM_FORM'].column['BPM_PROC_KEY']">
											<option value="">无</option>
										</select>
										数据表必须包含INSTANCE_ID，用来存放流程实例ID
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
					url : '${ctx}/eform/formdesign/formdesign_main_save.vm',// any URL you want to submit
					data : $("#formInfo").serialize()
				});
			}
		}
		//返回
		function goBack() {
			$("#main-container", window.parent.document).show();
			$("#iframeInfo", window.parent.document).attr("src", "#").hide();
		}
		
		var treeDialog;
		function openMeta(){
			  treeDialog=dialog({
					id:"dialog-meta-muti",
			        title: "选择元数据",
			        url: "${ctx}/eform/tree/window.vm?sqlpackage=ths.jdp.eform.mapper.Meta&mapperid=meta_tree&callback=metaCallBack&loginName=<%=request.getAttribute("loginName") == null || ths.jdp.core.web.LoginCache.isSuperAdmin(request.getAttribute("loginName").toString()) ? "" : request.getAttribute("loginName").toString() %>&jdpAppCode="+jdpAppCode,
			        width:380,
			        height:480
			    }).showModal();
		}
		function metaCallBack(tree){
			if(tree.TABLE_STATE){
				var _tableId=tree.TREE_ID;
				$.ajax({
					url:"${ctx}/eform/meta/definition/getPrimaryKeyNum.vm?TABLE_ID="+_tableId,
					dataType:"text",
					cache:false,
					success:function(response){
						var num=parseInt(response)
						if(num<1){
							dialog({
				                title: '提示',
				                content: '该元数据未设置主键，请前往元数据处进行设置！',
				                wraperstyle:'alert-info',
				                ok: function () {}
				            }).showModal();
						}else if(num>1){
							dialog({
				                title: '提示',
				                content: '元数据只能设置一个主键，请前往元数据处进行修改',
				                wraperstyle:'alert-info',
				                ok: function () {}
				            }).showModal();
						}else{
							treeDialog.close().remove();
							$("#TABLE_ID").val(tree.TREE_ID);
							$("#TABLE_NAME").val(tree.TREE_NAME);
						}
					}
				})
			}
		}
		var jdpAppCode = "<%=ths.jdp.core.context.PropertyConfigure.getProperty("jdp.app.code").toString()%>";
		//选择流程分类
		function showCategorySelect(){
			dialog({
				id:"dialog-category-select",
		        title: '选择',
		        url: '${ctx}/eform/tree/window.vm?sqlpackage=ths.jdp.eform.mapper.settings.category.CategoryMapper&mapperid=tree&callback=diaCatSelCallback&loginName=<%=request.getAttribute("loginName") == null || ths.jdp.core.web.LoginCache.isSuperAdmin(request.getAttribute("loginName").toString()) ? "" : request.getAttribute("loginName").toString() %>'
		        		+ '&jdpAppCode=' + jdpAppCode + '&categoryTypeId=EFORM_DESIGN',
		        width:300,
		        height:400>document.documentElement.clientHeight?document.documentElement.clientHeight:400
		    }).showModal();
		}
		//选择流程分类回调
		function diaCatSelCallback(node){
			$("#categoryId").val(node.TREE_ID);
			$("#categoryName").val(node.TREE_NAME);
			dialog.get("dialog-category-select").close().remove();
		}
		
		//校验编码是否已被使用,在validate校验中添加funcCall[ajaxCodeRepeated],例如data-validation-engine="validate[required,funcCall[ajaxCodeRepeated]]"
		function ajaxCodeRepeated(){
			var ajaxResult=true;
			$.ajax({
				url:"${ctx}/eform/validation/repeated.vm",
				//{datasource:"数据源(可以不传，不传则使用系统默认数据源)",table:"表名",field:"需要校验的字段名",IgnoreCase:true|false,fieldValue:"该字段表单值",oldValue:"该字段数据库值"}
				//IgnoreCase取值，举例：当fieldValue值为form_info,如果数据库现有的值的FORM_INFO，当IgnoreCase为true时，服务端返回false，代表编号重复，如果IgnoreCase为false，服务端返回true，代表编号可用。
				data:{table:"jdp_eform_form",field:"form_code",IgnoreCase:true,fieldValue:$("#FORM_CODE").val(),oldValue:"${table['JDP_EFORM_FORM'].column['FORM_CODE']}"},
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

			/* $.validationEngineLanguage.allRules.ajaxCodeRepeated= {
		            url: "${ctx}/eform/validation/repeated.vm",
		            //extraDataDynamic:"#TABLE_ID", 
		            extraData: "datasource=datasource1&table=jdp_eform_form&field=form_code&oldValue=${table['JDP_EFORM_FORM'].column['FORM_CODE']}",  
		            alertText: "* 此编码已被其他人使用",
		            alertTextLoad: "* 正在确认编码是否被使用，请稍等。"
		 	};  */
			
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
			
			//初始化工作流key
			$.ajax({
				url:"${ctx}/console/getdeployprocess.vm",
				type:"post",
				dataType:"text",
				async:false,
				success:function(response){
					if(response != null && response != "" && response != "null"){
						var json = JSON.parse(response);
						for(var i = 0; i < json.length; i++){
							$("#BPM_PROC_KEY").append('<option value="' + json[i].procKey + '">' + json[i].procName + '</option>');
						}
						$("#BPM_PROC_KEY").val("${table['JDP_EFORM_FORM'].column['BPM_PROC_KEY']}");
					}
				},
				error:function(response){
				}
			});

		});
	</script>
</body>
</html>

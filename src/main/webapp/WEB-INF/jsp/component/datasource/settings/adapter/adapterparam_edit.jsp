<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
	<head>
	    <title>编辑适配器参数</title>
		<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
	  	<!--页面自定义的CSS，请放在这里 -->
	    <style type="text/css">
	    	#paramTable{
	    		table-layout: fixed;
	    	}
	    	#paramTable th,#paramTable td{
	    		text-overflow: ellipsis; /* for IE */  
			    -moz-text-overflow: ellipsis; /* for Firefox,mozilla */  
			    overflow: hidden;  
			    white-space: nowrap;  
			    border: 1px solid;  
			    text-align: left  
	    	}
	    </style>
	</head>
	<body class="no-skin">
		<div class="main-container" id="main-container">
		    <div class="main-content">
		    	<div class="main-content-inner fixed-page-header fixed-82">
		            <div id="breadcrumbs" class="breadcrumbs">
		                <ul class="breadcrumb">
		                    <li class="active">
		                        <h5 class="page-title" >
		                 			<i class="fa fa-file-text-o"></i>
		                 			编辑适配器参数
		                        </h5>
		                    </li>
		                </ul><!-- /.breadcrumb -->
		            </div>
		            <div class="page-toolbar align-right">
		                <button type="button" class="btn btn-xs btn-primary btn-xs-ths" id="btnSave">
		                    <i class="ace-icon fa fa-save"></i>
							保存
		                </button>
		                <button type="button" class="btn btn-xs btn-danger btn-xs-ths" id="btnReturn" data-self-js="goBack()">
		                    <i class="ace-icon fa fa-reply"></i>
							返回
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
		        				<form class="form-horizontal" role="form" id="formInfo" action="" method="post">
									<input type="hidden" name="adapterParamId" value="${form.adapterParamId }">
									<input type="hidden" id="adapterId" name="adapterId" value="${form.adapterId == null ? adapterId : form.adapterId }">
			                        <div class="form-group">
		                                <label class="col-sm-2 control-label no-padding-right">
		                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
											参数CODE
		                                </label>
		                                <div class="col-sm-4">
		                                	<input type="text" class="form-control" data-validation-engine="validate[required,custom[onlyFormCode],funcCall[checkParamCode],maxSize[100]]"
		                                   			name="paramCode" value="${form.paramCode }"/>
		                                </div>
		                            </div>
		                            <div class="form-group">
		                                <label class="col-sm-2 control-label no-padding-right">
		                                	<i class="ace-icon fa fa-asterisk red smaller-70"></i>
											参数名称
		                                </label>
		                                <div class="col-sm-10">
		                                    <textarea class="form-control" id="txtarea" placeholder="可拖动的大文本框" name="paramName" data-validation-engine="validate[required,maxLength[500]]"
		                                              style="height: 66px;">${form.paramName }</textarea>
		                                </div>
		                            </div>
		                            <div class="form-group">
		                                <label class="col-sm-2 control-label no-padding-right">
											参数提示
		                                </label>
		                                <div class="col-sm-10">
		                                    <textarea class="form-control" id="txtarea" placeholder="可拖动的大文本框" name="paramPrompt" data-validation-engine="validate[maxLength[1000]]"
		                                              style="height: 66px;">${form.paramPrompt }</textarea>
		                                </div>
		                            </div>
		                            <div class="form-group">
		                                <label class="col-sm-2 control-label no-padding-right">
											参数值字典
		                                </label>
		                                <div class="col-sm-4">
		                                	<input type="text" class="form-control" name="paramRequiredSelect" value="${form.paramRequiredSelect }" data-validation-engine="validate[custom[onlyFormCode],maxSize[100]]"/>
		                                </div>
		                                <label class="col-sm-2 control-label no-padding-right">
											默认值
		                                </label>
		                                <div class="col-sm-4">
		                                	<input type="text" class="form-control" name="paramDefaultValue" value="${form.paramDefaultValue }" data-validation-engine="validate[maxLength[200]]"/>
		                                </div>
		                            </div>
		                            <div class="form-group">
		                                <label class="col-sm-2 control-label no-padding-right">
		                                	<i class="ace-icon fa fa-asterisk red smaller-70"></i>
											是否必填
		                                </label>
		                                <div class="col-sm-4">
		                                	<select name="paramRequired" class="form-control" data-validation-engine="validate[required]">
			                                	<c:forEach var="dic" items="${dictionarys['META_IS_REQUIRED'] }">
													<option value="${dic.dictionary_code }" <c:if test="${form.paramRequired == dic.dictionary_code }">selected="selected"</c:if>>${dic.dictionary_name }</option>
												</c:forEach>
											</select>
		                                </div>
		                                <label class="col-sm-2 control-label no-padding-right">
		                                	<i class="ace-icon fa fa-asterisk red smaller-70"></i>
											排序
		                                </label>
		                                <div class="col-sm-4">
		                                	<input type="text" class="form-control" data-validation-engine="validate[required,custom[integer]]"
		                                   			name="paramOrderBy" value="${form.paramOrderBy }"/>
		                                </div>
		                            </div>
		                            <div class="form-group">
		                                <label class="col-sm-2 control-label no-padding-right">
		                                	<i class="ace-icon fa fa-asterisk red smaller-70"></i>
											数据类型
		                                </label>
		                                <div class="col-sm-4">
		                                	<select id="paramDataType" name="paramDataType" class="form-control" data-validation-engine="validate[required]" onchange="changeDataType()">
			                                	<c:forEach var="dic" items="${dictionarys['PARAM_DATA_TYPE'] }">
													<option value="${dic.dictionary_code }" <c:if test="${form.paramDataType == dic.dictionary_code }">selected="selected"</c:if>>${dic.dictionary_name }</option>
												</c:forEach>
											</select>
		                                </div>
		                                <label class="col-sm-2 control-label no-padding-right">
											最大长度
		                                </label>
		                                <div class="col-sm-4">
		                                	<input type="text" class="form-control" data-validation-engine="validate[custom[integer]]"
		                                   			name="paramMaxLength" value="${form.paramMaxLength }"/>
		                                </div>
		                            </div>
		                            <div class="form-group" id="num_prop_div" style="display: none;">
		                                <label class="col-sm-2 control-label no-padding-right">
											最大值
		                                </label>
		                                <div class="col-sm-4">
		                                	<input type="text" class="form-control" data-validation-engine="validate[custom[number]]"
		                                   			name="paramMaxValue" value="${form.paramMaxValue }"/>
		                                </div>
		                                <label class="col-sm-2 control-label no-padding-right">
											最小值
		                                </label>
		                                <div class="col-sm-4">
		                                	<input type="text" class="form-control" data-validation-engine="validate[custom[number]]"
		                                   			name="paramMinValue" value="${form.paramMinValue }"/>
		                                </div>
		                            </div>
		                            <div class="form-group" id="date_prop_div" style="display: none;">
		                                <label class="col-sm-2 control-label no-padding-right">
											日期格式
		                                </label>
		                                <div class="col-sm-4">
		                                	<input type="text" class="form-control" name="paramDatePattern" value="${form.paramDatePattern }"/>
		                                </div>
		                            </div>
								</form>
							</div>
						</div>
		        	</div>
		        </div>
		    </div><!-- /.main-content -->
		</div><!-- /.main-container -->
		
		<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
		
		<!-- 自己写的JS，请放在这里 -->
		<script type="text/javascript">
			//数据类型改变
			function changeDataType(){
				var value = $("#paramDataType").val();
				$("#num_prop_div").hide();
				$("#date_prop_div").hide();
				if(value == "DATE"){
					$("#date_prop_div").show();
				}else if(value == "INT" || value == "NUMBER"){
					$("#num_prop_div").show();
				}
			}
		
			//检测参数CODE是否可用
			function checkParamCode(field, rules, i, options){
				if("${form.paramCode }" == field.val()){
					return;
				}
				var ajaxResult = true;
				$.ajax({
					url: "${ctx}/component/datasource/settings/adapter/param/checkCode.vm",
					data: "adapterId=" + $("#adapterId").val() + "&paramCode=" + field.val(),
					type:"post",
					dataType:"text",
					async: false,
					success: function(response){
						if(response == "error"){
							ajaxResult = false;
						}
					},
					error: function(response){
						ajaxResult = false; 
					}
				});
				if(ajaxResult == false){
					return "此参数CODE已被使用，请重新命名！";
				}
			}
			//返回
			function goBack() {
			    $("#main-container",window.parent.document).show();
			    $("#iframeInfo",window.parent.document).attr("src","").hide();
			}
			
			jQuery(function ($) {
			    $("#formInfo").validationEngine({
			        scrollOffset: 98,//必须设置，因为Toolbar position为Fixed
			        promptPosition: 'bottomLeft',
			        autoHidePrompt: true,
			        validateNonVisibleFields: true
			    });
			    //保存操作
			    $("#btnSave").on(ace.click_event, function () {
		            if($('#formInfo').validationEngine('validate')) {
		            	$("#adapterStateName").val($("#adapterStateId").find("option:selected").text());
		            	ths.submitFormAjax({
							url : '${ctx}/component/datasource/settings/adapter/param/save.vm',
							data : $("#formInfo").serialize(),
							success : function(response){
								if(response == 'success'){
									window.parent.doSearch();
								}else{
									dialog({
										title: '信息',
										content: response,
										ok: function () {}
									}).showModal();
								}
							}
						});
		            }
		        });
			    
			    changeDataType();
			});
		</script>
	</body>
</html>

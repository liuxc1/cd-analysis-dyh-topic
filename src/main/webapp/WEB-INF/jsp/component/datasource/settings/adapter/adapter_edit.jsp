<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
	<head>
	    <title>编辑适配器</title>
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
		                 			编辑适配器
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
									<input type="hidden" name="adapterId" value="${form.adapterId }">
			                        <div class="form-group">
		                                <label class="col-sm-2 control-label no-padding-right">
		                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
											适配器名称
		                                </label>
		                                <div class="col-sm-4">
		                                	<input type="text" class="form-control" data-validation-engine="validate[required,maxLength[200]]"
		                                   			name="adapterName" value="${form.adapterName }"/>
		                                </div>
		                                <label class="col-sm-2 control-label no-padding-right">
											适配器实现类
		                                </label>
		                                <div class="col-sm-4">
		                                	<input type="text" class="form-control" name="adapterClass" value="${form.adapterClass }" 
		                                			data-validation-engine="validate[custom[onlyCode],maxSize[200]]"/>
		                                </div>
		                            </div>
		                            <div class="form-group">
		                            	<label class="col-sm-2 control-label no-padding-right">
		                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
											适配器状态
		                                </label>
		                                <div class="col-sm-4">
		                                	<input type="hidden" class="form-control" id="adapterStateName" name="adapterStateName"/>
		                                	<select id="adapterStateId" name="adapterStateId" data-validation-engine="validate[required]" class="form-control">
		                                		<option value="">请选择</option>
		                                		<option value="run" <c:if test="${form.adapterStateId == 'run' }">selected="selected"</c:if>>运行</option>
		                                	</select>
		                                </div>
		                                <label class="col-sm-2 control-label no-padding-right">
		                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
											 排序
		                                </label>
		                                <div class="col-sm-4">
		                                	<input type="text" class="form-control" data-validation-engine="validate[required,custom[integer]]"
		                                   			name="adapterOrderBy" value="${form.adapterOrderBy }"/>
		                                </div>
		                            </div>
		                            <div class="form-group">
		                                <label class="col-sm-2 control-label no-padding-right">
											适配器描述
		                                </label>
		                                <div class="col-sm-10">
		                                    <textarea class="form-control" id="txtarea" placeholder="可拖动的大文本框" name="adapterDescription"
		                                              style="height: 66px;" data-validation-engine="validate[maxLength[500]]">${form.adapterDescription }</textarea>
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
							url : '${ctx}/component/datasource/settings/adapter/save.vm',
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
			});
		</script>
	</body>
</html>

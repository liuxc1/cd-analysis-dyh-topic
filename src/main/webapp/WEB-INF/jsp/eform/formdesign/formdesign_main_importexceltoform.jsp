<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="en" >
	<head>
	    <title></title>
	    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
	</head>
	<body class="no-skin">
		<div class="main-container" id="main-container">
		    <div class="main-content">
		        <div class="main-content-inner fixed-page-header fixed-40">
					<div class="page-toolbar align-right">
		                <button type="button" class="btn btn-xs btn-primary btn-xs-ths" id="btnSave">
		                    <i class="ace-icon fa fa-save"></i> 提交
		                </button>
		                <button type="button" class="btn btn-xs btn-danger btn-xs-ths" id="btnReturn" data-self-js="window.parent.closeDialog('dialog-import')">
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
		                        <form class="form-horizontal" id="form1" name="form1" action="${ctx}/eform/formdesign/formdesign_main_importexceltoform.vm" method="post"  enctype="multipart/form-data">
		                        	<input type="hidden" name="formId" value="${formId }"/>
		                        	<input type="hidden" name="isCleanForm" value="true"/>
		                        	<!-- 
		                        	<div class="form-group" style="margin-bottom: 5px;">
		                                <label>
											<input name="isCleanForm" type="checkbox" value="true" class="ace">
											<span class="lbl">是否覆盖（将先清空表单）</span>
										</label>
		                            </div>
		                             -->
		                            <div class="form-group">
		                                <div style="width:98%">
		                             		<label style="width:100%">
		                                     	<input type="file" id="excelfile" name="excelfile" data-validation-engine="validate[required,funcCall[checkExcelFile]]" style="width:100%;height:25px;">
		                              		</label>
		                                </div>
		                            </div>
		                        </form>
		                    </div>
		                </div><!-- /.row -->
		            </div>
		        </div><!--/.main-content-inner-->
		    </div><!-- /.main-content -->
		</div><!-- /.main-container -->
		
		<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
		<script src="${ctx}/assets/js/ace-elements.js"></script>
		<script src="${ctx}/assets/components/jquery/dist/jquery.form.js"></script>
		
		<!-- 自己写的JS，请放在这里 -->
		<script type="text/javascript">
			
			function checkExcelFile(field, rules, i, options){
				if (!field.val().match(/^.*\.xlsx$/)) {
			    	return "必需为xlsx文件";
			  	};
			};
			
			function importFile(){
				$("#form1").ajaxSubmit({
					type: "POST",
					url:"${ctx}/eform/formdesign/formdesign_main_importexceltoform.vm",
				    success: function(response){
				    	if(response.indexOf("success") > -1){
				    		parent.refreshFormHtml();
				    		$("#desgin_center_iframe",parent.document)[0].contentWindow.jdp_eform_selectFormTable();
				    		parent.closeDialog('dialog-import');
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
		
		    jQuery(function ($) {
		    	
		    	$('#excelfile').ace_file_input({
					no_file:'请选择xlsx文件...',
					btn_choose:'选择',
					btn_change:'选择',
					droppable:false,
					onchange:null,
					thumbnail:false //| true | large
					//whitelist:'gif|png|jpg|jpeg'
					//blacklist:'exe|php'
					//onchange:''
					//
				});
		        $("#form1").validationEngine({
		            scrollOffset: 98,//必须设置，因为Toolbar position为Fixed
		            promptPosition: 'bottomLeft',
		            autoHidePrompt: true,
		            validateNonVisibleFields:true
		        });
		        
		        $("#btnSave").on(ace.click_event, function () {
		        	//提交之前验证表单
		    	    if ($('#form1').validationEngine('validate')) {
		    	    	importFile();
		    	    }
		        });
		    });
		</script>
	</body>
</html>

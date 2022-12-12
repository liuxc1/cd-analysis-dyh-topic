<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
	<head>
		<title>转办原因</title>
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
											class="col-xs-12 control-label no-padding-right blue" style="text-align:left;"><i class="ace-icon fa fa-asterisk red smaller-70"></i>转办原因</label>
										<div class="col-xs-12 control-group">
											<textarea class="form-control" id="txtWfComment" data-validation-engine="validate[required,maxSize[160]]"
											placeholder="请输入转办原因，160个字符以内" style="height: 66px;"></textarea>
										</div>
									</div>
									<div class="form-group">
										<label class="col-xs-12 control-label no-padding-right blue" style="text-align:left;"><i class="ace-icon fa fa-asterisk red smaller-70"></i>选择办理人</label>
										<div class="col-xs-12">
											<div class="input-group">
												<input type="hidden" name="assignee" id="assignee" value=""/>
		                                        <input id="assignee_thsname" type="text" class="form-control" name="assignee_thsname" value="" readonly="readonly" data-validation-engine="validate[required]">
		                                        <span class="input-group-btn">
	                                    			<button id="btnChooseManager" type="button" class="btn btn-white btn-grey">
	                                        			<i class="ace-icon fa fa-search"></i>选择
	                                    			</button>
	                                        		<button id="btnChooseManagerX" type="button" class="btn btn-white btn-grey">
	                                            		<i class="ace-icon fa fa-remove"></i>
	                                        		</button>
	                                    		</span>
	                                    	</div>
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
	            $("#btnChooseManager").on(ace.click_event,function(){
	            	parent.jdp_bpm_sentto_selUser("${cansendto}");
	    		});
	    		$("#btnChooseManagerX").on(ace.click_event,function(){
	    			parent.jdp_bpm_sendto_selectUser = {};
	    			$("#assignee").val("");
	    		});
			});
			
			function check(){
				return $('#form1').validationEngine('validate');
			}
		</script>
	</body>
</html>

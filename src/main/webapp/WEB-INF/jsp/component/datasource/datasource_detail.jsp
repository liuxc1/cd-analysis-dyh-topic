<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
	<head>
	    <title>编辑数据源</title>
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
		    	<div class="main-content-inner fixed-page-header fixed-40">
		            <div id="breadcrumbs" class="breadcrumbs">
		                <ul class="breadcrumb">
		                    <li class="active">
		                        <h5 class="page-title" >
		                 			<i class="fa fa-file-text-o"></i>
		                 			数据源管理
		                        </h5>
		                    </li>
		                </ul><!-- /.breadcrumb -->
		            </div>
		        </div>
		        <div class="main-content-inner padding-page-content" style="padding: 52px 12px 0px 12px;">
		            <ul id="myTab" class="nav nav-tabs ">
						<li class="active">
							<a href="#datasourceInfo" data-toggle="tab"> 
								<i class=" ace-icon fa fa-sitemap bigger-120"></i>
								基本信息
							</a>
						</li>
						<li class="">
							<a href="#datasourceParamInfo" data-toggle="tab"> 
								<i class=" ace-icon fa fa-user bigger-120"></i>
								配置参数
							</a>
						</li>
						<li style="float: right; width: 500px; text-align: right; padding-top: 3px;">
							<div>
				                <button type="button" class="btn btn-xs btn-primary btn-xs-ths" id="btnTestConnnection" data-self-js="testConnection()" style="display: none;">
				                    <i class="ace-icon fa fa-save"></i>
									连接测试
				                </button>
				                <button type="button" class="btn btn-xs btn-danger btn-xs-ths" id="btnReturn" data-self-js="goBack()">
				                    <i class="ace-icon fa fa-reply"></i>
									返回
				                </button>
				            </div>
						</li>
					</ul>
					<div class="row">
		            	<div class=" col-xs-12">
		        			<form class="form-horizontal" id="formInfo" action="" method="post">
								<div id="tab-content" class="tab-content">
									<div class="tab-pane in active" id="datasourceInfo">
										<input type="hidden" name="datasourceId" value="${form.datasourceId }">
			                            <div class="form-group">
			                                <label class="col-sm-2 control-label no-padding-right">
			                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
												 数据源CODE
			                                </label>
			                                <div class="col-sm-4">
			                                	<input type="text" class="form-control"
			                                   			name="datasourceCode" value="${form.datasourceCode }"/>
			                                </div>
			                                <label class="col-sm-2 control-label no-padding-right">
			                                    <i class="ace-icon fa fa-asterisk red smaller-70"> </i>
												数据源名称
			                                </label>
			                                <div class="col-sm-4">
			                                	<input type="text" class="form-control"
			                                   			name="datasourceName" value="${form.datasourceName }"/>
			                                </div>
			                            </div>
			                            <div class="form-group">
			                                <label class="col-sm-2 control-label no-padding-right">
			                                    <i class="ace-icon fa fa-asterisk red smaller-70"> </i>
												适配器
			                                </label>
			                                <div class="col-sm-4">
			                                	<div class="input-group">
		                                			<input type="hidden" id="adapterId" name="adapterId" value="${form.adapterId }"> 
					                                <span class="width-100">
					                             		<input type="text" class="form-control" id="adapterName" name="adapterName" value="${form.adapter.adapterName }" 
					                             				readonly="readonly">
					                          		</span>
					                                <span class="input-group-btn">
					                                	<button type="button" class="btn btn-white btn-default" onclick="selectAdapter()">
															选择
												      	</button>    
					                                </span>
				                                 </div>
			                                </div>
			                                <label class="col-sm-2 control-label no-padding-right">
			                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
												 排序
			                                </label>
			                                <div class="col-sm-4">
			                                	<input type="text" class="form-control"
			                                   			name="datasourceOrderBy" value="${form.datasourceOrderBy }"/>
			                                </div>
			                            </div>
			                            <div class="form-group">
			                                <label class="col-sm-2 control-label no-padding-right">
												数据源描述
			                                </label>
			                                <div class="col-sm-10">
			                                    <textarea class="form-control" id="txtarea" placeholder="可拖动的大文本框" name="datasourceDescription"
			                                              style="height: 66px;">${form.datasourceDescription }</textarea>
			                                </div>
			                            </div>
									</div>
									<div class="tab-pane" id="datasourceParamInfo" style="height: 520px; overflow: auto;">
										<table class="table table-bordered table-hover" id="paramTable">
											<thead>
												<tr>
													<th style="width: 20%;">参数CODE</th>
													<th style="width: 50%;">参数名称</th>
													<th style="width: 30%;">参数值</th>
												</tr>
											</thead>
											<tbody id="adapter_div">
												<tr>
													<td colspan="3">请先选择适配器，然后配置参数</td>
												</tr>
											</tbody>
										</table>
									</div>
								</div>
							</form>
						</div>
					</div>
		        </div>
		    </div><!-- /.main-content -->
		</div><!-- /.main-container -->
		
		<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
		
		<!-- 自己写的JS，请放在这里 -->
		<script type="text/javascript">
			//tab高度
			function resizeIframe() {
				$(".tab-pane").height($(window).height() - 108);
			}
			window.onresize = resizeIframe;
			resizeIframe();
		
			//连接测试
			function testConnection(){
				var driverClassObj = $("[param='driverClass']");
				var jdbcUrlObj = $("[param='jdbcUrl']");
				var userObj = $("[param='user']");
				var passwordObj = $("[param='password']");
				if(driverClassObj[0] && jdbcUrlObj[0] && userObj[0] && passwordObj[0] 
						&& !driverClassObj.validationEngine('validate') && !jdbcUrlObj.validationEngine('validate')
						&& !userObj.validationEngine('validate') && !passwordObj.validationEngine('validate')){
					ths.submitFormAjax({
						url : '${ctx}/component/datasource/testConnection.vm',
						data : "adapterId=" + $("#adapterId").val() + "&form['driverClass']=" + driverClassObj.val() + "&form['jdbcUrl']=" + jdbcUrlObj.val() + "&form['user']=" + userObj.val() + "&form['password']=" + passwordObj.val(),
						dataType: "json",
						success : function(response){
							if(response.code == 1){
								dialog({
									title: '提示',
									content: response.msg,
									ok: function () {},
									width: 350
								}).showModal();
							}else{
								dialog({
									title: '错误',
									content: response.msg,
									ok: function () {},
									width: 350
								}).showModal();
							}
						}
					});
				}
			}
			//返回
			function goBack() {
			    $("#main-container",window.parent.document).show();
			    $("#iframeInfo",window.parent.document).attr("src","").hide();
			}
			
			jQuery(function ($) {
			    //编辑操作，初始化数据源适配器参数
			    if("${form.datasourceId }" != ""){
			    	loadAdapterParam("${form.adapterId }");
			    }
				
				//监听tab切换，移除提示
			    $('#myTab a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
			    	//判断显示测试连接按钮
			    	if($(e.target).attr("href") == "#datasourceParamInfo"){
			    		$("#btnTestConnnection").css("display", "");
			    	}else{
			    		$("#btnTestConnnection").css("display", "none");
			    	}
				});
				
			});
	        
	        //加载适配器参数
	        function loadAdapterParam(adapterId){
	        	$("#adapter_div").load("${ctx}/component/datasource/param.vm?datasourceId=${form.datasourceId}&adapterId=" + adapterId, function(){
	        		//只读
				    $(".row").find("select,button,input[type!='text']").prop("disabled",true);
					$(".row").find("input[type='text'],textarea").prop("readonly",true);
					$(".row").find("input[type='text'],textarea").prop("onclick","");
	        	});
	        }
		</script>
	</body>
</html>

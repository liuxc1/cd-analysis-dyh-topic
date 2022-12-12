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
		    	<c:choose>
			    	<c:when test='${"true" != isDialog}'>
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
			        </c:when>
			        <c:otherwise>
			        </c:otherwise>
		        </c:choose>
		        <div class="main-content-inner padding-page-content" style="padding: 52px 12px 0px 12px;">
		            <ul id="myTab" class="nav nav-tabs ">
						<li class="active">
							<a href="#datasourceInfo" data-toggle="tab"> 
								<i class=" ace-icon fa fa-info-circle bigger-120"></i>
								基本信息
							</a>
						</li>
						<li class="">
							<a href="#datasourceParamInfo" data-toggle="tab"> 
								<i class=" ace-icon fa fa-ellipsis-h bigger-120"></i>
								配置参数
							</a>
						</li>
						<li style="float: right; width: 500px; text-align: right; padding-top: 3px;">
							<div>
				                <button type="button" class="btn btn-xs btn-primary btn-xs-ths" id="btnTestConnnection" data-self-js="testConnection()" style="display: none;">
				                    <i class="ace-icon fa fa-save"></i>
									连接测试
				                </button>
				                <button type="button" class="btn btn-xs btn-primary btn-xs-ths" id="btnSave">
				                    <i class="ace-icon fa fa-save"></i>
									 保存
				                </button>
				                <c:if test='${"true" != isDialog}'>
					                <button type="button" class="btn btn-xs btn-danger btn-xs-ths" id="btnReturn" data-self-js="goBack()">
					                    <i class="ace-icon fa fa-reply"></i>
										返回
					                </button>
				                </c:if>
				                <c:if test='${"true" eq isDialog}'>
				                <button type="button" class="btn btn-xs btn-danger btn-xs-ths" data-self-js="javascript:parent.selectDatasource();parent.dialog.get('dialog-datasource-edit').close().remove();">
				                    <i class="ace-icon fa fa-reply"></i>
									返回
				                </button>
				                </c:if>
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
			                                	<input type="text" class="form-control" data-validation-engine="validate[required,custom[onlyFormCode],funcCall[checkDatasourceCode],maxSize[100]]"
			                                   			placeholder="允许字母、数字、下划线，100个字符以内" name="datasourceCode" value="${form.datasourceCode }"/>
			                                </div>
			                                <label class="col-sm-2 control-label no-padding-right">
			                                    <i class="ace-icon fa fa-asterisk red smaller-70"> </i>
												数据源名称
			                                </label>
			                                <div class="col-sm-4">
			                                	<input type="text" class="form-control" data-validation-engine="validate[required,maxLength[200]]"
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
					                             				data-validation-engine="validate[required]" readonly="readonly">
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
			                                	<input type="text" class="form-control" data-validation-engine="validate[required,custom[integer]]"
			                                   			name="datasourceOrderBy" value="${form.datasourceOrderBy }"/>
			                                </div>
			                            </div>
			                            <div class="form-group">
			                                <label class="col-sm-2 control-label no-padding-right">
												数据源描述
			                                </label>
			                                <div class="col-sm-10">
			                                    <textarea class="form-control" id="txtarea" placeholder="可拖动的大文本框" name="datasourceDescription"
			                                              style="height: 66px;" data-validation-engine="validate[maxLength[600]]">${form.datasourceDescription }</textarea>
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
			
            var edited = false;
            // input框,select框,textarea框绑定聚焦和变化事件
            $("form input,form select,form textarea").on("focus change", function (event) {
                // console.log(event.type);// 事件名称
                edited = true;
            });
            window.onbeforeunload = function (e) {
                if (edited) {
                    return (e || window.event).returnValue = '有信息未保存，确认离开？！';
                }
            };

			//检测数据源CODE是否可用
			function checkDatasourceCode(field, rules, i, options){
				if("${form.datasourceCode }" == field.val()){
					return;
				}
				var ajaxResult = true;
				$.ajax({
					url: "${ctx}/component/datasource/checkCode.vm",
					data: "datasourceCode=" + field.val(),
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
					return "此数据源CODE已被使用，请重新命名！";
				}
			}
			//连接测试
			function testConnection(){
				var validateFlag = true;
				var paramJson = {};
				$('#datasourceParamInfo').find("input,textarea,select").each(function(){
					if($(this).attr("data-validation-engine") != null){
						var flag = !$(this).validationEngine('validate');
						//判断是否验证不通过，设置验证标识
						if(flag == false){
							validateFlag = false;
						}
					}
					if($(this).attr("param") != null && $(this).attr("param") != ""){
						var json;
						eval('json = {"form[' + $(this).attr("param") + ']": "' + $(this).val() + '"}');
						$.extend(paramJson, json);
					}
				});
				//校验成功，进行测试
				if(validateFlag){
					paramJson.adapterId = $("#adapterId").val();
					ths.submitFormAjax({
						url : '${ctx}/component/datasource/testConnection.vm',
						data : paramJson,
						dataType: "json",
						success : function(response){
							if(response.code == 1){
								dialog({
									title: '提示',
									content: response.msg,
									ok: function () {}
								}).showModal();
							}else{
								dialog({
									title: '错误',
									content: response.msg,
									ok: function () {},
								}).showModal();
							}
						}
					});
				}
			}
			//返回
			function goBack() {
			    edited = false;
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
                    $("form input,form select,form textarea").blur();
			    	//移除提示
            		$("div.formError").remove();
		            if($('#formInfo').validationEngine('validate')) {
		            	ths.submitFormAjax({
							url : '${ctx}/component/datasource/save.vm',
							data : $("#formInfo").serialize(),
							success : function(response){
							    edited = false;
								if(response == 'success'){
						    		if ('true' != '${isDialog}'){
						    			window.parent.doSearch();
						    		} else {
						    			dialog({
											title: '提示',
											content: '保存成功。',
											ok: function () {
												// ??? 比较奇怪，应该是先关闭dialog，再执行方法，可是js不执行，只能先执行后去掉dialog，就好了
												parent.selectDatasource();
												parent.dialog.get("dialog-datasource-edit").close().remove();
											}
										}).showModal();
						    		}
								} else {
									dialog({
										title: '信息',
										content: response,
										ok: function () {}
									}).showModal();
								}
							}
						});
		            }else{
		            	//需要切换的tab_id
		            	var tab_id = "#" + $($("div.formError")[0]).closest(".tab-pane").attr("id");
		            	//判断tab是否需要切换
		            	if($($("#myTab li.active").children("a")[0]).attr("href") != tab_id){
		            		//切换tab
			            	$("a[href='" + tab_id + "']").click();
		            		//定时显示提示
			            	setTimeout(function(){
			            		$('#formInfo').validationEngine('validate');
			            	},100);
		            	}
		            }
		        });
			    //监听tab切换，移除提示
			    $('#myTab a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
			    	//判断显示测试连接按钮
			    	if($(e.target).attr("href") == "#datasourceParamInfo"){
			    		$("#btnTestConnnection").css("display", "");
			    	}else{
			    		$("#btnTestConnnection").css("display", "none");
			    	}
			    	//移除提示
            		$("div.formError").remove();
				});
			    //编辑操作，初始化数据源适配器参数
			    if("${form.datasourceId }" != ""){
			    	loadAdapterParam("${form.adapterId }");
			    }
			});
			
			/*------------------选择适配器 开始-------------------*/
			function selectAdapter(){
				dialog({
					id:"dialog-adapter",
				        title: '选择',
				        url: '${ctx}/eform/components/table/table_choose.vm?selectType=1&sqlpackage=ths.jdp.component.datasource.mapper.AdapterMapper&mapperid=listDic&closeCallback=closeAdapterDialog&callback=adapterCallback&hiddenId=adapterId&textId=adapterName',
				        width:550,
				        height: 450
				}).showModal();
			}
	        function adapterCallback(table){
				if(table){
					$("#adapterId").val(table.CODE);
					$("#adapterName").val(table.NAME);
					loadAdapterParam(table.CODE);
				}
			}
	        function closeAdapterDialog(){
				dialog.get("dialog-adapter").close().remove();
	        }
	        /*------------------选择适配器 结束-------------------*/
	        
	        //加载适配器参数
	        function loadAdapterParam(adapterId){
	        	$("#adapter_div").load("${ctx}/component/datasource/param.vm?datasourceId=${form.datasourceId}&adapterId=" + adapterId);
	        }
		</script>
	</body>
</html>

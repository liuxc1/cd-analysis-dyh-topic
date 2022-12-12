<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
	<head>
	    <title>数据表导入</title>
		<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
	  	<!--页面自定义的CSS，请放在这里 -->
	    <style type="text/css">
	    	/*遮罩的样式  */
			.ajax_background {
			    background: none repeat scroll 0 0 #1d1d1d;
			    display: none;
			    height: 100%;
			    left: 0;
			    opacity: 0.4;
			    position:fixed;
			    top: 0;
			    width: 100%;
			    z-index: 9999;
			}
			.ajax_background_inner{
			
				display: none;
				width:30%;
				height:25px;
				position:fixed;
				left:45%;
				top:45%;
				z-index: 10000;
			}
			.chosen-single{
				border-radius: 3px !important;
				height: 34px !important;
			}
	    </style>
	</head>
	<body class="no-skin">
		<div class="main-container" id="main-container">
		    <div class="main-content">
		        <div class="main-content-inner fixed-page-header fixed-40">
		            <div class="page-toolbar align-right">
		                <button type="button" class="btn btn-xs btn-success btn-xs-ths" id="btnSubmit"  data-self-js="saveImport()">
		                    <i class="ace-icon fa fa-check"></i>
							提交
		                </button>
		                <button type="button" class="btn btn-xs btn-danger btn-xs-ths" id="btnReturn" data-self-js="window.parent.closeDialog('dialog-import')">
		                    <i class="ace-icon fa fa-reply"></i>
							返回
		                </button>
		                <div class="space-2"></div>
		                <hr class="no-margin">
		            </div>
		        </div>
		        <div class="main-content-inner padding-page-content">
		            <div class="page-content">
		                <div class="row">
		                    <div class="col-xs-12">
		                        <form class="form-horizontal" id="formInfo" action="" method="post">
		                        	<input type="hidden" id="categoryId" value="${form.CATEGORY_ID }"/>
		           					<div class="form-group">
		                                <div class="col-xs-6">
		                                	<select id="paramMap_datasource" class="form-control" name="datasource" onchange="changeDataSource()" > 
												<option value ="">--请选择数据源--</option>
												<c:forEach var="db" items="${dataSourceIdList}">
													<option value="${db}" <c:if test="${table.TABLE_DATASOURCE == db }">selected="selected"</c:if>>${db}</option>
												</c:forEach>	
											</select> 
										</div>
										<div class="col-xs-6">
											<select id="paramMap_schema" name="schema" class="chosen-select form-control" onchange="changeSchema()"
													data-placeholder="--请选择架构--"> 
											</select>
										</div>
		                           	</div>
		                         	<div class="form-group">
			                           	<div class="col-xs-6">
			                             	<input class="form-control" id="tableName" placeholder="需要过滤的表名" onkeyup="queryTable()"/>
			                           	</div>
			                           	<div class="col-xs-6">
											<select id="paramMap_operate" class="form-control" name="type"> 
												<option value ="Ignore">忽略此数据源下已存在的元数据</option>
												<option value ="Update">更新此数据源下已存在的元数据</option>
											</select>
			                           	</div>
			                         </div>
		                          
		                     	 	<div class="form-group">
			                          	<DIV id="" style="HEIGHT: 220px; WIDTH: 100%; OVERFLOW-Y: scroll">
											<TABLE  style="WIDTH: 100%;" class="table table-bordered table-hover">
												<thead>
													<tr>
														<th style="width:25px;text-align:center"><input id="all_select" name="all_table" type="checkbox" onclick="checkAll(this)" value=""/></th>
														<th style="text-align:center">表名</th>
													</tr>
												<thead>
												<tbody id="alltable">
												
												</tbody>
											</TABLE>
										</DIV>
			                      	</div>
		                        </form>
		                    </div>
		                </div><!-- /.row -->
		            </div>
		        </div><!--/.main-content-inner-->
		    </div><!-- /.main-content -->
		    <!-- 遮罩层 -->
		    <div class="ajax_background" id="ajax_mask"></div>
			<div class="ajax_background_inner" id="ajax_mask_inner">
					<image src="${ctx }/assets/blue/css/images/loading.gif"></image><font color="white" size="3">正在导入中</font>
			</div> 
		</div><!-- /.main-container -->
		
		<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
		<script src="${ctx }/assets/js/ace-extra.js"></script>
		<script type="text/javascript" src="${ctx }/assets/components/chosen/chosen.jquery.js"></script>
		
		<!-- 自己写的JS，请放在这里 -->
		<script type="text/javascript">
			//AJAX保存
			function save(){
				//提交之前，将多选人的值写到hidden中
				var ids="",names="";
				$.each(selectUsers,function(i){
					var sp =  i == 0?"":",";
			    	ids = ids + sp + this.loginName;
			    	names = names + sp + this.name;
		        });
				$("#txtDeptManagerId").val(ids);
				$("#txtDeptManager").val(names);
				
				//提交之前验证表单
			    if ($('#formInfo').validationEngine('validate')) {
			        ths.submitFormAjax({
			            url:'save.vm',// any URL you want to submit
			            data:$("#formInfo").serialize()// 如果不需要提交整个表单，可构造JSON提交，如{name:'老王',age:50}
			        	//如需自行处理返回值，请增加以下代码
			        	/*
			        	,success:function (response) {
							
						}
			        	*/
			        });
			    }
			}
			/* //返回
			function goBack() {
			    $("#main-container",window.parent.document).show();
			    $("#iframeInfo",window.parent.document).attr("src","").hide();
			} */
			
			jQuery(function ($) {
			    //日期控件使用示例，详细文档请参考http://www.my97.net/dp/demo/index.htm
			    $("#btnSignDate").on(ace.click_event, function () {
			        WdatePicker({el: 'txtSignDate'});
			    });
			
			    //表单验证组件初始化，详细文档请参考http://code.ciaoca.com/jquery/validation-engine/ 或官网文档http://posabsolute.github.io/jQuery-Validation-Engine/
			    $("#formInfo").validationEngine({
			        scrollOffset: 98,//必须设置，因为Toolbar position为Fixed
			        promptPosition: 'bottomLeft',
			        autoHidePrompt: true
			    });
			    
			    $('#paramMap_schema').chosen();
			    
			    if("${table.TABLE_ID}" != ""){
			    	changeDataSource("${table.TABLE_SCHEMA}");
			    	changeSchema();
			    	$("#tableName").val("${table.TABLE_CODE}");
			    	$("#categoryId").val("${table.CATEGORY_ID}");
			    	queryTable(true);
			    }
			});
			
			function changeDataSource(selectedSchema){
				var _datasource=$("#paramMap_datasource").val();
				$("#alltable").empty();
				$("#tableName").val("");
				$("#paramMap_schema").empty();
				$("#paramMap_schema").append('<option value =""></option>');
				if(_datasource!=""){
					$.ajax({
						type : "POST",
						url : "${ctx}/report/tableManager/findSchemas.vm?datasource="+_datasource,
						async : false,
						success : function(json) {//调用成功的话
							if (json && json.length > 0) {
								var jsonData = JSON.parse(json);
								if(jsonData.operate=='true'){
									var schemas=JSON.parse(jsonData.message);
									for(var i=0;i<schemas.length;i++){
										if(selectedSchema == schemas[i]){
											$("#paramMap_schema").append("<option value='"+schemas[i]+"' selected='selected'>"+schemas[i]+"</option>");
										}else{
											$("#paramMap_schema").append("<option value='"+schemas[i]+"'>"+schemas[i]+"</option>");
										}
									}
									$('#paramMap_schema').trigger("chosen:updated");
								} 
							}
						},
						error:function(xMLHttpRequest){
							var status=xMLHttpRequest.status;
							var message="请求错误";
							switch (status){
								case '404':
									message="未知请求";
								case '500':
									message="运行错误";
							}
							//alert(message);
						}
					});
				}
			}
			
			function changeSchema(){
				var _datasource=$("#paramMap_datasource").val();
				var _schema=$("#paramMap_schema").val();
				$("#alltable").empty();
				$("#tableName").val("");
				if(_schema!=""){
					$.ajax({
						type : "POST",
						url : "${ctx}/report/tableManager/getTableBySchemas.vm",
						async : false,
						data : "datasource="+_datasource+"&schema="+_schema,
						success : function(json) {//调用成功的话
							if (json && json.length > 0) {
								var jsonData = JSON.parse(json);
								if(jsonData.operate=='true'){
									
									var alltable=JSON.parse(jsonData.message);
									var trs="";
									for(var i=0;i<alltable.length;i++){
										trs+='<tr><td width="25px" align="center"><INPUT  type="checkbox" name="all_table" value="'+alltable[i]+'"/></td>'
												+'<td align="center" name="table_name">'+alltable[i]+'</td></tr>';
										
									}
									$("#alltable").append(trs);
								} 
							}
						},
						error:function(xMLHttpRequest){
							var status=xMLHttpRequest.status;
							var message="请求错误";
							switch (status){
								case '404':
									message="未知请求";
								case '500':
									message="运行错误";
							}
							//alert(message);
						}
					});
				}
			}
			
			function checkAll(o){
			    var allCheckBoxs = $("input[name='all_table']");
			    for (var i = 0; i < allCheckBoxs.length; i++) {
			    	allCheckBoxs[i].checked =o.checked;
			    }
			}
			
			function saveImport() {
				//开启遮罩
				var _datasource=$("#paramMap_datasource").val();
		 		var _schema=$("#paramMap_schema").val();
				var tableNames = "";
				$('tr:visible input:checkbox[name=all_table]:checked').each(function(i){
					if(0==i){
						tableNames = $(this).val();
					}else{
						tableNames += (","+$(this).val());
					}
				});
				if(""==tableNames){
					dialog({
						title: '信息',
						content: '请选择要导入的表',
						ok: function () {}
					}).showModal();
					return ;
				}
				$("#ajax_mask").show();
				$("#ajax_mask_inner").show();
				var type=$("#paramMap_operate").val();
				if ($('#formInfo').validationEngine('validate')) {
					$.ajax({
						type : "POST",
						url : "${ctx}/eform/meta/definition/importTables.vm",
						async : true,
						data : "category_id=" + $("#categoryId").val() + "&datasource="+_datasource+"&schema="+_schema+"&type="+type+"&allTable="+tableNames,
						success : function(json) {//调用成功的话
							if (json && json.length > 0) {
								var jsonData = JSON.parse(json);
								//alert(jsonData.message);
								if(jsonData.operate=='true'){
									if(parent&&parent.doSearch){
										parent.doSearch();
									}
		    	            		parent.closeDialog('dialog-import');
		    	            		//关闭遮罩
		    	            		$("#ajax_mask").hide();
		    	            		$("#ajax_mask_inner").hide();
								} 
							}
						},
						error:function(xMLHttpRequest){
							var status=xMLHttpRequest.status;
							var message="请求错误";
							switch (status){
								case '404':
									message="未知请求";
								case '500':
									message="运行错误";
							}
							alert(message);
						}
					});
				} 
			}
			
			
			function queryTable(checked){
				
				var tableName=$("#tableName").val();
				$("td[name='table_name']").each(function(){
					if($(this).text().toUpperCase( ).indexOf(tableName.toUpperCase( ))>-1){
						$(this).closest("tr").show();
						if(checked && $(this).text() == tableName.toUpperCase()){
							$(this).parent().find("[name='all_table']").prop("checked", true);
						}
					}else{
						$(this).closest("tr").find("input[type='checkbox']").removeAttr("checked");
						$(this).closest("tr").hide();
					}
				})
			}
		</script>
	</body>
</html>

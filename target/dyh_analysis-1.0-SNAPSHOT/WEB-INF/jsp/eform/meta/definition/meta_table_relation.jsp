<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
	<head>
		<title>关联关系列表</title>
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
							<div class="col-xs-12">
								<form class="form-horizontal" role="form" id="formList"
									action="#" method="post">
									<div class="col-xs-6" style="padding-top:13px">
										<span style="color:red;font-size:13px">*&nbsp;&nbsp;&nbsp;添加后需要点击保存</span>
									</div>
									<div class="col-xs-6 page-toolbar align-right list-toolbar">
										<button type="button" class="btn btn-xs btn-primary btn-xs-ths" id="btnSave" data-self-js="save()" disabled>
                    						<i class="ace-icon fa fa-save"></i>
                    						保存
               							</button>
										<button type="button" class="btn btn-xs btn-primary btn-xs-ths"
											id="btnAdd" data-self-js="addrelation()">
											<i class="ace-icon fa fa-plus"></i> 添加
										</button>
									</div>									
									<table id="listTable" class="table table-bordered table-hover">	
										<input type="hidden" id="tableId" name="form['TABLE_ID']" value="${form.TABLE_ID}" />
										<input type="hidden" name="form['TABLE_DATASOURCE']" value="${form.TABLE_DATASOURCE }" />
										<input type="hidden" name="form['TABLE_SCHEMA']" value="${form.TABLE_SCHEMA }" />
										<input type="hidden" name="form['TABLE_CODE']" value="${form.TABLE_CODE }" />
										<input type="hidden" id="fileCodes" name="form['FIELD_CODE']" />
										<input type="hidden" id="fileIds" name="form['FIELD_ID']" />
										<input type="hidden" id="rTableIds" name="form['R_TABLE_ID']" />
										<input type="hidden" id="rTableCodes" name="form['R_TABLE_CODE']" />
										<input type="hidden" id="rFieldCodes" name="form['R_FIELD_CODE']" />
										<input type="hidden" id="rFieldIds" name="form['R_FIELD_ID']" />
										<thead>
											<tr>
												<th  data-sort-col="TABLE_CODE">
													<i class="ace-icon fa "></i>
													当前表字段
												</th>
												<th  data-sort-col="TABLE_NAME">
													<i class="ace-icon fa "></i>
													关联主表 
												</th>
												<th  data-sort-col="TABLE_DATASOURCE" >
													<i class="ace-icon fa "></i>
													关联主表字段
												</th>
												<th class="align-center " style="width: 150px">
													<i class="ace-icon fa fa-wrench"></i> 
													操作
												</th>
											</tr>
										</thead>
										<tbody id="gridView1">
											<!--以下 用于新增行复制  -->
											<tr style="display:none;">
												<td width="25%">
													<select class="form-control"  name="field" onchange="changeField(this)" data-validation-engine="validate[required]">
                                       					<option value="" >--请选择--</option>
                                       					<c:forEach items="${form.fieldList }" var="field" >
                                       						<option  value="${field.FIELD_ID }" >${field.FIELD_CODE }</option>
                                       					</c:forEach>
                                   					</select>
												</td>
												<td width="25%">
													<select class="form-control"  name="rTable" onchange="changeRTable(this)" data-validation-engine="validate[required]">
                                       					<option value=""  selected>--请选择--</option>
                                       					<c:forEach items="${form.tableList }" var="table" >
                                       						<c:if test="${table.TABLE_CODE!=form.TABLE_CODE }">
                                       							<option value="${table.TABLE_ID }">${table.TABLE_CODE }</option>
                                       						</c:if>
                                       					</c:forEach>
                                   					</select>
												</td>
												<td width="25%">
													<select class="form-control"  name="rField" onchange="changeRField()" data-validation-engine="validate[required]">
                                       		·			<option value="" selected>--请选择--</option>
                                   					</select>
												</td>
												<td class="align-center col-op-ths">
													<button type="button"
														class="btn btn-sm btn-grey btn-white btn-op-ths"
														title="删除" onclick="deleteRelation(this)" style="margin-top:6px">
														<i class="ace-icon fa fa-trash"></i>
													</button>
												</td>
											</tr>
											<!--以上 用于新增行复制  -->
											<c:forEach items="${form.relationList }" var="relation">
												<tr >
													<td width="25%">
														<select class="form-control"  name="field" onchange="changeField(this)" data-validation-engine="validate[required]">
	                                       					<option value="">--请选择--</option>
	                                       					<c:forEach items="${form.fieldList }" var="field" >
	                                       						<option value="${field.FIELD_ID }" <c:if test="${relation.FIELD_ID==field.FIELD_ID }">selected</c:if>>${field.FIELD_CODE }</option>
	                                       					</c:forEach>
	                                   					</select>
													</td>
													<td width="25%">
														<select class="form-control"  name="rTable" onchange="changeRTable(this)" data-validation-engine="validate[required]">										
	                                       					<option  value="" selected>--请选择--</option>
	                                       					<c:forEach items="${form.tableList }" var="table" >
	                                       						<c:if test="${table.TABLE_CODE!=form.TABLE_CODE }">
	                                       							<option value="${table.TABLE_ID }" <c:if test="${relation.R_TABLE_ID == table.TABLE_ID }">selected</c:if>>${table.TABLE_CODE }</option>
	                                       						</c:if>
	                                       					</c:forEach>
	                                   					</select>
													</td>
													<td width="25%">
														<select class="form-control"  name="rField" onchange="changeRField()" data-validation-engine="validate[required]">
	                                       		·			<option value="" >--请选择--</option>
	                                       					<c:forEach items="${relation.rFiledList}" var="rField">
	                                       						<c:if test="${rField.FIELD_ISPRIMARY=='true' }" >
	                                       							<option value="${rField.FIELD_ID}" <c:if test="${relation.R_FIELD_ID == rField.FIELD_ID }">selected</c:if>>${rField.FIELD_CODE }</option>
	                                       						</c:if>
	                                       					</c:forEach>
	                                   					</select>
													</td>
													<td class="align-center col-op-ths">
														<button type="button" 
															class="btn btn-sm btn-grey btn-white btn-op-ths"
															title="删除" onclick="deleteRelation(this)" >
															<i class="ace-icon fa fa-trash"></i>
														</button>
													</td>
												</tr>	
											</c:forEach>
										</tbody>
									</table>
								</form>
							</div>
						</div>
					</div>
				</div>
				<!--/.main-content-inner-->
			</div>
			<!-- /.main-content -->
		</div>
		<!-- /.main-container -->
	
		<iframe id="iframeInfo" name="iframeInfo" class="frmContent" src=""
			style="border: none; display: none" frameborder="0" width="100%"></iframe>
	
		<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
	
		<!-- 自己写的JS，请放在这里 -->
		<script type="text/javascript">
			
			//保存
			function save()
			{
				if($("#gridView1").find("tr:gt(0)").length>0){
					if(!$('#formList').validationEngine('validate')) {
						return;
					}
				}
				var _fieldCodes="";
				var _fieldIds="";
				var _rTableIds="";
				var _rTableCodes="";
				var _rFieldCodes="";
				var _rFieldIds="";
				$("#gridView1 tr:gt(0)").each(function(index){
					var _fieldSelect=$(this).find("select[name=field]");
					var _rTableSelect=$(this).find("select[name=rTable]");
					var _rFieldSelect=$(this).find("select[name=rField]");
					var sp =  index == 0?"":",";
					_fieldIds = _fieldIds + sp + _fieldSelect.val();
					_fieldCodes = _fieldCodes + sp + _fieldSelect.find("option:selected").text();
					_rTableIds = _rTableIds + sp + _rTableSelect.val();
					_rTableCodes = _rTableCodes + sp + _rTableSelect.find("option:selected").text();
					_rFieldIds = _rFieldIds + sp + _rFieldSelect.val();
					_rFieldCodes = _rFieldCodes + sp + _rFieldSelect.find("option:selected").text();
				});
				$("#fileCodes").val(_fieldCodes);
				$("#fileIds").val(_fieldIds);
				$("#rTableIds").val(_rTableIds);
				$("#rTableCodes").val(_rTableCodes);
				$("#rFieldCodes").val(_rFieldCodes);
				$("#rFieldIds").val(_rFieldIds);
				//提交之前验证表单
		        ths.submitFormAjax({
		            url:'saveRelation.vm',// any URL you want to submit
		            data:$("#formList").serialize()
		        	//如需自行处理返回值，请增加以下代码
		        	,success:function (response) {
		        		if(response=="success")
		        		{
		        			dialog({
		    		            title: '提示',
		    		            content: '保存成功',
		    		            wraperstyle:'alert-info',
		    		            ok: function () {}
		    		        }).showModal();
		        			$("#btnSave").attr("disabled",true);
		        		}
					}
		        });
			}
			
			
			var relation_number=0;
			function addrelation(){
				var flag='<c:if test="${(form.fieldList)!= null && fn:length(form.fieldList) > 0}">true</c:if>';
				if(flag!="true"){
					dialog({
    		            title: '提示',
    		            content: '该数据表无可用字段，无法添加关联关系！',
    		            wraperstyle:'alert-info',
    		            ok: function () {}
    		        }).showModal();
					return;
				}
				$("#btnSave").attr("disabled",false);
		 		var _tr=$($("#gridView1 tr")[0]).clone();
		 		_tr.find("input[name=isModified]").val("1");
		 		_tr.show();
		 		$("#gridView1").append(_tr);
			}
			
		 	function deleteRelation(objTr){
				$(objTr).parent().parent().remove();
				$("#btnSave").attr("disabled",false);		
			}
			
		 	function changeField(objField)
		 	{
		 		$("#btnSave").attr("disabled",false);
		 		$(objField).parent().next().find("option:first").prop("selected","selected");
		 		$(objField).parent().next().next().find("select").empty();
		 		$(objField).parent().next().next().find("select").append("<option value=\"\">--请选择--</option>");
		 	}
			function changeRTable(objRTable)
			{
				var nextSelect=$(objRTable).parent().next().find("select");
				nextSelect.empty();
				nextSelect.append('<option value="">--请选择--</option>');
				var _rTableId=$(objRTable).find("option:selected").val();
				var _tableId=$("#tableId").val();
				var _result=true;
				$.ajax({
					url:"${ctx}/eform/meta/definition/checkCirculeRefer.vm",
					data:{tableId:_tableId,rTableId:_rTableId},
					dataType:"text",
					async:false,
					type:"post",
					success:function(response){
						if(response=="failure"){
							_result=false;
						}
					}
				})
				if(_result==false){
					dialog({
    		            title: '提示',
    		            content: '选择该表后将会出现循环引用，请检查关联关系！',
    		            wraperstyle:'alert-info',
    		            ok: function () {}
    		        }).showModal();
					return;
				}
				$("#btnSave").attr("disabled",false);
				$(objRTable).parent().parent().children("input[name='isModified']").val("1");
				var _tableId=$(objRTable).val();
				$.ajax({
				type : "POST",
				url : "${ctx}/eform/meta/definition/fieldListJson.vm?TABLE_ID="+_tableId,
				async : false,
				dataType:"json",
				success : function(data) {//调用成功的话
					for(var i=0;i<data.length;i++){
						if(data[i].FIELD_ISPRIMARY=='true'){
							nextSelect.append("<option value='"+data[i].FIELD_ID+"'>"+data[i].FIELD_CODE+"</option>");
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
			
			function changeRField()
			{
				$("#btnSave").attr("disabled",false);
			}
			
			jQuery(function($){
				//初始化表格的事件，如表头排序，列操作等
				__doInitTableEvent("listTable");
				
				if($("#gridView1 tr:gt(0)").length==0){
					$("#btnSave").attr("disabled",true); 
				}
				
				$("#formList").validationEngine({
					scrollOffset : 98,//必须设置，因为Toolbar position为Fixed
					promptPosition : 'bottomLeft',
					autoHidePrompt : true
				});
			});
		</script>
	</body>
</html>

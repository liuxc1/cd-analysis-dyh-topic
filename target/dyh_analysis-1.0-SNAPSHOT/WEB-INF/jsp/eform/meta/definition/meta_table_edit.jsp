<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
<head>
    <title>数据表编辑页面</title>
	<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
  	<!--页面自定义的CSS，请放在这里 -->
    <style type="text/css">
    </style>
</head>

<body class="no-skin">

<div class="main-container" id="main-container">
    <div class="main-content">
        <div class="main-content-inner padding-page-content">
                <div style="padding-top: 5px">
                        <div class="col-xs-12 tabable">
                           <ul id="myTab" class="nav nav-tabs ">
                                <li  class="active">
                                    <a href="#common" onclick="diagramFresh()" data-toggle="tab">
                                        <i class=" ace-icon fa fa-sliders bigger-120"></i>
                                     	基本属性
                                    </a>
                                </li>
                                <li >
                                    <a href="#field" data-toggle="tab">
                                        <i class=" ace-icon fa fa-file-text-o bigger-120"></i>
                                     	   字段
                                        <!--
                                        <span class="badge badge-warning line-height-1">19</span>
                                        -->
                                    </a>
                                </li>
                                <li >
                                    <a href="#relation" data-toggle="tab">
                                        <i class=" ace-icon fa fa-file-text-o bigger-120"></i>
                                     	   关联关系
                                        <!--
                                        <span class="badge badge-warning line-height-1">19</span>
                                        -->
                                    </a>
                                </li>
                                
                            </ul>

                            <div id="tab-content" class="tab-content" >
                                <div class="tab-pane  in active" id="common">
                                	<form class="form-horizontal" role="form" id="formCommon" action="" method="post" style="height:400px">
			                            <!-- ID隐藏域 -->
			               				<input type="hidden" name="form['TABLE_ID']" value="${form.tableInfo.TABLE_ID }"/>
			                            <div class="form-group">
			                                <label class="col-sm-2 control-label no-padding-right">
			                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
			                                 	数据库表名：
			                                </label>
			                                <div class="col-sm-4">
		                                        <input type="text" class="form-control"   name="form['TABLE_CODE']"
		                                        placeholder="允许字母、数字、下划线"  readonly
		                                        value="${form.tableInfo.TABLE_CODE}" data-validation-engine="validate[required,custom[onlyFormCode],maxSize[30]]" />
			                                </div>
			                                </div>
			                               <div class="form-group"> 
			                                <label class="col-sm-2 control-label no-padding-right">
			                                    <i class="ace-icon fa fa-asterisk red smaller-70"> </i>
			                                   	别名：
			                                </label>
			                                <div class="col-sm-4">
		                                        <input type="text" class="form-control"  
		                                       	data-validation-engine="validate[required,maxLength[100]]" name="form['TABLE_NAME']" value="${form.tableInfo.TABLE_NAME }" />
			                                </div>
			                            </div>			                               
			                            <div class="form-group">
			                                <label class="col-sm-2 control-label no-padding-right">
			                                	<i class="ace-icon fa fa-asterisk red smaller-70"> </i>
			                                	数据源：</label>
			                                <div class="col-sm-4">
			                                   <select class="form-control" id="tableDataSource" name="form['TABLE_DATASOURCE']" onchange="changeDataSource()" data-validation-engine="validate[required]">
			                                       <option value="">---请选择---</option>
			                                       <c:forEach items="${form.dataSourceIdList}" var="dataSourceId">
			                                       		<option value="${dataSourceId }" <c:if test="${form.tableInfo.TABLE_DATASOURCE==dataSourceId }">selected</c:if>>${dataSourceId }</option>
			                                       </c:forEach>
			                                   </select>
			                                </div>
			                            </div>
			                            <div class="form-group"> 
			                                <label class="col-sm-2 control-label no-padding-right">
				                                <i class="ace-icon fa fa-asterisk red smaller-70"> </i>
				                               	Schema：
			                               	</label>
			                                <div class="col-sm-4">
			                                   <select class="form-control" id="tableSchema" name="form['TABLE_SCHEMA']"  data-validation-engine="validate[required]">
			                                       <option value="">---请选择---</option>
			                                       <c:forEach items="${form.schemaList }" var="schema">
			                                       		<option value="${schema}" <c:if test="${form.tableInfo.TABLE_SCHEMA==schema}">selected</c:if>>${schema}</option>
			                                   		</c:forEach>
			                                   </select>
			                                </div>
			                            </div>
			                            <div class="form-group" >
			                                <label class="col-sm-2 control-label no-padding-right">
			                                 	                    描述：
			                                </label>
			                                <div class="col-sm-8">
			                                    <textarea rows="" cols="" name="form['TABLE_DESCRIPTION']" style="width:100%;height:50px;resize: vertical;"
			                                    	data-validation-engine="validate[maxSize[150]]">${form.tableInfo.TABLE_DESCRIPTION }</textarea>
			                                </div>
			                                <div class="col-sm-2">
			                                    
			                                </div>
			
			                            </div>
			                            <div class="form-group" >
				                            <label class="col-sm-2 control-label no-padding-right">
												 所属分类名称
											</label>
											<div class="col-sm-4">
												<input type="hidden" name="form['CATEGORY_ID']" id="categoryId" value="${form.tableInfo.CATEGORY_ID}"/>
												<input type="text"
													class="form-control"
													id="categoryName"
													readonly="readonly"
													data-validation-engine="validate[required]"
													value="${form.tableInfo.CATEGORY_NAME}" onclick="showCategorySelect()"/>
											</div>
										</div>
			                            <div class="form-group"> 
			                            	 <div class="col-sm-2">
			                                    
			                                </div>
			                                 <div class="col-sm-2">
			                                    <button type="button" class="btn btn-xs btn-primary btn-xs-ths"
													id="btnSave" data-self-js="save()">
													<i class="ace-icon fa fa-save"></i> 保存本页
												</button>
			                                </div>
										</div>
			                        </form>
                                </div>
                                <div class="tab-pane" id="field">
                                	<iframe id="ifrmfield" name="ifrmfield" class="frmContent" style="border: none" height="400px" frameborder="0" width="100%"
                                	src="${ctx}/eform/meta/definition/meta_field_list.vm?form%5BTABLE_ID%5D=${form.tableInfo.TABLE_ID}"></iframe>
                            	</div>
                                <div class="tab-pane" id="relation">
                                	<iframe id="ifrmrelation" class="frmContent" style="border: none" height="400px" frameborder="0" width="100%"
                                	src="${ctx}/eform/meta/definition/meta_relation_list.vm?form%5BTABLE_ID%5D=${form.tableInfo.TABLE_ID}&tableCode=${form.tableInfo.TABLE_CODE }&loginName=<%=request.getAttribute("loginName") == null || ths.jdp.core.web.LoginCache.isSuperAdmin(request.getAttribute("loginName").toString()) ? "" : request.getAttribute("loginName").toString() %>"></iframe>
                            	</div>
                            </div>
                        </div>
                </div>
        </div><!--/.main-content-inner-->
    </div><!-- /.main-content -->
</div><!-- /.main-container -->

<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>

<script type="text/javascript">


function save(){
	
	//提交之前验证表单
    if ($('#formCommon').validationEngine('validate')) {
        ths.submitFormAjax({
            url:'saveTable.vm',// any URL you want to submit
            data:$("#formCommon").serialize()// 如果不需要提交整个表单，可构造JSON提交，如{name:'老王',age:50}
        	//如需自行处理返回值，请增加以下代码
        	,dataType:"json",
        	success:function (data) {
        		if(data.flag=="success")
        		{
        			dialog({
    		            title: '提示',
    		            content: '保存成功',
    		            wraperstyle:'alert-info',
    		            ok: function () {
    		            	$("#ifrmfield").attr("src", ths.urlEncode4Get("${ctx}/eform/meta/definition/meta_field_list.vm?form[TABLE_ID]="+data.TABLE_ID));
    		            }
    		        }).showModal();
        		}
			}
        });
    	}
	}
	function changeDataSource(){
		var _datasource=$("#tableDataSource").val();
		$("#tableSchema").empty();
		$("#tableSchema").append('<option value ="">---请选择---</option>');
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
							$("#tableSchema").empty();
							$("#tableSchema").append('<option value ="">---请选择---</option>');
							for(var i=0;i<schemas.length;i++){
								$("#tableSchema").append("<option value='"+schemas[i]+"'>"+schemas[i]+"</option>");
							}
						}
					}
				}
				});
		}
	}
	
	var jdpAppCode = "<%=ths.jdp.core.context.PropertyConfigure.getProperty("jdp.app.code").toString()%>";
	//选择流程分类
	function showCategorySelect(){
		dialog({
			id:"dialog-category-select",
	        title: '选择',
	        url: '${ctx}/eform/tree/window.vm?sqlpackage=ths.jdp.eform.mapper.settings.category.CategoryMapper&mapperid=tree&callback=diaCatSelCallback&loginName=<%=request.getAttribute("loginName") == null || ths.jdp.core.web.LoginCache.isSuperAdmin(request.getAttribute("loginName").toString()) ? "" : request.getAttribute("loginName").toString() %>'
	        		+ '&jdpAppCode=' + jdpAppCode + '&categoryTypeId=EFORM_META',
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
	
	jQuery(function ($) {
		
		$.validationEngineLanguage.allRules.onlyFormCode= {
				 "regex": /^[0-9a-zA-Z\_]+$/,
                "alertText": "* 只接受字母、数字、下划线"
	 	};

		$("#formCommon").validationEngine({
			scrollOffset : 98,//必须设置，因为Toolbar position为Fixed
			promptPosition : 'bottomLeft',
			autoHidePrompt : true
		});
	});
	
	
</script>
</body>
</html>

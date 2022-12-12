<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
<head>
    <title>字段编辑页面</title>
	<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
  	<!--页面自定义的CSS，请放在这里 -->
    <style type="text/css">
    	.form-field-native{
   			margin-bottom: 12px;
    	}
    </style>
</head>

<body class="no-skin">

<div class="main-container" id="main-container">
    <div class="main-content">
        <div class="main-content-inner padding-page-content">
           <div class="main-content-inner fixed-page-header fixed-40">
            <div class="page-toolbar align-right">
                <button type="button" class="btn btn-xs btn-primary btn-xs-ths" id="btnSave" data-self-js="save()">
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
            <div class="main-content-inner padding-page-content">
            <div class="page-content">
                <div class="space-4"></div>
                
                <div class="row">
                    <div class=" col-xs-12">
                        <form class="form-horizontal" role="form" id="formField" action="" method="post">
                            <!-- ID隐藏域 -->
               				<input type="hidden" name="form['FIELD_ID']" value="${fieldInfo.FIELD_ID}"/>
               				<input type="hidden" name="form['TABLE_ID']" value="${tableId}"/>
                            <div class="form-group">
                                <label class="col-xs-2 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                 	字段编码：
                                </label>
                                <div class="col-xs-4">
                                     <input type="text" class="form-control"  name="form['FIELD_CODE']" 
                                      placeholder="允许字母、数字、下划线"  
                                     value="${fieldInfo.FIELD_CODE }" data-validation-engine="validate[required,maxSize[30],custom[onlyFormCode]]"
                                     <c:if test="${not empty fieldInfo.FIELD_CODE}">readonly</c:if>/>
                                </div>
                                <label class="col-xs-2 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"> </i>
                                   	 别名：
                                </label>
                                <div class="col-xs-4">
                                    <input type="text" class="form-control"   
                                   	data-validation-engine="validate[required,maxSize[12]]" name="form['FIELD_NAME']" value="${fieldInfo.FIELD_NAME}" />
                                </div>
                            </div>                        
                            <div class="form-group">
                                <label class="col-xs-2 control-label no-padding-right">
                                	<i class="ace-icon fa fa-asterisk red smaller-70"> </i>
                               		 数据类型：
                               	</label>
                                <div class="col-xs-4">
                                    <input type="text" class="form-control"
                                           data-validation-engine="validate[required,maxSize[12]]" 
                                           id="txtDateStart" name="form['FIELD_DATATYPE']" value="${fieldInfo.FIELD_DATATYPE}"/>
                                </div>
                                <label class="col-xs-2 control-label no-padding-right">
	                                <i class="ace-icon fa smaller-70"> </i>
	                               	长度：
                               	</label>
                                <div class="col-xs-4">
                                    <input type="text" class="form-control" placeholder=""
                                           id="txtDateEnd"  name="form['FIELD_LENGTH']" readonly value="${fieldInfo.FIELD_LENGTH}"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-xs-2 control-label no-padding-right">
                                	<i class="ace-icon fa fa-asterisk red smaller-70"> </i>
                               		 是否主键：
                                </label>
                                <div class="col-xs-4">
									<div class="radio">
										<label>
											<input name="form['FIELD_ISPRIMARY']" type="radio" class="ace" value="true" <c:if test="${fieldInfo.FIELD_ISPRIMARY=='true' }">checked</c:if>
											onclick="checkPrimaryKey(this)"/>
											<span class="lbl">是</span>
										</label>
										<label>
											<input name="form['FIELD_ISPRIMARY']" type="radio" class="ace" value="false" <c:if test="${fieldInfo.FIELD_ISPRIMARY!='true' }">checked</c:if>/>
											<span class="lbl">否</span>
										</label>
									</div>
                                </div>
                                <label class="col-xs-2 control-label no-padding-right">
                                	<i class="ace-icon fa fa-asterisk red smaller-70"> </i>
                                	精度：
                                </label>
                                <div class="col-xs-4">
									<input type="text" class="form-control"
                                           data-validation-engine="validate[required,custom[integer]]" placeholder=""
                                           id="txtDateEnd"  name="form['FIELD_PRECISION']" value="${fieldInfo.FIELD_PRECISION == null ? 0 : fieldInfo.FIELD_PRECISION }"/>
                                </div>
                            </div>
                           <div class="form-group" >
	                      		<label class="col-xs-2 control-label no-padding-right">
	                      			<i class="ace-icon fa fa-asterisk red smaller-70"> </i>
	                      			允许空：
	                      		</label>
	                            <div class="col-xs-4">
									<div class="radio">
										<label>
											<input name="form['FIELD_ISNULL']" type="radio" class="ace" value="true" <c:if test="${fieldInfo.FIELD_ISNULL!='false' }">checked</c:if>/>
											<span class="lbl">是</span>
										</label>
										<label>
											<input name="form['FIELD_ISNULL']" type="radio" class="ace" value="false" <c:if test="${fieldInfo.FIELD_ISNULL=='false' }">checked</c:if>/>
											<span class="lbl">否</span>
										</label>
									</div>
	                           </div>
                           </div>
                            <hr class="no-margin" style="height:1px;border:none;border-top:1px dashed #0066CC;">
                            <br/>
                          <div class="row">
                            <div class="col-xs-6 form-field-native">
                                <label class="col-xs-4 control-label no-padding-right">
	                                <i class="ace-icon fa   smaller-70"> </i>
	                               	字典：
                               	</label>
                                <div class="col-xs-8">
                                    <div class="input-group">
                                        <input type="hidden" class="form-control"  id="fieldDictionaryCode" name="form['FIELD_DICTIONARY']" 
                                        value="${fieldInfo.FIELD_DICTIONARY}" />
                                        <input type="text" class="form-control" readonly="readonly" id="fieldDictionaryName"  
                                        value="${fieldInfo.TREE_NAME}" />
                                        <span class="input-group-btn">
                                        <button type="button" class="btn btn-white btn-grey" id="btnChooseDictionary" onclick="openDictionary()">
                                            <i class="ace-icon fa fa-search"></i>
                                        </button>
                                         <button type="button" class="btn btn-white btn-default" data-self-js="clearValue(this)">
				                            <i class="ace-icon fa fa-remove"></i>
				                        </button>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xs-6 form-field-native">
                                <label class="col-xs-4 control-label no-padding-right">
                                	<i class="ace-icon fa   smaller-70"> </i>
                               		 控件类型：
                               	</label>
                                <div class="col-xs-8">
                                   <select class="form-control" name="form[FIELD_INPUTTYPE]" onchange="changeInputType(this)">
                                       <option  value="">--请选择--</option>
                                       <c:forEach var="formcell_type_native" items="${dictionarys_map.FORMCELL_TYPE_NATIVE}"  varStatus="status">
											<option value="${formcell_type_native.dictionary_code}"  
											        title="${formcell_type_native.dictionary_name}"
											 	    <c:if test="${formcell_type_native.dictionary_code==fieldInfo.FIELD_INPUTTYPE}">selected="selected"</c:if>>
												    ${formcell_type_native.dictionary_name}
											</option>
									   </c:forEach>	
									   <c:forEach var="formcell_type_extend" items="${dictionarys_map.FORMCELL_TYPE_EXTEND}"  varStatus="status">
											<option value="${formcell_type_extend.dictionary_code}"  
											        title="${formcell_type_extend.dictionary_name}"
											 	    <c:if test="${formcell_type_extend.dictionary_code==fieldInfo.FIELD_INPUTTYPE}">selected="selected"</c:if>>
												    ${formcell_type_extend.dictionary_name}
											</option>
									   </c:forEach>	
                                   </select>
                                </div>
                            </div>
                             <div id="fieldDateType" class="col-xs-6 form-field-native" <c:if test="${empty fieldInfo.FIELD_DATETYPE}">style="display:none"</c:if>>
                             	<label class="col-xs-4 control-label no-padding-right">
                               <i class="ace-icon fa  smaller-70"> </i>
                              	时间格式：
                             	</label>
                              <div class="col-xs-8">
                                 <select class="form-control" id="dateType"  name="form['FIELD_DATETYPE']" onchange="">
                                     <c:forEach var="formcell_datetype" items="${dictionarys_map.FORMCELL_DATETYPE}"  varStatus="status">
										<option value="${formcell_datetype.dictionary_code}"  
										        title="${formcell_datetype.dictionary_name}"
										 	    <c:if test="${formcell_datetype.dictionary_code==fieldInfo.FIELD_DATETYPE}">selected="selected"</c:if>>
											    ${formcell_datetype.dictionary_name}
										</option>
							   		</c:forEach>
                                 </select>
                              </div>
                             </div>
                             </div>    
                        </form>
                    </div>
                </div><!-- /.row -->
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
	    if ($('#formField').validationEngine('validate')) {
				ths.submitFormAjax({
		            url:'saveField.vm',// any URL you want to submit
		            data:$("#formField").serialize()// 如果不需要提交整个表单，可构造JSON提交，如{name:'老王',age:50}
		        	//如需自行处理返回值，请增加以下代码
		        	,success:function (response) {
		        		if(response=="success"){
		        			$(window.parent.frames["dialog-eform-table-edit"].document).find("#ifrmfield")[0].contentWindow.doSearch();
		        			$(window.parent.frames["dialog-eform-table-edit"].document).find("#ifrmrelation").attr("src", ths.urlEncode4Get("${ctx}/eform/meta/definition/meta_relation_list.vm?form[TABLE_ID]=${tableId}"));
			            	goBack();
		        		}else{
		        			dialog({
					            title: '提示',
					            content: '修改失败',
					            wraperstyle:'alert-info',
					            ok: function () {},

					        }).showModal();
		        		}
					}
			});
		} 
	}
	//返回
	function goBack() {
		window.parent.dialog.get("dialog-eform-field-edit").close().remove();
	}	
	
	function loadSubList(procInstId, executionId){
		$("#records").load("${ctx }/bpm/monitor/history.vm?procInstId=" + procInstId + "&executionId=" + executionId+"&_t=" + new Date().getTime());
	}
	
	function changeInputType(objInput)
	{
		if($(objInput).val()=="DATE"){
			$("#fieldDateType").css("display","block");
			$("#dateType option:first").prop("selected",true);
		}
		else{
			$("#fieldDateType").css("display","none");
			$("#dateType").val("");
		} 
	}
	var treeDialog;
	//字典选择
	function openDictionary(){
		  treeDialog=dialog({
				id:"dialog-meta-dictionary",
		        title: "选择字典",
		        url: "${ctx}/eform/tree/window.vm?sqlpackage=ths.jdp.eform.service.formdesign.designmapper&mapperid=selectDictionary&callback=dictionaryCallBack&jdpAppCode=<%=ths.jdp.core.context.PropertyConfigure.getProperty("jdp.app.code").toString()%>",
		        width:380,
		        height:350>document.documentElement.clientHeight?document.documentElement.clientHeight:350
		    }).showModal();
	}
	//字典选择回调
	function dictionaryCallBack(tree){
		treeDialog.close().remove();
		$("#fieldDictionaryCode").val(tree.TREE_CODE);
		$("#fieldDictionaryName").val(tree.TREE_NAME);
	}
	//清空值方法
	function clearValue(obj){
		$(obj).closest("div.input-group").find("input").each(function(){
			$(this).val("");
		});
	}
	//检查主键数量
	function checkPrimaryKey(obj){
		var _tableId="${tableId}";
		$.ajax({
			url:"${ctx}/eform/meta/definition/getPrimaryKeyNum.vm?TABLE_ID="+_tableId,
			dataType:"text",
			cache:false,
			success:function(response){
				var num=parseInt(response)
				if(num>=1){
					dialog({
		                title: '提示',
		                content: '元数据只能设置一个主键',
		                wraperstyle:'alert-info',
		                ok: function () {}
		            }).showModal();
					$(obj).closest("label").next().find("input[type='radio']").prop("checked",true);
				}
			}
		}) 
	}
	
	jQuery(function ($) {
		
		$.validationEngineLanguage.allRules.onlyFormCode= {
				 "regex": /^[0-9a-zA-Z\_]+$/,
               "alertText": "* 只接受字母、数字、下划线"
	 	};
		$("#formField").validationEngine({
			scrollOffset : 98,//必须设置，因为Toolbar position为Fixed
			promptPosition : 'bottomLeft',
			autoHidePrompt : true
		});
	});
</script>
</body>
</html>

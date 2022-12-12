<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
	<head>
	    <title>控件属性</title>
		<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
		<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
		<script src="${ctx}/assets/components/chosen/chosen.jquery.js?v=20221129015223"></script>
		<!-- codemirror core css and js -->
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/lib/codemirror.css?v=20221129015223">
		<script src="${ctx }/assets/components/codemirror/lib/codemirror.js?v=20221129015223"></script>
		<!-- codemirror fullscreen css and js -->
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/addon/display/fullscreen.css?v=20221129015223">
		<script src="${ctx }/assets/components/codemirror/addon/display/fullscreen.js?v=20221129015223"></script>
		<!-- codemirror hint css and js -->
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/addon/hint/show-hint.css?v=20221129015223" />
		<script src="${ctx }/assets/components/codemirror/addon/hint/show-hint.js?v=20221129015223"></script>
		<script src="${ctx }/assets/components/codemirror/addon/hint/html-hint.js?v=20221129015223"></script>
		<!-- codemirror fold css and js -->
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/addon/fold/foldgutter.css?v=20221129015223" />
		<script src="${ctx }/assets/components/codemirror/addon/fold/foldcode.js?v=20221129015223"></script>
  		<script src="${ctx }/assets/components/codemirror/addon/fold/foldgutter.js?v=20221129015223"></script>
  		<script src="${ctx }/assets/components/codemirror/addon/fold/brace-fold.js?v=20221129015223"></script>
  		<script src="${ctx }/assets/components/codemirror/addon/fold/xml-fold.js?v=20221129015223"></script>
  		<script src="${ctx }/assets/components/codemirror/addon/fold/comment-fold.js?v=20221129015223"></script>
		<!-- codemirror language css and js -->
		<script src="${ctx }/assets/components/codemirror/mode/xml/xml.js?v=20221129015223"></script>
		<script src="${ctx }/assets/components/codemirror/mode/htmlmixed/htmlmixed.js?v=20221129015223"></script>
		<!-- codemirror autorefresh css and js -->
		<script src="${ctx }/assets/components/codemirror/addon/display/autorefresh.js?v=20221129015223"></script>
		<!-- codemirror placeholder js -->
		<script src="${ctx }/assets/components/codemirror/addon/display/placeholder.js?v=20221129015223"></script>
	  	<!--页面自定义的CSS，请放在这里 -->
	    <style type="text/css">
			td{
				height: 20px;
				text-align: center;
				font-size: 14px;
				border-right: 0;
				border-bottom: 0;
				line-height: 20px;
				font-family: "宋体";
				border: solid #D5D5D5 1px;   
			}
			
			.right{
			text-align: right;
			padding-top: 7px;
			}
			.form-group-height{
			}
			.chosen-container{
				width: 100% !important;
				min-height: 34px;
    			font-size: 14px;
    			line-height: 34px;
    			    text-align: left;
			}
			.chosen-container-multi .chosen-choices{
				border: 1px solid #D5D5D5;
			}
			.CodeMirror {
				text-align: left;
	    		border: 1px solid #D5D5D5;
	    	}
	    	.CodeMirror-fullscreen{
	    		border-top: none;
	    	}
	    	.CodeMirror-hints {
	    		z-index: 9999;
	    	}
	    </style>
	</head>
	<body>
		<div class="tabbable col-xs-12 no-padding-left no-padding-right right">
			<div style="position: absolute; right: 0px; margin: 3px; z-index: 9999;">
				<c:if test="${form.DESIGN_MODEL == 'TABLE'}">
					<button type="button" class="btn btn-xs btn-xs-ths"
						id="btnImportExcel" onclick="parent.jdp_eform_importExcelToForm();">
						导入excel模板
					</button>
				</c:if>
				<button type="button" class="btn btn-xs btn-success btn-xs-ths"
						id="btnFormValidate" onclick="jdp_eform_formValidate();">
						<i class="ace-icon fa fa-check"></i> 较验
				</button>
				<!--  <button type="button" class="btn btn-xs btn-success btn-xs-ths "
						id="btnFormValidate" onclick="jdp_eform_initform();">
						 智能初始化
				</button> -->
			</div>
        	<ul id="myTab" class="nav nav-tabs">
            	<li >
              		<a id="opt_cell" href="#div_${selectType == null || selectType == '' || selectType == 'td_cell' || selectType == 'row' ? 'cell' : selectType }" data-toggle="tab">控件属性</a>
            	</li>
              	<li class="active">
                	<a id="opt_row" href="#div_row"  data-toggle="tab">表单属性</a>
                </li>
           	</ul>
      		<div id="aotuHeight" class="tab-content min-height-200 " style="height: 100px">
<!-- -------------表单属性--------------------------------------------------------------------------------------------------------------------- -->
          		<div class="tab-pane" id="div_row" style="padding:5px;">
					<label class="col-xs-12" style="text-align: left; padding-left: 0px;">表单页属性：</label>
           			<textarea  id ="formPropStr" name="formPropStr" placeholder="自定义的JS以及HTML代码，默认添加在页面底部"
           			value="" style="width:100%;min-height:200px;resize:none;margin-bottom:5px">${formProp}</textarea>
           			<label class="col-xs-12" style="text-align: left; padding-left: 0px;">查看页属性：</label>
           			<textarea  id ="formDetailProperty" name="formDetailProperty" placeholder="自定义的JS以及HTML代码，默认添加在页面底部"
           			value="" style="width:100%;min-height:200px;resize:none;margin-bottom:5px">${formDetailProperty}</textarea>
           			<button type="button" class="btn btn-xs btn-primary btn-xs-ths"
						id="btnFormSave" onclick="doSaveFormProp()">
						<i class="ace-icon fa fa-save"></i> 保存
					</button>
           		</div>
<!-- --------------表格属性-------------------------------------------------------------------------------------------------------------------- --> 
				<div class="tab-pane" id="div_table">
					<form class="form-horizontal" id="tableFormInfo" action="" method="post" style="padding: 5px;">
						<input type="hidden" id="TABLE_FORM_ID" name="form['FORM_ID']" value="${form_id}" />
						<div class="form-group form-group-height">
                        	<label class="col-xs-3 control-label no-padding-right right right">
								<i class="ace-icon fa fa-asterisk red smaller-70"></i> 
								表格列数
							</label>
							<div class="col-xs-9">
								<input type="text" class="form-control" id="TABLE_COL_NUM" 
										name="form['TABLE_COL_NUM']"
										data-validation-engine="validate[required,custom[number],min[1],max[10]]"
										oldvalue="${form.TABLE_COL_NUM}"
										value="${form.TABLE_COL_NUM}" />
			              	</div>
				     	</div>
				     	<div class="form-group form-group-height">
				     		<div class="col-xs-12">
				            	<button type="button" class="btn btn-xs btn-primary btn-xs-ths" onclick="doSaveTable()">
									<i class="ace-icon fa fa-save"></i> 保存
								</button>
								<button type="button" class="btn btn-xs btn-danger btn-xs-ths" onclick="doClearTable()">
									<i class="ace-icon fa fa-remove"></i> 清空
								</button>
							</div>
				    	</div>
					</form>
				</div>
<!-- --------------单元格属性-------------------------------------------------------------------------------------------------------------------- -->       
           		<div class="tab-pane" id="div_table_td">
					<form class="form-horizontal" id="tdFormInfo" action="" method="post" style="padding: 5px;">
						<input type="hidden" id="FORMTD_ID" name="form['FORMTD_ID']" value="${tdMap.FORMTD_ID}" />
						<c:if test='${trMap.IS_BASE_ROW != true }'>
							<div class="form-group form-group-height">
	                        	<label class="col-xs-3 control-label no-padding-right right">
									边框是否隐藏
								</label>
								<div class="col-xs-9" style="text-align: left; padding-top: 7px;">
									<label>
										<input name="form['FORMTD_BORDER_TOP']" type="checkbox" value="2" class="ace" <c:if test="${tdMap.FORMTD_BORDER_TOP == 2}">checked="checked"</c:if>>
										<span class="lbl">上</span>
									</label>
									<label>
										<input name="form['FORMTD_BORDER_RIGHT']" type="checkbox" value="2" class="ace" <c:if test="${tdMap.FORMTD_BORDER_RIGHT == 2}">checked="checked"</c:if>>
										<span class="lbl">右</span>
									</label>
									<label>
										<input name="form['FORMTD_BORDER_BOTTOM']" type="checkbox" value="2" class="ace" <c:if test="${tdMap.FORMTD_BORDER_BOTTOM == 2}">checked="checked"</c:if>>
										<span class="lbl">下</span>
									</label>
									<label>
										<input name="form['FORMTD_BORDER_LEFT']" type="checkbox" value="2" class="ace" <c:if test="${tdMap.FORMTD_BORDER_LEFT == 2}">checked="checked"</c:if>>
										<span class="lbl">左</span>
									</label>
				              	</div>
					     	</div>
					     	<div class="form-group">
	                        	<label class="col-xs-3 control-label no-padding-right right">
									上边距
								</label>
								<div class="col-xs-9">
									<input type="text" class="form-control" id="FORMTD_PADDING_TOP" name="form['FORMTD_PADDING_TOP']" oldvalue="${tdMap.FORMTD_PADDING_TOP}" 
												value="${tdMap.FORMTD_PADDING_TOP}" data-validation-engine="validate[custom[number],min[1]]" style="padding: 1px;"/>
					            </div>
							</div>
							<div class="form-group">
	                        	<label class="col-xs-3 control-label no-padding-right right">
									右边距
								</label>
								<div class="col-xs-9">
									<input type="text" class="form-control" id="FORMTD_PADDING_RIGHT" name="form['FORMTD_PADDING_RIGHT']" oldvalue="${tdMap.FORMTD_PADDING_RIGHT}" 
												value="${tdMap.FORMTD_PADDING_RIGHT}" data-validation-engine="validate[custom[number],min[1]]" style="padding: 1px;"/>
					            </div>
							</div>
							<div class="form-group">
	                        	<label class="col-xs-3 control-label no-padding-right right">
									下边距
								</label>
								<div class="col-xs-9">
									<input type="text" class="form-control" id="FORMTD_PADDING_BOTTOM" name="form['FORMTD_PADDING_BOTTOM']" oldvalue="${tdMap.FORMTD_PADDING_BOTTOM}" 
												value="${tdMap.FORMTD_PADDING_BOTTOM}" data-validation-engine="validate[custom[number],min[1]]" style="padding: 1px;"/>
					            </div>
							</div>
							<div class="form-group">
	                        	<label class="col-xs-3 control-label no-padding-right right">
									左边距
								</label>
								<div class="col-xs-9">
									<input type="text" class="form-control" id="FORMTD_PADDING_LEFT" name="form['FORMTD_PADDING_LEFT']" oldvalue="${tdMap.FORMTD_PADDING_LEFT}" 
												value="${tdMap.FORMTD_PADDING_LEFT}" data-validation-engine="validate[custom[number],min[1]]" style="padding: 1px;"/>
					            </div>
							</div>
					     	<div class="form-group form-group-height">
	                        	<label class="col-xs-3 control-label no-padding-right right">
									背景色
								</label>
								<div class="col-xs-9">
									<input type="hidden" class="form-control" id="FORMTD_BACKGROUND" 
											name="form['FORMTD_BACKGROUND']"
											oldvalue="${tdMap.FORMTD_BACKGROUND}"
											value="${tdMap.FORMTD_BACKGROUND}" />
									<div class="dropdown dropdown-colorpicker" style="text-align: left; padding-top: 6px;">		
										<a data-toggle="dropdown" class="dropdown-toggle" data-position="auto" aria-expanded="false">
											<span class="btn-colorpicker" style="background-color: ${tdMap.FORMTD_BACKGROUND == null || tdMap.FORMTD_BACKGROUND == '' ? '#ffffff' : tdMap.FORMTD_BACKGROUND}; border: 1px solid #000000;"></span>
										</a>
										<ul class="dropdown-menu dropdown-caret">
											<li><a class="colorpick-btn <c:if test="${tdMap.FORMTD_BACKGROUND == null || tdMap.FORMTD_BACKGROUND == '' }">selected</c:if>" style="background-color:#ffffff;" data-color="#ffffff"></a></li>
											<li><a class="colorpick-btn <c:if test="${tdMap.FORMTD_BACKGROUND == '#d06b64' }">selected</c:if>" style="background-color:#d06b64;" data-color="#d06b64"></a></li>
											<li><a class="colorpick-btn <c:if test="${tdMap.FORMTD_BACKGROUND == '#f83a22' }">selected</c:if>" style="background-color:#f83a22;" data-color="#f83a22"></a></li>
											<li><a class="colorpick-btn <c:if test="${tdMap.FORMTD_BACKGROUND == '#fa573c' }">selected</c:if>" style="background-color:#fa573c;" data-color="#fa573c"></a></li>
											<li><a class="colorpick-btn <c:if test="${tdMap.FORMTD_BACKGROUND == '#ff7537' }">selected</c:if>" style="background-color:#ff7537;" data-color="#ff7537"></a></li>
											<li><a class="colorpick-btn <c:if test="${tdMap.FORMTD_BACKGROUND == '#ffad46' }">selected</c:if>" style="background-color:#ffad46;" data-color="#ffad46"></a></li>
											<li><a class="colorpick-btn <c:if test="${tdMap.FORMTD_BACKGROUND == '#42d692' }">selected</c:if>" style="background-color:#42d692;" data-color="#42d692"></a></li>
											<li><a class="colorpick-btn <c:if test="${tdMap.FORMTD_BACKGROUND == '#16a765' }">selected</c:if>" style="background-color:#16a765;" data-color="#16a765"></a></li>
											<li><a class="colorpick-btn <c:if test="${tdMap.FORMTD_BACKGROUND == '#7bd148' }">selected</c:if>" style="background-color:#7bd148;" data-color="#7bd148"></a></li>
											<li><a class="colorpick-btn <c:if test="${tdMap.FORMTD_BACKGROUND == '#b3dc6c' }">selected</c:if>" style="background-color:#b3dc6c;" data-color="#b3dc6c"></a></li>
											<li><a class="colorpick-btn <c:if test="${tdMap.FORMTD_BACKGROUND == '#fbe983' }">selected</c:if>" style="background-color:#fbe983;" data-color="#fbe983"></a></li>
											<li><a class="colorpick-btn <c:if test="${tdMap.FORMTD_BACKGROUND == '#fad165' }">selected</c:if>" style="background-color:#fad165;" data-color="#fad165"></a></li>
											<li><a class="colorpick-btn <c:if test="${tdMap.FORMTD_BACKGROUND == '#92e1c0' }">selected</c:if>" style="background-color:#92e1c0;" data-color="#92e1c0"></a></li>
											<li><a class="colorpick-btn <c:if test="${tdMap.FORMTD_BACKGROUND == '#9fe1e7' }">selected</c:if>" style="background-color:#9fe1e7;" data-color="#9fe1e7"></a></li>
											<li><a class="colorpick-btn <c:if test="${tdMap.FORMTD_BACKGROUND == '#9fc6e7' }">selected</c:if>" style="background-color:#9fc6e7;" data-color="#9fc6e7"></a></li>
											<li><a class="colorpick-btn <c:if test="${tdMap.FORMTD_BACKGROUND == '#4986e7' }">selected</c:if>" style="background-color:#4986e7;" data-color="#4986e7"></a></li>
											<li><a class="colorpick-btn <c:if test="${tdMap.FORMTD_BACKGROUND == '#9a9cff' }">selected</c:if>" style="background-color:#9a9cff;" data-color="#9a9cff"></a></li>
											<li><a class="colorpick-btn <c:if test="${tdMap.FORMTD_BACKGROUND == '#b99aff' }">selected</c:if>" style="background-color:#b99aff;" data-color="#b99aff"></a></li>
											<li><a class="colorpick-btn <c:if test="${tdMap.FORMTD_BACKGROUND == '#c2c2c2' }">selected</c:if>" style="background-color:#c2c2c2;" data-color="#c2c2c2"></a></li>
											<li><a class="colorpick-btn <c:if test="${tdMap.FORMTD_BACKGROUND == '#cabdbf' }">selected</c:if>" style="background-color:#cabdbf;" data-color="#cabdbf"></a></li>
											<li><a class="colorpick-btn <c:if test="${tdMap.FORMTD_BACKGROUND == '#cca6ac' }">selected</c:if>" style="background-color:#cca6ac;" data-color="#cca6ac"></a></li>
											<li><a class="colorpick-btn <c:if test="${tdMap.FORMTD_BACKGROUND == '#f691b2' }">selected</c:if>" style="background-color:#f691b2;" data-color="#f691b2"></a></li>
											<li><a class="colorpick-btn <c:if test="${tdMap.FORMTD_BACKGROUND == '#cd74e6' }">selected</c:if>" style="background-color:#cd74e6;" data-color="#cd74e6"></a></li>
											<li><a class="colorpick-btn <c:if test="${tdMap.FORMTD_BACKGROUND == '#a47ae2' }">selected</c:if>" style="background-color:#a47ae2;" data-color="#a47ae2"></a></li>
											<li><a class="colorpick-btn <c:if test="${tdMap.FORMTD_BACKGROUND == '#555' }">selected</c:if>" style="background-color:#555;" data-color="#555"></a></li>
										</ul>
									</div>
				              	</div>
					     	</div>
					     	<div class="form-group form-group-height">
	                        	<label class="col-xs-3 control-label no-padding-right right">
									单元格其它样式
								</label>
								<div class="col-xs-9">
									<input type="text" class="form-control" id="FORMTD_STYLE" 
											name="form['FORMTD_STYLE']"
											oldvalue="${tdMap.FORMTD_STYLE}"
											value="${tdMap.FORMTD_STYLE}" />
				              	</div>
					     	</div>
						</c:if>
						<c:if test='${trMap.IS_BASE_ROW == true }'>
							<div class="form-group form-group-height">
	                        	<label class="col-xs-3 control-label no-padding-right right">
									单元格宽度
								</label>
								<div class="col-xs-9">
									<input type="text" class="form-control" id="FORMTD_WIDTH" 
											name="form['FORMTD_WIDTH']"
											oldvalue="${tdMap.FORMTD_WIDTH}"
											value="${tdMap.FORMTD_WIDTH}" />
				              	</div>
					     	</div>
				     	</c:if>
				     	<div class="form-group form-group-height">
				     		<div class="col-xs-12">
				     			<button type="button" class="btn btn-xs btn-primary btn-xs-ths" onclick="doSaveTd()">
									<i class="ace-icon fa fa-save"></i> 保存
								</button>
								<c:choose>
									<c:when test="${trMap.IS_BASE_ROW == true }">
										<button type="button" class="btn btn-xs btn-primary btn-xs-ths" onclick="jdp_eform_mouseRightClick('table_add_td');">
											添加列
										</button>
										<button type="button" class="btn btn-xs btn-primary btn-xs-ths" onclick="jdp_eform_mouseRightClick('table_delete_td');">
											删除列
										</button>
									</c:when>
									<c:otherwise>
										<button type="button" class="btn btn-xs btn-primary btn-xs-ths" onclick="jdp_eform_mouseRightClick('table_td_add_cell');">
											插入控件
										</button>
									</c:otherwise>
								</c:choose>
								<c:if test="${tdMap.FORMTD_COLSPAN > 1 || tdMap.FORMTD_ROWSPAN > 1 }">
									<button type="button" class="btn btn-xs btn-primary btn-xs-ths" onclick="jdp_eform_mouseRightClick('table_td_split');">
										拆分单元格
									</button>
								</c:if>
							</div>
				    	</div>
					</form>
				</div>
<!-- --------------表格行属性tr-------------------------------------------------------------------------------------------------------------------- -->       
           		<div class="tab-pane" id="div_table_tr">
					<form class="form-horizontal" id="trFormInfo" action="" method="post" style="padding: 5px;">
						<input type="hidden" id="FORMTD_ID" name="form['FORMROW_ID']" value="${tdMap.FORMROW_ID}" />
				     	<div class="form-group form-group-height">
				     		<div class="col-xs-12">
				     			<button type="button" class="btn btn-xs btn-primary btn-xs-ths" onclick="jdp_eform_mouseRightClick('table_add_tr');">
									添加行
								</button>
								<button type="button" class="btn btn-xs btn-primary btn-xs-ths" onclick="jdp_eform_mouseRightClick('table_delete_tr');">
									删除行
								</button>
								<button type="button" class="btn btn-xs btn-primary btn-xs-ths" onclick="jdp_eform_mouseRightClick('table_tr_up');">
									上移
								</button>
								<button type="button" class="btn btn-xs btn-primary btn-xs-ths" onclick="jdp_eform_mouseRightClick('table_tr_down');">
									下移
								</button>
								<!-- 
				            	<button type="button" class="btn btn-xs btn-primary btn-xs-ths" onclick="doSaveTr()">
									<i class="ace-icon fa fa-save"></i> 保存
								</button>
								 -->
							</div>
				    	</div>
					</form>
				</div>
<!-- --------------控件设置-------------------------------------------------------------------------------------------------------------------- -->                                   
           		<div class="tab-pane" id="div_cell">
					<form class="form-horizontal" role="form" id="formInfo" action="" method="post" style="padding: 5px;">
				    	<input type="hidden" id="FORMCELL_ID" name="table['JDP_EFORM_FORMCELL'].key['FORMCELL_ID']" value="${cellMap.FORMCELL_ID}" />
						<input type="hidden" id="FORM_ID" name="table['JDP_EFORM_FORMCELL'].column['FORM_ID']" value="${cellMap.FORM_ID}" />
						<input type="hidden" id="FORMROW_ID" name="table['JDP_EFORM_FORMCELL'].column['FORMROW_ID']" value="${cellMap.FORMROW_ID}" />
						<input type="hidden" id="FORMCELL_ORDER" name="table['JDP_EFORM_FORMCELL'].column['FORMCELL_ORDER']" value="${cellMap.FORMCELL_ORDER}" />
						<div class="form-group form-group-height" >
                        	<label class="col-xs-3 control-label no-padding-right right">
                        	<i class="ace-icon fa fa-asterisk red smaller-70"></i> 
								控件类型
							</label>
							<div class="col-xs-9">
								<input type="hidden"  
				                   		id="FORMCELL_TYPECODE" 
				                   	    name="table['JDP_EFORM_FORMCELL'].column['FORMCELL_TYPECODE']"
										value="${cellMap.FORMCELL_TYPECODE}"/>
								<input type="text"
										class="form-control"   
										data-validation-engine="validate[required]" 
				                   		id="FORMCELL_TYPECODE_NAME"
				                   		<c:forEach var="formcell" items="${dictionarys_map.FORMCELL_TYPE_NATIVE}">
				                   			<c:if test="${cellMap.FORMCELL_TYPECODE == formcell.dictionary_code }">
				                   				value="${formcell.dictionary_name}"
				                   			</c:if> 
										</c:forEach>
										<c:forEach var="formcell" items="${dictionarys_map.FORMCELL_TYPE_EXTEND}">
				                   			<c:if test="${cellMap.FORMCELL_TYPECODE == formcell.dictionary_code }">
				                   				value="${formcell.dictionary_name}"
				                   			</c:if> 
										</c:forEach> 
										readonly="readonly"
										onclick="chooseFormCell();"/>
			            	</div>
				       	</div>
						<div class="form-group form-group-height" id="div_formcell_meta">
                        	<label class="col-xs-3 control-label no-padding-right right right">
								<i class="ace-icon fa fa-asterisk red smaller-70"></i> 
								元数据
							</label>
							<div class="col-xs-9">
								<div class="input-group">
				 					<input type="hidden"  
				                   			id="FIELD_ID" 
				                   	        name="table['JDP_EFORM_FORMCELL'].column['FIELD_ID']"
										   	value="${cellMap.FIELD_ID}" />
				                    <input type="text" class="form-control"
				                           	id="FIELD_NAME"
				                           	data-validation-engine="validate[required]" readonly="readonly"
				                           	placeholder=""
				                           	<c:if test="${not empty  cellMap.TABLE_NAME}"><c:choose><c:when test='${cellMap.FORMCELL_TYPECODE == "TABLE" }'>title="【${cellMap.TABLE_NAME}】"</c:when><c:otherwise>title="【${cellMap.TABLE_NAME}】.【${cellMap.FIELD_NAME}】"</c:otherwise></c:choose></c:if>
							   				value='${cellMap.FORMCELL_TYPECODE == "TABLE" ? cellMap.TABLE_NAME : cellMap.FIELD_NAME}' />
					                <span class="input-group-btn">
						            	<button type="button" class="btn btn-white btn-default" data-self-js="openMeta('${cellMap.TABLE_CODE}')">
						                	<i class="ace-icon fa fa-search" ></i>选择
						              	</button>
					                 	<button type="button" class="btn btn-white btn-default" data-self-js="clearValue(this)">
					                      	<i class="ace-icon fa fa-remove"></i>
					                    </button>
					               	</span>
				              	</div>
			              	</div>
				     	</div>
				     	<div class="form-group form-group-height" id="div_showname_filed_id" style="display: none;">
                        	<label class="col-xs-3 control-label no-padding-right right right">
								名称元数据
							</label>
							<div class="col-xs-9">
								<div class="input-group">
				 					<input type="hidden" id="SHOWNAME_FIELD_ID" name="table['JDP_EFORM_FORMCELL'].column['SHOWNAME_FIELD_ID']" 
				 							value="${cellMap.SHOWNAME_FIELD_ID}"/>
				                    <input type="text" class="form-control" id="SHOWNAME_FIELD_NAME" readonly="readonly"
				                           	<c:if test="${not empty cellMap.SHOWNAME_FIELD_NAME}">title="【${cellMap.TABLE_NAME}】.【${cellMap.SHOWNAME_FIELD_NAME}】"</c:if> 
				                           	value='${cellMap.SHOWNAME_FIELD_NAME}' data-validation-engine="validate[funcCall[checkShowNameFieldId]]"/>
					                <span class="input-group-btn">
						            	<button type="button" class="btn btn-white btn-default" data-self-js="openNameMeta('${cellMap.TABLE_CODE}')">
						                	<i class="ace-icon fa fa-search" ></i>选择
						              	</button>
					                 	<button type="button" class="btn btn-white btn-default" data-self-js="clearValue(this)">
					                      	<i class="ace-icon fa fa-remove"></i>
					                    </button>
					               	</span>
				              	</div>
			              	</div>
				     	</div>
						<div class="form-group form-group-height" id="div_formcell_width">
					  		<label class="col-xs-3 control-label no-padding-right right">
								控件宽度
							</label>
							<div class="col-xs-9">
								<select id="FORMCELL_WIDTH" 
								name="table['JDP_EFORM_FORMCELL'].column['FORMCELL_WIDTH']"
								class="form-control" 
								data-validation-engine="validate[required]">
									<c:forEach var="formcell_width" items="${dictionarys_map.FORMCELL_WIDTH}"  varStatus="status">
										<option value="${formcell_width.dictionary_code}"  
										        title="${formcell_width.dictionary_name}"
										 	    <c:if test="${formcell_width.dictionary_code==cellMap.FORMCELL_WIDTH}">selected="selected"</c:if>>
											    ${formcell_width.dictionary_name}
										</option>
									</c:forEach>	
								</select>
				            </div>
				     	</div>			                         
				     	<div class="form-group form-group-height" id="div_formcell_descpre">
						 	<label class="col-xs-3 control-label no-padding-right right">
								前置描述
							</label>
							<div class="col-xs-5" >
								  <input type="text"
										class="form-control" 
										id="FORMCELL_DESCR" 
										name="table['JDP_EFORM_FORMCELL'].column['FORMCELL_DESCR']"
										placeholder=""
										oldvalue="${cellMap.FORMCELL_DESCR}"
										value="${cellMap.FORMCELL_DESCR}" />
				            </div>
				            <div class="col-xs-4">
								<select id="FORMCELL_LABLEWIDTH" 
								name="table['JDP_EFORM_FORMCELL'].column['FORMCELL_LABLEWIDTH']"
								class="form-control" 
								data-validation-engine="validate[required]">
									<c:forEach var="formcell_lablewidth" items="${dictionarys_map.FORMCELL_LABLEWIDTH}"  varStatus="status">
										<option value="${formcell_lablewidth.dictionary_code}"  
										        title="${formcell_lablewidth.dictionary_name}"
										 	    <c:if test="${formcell_lablewidth.dictionary_code==cellMap.FORMCELL_LABLEWIDTH}">selected="selected"</c:if>>
											    ${formcell_lablewidth.dictionary_name}
										</option>
									</c:forEach>	
								</select>
				            </div>
				     	</div>
				    	<div class="form-group form-group-height" id="div_formcell_descrend" >
						  	<label class="col-xs-3 control-label no-padding-right right">
								后置描述
							</label>
							<div class="col-xs-9">
								  <input type="text"
										class="form-control" 
										id="FORMCELL_DESCREND" 
										name="table['JDP_EFORM_FORMCELL'].column['FORMCELL_DESCREND']"
										placeholder=""
										oldvalue="${cellMap.FORMCELL_DESCREND}"
										value="${cellMap.FORMCELL_DESCREND}" />
				            </div>
				    	</div>
				    	<div class="form-group form-group-height" id="div_formcell_title" >
						  	<label class="col-xs-3 control-label no-padding-right right">
								TITLE描述
							</label>
							<div class="col-xs-9">
								  <input type="text"
										class="form-control" 
										id="FORMCELL_TITLE" 
										name="table['JDP_EFORM_FORMCELL'].column['FORMCELL_TITLE']"
										placeholder=""
										oldvalue="${cellMap.FORMCELL_TITLE}"
										value="${cellMap.FORMCELL_TITLE}" />
				            </div>
				    	</div>
				     	<div class="form-group form-group-height" id="div_formcell_datetype">
						  	<label class="col-xs-3 control-label no-padding-right right">
								日期格式
							</label>
							<div class="col-xs-9">
								<input type="hidden" id="FORMCELL_DATETYPE" name="table['JDP_EFORM_FORMCELL'].column['FORMCELL_DATETYPE']"/>
								<select id="FORMCELL_DATETYPE_SELECT" 
								class="form-control" >
									<c:forEach var="formcell_datetype" items="${dictionarys_map.FORMCELL_DATETYPE}"  varStatus="status">
										<option value="${formcell_datetype.dictionary_code}"  
										        title="${formcell_datetype.dictionary_name}"
										 	    <c:if test="${formcell_datetype.dictionary_code==cellMap.FORMCELL_DATETYPE}">selected="selected"</c:if>>
											    ${formcell_datetype.dictionary_name}
										</option>
									</c:forEach>	
								</select>
				            </div>
				     	</div>
				     	<div class="form-group form-group-height" id="div_formcell_dictionary">
						  	<label class="col-xs-3 control-label no-padding-right right right">
						  		<i class="ace-icon fa fa-asterisk red smaller-70"></i>
								字典引用
							</label>
							<div class="col-xs-9">
								<div class="input-group">
				                	<input type="hidden"  
				                	       id="FORMCELL_DICTIONARY" 
				                	       name="table['JDP_EFORM_FORMCELL'].column['FORMCELL_DICTIONARY']"
										   value="${cellMap.FORMCELL_DICTIONARY}" />
				                    <input type="text" class="form-control"
				                           id="TREE_NAME"
				                           data-validation-engine="validate[required]" readonly="readonly"
				                           placeholder="" 
				                           title="${cellMap.TREE_NAME}"
									       value="${cellMap.TREE_NAME}"
				                    />
				                    <span class="input-group-btn">
				                        <button type="button" class="btn btn-white btn-default" data-self-js="openDistionary()">
				                            <i class="ace-icon fa fa-search" ></i>
				                           	 选择
				                        </button>
				                        <button type="button" class="btn btn-white btn-default" data-self-js="clearValue(this)">
				                            <i class="ace-icon fa fa-remove"></i>
				                        </button>
				                    </span>
				                </div>
				            </div>
				     	</div>
				      	<div class="form-group form-group-height"  id="div_formcell_open">
						  	<label class="col-xs-3 control-label no-padding-right right">
								弹出高/宽
							</label>
							<div class="col-xs-5" >
								  <input type="text"
										class="form-control" 
										id="FORMCELL_OPENHEIGHT" 
										name="table['JDP_EFORM_FORMCELL'].column['FORMCELL_OPENHEIGHT']"
										data-validation-engine="validate[custom[number]]"
										placeholder=""
										oldvalue="${cellMap.FORMCELL_OPENHEIGHT}"
										value="${cellMap.FORMCELL_OPENHEIGHT}" />
				            </div>
				            <div class="col-xs-4">
								<input type="text"
										class="form-control" 
										id="FORMCELL_OPENWIDTH" 
										name="table['JDP_EFORM_FORMCELL'].column['FORMCELL_OPENWIDTH']"
										data-validation-engine="validate[custom[number]]"
										placeholder=""
										oldvalue="${cellMap.FORMCELL_OPENWIDTH}"
										value="${cellMap.FORMCELL_OPENWIDTH}" />
				            </div>
				     	</div>
				     	<div class="form-group form-group-height"   id="div_formcell_height">
						  	<label class="col-xs-3 control-label no-padding-right right">
								控件高度
							</label>
							<div class="col-xs-8">
								  <input type="text"
										class="form-control" 
										id="FORMCELL_HEIGHT" 
										name="table['JDP_EFORM_FORMCELL'].column['FORMCELL_HEIGHT']"
										data-validation-engine="validate[custom[number]]"
										oldvalue="${cellMap.FORMCELL_HEIGHT}"
										value="${cellMap.FORMCELL_HEIGHT}" />
				            </div>
				            <div class="col-xs-1" style="height: 34px; text-align: left; padding: 4px 0px 0px 0px;">
				            	px
				            </div>
				     	</div>
				     	<div class="form-group form-group-height"  id="div_formcell_required">
						  	<label class="col-xs-3 control-label no-padding-right right">
								是否必填
							</label>
							<div class="col-xs-9">
								<select id="FORMCELL_REQUIRED" 
								name="table['JDP_EFORM_FORMCELL'].column['FORMCELL_REQUIRED']"
								class="form-control" 
								data-validation-engine="validate[required]">
									<c:forEach var="formcell_required" items="${dictionarys_map.FORMCELL_REQUIRED}"  varStatus="status">
										<option value="${formcell_required.dictionary_code}"  
										        title="${formcell_required.dictionary_name}"
										 	    <c:if test="${formcell_required.dictionary_code==cellMap.FORMCELL_REQUIRED}">selected="selected"</c:if>>
											    ${formcell_required.dictionary_name}
										</option>
									</c:forEach>	
								</select>
				            </div>
				     	</div>
				     	<div class="form-group form-group-height"  id="div_formcell_validate_rules">
						  	<label class="col-xs-3 control-label no-padding-right right">
								验证规则
							</label>
							<div class="col-xs-9">
								<input type="hidden" name="table['JDP_EFORM_FORMCELL'].column['FORMCELL_VALIDATE_RULES']" id="FORMCELL_VALIDATE_RULES"/>
								<select multiple="" class="chosen-select form-control" id="FORMCELL_VALIDATE_RULES_SELECT" 
										data-placeholder="可选验证规则">
									<c:forEach var="formcell_validate_rule" items="${dictionarys_map.FORMCELL_VALIDATE_RULES}"  varStatus="status">
										<option <c:choose><c:when test="${formcell_validate_rule.ext1 != null }">value="${formcell_validate_rule.ext1 }[${formcell_validate_rule.dictionary_code}]"</c:when><c:otherwise>value="${formcell_validate_rule.dictionary_code}"</c:otherwise></c:choose>  
										        title="${formcell_validate_rule.dictionary_name}"
										 	    <c:if test="${fn:contains(cellMap.FORMCELL_VALIDATE_RULES,formcell_validate_rule.dictionary_code)}">selected="selected"</c:if>>
											    ${formcell_validate_rule.dictionary_name}
										</option>
									</c:forEach>	
								</select>
				            </div>
				     	</div>
				     	<div class="form-group form-group-height"  id="div_formcell_readonly">
						  	<label class="col-xs-3 control-label no-padding-right right">
								是否只读
							</label>
							<div class="col-xs-9">
								<select id="FORMCELL_UNIQUE" 
								name="table['JDP_EFORM_FORMCELL'].column['FORMCELL_READONLY']"
								class="form-control" 
								data-validation-engine="validate[required]">
									<c:forEach var="formcell_readonly" items="${dictionarys_map.FORMCELL_READONLY}"  varStatus="status">
										<option value="${formcell_readonly.dictionary_code}"  
										        title="${formcell_readonly.dictionary_name}"
										 	    <c:if test="${formcell_readonly.dictionary_code==cellMap.FORMCELL_READONLY}">selected="selected"</c:if>>
											    ${formcell_readonly.dictionary_name}
										</option>
									</c:forEach>	
								</select>
				            </div>
				     	</div>
				      	<div class="form-group form-group-height" id="div_formcell_length">
						  	<label class="col-xs-3 control-label no-padding-right right">
								最大长度
							</label>
							<div class="col-xs-9">
								  <input type="text"
										class="form-control" 
										id="FORMCELL_LENGTH" 
										name="table['JDP_EFORM_FORMCELL'].column['FORMCELL_LENGTH']"
										data-validation-engine="validate[custom[number],max[<fmt:formatNumber type="number" value="${cellMap.FIELD_LENGTH}" maxFractionDigits="0" pattern="#"/>]]"
										placeholder=""
										oldvalue="${cellMap.FORMCELL_LENGTH}"
										value="${cellMap.FORMCELL_LENGTH}" />
				            </div>
				    	</div>
				      	<div class="form-group form-group-height" id="div_formcell_message">
						  	<label class="col-xs-3 control-label no-padding-right right">
								提示信息
							</label>
							<div class="col-xs-9">
								  <input type="text"
										class="form-control" 
										id="FORMCELL_MESSAGE" 
										name="table['JDP_EFORM_FORMCELL'].column['FORMCELL_MESSAGE']"
										placeholder=""
										oldvalue="${cellMap.FORMCELL_MESSAGE}"
										value="${cellMap.FORMCELL_MESSAGE}" />
				            </div>
				    	</div>
				    	<div class="form-group form-group-height" id="div_formcell_max">
						  	<label class="col-xs-3 control-label no-padding-right right">
								最大值
							</label>
							<div class="col-xs-9">
								  <input type="text"
										class="form-control" 
										id="FORMCELL_MAX" 
										name="table['JDP_EFORM_FORMCELL'].column['FORMCELL_MAX']"
										data-validation-engine="validate[custom[number],max[9999999999]]"
										placeholder=""
										oldvalue="${cellMap.FORMCELL_MAX}"
										value="${cellMap.FORMCELL_MAX}" />
				            </div>
				    	</div>
				    	<div class="form-group form-group-height" id="div_formcell_min">
						  	<label class="col-xs-3 control-label no-padding-right right">
								最小值
							</label>
							<div class="col-xs-9">
								  <input type="text"
										class="form-control" 
										id="FORMCELL_MIN" 
										name="table['JDP_EFORM_FORMCELL'].column['FORMCELL_MIN']"
										data-validation-engine="validate[custom[number],max[9999999999]]"
										placeholder=""
										oldvalue="${cellMap.FORMCELL_MIN}"
										value="${cellMap.FORMCELL_MIN}" />
				            </div>
				    	</div>
				     	<div class="form-group form-group-height"  id="div_formcell_median">
						  	<label class="col-xs-3 control-label no-padding-right right">
								保留位数
							</label>
							<div class="col-xs-9">
								  <input type="text"
										class="form-control" 
										id="FORMCELL_MEDIAN" 
										name="table['JDP_EFORM_FORMCELL'].column['FORMCELL_MEDIAN']"
										data-validation-engine="validate[custom[number]]"
										placeholder=""
										oldvalue="${cellMap.FORMCELL_MEDIAN}"
										value="${cellMap.FORMCELL_MEDIAN}" />
				            </div>
				    	</div>
				    	<div class="form-group form-group-height" id="div_formcell_def_type">
						  	<label class="col-xs-3 control-label no-padding-right right">
								默认值类型
							</label>
							<div class="col-xs-9" style="text-align: left;">
								<select id="FORMCELL_DEF_TYPE" 
										name="table['JDP_EFORM_FORMCELL'].column['FORMCELL_DEF_TYPE']"
										class="form-control" style="width: 80%; display: inline; ">
									<c:forEach var="formcell_def_type" items="${dictionarys_map.FORMCELL_DEF_TYPE}"  varStatus="status">
										<option value="${formcell_def_type.dictionary_code}"  
										        title="${formcell_def_type.dictionary_name}"
										 	    <c:if test="${formcell_def_type.dictionary_code==cellMap.FORMCELL_DEF_TYPE}">selected="selected"</c:if>>
										    ${formcell_def_type.dictionary_name}
										</option>
									</c:forEach>	
								</select>
								<span class="help-button" data-rel="popover" data-trigger="hover" data-placement="left" data-original-title="帮助" >?</span>
				            </div>
				    	</div>
				    	<div class="form-group form-group-height" id="div_formcell_def">
						  	<label class="col-xs-3 control-label no-padding-right right">
								默认值
							</label>
							<div class="col-xs-9">
								  <input type="text"
										class="form-control" 
										id="FORMCELL_DEF" 
										name="table['JDP_EFORM_FORMCELL'].column['FORMCELL_DEF']"
										placeholder=""
										oldvalue="${cellMap.FORMCELL_DEF}"
										value="${cellMap.FORMCELL_DEF}" />
				            </div>
				    	</div>
				    	<div class="form-group form-group-height" id="div_table_column_num">
						  	<label class="col-xs-3 control-label no-padding-right right">
						  		<i class="ace-icon fa fa-asterisk red smaller-70"></i>
								列数
							</label>
							<div class="col-xs-9">
								  <input type="text"
										class="form-control" 
										id="FORMCELL_TABLE_COLUMN_NUM" 
										name="table['JDP_EFORM_FORMCELL'].column['FORMCELL_TABLE_COLUMN_NUM']"
										data-validation-engine="validate[required,integer,min[1]]"
										placeholder=""
										oldvalue="${cellMap.FORMCELL_TABLE_COLUMN_NUM}"
										value="${cellMap.FORMCELL_TABLE_COLUMN_NUM}" />
				            </div>
				    	</div>
				    	<div class="form-group form-group-height" id="div_table_row_init_num">
						  	<label class="col-xs-3 control-label no-padding-right right">
						  		<i class="ace-icon fa fa-asterisk red smaller-70"></i>
								初始化行数
							</label>
							<div class="col-xs-9">
								  <input type="text"
										class="form-control" 
										id="FORMCELL_TABLE_ROW_INIT_NUM" 
										name="table['JDP_EFORM_FORMCELL'].column['FORMCELL_TABLE_ROW_INIT_NUM']"
										data-validation-engine="validate[required,integer,min[1]]"
										placeholder=""
										oldvalue="${cellMap.FORMCELL_TABLE_ROW_INIT_NUM}"
										value="${cellMap.FORMCELL_TABLE_ROW_INIT_NUM}" />
				            </div>
				    	</div>
				    	<div class="form-group form-group-height" id="div_table_column_width">
						  	<label class="col-xs-3 control-label no-padding-right right">
								列宽
							</label>
							<div class="col-xs-9">
								  <input type="text"
										class="form-control" 
										id="FORMCELL_TABLE_COLUMN_WIDTH" 
										name="table['JDP_EFORM_FORMCELL'].column['FORMCELL_TABLE_COLUMN_WIDTH']"
										oldvalue="${cellMap.FORMCELL_TABLE_COLUMN_WIDTH}"
										value="${cellMap.FORMCELL_TABLE_COLUMN_WIDTH}"/>
				            </div>
				    	</div>
				    	<div class="form-group form-group-height" id="div_formcell_style">
						  	<label class="col-xs-3 control-label no-padding-right right">
								style样式
							</label>
							<div class="col-xs-9">
								  <input type="text"
										class="form-control" 
										id="FORMCELL_STYLE" 
										name="table['JDP_EFORM_FORMCELL'].column['FORMCELL_STYLE']"
										oldvalue="${cellMap.FORMCELL_STYLE}"
										value="${cellMap.FORMCELL_STYLE}" />
				            </div>
				    	</div>
				    	<div class="form-group form-group-height" id="div_formcell_label_showline">
						  	<label class="col-xs-3 control-label no-padding-right right">
								是否显示线
							</label>
							<div class="col-xs-9">
								<select id="FORMCELL_LABEL_SHOWLINE" 
										name="table['JDP_EFORM_FORMCELL'].column['FORMCELL_LABEL_SHOWLINE']"
										class="form-control" style="width: 100%; display: inline; ">
									<c:forEach var="formcell_label_showline" items="${dictionarys_map.FORMCELL_LABEL_SHOWLINE}"  varStatus="status">
										<option value="${formcell_label_showline.dictionary_code}"  
										        title="${formcell_label_showline.dictionary_name}"
										 	    <c:if test="${formcell_label_showline.dictionary_code==cellMap.FORMCELL_LABEL_SHOWLINE}">selected="selected"</c:if>>
										    ${formcell_label_showline.dictionary_name}
										</option>
									</c:forEach>	
								</select>
				            </div>
				    	</div>
				    	<div class="form-group form-group-height" id="div_formcell_select_canedit">
						  	<label class="col-xs-3 control-label no-padding-right right">
								是否可输入
							</label>
							<div class="col-xs-9">
								<select id="FORMCELL_SELECT_CANEDIT" 
										name="table['JDP_EFORM_FORMCELL'].column['FORMCELL_SELECT_CANEDIT']"
										class="form-control" style="width: 100%; display: inline; ">
									<c:forEach var="formcell_select_canedit" items="${dictionarys_map.FORMCELL_SELECT_CANEDIT}"  varStatus="status">
										<option value="${formcell_select_canedit.dictionary_code}"  
										        title="${formcell_select_canedit.dictionary_name}"
										 	    <c:if test="${formcell_select_canedit.dictionary_code==cellMap.FORMCELL_SELECT_CANEDIT}">selected="selected"</c:if>>
										    ${formcell_select_canedit.dictionary_name}
										</option>
									</c:forEach>	
								</select>
				            </div>
				    	</div>
				    	<div class="form-group form-group-height" id="div_table_primary_fieldnames">
						  	<label class="col-xs-3 control-label no-padding-right right">
								主键
							</label>
							<div class="col-xs-9">
								  <input type="text"
										class="form-control" 
										readonly="readonly"
										value="${cellMap.primaryFieldNames}" />
				            </div>
				    	</div>
				    	<div class="form-group form-group-height" id="div_table_foreign_fieldnames">
						  	<label class="col-xs-3 control-label no-padding-right right">
								外键
							</label>
							<div class="col-xs-9">
								  <input type="text"
										class="form-control" 
										readonly="readonly"
										value="${cellMap.foreignFieldNames}" />
				            </div>
				    	</div>
				    	<div class="form-group form-group-height" id="div_table_hidebtncol">
				    		<label class="col-xs-3 control-label no-padding-right right">
								隐藏行操作列
							</label>
							<div class="col-xs-9" style="text-align: left; padding-top: 7px;">
								<label>
									<input id="FORMCELL_TABLE_HIDEBTNCOL" name="table['JDP_EFORM_FORMCELL'].column['FORMCELL_TABLE_HIDEBTNCOL']" type="checkbox" value="true" class="ace" <c:if test='${cellMap.FORMCELL_TABLE_HIDEBTNCOL == "true"}'>checked="checked"</c:if>>
									<span class="lbl"></span>
								</label>
			              	</div>
				    	</div>
				    	<div class="form-group form-group-height" id="div_formcell_label_align">
						  	<label class="col-xs-3 control-label no-padding-right right">
								对齐方式
							</label>
							<div class="col-xs-9">
								<select id="FORMCELL_LABEL_ALIGN" 
										name="table['JDP_EFORM_FORMCELL'].column['FORMCELL_LABEL_ALIGN']"
										class="form-control" style="width: 100%; display: inline; ">
									<c:forEach var="formcell_label_align" items="${dictionarys_map.FORMCELL_LABEL_ALIGN}"  varStatus="status">
										<option value="${formcell_label_align.dictionary_code}"  
										        title="${formcell_label_align.dictionary_name}"
										 	    <c:if test="${formcell_label_align.dictionary_code==cellMap.FORMCELL_LABEL_ALIGN}">selected="selected"</c:if>>
										    ${formcell_label_align.dictionary_name}
										</option>
									</c:forEach>	
								</select>
				            </div>
				    	</div>
				    	<div class="form-group form-group-height" id="div_formcell_load_url">
						  	<label class="col-xs-3 control-label no-padding-right right">
								加载地址
							</label>
							<div class="col-xs-9">
								<input type="text" class="form-control" id="FORMCELL_LOAD_URL" name="table['JDP_EFORM_FORMCELL'].column['FORMCELL_LOAD_URL']"
										data-validation-engine="validate[required,maxLength[500]]" oldvalue="${cellMap.FORMCELL_LOAD_URL}" value="${cellMap.FORMCELL_LOAD_URL}" />
				            </div>
				    	</div>
				     	<div class="form-group form-group-height">
				     		<div class="col-xs-12">
				            	<button type="button" class="btn btn-xs btn-primary btn-xs-ths"
										id="btnSave" data-self-js="doSaveCell('${rowMap.FORMROW_ID}','${cellMap.FORMCELL_ID}');">
									<i class="ace-icon fa fa-save"></i>
									<c:choose>
										<c:when test="${cellMap.FORMCELL_ID == null }">添加</c:when>
										<c:otherwise>保存</c:otherwise>
									</c:choose>
								</button>
								<c:if test="${form.DESIGN_MODEL == 'TABLE' && cellMap.FORMCELL_ID != null && cellMap.FORMCELL_TYPECODE != 'INPUTHIDDEN' && empty cellMap.P_FORMCELL_ID}">
					     			<button type="button" class="btn btn-xs btn-primary btn-xs-ths" onclick="jdp_eform_mouseRightClick('table_td_cell_left_move');">
										左移
									</button>
									<button type="button" class="btn btn-xs btn-primary btn-xs-ths" onclick="jdp_eform_mouseRightClick('table_td_cell_right_move');">
										右移
									</button>
									<button type="button" class="btn btn-xs btn-primary btn-xs-ths" onclick="jdp_eform_mouseRightClick('table_td_cell_move_to');">
										移动到
									</button>
								</c:if>
								<c:if test="${cellMap.FORMCELL_ID != null}">
									<button type="button" class="btn btn-xs btn-danger btn-xs-ths"
										id="btnDelete" data-self-js="doDeleteCell('${cellMap.FORMCELL_ID}')">
										<i class="ace-icon fa fa-save"></i> 删除
									</button>
								</c:if>
							</div>
				    	</div>
	   				</form>  
				</div>
			</div>
		</div>					 
		<script type="text/javascript">
			//初始化-页面高度和宽度
			/* $("#myflow_props_custom",window.parent.document).height("513px"); */
			function autoHeight(){
				var h = $(document).height();
				$("#aotuHeight").height(h-70);
			}
			autoHeight();
			
			$("#opt_cell").click();
			
			//链接触发design_formhtml页方法
			function jdp_eform_mouseRightClick(type){
				$("#desgin_center_iframe",parent.document)[0].contentWindow.jdp_eform_mouseRightClick(type, true);
			}
			
			//清空值方法
			function clearValue(obj){
				$(obj).closest("div.form-group").find("input").each(function(){
					$(this).val("");
					$(this).attr("title","");
				});
			}
			//保存表格信息
			function doSaveTable(){
				if ($('#tableFormInfo').validationEngine('validate')) {
					ths.submitFormAjax({
						url : '${ctx}/eform/formdesign/formdesign_main_desgin_savetableform.vm',// any URL you want to submit
			            type:"post",
			            async:false,
						data : $("#tableFormInfo").serialize(),
						success:function (response) {
							window.parent.refreshFormHtml();
							$("#desgin_center_iframe",parent.document)[0].contentWindow.jdp_eform_selectFormTable();
						}
					});
				}
			}
			//清空表格
			function doClearTable(){
				dialog({
	                title: '提示',
	                content: '确定要清空表格信息?',
	                width: 360,
	                wraperstyle: 'alert-info',
	                ok: function () {
	                	ths.submitFormAjax({
							url: '${ctx}/eform/formdesign/formdesign_main_desgin_clearTableForm.vm',// any URL you want to submit
				            type: "post",
				            async: false,
				            data : "formId=${form_id}",
							success:function (response) {
								window.parent.refreshFormHtml();
								$("#desgin_center_iframe",parent.document)[0].contentWindow.jdp_eform_selectFormTable();
							}
						});
	                },
	                cancel: function(){
	                	return true;
	                }
	            }).showModal();
			}
			//保存行tr信息
			function doSaveTr(){
				
			}
			//保存单元格信息
			function doSaveTd(){
				if ($('#tdFormInfo').validationEngine('validate')) {
					ths.submitFormAjax({
						url : '${ctx}/eform/formdesign/formdesign_main_desgin_savetd.vm',// any URL you want to submit
			            type:"post",
			            async:false,
						data : $("#tdFormInfo").serialize(),
						success:function (response) {
							window.parent.refreshFormHtml();
							$("#desgin_center_iframe",parent.document)[0].contentWindow.jdp_eform_selectFormTableTd("${tdMap.FORMTD_ID}", "table_td");
						}
					});
				}
			}
			
			//AJAX保存
			function doSaveCell(row_id,cell_id) {
				$("#FORMCELL_DATETYPE").val($("#FORMCELL_DATETYPE_SELECT").val());
				//FORMCELL_VALIDATE_RULES chosen控件值
				var rules = $("#FORMCELL_VALIDATE_RULES_SELECT").val();
				if(rules != null){
					var rules_str = "";
					for(var i = 0; i < rules.length; i++){
						rules_str += "," + rules[i];
					}
					$("#FORMCELL_VALIDATE_RULES").val(rules_str.substring(1))
				}
				//提交之前验证表单
				if ($('#formInfo').validationEngine('validate')) {
					//名称元数据隐藏时，将值清空
					if(!$("#div_showname_filed_id").is(':visible')){
						$("#SHOWNAME_FIELD_ID").val("");
						$("#SHOWNAME_FIELD_NAME").val("");
					}
					var isRowSelected = "${rowMap.FORMROW_ID != null }";
					var isTdSelected = "${tdMap.FORMTD_ID != null }";
					if(isRowSelected == "true" || isTdSelected == "true"){
						if(isTdSelected == "true"){
							row_id = "${tdMap.FORMROW_ID }";
							$("#FORMROW_ID").val(row_id);
						}
						saveCell(row_id,cell_id);
					}else{
						dialog({
			                title: '提示',
			                content: '当前没有选中行，将会新增一行!<hr/>',
			                width:360,
			                wraperstyle:'alert-info',
			                ok: function () {
			                	saveCell(row_id,cell_id);
			                },
			                cancel: function(){
			                	return true;
			                }
			            }).showModal();
					}
				}
			}
			
			//保存表单属性
			function doSaveFormProp(){
				 $.ajax({
					url : '${ctx}/eform/formdesign/formdesign_main_desgin_save_formprop.vm',// any URL you want to submit
		            type: "post",
					data : {'formId':'${form_id}','formPropStr':$("#formPropStr").val(),'formDetailProperty':$("#formDetailProperty").val()},
					dataType:"text",
					success:function(response){
						if(response=="success"){
							dialog({
	          		            title: '提示',
	          		            content: '保存成功',
	          		          	width:360,
	          		            wraperstyle:'alert-info',
	          		            ok: function () {
	          		            	window.parent.refreshFormHtml();
	          		            }
	          		        }).showModal();
						}
					}
				});  
			}
			
			//表单校验
			function jdp_eform_formValidate(){
				$.ajax({
					url : '${ctx}/eform/formdesign/formdesign_main_desgin_validate.vm',
		            type: "post",
					data : {'formId':'${form_id}'},
					dataType:"text",
					success:function(response){
						if(response=="success"){
							dialog({
	          		            title: '提示',
	          		            content: '校验通过',
	          		            wraperstyle:'alert-info',
	          		            width:360,
	          		            ok: function () {
	          		            }
	          		        }).showModal();
						}else{
							dialog({
	          		            title: '提示',
	          		            content: response,
	          		            wraperstyle:'alert-info',
	          		            width:360,
	          		            ok: function () {
	          		            }
	          		        }).showModal();
						}
					}
				});
			}
			
			//智能初始化
			function jdp_eform_initform(){
				$.ajax({
					url : '${ctx}/eform/formdesign/formdesign_main_initform.vm',
		            type: "post",
					data : {'formId':'${form_id}'},
					dataType:"text",
					success:function(response){
						var jsonData = JSON.parse(response);
						dialog({
          		            title: '提示',
          		            content: jsonData.text,
          		            wraperstyle:'alert-info',
          		            width:360,
          		            ok: function () {
          		            	window.parent.refreshFormHtml();
          		            }
          		        }).showModal();
					}
				});
			}
			
			//保存cell
			function saveCell(row_id,cell_id){
				if(cell_id==''){
					cell_id = generateUUID();
					$("#FORMCELL_ID").val(cell_id);
					$("#FORM_ID").val('${form_id}');
					$("#FORMROW_ID").val(row_id);
				}
				if($("#FORMCELL_HEIGHT").val() != ""){
					$("#FORMCELL_HEIGHT").val($("#FORMCELL_HEIGHT").val() + "px");
				}
				ths.submitFormAjax({
					url : '${ctx}/eform/formdesign/formdesign_main_desgin_savecell.vm',// any URL you want to submit
		            type:"post",
		            async:false,
					data : $("#formInfo").serialize() + "&td_id=${tdMap.FORMTD_ID}" + ($("#FORMCELL_TABLE_HIDEBTNCOL").is(":hidden") || $("#FORMCELL_TABLE_HIDEBTNCOL").prop("checked") ? "" : "&table['JDP_EFORM_FORMCELL'].column['FORMCELL_TABLE_HIDEBTNCOL']=false"),
					success:function (response) {
						window.parent.refreshFormHtml();
						if("${cellMap.P_FORMCELL_ID}" != ""){
							$("#desgin_center_iframe",parent.document)[0].contentWindow.selectTableFormCell(row_id,cell_id, "${form.DESIGN_MODEL}");
						}else{
							$("#desgin_center_iframe",parent.document)[0].contentWindow.selectFormCell(row_id, cell_id, "${form.DESIGN_MODEL}");
						}
					}
				});
			}
			function doDeleteCell(cell_id){
		        ths.submitFormAjax({
		            url:"${ctx}/eform/formdesign/formdesign_main_desgin_deletecell.vm?cell_id="+cell_id,// any URL you want to submit
		            async:false,
		        	success:function (response) {
		        		window.parent.refreshFormHtml();
		        		window.parent.selectProperties("","","");
		        		if("TABLE" == "${form.DESIGN_MODEL}"){
		        			$("#desgin_center_iframe",parent.document)[0].contentWindow.jdp_eform_selectFormTable();
		        		}
					}
		        });}
			var treeDialog;
			function openMeta(table_code){
				var formcell_typecode = $("#FORMCELL_TYPECODE").val();
				var TABLE_STATE="";
				var TABLE_CODE = "";
				if(formcell_typecode=='TABLE'){
					TABLE_STATE='TABLE';
				}
				if("${cellMap.P_FORMCELL_ID}" != ""){
					TABLE_CODE = table_code;
				}
				treeDialog = dialog({
						id:"dialog-meta-muti",
				        title: "选择元数据",
				        url: "${ctx}/eform/formdesign/formdesign_main_desgin_choose_meta.vm?form_id=${form_id }&table_state=" + TABLE_STATE + "&table_code=" + TABLE_CODE,
				        width:360,
				        height:480
				}).showModal();
			}
			//元数据选择回调函数
			function metaCallBack(tree){
				var formcell_type = $("#FORMCELL_TYPECODE").val();
				if(formcell_type=='TABLE'){
					treeDialog.close().remove();
					$("#FIELD_ID").val(tree.TREE_ID);
					$("#FIELD_NAME").val(tree.TREE_NAME);
					$("#FIELD_NAME").attr("title","【"+tree.TABLE_NAME+"】")
				}else if(tree.TABLE_STATE=='FIELD'){
					treeDialog.close().remove();
					$("#FIELD_ID").val(tree.FIELD_ID);
					$("#FIELD_NAME").val(tree.TREE_NAME);
					$("#FIELD_NAME").attr("title","【"+tree.TABLE_NAME+"】.【"+tree.FIELD_NAME+"】");
					//查询元数据字段对应的值
					ths.submitFormAjax({
			            url:"${ctx}/eform/meta/definition/fieldJson.vm",// any URL you want to submit
			            data:{'fieldId':tree.FIELD_ID},
			            dataType:"json",
			        	success:function (response) {
			        		//设置控件类型
			        		if($("#FORMCELL_TYPECODE").val()==""){
			        			$("#FORMCELL_TYPECODE").val(response.FIELD_INPUTTYPE);
								$("#FORMCELL_TYPECODE_NAME").val(response.DICTIONARY_NAME);
								showProByType();
		        			}
			        		//设置最大长度
			        		if(response.FIELD_LENGTH != null && response.FIELD_LENGTH != ""){
			        			var formcell_length = response.FIELD_LENGTH + "";
			        			if(response.FIELD_DATATYPE && response.FIELD_DATATYPE.indexOf("INT") > -1 || response.FIELD_DATATYPE.indexOf("NUM") > -1
			        					|| response.FIELD_DATATYPE.indexOf("FLOAT") > -1 || response.FIELD_DATATYPE.indexOf("DOUBLE") > -1 
			        					|| response.FIELD_DATATYPE.indexOf("DECIMAL") > -1){
			        				//formcell_length = "0";
			        			}
			        			if(formcell_length.indexOf(".") > -1){
			        				formcell_length = formcell_length.substring(0,formcell_length.indexOf("."));
			        			}
			        			if(formcell_length != "0"){
			        				$("#FORMCELL_LENGTH").val(formcell_length);
			        				$("#FORMCELL_LENGTH").attr("data-validation-engine", "validate[custom[number],max[" + formcell_length + "]]");
			        			}
			        		}
							//设置是否必填
							if(response.FIELD_ISNULL=='true'){
								$("#FORMCELL_REQUIRED option[value='false']").attr("selected","selected");
							}else{
								$("#FORMCELL_REQUIRED option[value='true']").attr("selected","selected");
							}
							//设置前置描述
							$("#FORMCELL_DESCR").val(response.FIELD_NAME);
							//设置日期格式
							$("#FORMCELL_DATETYPE_SELECT option[value='"+response.FIELD_DATETYPE+"']").attr("selected","selected");
							//设置字典项
							$("#FORMCELL_DICTIONARY").val(response.FIELD_DICTIONARY);
							$("#TREE_NAME").val(response.TREE_NAME);
							//设置保留位数
							$("#FORMCELL_MEDIAN").val(response.FIELD_PRECISION);
						}
			        });
				}
			}
			/*********************** 名称元数据选择框 start ***********************/
			function openNameMeta(table_code){
				var TABLE_CODE = "";
				if("${cellMap.P_FORMCELL_ID}" != ""){
					TABLE_CODE = table_code;
				}
				var formcell_typecode = $("#FORMCELL_TYPECODE").val();
				dialog({
					id:"dialog-name-meta",
				    title: "选择名称元数据",
					url: "${ctx}/eform/formdesign/formdesign_main_desgin_choose_meta.vm?form_id=${form_id }&table_code=" + TABLE_CODE + "&callback=nameMetaCallback",
				 	width:360,
				  	height:480
				}).showModal();
			}
			function nameMetaCallback(tree){
				$("#SHOWNAME_FIELD_ID").val(tree.FIELD_ID);
				$("#SHOWNAME_FIELD_NAME").val(tree.FIELD_NAME);
				$("#SHOWNAME_FIELD_NAME").attr("title", "【" + tree.TABLE_NAME + "】.【" + tree.FIELD_NAME + "】");
				dialog.get("dialog-name-meta").close().remove();
			}
			/*********************** 名称元数据选择框 end **********************/
			
			function openDistionary(){
				if(treeDialog){
					treeDialog.close().remove();
				}
				treeDialog=dialog({
					id:"dialog-meta-muti",
				    title: "选择字典（<a href='javascript: void(0)' onclick='window.parent.openDictionaryEditDialog();'>维护</a>）",
				    url: "${ctx}/eform/tree/window.vm?sqlpackage=ths.jdp.eform.service.formdesign.designmapper&mapperid=selectDictionary&callback=dictionaryCallBack&jdpAppCode=<%=ths.jdp.core.context.PropertyConfigure.getProperty("jdp.app.code").toString()%>",
				    width:360,
				    height:480
				}).showModal();
			}
			
			function dictionaryCallBack(tree){
				var zTreeObj = document.getElementsByName('dialog-meta-muti')[0].contentWindow.zTreeObj;
				if(zTreeObj){
					var node = zTreeObj.getNodesByParam("id", tree.TREE_ID, null)[0];
					if(node && node.children == null){
						treeDialog.close().remove();
						$("#FORMCELL_DICTIONARY").val(tree.TREE_CODE);
						$("#TREE_NAME").val(tree.TREE_NAME);
					}
				}
			}
			function treeOnReady(){
				//dialog关闭时留下了空的iframe，需要删除
				$("iframe[name='dialog-meta-muti']").each(function(){
					if($(this).attr("src") == "about:blank"){
						$(this).remove();
					}
				});
				//默认展开字典根节点
				if(document.getElementsByName('dialog-meta-muti')[0] && document.getElementsByName('dialog-meta-muti')[0].contentWindow){
					var zTreeObj = document.getElementsByName('dialog-meta-muti')[0].contentWindow.zTreeObj;
					if(zTreeObj){
						var node = zTreeObj.getNodesByFilter(function (node) { return node.level == 0 }, true);
						if(node){
							zTreeObj.expandNode(node);
						}
					}
				}
			}
			
			/*选择form控件窗口*/
			function chooseFormCell(){
				dialog({
					id:"dialog-choose-formcell",
			        title: "选择控件",
			        url: "${ctx}/eform/formdesign/formdesign_main_desgin_choose_formcell.vm?formcell_type_code=" + $("#FORMCELL_TYPECODE").val(),
			        width:360,
			        height:480
			    }).showModal();
			}
			/*选择form控件回调*/
			function chooseFormCellCallback(formcell){
				if(formcell.code){
					$("#FORMCELL_TYPECODE").val(formcell.code);
					$("#FORMCELL_TYPECODE_NAME").val(formcell.name);
					showProByType();
				}
			}
			/*关闭选择form控件窗口*/
			function closeChooseFormCellDialog(){
				dialog.get("dialog-choose-formcell").close().remove();
			}
			
			function showProByType(type){
				var formcell_type = $("#FORMCELL_TYPECODE").val();
				$("#div_formcell_width").hide();//控件宽度
				$("#div_formcell_descpre").hide();//前置描述
				$("#div_formcell_height").hide();//日期类型
				$("#div_formcell_datetype").hide();//日期类型
				$("#div_formcell_length").hide();//最大长度
				$("#div_formcell_message").hide();//提示信息
				$("#div_formcell_max").hide();//最大值
				$("#div_formcell_min").hide();//最小值
				$("#div_formcell_median").hide();//保留位数
				$("#div_formcell_dictionary").hide();//字典项目
				$("#div_formcell_descrend").hide();//后置描述
				$("#div_formcell_open").hide();//弹出框高度和宽度
				
				$("#div_formcell_required").hide();//是否必填
				$("#div_formcell_validate_rules").hide();//验证规则
				$("#div_formcell_readonly").hide();//是否只读
				$("#div_formcell_def_type").hide();//默认值类型
				$("#div_formcell_def").hide();//默认值
				$("#div_table_column_num").hide();//table列数
				$("#div_table_row_init_num").hide();//table初始化行数
				$("#div_table_column_width").hide();//table列宽
				$("#div_table_primary_fieldnames").hide();//table主键列
				$("#div_table_foreign_fieldnames").hide();//table外键列
				$("#div_formcell_style").hide();//style样式，目前仅应用于LABEL
				$("#div_formcell_label_showline").hide();//是否显示线（label控件）
				$("#div_formcell_select_canedit").hide();//是否可输入（select控件）
				$("#div_formcell_title").hide();//title样式描述
				$("#div_table_hidebtncol").hide();//隐藏行操作列
				$("#div_formcell_label_align").hide();//label水平对齐方式
				$("#div_showname_filed_id").hide();//显示名称元数据
				$("#div_formcell_load_url").hide();
				
				$("#div_formcell_meta").hide();//元数据
				//分隔线、上传控件没有元数据
				if(formcell_type != 'LABEL' && formcell_type != 'FILE' && formcell_type != 'MULTIFILE' && formcell_type != 'LOADURL'){
					$("#div_formcell_meta").show();
				}else if(formcell_type == 'LABEL'){
					$("#FORMCELL_LABLEWIDTH").hide();
					$("#div_formcell_style").show();
					$("#div_formcell_label_showline").show();
					$("#div_formcell_label_align").show();
					$("#div_formcell_required").show();
					if(!type){
						$("#FIELD_ID").val("");
						$("#FIELD_NAME").val("");
						$("#FIELD_NAME").removeAttr("title");
					}
				}else if(formcell_type == 'FILE' || formcell_type == 'MULTIFILE'){
					$("#div_formcell_required").show();
					$("#div_formcell_validate_rules").show();
				}
				//清空日期控件的值
				$("#FORMCELL_DATETYPE").val("");

				//隐藏域处理
				if(formcell_type == 'INPUTHIDDEN'){
					$("#div_formcell_def_type").show();
					$("#div_formcell_def").show();
				}else{
					//如果是子表控件，显示高度设置
					if("${cellMap.P_FORMCELL_ID}" != ""){
						$("#div_formcell_width").hide();
						$("#div_table_column_width").show();
					}else{
						$("#div_formcell_width").show();
					}
					$("#div_formcell_descpre").show();
					$("#div_formcell_title").show();
				}
				
				if(formcell_type=='SELECT'||formcell_type=='RADIO'||formcell_type=='CHECKBOX'){
					$("#div_formcell_dictionary").show();
					$("#div_formcell_required").show();
					$("#div_formcell_def_type").show();
					$("#div_formcell_def").show();
					$("#div_formcell_readonly").show();
					if(formcell_type=='SELECT'){
						$("#div_formcell_validate_rules").show();
						$("#div_formcell_select_canedit").show();
					}
				}else if(formcell_type=='OPENRADIO'||formcell_type=='OPENCHECKBOX'){
					$("#div_formcell_dictionary").show();
					$("#div_formcell_open").show();
					$("#div_formcell_required").show();
					$("#div_formcell_validate_rules").show();
					$("#div_formcell_def_type").show();
					$("#div_formcell_def").show();
					$("#div_formcell_readonly").show();
					$("#div_formcell_length").show();
					$("#div_showname_filed_id").show();
				}else if(formcell_type=='AREATREE'||formcell_type=='TRADETREE'
						|| formcell_type=='RADIOUSER' || formcell_type=='CHECKBOXUSER'
						|| formcell_type=='RADIODEPT' || formcell_type=='CHECKBOXDEPT' || formcell_type=='CHECKBOXROLE'
						|| formcell_type=='CHECKBOXPOSI' || formcell_type=='CHECKBOXGROUP'){
					$("#div_formcell_open").show();
					$("#div_formcell_required").show();
					$("#div_formcell_validate_rules").show();
					$("#div_formcell_def_type").show();
					$("#div_formcell_def").show();
					$("#div_formcell_readonly").show();
					$("#div_formcell_length").show();
					$("#div_showname_filed_id").show();
				}else if(formcell_type=='INPUTNUMBER'){
					$("#div_formcell_height").show();
					$("#div_formcell_max").show();
					$("#div_formcell_min").show();
					$("#div_formcell_required").show();
					$("#div_formcell_validate_rules").show();
					$("#div_formcell_def_type").show();
					$("#div_formcell_def").show();
					$("#div_formcell_readonly").show();
					$("#div_formcell_length").show();
				}else if(formcell_type=='DATE'){
					$("#div_formcell_height").show();
					$("#div_formcell_datetype").show();
					$("#div_formcell_required").show();
					$("#div_formcell_validate_rules").show();
					$("#div_formcell_def_type").show();
					$("#div_formcell_def").show();
					$("#div_formcell_readonly").show();
					$("#FORMCELL_DATETYPE").val($("#FORMCELL_DATETYPE_SELECT").val());
				}else if(formcell_type=='INPUT'){
					$("#div_formcell_height").show();
					$("#div_formcell_length").show();//最大长度
					$("#div_formcell_height").show();
					$("#div_formcell_required").show();
					$("#div_formcell_validate_rules").show();
					$("#div_formcell_def_type").show();
					$("#div_formcell_def").show();
					$("#div_formcell_readonly").show();
				}else if(formcell_type=='TEXTAREA'){
					$("#div_formcell_length").show();//最大长度
					$("#div_formcell_height").show();
					$("#div_formcell_message").show();
					$("#div_formcell_required").show();
					$("#div_formcell_validate_rules").show();
					$("#div_formcell_def_type").show();
					$("#div_formcell_def").show();
					$("#div_formcell_readonly").show();
				}else if(formcell_type=='TABLE'){
					$("#div_table_column_num").show();
					$("#div_table_row_init_num").show();
					$("#div_table_primary_fieldnames").show();
					$("#div_table_foreign_fieldnames").show();
					$("#div_table_hidebtncol").show();
					if(!type){
						$("#FIELD_ID").val("");
						$("#FIELD_NAME").val("");
						$("#FIELD_NAME").removeAttr("title");
					}
				}else if(formcell_type=='RADIOTREE'||formcell_type=='CHECKBOXTREE'){
					$("#div_formcell_open").show();
					$("#div_formcell_required").show();
					$("#div_formcell_validate_rules").show();
					$("#div_formcell_def_type").show();
					$("#div_formcell_def").show();
					$("#div_formcell_dictionary").show();
					$("#div_formcell_readonly").show();
					$("#div_formcell_length").show();
					$("#div_showname_filed_id").show();
				}else if(formcell_type == 'LOADURL'){
					$("#div_formcell_load_url").show();
				}
				autoHeight();
			}
			
			jQuery(function($) {
				//表单验证组件初始化，详细文档请参考http://code.ciaoca.com/jquery/validation-engine/ 或官网文档http://posabsolute.github.io/jQuery-Validation-Engine/
				$("#formInfo,#tableFormInfo,#tdFormInfo,#trFormInfo").validationEngine({
					scrollOffset : 98,//必须设置，因为Toolbar position为Fixed
					promptPosition : 'bottomLeft',
					autoHidePrompt : true
				});
				$('.chosen-select').chosen({allow_single_deselect:true}); 
				showProByType(true); 
				
				//初始化popover菜单
				$('[data-rel=popover]').popover({
					content:"当前时间变量：CUR_DATE.<br/>当前用户变量：CUR_LOGINNAME.<br />表单控件关系以{id}形式",
					html:true
			    });
				
				$("#FORMCELL_HEIGHT").val($("#FORMCELL_HEIGHT").val().replace(/px/g, ""));
				
				$(".colorpick-btn").bind("click", function(){
					$(".colorpick-btn").removeClass("selected");
					$(this).addClass("selected");
					$(".btn-colorpicker").css("background-color", $(this).attr("data-color"));
					$("#FORMTD_BACKGROUND").val($(this).attr("data-color"));
				});
				
				//初始化html-codemirror
	    		var formPropStr_html = CodeMirror.fromTextArea(document.getElementById('formPropStr'), {
					mode: 'text/html',
					indentWithTabs: true,
					indentUnit: 0,
					lineNumbers: true,
					matchBrackets : true,
					autofocus: true,
					autoRefresh: true,
					foldGutter: true,
				    gutters: ["CodeMirror-linenumbers", "CodeMirror-foldgutter"],
					extraKeys: {
						"F11": function(cm) {
							cm.setOption("fullScreen", !cm.getOption("fullScreen"));
						},
						"Esc": function(cm) {
							if (cm.getOption("fullScreen")) cm.setOption("fullScreen", false);
						}
					}
				});
			  	//绑定keyup事件，设置textarea的值
	    		formPropStr_html.on('keyup', function(cm, event){
	    			//给textarea覆值（如果不覆值，serialize()获取的还是变更前的值）。
	    			$("#formPropStr").val(cm.doc.getValue());
	    			if(event.key.length == 1 && (event.key == "<" || event.key == "/")){
	    				editor_html.showHint({
	    					completeSingle: false
	    				});
	    			}
	    		});
			  	
	    		var formDetailProperty_html = CodeMirror.fromTextArea(document.getElementById('formDetailProperty'), {
					mode: 'text/html',
					indentWithTabs: true,
					indentUnit: 0,
					lineNumbers: true,
					matchBrackets : true,
					autofocus: true,
					autoRefresh: true,
					foldGutter: true,
				    gutters: ["CodeMirror-linenumbers", "CodeMirror-foldgutter"],
					extraKeys: {
						"F11": function(cm) {
							cm.setOption("fullScreen", !cm.getOption("fullScreen"));
						},
						"Esc": function(cm) {
							if (cm.getOption("fullScreen")) cm.setOption("fullScreen", false);
						}
					}
				});
			  	//绑定keyup事件，设置textarea的值
	    		formDetailProperty_html.on('keyup', function(cm, event){
	    			//给textarea覆值（如果不覆值，serialize()获取的还是变更前的值）。
	    			$("#formDetailProperty").val(cm.doc.getValue());
	    			if(event.key.length == 1 && (event.key == "<" || event.key == "/")){
	    				editor_html.showHint({
	    					completeSingle: false
	    				});
	    			}
	    		});
			});
			//检查名称元数据字段
			function checkShowNameFieldId(field, rules, i, options){
				if($("#FIELD_ID").val() == $("#SHOWNAME_FIELD_ID").val()){
					return "控件的名称元数据与元数据不能选择同一字段！";
				}
			}
		</script>
	</body>
</html>

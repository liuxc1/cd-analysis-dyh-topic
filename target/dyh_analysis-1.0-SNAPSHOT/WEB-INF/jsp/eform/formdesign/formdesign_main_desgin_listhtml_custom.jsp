<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
	<head>
		<title>列属性设置</title>
		<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
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
		<!--页面自定义的CSS，请放在这里 -->
		<style type="text/css">
			#top{
				position:fixed;
				top:30;
				left:23px;
				z-index:99;
				width:95%;
				background:#FFF;
				/* box-shadow:0px 3px 1px #d1d1d1; */
			}
			body{
				overflow: hidden;
			}
			.CodeMirror {
	    		border: 1px solid #D5D5D5;
	    		height: 100%;
	    	}
	    	.CodeMirror-fullscreen{
	    		border-top: none;
	    	}
	    	.CodeMirror-hints {
	    		z-index: 9999;
	    	}
		</style>
	</head>
	<body class="no-skin">
		<div class="main-container" id="main-container">
			<div class="main-content">
				<div class="main-content-inner padding-page-content">
					<div class="page-content">
						<div class="tabbable col-xs-12 no-padding-left no-padding-right">
				        	<ul id="myTab" class="nav nav-tabs">
				            	<li class="active">
				              		<a id="opt_cell" href="#div_cell" data-toggle="tab">列属性</a>
				            	</li>
				              	<li>
				                	<a id="opt_row" href="#div_form_list_property"  data-toggle="tab">列表页属性</a>
				                </li>
				           	</ul>
				           	<div id="tab-content" class="tab-content" >
					           	<div class="tab-pane in active" id="div_cell" style="height: 435px;">
									<div class="row">
										<div class="col-xs-12">
											<form class="form-horizontal" role="form" id="formList"
												action="#" method="post">
												<input type="hidden" name="form['FORM_ID']" value="${formId }"/>
												<input type="hidden" id="fieldIds" id="" name="form['FIELD_ID']" />
												<input type="hidden" id="fieldImages" name="form['FIELD_IMAGE']" />
												<input type="hidden" id="fieldLevels" name="form['FIELD_LEVEL']" />
												<input type="hidden" id="fieldUserOrderBys" name="form['FIELD_USERORDERBY']" />
												<input type="hidden" id="fieldWidths" name="form['FIELD_WIDTH']" />
												<input type="hidden" id="fieldQuerys" name="form['FIELD_QUERY']" />
												<input type="hidden" id="fieldTransDics" name="form['FIELD_TRANSDIC']" />
												<div id="top">
													<span style="float:left"><a href="javascript:void(0)" onclick="moveUp()">【上移】</a></span>
													<span style="float:left"><a href="javascript:void(0)" onclick="moveDown()">【下移】</a></span>
													<span style="float:left"><a href="javascript:void(0)" onclick="moveTop()">【置顶】</a></span>
													<span style="float:right;">
														<button type="button" class="btn btn-xs btn-primary btn-xs-ths" id="btnSave" data-self-js="save()">
														<i class="ace-icon fa fa-save"></i>
															保存
														</button>
													</span>
												</div>
												<div style="height: 405px; overflow: auto; margin-top:32px; width:95%; position:fixed; padding-right: 4px;">
													<table id="listTable" class="col-sm-12 table table-bordered table-hover">
														<thead>
															<tr>
																<th >
																	
																</th>
																<th class="center" >
																	列名称
																</th>
																<th class="center" >
																	列图标
																</th>
																<th class="center" >
																	显示级别
																</th>
																<th class="center" >
																	是否能排序
																</th>
																<th class="center">
																	列宽
																</th>
																<th class="center" >
																	是否为查询条件
																</th>
																<th class="center" >
																	是否进行字典转换
																</th>
															</tr>
														</thead>
														<tbody id="listBody">
															<c:forEach var="titleObj" items="${titleList}">
																<tr>
																	<input type="hidden" name="fieldId" value="${titleObj.FIELD_ID }" />
																	<td class="align-center " style="width: 50px">
																		<label class="pos-rel"> <input
																		type="radio" class="ace" name="curRadio"/> <span class="lbl"></span>
																		</label>
																	</td>
																	<td class="center" style="width:100px"><a href="javascript:void(0)" 
																	onclick="openMetaFieldEdit('${titleObj.FIELD_ID}','${titleObj.TABLE_ID}')">
																		${titleObj.FIELD_NAME }
																	</a></td>
																	<td style="width:180px" name="fieldImage">
																		<div class="input-group">
									                                        <input type="text" class="form-control" readonly="readonly" id="fieldDictionaryName"  
									                                        value="${titleObj.FIELD_IMAGE}" onclick="selectImg(this)"/>
									                                        <span class="input-group-btn">
									                                         <button type="button" class="btn btn-white btn-default" data-self-js="clearValue(this)">
													                            <i class="ace-icon fa fa-remove"></i>
													                        </button>
									                                        </span>
				                                  						 </div>  	
																	</td>
																	<td style="width:100px" name="fieldLevel">
																		<select class="form-control"  name="" onchange="changeField(this)" >
					                                       					<c:forEach items="${fieldViewLevelList}" var="fieldLevel" >
					                                       						<option  value="${fieldLevel.dictionary_code}"   <c:if test="${fieldLevel.dictionary_code==titleObj.FIELD_LEVEL }">selected</c:if>>${fieldLevel.dictionary_name}</option>
					                                       					</c:forEach>
				                                   						</select>
																	</td>
																	<td style="width:100px" name="fieldUserOrderBy">
																		<select class="form-control"  name="" onchange="changeField(this)" >
					                                       					<option  value="1" <c:if test="${titleObj.FIELD_USERORDERBY==1}">selected</c:if>>是</option>
					                                       					<option  value="0" <c:if test="${titleObj.FIELD_USERORDERBY!=1}">selected</c:if>>否</option>
				                                   						</select>
																	</td>
																	<td style="width:100px" name="fieldWidth">
																		<div class="input-group">
																			<input type="text" class="form-control" name="" value="${titleObj.FIELD_WIDTH}" data-validation-engine="validate[custom[onlyNumber]]"/>
																		</div>
																	</td>
																	<td style="width:120px" name="fieldQuery">
																		<select class="form-control"  name="" onchange="changeField(this)" >
					                                       					<option  value="1" <c:if test="${titleObj.FIELD_QUERY==1}">selected</c:if>>是</option>
					                                       					<option  value="0" <c:if test="${titleObj.FIELD_QUERY!=1}">selected</c:if>>否</option>
				                                   						</select>
																	</td>
																	<td style="width:120px" name="fieldTransDic">
																		<select class="form-control"  name="" onchange="changeField(this)" >
					                                       					<option  value="1" <c:if test="${titleObj.FIELD_TRANSDIC==1}">selected</c:if>>是</option>
					                                       					<option  value="0" <c:if test="${titleObj.FIELD_TRANSDIC!=1}">selected</c:if>>否</option>
				                                   						</select>
																	</td>
																</tr>
																</c:forEach>
														</tbody>
													</table>
												</div>
											</form>
										</div>
									</div>
								</div>
								<div class="tab-pane" id="div_form_list_property" style="height: 435px;">
									<form class="form-horizontal" id="listPropertyForm">
										<input type="hidden" name="table['JDP_EFORM_FORM'].key['FORM_ID']" value="${formId }"/>
										<div id="top">
											<span style="float:right;">
												<button type="button" class="btn btn-xs btn-primary btn-xs-ths" data-self-js="saveFromListProperty()">
												<i class="ace-icon fa fa-save"></i>
													保存
												</button>
											</span>
										</div>
										<div style="height: 405px; overflow: height; margin-top:32px; width:95%; position:fixed; padding-right: 4px;">
											<textarea id="editor_html" name="table['JDP_EFORM_FORM'].column['FORM_LIST_PROPERTY']" style="width: 100%; height: 100%; resize: none;" 
													placeholder="自定义列表toolbar的JS以及HTML代码">${jdpEformForm.formListProperty }</textarea>
										</div>
									</form>
								</div>
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
			//设置iframe自动高
			autoHeightIframe("iframeInfo");
			
			function changeField(obj){
				
			}
			
			//保存列表页属性
			function saveFromListProperty(){
				ths.submitFormAjax({
					url : '${ctx}/eform/formdesign/formdesign_main_save.vm',// any URL you want to submit
					data : $("#listPropertyForm").serialize(),
					success: function(response){
						if(response == "success"){
							dialog({
		       		            title: '提示',
		       		            content: '保存成功',
		       		            wraperstyle:'alert-info',
		       		            ok: function () {
		       		            }
		       		        }).showModal();
						}else{
							dialog({
		       		            title: '提示',
		       		            content: '保存失败',
		       		            wraperstyle:'alert-info',
		       		            ok: function () {
		       		            }
		       		        }).showModal();
						}
					}
				});
			}
			
			//保存
			function save(){
				if ($('#formList').validationEngine('validate')) {
					var _fieldIds="";
					var _fieldImages="";
					var _fieldLevels="";
					var _fieldUserOrderBys="";
					var _fieldWidths="";
					var _fieldQeurys="";
					var _fieldTransDics="";
					//处理FIELD_ID
					$("input[name='fieldId']").each(function(){
						
						_fieldIds = _fieldIds + $(this).val() + ",";
					})
					_fieldIds = _fieldIds == "" ? _fieldIds : _fieldIds.substr(0,_fieldIds.length -1 );
					$("#fieldIds").val(_fieldIds);
					//处理FIELD_IMAGE
					$("td[name='fieldImage']").each(function(){
						_fieldImages = _fieldImages + $(this).find("input").val() + ",";
					})
					_fieldImages = _fieldImages == "" ? _fieldImages : _fieldImages.substr(0,_fieldImages.length -1 );
					$("#fieldImages").val(_fieldImages);
					//处理FieldLevel
					$("td[name='fieldLevel']").each(function(){
						_fieldLevels = _fieldLevels + $(this).find("select").val() + ",";
					})
					_fieldLevels = _fieldLevels == "" ? _fieldLevels : _fieldLevels.substr(0,_fieldLevels.length -1 );
					$("#fieldLevels").val(_fieldLevels);
					//处理FIEL_USERORDERBY
					$("td[name='fieldUserOrderBy']").each(function(){
						_fieldUserOrderBys = _fieldUserOrderBys + $(this).find("select").val() + ",";
					})
					_fieldUserOrderBys = _fieldUserOrderBys == "" ? _fieldUserOrderBys : _fieldUserOrderBys.substr(0,_fieldUserOrderBys.length -1 );
					$("#fieldUserOrderBys").val(_fieldUserOrderBys);
					//处理FIEL_WIDTH
					$("td[name='fieldWidth']").each(function(){
						_fieldWidths = _fieldWidths + $(this).find("input").val() + ",";
					})
					_fieldWidths = _fieldWidths == "" ? _fieldWidths : _fieldWidths.substr(0,_fieldWidths.length -1 );
					$("#fieldWidths").val(_fieldWidths);
					//处理FIEL_QUERY
					$("td[name='fieldQuery']").each(function(){
						_fieldQeurys = _fieldQeurys + $(this).find("select").val() + ",";
					})
					_fieldQeurys = _fieldQeurys == "" ? _fieldQeurys : _fieldQeurys.substr(0,_fieldQeurys.length -1 );
					$("#fieldQuerys").val(_fieldQeurys);
					//处理FIEL_TRANSDIC
					$("td[name='fieldTransDic']").each(function(){
						_fieldTransDics = _fieldTransDics + $(this).find("select").val() + ",";
					})
					_fieldTransDics = _fieldTransDics == "" ? _fieldTransDics : _fieldTransDics.substr(0,_fieldTransDics.length -1 );
					$("#fieldTransDics").val(_fieldTransDics);
					//提交表单
					ths.submitFormAjax({
						url : '${ctx}/eform/formdesign/formListCustom_save.vm',// any URL you want to submit
						data : $("#formList").serialize(),
						type: 'post',
						dataType: 'text',
						success:function(response){
							if(response=="success"){
								dialog({
			       		            title: '提示',
			       		            content: '保存成功',
			       		            wraperstyle:'alert-info',
			       		            ok: function () {
			       		            }
			       		        }).showModal();
							}else{
								dialog({
			       		            title: '提示',
			       		            content: '保存失败',
			       		            wraperstyle:'alert-info',
			       		            ok: function () {
			       		            }
			       		        }).showModal();
							}
						}
					}); 
				}
			}
			
			//清空值方法
			function clearValue(obj){
				$(obj).closest("div.input-group").find("input").each(function(){
					$(this).val("");
				});
			}
			var curInput;
			//弹出图标选择
			function selectImg(obj){
				curInput=obj;
				dialog({
					id:"dialog-eform-icons",
		            title: '列图标选择',
		            url: '${ctx}/common/icons/selIcon.html',
		            width:600,
		            height:400>document.documentElement.clientHeight?document.documentElement.clientHeight:400
		        }).showModal();
			}
			
			//跳转到元数据编辑页面
			function openMetaFieldEdit(_fieldId,_tableId){
				dialog({
					id:"dialog-eform-field-edit",
		            title: '元数据编辑',
		            url: '${ctx}/eform/meta/definition/meta_field_edit.vm?fieldId='+_fieldId+'&tableId='+_tableId,
		            width:800,
		            height:450>document.documentElement.clientHeight?document.documentElement.clientHeight:450
		        }).showModal();
			}
			//选择图标回调
			function iconSelectCallBack(selIcon){
				$(curInput).val(selIcon.substr(3));
			}
			//选择图标关闭回调
			function closeSelecticonDialog() {
				dialog.get("dialog-eform-icons").close().remove(); 
			}
			var curTr;
			//上移
			function moveUp(){
				curTr=$("input[type='radio']:checked").closest("tr");
				curTr.prev().before(curTr);
			}
			//下移
			function moveDown(){
				curTr=$("input[type='radio']:checked").closest("tr");
				curTr.next().after(curTr);
			}
			//置顶
			function moveTop(){
				curTr=$("input[type='radio']:checked").closest("tr");
				curTr.prependTo("#listBody");
			}
			
			jQuery(function($){
				//初始化表格的事件，如表头排序，列操作等
				__doInitTableEvent("listTable");
				
				$.validationEngineLanguage.allRules.onlyNumber= {
						 "regex": /^[1-9][0-9]*(px|%)$/,
		                 "alertText": "* 只能填写数字,<br>并且需要以%或者px结尾"
			 	};
				
				//表单验证组件初始化，详细文档请参考http://code.ciaoca.com/jquery/validation-engine/ 或官网文档http://posabsolute.github.io/jQuery-Validation-Engine/
				$("#formList").validationEngine({
					scrollOffset : 98,//必须设置，因为Toolbar position为Fixed
					promptPosition : 'bottomLeft',
					autoHidePrompt : true
				});
				
				//初始化html-codemirror
	    		editor_html = CodeMirror.fromTextArea(document.getElementById('editor_html'), {
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
	    		editor_html.on('keyup', function(cm, event){
	    			//给textarea覆值（如果不覆值，serialize()获取的还是变更前的值）。
	    			$("#editor_html").val(cm.doc.getValue());
	    			if(event.key.length == 1 && (event.key == "<" || event.key == "/")){
	    				editor_html.showHint({
	    					completeSingle: false
	    				});
	    			}
	    		});
			});
		</script>
	</body>
</html>

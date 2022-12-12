<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
	<head>
	    <title>控件属性</title>
		<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
		<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
	</head>
	<body>
		<div class="main-container" id="main-container">
    		<div class="main-content">
        		<div class="main-content-inner padding-page-content">
                	<div class="col-xs-12 no-padding">
                        <div class="widget-box transparent" style="margin-top: 0px;">
                            <div class="widget-header">
                                <div class="widget-toolbar no-border ">
                                    <button type="button" class="btn btn-xs btn-primary btn-xs-ths" id="btnOk">
										<i class="ace-icon fa fa-plus"></i> 确定
									</button>
									<button type="button" class="btn btn-xs btn-danger btn-xs-ths" id="btnCancel">
										<i class="ace-icon fa fa-remove"></i> 取消
									</button>
                                </div>
                            </div>
                            <div class="space-4"></div>
                            <div class="" style="margin-right: -1px;overflow: auto">
                                <div class="profile-user-info profile-user-info-striped">
									<div class="profile-info-row">
										<div class="profile-info-name">原生控件：</div>
										<div class="profile-info-value" style="padding: 2px;">
											<table class="table table-bordered table-hover">
												<tbody>
													<c:forEach var="formcell" items="${dictionarys_map.FORMCELL_TYPE_NATIVE}"  varStatus="status">
														<c:if test="${status.index % 3 == 0}">
															<c:set var="startIndex" value="${status.index }"></c:set>
															<tr>
														</c:if>
														<td class="left" style="width: 33.333%;">
															<label ondblclick="chooseSubmit();">
																<input name="form-field-radio" type="radio" class="ace" value="${formcell.dictionary_code }" 
																		text="${formcell.dictionary_name }"
																		<c:if test="${formcell_type_code == formcell.dictionary_code }">checked="checked"</c:if> />
																<span class="lbl"> ${formcell.dictionary_name }</span>
															</label>
														</td>
														<c:if test="${status.last && status.count % 3 != 0 }">
															<c:forEach begin="1" end="${3 - status.count % 3}" step="1">
																<td class="left" style="width: 33.333%;">&nbsp;</td>
															</c:forEach>
														</c:if>
														<c:if test="${startIndex + 3 == status.index }">
															</tr>
														</c:if>
													</c:forEach> 
												</tbody>
											</table>
										</div>
									</div>
									<div class="profile-info-row">
										<div class="profile-info-name">扩展控件：</div>
										<div class="profile-info-value" style="padding: 2px;">
											<table class="table table-bordered table-hover">
												<tbody>
													<c:forEach var="formcell" items="${dictionarys_map.FORMCELL_TYPE_EXTEND}"  varStatus="status">
														<c:if test="${status.index % 3 == 0}">
															<c:set var="startIndex" value="${status.index }"></c:set>
															<tr>
														</c:if>
														<td class="left" style="width: 33.333%;">
															<label ondblclick="chooseSubmit();">
																<input name="form-field-radio" type="radio" class="ace" value="${formcell.dictionary_code }" 
																		text="${formcell.dictionary_name }"
																		<c:if test="${formcell_type_code == formcell.dictionary_code }">checked="checked"</c:if> />
																<span class="lbl"> ${formcell.dictionary_name }</span>
															</label>
														</td>
														<c:if test="${status.last && status.count % 3 != 0 }">
															<c:forEach begin="1" end="${3 - status.count % 3}" step="1">
																<td class="left" style="width: 33.333%;">&nbsp;</td>
															</c:forEach>
														</c:if>
														<c:if test="${startIndex + 3 == status.index }">
															</tr>
														</c:if>
													</c:forEach>
												</tbody>
											</table>
										</div>
									</div>
								</div>
	                        </div>
						</div>
	    			</div>
		        </div><!--/.main-content-inner-->
		    </div><!-- /.main-content -->
		</div><!-- /.main-container -->
		<script type="text/javascript">
			function chooseSubmit(){
				if(window.parent && window.parent.chooseFormCellCallback){
					var formcell = {};
					formcell.code = $('input:radio[name="form-field-radio"]:checked').val();
					formcell.name = $('input:radio[name="form-field-radio"]:checked').attr("text");
					window.parent.chooseFormCellCallback(formcell);
				}
	            if(window.parent.closeChooseFormCellDialog) {
	                window.parent.closeChooseFormCellDialog();
	            }
			}
		
			jQuery(function($){
				//确认按钮click事件
				$("#btnOk").on(ace.click_event,function () {
					chooseSubmit();
		        });
				//取消按钮click事件
		        $("#btnCancel").on(ace.click_event,function () {
		            if(window.parent.closeChooseFormCellDialog) {
		                window.parent.closeChooseFormCellDialog();
		            }
		        });
			});
		</script>
	</body>
</html>

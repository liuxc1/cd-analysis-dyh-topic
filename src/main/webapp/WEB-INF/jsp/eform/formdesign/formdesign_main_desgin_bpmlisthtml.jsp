<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
	<head>
		<title>数据表列表</title>
		<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
		<script type="text/javascript" src="${ctx}/assets/js/eform/eform_custom.js"></script>
		<!--页面自定义的CSS，请放在这里 -->
		<style type="text/css">
		</style>
	</head>
	<body class="no-skin">
		<div class="main-container" id="main-container">
			<div class="main-content">
				<div class="main-content-inner fixed-page-header" style="display: none;">
		            <div id="breadcrumbs" class="breadcrumbs">
		                <ul class="breadcrumb">
		                    <li class="active">
		                        <h5 class="page-title" >
		                            <i class="fa fa-file-text-o"></i>
									列表
		                        </h5>
		                    </li>
		                </ul><!-- /.breadcrumb -->
		            </div>
		        </div>
				<div class="main-content-inner padding-page-content">
					<div class="page-content">
						<div class="space-4"></div>
						<div class="row">
							<div class="col-xs-12">
								<form class="form-horizontal" role="form" id="formList"
									action="#" method="post">
									<input name="showDesign" type="hidden" value="${showDesign}" />
									<c:if test='${hideQuery == null || hideQuery != "true"}'>
										<c:set var="isBpmListHtml" value="true"></c:set>
										<%@ include file="/WEB-INF/jsp/eform/formdesign/formdesign_main_desgin_list_queryhtml.jsp"%>
									</c:if>
									<%@ include file="toolbar/listhtml_bpm_btn_toolbar.jsp" %>
									<div style="width: 100%; max-width: 100%; overflow: auto;">
										<table id="listTable" class="table table-bordered table-hover">
											<thead>
												<tr>
													<c:if test='${onlyView == null || onlyView != "true" }'>
													<th class="center" style="width: 30px">
														<label class="pos-rel"> 
															<input type="checkbox" class="ace" />
															<span class="lbl"></span>
														</label>
													</th>
													</c:if>
													<c:forEach var="titleObj" items="${titleList}">
														<c:if test="${titleObj.FIELD_LEVEL!='0'}">
															<th  
																<c:if test="${titleObj.FIELD_USERORDERBY=='1'}">
																	data-sort-col="${titleObj.FIELD_CODE}"
																</c:if>
																<c:if test="${titleObj.FIELD_LEVEL=='1'}">
																	class="hidden-sm hidden-xs"
																</c:if>
																style="<c:choose><c:when test='${empty titleObj.FIELD_WIDTH}'></c:when><c:when test='${fn:contains(titleObj.FIELD_WIDTH, \"%\")}'>width:${titleObj.FIELD_WIDTH};min-width:150px;</c:when><c:when test='${fn:contains(titleObj.FIELD_WIDTH, \"px\")}'>width:${titleObj.FIELD_WIDTH};min-width:${titleObj.FIELD_WIDTH};</c:when><c:otherwise>width:${titleObj.FIELD_WIDTH}px;min-width:${titleObj.FIELD_WIDTH}px;</c:otherwise></c:choose>">
																<c:if test="${titleObj.FIELD_IMAGE!=''}">
																	<i class="ace-icon fa ${titleObj.FIELD_IMAGE}"></i> <!--列标题图片-->
																</c:if>
																	${titleObj.FIELD_NAME} 
																<c:if test="${titleObj.FIELD_USERORDERBY=='1'}">
																	<i class="ace-icon fa fa-sort pull-right"></i>  <!--用户是否可以排序-->
																</c:if>
															</th>
														</c:if>
													</c:forEach>
													<th class="align-center " style="width: 80px">
													<i class="ace-icon fa fa-wrench"></i> 操作</th>
												</tr>
											</thead>
											<tbody>
												<c:forEach var="item" items="${pageInfo.list}">
													<tr>
														<c:if test='${onlyView == null || onlyView != "true" }'>
														<td class="center">
															<label class="pos-rel"> 
																<input type="checkbox" class="ace" value="${item[mainPkColumn] }" /> 
																<span class="lbl"></span>
															</label>
														</td>
														</c:if>
														<c:forEach var="titleObj" items="${titleList}">
															<c:if test="${titleObj.FIELD_LEVEL!='0'}">
																<td 
																	<c:if test="${titleObj.FIELD_LEVEL=='1'}">
																		class="hidden-sm hidden-xs"
																	</c:if>
																	style="<c:if test='${not empty titleObj.FIELD_WIDTH}'>width:${titleObj.FIELD_WIDTH}</c:if>"
																 >
																<c:set var="fieldCodeThsName" value="${titleObj.FIELD_CODE }_THSNAME"></c:set>
																${item[fieldCodeThsName] == null ? item[titleObj.FIELD_CODE] : item[fieldCodeThsName] }
																</td>
															</c:if>
														</c:forEach>
														<td class=" align-center col-op-ths">
															<c:if test="${form.HANDLE_STATE == null || form.HANDLE_STATE=='V_JDP_BPM_TODO_TASKS'}">
																<button type="button"
																	class="btn btn-sm btn-default btn-white btn-op-ths"
																	title="编辑" data-self-js="doEdit('${item[mainPkColumn]}','${item.TASK_ID_ }')">
																	<i class="ace-icon fa fa-edit"></i>
																</button>
															</c:if>
															<c:if test="${form.HANDLE_STATE=='V_JDP_BPM_DONE_TASKS'}">
																<button type="button"
																	class="btn btn-sm btn-default btn-white btn-op-ths"
																	title="查看" data-self-js="doEdit('${item[mainPkColumn]}','${item.TASK_ID_ }')">
																	<i class="ace-icon fa fa-eye"></i>
																</button>
															</c:if>
															
														</td>
													</tr>
												</c:forEach>
											</tbody>
										</table>
									</div>
									<%@ include file="/WEB-INF/jsp/_common/paging.jsp"%>
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
			//设置iframe自动高
			autoHeightIframe("iframeInfo");
			
			//搜索
			function doSearch(){
				if( typeof(arguments[0]) != "undefined" && arguments[0] == true)
					$("#pageNum").val(1);
				$("#orderBy").closest("form").submit();
			}
			
			jQuery(function($){
				//初始化表格的事件，如表头排序，列操作等
				__doInitTableEvent("listTable");
			});
		</script>
	</body>
</html>

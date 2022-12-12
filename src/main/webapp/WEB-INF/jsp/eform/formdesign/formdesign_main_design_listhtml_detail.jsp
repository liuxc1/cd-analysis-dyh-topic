<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
	<head>
		<title>详情页</title>
		<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
		<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
		<!--页面自定义的CSS，请放在这里 -->
		<style type="text/css">
			.formcell-label {
				text-align: center;
				position: relative;
				z-index: 1;
				padding-left: 12px;
				padding-right: 12px;
			}
			
			.formcell-label :first-child {
				display: inline-block;
				background: #fafafa;
				line-height: 36px;
				font-size: 13px;
			}
			.formcell-label :nth-child(2){
				display: block;
				position: absolute;
				z-index: -1;
				top: 50%;
				left: 12px;
				right: 12px;
				border-top: 1px solid #eeeeee;
			}
			.page-toolbar{
				padding-left: 0px !important;
				padding-right: 0px !important;
			}
		</style>
		<script type="text/javascript">
			$(function(){
				//加载附件
				$('[formcell_type="FILE"]').each(function(){
					var _this_file = $(this);
					var inputFileId = _this_file.attr("id");
					if(inputFileId != null && inputFileId.indexOf("_row_") > -1){
						inputFileId = inputFileId.substring(0, inputFileId.indexOf("_row_")) + "_row";
					}
					var data = {'businessKey': '${businessKey}', inputFileId: inputFileId};
					if(_this_file.attr("subBusinessKey") != null){
						data.subBusinessKey = _this_file.attr("subBusinessKey");
					}
					$.ajax({
	            		url: ctx + '/eform/formdesign/formdesign_main_filelist.vm',
	            		data: data,
	            		dataType: 'json',
	            		type: 'post',
	            		success: function(response){
	            			if(response.length > 0){
	            				for(var i = 0; i < response.length; i++){
	            					_this_file.append("<div class=\"tag\">" + response[i].FILE_NAME + "<button type=\"button\" class=\"close\" onclick=\"jdp_eform_downFile(this, '" + response[i].FILE_ID + "');\"><i class=\"ace-icon fa fa-download green smaller-70\"></i></button></div>");
	            				}
	            			}
	            		}
	            	});
				});
			});
			
			//文件下载
			function jdp_eform_downFile(obj, fileId){
				var form = $("#exportForm");
				$("#fileId").val(fileId);
				form.submit();
			}
			
			function goBack() {
				parent.doSearch();
			}
		</script>
	</head>
	<body>
		<div class="main-container" id="main-container">
		    <div class="main-content">
		    	<div class="main-content-inner fixed-page-header" style="display: none;">
		            <div id="breadcrumbs" class="breadcrumbs">
		                <ul class="breadcrumb">
		                    <li class="active">
		                        <h5 class="page-title" >
		                            <i class="fa fa-file-text-o"></i>
									详情页
		                        </h5>
		                    </li>
		                </ul><!-- /.breadcrumb -->
		            </div>
		        </div>
		        <div class="main-content-inner padding-page-content">
		            <div class="page-content">
		            	<c:if test='${onlyView == null || onlyView != "true" }'>
					  		<div class="page-toolbar align-right">
				                <button type="button" class="btn btn-xs btn-danger btn-xs-ths" id="btnReturn" onclick="goBack()">
				                    <i class="ace-icon fa fa-reply"></i>返回
				                </button>
								<div class="space-2"></div>
								<hr class="no-margin">
				            </div>
				        </c:if>
		            	<form action="${ctx}/eform/formdesign/formdesign_main_exportfile.vm" style="display: none;" target="" method="post" id="exportForm">
							<input type="hidden" name="fileId" id="fileId"/>
						</form>
						<table width="100%" cellpadding="5" cellspacing="0" class="form-table-info">
			                <tbody>
		                		<tr style="visibility: hidden;">
		                			<c:forEach begin="1" end="144" step="1" varStatus="status">
		                				<td style="width:0.00694%; height: 5px; padding: 0px; border: 0px;">&nbsp;</td>
		                			</c:forEach>
			                	</tr>
			                	<c:forEach var="row" items="${rows }" varStatus="rowStatus">
			                		<c:set var="total_width" value="0"></c:set>
			                		<tr>
					                	<c:forEach var="column" items="${row.FORMCELLS }" varStatus="columnStatus">
					                		<c:set var="total_width" value="${total_width == null ? column.FORMCELL_WIDTH : column.FORMCELL_WIDTH + total_width }"></c:set>
					                		<c:choose>
						            			<c:when test='${column.FORMCELL_TYPECODE == "LABEL" }'>
						            				<td colspan="${column.FORMCELL_WIDTH * 12 }" style="width: 0%; background: #fafafa;" id="${column.FORMCELL_ID }">
						            					<div class="formcell-label" <c:if test='${column.FORMCELL_STYLE != null && column.FORMCELL_STYLE != ""}'>style="${column.FORMCELL_STYLE }"</c:if>>
															<span class="bigger-110">${column.FORMCELL_DESCR }</span>
															<div <c:if test='${column.FORMCELL_LABEL_SHOWLINE == "false" }'>style="display: none;"</c:if>></div>
														</div>
						            				</td>
						            			</c:when>
						            			<c:when test='${column.FORMCELL_TYPECODE == "TABLE" }'>
						            				<c:if test="${column.FORMCELL_LABLEWIDTH > 0 }">
								           				<td colspan="${column.FORMCELL_WIDTH / 12 * column.FORMCELL_LABLEWIDTH * 12 }" style="width: 0%; background: #fafafa; color: #2b7dbc; text-align: right; padding-right: 10px;" id="${column.FORMCELL_ID }_DESCR">${column.FORMCELL_DESCR }</td>
										           	</c:if>
						                			<td colspan="${(column.FORMCELL_WIDTH - (column.FORMCELL_WIDTH / 12 * column.FORMCELL_LABLEWIDTH)) * 12  }" style="width: 0%; background: #FFFFFF; color: #555555; padding: 0px;" id="${column.FORMCELL_ID }">
						                				<table width="100%" cellpadding="5" cellspacing="0">
						                					<tr>
						                						<c:forEach var="table_column" items="${column.FORMCELLS }" varStatus="tableColumnStatus">
						                							<c:if test='${table_column.FORMCELL_TYPECODE != "INPUTHIDDEN" }'>
						                								<td style="width: <fmt:formatNumber value="${100 / fn:length(column.FORMCELLS) }" pattern="#.##"/>%; background: #fafafa; color: #2b7dbc; text-align: center; border-top: 0px; border-bottom: 0px; <c:if test="${tableColumnStatus.first }">border-left: 0px;</c:if> <c:if test="${tableColumnStatus.last }">border-right: 0px;</c:if>">${table_column.FORMCELL_DESCR }</td>
						                							</c:if>
						                						</c:forEach>
						                					</tr>
						                					<c:set var="tableName" value="${column.TABLE_SCHEMA }.${column.TABLE_CODE }"></c:set>
						                					<c:forEach var="data" items="${multirowtable[tableName].row }" varStatus="dataStatus">
						                						<tr>
						                							<c:forEach var="table_column" items="${column.FORMCELLS }" varStatus="tableColumnStatus">
						                								<c:if test='${table_column.FORMCELL_TYPECODE != "INPUTHIDDEN" }'>
								                							<td style="width: <fmt:formatNumber value="${100 / fn:length(column.FORMCELLS) }" pattern="#.##"/>%; background: #ffffff; color: #555555; text-align: left; <c:if test="${tableColumnStatus.first }">border-left: 0px;</c:if> <c:if test="${dataStatus.last == true }">border-bottom: 0px;</c:if>">
									                							<c:if test='${table_column.FORMCELL_TYPECODE == "FILE" }'>
														          					<div class="tags" style="width: 100%; border: 0px;" formcell_type="${table_column.FORMCELL_TYPECODE}" id="${table_column.FORMCELL_ID}_row_${dataStatus.index}"
														          							subBusinessKey="${data.column[column.PRIMARY_FIELD_CODE] }">
														           						
														           					</div>
														           				</c:if>
														           				<c:set var="fieldCodeThsName" value="${table_column.FIELD_CODE }_THSNAME"></c:set>
																				${data.column[fieldCodeThsName] == null ? data.column[table_column.FIELD_CODE] : data.column[fieldCodeThsName] }
								                							</td>
							                							</c:if>
							                						</c:forEach>
						                						</tr>
						                					</c:forEach>
						                				</table>
						                			</td>
						            			</c:when>
						               			<c:otherwise>
								           			<c:if test="${column.FORMCELL_LABLEWIDTH > 0 }">
								           				<td colspan="${column.FORMCELL_WIDTH / 12 * column.FORMCELL_LABLEWIDTH * 12 }" style="width: 0%; background: #fafafa; color: #2b7dbc; text-align: right; padding-right: 10px;" id="${column.FORMCELL_ID }_DESCR">${column.FORMCELL_DESCR }</td>
										           	</c:if>
										           	<td colspan="${(column.FORMCELL_WIDTH - (column.FORMCELL_WIDTH / 12 * column.FORMCELL_LABLEWIDTH)) * 12 }" style="width: 0%; background: #FFFFFF; color: #555555; text-align: left;" id="${column.FORMCELL_ID }">
										           		<c:if test='${column.FORMCELL_TYPECODE == "FILE" }'>
									           				<div class="tags" style="width: 100%; border: 0px;" formcell_type="${column.FORMCELL_TYPECODE}" id="${column.FORMCELL_ID}">
									                						
									           				</div>
									           			</c:if>
									           			<c:set var="tableName" value="${column.TABLE_SCHEMA }.${column.TABLE_CODE }"></c:set>
									           			<c:set var="fieldCodeThsName" value="${column.FIELD_CODE }_THSNAME"></c:set>
										           		${table[tableName].column[fieldCodeThsName] == null ? table[tableName].column[column.FIELD_CODE] : table[tableName].column[fieldCodeThsName]}
										           	</td>
								           		</c:otherwise>
							            	</c:choose>
					                	</c:forEach>
					                	<c:if test="${total_width < 12 }">
					                		<td colspan="${(12 - total_width) * 12 }" style="width:0%; background: #fafafa;">&nbsp;</td>
					                	</c:if>
				                	</tr>
			                	</c:forEach>
			                </tbody>
			            </table>
		        	</div>
		        </div><!--/.main-content-inner-->
		    </div><!-- /.main-content -->
		</div><!-- /.main-container -->
		${jdpEformForm.formDetailProperty }
	</body>
</html>
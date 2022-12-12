<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
<head>
    <title>项目费用</title>
	<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
  	<!--页面自定义的CSS，请放在这里 -->
    <style type="text/css">

    </style>
</head>

<body class="no-skin">

<div class="main-container" id="main-container">
    <div class="main-content">
        <div class="main-content-inner fixed-page-header fixed-40">
            <div id="breadcrumbs" class="breadcrumbs">
				<ul class="breadcrumb">
					<li class="active">
						<h5 class="page-title" >
							<i class="fa fa-file-o"></i>
							${THS_JDP_RES_DESC }
						</h5>
					</li>
				</ul><!-- /.breadcrumb -->

            </div>
        </div>
        <div class="main-content-inner padding-page-content">
            <div class="page-content">
            	<div class="page-content-new">
		            <div class="page-toolbar align-right form-group">
		            	<p class="title" style="display:none;">查看</p>
		                <button type="button" class="btn btn-info"  data-self-js="goBack()">
		                    <i class="ace-icon fa fa-reply"></i>
		                    返回
		                </button>
		            </div>
                <table width="100%" cellpadding="5" cellspacing="0" class="form-table-info">
                	<tr>
                		<td >项目名称</td>
                		<td >${form.PRO_NAME}</td>
                		<td >项目类型</td>
                		<td >${form.DICT_NAME}</td>
                	</tr>
                	<tr>
                		<td>合同名称</td>
                		<td colspan="3">${form.CONTRACT_NAME}</td>
                	</tr>
                	<tr>
                		<td>签署日期</td>
                		<td><fmt:formatDate value="${form.SIGN_DATE}" type="date" pattern="yyyy-MM-dd"/> </td>
                		<td>项目状态</td>
                		<td> 
                			<c:if test="${form.PRO_STATUS==1}">
                                  <span class="label label-sm label-success arrowed-in-right min-width-75">
                                          <i class="ace-icon fa fa-info-circle"></i>
                                          在行 </span>
                                  </c:if>
                                  <c:if test="${form.PRO_STATUS==0}">
                                  <span class="label label-sm label-info arrowed-in-right min-width-75">
                                          <i class="ace-icon fa fa-check-circle"></i>
                                          竣工 </span>
                                  </c:if>
                           </td>
                	</tr>
                	<tr>
                		<td>项目经费(元)</td>
                		<td><fmt:formatNumber value="${form.PRO_FEE}" pattern="##.##" minFractionDigits="2" /></td>
                		<td>项目经理</td>
                		<td>${form.MANAGER}</td>
                	</tr>
                	<tr>
                		<td>所属部门</td>
                		<td>${form.DEPT_NAME}</td>
                		<td></td>
                		<td></td>
                	</tr>
                	<tr>
                		<td>干系人</td>
                		<td colspan="3">${form.DEPT_MANAGER}</td>
                	</tr>
                	<tr>
                		<td>项目描述</td>
                		<td colspan="3">${form.PRO_DESC}</td>
                	</tr>
                </table>
               </div>
        		</div>
        </div><!--/.main-content-inner-->
    </div><!-- /.main-content -->
</div><!-- /.main-container -->

<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>

<!-- 自己写的JS，请放在这里 -->
<script type="text/javascript">

	//返回
	function goBack() {
	    $("#main-container",window.parent.document).show();
	    $("#iframeInfo",window.parent.document).attr("src","#").hide();
	}
	
	jQuery(function ($) {
	    
	});
</script>
</body>
</html>

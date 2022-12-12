<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>月趋势预报</title>
<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
<link rel="stylesheet" href="${ctx}/assets/components/bootstrap-select/dist/css/bootstrap-select.min.css?v=20221129015223" />
<!-- 分析平台-文件上传表格组件-样式文件 -->
<link href="${ctx }/assets/custom/components/analysis/css/file-upload-table.css?v=20221129015223" rel="stylesheet" />
<style type="text/css">
table {
	border-spacing: 0;
	border-collapse: collapse;
}

td, th, caption {
	padding: 0;
}

.w-table {
	width: 100%;
}

.w-table td {
	padding: 8px;
}

.w-table td, .w-table th {
	border: 1px solid rgb(221, 221, 221);
	height: 35px;
	text-align: center;
}

.w-table thead th, .w-table thead td, .w-table tbody th {
	background-color: #F2F2F2;
}

.w-table tr.even td {
	background-color: rgb(241, 241, 241);
}

.w-table a {
	color: rgb(42, 151, 253);
}

.w-editable {
	padding-right: 15px;
	line-height: 18px;
	position: relative;
}

.w-input {
	line-height: 28px;
	box-sizing: content-box;
	height: 28px;
	width: 140px;
	padding: 0 2px 0 6px !important;
	border: 1px solid rgb(151, 151, 151);
	font-size: 12px;
}

.w-input.aqi-min, .w-input.aqi-max {
	width: 60px;
	text-align: center;
}

#forecastValueTbody td {
	padding: 8px;
	height: 35px;
}

.weather_trend_edit span {
	display: inline-block;
	width: 95%;
	height: 35px;
	line-height: 35px;
	text-align: left;
	overflow: hidden;
	white-space: nowrap;
	text-overflow: ellipsis;
}

.dropdown-toggle, .dropdown-toggle:hover, .dropdown-toggle:focus, .open>.btn.dropdown-toggle {
	background-color: #ffffff !important;
	border: 1px solid #D5D5D5;
	color: #858585 !important;
	border-width: 1px !important;
}
</style>
</head>

<body class="no-skin">
	<div class="main-container" id="main-container" v-cloak>
		<div class="main-content">
			<div class="main-content-inner fixed-page-header fixed-40">
				<div id="breadcrumbs" class="breadcrumbs">
					<ul class="breadcrumb">
						<li class="active">
							<h5 v-if="reportId" class="page-title">
								<i class="header-icon fa fa-edit"></i> 月趋势预报-编辑
							</h5>
							<h5 v-if="!reportId" class="page-title">
								<i class="header-icon fa fa-plus"></i> 月趋势预报-添加
							</h5>
						</li>
					</ul>
					<div class="btn-toolbar pull-right" role="toolbar" style="padding-top: 7px;">
						<a class="btn btn-xs btn-primary btn-xs-ths" @click="templateDownload()"> <i class="ace-icon fa fa-cloud-download"></i> 模板下载
						</a>
						<button type="button" class="btn btn-xs btn-danger btn-xs-ths" @click="importData()">
							<i class="ace-icon fa fa-cloud-upload"></i> 数据导入
						</button>

						<button type="button" class="btn btn-xs btn-xs-ths" @click="saveData('UPLOAD');">
							<i class="ace-icon fa fa-upload"></i></i> 提交
						</button>
						<button type="button" class="btn btn-xs btn-xs-ths" @click="saveData('TEMP');">
							<i class="ace-icon fa fa-save"></i> 暂存
						</button>
						<%-- 					<c:if test="${isShowReturn ==null }"> --%>
						<button type="button" class="btn btn-xs btn-xs-ths btn-danger" @click="cancel()">
							<i class="ace-icon fa fa-reply"></i> 返回
						</button>
						<%-- 					</c:if> --%>
					</div>
				</div>
			</div>
			<div class="main-content-inner">
				<div class="page-content">
					<form id="mainForm" class="form-horizontal" role="form" id="formList" method="post">
						<input type="hidden" name="reportId" value="${reportId}" id="reportId">
						<div class="row">
							<div class="col-xs-12 text-center" style="margin-top: 10px; padding-left: 5%; padding-right: 5%">
								<div v-if="!reportId" class="text-left col-xs-2 no-padding-left">
									<label><i class="ace-icon fa fa-asterisk red smaller-70"></i> 填报日期：</label>
									<div  class="input-group" id="divDate" @click="wdatePicker">
										<input type="text" id="txtDateStart" class="form-control" :value="resultData.FORECAST_TIME" name="datetime" readonly="readonly"> <span class="input-group-btn">
											<button type="button" class="btn btn-white btn-default" id="btnDateStart" readonly="readonly">
												<i class="ace-icon fa fa-calendar"></i>
											</button>
										</span>
									</div>
								</div>
								<div v-if="reportId" class="text-left col-xs-2 no-padding-left">
									<label> 填报日期：{{resultData.FORECAST_TIME}}</label>
									
								</div>
							</div>
							<div class="col-xs-12 text-center" style="margin-top: 10px; padding-left: 5%; padding-right: 5%">
								<div class="text-left">
									<label> <i class="ace-icon fa fa-asterisk red smaller-70"></i> 月趋势预报名称：
									</label> <input maxlength="40" class="form-control" placeholder="请输入月趋势预报名称，最多40个字符" data-validation-engine="validate[required,maxSize[40]]" name="inscribe" v-model="resultData.MONTHTREND_NAME" style="width: 100%;" />
								</div>
							</div>
							<div class="col-xs-12 text-center" style="margin-top: 10px; padding-left: 5%; padding-right: 5%">
								<div class="text-left">重要提示：</div>
								<textarea maxlength="1000" class="form-control " data-validation-engine="validate[maxSize[1000]]" placeholder="请输入重要提示信息，最多1000个字符" name="important_hints" v-model="resultData.HINT" style="width: 100%; height: 150px; margin: 5px auto; resize: none;"></textarea>
							</div>
							<div class="col-xs-12 text-center" style="margin-top: 10px; padding-left: 5%; padding-right: 5%;">
								<div class="text-left" style="margin-bottom: 5px;">月趋势预报：</div>
								<table class="w-table">
									<thead>
										<tr>
											<th style="width: 13%;">预报日期</th>
											<th style="width: 10%;">等级1</th>
											<th style="width: 10%;">等级2</th>
											<th style="width: 13%;">预报日期</th>
											<th style="width: 10%;">等级1</th>
											<th style="width: 10%;">等级2</th>
											<th style="width: 13%;">预报日期</th>
											<th style="width: 10%;">等级1</th>
											<th style="width: 10%;">等级2</th>
										</tr>
									</thead>
									<tbody>
										<tr v-for="(item, index) in forecastValueList">
											<td>{{item.RESULT_TIME1}}</td>
											<td><select class="form-control" v-if="item.RESULT_TIME1" v-model="item.LEVEL1" data-validation-engine="validate[required, funcCall[ckeck]]">
													<option value="" selected="selected">--请选择--</option>
													<option value="优">优</option>
													<option value="良">良</option>
													<option value="轻度污染">轻度污染</option>
													<option value="中度污染">中度污染</option>
													<option value="重度污染">重度污染</option>
													<option value="严重污染">严重污染</option>
											</select></td>
											<td><select class="form-control" v-if="item.RESULT_TIME1" v-model="item.LEVEL2" data-validation-engine="validate[required, funcCall[ckeck]]">
													<option value="">--请选择--</option>
													<option value="优">优</option>
													<option value="良">良</option>
													<option value="轻度污染">轻度污染</option>
													<option value="中度污染">中度污染</option>
													<option value="重度污染">重度污染</option>
													<option value="严重污染">严重污染</option>
											</select></td>

											<td>{{item.RESULT_TIME2}}</td>
											<td><select class="form-control" v-if="item.RESULT_TIME2" v-model="item.LEVEL3" data-validation-engine="validate[required, funcCall[ckeck]]">
													<option value="">--请选择--</option>
													<option value="优">优</option>
													<option value="良">良</option>
													<option value="轻度污染">轻度污染</option>
													<option value="中度污染">中度污染</option>
													<option value="重度污染">重度污染</option>
													<option value="严重污染">严重污染</option>
											</select></td>
											<td><select class="form-control" v-if="item.RESULT_TIME2" v-model="item.LEVEL4" data-validation-engine="validate[required, funcCall[ckeck]]">
													<option value="">--请选择</option>
													<option value="优">优</option>
													<option value="良">良</option>
													<option value="轻度污染">轻度污染</option>
													<option value="中度污染">中度污染</option>
													<option value="重度污染">重度污染</option>
													<option value="严重污染">严重污染</option>
											</select></td>

											<td>{{item.RESULT_TIME3}}</td>
											<td><select class="form-control" v-if="item.RESULT_TIME3" v-model="item.LEVEL5" data-validation-engine="validate[required, funcCall[ckeck]]">
													<option value="">--请选择--</option>
													<option value="优">优</option>
													<option value="良">良</option>
													<option value="轻度污染">轻度污染</option>
													<option value="中度污染">中度污染</option>
													<option value="重度污染">重度污染</option>
													<option value="严重污染">严重污染</option>
											</select></td>
											<td><select class="form-control" v-if="item.RESULT_TIME3" v-model="item.LEVEL6" data-validation-engine="validate[required, funcCall[ckeck]]">
													<option value="">--请选择--</option>
													<option value="优">优</option>
													<option value="良">良</option>
													<option value="轻度污染">轻度污染</option>
													<option value="中度污染">中度污染</option>
													<option value="重度污染">重度污染</option>
													<option value="严重污染">严重污染</option>
											</select></td>
										</tr>
									</tbody>
								</table>
							</div>

							<div class="col-xs-12" style="margin-top: 10px; padding-left: 5%; padding-right: 5%;">
								<div class="text-left" style="margin-bottom: 5px;">附件：</div>
								<file-upload-table ref="fileUploadTable" :delete-file-ids="resultData.deleteFileIds" :file-list="fileList" allow-file-types="doc,docx"></file-upload-table>
							</div>
						</div>
						<hr>
					</form>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
	<%-- <%@ include file="/WEB-INF/jsp/_common/uploadJS.jsp"%> --%>
	<script type="text/javascript">
		// 地址，必须
		var ctx = "${ctx}";
		var isRead = "${isRead}";
		var reportId = "${reportId}";
		var loginName = "${LOGINNAME}";
	</script>
	<script type="text/javascript" src="${ctx}/assets/components/bootstrap-select/dist/js/bootstrap-select.min.js?v=20221129015223"></script>
	<script type="text/javascript" src="${ctx}/assets/components/bootstrap-select/dist/js/i18n/defaults-zh_CN.min.js?v=20221129015223"></script>
	<%-- 	<script type="text/javascript" src="${ctx}/assets/components/jQuery-Validation-Engine/jquery.validationEngine.min.js?v=20221129015223"></script> --%>
	<!-- vue插件 -->
	<script type="text/javascript" src="${ctx}/assets/components/vue/vue.min.js?v=20221129015223"></script>
	<!-- 引入组件库elementui -->
	<script src="${ctx }/assets/components/element-ui/js/index.js?v=20221129015223"></script>
	<!-- Dialog 工具类 -->
	<script type="text/javascript" src="${ctx}/assets/custom/common/util/dialog-util.js?v=20221129015223"></script>
	<!-- Ajax 工具类 -->
	<script type="text/javascript" src="${ctx}/assets/custom/common/util/ajax-util.js?v=20221129015223"></script>
	<!-- 日期时间 工具类 -->
	<script type="text/javascript" src="${ctx}/assets/custom/common/util/date-time-util.js?v=20221129015223"></script>
	<!-- 文件上传 工具类 -->
	<script type="text/javascript" src="${ctx}/assets/custom/common/util/file-upload-util.js?v=20221129015223"></script>
	<!-- 文件下载 工具类 -->
	<script type="text/javascript" src="${ctx}/assets/custom/common/util/file-download-util.js?v=20221129015223"></script>
	<!-- 分析平台-文件上传表格组件-逻辑js -->
	<script type="text/javascript" src="${ctx}/assets/custom/components/analysis/js/file-upload-table.js?v=20221129015223"></script>
	<!-- 分析平台-文件上传表格组件-模板 -->
	<script id="vue-template-file-upload-table" type="text/x-template">
		<%@ include file="/WEB-INF/jsp/components/analysis/file-upload-table.jsp" %>
	</script>

	<script type="text/javascript" src="${ctx}/assets/custom/analysis/forecast/airforecastmonth/trendEditOrAdd.js?v=20221129015223"></script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>分区预报</title>
<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
<link rel="stylesheet"
	href="${ctx}/assets/components/bootstrap-select/dist/css/bootstrap-select.min.css" />
<!-- 分析平台-文件上传表格组件-样式文件 -->
<link
	href="${ctx }/assets/custom/components/analysis/css/file-upload-table.css"
	rel="stylesheet" />
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
.divBox{
	width:100%;
	min-height:100px;
	max-height:300px;
	padding: 3px;
	border:1px solid #D5D5D5;font-size:12px;
	word-wrap:break-word;
	overflow-y: auto;
	box-shadow: none !important;
	border-top-right-radius: 3px;
	border-top-left-radius:3px;
	border-bottom-right-radius:3px;
	border-bottom-left-radius:3px;
}

.w-input.aqi-min, .w-input.aqi-max {
	width: 60px;
	text-align: center;
}

#forecastValueTbody td {
	width: 25%;
	padding: 0;
	height: 35px;
}

.dropdown-toggle, .dropdown-toggle:hover, .dropdown-toggle:focus, .open>.btn.dropdown-toggle
	{
	background-color: #ffffff !important;
	border: 1px solid #D5D5D5;
	color: #858585 !important;
	border-width: 1px !important;
}

#modeltable tr td:nth-child(even) input {
	width: 45px
}
</style>
</head>

<body class="no-skin">
	<div class="main-container" id="main-container" v-cloak>
		<div class="main-content">
			<div class="main-content-inner padding-page-content">
				<div class="page-content">
					<form id="mainForm" class="form-horizontal" role="form"	id="formList" method="post">
						<div class="breadcrumbs">
							<ul class="breadcrumb">
								<li class="active">
									<h5 class="page-title">
										<i class="header-icon fa fa-plus"></i>添加
									</h5>
								</li>
							</ul>
							<div class="btn-toolbar pull-right" role="toolbar">
								<button type="button" class="btn btn-xs btn-xs-ths"	@click="saveData('UPLOAD');">
									<i class="ace-icon fa fa-upload"></i> 提交
								</button>
								<button type="button" class="btn btn-xs btn-xs-ths btn-danger"	@click="cancel()">
									<i class="ace-icon fa fa-reply"></i> 返回
								</button>
							</div>
						</div>
						<hr class="no-margin" />
						<div class="panel-body">
							<div class="row">
								<div class="col-xs-12 form-group" style="margin-top: 10px; padding-left: 5%; padding-right: 5%;">
									<label class="col-xs-1 control-label no-padding-right">
										<i class="ace-icon fa fa-asterisk red smaller-70"></i>
										报告期数编码：</label>
									<div class="col-xs-2">
										<div class="col-xs-4 no-padding-right no-padding-left"
											 style="width: 140px;">
											<div  class="input-group" @click="wdatePicker">
												<input type="text" id="dailyNum" class="form-control" v-model="dailyNum"
													   data-validation-engine="validate[required,custom[integer],maxSize[10]]">
											</div>
										</div>
									</div>
									<label class="col-xs-1 control-label no-padding-right">
										<i class="ace-icon fa fa-asterisk red smaller-70"></i>
										填报日期：</label>
									<div class="col-xs-2">
										<div class="col-xs-4 no-padding-right no-padding-left"	style="width: 140px;">
											<div  class="input-group" id="divDate"	@click="wdatePicker">
												<input type="text" id="txtDateStart" class="form-control" v-model="resultData.FORECAST_TIME" name="datetime"
													readonly="readonly" data-validation-engine="validate[required]]"> <span class="input-group-btn" >
													<button type="button" class="btn btn-white btn-default"
														id="btnDateStart" readonly="readonly">
														<i class="ace-icon fa fa-calendar"></i>
													</button>
												</span>
											</div>
										</div>
									</div>
								</div>
							</div>
							<hr class="no-margin" />
							<div class="col-xs-12 text-center" style="margin-top: 0px;">
								<div class="col-xs-12 text-center"	style="margin-top: 10px; padding-left: 5%; padding-right: 5%;">
									<div class="text-left">重要提示：</div>
									<textarea maxlength="1000" class="form-control " data-validation-engine="validate[maxSize[1000]]"
										v-model="resultData.HINT" placeholder="请输入重要提示信息，最多1000个字符" style="width: 100%; height: 150px; margin: 5px auto; resize: none;"></textarea>
								</div>
								<div class="col-xs-12 text-center" style="margin-top: 10px; padding-left: 5%; padding-right: 5%;">
									<div class="text-left">
										<label>
											<i class="ace-icon fa fa-asterisk red smaller-70"></i>
											前言：</label>
										<div class="input-group divBox" >
											<div style="padding: 2px 2px 2px 2px;">
												&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;根据
												<input type="text" id="reDate"  @click="reDatedatePicker" v-model="txt1.reDate" name="datetime" readonly="readonly"
													   data-validation-engine="validate[required]]">
												空气质量预报结果，
												<input type="text" id="startDate" @click="startDatedatePicker" v-model="txt1.startDate" name="datetime"
													   data-validation-engine="validate[required]]" readonly="readonly">
												起我市有中度及以上臭氧污染风险，且将持
												<input type="text" v-model="txt1.cxNum" data-validation-engine="validate[required,custom[integer],maxSize[5]]" />
												天及以上，按照《四川省污染防治攻坚战领导小组办公室关于建议启动臭氧污染强化管控的函》（川污防攻坚办〔2021〕20号）相关要求和
												《成都市臭氧重污染天气应急预案（2021年版）》相关规定，我市于
												{{getYear(txt1.startDate)}}年{{getMonth(txt1.startDate)}}月{{getDay(txt1.startDate)}}日
												零时启动臭氧重污染天气黄色预警。
											<br>
												&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{{getMonth(txt1.startDate)}}月{{getDay(txt1.startDate)}}日 至
												{{getMonth(resultData.FORECAST_TIME)}}月{{getDay(resultData.FORECAST_TIME)}}日
												空气质量及应急预案执行情况、未来三天空气质量趋势预测如下。
											</div>
										</div>
									</div>
								</div>
								<div class="col-xs-12 text-center" style="margin-top: 10px; padding-left: 5%; padding-right: 5%;">
									<div class="text-left">
										<label>
											<i class="ace-icon fa fa-asterisk red smaller-70"></i>
											空气质量情况：</label>
										<div class="input-group divBox">
											<template v-for="item in airData" >
												&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{{getMonth(item.MONITORTIME)}}月{{getDay(item.MONITORTIME)}}日空气质量为
												<select v-model="item.AQISTATIONNAME"  data-validation-engine="validate[required]]" >
													<option value="优">优</option>
													<option value="良">良</option>
													<option value="轻度污染">轻度污染</option>
													<option value="中度污染">中度污染</option>
													<option value="重度污染">重度污染</option>
													<option value="严重污染">严重污染</option>
												</select>
												AQI为
												<input type="text" v-model="item.AQI"  data-validation-engine="validate[required,custom[integer],maxSize[5]]">，O3为
												<input type="text" v-model="item.O3_8"  data-validation-engine="validate[required,custom[integer],maxSize[5]]">
												微克/立方米；
												<br>
											</template>
										</div>
									</div>
								</div>
								<div class="col-xs-12 text-center" style="margin-top: 10px; padding-left: 5%; padding-right: 5%;">
									<div class="text-left">
										<label>
											<i class="ace-icon fa fa-asterisk red smaller-70"></i>
											未来三天空气质量趋势预测：</label>
										<div class="input-group divBox">
											<template v-for="item in forecastList" >
												&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{{getMonth(item.RESULT_TIME)}}月{{getDay(item.RESULT_TIME)}}日
												，气象扩散条件为
												<input type="text" v-model="item.WEATHER_LEVEL"  data-validation-engine="validate[required]">
												，预计AQI为
												<input type="text" v-model="item.AQI"  data-validation-engine="validate[required]]">
												，空气质量等级为
												<select v-model="item.AQI_LEVEL"  data-validation-engine="validate[required]]">
													<option value="优">优</option>
													<option value="优或良">优或良</option>
													<option value="良">良</option>
													<option value="良至轻度污染">良至轻度污染</option>
													<option value="轻度污染">轻度污染</option>
													<option value="轻度至中度污染">轻度至中度污染</option>
													<option value="中度污染">中度污染</option>
													<option value="中度至重度污染">中度至重度污染</option>
													<option value="重度污染">重度污染</option>
													<option value="重度至严重污染">重度至严重污染</option>
													<option value="严重污染">严重污染</option>
												</select>
												，首要污染物为
												<select v-model="item.PRIM_POLLUTE">
													<option value="">无</option>
													<option value="PM2.5">PM₂.₅</option>
													<option value="PM10">PM₁₀</option>
													<option value="O3">O₃</option>
													<option value="NO2">NO₂</option>
													<option value="SO2">SO₂</option>
													<option value="CO">CO</option>
												</select>
												；
												<br>
											</template>
											<br>
										</div>
									</div>
								</div>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
		<!--/.main-content-inner-->
	</div>
	<script type="text/javascript" src="${ctx}/assets/js/eform/eform_custom.js"></script>
	<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
	<script type="text/javascript">
		// 地址，必须
		var ctx = "${ctx}";
		var isRead = "${isRead}";
		var reportId = "${reportId}";
		var loginName="${LOGINNAME}"
	</script>
	<script type="text/javascript"	src="${ctx}/assets/components/bootstrap-select/dist/js/bootstrap-select.min.js"></script>
	<script type="text/javascript"	src="${ctx}/assets/components/bootstrap-select/dist/js/i18n/defaults-zh_CN.min.js"></script>
	<!-- vue插件 -->
	<script type="text/javascript"	src="${ctx}/assets/components/vue/vue.min.js"></script>
	<!-- 引入组件库elementui -->
	<script src="${ctx }/assets/components/element-ui/js/index.js"></script>
	<!-- Dialog 工具类 -->
	<script type="text/javascript"	src="${ctx}/assets/custom/common/util/dialog-util.js"></script>
	<!-- Ajax 工具类 -->
	<script type="text/javascript" src="${ctx}/assets/custom/common/util/ajax-util.js"></script>
	<!-- 日期时间 工具类 -->
	<script type="text/javascript"	src="${ctx}/assets/custom/common/util/date-time-util.js"></script>
	<!-- 文件上传 工具类 -->
	<script type="text/javascript"	src="${ctx}/assets/custom/common/util/file-upload-util.js"></script>
	<!-- 文件下载 工具类 -->
	<script type="text/javascript"	src="${ctx}/assets/custom/common/util/file-download-util.js"></script>
	<!-- 分析平台-文件上传表格组件-逻辑js -->
	<script type="text/javascript"	src="${ctx}/assets/custom/components/analysis/js/file-upload-table.js"></script>
	<!-- 分析平台-文件上传表格组件-模板 -->
	<script id="vue-template-file-upload-table" type="text/x-template">
			<%@ include file="/WEB-INF/jsp/components/analysis/file-upload-table.jsp" %>
		</script>
	<script type="text/javascript"	src="${ctx}/assets/custom/warnreport/dailyReport/dailyReportEdit.js"></script>
</body>
</html>
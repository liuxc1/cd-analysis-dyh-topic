<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<title>月趋势预报</title>
<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
<!-- 分析平台-记录列表组件-样式文件 -->
<link href="${ctx }/assets/custom/components/analysis/css/record.css" rel="stylesheet"/>
<style type="text/css">
    .no-data {
    	font-size: 16px;
    }
    .span-btn {
    	color: #428bca;
    	cursor: pointer;
    }
    .record-div {
    	/* height: 35px; */
    	line-height: 35px;
    }
</style>
</head>
<body class="no-skin">
	<div class="main-container" id="main-container" v-cloak>
	<input type="hidden" name="reportId" value="${reportId}" id="reportId">
		<c:if test="${'Y' ne IS_LAYER_OPEN }">
			<div class="main-content-inner fixed-page-header fixed-40">
				<div id="breadcrumbs" class="breadcrumbs">
					<ul class="breadcrumb">
						<li class="active">
							<h5 class="page-title">
								<i class="header-icon fa fa-vine"></i>
								月趋势预报
							</h5>
						</li>
					</ul>
					<div class="align-right" style="float: right; padding-right: 5px;">
						<button type="button" class="btn btn-xs btn-xs-ths btn-danger" @click="cancel">
							<i class="ace-icon fa fa-reply"></i> 返回
						</button>
					</div>
				</div>
			</div>
		</c:if>
		<div class="main-content-inner padding-page-content">
			<div class="main-content">
				<div class="page-content">
					<div class="col-sm-12 no-padding" v-if="record">
						<div class="space-4"></div>
						<table class="table table-bordered">
							<tbody>
								<!-- <tr>
									<th class="text-right" width="20%">
										填报日期：
									</th>
									<td width="80%">
										{{record.createTime}}
									</td>
								</tr> -->
								<tr>
									<th class="text-right" width="20%">
										重要提示：
									</th>
									<td width="80%">
										{{record.importantHints}}
									</td>
								</tr>
								<!-- <tr>
									<th class="text-right">
										状态：
									</th>
									<td>
										{{record.flowState == 'UPLOAD' ? '已提交' : '暂存'}}
									</td>
								</tr> -->
							</tbody>
						</table>
					</div>
					<div class="col-sm-12 no-padding" v-if="record && record.cityForecastAqiList">
						<div class="space-4"></div>
						<table class="table table-bordered">
							<thead>
								<tr>
									<th class="text-center" style="width: 13%;">预报日期</th>
									<th class="text-center" style="width: 10%;">等级1</th>
									<th class="text-center" style="width: 10%;">等级2</th>
									<th class="text-center" style="width: 13%;">预报日期</th>
									<th class="text-center" style="width: 10%;">等级1</th>
									<th class="text-center" style="width: 10%;">等级2</th>
									<th class="text-center" style="width: 13%;">预报日期</th>
									<th class="text-center" style="width: 10%;">等级1</th>
									<th class="text-center" style="width: 10%;">等级2</th>
								</tr>
							</thead>
							<tbody>
								<tr v-for="(item, index) in record.cityForecastAqiList">
									<td class="text-center">{{item.RESULT_TIME1}}</td>
									<td class="text-center">{{item.LEVEL1 || '-'}}</td>
									<td class="text-center">{{item.LEVEL2 || '-'}}</td>
									<td class="text-center">{{item.RESULT_TIME2}}</td>
									<td class="text-center">{{item.LEVEL3 || '-'}}</td>
									<td class="text-center">{{item.LEVEL4 || '-'}}</td>
									<td class="text-center">{{item.RESULT_TIME3|| '-'}}</td>
									<td class="text-center">{{item.LEVEL5 || '-'}}</td>
									<td class="text-center">{{item.LEVEL6 || '-'}}</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="col-sm-12">
						<div class="space-4"></div>
						<record ref="fileRecord" :records="fileRecords" @recordclick="fileRecordClick"></record>
						<div class="align-right" style="padding-right: 5px;">
							<span @click="downloadFile" class="span-btn" v-if="pdfUrl">
								<i class="ace-icon fa fa-download"></i> 下载
							</span>
						</div>
					</div>
					<div class="col-sm-12 no-padding" v-if="pdfUrl">
						<iframe :src="pdfUrl" class="col-sm-12 no-padding no-border" height="600"></iframe>
					</div>
					<div class="col-sm-12 center no-data" v-if="noDataText">
						{{noDataText}}
					</div>
				</div>
			</div>
			<!--/.main-content-inner-->
		</div>
		<!-- /.main-content -->
	</div>

	<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
	<!-- vue插件 -->
	<!--[if lte IE 9]>
	<script type="text/javascript" src="${ctx}/assets/components/babel-polyfill/polyfill.min.js"></script>
	<![endif]-->
	<!-- vue插件 -->
	<script type="text/javascript" src="${ctx}/assets/components/vue/vue.min.js"></script>
	<!-- Dialog 工具类 -->
	<script type="text/javascript" src="${ctx}/assets/custom/common/util/dialog-util.js"></script>
	<!-- Ajax 工具类 -->
	<script type="text/javascript" src="${ctx}/assets/custom/common/util/ajax-util.js"></script>
	<!-- 日期时间 工具类 -->
	<script type="text/javascript" src="${ctx}/assets/custom/common/util/date-time-util.js"></script>
	<!-- 文件下载 工具类 -->
	<script type="text/javascript" src="${ctx}/assets/custom/common/util/file-download-util.js"></script>
	<!-- 分析平台-记录列表组件-逻辑js -->
	<script type="text/javascript" src="${ctx}/assets/custom/components/analysis/js/record.js"></script>
	<!-- 分析平台-记录列表组件-模板 -->
	<script id="vue-template-record" type="text/x-template">
		<%@ include file="/WEB-INF/jsp/components/analysis/record.jsp" %>
	</script>
	<!-- 自定义js（逻辑js） -->
	<script type="text/javascript" src="${ctx}/assets/custom/analysis/forecast/airforecastmonth/trendView.js"></script>
</body>
</html>
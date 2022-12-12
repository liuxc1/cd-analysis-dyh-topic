<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<title>成都市源解析</title>
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
     .form-control[disabled], .form-control[readonly], fieldset[disabled] .form-control {
    	background-color: white;
    	opacity: 1;
	} 
</style>
</head>
<body class="no-skin" >
	<div id="index-app" class="main-container" style="width: 100%; height: 100%; overflow: auto;" v-cloak>
		<div class="main-content-inner fixed-page-header fixed-40" v-if="${showTitle}">
			<div id="breadcrumbs" class="breadcrumbs">
				<ul class="breadcrumb">
					<li class="active">
						<h5 class="page-title">
							<i class="header-icon fa fa-cubes"></i>
							成都市源解析
						</h5>
					</li>
				</ul>
				<div class="align-right" style="float: right; padding-right: 5px;">
					<button type="button" class="btn btn-xs btn-xs-ths" @click="goAdd">
						<i class="ace-icon fa fa-plus"></i> 添加
					</button>
				</div>
			</div>
		</div>
		<div class="main-content-inner padding-page-content">
			<div class="main-content">
				<div class="page-content">
					<div class="row">
					<form class="form-horizontal" role="form">
						<div class="space-4"></div>
						<div class="col-sm-12 no-padding">
							<div class="col-sm-3 no-padding">
								<label class="col-sm-4 control-label">填报年份：</label>
								<div class="col-sm-8 input-group">
									<input type="text" id="reportYear" v-model="param.REPORT_YEAR" @click="findByReportYear" class="form-control"  readonly placeholder="请输入年份">
									<span class="input-group-btn">
										<button type="button" class="btn btn-white btn-default" @click="findByReportYear">
											<i class="ace-icon fa fa-calendar"></i>
										</button>
									</span>
								</div>
							</div>
							<div class="col-sm-5 no-padding">
								<label class="radio-inline" style="margin-left: 60px">污染物类型：</label>
								<label class="checkbox-inline">
									<input type="radio" name="pm" :checked="param.PM == 'PM25'" value="PM25" @click="changePollute('PM25')">
									<span>PM<sub>2.5</sub></span>
								</label>
								<label class="checkbox-inline">
									<input type="radio" name="pm" :checked="param.PM == 'PM10'"  value="PM10" @click="changePollute('PM10')">
									<span>PM<sub>10</sub></span>
								</label>
							</div>
							<div class="col-sm-4 align-right no-padding form-group no-margin">
								<button id="btn-search" type="button" class="btn btn-info btn-default-ths" @click="querySourceAnalysis()">
									<i class="ace-icon fa fa-search"></i>查询
								</button>
							</div>
						</div>
						<div class="col-sm-12 no-padding">
							<div class="col-sm-9 record-div">
								<record ref="record" :records="records" @recordclick="recordClick"></record>
							</div>
							<div class="col-sm-3 align-right no-padding" style="margin-top:10px;" v-if="${showTitle}">
								<button type="button" class="btn btn-xs btn-xs-ths" @click="submit" v-if="state == 'TEMP' && record == 1">
									<i class="ace-icon fa fa-upload"></i> 提交
								</button>
								<button type="button" class="btn btn-xs btn-xs-ths" @click="goEdit" v-if="state == 'TEMP' && record == 1">
									<i class="ace-icon fa fa-edit"></i> 编辑
								</button>
								<button type="button" class="btn btn-xs btn-xs-ths btn-danger" @click="deleteReportFile" v-if="state == 'TEMP' && record == 1">
									<i class="ace-icon fa fa-trash-o"></i> 删除
								</button>
							</div>
						</div>	
						<div class="col-xs-12" style="padding-top:25px;">
							<div class="panel panel-default">
							  <div class="panel-heading">组分特征</div>
							  <div class="panel-body" v-if="ascriptionId != ''">
							  	<div class="row">
							  		<div class="col-xs-8">
								      <div id='echart_1' style="height: 300px;"></div>
							  		</div>
							  		<div class="col-xs-4" >
							  			<textarea style="border:0px;width: 100%; height: 280px;  resize:none" readonly>{{polluteinfo1}}</textarea>
							  		</div>
							  	</div>
							  </div>
							</div>
						</div>
						<div class="col-xs-6">
							<div class="panel panel-default">
							  <div class="panel-heading">综合源解析</div>
							  <div class="panel-body" v-if="ascriptionId != ''" style="padding-bottom: 5px;">
								  <div class="row">
								  		<div class="col-xs-12">
									      <div id='echart_2' style="height: 300px"></div>
								  		</div>
								  		<div class="col-xs-12" style="margin-top:15px;padding-right: 0px;padding-left: 0px;">
								  			<textarea style="border:0px;width: 100%; height: 120px;  resize:none" readonly>{{polluteinfo2}}</textarea>
								  		</div>
                                  </div>
							  </div>
							</div>
						 </div>
						 <div class="col-xs-6">
							<div class="panel panel-default">
							  <div class="panel-heading">历年源解析</div>
							  <div class="panel-body" v-if="ascriptionId != ''" style="padding-bottom: 5px;">
								  <div class="row">
							  		<div class="col-xs-12">
								      <div id='echart_3' style="height: 300px"></div>
							  		</div>
							  		<div class="col-xs-12" style="margin-top:15px;padding-right: 0px;padding-left: 0px;">
							  			<textarea style="border:0px;width: 100%; height: 120px;  resize:none" readonly>{{polluteinfo3}}</textarea>
							  		</div>
								  </div>
							  </div>
							</div>
						</div>
					</form>
				</div>
			</div>
			<!--/.main-content-inner-->
		</div>
		<!-- /.main-content -->
	</div>
	
		
	
	<script type="text/javascript">
		var ctx = '${ctx}';
	</script>
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
	<!-- 图标 -->
		<script type="text/javascript" src="${ctx}/assets/components/echarts/echarts.min.js"></script>
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
	<script src="${ctx}/assets/js/echart-ct.js" type="text/javascript"></script>
	<script type="text/javascript" src="${ctx}/assets/custom/analysis/sourceAnalysis/sourceResolveIndex.js"></script>
</body>
</html>
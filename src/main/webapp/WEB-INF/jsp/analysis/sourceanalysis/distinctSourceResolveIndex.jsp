<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<title>区县源解析</title>
<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
<!-- 分析平台-记录列表组件-样式文件 -->
<link href="${ctx }/assets/custom/components/analysis/css/record.css" rel="stylesheet"/>
<link href="${ctx}/assets/components/viewer-master/dist/viewer.min.css" rel="stylesheet">
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
	
	.imgsty{
		padding-bottom:10px;
	    width: 50%;
	    height: 300px;
	    max-width: 97%;
	    display:inline;
	    float:right;
	    
	} 
   
</style>
</head>
<body class="no-skin" >
	<div id="index-app" class="main-container" style="width: 100%; height: 100%; overflow: auto;" v-cloak>
		<div class="main-content-inner fixed-page-header fixed-40">
			<div id="breadcrumbs" class="breadcrumbs">
				<ul class="breadcrumb">
					<li class="active">
						<h5 class="page-title">
							<i class="header-icon fa fa-inbox"></i>
							区县源解析
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
									<input type="text" id="reportYear" v-model="report.REPORT_YEAR" @click="findByReportYear" class="form-control"  readonly placeholder="请填入年份">
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
									<input type="radio" name="pm" value="PM25" :checked="sourcePollute.PM == 'PM25'" @click="changePollute('PM25')">
									<span>PM<sub>2.5</sub></span>
								</label>
								<label class="checkbox-inline">
									<input type="radio" name="pm" value="PM10" :checked="sourcePollute.PM == 'PM10'" @click="changePollute('PM10')">
									<span>PM<sub>10</sub></span>
								</label>
							</div>
							<div class="col-sm-4 align-right no-padding form-group no-margin">
								<button type="button" class="btn btn-info btn-default-ths" @click="queryCounty()">
									<i class="ace-icon fa fa-search"></i>查询
								</button>
							</div>
						</div>
						<div class="col-sm-12 no-padding">
							<div class="col-sm-8 record-div">
								<record ref="record" :records="records" @recordClick="recordClick"></record>
							</div>
							<div class="col-sm-4 align-right no-padding" style="margin-top:10px;">
								<button type="button" class="btn btn-xs btn-xs-ths" v-if="report.STATE=='TEMP' && record == 1" @click="submit">
									<i class="ace-icon fa fa-upload"></i> 提交
								</button>
								<button type="button" class="btn btn-xs btn-xs-ths" v-if="report.STATE=='TEMP' && record == 1" @click="goEdit">
									<i class="ace-icon fa fa-edit"></i> 编辑
								</button>
								<button type="button" class="btn btn-xs btn-xs-ths btn-danger" v-if="report.STATE=='TEMP' && record == 1" @click="deleteReportFile">
									<i class="ace-icon fa fa-trash-o"></i> 删除
								</button>
							</div>
						</div>	
						<div class="col-xs-12" style="padding-top:25px;">
							<div class="panel panel-default">
							  <div class="panel-heading">组分特征</div>
							  <div class="panel-body" v-if="report.REPORT_ID != ''">
							  	<div class="col-xs-6">
								  	<div class="row">
								  		<div class="col-xs-12">
									      <div id='echart_1' style="height: 300px;"></div>
								  		</div>
								  		<div class="col-xs-12">
								  			<textarea class="form-control"  style="width: 100%; height: 200px; resize:none;border:0px" readonly>{{polluteinfo1}}</textarea>
								  		</div>
								  	</div>
							  	</div>
							  	<div class="col-xs-6">
								  	<div class="row">
								  		<div class="col-xs-12">
									      <div id='echart_2' style="height: 300px;"></div>
								  		</div>
								  		<div class="col-xs-12">
								  			<textarea class="form-control"  style="width: 100%; height: 200px; resize:none;border:0px" readonly>{{polluteinfo2}}</textarea>
								  		</div>
								  	</div>
								 </div> 	
							  </div>
							</div>
						</div>
						<div class="col-xs-12">
							<div class="panel panel-default">
							  <div class="panel-heading">区县源解析</div>
							  <div class="panel-body"  v-if="report.REPORT_ID != ''" style="padding-bottom: 5px;">
								  <div class="row">
								  		<div style="height: 330px;overflow: auto;">
									  		<div v-if='fileList.length > 0' :class="{'col-xs-12':fileList.length==1,'col-xs-6':fileList.length==2,'col-xs-4':fileList.length==3,'col-xs-3':fileList.length>=4}"  v-for="(data, index) in fileList">
											    <a href="javascript:void(0);" class="thumbnail">
											     	<img :src="data.FILE_URL" :alt="data.FILE_NAME"  style="height: 300px;">
									  			</a>
									  		</div>
									  		<div v-if='fileList.length == 0' class="center" style="line-height: 250px;">暂无数据</div>
								  		</div>
								  		
									  		
								  		<div class="col-xs-12" style="margin-top:15px;padding-right: 0px;padding-left: 0px;">
								  			<textarea class="form-control" unselectable='on' style="width: 100%; height: 100px;  resize:none;border:0px" readonly>{{report.FIELD5}}</textarea>
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
	<!-- 图片点击放大插件 -->
	<!-- 分析平台-文件上传表格组件-逻辑js -->
	<script type="text/javascript" src="${ctx}/assets/components/viewer-master/dist/viewer.min.js"></script>	<!-- Dialog 工具类 -->
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
	<script type="text/javascript" src="${ctx}/assets/custom/analysis/sourceAnalysis/distinctSourceResolveIndex.js"></script>
</body>
</html>
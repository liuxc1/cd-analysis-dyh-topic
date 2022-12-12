<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<title>分区预报</title>
<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
<!-- 分析平台-时间轴组件-样式文件 -->
<link href="${ctx }/assets/custom/components/analysis/css/time-axis.css?v=20221129015223" rel="stylesheet"/>
<!-- 分析平台-记录列表组件-样式文件 -->
<link href="${ctx }/assets/custom/components/analysis/css/record.css?v=20221129015223" rel="stylesheet"/>
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
								<i class="header-icon fa fa-university"></i>
								分区预报-查看
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
<!-- 								<tr> -->
<!-- 									<th class="text-right" width="20%"> -->
<!-- 										填报日期： -->
<!-- 									</th> -->
<!-- 									<td width="80%"> -->
<!-- 										{{record.createTime}} -->
<!-- 									</td> -->
<!-- 								</tr> -->
								<tr>
									<th class="text-right" width="20%">
										重要提示：
									</th>
									<td width="80%">
										{{record.importantHints==null||record.importantHints==""?"--":record.importantHints}}
									</td>
								</tr>
<!-- 								<tr> -->
<!-- 									<th class="text-right"> -->
<!-- 										状态： -->
<!-- 									</th> -->
<!-- 									<td> -->
<!-- 										{{record.flowState == 'UPLOAD' ? '已提交' : '暂存'}} -->
<!-- 									</td> -->
<!-- 								</tr> -->
							</tbody>
						</table>
					</div>
					<div class="col-sm-12 no-padding">
						<div class="space-4"></div>
						<ul class="nav nav-tabs" role="tablist"
										style="width: 90%; margin-left: 5%">
<!-- 										<li role="presentation" class="active"><a href="#tab_1" -->
<!-- 											aria-controls="tab_1" role="tab" data-toggle="tab">四大区域24h预报</a> -->
<!-- 										</li> -->
<!-- 										<li role="presentation"><a href="#tab_3" -->
<!-- 											aria-controls="tab_3" role="tab" data-toggle="tab">区县3天预报</a> -->
<!-- 										</li> -->
						</ul>
							<div class="tab-content" style="width: 100%; margin-left: 0%">
<!-- 										<div role="tabpanel" class="tab-pane active" id="tab_1"> -->
<!-- 											<table class="table table-bordered" -->
<!-- 												style="width: 95%; margin-left: 3%"> -->
<!-- 												<colgroup> -->
<!-- 													<col width="30%" /> -->
<!-- 													<col width="35%" /> -->
<!-- 													<col width="35%" /> -->
<!-- 												</colgroup> -->
<!-- 												<thead> -->
<!-- 													<tr> -->
<!-- 														<th class="center">区域名称</th> -->
<!-- 														<th class="center">空气质量等级</th> -->
<!-- 														<th class="text-center">首要污染物</th> -->
<!-- 													</tr> -->
<!-- 												</thead> -->
<!-- 												<tr v-for="(area, areaindex) in form24h" -->
<!-- 													v-if="area.TYPECODE==0"> -->
<!-- 													<td style="vertical-align: inherit !important;">{{area.REGIONNAME}}</td> -->
<!-- 													<td>{{area.AQI_LEVEL}}</td> -->
<!-- 													<td class="text-center" v-html="getPrimPolluteHtml(area.PULLNAME)"></td> -->
<!-- 												</tr> -->
<!-- 											</table> -->
<!-- 										</div> -->
										<div role="tabpanel" class="tab-pane active" id="tab_3">
											<table id="modeltable" class="table table-bordered"
												style="width: 100%; margin-left: 0%">
												<colgroup>
													<col width="10%" />
													<col width="15%" />
													<col width="15%" />
													<col width="15%" />
													<col width="15%" />
													<col width="15%" />
													<col width="15%" />
												</colgroup>
												<thead>
													<tr>
														<th class="center" rowspan="2">区县</th>
														<th class="center" colspan="2"
															style="border-bottom: 1px solid #D5D5D5">{{form3d[0].FORECAST_DATE1}}</th>
														<th class="center" colspan="2"
															style="border-bottom: 1px solid #D5D5D5">{{form3d[0].FORECAST_DATE2}}</th>
														<th class="center" colspan="2"
															style="border-bottom: 1px solid #D5D5D5">{{form3d[0].FORECAST_DATE3}}</th>
													</tr>
													<tr>
														<th class="center">AQI范围</th>
														<th class="center">首要污染物 </th>
														<th class="center">AQI范围</th>
														<th class="center">首要污染物 </th>
														<th class="center">AQI范围</th>
														<th class="center">首要污染物 </th>
													</tr>
												</thead>
												<tr v-if="form3d!=null&&form3d.length>1" v-for="(datas3d, datas3dindex) in form3d"
													:key="datas3dindex">
													<td style="vertical-align: middle;" class="text-center">
														{{datas3d.REGIONNAME }}</td>
													<td class="text-center">{{datas3d.AQI_START1+'~'+datas3d.AQI_END1}}</td>
												<td class="text-center" v-html="getPrimPolluteHtml(datas3d.PULLNAME1)"></td>
													<td class="text-center">{{datas3d.AQI_START2+'~'+datas3d.AQI_END2}}</td>
													<td class="text-center" v-html="getPrimPolluteHtml(datas3d.PULLNAME2)"></td>
													<td class="text-center">{{datas3d.AQI_START3+'~'+datas3d.AQI_END3}}</td>
													<td class="text-center" v-html="getPrimPolluteHtml(datas3d.PULLNAME3)"></td>
												</tr>
											</table>
										</div>
									</div>
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
	<script type="text/javascript" src="${ctx}/assets/components/babel-polyfill/polyfill.min.js?v=20221129015223"></script>
	<![endif]-->
	<!-- vue插件 -->
	<script type="text/javascript" src="${ctx}/assets/components/vue/vue.min.js?v=20221129015223"></script>
	<!-- Dialog 工具类 -->
	<script type="text/javascript" src="${ctx}/assets/custom/common/util/dialog-util.js?v=20221129015223"></script>
	<!-- Ajax 工具类 -->
	<script type="text/javascript" src="${ctx}/assets/custom/common/util/ajax-util.js?v=20221129015223"></script>
	<!-- 日期时间 工具类 -->
	<script type="text/javascript" src="${ctx}/assets/custom/common/util/date-time-util.js?v=20221129015223"></script>
	<!-- 文件下载 工具类 -->
	<script type="text/javascript" src="${ctx}/assets/custom/common/util/file-download-util.js?v=20221129015223"></script>
	<!-- 分析平台-时间轴组件-逻辑js -->
	<script type="text/javascript" src="${ctx}/assets/custom/components/analysis/js/time-axis.js?v=20221129015223"></script>
	<!-- 分析平台-时间轴组件-模板 -->
	<script id="vue-template-time-axis" type="text/x-template">
		<%@ include file="/WEB-INF/jsp/components/analysis/time-axis.jsp" %>
	</script>
	<!-- 分析平台-记录列表组件-逻辑js -->
	<script type="text/javascript" src="${ctx}/assets/custom/components/analysis/js/record.js?v=20221129015223"></script>
	<!-- 分析平台-记录列表组件-模板 -->
	<script id="vue-template-record" type="text/x-template">
		<%@ include file="/WEB-INF/jsp/components/analysis/record.jsp" %>
	</script>
	<!-- 自定义js（逻辑js） -->
	<script type="text/javascript" src="${ctx}/assets/custom/analysis/forecast/airforecastparition/partitionView.js?v=20221129015223"></script>
</body>
</html>
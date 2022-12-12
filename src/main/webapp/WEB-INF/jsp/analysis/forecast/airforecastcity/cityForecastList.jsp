<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
	<title>城市预报</title>
	<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
	<!-- 分析平台-时间轴组件-样式文件 -->
	<link href="${ctx }/assets/custom/components/analysis/css/time-axis.css" rel="stylesheet"/>
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
		.tableTitle >th{
			vertical-align: middle !important;
		}
	</style>
</head>
<body class="no-skin">
<div class="main-container" id="main-container" v-cloak>
	<div class="main-content-inner fixed-page-header fixed-40">
		<div id="breadcrumbs" class="breadcrumbs">
			<ul class="breadcrumb">
				<li class="active">
					<h5 class="page-title">
						<i class="header-icon fa fa-university"></i>
						城市预报
					</h5>
				</li>
			</ul>
			<div class="align-right" style="float: right; padding-right: 5px;" v-if="!isOnlyRead">
				<button type="button" class="btn btn-xs btn-xs-ths" @click="goAdd">
					<i class="ace-icon fa fa-plus"></i> 添加
				</button>
				<!-- <button type="button" class="btn btn-xs btn-xs-ths" @click="downloadFile" v-if="pdfUrl || imgUrl">
                    <i class="ace-icon fa fa-download"></i> 下载
                </button> -->
			</div>
		</div>
	</div>
	<div class="main-content-inner padding-page-content">
		<div class="main-content">
			<div class="page-content">
				<form class="form-horizontal" role="form">
					<div class="space-4"></div>
					<div class="col-sm-12 no-padding">
						<div class="col-sm-3 no-padding">
							<label class="col-sm-4 control-label">填报月份：</label>
							<div class="col-sm-8 input-group">
								<input type="text" id="wdate-picker" v-model="month" @click="wdatePicker" class="form-control" placeholder="请选择填报月份" readonly>
								<span class="input-group-btn">
										<button type="button" class="btn btn-white btn-default" @click="wdatePicker">
											<i class="ace-icon fa fa-calendar"></i>
										</button>
									</span>
							</div>
						</div>
						<div class="col-sm-9">
							<time-axis ref="timeAxis"
									   :current="month"
									   :prev="timeAxis.prev"
									   :next="timeAxis.next"
									   :list="timeAxis.list"
									   @prevclick="prevClick"
									   @nextclick="nextClick"
									   @listclick="timeAxisListClick"
							></time-axis>
						</div>
					</div>
					<%@ include file="/WEB-INF/jsp/analysis/forecast/airforecastcity/messDialog.jsp"%>
				</form>
				<div class="col-sm-12 record-div">
					<div class="col-sm-9 no-padding">
						<record ref="record" :records="records" @recordclick="recordClick"></record>
					</div>
					<div class="col-sm-3 align-right no-padding" v-if="!isOnlyRead">
						<button type="button" class="btn btn-xs btn-xs-ths" @click="uploadClick" v-if="record && record.flowState == '0'">
							<i class="ace-icon fa fa-upload"></i> 提交
						</button>
						<button type="button" class="btn btn-xs btn-xs-ths" @click="goEdit" v-if="record && record.flowState == '0'">
							<i class="ace-icon fa fa-edit"></i> 编辑
						</button>
						<button type="button" class="btn btn-xs btn-xs-ths" @click="pushData" v-if="record && record.flowState == '1' && record.isSend != 1">
							<i class="ace-icon fa fa-send"></i> 推送省站
						</button>
						<button type="button" class="btn btn-xs btn-xs-ths btn-danger" @click="deleteData" v-if="record && record.flowState == '0'">
							<i class="ace-icon fa fa-trash-o"></i> 删除
						</button>
						<button type="button" class="btn btn-xs btn-xs-ths" @click="revocation" v-if="record && record.flowState == '1'">
							<i class="ace-icon fa fa-reply"></i> 撤销
						</button>
					</div>
					<div class="space-4"></div>
				</div>
				<div class="col-sm-12 no-padding" v-if="record">
					<div class="space-4"></div>
					<table class="table table-bordered">
						<tbody>
						<!-- <tr>
                            <th class="text-right" width="20%">
                                填报日期：
                            </th>
                            <td width="80%">
                                {{record.reportTime}}
                            </td>
                        </tr> -->
						<tr>
							<th class="text-right" width="20%">
								3天重要提示：
							</th>
							<td width="80%">
								{{record.importantHints | resultFormat }}
							</td>
						</tr>
						<tr>
							<th class="text-right" width="20%">
								7天重要提示：
							</th>
							<td width="80%">
								{{record.importantHints_7day | resultFormat}}
							</td>
						</tr>
						<!-- <tr>
                            <th class="text-right">
                                状态：
                            </th>
                            <td>
                                {{record.flowState == '1' ? '已提交' : '暂存'}}
                            </td>
                        </tr> -->
						</tbody>
					</table>
				</div>

				<div class="col-sm-12 no-padding" >
					<div class="space-4"></div>
					<table class="table table-bordered">
						<tbody>
						<tr class="tableTitle" >
							<th class="text-center" rowspan="2" >
								预报日期
							</th>

							<th class="text-center" rowspan="2">
								级别
							</th>
							<th class="text-center" rowspan="2">
								AQI范围
							</th>
							<template v-if="showFlag != 1">
								<th class="text-center" colspan="2">
									PM<sub>2.5</sub>(μg/m³)
								</th>
								<th class="text-center" colspan="2">
									O<sub>3</sub>(μg/m³)
								</th>
							</template>
							<th class="text-center" rowspan="2">
								首要污染物
							</th>

							<th class="text-center"rowspan="2" >
								控制目标
							</th>
							<th class="text-center" rowspan="2">
								{{weatherConditionsType==1?'臭氧污染气象条件':'气象扩散条件'}}
							</th>
						</tr>
						<tr>
							<template v-if="showFlag != 1">
								<th class="text-center">
									浓度范围
								</th>
								<th class="text-center">
									IAQI范围
								</th>
								<th class="text-center">
									浓度范围
								</th>
								<th class="text-center">
									IAQI范围
								</th>
							</template>
						</tr>
						<template v-if="record && record.cityForecastAqiList">
						<tr  v-if="record && record.cityForecastAqiList!=null && record.cityForecastAqiList.length>1" v-for="cityForecastAqi in record.cityForecastAqiList">
							<td class="text-center">{{cityForecastAqi.resultTime}}</td>
							<td class="text-center">{{cityForecastAqi.aqiLevel}}</td>
							<td class="text-center">{{cityForecastAqi.aqi}}</td>
							<template v-if="showFlag != 1">
								<td class="text-center">{{cityForecastAqi.pm25}}</td>
								<td class="text-center">{{cityForecastAqi.pm25Iaqi}}</td>
								<td class="text-center">{{cityForecastAqi.o3}}</td>
								<td class="text-center">{{cityForecastAqi.o3Iaqi}}</td>
							</template>
							<td class="text-center" v-html="getPrimPolluteHtml(cityForecastAqi.primPollute)"></td>
							<td class="text-center">{{cityForecastAqi.CONTROL_TARGET}}</td>
							<td class="text-center">{{cityForecastAqi.weatherLevel}}</td>
						</tr>
						</template>
						<tr v-if="record == null ||record.cityForecastAqiList == null || record.cityForecastAqiList.length<1">
							<td class="text-center" colspan="8">暂无数据</td>
						</tr>
						</tbody>
					</table>
				</div>
                <div class="col-sm-12">
                    <div class="space-4"></div>
                    <record ref="fileRecord" :records="fileRecords" @recordclick="fileRecordClick"></record>
                    <div class="align-right" style="padding-right: 5px;">
							<span @click="openFullScreen" class="span-btn" v-if="pdfUrl" style="margin-right: 20px">
                                <i class="ace-icon fa fa-arrows-alt"></i> 全屏
                            </span>
                            <span @click="downloadFile" class="span-btn" v-if="pdfUrl">
                                <i class="ace-icon fa fa-download"></i> 下载
                            </span>
                    </div>
                </div>
                <div class="col-sm-12 no-padding" v-if="pdfUrl">
                    <iframe :src="pdfUrl" class="col-sm-12 no-padding no-border" height="600"></iframe>
                </div>
                <%--<div class="col-sm-12 center no-data" v-if="noDataText">
                    {{noDataText}}
                </div>--%>
			</div>
		</div>
		<!--/.main-content-inner-->
	</div>
	<!-- /.main-content -->
</div>

<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
<script>
	var  showFlag = '${showFlag}';
	//是否只允许查看
	var isOnlyRead = '<%=request.getParameter("isOnlyRead")%>';
</script>
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
<!-- 分析平台-时间轴组件-逻辑js -->
<script type="text/javascript" src="${ctx}/assets/custom/components/analysis/js/time-axis.js"></script>
<!-- 分析平台-时间轴组件-模板 -->
<script id="vue-template-time-axis" type="text/x-template">
	<%@ include file="/WEB-INF/jsp/components/analysis/time-axis.jsp" %>
</script>
<!-- 分析平台-记录列表组件-逻辑js -->
<script type="text/javascript" src="${ctx}/assets/custom/components/analysis/js/record.js"></script>
<!-- 分析平台-记录列表组件-模板 -->
<script id="vue-template-record" type="text/x-template">
	<%@ include file="/WEB-INF/jsp/components/analysis/record.jsp" %>
</script>
<script type="text/javascript"
		src="${ctx}/assets/custom/analysis/forecast/airforecastcity/assembleData.js"></script>
<!-- 自定义js（逻辑js） -->
<script type="text/javascript" src="${ctx}/assets/custom/analysis/forecast/airforecastcity/cityForecastList.js"></script>
</body>
</html>
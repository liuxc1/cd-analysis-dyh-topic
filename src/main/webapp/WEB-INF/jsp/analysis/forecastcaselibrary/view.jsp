<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>预报案例库</title>
<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
<link rel="stylesheet" href="${ctx }/assets/custom/analysis/forecastcastlibrary/step_play.css">
<link rel="stylesheet" href="${ctx }/assets/custom/analysis/forecastcastlibrary/util-1.0.1.css">
<link rel="stylesheet" href="${ctx }/assets/components/element-ui/css/index.css">
</head>
<body class="no-skin">
	<div class="main-container" id="main-container" v-cloak>
		<div class="main-content">
			<div class="step-title-row">
				<p class="step-title-p" style="width: 80%">
                    {{dataList[0].WEATHER_TYPE_NAME}}-{{dataList[0].POLLUTE_NAME}} 时段：{{dataList[0].W_START_TIME}}~{{dataList[0].W_END_TIME}}
				</p>
                <div style="width: 18%;text-align: right">
                    <button type="button" class="btn btn-purple btn-default-ths" @click="downloadWord"><i class="ace-icon fa fa-file-excel-o"></i> 导出 </button>
                    <button type="button" class="btn btn-purple btn-default-ths" @click="cancel"><i class="ace-icon fa fa-reply"></i> 返回 </button>
                </div>
			</div>
			<div class="main-content-inner padding-page-content">
				<div class="page-content">
					<div class="space-4"></div>
					<div class="row">
						<div  class="col-xs-12 tabs-left no-padding-left">
							<div id="r1_col1" class="sidebar">
								<div class="isButton menu active" data-oper="menu"  id="ppl_list">
									<ul  id="myTab3">
										<li @click="activeLiMethod(0)" :class="{'isButton':true,'imgInfo':true,'active':defaultLiIndex==0}">污染过程基本信息</li>
										<li @click="activeLiMethod(1)" :class="{'isButton':true,'imgInfo':true,'active':defaultLiIndex==1}">案例基本信息</li>
										<li @click="activeLiMethod(2)" :class="{'isButton':true,'imgInfo':true,'active':defaultLiIndex==2}">气象分析</li>
										<li @click="activeLiMethod(3)" :class="{'isButton':true,'imgInfo':true,'active':defaultLiIndex==3}">案例归型及预报参考</li>
									</ul>
								</div>
							</div>
							<div id="r1_col2" >
								<div class="tab-content min-height-200" style="overflow: hidden">
									<div v-show="defaultLiIndex===0"  :class="{'tab-pane':true,'active':defaultLiIndex==0}">
										<form class="form-horizontal" role="form" id="formList"  method="post">
											<div class="form-group">
												<label class="col-xs-1 control-label no-padding-right">开始时间：</label>
												<div class="col-xs-2">
													<label class="control-label">{{dataList[0].W_START_TIME}}</label>
												</div>
												<label class="col-xs-1 control-label " >结束时间:</label>
												<div class="col-xs-2">
													<label class="control-label">{{dataList[0].W_END_TIME}}</label>
												</div>
												<label class="col-xs-1 control-label no-padding-right">天气类型：</label>
												<div class="col-xs-2 hidden-xs">
													<label class="control-label">{{dataList[0].WEATHER_TYPE_NAME}}</label>
												</div>
												<label class="col-xs-1 control-label no-padding-right">污染物类型：</label>
												<div class="col-xs-2 hidden-xs">
													<label class="control-label">{{dataList[0].POLLUTE_NAME}}</label>
												</div>
											</div>
											<div class="row">
												<div class="col-xs-12 col-md-12" style="margin-top: 20px">
													<table class="table table-bordered table-hover">
														<thead>
														<tr>
															<th class="text-center" rowspan="2">污染天数</th>
															<th class="text-center" colspan="2">最大浓度</th>
															<th class="text-center" colspan="6">平均浓度</th>
															<th class="text-center" colspan="4">气象要素</th>
														</tr>
														<tr>
															<th class="text-center">PM<sub>2.5</sub></th>
															<th class="text-center">O<sub>3</sub></th>
															<th class="text-center">PM<sub>2.5</sub></th>
															<th class="text-center">PM<sub>10</sub></th>
															<th class="text-center">SO<sub>2</sub></th>
															<th class="text-center">NO<sub>2</sub></th>
															<th class="text-center">CO</th>
															<th class="text-center">O<sub>3</sub></th>
															<th class="text-center">平均气温</th>
															<th class="text-center">降水量</th>
															<th class="text-center">平均风速</th>
															<th class="text-center">静风频率</th>
														</tr>
														</thead>
														<tbody v-if="dataList!=null &&dataList.length>0">
														<tr v-for="item in dataList">
															<td class="text-right">{{item.POLLUTE_NUM}}</td>
															<td class="text-right">{{item.MAX_PM25}}</td>
															<td class="text-right">{{item.MAX_O3}}</td>
															<td class="text-right">{{item.AVG_PM25}}</td>
															<td class="text-right">{{item.AVG_PM10}}</td>
															<td class="text-right">{{item.AVG_SO2}}</td>
															<td class="text-right">{{item.AVG_NO2}}</td>
															<td class="text-right">{{item.AVG_CO}}</td>
															<td class="text-right">{{item.AVG_O3}}</td>
															<td class="text-right">{{item.TEMPERATURE}}</td>
															<td class="text-right">{{item.PRECIPITATION}}</td>
															<td class="text-right">{{item.WIND_SPEED}}</td>
															<td class="text-right">{{item.WIND_FREQUENCY}}</td>
														</tr>
														</tbody>
														<tbody v-else>
														<tr><td class="text-center" colspan="13">暂无数据！</td></tr>
														</tbody>
													</table>
												</div>
											</div>
										</form>
									</div>
									<div v-show="defaultLiIndex===1" :class="{'tab-pane':true,'active':defaultLiIndex==1}">
										<div class="col-xs-12" style="margin-bottom: 10px">
											<div class="col-xs-2" style="line-height: 34px">
												<label style="margin-right: 10px" class="control-label">
													<input type="radio"  value="hour" name="dateType" checked="checked" @click="changeDateType('hour')"/>
													<span class="lbl">小时数据</span>
												</label>
												<label class="control-label">
													<input type="radio"  value="day" name="dateType" @click="changeDateType('day')"/>
													<span class="lbl">日数据</span>
												</label>
											</div>
											<label class="col-xs-1 control-label no-padding-right"
												   style="line-height: 34px;text-align: right">查询时间:
											</label>
											<template v-if="param.dateType=='hour'">
												<div class="col-xs-2 ">
													<div class="input-group" @click="queryStartTime">
														<input key="startTime" type="text"
															   class="form-control" :value="param.startTime" id="startTime"
															   readonly="readonly" placeholder="开始时间">
														<span class="input-group-btn">
															<button type="button"
																	class="btn btn-white btn-default">
																<i class="ace-icon fa fa-calendar"></i>
															</button>
														</span>
													</div>
												</div>
												<label class="col-xs-1 control-label" style="line-height: 34px;padding-left:0px;width: 12px">~</label>
												<div class="col-xs-2 ">
													<div class="input-group" @click="queryEndTime">
														<input key="endTime" type="text"
															   class="form-control" :value="param.endTime" id="endTime"
															   readonly="readonly" placeholder="结束时间">
														<span class="input-group-btn">
															<button type="button"
																	class="btn btn-white btn-default">
																<i class="ace-icon fa fa-calendar"></i>
															</button>
														</span>
													</div>
												</div>
											</template>
											<template v-else>
												<div class="col-xs-2 ">
													<div class="input-group" @click="queryStartDate">
														<input key="startDate" type="text"
															   class="form-control" :value="param.startDate" id="startDate"
															   readonly="readonly" placeholder="开始时间">
														<span class="input-group-btn">
															<button type="button"
																	class="btn btn-white btn-default">
																<i class="ace-icon fa fa-calendar"></i>
															</button>
														</span>
													</div>
												</div>
												<label class="col-xs-1 control-label" style="line-height: 34px;padding-left:0px;width: 12px">~</label>
												<div class="col-xs-2 ">
													<div class="input-group" @click="queryEndDate">
														<input key="endDate" type="text"
															   class="form-control" :value="param.endDate" id="endDate"
															   readonly="readonly" placeholder="结束时间">
														<span class="input-group-btn">
															<button type="button"
																	class="btn btn-white btn-default">
																<i class="ace-icon fa fa-calendar"></i>
															</button>
														</span>
													</div>
												</div>
											</template>
											<div class="col-xs-* align-right">
												<button type="button" class="btn btn-info btn-default-ths"
														@click="queryPollutionAnalysisCharts">
													<i class="ace-icon fa fa-search"></i> 查询
												</button>
											</div>
										</div>
										<div class="col-xs-12" id="pollutionAnalysisCharts" style="width:100%;height:450px"></div>
										<div style="padding-top: 20px;">
											<div class="clo-xs-12 text-right" style="padding-bottom: 12px;">
												<button type="button" class="btn btn-xs btn-xs-ths" @click="updatePollutionAnalysisText">
													<i class="ace-icon fa fa-save"></i>保存
												</button>
											</div>
											<table class="table table-bordered table-hover">
												<tbody>
													<tr>
														<td class="active text-right" style="width: 20%;height: 60px;vertical-align: middle;font-size: 14px;">分析结论:</td>
														<td>
															<textarea v-model="analysisText" class="form-control" rows="3"></textarea>
														</td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>
									<div v-show="defaultLiIndex==2" :class="{'tab-pane':true,'active':defaultLiIndex==2}">
										<div class="row">
											<div class="col-xs-12 col-md-12">
												<h4 class="text-center" style="padding-bottom: 10px;">污染时段气象要素简析</h4>
												<table id="listTable" class="table table-bordered table-hover">
													<thead>
														<tr>
															<th class="text-center">时间</th>
															<th class="text-center">PM2.5日均值</th>
															<th class="text-center">平均气温°C</th>
															<th class="text-center">相对湿度%</th>
															<th class="text-center">降雨量mm</th>
															<th class="text-center">平均风速</th>
															<th class="text-center">静风频率</th>
															<th class="text-center">08逆温°C</th>
															<th class="text-center">20逆温°C</th>
														</tr>
													</thead>
													<tbody v-if="waterObj.list!=null && waterObj.list.length>0">
													<tr v-for="item in waterObj.list">
														<td class="text-center">{{item.MONITORTIME}}</td>
														<td class="text-right">{{item.PM25}}</td>
														<td class="text-right">{{item.TEMPERATURE}}</td>
														<td class="text-right">{{item.RHU}}</td>
														<td class="text-right">{{item.RAINFALL}}</td>
														<td class="text-right">{{item.WIND_SPEED}}</td>
														<td class="text-right">{{item.WIND_FREQUENCY}}</td>
														<td class="text-right">{{item.TEMP_INVERSION08}}</td>
														<td class="text-right">{{item.TEMP_INVERSION20}}</td>
													</tr>
													</tbody>
													<tbody v-else>
													<tr><td class="text-center" colspan="9">暂无数据！</td></tr>
													</tbody>
												</table>
												<my-pagination @handlecurrentchange="querywaterList()" :tableobj="waterObj"></my-pagination>
											</div>
											<div class="col-xs-12">
												<div id="waterCharts" style="height: 350px;"></div>
											</div>
                                            <div class="col-xs-12 text-right" style="padding-bottom: 12px;">
                                                <button type="button" class="btn btn-xs btn-xs-ths" @click="updateWaterAnalysis">
                                                    <i class="ace-icon fa fa-save"></i>保存
                                                </button>
                                            </div>
                                            <table class="table table-bordered table-hover">
                                                <tbody>
                                                <tr>
                                                    <td class="active text-right" style="width: 20%;height: 60px;vertical-align: middle;font-size: 14px;">分析结论:</td>
                                                    <td>
                                                        <textarea v-model="waterAnalysisText" class="form-control" rows="3"></textarea>
                                                    </td>
                                                </tr>
                                                </tbody>
                                            </table>
										</div>
									</div>
									<div v-show="defaultLiIndex==3" :class="{'tab-pane':true,'active':defaultLiIndex==3}">
										<div class="clo-xs-12 text-right" style="padding-bottom: 12px;">
											<button type="button" class="btn btn-xs btn-xs-ths" @click="updateForcastRef">
												<i class="ace-icon fa fa-save"></i>保存
											</button>
										</div>
										<table class="table table-bordered table-hover">
											<tbody>
											<tr>
												<td class="active text-right" style="width: 20%;height: 60px;vertical-align: middle;font-size: 14px;">案例归型及预报参考:</td>
												<td>
													<textarea v-model="forcastRef" class="form-control" rows="3"></textarea>
												</td>
											</tr>
											</tbody>
										</table>
									</div>
								</div>
							</div>
							<%--
							--%>
						</div>
					</div>
				</div>
			</div>
			<!--/.main-content-inner-->
		</div>
		<!-- /.main-content -->
	</div>

	<form class="form-horizontal" role="form" id="formhidden" action="${ctx}/eform/exceltemplate/download.vm" method="post">
		<input type="hidden" name="desigerid" id="desigerid" value="1">
	</form>
	<script type="text/javascript" src="${ctx}/assets/js/eform/eform_custom.js"></script>
	<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
	<script type="text/javascript">
		// 地址，必须
		var ctx = "${ctx}";
		var params = {
			id:'${id}'
		};
	</script>

	<script src="${ctx}/assets/components/artDialog/dist/dialog-plus.js"></script>
	<script src="${ctx}/assets/components/echarts/echarts.js"></script>
	<script src="${ctx}/assets/components/element-ui/index.js"></script>
	<!-- 分页组件 -->
	<%@ include file="/WEB-INF/jsp/components/common/page-pagination.jsp"%>
	<!-- 自己写的JS，请放在这里 -->
	<script src="${ctx}/assets/custom/analysis/forecastcastlibrary/view.js"></script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>预报案例库</title>
<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
<link rel="stylesheet" href="${ctx }/assets/components/element-ui/css/index.css" />

</head>
<body class="no-skin">
	<div class="main-container" id="main-container">
		<div class="main-content">
			<div class="main-content-inner fixed-page-header fixed-40">
				<div id="breadcrumbs" class="breadcrumbs">
					<ul class="breadcrumb">
						<li class="active">
							<h5 class="page-title">
								<i class="fa fa-suitcase"></i> 预报案例库
							</h5>
						</li>
					</ul>
				</div>
			</div>
			<div class="main-content-inner padding-page-content">
				<div class="page-content">
					<div class="space-4"></div>
					<div class="row">
						<div class="col-xs-12">
							<form class="form-horizontal" role="form" id="formList" method="post">
								<div class="form-group">
									<label class="col-xs-1 control-label no-padding-right">开始时间：</label>
									<div class="col-xs-3">
										<div class="input-group" @click="distributeTimeStart">
											<input type="text" class="form-control" id="distributeTimeStart" readonly="readonly"  placeholder="请选择开始时间">
												<span class="input-group-btn">
												<button type="button" class="btn btn-white btn-default">
													<i class="ace-icon fa fa-calendar"></i>
												</button>
											</span>
										</div>
									</div>
									<label class="col-xs-1 control-label " >结束时间</label>
									<div class="col-xs-3 ">
										<div class="input-group" @click="distributeTimeEnd">
											<input type="text" class="form-control" id="distributeTimeEnd" readonly="readonly" placeholder="请选择结束时间">
											<span class="input-group-btn">
												<button type="button" class="btn btn-white btn-default">
													<i class="ace-icon fa fa-calendar"></i>
												</button>
											</span>
										</div>
									</div>
									<div class="col-xs-* text-right">
										<div class="space-10 hidden-lg hidden-md hidden-sm"></div>
										<button type="button" class="btn btn-info btn-default-ths" @click="queryCastList">
											<i class="ace-icon fa fa-search"></i> 搜索
										</button>
										<button type="button" class="btn btn-purple btn-default-ths" @click="exportForcast">
											<i class="ace-icon fa fa-download"></i> 导出
										</button>
										<button type="button" class="btn btn-purple btn-default-ths" @click="caseAddIndex()" id="btnAdd">

											<i class="ace-icon fa fa-plus"></i> 添加
										</button>
									</div>
								</div>
								<div class="form-group">
									<label class="col-xs-1 control-label no-padding-right">天气类型：</label>
									<div class="col-xs-3 hidden-xs">
										<el-select v-model="param.weatherCodes"  style="width:100%"  multiple collapse-tags size="medium" placeholder="请选择">
											 <el-option v-for="item in weatherTypeList" :key="item.DICTIONARY_ID" :label="item.DICTIONARY_NAME" :value="item.DICTIONARY_CODE">
											</el-option>
                                        </el-select>
									</div>
									<label class="col-xs-1 control-label no-padding-right">污染物类型：</label>
									<div class="col-xs-3 hidden-xs">
										<el-select v-model="param.polluteCodes" style="width:100%"   multiple collapse-tags size="medium" placeholder="请选择">
										     <el-option
												v-for="item in pollutantList"
												:key="item.DICTIONARY_ID"
												:label="item.DICTIONARY_NAME"
												:value="item.DICTIONARY_CODE">
											</el-option>
                                        </el-select>
									</div>
								</div>
								<div class="row">
									<div class="col-xs-12 col-md-12" style="margin-top: 20px">
										<table id="listTable" class="table table-bordered table-hover">
											<thead>
												<tr>
													<th rowspan="2" class="text-center">开始时间</th>
													<th rowspan="2" class="text-center">结束时间</th>
													<th rowspan="2" class="text-center">影响类型</th>
													<th rowspan="2" class="text-center" >污染类型</th>
													<th rowspan="2" class="text-center">污染天数</th>
													<th colspan="2" class="text-center">最大浓度</th>
													<th colspan="6" class="text-center" >平均浓度</th>
													<th colspan="4" class="text-center">气象要素</th>
													<th rowspan="2" class="text-center">操作</th>
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
											<tbody v-if="pageObj.list!=null && pageObj.list.length>0">
												<tr v-for="item in pageObj.list">
													<td class="text-center">{{item.W_START_TIME}}</td>
													<td class="text-center">{{item.W_END_TIME}}</td>
													<td class="text-left">{{item.WEATHER_TYPE_NAME}}</td>
													<td class="text-center">{{item.POLLUTE_NAME}}</td>
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
													<td class="text-center">
															<a @click="view(item.PK_ID)">查看</a>
															<a @click="exportWord(item.PK_ID)">导出</a>
															<a @click="deleteById(item.PK_ID)">删除</a>
													</td>
												</tr>
											</tbody>
											<tbody v-else>
												<tr><td class="text-center" colspan="18">暂无数据！</td></tr>
											</tbody>
										</table>
										<my-pagination @handlecurrentchange="queryCastList()" :tableobj="pageObj"></my-pagination>
									</div>
								</div>
							</form>
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
	</script>
	<script src="${ctx}/assets/components/jQuery-Validation-Engine/jquery.validationEngine-zh_CN.js" type="text/javascript"></script>
	<script src="${ctx}/assets/components/jQuery-Validation-Engine/jquery.validationEngine.js" type="text/javascript"></script>
	<script src="${ctx}/assets/components/artDialog/dist/dialog-plus.js"></script>
	<script src="${ctx}/assets/components/element-ui/js/index.js"></script>
	<!-- 分页组件 -->
	<%@ include file="/WEB-INF/jsp/components/common/page-pagination.jsp"%>
	<!-- 自己写的JS，请放在这里 -->
	<script src="${ctx}/assets/custom/analysis/forecastcastlibrary/index.js"></script>
</body>
</html>
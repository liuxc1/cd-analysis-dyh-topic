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
					<form id="mainForm" class="form-horizontal" role="form"
						id="formList" method="post">
						<input type="hidden" name="PKID" value="${reportId}"
							id="PKIDInput">
						<div class="breadcrumbs">
							<ul class="breadcrumb">
								<li class="active">
									<h5 v-if="reportId" class="page-title">
										<i class="header-icon fa fa-edit"></i>分区预报-编辑
									</h5>

									<h5 v-if="!reportId" class="page-title">
										<i class="header-icon fa fa-plus"></i>分区预报-添加
									</h5>
								</li>
							</ul>
							<div class="btn-toolbar pull-right" role="toolbar">
								<button type="button"
									class="btn btn-xs btn-primary btn-xs-ths"
									@click="exportData()">
									<i class="ace-icon fa fa-cloud-download"></i> 模板下载
								</button>
								<button type="button"
									class="btn btn-xs btn-danger btn-xs-ths"
									@click="importData()">
									<i class="ace-icon fa fa-cloud-upload"></i> 数据导入
								</button>
								<button type="button"
									class="btn btn-xs btn-xs-ths"
									@click="saveData('UPLOAD');">
									<i class="ace-icon fa fa-upload"></i> 提交
								</button>
								<button type="button"
									class="btn btn-xs btn-xs-ths"
									@click="saveData('TEMP');">
									<i class="ace-icon fa fa-save"></i> 暂存
								</button>
								<button type="button" class="btn btn-xs btn-xs-ths btn-danger"
									@click="cancel()">
									<i class="ace-icon fa fa-reply"></i> 返回
								</button>
							</div>
						</div>
						<hr class="no-margin" />
						<div class="panel-body">
							<div class="row">
								<div class="col-xs-12 form-group">
									<label class="col-xs-1 control-label no-padding-right">填报日期：</label>
									<div class="col-xs-2">
										<div class="col-xs-4 no-padding-right no-padding-left"
											style="width: 140px;">
											<div v-if="reportId">
												<label class="col-xs-12 control-label"
													style="text-align: left;">{{resultData.FORECAST_TIME}}</label>
											</div>
											<div v-if="!reportId" class="input-group" id="divDate"
												@click="wdatePicker">
												<input type="text" id="txtDateStart" class="form-control"
													v-model="resultData.FORECAST_TIME" name="datetime"
													readonly="readonly"> <span class="input-group-btn">
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
								<div class="col-xs-12 text-center"
									style="margin-top: 10px; padding-left: 5%; padding-right: 5%;">
									<div class="text-left">未来24小时分区气象扩散条件：</div>
									<textarea maxlength="1000" class="form-control"
										data-validation-engine="validate[maxSize[1000]]"
										v-model="resultData.AREA_OPINION" placeholder="请输入未来24小时分区气象扩散条件，最多1000个字符"
										style="width: 100%; height: 150px; margin: 5px auto; resize: none;"></textarea>
								</div>
								<div class="col-xs-12 text-center"
									style="margin-top: 10px; padding-left: 5%; padding-right: 5%;">
									<div class="text-left">重要提示：</div>
									<textarea maxlength="1000" class="form-control "
										data-validation-engine="validate[maxSize[1000]]"
										v-model="resultData.HINT " placeholder="请输入重要提示信息，最多1000个字符"
										style="width: 100%; height: 150px; margin: 5px auto; resize: none;"></textarea>
								</div>
								
								<div class="col-xs-12 text-center"
									style="margin-top: 10px; padding-left: 5%; padding-right: 5%;">
									<div class="text-left">
										<label> <i
											class="ace-icon fa fa-asterisk red smaller-70"></i>落款：
										</label> <input maxlength="100" class="form-control"
											data-validation-engine="validate[required,maxSize[100]]"
											placeholder="请输入落款，最多100个字符"
											name="inscribe" v-model="resultData.INSCRIBE" maxLength="100"
											style="width: 100%;" />
									</div>
								</div>
							</div>

							<div class="col-xs-12 text-center" style="margin-top: 10px;">
								<ul class="nav nav-tabs" role="tablist"
									style="width: 90%; margin-left: 5%">
								</ul>
								<div class="tab-content" style="width: 90%; margin-left: 5%">
									<div role="tabpanel" class="tab-pane active" id="tab_3">
										<table id="modeltable" class="table table-bordered"	style="width: 95%; margin-left: 3%">
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
														style="border-bottom: 1px solid #D5D5D5">{{form.ONEDAY
														}}</th>
													<th class="center" colspan="2"
														style="border-bottom: 1px solid #D5D5D5">{{form.TWODAY
														}}</th>
													<th class="center" colspan="2"
														style="border-bottom: 1px solid #D5D5D5">{{form.THREEDAY
														}}</th>
												</tr>
												<tr>
													<th class="center">AQI范围</th>
													<th class="center">首要污染物 <i
														class="fa fa-plus-circle open_modal" pulltype="1"
														style="float: right; cursor: pointer;"></i></th>
													<th class="center">AQI范围</th>
													<th class="center">首要污染物 <i
														class="fa fa-plus-circle open_modal" pulltype="2"
														style="float: right; cursor: pointer;"></i></th>
													<th class="center">AQI范围</th>
													<th class="center">首要污染物 <i
														class="fa fa-plus-circle open_modal" pulltype="3"
														style="float: right; cursor: pointer;"></i></th>
												</tr>
											</thead>
											<tr v-for="(datas3d, datas3dindex) in form3d"
												:key="datas3dindex">
												<td style="vertical-align: middle;">
													{{datas3d.REGIONNAME }}</td>
												<td><input type="text" class="3dbefore beforenum"
													data-validation-engine="validate[min[0],max[470],custom[integer]]" data-prompt-position="topLeft"
													v-model="datas3d.AQI_START1"
													v-on:input="inputAqi(datas3dindex,'add',1)"> 至 <input
													type="text" class="3dafter afternum"
													data-validation-engine="validate[min[0],max[500],custom[integer]]" data-prompt-position="bottomRight"
													v-model="datas3d.AQI_END1"
													v-on:input="inputAqi(datas3dindex,'subtract',1)"></td>
												<td><select :id="datas3d.REGIONNAME+'_1'"
													class="selectpicker form-control selectpull1"
													v-model="datas3d.PULLNAME1" multiple data-max-options="2"
													title="无">
														<option v-if="getstate(datas3d.PULLNAME1,'PM2.5')>=0"
															selected value="PM2.5">PM₂.₅</option>
														<option v-else value="PM2.5">PM₂.₅</option>
														<option v-if="getstate(datas3d.PULLNAME1,'PM10')>=0"
															selected value="PM10">PM₁₀</option>
														<option v-else value="PM10">PM₁₀</option>
														<option v-if="getstate(datas3d.PULLNAME1,'O3')>=0"
															selected value="O3">O₃</option>
														<option v-else value="O3">O₃</option>
														<option v-if="getstate(datas3d.PULLNAME1,'CO')>=0"
															selected value="CO">CO</option>
														<option v-else value="CO">CO</option>
														<option v-if="getstate(datas3d.PULLNAME1,'SO2')>=0"
															selected value="SO2">SO₂</option>
														<option v-else value="SO2">SO₂</option>
														<option v-if="getstate(datas3d.PULLNAME1,'NO2')>=0"
															selected value="NO2">NO₂</option>
														<option v-else value="NO2">NO₂</option>
												</select></td>
												<td><input type="text" class="3dbefore beforenum "
													data-validation-engine="validate[min[0],max[470],custom[integer]]" data-prompt-position="topLeft"
													v-model="datas3d.AQI_START2 "
													v-on:input="inputAqi(datas3dindex,'add',2)"> 至 <input
													type="text" class="3dafter afternum "
													data-validation-engine="validate[min[0],max[500],custom[integer]]" data-prompt-position="bottomRight"
													v-model="datas3d.AQI_END2 "
													v-on:input="inputAqi(datas3dindex,'subtract',2)"></td>
												<td><select :id="datas3d.REGIONNAME+'_2'"
													class="selectpicker form-control selectpull2" 
													v-model="datas3d.PULLNAME2 " multiple data-max-options="2"
													title="无">
														<option v-if="getstate(datas3d.PULLNAME2,'PM2.5')>=0"
															selected value="PM2.5">PM₂.₅</option>
														<option v-else value="PM2.5">PM₂.₅</option>
														<option v-if="getstate(datas3d.PULLNAME2,'PM10')>=0"
															selected value="PM10">PM₁₀</option>
														<option v-else value="PM10">PM₁₀</option>
														<option v-if="getstate(datas3d.PULLNAME2,'O3')>=0"
															selected value="O3">O₃</option>
														<option v-else value="O3">O₃</option>
														<option v-if="getstate(datas3d.PULLNAME2,'CO')>=0"
															selected value="CO">CO</option>
														<option v-else value="CO">CO</option>
														<option v-if="getstate(datas3d.PULLNAME2,'SO2')>=0"
															selected value="SO2">SO₂</option>
														<option v-else value="SO2">SO₂</option>
														<option v-if="getstate(datas3d.PULLNAME2,'NO2')>=0"
															selected value="NO2">NO₂</option>
														<option v-else value="NO2">NO₂</option>
												</select></td>
												<td><input type="text" class="3dbefore beforenum "
													data-validation-engine="validate[min[0],max[470],custom[integer]]" data-prompt-position="topLeft"
													v-model="datas3d.AQI_START3 "
													v-on:input="inputAqi(datas3dindex,'add',3)"> 至 <input
													type="text" class="3dafter afternum "
													data-validation-engine="validate[min[0],max[500],custom[integer]]" data-prompt-position="bottomRight"
													v-model="datas3d.AQI_END3 "
													v-on:input="inputAqi(datas3dindex,'subtract',3)"></td>
												<td><select :id="datas3d.REGIONNAME+'_3'"
													class="selectpicker form-control selectpull3"
													v-model="datas3d.PULLNAME3 " multiple data-max-options="2"
													title="无">
														<option v-if="getstate(datas3d.PULLNAME3,'PM2.5')>=0"
															selected value="PM2.5">PM₂.₅</option>
														<option v-else value="PM2.5">PM₂.₅</option>
														<option v-if="getstate(datas3d.PULLNAME3,'PM10')>=0"
															selected value="PM10">PM₁₀</option>
														<option v-else value="PM10">PM₁₀</option>
														<option v-if="getstate(datas3d.PULLNAME3,'O3')>=0"
															selected value="O3">O₃</option>
														<option v-else value="O3">O₃</option>
														<option v-if="getstate(datas3d.PULLNAME3,'CO')>=0"
															selected value="CO">CO</option>
														<option v-else value="CO">CO</option>
														<option v-if="getstate(datas3d.PULLNAME3,'SO2')>=0"
															selected value="SO2">SO₂</option>
														<option v-else value="SO2">SO₂</option>
														<option v-if="getstate(datas3d.PULLNAME3,'NO2')>=0"
															selected value="NO2">NO₂</option>
														<option v-else value="NO2">NO₂</option>
												</select></td>
											</tr>
										</table>
									</div>
								</div>
								
								<div class="col-xs-12 text-center" style="margin-top: 10px; padding-left: 5%; padding-right: 5%;">
									<div class="text-left">区县重要提示：</div>
									<div class="text-right">
										<button type="button"  class="btn btn-xs btn-primary btn-xs-ths"
											@click="createRow();">
											<i class="ace-icon fa fa-plus"></i> 添加区县重要提示
										</button>
									</div>
										<div class="panel panel-default">
									    <div class="panel-body">
											<table id ="districtTable" class="table table-bordered"	style="width: 95%; margin-left: 3%">
											<colgroup>
												<col width="30%" />
												<col width="70%" />
											</colgroup>
												<thead>
													<tr>
														<th class="center">区县</th>
														<th class="center">重要提示</th>
													</tr>
												</thead>
												<tbody>
												<tr v-for="(datasTips, datasTipsIndex) in formTips" >
													<td onmouseout="vue.checkDuplicate(this)"><select class="selectpicker form-control districtMsg"  multiple title="无" data-width="300">
													<option v-for="option in countrys"  v-bind:selected="getIsSelect(option.REGIONCODE,datasTips.REGION_CODE)"  v-bind:value="option.REGIONCODE">{{option.REGIONNAME}}</option>
													</select></td>
													<td><input type="text" class="form-control important_tips"  v-model="datasTips.IMPORTANT_HINTS" data-validation-engine="validate[maxSize[1000]]" maxlength="1000"/></td>
												</tr>
												</tbody>
											</table>
												<h6 id ="districtWarning" class="text-left hidden" style="color: red; margin-left: 3%"><span >** 以上区县记录重复 </span></h6>
									    </div>
									</div>
								</div>
								<div class="col-xs-12 text-left"
									style="width: 92%; margin-left: 4%; margin-right: 0%; margin-top: 0%">
									<div class="text-left" style="margin-bottom:5px;">附件：</div>
									<file-upload-table ref="fileUploadTable"
										:delete-file-ids="resultData.DELETE_FILE_IDS"
										:file-list="fileList" allow-file-types="gif,jpg,png"></file-upload-table>
								</div>
							</div>
						</div>
			
				</form>
					</div>
				<div id="sourceSelection" pulltype="0" style="display: none;">
					<div class="col-xs-12"
						style="padding-top: 10px; padding-bottom: 10px; height: 100px; border: 1px solid #e9e9e9;">
						<form class="form-horizontal" role="form">
							<div class="form-group align-center">
								<label><input type="checkbox" name="pull" value="PM2.5">PM₂.₅</label>
								<label><input type="checkbox" name="pull" value="PM10">PM₁₀</label>
								<label><input type="checkbox" name="pull" value="O3">O₃</label>
								<label><input type="checkbox" name="pull" value="CO">CO</label>
								<label><input type="checkbox" name="pull" value="SO2">SO₂</label>
								<label><input type="checkbox" name="pull" value="NO2">NO₂</label>
							</div>
						</form>
						<div class="col-xs-12 align-center" style="margin-top: 5px;">
							<label class="modal_label col-xs-3" style="color: red; float: left"></label>
							<a class="btn btn-xs btn-primary btn-xs-ths pull_modal"
								style="width: 80px; margin-right: 30px;margin-left: -130px;">确定</a> <a
								class="btn btn-xs btn-primary btn-xs-ths" style="width: 80px;"
								v-on:click="cancelDialog()">取消</a>
						</div>
					</div>
				</div>
				
			</div>
		</div>
		<!--/.main-content-inner-->
	</div>
	<!-- /.main-content -->
<!-- 	</div> -->
	<form class="form-horizontal" role="form" id="formhidden" action="${ctx}/eform/exceltemplate/download.vm" method="post">
		<input type="hidden" name="desigerid" id="desigerid" value="1">
	</form>
	<script type="text/javascript" src="${ctx}/assets/js/eform/eform_custom.js"></script>
	<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
	<script type="text/javascript">
		// 地址，必须
		var ctx = "${ctx}";
		var isRead = "${isRead}";
		var reportId = "${reportId}";
		var loginName="${LOGINNAME}"
	</script>
	<script type="text/javascript"
		src="${ctx}/assets/components/bootstrap-select/dist/js/bootstrap-select.min.js"></script>
	<script type="text/javascript"
		src="${ctx}/assets/components/bootstrap-select/dist/js/i18n/defaults-zh_CN.min.js"></script>
	<!-- vue插件 -->
	<script type="text/javascript"
		src="${ctx}/assets/components/vue/vue.min.js"></script>
	<!-- 引入组件库elementui -->
	<script src="${ctx }/assets/components/element-ui/js/index.js"></script>
	<!-- Dialog 工具类 -->
	<script type="text/javascript"
		src="${ctx}/assets/custom/common/util/dialog-util.js"></script>
	<!-- Ajax 工具类 -->
	<script type="text/javascript"
		src="${ctx}/assets/custom/common/util/ajax-util.js"></script>
	<!-- 日期时间 工具类 -->
	<script type="text/javascript"
		src="${ctx}/assets/custom/common/util/date-time-util.js"></script>
	<!-- 文件上传 工具类 -->
	<script type="text/javascript"
		src="${ctx}/assets/custom/common/util/file-upload-util.js"></script>
	<!-- 文件下载 工具类 -->
	<script type="text/javascript"
		src="${ctx}/assets/custom/common/util/file-download-util.js"></script>
	<!-- 分析平台-文件上传表格组件-逻辑js -->
	<script type="text/javascript"
		src="${ctx}/assets/custom/components/analysis/js/file-upload-table.js"></script>
	<!-- 分析平台-文件上传表格组件-模板 -->
	<script id="vue-template-file-upload-table" type="text/x-template">
			<%@ include file="/WEB-INF/jsp/components/analysis/file-upload-table.jsp" %>
		</script>
	<script type="text/javascript"
		src="${ctx}/assets/custom/analysis/forecast/airforecastparition/partitionEditOrAdd.js"></script>
</body>
</html>
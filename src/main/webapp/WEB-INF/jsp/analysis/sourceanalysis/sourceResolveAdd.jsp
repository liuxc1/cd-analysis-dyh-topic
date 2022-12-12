<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
<head>
<title>成都市源解析</title>
<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
<!-- 引入样式 -->
<style type="text/css">
/** 自定义css **/
</style>
</head>

<body>
	<div id="index-app" class="main-container" style="width: 100%; height: 100%; overflow: auto;" v-cloak>
		<!-- 标题 -->
		<div class="main-content-inner fixed-page-header fixed-40">
			<div id="breadcrumbs" class="breadcrumbs">
				<ul class="breadcrumb">
					<li class="active">
						<h5 class="page-title">
							<i class="header-icon fa fa-plus"  v-if="param.STATE == ''">
								成都市源解析-添加
							</i>
							<i class="header-icon fa fa-edit" v-if="param.STATE != ''">
								成都市源解析-修改
							</i>
							
						</h5>
					</li>
				</ul>	
				
				<div class="btn-toolbar pull-right" style="padding-top:10px">
					<button type="button" class="btn btn-xs   btn-xs-ths" id="btnDownload" @click="downloadExcel" v-if="param.STATE == ''">
							<i class="ace-icon fa fa-cloud-download"></i> 模板下载
					</button>
					<button type="button" class="btn btn-xs btn-danger btn-xs-ths" id="btnUpload" @click="uploadExcel" v-if="param.STATE == ''">
							<i class="ace-icon fa fa-cloud-upload"></i> 数据导入
					</button>
					<button type="button" class="btn btn-xs btn-xs-ths" id="btnSubmit" @click="submit">
							<i class="ace-icon fa fa-upload"></i> 提交
					</button>
					<button type="button" class="btn btn-xs btn-xs-ths" id="btnSave" @click="save">
							<i class="ace-icon fa fa-save"></i> 暂存
					</button>
					<button type="button" class="btn btn-xs btn-xs-ths" id="btnBack" @click="cancel">
						 	<i class="ace-icon fa fa-reply"></i> 返回
					</button>
				</div>
			</div>
		</div>

		<div class="main-content-inner padding-page-content">
			<div class="main-content">
				<div class="page-content">
					<form class="form-horizontal" role="form" id="formList" action="" method="post">
						<table class="table table-bordered">
							<tbody>
								<tr>
									<td class="text-right active" width="20%">
										<label class="col-md-12 control-label no-padding-right">
									 	 	<i class="ace-icon fa fa-asterisk red smaller-70"></i>  填报年份：
									 	</label>
									</td>
									<td width="80%">
										<div class="col-xs-3 no-padding-left">
											<div id="div-start-date0" class="input-group">
												 <input id="reportYear" type="text" readonly="readonly" :disabled="param.disable" data-validation-engine="validate[required]" v-model="param.REPORT_YEAR" class="form-control" @click="reportYear" />
												 <span class="input-group-btn">
													 <button  type="button" @click="reportYear" class="btn btn-white btn-default">
														 <i class="ace-icon fa fa-calendar"></i>
													 </button>
												 </span>
											</div>
										</div>
										<div class="col-xs-6 no-padding-left">
											<p class="text-muted" style="margin-bottom: 0px;margin-top: 12px;">提示：数据导入成功之后年份不可重新选择，且不能重复导入！</p>
										</div>
									</td>
								</tr>
								<tr>
									<td class="text-right active" width="20%">
										<label  class="col-md-12 control-label no-padding-right">
											<i class="ace-icon fa fa-asterisk red smaller-70"></i>源解析名称：
									 	</label>
									</td>
									<td width="80%">
										<div class="col-md-12 no-padding-left">
											<input type="text" data-validation-engine="validate[required,maxSize[40],funcCall[cuFilteringSpecialCharacters]]" maxlength="40" v-model="param.REPORT_NAME" class="form-control" placeholder="必填，且字符长度不能超过40字符。">
										</div>
									</td>
								</tr>
								<tr>
									<td class="text-right active" width="20%">
										<!-- 设置当前导入数据记录的report-id -->
										<input type="hidden" v-model="param.REPORT_ID"  class="form-control">
									 	<label  class="col-md-12 control-label no-padding-right">
											<i class="ace-icon fa fa-asterisk red smaller-70"></i> PM₂.₅组分特征解析：
									 	</label>
									</td>
									<td width="80%">
										<div class="col-md-12 no-padding-left">
											<textarea v-model="param.FIELD1" class="form-control" style="width: 100%; height: 100px;  resize:none" data-validation-engine="validate[required,maxSize[1000],funcCall[cuFilteringSpecialCharacters]]" maxlength="1000" placeholder="必填，且字符长度不能超过1000字符。"></textarea>
										</div>
									</td>
								</tr>
								<tr>
									<td class="text-right active" width="20%">
										<label class="col-md-12 control-label no-padding-right">
											<i class="ace-icon fa fa-asterisk red smaller-70"></i> PM₂.₅综合源解析：
									 	</label>
									</td>
									<td>
										<div class="col-md-12 no-padding-left">
										<textarea v-model="param.FIELD2" class="form-control" style="width: 100%; height: 100px; resize:none"  data-validation-engine="validate[required,maxSize[1000],funcCall[cuFilteringSpecialCharacters]]" maxlength="1000" placeholder="必填，且字符长度不能超过1000字符。"></textarea>
										</div>
									</td>
								</tr>
								<tr>
									<td class="text-right active" width="20%">
										<label class="col-md-12 control-label no-padding-right">
									 		<i class="ace-icon fa fa-asterisk red smaller-70"></i> PM₂.₅历年源解析：
									 	</label>
									</td>
									<td width="80%">
										<div class="col-md-12 no-padding-left">
											<textarea v-model="param.FIELD3" class="form-control" style="width: 100%; height: 100px; resize:none" data-validation-engine="validate[required,maxSize[1000],funcCall[cuFilteringSpecialCharacters]]" maxlength="1000" placeholder="必填，且字符长度不能超过1000字符。"></textarea>
										</div>
									</td>
								</tr>
								<tr>
									<td class="text-right active" width="20%">
										<label  class="col-md-12 control-label no-padding-right">
											<i class="ace-icon fa fa-asterisk red smaller-70"></i> PM₁₀组分特征解析：
									 	</label>
									</td>
									<td width="80%">
										<div class="col-md-12 no-padding-left">
											<textarea v-model="param.FIELD4" class="form-control" style="width: 100%; height: 100px;  resize:none" data-validation-engine="validate[required,maxSize[1000],funcCall[cuFilteringSpecialCharacters]]" maxlength="1000" placeholder="必填，且字符长度不能超过1000字符。"></textarea>
										</div>
									</td>
								</tr>
								<tr>
									<td class="text-right active" width="20%">
										<label class="col-md-12 control-label no-padding-right">
											<i class="ace-icon fa fa-asterisk red smaller-70"></i> PM₁₀综合源解析：
									 	</label>
									</td>
									<td width="80%">
										<div class="col-md-12 no-padding-left">
											<textarea v-model="param.FIELD5" class="form-control" style="width: 100%; height: 100px; resize:none"  data-validation-engine="validate[required,maxSize[1000],funcCall[cuFilteringSpecialCharacters]]" maxlength="1000" placeholder="必填，且字符长度不能超过1000字符。"></textarea>
										</div>
									</td>
								</tr>
								<tr>
									<td class="text-right active" width="20%">
										<label class="col-md-12 control-label no-padding-right">
									 		<i class="ace-icon fa fa-asterisk red smaller-70"></i> PM₁₀历年源解析：
									 	</label>
									</td>
									<td width="80%">
										<div class="col-md-12 no-padding-left">
											<textarea v-model="param.FIELD6" class="form-control" style="width: 100%; height: 100px; resize:none" data-validation-engine="validate[required,maxSize[1000],funcCall[cuFilteringSpecialCharacters]]" maxlength="1000" placeholder="必填，且字符长度不能超过1000字符。"></textarea>
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</form>
			</div>
		</div>
	</div>
	<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
	<script type="text/javascript">
		var ctx = '${ctx}';
		var id = '${paramsMap.REPORT_ID}';
		var state = '${paramsMap.state}';
	</script>
	<!-- vue插件 -->
	<!--[if lte IE 9]>
	<script type="text/javascript" src="${ctx}/assets/components/babel-polyfill/polyfill.min.js"></script>
	<![endif]-->
	<!-- vue插件 -->
	<script type="text/javascript" src="${ctx}/assets/components/vue/vue.min.js"></script>
	<!-- vue-分页组件 -->
	<%@ include file="/WEB-INF/jsp/components/common/page-pagination.jsp" %> 
	<!-- Dialog 工具类 -->
	<script type="text/javascript" src="${ctx}/assets/custom/common/util/dialog-util.js"></script>
		<!-- 日期时间 工具类 -->
	<script type="text/javascript" src="${ctx}/assets/custom/common/util/date-time-util.js"></script>
	<!-- Ajax 工具类 -->
	<script type="text/javascript" src="${ctx}/assets/custom/common/util/ajax-util.js"></script>
	<!-- 自定义js -->
	<script type="text/javascript" src="${ctx }/assets/custom/analysis/sourceAnalysis/sourceResolveAdd.js"></script>
	
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>区县源解析</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
<!-- 引入样式 -->
<!-- 分析平台-文件上传表格组件-样式文件 -->
<link href="${ctx }/assets/custom/components/analysis/css/file-upload-table.css?v=20221129015223" rel="stylesheet"/>
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
							<i class="header-icon fa fa-plus" v-if="report.STATE == ''">
								区县源解析-添加
							</i>
							
							<i class="header-icon fa fa-edit" v-if="report.STATE != ''">
								区县源解析-修改
							</i>
							
						</h5>
					</li>
				</ul>	
				
				<div class="btn-toolbar pull-right" style="padding-top:10px">
					<button type="button" class="btn btn-xs   btn-xs-ths" id="btnDownload" v-if="report.STATE == ''" @click="templateDownload">
							<i class="ace-icon fa fa-cloud-download"></i> 模板下载
					</button>
					<button type="button" class="btn btn-xs btn-danger btn-xs-ths" id="btnUpload" v-if="report.STATE == ''" @click="uploadExcel">
							<i class="ace-icon fa fa-cloud-upload"></i> 数据导入
					</button>
					<button type="button" class="btn btn-xs btn-xs-ths" id="btnSubmit" @click="saveData('UPLOAD')">
							<i class="ace-icon fa fa-upload"></i> 提交
					</button>
					<button type="button" class="btn btn-xs btn-xs-ths" id="btnSave" @click="saveData('TEMP')">
							<i class="ace-icon fa fa-save"></i> 暂存
					</button>
					<button type="button" class="btn btn-xs btn-xs-ths" id="btnBack" @click="cancel">
						 	<i class="ace-icon fa fa-reply"></i> 返回
					</button>
				</div>
			</div>
		</div>

		<div class="main-content-inner padding-page-content">
			<!-- 文件来源 -->
			<input type="hidden" id="file-sources" value="${fileSources}"/>
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
												 <input id="reportYear" type="text" readonly="readonly" @click="reportYear" :disabled="param.disable" v-model="report.REPORT_YEAR" data-validation-engine="validate[required]" class="form-control"/>
												 <span class="input-group-btn">
													 <button  type="button" class="btn btn-white btn-default" @click="reportYear">
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
											<input type="text" v-model="report.REPORT_NAME" data-validation-engine="validate[required,maxSize[200],funcCall[cuFilteringSpecialCharacters]]" maxlength="40"  class="form-control" placeholder="必填，且字符长度不能超过40字符。">
										</div>
									</td>
								</tr>
								<tr>
									<td class="text-right active" width="20%">
										<!-- 设置当前导入数据记录的report-id -->
										<input type="hidden" class="form-control">
									 	<label  class="col-md-12 control-label no-padding-right">
											<i class="ace-icon fa fa-asterisk red smaller-70"></i> PM₂.₅组分特征-夏季解析：
									 	</label>
									</td>
									<td width="80%">
										<div class="col-md-12 no-padding-left">
											<textarea  class="form-control" v-model="report.FIELD1" style="width: 100%; height: 100px;  resize:none" data-validation-engine="validate[required,maxSize[1000],funcCall[cuFilteringSpecialCharacters]]" maxlength="1000" placeholder="必填，且字符长度不能超过1000字符。"></textarea>
										</div>
									</td>
								</tr>
								<tr>
									<td class="text-right active" width="20%">
										<label class="col-md-12 control-label no-padding-right">
											<i class="ace-icon fa fa-asterisk red smaller-70"></i> PM₂.₅组分特征-冬季解析：
									 	</label>
									</td>
									<td>
										<div class="col-md-12 no-padding-left">
										<textarea  class="form-control"  v-model="report.FIELD2" style="width: 100%; height: 100px; resize:none"  data-validation-engine="validate[required,maxSize[1000],funcCall[cuFilteringSpecialCharacters]]" maxlength="1000" placeholder="必填，且字符长度不能超过1000字符。"></textarea>
										</div>
									</td>
								</tr>
								<tr>
									<td class="text-right active" width="20%">
										<label class="col-md-12 control-label no-padding-right">
									 		<i class="ace-icon fa fa-asterisk red smaller-70"></i> PM₁₀组分特征-夏季解析：
									 	</label>
									</td>
									<td width="80%">
										<div class="col-md-12 no-padding-left">
											<textarea  class="form-control"  v-model="report.FIELD3" style="width: 100%; height: 100px; resize:none" data-validation-engine="validate[required,maxSize[1000],funcCall[cuFilteringSpecialCharacters]]" maxlength="1000" placeholder="必填，且字符长度不能超过1000字符。"></textarea>
										</div>
									</td>
								</tr>
								<tr>
									<td class="text-right active" width="20%">
										<label  class="col-md-12 control-label no-padding-right">
											<i class="ace-icon fa fa-asterisk red smaller-70"></i> PM₁₀组分特征-冬季解析：
									 	</label>
									</td>
									<td width="80%">
										<div class="col-md-12 no-padding-left">
											<textarea  class="form-control"  v-model="report.FIELD4" style="width: 100%; height: 100px;  resize:none" data-validation-engine="validate[required,maxSize[1000],funcCall[cuFilteringSpecialCharacters]]" maxlength="1000" placeholder="必填，且字符长度不能超过1000字符。"></textarea>
										</div>
									</td>
								</tr>
								<tr>
									<td class="text-right active" width="20%">
										<label class="col-md-12 control-label no-padding-right">
											<i class="ace-icon fa fa-asterisk red smaller-70"></i> 区县源解析：
									 	</label>
									</td>
									<td width="80%">
										<div class="col-md-12 no-padding-left">
											<textarea  class="form-control"  v-model="report.FIELD5" style="width: 100%; height: 100px; resize:none"  data-validation-engine="validate[required,maxSize[1000],funcCall[cuFilteringSpecialCharacters]]" maxlength="1000" placeholder="必填，且字符长度不能超过1000字符。"></textarea>
										</div>
									</td>
								</tr>
								<tr>
									<td class="text-right active" width="20%">
										<label class="col-md-12 control-label no-padding-right">
									 		区县源解析附件：
									 	</label>
									</td>
									<td width="80%">
										<div class="col-md-12 no-padding-left">
											<file-upload-table ref="fileUploadTable" :file-list="report.fileList" allow-file-types="jpg,png,gif" :delete-file-ids="report.deleteFileIds" min-file-number="0" max-file-number="10"></file-upload-table>
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
	<script type="text/javascript" src="${ctx}/assets/components/babel-polyfill/polyfill.min.js?v=20221129015223"></script>
	<![endif]-->
	<!-- vue插件 -->
	<script type="text/javascript" src="${ctx}/assets/components/vue/vue.min.js?v=20221129015223"></script>
	<!-- 引入组件库elementui -->
	<script src="${ctx }/assets/components/element-ui/js/index.js?v=20221129015223"></script>
	<!-- Dialog 工具类 -->
	<script type="text/javascript" src="${ctx}/assets/custom/common/util/dialog-util.js?v=20221129015223"></script>
	<!-- Ajax 工具类 -->
	<script type="text/javascript" src="${ctx}/assets/custom/common/util/ajax-util.js?v=20221129015223"></script>
	<!-- 日期时间 工具类 -->
	<script type="text/javascript" src="${ctx}/assets/custom/common/util/date-time-util.js?v=20221129015223"></script>
	<!-- 文件上传 工具类 -->
	<script type="text/javascript" src="${ctx}/assets/custom/common/util/file-upload-util.js?v=20221129015223"></script>
	<!-- 文件下载 工具类 -->
	<script type="text/javascript" src="${ctx}/assets/custom/common/util/file-download-util.js?v=20221129015223"></script>
	<!-- 分析平台-文件上传表格组件-逻辑js -->
	<script type="text/javascript" src="${ctx}/assets/custom/components/analysis/js/file-upload-table.js?v=20221129015223"></script>
	<!-- 分析平台-文件上传表格组件-模板 -->
	<script id="vue-template-file-upload-table" type="text/x-template">
		<%@ include file="/WEB-INF/jsp/components/analysis/file-upload-table.jsp" %>
	</script>
	<!-- 自定义js -->
	<script type="text/javascript" src="${ctx }/assets/custom/analysis/sourceAnalysis/distinctSourceResolveAdd.js?v=20221129015223"></script>
	
	
</body>
</html>
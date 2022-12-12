<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>决策措施专栏</title>
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp" %>
    <!-- 分析平台-文件上传表格组件-样式文件 -->
    <link href="${ctx }/assets/custom/components/analysis/css/file-upload-table.css" rel="stylesheet"/>
    <link href="${ctx}/assets/components/element-ui/lib/theme-chalk/index.css" rel="stylesheet" type="text/css">
</head>
<body class="no-skin">
<div class="main-container" id="main-container" v-cloak>
    <div class="main-content-inner fixed-page-header fixed-40">
        <div id="breadcrumbs" class="breadcrumbs">
            <ul class="breadcrumb">
                <li class="active">
                    <h5 class="page-title" v-if="isAdd=='1'">
                        <i class="header-icon fa fa-edit"></i>
                        {{menuName}}-添加
                    </h5>
                    <h5 class="page-title" v-else>
                        <i class="header-icon fa fa-edit"></i>
                        {{menuName}}-编辑
                    </h5>
                </li>
            </ul>
            <div class="align-right" style="float: right; padding-right: 5px;">
                <button type="button" class="btn btn-xs btn-xs-ths" @click="saveData('TEMP')">
                    <i class="ace-icon fa fa-upload"></i> 暂存
                </button>
                <button type="button" class="btn btn-xs btn-xs-ths" @click="saveData('UPLOAD')">
                    <i class="ace-icon fa fa-check"></i> 提交
                </button>
                <button type="button" class="btn btn-xs btn-xs-ths btn-danger" @click="cancel">
                    <i class="ace-icon fa fa-reply"></i> 取消
                </button>
            </div>
        </div>
    </div>
    <div class="main-content-inner padding-page-content">
        <div class="main-content">
            <div class="page-content">
                <form id="mainForm" class="form-horizontal" role="form" method="post">
                    <div class="space-4"></div>
                    <table class="table table-bordered">
                        <tbody>
                        <tr>
                            <th class="text-right" width="20%">
                                <label class="col-sm-12 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    日期：
                                </label>
                            </th>
                            <td width="80%">
                                <div class="col-sm-2 no-padding">
                                    <div class="input-group" id="divDate" @click="wdatePicker">
                                        <input type="text" id="txtDateStart" class="form-control"
                                               data-validation-engine="validate[required]"
                                               v-model="report.reportTime" name="datetime" readonly="readonly">
                                        <span class="input-group-btn">
												<button type="button" class="btn btn-white btn-default"
                                                        id="btnDateStart" readonly="readonly">
													<i class="ace-icon fa fa-calendar"></i>
												</button>
											</span>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right" width="20%">
                                <label class="col-sm-12 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    名称：
                                </label>
                            </th>
                            <td width="80%">
                                <div class="col-sm-12 no-padding">
                                    <input type="text" v-model="report.reportName" class="form-control"
                                           data-validation-engine="validate[required, maxSize[40]]"
                                           placeholder="请输入名称，最多40个字符" maxLength="40"/>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right" width="20%">
                                <label class="col-sm-12 control-label no-padding-right">
                                    重要提示：
                                </label>
                            </th>
                            <td width="80%">
                                <div class="col-sm-12 no-padding">
                                    <textarea v-model="report.reportTip" class="form-control"
                                              placeholder="请输入重要提示，最多1000个字符" rows="3" cols="10"
                                              data-validation-engine="validate[maxSize[1000]]"
                                              maxlength="1000"></textarea>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right" width="20%">
                                <label class="col-sm-12 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    预警快报内容：
                                </label>
                            </th>
                            <td width="80%">
                                <div class="col-sm-12 no-padding">
                                    <textarea v-model="report.remark" class="form-control" placeholder="请输入预警快报内容，最多1000个字符" rows="3" cols="10" data-validation-engine="validate[required, maxSize[1000]]" maxlength="1000"></textarea>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right" width="20%">
                                <label class="col-sm-12 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    落款：
                                </label>
                            </th>
                            <td width="80%">
                                <div class="col-sm-12 no-padding">
                                    <input type="text" v-model="report.reportInscribe" class="form-control" data-validation-engine="validate[required, maxSize[25]]" placeholder="请输入落款，最多25个字符" maxLength="25"/>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    附件：
                                </label>
                            </th>
                            <td>
                                <div is="file-upload-table" key="fileUploadTable" ref="fileUploadTable"
                                     :ascription-id="report.reportId"
                                     :ascription-type="report.ascriptionType"
                                     allow-file-types="doc,docx,pdf"
                                     is-transform="Y"
                                     :max-file-size="15728640"
                                     :min-file-number="0"
                                     :max-file-number="10">
                                </div>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </form>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp" %>
<script>
    var ascriptionType = '${ascriptionType}';
    var menuName = '${menuName}';
    var reportId = '${reportId}';
    var isAdd = '${isAdd}';
</script>
<!-- vue插件 -->
<!--[if lte IE 9]>
	<script type="text/javascript" src="${ctx}/assets/components/babel-polyfill/polyfill.min.js"></script>
	<![endif]-->
<!-- vue插件 -->
<script type="text/javascript" src="${ctx}/assets/components/vue/vue.min.js"></script>
<!-- Dialog 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/dialog-util.js"></script>
<%--日期--%>
<script type="text/javascript" src="${ctx}/assets/custom/common/util/date-time-util.js"></script>
<!-- Ajax 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/ajax-util.js"></script>
<!-- 分析平台-文件上传表格组件-模板 -->
<!-- jQuery图片查看器插件 -->
<script type="text/javascript" src="${ctx}/assets/components/viewer-master/dist/viewer.min.js"></script>
<%@ include file="/WEB-INF/jsp/components/common/file-upload-table.jsp" %>
<%@ include file="/WEB-INF/jsp/components/common/image-upload-table.jsp" %>
<script type="text/javascript" src="${ctx}/assets/components/element-ui/index.js"></script>
<!-- 自定义js（逻辑js） -->
<script type="text/javascript" src="${ctx}/assets/custom/analysis/warnbulletin/add.js"></script>
</body>
</html>
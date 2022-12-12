<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>报告管理</title>
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
    <!-- 分析平台-记录列表组件-样式文件 -->
    <link href="${ctx }/assets/custom/components/analysis/css/record.css?v=20221129015223" rel="stylesheet"/>
    <!-- zTree 全局样式文件 -->
    <link href="${ctx}/assets/components/zTree/css/zTreeStyle/zTreeStyle.css?v=20221129015223" rel="stylesheet">
    <!-- zTree Bootstrap风格样式文件  -->
    <link href="${ctx}/assets/components/zTree/css/metroStyle/metroStyle.css?v=20221129015223" rel="stylesheet">
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
    <div class="main-content-inner fixed-page-header fixed-40">
        <div id="breadcrumbs" class="breadcrumbs">
            <ul class="breadcrumb col-xs-10">
                <li class="active">
                    <h5 class="page-title">
                        {{menuName}}
                    </h5>
                </li>
            </ul>
            <div  style="text-align: right" v-if="!isHidden">
                <button type="button" class="btn btn-xs btn-xs-ths" @click="cancel" v-if="showClose==1">
                    <i class="ace-icon fa fa-close"></i> 关闭
                </button>
                <button type="button" class="btn btn-xs btn-xs-ths" @click="goList" v-else>
                    <i class="ace-icon fa fa-list"></i>查看全部
                </button>
            </div>
        </div>
    </div>
    <div class="main-content-inner padding-page-content">
        <div class="main-content">
            <div class="page-content">
                <div class="col-sm-12 record-div no-padding">
                    <div class="col-sm-9 no-padding">
                        <record ref="record" :records="records" @recordclick="recordClick"></record>
                    </div>
                    <div class="space-4"></div>
                </div>
                <div class="col-sm-12 no-padding" v-if="record">
                    <div class="space-4"></div>
                    <table class="table table-bordered">
                        <tbody>
                        <tr>
                            <th class="text-right" width="20%">
                                重要提示：
                            </th>
                            <td width="80%">
                                {{record.reportTip}}
                            </td>
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
                <div class="col-sm-12 no-padding" v-if="fileRecords && fileRecords.length > 0 && pdfUrl">
                    <iframe :src="pdfUrl" class="col-sm-12 no-padding no-border" height="600" allow-pdf-auto-height="true"></iframe>
                </div>
                <div class="col-sm-12 center no-data" v-if="noDataText">
                    {{noDataText}}
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
<script>
    var  ascriptionType = '${ascriptionType}';
    var  menuName = '${menuName}';
    var reportId= '${reportId}';
    var showClose= '<%=request.getParameter("showClose")%>'
    var isSmallType = '${isSmallType}';
    //是否隐藏
    var isHidden= '<%=request.getParameter("isHidden")%>'
</script>
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
<!-- 分析平台-记录列表组件-逻辑js -->
<script type="text/javascript" src="${ctx}/assets/custom/components/analysis/js/record.js?v=20221129015223"></script>
<!-- 分析平台-记录列表组件-模板 -->
<script id="vue-template-record" type="text/x-template">
    <%@ include file="/WEB-INF/jsp/components/analysis/record.jsp" %>
</script>
<!-- 自定义js（逻辑js） -->
<script type="text/javascript" src="${ctx}/assets/custom/analysis/commonreport/index.js?v=20221129015223"></script>
</body>
</html>
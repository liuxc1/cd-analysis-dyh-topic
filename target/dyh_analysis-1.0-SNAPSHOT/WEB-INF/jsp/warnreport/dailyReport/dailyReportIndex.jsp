<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>应急管控工作日报表</title>
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
    <link rel="stylesheet" href="${ctx}/assets/components/bootstrap-select/dist/css/bootstrap-select.min.css?v=20221129015223" />
    <link href="${ctx }/assets/custom/components/analysis/css/time-axis.css?v=20221129015223" rel="stylesheet"/>
    <!-- 分析平台-记录列表组件-样式文件 -->
    <link href="${ctx }/assets/custom/components/analysis/css/record.css?v=20221129015223" rel="stylesheet"/>
    <!-- 分析平台-文件上传表格组件-样式文件 -->
    <link href="${ctx }/assets/custom/components/analysis/css/file-upload-table.css?v=20221129015223" rel="stylesheet" />
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
            padding: 8px;
            height: 35px;
        }
        .textCenter{
            text-align: center;
        }
        .weather_trend_edit span {
            display: inline-block;
            width: 95%;
            height: 35px;
            line-height: 35px;
            text-align: left;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
        }

        .dropdown-toggle, .dropdown-toggle:hover, .dropdown-toggle:focus, .open>.btn.dropdown-toggle {
            background-color: #ffffff !important;
            border: 1px solid #D5D5D5;
            color: #858585 !important;
            border-width: 1px !important;
        }
    </style>
</head>

<body class="no-skin">
<div class="main-container" id="main-container" v-cloak>
    <div class="main-content">
        <div class="main-content-inner fixed-page-header fixed-40">
            <div id="breadcrumbs" class="breadcrumbs">
                <ul class="breadcrumb">
                    <li class="active">
                        <h5  class="page-title">
                            <i class="header-icon fa fa-edit"></i>
                            应急管控工作日报表
                        </h5>
                    </li>
                </ul>
                <div class="btn-toolbar pull-right" role="toolbar" style="padding-top: 7px;">
                    <button type="button" class="btn btn-xs btn-xs-ths " @click="exportDailyReportFile()">
                        <i class="ace-icon fa fa-download"></i>
                        导出成都市臭氧重污染天气应急管控工作日报表
                    </button>
                     <button type="button" class="btn btn-xs btn-xs-ths " @click="exportStDailyReportFile()">
                         <i class="ace-icon fa fa-download"></i>
                         导出生态环境局日报
                     </button>
                    <button type="button" class="btn btn-xs btn-xs-ths " @click="goAdd()">
                        <i class="ace-icon fa fa-plus"></i>
                        添加
                    </button>
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
                                    <input type="text" id="wdate-picker" v-model="yearMonth" @click="wdatePicker"
                                           class="form-control" placeholder="请选择填报月份" readonly>
                                    <span class="input-group-btn">
										<button type="button" class="btn btn-white btn-default" @click="wdatePicker">
											<i class="ace-icon fa fa-calendar"></i>
										</button>
									</span>
                                </div>
                            </div>
                            <div class="col-sm-9"><time-axis ref="timeAxis"
                                                             :current="yearMonth"
                                                             :prev="timeAxis.prev"
                                                             :next="timeAxis.next"
                                                             :list="timeAxis.list"
                                                             @prevclick="prevClick"
                                                             @nextclick="nextClick"
                                                             @listclick="timeAxisListClick"
                            ></time-axis></div>
                        </div>
                    </form>
                    <div class="col-sm-12 record-div">
                        <div class="col-sm-9 no-padding">
                            <record ref="record" :records="records" @recordclick="recordClick"></record>
                        </div>
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
                                    {{record.importantHints==null||record.importantHints==""?"--":record.importantHints}}
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <div id="tableContent" class="tab-content" style="border: none;">
                        <%--数据表及其报告标签页--%>
                        <div id="data-table" class="tab-pane fade in active">
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
                </div>
            </div>
            <!--/.main-content-inner-->
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
<%-- <%@ include file="/WEB-INF/jsp/_common/uploadJS.jsp"%> --%>
<script type="text/javascript">
    // 地址，必须
    var ctx = "${ctx}";
    var isRead = "${isRead}";
</script>
<script type="text/javascript" src="${ctx}/assets/components/bootstrap-select/dist/js/bootstrap-select.min.js?v=20221129015223"></script>
<script type="text/javascript" src="${ctx}/assets/components/bootstrap-select/dist/js/i18n/defaults-zh_CN.min.js?v=20221129015223"></script>
<%-- 	<script type="text/javascript" src="${ctx}/assets/components/jQuery-Validation-Engine/jquery.validationEngine.min.js?v=20221129015223"></script> --%>
<!-- vue插件 -->
<script type="text/javascript" src="${ctx}/assets/components/vue/vue.js?v=20221129015223"></script>
<!-- 引入组件库elementui -->
<script src="${ctx }/assets/components/element-ui/js/index.js?v=20221129015223"></script>
<!-- Dialog 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/dialog-util.js?v=20221129015223"></script>
<!-- Ajax 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/ajax-util.js?v=20221129015223"></script>
<!-- 日期时间 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/date-time-util.js?v=20221129015223"></script>
<!-- 分析平台-时间轴组件-逻辑js -->
<script type="text/javascript" src="${ctx}/assets/custom/components/analysis/js/time-axis.js?v=20221129015223"></script>
<script id="vue-template-time-axis" type="text/x-template">
    <%@ include file="/WEB-INF/jsp/components/analysis/time-axis.jsp" %>
</script>
<!-- 分析平台-记录列表组件-逻辑js -->
<script type="text/javascript" src="${ctx}/assets/custom/components/analysis/js/record.js?v=20221129015223"></script>
<!-- 分析平台-记录列表组件-模板 -->
<script id="vue-template-record" type="text/x-template">
    <%@ include file="/WEB-INF/jsp/components/analysis/record.jsp" %>
</script>
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
<script type="text/javascript" src="${ctx}/assets/custom/warnreport/dailyReport/dailyReportIndex.js?v=20221129015223"></script>
</body>
</html>
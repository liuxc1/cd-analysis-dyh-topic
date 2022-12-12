<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>周报分析</title>
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
    <!-- 分析平台-记录列表组件-样式文件 -->
    <link href="${ctx }/assets/custom/components/analysis/css/record.css" rel="stylesheet"/>
    <link href="${ctx }/assets/custom/components/analysis/css/time-axis.css" rel="stylesheet"/>
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

        .time-axis li{
            width: 88px;!important;
        }
    </style>
</head>
<body class="no-skin">
<div class="main-container" id="main-container" v-cloak>
    <!-- 归属类型 -->
    <input type="hidden" id="ascription-type" value="${ascriptionType}"/>
    <!-- 文件来源 -->
    <input type="hidden" id="file-sources" value="${fileSources}"/>
    <div class="main-content-inner fixed-page-header fixed-40">
        <div id="breadcrumbs" class="breadcrumbs">
            <ul class="breadcrumb">
                <li class="active">
                    <h5 class="menu-icon fa fa-ellipsis-v">
                        <i class="menu-icon fa fa-ellipsis-v"></i>
                        周报分析
                    </h5>
                </li>
            </ul>
            <div class="align-right" style="float: right; padding-right: 5px;">
                <button type="button" class="btn btn-xs btn-xs-ths" @click="goAdd">
                    <i class="ace-icon fa fa-plus"></i> 添加
                </button>
            </div>
        </div>
    </div>
    <div class="main-content-inner padding-page-content">
        <div class="main-content">
            <div class="page-content">
                <form class="form-horizontal" role="form">
                    <div class="space-4"></div>
                    <div class="form-group">
                        <div class="col-sm-12 no-padding">
                            <div class="col-sm-3 no-padding">
                                <label class="col-sm-4 control-label">填报月份：</label>
                                <div class="col-sm-8 input-group" @click="startWdatePicker">
                                    <input type="text" id="start-wdate-picker" v-model="yearMonth" class="form-control" placeholder="请选择填报月份" readonly>
                                    <span class="input-group-btn">
											<button type="button" class="btn btn-white btn-default">
												<i class="ace-icon fa fa-calendar"></i>
											</button>
										</span>
                                </div>
                            </div>
                            <div class="col-sm-9">
                                <time-axis ref="timeAxis"
                                           :current="yearMonth"
                                           :prev="timeAxis.prev"
                                           :next="timeAxis.next"
                                           :list="timeAxis.list"
                                           @prevclick="prevClick"
                                           @nextclick="nextClick"
                                           @listclick="timeAxisListClick"
                                ></time-axis>
                            </div>
                        </div>

                    </div>
                </form>
                <div class="col-sm-12 record-div no-padding">
                    <div class="col-sm-9 no-padding">
                        <record ref="record" :records="records" @recordclick="recordClick"></record>
                    </div>
                    <div class="col-sm-3 align-right no-padding">

                        <button type="button" class="btn btn-xs btn-xs-ths" @click="uploadClick" v-if="record && record.state == 'TEMP'">
                            <i class="ace-icon fa fa-upload"></i> 提交
                        </button>
                        <button type="button" class="btn btn-xs btn-xs-ths" @click="goEdit" v-if="record && record.state == 'TEMP'">
                            <i class="ace-icon fa fa-edit"></i> 编辑
                        </button>
                        <button type="button" class="btn btn-xs btn-xs-ths btn-danger" @click="deleteData" v-if="record && record.state == 'TEMP'">
                            <i class="ace-icon fa fa-trash-o"></i> 删除
                        </button>
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
                                {{reportTip}}
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

<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
<!-- vue插件 -->
<script type="text/javascript" src="${ctx}/assets/components/vue/vue.min.js"></script>
<!-- Dialog 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/dialog-util.js"></script>
<!-- 分析平台-时间轴组件-逻辑js -->
<script type="text/javascript" src="${ctx}/assets/custom/components/analysis/js/time-axis.js"></script>
<script id="vue-template-time-axis" type="text/x-template">
    <%@ include file="/WEB-INF/jsp/components/analysis/time-axis.jsp" %>
</script>
<script type="text/javascript" src="${ctx}/assets/custom/common/util/ajax-util.js"></script>
<!-- Ajax 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/ajax-util.js"></script>
<!-- 日期时间 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/date-time-util.js"></script>
<!-- 文件下载 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/file-download-util.js"></script>
<!-- 分析平台-记录列表组件-逻辑js -->
<script type="text/javascript" src="${ctx}/assets/custom/components/analysis/js/record.js"></script>
<!-- 分析平台-记录列表组件-模板 -->
<script id="vue-template-record" type="text/x-template">
    <%@ include file="/WEB-INF/jsp/components/analysis/record.jsp" %>
</script>
<!-- 自定义js（逻辑js） -->
<script type="text/javascript" src="${ctx}/assets/custom/analysis/analysisreport/week/weekReportIndex.js"></script>
</body>
</html>
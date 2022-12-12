<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>月报分析</title>
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp" %>
    <link href="${ctx }/assets/custom/components/analysis/css/time-axis.css?v=20221129015223" rel="stylesheet"/>
    <link href="${ctx }/assets/custom/components/analysis/css/record.css?v=20221129015223" rel="stylesheet"/>
</head>
<body class="no-skin">
<div class="main-container" id="main-container" v-cloak>
    <div class="main-content-inner fixed-page-header fixed-40">
        <div id="breadcrumbs" class="breadcrumbs">
            <ul class="breadcrumb">
                <li class="active">
                    <h5 class="page-title">
                        <i class="menu-icon fa fa-trophy"></i>
                        月报分析报告
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
                    <div class="col-sm-12 no-padding">
                        <div class="col-sm-3 no-padding">
                            <label class="col-sm-4 control-label">填报年份：</label>
                            <div class="col-sm-8 input-group">
                                <input type="text" id="wdate-picker" v-model="year" @click="wdatePicker"
                                       class="form-control" placeholder="请选择填报年份" readonly>
                                <span class="input-group-btn">
										<button type="button" class="btn btn-white btn-default" @click="wdatePicker">
											<i class="ace-icon fa fa-calendar"></i>
										</button>
									</span>
                            </div>
                        </div>
                        <div class="col-sm-9">
                            <time-axis ref="timeAxis"
                                       :current="year"
                                       :prev="timeAxis.prev"
                                       :next="timeAxis.next"
                                       :list="timeAxis.list"
                                       @prevclick="prevClick"
                                       @nextclick="nextClick"
                                       @listclick="timeAxisListClick"
                            ></time-axis>
                        </div>
                    </div>
                </form>
            </div>

            <div class="col-sm-12 record-div no-padding">
                <div class="col-sm-9 no-padding">
                    <record ref="record" :records="records" @recordclick="recordClick"></record>
                </div>
                <div class="col-sm-3 align-right no-padding">

                    <button type="button" class="btn btn-xs btn-xs-ths" @click="uploadClick"
                            v-if="record && record.flowState == 'TEMP'">
                        <i class="ace-icon fa fa-upload"></i> 提交
                    </button>
                    <button type="button" class="btn btn-xs btn-xs-ths" @click="goEdit"
                            v-if="record && record.flowState == 'TEMP'">
                        <i class="ace-icon fa fa-edit"></i> 编辑
                    </button>
                    <button type="button" class="btn btn-xs btn-xs-ths btn-danger" @click="deleteData"
                            v-if="record && record.flowState == 'TEMP'">
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
                    <a href="javascript:video(0);">
                            <span @click="openFullScreen" class="span-btn" v-if="pdfUrl" style="margin-right: 20px">
                                <i class="ace-icon fa fa-arrows-alt"></i> 全屏
                            </span>
                    </a>
                    <a href="javascript:video(0);">
							<span @click="downloadFile" class="span-btn" v-if="pdfUrl">
								<i class="ace-icon fa fa-download"></i> 下载
							</span>
                    </a>
                </div>
            </div>
            <div class="col-sm-12 no-padding" v-if="pdfUrl">
                <iframe :src="pdfUrl" class="col-sm-12 no-padding no-border" height="600"></iframe>
            </div>

        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp" %>
<script type="text/javascript" src="${ctx}/assets/components/babel-polyfill/polyfill.min.js?v=20221129015223"></script>
<script type="text/javascript" src="${ctx}/assets/components/vue/vue.js?v=20221129015223"></script>
<script type="text/javascript" src="${ctx}/assets/custom/common/util/dialog-util.js?v=20221129015223"></script>
<script type="text/javascript" src="${ctx}/assets/custom/common/util/ajax-util.js?v=20221129015223"></script>
<script type="text/javascript" src="${ctx}/assets/custom/common/util/date-time-util.js?v=20221129015223"></script>
<script type="text/javascript" src="${ctx}/assets/custom/common/util/file-download-util.js?v=20221129015223"></script>
<script type="text/javascript" src="${ctx}/assets/custom/components/analysis/js/time-axis.js?v=20221129015223"></script>
<script id="vue-template-time-axis" type="text/x-template">
    <%@ include file="/WEB-INF/jsp/components/analysis/time-axis.jsp" %>
</script>
<script type="text/javascript" src="${ctx}/assets/custom/components/analysis/js/record.js?v=20221129015223"></script>
<script id="vue-template-record" type="text/x-template">
    <%@ include file="/WEB-INF/jsp/components/analysis/record.jsp" %>
</script>
<script type="text/javascript"
        src="${ctx}/assets/custom/analysis/analysisreport/monthlyAnalysis/monthlyAnalysisList.js?v=20221129015223"></script>
</body>
</html>
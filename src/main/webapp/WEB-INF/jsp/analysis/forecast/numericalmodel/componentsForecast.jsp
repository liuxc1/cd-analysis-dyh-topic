<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>PM2.5组分预报</title>
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp" %>
    <link href="${ctx }/assets/custom/components/analysis/css/time-axis.css" rel="stylesheet"/>
    <link rel="stylesheet" href="${ctx }/assets/components/zTree/css/zTreeStyle/zTreeStyle.css"/>
    <link rel="stylesheet" href="${ctx }/assets/components/zTree/css/metroStyle/metroStyle.css"/>
    <style type="text/css">
        .timeType {
            display: inline-block;
            width: 80px;
            height: 40px;
            border: 4px solid #02A7F0;
            font-size: 22px;
            text-align: center;
            margin-top: 10px;
            margin-left: 4%;
            overflow: hidden;
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
                        <h5 class="page-title">
                            <i class="header-icon fa fa-arrows"></i>
                            PM2.5组分预报
                        </h5>
                    </li>
                </ul>
            </div>
        </div>
        <div class="main-content-inner">
            <div class="page-content">
                <form id="mainForm" class="form-horizontal" role="form" id="formList" method="post">
                    <div class="form-group">
                        <label class="col-xs-1 control-label no-padding-right">起报日期：</label>
                        <div class="col-xs-2">
                            <div class="col-xs-4 no-padding-right no-padding-left" style="width: 160px;">
                                <div class="input-group" id="divDate" @click="wdatePicker">
                                    <input type="text" id="txtDateStart" class="form-control"
                                           v-model="queryParams.month"
                                           name="datetime" readonly="readonly">
                                    <span class="input-group-btn">
												<button type="button" class="btn btn-white btn-default"
                                                        id="btnDateStart" readonly="readonly">
													<i class="ace-icon fa fa-calendar"></i>
												</button>
											</span>
                                </div>
                            </div>
                        </div>
                        <div class="col-xs-8">
                            <time-axis ref="timeAxis"
                                       :current="queryParams.month"
                                       :prev="timeAxis.prev"
                                       :next="timeAxis.next"
                                       :list="timeAxis.list"
                                       @prevclick="prevClick"
                                       @nextclick="nextClick"
                                       @listclick="timeAxisListClick"
                            ></time-axis>
                        </div>
                        <div class="col-xs-1">
                        </div>
                    </div>
                    <div class="form-group" style="margin-top: 10px">
                        <label class="col-xs-1 control-label no-padding-right">展示类型：</label>
                        <div class="col-xs-2">
                            <input id="heap" class="btn btn-white showType" type="button"
                                   @click="doSearch('heap')" value="堆积">
                            <input id="percent" class="btn btn-white showType" type="button"
                                   @click="doSearch('percent')" value="百分堆积">
                        </div>
                        <label class="col-xs-1 control-label no-padding-right">行政区/点位：</label>
                        <div class="col-xs-2">
                            <div class="no-padding-right no-padding-left">
                                <div class="input-group">
                                    <input type="text" id="regionAndPoint" class="form-control"
                                           @click="checkRegionAndPoint"
                                           v-model="queryParams.pointName" readonly="readonly">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-xs-10">
                        </div>
                        <div class="col-xs-2" style="text-align: right">
                            <button type="button" class="btn  btn-info btn-default-ths" @click="doSearch('')">
                                <i class="ace-icon fa fa-search"></i> 查询
                            </button>
                            <button type="button" class="btn btn-xs btn-primary btn-default-ths" @click="exportExcel">
                                <i class="ace-icon fa fa-download"></i> 导出
                            </button>
                        </div>
                    </div>

                    <hr class="no-margin">
                    <div class="col-xs-12 form-group">
                        <div class="timeType">12时</div>
                        <div id="pm25_12" style="height: 450px">
                        </div>
                    </div>
                    <div class="col-xs-12 form-group">
                        <div class="timeType">00时</div>
                        <div id="pm25_0" style="height: 450px">
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp" %>
<script type="text/javascript">
    var ctx = "${ctx}";
</script>
<script type="text/javascript" src="${ctx }/assets/components/zTree/js/jquery.ztree.all.js"></script>
<script type="text/javascript" src="${ctx}/assets/components/echarts/echarts.js"></script>
<!-- Dialog 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/dialog-util.js"></script>
<!-- Ajax 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/ajax-util.js"></script>
<!-- 日期时间 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/date-time-util.js"></script>
<!-- 分析平台-时间轴组件-逻辑js -->
<script type="text/javascript" src="${ctx}/assets/custom/components/analysis/js/time-axis.js"></script>
<script id="vue-template-time-axis" type="text/x-template">
    <%@ include file="/WEB-INF/jsp/components/analysis/time-axis.jsp" %>
</script>
<!-- 文件下载 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/file/file-download-util.js"></script>
<script type="text/javascript"
        src="${ctx}/assets/custom/analysis/forecast/numericalmodel/componentsForecast.js"></script>
</body>
</html>
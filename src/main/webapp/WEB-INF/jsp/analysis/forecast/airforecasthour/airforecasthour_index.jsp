<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>逐小时预报结果</title>
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp" %>
    <%-- <link rel="stylesheet" href="${ctx}/assets/components/bootstrap-select/dist/css/bootstrap-select.min.css" /> --%>
    <link href="${ctx }/assets/custom/components/analysis/css/time-axis.css" rel="stylesheet"/>
    <!-- 分析平台-文件上传表格组件-样式文件 -->
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

        .dropdown-toggle, .dropdown-toggle:hover, .dropdown-toggle:focus, .open > .btn.dropdown-toggle {
            background-color: #ffffff !important;
            border: 1px solid #D5D5D5;
            color: #858585 !important;
            border-width: 1px !important;
        }
        .table-bordered>thead>tr>th, .table-bordered>thead>tr>td {
            border-bottom-width: 1px;
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
                            <i class="header-icon fa fa-get-pocket"></i>
                            逐小时预报结果
                        </h5>
                    </li>
                </ul>
            </div>
        </div>
        <div class="main-content-inner">
            <div class="page-content">
                <form id="mainForm" class="form-horizontal" role="form" id="formList" method="post">
                    <div class="row">
                        <div id="queryDate" class="col-xs-12 form-group" v-if="showAndEdit==='show'">
                            <label class="col-xs-1 control-label no-padding-right">填报月份：</label>
                            <div class="col-xs-2">
                                <div class="col-xs-4 no-padding-right no-padding-left" style="width: 160px;">
                                    <div class="input-group" id="divDate" @click="wdatePicker">
                                        <input type="text" id="txtDateStart" class="form-control" v-model="month"
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
                            <div>
                                <div class="col-xs-8">
                                    <time-axis ref="timeAxis"
                                               :current="month"
                                               :prev="timeAxis.prev"
                                               :next="timeAxis.next"
                                               :list="timeAxis.list"
                                               @prevclick="prevClick"
                                               @nextclick="nextClick"
                                               @listclick="timeAxisListClick"
                                    ></time-axis>
                                </div>
                                <div class="col-xs-1" v-if="state!='UPLOAD'">
                                    <button id="btn-search" type="button" @click="add"
                                            class="btn btn-info btn-default-ths">
                                        <i class="ace-icon fa fa-plus"></i>填报
                                    </button>
                                </div>
                            </div>
                        </div>
                        <div class="col-xs-12 form-group" v-else>
                            <div class="col-xs-10">
                            </div>
                            <div class="col-xs-2">
                                <button id="btn-commit" type="button" @click="save(1)"
                                        class="btn btn-info btn-default-ths">
                                    <i class="ace-icon fa "></i>提交
                                </button>
                                <button id="btn-save" type="button" @click="save(0)"
                                        class="btn btn-info btn-default-ths">
                                    <i class="ace-icon fa "></i>保存
                                </button>
                                <button id="btn-cancel" type="button" @click="back"
                                        class="btn btn-info btn-default-ths">
                                    <i class="ace-icon fa fa-cancel"></i>返回
                                </button>
                            </div>
                        </div>
                        <div class="col-xs-12 form-group">
                            <label class="col-xs-1 control-label no-padding-right">展示类别：</label>
                            <label class="check-label control-label" v-for="(item,index) of forecastTypeAndUser">
                                <input type="checkbox" v-model="item.checked" @click="changeCheckBox(item.model)"/>
                                <span>{{item.userName}}&nbsp&nbsp</span>
                            </label>
                        </div>
                    </div>
                    <hr class="no-margin">
                    <div class="col-xs-12 form-group">
                        <div class="col-xs-6 echars echartsHeihgt" id="pm25" style="height: 300px">

                        </div>
                        <div class="col-xs-6 echars echartsHeihgt" id="o3" style="height: 300px">

                        </div>
                    </div>
                    <div class="col-xs-8" >单位：(μg/m³)</div>
                    <div class="col-xs-4 text-right">
                        <button type="button" class=" btn btn-xs  btn-xs-ths" @click="exportExcel"
                                v-if="tableList && tableList.length>0">
                            <i class="ace-icon fa fa-download"></i> 导出
                        </button>
                    </div>
                    <table class="table table-bordered table-hover">
                        <thead>
                        <tr>
                            <th rowspan="2" width="10%" style="text-align: center">预报时间</th>
                            <th style="text-align: center" v-for="item in cheakForecastTypeAndUserName" colspan="2">
                                {{item}}
                            </th>
                            <th style="text-align: center" v-if="isNew" colspan="2">
                                {{userName}}
                            </th>
                        </tr>
                        <tr>
                            <template v-for="item in cheakForecastTypeAndUser">
                                <th style="text-align: center">PM₂.₅</th>
                                <th style="text-align: center">O₃</th>
                            </template>
                            <template v-if="isNew">
                                <th style="text-align: center; width: 200px">PM₂.₅</th>
                                <th style="text-align: center; width: 200px">O₃</th>
                            </template>

                        </tr>
                        </thead>
                        <tbody>
                        <tr v-for="(tabItem,index) in tableList">
                            <td>{{substringDate(tabItem.resultTime)}}</td>
                            <template v-for="item in keyList">
                                <th style="text-align: right">
                                    <template v-if="showAndEdit ===item.model ">
                                        <input type="text" v-model="tabItem[item.pm25]" class="form-control validate[funcCall[checkNumber]] "/>
                                    </template>
                                    <template v-else>
                                        <span>{{tabItem[item.pm25]}}</span>
                                    </template>
                                </th>
                                <th style="text-align: right">
                                    <template v-if="showAndEdit ===item.model ">
                                        <input type="text" v-model="tabItem[item.o3]" class="form-control validate[funcCall[checkNumber]]"/>
                                    </template>
                                    <template v-else>
                                        <span>{{tabItem[item.o3]}}</span>
                                    </template>
                                </th>
                            </template>
                            <template v-if="isNew">
                                <th>
                                    <input type="text"  v-model="tabItem[userId+'_pm25']" class="form-control validate[funcCall[checkNumber]]" />
                                </th>
                                <th>
                                    <input type="text"  v-model="tabItem[userId+'_o3']" class="form-control validate[funcCall[checkNumber]]"/>
                                </th>
                            </template>

                        </tr>
                        </tbody>
                    </table>
                </form>
            </div>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp" %>
<%-- <%@ include file="/WEB-INF/jsp/_common/uploadJS.jsp"%> --%>
<script type="text/javascript">
    // 地址，必须
    var ctx = "${ctx}";
</script>
<script type="text/javascript" src="${ctx}/assets/components/echarts/echarts.min.js"></script>
<!-- Dialog 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/dialog-util.js"></script>
<!-- Ajax 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/ajax-util.js"></script>
<!-- 日期时间 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/date-time-util.js"></script>
<!-- 文件上传 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/file/file-upload-util.js"></script>
<!-- 分析平台-时间轴组件-逻辑js -->
<script type="text/javascript" src="${ctx}/assets/custom/components/analysis/js/time-axis.js"></script>
<script id="vue-template-time-axis" type="text/x-template">
    <%@ include file="/WEB-INF/jsp/components/analysis/time-axis.jsp" %>
</script>
<!-- 文件下载 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/file/file-download-util.js"></script>
<!-- 分析平台-文件上传表格组件-模板 -->
<%-- <script id="vue-template-file-upload-table" type="text/x-template">
    <%@ include file="/WEB-INF/jsp/components/analysis/file-upload-table.jsp" %>
</script> --%>

<script type="text/javascript"
        src="${ctx}/assets/custom/analysis/forecast/airforecasthour/airforecasthour_index.js"></script>
</body>
</html>
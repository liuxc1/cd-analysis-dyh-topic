<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>月趋势预报</title>
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp" %>
    <!-- 分析平台-时间轴组件-样式文件 -->
    <link href="${ctx }/assets/custom/components/analysis/css/time-axis.css" rel="stylesheet"/>
    <!-- 分析平台-记录列表组件-样式文件 -->
    <link href="${ctx }/assets/custom/components/analysis/css/record.css" rel="stylesheet"/>
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

        #cal-tab {
            width: 800px;
            text-align: center;
            font-size: 17px;
            font-family: '宋体';
            font-weight: 500;
            margin: auto;
        }

        #cal-tab tr td {
            padding: 3px 0 3px 0;
        }

        #cal-title, #color-title {
            margin: 0 auto 10px auto;
            text-align: center;
            font-size: 25px;
            font-weight: bold;
        }

        #cal-tab tbody tr td div {
            height: 20px;
        }

        #cal-tab tbody tr td div:first-child {
            margin-bottom: 6px;
        }

        #cal-tab tbody tr td div:nth-child(2) {
            margin-bottom: 3px;
        }

        #color-tab {
            margin: auto;
            font-family: '黑体';
            font-weight: 500;
            margin: auto;
            font-size: 17px;
            text-align: center;
            font-weight: bold;
        }

        .day31-td {
            width: 70px;
            display: none;
            height: 33px;
        }

        #color-tab tr td {
            width: 70px;
            height: 33px;
        }
    </style>
</head>
<body class="no-skin">
<div class="main-container" id="main-container" v-cloak>
    <div class="main-content-inner fixed-page-header fixed-40">
        <div id="breadcrumbs" class="breadcrumbs">
            <ul class="breadcrumb">
                <li class="active">
                    <h5 class="page-title">
                        <i class="header-icon fa fa-vine"></i>
                        月趋势预报
                    </h5>
                </li>
            </ul>
            <div class="align-right" style="float: right; padding-right: 5px;">
                <button type="button" class="btn btn-xs btn-xs-ths" @click="goAdd">
                    <i class="ace-icon fa fa-plus"></i> 添加
                </button>
                <!-- <button type="button" class="btn btn-xs btn-xs-ths" @click="downloadFile" v-if="pdfUrl || imgUrl">
                    <i class="ace-icon fa fa-download"></i> 下载
                </button> -->
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
            <div style="margin-top: 50px">
                <ul id="tabSet" class="nav nav-tabs" >
                    <li class="active">
                        <a href="#data-table" data-toggle="tab">数据表</a>
                    </li>
                    <li>
                        <a href="#calendar-pic" data-toggle="tab">日历图</a>
                    </li>
                    <li>
                        <a href="#fill-col-pic" data-toggle="tab">填色图</a>
                    </li>
                </ul>
            </div>

            <div id="tableContent" class="tab-content" style="border: none;">
                <%--数据表标签页--%>
                <div id="data-table" class="tab-pane fade in active">
                    <div class="col-sm-12 record-div">
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
                            <button type="button" class=" btn btn-xs  btn-xs-ths" @click="exportExcel"
                                    v-if="record && record.flowState == 'UPLOAD'">
                                <i class="ace-icon fa fa-download"></i> 导出
                            </button>
                        </div>
                        <div class="space-4"></div>
                    </div>
                    <div class="col-sm-12 no-padding" v-if="record">
                        <div class="space-4"></div>
                        <table class="table table-bordered">
                            <tbody>
                            <!-- <tr>
                                <th class="text-right" width="20%">
                                    填报日期：
                                </th>
                                <td width="80%">
                                    {{record.createTime}}
                                </td>
                            </tr> -->
                            <tr>
                                <th class="text-right" width="20%">
                                    重要提示：
                                </th>
                                <td width="80%">
                                    {{record.importantHints==null||record.importantHints==''?'--':record.importantHints}}
                                </td>
                            </tr>
                            <!-- <tr>
                                <th class="text-right">
                                    状态：
                                </th>
                                <td>
                                    {{record.flowState == 'UPLOAD' ? '已提交' : '暂存'}}
                                </td>
                            </tr> -->
                            </tbody>
                        </table>
                    </div>
                    <div class="col-sm-12 no-padding" v-if="record && record.cityForecastAqiList">
                        <div class="space-4"></div>
                        <table class="table table-bordered">
                            <thead>
                            <tr>
                                <th class="text-center" style="width: 13%;">预报日期</th>
                                <th class="text-center" style="width: 10%;">等级1</th>
                                <th class="text-center" style="width: 10%;">等级2</th>
                                <th class="text-center" style="width: 13%;">预报日期</th>
                                <th class="text-center" style="width: 10%;">等级1</th>
                                <th class="text-center" style="width: 10%;">等级2</th>
                                <th class="text-center" style="width: 13%;">预报日期</th>
                                <th class="text-center" style="width: 10%;">等级1</th>
                                <th class="text-center" style="width: 10%;">等级2</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr v-for="(item, index) in record.cityForecastAqiList">
                                <td class="text-center">{{item.RESULT_TIME1}}</td>
                                <td class="text-center">{{item.LEVEL1 || '-'}}</td>
                                <td class="text-center">{{item.LEVEL2 || '-'}}</td>
                                <td class="text-center">{{item.RESULT_TIME2}}</td>
                                <td class="text-center">{{item.LEVEL3 || '-'}}</td>
                                <td class="text-center">{{item.LEVEL4 || '-'}}</td>
                                <td class="text-center">{{item.RESULT_TIME3|| '-'}}</td>
                                <td class="text-center">{{item.LEVEL5 || '-'}}</td>
                                <td class="text-center">{{item.LEVEL6 || '-'}}</td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="col-sm-12">
                        <div class="space-4"></div>
                        <record ref="fileRecord" :records="fileRecords" @recordclick="fileRecordClick"></record>
                        <div class="align-right" style="padding-right: 5px;">、
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
                    <div class="col-sm-12 center no-data" v-if="noForecastDataText">
                        {{noForecastDataText}}
                    </div>
                </div>
                <%--								日历图--%>
                <div id="calendar-pic" class="tab-pane fade">
                    <div class="col-sm-12 record-div">
                        <div class="col-xs-9"></div>
                        <div class="col-sm-3 align-right no-padding">
                            <button type="button" class=" btn btn-xs  btn-xs-ths" @click="exportExcel"
                                    v-if="record && record.flowState == 'UPLOAD'">
                                <i class="ace-icon fa fa-download"></i> 导出
                            </button>
                        </div>
                        <div class="space-4"></div>
                    </div>
                    <div v-if="lastMonthData && lastMonthData.list.length > 0">
                        <div class="col-sm-12 position-relative">
                            <div id="cal-title" style="width: 900px;">表1 {{ lastMonthData.date }}成都市空气质量逐日状况</div>
                            <table id="cal-tab" border="2">
                                <thead>
                                <tr>
                                    <td>星期日</td>
                                    <td>星期一</td>
                                    <td>星期二</td>
                                    <td>星期三</td>
                                    <td>星期四</td>
                                    <td>星期五</td>
                                    <td>星期六</td>
                                </tr>
                                </thead>
                                <tbody>
                                <tr v-for="row in calTabList">
                                    <td v-for="item in row" :style="item.style">
                                        <div>{{ item.dateTime }}</div>
                                        <div v-if="item.aqi != ''">
                                            <span>{{ item.aqi }}</span>
                                            <span v-if="item.primaryPollutant != ''">
																<span v-html="item.primaryPollutant"></span>
															</span>
                                        </div>
                                        <div v-else></div>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="col-sm-12 center no-data" v-if="noLastMonthDataText" style="margin-top: 28px">
                        {{ noLastMonthDataText }}
                    </div>
                </div>
                <%--								填色图--%>
                <div id="fill-col-pic" class="tab-pane fade">
                    <div class="col-sm-12 record-div">
                        <div class="col-xs-9"></div>
                        <div class="col-sm-3 align-right no-padding">
                            <button type="button" class=" btn btn-xs  btn-xs-ths" @click="exportExcel"
                                    v-if="record && record.flowState == 'UPLOAD'">
                                <i class="ace-icon fa fa-download"></i> 导出
                            </button>
                        </div>
                        <div class="space-4"></div>
                    </div>
                    <div v-if="record && record.cityForecastAqiList">
                        <div class="col-sm-12 position-relative">
                            <div id="color-title" style="width: 750px;">表2 {{ reportTime }}成都市空气质量趋势预报</div>
                            <table id="color-tab" border="1">
                                <template v-for="(row,index) in clrTabList">
                                    <tr>
                                        <td v-if="index == 0" rowspan="2">上旬</td>
                                        <td v-else-if="index == 1" rowspan="2">中旬</td>
                                        <td v-else rowspan="2">下旬</td>
                                        <td v-for="item1 in row">
                                            <div>{{item1.tdDay}}</div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td v-for="item2 in row" :style="item2.style"></td>
                                    </tr>
                                </template>
                            </table>
                        </div>
                    </div>
                    <div class="col-sm-12 center no-data" v-if="noForecastDataText" style="margin-top: 28px">
                        {{ noForecastDataText }}
                    </div>
                </div>
            </div>

        </div>
        <!--/.main-content-inner-->
    </div>
    <!-- /.main-content -->
</div>

<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp" %>
<!-- vue插件 -->
<!--[if lte IE 9]>
	<script type="text/javascript" src="${ctx}/assets/components/babel-polyfill/polyfill.min.js"></script>
	<![endif]-->
<!-- vue插件 -->
<script type="text/javascript" src="${ctx}/assets/components/vue/vue.js"></script>
<!-- Dialog 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/dialog-util.js"></script>
<!-- Ajax 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/ajax-util.js"></script>
<!-- 日期时间 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/date-time-util.js"></script>
<!-- 文件下载 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/file-download-util.js"></script>
<!-- 分析平台-时间轴组件-逻辑js -->
<script type="text/javascript" src="${ctx}/assets/custom/components/analysis/js/time-axis.js"></script>
<!-- 分析平台-时间轴组件-模板 -->
<script id="vue-template-time-axis" type="text/x-template">
    <%@ include file="/WEB-INF/jsp/components/analysis/time-axis.jsp" %>
</script>
<!-- 分析平台-记录列表组件-逻辑js -->
<script type="text/javascript" src="${ctx}/assets/custom/components/analysis/js/record.js"></script>

<!-- 分析平台-记录列表组件-模板 -->
<script id="vue-template-record" type="text/x-template">
    <%@ include file="/WEB-INF/jsp/components/analysis/record.jsp" %>
</script>
<!-- 自定义js（逻辑js） -->
<script type="text/javascript" src="${ctx}/assets/custom/analysis/forecast/airforecastmonth/trendList.js"></script>
</body>
</html>
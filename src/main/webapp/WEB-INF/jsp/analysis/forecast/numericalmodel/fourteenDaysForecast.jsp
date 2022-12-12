<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>未来14天预报</title>
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp" %>
    <%-- <link rel="stylesheet" href="${ctx}/assets/components/bootstrap-select/dist/css/bootstrap-select.min.css" /> --%>
    <link href="${ctx }/assets/custom/components/analysis/css/time-axis.css" rel="stylesheet"/>
    <link rel="stylesheet" href="${ctx }/assets/components/zTree/css/zTreeStyle/zTreeStyle.css"/>
    <link rel="stylesheet" href="${ctx }/assets/components/zTree/css/metroStyle/metroStyle.css"/>
    <!-- 分析平台-文件上传表格组件-样式文件 -->
    <style type="text/css">
      .timeType {
          display: inline-block;
          width: 80px;
          height: 40px;
          border: 4px solid #02A7F0;
          font-size: 22px;
          text-align: center;
          margin-top: 20px;
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
                            <i class="header-icon fa fa-adjust"></i>
                            未来14天预报
                        </h5>
                    </li>
                </ul>
            </div>
        </div>
        <div class="main-content-inner">
            <div class="page-content">
                <form id="mainForm" class="form-horizontal" role="form" id="formList" method="post">
                    <div class="row ">
                        <div class="col-xs-12 " >
                            <label class="col-xs-1 control-label no-padding-right">起报日期：</label>
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
                                    <div class="col-xs-1" >
                                </div>
                            </div>
                        </div>
                        <div class="col-xs-12 " style="margin-top: 10px">
                            <label class="col-xs-1 control-label no-padding-right">行政区/点位：</label>
                            <div class="col-xs-2">
                                <div class="col-xs-4 no-padding-right no-padding-left" style="width: 160px;">
                                    <div class="input-group"  >
                                        <input type="text" id="regionAndpoint" class="form-control" @click = "cheakRegionAndPoint"
                                               v-model="name"    readonly="readonly">
                                    </div>
                                </div>
                            </div>
                            <button type="button" class="btn btn-xs btn-primary btn-default-ths" @click="exportExcel" style="float: right;margin-right: 10px;">
                                <i class="ace-icon fa fa-download"></i> 导出
                            </button>
                            <div class=" form-group" style="float: right;margin-right: 10px;" >
                                <button type="button" class="btn  btn-info btn-default-ths" @click="query" >
                                    <i class="ace-icon fa fa-search"></i> 查询
                                </button>
                            </div>
                        </div>
                        <div class="col-xs-12 " >
                            <div class="col-xs-10">
                                <span style="margin-left: 3%;color: #027DB4;font-size: 16px;    ">({{thisYMD.substring(5,7)}}月{{thisYMD.substring(8,10)}}日CDAQS-MT中期空气质量预报系统中心城区订正预报结果）</span>
                            </div>
                        </div>
                    </div>
                    <hr class="no-margin">
                    <div class="col-xs-12 form-group">
                        <div class="col-xs-3 echars echartsHeihgt" id="so2" style="height: 300px">
                        </div>
                        <div class="col-xs-3 echars echartsHeihgt" id="no2" style="height: 300px">
                        </div>
                        <div class="col-xs-3 echars echartsHeihgt" id="pm10" style="height: 300px">
                        </div>
                        <div class="col-xs-3 echars echartsHeihgt" id="co" style="height: 300px">
                        </div>
                    </div>
                    <div class="col-xs-12 form-group">
                        <div class="col-xs-3 echars echartsHeihgt" id="o3" style="height: 300px">
                        </div>
                        <div class="col-xs-3 echars echartsHeihgt" id="o38" style="height: 300px">
                        </div>
                        <div class="col-xs-3 echars echartsHeihgt" id="pm25" style="height: 300px">
                        </div>
                        <div class="col-xs-3 echars echartsHeihgt" id="aqi" style="height: 300px">
                        </div>
                    </div>
                    <div class="col-xs-12 form-group">
                        <div class="col-xs-6 echars echartsHeihgt" id="table12" >
                            <div class="timeType">12时</div>
                            <div>单位：μg/m³（CO为mg/m³，AQI无量纲）</div>
                            <table class="table table-bordered table-hover">
                                <thead>
                                    <tr>
                                        <th style="text-align: center">点位</th>
                                        <th style="text-align: center">日期</th>
                                        <th style="text-align: center;width: 5%;">SO<sub>2</sub></th>
                                        <th style="text-align: center;width: 5%;">NO<sub>2</sub></th>
                                        <th style="text-align: center;width: 5%;">PM<sub>10</sub></th>
                                        <th style="text-align: center;width: 5%;">CO</th>
                                        <th style="text-align: center;width: 7%;">O<sub>3</sub></th>
                                        <th style="text-align: center;width: 7%;">O<sub>3</sub>_8</th>
                                        <th style="text-align: center;width: 5%;">PM<sub>2.5</sub></th>
                                        <th style="text-align: center;width: 9%;">AQI</th>
                                        <th style="text-align: center">等级</th>
                                        <th style="text-align: center">首要污染物</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <template v-if="table12 != null && table12.length > 0" v-for="item in table12">
                                        <tr>
                                            <td style="text-align: left">{{item.pointname}}</td>
                                            <td style="text-align: center" :title="item.resulttime.substring(0,10)">{{item.resulttime.substring(0,10)}}</td>
                                            <td style="text-align: right" :title="item.so2">{{item.so2}}</td>
                                            <td style="text-align: right" :title="item.no2">{{item.no2}}</td>
                                            <td style="text-align: right" :title="item.pm10">{{item.pm10}}</td>
                                            <td style="text-align: right" :title="item.co">{{item.co}}</td>
                                            <td style="text-align: right" :title="item.o3">{{item.o3}}</td>
                                            <td style="text-align: right" :title="item.o3_8">{{item.o38}}</td>
                                            <td style="text-align: right" :title="item.pm25">{{item.pm25}}</td>
                                            <td style="text-align: right" :title="item.aqiReange">{{item.aqiReange}}</td>
                                            <td style="text-align: center" :title="item.aqilevelreangestate" :style="getTwoColor(item.aqiMin,item.aqiMax)">{{item.aqilevelreangestate}}</td>
                                            <td style="text-align: center" :title="item.primpollute" :style="primpolluteColor(item.primpollute)">{{item.primpollute == null?'--':item.primpollute}}
                                            </td>
                                        </tr>
                                    </template>
                                    <tr v-if="table12 == null || table0.length == 0" >
                                        <td colspan="12" style="text-align: center;">暂无数据</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="col-xs-6 echars echartsHeihgt" id="table00" >
                            <div class="timeType">0时</div>
                            <div>单位：μg/m³（CO为mg/m³，AQI无量纲）</div>
                            <table class="table table-bordered table-hover">
                                <thead>
                                <tr>
                                    <th style="text-align: center">点位</th>
                                    <th style="text-align: center">日期</th>
                                    <th style="text-align: center;width: 5%;">SO<sub>2</sub></th>
                                    <th style="text-align: center;width: 5%;">NO<sub>2</sub></th>
                                    <th style="text-align: center;width: 5%;">PM<sub>10</sub></th>
                                    <th style="text-align: center;width: 5%;">CO</th>
                                    <th style="text-align: center;width: 7%;">O<sub>3</sub></th>
                                    <th style="text-align: center;width: 7%;">O<sub>3</sub>_8</th>
                                    <th style="text-align: center;width: 5%;">PM<sub>2.5</sub></th>
                                    <th style="text-align: center;width: 9%;">AQI</th>
                                    <th style="text-align: center">等级</th>
                                    <th style="text-align: center">首要污染物</th>
                                </tr>
                                </thead>
                                <tbody>
                                <template v-if="table0 != null && table0.length > 0" v-for="item in table0">
                                    <tr>
                                        <td style="text-align: left">{{item.pointname}}</td>
                                        <td style="text-align: center" :title="item.resulttime.substring(0,10)">{{item.resulttime.substring(0,10)}}</td>
                                        <td style="text-align: right" :title="item.so2">{{item.so2}}</td>
                                        <td style="text-align: right" :title="item.no2">{{item.no2}}</td>
                                        <td style="text-align: right" :title="item.pm10">{{item.pm10}}</td>
                                        <td style="text-align: right" :title="item.co">{{item.co}}</td>
                                        <td style="text-align: right" :title="item.o3">{{item.o3}}</td>
                                        <td style="text-align: right" :title="item.o3_8">{{item.o38}}</td>
                                        <td style="text-align: right" :title="item.pm25">{{item.pm25}}</td>
                                        <td style="text-align: right" :title="item.aqiReange">{{item.aqiReange}}</td>
                                        <td style="text-align: center" :title="item.aqilevelreangestate" :style="getTwoColor(item.aqiMin,item.aqiMax)">{{item.aqilevelreangestate}}</td>
                                        <td style="text-align: center" :title="item.primpollute" :style="primpolluteColor(item.primpollute)">{{item.primpollute == null?'--':item.primpollute}}</td>
                                    </tr>
                                </template>
                                <tr v-if="table0 == null || table0.length == 0" >
                                    <td colspan="12" style="text-align: center;">暂无数据</td>
                                </tr>
                                </tbody>
                            </table>
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
<!-- 文件上传 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/file/file-upload-util.js"></script>
<!-- 分析平台-时间轴组件-逻辑js -->
<script type="text/javascript" src="${ctx}/assets/custom/components/analysis/js/time-axis.js"></script>
<script id="vue-template-time-axis" type="text/x-template">
    <%@ include file="/WEB-INF/jsp/components/analysis/time-axis.jsp" %>
</script>
<!-- 文件下载 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/file/file-download-util.js"></script>
<script type="text/javascript"
        src="${ctx}/assets/custom/analysis/forecast/numericalmodel/fourteenDaysForecast.js"></script>
</body>
</html>
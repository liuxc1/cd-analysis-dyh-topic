<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>未来14天污染物浓度预报变化趋势</title>
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp" %>
    <%-- <link rel="stylesheet" href="${ctx}/assets/components/bootstrap-select/dist/css/bootstrap-select.min.css?v=20221129015223" /> --%>
    <link rel="stylesheet" href="${ctx }/assets/components/zTree/css/zTreeStyle/zTreeStyle.css?v=20221129015223"/>
    <link rel="stylesheet" href="${ctx }/assets/components/zTree/css/metroStyle/metroStyle.css?v=20221129015223"/>
    <link href="${ctx }/assets/custom/components/analysis/css/time-axis.css?v=20221129015223" rel="stylesheet"/>
</head>
<style>
    .timeType {
        display: inline-block;
        width: 80px;
        height: 40px;
        border: 4px solid #02A7F0;
        font-size: 18px;
        text-align: center;
        margin-top: 20px;
        overflow: hidden;
    }
</style>
<body class="no-skin">
<div class="main-container" id="main-container" v-cloak>
    <div class="main-content">
        <div class="main-content-inner fixed-page-header fixed-40">
            <div id="breadcrumbs" class="breadcrumbs">
                <ul class="breadcrumb">
                    <li class="active">
                        <h5 class="page-title">
                            <i class="menu-icon fa fa-area-chart"></i>
                            未来14天污染物浓度预报变化趋势
                        </h5>
                    </li>
                </ul>
            </div>
        </div>
        <div class="main-content-inner">
            <div class="page-content">
                <form id="mainForm" class="form-horizontal" role="form" method="post">
                    <div class="row">
                        <%-- <div id="queryDate" class="col-xs-12 form-group" v-if="showAndEdit==='show'">--%>
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
                            <div class="col-xs-1">

                            </div>
                            <%-- </div>--%>
                        </div>
                        <div class="col-xs-12 form-group" style="margin-top: 10px">
                            <label class="col-xs-1 control-label no-padding-right">行政区/点位：</label>
                            <div class="col-xs-2">
                                <div class="col-xs-4 no-padding-right no-padding-left" style="width: 160px;">
                                    <div class="input-group">
                                        <input type="text" id="regionAndpoint" class="form-control"
                                               @click="cheakRegionAndPoint"
                                               v-model="name" readonly="readonly">
                                    </div>
                                </div>
                            </div>
                            <label class="col-xs-1 control-label no-padding-right ">展示指标：</label>
                            <div class="col-xs-2">
                                <div class="col-xs-4 no-padding-right no-padding-left" style="width: 160px;">
                                    <div class="input-group">
                                        <select id="sel" @change="cge">
                                            <option value="NO2">NO₂</option>
                                            <option value="SO2">SO₂</option>
                                            <option value="CO">CO</option>
                                            <option value="O3">O₃</option>
                                            <option value="PM10">PM₁₀</option>
                                            <option value="PM2.5">PM₂.₅</option>
                                            <option value="VOCs">VOCs</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                            <div class="form-group">
                                <div class="col-xs-10">
                                </div>
                                <div class="col-xs-2" style="text-align: right">
                                    <button type="button" class="btn  btn-info btn-default-ths" @click="queryListByPointCode">
                                        <i class="ace-icon fa fa-search"></i> 查询
                                    </button>
                                    <button type="button" class="btn btn-xs btn-primary btn-default-ths" @click="exportExcel">
                                        <i class="ace-icon fa fa-download"></i> 导出
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
                        <div class="col-xs-3 echars echartsHeihgt" id="trendLayer" style="height: 300px;width: 100%">
                        </div>
                    </div>

                    <div class="col-xs-12 form-group">
                        <div class="col-xs-6 echars echartsHeihgt" id="table12">
                            <div class="timeType">12时</div>
                            <div>单位：μg/m³（CO为mg/m³）</div>
                            <table class="table table-bordered table-hover">
                                <thead>
                                <tr>
                                    <th style="text-align: center">点位</th>
                                    <th style="text-align: center">时间</th>
                                    <th style="text-align: center;width: 5%;">SO<sub>2</sub></th>
                                    <th style="text-align: center;width: 5%;">NO<sub>2</sub></th>
                                    <th style="text-align: center;width: 5%;">PM<sub>10</sub></th>
                                    <th style="text-align: center;width: 7%;">CO<sub></sub></th>
                                    <th style="text-align: center;width: 7%;">O<sub>3</sub></th>
                                    <th style="text-align: center;width: 5%;">PM<sub>2.5</sub></th>
                                    <th style="text-align: center;width: 9%;">VOCs</th>
                                </tr>
                                </thead>
                                <tbody>
                                <template v-if="measureObj12.list != null && measureObj12.list.length > 0" v-for="(item,index) in measureObj12.list">
                                    <tr>
                                        <td style="text-align: center" :title="item.pointName">{{item.pointName}}</td>
                                        <td style="text-align: center" :title="item.resultTime">{{item.resultTime}}</td>
                                        <td style="text-align: right" :title="item.so2">{{item.so2}}</td>
                                        <td style="text-align: right" :title="item.no2">{{item.no2}}</td>
                                        <td style="text-align: right" :title="item.pm10">{{item.pm10}}</td>
                                        <td style="text-align: right" :title="item.co">{{item.co}}</td>
                                        <td style="text-align: right" :title="item.o3">{{item.o3}}</td>
                                        <td style="text-align: right" :title="item.pm25">{{item.pm25}}</td>
                                        <td style="text-align: right" :title="item.vocs">{{item.vocs}}</td>
                                    </tr>
                                </template>
                                <tr v-if="measureObj12.list == null || measureObj12.list == 0" >
                                    <td colspan="12" style="text-align: center;">暂无数据</td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="col-xs-6 echars echartsHeihgt" id="table00">
                            <div class="timeType">0时</div>
                            <div>单位：μg/m³（CO为mg/m³）</div>
                            <table class="table table-bordered table-hover">
                                <thead>
                                <tr>
                                    <th style="text-align: center">点位</th>
                                    <th style="text-align: center">时间</th>
                                    <th style="text-align: center;width: 5%;">SO<sub>2</sub></th>
                                    <th style="text-align: center;width: 5%;">NO<sub>2</sub></th>
                                    <th style="text-align: center;width: 5%;"><sub>10</sub></th>
                                    <th style="text-align: center;width: 7%;">CO<sub></sub></th>
                                    <th style="text-align: center;width: 7%;">O<sub>3</sub></th>
                                    <th style="text-align: center;width: 5%;">PM<sub>2.5</sub></th>
                                    <th style="text-align: center;width: 9%;">VOCs</th>
                                </tr>
                                </thead>
                                <tbody>
                                <template v-if="measureObj0.list != null && measureObj0.list.length > 0" v-for="(item,index) in measureObj0.list">
                                    <tr>
                                        <td style="text-align: center" :title="item.pointName">{{item.pointName}}</td>
                                        <td style="text-align: center" :title="item.resultTime">{{item.resultTime}}</td>
                                        <td style="text-align: right" :title="item.so2">{{item.so2}}</td>
                                        <td style="text-align: right" :title="item.no2">{{item.no2}}</td>
                                        <td style="text-align: right" :title="item.pm10">{{item.pm10}}</td>
                                        <td style="text-align: right" :title="item.co">{{item.co}}</td>
                                        <td style="text-align: right" :title="item.o3">{{item.o3}}</td>
                                        <td style="text-align: right" :title="item.pm25">{{item.pm25}}</td>
                                        <td style="text-align: right" :title="item.vocs">{{item.vocs}}</td>
                                    </tr>
                                </template>
                                <tr v-if="measureObj0.list == null || measureObj0.list == 0" >
                                    <td colspan="12" style="text-align: center;">暂无数据</td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="col-xs-12">
                            <my-pagination @handlecurrentchange="handlecurrentchange"
                                           :tableobj="measureObj0"></my-pagination>
                        </div>
                    </div>
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
<%@ include file="/WEB-INF/jsp/components/common/page-pagination.jsp" %>
<script type="text/javascript" src="${ctx }/assets/components/zTree/js/jquery.ztree.all.js?v=20221129015223"></script>
<script type="text/javascript" src="${ctx}/assets/components/echarts/echarts.min.js?v=20221129015223"></script>
<!-- 文件上传 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/file/file-upload-util.js?v=20221129015223"></script>
<!-- 分析平台-时间轴组件-逻辑js -->
<script type="text/javascript" src="${ctx}/assets/custom/components/analysis/js/time-axis.js?v=20221129015223"></script>
<script id="vue-template-time-axis" type="text/x-template">
    <%@ include file="/WEB-INF/jsp/components/analysis/time-axis.jsp" %>
</script>
<!-- 文件下载 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/file/file-download-util.js?v=20221129015223"></script>

<script type="text/javascript"
        src="${ctx}/assets/custom/analysis/forecast/trendforecast/trendForecast.js?v=20221129015223"></script>
</body>
</html>
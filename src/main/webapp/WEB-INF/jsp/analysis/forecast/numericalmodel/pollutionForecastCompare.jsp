<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>近期污染物浓度预报比较</title>
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp" %>
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
            margin-top: 20px;
            margin-left: 5%;
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
                            <i class="header-icon fa fa-anchor"></i>
                            近期污染物浓度预报比较
                        </h5>
                    </li>
                </ul>
            </div>
        </div>
        <div class="main-content-inner">
            <div class="page-content">
                <form id="mainForm" class="form-horizontal" role="form" id="formList" method="post">
                    <div class="form-group">
                        <label class="col-xs-1 control-label no-padding-right">
                            <i title="预报日期范围必须≤14天！"></i>预报日期：
                        </label>
                        <div class="col-xs-4">
                            <div class="col-xs-5">
                                <div class="input-group" @click="forecastTimeStart">
                                    <input type="text" class="form-control" :value="queryParams.forecastTimeStart"
                                           id="forecastTimeStart" readonly="readonly" placeholder="请选择预报时间">
                                    <span class="input-group-btn">
                                                 <button type="button" class="btn btn-white btn-default">
                                                     <i class="ace-icon fa fa-calendar"></i>
                                                 </button>
                                             </span>
                                </div>
                            </div>
                            <label class="col-xs-1 control-label  no-padding-right"
                                   style="text-align: center ;padding-left: 0px">至</label>
                            <div class="col-xs-5">
                                <div class="input-group" @click="forecastTimeEnd">
                                    <input type="text" class="form-control" :value="queryParams.forecastTimeEnd"
                                           id="forecastTimeEnd" readonly="readonly" placeholder="请选择预报时间">
                                    <span class="input-group-btn">
                                                 <button type="button" class="btn btn-white btn-default">
                                                     <i class="ace-icon fa fa-calendar"></i>
                                                 </button>
                                             </span>
                                </div>
                            </div>
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
                            <button type="button" class="btn  btn-info btn-default-ths" @click="doSearch">
                                <i class="ace-icon fa fa-search"></i> 查询
                            </button>
                            <button type="button" class="btn btn-xs btn-primary btn-default-ths" @click="exportExcel">
                                <i class="ace-icon fa fa-download"></i> 导出
                            </button>
                        </div>
                    </div>
                    <hr class="no-margin">
                    <div class="col-xs-6 form-group">
                        <div class="timeType">12时</div>
                        <div id="pm25_12" style="height: 450px">

                        </div>
                        <div id="o3_8_12" style="height: 450px">

                        </div>
                    </div>
                    <div class="col-xs-6 form-group">
                        <div class="timeType">0时</div>
                        <div id="pm25_0" style="height: 450px">

                        </div>
                        <div id="o3_8_0" style="height: 450px">

                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp" %>
<script type="text/javascript">
    // 地址
    var ctx = "${ctx}";
</script>
<%--Ztree--%>
<script type="text/javascript" src="${ctx }/assets/components/zTree/js/jquery.ztree.all.js"></script>
<%--echarts--%>
<script type="text/javascript" src="${ctx}/assets/components/echarts/echarts.min.js"></script>
<!-- Ajax 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/ajax-util.js"></script>
<!-- 文件下载 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/file/file-download-util.js"></script>

<script type="text/javascript"
        src="${ctx}/assets/custom/analysis/forecast/numericalmodel/pollutionForecastCompare.js"></script>
</body>
</html>
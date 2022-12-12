<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>预报进程</title>
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp" %>
    <link href="${ctx }/assets/custom/components/analysis/css/time-axis.css?v=20221129015223" rel="stylesheet"/>
</head>

<body class="no-skin">
<div class="main-container" id="main-container" v-cloak>
    <div class="main-content">
        <div class="main-content-inner fixed-page-header fixed-40">
            <div id="breadcrumbs" class="breadcrumbs">
                <ul class="breadcrumb">
                    <li class="active">
                        <h5 class="page-title">
                            <i class="header-icon fa fa-cubes"></i>
                            预报进程
                        </h5>
                    </li>
                </ul>
            </div>
        </div>
        <div class="main-content-inner">
            <div class="page-content">
                <form id="mainForm" class="form-horizontal" role="form" id="formList" method="post">
                    <div class="row">
                        <label class="col-xs-2 control-label no-padding-right">
                           预报进程日期：
                        </label>
                        <div class="col-xs-3">
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

                        <div class="col-xs-7 align-right no-padding form-group">
                            <button type="button" class="btn  btn-info btn-default-ths" @click="doSearch">
                                <i class="ace-icon fa fa-search"></i> 查询
                            </button>
                            <button type="button" class="btn btn-primary btn-default-ths" @click="exportExcel">
                                <i class="ace-icon fa fa-download"></i> 导出
                            </button>
                        </div>
                    </div>
                    <hr class="no-margin">
                    <div class="col-xs-12 form-group">
                        <div class="col-xs-12 "  >
                            <table class="table table-bordered table-hover">
                                <thead>
                                    <tr>
                                        <th style="text-align: center;">序号</th>
                                        <th style="text-align: center;">时间</th>
                                        <th style="text-align: center;">内容</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="(item,index) in forecastPage.list">
                                        <td style="text-align: right;">{{(forecastPage.pageNum-1)*forecastPage.pageSize+index+1}}</td>
                                        <td style="text-align: center;"> {{item.logTime.substring(0,16)}}</td>
                                        <td style="text-align: center;" >{{item.logText}}</td>
                                    </tr>
                                    <tr v-if="forecastPage.list.length===0">
                                        <td colspan="3" class="text-center">暂无数据</td>
                                    </tr>
                                </tbody>
                            </table>
                            <my-pagination @handlecurrentchange="doSearch()" :tableobj="forecastPage"></my-pagination>
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
<!-- 分页组件 -->
<%@ include file="/WEB-INF/jsp/components/common/page-pagination.jsp" %>
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
<!-- 文件下载 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/file/file-download-util.js?v=20221129015223"></script>
<script type="text/javascript"
        src="${ctx}/assets/custom/analysis/forecast/numericalmodel/forecastProcess.js?v=20221129015223"></script>
</body>
</html>
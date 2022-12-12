<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <title>预报结果评估</title>
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp" %>
    <!-- 引入样式 -->
    <%--<link rel="stylesheet"	href="${ctx}/assets/components/element-ui/lib/theme-chalk/index.css">--%>
    <!--页面自定义的CSS，请放在这里 -->
</head>
<body class="no-skin">
<div class="main-container" id="main-container" v-cloak>
    <div class="main-content">
        <div class="main-content-inner fixed-page-header fixed-40">
            <div id="breadcrumbs" class="breadcrumbs">
                <ul class="breadcrumb">
                    <li class="active">
                        <h5 class="page-title">
                            <i class="fa fa-road"></i> 区县预报准确率
                        </h5>
                    </li>
                </ul>
            </div>
        </div>
        <div class="main-content-inner padding-page-content">
            <div class="page-content">
                <div class="space-4"></div>
                <!-- 顶部面板 -->
                <div class="row">
                    <!-- 查询区域 -->
                    <div class="col-xs-12">
                        <form class="form-horizontal" role="form" id="formList"
                              action="list.vm" method="post">
                            <div class="form-group">
                                <label class="col-sm-1 control-label no-padding-right ">起报时间：</label>
                                <div class="col-xs-2">
                                    <div class="input-group" @click="queryTimeStart">
                                        <input type="text" class="form-control" :value="params.startTime"
                                               placeholder="请选择开始时间" id="queryTimeStart" readonly="readonly">
                                        <span class="input-group-btn">
                                                 <button type="button" class="btn btn-white btn-default">
                                                     <i class="ace-icon fa fa-calendar"></i>
                                                 </button>
                                            </span>
                                    </div>
                                </div>
                                <label class="col-xs-1 control-label " style="width: 3%">至</label>
                                <div class="col-xs-2 ">
                                    <div class="input-group" @click="queryTimeEnd">
                                        <input type="text" class="form-control" :value="params.endTime"
                                               placeholder="请选择结束时间" id="queryTimeEnd" readonly="readonly">
                                        <span class="input-group-btn">
                                                 <button type="button" class="btn btn-white btn-default">
                                                     <i class="ace-icon fa fa-calendar"></i>
                                                 </button>
                                            </span>
                                    </div>
                                </div>
                                <div class="col-sm-3  align-right" style="float: right;">
                                    <div class="space-1 hidden-lg hidden-md hidden-sm"></div>

                                    <button type="button" class="btn btn-info btn-default-ths"
                                            @click="doSearch">
                                        <i class="ace-icon fa fa-search"></i> 查询
                                    </button>
                                    <button type="button"  @click="exportFile" class="btn btn-xs btn-primary btn-default-ths  pull-right" style="margin-left:5px">
                                        <i class="ace-icon fa fa-download"></i> 导出
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="space-4"></div>
                <!-- 底部面板 -->
                <div id="tableContent" class="tab-content" style="margin-left:20px">
                    <div id="zj-assess" class="tab-pane fade in active assess-type">
                        <div class="row">
                            <div class="col-xs-12" style="width:90%;margin-left: 5%;margin-top: 20px;"  >
                                <table id="ZJ-listTable" class="table table-bordered table-hover">
                                    <thead>
                                    <tr>
                                        <th rowspan="2" class="align-center" width="10%">行政区</th>
                                        <th colspan="3" class="align-center" width="10%">预报第一天准确率</th>
                                        <th colspan="3" class="align-center" width="10%">预报第二天准确率</th>
                                        <th colspan="3" class="align-center" width="10%">预报第三天准确率</th>
                                    </tr>
                                    <tr>
                                        <th class="align-center" width="10%">AQI</th>
                                        <th class="align-center" width="10%">等级</th>
                                        <th class="align-center" width="10%">首要污染物</th>
                                        <th class="align-center" width="10%">AQI</th>
                                        <th class="align-center" width="10%">等级</th>
                                        <th class="align-center" width="10%">首要污染物</th>
                                        <th class="align-center" width="10%">AQI</th>
                                        <th class="align-center" width="10%">等级</th>
                                        <th class="align-center" width="10%">首要污染物</th>
                                    </tr>
                                    </thead>
                                    <tbody >
                                        <tr v-for="item in tableList">
                                            <td style="text-align: center">{{item.REGION_NAME | resultFormat}}</td>
                                            <td style="text-align: center">{{item.ZQAQI1 | resultFormat}}</td>
                                            <td style="text-align: center">{{item.ZQLEVEL1 | resultFormat}}</td>
                                            <td style="text-align: center">{{item.ZQSW1 | resultFormat}}</td>
                                            <td style="text-align: center">{{item.ZQAQI2 | resultFormat}}</td>
                                            <td style="text-align: center">{{item.ZQLEVEL2 | resultFormat}}</td>
                                            <td style="text-align: center">{{item.ZQSW2 | resultFormat}}</td>
                                            <td style="text-align: center">{{item.ZQAQI3 | resultFormat}}</td>
                                            <td style="text-align: center">{{item.ZQLEVEL3 | resultFormat}}</td>
                                            <td style="text-align: center">{{item.ZQSW3 | resultFormat}}</td>
                                        </tr>

                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!--/.main-content-inner-->
    </div>
    <!-- /.main-content -->
</div>
<!-- /.main-container -->
<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp" %>
<!-- vue插件 -->
<script type="text/javascript" src="${ctx}/assets/components/vue/vue.min.js"></script>
<!-- Echarts4组件 -->
<script type="text/javascript" src="${ctx}/assets/components/echarts/echarts.min.js"></script>
<!-- 自定义JS -->
<script type="text/javascript" src="${ctx}/assets/custom/common/file/file-download-util.js"></script>
<script type="text/javascript" src="${ctx}/assets/custom/analysis/forecast/airforecastcheck/countyIndex2.js"></script>
</body>
</html>
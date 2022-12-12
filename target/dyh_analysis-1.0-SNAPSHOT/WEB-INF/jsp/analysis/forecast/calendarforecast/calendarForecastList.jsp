<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>平原城市预报日历 </title>
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp" %>
    <link href="${ctx }/assets/custom/components/analysis/css/time-axis.css?v=20221205102239" rel="stylesheet"/>
    <link rel="stylesheet" href="${ctx }/assets/components/element-ui/css/index.css?v=20221205102239"/>
</head>

<body class="no-skin">
<div class="main-container" id="main-container" v-cloak>
    <div class="main-content">
        <div class="main-content-inner fixed-page-header fixed-40">
            <div id="breadcrumbs" class="breadcrumbs">
                <ul class="breadcrumb">
                    <li class="active">
                        <h5 class="page-title">
                            <i class="menu-icon fa"
                               :class="[cityNums=='4'?'fa-calculator':'fa-calendar-check-o']"></i>
                            {{cityNums==4?'成德眉资城市圈':'成都平原八市预报'}}
                        </h5>
                    </li>
                </ul>
            </div>
        </div>
        <div class="main-content-inner">
            <div class="page-content">
                <form id="mainForm" class="form-horizontal" role="form" method="post">
                    <div class="col-xs-12">
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
                        <div class="col-xs-9">
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
                    </div>
                    <div class="col-xs-12" style="margin-top: 10px;margin-bottom: 8px">
                        <label class="col-xs-1 control-label no-padding-right">模式选择：</label>
                        <div class="col-xs-9">
                            <el-radio-group v-model="model" size="small" @change.native="changeModel">
                                <template v-for="(item,index) in modelList">
                                    <el-radio-button :label="item.code">{{item.name}}</el-radio-button>
                                </template>
                            </el-radio-group>
                        </div>
                        <div class="col-xs-2">
                            <button type="button" class="btn btn-xs btn-primary btn-default-ths" @click="exportExcel"
                                    style="float: right;margin-right: 10px;">
                                <i class="ace-icon fa fa-download"></i> 导出
                            </button>
                        </div>
                    </div>
                    <div class="form-group  col-xs-12">
                        <hr class="no-margin">
                    </div>
                    <div id="mainContainer1">
                        <template v-if="model == 'CFS' || model == 'CMA'">
                            <div class="col-xs-2"></div>
                            <div id="zero" :key="model + 'zero-0'" class="col-xs-8 echars echartsHeihgt" style="height: 1000px">
                            </div>
                        </template>
                        <template v-else>
                            <div id="twelve" :key="model + 'zero-1'" class="col-xs-6 echars echartsHeihgt" style="height: 800px">
                            </div>
                            <div id="zero" :key="model + 'zero-12'" class="col-xs-6 echars echartsHeihgt" style="height: 800px">
                            </div>
                        </template>
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
    var cityNums = '<%=request.getParameter("queryPointType")%>';
</script>
<script type="text/javascript" src="${ctx}/assets/components/vue/vue.js?v=20221205102239"></script>
<script type="text/javascript" src="${ctx}/assets/components/element-ui/index.js?v=20221205102239"></script>
<script type="text/javascript" src="${ctx}/assets/components/echarts/echarts.min.js?v=20221205102239"></script>
<!-- 日期时间 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/date-time-util.js?v=20221205102239"></script>
<!-- 分析平台-时间轴组件-逻辑js -->
<script type="text/javascript" src="${ctx}/assets/custom/components/analysis/js/time-axis.js?v=20221205102239"></script>
<script id="vue-template-time-axis" type="text/x-template">
    <%@ include file="/WEB-INF/jsp/components/analysis/time-axis.jsp" %>
</script>
<!-- 文件下载 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/file/file-download-util.js?v=20221205102239"></script>
<script type="text/javascript"
        src="${ctx}/assets/custom/analysis/forecast/calendarforecast/calendarForecastList.js?v=20221205102239"></script>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <title>预报结果评估</title>
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp" %>
    <!-- 引入样式 -->
    <%--<link rel="stylesheet"	href="${ctx}/assets/components/element-ui/lib/theme-chalk/index.css?v=20221207100602">--%>
    <link rel="stylesheet" href="${ctx }/assets/components/element-ui/css/index.css?v=20221207100602"/>
    <!--页面自定义的CSS，请放在这里 -->
    <style type="text/css">
        .time-axis li {
            float: left;
            width: 25px;
            height: 28px;
            line-height: 28px;
            border: 1px solid #00FF00;
            border-radius: 3px;
            text-align: center;
            font-size: 14px;
            color: #00FF00;
            cursor: pointer;
        }

        .time-axis {
            list-style: none;
            margin-top: 10px;
        }
        .checked{
            background-color: #00FF00;
            color: #fff !important;
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
                            <i class="fa fa-map-pin"></i> 城市预报准确率
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
                                <label class="col-sm-1 control-label no-padding-right ">预报时间：</label>
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
                                <label class="col-sm-1 control-label no-padding-right"
                                       style="display: none">预报时长：</label>
                                <div class="col-sm-2 " style="display: none">
                                    <select id="selTimeStep" name="TIME_STEP" class="form-control">
                                        <option value="1">24小时</option>
                                        <option value="2">48小时</option>
                                        <option value="3">72小时</option>
                                        <option value="4">96小时</option>
                                        <option value="5">120小时</option>
                                        <option value="6">148小时</option>
                                        <option value="7">168小时</option>
                                    </select>
                                </div>
                                <div class="col-sm-1  align-right" style="float: right;">
                                    <div class="space-1 hidden-lg hidden-md hidden-sm"></div>
                                    <button type="button" class="btn btn-info btn-default-ths pull-right"
                                            @click="doSearch">
                                        <i class="ace-icon fa fa-search"></i> 查询
                                    </button>
                                </div>

                            </div>

                        </form>
                    </div>
                </div>
                <div class="space-4"></div>

                <!-- 底部面板 -->

                        <div class="row">
                            <div class="col-xs-12">
                                <template v-if="type=='ZJPG'">
                                    <label class="col-sm-8"></label>
                                </template>
                                <template v-else-if="type=='MSPG'">
                                    <div class="col-sm-8">
                                        <div class="col-sm-12">
                                            <label class="col-sm-2 control-label no-padding-right "
                                                   style="text-align: right;line-height: 34px">
                                                <span class="g-text-gray">预测模型：</span>
                                            </label>
                                            <el-radio-group v-model="params.modelName" size="small" @change.native="changeModel()">
                                                <template  v-for="(item,index) in modelList">
                                                    <el-radio-button :label="item.code">{{item.name}}</el-radio-button>
                                                </template>
                                            </el-radio-group>
                                        </div>
                                        <div class="col-sm-12">
                                            <label class="col-sm-2 control-label no-padding-right "
                                                   style="text-align: right;line-height: 34px">
                                                <span class="g-text-gray">时次：</span>
                                            </label>
                                            <el-radio-group v-model="params.timeType" size="small" @change.native="doSearch()">
                                                <el-radio-button label="0">0时</el-radio-button>
                                                <template  v-if="params.modelName!='CFS' && params.modelName!='CMA'">
                                                    <el-radio-button label="12">12时</el-radio-button>
                                                </template>
                                            </el-radio-group>
                                        </div>
                                    </div>
                                </template>
                                <template v-else-if="type=='GRPG'">
                                    <label class="col-sm-1 control-label no-padding-right "
                                           style="margin-top: 14px; text-align: right;">
                                        <span class="g-text-gray">预报人员：</span>
                                    </label>
                                    <div class="col-sm-7" style="margin-top: 14px; text-align: left;">
                                        <label class="check-label" v-for="(item,index) in personList"
                                               @change="changeCheckBox()">
                                            <input type="checkbox" v-model="item.checked"/>
                                            <span>{{item.userName}}&nbsp;&nbsp;</span>
                                        </label>
                                    </div>
                                </template>
                                <label class="col-sm-1 control-label no-padding-right "
                                       style="margin-top: 14px; text-align: right;">预报天数：</label>
                                <div class="col-sm-3 control-label no-padding-right " style="width: 280px">
                                    <ul class="time-axis no-margin-left" v-for="item in ybdList">
                                        <li @click="stepTo(item.value)"  :class="item.select">{{item.value}}</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <!-- Echarts区域 -->
                            <div class="col-xs-8">
                                <div id="mychart" style="height:450px;"></div>
                            </div>
                            <div class="col-xs-4">
                                <div id="mycharts" style="height:450px;"></div>
                            </div>
                            <div class="col-xs-8">
                                <div id="mychartpm25" style="height:450px;"></div>
                            </div>
                            <div class="col-xs-4">
                                <div id="mychartpm25s" style="height:450px;"></div>
                            </div>
                            <div class="col-xs-8">
                                <div id="mycharto3" style="height:450px;"></div>
                            </div>
                            <div class="col-xs-4">
                                <div id="mycharto3s" style="height:450px;"></div>
                            </div>
                            <%--主要污染物预测--%>
                            <div class="row">
                                <div class="col-xs-12" style="height: 250px;" id="pollutant-forecast"></div>
                            </div>
                            <%--空气质量等级预测--%>
                            <div class="row">
                                <div class="col-xs-12" style="height: 250px;" id="level-forecast"></div>
                            </div>

                        </div>


                <div class="row">
                    <div  class="col-xs-12" >
                        <iframe id="iframeInfo3"  src="${ctx}/analysis/forecastflow/humanForecastCheck/countyIndex.vm" style="width: 100%;height: 1138px;"  scrolling="no" frameborder="no"></iframe>
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
<script type="text/javascript" src="${ctx}/assets/components/vue/vue.min.js?v=20221207100602"></script>
<!-- Echarts4组件 -->
<script type="text/javascript" src="${ctx}/assets/components/echarts/echarts.min.js?v=20221207100602"></script>
<script type="text/javascript" src="${ctx}/assets/components/element-ui/index.js?v=20221207100602"></script>
<script>
    var startTime = "${START_TIME}";
    var endTime = "${END_TIME}";
   // autoHeightIframe("iframeInfo3");
</script>
<!-- 自定义JS -->
<script type="text/javascript" src="${ctx}/assets/custom/analysis/forecast/airforecastcheck/index.js?v=20221207100602"></script>
</body>
</html>
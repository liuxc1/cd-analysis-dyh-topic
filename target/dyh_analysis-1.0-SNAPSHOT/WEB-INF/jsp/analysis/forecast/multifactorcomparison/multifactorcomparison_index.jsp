<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>多要素对比</title>
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp" %>
    <link href="${ctx }/assets/custom/components/analysis/css/time-axis.css?v=20221204075322" rel="stylesheet"/>
    <link rel="stylesheet" href="${ctx }/assets/components/zTree/css/zTreeStyle/zTreeStyle.css?v=20221204075322"/>
    <link rel="stylesheet" href="${ctx }/assets/components/zTree/css/metroStyle/metroStyle.css?v=20221204075322"/>
    <link rel="stylesheet" href="${ctx }/assets/components/element-ui/css/index.css?v=20221204075322"/>
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
      .el-radio-group {
          margin-left: 12px;
          margin-bottom: 5px;
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
                            <i class="fa fa-balance-scale" aria-hidden="true"></i>
                            多要素对比
                        </h5>
                    </li>
                </ul>
            </div>
        </div>
        <div class="main-content-inner">
            <div class="page-content">
                <form id="mainForm" class="form-horizontal" role="form" id="formList" method="post">
                    <div class="row ">
                        <div class="col-xs-12 ">
                            <label class="col-xs-1 control-label no-padding-right">预报时长：</label>
                            <el-radio-group v-model="stepDay" size="small" @change.native="changeStep">
                               <%-- <template v-if="queryParams.model !== 'CFS'">--%>
                                    <el-radio-button label="8" >8天</el-radio-button>
                                    <el-radio-button label="14" >14天</el-radio-button>
                                <%--</template>
                                <template v-else>--%>
                                    <el-radio-button label="35" >35天</el-radio-button>
                               <%-- </template>--%>
                            </el-radio-group>
                        </div>

                        <div class="col-xs-12 " >
                            <label class="col-xs-1 control-label no-padding-right">起报日期：</label>
                            <div class="col-xs-2">
                                <div class="col-xs-4 no-padding-right no-padding-left" style="width: 160px;">
                                    <div class="input-group" id="divDate" @click="wdatePicker">
                                        <input type="text" id="txtDateStart" class="form-control" v-model="queryParams.month" name="datetime" readonly="readonly">
                                        <span class="input-group-btn">
                                                <button type="button" class="btn btn-white btn-default"  id="btnDateStart" readonly="readonly">
                                                    <i class="ace-icon fa fa-calendar"></i>
                                                </button>
                                            </span>
                                    </div>
                                </div>
                            </div>
                            <div>
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
                                    <div class="col-xs-1" >
                                </div>
                            </div>
                        </div>
                        <div class="col-xs-12 " style="margin-top: 10px;margin-bottom: 10px">
                            <label class="col-xs-1 control-label no-padding-right">行政区/点位：</label>
                            <div class="col-xs-2">
                                <div class="col-xs-4 no-padding-right no-padding-left" style="width: 160px;">
                                    <div class="input-group"  >
                                        <input type="text" id="regionAndpoint" class="form-control" @click = "cheakRegionAndPoint" v-model="queryParams.pointName"    readonly="readonly">
                                    </div>
                                </div>
                            </div>

                            <div class=" form-group" style="float: right;margin-right: 10px;" >
                                <button type="button" class="btn  btn-info btn-default-ths" @click="query" >
                                    <i class="ace-icon fa fa-search"></i> 查询
                                </button>
                            </div>
                        </div>
                    </div>
                    <hr class="no-margin">
                    <%--污染浓度变化 - echart--%>
                    <div class="col-xs-12 form-group" style="margin-top: 10px">
                        <label class="col-xs-1 control-label no-padding-right">展示指标：</label>
                        <div class="col-xs-2">
                            <select class="form-control"  v-model="queryParams.pollutant" @change="queryModelForcastList">
                                <option v-for="(item,index) in polluteList" :key="item.POLLUTE"  :value="item.POLLUTE">
                                    {{item.OTHERNAME}}
                                </option>
                            </select>
                        </div>
                    </div>

                    <div class="col-xs-12 form-group">
                        <template v-if="queryParams.model == 'CFS' || queryParams.model == 'CMA'">
                            <div class="col-xs-12">
                                <div id="echarts00" style="height: 450px">
                                </div>
                            </div>
                        </template>

                        <template v-else>
                            <div class="col-xs-6">
                                <div id="echarts22" style="height: 450px">
                                </div>
                            </div>
                            <div class="col-xs-6">
                                <div id="echarts00" style="height: 450px">
                                </div>
                            </div>
                        </template>
                    </div>

                     <hr class="no-margin">
                    <%--气象要素变化--%>
                    <div class="col-xs-12 form-group" style="margin-top: 10px">
                        <label class="col-xs-1 control-label no-padding-right">展示指标：</label>
                        <div class="col-xs-2">
                            <select class="form-control"  v-model="queryParams.targetIndex" @change="changeTarget()">
                                <option v-for="(item,index) in targetTypeList" :value="item.targetIndex">
                                    {{item.targetName}}
                                </option>
                            </select>
                        </div>
                        <template v-if="queryParams.targetIndex==10">
                            <label class="col-xs-1 control-label no-padding-right">数据类型：</label>
                            <div class="col-xs-2">
                                <select class="form-control"
                                        v-model="queryParams.dataType" @change="queryWeatherList">
                                    <option v-for="(item,index) in dataTypeList" :value="item.typeCode">
                                        {{item.typeName}}
                                    </option>
                                </select>
                            </div>
                        </template>
                    </div>

                    <div class="col-xs-12 form-group">
                        <template v-if="queryParams.model == 'CFS' || queryParams.model == 'CMA'">
                            <div class="col-xs-12">
                                <div id="echarts_00" style="height: 450px">
                                </div>
                            </div>
                        </template>
                        <template v-else>
                            <div class="col-xs-6">
                                <div id="echarts_12" style="height: 450px">
                                </div>
                            </div>
                            <div class="col-xs-6">
                                <div id="echarts_00" style="height: 450px">
                                </div>
                            </div>
                        </template>
                    </div>


                </form>
            </div>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp" %>
<img id="errorImg" src="${ctx}/mvc/forecastshow/no_img.jpg" style="display: none">
<script type="text/javascript">
    var ctx = "${ctx}";
    var model = '<%=request.getParameter("model")%>';
    var modelTime = '<%=request.getParameter("modelTime")%>';
    var pointCode = '<%=request.getParameter("pointCode")%>';
    var pointName = '<%=request.getParameter("pointName")%>';
    const wrfImagePth = '${path}';
    //设置iframe自动高
    autoHeightIframe("iframeInfo");
    autoHeightIframe("iframeInfo2");
/*
    autoHeightIframe("iframeInfo3");
*/

</script>
<script type="text/javascript" src="${ctx}/assets/components/vue/vue.js?v=20221204075322"></script>
<script type="text/javascript" src="${ctx }/assets/components/zTree/js/jquery.ztree.all.js?v=20221204075322"></script>
<script type="text/javascript" src="${ctx}/assets/components/echarts/echarts.js?v=20221204075322"></script>
<!-- Dialog 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/dialog-util.js?v=20221204075322"></script>
<!-- Ajax 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/ajax-util.js?v=20221204075322"></script>
<!-- 日期时间 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/date-time-util.js?v=20221204075322"></script>
<!-- 文件上传 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/file/file-upload-util.js?v=20221204075322"></script>
<!-- 分析平台-时间轴组件-逻辑js -->
<script type="text/javascript" src="${ctx}/assets/custom/components/analysis/js/time-axis.js?v=20221204075322"></script>
<script id="vue-template-time-axis" type="text/x-template">
    <%@ include file="/WEB-INF/jsp/components/analysis/time-axis.jsp" %>
</script>
<!-- vue-分页组件 -->
<%@ include file="/WEB-INF/jsp/components/common/page-pagination.jsp" %>
<!-- 文件下载 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/file/file-download-util.js?v=20221204075322"></script>
<script type="text/javascript" src="${ctx}/assets/components/element-ui/index.js?v=20221204075322"></script>
<script type="text/javascript" src="${ctx}/assets/custom/analysis/forecast/multifactorcomparison/multifactorcomparison_index.js?v=20221204075322"></script>
</body>
</html>
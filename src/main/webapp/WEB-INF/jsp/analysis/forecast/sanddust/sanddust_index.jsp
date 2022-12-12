<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>沙尘预报趋势图</title>
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp" %>
    <link href="${ctx }/assets/custom/components/analysis/css/time-axis.css" rel="stylesheet"/>
    <link rel="stylesheet" href="${ctx }/assets/components/zTree/css/zTreeStyle/zTreeStyle.css"/>
    <link rel="stylesheet" href="${ctx }/assets/components/zTree/css/metroStyle/metroStyle.css"/>
    <link rel="stylesheet" href="${ctx }/assets/components/element-ui/css/index.css"/>
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
                            <i class="fa fa-line-chart" aria-hidden="true"></i> 沙尘预报趋势图
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
                                        <input type="text" id="txtDateStart" class="form-control" v-model="queryParams.month" name="datetime" readonly="readonly">
                                        <span class="input-group-btn">
                                                <button type="button" class="btn btn-white btn-default"  id="btnDateStart" readonly="readonly">
                                                    <i class="ace-icon fa fa-calendar"></i>
                                                </button>
                                        </span>
                                    </div>
                                </div>
                            </div>
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
                    <div class="col-xs-12 form-group">
                        <div id="echarts00" style="height: 450px"></div>
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
<script type="text/javascript" src="${ctx}/assets/components/vue/vue.js"></script>
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
<!-- vue-分页组件 -->
<%@ include file="/WEB-INF/jsp/components/common/page-pagination.jsp" %>
<!-- 文件下载 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/file/file-download-util.js"></script>
<script type="text/javascript" src="${ctx}/assets/components/element-ui/index.js"></script>
<script type="text/javascript" src="${ctx}/assets/custom/analysis/forecast/sanddust/sanddust_index.js"></script>
</body>
</html>
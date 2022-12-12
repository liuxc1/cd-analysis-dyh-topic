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
<div class="main-container" >
    <div class="main-content">
        <div class="main-content-inner">
            <div class="page-content">
                <div class="row ">
                    <div class="col-xs-12" >
                        <iframe id="iframeInfo3"  src="${ctx}/analysis/air/dustForecast/index.vm" style="width: 100%;"  scrolling="no" frameborder="no"></iframe>
                    </div>
                    <div class="col-xs-12">
                        <iframe id="iframeInfo2"  src="${ctx}/analysis/air/sandDust/index.vm" style="width: 100%;"  scrolling="no" frameborder="no"></iframe>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp" %>
<img id="errorImg" src="${ctx}/mvc/forecastshow/no_img.jpg" style="display: none">
<script type="text/javascript">
    var ctx = "${ctx}";
    //设置iframe自动高
    autoHeightIframe("iframeInfo3");
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

</body>
</html>
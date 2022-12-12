<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp" %>
    <link href="${ctx}/mvc/forecastshow/util/util.css?ver=${ver}" rel="stylesheet" type="text/css">
    <link href="${ctx}/mvc/forecastshow/iv/imageviewer.css?ver=${ver}" rel="stylesheet" type="text/css">
    <link href="${ctx}/mvc/forecastshow/myPlay.css?ver=${ver}" rel="stylesheet" type="text/css">
    <title>评估查看</title>

</head>
<style>
    .border{
        border:1px solid #C5D0DC;
    }
    .left{
        width:5%;
        background-color: #F7F7F7;
        float: left;
    }
    .left .ch{
        margin: 0 auto;
        width: 60px;
        line-height: 30px;
        /*margin-top: 130px;*/
        margin-top: 40px;
        font-size: 18px
    }
    .divEcharts1{
        width: 50%;
        float: left;
    }
    .divEcharts3{
        width: 95%;
        float: left;
    }
    .divEcharts2{
        width: 45%;
        float: left;
    }
    .sName{
        width: 33%;
        float: left;
        text-align: center;
    }
    .echartsHeight{
        height: 300px;
    }
    .sNameHeight{
        height: 20px;
    }
    .sctitle{
        text-align: center;
        background-color: #F7F7F7;
        font-size: 19px;
        height: 34px;
    }
    .inputRdio{
        float: left;
        width: 30%;
        margin-left: 30px;
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
                            <i class="header-icon fa fa-file-archive-o"></i>
                            评估查看
                        </h5>
                    </li>
                </ul>
                <div class="align-right" style="float: right; padding-right: 5px;">
                    <button type="button" class="btn btn-xs btn-xs-ths btn-danger" @click="cancel">
                        <i class="ace-icon fa fa-reply"></i> 返回
                    </button>
                </div>
            </div>
        </div>
        <div class="main-content-inner" id="main-content-inner">
            <div class="page-content">
                <form id="mainForm" class="form-horizontal" role="form" id="formList" method="post">
                    <div class="row">
                        <label class="col-xs-1 control-label no-padding-right">
                            减排场景：
                        </label>
                        <div class="col-xs-3">
                            <div class="input-group" style="padding-top: 7px;">
                                <template v-for="item in cjList">
                                    <input   type="checkbox" v-model="item.info.checked" @change="initChecked">{{item.info.sceneName}}
                                </template>
                            </div>
                        </div>

                    </div>
                    <div style="margin-left:20px ;margin-top: 50px">
                        <ul id="tabSet" class="nav nav-tabs">
                            <li class="active" >
                                <a href="#zj-assess1" data-toggle="tab" @click="exchangeTab1" >污染物减排</a>
                            </li>
                            <li >
                                <a href="#zj-assess2" data-toggle="tab" @click="exchangeTab2" >污染物消减</a>
                            </li>
                            <li >
                                <a href="#zj-assess3" data-toggle="tab" @click="exchangeTabWrfb" >污染物分布</a>
                            </li>
                        </ul>

                    </div>
                    <div id="tableContent" class="tab-content" style="border:none">
                        <div id="zj-assess1" class="tab-pane fade in active " >
                            <template v-for="item in sceneDivList">
                                <div class="row border" >
                                    <div class="left echartsHeight"  >
                                        <div class="ch echartsHeight" >{{item.name}}</div>
                                    </div>
                                    <div :id="item.id1"  class="divEcharts1 echartsHeight"  >
                                    </div>
                                    <div :id="item.id2"  class="divEcharts2 echartsHeight"  >
                                    </div>
                                    <div  class="left sNameHeight"></div>
                                    <div  class="divEcharts1" >
                                        <div class="sName sNameHeight"  >黄色预警</div>
                                        <div class="sName sNameHeight"  >橙色预警</div>
                                        <div class="sName sNameHeight" >红色预警</div>
                                    </div>
                                    <div  class="divEcharts2" >
                                        <div  class="sName sNameHeight"  >黄色预警</div>
                                        <div  class="sName sNameHeight"  >橙色预警</div>
                                        <div  class="sName sNameHeight"  >红色预警</div>
                                    </div>
                                </div>
                            </template>
                        </div>
                        <div id="zj-assess2" class=" tab-pane fade ">
                            <template v-for="item in sceneDivList">
                                <div class="row border" >
                                    <div class="left echartsHeight"  >
                                        <div class="ch echartsHeight" >{{item.name}}</div>
                                    </div>
                                    <div :id="item.id3"  class="divEcharts3 echartsHeight"  >
                                    </div>
                                    <div  class="left sNameHeight"></div>
                                    <div  class="divEcharts3" >
                                        <div class="sName sNameHeight"  >黄色预警</div>
                                        <div class="sName sNameHeight"  >橙色预警</div>
                                        <div class="sName sNameHeight" >红色预警</div>
                                    </div>
                                </div>
                            </template>
                        </div>
                        <div id="zj-assess3" class=" tab-pane fade  ">
                            <div class="col-xs-8" id="r1_col2">
                                <div class="row" id="row_h">
                                    <a class="isButton goLeft play_c" data-oper="showPrev"></a>
                                    <a class="isButton goRight play_c" data-oper="showNext"></a>
                                    <%--  <a class="isButton col_btn_big" data-oper="big">
                                <img alt="放大" title="放大" src="${ctx}/assets/image/zoomin.gif">
                               </a> --%>
                                    <a class="isButton col_btn_small" data-oper="small">
                                        <img alt="缩小" title="缩小" src="${ctx}/assets/image/zoomout.gif">
                                    </a>
                                   <template v-for="item in sceneDivList">
                                        <div style="display: inline-block;width: 100%;height: 100%;">
                                            <div class="sctitle border" >{{date}}污染物分布变化</div>
                                            <div :id="item.id4+'1'" class="img_wrap border picHeight col-xs-6"  style="height: 400px"></div>
                                            <div :id="item.id4+'2'" class="img_wrap border picHeight col-xs-6"   style="height: 400px"></div>
                                        </div>
                                    </template>
                                    <%--<div id="sceneDiv24" style="height: 400px;"></div>
                                    <div id="sceneDiv14" style="height: 400px;"></div>--%>



                                    <div class="time_line play_c" id="time_line">
                                        <div class="time_line_wrap">
                                            <div class="progress_cache"></div>
                                            <div class="isButton progress_wrap" data-oper="goProgress">
                                                <span class="progress_tips"></span>
                                                <span class="progress_tips_arrow"></span>
                                                <span id="progress_bar" class="time_line_progress"></span>
                                            </div>
                                            <div class="time_line_btns">
                                                <span data-oper="showPrev" class="isButton my-btn showPrev"></span>
                                                <span data-oper="play" class="isButton my-btn play"></span>
                                                <span data-oper="showNext" class="isButton my-btn showNext"></span>
                                            </div>
                                        </div>
                                        <div class="progress_text"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xs-4 wrap">
                                <form class="form-horizontal" role="form" style="margin-top: 8px">

                                    <div class="form-group">
                                        <label class="col-xs-3 control-label no-padding-right" style="font-weight: normal">时间类型：</label>
                                        <div class="col-xs-9 radio-group">
                                            <div class="row">
                                                <div class="inputRdio" style="withd:300px;float: left;">
                                                    <label class="radio-inline">
                                                        <input type="radio" class="isButton radio"  value="day" data-oper="search" name="dateTypes" class="d0" id="leix1" checked="checked" />
                                                        <span style="font-weight: normal">日数据</span>
                                                    </label>
                                                </div>
                            <%--                    <div class="d" style="withd:300px;float: left;margin-left:50px;">
                                                    <label class="radio-inline">
                                                        <input type="radio" class=" isButton radio" value="hour" data-oper="search" name="dateTypes" class="d0" id="leix2" />
                                                        <span style="font-weight: normal">小时数据</span>
                                                    </label>
                                                </div>--%>

                                            </div>

                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-xs-3 control-label no-padding-right" style="font-weight: normal">指标：</label>
                                        <div class="col-xs-9 radio-group">
                                            <div class="row">
                                                <div class="inputRdio" style="withd:300px;float: left;">
                                                    <label class="radio-inline">
                                                        <input type="radio"  class="isButton radio" data-oper="search" name="types" class="d0" value="o3" checked="checked" />
                                                        <span style="font-weight: normal">O<sub>3</sub></span>
                                                    </label>
                                                </div>
                                                <div class="inputRdio" style="withd:300px;float: left;margin-left:50px;">
                                                    <label class="radio-inline">
                                                        <input type="radio"  class="isButton radio" data-oper="search" name="types" class="d0"  value="co"  />
                                                        <span style="font-weight: normal">CO</span>
                                                    </label>
                                                </div>

                                            </div>
                                            <div class="row">
                                                <div class="inputRdio" style="withd:300px;float: left;">
                                                    <label class="radio-inline">
                                                        <input type="radio"  class="isButton radio" data-oper="search" name="types" class="d0" value="pm25" />
                                                        <span style="font-weight: normal">PM<sub>2.5</sub></span>
                                                    </label>
                                                </div>
                                                <div class="inputRdio" style="withd:300px;float: left;margin-left:50px;">
                                                    <label class="radio-inline">
                                                        <input type="radio"  class="isButton radio" data-oper="search" name="types" class="d0"  value="so2"  />
                                                        <span style="font-weight: normal">SO<sub>2</sub></span>
                                                    </label>
                                                </div>

                                            </div>
                                            <div class="row">
                                                <div class="inputRdio" style="withd:300px;float: left;">
                                                    <label class="radio-inline">
                                                        <input type="radio"  class="isButton radio" data-oper="search" name="types" class="d0" value="pm10"  />
                                                        <span style="font-weight: normal">PM<sub>10</sub></span>
                                                    </label>
                                                </div>
                                                <div class="inputRdio" style="withd:300px;float: left;margin-left:50px;">
                                                    <label class="radio-inline">
                                                        <input type="radio"  class="isButton radio" data-oper="search" name="types" class="d0"  value="no2"  />
                                                        <span style="font-weight: normal">NO<sub>2</sub></span>
                                                    </label>
                                                </div>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="row play_c">
                                        <div class="item_img_list"></div>
                                    </div>
                                </form>
                            </div>
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
    var pkid = "${assessMain.pkid}";
    var date = "${assessMain.date}";
    var type = '<%=request.getParameter("type")%>';
</script>
<!-- Dialog 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/dialog-util.js?v=20221129015223"></script>
<!-- Ajax 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/ajax-util.js?v=20221129015223"></script>
<!-- 日期时间 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/date-time-util.js?v=20221129015223"></script>

<script type="text/javascript" src="${ctx}/assets/components/echarts/echarts.js?v=20221129015223"></script>
<img id="errorImg" src="${ctx}/mvc/forecastshow/no_img.jpg" style="display: none">
<script src="${ctx}/mvc/forecastshow/util/util-1.0.0.js?ver=${ver}"></script>
<script src="${ctx}/mvc/forecastshow/iv/imageviewer.js?ver=${ver}"></script>
<script src="${ctx}/mvc/forecastshow/player2.js?ver=${ver}"></script>
<script type="text/javascript" src="${ctx}/assets/custom/asses/js/asses_show.js?v=20221129015223"></script>

</body>
</html>
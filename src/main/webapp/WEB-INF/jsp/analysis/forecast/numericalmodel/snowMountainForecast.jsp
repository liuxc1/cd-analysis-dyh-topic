<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>雪山指数预报</title>
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp" %>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0, minimum-scale=1.0, maximum-scale=1.0">
    <link href="${ctx}/mvc/forecastshow/util/util.css?ver=${ver}" rel="stylesheet" type="text/css">
    <link href="${ctx}/mvc/forecastshow/iv/imageviewer.css?ver=${ver}" rel="stylesheet" type="text/css">
    <link href="${ctx}/mvc/forecastshow/myPlay.css?ver=${ver}" rel="stylesheet" type="text/css">
</head>

<body class="no-skin">
<div id="index-app" class="main-container" style="min-width: 1300px; height: auto;">
    <div id="container">
        <div class="main-content-inner fixed-page-header fixed-40">
            <div id="breadcrumbs" class="breadcrumbs">
                <ul class="breadcrumb">
                    <li class="active">
                        <h5 class="page-title">
                            <i class="menu-icon fa fa-image"></i>
                            雪山指数预报
                        </h5>
                    </li>
                </ul>
            </div>
        </div>
        <div class="main-content-inner padding-page-content" style="margin-top: 12px">
            <div class="main-content">
                <div class="col-xs-12">
                    <div class="row" id="row1">
                        <div class="col-xs-9" id="r1_col2">
                            <div class="row" id="row_h">
                                <a class="isButton goLeft play_c" data-oper="showPrev"></a>
                                <a class="isButton goRight play_c" data-oper="showNext"></a>
                                <a class="isButton col_btn_small" data-oper="small">
                                    <img alt="缩小" title="缩小" src="${ctx}/assets/image/zoomout.gif">
                                </a>
                                <div style="display: inline-block;width: 48%;height: 100%;">
                                    <div id="img_wrap12" class="img_wrap"></div>
                                </div>

                                <div style="display: inline-block;width: 48%;height: 100%;">
                                    <div id="img_wrap" class="img_wrap"></div>
                                </div>


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
                        <div class="col-xs-3 wrap" style="width: 400px">
                            <form class="form-horizontal" role="form" style="margin-top: 8px">
                                <div class="form-group">
                                    <label class="col-xs-3 control-label no-padding-right" style="font-weight: normal">起报时间：</label>
                                    <div class="col-xs-4 input-group" style="float:left;">
                                        <input type="text" id="dateTime" name="dateTime" class="form-control"
                                               placeholder="起报时间" value="${dateTime}" readonly>
                                        <span class="input-group-btn">
												<button id="dateTimeBtn" style="margin-left: -1px;" type="button"
                                                        class="btn btn-white btn-default">
													<i class="ace-icon fa fa-calendar"></i>
												</button>
											</span>
                                        <input id="table" type="hidden" value=""/>
                                    </div>
                                    <div class="col-xs-5">
                                        <button id="btn-search" type="button"
                                                class="btn btn-info btn-default-ths isButton " data-oper="search">
                                            <i class="ace-icon fa fa-search"></i>
                                            查询
                                        </button>
                                    </div>
                                </div>
                                <div class="row play_c">
                                    <div class="item_img_list"></div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                <div class="col-xs-12">
                    <div class="col-xs-6 form-group" style="text-align: left">
                        <div style="margin: 5px;font-size: 14px;font-family: 'Microsoft YaHei'">大雪塘方向-点位预报结果</div>
                        <img id="pt_dxt" style="height: 220px" src="" onerror="onError('pt_dxt')">
                    </div>
                    <div class="col-xs-6 form-group" style="text-align: left">
                        <div style="margin: 5px;font-size: 14px;font-family: 'Microsoft YaHei'">幺妹峰方向-点位预报结果</div>
                        <img id="pt_ymf" style="height: 220px" src="" onerror="onError('pt_ymf')">
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp" %>
<img id="errorImg" src="${ctx}/mvc/forecastshow/no_img.jpg" style="display: none">
<script type="text/javascript">
    const wrfImagePth = '${path}';
</script>
<script src="${ctx}/mvc/forecastshow/util/util-1.0.0.js?ver=${ver}"></script>
<script src="${ctx}/mvc/forecastshow/iv/imageviewer.js?ver=${ver}"></script>
<script src="${ctx}/mvc/forecastshow/player.js?ver=${ver}"></script>
<script type="text/javascript" src="${ctx}/assets/custom/analysis/forecast/numericalmodel/snowMountainForecast.js?v=20221129015223"></script>
</body>
</html>
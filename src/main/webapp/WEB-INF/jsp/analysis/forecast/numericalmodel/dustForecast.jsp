<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>沙尘预报</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
	<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp" %>
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0, minimum-scale=1.0, maximum-scale=1.0">
<link href="${ctx}/mvc/forecastshow/util/util.css?ver=${ver}" rel="stylesheet" type="text/css">
<link href="${ctx}/mvc/forecastshow/iv/imageviewer.css?ver=${ver}" rel="stylesheet" type="text/css">
<link href="${ctx}/mvc/forecastshow/myPlay.css?ver=${ver}" rel="stylesheet" type="text/css">
<style type="text/css">
input[type="text"] {
	border: 1px solid #d3d3d3;
	color: #4a4a4a;
	border-radius: 3px !important;
	padding: 5px 4px 6px;
	font-size: 14px;
	font-family: inherit;
	box-shadow: none !important;
	transition-duration: 0.1s;
	border-bottom-right-radius: 0px !important;
	border-top-right-radius: 0px !important;
}

 .timeType {
	 display: inline-block;
	 width: 80px;
	 height: 40px;
	 border: 4px solid #02A7F0;
	 font-size: 22px;
	 text-align: center;
	 margin-top: 20px;
	 overflow: hidden;
	 margin-left: 20%;
 }


input[readonly] {
	background: #FAFAFA !important;
	cursor: default;
}

label {
	font-weight: normal;
	font-size: 14px;
}

.btn-white.btn-default {
	border-color: #d3d3d3;
	color: #acacac !important;
}
.radio-inline, .checkbox-inline {
	padding-left: 20px;
}
</style>
</head>
<body>
	<div id="index-app" class="main-container" style="min-width: 1150px; height: auto">
		<div id="container">
			<div class="main-content-inner fixed-page-header fixed-40">
				<div id="breadcrumbs" class="breadcrumbs">
					<ul class="breadcrumb">
						<li class="active">
							<h5 class="page-title">
								<i class="menu-icon fa fa-sellsy"></i>
								沙尘预报
							</h5>
						</li>
					</ul>
				</div>
			</div>
			<div class="main-content-inner padding-page-content">
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
										<div id="img_wrap12" class="img_wrap" ></div>
									</div>

									<div style="display: inline-block;width: 48%;height: 100%;">
										<div id="img_wrap" class="img_wrap" ></div>
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
							<div class="col-xs-3 wrap" style="width: 400px;">
								<form class="form-horizontal" role="form" style="margin-top: 8px">
									<div class="form-group">
										<label class="col-xs-3 control-label no-padding-right" style="font-weight: normal">起报时间：</label>
										<div class="col-xs-6 input-group" style="float:left;">
											<input type="text" id="dateTime" name="dateTime" class="form-control" placeholder="起报时间" value="${dateTime}" readonly>
											<span class="input-group-btn">
												<button id="dateTimeBtn" style="margin-left: -1px;" type="button" class="btn btn-white btn-default">
													<i class="ace-icon fa fa-calendar"></i>
												</button>
											</span>
											<input id="table" type="hidden" value="" />
										</div>
									</div>
									<div class="form-group">
										<label class="col-xs-3 control-label no-padding-right" style="font-weight: normal">类型：</label>
										<div class="col-xs-9 radio-group">
											<div class="row">
												<div class="d" style="float: left;">
													<label class="radio-inline">
														<input type="radio" style="margin-top: -2px;" class="isButton radio" data-oper="search" name="dateType" class="d0" id="day" value="day" checked="checked" />
														<span style="font-weight: normal">日</span>
													</label>
												</div>
												<div class="d" style="float: left;margin-left:10px;">
													<label class="radio-inline">
														<input type="radio" style="margin-top: -2px;" class="isButton radio" data-oper="search" name="dateType" class="d0" id="hour" value="hour" />
														<span style="font-weight: normal">小时</span>
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
				</div>
			</div>
		</div>
	</div>
	<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
	<img id="errorImg" src="${ctx}/mvc/forecastshow/no_img.jpg" style="display: none">
	<script src="${ctx}/mvc/forecastshow/util/util-1.0.0.js?ver=${ver}"></script>
	<script src="${ctx}/mvc/forecastshow/iv/imageviewer.js?ver=${ver}"></script>
	<script src="${ctx}/mvc/forecastshow/player.js?ver=${ver}"></script>
	<!-- 日期时间 工具类 -->
	<script type="text/javascript" src="${ctx}/assets/custom/common/util/date-time-util.js"></script>
	<script src="${ctx}/assets/custom/analysis/forecast/numericalmodel/dustForecast.js"></script>
	<script type="text/javascript">
		const wrfImagePth = '${path}';
	</script>
</body>
</html>
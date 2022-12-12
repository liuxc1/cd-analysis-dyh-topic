<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>空间分布图</title>
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
								<i class="menu-icon fa fa-image"></i>
								空间分布图
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
										<div class="timeType">12时</div>
										<div id="img_wrap12" class="img_wrap" ></div>
									</div>

									<div style="display: inline-block;width: 48%;height: 100%;">
										<div class="timeType">0时</div>
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
							<div class="col-xs-3 wrap" style="width: 400px">
								<form class="form-horizontal" role="form" style="margin-top: 8px">
									<div class="form-group">
										<label class="col-xs-3 control-label no-padding-right" style="font-weight: normal">起报时间：</label>
										<div class="col-xs-4 input-group" style="float:left;">
											<input type="text" id="dateTime" name="dateTime" class="form-control" placeholder="起报时间" value="${dateTime}" readonly>
											<span class="input-group-btn">
												<button id="dateTimeBtn" style="margin-left: -1px;" type="button" class="btn btn-white btn-default">
													<i class="ace-icon fa fa-calendar"></i>
												</button>
											</span>
											<input id="table" type="hidden" value="" />
										</div>
										<div class="col-xs-5">
											<button id="btn-search" type="button" class="btn btn-info btn-default-ths isButton " data-oper="search" >
												<i class="ace-icon fa fa-search"></i>
												查询
											</button>
										</div>
									</div>

									<div class="form-group">
										<label class="col-xs-3 control-label no-padding-right" style="font-weight: normal">类型：</label>
										<div class="col-xs-9 radio-group">
											<div class="row">
												<div class="d" style="float: left;">
													<label class="radio-inline">
														<input type="radio" style="margin-top: -2px;" class="isButton radio" data-oper="search" name="chooseType" class="d0" id="type1" value="0" checked="checked"/>
														<span style="font-weight: normal">污染物</span>
													</label>
												</div>
												<div class="d" style="float: left;margin-left:10px;">
													<label class="radio-inline">
														<input type="radio" style="margin-top: -2px;" class="isButton radio" data-oper="search" name="chooseType" class="d0" id="type2" value="1"  />
														<span style="font-weight: normal">气象要素</span>
													</label>
												</div>
											</div>
										</div>
									</div>
									<div class="form-group" id="index_1">
										<label class="col-xs-3 control-label no-padding-right" style="font-weight: normal">指标：</label>
										<div class="col-xs-9 radio-group">
											<div class="row">
												<div class="d" style="float: left;">
													<label class="radio-inline">
														<input type="radio" style="margin-top: -2px;" class="isButton radio" data-oper="search" name="types" class="d0" id="leix1" value="pm25" checked="checked" />
														<span style="font-weight: normal">PM<sub>2.5</sub>日均</span>
													</label>
												</div>
												<div class="d" style="float: left;margin-left:10px;">
													<label class="radio-inline">
														<input type="radio" style="margin-top: -2px;" class="isButton radio" data-oper="search" name="types" class="d0" id="leix2" value="no2" />
														<span style="font-weight: normal">NO<sub>2</sub>日均</span>
													</label>
												</div>
												<div class="d" style="float: left;margin-left:10px;">
													<label class="radio-inline">
														<input type="radio" style="margin-top: -2px;" class="isButton radio" data-oper="search" name="types" class="d0" id="leix3" value="o3" />
														<span style="font-weight: normal">O<sub>3</sub>最大值</span>
													</label>
												</div>
											</div>
										</div>
									</div>
									<div class="form-group" id="index_2" style="display: none">
										<label class="col-xs-3 control-label no-padding-right" style="font-weight: normal">指标：</label>
										<div class="col-xs-9 radio-group">
											<div class="row">
												<div class="d" style="withd:300px;float: left;">
													<label class="radio-inline">
														<input type="radio" style="margin-top: -2px;" class="isButton radio"
															   data-oper="search" name="w_types" class="d0" id="rwd"
															   value="DTD" checked="checked"/>
														<span style="font-weight: normal">日最大温度</span>
													</label>
												</div>
												<div class="d" style="withd:300px;float: left;margin-left:50px;">
													<label class="radio-inline">
														<input type="radio" style="margin-top: -2px;" class="isButton radio"
															   data-oper="search" name="w_types" class="d0" id="rjs"
															   value="DT"/>
														<span style="font-weight: normal">日降水量</span>
													</label>
												</div>
											</div>
											<div class="row">
												<div class="d" style="withd:300px;float: left;">
													<label style="margin-left: 0px;" class="radio-inline">
														<input type="radio" style="margin-top: -2px;" class="isButton radio"
															   data-oper="search" name="w_types" class="d0" id="xfc"
															   value="HWF"/>
														<span style="font-weight: normal">小时风场</span>
													</label>
												</div>
												<div class="d" style="withd:300px;float: left;margin-left:64px;">
													<label class="radio-inline">
														<input type="radio" style="margin-top: -2px;" class="isButton radio"
															   data-oper="search" name="w_types" class="d0" id="xjs"
															   value="PPH"/>
														<span style="font-weight: normal">小时降水量</span>
													</label>
												</div>
											</div>
											<div class="row">
												<div class="d" style="withd:300px;float: left;">
													<label class="radio-inline">
														<input type="radio" style="margin-top: -2px;" class="isButton radio"
															   data-oper="search" name="w_types" class="d0" id="xy"
															   value="HC"/>
														<span style="font-weight: normal">小时云盖比</span>
													</label>
												</div>
												<div class="d" style="withd:300px;float: left;margin-left:50px;">
													<label class="radio-inline">
														<input type="radio" style="margin-top: -2px;" class="isButton radio"
															   data-oper="search" name="w_types" class="d0" id="xyhs"
															   value="HGCARC"/>
														<span style="font-weight: normal">小时地面云水含量</span>
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
	<script src="${ctx}/assets/custom/analysis/forecast/concentrationdistribution/concentrationdistribution_new.js?v=20221129015223"></script>
	<script type="text/javascript">
		var wrfImagePth = '${path}';
		var type = '<%=request.getParameter("type")%>';
	</script>

</body>
</html>
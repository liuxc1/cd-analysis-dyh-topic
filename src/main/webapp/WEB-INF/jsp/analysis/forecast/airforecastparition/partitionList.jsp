<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>分区预报</title>
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp" %>
    <!-- 分析平台-时间轴组件-样式文件 -->
    <link href="${ctx }/assets/custom/components/analysis/css/time-axis.css" rel="stylesheet"/>
    <!-- 分析平台-记录列表组件-样式文件 -->
    <link href="${ctx }/assets/custom/components/analysis/css/record.css" rel="stylesheet"/>
    <style type="text/css">
        .no-data {
            font-size: 16px;
        }

        .span-btn {
            color: #428bca;
            cursor: pointer;
        }

        .record-div {
            /* height: 35px; */
            line-height: 35px;
        }
        .time-axis .checked{
            background-color: #438eb9;
            color: #fff !important;
        }
    </style>
</head>
<body class="no-skin">
<div class="main-container" id="main-container" v-cloak>
    <div class="main-content-inner fixed-page-header fixed-40">
        <div id="breadcrumbs" class="breadcrumbs">
            <ul class="breadcrumb">
                <li class="active">
                    <h5 class="page-title">
                        <i class="header-icon fa fa-bullhorn"></i>
                        分区预报
                    </h5>
                </li>
            </ul>
            <div class="align-right" style="float: right; padding-right: 5px;" v-if="!isHidden">
                <button type="button" class="btn btn-xs btn-xs-ths" @click="goAdd">
                    <i class="ace-icon fa fa-plus"></i> 添加
                </button>
                <!-- <button type="button" class="btn btn-xs btn-xs-ths" @click="downloadFile" v-if="pdfUrl || imgUrl">
                    <i class="ace-icon fa fa-download"></i> 下载
                </button> -->
            </div>
        </div>
    </div>
    <div class="main-content-inner padding-page-content">
        <div class="main-content">
            <div class="page-content">
                <form class="form-horizontal" role="form">
                    <div class="space-4"></div>
                    <div class="col-sm-12 no-padding">
                        <div class="col-sm-3 no-padding">
                            <label class="col-sm-4 control-label">填报月份：</label>
                            <div class="col-sm-8 input-group">
                                <input type="text" id="wdate-picker" v-model="yearMonth" @click="wdatePicker"
                                       class="form-control" placeholder="请选择填报月份" readonly>
                                <span class="input-group-btn">
										<button type="button" class="btn btn-white btn-default" @click="wdatePicker">
											<i class="ace-icon fa fa-calendar"></i>
										</button>
									</span>
                            </div>
                        </div>
                        <div class="col-sm-9"><time-axis ref="timeAxis"
                                       :current="yearMonth"
                                       :prev="timeAxis.prev"
                                       :next="timeAxis.next"
                                       :list="timeAxis.list"
                                       @prevclick="prevClick"
                                       @nextclick="nextClick"
                                       @listclick="timeAxisListClick"
                            ></time-axis></div>
                    </div>
                </form>
                <div class="col-sm-12 record-div">
                    <div class="col-sm-9 no-padding">
                        <record ref="record" :records="records" @recordclick="recordClick"></record>
                    </div>
                    <div class="col-sm-3 align-right no-padding">
                        <button type="button" class="btn btn-xs btn-xs-ths" @click="uploadClick"
                                v-if="record && record.flowState == 'TEMP'">
                            <i class="ace-icon fa fa-upload"></i> 提交
                        </button>
                        <button type="button" class="btn btn-xs btn-xs-ths" @click="goEdit"
                                v-if="record && record.flowState == 'TEMP'">
                            <i class="ace-icon fa fa-edit"></i> 编辑
                        </button>
                        <button type="button" class="btn btn-xs btn-xs-ths btn-danger" @click="deleteData"
                                v-if="record && record.flowState == 'TEMP'">
                            <i class="ace-icon fa fa-trash-o"></i> 删除
                        </button>
                    </div>
                    <div class="space-4"></div>
                </div>
                <div class="col-sm-12 no-padding" v-if="record">
                    <div class="space-4"></div>
                    <table class="table table-bordered">
                        <tbody>
                        <!-- 								<tr> -->
                        <!-- 									<th class="text-right" width="20%"> -->
                        <!-- 										填报日期： -->
                        <!-- 									</th> -->
                        <!-- 									<td width="80%"> -->
                        <!-- 										{{record.createTime}} -->
                        <!-- 									</td> -->
                        <!-- 								</tr> -->
                        <tr>
                            <th class="text-right" width="20%">
                                重要提示：
                            </th>
                            <td width="80%">
                                {{record.importantHints==null||record.importantHints==""?"--":record.importantHints}}
                            </td>
                        </tr>
                        <!-- 								<tr> -->
                        <!-- 									<th class="text-right"> -->
                        <!-- 										状态： -->
                        <!-- 									</th> -->
                        <!-- 									<td> -->
                        <!-- 										{{record.flowState == 'UPLOAD' ? '已提交' : '暂存'}} -->
                        <!-- 									</td> -->
                        <!-- 								</tr> -->
                        </tbody>
                    </table>
                </div>

                <div style="margin-top: 80px">
                    <ul id="tabSet" class="nav nav-tabs">
                        <li id="tableId" class="active">
                            <a href="#data-table" data-toggle="tab">数据表及其报告</a>
                        </li>
                        <li id="picId">
                            <a href="#color-pic" data-toggle="tab" @click="switchingWindow()">填色图</a>
                        </li>
                    </ul>
                </div>
                <div id="tableContent" class="tab-content" style="border: none;">
                    <%--数据表及其报告标签页--%>
                    <div id="data-table" class="tab-pane fade in active">
                        <div class="col-sm-12 no-padding">
                            <div class="space-4"></div>
                            <ul class="nav nav-tabs" role="tablist"
                                style="width: 90%; margin-left: 5%">
                                <!-- 										<li role="presentation" class="active"><a href="#tab_1" -->
                                <!-- 											aria-controls="tab_1" role="tab" data-toggle="tab">四大区域24h预报</a> -->
                                <!-- 										</li> -->
                                <!-- 										<li role="presentation"><a href="#tab_3" -->
                                <!-- 											aria-controls="tab_3" role="tab" data-toggle="tab">区县3天预报</a> -->
                                <!-- 										</li> -->
                            </ul>
                            <div class="tab-content" style="width: 100%; margin-left: 0%">
                                <!-- 										<div role="tabpanel" class="tab-pane active" id="tab_1"> -->
                                <!-- 											<table class="table table-bordered" -->
                                <!-- 												style="width: 95%; margin-left: 3%"> -->
                                <!-- 												<colgroup> -->
                                <!-- 													<col width="30%" /> -->
                                <!-- 													<col width="35%" /> -->
                                <!-- 													<col width="35%" /> -->
                                <!-- 												</colgroup> -->
                                <!-- 												<thead> -->
                                <!-- 													<tr> -->
                                <!-- 														<th class="center">区域名称</th> -->
                                <!-- 														<th class="center">空气质量等级</th> -->
                                <!-- 														<th class="text-center">首要污染物</th> -->
                                <!-- 													</tr> -->
                                <!-- 												</thead> -->
                                <!-- 												<tr v-for="(area, areaindex) in form24h" -->
                                <!-- 													v-if="area.TYPECODE==0"> -->
                                <!-- 													<td style="vertical-align: inherit !important;">{{area.REGIONNAME}}</td> -->
                                <!-- 													<td>{{area.AQI_LEVEL}}</td> -->
                                <!-- 													<td class="text-center" v-html="getPrimPolluteHtml(area.PULLNAME)"></td> -->
                                <!-- 												</tr> -->
                                <!-- 											</table> -->
                                <!-- 										</div> -->
                                <div role="tabpanel" class="tab-pane active" id="tab_3">
                                    <table id="modeltable" class="table table-bordered"
                                           style="width: 100%; margin-left: 0%">
                                        <colgroup>
                                            <col width="10%"/>
                                            <col width="15%"/>
                                            <col width="15%"/>
                                            <col width="15%"/>
                                            <col width="15%"/>
                                            <col width="15%"/>
                                            <col width="15%"/>
                                        </colgroup>
                                        <thead>
                                        <tr>
                                            <th class="center" rowspan="2">区县</th>
                                            <template v-if="form3d!=null&&form3d.length>1">
                                                <th class="center" colspan="2"
                                                    style="border-bottom: 1px solid #D5D5D5">
                                                    {{form3d[0].FORECAST_DATE1}}
                                                </th>
                                                <th class="center" colspan="2"
                                                    style="border-bottom: 1px solid #D5D5D5">
                                                    {{form3d[0].FORECAST_DATE2}}
                                                </th>
                                                <th class="center" colspan="2"
                                                    style="border-bottom: 1px solid #D5D5D5">
                                                    {{form3d[0].FORECAST_DATE3}}
                                                </th>
                                            </template>
                                        </tr>
                                        <tr>
                                            <th class="center">AQI范围</th>
                                            <th class="center">首要污染物</th>
                                            <th class="center">AQI范围</th>
                                            <th class="center">首要污染物</th>
                                            <th class="center">AQI范围</th>
                                            <th class="center">首要污染物</th>
                                        </tr>
                                        </thead>
                                        <tr v-if="form3d!=null&&form3d.length>1"
                                            v-for="(datas3d, datas3dindex) in form3d"
                                            :key="datas3dindex">
                                            <td style="vertical-align: middle;" class="text-center">
                                                {{datas3d.REGIONNAME }}
                                            </td>
                                            <td class="text-center">{{datas3d.AQI_START1+'~'+datas3d.AQI_END1}}</td>
                                            <td class="text-center" v-html="getPrimPolluteHtml(datas3d.PULLNAME1)"></td>
                                            <td class="text-center">{{datas3d.AQI_START2+'~'+datas3d.AQI_END2}}</td>
                                            <td class="text-center" v-html="getPrimPolluteHtml(datas3d.PULLNAME2)"></td>
                                            <td class="text-center">{{datas3d.AQI_START3+'~'+datas3d.AQI_END3}}</td>
                                            <td class="text-center" v-html="getPrimPolluteHtml(datas3d.PULLNAME3)"></td>
                                        </tr>
                                        <tr v-if="form3d==null || form3d.length<1">
                                            <td class="text-center" colspan="7">暂无数据</td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-12">
                            <div class="space-4"></div>
                            <record ref="fileRecord" :records="fileRecords" @recordclick="fileRecordClick"></record>
                            <div class="align-right" style="padding-right: 5px;">
                            <span @click="openFullScreen" class="span-btn" v-if="pdfUrl"
                                  style="margin-right: 20px">
                                <i class="ace-icon fa fa-arrows-alt"></i> 全屏
                            </span>
                                <span @click="downloadFile" class="span-btn" v-if="pdfUrl">
								<i class="ace-icon fa fa-download"></i> 下载
							</span>
                                <span @click="downloadZipFile" class="span-btn" v-if="zipFileId"
                                      style="margin-left:10px;">
								<i class="ace-icon fa fa-download"></i> zip下载
							</span>
                            </div>
                        </div>
                        <div class="col-sm-12 no-padding" v-if="pdfUrl">
                            <iframe :src="pdfUrl" class="col-sm-12 no-padding no-border" height="600"></iframe>
                        </div>
<%--                        <div class="col-sm-12 center no-data" v-if="noDataText">
                            {{noDataText}}
                        </div>--%>
                    </div>
                    <div id="color-pic" class=" tab-pane fade ">
                        <!--  <iframe :src="urls.partitionColrPicUrl" frameborder="0" width="100%" height="100%"></iframe>  -->
                        <div class="row">
                            <div class="col-xs-12">
                                <label class="col-sm-1 control-label no-padding-right "
                                       style="margin-top: 14px; text-align: right;">预报第几天：</label>
                                <div class="col-sm-3 control-label no-padding-right ">
                                    <ul class="time-axis no-margin-left" >
                                        <li v-for="item in ybdList" @click="stepTo(item.value)" :class="item.select">{{item.value}}</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <div id="mainContainer1">
                            <div id="cdMap" style="width: 100px;height: 300px"></div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
        <!--/.main-content-inner-->
    </div>
    <!-- /.main-content -->
</div>

<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp" %>
<script>
    //是否隐藏
    var isHidden= '<%=request.getParameter("isHidden")%>'
</script>
<!-- vue插件 -->
<!--[if lte IE 9]>
	<script type="text/javascript" src="${ctx}/assets/components/babel-polyfill/polyfill.min.js"></script>
	<![endif]-->
<!-- vue插件 -->
<script type="text/javascript" src="${ctx}/assets/components/vue/vue.min.js"></script>
<!-- echarts插件 -->
<script type="text/javascript" src="${ctx}/assets/components/echarts/echarts.min.js"></script>
<!-- Dialog 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/dialog-util.js"></script>
<!-- Ajax 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/ajax-util.js"></script>
<!-- 日期时间 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/date-time-util.js"></script>
<!-- 文件下载 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/file-download-util.js"></script>
<!-- 分析平台-时间轴组件-逻辑js -->
<script type="text/javascript" src="${ctx}/assets/custom/components/analysis/js/time-axis.js"></script>
<!-- 分析平台-时间轴组件-模板 -->
<script id="vue-template-time-axis" type="text/x-template">
    <%@ include file="/WEB-INF/jsp/components/analysis/time-axis.jsp" %>
</script>
<!-- 分析平台-记录列表组件-逻辑js -->
<script type="text/javascript" src="${ctx}/assets/custom/components/analysis/js/record.js"></script>
<!-- 分析平台-记录列表组件-模板 -->
<script id="vue-template-record" type="text/x-template">
    <%@ include file="/WEB-INF/jsp/components/analysis/record.jsp" %>
</script>
<!-- 自定义js（逻辑js） -->
<script type="text/javascript" src="${ctx}/assets/custom/analysis/forecast/airforecastparition/cdMap.js"></script>
<script type="text/javascript" src="${ctx}/assets/custom/analysis/forecast/airforecastparition/partitionList.js"></script>
</body>
</html>
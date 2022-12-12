<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>城市预报</title>
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp" %>
    <link rel="stylesheet" href="${ctx}/assets/components/bootstrap-select/dist/css/bootstrap-select.min.css"/>
    <style type="text/css">
        table {
            border-spacing: 0;
            border-collapse: collapse;
        }

        td, th, caption {
            padding: 0;
        }

        .w-table {
            width: 100%;
        }

        .w-table td, .w-table th {
            border: 1px solid rgb(221, 221, 221);
            height: 35px;
            text-align: center;
        }

        .w-table thead th, .w-table thead td, .w-table tbody th {
            background-color: #F2F2F2;
        }

        .w-table tr.even td {
            background-color: rgb(241, 241, 241);
        }

        .w-table a {
            color: rgb(42, 151, 253);
        }

        .w-editable {
            padding-right: 15px;
            line-height: 18px;
            position: relative;
        }

        .w-input {
            line-height: 28px;
            box-sizing: content-box;
            height: 28px;
            width: 140px;
            padding: 0 2px 0 6px !important;
            border: 1px solid rgb(151, 151, 151);
            font-size: 12px;
        }

        .w-input.aqi-min, .w-input.aqi-max {
            width: 60px;
            text-align: center;
        }

        #forecastValueTbody td {
            padding: 8px;
            height: 35px;
        }

        .textCenter {
            text-align: center;
        }

        .weather_trend_edit span {
            display: inline-block;
            width: 95%;
            height: 35px;
            line-height: 35px;
            text-align: left;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
        }

        .dropdown-toggle, .dropdown-toggle:hover, .dropdown-toggle:focus, .open > .btn.dropdown-toggle {
            background-color: #ffffff !important;
            border: 1px solid #D5D5D5;
            color: #858585 !important;
            border-width: 1px !important;
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
                        <h5 v-if="isAdd==1" class="page-title">
                            <i class="header-icon fa fa-plus"></i>
                            城市预报-添加
                        </h5>
                        <h5 v-else class="page-title">
                            <i class="header-icon fa fa-edit"></i>
                            城市预报-编辑
                        </h5>

                    </li>
                </ul>
                <div class="btn-toolbar pull-right" role="toolbar" style="padding-top: 7px;">

                    <button type="button" class="btn btn-xs btn-xs-ths" @click="saveData('UPLOAD');">
                        <i class="ace-icon fa fa-upload"></i>
                        </i>
                        提交
                    </button>
                    <button type="button" class="btn btn-xs btn-xs-ths" @click="saveData('TEMP');">
                        <i class="ace-icon fa fa-save"></i>
                        暂存
                    </button>
                    <%-- 						<c:if test="${isShowReturn ==null }"> --%>
                    <button type="button" class="btn btn-xs btn-xs-ths btn-danger" @click="cancel()">
                        <i class="ace-icon fa fa-reply"></i>
                        返回
                    </button>
                    <%-- 						</c:if> --%>
                </div>
            </div>
        </div>
        <div class="main-content-inner">
            <div class="page-content">
                <form id="mainForm" class="form-horizontal" role="form" id="formList" method="post">
                    <input type="hidden" name="reportId" value="${reportId}" id="reportIdInput">
                    <div class="row">
                        <div class="col-xs-12 form-group">
                            <label class="col-xs-1 control-label no-padding-right">填报日期：</label>
                            <div class="col-xs-2">
                                <div class="col-xs-4 no-padding-right no-padding-left" style="width: 140px;">

                                    <div v-if="isAdd==1" class="input-group" id="divDate" @click="wdatePicker">
                                        <input type="text" id="txtDateStart" class="form-control"
                                               v-model="resultData.FORECAST_TIME" name="datetime" readonly="readonly">
                                        <span class="input-group-btn">
												<button type="button" class="btn btn-white btn-default"
                                                        id="btnDateStart" readonly="readonly">
													<i class="ace-icon fa fa-calendar"></i>
												</button>
											</span>
                                    </div>
                                    <div v-else>
                                        <label class="col-xs-12 control-label" style="text-align: left;">{{resultData.FORECAST_TIME}}</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <hr class="no-margin">

                    <div class="row">
                        <div class="col-xs-12 text-center"
                             style="margin-top: 10px; padding-left: 5%; padding-right: 5%;">
                            <div class="text-left">未来3天城市预报解析意见：</div>
                            <textarea maxlength="1000" class="form-control"
                                      data-validation-engine="validate[maxSize[1000]]"
                                      v-model="resultData.FORECAST_THREE_CITY" placeholder="请输入未来3天城市预报解析意见，最多1000个字符"
                                      maxLength="1000" name="city_opinion_day3"
                                      style="width: 100%; height: 150px; margin: 5px auto; resize: none;"></textarea>
                        </div>
                        <div class="col-xs-12 text-center"
                             style="margin-top: 10px; padding-left: 5%; padding-right: 5%;">
                            <div class="text-left">未来3天国控站点预报解析意见：</div>
                            <textarea maxlength="1000" class="form-control "
                                      data-validation-engine="validate[maxSize[1000]]"
                                      v-model="resultData.FORECAST_THREE" placeholder="请输入未来3天国控站点预报解析意见，最多1000个字符"
                                      name="country_opinion_day3"
                                      style="width: 100%; height: 150px; margin: 5px auto; resize: none;"></textarea>
                        </div>
                        <div class="col-xs-12 text-center"
                             style="margin-top: 10px; padding-left: 5%; padding-right: 5%;">
                            <div class="text-left">未来7天城市预报解析意见：</div>
                            <textarea maxlength="1000" class="form-control"
                                      data-validation-engine="validate[maxSize[1000]]"
                                      v-model="resultData.FORECAST_SEVEN_CITY" placeholder="请输入未来7天城市预报解析意见，最多1000个字符"
                                      name="city_opinion"
                                      style="width: 100%; height: 150px; margin: 5px auto; resize: none;"></textarea>
                        </div>
                        <div class="col-xs-12 text-center"
                             style="margin-top: 10px; padding-left: 5%; padding-right: 5%;">
                            <div class="text-left">未来7天国控站点预报解析意见：</div>
                            <textarea maxlength="1000" class="form-control"
                                      data-validation-engine="validate[maxSize[1000]]"
                                      v-model="resultData.FORECAST_SEVEN" placeholder="请输入未来7天国控站点预报解析意见，最多1000个字符"
                                      name="country_opinion"
                                      style="width: 100%; height: 150px; margin: 5px auto; resize: none;"></textarea>
                        </div>
                        <div class="col-xs-12 text-center"
                             style="margin-top: 10px; padding-left: 5%; padding-right: 5%;">
                            <div class="text-left">3天重要提示：</div>
                            <textarea maxlength="1000" class="form-control "
                                      data-validation-engine="validate[maxSize[1000]]" name="important_hints"
                                      placeholder="请输入3天重要提示信息，最多1000个字符" v-model="resultData.HINT"
                                      style="width: 100%; height: 150px; margin: 5px auto; resize: none;"></textarea>
                        </div>
                        <div class="col-xs-12 text-center"
                             style="margin-top: 10px; padding-left: 5%; padding-right: 5%;">
                            <div class="text-left">7天重要提示：</div>
                            <textarea maxlength="1000" class="form-control "
                                      data-validation-engine="validate[maxSize[1000]]" name="important_hints_day7"
                                      placeholder="请输入7天重要提示信息，最多1000个字符" v-model="resultData.HINT_7DAY"
                                      style="width: 100%; height: 150px; margin: 5px auto; resize: none;"></textarea>
                        </div>
                        <div class="col-xs-12 text-center"
                             style="margin-top: 10px; padding-left: 5%; padding-right: 5%;">
                            <div class="text-left">
                                <label>
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    落款：
                                </label>
                                <input maxlength="500" class="form-control"
                                       data-validation-engine="validate[required,maxSize[500]]" name="inscribe"
                                       v-model="resultData.INSCRIBE" style="width: 100%;" placeholder="请输入落款，最多100个字符"/>
                            </div>
                        </div>
                        <div class="col-xs-12 text-center"
                             style="margin-top: 10px; padding-left: 5%; padding-right: 5%;">
                            <table id="listTable" class="w-table" style="table-layout: fixed;">
                                <thead>
                                <tr>
                                    <th rowspan="2">预报日期</th>
                                    <template v-if="showFlag != 1">
                                        <th colspan="2">PM<sub>2.5</sub></th>
                                        <th colspan="2">O<sub>3</sub></th>
                                    </template>
                                    <th rowspan="2">AQI范围</th>
                                    <th rowspan="2" style="width: 160px">级别</th>
                                    <th rowspan="2">
                                        首要污染物
                                    </th>
                                    <th rowspan="2">控制目标</th>
                                    <th rowspan="2">
                                        <select class="form-control col-xs-12"
                                                v-model="resultData.weatherConditionsType"
                                                style="background-color: #F2F2F2;">
                                            <option v-for="item in weatherConditionsTypeArr" :value="item.code">
                                                {{item.name}}
                                            </option>
                                        </select>
                                    </th>
                                </tr>
                                <tr>
                                    <template v-if="showFlag != 1">
                                        <th>浓度(μg/m³)</th>
                                        <th>IAQI</th>
                                        <th>浓度(μg/m³)</th>
                                        <th>IAQI</th>
                                    </template>
                                </tr>
                                </thead>
                                <tbody id="forecastValueTbody">
                                <tr v-for="(item,index) in sevenDaysTable">
                                    <td class="td_date">{{item.RESULT_TIME}}</td>
                                    <template v-if="showFlag != 1">
                                        <td class="edit pm25_edit">
                                            <div>
                                                <div class="text-center" style="display:inline-block;width: 35%">
                                                    <input type="text" class="pm25Median textCenter form-control"
                                                           @change="changePm25OrO3(index,'PM25')"
                                                           v-model="item.PM25_MEDIAN"
                                                           data-validation-engine="validate[required,min[0],max[470],custom[integer]]">
                                                </div>
                                                <div class="text-center" style="display:inline-block;width: 61%">
                                                    <input type="text" class="pm25Median textCenter form-control"
                                                           readonly="readonly"
                                                           :value="(item.PM25_MIN!=null?item.PM25_MIN:'')+'~'+(item.PM25_MAX!=null?item.PM25_MAX:'')">
                                                </div>
                                            </div>
                                        </td>
                                        <td class="edit pm25_edit">
                                            <div>
                                                <div class="text-center" style="display:inline-block;width: 35%">
                                                    <input type="text" class="pm25Median textCenter form-control"
                                                           readonly="readonly"
                                                           :value="item.PM25_IAQI!=null?item.PM25_IAQI:''">
                                                </div>
                                                <div class="text-center" style="display:inline-block;width: 61%">
                                                    <input type="text" class="pm25Median textCenter form-control"
                                                           readonly="readonly"
                                                           :value="(item.PM25_MIN_IAQI!=null?item.PM25_MIN_IAQI:'')+'~'+(item.PM25_MAX_IAQI!=null?item.PM25_MAX_IAQI:'')">
                                                </div>
                                            </div>
                                        </td>
                                        <td class="edit o3_edit">
                                            <div class="">
                                                <div class="text-center" style="display:inline-block;width: 35%">
                                                    <input type="text" class="o3Median textCenter form-control"
                                                           @change="changePm25OrO3(index,'O3')" v-model="item.O3_MEDIAN"
                                                           data-validation-engine="validate[required,min[0],max[470],custom[integer]]">
                                                </div>
                                                <div class="text-center" style="display:inline-block;width: 61%">
                                                    <input type="text" class="o3Median textCenter form-control"
                                                           readonly="readonly"
                                                           :value="(item.O3_MIN!=null?item.O3_MIN:'')+'~'+(item.O3_MAX!=null?item.O3_MAX:'')">
                                                </div>
                                            </div>
                                        </td>
                                        <td class="edit pm25_edit">
                                            <div>
                                                <div class="text-center" style="display:inline-block;width: 35%">
                                                    <input type="text" class="o3Median textCenter form-control"
                                                           readonly="readonly"
                                                           :value="item.O3_IAQI!=null?item.O3_IAQI:''">
                                                </div>
                                                <div class="text-center" style="display:inline-block;width: 61%">
                                                    <input type="text" class="o3Median textCenter form-control"
                                                           readonly="readonly"
                                                           :value="(item.O3_MIN_IAQI!=null?item.O3_MIN_IAQI:'')+'~'+(item.O3_MAX_IAQI!=null?item.O3_MAX_IAQI:'')">
                                                </div>
                                            </div>
                                        </td>
                                    </template>
                                    <td class="edit aqi_edit">
                                        <div>
                                            <input type="text" class="aqiMedian textCenter" @change="changeAqi(index)"
                                                   :readonly="showFlag == 1||(showFlag != 1&&(item.PRIM_POLLUTE!='PM2.5' && item.PRIM_POLLUTE!='O3')) ? false:true"
                                                   v-model="item.AQI_MEDIAN"
                                                   data-validation-engine="validate[required,min[15],max[470],custom[integer]]"
                                                   style="width: 70%;margin-bottom: 5px;">
                                        </div>
                                        <div>
                                            <label>{{item.AQI_MIN}} </label>~<label>{{item.AQI_MAX}} </label>
                                        </div>
                                    </td>
                                    <td class="align-center level_last">
                                        <div>{{item.AQI_LEVEL}}</div>
                                    </td>

                                    <td class="edit primpollute_last">
                                        <select class="col-xs-12 form-control" title="请选择" v-model="item.PRIM_POLLUTE"
                                                @change=" changePollute(index)">
                                            <option value="">--无--</option>
                                            <option v-for="itemsm in primpollutes" :value="itemsm.code">
                                                {{itemsm.name}}
                                            </option>
                                        </select>
                                    </td>
                                    <td class="edit control_target_edit">
                                        <select class="form-control col-xs-12" v-model="item.CONTROL_TARGET">
                                            <option value="">--无--</option>
                                            <option>力保</option>
                                            <option>力争</option>
                                            <option>削峰</option>
                                        </select>
                                    </td>
                                    <td class="edit weather_trend_edit">
                                        <div class="col-xs-12">
                                            <select class="form-control col-xs-12" v-model="item.WEATHER_LEVEL"
                                                    style="margin:0px 0px -34px 0px">
                                                <option v-for="itemsm in levelNameArr" :value="itemsm">
                                                    {{itemsm}}
                                                </option>
                                            </select>
                                            <input type="text" class="col-xs-10" placeholder="请输入气象扩散条件"
                                                   data-validation-engine="validate[required,maxSize[10]]"
                                                   style="border-bottom:0px ;border-right:0px"
                                                   v-model="item.WEATHER_LEVEL"/>
                                        </div>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="col-xs-12" style="margin-top: 10px; padding-left: 5%; padding-right: 5%;">
                            <div class="text-left" style="margin-bottom:5px;">图片：</div>
                            <div is="file-upload-table" key="imageUploadTable" ref="imageUploadTable"
                                 :ascription-id="reportId"
                                 ascription-type="UPLOAD_IMAGE"
                                 allow-file-types="gif,jpg,png"
                                 :min-file-number="0"
                                 :max-file-number="10">
                            </div>
                        </div>
                        <div class="col-xs-12" style="margin-top: 10px; padding-left: 5%; padding-right: 5%;">
                            <div class="text-left" style="margin-bottom:5px;">附件：</div>
                            <div is="file-upload-table" key="fileUploadTable" ref="fileUploadTable"
                                 :ascription-id="reportId"
                                 ascription-type="UPLOAD"
                                 allow-file-types="doc,docx,pdf"
                                 is-transform="Y"
                                 file-source="GENERATE"
                                 :min-file-number="0"
                                 :max-file-number="10"></div>
                        </div>
                    </div>
                    <hr>
                    <%@ include file="/WEB-INF/jsp/analysis/forecast/airforecastcity/messDialog.jsp" %>
                </form>
            </div>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp" %>
<script type="text/javascript">
    // 地址，必须
    var ctx = "${ctx}";
    var isRead = "${isRead}";
    var isAdd = "${isAdd}";
    var reportId = "${reportId}"
    var showFlag = "${showFlag}"
</script>
<script type="text/javascript" src="${ctx}/assets/components/bootstrap-select/dist/js/bootstrap-select.min.js"></script>
<script type="text/javascript"
        src="${ctx}/assets/components/bootstrap-select/dist/js/i18n/defaults-zh_CN.min.js"></script>
<!-- vue插件 -->
<script type="text/javascript" src="${ctx}/assets/components/vue/vue.js"></script>
<!-- 引入组件库elementui -->
<script src="${ctx }/assets/components/element-ui/js/index.js"></script>
<!-- Dialog 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/dialog-util.js"></script>
<!-- Ajax 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/ajax-util.js"></script>
<!-- 日期时间 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/date-time-util.js"></script>
<!-- 分析平台-文件上传表格组件-模板 -->
<%@ include file="/WEB-INF/jsp/components/common/file-upload-table.jsp" %>

<script type="text/javascript"
        src="${ctx}/assets/custom/analysis/forecast/airforecastcity/assembleData.js"></script>
<script type="text/javascript"
        src="${ctx}/assets/custom/analysis/forecast/airforecastcity/cityForecastIndex.js"></script>
</body>
</html>
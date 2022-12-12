<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>快报分析报告</title>
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp" %>
    <link href="${ctx }/assets/custom/components/analysis/css/file-upload-table.css" rel="stylesheet"/>
</head>
<body class="no-skin">
<div class="main-container" id="main-container" v-cloak>
    <!-- 报告ID -->
    <input type="hidden" id="report-id" value="${reportId}"/>
    <!-- 归属类型 -->
    <input type="hidden" id="ascription-type" value="${ascriptionType}"/>
    <!-- 报告频率 -->
    <input type="hidden" id="report-rate" value="${reportRate}"/>
    <div class="main-content-inner fixed-page-header fixed-40">
        <div id="breadcrumbs" class="breadcrumbs">
            <ul class="breadcrumb">
                <li class="active">
                    <h5 class="page-title">
                        <i class="header-icon fa fa-plus"></i>
                        快报分析报告-添加/编辑
                    </h5>
                </li>
            </ul>
            <div class="align-right" style="float: right; padding-right: 5px;">
                <button type="button" class="btn btn-xs btn-xs-ths" @click="saveData('UPLOAD')">
                    <i class="ace-icon fa fa-upload"></i> 提交
                </button>
                <button type="button" class="btn btn-xs btn-xs-ths" @click="saveData('TEMP')">
                    <i class="ace-icon fa fa-save"></i> 暂存
                </button>
                <button type="button" class="btn btn-xs btn-xs-ths btn-danger" @click="cancel">
                    <i class="ace-icon fa fa-reply"></i> 取消
                </button>
            </div>
        </div>
    </div>
    <div class="main-content-inner padding-page-content">
        <div class="main-content">
            <div class="page-content">
                <form id="mainForm" class="form-horizontal" role="form" method="post">
                    <div class="space-4"></div>
                    <table class="table table-bordered" style="table-layout: fixed;">
                        <tbody>
                        <tr>
                            <th class="text-right" width="10%">
                                <label class="col-sm-12 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    填报时间：
                                </label>
                            </th>
                            <td width="80%">
                                <div class="col-sm-2 no-padding input-group " @click="wdatePicker1">
                                    <input type="text" id="txtDate" v-model="report.reportTime" class="form-control"
                                           placeholder="请选择填报日期" readonly>
                                    <span class="input-group-btn">
                                        <button type="button" class="btn btn-white btn-default">
                                            <i class="ace-icon fa fa-calendar"></i>
                                        </button>
                                    </span>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right" width="10%">
                                <label class="col-sm-12 control-label no-padding-right">
                                    重要提示：
                                </label>
                            </th>
                            <td width="80%">
                                <div class="col-sm-12 no-padding">
                                    <textarea v-model="report.reportTip" class="form-control" placeholder="请输入重要提示"
                                              rows="3" cols="10" data-validation-engine="validate[maxSize[1000]]"
                                              maxlength="1000"></textarea>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    快报期数：
                                </label>
                            </th>
                            <td>
                                {{report.currentYear}}年<input v-model="report.reportBatch" type="text"
                                                              data-validation-engine="validate[required,custom[integer],maxSize[3]]">期
                            </td>
                        </tr>

                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    昨日污染情况：
                                </label>
                            </th>
                            <td>
                                <input type="text" v-model="report.pollutionMoon" placeholder="请输入内容"/>
                                月
                                <input type="text" v-model="report.pollutionDay" placeholder="请输入内容"/>
                                日，边界层高度在
                                <input type="text" v-model="report.pollutionBoundaryLayerHeightInterval"
                                       placeholder="请输入内容"/>
                                米之间，平均风速
                                <input type="text" v-model="report.pollutionWindSpeed" placeholder="请输入内容"/>
                                米每秒，扩散条件
                                <input type="text" v-model="report.pollutionDiffusionConditions" placeholder="请输入内容"/>
                                。激光雷达反演显示浮尘传输和近地面扬尘排放影响持续，PM₂.₅/PM₁₀ 平均比值低至
                                <input type="text" v-model="report.pollutionAverageRatio" placeholder="请输入内容"/>
                                。 此外，由于光化学反应前期 VOC 浓度及活性偏大，午后辐射强，臭氧生成速率快，出现
                                <input type="text" v-model="report.pollutionConsecutiveHours" placeholder="请输入内容"/>
                                小时臭氧超标（峰值浓度达
                                <input type="text" v-model="report.pollutionPeakConcentration" placeholder="请输入内容"/>
                                µg/m³），当天空气质量为
                                <input type="text" v-model="report.pollutionLevel" placeholder="请输入内容"/>。
                                <br>
                                <a @click="generatePollution()">生成</a>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    昨日污染情况生成内容：
                                </label>
                            </th>
                            <td>
                                <textarea class="col-sm-12" v-model="report.generateContentOne"
                                          data-validation-engine="validate[required, maxSize[5000]]"/>
                                {{report.generateContentOne}}
                                </textarea>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    今日污染情况：
                                </label>
                            </th>
                            <td>
                                <input type="text" v-model="report.nextDayPollutionDay" placeholder="请输入内容"/>
                                日上午
                                <input type="text" v-model="report.nextDayPollutionWeatherConditions"
                                       placeholder="请输入内容"/>
                                ，边界层高度在
                                <input type="text" v-model="report.nextDayPollutionBoundaryLayerHeight"
                                       placeholder="请输入内容"/>
                                米左右波动变化，风速较
                                <input type="text" v-model="report.nextDayPollutionWindSpeed" placeholder="请输入内容"/>
                                ， 扩散条件
                                <input type="text" v-model="report.nextDayPollutionDiffusionConditions"
                                       placeholder="请输入内容"/>
                                ，高空仍有轻微浮尘传输，同时， 二次颗粒物转化速率
                                <input type="text" v-model="report.nextDayPollutionRate" placeholder="请输入内容"/>
                                ， PM₂.₅ 累积升高出现
                                <input type="text" v-model="report.nextDayPollutionPm25ExcessiveConcentration"
                                       placeholder="请输入内容"/>
                                小时浓度超标；臭氧前体物NO₂ 平均浓度达
                                <input type="text" v-model="report.nextDayPollutionNo2AverageConcentration"
                                       placeholder="请输入内容"/>
                                μg/m³，较前日同期{{report.riseAndFallFlat}}
                                <input type="text" v-model="report.nextDayPollutionDecreaseRatio" placeholder="请输入内容"/>
                                ， 0-10时光化学主站 VOC 数据由于仪器校准，数据无效，暂不加入本日分析。光化学南站 VOC 浓度和 OFP 分别为
                                <input type="text" v-model="report.nextDayPollutionVocConcentration"
                                       placeholder="请输入内容"/>
                                μg/m³、
                                <input type="text" v-model="report.nextDayPollutionOfpConcentration"
                                       placeholder="请输入内容"/>
                                μg/m³， 环比下降
                                <input type="text" v-model="report.nextDayPollutionVocDecreaseRatio"
                                       placeholder="请输入内容"/>
                                、
                                <input type="text" v-model="report.nextDayPollutionOfpDecreaseRatio"
                                       placeholder="请输入内容"/>
                                ， OFP 贡献前五物种以
                                <input type="text" v-model="report.nextDayPollutionOfpSpecies" placeholder="请输入内容"/>
                                为主，指示
                                <input type="text" v-model="report.nextDayPollutionOfpSource" placeholder="请输入内容"/>
                                影响显著。今日 NO₂、O1D、甲醛和 HONO 的光解速率和辐射强度较前日明显
                                <input type="text" v-model="report.nextDayPollutionCompare" placeholder="请输入内容"/>
                                ， 截止 11 时，PM₂.₅ 和 O₃ 浓度分别为
                                <input type="text" v-model="report.nextDayPollutionPm25Concentration"
                                       placeholder="请输入内容"/>
                                µg/m³、和
                                <input type="text" v-model="report.nextDayPollutionO3Concentration"
                                       placeholder="请输入内容"/>
                                µg/m³，空气质量为
                                <input type="text" v-model="report.nextDayPollutionLevel" placeholder="请输入内容"/>
                                （AQI
                                <input type="text" v-model="report.nextDayPollutionAqi" placeholder="请输入内容"/>
                                ），首要污染物为
                                <input type="text" v-model="report.nextDayPollutionPrimaryPollutant"
                                       placeholder="请输入内容"/>。
                                <br>
                                <a @click="generateNextDayPollution()">生成</a>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    今日污染情况生成内容
                                </label>
                            </th>
                            <td>
                                <textarea style="height: 70px" class="col-sm-12" v-model="report.generateContentTwo"
                                          data-validation-engine="validate[required, maxSize[5000]]">
{{report.generateContentTwo}}
                                </textarea>
                            </td>
                        </tr>

                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    图 1 气溶胶激光雷达反演退偏比（上）、混合层高度、消光系数（中）和臭氧雷达（下）：
                                </label>
                            </th>
                            <td>
                                <li class="one-line">
                                    <span>
                                <image-upload-table
                                        key="preImageUploadTable"
                                        ref="preImageUploadTable"
                                        :ascription-id="report.reportId"
                                        :ascription-type="report.ascriptionType"
                                        :min-file-number="1"
                                        :max-file-number="3"
                                        :is-download="false"></image-upload-table>
                                    </span>
                                </li>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    图 2 主要污染物浓度时间序列：
                                </label>
                            </th>
                            <td>
                                <li class="one-line">
                                    <span>
                                   <image-upload-table
                                           key="preImageUploadTable"
                                           ref="preImageUploadTable"
                                           :ascription-id="report.reportId"
                                           :ascription-type="report.ascriptionTypeTwo"
                                           :min-file-number="1"
                                           :max-file-number="3"
                                           :is-download="false"></image-upload-table>
                    </span>
                                </li>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    图 3 主城区（上）、光化学南站（下）VOC 浓度（PAMS）及占比时间序列变化趋势：
                                </label>
                            </th>
                            <td>
                                <li class="one-line">
                                    <span>
                               <image-upload-table
                                       key="preImageUploadTable"
                                       ref="preImageUploadTable"
                                       :ascription-id="report.reportId"
                                       :ascription-type="report.ascriptionTypeThree"
                                       :min-file-number="1"
                                       :max-file-number="3"
                                       :is-download="false"></image-upload-table>
                    </span>
                                </li>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    图 4 颗粒物组分重构及占比：
                                </label>
                            </th>
                            <td>
                                <li class="one-line">
                                    <span>
                    <image-upload-table
                            key="preImageUploadTable"
                            ref="preImageUploadTable"
                            :ascription-id="report.reportId"
                            :ascription-type="report.ascriptionTypeFour"
                            :min-file-number="1"
                            :max-file-number="3"
                            :is-download="false"></image-upload-table>
                    </span>
                                </li>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    图 5 主要光解过程时间序列：
                                </label>
                            </th>
                            <td>
                                <li class="one-line">
                                    <span>
                     <image-upload-table
                             key="preImageUploadTable"
                             ref="preImageUploadTable"
                             :ascription-id="report.reportId"
                             :ascription-type="report.ascriptionTypeFive"
                             :min-file-number="1"
                             :max-file-number="3"
                             :is-download="false"></image-upload-table>
                    </span>
                                </li>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </form>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    // 地址，必须
    var ctx = "${ctx}";
    var reportId = "${reportId}"
</script>
<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp" %>
<!-- vue插件 -->
<script type="text/javascript" src="${ctx}/assets/components/vue/vue.js"></script>
<!-- Dialog 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/dialog-util.js"></script>
<!-- Ajax 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/ajax-util.js"></script>
<!-- 日期时间 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/date-time-util.js"></script>
<!-- 图片上传器 -->
<%@ include file="/WEB-INF/jsp/components/common/image-upload-table.jsp" %>
<!-- 自定义js（逻辑js） -->

<script type="text/javascript" src="${ctx}/assets/custom/analysis/analysisreport/day/expressListEdit.js"></script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>冬季快报</title>
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp" %>
    <link href="${ctx }/assets/custom/components/analysis/css/file-upload-table.css?v=20221129015223" rel="stylesheet"/>
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
                        冬季快报-添加/编辑
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
                                    填报月份：
                                </label>
                            </th>
                            <td width="80%">
                                <div class="col-sm-2 input-group" @click="wdatePicker">
                                    <input type="text" id="wdate-picker" v-model="yearMonthDayHour" class="form-control"
                                           placeholder="请选择填报月份" readonly>
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
                                    污染过程：
                                </label>
                            </th>
                            <td v-model="report.editContentOne">
                                <input type="text" v-model="report.pollutionTheDayBefore" placeholder="请输入日期"/>
                                日早晨
                                <input type="text" v-model="report.pollutionWeatherConditions"
                                       placeholder="请填写（有雾/有雨/天晴）"/>
                                ，
                                <input type="text" v-model="report.pollutionInfluencingFactors"
                                       placeholder="请填写（湿度/温度/风速）"/>
                                <input type="text" v-model="report.pollutionInfluencingFactorsIncreaseOrDecrease"
                                       placeholder="请填写（增大/减小）"/>
                                ，边界层高度
                                <input type="text" v-model="report.pollutionInBoundary" placeholder="请填写（上升/下降）"/>
                                至
                                <input type="text" v-model="report.pollutionInBoundaryLayer" placeholder="请填写数值"/>
                                米左右，污染累积速度
                                <input type="text" v-model="report.pollutionAccumulationSpeed"
                                       placeholder="请填写内容（加快/减慢）"/>
                                ，国控均值出现连续
                                <input type="text" v-model="report.pollutionConsecutiveHours" placeholder="请填写连续超标小时数"/>
                                小时
                                <input type="text" v-model="report.pollutionLevel" placeholder="请填写污染程度"/>
                                ，午后天空状况
                                <input type="text" v-model="report.pollutionAfternoonSkyConditions"
                                       placeholder="请填写天气情况"/>
                                ，湿度
                                <input type="text" v-model="report.pollutionHumidity" placeholder="请填写湿度情况（降低/升高）"/>
                                边界层逐渐
                                <input type="text" v-model="report.pollutionBoundaryLayerCondition"
                                       placeholder="请填写边界层情况"/>
                                ，垂直扩散条件
                                <input type="text" v-model="report.pollutionVerticalDiffusionConditions"
                                       placeholder="请填写垂直扩散条件情况"/>
                                ，空气质量逐渐改善至
                                <input type="text" v-model="report.pollutionAirQualityLevel" placeholder="请填写空气质量等级"/>
                                ，夜间边界层
                                <input type="text" v-model="report.pollutionNocturnalBoundaryLayer"
                                       placeholder="请输入夜间边界层情况"/>
                                ，空气质量于
                                <input type="text" v-model="report.pollutionNightAirQualityTime"
                                       placeholder="请输入空气质量时间"/>
                                时又转为
                                <input type="text" v-model="report.pollutionNightAirQualityLevel"
                                       placeholder="请填写空气质量等级"/>
                                并维持，全天空气质量为
                                <input type="text" v-model="report.pollutionAirQualityThroughoutTheDay"
                                       placeholder="请填写空气质量等级"/>
                                ,AQI为
                                <input type="text" v-model="report.pollutantAqi" placeholder="请输入AQI数值"/>
                                ，首要污染物为
                                <input type="text" v-model="report.pollutantPrimary"
                                       placeholder="请填写(PM2.5、PM10、SO2、NO2、O3、CO)"/>
                                。全市
                                <input type="text" v-model="report.pollutantDistrict" placeholder="请填写区县名"/>
                                为
                                <input type="text" v-model="report.pollutionCountyPollutionLevel"
                                       placeholder="请填写空气质量等级"/>
                                ，其余均为
                                <input type="text" v-model="report.pollutionLevelOfOtherCounties"
                                       placeholder="请填写空气质量等级"/>
                                ；
                                <input type="text" v-model="report.pollutionCondition" placeholder="请填写区域污染情况概述"/>
                                。
                                <input type="text" v-model="report.pollutionThatDay" placeholder="请输入日期"/>
                                日早晨出现
                                <input type="text" v-model="report.pollutionInversion" placeholder="请填写逆温温度"/>
                                强逆温，边界层持续下压，湿度较大，污染累积加快，空气质量于
                                <input type="text" v-model="report.pollutionConversionTime" placeholder="请输入时间"/>
                                时再次转为
                                <input type="text" v-model="report.pollutionThatDayGrade" placeholder="请填写空气质量等级"/>
                                ，国控站点中，
                                <input type="text" v-model="report.pollutionSiteSituation" placeholder="请填写各个国控站点空气质量情况"
                                       style="width: 500px"/>
                                <input type="text" v-model="report.pollutionCountySituation" placeholder="请填写各区县空气质量情况"
                                       style="width: 500px">
                                <input type="text" v-model="report.pollutionRegional" placeholder="请填写区域污染情况概述"/>
                                。
                                <br><br>
                                <a href="#" @click="generateOne()">生成</a>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    污染过程生成内容：
                                </label>
                            </th>
                            <td>
                                <textarea style="height: 100px" class="col-sm-12" v-model="report.generateContentOne"
                                          data-validation-engine="validate[required, maxSize[5000]]">
                                {{report.generateContentOne}}
                                </textarea>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    大气科研实验室数据分析：
                                </label>
                            </th>
                            <td>
                                <textarea style="height: 100px" class="col-sm-12" v-model="report.generateContentTwo"
                                          data-validation-engine="validate[required, maxSize[5000]]">
                                {{report.generateContentTwo}}
                                                                </textarea>
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
    var ctx = "${ctx}";
    var reportId = "${reportId}"
</script>
<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp" %>
<!-- vue插件 -->
<script type="text/javascript" src="${ctx}/assets/components/vue/vue.min.js?v=20221129015223"></script>
<!-- 引入组件库elementui -->
<script src="${ctx }/assets/components/element-ui/js/index.js?v=20221129015223"></script>
<!-- Dialog 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/dialog-util.js?v=20221129015223"></script>
<!-- Ajax 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/ajax-util.js?v=20221129015223"></script>
<!-- 日期时间 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/date-time-util.js?v=20221129015223"></script>
<!-- 文件下载 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/file-download-util.js?v=20221129015223"></script>
<!-- 图片上传器 -->
<%@ include file="/WEB-INF/jsp/components/common/image-upload-table.jsp" %>
<!-- 自定义js（逻辑js） -->

<script type="text/javascript"
        src="${ctx}/assets/custom/analysis/analysisreport/winterexpress/winterExpresEdit.js?v=20221129015223"></script>
</body>
</html>
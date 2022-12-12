<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>月报分析</title>
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
    <!--报告时间-->
    <input type="hidden" id="report-time" value="${reportTime}"/>
    <div class="main-content-inner fixed-page-header fixed-40">
        <div id="breadcrumbs" class="breadcrumbs">
            <ul class="breadcrumb">
                <li class="active">
                    <h5 class="page-title">
                        <i class="header-icon fa fa-edit"></i>
                        月报分析-添加/编辑
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
                                    月报期数：
                                </label>
                            </th>
                            <td>
                                {{report.defaultYear}}年<input placeholder="请输入内容" v-model="report.reportBatch"
                                                              type="text"
                                                              data-validation-engine="validate[required,custom[integer],maxSize[3]]">期
                            </td>
                        </tr>

                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    气环境科研分析报告：
                                </label>
                            </th>
                            <td>
                                {{report.month}}月优良天数
                                <input placeholder="请输入内容" type="text" v-model="report.excellentandGood"/>
                                天，优
                                <input placeholder="请输入内容" type="text" v-model="report.excellent"/>
                                天，良
                                <input placeholder="请输入内容" type="text" v-model="report.good"/>
                                天，优良天数比例
                                <input placeholder="请输入内容" type="text" v-model="report.correctRate"/>
                                ；污染天数
                                <input placeholder="请输入内容" type="text" v-model="report.contaminationDays"/>
                                天，轻度污染
                                <input placeholder="请输入内容" type="text" v-model="report.lightPollution"/>
                                天，中度污染
                                <input placeholder="请输入内容" type="text" v-model="report.moderatelyPolluted"/>
                                天，重度污染
                                <input placeholder="请输入内容" type="text" v-model="report.heavyPollution"/>
                                天，首要污染物均为
                                <input placeholder="请输入内容" type="text" v-model="report.primaryPollutant"/>
                                。主要污染物PM₁₀、PM₂.₅、NO₂、SO₂、O₃ 日最大 8 小时第 90 百分位数和CO 日均值第 95 百分位数分别为
                                <input placeholder="请输入内容" type="text" v-model="report.pm10"/>
                                μg/m³、
                                <input placeholder="请输入内容" type="text" v-model="report.pm25"/>
                                μg/m³、
                                <input placeholder="请输入内容" type="text" v-model="report.no2"/>
                                μg/m³、
                                <input placeholder="请输入内容" type="text" v-model="report.so2"/>
                                μg/m³、
                                <input placeholder="请输入内容" type="text" v-model="report.o3"/>
                                μg/m³ 和
                                <input placeholder="请输入内容" type="text" v-model="report.co"/>
                                mg/m³，与去年同期相比，PM₁₀
                                <input placeholder="请输入内容" type="text" v-model="report.pm10RiseOrDecline"/>
                                <input placeholder="请输入内容" type="text" v-model="report.pm10Percentage"/>
                                ，PM₂.₅
                                <input placeholder="请输入内容" type="text" v-model="report.pm25RiseOrDecline"/>
                                <input placeholder="请输入内容" type="text" v-model="report.pm25Percentage"/>
                                ，NO₂
                                <input placeholder="请输入内容" type="text" v-model="report.no2RiseOrDecline"/>
                                <input placeholder="请输入内容" type="text" v-model="report.no2Percentage"/>
                                ，SO₂
                                <input placeholder="请输入内容" type="text" v-model="report.so2RiseOrDecline"/>
                                <input placeholder="请输入内容" type="text" v-model="report.so2Percentage"/>
                                ，O₃
                                <input placeholder="请输入内容" type="text" v-model="report.o38RiseOrDecline"/>
                                <input placeholder="请输入内容" type="text" v-model="report.o38Percentage"/>
                                ，CO
                                <input placeholder="请输入内容" type="text" v-model="report.coRiseOrDecline"/>
                                <input placeholder="请输入内容" type="text" v-model="report.coPercentage"/>
                                。
                            </td>
                        </tr>

                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    实验室观测数据质量分析：
                                </label>
                            </th>
                            <td>
                                {{report.defaultYear}}年{{report.month}}月，大气科研分析实验室在线监测系统整体运行
                                <input placeholder="请输入内容" type="text" v-model="report.qualityState"/>
                                ，除设备配件更换、故障维修以及数据校准致数据 有所缺失外，仪器设备数据有效率在
                                <input placeholder="请输入内容" type="text" v-model="report.qualityPercentage"/>
                                以上。
                                <br>
                                <a @click="generateContentQuality()">生成</a>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    实验室观测数据质量分析生成内容：
                                </label>
                            </th>
                            <td>
                                <textarea class="col-sm-12" v-model="report.generateContentQuality"
                                          data-validation-engine="validate[required, maxSize[5000]]"/>
                                {{report.generateContentQuality}}
                                </textarea>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    污染过程分析：
                                </label>
                            </th>
                            <td>
                                {{report.month}}月
                                <input placeholder="请输入内容" type="text" v-model="report.analysisTimeLimit"/>
                                日，出现了今年
                                <input placeholder="请输入内容" type="text" v-model="report.analysisSeasons"/>
                                季最长的一次污染过程也是近两年唯一出现的颗粒物重度污染的过程，持续性静稳天气叠加本地排放，污染物浓度持续升高，其中
                                <input placeholder="请输入内容" type="text" v-model="report.analysisGoodSky"/>
                                日为高位
                                <input placeholder="请输入内容" type="text" v-model="report.analysisExcellent"/>
                                ，
                                <input placeholder="请输入内容" type="text"
                                       v-model="report.analysisLightPollutionTimeRange"/>
                                日为
                                <input placeholder="请输入内容" type="text" v-model="report.analysisDaysWithLightPollution"/>
                                天
                                <input placeholder="请输入内容" type="text" v-model="report.analysisLightPollution"/>
                                ，
                                <input placeholder="请输入内容" type="text"
                                       v-model="report.analysisModeratePollutionTimeRange"/>
                                日为
                                <input placeholder="请输入内容" type="text" v-model="report.analysisModeratelyPolluted"/>
                                ，
                                <input placeholder="请输入内容" type="text"
                                       v-model="report.analysisSeverePollutionTimeRange"/>
                                日为
                                <input placeholder="请输入内容" type="text" v-model="report.analysisHeavyPollution"/>
                                。
                                <input placeholder="请输入内容" type="text" v-model="report.analysisContaminationEndTime"/>
                                日，冷空气入境，扩散条件好转空气质量改善为良，污染过程结束。
                                <br>
                                <a @click="generateContentAnalysis()">生成</a>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    污染过程分析生成内容：
                                </label>
                            </th>
                            <td>
                                <textarea style="height: 70px" class="col-sm-12"
                                          v-model="report.generateContentAnalysis"
                                          data-validation-engine="validate[required, maxSize[5000]]">
{{report.generateContentAnalysis}}
                                </textarea>
                            </td>
                        </tr>

                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    静稳高湿加快二次组分转化进一步推高颗粒物浓度：
                                </label>
                            </th>
                            <td>
                                <input placeholder="请输入内容" type="text" v-model="report.concentrationWeatherCondition"/>
                                ，是本次污染物累积上升并达
                                <input placeholder="请输入内容" type="text" v-model="report.concentrationPollutionLevel"/>
                                的主要外因。尤其是过程中后期（
                                <input placeholder="请输入内容" type="text" v-model="report.concentrationLateTimeRange"/>
                                日），边界层高度整体偏低，其中
                                <input placeholder="请输入内容" type="text" v-model="report.concentrationEarlyTimeRange"/>
                                日边界层昼夜差异消失且连续
                                <input placeholder="请输入内容" type="text" v-model="report.concentrationContinuousTime"/>
                                个小时在
                                <input placeholder="请输入内容" type="text" v-model="report.concentrationIndex"/>
                                m以下，
                                <input placeholder="请输入内容" type="text" v-model="report.concentrationReason"/>
                                ，扩散条件明显弱于今年 以往过程，随着污染累积，空气质量由
                                <input placeholder="请输入内容" type="text" v-model="report.concentrationPollution"/>
                                上升至
                                <input placeholder="请输入内容" type="text" v-model="report.concentrationPollutionPlus"/>
                                。过程期间，NOx、SO₂浓度保持在较高水平，且二次组分转化明显加快，NOR和SOR呈上升趋势，最高达
                                <input placeholder="请输入内容" type="text" v-model="report.concentrationNor"/>
                                、
                                <input placeholder="请输入内容" type="text" v-model="report.concentrationSor"/>
                                ； 硝酸根、硫酸根及铵根等占比在
                                <input placeholder="请输入内容" type="text" v-model="report.concentrationPercentage"/>
                                左右，是颗粒物浓度保持高位并逐日升高的主要贡献组分。
                                <br>
                                <a @click="generateConcentration()">生成</a>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    静稳高湿加快二次组分转化进一步推高颗粒物浓度生成内容：
                                </label>
                            </th>
                            <td>
                                <textarea style="height: 70px" class="col-sm-12"
                                          v-model="report.generateContentConcentration"
                                          data-validation-engine="validate[required, maxSize[5000]]">
{{report.generateContentConcentration}}
                                </textarea>
                            </td>
                        </tr>

                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    排放体量偏大，以移动源与溶剂源影响为主：
                                </label>
                            </th>
                            <td>
                                在不利气象控制下，污染排放持续累积，其中与机动排放相关得污染物累积尤其明显，其中NO平均浓度达
                                <input placeholder="请输入内容" type="text" v-model="report.solventNo"/>
                                µg/m³，较污染前上升
                                <input placeholder="请输入内容" type="text" v-model="report.solventNoRise"/>
                                ，VOCₛ平均浓度达
                                <input placeholder="请输入内容" type="text" v-model="report.solventVocs"/>
                                µg/m³， 较污染前上升
                                <input placeholder="请输入内容" type="text" v-model="report.solventVocsRise"/>
                                ，尤其是VOC中
                                <input placeholder="请输入内容" type="text" v-model="report.solventVoc"/>
                                等上升最为明显，结合T/B（甲苯 /苯）比值结果（见图7）判断，污染时段以
                                <input placeholder="请输入内容" type="text" v-model="report.solventCauseOfImpactOne"/>
                                与
                                <input placeholder="请输入内容" type="text" v-model="report.solventCauseOfImpactTwo"/>
                                共同影响为主。此外，SO₂的整体浓度也较污染前上涨
                                <input placeholder="请输入内容" type="text" v-model="report.solventSo2RisePercentage"/>
                                ，颗粒物中
                                <input placeholder="请输入内容" type="text" v-model="report.solventElement"/>
                                出现小时浓度及占比偏高情况，周边或存在
                                <input placeholder="请输入内容" type="text" v-model="report.solventInfluence"/>
                                排放影响。可见，整个过程除气象外因影响外， 本地较大排放的影响也不容忽视。
                                <br>
                                <a @click="generateSolvent()">生成</a>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    排放体量偏大，以移动源与溶剂源影响为主生成内容：
                                </label>
                            </th>
                            <td>
                                <textarea style="height: 70px" class="col-sm-12" v-model="report.generateContentSolvent"
                                          data-validation-engine="validate[required, maxSize[5000]]">
{{report.generateContentSolvent}}
                                </textarea>
                            </td>
                        </tr>


                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    小结：
                                </label>
                            </th>
                            <td>
                                小结：本月
                                <input placeholder="请输入内容" type="text" v-model="report.summaryTimeLimit"/>
                                日间，我市出现
                                <input placeholder="请输入内容" type="text" v-model="report.summarySeason"/>
                                季以来最长的一次污染过程，也出现了近两年以来第一次颗粒物重度污染天。静稳高湿的不利天气条件，尤其是极低的边界层高度，是本次污染的主要外因，由于本地大气污染物排放体量大，强度
                                高，一旦出现静稳高湿等气象条件不利，出现中度及以上污染的风险将非常高。
                                <br>
                                <a @click="generateSummary()">生成</a>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    小结生成内容：
                                </label>
                            </th>
                            <td>
                                <textarea style="height: 70px" class="col-sm-12" v-model="report.generateContentSummary"
                                          data-validation-engine="validate[required, maxSize[5000]]">
{{report.generateContentSummary}}
                                </textarea>
                            </td>
                        </tr>


                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    日气溶胶激光雷达反演混合层高度、消光系数（上）和退偏比（下）图：
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
                                    日气象因素日均变化趋势图：
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
                                    PM₂.₅、PM₁₀ 以及 PM₂.₅/PM₁₀ 时间序列变化图：
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
                                    日实验室 PM₂.₅ 组分重构浓度（上）及占比（下）时间序列变化趋势图：
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
                                    日氮氧化物及二氧化硫浓度时间序列变化趋势图：
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

                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    日实验室氮转换率（NOR）和硫转化率（SOR）变化趋势图：
                                </label>
                            </th>
                            <td>
                                <li class="one-line">
                                    <span>
                     <image-upload-table
                             key="preImageUploadTable"
                             ref="preImageUploadTable"
                             :ascription-id="report.reportId"
                             :ascription-type="report.ascriptionTypeSix"
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
                                    日 T/B 时间序列图：
                                </label>
                            </th>
                            <td>
                                <li class="one-line">
                                    <span>
                     <image-upload-table
                             key="preImageUploadTable"
                             ref="preImageUploadTable"
                             :ascription-id="report.reportId"
                             :ascription-type="report.ascriptionTypeSeven"
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

<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp" %>
<!-- vue插件 -->
<script type="text/javascript" src="${ctx}/assets/components/vue/vue.js?v=20221129015223"></script>
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
        src="${ctx}/assets/custom/analysis/analysisreport/monthlyAnalysis/monthlyAnalysisListEdit.js?v=20221129015223"></script>
</body>
</html>
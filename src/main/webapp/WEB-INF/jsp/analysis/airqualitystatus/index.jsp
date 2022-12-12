<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>空气质量现状</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge">
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp" %>
    <link href="${ctx}/assets/components/element-ui/css/index.css" rel="stylesheet" type="text/css">
    <style type="text/css">
        .option-type {
            width: 90px;
            height: 50px;
        }

        .title-style {
            background: #F2F2F2;
            height: 40px;
            font-size: 20px;
            line-height: 40px;
        }

        .left_content {
            background: #F2F2F2;
        }

        .day-next {
            display: inline-block;
            position: absolute;
            right: 5px;
            bottom: 1px;
        }

        .el-btn {
            background: transparent;
            border: 0px;
        }
    </style>
</head>
<body>
<div id="vue-app" class="main-container" style="min-width: 1150px; height: auto">
    <div id="container">
        <div class="main-content-inner fixed-page-header fixed-40">
            <div id="breadcrumbs" class="breadcrumbs">
                <ul class="breadcrumb">
                    <li class="active">
                        <h5 class="page-title">
                            <i class="menu-icon fa fa-image"></i>
                            空气质量现状
                        </h5>
                    </li>
                </ul>
            </div>
        </div>
        <div class="main-content-inner padding-page-content">
            <div class="main-content">
                <div class="col-xs-12">
                    <div class="row" id="row1">
                        <div class="col-xs-10 left_content" id="r1_col2">
                            <div class="row" id="row_h">
                                <div style="margin-top:10px;">
                                    <div class="col-xs-6" style="margin-bottom: 10px;height: 600px">
                                        <img :key="urlMap.one" :src="urlMap.one" alt=""
                                             onerror="this.src='${ctx}/mvc/forecastshow/no_img.jpg';this.onerror=null;"
                                             width=100% height=100%/>
                                        <div style="display:inline-block;position: absolute;top: 10px;right: 15px">
                                            <el-button class="el-icon-download el-btn"
                                                       @click="download(urlMap.one)"></el-button>
                                        </div>
                                    </div>
                                    <div class="col-xs-6" style="margin-bottom: 10px;height: 600px">
                                        <img :key="urlMap.two" :src="urlMap.two" alt=""
                                             onerror="this.src='${ctx}/mvc/forecastshow/no_img.jpg';this.onerror=null;"
                                             width=100% height=100%/>
                                        <div style="display:inline-block;position: absolute;top: 10px;right: 15px">
                                            <el-button class="el-icon-download el-btn"
                                                       @click="download(urlMap.two)"></el-button>
                                        </div>
                                    </div>
                                </div>
                                <div style="margin-top:10px;">
                                    <div class="col-xs-6" style="margin-bottom: 10px;height: 600px">
                                        <img :key="urlMap.three" :src="urlMap.three" alt=""
                                             onerror="this.src='${ctx}/mvc/forecastshow/no_img.jpg';this.onerror=null;"
                                             width=100% height=100%/>
                                        <div style="display:inline-block;position: absolute;top: 10px;right: 15px">
                                            <el-button class="el-icon-download el-btn"
                                                       @click="download(urlMap.three)"></el-button>
                                        </div>
                                    </div>
                                    <div class="col-xs-6" style="margin-bottom: 10px;height: 600px">
                                        <img :key="urlMap.four" :src="urlMap.four" alt=""
                                             onerror="this.src='${ctx}/mvc/forecastshow/no_img.jpg';this.onerror=null;"
                                             width=100% height=100%/>
                                        <div style="display:inline-block;position: absolute;top: 10px;right: 15px">
                                            <el-button class="el-icon-download el-btn"
                                                       @click="download(urlMap.four)"></el-button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-xs-2" style="">
                            <form class="form-horizontal" role="form" style="margin-left: 10px">
                                <div class="form-group title-style" style="font-weight: bold;position: relative;">时间选择
                                    <div class="day-next">
                                        <el-button-group>
                                            <el-tooltip class="item" effect="dark"
                                                        :content="dateType=='hour'?'上一小时':'前一天'" placement="bottom">
                                                <el-button icon="el-icon-back" size="mini" round
                                                           @click="prevTime()"></el-button>
                                            </el-tooltip>
                                            <el-tooltip class="item" effect="dark"
                                                        :content="dateType=='hour'?'下一小时':'后一天'" placement="bottom">
                                                <el-button icon="el-icon-right" size="mini" round
                                                           @click="nextTime()"></el-button>
                                            </el-tooltip>
                                        </el-button-group>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <input id="hour" class="btn btn-white option-type"
                                           :style="dateType=='hour'?styleObj:null" type="button"
                                           @click="dateTypeChoose('hour')" value="小时">
                                    <input id="day" class="btn btn-white option-type"
                                           :style="dateType=='day'?styleObj:null" type="button"
                                           @click="dateTypeChoose('day')" value="日">
                                </div>
                                <div class="form-group " style="width: 80%">
                                    <div class="input-group" @click="queryHourTime" v-if="dateType == 'hour'">
                                        <input key="hour" type="text" class="form-control" :value="dateHourTime" id="hourTime"
                                               readonly="readonly" placeholder="请查询时间">
                                        <span class="input-group-btn">
												<button type="button" class="btn btn-white btn-default">
													<i class="ace-icon fa fa-calendar"
                                                       style="margin-right: 0px;margin-top: 3px;"></i>
												</button>
                           					</span>
                                    </div>
                                    <div class="input-group" @click="queryDayTime" v-if="dateType == 'day'">
                                        <input key="day" type="text" class="form-control" :value="dateDayTime" id="dayTime"
                                               readonly="readonly" placeholder="请查询时间">
                                        <span class="input-group-btn">
												<button type="button" class="btn btn-white btn-default">
													<i class="ace-icon fa fa-calendar"
                                                       style="margin-right: 0px;margin-top: 3px;"></i>
												</button>
                           					</span>
                                    </div>
                                </div>
                                <div class="form-group title-style">
                                    展示类型
                                </div>
                                <div class="form-group">
                                    <input id="czt" class="btn btn-white option-type"
                                           :style="showType=='cz'?styleObj:null" type="button"
                                           @click="showTypeChoose('cz')" value="插值图">
                                    <input id="tst" class="btn btn-white option-type"
                                           :style="showType=='ts'?styleObj:null" type="button"
                                           @click="showTypeChoose('ts')" value="填色图">
                                    <input id="uv" class="btn btn-white option-type"
                                           :style="showType=='uv'?styleObj:null" type="button"
                                           @click="showTypeChoose('uv')" value="风速风向图">
                                </div>
                                <template v-if="showType!='uv'">
                                    <div class="form-group title-style">
                                        指标选择
                                    </div>
                                    <div class="form-group">
                                        <div>
                                            <input id="ZB_O3" class="btn btn-white option-type"
                                                   :style="pollute=='o3'?styleObj:null" type="button"
                                                   @click="indexChoose('o3')" value="O₃">
                                            <input id="ZB_SO2" class="btn btn-white option-type"
                                                   :style="pollute=='so2'?styleObj:null" type="button"
                                                   @click="indexChoose('so2')" value="SO₂">
                                            <input id="ZB_NO2" class="btn btn-white option-type"
                                                   :style="pollute=='no2'?styleObj:null" type="button"
                                                   @click="indexChoose('no2')" value="NO₂">
                                        </div>
                                        <div style="margin-bottom: 5px;margin-top: 5px">
                                            <input id="ZB_CO" class="btn btn-white option-type"
                                                   :style="pollute=='co'?styleObj:null" type="button"
                                                   @click="indexChoose('co')" value="CO">
                                            <input id="ZB_PM25" class="btn btn-white option-type"
                                                   :style="pollute=='pm25'?styleObj:null" type="button"
                                                   @click="indexChoose('pm25')" value="PM₂.₅">
                                            <input id="ZB_PM10" class="btn btn-white option-type"
                                                   :style="pollute=='pm10'?styleObj:null" type="button"
                                                   @click="indexChoose('pm10')" value="PM₁₀">
                                        </div>
                                        <div>
                                            <input id="ZB_AQI" class="btn btn-white option-type"
                                                   :style="pollute=='aqi'?styleObj:null" type="button"
                                                   @click="indexChoose('aqi')" value="AQI">
                                        </div>
                                    </div>
                                </template>
                                <div class="form-group title-style">
                                    范围选择
                                </div>
                                <div class="form-group">
                                    <input id="fw_sc" class="btn btn-white option-type"
                                           :style="scope=='sc'?styleObj:null" type="button"
                                           @click="scopeChoose('sc')" value="四川省">
                                    <input id="fw_cd" class="btn btn-white option-type"
                                           :style="scope=='cd'?styleObj:null" type="button"
                                           @click="scopeChoose('cd')" value="成都市">
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp" %>
<script src="${ctx}/assets/components/element-ui/index.js"></script>
<script type="text/javascript">
    var imagePath = '${path}';
    var dateDayTime = '${dateDayTime}';
    var dateHourTime = '${dateHourTime}';
</script>
<script src="${ctx}/assets/custom/analysis/airqualitystatus/index.js"></script>
</body>
</html>
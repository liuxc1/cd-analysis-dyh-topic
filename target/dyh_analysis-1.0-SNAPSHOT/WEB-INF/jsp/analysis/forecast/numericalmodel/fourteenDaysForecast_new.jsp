<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>预报查询</title>
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp" %>
    <link href="${ctx }/assets/custom/components/analysis/css/time-axis.css?v=20221205102239" rel="stylesheet"/>
    <link rel="stylesheet" href="${ctx }/assets/components/zTree/css/zTreeStyle/zTreeStyle.css?v=20221205102239"/>
    <link rel="stylesheet" href="${ctx }/assets/components/zTree/css/metroStyle/metroStyle.css?v=20221205102239"/>
    <link rel="stylesheet" href="${ctx }/assets/components/element-ui/css/index.css?v=20221205102239"/>
    <!-- 分析平台-文件上传表格组件-样式文件 -->
    <style type="text/css">
      .timeType {
          display: inline-block;
          width: 80px;
          height: 40px;
          border: 4px solid #02A7F0;
          font-size: 22px;
          text-align: center;
          margin-top: 20px;
          overflow: hidden;
      }
      .el-radio-group {
          margin-left: 12px;
          margin-bottom: 5px;
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
                        <h5 class="page-title">
                           <i class="header-icon fa fa-adjust"></i>
                            预报查询
                        </h5>
                    </li>
                </ul>
            </div>
        </div>
        <div class="main-content-inner">
            <div class="page-content">
                <form id="mainForm" class="form-horizontal" role="form" id="formList" method="post">
                    <div class="row ">
                        <div class="col-xs-12 ">
                            <label class="col-xs-1 control-label no-padding-right">预报时长：</label>
                            <el-radio-group v-model="stepDay" size="small" @change.native="changeStep">
                               <%-- <template v-if="queryParams.model !== 'CFS'">--%>
                                    <el-radio-button label="8" >8天</el-radio-button>
                                    <el-radio-button label="14" >14天</el-radio-button>
                                <%--</template>
                                <template v-else>--%>
                                    <el-radio-button label="35" >35天</el-radio-button>
                               <%-- </template>--%>
                            </el-radio-group>
                        </div>

                        <div class="col-xs-12 " >
                            <label class="col-xs-1 control-label no-padding-right">起报日期：</label>
                            <div class="col-xs-2">
                                <div class="col-xs-4 no-padding-right no-padding-left" style="width: 160px;">
                                    <div class="input-group" id="divDate" @click="wdatePicker">
                                        <input type="text" id="txtDateStart" class="form-control" v-model="queryParams.month" name="datetime" readonly="readonly">
                                        <span class="input-group-btn">
                                                <button type="button" class="btn btn-white btn-default"  id="btnDateStart" readonly="readonly">
                                                    <i class="ace-icon fa fa-calendar"></i>
                                                </button>
                                            </span>
                                    </div>
                                </div>
                            </div>
                            <div>
                                <div class="col-xs-8">
                                    <time-axis ref="timeAxis"
                                               :current="queryParams.month"
                                               :prev="timeAxis.prev"
                                               :next="timeAxis.next"
                                               :list="timeAxis.list"
                                               @prevclick="prevClick"
                                               @nextclick="nextClick"
                                               @listclick="timeAxisListClick"
                                    ></time-axis>
                                </div>
                                    <div class="col-xs-1" >
                                </div>
                            </div>
                        </div>
                        <div class="col-xs-12 " style="margin-top: 10px;margin-bottom: 10px">
                            <label class="col-xs-1 control-label no-padding-right">行政区/点位：</label>
                            <div class="col-xs-2">
                                <div class="col-xs-4 no-padding-right no-padding-left" style="width: 160px;">
                                    <div class="input-group"  >
                                        <input type="text" id="regionAndpoint" class="form-control" @click = "cheakRegionAndPoint"
                                               v-model="queryParams.pointName"    readonly="readonly">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-xs-12 ">
                            <label class="col-xs-1 control-label no-padding-right">模式选择：</label>
                            <el-radio-group v-model="queryParams.model" size="small" @change.native="changeModel">
                                <template  v-for="(item,index) in modelList">
                                    <template v-if="stepDay == item.step">
                                        <el-radio-button :label="item.code">{{item.name}}</el-radio-button>
                                    </template>
                                </template>
                            </el-radio-group>
                            <button type="button" class="btn btn-xs btn-primary btn-default-ths" @click="exportExcel" style="float: right;margin-right: 10px;">
                                <i class="ace-icon fa fa-download"></i> 导出
                            </button>
                            <div class=" form-group" style="float: right;margin-right: 10px;" >
                                <button type="button" class="btn  btn-info btn-default-ths" @click="query" >
                                    <i class="ace-icon fa fa-search"></i> 查询
                                </button>
                            </div>
                        </div>
                        <div class="col-xs-12 " >
                            <div class="col-xs-10">
                                <span style="margin-left: 3%;color: #027DB4;font-size: 16px;    ">({{queryParams.modelTime.substring(5,7)}}月{{queryParams.modelTime.substring(8,10)}}日{{getModelName()}}中期空气质量预报系统中心城区订正预报结果）</span>
                            </div>
                        </div>
                    </div>
                    <hr class="no-margin">
                    <%--污染浓度变化 - table--%>
                    <div class="col-xs-12 form-group">
                        <template v-if="queryParams.model == 'CFS' || queryParams.model == 'CMA'">
                            <div class="col-xs-12 echars echartsHeihgt">
                                <div class="timeType">0时</div>
                                <div>单位：μg/m³（CO为mg/m³，AQI无量纲）</div>
                                <table class="table table-bordered table-hover">
                                    <thead>
                                    <tr>
                                        <th style="text-align: center">点位</th>
                                        <th style="text-align: center">日期</th>
                                        <th style="text-align: center;width: 5%;">SO<sub>2</sub></th>
                                        <th style="text-align: center;width: 5%;">NO<sub>2</sub></th>
                                        <th style="text-align: center;width: 5%;">PM<sub>10</sub></th>
                                        <th style="text-align: center;width: 5%;">CO</th>
                                        <th style="text-align: center;width: 7%;">O<sub>3</sub></th>
                                        <th style="text-align: center;width: 7%;">O<sub>3</sub>_8</th>
                                        <th style="text-align: center;width: 5%;">PM<sub>2.5</sub></th>
                                        <th style="text-align: center;width: 9%;">AQI</th>
                                        <th style="text-align: center">等级</th>
                                        <th style="text-align: center">首要污染物</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <template v-if="table0 != null && table0.length > 0" v-for="item in table0">
                                        <tr>
                                            <td style="text-align: center">{{item.pointname}}</td>
                                            <td style="text-align: center" :title="item.resulttime.substring(0,10)">{{item.resulttime.substring(0,10)}}</td>
                                            <td style="text-align: right" :title="item.so2">{{item.so2}}</td>
                                            <td style="text-align: right" :title="item.no2">{{item.no2}}</td>
                                            <td style="text-align: right" :title="item.pm10">{{item.pm10}}</td>
                                            <td style="text-align: right" :title="item.co">{{item.co}}</td>
                                            <td style="text-align: right" :title="item.o3">{{item.o3}}</td>
                                            <td style="text-align: right" :title="item.o3_8">{{item.o38}}</td>
                                            <td style="text-align: right" :title="item.pm25">{{item.pm25}}</td>
                                            <td style="text-align: right" :title="item.aqiReange">{{item.aqiReange}}</td>
                                            <td style="text-align: center" :title="item.aqilevelreangestate" :style="getTwoColor(item.aqiMin,item.aqiMax)">{{item.aqilevelreangestate}}</td>
                                            <td style="text-align: center" :title="item.primpollute" <%--:style="primpolluteColor(item.primpollute)"--%>>{{item.primpollute == null?'--':item.primpollute}}</td>
                                        </tr>
                                    </template>
                                    <tr v-if="table0 == null || table0.length == 0" >
                                        <td colspan="12" style="text-align: center;">暂无数据</td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </template>
                        <template v-else>
                            <div class="col-xs-6 echars echartsHeihgt">
                                <div class="timeType">12时</div>
                                <div>单位：μg/m³（CO为mg/m³，AQI无量纲）</div>
                                <table class="table table-bordered table-hover">
                                    <thead>
                                    <tr>
                                        <th style="text-align: center">点位</th>
                                        <th style="text-align: center">日期</th>
                                        <th style="text-align: center;width: 5%;">SO<sub>2</sub></th>
                                        <th style="text-align: center;width: 5%;">NO<sub>2</sub></th>
                                        <th style="text-align: center;width: 5%;">PM<sub>10</sub></th>
                                        <th style="text-align: center;width: 5%;">CO</th>
                                        <th style="text-align: center;width: 7%;">O<sub>3</sub></th>
                                        <th style="text-align: center;width: 7%;">O<sub>3</sub>_8</th>
                                        <th style="text-align: center;width: 5%;">PM<sub>2.5</sub></th>
                                        <th style="text-align: center;width: 9%;">AQI</th>
                                        <th style="text-align: center">等级</th>
                                        <th style="text-align: center">首要污染物</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <template v-if="table12 != null && table12.length > 0" v-for="item in table12">
                                        <tr>
                                            <td style="text-align: center">{{item.pointname}}</td>
                                            <td style="text-align: center" :title="item.resulttime.substring(0,10)">{{item.resulttime.substring(0,10)}}</td>
                                            <td style="text-align: right" :title="item.so2">{{item.so2}}</td>
                                            <td style="text-align: right" :title="item.no2">{{item.no2}}</td>
                                            <td style="text-align: right" :title="item.pm10">{{item.pm10}}</td>
                                            <td style="text-align: right" :title="item.co">{{item.co}}</td>
                                            <td style="text-align: right" :title="item.o3">{{item.o3}}</td>
                                            <td style="text-align: right" :title="item.o3_8">{{item.o38}}</td>
                                            <td style="text-align: right" :title="item.pm25">{{item.pm25}}</td>
                                            <td style="text-align: right" :title="item.aqiReange">{{item.aqiReange}}</td>
                                            <td style="text-align: center" :title="item.aqilevelreangestate" :style="getTwoColor(item.aqiMin,item.aqiMax)">{{item.aqilevelreangestate}}</td>
                                            <td style="text-align: center" :title="item.primpollute" <%--:style="primpolluteColor(item.primpollute)"--%>>{{item.primpollute == null?'--':item.primpollute}}
                                            </td>
                                        </tr>
                                    </template>
                                    <tr v-if="table12 == null || table0.length == 0" >
                                        <td colspan="12" style="text-align: center;">暂无数据</td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="col-xs-6 echars echartsHeihgt" >
                                <div class="timeType">0时</div>
                                <div>单位：μg/m³（CO为mg/m³，AQI无量纲）</div>
                                <table class="table table-bordered table-hover">
                                    <thead>
                                    <tr>
                                        <th style="text-align: center">点位</th>
                                        <th style="text-align: center">日期</th>
                                        <th style="text-align: center;width: 5%;">SO<sub>2</sub></th>
                                        <th style="text-align: center;width: 5%;">NO<sub>2</sub></th>
                                        <th style="text-align: center;width: 5%;">PM<sub>10</sub></th>
                                        <th style="text-align: center;width: 5%;">CO</th>
                                        <th style="text-align: center;width: 7%;">O<sub>3</sub></th>
                                        <th style="text-align: center;width: 7%;">O<sub>3</sub>_8</th>
                                        <th style="text-align: center;width: 5%;">PM<sub>2.5</sub></th>
                                        <th style="text-align: center;width: 9%;">AQI</th>
                                        <th style="text-align: center">等级</th>
                                        <th style="text-align: center">首要污染物</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <template v-if="table0 != null && table0.length > 0" v-for="item in table0">
                                        <tr>
                                            <td style="text-align: center">{{item.pointname}}</td>
                                            <td style="text-align: center" :title="item.resulttime.substring(0,10)">{{item.resulttime.substring(0,10)}}</td>
                                            <td style="text-align: right" :title="item.so2">{{item.so2}}</td>
                                            <td style="text-align: right" :title="item.no2">{{item.no2}}</td>
                                            <td style="text-align: right" :title="item.pm10">{{item.pm10}}</td>
                                            <td style="text-align: right" :title="item.co">{{item.co}}</td>
                                            <td style="text-align: right" :title="item.o3">{{item.o3}}</td>
                                            <td style="text-align: right" :title="item.o3_8">{{item.o38}}</td>
                                            <td style="text-align: right" :title="item.pm25">{{item.pm25}}</td>
                                            <td style="text-align: right" :title="item.aqiReange">{{item.aqiReange}}</td>
                                            <td style="text-align: center" :title="item.aqilevelreangestate" :style="getTwoColor(item.aqiMin,item.aqiMax)">{{item.aqilevelreangestate}}</td>
                                            <td style="text-align: center" :title="item.primpollute" <%--:style="primpolluteColor(item.primpollute)"--%>>{{item.primpollute == null?'--':item.primpollute}}</td>
                                        </tr>
                                    </template>
                                    <tr v-if="table0 == null || table0.length == 0" >
                                        <td colspan="12" style="text-align: center;">暂无数据</td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </template>
                    </div>
                    <%--污染浓度变化 - echart--%>
                    <div class="col-xs-12 form-group">
                        <div class="col-xs-3 echars echartsHeihgt" id="so2" style="height: 300px">
                        </div>
                        <div class="col-xs-3 echars echartsHeihgt" id="no2" style="height: 300px">
                        </div>
                        <div class="col-xs-3 echars echartsHeihgt" id="pm10" style="height: 300px">
                        </div>
                        <div class="col-xs-3 echars echartsHeihgt" id="co" style="height: 300px">
                        </div>
                    </div>
                    <div class="col-xs-12 form-group">
                        <div class="col-xs-3 echars echartsHeihgt" id="o3" style="height: 300px">
                        </div>
                        <div class="col-xs-3 echars echartsHeihgt" id="o38" style="height: 300px">
                        </div>
                        <div class="col-xs-3 echars echartsHeihgt" id="pm25" style="height: 300px">
                        </div>
                        <div class="col-xs-3 echars echartsHeihgt" id="aqi" style="height: 300px">
                        </div>
                    </div>
                    <%--近期污染物浓度预报比较--%>
                    <hr class="no-margin">
                    <template v-if="queryParams.model == 'CFS' || queryParams.model == 'CMA'">
                        <div class="col-xs-12 form-group">
                            <div id="pm25_0" style="height: 450px">
                            </div>
                        </div>
                        <div class="col-xs-12 form-group">
                            <div id="o3_8_0" style="height: 450px">
                            </div>
                        </div>
                    </template>
                    <template v-else>
                        <div class="col-xs-6 form-group">
                            <div id="pm25_12" style="height: 450px">
                            </div>
                            <div id="o3_8_12" style="height: 450px">
                            </div>
                        </div>
                        <div class="col-xs-6 form-group">
                            <div id="pm25_0" style="height: 450px">
                            </div>
                            <div id="o3_8_0" style="height: 450px">
                            </div>
                        </div>
                    </template>
                    <hr class="no-margin">
                    <%--气象要素变化--%>
                    <div class="col-xs-12 form-group" style="margin-top: 10px">
                        <label class="col-xs-1 control-label no-padding-right">展示指标：</label>
                        <div class="col-xs-2">
                            <select class="form-control"
                                    v-model="queryParams.targetIndex" @change="changeTarget()">
                                <option v-for="(item,index) in targetTypeList" :value="item.targetIndex">
                                    {{item.targetName}}
                                </option>
                            </select>
                        </div>
                        <template v-if="queryParams.targetIndex==10">
                            <label class="col-xs-1 control-label no-padding-right">数据类型：</label>
                            <div class="col-xs-2">
                                <select class="form-control"
                                        v-model="queryParams.dataType" @change="queryWeatherList">
                                    <option v-for="(item,index) in dataTypeList" :value="item.typeCode">
                                        {{item.typeName}}
                                    </option>
                                </select>
                            </div>
                        </template>
                    </div>
                    <div class="col-xs-12 form-group">
                        <template v-if="queryParams.model == 'CFS' || queryParams.model == 'CMA'">
                            <div class="col-xs-12">
                                <div id="echarts_00" style="height: 450px">
                                </div>
                            </div>
                        </template>
                        <template v-else>
                            <div class="col-xs-6">
                                <div id="echarts_12" style="height: 450px">
                                </div>
                            </div>
                            <div class="col-xs-6">
                                <div id="echarts_00" style="height: 450px">
                                </div>
                            </div>
                        </template>
                    </div>
                    <%--公共气象数据表--%>
                    <div class="col-xs-12 form-group" v-if="queryParams.targetIndex<10">
                        <template v-if="queryParams.model == 'CFS' || queryParams.model == 'CMA'">
                            <div class="col-xs-12" style="overflow: auto;">
                                <table class="table table-bordered table-hover table-striped"
                                       style="table-layout:fixed;">
                                    <thead>
                                    <tr>
                                        <th style="text-align: center;width:150px">点位</th>
                                        <th style="text-align: center;width:130px ">时间</th>
                                        <th style="text-align: center;width:60px;">风速(m/s)</th>
                                        <th style="text-align: center;width: 65px;">2m气温(℃)</th>
                                        <th style="text-align: center;width: 80px;">2m露点差(℃)</th>
                                        <th style="text-align: center;width: 85px;">边界层高度(km)</th>
                                        <th style="text-align: center;width: 60px;">降水(mm)</th>
                                        <th style="text-align: center;width: 60px;">气压(Pa)</th>
                                        <th style="text-align: center;width: 70px;">辐射强度</th>
                                        <th style="text-align: center;width: 70px;">相对湿度(%RH)</th>
                                        <th style="text-align: center;width: 70px;">通风系数</th>
                                        <th style="text-align: center;width: 95px;">气象综合指数</th>
                                        <th style="text-align: center;width: 70px;">云覆盖率(%)</th>
                                    </tr>
                                    </thead>
                                    <tbody v-if="tableWeather0.list.length>0">
                                    <template v-for="item in tableWeather0.list">
                                        <tr>
                                            <td style="text-align: center">{{item.pointName}}</td>
                                            <td style="text-align: center" :title="item.resultTime">{{item.resultTime}}</td>
                                            <td class="align-right" :title="item.windSpeed">{{item.windSpeed}}</td>
                                            <td class="align-right" :title="item.temperature">{{item.temperature}}
                                            </td>
                                            <td class="align-right" :title="item.dewPointSpread">
                                                {{item.dewPointSpread}}
                                            </td>
                                            <td class="align-right" :title="item.boundingLayer">
                                                {{item.boundingLayer}}
                                            </td>
                                            <td class="align-right" :title="item.rainfall">{{item.rainfall}}</td>
                                            <td class="align-right" :title="item.pressure">{{item.pressure}}</td>
                                            <td class="align-right" :title="item.radiation">{{item.radiation}}</td>
                                            <td class="align-right" :title="item.humidity">{{item.humidity}}</td>
                                            <td class="align-right" :title="item.ventilationCoefficient">
                                                {{item.ventilationCoefficient}}
                                            </td>
                                            <td class="align-right" :title="item.compositeIndex">
                                                {{item.compositeIndex}}
                                            </td>
                                            <td class="align-right" :title="item.cloudCover">{{item.cloudCover}}</td>
                                        </tr>
                                    </template>
                                    </tbody>
                                    <tbody v-else>
                                    <tr class="align-center">
                                        <td colspan="13">暂无数据</td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="col-xs-12">
                                <my-pagination @handlecurrentchange="queryWeatherPageInfo()"
                                               :tableobj="tableWeather0"></my-pagination>
                            </div>
                        </template>
                        <template v-else>
                            <div class="col-xs-6" style="overflow: auto;">
                                <table class="table table-bordered table-hover table-striped"
                                       style="table-layout:fixed;">
                                    <thead>
                                    <tr>
                                        <th style="text-align: center;width:150px">点位</th>
                                        <th style="text-align: center;width:130px ">时间</th>
                                        <th style="text-align: center;width:60px;">风速(m/s)</th>
                                        <th style="text-align: center;width: 65px;">2m气温(℃)</th>
                                        <th style="text-align: center;width: 80px;">2m露点差(℃)</th>
                                        <th style="text-align: center;width: 85px;">边界层高度(km)</th>
                                        <th style="text-align: center;width: 60px;">降水(mm)</th>
                                        <th style="text-align: center;width: 60px;">气压(Pa)</th>
                                        <th style="text-align: center;width: 70px;">辐射强度</th>
                                        <th style="text-align: center;width: 70px;">相对湿度(%RH)</th>
                                        <th style="text-align: center;width: 70px;">通风系数</th>
                                        <th style="text-align: center;width: 95px;">气象综合指数</th>
                                        <th style="text-align: center;width: 70px;">云覆盖率(%)</th>
                                    </tr>
                                    </thead>
                                    <tbody v-if="tableWeather12.list.length>0">
                                    <template v-for="item in tableWeather12.list">
                                        <tr>
                                            <td style="text-align: center">{{item.pointName}}</td>
                                            <td style="text-align: center" :title="item.resultTime">{{item.resultTime}}</td>
                                            <td class="align-right" :title="item.windSpeed">{{item.windSpeed}}</td>
                                            <td class="align-right" :title="item.temperature">{{item.temperature}}
                                            </td>
                                            <td class="align-right" :title="item.dewPointSpread">
                                                {{item.dewPointSpread}}
                                            </td>
                                            <td class="align-right" :title="item.boundingLayer">
                                                {{item.boundingLayer}}
                                            </td>
                                            <td class="align-right" :title="item.rainfall">{{item.rainfall}}</td>
                                            <td class="align-right" :title="item.pressure">{{item.pressure}}</td>
                                            <td class="align-right" :title="item.radiation">{{item.radiation}}</td>
                                            <td class="align-right" :title="item.humidity">{{item.humidity}}</td>
                                            <td class="align-right" :title="item.ventilationCoefficient">
                                                {{item.ventilationCoefficient}}
                                            </td>
                                            <td class="align-right" :title="item.compositeIndex">
                                                {{item.compositeIndex}}
                                            </td>
                                            <td class="align-right" :title="item.cloudCover">{{item.cloudCover}}</td>
                                        </tr>
                                    </template>
                                    </tbody>
                                    <tbody v-else>
                                    <tr class="align-center">
                                        <td colspan="13">暂无数据</td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="col-xs-6" style="overflow: auto;">
                                <table class="table table-bordered table-hover table-striped"
                                       style="table-layout:fixed;">
                                    <thead>
                                    <tr>
                                        <th style="text-align: center;width:150px">点位</th>
                                        <th style="text-align: center;width:130px ">时间</th>
                                        <th style="text-align: center;width:60px;">风速(m/s)</th>
                                        <th style="text-align: center;width: 65px;">2m气温(℃)</th>
                                        <th style="text-align: center;width: 80px;">2m露点差(℃)</th>
                                        <th style="text-align: center;width: 85px;">边界层高度(km)</th>
                                        <th style="text-align: center;width: 60px;">降水(mm)</th>
                                        <th style="text-align: center;width: 60px;">气压(Pa)</th>
                                        <th style="text-align: center;width: 70px;">辐射强度</th>
                                        <th style="text-align: center;width: 70px;">相对湿度(%RH)</th>
                                        <th style="text-align: center;width: 70px;">通风系数</th>
                                        <th style="text-align: center;width: 95px;">气象综合指数</th>
                                        <th style="text-align: center;width: 70px;">云覆盖率(%)</th>
                                    </tr>
                                    </thead>
                                    <tbody v-if="tableWeather0.list.length>0">
                                    <template v-for="item in tableWeather0.list">
                                        <tr>
                                            <td style="text-align: center">{{item.pointName}}</td>
                                            <td style="text-align: center" :title="item.resultTime">{{item.resultTime}}</td>
                                            <td class="align-right" :title="item.windSpeed">{{item.windSpeed}}</td>
                                            <td class="align-right" :title="item.temperature">{{item.temperature}}
                                            </td>
                                            <td class="align-right" :title="item.dewPointSpread">
                                                {{item.dewPointSpread}}
                                            </td>
                                            <td class="align-right" :title="item.boundingLayer">
                                                {{item.boundingLayer}}
                                            </td>
                                            <td class="align-right" :title="item.rainfall">{{item.rainfall}}</td>
                                            <td class="align-right" :title="item.pressure">{{item.pressure}}</td>
                                            <td class="align-right" :title="item.radiation">{{item.radiation}}</td>
                                            <td class="align-right" :title="item.humidity">{{item.humidity}}</td>
                                            <td class="align-right" :title="item.ventilationCoefficient">
                                                {{item.ventilationCoefficient}}
                                            </td>
                                            <td class="align-right" :title="item.compositeIndex">
                                                {{item.compositeIndex}}
                                            </td>
                                            <td class="align-right" :title="item.cloudCover">{{item.cloudCover}}</td>
                                        </tr>
                                    </template>
                                    </tbody>
                                    <tbody v-else>
                                    <tr class="align-center">
                                        <td colspan="12">暂无数据</td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="col-xs-12">
                                <my-pagination @handlecurrentchange="queryWeatherPageInfo()"
                                               :tableobj="tableWeather0"></my-pagination>
                            </div>
                        </template>
                    </div>
                    <%--风速风向--%>
                    <div class="col-xs-12 form-group" v-if="queryParams.targetIndex==10">
                        <template v-if="queryParams.model == 'CFS' || queryParams.model == 'CMA'">
                            <div class="col-xs-12">
                                <table class="table table-bordered table-hover table-striped"
                                       style="table-layout:fixed">
                                    <thead>
                                    <tr>
                                        <th style="text-align: center;">点位</th>
                                        <th style="text-align: center; ">时间</th>
                                        <th style="text-align: center;">风速(m/s)</th>
                                        <th style="text-align: center;">风向(°)</th>
                                    </tr>
                                    </thead>
                                    <tbody v-if="tableWeather0.list.length>0">
                                    <template v-for="item in tableWeather0.list">
                                        <tr>
                                            <td style="text-align: center">{{item.pointName}}</td>
                                            <td style="text-align: center" :title="item.resultTime">{{item.resultTime}}</td>
                                            <td class="align-right" :title="item.windSpeed">{{item.windSpeed}}</td>
                                            <td class="align-right" :title="item.temperature">{{item.windDirection}}
                                            </td>
                                        </tr>
                                    </template>
                                    </tbody>
                                    <tbody v-else>
                                    <tr class="align-center">
                                        <td colspan="4">暂无数据</td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="col-xs-12">
                                <my-pagination @handlecurrentchange="queryWeatherPageInfo()"
                                               :tableobj="tableWeather0"></my-pagination>
                            </div>
                        </template>
                        <template v-else>
                            <div class="col-xs-6">
                                <table class="table table-bordered table-hover table-striped"
                                       style="table-layout:fixed ">
                                    <thead>
                                    <tr>
                                        <th style="text-align: center;">点位</th>
                                        <th style="text-align: center;">时间</th>
                                        <th style="text-align: center;">风速(m/s)</th>
                                        <th style="text-align: center;">风向(°)</th>
                                    </tr>
                                    </thead>
                                    <tbody v-if="tableWeather12.list.length>0">
                                    <template v-for="item in tableWeather12.list">
                                        <tr>
                                            <td style="text-align: center">{{item.pointName}}</td>
                                            <td style="text-align: center" :title="item.resultTime">{{item.resultTime}}</td>
                                            <td class="align-right" :title="item.windSpeed">{{item.windSpeed}}</td>
                                            <td class="align-right" :title="item.temperature">{{item.windDirection}}
                                            </td>
                                        </tr>
                                    </template>
                                    </tbody>
                                    <tbody v-else>
                                    <tr class="align-center">
                                        <td colspan="4">暂无数据</td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="col-xs-6">
                                <table class="table table-bordered table-hover table-striped"
                                       style="table-layout:fixed">
                                    <thead>
                                    <tr>
                                        <th style="text-align: center;">点位</th>
                                        <th style="text-align: center; ">时间</th>
                                        <th style="text-align: center;">风速(m/s)</th>
                                        <th style="text-align: center;">风向(°)</th>
                                    </tr>
                                    </thead>
                                    <tbody v-if="tableWeather0.list.length>0">
                                    <template v-for="item in tableWeather0.list">
                                        <tr>
                                            <td style="text-align: center">{{item.pointName}}</td>
                                            <td style="text-align: center" :title="item.resultTime">{{item.resultTime}}</td>
                                            <td class="align-right" :title="item.windSpeed">{{item.windSpeed}}</td>
                                            <td class="align-right" :title="item.temperature">{{item.windDirection}}
                                            </td>
                                        </tr>
                                    </template>
                                    </tbody>
                                    <tbody v-else>
                                    <tr class="align-center">
                                        <td colspan="4">暂无数据</td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="col-xs-12">
                                <my-pagination @handlecurrentchange="queryWeatherPageInfo()"
                                               :tableobj="tableWeather0"></my-pagination>
                            </div>
                        </template>
                    </div>
                    <%--逆温--%>
                    <div class="col-xs-12 form-group" v-if="queryParams.targetIndex==11">
                        <template v-if="queryParams.model == 'CFS' || queryParams.model == 'CMA'">
                            <div class="col-xs-12">
                                <table class="table table-bordered table-hover table-striped"
                                       style="table-layout:fixed">
                                    <thead>
                                    <tr>
                                        <th style="text-align: center; border-bottom-width: 3px;width: 150PX" rowspan="2">点位</th>
                                        <th style="text-align: center; border-bottom-width: 3px;width: 130PX" rowspan="2">时间</th>
                                        <th style="text-align: center; border-bottom-width: 1px;" colspan="8">高度</th>
                                    </tr>
                                    <tr>
                                        <th style="text-align: center;">67</th>
                                        <th style="text-align: center;">127</th>
                                        <th style="text-align: center;">170</th>
                                        <th style="text-align: center;">256</th>
                                        <th style="text-align: center;">430</th>
                                        <th style="text-align: center;">874</th>
                                        <th style="text-align: center;">1340</th>
                                        <th style="text-align: center;">1825</th>
                                    </tr>
                                    </thead>
                                    <tbody v-if="tableWeather0.list.length>0">
                                    <template v-for="item in tableWeather0.list">
                                        <tr>
                                            <td style="text-align: left">{{item.POINT_NAME}}</td>
                                            <td style="text-align: center" :title="item.resultTime">{{item.RESULT_TIME}}</td>
                                            <td class="align-right" :title="item.H_67">{{item.H_67}}</td>
                                            <td class="align-right" :title="item.H_127">{{item.H_127}}</td>
                                            <td class="align-right" :title="item.H_170">{{item.H_170}}</td>
                                            <td class="align-right" :title="item.H_256">{{item.H_256}}</td>
                                            <td class="align-right" :title="item.H_430">{{item.H_430}}</td>
                                            <td class="align-right" :title="item.H_874">{{item.H_874}}</td>
                                            <td class="align-right" :title="item.H_1340">{{item.H_1340}}</td>
                                            <td class="align-right" :title="item.H_1825">{{item.H_1825}}
                                            </td>
                                        </tr>
                                    </template>
                                    </tbody>
                                    <tbody v-else>
                                    <tr class="align-center">
                                        <td colspan="10">暂无数据</td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="col-xs-12">
                                <my-pagination @handlecurrentchange="queryWeatherPageInfo()"
                                               :tableobj="tableWeather0"></my-pagination>
                            </div>
                        </template>
                        <template v-else>
                            <div class="col-xs-6">
                                <table class="table table-bordered table-hover table-striped"
                                       style="table-layout:fixed">
                                    <thead>
                                    <tr>
                                        <th style="text-align: center; border-bottom-width: 3px;width: 150PX" rowspan="2">点位</th>
                                        <th style="text-align: center; border-bottom-width: 3px;width: 130PX" rowspan="2">时间</th>
                                        <th style="text-align: center; border-bottom-width: 1px;" colspan="8">高度</th>
                                    </tr>
                                    <tr>
                                        <th style="text-align: center;">67</th>
                                        <th style="text-align: center;">127</th>
                                        <th style="text-align: center;">170</th>
                                        <th style="text-align: center;">256</th>
                                        <th style="text-align: center;">430</th>
                                        <th style="text-align: center;">874</th>
                                        <th style="text-align: center;">1340</th>
                                        <th style="text-align: center;">1825</th>
                                    </tr>
                                    </thead>
                                    <tbody v-if="tableWeather12.list.length>0">
                                    <template v-for="item in tableWeather12.list">
                                        <tr>
                                            <td style="text-align: left">{{item.POINT_NAME}}</td>
                                            <td style="text-align: center" :title="item.resultTime">{{item.RESULT_TIME}}</td>
                                            <td class="align-right" :title="item.H_67">{{item.H_67}}</td>
                                            <td class="align-right" :title="item.H_127">{{item.H_127}}</td>
                                            <td class="align-right" :title="item.H_170">{{item.H_170}}</td>
                                            <td class="align-right" :title="item.H_256">{{item.H_256}}</td>
                                            <td class="align-right" :title="item.H_430">{{item.H_430}}</td>
                                            <td class="align-right" :title="item.H_874">{{item.H_874}}</td>
                                            <td class="align-right" :title="item.H_1340">{{item.H_1340}}</td>
                                            <td class="align-right" :title="item.H_1825">{{item.H_1825}}
                                            </td>
                                        </tr>
                                    </template>
                                    </tbody>
                                    <tbody v-else>
                                    <tr class="align-center">
                                        <td colspan="10">暂无数据</td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="col-xs-6">
                                <table class="table table-bordered table-hover table-striped"
                                       style="table-layout:fixed">
                                    <thead>
                                    <tr>
                                        <th style="text-align: center; border-bottom-width: 3px;width: 150PX" rowspan="2">点位</th>
                                        <th style="text-align: center; border-bottom-width: 3px;width: 130PX" rowspan="2">时间</th>
                                        <th style="text-align: center; border-bottom-width: 1px;" colspan="8">高度</th>
                                    </tr>
                                    <tr>
                                        <th style="text-align: center;">67</th>
                                        <th style="text-align: center;">127</th>
                                        <th style="text-align: center;">170</th>
                                        <th style="text-align: center;">256</th>
                                        <th style="text-align: center;">430</th>
                                        <th style="text-align: center;">874</th>
                                        <th style="text-align: center;">1340</th>
                                        <th style="text-align: center;">1825</th>
                                    </tr>
                                    </thead>
                                    <tbody v-if="tableWeather0.list.length>0">
                                    <template v-for="item in tableWeather0.list">
                                        <tr>
                                            <td style="text-align: left">{{item.POINT_NAME}}</td>
                                            <td style="text-align: center" :title="item.resultTime">{{item.RESULT_TIME}}</td>
                                            <td class="align-right" :title="item.H_67">{{item.H_67}}</td>
                                            <td class="align-right" :title="item.H_127">{{item.H_127}}</td>
                                            <td class="align-right" :title="item.H_170">{{item.H_170}}</td>
                                            <td class="align-right" :title="item.H_256">{{item.H_256}}</td>
                                            <td class="align-right" :title="item.H_430">{{item.H_430}}</td>
                                            <td class="align-right" :title="item.H_874">{{item.H_874}}</td>
                                            <td class="align-right" :title="item.H_1340">{{item.H_1340}}</td>
                                            <td class="align-right" :title="item.H_1825">{{item.H_1825}}
                                            </td>
                                        </tr>
                                    </template>
                                    </tbody>
                                    <tbody v-else>
                                    <tr class="align-center">
                                        <td colspan="10">暂无数据</td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="col-xs-12">
                                <my-pagination @handlecurrentchange="queryWeatherPageInfo()"
                                               :tableobj="tableWeather0"></my-pagination>
                            </div>
                        </template>
                    </div>
                    <%--水汽分布--%>
                    <div class="col-xs-12 form-group" v-if="queryParams.targetIndex==12">
                        <template v-if="queryParams.model == 'CFS' || queryParams.model == 'CMA'">
                            <div class="col-xs-12">
                                <table class="table table-bordered table-hover table-striped"
                                       style="table-layout:fixed">
                                    <thead>
                                    <tr>
                                        <th style="text-align: center; border-bottom-width: 3px;" rowspan="2">点位</th>
                                        <th style="text-align: center; border-bottom-width: 3px;" rowspan="2">时间</th>
                                        <th style="text-align: center; border-bottom-width: 1px;" colspan="6">高度</th>
                                    </tr>
                                    <tr>
                                        <th style="text-align: center;">0</th>
                                        <th style="text-align: center;">200</th>
                                        <th style="text-align: center;">400</th>
                                        <th style="text-align: center;">800</th>
                                        <th style="text-align: center;">1600</th>
                                        <th style="text-align: center;">3200</th>
                                    </tr>
                                    </thead>
                                    <tbody v-if="1==0">
                                    <template v-for="item in tableWeather0.list">
                                        <tr>
                                            <%--    <td style="text-align: center">{{item.pointName}}</td>
                                                <td style="text-align: center" :title="item.resultTime">{{item.resultTime}}</td>
                                                <td class="align-right" :title="item.windSpeed">{{item.windSpeed}}</td>
                                                <td class="align-right" :title="item.temperature">{{item.windDirection}}
                                                </td>--%>
                                        </tr>
                                    </template>
                                    </tbody>
                                    <tbody v-else>
                                    <tr class="align-center">
                                        <td colspan="8">暂无数据</td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="col-xs-12">
                                <my-pagination @handlecurrentchange="queryWeatherPageInfo()"
                                               :tableobj="tableWeather0"></my-pagination>
                            </div>
                        </template>
                        <template v-else>
                            <div class="col-xs-6">
                                <table class="table table-bordered table-hover table-striped"
                                       style="table-layout:fixed ">
                                    <thead>
                                    <tr>
                                        <th style="text-align: center; border-bottom-width: 3px;" rowspan="2">点位</th>
                                        <th style="text-align: center; border-bottom-width: 3px;" rowspan="2">时间</th>
                                        <th style="text-align: center; border-bottom-width: 1px;" colspan="6">高度</th>
                                    </tr>
                                    <tr>
                                        <th style="text-align: center;">0</th>
                                        <th style="text-align: center;">200</th>
                                        <th style="text-align: center;">400</th>
                                        <th style="text-align: center;">800</th>
                                        <th style="text-align: center;">1600</th>
                                        <th style="text-align: center;">3200</th>
                                    </tr>
                                    </thead>
                                    <tbody v-if="1==0">
                                    <template v-for="item in tableWeather12.list">
                                        <tr>
                                            <%-- <td style="text-align: center">{{item.pointName}}</td>
                                             <td style="text-align: center" :title="item.resultTime">{{item.resultTime}}</td>
                                             <td class="align-right" :title="item.windSpeed">{{item.windSpeed}}</td>
                                             <td class="align-right" :title="item.temperature">{{item.windDirection}}
                                             </td>--%>
                                        </tr>
                                    </template>
                                    </tbody>
                                    <tbody v-else>
                                    <tr class="align-center">
                                        <td colspan="8">暂无数据</td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="col-xs-6">
                                <table class="table table-bordered table-hover table-striped"
                                       style="table-layout:fixed">
                                    <thead>
                                    <tr>
                                        <th style="text-align: center; border-bottom-width: 3px;" rowspan="2">点位</th>
                                        <th style="text-align: center; border-bottom-width: 3px;" rowspan="2">时间</th>
                                        <th style="text-align: center; border-bottom-width: 1px;" colspan="6">高度</th>
                                    </tr>
                                    <tr>
                                        <th style="text-align: center;">0</th>
                                        <th style="text-align: center;">200</th>
                                        <th style="text-align: center;">400</th>
                                        <th style="text-align: center;">800</th>
                                        <th style="text-align: center;">1600</th>
                                        <th style="text-align: center;">3200</th>
                                    </tr>
                                    </thead>
                                    <tbody v-if="1==0">
                                    <template v-for="item in tableWeather0.list">
                                        <tr>
                                            <%--    <td style="text-align: center">{{item.pointName}}</td>
                                                <td style="text-align: center" :title="item.resultTime">{{item.resultTime}}</td>
                                                <td class="align-right" :title="item.windSpeed">{{item.windSpeed}}</td>
                                                <td class="align-right" :title="item.temperature">{{item.windDirection}}
                                                </td>--%>
                                        </tr>
                                    </template>
                                    </tbody>
                                    <tbody v-else>
                                    <tr class="align-center">
                                        <td colspan="8">暂无数据</td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="col-xs-12">
                                <my-pagination @handlecurrentchange="queryWeatherPageInfo()"
                                               :tableobj="tableWeather0"></my-pagination>
                            </div>
                        </template>
                    </div>
                    <%--气象多要素--%>
                    <div class="col-xs-12 form-group" v-if="queryParams.targetIndex==13">
                        <template v-if="queryParams.model == 'CFS' || queryParams.model == 'CMA'">
                            <div class="col-xs-12">
                                <table class="table table-bordered table-hover table-striped"
                                       style="table-layout:fixed">
                                    <thead>
                                    <tr>
                                        <th style="text-align: center;">点位</th>
                                        <th style="text-align: center;">时间</th>
                                        <th style="text-align: center;">风速(m/s)</th>
                                        <th style="text-align: center;">温度(℃)</th>
                                        <th style="text-align: center;">降水(mm)</th>
                                    </tr>
                                    </thead>
                                    <tbody v-if="tableWeather0.list.length>0">
                                    <template v-for="item in tableWeather0.list">
                                        <tr>
                                            <td style="text-align: center">{{item.pointName}}</td>
                                            <td style="text-align: center" :title="item.resultTime">{{item.resultTime}}</td>
                                            <td class="align-right" :title="item.windSpeed">{{item.windSpeed}}</td>
                                            <td class="align-right" :title="item.temperature">{{item.temperature}}
                                            <td class="align-right" :title="item.rainfall">{{item.rainfall}}
                                            </td>
                                        </tr>
                                    </template>
                                    </tbody>
                                    <tbody v-else>
                                    <tr class="align-center">
                                        <td colspan="5">暂无数据</td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="col-xs-12">
                                <my-pagination @handlecurrentchange="queryWeatherPageInfo()"
                                               :tableobj="tableWeather0"></my-pagination>
                            </div>
                        </template>
                        <template v-else>
                            <div class="col-xs-6">
                                <table class="table table-bordered table-hover table-striped"
                                       style="table-layout:fixed">
                                    <thead>
                                    <tr>
                                        <th style="text-align: center;">点位</th>
                                        <th style="text-align: center;">时间</th>
                                        <th style="text-align: center;">风速(m/s)</th>
                                        <th style="text-align: center;">温度(℃)</th>
                                        <th style="text-align: center;">降水(mm)</th>
                                    </tr>
                                    </thead>
                                    <tbody v-if="tableWeather12.list.length>0">
                                    <template v-for="item in tableWeather12.list">
                                        <tr>
                                            <td style="text-align: center">{{item.pointName}}</td>
                                            <td style="text-align: center" :title="item.resultTime">{{item.resultTime}}</td>
                                            <td class="align-right" :title="item.windSpeed">{{item.windSpeed}}</td>
                                            <td class="align-right" :title="item.temperature">{{item.temperature}}
                                            <td class="align-right" :title="item.rainfall">{{item.rainfall}}
                                            </td>
                                        </tr>
                                    </template>
                                    </tbody>
                                    <tbody v-else>
                                    <tr class="align-center">
                                        <td colspan="5">暂无数据</td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="col-xs-6">
                                <table class="table table-bordered table-hover table-striped"
                                       style="table-layout:fixed">
                                    <thead>
                                    <tr>
                                        <th style="text-align: center;">点位</th>
                                        <th style="text-align: center;">时间</th>
                                        <th style="text-align: center;">风速(m/s)</th>
                                        <th style="text-align: center;">温度(℃)</th>
                                        <th style="text-align: center;">降水(mm)</th>
                                    </tr>
                                    </thead>
                                    <tbody v-if="tableWeather0.list.length>0">
                                    <template v-for="item in tableWeather0.list">
                                        <tr>
                                            <td style="text-align: center">{{item.pointName}}</td>
                                            <td style="text-align: center" :title="item.resultTime">{{item.resultTime}}</td>
                                            <td class="align-right" :title="item.windSpeed">{{item.windSpeed}}</td>
                                            <td class="align-right" :title="item.temperature">{{item.temperature}}
                                            <td class="align-right" :title="item.rainfall">{{item.rainfall}}
                                            </td>
                                        </tr>
                                    </template>
                                    </tbody>
                                    <tbody v-else>
                                    <tr class="align-center">
                                        <td colspan="5">暂无数据</td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="col-xs-12">
                                <my-pagination @handlecurrentchange="queryWeatherPageInfo()"
                                               :tableobj="tableWeather0"></my-pagination>
                            </div>
                        </template>
                    </div>
                <%--    <hr class="no-margin">
                    &lt;%&ndash;剖面图&ndash;%&gt;
                    <template v-if="queryParams.model !== 'CFS'">
                        <div class="col-xs-6 form-group" style="text-align: center" v-if="queryParams.model !== 'CFS'">
                            <img id="image_12" style="height: 380px" :src="met_vert_12" onerror="onError('image_12')">
                        </div>
                        <div class="col-xs-6 form-group" style="text-align: center" v-if="queryParams.model !== 'CFS'">
                            <img id="image_0" style="height: 380px" :src="met_vert_00" onerror="onError('image_0')">
                        </div>
                    </template>--%>

                 <%--雪山预报--%>
               <%-- <div class="row">
                    <div  class="col-xs-12">
                        <ul class="breadcrumb">
                            <li class="active">
                                <h5 class="page-title">
                                     <i class="header-icon fa fa-adjust"></i>
                                     雪山空气质量预报
                                </h5>
                            </li>
                        </ul>
                        <hr class="no-margin">
                    </div>
                    <div  class="col-xs-12" >
                         <iframe  src="http://118.112.190.75:5026/" style="width: 100%;" height="18620"  scrolling="no" frameborder="no"></iframe>
                    </div>
                </div>--%>

                    <%--空间分布图--%>
                <div class="row">
                    <div  class="col-xs-12" >
                        <iframe  id="iframeInfo"  src="${ctx}/analysis/pollutants/concentration/distributed_new.vm" style="width: 100%;"   scrolling="no" frameborder="no"></iframe>
                    </div>
                </div>

                <%--pm.25组分预报--%>
                <div class="row">
                    <div  class="col-xs-12" >
                        <iframe onload="adjustIframe('iframeInfo2')" id="iframeInfo2"  src="${ctx}/analysis/air/componentsForecast/toComponentsForecast.vm" style="width: 100%;"   scrolling="no" frameborder="no"></iframe>
                    </div>
                </div>

                <%--成都平原八市预报--%>
                <div class="row">
                    <div  class="col-xs-12" >
                        <iframe onload="adjustIframe('iframeInfo3')" id="iframeInfo3"  src="${ctx}/analysis/calendar/forecast/forecastList.vm?queryPointType=8" style="width: 100%;"  scrolling="no" frameborder="no"></iframe>
                    </div>
                </div>

                <%--成德眉资城市圈--%>
                <div class="row">
                    <div  class="col-xs-12" >
                        <iframe onload="adjustIframe('iframeInfo4')" id="iframeInfo4"  src="${ctx}/analysis/calendar/forecast/forecastList.vm?queryPointType=4" style="width: 100%;"  scrolling="no" frameborder="no"></iframe>
                    </div>
                </div>

                </form>
            </div>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp" %>
<img id="errorImg" src="${ctx}/mvc/forecastshow/no_img.jpg" style="display: none">
<script type="text/javascript">
    var ctx = "${ctx}";
    var model = '<%=request.getParameter("model")%>';
    var modelTime = '<%=request.getParameter("modelTime")%>';
    var pointCode = '<%=request.getParameter("pointCode")%>';
    var pointName = '<%=request.getParameter("pointName")%>';
    const wrfImagePth = '${path}';
    //设置iframe自动高
    autoHeightIframe("iframeInfo");

    function adjustIframe(id) {
        let ifm = document.getElementById(id);
        let subWeb = document.frames ? document.frames[iframe.id].document : ifm.contentDocument;
        if (ifm !== null && subWeb !== null) {
            ifm.height = subWeb.body.scrollHeight;
            ifm.width = subWeb.body.scrollWidth;
        }
    }
</script>
<script type="text/javascript" src="${ctx}/assets/components/vue/vue.js?v=20221205102239"></script>
<script type="text/javascript" src="${ctx }/assets/components/zTree/js/jquery.ztree.all.js?v=20221205102239"></script>
<script type="text/javascript" src="${ctx}/assets/components/echarts/echarts.js?v=20221205102239"></script>
<!-- Dialog 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/dialog-util.js?v=20221205102239"></script>
<!-- Ajax 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/ajax-util.js?v=20221205102239"></script>
<!-- 日期时间 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/date-time-util.js?v=20221205102239"></script>
<!-- 文件上传 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/file/file-upload-util.js?v=20221205102239"></script>
<!-- 分析平台-时间轴组件-逻辑js -->
<script type="text/javascript" src="${ctx}/assets/custom/components/analysis/js/time-axis.js?v=20221205102239"></script>
<script id="vue-template-time-axis" type="text/x-template">
    <%@ include file="/WEB-INF/jsp/components/analysis/time-axis.jsp" %>
</script>
<!-- vue-分页组件 -->
<%@ include file="/WEB-INF/jsp/components/common/page-pagination.jsp" %>
<!-- 文件下载 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/file/file-download-util.js?v=20221205102239"></script>
<script type="text/javascript" src="${ctx}/assets/components/element-ui/index.js?v=20221205102239"></script>
<script type="text/javascript" src="${ctx}/assets/custom/analysis/forecast/numericalmodel/fourteenDaysForecast_new.js?v=20221205102239"></script>

</body>
</html>
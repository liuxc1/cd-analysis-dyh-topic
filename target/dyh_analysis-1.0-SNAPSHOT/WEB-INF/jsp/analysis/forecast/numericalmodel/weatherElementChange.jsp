<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>CDAQS-MT气象要素变化</title>
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp" %>
    <link href="${ctx }/assets/custom/components/analysis/css/time-axis.css?v=20221129015223" rel="stylesheet"/>
    <link rel="stylesheet" href="${ctx }/assets/components/zTree/css/zTreeStyle/zTreeStyle.css?v=20221129015223"/>
    <link rel="stylesheet" href="${ctx }/assets/components/zTree/css/metroStyle/metroStyle.css?v=20221129015223"/>
    <style type="text/css">
        .timeType {
            display: inline-block;
            width: 80px;
            height: 40px;
            border: 4px solid #02A7F0;
            font-size: 22px;
            text-align: center;
            margin-top: 10px;
            margin-left: 4%;
            overflow: hidden;
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
                            <i class="header-icon fa fa-bars"></i>
                            CDAQS-MT气象要素变化
                        </h5>
                    </li>
                </ul>
            </div>
        </div>
        <div class="main-content-inner">
            <div class="page-content">
                <form id="mainForm" class="form-horizontal" role="form" id="formList" method="post">
                    <div class="form-group">
                        <label class="col-xs-1 control-label no-padding-right">起报日期：</label>
                        <div class="col-xs-2">
                            <div class="col-xs-4 no-padding-right no-padding-left" style="width: 160px;">
                                <div class="input-group" id="divDate" @click="wdatePicker">
                                    <input type="text" id="txtDateStart" class="form-control"
                                           v-model="queryParams.month"
                                           name="datetime" readonly="readonly">
                                    <span class="input-group-btn">
												<button type="button" class="btn btn-white btn-default"
                                                        id="btnDateStart" readonly="readonly">
													<i class="ace-icon fa fa-calendar"></i>
												</button>
											</span>
                                </div>
                            </div>
                        </div>
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
                        <div class="col-xs-1">
                        </div>
                    </div>
                    <div class="form-group" style="margin-top: 10px">
                        <label class="col-xs-1 control-label no-padding-right">行政区/点位：</label>
                        <div class="col-xs-2">
                            <div class="no-padding-right no-padding-left">
                                <div class="input-group">
                                    <input type="text" id="regionAndPoint" class="form-control"
                                           @click="checkRegionAndPoint"
                                           v-model="queryParams.pointName" readonly="readonly">
                                </div>
                            </div>
                        </div>
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
                                        v-model="queryParams.dataType" @change="doSearch">
                                    <option v-for="(item,index) in dataTypeList" :value="item.typeCode">
                                        {{item.typeName}}
                                    </option>
                                </select>
                            </div>
                        </template>
                    </div>
                    <div class="form-group">
                        <div class="col-xs-10">
                        </div>
                        <div class="col-xs-2" style="text-align: right">
                            <button type="button" class="btn  btn-info btn-default-ths" @click="doSearch()">
                                <i class="ace-icon fa fa-search"></i> 查询
                            </button>
                            <button type="button" class="btn btn-xs btn-primary btn-default-ths" @click="exportExcel">
                                <i class="ace-icon fa fa-download"></i> 导出
                            </button>
                        </div>
                    </div>

                    <hr class="no-margin">
                    <div class="col-xs-12 form-group">
                        <div class="col-xs-6">
                            <div id="echarts_12" style="height: 450px">
                            </div>
                        </div>
                        <div class="col-xs-6">
                            <div id="echarts_00" style="height: 450px">
                            </div>
                        </div>
                    </div>
                    <%--公共气象数据表--%>
                    <div class="col-xs-12 form-group" v-if="queryParams.targetIndex<10">
                        <div class="col-xs-6" style="overflow: auto;">
                            <div class="timeType">12时</div>
                            <table class="table table-bordered table-hover table-striped"
                                   style="table-layout:fixed;">
                                <thead>
                                <tr>
                                    <th style="text-align: center;width:150px">点位</th>
                                    <th style="text-align: center;width:130px ">时间</th>
                                    <th style="text-align: center;width:60px;">风速</th>
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
                                <tbody v-if="table12.list.length>0">
                                <template v-for="item in table12.list">
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
                            <div class="timeType">00时</div>
                            <table class="table table-bordered table-hover table-striped"
                                   style="table-layout:fixed;">
                                <thead>
                                <tr>
                                    <th style="text-align: center;width:150px">点位</th>
                                    <th style="text-align: center;width:130px ">时间</th>
                                    <th style="text-align: center;width:60px;">风速</th>
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
                                <tbody v-if="table0.list.length>0">
                                <template v-for="item in table0.list">
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
                                           :tableobj="table12"></my-pagination>
                        </div>
                    </div>
                    <%--风速风向--%>
                    <div class="col-xs-12 form-group" v-if="queryParams.targetIndex==10">
                        <div class="col-xs-6">
                            <div class="timeType">12时</div>
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
                                <tbody v-if="table12.list.length>0">
                                <template v-for="item in table12.list">
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
                            <div class="timeType">00时</div>
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
                                <tbody v-if="table0.list.length>0">
                                <template v-for="item in table0.list">
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
                                           :tableobj="table12"></my-pagination>
                        </div>
                    </div>
                    <%--逆温--%>
                    <div class="col-xs-12 form-group" v-if="queryParams.targetIndex==11">
                        <div class="col-xs-6">
                            <div class="timeType">12时</div>
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
                                <tbody v-if="table12.list.length>0">
                                <template v-for="item in table12.list">
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
                            <div class="timeType">00时</div>
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
                                <tbody v-if="table0.list.length>0">
                                <template v-for="item in table0.list">
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
                                           :tableobj="table12"></my-pagination>
                        </div>
                    </div>
                    <%--水汽分布--%>
                    <div class="col-xs-12 form-group" v-if="queryParams.targetIndex==12">
                        <div class="col-xs-6">
                            <div class="timeType">12时</div>
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
                                <template v-for="item in table12.list">
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
                            <div class="timeType">00时</div>
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
                                <template v-for="item in table0.list">
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
                                           :tableobj="table12"></my-pagination>
                        </div>
                    </div>
                    <%--气象多要素--%>
                    <div class="col-xs-12 form-group" v-if="queryParams.targetIndex==13">
                        <div class="col-xs-6">
                            <div class="timeType">12时</div>
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
                                <tbody v-if="table12.list.length>0">
                                <template v-for="item in table12.list">
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
                            <div class="timeType">00时</div>
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
                                <tbody v-if="table0.list.length>0">
                                <template v-for="item in table0.list">
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
                                           :tableobj="table12"></my-pagination>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp" %>
<script type="text/javascript">
    var ctx = "${ctx}";
</script>
<script type="text/javascript" src="${ctx }/assets/components/zTree/js/jquery.ztree.all.js?v=20221129015223"></script>
<script type="text/javascript" src="${ctx}/assets/components/echarts/echarts.js?v=20221129015223"></script>
<!-- Dialog 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/dialog-util.js?v=20221129015223"></script>
<!-- Ajax 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/ajax-util.js?v=20221129015223"></script>
<!-- 日期时间 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/date-time-util.js?v=20221129015223"></script>
<!-- 分析平台-时间轴组件-逻辑js -->
<script type="text/javascript" src="${ctx}/assets/custom/components/analysis/js/time-axis.js?v=20221129015223"></script>
<script id="vue-template-time-axis" type="text/x-template">
    <%@ include file="/WEB-INF/jsp/components/analysis/time-axis.jsp" %>
</script>
<!-- 文件下载 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/file/file-download-util.js?v=20221129015223"></script>
<!-- vue-分页组件 -->
<%@ include file="/WEB-INF/jsp/components/common/page-pagination.jsp" %>
<script type="text/javascript"
        src="${ctx}/assets/custom/analysis/forecast/numericalmodel/weatherElementChange.js?v=20221129015223"></script>
</body>
</html>
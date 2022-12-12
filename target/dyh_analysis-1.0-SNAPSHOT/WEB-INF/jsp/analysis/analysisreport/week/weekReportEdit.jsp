<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>周报分析—添加/编辑</title>
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp" %>
    <link href="${ctx }/assets/custom/components/analysis/css/file-upload-table.css?v=20221129015223" rel="stylesheet"/>
    <style>
        input{
            border-bottom: 1px solid #000;
            border-top: 0px;
            border-left: 0px;
            border-right: 0px;
        }
    </style>
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
                    <h5 class="page-title"  >
                        <i class="header-icon fa fa-ellipsis-v"></i>
                        周报分析—添加/编辑
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
                                    <input type="text" id="txtDate" v-model="report.reportTime" data-validation-engine="validate[required]" class="form-control" placeholder="请选择填报日期" readonly>
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
                                    周报期数：
                                </label>
                            </th>
                            <td>
                                {{getYear(report.reportTime)}}年<input v-model="report.reportNum" type="text" data-validation-engine="validate[required,custom[integer],maxSize[3]]">期
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right" width="10%">
                                <label class="col-sm-12 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    编制：
                                </label>
                            </th>
                            <td width="80%">
                                <div class="col-sm-12 no-padding">
                                    <input v-model="report.bz" class="form-control" placeholder="请输入重要提示"
                                           rows="3" cols="10" data-validation-engine="validate[required,maxSize[20]]"
                                           maxlength="1000"></input>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right" width="10%">
                                <label class="col-sm-12 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    审稿：
                                </label>
                            </th>
                            <td width="80%">
                                <div class="col-sm-12 no-padding">
                                    <input v-model="report.sg" class="form-control" placeholder="请输入重要提示"
                                           rows="3" cols="10" data-validation-engine="validate[required,maxSize[20]]"
                                           maxlength="1000"></input>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right" width="10%">
                                <label class="col-sm-12 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    签发：
                                </label>
                            </th>
                            <td width="80%">
                                <div class="col-sm-12 no-padding">
                                    <input v-model="report.qf" class="form-control" placeholder="请输入重要提示"
                                           rows="3" cols="10" data-validation-engine="validate[required,maxSize[20]]"
                                           maxlength="1000"></input>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right" width="10%">
                                <label class="col-sm-12 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    主题词：
                                </label>
                            </th>
                            <td width="80%">
                                <div class="col-sm-12 no-padding">
                                    <input v-model="report.ztc" class="form-control" placeholder="请输入重要提示"
                                           rows="3" cols="10" data-validation-engine="validate[required,maxSize[20]]"
                                           maxlength="1000"></input>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right" width="10%">
                                <label class="col-sm-12 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    主送：
                                </label>
                            </th>
                            <td width="80%">
                                <div class="col-sm-12 no-padding">
                                    <input v-model="report.zs" class="form-control" placeholder="请输入重要提示"
                                           rows="3" cols="10" data-validation-engine="validate[required,maxSize[20]]"
                                           maxlength="1000"></input>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    编辑内容第一段
                                </label>
                            </th>
                            <td >
                                <div>
                                    <input type="text" v-model="report.stratTime">
                                    -
                                    <input type="text" v-model="report.endTime" >
                                    ，我市空气质量为
                                    <input type="text" v-model="report.ynum">
                                    天优，
                                    <input type="text"  v-model="report.lnum" >
                                    天良，
                                    <input type="text" v-model="report.qdnum">
                                    天轻度污染；PM₂.₅、PM、SO₂、NO₂、O₃ 及 CO 平均浓度分别为
                                    <input type="text" v-model="report.pm25">
                                    μg/m³ 、
                                    <input type="text" v-model="report.pm10">
                                    μg/m³  、
                                    <input type="text" v-model="report.so2">
                                    μg/m³  、
                                    <input type="text" v-model="report.no2">
                                    μg/m³  、
                                    <input type="text" v-model="report.o3">
                                    μg/m³  、
                                    <input type="text" v-model="report.co">
                                    mg/m³ 。
                                    <a  @click="getText1" >生成</a>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    生成内容第一段
                                </label>
                            </th>
                            <td >

                                <textarea class="col-sm-12" v-model="report.text1"
                                          data-validation-engine="validate[required, maxSize[5000]]"/>
                                {{report.text1}}
                                </textarea>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    编辑内容第二段
                                </label>
                            </th>
                            <td >
                                <div>
                                    （{{getYear(report.reportTime)}}年1月1日至
                                    <input type="text" v-model="report.endTime" >
                                    ），中心城区空气质量为
                                    <input type="text" v-model="report.txtynum2">
                                    天优，
                                    <input type="text"  v-model="report.txtlnum2" >
                                    天良，
                                    <input type="text" v-model="report.txtqdnum2">
                                    天轻度污染，
                                    <input type="text" v-model="report.txtzdnum2">
                                    天中度污染，优良率
                                    <input type="text" v-model="report.txtthisyear2">
                                    %， 与去年相比，优良天数
                                    <input type="text" v-model="report.isAdd">
                                    <input type="text" v-model="report.addNum">
                                    天。PM₂.₅、PM₁₀ 平均浓度分别为
                                    <input type="text" v-model="report.txtpm252">
                                    μg/m³  和
                                    <input type="text" v-model="report.txtpm102">
                                    μg/m³ ，较去年同期分别
                                    <input type="text" v-model="report.isaddpm25" placeholder="请填写（上升、降低）">
                                    <input type="text" v-model="report.ratepm25">
                                    %、
                                    <input type="text" v-model="report.ratepm10">
                                    %。(注： 数据未经国家复核，以国家最终下发数据为准)
                                    <a   @click="getText2" >生成</a>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    生成内容第二段
                                </label>
                            </th>
                            <td >

                                <textarea style="height: 70px" class="col-sm-12" v-model="report.text2"
                                          data-validation-engine="validate[required, maxSize[5000]]">
                                        {{report.text2}}
                                </textarea>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    编辑数据质量简述第一段
                                </label>
                            </th>
                            <td >
                                <div>
                                    本周
                                    <input type="text" v-model="report.stratTime">
                                    -
                                    <input type="text" v-model="report.endTime" >
                                    ，除停电无数据外，设备均运行正常，数据有效性
                                    <input type="text" v-model="report.datavalidity" >
                                    %以上，期间设备数据有效率详见附表。
                                    <a  @click="getText3" >生成</a>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    生成数据质量简述第一段
                                </label>
                            </th>
                            <td >

                                <textarea style="height: 70px" class="col-sm-12" v-model="report.text3"
                                          data-validation-engine="validate[required, maxSize[5000]]">
                                        {{report.text3}}
                                </textarea>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    编辑数据质量简述第二段
                                </label>
                            </th>
                            <td >
                                <div>
                                    根据实验室监测结果，观测期间 PM₂.₅ 平均浓度为
                                    <input type="text" v-model="report.spm25">
                                    μg/m³ ， 其中有机质、地壳元素、硝酸根、硫酸根和铵根离子浓度分别为
                                    <input type="text" v-model="report.yjz">
                                    μg/m³ 、
                                    <input type="text" v-model="report.dqys">
                                    μg/m³ 、
                                    <input type="text" v-model="report.xsg">
                                    μg/m³ 、
                                    <input type="text" v-model="report.lsg">
                                    μg/m³ 、
                                    <input type="text" v-model="report.aglz">
                                    μg/m³ ；总挥发性有机污染物（PAMS56）浓度为
                                    <input type="text" v-model="report.pams56">
                                    μg/m³ ，详见表 1。
                                    <a  @click="getText4" >生成</a>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    生成数据质量简述第二段
                                </label>
                            </th>
                            <td >

                                <textarea style="height: 70px" class="col-sm-12" v-model="report.text4"
                                          data-validation-engine="validate[required, maxSize[5000]]">
                                        {{report.text4}}
                                </textarea>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    本周空气质量变化过程分析第一段编辑
                                </label>
                            </th>
                            <td >
                                <div>
                                    本周（ <input type="text" v-model="report.stratTime">
                                    -
                                    <input type="text" v-model="report.endTime" >
                                    ）气温升高，我市空气质量为
                                    <%--<template v-if="report.ynum > 0 ">--%>
                                    <input type="text" v-model="report.ynum" >
                                    天优、
                                    <%-- </template>
                                     <template v-if="report.lnum > 0 ">--%>
                                    <input type="text" v-model="report.lnum" >
                                    天良、
                                    <%--  </template>
                                      <template v-if="report.qdnum > 0 ">--%>
                                    <input type="text" v-model="report.qdnum" >
                                    天轻度污染、
                                    <%-- </template>
                                     <template v-if="report.zdnum > 0 ">--%>
                                    <input type="text" v-model="report.zdnum" >
                                    天中度污染、
                                    <%-- </template>
                                     <template v-if="report.zzdnum > 0 ">--%>
                                    <input type="text" v-model="report.zzdnum" >
                                    天重度污染、
                                    <%-- </template>
                                     <template v-if="report.yznum > 0 ">--%>
                                    <input type="text" v-model="report.yznum" >
                                    天严重污染
                                    <%--  </template>--%>

                                    ，首要污染物为
                                    <%--<template v-if="report.numpm25 > 0 ">--%>
                                    (PM₂.₅<input type="text" v-model="report.numpm25" >天)
                                    <%-- </template>
                                     <template v-if="report.numpm10 > 0 ">--%>
                                    (PM₁₀<input type="text" v-model="report.numpm10" >天)
                                    <%--</template>
                                    <template v-if="report.numso2 > 0 ">--%>
                                    (SO₂<input type="text" v-model="report.numso2" >天)
                                    <%-- </template>
                                     <template v-if="report.numo3 > 0 ">--%>
                                    (O₃<input type="text" v-model="report.numo3" >天)
                                    <%-- </template>
                                     <template v-if="report.numno2 > 0 ">--%>
                                    (NO₂<input type="text" v-model="report.numno2" >天)
                                    (CO<input type="text" v-model="report.numco" >天)
                                    <%--</template>--%>
                                    ：前期（
                                    <input type="text" v-model="report.stratTime">
                                    -
                                    <input type="text" id="earlyTime"  v-model="report.earlyTime" data-validation-engine="validate[required]"  @click="earlyTimeClick" >
                                    )
                                    <input type="text" v-model="report.earlyText">
                                    。后期（
                                    <input type="text" id="laterTime" v-model="report.laterTime" data-validation-engine="validate[required]"   @click="laterTimeClick">
                                    -
                                    <input type="text" v-model="report.endTime">
                                    )
                                    <input type="text" v-model="report.laterText">
                                    <a  @click="getText5" >生成</a>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    本周空气质量变化过程分析第一段生成
                                </label>
                            </th>
                            <td>
                                <textarea class="col-sm-12" v-model="report.text5"
                                          data-validation-engine="validate[required, maxSize[5000]]"/>
                                {{report.text5}}
                                </textarea>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    本周空气质量变化过程分析第二段
                                </label>
                            </th>
                            <td >
                                <div>
                                    前期（
                                    <input type="text" v-model="report.earlyTextSd">
                                    时段）（
                                    <input type="text" v-model="report.stratTime">
                                    -
                                    <input type="text"  v-model="report.earlyTime" >
                                    )：天气
                                    <input type="text" v-model="report.earlyWaether">
                                    ，边界层高度维持在
                                    <input type="text" v-model="report.earlyHeightStart">
                                    -
                                    <input type="text" v-model="report.earlyHeightEnd">
                                    米之间，空气湿度
                                    <input type="text" v-model="report.earlyHumidity">
                                    %，二次颗粒物转化速率
                                    <input type="text" v-model="report.earlyTransformRate">
                                    （NOR为
                                    <input type="text"  v-model="report.enor">
                                    ，SOR为
                                    <input type="text"  v-model="report.esor" >
                                    ），二次无机组分占比
                                    <input type="text" v-model="report.earlyProportion">
                                    （
                                    <input type="text" v-model="report.earlyProportionRate">
                                    %），前体物活性
                                    <input type="text" v-model="report.earlyActivity">
                                    （0-10 时VOCs 的平均OFP为
                                    <input type="text"   v-model="report.eofp" >
                                    μg/m³ ）。
                                    <input type="text" v-model="report.earlySummary">
                                    <a  @click="getText6" >生成</a>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    本周空气质量变化过程分析第二段生成
                                </label>
                            </th>
                            <td>
                                <textarea class="col-sm-12" v-model="report.text6"
                                          data-validation-engine="validate[required, maxSize[5000]]"/>
                                {{report.text6}}
                                </textarea>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    本周空气质量变化过程分析第三段
                                </label>
                            </th>
                            <td >
                                <div>
                                    后期（
                                    <input type="text" v-model="report.laterTextSd">
                                    时段）（
                                    <input type="text" v-model="report.laterTime">
                                    -
                                    <input type="text" v-model="report.endTime">

                                    )：天气
                                    <input type="text" v-model="report.laterWaether">
                                    ，边界层高度维持在
                                    <input type="text" v-model="report.laterHeightStart">
                                    -
                                    <input type="text" v-model="report.laterHeightEnd">
                                    米之间，空气湿度
                                    <input type="text" v-model="report.laterHumidity">
                                    %，二次颗粒物转化速率
                                    <input type="text" v-model="report.laterTransformRate">
                                    （NOR为
                                    <input type="text" v-model="report.nor">
                                    ，SOR为
                                    <input type="text" v-model="report.sor">
                                    ），二次无机组分占比
                                    <input type="text" v-model="report.laterProportion">
                                    （
                                    <input type="text" v-model="report.laterProportionRate">
                                    %），前体物活性
                                    <input type="text" v-model="report.laterActivity">
                                    （0-10 时VOCs 的平均OFP为
                                    <input type="text" v-model="report.ofp">
                                    μg/m³ ）。
                                    <input type="text" v-model="report.laterSummary">
                                    <a  @click="getText7" >生成</a>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    本周空气质量变化过程分析第三段生成
                                </label>
                            </th>
                            <td>
                                <textarea class="col-sm-12" v-model="report.text7"
                                          data-validation-engine="validate[required, maxSize[5000]]"/>
                                {{report.text7}}
                                </textarea>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    三、小结
                                </label>
                            </th>
                            <td >
                                <div>
                                    本周我市空气质量为
                                    <input type="text" v-model="report.ynum">
                                    天优，
                                    <input type="text"  v-model="report.lnum" >
                                    天良，
                                    <input type="text" v-model="report.qdnum">
                                    天轻度污染、
                                    <input type="text" v-model="report.zdnum">
                                    天中度污染、
                                    <input type="text" v-model="report.zzdnum">
                                    天重度污染、
                                    <input type="text" v-model="report.yznum">
                                    天严重污染。从大气科研实验室观测数据看，本周前期
                                    <input type="text" v-model="report.weekEarlyText">
                                    。周后期，
                                    <input type="text" v-model="report.weekLaterText">
                                    。建议
                                    <input type="text" v-model="report.advAdvise">
                                    <a  @click="getText8" >生成</a>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    三、小结生成
                                </label>
                            </th>
                            <td>
                                <textarea class="col-sm-12" v-model="report.text8"
                                          data-validation-engine="validate[required, maxSize[5000]]"/>
                                {{report.text8}}
                                </textarea>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    附表1: 实验室主要观测参数统计表（单位：μg/m³ ）
                                </label>
                            </th>
                            <td>
                                <table border="1" style=" min-height: 25px; line-height: 25px; text-align: center; border-color:black; border-collapse: collapse;">
                                    <tr>
                                        <td style="width: 20%">组份名称</td>
                                        <td style="width: 20%">浓度</td>
                                        <td style="width: 20%">组份名称</td>
                                        <td style="width: 20%">浓度</td>
                                    </tr>
                                    <tr>
                                        <td>PM₂.₅</td>
                                        <td><input type="text" v-model="report.spm25"></td>
                                        <td>地壳元素</td>
                                        <td><input type="text" v-model="report.dqys"></td>
                                    </tr>
                                    <tr>
                                        <td>硫酸根</td>
                                        <td><input type="text" v-model="report.lsg"></td>
                                        <td>微量元素</td>
                                        <td><input type="text" v-model="report.wlys"></td>
                                    </tr>
                                    <tr>
                                        <td>硝酸根</td>
                                        <td><input type="text" v-model="report.xsg"></td>
                                        <td>元素碳</td>
                                        <td><input type="text" v-model="report.yst"></td>
                                    </tr>
                                    <tr>
                                        <td>铵根</td>
                                        <td><input type="text" v-model="report.aglz"></td>
                                        <td>有机质</td>
                                        <td><input type="text" v-model="report.yjz"></td>
                                    </tr>
                                    <tr>
                                        <td>氯离子</td>
                                        <td><input type="text" v-model="report.llz"></td>

                                    </tr>
                                    <tr>
                                        <td>TVOC（PAMS56）</td>
                                        <td><input type="text" v-model="report.pams56"></td>
                                        <td>烷烃</td>
                                        <td><input type="text" v-model="report.wt"></td>
                                    </tr>
                                    <tr>
                                        <td>烯烃</td>
                                        <td><input type="text" v-model="report.xt"></td>
                                        <td>芳香烃</td>
                                        <td><input type="text" v-model="report.fxt"></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    附表2:一周污染形势汇总（单位：μg/m³ ）
                                </label>
                            </th>
                            <td>
                                <table border="1" style=" min-height: 25px; line-height: 25px; text-align: center; border-color:black; border-collapse: collapse;">
                                    <thead>
                                    <tr>
                                        <th style="width: 15%;text-align: center">日期及指标</th>
                                        <template v-for="item in tableList">
                                            <th style="width: 12%;text-align: center">{{item.monitorTime.substring(0,10)}}</th>
                                        </template>
                                    </tr>

                                    </thead>
                                    <tbody>
                                    <tr>
                                        <td>AQI</td>
                                        <template v-for="item in tableList">
                                            <td><input type="text" v-model="item.aqi"></td>
                                        </template>
                                    </tr>
                                    <tr>
                                        <td>首要污染物</td>
                                        <template v-for="item in tableList">
                                            <td><input type="text" v-model="item.primaryPollutant=='O3_8'?'O3':item.primaryPollutant"></td>
                                        </template>
                                    </tr>
                                    <tr>
                                        <td>O₃ 浓度</td>
                                        <template v-for="item in tableList">
                                            <td><input type="text" v-model="item.o38"></td>
                                        </template>
                                    </tr>
                                    <tr>
                                        <td>PM₂.₅ 浓度</td>
                                        <template v-for="item in tableList">
                                            <td><input type="text" v-model="item.pm25"></td>
                                        </template>
                                    </tr>
                                    <tr>
                                        <td>PM₁₀ 浓度</td>
                                        <template v-for="item in tableList">
                                            <td><input type="text" v-model="item.pm10"></td>
                                        </template>
                                    </tr>

                                    </tbody>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    附表3:主要污染物浓度同比变化（单位：μg/m³ ）
                                </label>
                            </th>
                            <td>
                                <table border="1" style=" min-height: 25px; line-height: 25px; text-align: center; border-color:black; border-collapse: collapse;">
                                    <tbody>
                                    <tr>
                                        <td style="width: 30%">污染物</td>
                                        <td style="width: 30%">本周平均浓度</td>
                                        <td style="width: 30%">成都市在全省排名（从高到低）</td>
                                    </tr>
                                    <tr>
                                        <td>O₃</td>
                                        <td><input type="text" v-model="report.o3"></td>
                                        <td><input type="text" v-model="report.rankingO3"></td>
                                    </tr>
                                    <tr>
                                        <td>PM₂.₅</td>
                                        <td><input type="text" v-model="report.pm25"></td>
                                        <td><input type="text" v-model="report.rankingPm25"></td>
                                    </tr>
                                    <tr>
                                        <td>PM₁₀</td>
                                        <td><input type="text" v-model="report.pm10"></td>
                                        <td><input type="text" v-model="report.rankingPm10"></td>
                                    </tr>
                                    <tr>
                                        <td>NO₂</td>
                                        <td><input type="text" v-model="report.no2"></td>
                                        <td><input type="text" v-model="report.rankingNo2"></td>
                                    </tr>
                                    <tr>
                                        <td>SO₂</td>
                                        <td><input type="text" v-model="report.so2"></td>
                                        <td><input type="text" v-model="report.rankingSo2"></td>
                                    </tr>
                                    <tr>
                                        <td>CO</td>
                                        <td><input type="text" v-model="report.co"></td>
                                        <td><input type="text" v-model="report.rankingCo"></td>
                                    </tr>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    现场图片一：
                                </label>
                            </th>
                            <td>
                                <li class="one-line">
                                    <span>
                                <image-upload-table
                                        key="preImageUploadTable"
                                        ref="preImageUploadTable"
                                        :ascription-id="report.reportId"
                                        :ascription-type="ascriptionType"
                                        :min-file-number="1"
                                        :max-file-number="1"
                                        :is-download="false"></image-upload-table>
                                    </span>
                                </li>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    现场图片二：
                                </label>
                            </th>
                            <td>
                                <li class="one-line">
                                    <span>
                                   <image-upload-table
                                           key="preImageUploadTable"
                                           ref="preImageUploadTable"
                                           :ascription-id="report.reportId"
                                           :ascription-type="ascriptionTypeTwo"
                                           :min-file-number="1"
                                           :max-file-number="1"
                                           :is-download="false"></image-upload-table>
                    </span>
                                </li>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    现场图片三：
                                </label>
                            </th>
                            <td>
                                <li class="one-line">
                                    <span>
                               <image-upload-table
                                       key="preImageUploadTable"
                                       ref="preImageUploadTable"
                                       :ascription-id="report.reportId"
                                       :ascription-type="ascriptionTypeThree"
                                       :min-file-number="1"
                                       :max-file-number="1"
                                       :is-download="false"></image-upload-table>
                    </span>
                                </li>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    现场图片四：
                                </label>
                            </th>
                            <td>
                                <li class="one-line">
                                    <span>
                    <image-upload-table
                            key="preImageUploadTable"
                            ref="preImageUploadTable"
                            :ascription-id="report.reportId"
                            :ascription-type="ascriptionTypeFour"
                            :min-file-number="1"
                            :max-file-number="1"
                            :is-download="false"></image-upload-table>
                    </span>
                                </li>
                            </td>
                        </tr>
                        <tr>
                            <th class="text-right">
                                <label class="col-sm-12 control-label no-padding-right">
                                    现场图片五：
                                </label>
                            </th>
                            <td>
                                <li class="one-line">
                                    <span>
                     <image-upload-table
                             key="preImageUploadTable"
                             ref="preImageUploadTable"
                             :ascription-id="report.reportId"
                             :ascription-type="ascriptionTypeFive"
                             :min-file-number="1"
                             :max-file-number="1"
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
<script type="text/javascript">
    // 地址，必须
    var ctx = "${ctx}";
    var reportId = "${reportId}"
</script>
<!-- vue插件 -->
<script type="text/javascript" src="${ctx}/assets/components/vue/vue.js?v=20221129015223"></script>
<!-- 引入组件库elementui -->
<script src="${ctx }/assets/components/element-ui/js/index.js?v=20221129015223"></script>
<!-- Dialog 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/dialog-util.js?v=20221129015223"></script>
<!-- Ajax 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/ajax-util.js?v=20221129015223"></script>
<!-- 日期时间 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/date-time-util.js?v=20221129015223"></script>
<%--<!-- 文件上传 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/file-upload-util.js?v=20221129015223"></script>--%>
<!-- 文件下载 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/file-download-util.js?v=20221129015223"></script>
<!-- 分析平台-文件上传表格组件-逻辑js -->
<script type="text/javascript" src="${ctx}/assets/custom/components/analysis/js/file-upload-table.js?v=20221129015223"></script>
<!-- 分析平台-文件上传表格组件-模板 -->
<script id="vue-template-file-upload-table" type="text/x-template">
    <%@ include file="/WEB-INF/jsp/components/analysis/file-upload-table.jsp" %>
</script>
<script type="text/javascript" src="${ctx}/assets/custom/components/viewer-master/dist/viewer.js?v=20221129015223"></script>

<!-- 图片上传器 -->
<%@ include file="/WEB-INF/jsp/components/common/image-upload-table.jsp" %>
<!-- 自定义js（逻辑js） -->

<script type="text/javascript" src="${ctx}/assets/custom/analysis/analysisreport/week/weekReportEdit.js?v=20221129015223"></script>
</body>
</html>
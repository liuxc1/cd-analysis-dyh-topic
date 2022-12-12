<%@ page language="java" contentType="text/html; charset=utf-8"
         pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>预报案例库添加</title>
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp" %>
    <link rel="stylesheet" href="${ctx }/assets/components/element-ui/css/index.css?v=20221129015223"/>
    <!-- 本页面的CSS -->
    <style type="text/css">
        .table th, .table td {
            text-align: center;
            vertical-align: middle !important;
        }
        .table-bordered>thead>tr>th, .table-bordered>thead>tr>td {
            border-bottom-width: 1px;
        }
    </style>
</head>
<body class="no-skin">
<div class="main-container" id="main-container" v-cloak>
    <div class="main-content">
        <div class="main-content-inner fixed-page-header fixed-40">
            <div id="breadcrumbs " class="breadcrumbs col-xs-12">
                <ul class="breadcrumb col-xs-8">
                    <li class="active">
                        <h5 class="page-title">
                            <i class="fa fa-plus"></i> 预报案例添加
                        </h5>
                    </li>
                </ul>
                <div class="col-xs-* text-right">
                    <div class="space-10 hidden-lg hidden-md hidden-sm"></div>
                    <button type="button" class="btn btn-info btn-default-ths" @click="save">
                        <i class="ace-icon fa fa-save"></i> 保存
                    </button>
                    <button type="button" class="btn btn-purple btn-default-ths"  @click="cancel()" id="btnExport">
                        <i class="ace-icon fa fa-reply"></i> 返回
                    </button>
                </div>
            </div>
        </div>
        <div class="main-content-inner padding-page-content">
            <div class="page-content">
                <div class="space-4"></div>
                <div class="row">
                    <div class="col-xs-12">
                        <form class="form-horizontal" role="form" id="formList"  method="post">
                            <div class="form-group">
                                <label class="col-xs-1 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i> 开始时间：
                                </label>
                                <div class="col-xs-3">
                                    <div class="input-group" @click="distributeTimeStart">
                                        <input type="text" class="form-control" data-validation-engine="validate[required]"  id="distributeTimeStart" readonly="readonly" placeholder="请选择接收时间">
                                        <span class="input-group-btn">
                                             <button type="button" class="btn btn-white btn-default">
                                                 <i class="ace-icon fa fa-calendar"></i>
                                             </button>
                                        </span>
                                    </div>
                                </div>
                                <label class="col-xs-1 control-label">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>结束时间：
                                </label>
                                <div class="col-xs-3">
                                    <div class="input-group" @click="distributeTimeEnd">
                                        <input type="text" class="form-control" data-validation-engine="validate[required]" id="distributeTimeEnd"  readonly="readonly" placeholder="请选择结束时间">
                                        <span class="input-group-btn">
                                            <button type="button" class="btn btn-white btn-default">
                                                <i class="ace-icon fa fa-calendar"></i>
                                            </button>
                                         </span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-xs-1 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>天气类型：
                                </label>
                                <div class="col-xs-3 hidden-xs">
                                    <select data-validation-engine="validate[required]" v-model="param.weatherCode" class="form-control">
                                        <option value="">--请选择--</option>
                                        <option  v-for="item in weatherTypeList" :key="item.DICTIONARY_ID" :value="item.DICTIONARY_CODE">{{item.DICTIONARY_NAME}}</option>
                                    </select>
                                </div>
                                <label class="col-xs-1 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>污染物类型：
                                </label>
                                <div class="col-xs-3 hidden-xs">
                                    <select  v-model="param.polluteCode" class="form-control" data-validation-engine="validate[required]">
                                        <option value="">--请选择--</option>
                                        <option  v-for="item in pollutantList" :key="item.DICTIONARY_ID" :value="item.DICTIONARY_CODE">{{item.DICTIONARY_NAME}}</option>
                                    </select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-12 col-md-12" style="margin-top: 20px">
                                    <table id="listTable" class="table table-bordered table-hover">
                                        <thead>
                                        <tr>
                                            <th rowspan="2">污染天数(天)</th>
                                            <th colspan="2">最大浓度</th>
                                            <th colspan="6">平均浓度</th>
                                            <th colspan="4">气象要素</th>
                                        </tr>
                                        <tr>
                                            <th>PM<sub>2.5</sub>(μg/m³)</th>
                                            <th>O<sub>3</sub>(μg/m³)</th>
                                            <th>PM<sub>2.5</sub>(μg/m³)</th>
                                            <th>PM<sub>10</sub>(μg/m³)</th>
                                            <th>SO<sub>2</sub>(μg/m³)</th>
                                            <th>NO<sub>2</sub>(μg/m³)</th>
                                            <th>CO(mg/m³)</th>
                                            <th>O<sub>3</sub>(μg/m³)</th>
                                            <th>平均气温(℃)</th>
                                            <th>降水量(mm)</th>
                                            <th>平均风速(m/s)</th>
                                            <th>静风频率(%)</th>
                                        </tr>
                                        </thead>
                                        <tbody v-if="dataList!=null && dataList.length>0">
                                        <tr v-for="item in dataList">
                                            <td>{{item.POLLUTE_NUM}}</td>
                                            <td>{{item.MAX_PM25}}</td>
                                            <td>{{item.MAX_O3}}</td>
                                            <td>{{item.AVG_PM25}}</td>
                                            <td>{{item.AVG_PM10}}</td>
                                            <td>{{item.AVG_SO2}}</td>
                                            <td>{{item.AVG_NO2}}</td>
                                            <td>{{item.AVG_CO}}</td>
                                            <td>{{item.AVG_O3}}</td>
                                            <td>{{item.AVG_TEMPERATURE}}</td>
                                            <td>{{item.AVG_RAINFALL}}</td>
                                            <td>{{item.AVG_WIND_SPEED}}</td>
                                            <td>{{item.PL}}</td>
                                        </tr>
                                        </tbody>
                                        <tbody v-else>
                                        <tr>
                                            <td class="text-center" colspan="13">暂无数据！</td>
                                        </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <!--/.main-content-inner-->
    </div>
    <!-- /.main-content -->
</div>
<script type="text/javascript" src="${ctx}/assets/js/eform/eform_custom.js?v=20221129015223"></script>
<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp" %>
<script type="text/javascript">
    // 地址，必须
    var ctx = "${ctx}";
</script>
<script src="${ctx}/assets/components/jQuery-Validation-Engine/jquery.validationEngine-zh_CN.js?v=20221129015223" type="text/javascript"></script>
<script src="${ctx}/assets/components/jQuery-Validation-Engine/jquery.validationEngine.js?v=20221129015223" type="text/javascript"></script>
<script src="${ctx}/assets/components/artDialog/dist/dialog-plus.js?v=20221129015223"></script>
<script src="${ctx}/assets/components/element-ui/js/index.js?v=20221129015223"></script>
<!-- 自己写的JS，请放在这里 -->
<script src="${ctx}/assets/custom/analysis/forecastcastlibrary/add.js?v=20221129015223"></script>
</body>
</html>
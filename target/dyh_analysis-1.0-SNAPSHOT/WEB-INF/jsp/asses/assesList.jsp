<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>后评估</title>
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp" %>
    <link href="${ctx }/assets/custom/components/analysis/css/time-axis.css?v=20221129015223" rel="stylesheet"/>
</head>

<body class="no-skin">
<div class="main-container" id="main-container" v-cloak>
    <div class="main-content">
        <div class="main-content-inner fixed-page-header fixed-40">
            <div id="breadcrumbs" class="breadcrumbs">
                <ul class="breadcrumb">
                    <li class="active">
                        <h5 class="page-title">
                            <i class="header-icon fa" :class="type == 2?'fa-cubes':'fa-tasks'"></i>
                            {{type==2?'后评估':'预评估'}}
                        </h5>
                    </li>
                </ul>
            </div>
        </div>
        <div class="main-content-inner">
            <div class="page-content">
                <form id="mainForm" class="form-horizontal" role="form" id="formList" method="post">
                    <label class="col-xs-1 control-label no-padding-right">
                        模拟起始日期：
                    </label>
                    <div class="col-xs-5">
                        <div class="col-xs-5">
                            <div class="input-group" @click="forecastTimeStart">
                                <input type="text" class="form-control" :value="queryParams.startTime"
                                       id="forecastTimeStart" readonly="readonly" placeholder="请选择">
                                <span class="input-group-btn">
                                                 <button type="button" class="btn btn-white btn-default">
                                                     <i class="ace-icon fa fa-calendar"></i>
                                                 </button>
                                             </span>
                            </div>
                        </div>
                        <label class="col-xs-1 control-label  no-padding-right"
                               style="text-align: center ;padding-left: 0px">至</label>
                        <div class="col-xs-5">
                            <div class="input-group" @click="forecastTimeEnd">
                                <input type="text" class="form-control" :value="queryParams.endTime"
                                       id="forecastTimeEnd" readonly="readonly" placeholder="请选择">
                                <span class="input-group-btn">
                                                 <button type="button" class="btn btn-white btn-default">
                                                     <i class="ace-icon fa fa-calendar"></i>
                                                 </button>
                                             </span>
                            </div>
                        </div>
                    </div>

                    <div class="form-group col-xs-* align-right">
                        <button type="button" class="btn btn-info btn-default-ths"  @click="doSearch">
                            <i class="ace-icon fa fa-search"></i>
                            搜索
                        </button>
                    </div>
                    <template v-if="type==2">
                        <div class="col-xs-12 align-right">
                            <div class=" form-group col-sm-12 col-lg-12">
                                <button type="button" class="btn btn-xs btn-inverse btn-xs-ths" id="btnAdd"
                                        @click="toAdd('')">
                                    <i class="ace-icon fa fa-plus"></i>
                                    添加
                                </button>
                                <button type="button" class=" btn btn-xs btn-danger btn-xs-ths" @click="bachDelete">
                                    <i class="ace-icon fa fa-trash-o"></i>
                                    删除
                                </button>
                            </div>
                        </div>
                    </template>
                    <hr class="no-margin">
                    <div class="col-xs-12 ">
                        <div class="col-xs-12 ">
                            <table class="table table-bordered table-hover" id="listTable">
                                <thead>
                                <tr>
                                    <th class="center">
                                        <label class="pos-rel">
                                            <input type="checkbox" class="ace" v-model="globalStatus.checkedAll"
                                                   @change="checkTableData()"/>
                                            <span class="lbl"></span>
                                        </label>
                                    </th>
                                    <th class="align-center">方案名称</th>
                                    <th class="align-center"  >模拟起始日期</th>
                                    <th class="align-center"  >模拟截止日期</th>
                                    <th class="align-center" >创建时间</th>
                                    <th class="align-center" >备注</th>
                                    <th class="align-center">操作</th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr v-for="(item,index) in forecastPage.list">
                                    <td class="center">
                                        <label class="pos-rel">
                                            <input type="checkbox" id="asses-checkbox" class="ace" v-model="item.checked"
                                                   @change="checkTableData(item)"/>
                                            <span class="lbl"></span>
                                        </label>
                                    </td>
                                    <td class="align-left"  width="20%">{{item.assessName | resultFormat}}</td>
                                    <td class="align-center"  width="10%"> {{item.date | startDateFormat}}</td>
                                    <td class="align-center"  width="10%"> {{item.date | endDateFormat}}</td>
                                    <td class="align-center"  width="15%" > {{item.createTime | resultFormat}}</td>
                                    <td class="align-left"  width="30%">{{item.remark | resultFormat}}</td>
                                    <td class="align-center">
                                        <template v-if="type==2">
                                            <button type="button" @click="toAdd(item.pkid)" class="btn btn-sm btn-info  btn-op-ths" title="编辑">
                                                <i class="ace-icon fa fa-edit"></i>
                                            </button>
                                            <button type="button"  @click="deleteMain(item.pkid)" class="btn btn-sm btn-info  btn-op-ths" title="删除">
                                                <i class="ace-icon fa fa-trash-o"></i>
                                            </button>
                                        </template>
                                        <button type="button"  @click="toShow(item)" class="btn btn-sm btn-info  btn-op-ths" title="查看">
                                            <i class="ace-icon fa fa-eye"></i>
                                        </button>
                                    </td>
                                </tr>
                                <tr v-if="forecastPage.list.length===0">
                                    <td colspan="6" class="text-center">暂无数据</td>
                                </tr>
                                </tbody>
                            </table>
                            <my-pagination @handlecurrentchange="doSearch()" :tableobj="forecastPage"></my-pagination>
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
    var type = '<%=request.getParameter("type")%>';
    jQuery(function($){
        //初始化表格的事件，如表头排序，列操作等
        __doInitTableEvent("listTable");
    });
</script>
<!-- 分页组件 -->
<%@ include file="/WEB-INF/jsp/components/common/page-pagination.jsp" %>
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

<script type="text/javascript" src="${ctx }/assets/custom/common/vueplus/axios.js?v=20221129015223"></script>
<script type="text/javascript" src="${ctx}/assets/custom/common/vueplus/http.js?v=20221129015223"></script>
<script type="text/javascript" src="${ctx}/assets/custom/asses/js/assesList.js?v=20221129015223"></script>
</body>
</html>
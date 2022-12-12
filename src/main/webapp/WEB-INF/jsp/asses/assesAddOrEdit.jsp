<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>后分析</title>
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp" %>
    <link href="${ctx }/assets/custom/components/analysis/css/file-upload-table.css" rel="stylesheet"/>
    <!-- 引入样式 -->
    <link href="${ctx }/assets/custom/common/vueplus/index.css" rel="stylesheet"/>
</head>
<style>
    .self-float-left {
        float: left !important;
        padding-top: 1rem;
    }

    .add-bottom {
        border: 1px solid #d6cbcb;
        margin-left: 0.5rem;
        padding: 0.3rem;
        margin-top: 0.2rem;
    }

    .my-td {
        padding: unset !important;
    }

    .my-clonmd {
        width: 20%;
        float: left;
        height: 3.3rem;
        padding: 0.5rem;
        text-align: center;
    }

    .my-right-solid {
        border-right: 1px solid #efefef;
    }
</style>
<body class="no-skin">
<div class="main-container" id="main-container" v-cloak>


    <div class="main-content-inner fixed-page-header fixed-40">
        <div id="breadcrumbs" class="breadcrumbs">
            <ul class="breadcrumb">
                <li class="active">
                    <h5 class="page-title">
                        <i class="header-icon fa fa-edit"></i>
                        {{type==2?'后评估':'预评估'}}-{{params.id?'编辑':'添加'}}
                    </h5>
                </li>
            </ul>
            <div class="align-right" style="float: right; padding-right: 5px;">
                <button type="button" class="btn btn-xs btn-xs-ths" @click="saveData('UPLOAD')">
                    <i class="ace-icon fa fa-upload"></i> 提交
                </button>
                <button type="button" class="btn btn-xs btn-xs-ths btn-danger" @click="goBack">
                    <i class="ace-icon fa fa-reply"></i> 返回
                </button>
            </div>
        </div>
    </div>
    <div class="main-content-inner padding-page-content">
        <div class="main-content">
            <%--            方案名称--%>
            <div class="space-4"></div>
            <div class="page-content">
                <form class="form-horizontal" action="#" id="mainForm">
                    <div class="form-group">
                        <label class="col-sm-1 control-label no-padding-right">
                            <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                            方案名称:
                        </label>
                        <div class="col-xs-3">
                                <span class="input-icon width-100">
                                        <input type="text" class="form-control"
                                               data-validation-engine="validate[required,maxSize[10]]" placeholder="10个汉字以内" maxlength="10"
                                               v-model="params.name">
                                   </span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-1 control-label no-padding-right">
                            <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                            模拟日期:
                        </label>
                        <div class="col-xs-3">
                            <div class="input-group" @click="wdatePicker1('txtDate')">
                                <input type="text" class="form-control" data-validation-engine="validate[required]"
                                       placeholder="请选择模拟开始日期" id="txtDate" readonly="readonly"
                                       v-model="params.startTime">
                                <span class="input-group-btn">
                                        <button type="button" class="btn btn-white btn-default">
                                            <i class="ace-icon fa fa-calendar"></i>
                                        </button>
                                    </span>
                            </div>
                        </div>
                        <div class="self-float-left text-center">至</div>
                        <div class="col-xs-3">
                            <div class="input-group" @click="wdatePicker1('txtDate2')">
                                <input type="text" class="form-control" data-validation-engine="validate[required]"
                                       placeholder="请选择模拟结束日期" id="txtDate2" readonly="readonly"
                                       v-model="params.endTime">
                                <span class="input-group-btn">
                                        <button type="button" class="btn btn-white btn-default">
                                            <i class="ace-icon fa fa-calendar"></i>
                                        </button>
                                    </span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-1 control-label no-padding-right">
                            备注:
                        </label>
                        <div class="col-xs-3">
                              <textarea v-model="params.remarks" class="form-control"
                                        placeholder="请输入重要提示(最多200字)"
                                        data-validation-engine="validate[maxSize[200]]"
                                        maxlength="200"></textarea>
                        </div>
                    </div>
                    <%--                切换场景--%>
                    <div class="form-group">
                        <ul id="tabSet" class="nav nav-tabs">
                            <li :class="{active:item.active}" v-for="(item,index) in tabList" :key="index"
                                @click="changeTable(item,index)">
                                <a href="#zj-assess" data-toggle="tab" style="width: 120px; height: 3.5rem;">
                                    <p style="width:80%;overflow: hidden; white-space: nowrap;text-overflow: ellipsis;float: left">
                                        {{item.name}}</p>
                                    <div style="float: right;margin-left: 0.5rem;">
                                        <i class="fa fa-trash fa-lg" @click.s="delScenario(item,index)"
                                           :style="{visibility:item.active?'hidden':''}"> </i>
                                    </div>
                                </a>

                            </li>
                            <li @click="addTable">
                                <div class="add-bottom">
                                    <i class="ace-icon fa fa-plus"></i>
                                </div>
                            </li>
                        </ul>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-1 control-label no-padding-right">
                            <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                            场景名称:
                        </label>
                        <div class="col-xs-3">
                            <input type="text" v-model="tabList[tabIndex].name"
                                   data-validation-engine="validate[required]"   placeholder="最多20字" maxlength="20">
                        </div>
                    </div>
                    <%--              污染物减排信息      --%>
                    <div class="form-group">
                        <label class="col-sm-1 control-label no-padding-right">
                            <span style="font-weight: 600;color: #118fe8;">污染物减排信息>></span>
                        </label>
                        <div class="col-xs-11 align-right">
                            <button type="button" class="btn btn-xs btn-xs-ths" @click="excel('IMPORT')">
                                <i class="ace-icon fa fa-folder-open"></i> 导入
                            </button>
                            <button type="button" v-show="params.id " class="btn btn-xs btn-xs-ths"
                                    @click="excel('EXPORT')">
                                <i class="ace-icon fa fa-download"></i> 导出
                            </button>
                            <button type="button" class="btn btn-xs btn-xs-ths" @click="excel('TEMPLATE')">
                                <i class="ace-icon fa  fa-file-excel-o"></i> 下载模板
                            </button>
                        </div>
                    </div>
                    <div class="col-xs-12" style="overflow-x: auto">
                        <table class="table table-bordered" style="min-width: 1820px">
                        <tbody>
                        <tr>
                            <td rowspan="2"></td>
                            <td colspan="5" class="align-center">红色预警减排量(吨)</td>
                            <td colspan="5" class="align-center">橙色预警减排量(吨)</td>
                            <td colspan="5" class="align-center">黄色预警减排量(吨)</td>
                            <td colspan="5" class="align-center">红色预警减排比例(%)</td>
                            <td colspan="5" class="align-center">橙色预警减排比例(%)</td>
                            <td colspan="5" class="align-center">黄色预警减排比例(%)</td>
                        </tr>
                        <tr>
                            <td width="3%" class="align-center">PM<sub>10</sub></td>
                            <td width="3%" class="align-center">PM<sub>2.5</sub></td>
                            <td width="3%" class="align-center">SO<sub>2</sub></td>
                            <td width="3%" class="align-center">NOx</td>
                            <td width="3%" class="align-center">VOC</td>

                            <td width="3%" class="align-center">PM<sub>10</sub></td>
                            <td width="3%" class="align-center">PM<sub>2.5</sub></td>
                            <td width="3%" class="align-center">SO<sub>2</sub></td>
                            <td width="3%" class="align-center">NOx</td>
                            <td width="3%" class="align-center">VOC</td>

                            <td width="3%" class="align-center">PM<sub>10</sub></td>
                            <td width="3%" class="align-center">PM<sub>2.5</sub></td>
                            <td width="3%" class="align-center">SO<sub>2</sub></td>
                            <td width="3%" class="align-center">NOx</td>
                            <td width="3%" class="align-center">VOC</td>

                            <td width="3%" class="align-center">PM<sub>10</sub></td>
                            <td width="3%" class="align-center">PM<sub>2.5</sub></td>
                            <td width="3%" class="align-center">SO<sub>2</sub></td>
                            <td width="3%" class="align-center">NOx</td>
                            <td width="3%" class="align-center">VOC</td>

                            <td width="3%" class="align-center">PM<sub>10</sub></td>
                            <td width="3%" class="align-center">PM<sub>2.5</sub></td>
                            <td width="3%" class="align-center">SO<sub>2</sub></td>
                            <td width="3%" class="align-center">NOx</td>
                            <td width="3%" class="align-center">VOC</td>

                            <td width="3%" class="align-center">PM<sub>10</sub></td>
                            <td width="3%" class="align-center">PM<sub>2.5</sub></td>
                            <td width="3%" class="align-center">SO<sub>2</sub></td>
                            <td width="3%" class="align-center">NOx</td>
                            <td width="3%" class="align-center">VOC</td>
                        </tr>
                        <tr>

                            <td class="align-left">建筑扬尘减排</td>
                            <td class="my-td" colspan="5" v-for="(item,index) in filterTableListForPollution(1)">
                                <div class="my-clonmd" v-for="(val,index1) in item.list" :key="index1"
                                     :class="index1<item.list.length-1?'my-right-solid':''">
                                    <input style="width: 5rem;border: none;text-align: center;"
                                           data-validation-engine="validate[custom[number]]"
                                           v-model="item.list[index1]"
                                           maxlength="10">
                                </div>
                            </td>
                            </td>
                        </tr>
                        <tr>
                            <td class="align-left">工业减排</td>
                            <td class="my-td" colspan="5" v-for="(item,index) in filterTableListForPollution(2)">
                                <div v-for="(val,index1) in item.list" class="my-clonmd"
                                     :class="index1<item.list.length-1?'my-right-solid':''">
                                    <%--{{item.list[index1]}}--%>
                                    <input style="width: 5rem;border: none;text-align: center;"
                                           data-validation-engine="validate[custom[number]]"
                                           v-model="item.list[index1]"
                                           maxlength="10">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="align-left">机动车减排</td>
                            <td class="my-td" colspan="5" v-for="(item,index) in filterTableListForPollution(3)">
                                <div class="my-clonmd" v-for="(val,index1) in item.list" :key="index1"
                                     :class="index1<item.list.length-1?'my-right-solid':''">
                                    <input style="width: 5rem;border: none;text-align: center;"
                                           data-validation-engine="validate[custom[number]]"
                                           v-model="item.list[index1]"
                                           maxlength="10">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="align-left">其它减排</td>
                            <td class="my-td" colspan="5" v-for="(item,index) in filterTableListForPollution(4)">
                                <div class="my-clonmd" v-for="(val,index1) in item.list" :key="index1"
                                     :class="index1<item.list.length-1?'my-right-solid':''">
                                    <input style="width: 5rem;border: none;text-align: center;"
                                           data-validation-engine="validate[custom[number]]"
                                           v-model="item.list[index1]"
                                           maxlength="10">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="align-left">全社会减排</td>
                            <td class="my-td" colspan="5" v-for="(item,index) in filterTableListForPollution(6)">
                                <div class="my-clonmd" v-for="(val,index1) in item.list" :key="index1"
                                     :class="index1<item.list.length-1?'my-right-solid':''">
                                    <input style="width: 5rem;border: none;text-align: center;"
                                           data-validation-engine="validate[custom[number]]"
                                           v-model="item.list[index1]"
                                           maxlength="10">
                                </div>
                            </td>
                        </tr>
                    </table>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-1 control-label no-padding-right">
                            <span style="font-weight: 600;color: #118fe8;">质量改善信息>></span>
                        </label>
                    </div>
                    <div class="col-xs-12" style="overflow-x: auto">
                        <table class="table table-bordered" style="min-width: 1820px">
                            <tr>
                                <td rowspan="2" style="min-width: 100px;"></td>
                                <td colspan="15" class="align-center">消减浓度(ug/m³)</td>
                                <td colspan="15" class="align-center">消减比列(%)</td>
                            </tr>
                            <tr>
                                <td colspan="5" class="align-center">红色预警</td>
                                <td colspan="5" class="align-center">橙色预警</td>
                                <td colspan="5" class="align-center">黄色预警</td>

                                <td colspan="5" class="align-center">红色预警</td>
                                <td colspan="5" class="align-center">橙色预警</td>
                                <td colspan="5" class="align-center">黄色预警</td>
                            </tr>
                            <tr>
                                <td>PM10</td>
                                <td colspan="5" v-for="(item,index) in  filterTableListForQuality(1)" :key="index" class="align-center">
                                    <input style="width: 25rem;border: none;text-align: center;"
                                           data-validation-engine="validate[custom[number]]"
                                           v-model="item.list[0]"
                                           maxlength="10">
                                </td>
                            </tr>
                            <tr>
                                <td>PM2.5</td>
                                <td colspan="5" v-for="(item,index) in filterTableListForQuality(2)" :key="index" class="align-center">
                                    <input style="width: 25rem;border: none;text-align: center;"
                                           data-validation-engine="validate[custom[number]]"
                                           v-model="item.list[0]"
                                           maxlength="10">
                                </td>
                            </tr>
                            <tr>
                                <td>NO2</td>
                                <td colspan="5" v-for="(item,index) in filterTableListForQuality(3)" :key="index" class="align-center">
                                    <input style="width: 25rem;border: none;text-align: center;" v-model="item.list[0]"
                                           maxlength="10">                            </td>
                            </tr>
                        </table>
                    </div>

                </form>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    // 地址，必须
    var ctx = "${ctx}";
    var reportId = "${reportId}"
    var id = "${id}"
    var type = '<%=request.getParameter("type")%>';
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
<!-- 引入组件库 -->
<script type="text/javascript" src="${ctx }/assets/custom/common/vueplus/qs.js"></script>
<script type="text/javascript" src="${ctx }/assets/custom/common/vueplus/axios.js"></script>
<script type="text/javascript" src="${ctx }/assets/custom/common/vueplus/http.js"></script>
<script type="text/javascript" src="${ctx }/assets/custom/common/vueplus/xlsx.js"></script>

<script type="text/javascript" src="${ctx}/assets/custom/asses/js/afterAssesAddOrEdit.js"></script>
</body>
</html>
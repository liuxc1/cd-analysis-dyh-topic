<%--
  Created by IntelliJ IDEA.
  User: ZT
  Date: 2021/9/29
  Time: 10:24
  To change this template use File | Settings | File Templates.
--%>
<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp" %>
<html>
<head>
    <title>会商首页</title>
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp" %>
    <link href="../../assets/components/element-ui/lib/theme-chalk/index.css?v=20221129015223" rel="stylesheet" type="text/css">
    <style>
        .main-container:before {
            background-color:#00000000;
        }
        body {
            background-color:#00000000;
        }
        .breadcrumbs {
            background-color: #00000000;
            min-height: 40px;
            border-bottom: none;
        }
        .breadcrumbs .page-title {
            color: #ffffff;
        }
        .no-skin .btn, .no-skin .ui-dialog button, .no-skin .btn1 {
            color: #ffffff !important;
            background-color: #00000000 !important;
        }
        .table {
            background-color: #027db4 !important;
        }
        .no-skin table thead tr:last-child {
            border-bottom: 3px #030e44 solid;
        }
        .table.table-bordered > thead > tr > th:first-child {
            border-left-color: #030e44;
        }
        .table>thead>tr>th:last-child {
            border-right-color: #030e44;
        }
        .table-bordered {
            border: 1px solid #030e44;
        }
        .table-bordered > thead > tr > th, .table-bordered > tbody > tr > th, .table-bordered > tfoot > tr > th, .table-bordered > thead > tr > td, .table-bordered > tbody > tr > td, .table-bordered > tfoot > tr > td {
            border: 1px solid #030e44;
            color: #ffffff;
        }
        .el-pagination .btn-next, .el-pagination .btn-prev {
            background: center center no-repeat #00000000;
            background-size: 16px;
            cursor: pointer;
            margin: 0;
            color: #ffffff;
        }
        .el-dialog, .el-pager li {
            background: #00000000;
            -webkit-box-sizing: border-box;
        }
        .el-pagination button:disabled {
            color: #ffffff;
            background-color: #00000000;
            cursor: not-allowed;
        }
        .el-pagination {
            white-space: nowrap;
            padding: 2px 5px;
            color: #ffffff;
            font-weight: 700;
        }
        .el-pager li.active {
            color: #ffffff;
            cursor: default;
            background: #409EFF;
        }
        .el-form-item__label {
            color: #ffffff;
        }
        .el-form-item {
            margin: 0px;
        }
        form {
            display: block;
            margin-top: 0em;
            margin-block-end: 0em;
        }
        table { table-layout: fixed;}
        td{
            white-space: nowrap; /*文本不会换行，在同一行显示*/
            overflow: hidden; /*超出隐藏 */
            text-overflow: ellipsis; /*省略号显示*/
            -o-text-overflow: ellipsis;
            -moz-text-overflow: ellipsis;
            -webkit-text-overflow: ellipsis;
        }


    </style>
</head>
<body>
<div class="main-container" id="main-container" style="background-color: #0d1948 !important;">
    <div class="main-content">
        <div class="main-content-inner">
            <div class=" fixed-page-header fixed-40">
                <div id="breadcrumbs" class="breadcrumbs">
                    <ul class="breadcrumb">
                        <li class="active">
                            <h5 class="page-title">
                                计划会商
                            </h5>
                        </li>
                    </ul>
                    <div class="btn-toolbar pull-right" role="toolbar" style="padding: 10px 10px">
                        <button type="button" class="btn btn-xs btn-xs-ths " @click="addPlan">
                            <i class="ace-icon fa fa-plus"></i>
                            新增会商计划
                        </button>
                    </div>
                </div>

            </div>
            <div class="main-content-inner padding-page-content">
                <div class="col-xs-12">
                    <table  class="table table-bordered">
                        <thead>
                        <tr style="background-color: #0a8bea">
                            <th class="center">
                                时间
                            </th>
                            <th class="center">
                                主题
                            </th>
                            <th class="center">
                                部门
                            </th>
                            <th class="center">
                                状态
                            </th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr v-for="(item,index) in firstTable.list">
                            <td :title="item.CONSULT_TIME">
                                {{item.CONSULT_TIME}}
                            </td>
                            <td :title="item.CONSULT_THEME">
                                <a @click="editPlan(item.PKID,item.CONSULT_STATUS)" style="color: #ffffff">{{item.CONSULT_THEME}}</a>
                            </td>
                            <td :title="item.CONSULT_DEPT_NAMES">
                                {{item.CONSULT_DEPT_NAMES}}
                            </td>
                            <td :title="item.CONSULT_STATUS|status">
                                {{item.CONSULT_STATUS|status}}
                            </td>
                        </tr>
                        <tr v-if="firstTable.list.length==0"><td class="center" colspan="4">暂无记录</td></tr>
                        </tbody>
                    </table>
                    <el-row style="padding: 10px 0;text-align: center">
                        <el-pagination
                                small
                                @current-change="listFirstTable"
                                layout="prev, pager, next"
                                :total="firstTable.total" :page-size="5">
                        </el-pagination>
                    </el-row>
                </div>
                <div class="col-xs-12">
                    <h5 style="color: #ffffff;padding: 10px">历史会商记录</h5>
                </div>
                <div class="col-xs-12 no-padding" style="color: #ffffff;">
                    <el-form label-width="80px" class="demo-ruleForm">
                        <el-form-item label="会商时间">
                            <el-col :span="10">
                                <el-date-picker type="date"
                                                v-model="params.startTime"
                                                placeholder="开始日期"
                                                value-format="yyyy-MM-dd"
                                                size="small"
                                                @change="listSecondTable(1)"
                                                format="yyyy-MM-dd" style="width: 100%;">

                                </el-date-picker>
                            </el-col>
                            <el-col :span="2" style="text-align: center">
                                至
                            </el-col>
                            <el-col :span="10">
                                <el-date-picker type="date"
                                                v-model="params.endTime"
                                                placeholder="结束日期"
                                                value-format="yyyy-MM-dd"
                                                size="small"
                                                @change="listSecondTable(1)"
                                                format="yyyy-MM-dd" style="width: 100%;">

                                </el-date-picker>
                            </el-col>
                        </el-form-item>
                    </el-form>
                </div>
                <div class="col-xs-12">
                    <table  class="table table-bordered">
                        <thead>
                        <tr style="background-color: #0a8bea">
                            <th class="center">
                                时间
                            </th>
                            <th class="center">
                                会商类型
                            </th>
                            <th class="center">
                                主题
                            </th>
                            <th class="center">
                                下达措施
                            </th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr v-for="(item,index) in secondTable.list">
                            <td :title="item.CONSULT_TIME">
                                {{item.CONSULT_TIME}}
                            </td>
                            <td :title="item.CONSULT_TYPE_NAME">
                                {{item.CONSULT_TYPE_NAME}}
                            </td>
                            <td :title="item.CONSULT_THEME">
                                <a @click="showRecord(item.PKID)" style="color: #ffffff">{{item.CONSULT_THEME}}</a>
                            </td>
                            <td title="措施">
                                措施
                            </td>
                        </tr>
                        <tr v-if="secondTable.list.length==0"><td class="center" colspan="4">暂无记录</td></tr>
                        </tbody>
                    </table>
                    <el-row style="padding: 10px 0;text-align: center">
                        <el-pagination
                                small
                                @current-change="listSecondTable"
                                layout="prev, pager, next"
                                :total="secondTable.total">
                        </el-pagination>
                    </el-row>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp" %>
<script type="text/javascript" src="../../assets/components/element-ui/index.js?v=20221129015223"></script>
<script>
    let vue = new Vue({
        el: '#main-container',
        data:{
            firstTable:{
                list:[]
            },
            secondTable:{
                list:[]
            },
            params:{
                startTime:'',
                endTime:'',
            }
        },
        mounted:function(){
            this.listFirstTable();
            this.listSecondTable();
        },
        filters:{
            status:function(value){
                if(value === '0'){
                    return '暂存';
                }else if(value === '1'){
                    return '未开始';
                }else if(value === '2'){
                    return '会商中';
                }else if(value === '3'){
                    return '已结束';
                }

            }
        },
        methods:{
            listFirstTable:function(pageNum){
                let _this = this;
                let params = {
                    CONSULT_STATUS:'first',
                    pageSize:5,
                    pageNum:pageNum
                }
                $.post("listConsultationInfo.vm",params,function (datas) {
                    if(datas.success){
                        _this.firstTable =datas.data;
                    }
                },'json')
            },
            listSecondTable:function(pageNum){
                let _this = this;
                let params = {
                    CONSULT_STATUS:'second',
                    pageNum:pageNum,
                    START_TIME:_this.params.startTime,
                    END_TIME:_this.params.endTime,
                }
                $.post("listConsultationInfo.vm",params,function (datas) {
                    if(datas.success){
                        _this.secondTable =datas.data;
                    }
                },'json')
            },
            addPlan:function(){
                window.open('editIndex.vm');
            },
            editPlan:function(id,status){
                if(status==='0'){
                    window.open('editIndex.vm?PKID='+id);
                }else{
                    window.open('showInfo.vm?PKID='+id);
                }
            },
            showRecord:function(id){
                window.open('showInfo.vm?PKID='+id);
            }
        }
    })
</script>
</html>

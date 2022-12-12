<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>报告管理</title>
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp" %>
</head>
<body class="no-skin">
<div class="main-container" id="main-container" v-cloak>
    <div class="main-content-inner fixed-page-header fixed-40">
        <div id="breadcrumbs" class="breadcrumbs">
            <ul class="breadcrumb">
                <li class="active">
                    <h5 class="page-title">
                        <i class="header-icon fa fa-list"></i>
                        {{menuName}}-列表
                    </h5>
                </li>
            </ul>
            <div class="align-right" style="float: right; padding-right: 5px;">
                <button type="button" class="btn btn-xs btn-xs-ths btn-danger" @click="cancel(true)">
                    <i class="ace-icon fa fa-reply"></i> 返回
                </button>
            </div>
        </div>
    </div>
    <div class="main-content-inner padding-page-content">
        <div class="main-content">
            <div class="page-content">
                <div class="col-xs-12 no-padding">
                    <label class="col-xs-1" style="height: 34px;line-height: 34px;text-align: right">日期：</label>
                    <div class="col-xs-2 ">
                        <div class="input-group" @click="queryStartTime">
                            <input type="text" id="queryStartTime" v-model="param.startTime" class="form-control"
                                   placeholder="请选择报告开始日期" readonly>
                            <span class="input-group-btn">
											<button type="button" class="btn btn-white btn-default">
												<i class="ace-icon fa fa-calendar"></i>
											</button>
										</span>
                        </div>
                    </div>
                    <label class="col-xs-1"
                           style="height: 34px;width: 20px;padding-left: 0px;line-height: 34px">至</label>
                    <div class="col-xs-2 ">
                        <div class="input-group" @click="queryEndTime">
                            <input type="text" id="queryEndTime" v-model="param.endTime" class="form-control"
                                   placeholder="请选择报告结束日期" readonly>
                            <span class="input-group-btn">
											<button type="button" class="btn btn-white btn-default">
												<i class="ace-icon fa fa-calendar"></i>
											</button>
										</span>
                        </div>
                    </div>
                    <template v-if="isSmallType==1">
                        <div class="col-xs-1" style="height: 34px;line-height: 34px;text-align: right">
                            小类：
                        </div>
                        <div class="col-xs-2">
                            <div class="form-group">
                                <select class="form-control" v-model="param.samllType">
                                    <option value="">-全部-</option>
                                    <option v-for="item in samllTypes" :value="item.samllType">{{item.samllType}}
                                    </option>
                                </select>
                            </div>
                        </div>
                    </template>
                    <div class="sol-xs-3 align-right form-group">
                        <button type="button" class="btn btn-info btn-default-ths" @click="doSearch">
                            <i class="ace-icon fa fa-search"></i>
                            查询
                        </button>
                    </div>
                </div>
                <div class="col-xs-12 align-right">
                    <div class=" form-group col-sm-12 col-lg-12" style="margin-bottom: 0px">
                        <button type="button" class="btn btn-xs btn-inverse btn-xs-ths" id="btnAdd"
                                @click="toAdd('')">
                            <i class="ace-icon fa fa-plus"></i>
                            添加
                        </button>
                    </div>
                </div>
                <div class="col-xs-12 form-group">
                    <div class="col-xs-12 ">
                        <table class="table table-bordered">
                            <thead>
                            <tr>
                                <th style="text-align: center;width: 150px">日期</th>
                                <th style="text-align: center;width: 200px">名称</th>
                                <th style="text-align: center;width: 200px" v-if="isSmallType==1">小类</th>
                                <th style="text-align: center;">重要提示</th>
                                <th style="text-align: center;width: 150px">创建人</th>
                                <th style="text-align: center;width: 200px">创建时间</th>
                                <th style="text-align: center;width: 150px">操作</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr v-for="(item,index) in listObj.list" style="">
                                <td style="text-align: center;vertical-align: middle">{{item.reportTime | resultFormat}}</td>
                                <td style="text-align: left;vertical-align: middle" :title="item.reportName">{{item.reportName |
                                    resultFormat}}
                                </td>
                                <td style="text-align: left;vertical-align: middle" :title="item.samllType" v-if="isSmallType==1">{{item.samllType |
                                    resultFormat}}
                                </td>
                                <td style="text-align: left;vertical-align: middle" :title="item.reportTip">{{item.reportTip | resultFormat}}
                                </td>
                                <td style="text-align: left;vertical-align: middle" :title="item.createUser">{{item.createUser |
                                    resultFormat}}
                                </td>
                                <td style="text-align: center;vertical-align: middle">{{item.createTime | resultFormat}}</td>
                                <td style="text-align: center;vertical-align: middle">
                                    <a @click="view(item.reportId)">查看</a>
                                    <a @click="toAdd(item.reportId)">编辑</a>
                                    <a @click="deleteById(item.reportId)">删除</a>
                                </td>
                            </tr>
                            <tr v-if="listObj.list.length===0">
                                <td colspan="7" class="text-center">暂无数据</td>
                            </tr>
                            </tbody>
                        </table>
                        <my-pagination @handlecurrentchange="doSearch()" :tableobj="listObj"></my-pagination>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp" %>
<!-- 分页组件 -->
<%@ include file="/WEB-INF/jsp/components/common/page-pagination.jsp" %>
<script>
    var ascriptionType = '${ascriptionType}';
    var menuName = '${menuName}';
    var isSmallType = '${isSmallType}';
</script>

<!-- vue插件 -->
<!--[if lte IE 9]>
	<script type="text/javascript" src="${ctx}/assets/components/babel-polyfill/polyfill.min.js"></script>
	<![endif]-->
<!-- Dialog 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/dialog-util.js"></script>
<%--日期--%>
<script type="text/javascript" src="${ctx}/assets/custom/common/util/date-time-util.js"></script>
<!-- Ajax 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/ajax-util.js"></script>
<!-- 自定义js（逻辑js） -->
<script type="text/javascript" src="${ctx}/assets/custom/analysis/commonreport/list.js"></script>
</body>
</html>
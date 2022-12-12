<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
<head>
    <title>项目费用</title>
	<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
  	<!--页面自定义的CSS，请放在这里 -->
    <style type="text/css">

    </style>
</head>

<body class="no-skin">

<div class="main-container" id="main-container">
    <div class="main-content">
        <div class="main-content-inner fixed-page-header fixed-82">
            <div class="page-toolbar align-right">
                <button type="button" class="btn btn-xs   btn-xs-ths" id="btnAdd">
                    <i class="ace-icon fa fa-plus"></i>
                    添加
                </button>
                <button type="button" class="btn btn-xs  btn-xs-ths" id="btnSave">
                    <i class="ace-icon fa fa-save"></i>
                    保存
                </button>
                <button type="button" class="btn btn-xs    btn-xs-ths" id="btnSubmit">
                    <i class="ace-icon fa fa-check"></i>
                    提交
                </button>
                <button type="button" class="btn btn-xs btn-xs-ths" id="btnDelete">
                    <i class="ace-icon fa fa-trash-o"></i>
                    删除
                </button>
                <button type="button" class="btn btn-xs btn-yellow btn-xs-ths" id="btnReturn">
                    <i class="ace-icon fa fa-reply"></i>
                    返回
                </button>
                <div class="btn-group">
                    <button data-toggle="dropdown" class="btn btn-xs btn-pink btn-xs-ths dropdown-toggle"
                            aria-expanded="false">
                        <i class="ace-icon fa fa-wrench"></i>
                        操作
                        <i class="ace-icon fa fa-angle-down icon-on-right"></i>
                    </button>

                    <ul class="dropdown-menu dropdown-menu-right">
                        <li>
                            <a href="#">
                                <i class="ace-icon fa fa-plus"></i>
                                添加
                            </a>
                        </li>

                        <li>
                            <a href="#"><i class="ace-icon fa fa-trash-o"></i>
                                删除</a>
                        </li>

                        <li>
                            <a href="#"><i class="ace-icon fa fa-remove align-left"></i>
                                取消发布</a>
                        </li>

                        <li class="divider"></li>

                        <li>
                            <a href="#"><i class="ace-icon fa fa-check"></i>
                                提交</a>
                        </li>
                    </ul>
                </div>

            </div>
            <!--
            <div class="page-toolbar align-right">
                <button type="button" class="btn btn-sm   btn-white" id="btnAdd">
                    <i class="ace-icon fa fa-plus"></i>
                    添加
                </button>
                <button type="button" class="btn btn-sm  btn-white" id="btnSave">
                    <i class="ace-icon fa fa-save"></i>
                    保存
                </button>
                <button type="button" class="btn btn-sm    btn-white" id="btnSubmit">
                    <i class="ace-icon fa fa-check"></i>
                    提交
                </button>
                <button type="button" class="btn btn-sm btn-white" id="btnDelete">
                    <i class="ace-icon fa fa-trash-o"></i>
                    删除
                </button>
                <button type="button" class="btn btn-sm btn-yellow btn-white" id="btnReturn">
                    <i class="ace-icon fa fa-reply"></i>
                    返回
                </button>
                <button type="button" class="btn btn-sm   btn-white" id="btnExport">
                    <i class="ace-icon fa fa-file-excel-o"></i>
                    导出
                </button>
                <div class="btn-group">
                    <button data-toggle="dropdown" class="btn btn-sm 2 btn-white dropdown-toggle"
                            aria-expanded="false">
                        <i class="ace-icon fa fa-wrench"></i>
                        操作
                        <i class="ace-icon fa fa-angle-down icon-on-right"></i>
                    </button>

                    <ul class="dropdown-menu dropdown-menu-right">
                        <li>
                            <a href="#">
                                <i class="ace-icon fa fa-plus"></i>
                                添加
                            </a>
                        </li>

                        <li>
                            <a href="#"><i class="ace-icon fa fa-trash-o"></i>
                                删除</a>
                        </li>

                        <li>
                            <a href="#"><i class="ace-icon fa fa-remove align-left"></i>
                                取消发布</a>
                        </li>

                        <li class="divider"></li>

                        <li>
                            <a href="#"><i class="ace-icon fa fa-check"></i>
                                提交</a>
                        </li>
                    </ul>
                </div>

            </div>
            -->
        </div>
        <div class="main-content-inner padding-page-content">
            <div class="page-content">
                <div class="space-4"></div>
                <div class="row">
                    <div class=" col-xs-12">
                        <form class="form-horizontal" role="form" id="form1" action="index.html" method="post">
                            <div class="form-group">
                                <label class="col-sm-1 control-label no-padding-right" for="txtName">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    姓名
                                </label>
                                <div class="col-sm-3">
                                    <span class="input-icon width-100">
                                        <input type="text" class="form-control"
                                               data-validation-engine="validate[required]" placeholder="4个汉字以内"
                                               id="txtName"/>
                                        <i class="ace-icon fa fa-user"> </i>
                                   </span>

                                </div>
                                <label class="col-sm-1 control-label no-padding-right">性别</label>
                                <div class="col-sm-3">
                                    <div class="control-group">
                                        <div class="radio-inline">
                                            <label>
                                                <input name="gender" type="radio" class="ace" value="male" checked>
                                                <span class="lbl"> 男</span>
                                            </label>
                                        </div>

                                        <div class="radio-inline">
                                            <label>
                                                <input name="gender" type="radio" class="ace" value="female">
                                                <span class="lbl"> 女</span>
                                            </label>
                                        </div>

                                        <div class="radio-inline">
                                            <label>
                                                <input name="gender" type="radio" class="ace" value="other">
                                                <span class="lbl"> 其它</span>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                                <label class="col-sm-1 control-label no-padding-right">爱好</label>
                                <div class="col-sm-3">
                                    <div class="control-group">
                                        <div class="checkbox-inline">
                                            <label>
                                                <input name="hobby" type="checkbox" class="ace" value="q1"
                                                       data-validation-engine="validate[minCheckbox[2]]">
                                                <span class="lbl"> 足球</span>
                                            </label>
                                        </div>

                                        <div class="checkbox-inline">
                                            <label>
                                                <input name="hobby" type="checkbox" class="ace" value="q2"
                                                       data-validation-engine="validate[minCheckbox[2]]">
                                                <span class="lbl"> 篮球</span>
                                            </label>
                                        </div>

                                        <div class="checkbox-inline">
                                            <label>
                                                <input name="hobby" type="checkbox" class="ace" value="q3"
                                                       data-validation-engine="validate[minCheckbox[2]]">
                                                <span class="lbl"> 乒乓球</span>
                                            </label>
                                        </div>
                                        <div class="checkbox-inline">
                                            <label>
                                                <input name="hobby" type="checkbox" class="ace" value="q4"
                                                       data-validation-engine="validate[minCheckbox[2]]">
                                                <span class="lbl"> 跑步</span>
                                            </label>
                                        </div>

                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-1 control-label no-padding-right" for="txtBirthday">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"> </i>
                                    生日
                                </label>
                                <div class="col-sm-3">
                                    <div class="input-group input-group-date" id="divBirthday">
                                        <input type="text" class="form-control"
                                               data-validation-engine="validate[required,custom[date]]" placeholder=""
                                               id="txtBirthday" readonly="readonly"/>
                                    <span class="input-group-btn">
                                        <button type="button" class="btn btn-white  " id="btnBirthday">
                                            <i class="ace-icon fa fa-calendar"></i>
                                        </button>
                                    </span>
                                    </div>
                                </div>
                                <label class="col-sm-1 control-label no-padding-right" for="form-field-221">所属部门</label>
                                <div class="col-sm-3">
                                    <div class="input-group">
                                        <input type="text" class="form-control" placeholder="" id="form-field-221"
                                               readonly="readonly"/>
                                    <span class="input-group-btn">
                                    <button type="button" class="btn btn-white  ">
                                        <i class="ace-icon fa fa-search"></i>
                                        选择
                                    </button>
                                        <button type="button" class="btn btn-white  ">
                                            <i class="ace-icon fa fa-remove"></i>
                                        </button>
                                    </span>
                                    </div>
                                </div>
                                <label class="col-sm-1 control-label no-padding-right" for="form-field-16">序列号</label>
                                <div class="col-sm-3">
                                    <input type="text" class="form-control" placeholder="" id="form-field-16"
                                           disabled="disabled"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-1 control-label no-padding-right"
                                       for="form-field-select-1">
                                    职位
                                </label>
                                <div class="col-sm-3">
                                    <select class="form-control" id="form-field-select-1">
                                        <option value="">-请选择-</option>
                                        <option value="1">科员</option>
                                        <option value="2">科长</option>
                                        <option value="3">处长</option>
                                        <option value="4">局长</option>
                                    </select>
                                </div>
                                <label class="col-sm-1 control-label no-padding-right" for="form-field-8">职别</label>
                                <div class="col-sm-3">
                                    <input type="text" class="form-control" placeholder="" id="form-field-8"/>
                                </div>
                                <label class="col-sm-1 control-label no-padding-right">简历</label>
                                <div class="col-sm-3">
                                    <!-- #section:custom/file-input -->
                                    <label class="ace-file-input">
                                        <input type="file" id="id-input-file-2">
                                            <span class="ace-file-container" data-title="浏览 ..">
                                                <span class="ace-file-name" data-title="选择文件...">
                                                    <i class=" ace-icon fa fa-upload"></i>
                                                </span>
                                            </span>
                                    </label>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-1 control-label no-padding-right" for="txtBirthday">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"> </i>
                                    生日
                                </label>
                                <div class="col-sm-3">
                                    <div class="input-group input-group-date" id="divBirthday">
                                        <input type="text" class="form-control"
                                               data-validation-engine="validate[required,custom[date]]" placeholder=""
                                               id="txtBirthday" readonly="readonly"/>
                                    <span class="input-group-btn">
                                        <button type="button" class="btn btn-white  " id="btnBirthday">
                                            <i class="ace-icon fa fa-calendar"></i>
                                        </button>
                                    </span>
                                    </div>
                                </div>
                                <label class="col-sm-1 control-label no-padding-right" for="form-field-221">所属部门</label>
                                <div class="col-sm-3">
                                    <div class="input-group">
                                        <input type="text" class="form-control" placeholder="" id="form-field-221"
                                               readonly="readonly"/>
                                    <span class="input-group-btn">
                                    <button type="button" class="btn btn-white  ">
                                        <i class="ace-icon fa fa-search"></i>
                                        选择
                                    </button>
                                        <button type="button" class="btn btn-white  ">
                                            <i class="ace-icon fa fa-remove"></i>
                                        </button>
                                    </span>
                                    </div>
                                </div>
                                <label class="col-sm-1 control-label no-padding-right" for="form-field-16">序列号</label>
                                <div class="col-sm-3">
                                    <input type="text" class="form-control" placeholder="" id="form-field-16"
                                           disabled="disabled"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-1 control-label no-padding-right" for="txtBirthday">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"> </i>
                                    生日
                                </label>
                                <div class="col-sm-3">
                                    <div class="input-group input-group-date" id="divBirthday">
                                        <input type="text" class="form-control"
                                               data-validation-engine="validate[required,custom[date]]" placeholder=""
                                               id="txtBirthday" readonly="readonly"/>
                                    <span class="input-group-btn">
                                        <button type="button" class="btn btn-white  " id="btnBirthday">
                                            <i class="ace-icon fa fa-calendar"></i>
                                        </button>
                                    </span>
                                    </div>
                                </div>
                                <label class="col-sm-1 control-label no-padding-right" for="form-field-221">所属部门</label>
                                <div class="col-sm-3">
                                    <div class="input-group">
                                        <input type="text" class="form-control" placeholder="" id="form-field-221"
                                               readonly="readonly"/>
                                    <span class="input-group-btn">
                                    <button type="button" class="btn btn-white  ">
                                        <i class="ace-icon fa fa-search"></i>
                                        选择
                                    </button>
                                        <button type="button" class="btn btn-white  ">
                                            <i class="ace-icon fa fa-remove"></i>
                                        </button>
                                    </span>
                                    </div>
                                </div>
                                <label class="col-sm-1 control-label no-padding-right" for="form-field-16">序列号</label>
                                <div class="col-sm-3">
                                    <input type="text" class="form-control" placeholder="" id="form-field-16"
                                           disabled="disabled"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-1 control-label no-padding-right" for="txtBirthday">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"> </i>
                                    生日
                                </label>
                                <div class="col-sm-3">
                                    <div class="input-group input-group-date" id="divBirthday">
                                        <input type="text" class="form-control"
                                               data-validation-engine="validate[required,custom[date]]" placeholder=""
                                               id="txtBirthday" readonly="readonly"/>
                                    <span class="input-group-btn">
                                        <button type="button" class="btn btn-white  " id="btnBirthday">
                                            <i class="ace-icon fa fa-calendar"></i>
                                        </button>
                                    </span>
                                    </div>
                                </div>
                                <label class="col-sm-1 control-label no-padding-right" for="form-field-221">所属部门</label>
                                <div class="col-sm-3">
                                    <div class="input-group">
                                        <input type="text" class="form-control" placeholder="" id="form-field-221"
                                               readonly="readonly"/>
                                    <span class="input-group-btn">
                                    <button type="button" class="btn btn-white  ">
                                        <i class="ace-icon fa fa-search"></i>
                                        选择
                                    </button>
                                        <button type="button" class="btn btn-white  ">
                                            <i class="ace-icon fa fa-remove"></i>
                                        </button>
                                    </span>
                                    </div>
                                </div>
                                <label class="col-sm-1 control-label no-padding-right" for="form-field-16">序列号</label>
                                <div class="col-sm-3">
                                    <input type="text" class="form-control" placeholder="" id="form-field-16"
                                           disabled="disabled"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-1 control-label no-padding-right" for="txtBirthday">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"> </i>
                                    生日
                                </label>
                                <div class="col-sm-3">
                                    <div class="input-group input-group-date" id="divBirthday">
                                        <input type="text" class="form-control"
                                               data-validation-engine="validate[required,custom[date]]" placeholder=""
                                               id="txtBirthday" readonly="readonly"/>
                                    <span class="input-group-btn">
                                        <button type="button" class="btn btn-white  " id="btnBirthday">
                                            <i class="ace-icon fa fa-calendar"></i>
                                        </button>
                                    </span>
                                    </div>
                                </div>
                                <label class="col-sm-1 control-label no-padding-right" for="form-field-221">所属部门</label>
                                <div class="col-sm-3">
                                    <div class="input-group">
                                        <input type="text" class="form-control" placeholder="" id="form-field-221"
                                               readonly="readonly"/>
                                    <span class="input-group-btn">
                                    <button type="button" class="btn btn-white  ">
                                        <i class="ace-icon fa fa-search"></i>
                                        选择
                                    </button>
                                        <button type="button" class="btn btn-white  ">
                                            <i class="ace-icon fa fa-remove"></i>
                                        </button>
                                    </span>
                                    </div>
                                </div>
                                <label class="col-sm-1 control-label no-padding-right" for="form-field-16">序列号</label>
                                <div class="col-sm-3">
                                    <input type="text" class="form-control" placeholder="" id="form-field-16"
                                           disabled="disabled"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-1 control-label no-padding-right" for="txtBirthday">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"> </i>
                                    生日
                                </label>
                                <div class="col-sm-3">
                                    <div class="input-group input-group-date" id="divBirthday">
                                        <input type="text" class="form-control"
                                               data-validation-engine="validate[required,custom[date]]" placeholder=""
                                               id="txtBirthday" readonly="readonly"/>
                                    <span class="input-group-btn">
                                        <button type="button" class="btn btn-white  " id="btnBirthday">
                                            <i class="ace-icon fa fa-calendar"></i>
                                        </button>
                                    </span>
                                    </div>
                                </div>
                                <label class="col-sm-1 control-label no-padding-right" for="form-field-221">所属部门</label>
                                <div class="col-sm-3">
                                    <div class="input-group">
                                        <input type="text" class="form-control" placeholder="" id="form-field-221"
                                               readonly="readonly"/>
                                    <span class="input-group-btn">
                                    <button type="button" class="btn btn-white  ">
                                        <i class="ace-icon fa fa-search"></i>
                                        选择
                                    </button>
                                        <button type="button" class="btn btn-white  ">
                                            <i class="ace-icon fa fa-remove"></i>
                                        </button>
                                    </span>
                                    </div>
                                </div>
                                <label class="col-sm-1 control-label no-padding-right" for="form-field-16">序列号</label>
                                <div class="col-sm-3">
                                    <input type="text" class="form-control" placeholder="" id="form-field-16"
                                           disabled="disabled"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-1 control-label no-padding-right" for="txtBirthday">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"> </i>
                                    生日
                                </label>
                                <div class="col-sm-3">
                                    <div class="input-group input-group-date" id="divBirthday">
                                        <input type="text" class="form-control"
                                               data-validation-engine="validate[required,custom[date]]" placeholder=""
                                               id="txtBirthday" readonly="readonly"/>
                                    <span class="input-group-btn">
                                        <button type="button" class="btn btn-white  " id="btnBirthday">
                                            <i class="ace-icon fa fa-calendar"></i>
                                        </button>
                                    </span>
                                    </div>
                                </div>
                                <label class="col-sm-1 control-label no-padding-right" for="form-field-221">所属部门</label>
                                <div class="col-sm-3">
                                    <div class="input-group">
                                        <input type="text" class="form-control" placeholder="" id="form-field-221"
                                               readonly="readonly"/>
                                    <span class="input-group-btn">
                                    <button type="button" class="btn btn-white  ">
                                        <i class="ace-icon fa fa-search"></i>
                                        选择
                                    </button>
                                        <button type="button" class="btn btn-white  ">
                                            <i class="ace-icon fa fa-remove"></i>
                                        </button>
                                    </span>
                                    </div>
                                </div>
                                <label class="col-sm-1 control-label no-padding-right" for="form-field-16">序列号</label>
                                <div class="col-sm-3">
                                    <input type="text" class="form-control" placeholder="" id="form-field-16"
                                           disabled="disabled"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-1 control-label no-padding-right" for="txtBirthday">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"> </i>
                                    生日
                                </label>
                                <div class="col-sm-3">
                                    <div class="input-group input-group-date" id="divBirthday">
                                        <input type="text" class="form-control"
                                               data-validation-engine="validate[required,custom[date]]" placeholder=""
                                               id="txtBirthday" readonly="readonly"/>
                                    <span class="input-group-btn">
                                        <button type="button" class="btn btn-white  " id="btnBirthday">
                                            <i class="ace-icon fa fa-calendar"></i>
                                        </button>
                                    </span>
                                    </div>
                                </div>
                                <label class="col-sm-1 control-label no-padding-right" for="form-field-221">所属部门</label>
                                <div class="col-sm-3">
                                    <div class="input-group">
                                        <input type="text" class="form-control" placeholder="" id="form-field-221"
                                               readonly="readonly"/>
                                    <span class="input-group-btn">
                                    <button type="button" class="btn btn-white  ">
                                        <i class="ace-icon fa fa-search"></i>
                                        选择
                                    </button>
                                        <button type="button" class="btn btn-white  ">
                                            <i class="ace-icon fa fa-remove"></i>
                                        </button>
                                    </span>
                                    </div>
                                </div>
                                <label class="col-sm-1 control-label no-padding-right" for="form-field-16">序列号</label>
                                <div class="col-sm-3">
                                    <input type="text" class="form-control" placeholder="" id="form-field-16"
                                           disabled="disabled"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-1 control-label no-padding-right" for="txtBirthday">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"> </i>
                                    生日
                                </label>
                                <div class="col-sm-3">
                                    <div class="input-group input-group-date" id="divBirthday">
                                        <input type="text" class="form-control"
                                               data-validation-engine="validate[required,custom[date]]" placeholder=""
                                               id="txtBirthday" readonly="readonly"/>
                                    <span class="input-group-btn">
                                        <button type="button" class="btn btn-white  " id="btnBirthday">
                                            <i class="ace-icon fa fa-calendar"></i>
                                        </button>
                                    </span>
                                    </div>
                                </div>
                                <label class="col-sm-1 control-label no-padding-right" for="form-field-221">所属部门</label>
                                <div class="col-sm-3">
                                    <div class="input-group">
                                        <input type="text" class="form-control" placeholder="" id="form-field-221"
                                               readonly="readonly"/>
                                    <span class="input-group-btn">
                                    <button type="button" class="btn btn-white  ">
                                        <i class="ace-icon fa fa-search"></i>
                                        选择
                                    </button>
                                        <button type="button" class="btn btn-white  ">
                                            <i class="ace-icon fa fa-remove"></i>
                                        </button>
                                    </span>
                                    </div>
                                </div>
                                <label class="col-sm-1 control-label no-padding-right" for="form-field-16">序列号</label>
                                <div class="col-sm-3">
                                    <input type="text" class="form-control" placeholder="" id="form-field-16"
                                           disabled="disabled"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-1 control-label no-padding-right" for="txtBirthday">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"> </i>
                                    生日
                                </label>
                                <div class="col-sm-3">
                                    <div class="input-group input-group-date" id="divBirthday">
                                        <input type="text" class="form-control"
                                               data-validation-engine="validate[required,custom[date]]" placeholder=""
                                               id="txtBirthday" readonly="readonly"/>
                                    <span class="input-group-btn">
                                        <button type="button" class="btn btn-white  " id="btnBirthday">
                                            <i class="ace-icon fa fa-calendar"></i>
                                        </button>
                                    </span>
                                    </div>
                                </div>
                                <label class="col-sm-1 control-label no-padding-right" for="form-field-221">所属部门</label>
                                <div class="col-sm-3">
                                    <div class="input-group">
                                        <input type="text" class="form-control" placeholder="" id="form-field-221"
                                               readonly="readonly"/>
                                    <span class="input-group-btn">
                                    <button type="button" class="btn btn-white  ">
                                        <i class="ace-icon fa fa-search"></i>
                                        选择
                                    </button>
                                        <button type="button" class="btn btn-white  ">
                                            <i class="ace-icon fa fa-remove"></i>
                                        </button>
                                    </span>
                                    </div>
                                </div>
                                <label class="col-sm-1 control-label no-padding-right" for="form-field-16">序列号</label>
                                <div class="col-sm-3">
                                    <input type="text" class="form-control" placeholder="" id="form-field-16"
                                           disabled="disabled"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-1 control-label no-padding-right" for="txtBirthday">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"> </i>
                                    生日
                                </label>
                                <div class="col-sm-3">
                                    <div class="input-group input-group-date" id="divBirthday">
                                        <input type="text" class="form-control"
                                               data-validation-engine="validate[required,custom[date]]" placeholder=""
                                               id="txtBirthday" readonly="readonly"/>
                                    <span class="input-group-btn">
                                        <button type="button" class="btn btn-white  " id="btnBirthday">
                                            <i class="ace-icon fa fa-calendar"></i>
                                        </button>
                                    </span>
                                    </div>
                                </div>
                                <label class="col-sm-1 control-label no-padding-right" for="form-field-221">所属部门</label>
                                <div class="col-sm-3">
                                    <div class="input-group">
                                        <input type="text" class="form-control" placeholder="" id="form-field-221"
                                               readonly="readonly"/>
                                    <span class="input-group-btn">
                                    <button type="button" class="btn btn-white  ">
                                        <i class="ace-icon fa fa-search"></i>
                                        选择
                                    </button>
                                        <button type="button" class="btn btn-white  ">
                                            <i class="ace-icon fa fa-remove"></i>
                                        </button>
                                    </span>
                                    </div>
                                </div>
                                <label class="col-sm-1 control-label no-padding-right" for="form-field-16">序列号</label>
                                <div class="col-sm-3">
                                    <input type="text" class="form-control" placeholder="" id="form-field-16"
                                           disabled="disabled"/>
                                </div>
                            </div>
                        </form>
                    </div>
                </div><!-- /.row -->
            </div>
        </div><!--/.main-content-inner-->
    </div><!-- /.main-content -->
</div><!-- /.main-container -->

<!-- basic scripts -->


<!--[if IE]>
<script src="../components/jquery.1x/dist/jquery.js?v=20221129015223"></script>
<![endif]-->
<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>

<!-- 自己写的JS，请放在这里 -->
<script type="text/javascript">
    jQuery(function ($) {
        //日期控件使用示例，详细文档请参考http://www.my97.net/dp/demo/index.htm
        $("#divBirthday").on(ace.click_event, function () {
            WdatePicker({el: 'txtBirthday'});
        });

        //wysiwyg编辑器初始化
        $('#my-editor').ace_wysiwyg().prev().addClass('wysiwyg-style1');

        //表单验证组件初始化，详细文档请参考http://code.ciaoca.com/jquery/validation-engine/ 或官网文档http://posabsolute.github.io/jQuery-Validation-Engine/
        $("#form1").validationEngine({
            scrollOffset: 98,//必须设置，因为Toolbar position为Fixed
            promptPosition: 'bottomLeft',
            autoHidePrompt: true
        });

        $("#btnSubmit").on(ace.click_event, function () {
            //console.log("validate begin..");
            //console.log($('#form1').validationEngine('validate'));
            if ($('#form1').validationEngine('validate')) {
                //submit
            }
        });
        $("#btnSave").on(ace.click_event, function () {
            //console.log("validate begin..");
            //console.log($('#form1').validationEngine('validate'));
            if ($('#form1').validationEngine('validate')) {
                //submit
            }
        });
    });
</script>
</body>
</html>

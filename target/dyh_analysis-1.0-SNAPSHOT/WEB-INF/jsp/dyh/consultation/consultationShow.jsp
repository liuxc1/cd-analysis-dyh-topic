<%--
  Created by IntelliJ IDEA.
  User: ZT
  Date: 2021/9/29
  Time: 10:24
  To change this template use File | Settings | File Templates.
--%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>会商记录</title>
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp" %>
    <link href="${ctx }/assets/components/element-ui/lib/theme-chalk/index.css?v=20221129015223" rel="stylesheet" type="text/css">
    <!-- 分析平台-文件上传表格组件-样式文件 -->
    <link href="${ctx }/assets/custom/components/analysis/css/file-upload-table.css?v=20221129015223" rel="stylesheet" />
    <style>
        .el-checkbox-group{
            padding-top:10px;
        }
    </style>
</head>
<body>
<div class="main-container" id="main-container">
    <div class="main-content">
        <div class="main-content-inner">
            <div class=" fixed-page-header fixed-40">
                <div id="breadcrumbs" class="breadcrumbs">
                    <ul class="breadcrumb">
                        <li class="active">
                            <h3 class="page-title">
                                重污染会商-记录
                            </h3>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="main-content-inner padding-page-content">
                <div class="col-sm-12" style="padding-top: 20px;">
                    <el-form :model="form" ref="form" :rules="rules" label-width="100px" class="demo-ruleForm" v-if="form.CONSULT_STATUS !='3'">
                        <el-form-item label="会商时间：">
                            {{form.CONSULT_TIME}}~{{form.CONSULT_TIME_END}}
                        </el-form-item>
                        <el-form-item label="会商类型：">
                            {{form.CONSULT_TYPE_NAME}}
                        </el-form-item>
                        <el-form-item label="参与部门：">
                            {{form.CONSULT_DEPT_NAMES}}
                        </el-form-item>
                        <el-form-item label="会议主题：">
                            {{form.CONSULT_THEME}}
                        </el-form-item>
                        <el-form-item label="简介：">
                            {{form.CONSULT_SYNOPSIS}}
                        </el-form-item>
                        <el-form-item label="附件：">
                            <file-upload-table ref="fileUploadTable" :ascription-id="form.PKID" :ascription-type="ascriptionType" :allow-upload="false" :file-list="fileList" allow-file-types="doc,docx,pdf"></file-upload-table>
                        </el-form-item>
                        <el-form-item label="参会专家：" prop="CONSULT_EXPERT">
                            <el-input type="textarea" v-model="form.CONSULT_EXPERT"></el-input>
                        </el-form-item>
                        <el-form-item label="会议纪要：" prop="CONSULT_MINUTES">
                            <el-input type="textarea" v-model="form.CONSULT_MINUTES"></el-input>
                        </el-form-item>
                        <el-form-item label="会议决议：" prop="CONSULT_RESOLUTION">
                            <el-input type="textarea" v-model="form.CONSULT_RESOLUTION"></el-input>
                        </el-form-item>
                        <el-form-item>
                            <el-button type="primary" @click="temporaryStorage" >暂存</el-button>
                            <el-button @click="submitForm('form')">发布会商纪要</el-button>
                        </el-form-item>
                    </el-form>
                    <el-form :model="form" ref="form" :rules="rules" label-width="100px" class="demo-ruleForm" v-else>
                        <el-form-item label="会商时间：">
                            {{form.CONSULT_TIME}}
                        </el-form-item>
                        <el-form-item label="会商类型：">
                            {{form.CONSULT_TYPE_NAME}}
                        </el-form-item>
                        <el-form-item label="参与部门：">
                            {{form.CONSULT_DEPT_NAMES}}
                        </el-form-item>
                        <el-form-item label="会议主题：">
                            {{form.CONSULT_THEME}}
                        </el-form-item>
                        <el-form-item label="简介：">
                            {{form.CONSULT_SYNOPSIS}}
                        </el-form-item>
                        <el-form-item label="附件：">
                            <file-upload-table ref="fileUploadTable" :ascription-id="form.PKID" :ascription-type="ascriptionType" :allow-upload="false" :file-list="fileList" allow-file-types="doc,docx,pdf"></file-upload-table>
                        </el-form-item>
                        <el-form-item label="参会专家：">
                            {{form.CONSULT_EXPERT}}
                        </el-form-item>
                        <el-form-item label="会议纪要：">
                            {{form.CONSULT_MINUTES}}
                        </el-form-item>
                        <el-form-item label="会议决议：">
                            {{form.CONSULT_RESOLUTION}}
                        </el-form-item>
                    </el-form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp" %>
<script type="text/javascript" src="${ctx }/assets/components/element-ui/index.js?v=20221129015223"></script>
<!-- Ajax 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/ajax-util.js?v=20221129015223"></script>
<%@ include file="/WEB-INF/jsp/components/common/file-upload-table.jsp" %>

<script>
    let id = '${form.PKID}';
    let vue = new Vue({
        el: '#main-container',
        data:{
            ascriptionType:'consultation',
            form: {
                PKID:'',
                CONSULT_TIME: '',
                CONSULT_TYPE_CODE: '',
                CONSULT_TYPE_NAME: '',
                CONSULT_DEPT_CODES: [],
                CONSULT_DEPT_NAMES: '',
                CONSULT_DEPT_CODES_STR: '',
                CONSULT_THEME: '',
                CONSULT_SYNOPSIS: '',
                CONSULT_STATUS:'',
                CONSULT_EXPERT:'',
                CONSULT_MINUTES:'',
                CONSULT_RESOLUTION:'',
            },
            rules:{
                CONSULT_EXPERT:[
                    { required: true, message: '请输入参会专家', trigger: 'blur' },
                ],
                CONSULT_MINUTES:[
                    { required: true, message: '请输入会议纪要', trigger: 'blur' },
                ],
                CONSULT_RESOLUTION:[
                    { required: true, message: '请输入会议决议', trigger: 'blur' },
                ],
            },
            fileList: [],
        },
        mounted:function () {
            this.form.PKID = id;
            this.getInfo();
        },
        methods:{
            //暂存
            temporaryStorage(){
                let _this =this;
                _this.form.CONSULT_STATUS=2;
                _this.form.CONSULT_DEPT_CODES_STR = _this.form.CONSULT_DEPT_CODES.join(",");
                AjaxUtil.sendAjax('saveInfo.vm', _this.form, function (data) {
                    _this.$alert(data.data, '', {
                        confirmButtonText: '确定',
                        callback: action => {
                            if(data.success){
                                window.opener.location.reload();
                                window.close();
                            }
                        }
                    })
                });
            },
            //发布
            submitForm(formName) {
                let _this = this;
                _this.$refs[formName].validate((valid) => {
                    if (valid) {
                        _this.form.CONSULT_STATUS=3;
                        _this.form.CONSULT_DEPT_CODES_STR = _this.form.CONSULT_DEPT_CODES.join(",");
                        AjaxUtil.sendAjax('saveInfo.vm', _this.form, function (data) {
                            _this.$alert(data.data, '', {
                                confirmButtonText: '确定',
                                callback: action => {
                                    if(data.success){
                                        window.opener.location.reload();
                                        window.close();
                                    }
                                }
                            })
                        });
                    } else {
                        console.log('error submit!!');
                        return false;
                    }
                });
            },
            resetForm(formName) {
                this.$refs[formName].resetFields();
            },
            //获取会商基本信息
            getInfo(){
                let _this = this;
                AjaxUtil.sendAjax('getBaseInfo.vm',_this.form,function (data) {
                    if(data.data){
                        _this.form = data.data;
                        _this.form.CONSULT_DEPT_CODES = data.data.CONSULT_DEPT_CODES.split(',');
                    }
                })
            },

        }
    })
</script>
</html>

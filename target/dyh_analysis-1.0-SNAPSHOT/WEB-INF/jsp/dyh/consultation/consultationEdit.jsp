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
    <title>新增会商信息</title>
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp" %>
    <link href="${ctx}/assets/components/element-ui/lib/theme-chalk/index.css?v=20221129015223" rel="stylesheet" type="text/css">
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
                                会商-添加/修改计划
                            </h3>

                        </li>
                    </ul>
                    <a href="/dyh_analysis/dyh_view/consultation/consultation_index_pc.html"  target="_blank" style="float: right;font-size: 15px">进入会商后台管理</a>
                </div>
            </div>
            <div class="main-content-inner padding-page-content">
                <div class="col-sm-12" style="padding-top: 20px;">
                    <el-form :model="form" ref="form" :rules="rules" label-width="80px" class="demo-ruleForm">
                        <el-form-item label="会商时间" prop="CONSULT_TIME">
                            <el-col :span="5">
                                <el-date-picker type="datetime" placeholder="选择日期" value-format="yyyy-MM-dd HH:mm" format="yyyy-MM-dd HH:mm" v-model="form.CONSULT_TIME" style="width: 100%;"></el-date-picker>
                            </el-col>
                            <el-col :span="2" style="text-align: center">
                                至
                            </el-col>
                            <el-col :span="5">
                                <el-date-picker type="datetime"
                                                v-model="form.CONSULT_TIME_END"
                                                placeholder="结束时间"
                                                value-format="yyyy-MM-dd HH:mm"
                                                format="yyyy-MM-dd HH:mm" style="width: 100%;">

                                </el-date-picker>
                            </el-col>
                        </el-form-item>
                        <el-form-item label="会商类型" prop="CONSULT_TYPE_CODE">
                            <el-select v-model="form.CONSULT_TYPE_CODE" placeholder="请选择会商类型" @change="setConsultTypeName()">
                                <el-option v-for="(item,index) in CONSULT_TYPE" :label="item.name" :value="item.code"></el-option>
                            </el-select>
                        </el-form-item>
                        <el-form-item label="参与部门" prop="CONSULT_DEPT_CODES">
                            <el-checkbox-group v-model="form.CONSULT_DEPT_CODES">
                                <el-checkbox v-for="(item,index) in CONSULT_DEPT" :label="item.DEPT_ID" name="type" @change="setDeptNames">{{item.DEPT_NAME}}</el-checkbox>
                            </el-checkbox-group>
                        </el-form-item>
                        <el-form-item label="会议主题" prop="CONSULT_THEME">
                            <el-input type="textarea" v-model="form.CONSULT_THEME"></el-input>
                        </el-form-item>
                        <el-form-item label="简介" prop="CONSULT_SYNOPSIS">
                            <el-input type="textarea" v-model="form.CONSULT_SYNOPSIS"></el-input>
                        </el-form-item>
                        <el-form-item label="附件">
                            <file-upload-table ref="fileUploadTable" :ascription-id="form.PKID" :ascription-type="ascriptionType" :delete-file-ids="resultData.deleteFileIds" :file-list="fileList" allow-file-types="doc,docx,pdf"></file-upload-table>
                        </el-form-item>
                        <el-form-item>
                            <el-button type="primary" @click="temporaryStorage" >暂存</el-button>
                            <el-button @click="submitForm('form')">发布会商计划</el-button>
                        </el-form-item>
                    </el-form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp" %>
<script type="text/javascript" src="${ctx}/assets/components/element-ui/index.js?v=20221129015223"></script>
<!-- Ajax 工具类 -->
<script type="text/javascript" src="${ctx}/assets/custom/common/util/ajax-util.js?v=20221129015223"></script>
<%@ include file="/WEB-INF/jsp/components/common/file-upload-table.jsp" %>

<script>
    let id = '${form.PKID}';
    let vue = new Vue({
        el: '#main-container',
        data:{
            ascriptionType:'consultation',
            CONSULT_TYPE:[
                {
                    code:'rchs',
                    name:'日常会商'
                },
                {
                    code:'zwrhs',
                    name:'重污染会商'
                },
                {
                    code:'zcqhs',
                    name:'中长期会商'
                },
                {
                    code:'cdpyqyhs',
                    name:'成都平原区域会商'
                },
            ],
            CONSULT_DEPT:[],
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
            },
            rules:{
                CONSULT_TIME:[
                    { required: true, message: '请选择会商时间', trigger: 'blur' },
                ],
                CONSULT_TYPE_CODE:[
                    { required: true, message: '请选择会商类型', trigger: 'blur' },
                ],
                CONSULT_DEPT_CODES:[
                    { required: true, message: '请选择参与部门', trigger: 'blur' },
                ],
                CONSULT_THEME:[
                    { required: true, message: '请输入会商主题', trigger: 'blur' },
                ],
                CONSULT_SYNOPSIS:[

                ],
            },
            resultData: {
                // 预报ID
                STATE:'',
                MONTHTREND_ID:'',
                FORECAST_TIME:'',
                MONTHTREND_NAME:'',
                HINT:'',
                deleteFileIds:[],
            },
            fileList: [],
        },
        mounted:function () {
            this.form.PKID = id;
            this.listDepts();
        },
        methods:{
            /**
             * 将基础数据添加到表单数据中
             * @param {FormData} formData 表单数据对象
             * @returns {FormData} formData 表单数据对象
             */
            appendBaseDataToForm: function (formData) {
                for (let key in this.form) {
                    formData.append(key, this.form[key]);
                }
                return formData;
            },
            nedsaw(){
              window.open("/dyh_analysis/dyh_view/consultation/consultation_index_pc.html")
            },
            temporaryStorage(){
                let _this =this;
                _this.form.CONSULT_STATUS=0;
                _this.form.CONSULT_DEPT_CODES_STR = _this.form.CONSULT_DEPT_CODES.join(",");
                this.$delete(this.form,'CONSULT_EXPERT')
                AjaxUtil.sendAjax('cheakTime.vm', _this.form, function (data) {
                    if(data.data.length > 0 ){
                        _this.$alert('该时间段已经预约会议，请重新选择', '', {
                            confirmButtonText: '确定',
                            callback: action => {}
                        })
                    }else{
                        AjaxUtil.sendAjax('saveInfo.vm', _this.form, function (data) {
                            debugger;
                            if(data.code == 200){
                                _this.$alert(data.data, '', {
                                    confirmButtonText: '确定',
                                    callback: action => {
                                        if(data.success){
                                            window.opener.location.reload();
                                            window.close();
                                        }
                                    }
                                })
                            }else{
                                _this.$alert('视频功能升级中，暂无法使用！', '', {
                                    confirmButtonText: '确定',
                                    callback: action => {
                                        if(data.success){
                                            window.opener.location.reload();
                                            window.close();
                                        }
                                    }
                                })
                            }

                        },function(data){
                            _this.$alert('视频功能升级中，暂无法使用！', '', {
                                confirmButtonText: '确定',
                                callback: action => {
                                    window.close();
                                }
                            })
                        });
                    }
                },function(){
                    _this.$alert('视频功能升级中，暂无法使用！', '', {
                        confirmButtonText: '确定',
                        callback: action => {
                            if(data.success){
                                window.close();
                            }
                        }
                    })
                });

            },
            submitForm(formName) {
                let _this = this;
                _this.$refs[formName].validate((valid) => {
                    if (valid) {
                        _this.form.CONSULT_STATUS=1;
                        _this.form.CONSULT_DEPT_CODES_STR = _this.form.CONSULT_DEPT_CODES.join(",");
                        this.$delete(this.form,'CONSULT_EXPERT')

                        if(_this.form.CONSULT_EXPERT){

                        }
                        AjaxUtil.sendAjax('cheakTime.vm', _this.form, function (data) {
                            if(data.data.length > 0 ){
                                _this.$alert('该时间段已经预约会议，请重新选择', '', {
                                    confirmButtonText: '确定',
                                    callback: action => {}
                                })
                            }else{
                                AjaxUtil.sendAjax('saveInfo.vm', _this.form, function (data) {
                                    alert(data)
                                    // console.log(data);
                                    // if(data.code == 200){
                                    //     _this.$alert(data.data, '', {
                                    //         confirmButtonText: '确定',
                                    //         callback: action => {
                                    //             if(data.success){
                                    //                 window.opener.location.reload();
                                    //                 window.close();
                                    //             }
                                    //         }
                                    //     })
                                    // }else{
                                    //     _this.$alert('腾讯会议连接失败！', '', {
                                    //         confirmButtonText: '确定',
                                    //         callback: action => {
                                    //             if(data.success){
                                    //                 window.opener.location.reload();
                                    //                 window.close();
                                    //             }
                                    //         }
                                    //     })
                                    // }
                                },function(){
                                    _this.$alert('视频功能升级中，暂无法使用！', '', {
                                        confirmButtonText: '确定',
                                        callback: action => {
                                            if(data.success){
                                                window.close();
                                            }
                                        }
                                    })
                                });
                           }
                        },function(){
                            _this.$alert('视频功能升级中，暂无法使用！', '', {
                                confirmButtonText: '确定',
                                callback: action => {
                                    if(data.success){
                                        window.close();
                                    }
                                }
                            })
                        })
                    } else {
                        console.log('error submit!!');
                        return false;
                    }
                });
            },
            resetForm(formName) {
                this.$refs[formName].resetFields();
            },
            listDepts(){
                let _this = this;
                AjaxUtil.sendAjax('listDepts.vm',_this.form,function (data) {
                    if(data.data){
                        _this.CONSULT_DEPT = data.data;
                        _this.getInfo();
                    }
                })
            },
            //获取会商基本信息
            getInfo(){
                let _this = this;
                AjaxUtil.sendAjax('getBaseInfo.vm',_this.form,function (data) {
                    if(data.data){
                        _this.form = data.data;
                        if(data.data.CONSULT_DEPT_CODES != null && data.data.CONSULT_DEPT_CODES != undefined){
                            _this.form.CONSULT_DEPT_CODES = data.data.CONSULT_DEPT_CODES.split(',');
                        }

                        console.log(_this.form);
                    }
                })
            },
            setDeptNames(){
                let _this = this;
                let deptNames=[];
                for(let i=0;i<_this.form.CONSULT_DEPT_CODES.length;i++){
                    for (let j = 0; j <_this.CONSULT_DEPT.length; j++) {
                        if(_this.form.CONSULT_DEPT_CODES[i]===_this.CONSULT_DEPT[j].DEPT_ID){
                            deptNames.push(_this.CONSULT_DEPT[j].DEPT_NAME);
                        }
                    }
                }
                _this.form.CONSULT_DEPT_NAMES = deptNames.join(",");
            },
            setConsultTypeName(){
                let _this = this;
                for(let i=0;i<_this.CONSULT_TYPE.length;i++){
                    if(_this.form.CONSULT_TYPE_CODE === _this.CONSULT_TYPE[i].code){
                        _this.form.CONSULT_TYPE_NAME = _this.CONSULT_TYPE[i].name;
                    }
                }
            }

        }
    })
</script>
</html>

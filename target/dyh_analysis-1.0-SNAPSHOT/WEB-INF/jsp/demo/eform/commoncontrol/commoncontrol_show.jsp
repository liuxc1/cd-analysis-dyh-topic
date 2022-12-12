<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
<head>
    <title>公用组件</title>
	<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
	<script src="${ctx}/assets/js/eform/eform_custom.js?v=20221129015223"></script>
  	<!--页面自定义的CSS，请放在这里 -->
    <style type="text/css">
		.input-group-btn{
			vertical-align: top;
		}
		.label-middle{
			padding-top:5px;
		}
		hr{
			width:95%;
			
		}
    </style>
</head>

<body class="no-skin">

<div class="main-container" id="main-container">
    <div class="main-content">
        <div class="main-content-inner fixed-page-header fixed-82">
            <div id="breadcrumbs" class="breadcrumbs">
                <ul class="breadcrumb">
                    <li class="active">
                        <h5 class="page-title" >
                            <i class="fa fa-edit"></i>
                            常用控件
                        </h5>
                    </li>
                </ul><!-- /.breadcrumb -->

            </div>
        <div class="main-content-inner padding-page-content">
            <div class="page-content">
                <div class="space-4"></div>
                <div class="row">
                    <div class=" col-xs-12">
                        <form class="form-horizontal" role="form" id="formInfo" action="" method="post">
                            <div class="form-group">
                                <label class="col-sm-2 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    单选人
                                </label>
                                <div class="col-sm-3">
                                	<div class="input-group">
                                		<input type="hidden" id="DANXAUNREN_ID" name="form['DANXAUNREN_ID']"  value="${form.DANXAUNREN_ID}"/> 
	                                    <span class="input-icon width-100">
	                                    <input type="text" class="form-control"  id="DANXAUNREN_NAME" 
	                                           data-validation-engine="validate[required]" placeholder="单击选择" 
	                                           name="form['DANXAUNREN_NAME']" value="${form.DANXAUNREN_NAME}"/>
	                                    <i class="ace-icon fa fa-info-circle"> </i>
	                                    </span>
	                                   <span class="input-group-btn">    
	                                        <button type="button" class="btn btn-white  " onclick="jdp_eform_clearValue(this)">
									         	<i class="ace-icon fa fa-remove"></i>
									      	</button>
	                                   </span>
                                	</div>
                                </div>
                                <label class="col-sm-1 label-middle" >
                                	<a href="javascript:void(0)" onclick="openWiki('http://192.168.0.140:8080/wiki/en/Jdp4.0.release#a_.E5.8D.95.E9.80.89.E3.80.81.E5.A4.9A.E9.80.89.E4.BA.BA')">链接wiki</a>
                                </label>
                                <label class="col-sm-2 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"> </i>
                                    多选人
                                </label>
                                <div class="col-sm-3">
                                <div class="input-group">
                                	<input type="hidden" id="DUOXAUNREN_ID" name="form['DUOXAUNREN_ID']"  value="${form.DUOXAUNREN_ID}"/> 
                                	<span class="input-icon width-100">
                                        <input type="text" class="form-control"  id="DUOXAUNREN_NAME" 
                                               data-validation-engine="validate[required]" placeholder="单击选择" 
                                               name="form['DUOXAUNREN_NAME']" value="${form.DUOXAUNREN_NAME}"/>
                                        <i class="ace-icon fa fa-info-circle"> </i>
                                   </span>
                                   <span class="input-group-btn">    
                                        <button type="button" class="btn btn-white  " onclick="jdp_eform_clearValue(this)">
								         	<i class="ace-icon fa fa-remove"></i>
								      	</button>
	                                </span>
                                 </div>
                                </div>
                                <label class="col-sm-1 label-middle" >
                                	<a href="javascript:void(0)" onclick="openWiki('http://192.168.0.140:8080/wiki/en/Jdp4.0.release#a_.E5.8D.95.E9.80.89.E3.80.81.E5.A4.9A.E9.80.89.E4.BA.BA')">链接wiki</a>
                                </label>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    单选部门
                                </label>
                                <div class="col-sm-3">
	                                <div class="input-group">
	                                <input type="hidden" id="DANXAUNBUMEN_ID" name="form['DANXAUNBUMEN_ID']"  value="${form.DANXAUNBUMEN_ID}"/> 
	                                <span class="input-icon width-100">
                                        <input type="text" class="form-control"  id="DANXAUNBUMEN_NAME" 
                                               data-validation-engine="validate[required]" placeholder="单击选择" 
                                               name="form['DANXAUNBUMEN_NAME']" value="${form.DANXAUNBUMEN_NAME}"/>
                                        <i class="ace-icon fa fa-info-circle"> </i>
                                   </span>
                                   <span class="input-group-btn">    
                                        <button type="button" class="btn btn-white  " onclick="jdp_eform_clearValue(this)">
								         	<i class="ace-icon fa fa-remove"></i>
								      	</button>
	                                </span>
	                                </div>
                                </div>
                                <label class="col-sm-1 label-middle" >
                                	<a href="javascript:void(0)" onclick="openWiki('http://192.168.0.140:8080/wiki/en/Jdp4.0.release#a_.E5.8D.95.E9.80.89.E3.80.81.E5.A4.9A.E9.80.89.E9.83.A8.E9.97.A8')">链接wiki</a>
                                </label>
                                <label class="col-sm-2 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"> </i>
                                    多选部门
                                </label>
                                <div class="col-sm-3">
                                	<div class="input-group">
                                	<input type="hidden" id="DUOXAUNBUMEN_ID" name="form['DUOXAUNBUMEN_ID']"  value="${form.DUOXAUNBUMEN_ID}"/> 
                                	<span class="input-icon width-100">
                                        <input type="text" class="form-control"  id="DUOXAUNBUMEN_NAME" 
                                               data-validation-engine="validate[required]" placeholder="单击选择" 
                                               name="form['DUOXAUNBUMEN_NAME']" value="${form.DUOXAUNBUMEN_NAME}"/>
                                        <i class="ace-icon fa fa-info-circle"> </i>
                                   </span>
                                   <span class="input-group-btn">    
                                        <button type="button" class="btn btn-white  " onclick="jdp_eform_clearValue(this)">
								         	<i class="ace-icon fa fa-remove"></i>
								      	</button>
	                                </span>
                                   </div>
                                </div>
                                 <label class="col-sm-1 label-middle" >
                                	<a href="javascript:void(0)" onclick="openWiki('http://192.168.0.140:8080/wiki/en/Jdp4.0.release#a_.E5.8D.95.E9.80.89.E3.80.81.E5.A4.9A.E9.80.89.E9.83.A8.E9.97.A8')">链接wiki</a>
                                </label>
                            </div>
                               <div class="form-group">
                                <label class="col-sm-2 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    复合选择人组件
                                </label>
                                <div class="col-sm-3">
                                <div class="input-group">
                                <input type="hidden" id="FUHEXUANZE_ID" name="form['FUHEXUANZE_ID']"  value="${form.FUHEXUANZE_ID}"/> 
                                <span class="input-icon width-100">
                                     <input type="text" class="form-control"  id="FUHEXUANZE_NAME" 
                                            data-validation-engine="validate[required]" placeholder="单击选择" 
                                            name="form['FUHEXUANZE_NAME']" value="${form.FUHEXUANZE_NAME}"/>
                                     <i class="ace-icon fa fa-info-circle"> </i>
                                </span>
                                <span class="input-group-btn">    
		                            <button type="button" class="btn btn-white  " onclick="jdp_eform_clearValue(this)">
							         	<i class="ace-icon fa fa-remove"></i>
							      	</button>
                               	</span>
                                </div>
                                </div>
                                <label class="col-sm-1 label-middle" >
                               		<a href="javascript:void(0)" onclick="openWiki('http://192.168.0.140:8080/wiki/en/Jdp4.0.release#a_.E8.87.AA.E5.AE.9A.E4.B9.89.E5.A4.8D.E5.90.88.E7.94.A8.E6.88.B7.E9.80.89.E6.8B.A9.E7.BB.84.E4.BB.B6')">链接wiki</a>
                                </label>
                            </div>
                            <hr>
                              <div class="form-group">
                                <label class="col-sm-2 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    行政区树
                                </label>
                                <div class="col-sm-3">
                                <div class="input-group">
                                <input type="hidden" id="XINGZHENGQU_ID" name="form['XINGZHENGQU_ID']"  value="${form.XINGZHENGQU_ID}"/> 
                                <span class="input-icon width-100">
                                     <input type="text" class="form-control"  id="XINGZHENGQU_NAME" 
                                            data-validation-engine="validate[required]" placeholder="单击选择" 
                                            name="form['XINGZHENGQU_NAME']" value="${form.XINGZHENGQU_NAME}"/>
                                     <i class="ace-icon fa fa-info-circle"> </i>
                                </span>
                                <span class="input-group-btn">    
                                     <button type="button" class="btn btn-white  " onclick="jdp_eform_clearValue(this)">
							         	<i class="ace-icon fa fa-remove"></i>
							      	</button>
                                </span>
                                </div>
                                </div>
                                <label class="col-sm-1 label-middle" >
                                	<a href="javascript:void(0)" onclick="openWiki('http://192.168.0.140:8080/wiki/en/Jdp4.0.release#a_.E8.A1.8C.E6.94.BF.E5.8C.BA.E6.A0.91')">链接wiki</a>
                                </label>
                                <label class="col-sm-2 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"> </i>
                                    行业树
                                </label>
                                <div class="col-sm-3">
                                	<div class="input-group">
                                	<input type="hidden" id="HANGYE_ID" name="form['HANGYE_ID']"  value="${form.HANGYE_ID}"/> 
                                	<span class="input-icon width-100">
                                        <input type="text" class="form-control"  id="HANGYE_NAME" 
                                               data-validation-engine="validate[required]" placeholder="单击选择" 
                                               name="form['HANGYE_NAME']" value="${form.HANGYE_NAME}"/>
                                        <i class="ace-icon fa fa-info-circle"> </i>
                                   	</span>
                                   	<span class="input-group-btn">    
	                                     <button type="button" class="btn btn-white  " onclick="jdp_eform_clearValue(this)">
								         	<i class="ace-icon fa fa-remove"></i>
								      	</button>
	                                </span>
                                   </div>
                                </div>
                                <label class="col-sm-1 label-middle" >
                                	<a href="javascript:void(0)" onclick="openWiki('http://192.168.0.140:8080/wiki/en/Jdp4.0.release#a_.E8.A1.8C.E4.B8.9A.E6.A0.91')">链接wiki</a>
                                </label>
                            </div>
                            <hr>
                             <div class="form-group">
                                <label class="col-sm-2 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    自定义单选树
                                </label>
                                <div class="col-sm-3">
                                <div class="input-group">
                                <input type="hidden" id="ZDYDANXUANSHU_ID" name="form['ZDYDANXUANSHU_ID']"  value="${form.ZDYDANXUANSHU_ID}"/> 
                                <span class="input-icon width-100">
                                     <input type="text" class="form-control"  id="ZDYDANXUANSHU_NAME" 
                                            data-validation-engine="validate[required]" placeholder="单击选择" 
                                            name="form['ZDYDANXUANSHU_NAME']" value="${form.ZDYDANXUANSHU_NAME}"/>
                                     <i class="ace-icon fa fa-info-circle"> </i>
                                 </span>
                                 <span class="input-group-btn">    
                                     <button type="button" class="btn btn-white  " onclick="jdp_eform_clearValue(this)">
							         	<i class="ace-icon fa fa-remove"></i>
							      	</button>
                                 </span>
                                 </div>
                                 </div>
                                 <label class="col-sm-1 label-middle" >
                                	<a href="javascript:void(0)" onclick="openWiki('http://192.168.0.140:8080/wiki/en/Jdp4.0.release#a_.E8.87.AA.E5.AE.9A.E4.B9.89.E5.8D.95.E9.80.89.E3.80.81.E5.A4.9A.E9.80.89.E6.A0.91')">链接wiki</a>
                                 </label>
                                <label class="col-sm-2 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"> </i>
                                    自定义多选树
                                </label>
                                <div class="col-sm-3">
                                	<div class="input-group">
                                	<input type="hidden" id="ZDYDUOXUANSHU_ID" name="form['ZDYDUOXUANSHU_ID']"  value="${form.ZDYDUOXUANSHU_ID}"/> 
                                	<span class="input-icon width-100">
                                        <input type="text" class="form-control"  id="ZDYDUOXUANSHU_NAME" 
                                               data-validation-engine="validate[required]" placeholder="单击选择" 
                                               name="form['ZDYDUOXUANSHU_NAME']" value="${form.ZDYDUOXUANSHU_NAME}"/>
                                        <i class="ace-icon fa fa-info-circle"> </i>
                                   </span>
                                   <span class="input-group-btn">    
                                     <button type="button" class="btn btn-white  " onclick="jdp_eform_clearValue(this)">
							         	<i class="ace-icon fa fa-remove"></i>
							      	</button>
                                 	</span>
                                   </div>
                                </div>
                                <label class="col-sm-1 label-middle" >
                               		<a href="javascript:void(0)" onclick="openWiki('http://192.168.0.140:8080/wiki/en/Jdp4.0.release#a_.E8.87.AA.E5.AE.9A.E4.B9.89.E5.8D.95.E9.80.89.E3.80.81.E5.A4.9A.E9.80.89.E6.A0.91')">链接wiki</a>
                                </label>
                            </div>
                            <hr>
                             <div class="form-group">
                                <label class="col-sm-2 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    自定义单选列表
                                </label>
                                <div class="col-sm-3">
                                <div class="input-group">
                                <input type="hidden" id="ZDYDANXUANLB_ID" name="form['ZDYDANXUANLB_ID']"  value="${form.ZDYDANXUANLB_ID}"/> 
                                <span class="input-icon width-100">
                                     <input type="text" class="form-control"  id="ZDYDANXUANLB_NAME" 
                                             placeholder="单击选择" 
                                            name="form['ZDYDANXUANLB_NAME']" value="${form.ZDYDANXUANLB_NAME}"/>
                                     <i class="ace-icon fa fa-info-circle"> </i>
                                 </span>
                                 <span class="input-group-btn">    
                                     <button type="button" class="btn btn-white  " onclick="jdp_eform_clearValue(this)">
							         	<i class="ace-icon fa fa-remove"></i>
							      	</button>
                                 </span>
                                 </div>
                                 </div>
                                 <label class="col-sm-1 label-middle" >
                                	<a href="javascript:void(0)" onclick="openWiki('http://192.168.0.140:8080/wiki/en/Jdp4.0.release#a_.E8.87.AA.E5.AE.9A.E4.B9.89.E5.8D.95.E9.80.89.E3.80.81.E5.A4.9A.E9.80.89.E5.88.97.E8.A1.A8')">链接wiki</a>
                                 </label>
                                <label class="col-sm-2 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"> </i>
                                    自定义多选列表
                                </label>
                                <div class="col-sm-3">
                                	<div class="input-group">
                                	<input type="hidden" id="ZDYDUOXUANLB_ID" name="form['ZDYDUOXUANLB_ID']"  value="${form.ZDYDUOXUANLB_ID}"/> 
                                	<span class="input-icon width-100">
                                        <input type="text" class="form-control"  id="ZDYDUOXUANLB_NAME" 
                                                placeholder="单击选择" 
                                               name="form['ZDYDUOXUANLB_NAME']" value="${form.ZDYDUOXUANLB_NAME}"/>
                                        <i class="ace-icon fa fa-info-circle"> </i>
                                   </span>
                                   <span class="input-group-btn">    
                                     <button type="button" class="btn btn-white  " onclick="jdp_eform_clearValue(this)">
							         	<i class="ace-icon fa fa-remove"></i>
							      	</button>
                                 	</span>
                                   </div>
                                </div>
                                <label class="col-sm-1 label-middle" >
                               		<a href="javascript:void(0)" onclick="openWiki('http://192.168.0.140:8080/wiki/en/Jdp4.0.release#a_.E8.87.AA.E5.AE.9A.E4.B9.89.E5.8D.95.E9.80.89.E3.80.81.E5.A4.9A.E9.80.89.E5.88.97.E8.A1.A8')">链接wiki</a>
                                </label>
                            </div>
                            <hr>
                            <div class="form-group">
                                <label class="col-sm-2 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    异步加载单选树
                                </label>
                                <div class="col-sm-3">
                                <div class="input-group">
                                <input type="hidden" id="ZDYDANXUANSHU_ASYNC_ID" name="form['ZDYDANXUANSHU_ASYNC_ID']"  value="${form.ZDYDANXUANSHU_ASYNC_ID}"/> 
                                <span class="input-icon width-100">
                                     <input type="text" class="form-control"  id="ZDYDANXUANSHU_ASYNC_NAME" 
                                            data-validation-engine="validate[required]" placeholder="单击选择" 
                                            name="form['ZDYDANXUANSHU_ASYNC_NAME']" value="${form.ZDYDANXUANSHU_ASYNC_NAME}"/>
                                     <i class="ace-icon fa fa-info-circle"> </i>
                                 </span>
                                 <span class="input-group-btn">    
                                     <button type="button" class="btn btn-white  " onclick="jdp_eform_clearValue(this)">
							         	<i class="ace-icon fa fa-remove"></i>
							      	</button>
                                 </span>
                                 </div>
                                 </div>
                                 <label class="col-sm-1 label-middle" >
                                	<a href="javascript:void(0)" onclick="openWiki('http://192.168.0.140:8080/wiki/en/Jdp4.0.release#a_.E8.87.AA.E5.AE.9A.E4.B9.89.E5.8D.95.E9.80.89.E3.80.81.E5.A4.9A.E9.80.89.E6.A0.91')">链接wiki</a>
                                 </label>
                				<label class="col-sm-2 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
									cron表达式
                                </label>
                                <div class="col-sm-3">
                                	<div class="input-group">
		                                <span class="width-100">
		                                     <input type="text" class="form-control" id="cronExpression" 
		                                            data-validation-engine="validate[required]" placeholder="单击选择" />
		                                 </span>
		                                 <span class="input-group-btn">    
		                                     <button type="button" class="btn btn-white  " onclick="jdp_eform_clearValue(this)">
									         	<i class="ace-icon fa fa-remove"></i>
									      	</button>
		                                 </span>
		                      		</div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div><!-- /.row -->
            </div>
        </div><!--/.main-content-inner-->
    </div><!-- /.main-content -->
</div><!-- /.main-container -->
</div>
<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>

<!-- 自己写的JS，请放在这里 -->
<script type="text/javascript">
	//返回
	function goBack() {
	    $("#main-container",window.parent.document).show();
	    $("#iframeInfo",window.parent.document).attr("src","").hide();
	}
	
	
//单选人------------
$("#DANXAUNREN_NAME").on(ace.click_event,function(){
	//dialog的使用，请参考官方文档http://aui.github.io/artDialog/doc/index.html
	dialog({
	       id:"dialog",
	       title: '选择',
	       url: '${ctx}/common/ou/selUser.html?closeCallback=closeDialog&hiddenId=DANXAUNREN_ID&textId=DANXAUNREN_NAME&orgid=root&onlymain=1&showChildOrg=true',
	       width:550,
	       height:500>document.documentElement.clientHeight?document.documentElement.clientHeight:500,
	}).showModal();
});

function userSelectCallBack(user){
	$("#DANXAUNREN_ID").val(user.loginName);
	$("#DANXAUNREN_NAME").val(user.name);
        //user返回json,例如{loginName:"wangml",name:"王明力",id:"idxxx",deptid:"deptidxx",dept:"信息中心"}
    console.log(user.loginName);
    console.log(user.name);
    console.log(user.dept);
    closeDialog();
}

function closeDialog(dialogId){
	if(dialogId && dialogId.length > 0){
		dialog.get(dialogId).close().remove();
	}else{
		dialog.get("dialog").close().remove();
	}
}


//多选人------------------------------------------------------------
$("#DUOXAUNREN_NAME").on(ace.click_event,function(){
	  // 父页面弹框示例
	dialog({
	       id:"dialog",
	       title: '选择',
	       url: '${ctx}/common/ou/selUserMuti.html?closeCallback=closeDialog&hiddenId=DUOXAUNREN_ID&textId=DUOXAUNREN_NAME',
	       width:550,
	       height:500>document.documentElement.clientHeight?document.documentElement.clientHeight:500,
	}).showModal();
});

function userSelectMutiCallBack(users){
	//users返回为json数组，格式为[{loginName:"wangml",name:"王明力",id:"idxxx",deptid:"deptidxx",dept:"信息中心"}]
	var DUOXAUNREN_ID="";
	var DUOXAUNREN_NAME="";
	
		$.each(users,function(i){
			var sep=",";
   			if(i==0){
   				sep="";
   			}
			DUOXAUNREN_ID =DUOXAUNREN_ID+sep+ this.loginName; 
			DUOXAUNREN_NAME =DUOXAUNREN_NAME+sep+ this.name; 
        });
		$("#DUOXAUNREN_ID").val(DUOXAUNREN_ID);
		$("#DUOXAUNREN_NAME").val(DUOXAUNREN_NAME);
	console.log(users);
}


//单选部门------------------------------------------------------------
    $("#DANXAUNBUMEN_NAME").on(ace.click_event,function(){
	dialog({
	       id:"dialog",
	       title: '选择',
	       url: '${ctx}/common/ou/treeDept.html?closeCallback=closeDialog&callback=deptSelectCallBack',
	       width:550,
	       height:500>document.documentElement.clientHeight?document.documentElement.clientHeight:500,
	}).showModal();
    });

    function deptSelectCallBack(dept){
            //dept返回json,例如{id: "P00AE4DBCF194B7BB7214ED0ED41E979", name: "海淀区环保局", code: "hdq"}
	    console.log(dept);
	    $("#DANXAUNBUMEN_ID").val(dept.id);
		$("#DANXAUNBUMEN_NAME").val(dept.name);
	}
  
  
//多选部门------------------------------------------------------------
     $("#DUOXAUNBUMEN_NAME").on(ace.click_event,function(){
    dialog({
       id:"dialog",
       title: '选择',
       url: '${ctx}/common/ou/treeDeptMuti.html?hiddenId=DUOXAUNBUMEN_ID&textId=DUOXAUNBUMEN_NAME&closeCallback=closeDialog&callback=deptSelectMutiCallBack',
       width:550,
       height:500>document.documentElement.clientHeight?document.documentElement.clientHeight:500,
	}).showModal();
     });

    function deptSelectMutiCallBack(depts){
	//depts返回为json数组，格式为[{id: "P00AE4DBCF194B7BB7214ED0ED41E979", name: "海淀区环保局", code: "hdq"}]
	console.log(depts);
	var DUOXAUNBUMEN_ID="";
	var DUOXAUNBUMEN_NAME="";
	
		$.each(depts,function(i){
			var sep=",";
   			if(i==0){
   				sep="";
   			}
			DUOXAUNBUMEN_ID =DUOXAUNBUMEN_ID+sep+ this.id; 
			DUOXAUNBUMEN_NAME =DUOXAUNBUMEN_NAME+sep+ this.name; 
        });
		$("#DUOXAUNBUMEN_ID").val(DUOXAUNBUMEN_ID);
		$("#DUOXAUNBUMEN_NAME").val(DUOXAUNBUMEN_NAME);
}


//行政区------------------------------------------------------------
$("#XINGZHENGQU_NAME").on(ace.click_event,function(){
    dialog({
	id:"dialog",
        title: '选择',
        url: '${ctx}/eform/tree/window.vm?treetype=1&sqlpackage=ths.jdp.eform.mapper.TreeMapper&mapperid=jdp_region_tree&closeCallback=closeDialog&callback=treeCallBack1',
        width:550,
        height:500>document.documentElement.clientHeight?document.documentElement.clientHeight:500,
}).showModal();
});

    function treeCallBack1(tree){
	//{"TREE_ID":"110000000000","TREE_PID":"000000000000","TREE_NAME":"北京市"....}
	console.log(tree);
	var XINGZHENGQU_ID=tree.TREE_ID;
	var XINGZHENGQU_NAME=tree.TREE_NAME;
	
		$("#XINGZHENGQU_ID").val(XINGZHENGQU_ID);
		$("#XINGZHENGQU_NAME").val(XINGZHENGQU_NAME);
}


//行业------------------------------------------------------------
$("#HANGYE_NAME").on(ace.click_event,function(){
    dialog({
	id:"dialog",
        title: '选择',
        url: '${ctx}/eform/tree/window.vm?treetype=1&sqlpackage=ths.jdp.eform.mapper.TreeMapper&mapperid=jdp_trade_tree&closeCallback=closeDialog&callback=treeCallBackhy',
        width:550,
        height:500>document.documentElement.clientHeight?document.documentElement.clientHeight:500,
}).showModal();
});

//父页面回调函数示例
    function treeCallBackhy(tree){
	//depts返回为json数组，格式为[{id: "P00AE4DBCF194B7BB7214ED0ED41E979", name: "制造业"}]
	console.log(tree);
	$("#HANGYE_ID").val(tree.TREE_ID);
	$("#HANGYE_NAME").val(tree.TREE_NAME);
}

//自定义单选树------------------------------------------------------------
$("#ZDYDANXUANSHU_NAME").on(ace.click_event,function(){
    dialog({
	id:"dialog",
        title: '选择',
	//（sqlpackage、mapperid）与formcell_dictionary只需一种即可，如果同时存在，（sqlpackage、mapperid）优先
        url: '${ctx}/eform/tree/window.vm?closeCallback=closeDialog&callback=treeDanxuanCallBack1&treetype=1&sqlpackage=ths.jdp.eform.mapper.CustomTreeMapper&mapperid=custon_region_tree',
        width:550,
        height:500>document.documentElement.clientHeight?document.documentElement.clientHeight:500,
}).showModal();
});

//父页面回调函数示例
    function treeDanxuanCallBack1(tree){
	//depts返回为json数组，格式为{id: "", name: ""}
	console.log(tree);
	$("#ZDYDANXUANSHU_ID").val(tree.TREE_ID);
	$("#ZDYDANXUANSHU_NAME").val(tree.TREE_NAME);
}
//异步加载单选树------------------------------------------------------------
//自定义单选树------------------------------------------------------------
$("#ZDYDANXUANSHU_ASYNC_NAME").on(ace.click_event,function(){
    dialog({
	id:"dialog",
        title: '选择',
	//（sqlpackage、mapperid）与formcell_dictionary只需一种即可，如果同时存在，（sqlpackage、mapperid）优先
        url: '${ctx}/eform/tree/window.vm?closeCallback=closeDialog&callback=asyncTreeDanxuanCallBack1&treetype=1&sqlpackage=ths.jdp.eform.mapper.CustomTreeMapper&mapperid=custon_region_tree&async=true',
        width:550,
        height:500>document.documentElement.clientHeight?document.documentElement.clientHeight:500,
}).showModal();
});

//父页面回调函数示例
    function asyncTreeDanxuanCallBack1(tree){
	//depts返回为json数组，格式为{id: "", name: ""}
	console.log(tree);
	$("#ZDYDANXUANSHU_ASYNC_ID").val(tree.TREE_ID);
	$("#ZDYDANXUANSHU_ASYNC_NAME").val(tree.TREE_NAME);
}
//自定义多选树------------------------------------------------------------
   $("#ZDYDUOXUANSHU_NAME").on(ace.click_event,function(){
        dialog({
    	id:"dialog",
            title: '选择',
    	//（sqlpackage、mapperid）与formcell_dictionary只需一种即可，如果同时存在，（sqlpackage、mapperid）优先
            url: '${ctx}/eform/tree/window.vm?closeCallback=closeDialog&callback=treeDanxuanCallBack&treetype=2&sqlpackage=ths.jdp.eform.mapper.CustomTreeMapper&mapperid=custon_region_tree&hiddenId=ZDYDUOXUANSHU_ID&showLevel=2',
            width:550,
            height:500>document.documentElement.clientHeight?document.documentElement.clientHeight:500,
    }).showModal();
    });

    //父页面回调函数示例
        function treeDanxuanCallBack(tree){
        	var ZDYDUOXUANSHU_ID="";
        	var ZDYDUOXUANSHU_NAME="";
       		$.each(tree,function(i){
       			var sep=",";
       			if(i==0){
       				sep="";
       			}
       			ZDYDUOXUANSHU_ID =ZDYDUOXUANSHU_ID+sep+ this.TREE_ID; 
       			ZDYDUOXUANSHU_NAME =ZDYDUOXUANSHU_NAME+sep+ this.TREE_NAME; 
               });
       		$("#ZDYDUOXUANSHU_ID").val(ZDYDUOXUANSHU_ID);
       		$("#ZDYDUOXUANSHU_NAME").val(ZDYDUOXUANSHU_NAME);
    	console.log(tree);
    }
    
    $("#ZDYDANXUANLB_NAME").on(ace.click_event,function(){
    	dialog({
    		id:"dialog",
    	        title: '选择',
    		//（sqlpackage、mapperid）与formcell_dictionary只需一种即可，如果同时存在，（sqlpackage、mapperid）优先
    	        url: '${ctx}/eform/components/table/table_choose.vm?selectType=1&sqlpackage=ths.jdp.eform.mapper.CustomTreeMapper&mapperid=custom_control_table&callback=tableCallback&closeCallback=closeDialog',
    	        width:550,
    	        height:500>document.documentElement.clientHeight?document.documentElement.clientHeight:500
    	}).showModal();
    })
    //自定义单选列表
    function tableCallback(table){
		//depts返回为json数组，格式为{CODE: "", NAME: ""}
    	$("#ZDYDANXUANLB_ID").val(table.CODE);
    	$("#ZDYDANXUANLB_NAME").val(table.NAME);
	}
    
    $("#ZDYDUOXUANLB_NAME").on(ace.click_event,function(){
    	dialog({
    		id:"dialog",
    	        title: '选择',
    		//（sqlpackage、mapperid）与formcell_dictionary只需一种即可，如果同时存在，（sqlpackage、mapperid）优先
    	        url: '${ctx}/eform/components/table/table_choose.vm?hiddenId=ZDYDUOXUANLB_ID&textId=ZDYDUOXUANLB_NAME&selectType=2&sqlpackage=ths.jdp.eform.mapper.CustomTreeMapper&mapperid=custom_control_table&callback=tablesCallback&closeCallback=closeDialog',
    	        width:550,
    	        height:500>document.documentElement.clientHeight?document.documentElement.clientHeight:500
    	}).showModal();
    })
    //自定义单选列表
    function tablesCallback(tables){
    	console.log(tables)
		//depts返回为json数组，格式为{CODE: "", NAME: ""}
    	var ZDYDUOXUANLB_ID="";
    	var ZDYDUOXUANLB_NAME="";
   		$.each(tables,function(i){
   			var sep=",";
   			if(i==0){
   				sep="";
   			}
   			ZDYDUOXUANLB_ID =ZDYDUOXUANLB_ID+sep+this.CODE; 
   			ZDYDUOXUANLB_NAME =ZDYDUOXUANLB_NAME+sep+this.NAME; 
        });
   		$("#ZDYDUOXUANLB_ID").val(ZDYDUOXUANLB_ID);
   		$("#ZDYDUOXUANLB_NAME").val(ZDYDUOXUANLB_NAME);
	}
//FUHEXUANZE
   $("#FUHEXUANZE_NAME").on(ace.click_event,function(){
	    dialog({
		    id:"dialog",
		    title: '选择',
		    url: "${ctx}/common/ou/selGeneralUser.html?hiddenId=FUHEXUANZE_ID&callback=jdp_bpm_read_complexUserChoose&closeCallback=closeDialog",
		    width:800,
		    height:450
		}).showModal();
   });
	
	function jdp_bpm_read_complexUserChoose(complexUserObjs){
            //值示例：{user:[{id:"uuid",code:"zhangsan",name:"张三"},{id:"uuid",code:"lisi",name:"李四"}],dept:[{id:"",code:"ceshibu",name:"测试部"}],role:[],group:[],position:[]}
			var FUHEXUANZE_ID="";
       	   	var FUHEXUANZE_NAME="";
            for(var type in complexUserObjs){
				$.each(complexUserObjs[type], function(i){
					FUHEXUANZE_NAME =FUHEXUANZE_NAME + this.name + ","; 
				});
			}
       		$("#FUHEXUANZE_ID").val(JSON.stringify(complexUserObjs));
       		$("#FUHEXUANZE_NAME").val(FUHEXUANZE_NAME);
	}
	//cronExpression
	$("#cronExpression").on(ace.click_event,function(){
	    dialog({
		    id:"cron-edit",
		    title: '选择',
		    url: "${ctx}/common/cron/cron.jsp?cronField=cronExpression&dialogId=cron-edit",
		    width:420,
		    height:355
		}).showModal();
   });
	
	function getComplexUserVal(hiddenId){
		return $("#" + hiddenId + "").val();
	}
	
	function openWiki(url){
		window.open(url);
	}

	jQuery(function ($) {
	    //日期控件使用示例，详细文档请参考http://www.my97.net/dp/demo/index.htm
	    $("#btnSignDate").on(ace.click_event, function () {
	        WdatePicker({el: 'txtSignDate'});
	    });
	
	    //表单验证组件初始化，详细文档请参考http://code.ciaoca.com/jquery/validation-engine/ 或官网文档http://posabsolute.github.io/jQuery-Validation-Engine/
	    /* $("#formInfo").validationEngine({
	        scrollOffset: 98,//必须设置，因为Toolbar position为Fixed
	        promptPosition: 'bottomLeft',
	        autoHidePrompt: true
	    }); */
	    
	});
  


</script>
</body>
</html>

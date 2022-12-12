<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<%@ taglib prefix="ths" uri="/WEB-INF/tag/ths.tld"%>
<!DOCTYPE html>
<html lang="zh">
<head>
    <title>修改密码</title>
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
</head>

<body class="no-skin">

<div class="main-container" id="main-container">
    <div class="main-content">
         <div class="main-content-inner fixed-page-header fixed-40">
            <div id="breadcrumbs" class="breadcrumbs">
                <ul class="breadcrumb">
                    <li class="active">
                        <h5 class="page-title" >
                            <i class="fa fa-file-text-o"></i>
                            修改密码
                        </h5>
                    </li>
                </ul><!-- /.breadcrumb -->

            </div>
        </div>

        <div class="main-content-inner padding-page-content">
            <div class="page-toolbar align-right">
                <button type="button" class="btn btn-xs btn-primary btn-xs-ths" id="btnSave" >
                    <i class="ace-icon fa fa-save"></i>
                    保存
                </button>
	            <button type="button" class="btn btn-xs btn-danger btn-xs-ths" id="btnReturn">
	                    <i class="ace-icon fa fa-power-off"></i>
	           关闭
	            </button>
            </div>
            <div class="page-content">
                <div class="space-4"></div>
                <div class="row">
                    <div class=" col-xs-12">
                        <form class="form-horizontal" id="form1" name="form1" action="" method="post">
                            <input type="hidden" name="form['USER_ID']" id="userid" value="${form.USER_ID}"/> 
                            <input type="hidden" name="form['LOGIN_NAME']" id="userid" value="${form.LOGIN_NAME}"/> 
                            <input type="hidden" name="form['LAST_TOKEN']" id="userid" value="${LAST_TOKEN}"/> 
                            <div class="form-group">
                                <label class="col-sm-2 control-label no-padding-right" for="txtName">
                                    姓名
                                </label>
                                <div class="col-sm-4">
                                    <span class="input-icon width-100">
                                        <input type="text" class="form-control" disabled="disabled" value="${form.USER_NAME}"/>
                                        <i class="ace-icon fa fa-user"> </i>
                                   </span>

                                </div>
                                <label class="col-sm-2 control-label no-padding-right" for="txtName">
                                    登录名
                                </label>
                                <div class="col-sm-4">
                                	<input type="text" class="form-control" disabled="disabled" value="${form.LOGIN_NAME}"/>
                                </div>
                                
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label no-padding-right" for="txtName">
                                    主部门
                                </label>
                                <div class="col-sm-4">
                                    <input type="text" class="form-control"  disabled="disabled" value="${form.DEPT_NAME}"/>
                                </div>
                            	<label class="col-sm-2 control-label no-padding-right" for="txtName">
                                    状态
                                </label>
                                <div class="col-sm-4">
                                    <input type="text" class="form-control"  disabled="disabled"
                                    	<c:if test="${form.STATUS==10}">value="启用"</c:if>
                                    	<c:if test="${form.STATUS==-10}">value="停用"</c:if>
                                    />
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label no-padding-right">
                                    兼职部门</label>
                                <div class="col-sm-8">
                                    <div class="chosen-container chosen-container-multi width-100" style="border: solid 1px #D5D5D5; min-height: 62px ">
                                        <ul class="chosen-choices"  style="border: none" id="dept_list_ul">

                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label no-padding-right "><i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    旧密码</label>
                                <div class="col-sm-4">
                                    <input id="oldPassword" type="password" class="form-control pswd" maxlength="20" data-validation-engine="validate[required]" 
                                    name="form['PASSWORD']" />
                                </div>
                                
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label no-padding-right "><i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    新密码</label>
                                <div class="col-sm-4">
                                    <input id="password" type="password" class="form-control pswd" maxlength="20" data-validation-engine="validate[required,minSize[6],funcCall[passwordLevel]]" 
                                    name="form['NEW_PASSWORD']" onchange="complex('password')" />
                                </div>
                                <div class="col-sm-1 control-label">
                                	<span id="complex"></span>
                                </div>
                                <label class="col-sm-1 control-label no-padding-right" ><i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    确认新密码</label>
                                <div class="col-sm-4">
                                    <input type="password" class="form-control pswd" maxlength="20" data-validation-engine="validate[required,funcCall[checkPassword]]"/>
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
<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
<!-- 自己写的JS，请放在这里 -->
<script type="text/javascript">
	function complex(id){
		var value = $("#"+id).val();
		var level = checkPass(value);
		$("#complex").empty();
		if(level==1){
			$("#complex").css("color","gray");
			$("#complex").text("密码等级:低");
			return;
		}
		if(level==2){
			$("#complex").css("color","green");
			$("#complex").text("密码等级:中");
			return;
		}
		if(level==3){
			$("#complex").css("color","orange");
			$("#complex").text("密码等级:较高");
			return;
		}
		if(level==4){
			$("#complex").css("color","red");
			$("#complex").text("密码等级:高");
			return;
		}
	}
	
    function passwordLevel(field, rules, i, options){
    	 var password = field.val()
    	 var level = '${form.passwordLevel}';
	   	 if(checkPass(password)<level){
	   		if(level==1){
				return "* 密码至少包含为数字、小写字母、大写字母、特殊字符中的一种";
			}
			if(level==2){
				return "* 密码至少包含为数字、小写字母、大写字母、特殊字符中的两种";
			}
			if(level==3){
				return "* 密码至少包含为数字、小写字母、大写字母、特殊字符中的三种";
			}
			if(level==4){
				return "* 密码至少包含为数字、小写字母、大写字母、特殊字符中的四种";
			}
	   	 }
    }
	
	function checkPass(s){
		var ls = 0;
		if(s.length < 6){
            return 0;
        }
 		if(s.match(/([0-9])+/)){
		    ls++; 
		}
		if(s.match(/([a-z])+/)){
		    ls++;
		}
		if(s.match(/([A-Z])+/)){
		    ls++;
		}
		if(s.match(/[^a-zA-Z0-9]+/)){
		    ls++;
		}
		return ls 
	}

	function changeDeptList(){
    	$("#dept_list_ul").children().remove();
    	var liList="";
    	var deptNames = "${form.MUTI_DEPT_NAME}"
    	if(deptNames!=null && deptNames!=""){
	    	var array =  deptNames.split(",");
	    	for(i=0;i<array.length;i++){
	    		var userHtml='<li class="search-choice"><span>'+array[i]+'</span>';
	   			userHtml+='</li>';
	   			liList+=userHtml;
	    	}
	    	$("#dept_list_ul").append(liList);
    	}
    }
	
    jQuery(function ($) {
    	changeDeptList();
    	
        $("#form1").validationEngine({
            scrollOffset: 98,//必须设置，因为Toolbar position为Fixed
            promptPosition: 'bottomLeft',
            autoHidePrompt: true,
            validateNonVisibleFields:true
        });

        $("#btnSave").on(ace.click_event, function () {
        	if ($('#form1').validationEngine('validate')) {
        	 $.ajax({
        		   type: "post",
        		   url: "${ctx}/modifyPassord.vm",
        		   data: $("#form1").serialize(),
        		   dataType:"json",
        		   success: function(jsonObj){
        			   //console.log(response);
        			   if(jsonObj.success){
        				   dialog({
        					   title:"信息",
        					   content:"密码修改成功",
        					   okValue:"确定",
        					   ok:function(){
        						   $(".pswd").val("");
	   		        			   $("#complex").empty();
	   							   if(${not empty service}){
	   							 		url = "${service}"
	   							 		window.location.href=url;
	   							   }else{
		   								var userAgent = navigator.userAgent;
		   							    if (userAgent.indexOf("Firefox") != -1 || userAgent.indexOf("Chrome") != -1) {
		   							        location.href = "about:blank";
		   							    } else {
		   							        window.opener = null;
		   							        window.open('', '_self');
		   							    }
		   							    window.close();
	   							   }
        					   }
        				   }).showModal();
        			   }else{
        				   dialog({
        					   title:"错误",
        					   content:jsonObj.message,
        					   okValue:"确定",
        					   ok:function(){
        						   window.location.reload();
        					   }
        				   }).showModal();
        			   }
        		   },
				   error : function(error) {
					   console.log(error);
				   }
        	  });
        	}
        });
        
        $("#btnReturn").on(ace.click_event, function () {
        	window.close();
        });
        
    });
  
    //检查两次输入密码是否一致
    function checkPassword(field, rules, i, options){
	   	 if(field.val()!=$("#password").val()){
	   		 return "* 两次输入的密码不一致"
	   	 }
    }
    
</script>

</body>
</html>

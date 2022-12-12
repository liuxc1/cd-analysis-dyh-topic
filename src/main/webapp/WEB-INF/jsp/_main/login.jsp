<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>登录</title>
	<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
	<!--页面自定义的CSS，请放在这里 -->
    <link rel="stylesheet" href="${ctx}/assets/custom/analysis/_main/css/login.css"> </link>
</head>

<body>
<div class="container">
    <div class="wrapper">
        <div class="container-title"></div>
        <div class="middle">
            <div class="container-logo"></div>
            <form id="ouForm" class="login-form" action="">
                <h1>登录</h1>
                <div class="user">
                    <i class="user-name-img"></i>
                    <span class="split"></span>
                    <input id="txtUserName" class="user-name" type="text" placeholder="请输入你的账号" data-validation-engine="validate[required]"  data-prompt-position="topRight: 0,20"
                            maxlength="20">
                </div>
                <div class="paw">
                    <i class="password-img"></i>
                    <span class="split"></span>
                    <input id="password" class="password" type="password" placeholder="请输入密码" data-validation-engine="validate[required]" data-prompt-position="topRight: 0,20" maxlength="20">
                </div>
               <div class="verification-code">
                    <input type="text" id="code_input" value="" placeholder="验证码" data-validation-engine="validate[required]"/>
                    <div class="code" id="v_container">

                    </div>
                </div>
                <%--<div class="remember">
                   <input id="my-id" type="checkbox" /><label for="my-id">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;记住密码</label>
               </div>--%>
                <button class="submit" id="submit" type="button" onclick="login()">登录</button>
                <div id="dError" class="alert alert-block alert-danger width-100" style="display: none;">
                    <i class="ace-icon fa fa-times-circle red2" ></i>
                    用户名或密码错误！
                </div>
            </form>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
<script type="text/javascript" src="${ctx}/assets/custom/analysis/_main/js/verification.js"></script>
<script type="text/javascript">
    var verifyCode = new GVerify("v_container");
    jQuery(function($) {
		//给整个窗口注册回车keydown事件
		$(window).keydown(function(event){
			if(event.keyCode==13){
				login();
			}
		});
		
		//让帐号文本框获得焦点
		$("#txtUserName").focus();

        $('#ouForm').validationEngine();

        $("#txtUserName").on("focus",function(e){
            $("#dError").hide();
        });
        $("#code_input").on("focus",function(e){
            $("#dError").hide();
        });
    });
    
    function login(){
    	//验证
	    var flag=$("#ouForm").validationEngine("validate");
        var res = verifyCode.validate(document.getElementById("code_input").value);
   		if(!flag){
   			return ; 
   		}
        if(!res){
            $("#dError").text("验证码错误！");
            $("#dError").show();
            return ;
        }
    	var loginname=$("#txtUserName").val();
    	var password=$("#password").val();
    	$.ajax( {  
  	        url:'${ctx}/login.vm?format=json',// 跳转到 action  
  	        type:'post',  
  	        cache:false,  
  	        contentType:'application/json',
  	        data:JSON.stringify({'loginName':loginname,'password':password}),
  	        dataType:'json',  
  	        success:function(data) {
  	        	if(data.status=='1'){//登录成功
  	        		window.location.href="${ctx}/index.vm";
  	        	}else{
  	        		$("#dError").show();
  	        	}
  	         },  
  	         error : function() {  
  	        	 console.log("error");
  	         }  
  	    });
        
    }
    
    
  	//如果当前窗口不是顶层窗口
	if(window.self!=window.top){
		window.top.location.href='${ctx}/loginpage.vm';
	}
</script>
</body>
</html>

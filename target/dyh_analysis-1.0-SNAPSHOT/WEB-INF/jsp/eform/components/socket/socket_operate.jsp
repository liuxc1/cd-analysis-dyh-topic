<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
<head>
    <title>客户端发送命令</title>
	<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
  	<!--页面自定义的CSS，请放在这里 -->
    <style type="text/css">

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
                            向${form.customCode}客户端发送命令
                        </h5>
                    </li>
                </ul><!-- /.breadcrumb -->

            </div>
            <div class="page-toolbar align-right">
                <button type="button" class="btn btn-xs    btn-xs-ths" id="btnSubmit" data-self-js="doSubmit()">
                    <i class="ace-icon fa fa-check"></i>
                    提交
                </button>
                <button type="button" class="btn btn-xs btn-xs-ths" id="btnReturn" data-self-js="goBack()">
                    <i class="ace-icon fa fa-reply"></i>
                    返回
                </button>
                <div class="space-2"></div>
                <hr class="no-margin">
            </div>

        </div>
        <div class="main-content-inner padding-page-content">
            <div class="page-content">
                <div class="space-4"></div>
                <div class="row">
                    <div class=" col-xs-12">
                        <form class="form-horizontal" role="form" id="formInfo" action="" method="post">
                            <div class="form-group">
                                <div class="col-sm-12">
                                	<input type="hidden" name="form['customCode']" value="${form.customCode}">
                                	<input type="hidden" name="form['customId']" value="${form.customId}">
                                    <textarea class="form-control" id="txtarea" placeholder="可拖动的大文本框"
                                     name="form['command']"  value=""
                                     data-validation-engine="validate[required]"
                                     style="height: 160px;"></textarea>
                                </div>

                            </div>
                        </form>
                    </div>
                </div><!-- /.row -->
            </div>
        </div><!--/.main-content-inner-->
    </div><!-- /.main-content -->
</div><!-- /.main-container -->

<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>

<!-- 自己写的JS，请放在这里 -->
<script type="text/javascript">
	
	//提交
	function doSubmit(){
		//提交之前验证表单
	    if ($('#formInfo').validationEngine('validate')) {
	    	
	    	if(!confirm("确认提交吗？")){
				return;
			}
	    	
	        ths.submitFormAjax({
	            url:'socket_send.vm',// any URL you want to submit
	            data:$("#formInfo").serialize()// 如果不需要提交整个表单，可构造JSON提交，如{name:'老王',age:50}
	        	//如需自行处理返回值，请增加以下代码
	        	/*
	        	,success:function (response) {
					
				}
	        	*/
	        });
	    }
	}
	
	//返回
	function goBack() {
	    $("#main-container",window.parent.document).show();
	    $("#iframeInfo",window.parent.document).attr("src","").hide();
	}
	
	/**
	*这里的代码主要是选择人、选择部门的示例代码
	*请参考各组件HTML页面中的调用说明
	**/
	
	//单选人回调
	function userSelectCallBack(user){
		//console.log(user); 此代码可将user所有属性打印到浏览器console
		$("#txtManngerId").val(user.loginName);
		$("#txtMannger").val(user.name);
	}
	//关闭单选人Dialog
	function closeSelectUserDialog(){
		dialog.get("dialog-user").close().remove();
	}
	
	//多选人变量
	var selectUsers = [
			<c:forEach var="user"   items="${manager}" varStatus="status">
			{loginName:"${user.LOGIN}",name:"${user.NAME}"}
			<c:if test="${!empty manager[status.index+1]}">,</c:if>
			</c:forEach> 
	]; 
	//多选人回调
	function userSelectMutiCallBack(users){
		//console.log(users);
        //selectUsers = users;//这行代码一定要写，用于二次打开选择人Dialog的已选中数据回显
        
        //将选择的用户显示在界面上
        //注意：这里仅显示，需要在表单提交前，将selectUsers的值写入到Hidden中提交
        //参考 save(){}方法
        showMutiUserSelected(users);
     }
	//多选人界面显示
	function showMutiUserSelected(users)
	{
		var listHTML = "" ;
		$.each(users,function(i){
        	listHTML+="<li class='search-choice' >";
        	listHTML+="<span>"+this.name+"</span>";
        	listHTML+="<a class='search-choice-close' onclick=\"$(this).parent().remove();removeUser('"+this.loginName+"')\"></a>";
        	listHTML+="</li>";
        });
		selectUsers=users;
        $("#manageUserUl").html(listHTML);
	}
	function removeUser(loginName){
		 $.each(selectUsers,function(i){
	        	if(this.loginName == loginName){
	        		selectUsers.removeAt(i);
	        		return;
	        	}
	      });
	}
     //关闭多选人Dialog
     function closeSelectMutiUserDialog(){
    	 dialog.get("dialog-user-muti").close().remove();
     }
     
     //单选部门
     function deptSelectCallBack(dept){
        //console.log(dept);
    	$("#txtDeptID").val(dept.id);
 		$("#txtDeptName").val(dept.name);
      }
     //关闭选择部门Dialog
      function closeSelectDeptDialog(){
            dialog.get("dialog-dept").close().remove();
      }
      
     function selectUser(){
    	 dialog({
				id:"dialog-user-test",
	            title: '选择',
	            url: '${ctx}/common/ou/selUser.html',
	            width:600,
	            height:510>document.documentElement.clientHeight?document.documentElement.clientHeight:510,
	        }).showModal();
     }
	 function selectDept(){
		 dialog({
				id:"dialog-dept-test",
	            title: '选择',
	            url: '${ctx}/common/ou/treeDept.html',
	            width:550,
	            height:510>document.documentElement.clientHeight?document.documentElement.clientHeight:510,
	        }).showModal();
	 }
	 
	jQuery(function($){
		
		$("#btnChooseManager").on(ace.click_event,function(){
			//dialog的使用，请参考官方文档http://aui.github.io/artDialog/doc/index.html
			dialog({
				id:"dialog-user",
	            title: '选择',
	            url: '${ctx}/common/ou/selUser.html',
	            width:600,
	            height:500>document.documentElement.clientHeight?document.documentElement.clientHeight:500,
	        }).showModal();
		});
		$("#btnChooseManagerX").on(ace.click_event,function(){
			$("#txtManngerId").val("");
			$("#txtMannger").val("");
		});
		
		
		$("#btnChooseDeptManager").on(ace.click_event,function(){
			//dialog的使用，请参考官方文档http://aui.github.io/artDialog/doc/index.html
			dialog({
				id:"dialog-user-muti",
	            title: '选择',
	            url: '${ctx}/common/ou/selUserMuti.html?hiddenId=txtDeptManagerId&textId=txtDeptManager',
	            width:600,
	            height:510>document.documentElement.clientHeight?document.documentElement.clientHeight:510,
	        }).showModal();
		});
		$("#btnChooseDeptManagerX").on(ace.click_event,function(){
			selectUsers=[];
			$("#manageUserUl").html("");
		});
		
		
		$("#btnChooseDept").on(ace.click_event,function(){
			//dialog的使用，请参考官方文档http://aui.github.io/artDialog/doc/index.html
			dialog({
				id:"dialog-dept",
	            title: '选择',
	            url: '${ctx}/common/ou/treeDept.html',
	            width:350,
	            height:500>document.documentElement.clientHeight?document.documentElement.clientHeight:500,
	        }).showModal();
		});
		
		$("#btnChooseDeptX").on(ace.click_event,function(){
			$("#txtDeptID").val("");
	 		$("#txtDeptName").val("");
		});
				
		jQuery(function ($) {
		    //日期控件使用示例，详细文档请参考http://www.my97.net/dp/demo/index.htm
		    $("#btnSignDate").on(ace.click_event, function () {
		        WdatePicker({el: 'txtSignDate'});
		    });
		
		    //表单验证组件初始化，详细文档请参考http://code.ciaoca.com/jquery/validation-engine/ 或官网文档http://posabsolute.github.io/jQuery-Validation-Engine/
		    $("#formInfo").validationEngine({
		        scrollOffset: 98,//必须设置，因为Toolbar position为Fixed
		        promptPosition: 'bottomLeft',
		        autoHidePrompt: true
		    });
		    
		});
		
	});
</script>
</body>
</html>

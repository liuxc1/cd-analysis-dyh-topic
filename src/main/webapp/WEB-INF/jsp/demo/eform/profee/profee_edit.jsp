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
        <div class="main-content-inner fixed-page-header fixed-40">
            <div id="breadcrumbs" class="breadcrumbs">
                <ul class="breadcrumb">
                    <li class="active">
                        <h5 class="page-title" >
                            <i class="fa fa-edit"></i>
                            <span class="THS_JDP_RES_DESC">${THS_JDP_RES_DESC}</span>
                        </h5>
                    </li>
                </ul><!-- /.breadcrumb -->

            </div>

        </div>
        <div class="main-content-inner padding-page-content">
            <div class="page-content">
            <div class="page-content-new">
            
	            <div class="page-toolbar align-right form-group">
	            	<p class="title" style="display:none;">${empty form.PRO_NAME ? "新增":"编辑"}</p>
	                <button type="button" class="btn btn-save" id="btnSave" data-self-js="save()">
	                    <i class="ace-icon fa fa-save"></i>
	                    保存
	                </button>
	                <button type="button" class="btn btn-info" id="btnSubmit" data-self-js="doSubmit()">
	                    <i class="ace-icon fa fa-check"></i>
	                    提交
	                </button>
	                <button type="button" class="btn btn-info" id="btnReturn" data-self-js="goBack()">
	                    <i class="ace-icon fa fa-reply"></i>
	                    返回
	                </button>
	            </div>
                <!-- <div class="space-4"></div> -->
                <div class="row">
                    <div class=" col-xs-12">
                        <form class="form-horizontal" role="form" id="formInfo" action="" method="post">
                            <div class="form-group">
                                <label class="col-sm-2 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    项目名称
                                </label>
                                <div class="col-sm-4">
                                <input type="hidden" name="form['PRO_ID']"  value="${form.PRO_ID}"/> 
                                <span class="input-icon width-100">
                                        <input type="text" class="form-control"
                                               data-validation-engine="validate[required]" placeholder="25个汉字以内" 
                                               name="form['PRO_NAME']" value="${form.PRO_NAME}"/>
                                        <i class="ace-icon fa fa-info-circle"> </i>
                                   </span>
                                </div>
                                <label class="col-sm-2 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"> </i>
                                    项目类型
                                </label>
                                <div class="col-sm-4">
                                	<select class="form-control"   name="form['CODE_KIND']"  data-validation-engine="validate[required]" >
                                        <option value="">-全部-</option>
                                        <option <c:if test="${form.CODE_KIND==1}">selected="selected"</c:if> value="1">北京项目</option>
                                        <option <c:if test="${form.CODE_KIND==2}">selected="selected"</c:if> value="2">地方项目</option>
                                        <option <c:if test="${form.CODE_KIND==3}">selected="selected"</c:if> value="3">清华项目</option>
                                        <option <c:if test="${form.CODE_KIND==4}">selected="selected"</c:if> value="4">环保部项目</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label no-padding-right">合同名称</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" placeholder="50个汉字以内" 
                                    name="form['CONTRACT_NAME']"  value="${form.CONTRACT_NAME}" maxlength="50"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label no-padding-right">签署日期</label>
                                <div class="col-sm-4">
                                    <div class="input-group input-group-date">
                                        <input type="text" class="form-control" readonly="readonly" id="txtSignDate" name="form['SIGN_DATE']"  
                                        value="<fmt:formatDate value='${form.SIGN_DATE}' type='date' pattern='yyyy-MM-dd'/>" />
                                        <span class="input-group-btn">
                                        <button type="button" class="btn btn-white  " id="btnSignDate">
                                            <i class="ace-icon fa fa-calendar"></i>
                                        </button>
                                        </span>
                                    </div>
                                </div>
                                <label class="col-sm-2 control-label no-padding-right">项目状态</label>
                                <div class="col-sm-4">
                                   <div class="control-group">
                                        <div class="radio-inline">
                                            <label>
                                                <input name="form['PRO_STATUS']"  type="radio" class="ace" <c:if test="${form.PRO_STATUS==1}">checked</c:if> value="1" >
                                                <span class="lbl">在行</span>
                                            </label>
                                        </div>

                                        <div class="radio-inline">
                                            <label>
                                                <input name="form['PRO_STATUS']"  type="radio" class="ace" <c:if test="${form.PRO_STATUS==0}">checked</c:if> value="0">
                                                <span class="lbl">竣工</span>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"> </i>
                                    项目经费(元)
                                </label>
                                <div class="col-sm-4">
                                    <input type="text" class="form-control" name="form['PRO_FEE']"  data-validation-engine="validate[required,custom[number]]"  value="${form.PRO_FEE}"  maxlength="30"/>
                                </div>
                                <label class="col-sm-2 control-label no-padding-right">
                                    项目经理
                                </label>
                                <div class="col-sm-4">
                                   <input id="txtManngerId" type="hidden" name="form['MANAGER_ID']"  value="${form.MANAGER_ID}"/> 
                                     <div class="input-group">
                                        <input id="txtMannger"  type="text" class="form-control" name="form['MANAGER']"  value="${form.MANAGER}" placeholder="单选"
                                               readonly="readonly"  />
                                    <span class="input-group-btn">
                                    <button id="btnChooseManager" type="button" class="btn btn-white  ">
                                        <i class="ace-icon fa fa-search"></i>
                                        选择
                                    </button>
                                        <button id="btnChooseManagerX"  type="button" class="btn btn-white btn-clear ">
                                            <i class="ace-icon fa fa-remove"></i>
                                        </button>
                                    </span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label no-padding-right">
                                    所属部门
                                </label>
                                <div class="col-sm-4">
                                <input id="txtDeptID" type="hidden" name="form['DEPT_ID']"  value="${form.DEPT_ID}"/> 
                                    <div class="input-group">
                                        <input id="txtDeptName" type="text" class="form-control"  name="form['DEPT_NAME']"  value="${form.DEPT_NAME}"
                                               readonly="readonly"/>
                                    <span class="input-group-btn">
                                    <button id="btnChooseDept" type="button" class="btn btn-white  ">
                                        <i class="ace-icon fa fa-search"></i>
                                        选择
                                    </button>
                                        <button id="btnChooseDeptX" type="button" class="btn btn-white btn-clear ">
                                            <i class="ace-icon fa fa-remove"></i>
                                        </button>
                                    </span>
                                    </div>
                                </div>
                              </div>
                              <div class="form-group">  
                                <label class="col-sm-2 control-label no-padding-right">
                                    干系人
                                </label>
                                <div class="col-sm-8">
                                 <input type="hidden"  id="txtDeptManagerId" name="form['DEPT_MANAGER_ID']"  value="${form.DEPT_MANAGER_ID}"/> 
                                  <input type="hidden"   id="txtDeptManager" name="form['DEPT_MANAGER']"  value="${form.DEPT_MANAGER}"/> 
                                     <div class="chosen-container chosen-container-multi width-100"
                                         style="border: solid 1px #D5D5D5; min-height: 73px ">
                                        <ul class="chosen-choices" style="border: none" id="manageUserUl">
											<!-- TODO:展示已选择的人员 -->
                                        </ul>
                                    </div>
                                </div>
                                     <div class="col-sm-2">
                                    <button id="btnChooseDeptManager" type="button" class="btn btn-xs   btn-white btn-xs-ths"
                                            title="选择" id="btnChooseManage">
                                        <i class="ace-icon fa fa-search"></i>
                                        选择
                                    </button>
                                    <div class="space-4 hidden-xs"></div>
                                    <button  id="btnChooseDeptManagerX" type="button" class="btn btn-xs   btn-white btn-xs-ths"
                                            title="清空" >
                                        <i class="ace-icon fa fa-trash"></i>
                                        清空
                                    </button>
                                </div>
                                     
                            </div>
                            
                            <div class="form-group">
                                <label class="col-sm-2 control-label no-padding-right">
                                    项目描述
                                </label>
                                <div class="col-sm-10">
                                    <textarea class="form-control" id="txtarea" placeholder="可拖动的大文本框" name="form['PRO_DESC']"  value="${form.PRO_DESC}"
                                              style="height: 66px;">${form.PRO_DESC}</textarea>
                                </div>

                            </div>
                        </form>
                    </div>
                    </div>
                </div><!-- /.row -->
            </div>
        </div><!--/.main-content-inner-->
    </div><!-- /.main-content -->
</div><!-- /.main-container -->

<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>

<!-- 自己写的JS，请放在这里 -->
<script type="text/javascript">
	//暂存
	function save(){
		//提交之前，将多选人的值写到hidden中
		var ids="",names="";
		$.each(selectUsers,function(i){
			var sp =  i == 0?"":",";
	    	ids = ids + sp + this.loginName;
	    	names = names + sp + this.name;
        });
		$("#txtDeptManagerId").val(ids);
		$("#txtDeptManager").val(names);
        if($("#formInfo").validationEngine("validate")){
            ths.submitFormAjax({
                url:'profee_save.vm',// any URL you want to submit
                data:$("#formInfo").serialize()// 如果不需要提交整个表单，可构造JSON提交，如{name:'老王',age:50}
                //如需自行处理返回值，请增加以下代码
                /*
                ,success:function (response) {

                }
                */
            });
        }
	}
	
	//提交
	function doSubmit(){
		
		//提交之前，将多选人的值写到hidden中
		var ids="",names="";
		$.each(selectUsers,function(i){
			var sp =  i == 0?"":",";
	    	ids = ids + sp + this.loginName;
	    	names = names + sp + this.name;
        });
		$("#txtDeptManagerId").val(ids);
		$("#txtDeptManager").val(names);
		
		//提交之前验证表单
	    if ($('#formInfo').validationEngine('validate')) {
	    	
	    	if(!confirm("确认提交吗？")){
				return;
			}
	    	
	        ths.submitFormAjax({
	            url:'profee_save.vm',// any URL you want to submit
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
		selectUsers = JSON.parse(JSON.stringify(users));
        //这种写法在IE浏览器下报“不能执行已释放的Script代码”错误
        //selectUsers = users;
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
      
	jQuery(function($){
		
		$("#btnChooseManager").on(ace.click_event,function(){
			//dialog的使用，请参考官方文档http://aui.github.io/artDialog/doc/index.html
			dialog({
				id:"dialog-user",
	            title: '选择',
	            url: '${ctx}/common/ou/selUser.html?hiddenId=txtManngerId&textId=txtMannger',
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
            showMutiUserSelected(selectUsers);
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

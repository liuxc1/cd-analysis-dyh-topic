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
            <div id="breadcrumbs" class="breadcrumbs">
                <ul class="breadcrumb">
                    <li class="active">
                        <h5 class="page-title" >
                            <i class="fa fa-edit"></i>
                            项目经费审批
                        </h5>
                    </li>
                </ul><!-- /.breadcrumb -->

            </div>
            <div id="toolbarDiv">
            	<script type="text/javascript">
            		$("#toolbarDiv").load("${ctx }/console/toolbar.vm?taskId=${taskId}&processDefKey=${processDefKey}&status=${status}&_t=" + new Date().getTime());
            	</script>
            </div>
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
                                    项目名称
                                </label>
                                <div class="col-sm-4">
                                <input id="pro_id" type="hidden" name="form['PRO_ID']"  value="${form.PRO_ID}"/> 
                                <%-- <input id="operate_type" type="hidden" name="form['OPERATE_TYPE']"  value="${operateType}"/>  --%>
                                <span class="input-icon width-100">
                                        <input type="text" class="form-control" 
                                               data-validation-engine="validate[required,maxSize[25]]" placeholder="25个字符以内" 
                                               name="form['PRO_NAME']" value="${form.PRO_NAME}" id="PRO_NAME"/>
                                        <i class="ace-icon fa fa-info-circle"> </i>
                                   </span>
                                </div>
                                <label class="col-sm-2 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"> </i>
                                    项目类型
                                </label>
                                <div class="col-sm-4">
                                	<select class="form-control"   name="form['CODE_KIND']"   data-validation-engine="validate[required]"  >
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
                                    <input type="text" class="form-control" placeholder="50个字符以内" 
                                    name="form['CONTRACT_NAME']"  value="${form.CONTRACT_NAME}" data-validation-engine="validate[maxSize[50]]"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label no-padding-right">签署日期</label>
                                <div class="col-sm-4">
                                    <div class="input-group">
                                        <input type="text" class="form-control" readonly="readonly" id="txtSignDate" name="form['SIGN_DATE']"  
                                        value="<fmt:formatDate value='${form.SIGN_DATE}' type='date' pattern='yyyy-MM-dd'/>" />
                                        <span class="input-group-btn">
                                        <button type="button" class="btn btn-white  " id="btnSignDate">
                                            <i class="ace-icon fa fa-calendar"></i>
                                        </button>
                                        </span>
                                    </div>
                                </div>
                                <label class="col-sm-2 control-label no-padding-right">
                                 <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                 项目状态</label>
                                <div class="col-sm-4">
                                   <div class="control-group">
                                        <div class="radio-inline">
                                            <label>
                                                <input name='form["PRO_STATUS"]'  data-validation-engine="validate[required]"  type="radio" class="ace" <c:if test="${form.PRO_STATUS==1}">checked</c:if> value="1" >
                                                <span class="lbl">在行</span>
                                            </label>
                                        </div>

                                        <div class="radio-inline">
                                            <label>
                                                <input name='form["PRO_STATUS"]'  data-validation-engine="validate[required]"  type="radio" class="ace" <c:if test="${form.PRO_STATUS==0}">checked</c:if> value="0">
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
                                        <button id="btnChooseManagerX"  type="button" class="btn btn-white  ">
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
                                        <button id="btnChooseDeptX" type="button" class="btn btn-white  ">
                                            <i class="ace-icon fa fa-remove"></i>
                                        </button>
                                    </span>
                                    </div>
                                </div>
                              </div>
                            
                            <div class="form-group">
                                <label class="col-sm-2 control-label no-padding-right">
                                    项目描述
                                </label>
                                <div class="col-sm-10">
                                    <textarea class="form-control" id="txtarea" placeholder="可拖动的大文本框" name="form['PRO_DESC']"
                                              style="height: 66px;" data-validation-engine="validate[maxSize[60]]">${form.PRO_DESC}</textarea>
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
	
</script>
<!-- 流程相关saveForm，processBack，processVariables必须提供 -->
<script type="text/javascript">
	//客户端表单页面提供saveForm(instanceid)方法，供toolbar.jsp办理任务提交时调用
	function saveForm(instanceid){
		//表单验证，流程接收到false，将停止向下执行
		var result=true;
		if($('#formInfo').validationEngine('validate')!=true){
			return false;
		}
		
	    $.ajax({
	        url:'save.vm',
	        type:"post",
	        dataType: "text",
	        async: false,
	        data:$("#formInfo").serialize() + "&instanceid="+instanceid,
	    	success:function(bussinessId){
	    		if(bussinessId){
	    			$("#pro_id").val(bussinessId);
	    		}else{
	    			result=false;
	    		}
	    	}
	    });
	    
	    return result; //返回true，流程才会继续执行
	    
	}
	
	//执行工作流相关操作成功后回调
	function processBack(type,activitiCode) {
        //type，0:暂存；1：提交；2：退回；3：转办；4：阅读；5：撤回；6：终止流程
        //activitiCode:下一节点编码，多个以逗号分隔
		window.parent.location.reload();
	}
	
	//提供流程变量的方法，需要用户根据自己情况返回
	//示例：{"userId": "admin"}
	function processVariables(){
		var params = $("#formInfo").serializeArray();
		var json = {};
		for(var i = 0; i < params.length; i++){
			json[params[i].name] = params[i].value;
		}
		console.log(JSON.stringify(json));
		return json;
	}
	//提供流程Title名称
	function processTitle(){
		return $("#PRO_NAME").val();
	}
</script>

<script type="text/javascript">
	/**
	*这里的代码主要是选择人、选择部门的示例代码
	*请参考各组件HTML页面中的调用说明
	**/
	
	//单选人回调
	function userSelectCallBack(user){
		$("#txtManngerId").val(user.loginName);
		$("#txtMannger").val(user.name);
	}
	//关闭单选人Dialog
	function closeSelectUserDialog(){
		dialog.get("dialog-user").close().remove();
	}
	
     //关闭多选人Dialog
     function closeDialog(){
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
		
      function deleteNode(obj)
      {
      	$(obj).parent().remove();
      }

	jQuery(function($){
		
		var _editStatus='${status}';
		if(_editStatus=='2'){
			$("#formInfo").find("select,button,input[type!='text']").prop("disabled",true);
			$("#formInfo").find("input[type='text'],textarea").prop("readonly",true);
		}
		
		$("#btnChooseManager").on(ace.click_event,function(){
			//dialog的使用，请参考官方文档http://aui.github.io/artDialog/doc/index.html
			dialog({
				id:"dialog-user",
	            title: '选择',
	            url: '${ctx}/common/ou/selUser.html',
	            width:550,
	            height:500>document.documentElement.clientHeight?document.documentElement.clientHeight:500,
	        }).showModal();
		});
		$("#btnChooseManagerX").on(ace.click_event,function(){
			$("#txtManngerId").val("");
			$("#txtMannger").val("");
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
		
		//显示已经选择的人（多选人）
		/* showMutiUserSelected(selectUsers); */
		
	});
</script>
</body>
</html>

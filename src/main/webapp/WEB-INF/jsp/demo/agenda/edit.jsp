<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
<head>
    <title>日程安排表</title>
	<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
  	<!--页面自定义的CSS，请放在这里 -->
    <style type="text/css">
		
    </style>
</head>
<body class="no-skin">

<div class="main-container" id="main-container">
    <div class="main-content">
        <div class="main-content-inner fixed-page-header fixed-40">
            <div class="page-toolbar align-right">
                <button type="button" class="btn btn-xs    btn-xs-ths" id="btnEdit"  data-self-js="edit()">
                    <i class="ace-icon fa fa-pencil-square-o"></i>
                    编辑
                </button>
                <button type="button" class="btn btn-xs    btn-xs-ths" id="btnSave" data-self-js="save()">
                    <i class="ace-icon fa fa-save"></i>
                    保存
                </button>
                 <button type="button" class="btn btn-xs    btn-xs-ths" id="btnDelete" data-self-js="doDelete()">
                    <i class="ace-icon fa fa-close"></i>
                   清除
                </button>
                <button type="button" class="btn btn-xs btn-xs-ths" id="btnBack"  data-self-js="goBack()">
                    <i class="ace-icon fa fa-reply"></i>
                    返回
                </button>
                <hr class="no-margin">
            </div>

        </div>
        <div class="main-content-inner padding-page-content">
            <div class="page-content">
                <div class="row">
                    <div class=" col-xs-12">
                        <form class="form-horizontal" role="form" id="formInfo" action="" method="post">
						    <input type="hidden" name="form['AGENDA_ID']"  value="${form.AGENDA_ID}"/> 
						    <div class="form-group">
						    <label class="col-sm-2 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    主题
                                 </label>
                                <div class="col-sm-10">
                                   <span >
                                        <input type="text" class="form-control"
                                               data-validation-engine="validate[required,maxSize[50]]"  
                                               name="form['TITLE']" value="${form.TITLE}"/>
                                   </span>
                                </div>
						    </div>
						     <div class="form-group">
						     <label class="col-sm-2 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    开始时间
                                 </label>
                                 <div class="col-sm-4 hidden-xs">
                                        <div class="input-group" id="divDate1">
                                            <input type="text"  id="startDate" class="form-control "  data-validation-engine="validate[required]" name="form['START_TIME']"  value="${form.START_TIME}" readonly="readonly">
		                                    <span class="input-group-btn">
		                                        <button type="button" class="btn btn-white  " id="btnstart">
		                                            <i class="ace-icon fa fa-calendar"></i>
		                                        </button>
		                                    </span>
                                        </div>
                                    </div>
						    <label class="col-sm-2 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    结束时间
                                 </label>
                                 <div class="col-sm-4 hidden-xs">
                                        <div class="input-group" id="divDate1">
                                            <input type="text"  id="endDate" class="form-control"  data-validation-engine="validate[required]" name="form['END_TIME']"  value="${form.END_TIME}" readonly="readonly">
		                                    <span class="input-group-btn">
		                                        <button type="button" class="btn btn-white  " id="btnend">
		                                            <i class="ace-icon fa fa-calendar"></i>
		                                        </button>
		                                    </span>
                                        </div>
                                    </div>
						    </div>
						        <div class="form-group">
                              <label class="col-sm-2 control-label no-padding-right">
                                               日程分类
                                 </label>
                                 <div class="col-sm-4">
                                   <span class="input-icon width-100">
                                        <select  name="form['AGENDA_CATEGORY']" >
                                         <option value="参加会议" <c:if test="${form.AGENDA_CATEGORY=='参加会议'}">selected="selected"</c:if>>参加会议</option>
                                         <option value="工作办理" <c:if test="${form.AGENDA_CATEGORY=='工作办理'}">selected="selected"</c:if>>工作办理</option>
                                          <option value="文件办理" <c:if test="${form.AGENDA_CATEGORY=='文件办理'}">selected="selected"</c:if>>文件办理</option>
                                          <option value="出差" <c:if test="${form.AGENDA_CATEGORY=='出差'}">selected="selected"</c:if>>出差</option>
                                          <option value="活动" <c:if test="${form.AGENDA_CATEGORY=='活动'}">selected="selected"</c:if>>活动</option>
                                          <option value="加班" <c:if test="${form.AGENDA_CATEGORY=='加班'}">selected="selected"</c:if>>加班</option>
                                          <option value="其他" <c:if test="${form.AGENDA_CATEGORY=='其他'}">selected="selected"</c:if>>其他</option>
                                  		</select>
                                   </span>
                                </div>
                                <label class="col-sm-2 control-label no-padding-right">
                                                    重要级别
                                 </label>
                                <div class="col-sm-4">
                                   <span class="input-icon width-100">
                                         <select  name="form['AGENDA_IMPORTANCE']" >
                                         	<option value="一般" <c:if test="${form.AGENDA_IMPORTANCE=='一般'}">selected="selected"</c:if>>一般</option>
	                                        <option value="重要" <c:if test="${form.AGENDA_IMPORTANCE=='重要'}">selected="selected"</c:if>>重要</option>
	                                        <option value="非常重要" <c:if test="${form.AGENDA_IMPORTANCE=='非常重要'}">selected="selected"</c:if>>非常重要</option>
                                         </select>
                                   </span>
                                </div>
							  </div>
						     <div class="form-group">
						      <label class="col-sm-2 control-label no-padding-right">
                                     	地点
                                 </label>
                                <div class="col-sm-4">
                                   <span class="input-icon width-100">
                                        <input type="text" class="form-control"
                                               name="form['SITE']" value="${form.SITE}" title="${form.SITE}" data-validation-engine="validate[maxSize[30]]"/>
                                   </span>
                                </div>
						    </div>
						    <div class="form-group">
                             
							  	<label class="col-sm-2 control-label no-padding-right">
                                    <i class="ace-icon fa   smaller-70"></i>
                                    日程内容
                                 </label>
                                <div class="col-sm-10">
                                   <span class="input-icon width-100">
                                        <textarea class="form-control"  
                                               name="form['WORK_CONTENT']" data-validation-engine="validate[maxSize[300]]">${form.WORK_CONTENT}</textarea>
                                   </span>
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


	//AJAX保存
	function save(){
		//提交之前验证表单
	    if ($('#formInfo').validationEngine('validate')) {
	        //alert(44);
	    	$.ajax({
                url: 'save.vm',
                type: 'post',
                cache:false,
                dataType:'text',
                data:$("#formInfo").serialize(),
                success: function (events) {
                	if(events=='success'){
                		//window.location.href = "${ctx}/agenda/agenda/personalList.vm";
                		window.parent.doSearch();
                	}
                }
            });
	    	
	    	/* ths.submitFormAjax({
	            url:'save.vm',// any URL you want to submit
	            data:$("#formInfo").serialize()// 如果不需要提交整个表单，可构造JSON提交，如{name:'老王',age:50}
	        }); */
	    }
	}
	//返回
	$("#btnOK").on(ace.click_event,function () {
		//console.log(selPerson);
		/* window.location.href = "${ctx}/agenda/agenda/personalList.vm"; */
		parent.dialog.get("dialog-select-prepare").close().remove();
          /*  if(window.parent.closeSelectUserDialog){
               window.parent.closeSelectUserDialog();
           } */
    });
	var _type="${type}";
	function goBack() {
		console.log(_type);
		if(_type=="drag"){
			window.parent.doSearch();
		}else{
			window.parent.closeDialogAgenda();
		}
	}
	//开启日程编辑
	function edit(){
		$("input,select,textarea").attr("disabled",false);
		$("#btnSave").attr("disabled",false);
		$("#btnEdit").attr("disabled",true);
	}
	//清除日程
	function doDelete(){
		if(!confirm("确认清除当前日程吗")){
			return;
		}
		
		ths.submitFormAjax({
			url : 'delete.vm',// any URL you want to submit
			data : {'id':'${form.AGENDA_ID}'},
			success:function(){
				//刷出之后，刷新列表
				window.parent.doSearch();
			}
		});
	}
	
	jQuery(function ($) {
	    //表单验证组件初始化，详细文档请参考http://code.ciaoca.com/jquery/validation-engine/ 或官网文档http://posabsolute.github.io/jQuery-Validation-Engine/
	    $("#formInfo").validationEngine({
	        scrollOffset: 98,//必须设置，因为Toolbar position为Fixed
	        promptPosition: 'bottomLeft',
	        autoHidePrompt: true
	    });
	    
	  //日期控件使用示例，详细文档请参考http://www.my97.net/dp/demo/index.htm
		$("#btnstart").on(ace.click_event, function () {
		       WdatePicker({el: 'startDate',dateFmt:'yyyy-MM-dd HH:mm:ss'});
		});
		$("#btnend").on(ace.click_event, function () {
		   WdatePicker({el: 'endDate', dateFmt:'yyyy-MM-dd HH:mm:ss'});
		});
	    //将编辑页的样式默认设为
	    var _id="${form.AGENDA_ID}";
	    if(_id!=""){
	    	$("input,select,textarea").attr("disabled",true);
	    	$("#btnSave").attr("disabled",true);
	    }else{
	    	$("#btnEdit").css("display","none");
	    	$("#btnDelete").css("display","none");
	    }
	});
      	
</script>
</body>
</html>

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
                            多表信息维护实例
                        </h5>
                    </li>
                </ul><!-- /.breadcrumb -->

            </div>
            <div class="page-toolbar align-right">
                <button type="button" class="btn btn-xs    btn-xs-ths" id="btnSave" data-self-js="save()">
                    <i class="ace-icon fa fa-save"></i>
                    保存
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
                        <div class="no-margin">表一</div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                    项目名称
                                </label>
                                <div class="col-sm-4">
                                <input type="hidden" name="multiForm['PROJECT'].form['PRO_ID']"  value="${data.project.PRO_ID}"/> 
                                <span class="input-icon width-100">
                                        <input type="text" class="form-control"
                                               data-validation-engine="validate[required]" placeholder="25个汉字以内" 
                                               name="multiForm['PROJECT'].form['PRO_NAME']" value="${data.project.PRO_NAME}"/>
                                        <i class="ace-icon fa fa-info-circle"> </i>
                                   </span>
                                </div>
                                <label class="col-sm-2 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"> </i>
                                    项目类型
                                </label>
                                <div class="col-sm-4">
                                	<select class="form-control"   name="multiForm['PROJECT'].form['CODE_KIND']"  data-validation-engine="validate[required]" >
                                        <option value="">-全部-</option>
                                        <option <c:if test="${data.project.CODE_KIND==1}">selected="selected"</c:if> value="1">北京项目</option>
                                        <option <c:if test="${data.project.CODE_KIND==2}">selected="selected"</c:if> value="2">地方项目</option>
                                        <option <c:if test="${data.project.CODE_KIND==3}">selected="selected"</c:if> value="3">清华项目</option>
                                        <option <c:if test="${data.project.CODE_KIND==4}">selected="selected"</c:if> value="4">环保部项目</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label no-padding-right">
                                合同名称
                                </label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" placeholder="50个汉字以内" 
                                    name="multiForm['PROJECT'].form['CONTRACT_NAME']"  value="${data.project.CONTRACT_NAME}" maxlength="50"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"> </i>
                                    项目经费(元)
                                </label>
                                <div class="col-sm-4">
                                    <input type="text" class="form-control" name="multiForm['PROJECT'].form['PRO_FEE']"  
                                    	data-validation-engine="validate[required,custom[number]]"  
                                    	value="${data.project.PRO_FEE}"  maxlength="30"/>
                                </div>
                            </div>
                			<hr class="no-margin">
                			<div class="space-4"></div>
                			<div class="space-4"></div> 
                			<div class="no-margin">表二</div>                       
                            <div class="form-group">
                                <label class="col-sm-2 control-label no-padding-right">
                                    负责任人
                                </label>
                                <div class="col-sm-4">
                                	<input type="hidden" name="multiForm['TEAMLEADER'].form['ID']"  value="${data.teamLeader.ID}"/> 
                                    <input type="text" class="form-control" name="multiForm['TEAMLEADER'].form['NAME']"  
                                    	value="${data.teamLeader.NAME}"  maxlength="10"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label no-padding-right">
                                    电话
                                </label>
                                <div class="col-sm-4">
                                    <input type="text" class="form-control" name="multiForm['TEAMLEADER'].form['PHONE']"  
                                    	data-validation-engine="validate[custom[number]]"  
                                    	value="${data.teamLeader.PHONE}"  maxlength="30"/>
                                </div>
                                <label class="col-sm-2 control-label no-padding-right">
                                    Email
                                </label>
                                <div class="col-sm-4">
                                    <input type="text" class="form-control" name="multiForm['TEAMLEADER'].form['EMAIL']"  
                                    	value="${data.teamLeader.EMAIL}"  maxlength="50"/>
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
<!-- 按钮的权限控制 -->
<%@ include file="/WEB-INF/jsp/_common/opPermission.jsp"%>

<!-- 自己写的JS，请放在这里 -->
<script type="text/javascript">
	//AJAX保存
	function save(){		
		//提交之前验证表单
	    if ($('#formInfo').validationEngine('validate')) {
	        ths.submitFormAjax({
	            url:'multitable_save.vm',// any URL you want to submit
	            data:$("#formInfo").serialize()// 如果不需要提交整个表单，可构造JSON提交，如{name:'老王',age:50}
	        });
	    }
	}
	//返回
	function goBack() {
	    $("#main-container",window.parent.document).show();
	    $("#iframeInfo",window.parent.document).attr("src","#").hide();
	}
	jQuery(function ($) {
	    //表单验证组件初始化，详细文档请参考http://code.ciaoca.com/jquery/validation-engine/ 或官网文档http://posabsolute.github.io/jQuery-Validation-Engine/
	    $("#formInfo").validationEngine({
	        scrollOffset: 98,//必须设置，因为Toolbar position为Fixed
	        promptPosition: 'bottomLeft',
	        autoHidePrompt: true
	    });
	});
</script>
</body>
</html>

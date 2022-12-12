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
                            批量SQL实例
                        </h5>
                    </li>
                </ul><!-- /.breadcrumb -->

            </div>
            <div class="page-toolbar align-right">
                <button type="button" class="btn btn-xs   btn-xs-ths" id="btnBatch" data-self-js="goBatch()">
                <i class="ace-icon fa fa-reply"></i>
                    批量SQL
                </button>
                <button type="button" class="btn btn-xs btn-xs-ths" id="btnReturn" data-self-js="goBack()">
                    <i class="ace-icon fa fa-reply"></i>
                    返回
                </button>
                <div class="space-2"></div>
                <hr class="no-margin">
            </div>
			<form class="form-horizontal" role="form" id="formInfo" action="" method="post"></form>
        </div>
    </div><!-- /.main-content -->
</div><!-- /.main-container -->

<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
<!-- 按钮的权限控制 -->
<%@ include file="/WEB-INF/jsp/_common/opPermission.jsp"%>

<!-- 自己写的JS，请放在这里 -->
<script type="text/javascript">
	function goBatch(){
		//window.location.href="${ctx}/batchSQL/execute.vm"
		//提交之前验证表单
	    if ($('#formInfo').validationEngine('validate')) {
	        ths.submitFormAjax({
	            url:'execute.vm',// any URL you want to submit
	            data:$("#formInfo").serialize()// 如果不需要提交整个表单，可构造JSON提交，如{name:'老王',age:50}
	        });
	    }
	}
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

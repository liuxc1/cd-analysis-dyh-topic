<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
	<head>
		<title>表单帮助页面</title>
		<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
		<!--页面自定义的CSS，请放在这里 -->
		<style>
			.padding_1 {
				padding-left: 0px;
				padding-right: 0px;
				padding-top: 1px;
				padding-bottom: 1px ;
			}
		</style>
		<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
	</head>
	<body class="no-skin">
		<div class="main-container" id="main-container">
			<div class="alert alert-block alert-warning col-sm-12">
	            <ul class="list-unstyled ">
	                <li class="blue">
	                    <i class="ace-icon fa fa-info-circle "></i>
	                    <span>功能描述</span>
	                </li>
		            <span class="text-warning">
		             	通过自定义Js实现样式调整、联动等特殊属性。<br/>
		             	 <textarea rows="2" cols="5" style="width: 500px">
<script type="text/javascript">
</script></textarea>
		            </span>
	            </ul>
         	</div>
         	
         	<div class="alert alert-block alert-warning col-sm-12">
	            <ul class="list-unstyled ">
	                <li class="blue">
	                    <i class="ace-icon fa fa-info-circle "></i>
	                    <span>调整行间距</span>
	                </li>
		            <span class="text-warning">
		             	 <textarea rows="5" cols="5" style="width: 500px">
$(".form-group").css({ "margin-bottom": "1px"});
		             	 </textarea><br/>
		            </span>
	            </ul>
         	</div>
		</div>
		<!-- /.main-container -->
	
		<script type="text/javascript" src="${ ctx }/assets/js/eform/eform_custom.js"></script>
		<!-- 自己写的JS，请放在这里 -->
		<script type="text/javascript">
		function showDownloadPage()
		{
			dialog({
				id:"dialog-import",
	            title: '导出Excel模板',
	            url: '${ctx}/eform/exceltemplate/godownload.vm',
	            width:400,
	            height:200,
	           	cancel:function()
	           	{
	           	},
	           	cancelDisplay: false
	        }).showModal();
		}
		function showUploadPage()
		{
			dialog({
				id:"dialog-import",
	            title: '导入Excel数据',
	            url: '${ctx}/eform/exceltemplate/goupload.vm?desigerid=1',
	            width:400,
	            height:200,
	           	cancel:function()
	           	{
	           	},
	           	cancelDisplay: false
	        }).showModal();
		}
		//关闭dialog
		function closeDialog(id){
			dialog.get(id).close().remove();
		}
		
		</script>
	</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>WebUploader上传示例</title>
		<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
		<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
		<!--引入CSS-->
		<link rel="stylesheet" type="text/css" href="${ctx}/assets/components/webuploader/webuploader.css?v=20221129015223">
		<%-- <link rel="stylesheet" type="text/css" href="${ctx}/assets/js/eform/upload/demo1/demo1.css?v=20221129015223"> --%>
		<!--引入JS-->
		<script type="text/javascript" src="${ctx}/assets/components/webuploader/webuploader.js?v=20221129015223"></script>
		<%-- <script src="${ctx}/assets/js/eform/upload/demo1/demo1.js?v=20221129015223"></script> --%>
		<script src="${ctx}/assets/js/eform/base64.js?v=20221129015223"></script>
		<script src="${ctx}/assets/js/eform/eform_uploader.js?v=20221129015223"></script>
		<script src="${ctx}/assets/js/eform/eform_custom2.js?v=20221129015223"></script>
		<style type="text/css">
			.webuploader-pick-single {
			    display: block;
			    background: #fff;
			    padding: 0px;
			    text-align: left;
			}
			body{
				margin:0px 20px;
			}
		</style>
		<script type="text/javascript">
			$(function(){
                uploader = new ThsUploder({
                    pick: "picker", // 文件选择框的id
                    multifile: "false", // true:多文件,false:单文件(此参数可忽略)
                    fileDirectory: "{jdp.eform.file.path}", // 虚拟物理路径,一般不用修改,和context.properties文件的jdp.eform.file.path对应
                    editType: 'edit', // 编辑类型: edit:编辑状态,view:查看状态
                    params: {
                        inputFileId: 'picker', // 输入框文件的id
                        businessKey: '555', // 当前文件对应业务对象的主键
                        orderBy: "CREATE_TIME DESC" // 多个字段中间用,隔开
                    }
                });
                uploaderMuti = new ThsUploder({
                    pick: "pickerMuti",
                    fileDirectory: "{jdp.eform.file.path}",
                    multifile: "true",
                    theme: "block",
                    editType: "edit",
                    params: {
                        inputFileId: 'pickerMuti', 
                        businessKey: '555',
                        orderBy: "CREATE_TIME DESC" // 多个字段中间用,隔开
                    }
                });
				uploaderMuti.refresh();
			});
			
			//按钮调用上传方法
			function upload(){
				uploader.upload(function(response){
					console.log(response);
				});
			}
			
			function uploadMuti(){
				uploaderMuti.upload(function(response){
					console.log(response);
				});
			}
			
			//检查文件是否全部上传的方法
			function checkUpload(){
				alert(uploaderMuti.checkUpload());
			}
			function openWiki(url){
				window.open(url);
			}
		</script>
	</head>
	<body class="no-skin">
		<div class="main-content-inner fixed-page-header fixed-82">
			<h3>提示：目前仅做了基础上传功能，后续会完善控件样式。<a href="javascript:openWiki('http://192.168.0.140:8080/wiki/en/Jdp4.0.release#WebUploader.E4.B8.8A.E4.BC.A0.E7.BB.84.E4.BB.B6')" >链接wiki</a></h3>
			<h3>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;大家在项目中如果有好的上传样式，请与平台组联系，做成组件的形式方便以后开发使用</h3>
			<h4>示例1：单文件上传</h4>
			<div id="picker" style="width: 500px;"></div>
			<div class="space-4"></div>
			<button class="btn  " onclick="upload()">开始上传</button>
			<hr>
		    <h4>示例2：多文件上传</h4>
		  	<div id="pickerMuti" style="width:500px;">
		    	选择文件
			</div>
			<!-- <button type="button" class="btn  " onclick="checkUpload()">检查是否全部上传</button> -->
		</div>
	</body>
</html>
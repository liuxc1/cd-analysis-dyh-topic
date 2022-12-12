<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
<head>
    <title>${form.ARTICLE_TITLE}</title>
	<!--浏览器兼容性设置-->
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
	<meta name="renderer" content="webkit">
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0"/>
 	<!--[if !IE]> -->
	<script src="${ctx}/assets/components/jquery/dist/jquery.js?v=20221129015223"></script>
	<!-- <![endif]-->
	<!--[if IE]>
	<script src="${ctx}/assets/components/jquery.1x/dist/jquery.js?v=20221129015223"></script>
	<![endif]-->
  	<!--页面自定义的CSS，请放在这里 -->
    <style type="text/css">
 			#preview{
                width:80%;
                height:100%;
                padding:0;
                margin: auto;
			    position: absolute;
			    top: 0;
			    left: 0;
			    right: 0;
			    bottom: 0;
            }
           /*  #preview *{font-family:sans-serif;font-size:16px;} */
    </style>
</head>

<body >
 <div id="preview" >
	${form.ARTICLE_CONTENT}
 </div>
</body>
</html>

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
	<script src="${ctx}/assets/components/jquery/dist/jquery.js"></script>
	<!-- <![endif]-->
	<!--[if IE]>
	<script src="${ctx}/assets/components/jquery.1x/dist/jquery.js"></script>
	<![endif]-->
  	<!--页面自定义的CSS，请放在这里 -->
    <style type="text/css">
     #tab-main-wrap{
		width: 1000px;
		border: 1px solid #acacac;
		border-radius: 5px;
		margin: 0 auto;
		box-shadow: 0px 0px 10px 2px #ccc;
	}
	.top-title{
	    background: #d0d0d0;
	    height: 36px;
	    text-align: center;
	    border: 1px solid #aaaaaa;
	    font-family: "微软雅黑";
	    font-size: 16px;
	    line-height: 36px;
	    width: 990px;
	    margin: 4px auto 0 auto;
	    border-radius: 5px;
	}
	.top-text{
		border-bottom: 1px solid #aaaaaa;
		padding: 2px;
	}
	.bot-text{
		padding: 2px 0;
    	overflow-y: auto;
	}
	.bot-text p{
	    float: left;
	    padding: 0 14px;
	    font-size: 12px;
	    margin:5px;
	    color: Gray;
	}
            
           /*  #preview *{font-family:sans-serif;font-size:16px;} */
    </style>
</head>

<body >
<div id="tab-main-wrap">
	<div class="top-title">
		${form.ARTICLE_TITLE}
	</div>
	<div class="top-text" id="preview">
			${form.ARTICLE_CONTENT}
	</div>
	<div class="bot-text">
		<p>安建华于2018-03-16 17:15:52已读</p>
		<p>安建华于2018-03-16 17:15:52已读</p>
	</div>
	
</div>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>redirect</title>
<%
    String ctx=pageContext.getAttribute("ctx").toString();
    response.sendRedirect(ctx+"/index.vm");
%>
</head>
<body>

</body>
</html>
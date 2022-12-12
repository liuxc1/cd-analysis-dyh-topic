<%@ page import="java.util.Enumeration" %>
<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title></title>
</head>
<body>
<%
    Enumeration<String> headerNames = request.getHeaderNames();
    while (headerNames.hasMoreElements()) {
        String headerName = headerNames.nextElement();
%>
<%=headerName + ": " + request.getHeader(headerName)%><br/>
<%
    }
%>
</body>
</html>
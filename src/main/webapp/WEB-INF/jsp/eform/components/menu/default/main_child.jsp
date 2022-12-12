<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<ul class="submenu">
<c:forEach items="${childElements}" var="child">
	<c:set var="childCaseKey" value=",${child.key},"/>
	<c:if test="${empty nodeMap.showKey or fn:contains(showKey,childCaseKey)}" >
		<c:if test="${child.cardType=='group'}">
			<c:choose> 
				<c:when test="${fn:contains(openKey,childCaseKey)}">
					<li class="open">
				</c:when>
				<c:otherwise>
					<li class="">
				</c:otherwise>
			</c:choose>
			<a href="#" class="dropdown-toggle">
			<i class="menu-icon fa ${child.bgImage}"></i>
			<span class="menu-text">${child.name}</span>
			<b class="arrow fa fa-angle-down"></b></a><b class="arrow"></b>
			<c:if test="${fn:length(child.childElements)>0 }" >
				<c:set var="childElements" value="${child.childElements}" scope="request" />
				<c:import url="main_child.jsp" />
			</c:if>
		</c:if>
		<c:if test="${child.cardType!='group'}">
			<c:choose> 
				<c:when test="${child.key==define}">
					<li class="active" name="endLi">
				</c:when>
				<c:otherwise>
					<li class="" name="endLi">
				</c:otherwise>
			</c:choose>
			<a href="#" onclick="getTabInfo('${topCard}','${child.key }')">
				<i class="menu-icon fa ${empty child.bgImage?'fa-caret-right':child.bgImage}"></i>
				<span class="menu-text">${child.name }</span>
				</a><b class="arrow"></b>
		</c:if>
	</c:if>
</c:forEach>
</ul>
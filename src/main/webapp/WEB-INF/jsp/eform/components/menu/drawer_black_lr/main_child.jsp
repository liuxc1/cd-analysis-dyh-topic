<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<c:forEach items="${childElements}" var="child">
	<c:set var="childCaseKey" value=",${child.key},"/>
	<c:if test="${empty nodeMap.showKey or fn:contains(showKey,childCaseKey)}" >
		<c:if test="${child.cardType=='group'}">
			<c:choose> 
   				<c:when test="${child.key==define}">
  					<li name="active" >
  				</c:when>
  				<c:otherwise>
  					<li>
  				</c:otherwise>
   			</c:choose>
				<a href="#">
					<%-- <c:if test="${not fn:startsWith(child.bgImage,'fa')}">
						<i style="background:url(${child.bgImage}) no-repeat left center;"></i>
					</c:if>
					<c:if test="${fn:startsWith(child.bgImage,'fa')}">
						<i class="ace-icon fa ${child.bgImage}"></i>
					</c:if> --%>
					<span style="color: #c1c4c9;font-size: 14px;display: inline-block;text-align: left;">${child.name}</span>
					<span class="submenu-icon"></span>
				</a>
				<c:if test="${fn:length(child.childElements)>0 }" >
					<c:set var="childElements" value="${child.childElements}" scope="request" />
					<ul style="min-width:200px;width:auto;background:#313d4d;">
						<c:import url="main_child.jsp" />
					</ul>
				</c:if>
			</li>
		</c:if>
		<c:if test="${child.cardType!='group'}">
			<c:choose> 
   				<c:when test="${child.key==define}">
  					<li name="active" >
  				</c:when>
  				<c:otherwise>
  					<li>
  				</c:otherwise>
   			</c:choose>
				<a href="#" onclick="getTabInfo('${topCard}','${child.key }')">
					<%-- <c:if test="${not fn:startsWith(child.bgImage,'fa')}">
						<i style="background:url(${child.bgImage}) no-repeat left center;"></i>
					</c:if>
					<c:if test="${fn:startsWith(child.bgImage,'fa')}">
						<i class="ace-icon fa ${child.bgImage}" ></i>
					</c:if> --%>
					<span style="color: #c1c4c9;font-size: 14px;display: inline-block;text-align: left;">${child.name}</span>
				</a>
			</li>
		</c:if>
	</c:if>
</c:forEach>

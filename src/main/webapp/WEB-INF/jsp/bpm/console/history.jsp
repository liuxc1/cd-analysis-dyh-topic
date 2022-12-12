<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<style>
	table{
			table-layout: fixed;
		}
		td {
      		white-space:nowrap;
      		overflow:hidden;
      		text-overflow: ellipsis;
		}
		th{
			width:90px;
		}
</style>
<c:if test='${form.executionId != null && form.executionId != "" }'>
	<div class="align-right">
		<button type="button" class="btn btn-xs btn-danger btn-xs-ths"
			onclick="loadSubList('${form.procInstId }', '')">
			<i class="ace-icon fa fa-reply"></i> 返回
		</button>
	</div>
</c:if>
<table id="listTable" class="table table-bordered table-hover">
	<thead>
		<tr>

			<th><i class="ace-icon fa fa-file-o"></i> 节点</th>
			<th><i class="ace-icon fa "></i> 办理人</th>
			<th>办理意见</th>
			<th>操作类型</th>
			<th style="width:100px">下一步接收人</th>
			<th style="width:150px">开始时间</th>
			<th style="width:150px">完成时间</th>
			<th class="right">时长(小时)</th>

		</tr>
	</thead>
	<tbody>
		<c:forEach items="${form.htNodeList }" var="htNode" varStatus="status">
			<c:if test='${htNode.actType != "startEvent" }'>
				<tr>
					<td>
						<c:choose>
							<c:when test='${htNode.actType == "subProcess" }'>
								<a href="#" onclick="loadSubList('${htNode.procInstId }', '${htNode.executionId }')">${htNode.actName }</a>
							</c:when>
							<c:otherwise>
								${htNode.actName }
							</c:otherwise>
						</c:choose>
					</td>
					<td <c:if test="${not empty  htNode.assignee}">title="${form.nameList[status.index]}"</c:if>>
						<c:if test="${empty  htNode.assignee}">--</c:if>
						${form.nameList[status.index]}
					</td>
					<td title="${htNode.message}">
						<c:if test="${empty htNode.message }">--</c:if>
						${htNode.message}
					</td>
					<td>
						<c:choose>
							<c:when test="${empty htNode.deleteReason }">--</c:when>
							<c:when test='${htNode.deleteReason == "completed" }'>提交</c:when>
							<c:when test='${htNode.deleteReason == "deleted" }'>跳过</c:when>
							<c:otherwise>${htNode.deleteReason}</c:otherwise>
						</c:choose>
					</td>
					<td title="${htNode.destAssignees}">
					<c:if test="${empty htNode.destAssignees }">--</c:if>
						${htNode.destAssignees}
					</td>
					<td><c:if test="${empty htNode.claimTime }">--</c:if>${htNode.claimTime}</td>
					<td><c:if test="${empty htNode.endTime }">--</c:if>${htNode.endTime}</td>
					<td class="right">
						<c:choose>
							<c:when test="${empty htNode.duration }">--</c:when>
							<c:otherwise>
								<fmt:formatNumber value="${htNode.duration /3600000}" type="number" maxIntegerDigits="2" pattern="0.00"></fmt:formatNumber>
				          	</c:otherwise>
			          	</c:choose>
			        </td>
				</tr>
			</c:if>
		</c:forEach>
	</tbody>
</table>

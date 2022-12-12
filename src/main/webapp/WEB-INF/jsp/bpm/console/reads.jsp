<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
	<head>
		<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
		<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
	  	<!--页面自定义的CSS，请放在这里 -->
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
	</head>
	<body>
		<form class="form-horizontal" role="form" id="formList" action="#" method="post">
			<div style="width: 100%; max-width: 100%; overflow: auto;">
				<table id="readsListTable" class="table table-bordered table-hover">
					<thead>
						<tr>
							<th data-sort-col="ACTIVITY_NAME"><i class="ace-icon fa fa-file-o"></i>传阅节点<i class="ace-icon fa fa-sort pull-right"></i></th>
							<th data-sort-col="READTO_USERNAME"><i class="ace-icon fa "></i>传阅人<i class="ace-icon fa fa-sort pull-right"></i></th>
							<th data-sort-col="GENERATE_DATE" style="width:150px">传阅时间<i class="ace-icon fa fa-sort pull-right"></i></th>
							<th data-sort-col="READER_USERNAME">阅读人<i class="ace-icon fa fa-sort pull-right"></i></th>
							<th data-sort-col="COMPLETE_DATE" style="width:150px">阅读时间<i class="ace-icon fa fa-sort pull-right"></i></th>
							<th>阅读意见</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${pageInfo.list }" var="node" varStatus="status">
							<tr>
								<td>${node.activityName}</td>
								<td>${node.readtoUserName}</td>
								<td><c:if test="${empty node.generateDate }">--</c:if>${node.generateDate}</td>
								<td>${node.readerUserName}</td>
								<td><c:if test="${empty node.completeDate }">--</c:if>${node.completeDate}</td>
								<td title="${node.message}">${node.message}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			<%@ include file="/WEB-INF/jsp/_common/paging.jsp"%>
		</form>
	</body>
	<script>
		//搜索
		function doSearch(){
			if( typeof(arguments[0]) != "undefined" && arguments[0] == true)
				$("#pageNum").val(1);
			$("#orderBy").closest("form").submit();
		}	
		$(function(){
			__doInitTableEvent("readsListTable");
		});
	</script>
</html>
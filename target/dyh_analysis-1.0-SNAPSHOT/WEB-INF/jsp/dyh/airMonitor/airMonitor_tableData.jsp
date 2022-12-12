<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>表格数据</title>
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp" %>
    <style>
        td {
            vertical-align: middle !important;
        }

        tr:nth-child(even) {
            background-color: #f5f5f5
        }

        table {
            font-size: 13px !important;
        }

        ul a {
            height: 32px;
        }

        ul a i {
            margin-top: 2px;
        }
    </style>
</head>
<body>
<form id="formlist" method="post" action="${ctx }/dataquery/airMonitor/getTableDatas.vm">
    <input type="hidden" id="SNAME" name="form[SNAME]" value="${form.SNAME }"/>
    <i></i>
    <input type="hidden" id="PULL" name="form[PULL]" value="${form.PULL }"/>
    <i></i>
    <input type="hidden" id="endDate" name="form[endDate]" value="${form.endDate }"/>
    <i></i>
    <input type="hidden" id="beginDate" name="form[beginDate]" value="${form.beginDate }"/>
    <div style="height: 100%; overflow-y: auto;">
        <table class="table table-bordered">
            <colgroup>
                <col width="10%"/>
            </colgroup>
            <thead>
            <tr>
                <th class="center">时间</th>
                <c:forEach var="name" items="${form.SNAMES}">
                    <th class="center">
                            ${name}
                    </th>
                </c:forEach>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${pageInfo.total > 0}">
                    <c:forEach items="${pageInfo.list}" var="item" varStatus="index">
                        <tr>
                            <td class="center">${item.MONDATE}</td>
                            <c:forEach var="name" items="${form.SNAMES}">
                                <td class="center">${item[name] ==null ? '-':item[name]}</td>
                            </c:forEach>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <c:set var="PULLS" value="${fn:split(form.PULL, ',')}"></c:set>
                        <td class="center" colspan="${fn:length(PULLS) + 2}">暂无数据！</td>
                    </tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
        <%@ include file="/WEB-INF/jsp/_common/paging.jsp" %>
    </div>
</form>
<script type="text/javascript">
    function doSearch() {
        $('#formlist').submit();
    }
</script>
</body>
</html>
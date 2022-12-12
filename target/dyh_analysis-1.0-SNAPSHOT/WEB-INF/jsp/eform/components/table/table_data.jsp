<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<table id="listTable" class="table table-bordered table-hover">
	<thead id="listTableThead">
		<tr>
			<th class="center" style="width: 30px">
                <c:if test="${paramMap.selectType != 1 }">
					<label class="pos-rel"> <input type="checkbox" class="ace" />
						<span class="lbl"></span>
					</label>
				</c:if>
			</th>
			<!-- <th>条目编码 <i class="ace-icon fa pull-right"></i>
			</th>
			<th>条目名称 <i class="ace-icon fa pull-right"></i>
			</th> -->
			<c:if test="${fn:length(pageInfo.list[0]) > 0}">
				<c:forEach var="item" items="${pageInfo.list[0] }">
					<c:if test='${item.key != "CODE" && item.key != "NAME" && item.key != "ROW_ID" }'>
						<c:choose>
							<c:when test="${fn:containsIgnoreCase(item.key,'HIDDEN')}">  
						   	</c:when>
						   	<c:when test="${fn:containsIgnoreCase(item.key,'HIDE_')}">  
						   	</c:when>
						   	<c:otherwise> 
						   		<th class="center">${item.key}<i class="ace-icon fa pull-right"></i></th>
						   	</c:otherwise>
					  	</c:choose>
					</c:if>
				</c:forEach>
			</c:if>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="entity" items="${pageInfo.list}">
			<tr <c:if test="${paramMap.selectType == 1}">onclick="selectRowItem(this);"</c:if>>
				<td class="center"><label class="pos-rel"> 
					<input type='${paramMap.selectType == 1 ? "radio" : "checkbox" }' class="ace" id="${entity.CODE }" value="${entity }" name="selectInput" /> 
					<span class="lbl"></span>
				</label></td>
				<%-- <td>${entity.CODE }</td>
				<td>${entity.NAME }</td> --%>
				<c:forEach var="item" items="${entity }">
					<c:if test='${item.key != "CODE" && item.key != "NAME" && item.key != "ROW_ID" }'>
					<c:choose> 
						<c:when test="${fn:startsWith(item.key,'HIDDEN')}">  
					   	</c:when>
					   	<c:when test="${fn:startsWith(item.key,'HIDE_')}">  
						</c:when>
					   	<c:otherwise> 
					   		<td>${item.value }</td>
					   	</c:otherwise>
					</c:choose>
					</c:if>
				</c:forEach>
			</tr>
		</c:forEach>
	</tbody>
</table>
<c:choose>
	<c:when test="${fn:length(pageInfo.list) > 0}">
		<%@ include file="/WEB-INF/jsp/_common/paging.jsp"%>
	</c:when>
	<c:otherwise>
		<div class="nodata">
			暂无数据！
		</div>
	</c:otherwise>
</c:choose>
<script>
    // 如果查询有数据,则将thead的内容存储值table_choose页面的隐藏域,如果查询没有数据则从 table_choose页面的隐藏域 获取thead的代码再动态刷新thead
    <c:choose>
        <c:when test="${fn:length(pageInfo.list[0]) > 0}">
            $("#formListTitle").html($("#listTableThead").html());
        </c:when>
        <c:otherwise>
            $("#listTableThead").html($("#formListTitle").html());
        </c:otherwise>
    </c:choose>
	//全选
	$('#listTable > thead > tr > th input[type=checkbox]').eq(0).on(ace.click_event, function(){
	    var th_checked = this.checked;
	    $(this).closest('table').find('tbody > tr').each(function(){
	        var row = this;
	        $(row).find('input[type=checkbox]').each(function () {
	            if(this.checked != th_checked) {
	                $(this).eq(0).prop('checked', th_checked);
	                changeSelectItems(this);
	            }
	        });
	    });
	});
	//单个复选框
	$('#listTable > tbody > tr > td input[type=checkbox]').on(ace.click_event, function(){
		changeSelectItems(this);
	});
	//单选框
	$('#listTable > tbody > tr > td input[type=radio]').on(ace.click_event, function(){
		if($(this).prop("checked")){
			selectItems.clear();
			selectItems.add(JSON.parse($(this).val().replace(/ /g,"").replace("{","{\"").replace(/,/g, "\",\"").replace("}","\"}").replace(/=/g,"\":\"")));
		}
	});
	//复选框更新selectItems
	function changeSelectItems(obj){
		var jsonObj = JSON.parse($(obj).val().replace(/ /g,"").replace("{","{\"").replace(/,/g, "\",\"").replace("}","\"}").replace(/=/g,"\":\""));
		if(obj.checked == true){
			selectItems.add(jsonObj);
		}else{
			selectItems.remove(jsonObj.CODE);
		}
	}
	//初始化-勾选之前选中的项
	$.each(selectItems,function (i) {
		if(this.CODE && this.CODE != "" && $("#" + escapeJquery(this.CODE)).length > 0) {
			$("#" + escapeJquery(this.CODE)).prop("checked", true);
			//将全部信息放入被选中的对象
			selectItems[i] = JSON.parse($("#" + escapeJquery(this.CODE)).val().replace(/ /g,"").replace("{","{\"").replace(/,/g, "\",\"").replace("}","\"}").replace(/=/g,"\":\""));
		}
	});
	//单选点击行时间选中
	function selectRowItem(obj){
		$(obj).find("input[type='radio']").each(function(){
			$(this).prop("checked", true);
			selectItems.clear();
			selectItems.add(JSON.parse($(this).val().replace(/ /g,"").replace("{","{\"").replace(/,/g, "\",\"").replace("}","\"}").replace(/=/g,"\":\"")));
		});
	}
	//特殊字符转义
	function escapeJquery(srcString) {
		 // 转义之后的结果
		 var escapseResult = srcString;
		 // javascript正则表达式中的特殊字符
		 var jsSpecialChars = ["\\", "^", "$", "*", "?", ".", "+", "(", ")", "[",
		   "]", "|", "{", "}"];
		 // jquery中的特殊字符,不是正则表达式中的特殊字符
		 var jquerySpecialChars = ["~", "`", "@", "#", "%", "&", "=", "'", "\"",
		   ":", ";", "<", ">", ",", "/"];
		 for (var i = 0; i < jsSpecialChars.length; i++) {
		  escapseResult = escapseResult.replace(new RegExp("\\"
		        + jsSpecialChars[i], "g"), "\\"
		      + jsSpecialChars[i]);
		 }
		 for (var i = 0; i < jquerySpecialChars.length; i++) {
		  escapseResult = escapseResult.replace(new RegExp(jquerySpecialChars[i],
		      "g"), "\\" + jquerySpecialChars[i]);
		 }
		 return escapseResult;
	}
</script>
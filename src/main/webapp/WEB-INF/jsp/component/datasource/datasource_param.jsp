<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<c:forEach var="item" items="${params }" varStatus="status">
	<tr>
		<td style="padding: 0px 5px; vertical-align: middle;">
			<input type="hidden" name="datasourceParams[${status.index }].adapterParam.paramCode" value="${item.adapterParam.paramCode }"/>
			${item.adapterParam.paramCode }
			<c:if test="${item.adapterParam.paramRequired == 1 }"><i class="ace-icon fa fa-asterisk red smaller-70"></i></c:if>
		</td>
		<td style="padding: 0px 5px; vertical-align: middle;" title="${item.adapterParam.paramName }">
			${item.adapterParam.paramName }
			<c:if test="${not empty item.adapterParam.paramPrompt}">
				<span class="help-button" style="height: 20px; width: 20px; line-height: normal;" data-rel="popover">?</span>
				<p style="display: none;">
					 ${item.adapterParam.paramPrompt }
				</p>
			</c:if>
		</td>
		<td style="padding: 0px;">
			<input type="hidden" name="datasourceParams[${status.index }].datasourceParamId" value="${item.datasourceParamId }"/>
			<input type="hidden" name="datasourceParams[${status.index }].datasourceId" value="${item.datasourceId }"/>
			<input type="hidden" name="datasourceParams[${status.index }].paramId" value="${item.paramId }"/>
			<c:choose>
				<c:when test="${!empty item.adapterParam.paramRequiredSelect }">
					<select id="datasourceParamValue_${status.index }" name="datasourceParams[${status.index }].paramValue" style="width: 100%;" param="${item.adapterParam.paramCode }" 
							<c:if test="${item.adapterParam.paramRequired == 1 }">data-validation-engine="validate[required]"</c:if>>
						<c:forEach var="dic" items="${dictionarys[item.adapterParam.paramRequiredSelect] }">
							<option value="${dic.dictionary_code }" <c:if test="${item.paramValue == dic.dictionary_code }">selected="selected"</c:if>>${dic.dictionary_name }</option>
						</c:forEach>
					</select>
				</c:when>
				<c:when test="${item.adapterParam.paramDataType == 'DATE' }">
					<div class="input-group">
						<input type="text" style="width: 100%;" id="datasourceParamValue_${status.index }" name="datasourceParams[${status.index }].paramValue" param="${item.adapterParam.paramCode }" 
								<c:if test="${item.adapterParam.paramRequired == 1 }">data-validation-engine="validate[required]"</c:if> readonly="readonly">
						<span class="input-group-btn">
                      		<button type="button" class="btn btn-white btn-default" onclick="WdatePicker({el: 'datasourceParamValue_${status.index }', dateFmt: '${item.adapterParam.paramDatePattern }'});">
                            	<i class="ace-icon fa fa-calendar"></i>
                     		</button>
              			</span>
                    </div>
				</c:when>
				<c:otherwise>
					<input type="text" style="width: 100%;" id="datasourceParamValue_${status.index }" name="datasourceParams[${status.index }].paramValue" param="${item.adapterParam.paramCode }"
							value="${item.paramValue == null ? item.adapterParam.paramDefaultValue : item.paramValue }"
							<c:if test="${item.adapterParam.validateEngine != '' }">data-validation-engine="validate[${item.adapterParam.validateEngine }]"</c:if>
							/>
				</c:otherwise>
			</c:choose>
		</td>
	</tr>
</c:forEach>
<script type="text/javascript">
	$('[data-rel=popover]').popover({
		placement: "auto right",
		trigger: "click",
		html: true,
		content: function() {
			var content = $(this).parent().find("p").html().replace(/(^\s*)|(\s*$)/g, "");
            return "<pre style=\"padding: 2px; margin-bottom: 0px;\">" + content + "</pre>";
       	}
	});
</script>		

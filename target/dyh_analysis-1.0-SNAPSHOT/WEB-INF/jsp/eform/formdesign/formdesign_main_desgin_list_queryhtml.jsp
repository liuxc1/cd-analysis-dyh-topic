	<%@ page contentType="text/html;charset=UTF-8" language="java"%>
										<c:set var="queryNum" value="0"></c:set>
										<c:if test='${isBpmListHtml != null && isBpmListHtml == "true" }'>
											<c:set var="queryNum" value="${queryNum + 1 }"></c:set>
											<c:set var="isBpmListHtml" value="false"></c:set>
											<div class="form-group" style="margin-top: -12px;">
												<label class="col-sm-1 control-label no-padding-right" style="margin-top:10px">办理状态</label>
												<div class="col-sm-3"  style="margin-top:10px">
													<select class="form-control"  name="form['HANDLE_STATE']" >
						                    			<c:forEach items="${handleStates}" var="state" >
						                    				<option  value="${state.dictionary_code}"   <c:if test="${state.dictionary_code==form.HANDLE_STATE }">selected</c:if>>${state.dictionary_name}</option>
						                 				</c:forEach>
						                   	    	</select>
												</div>
										</c:if>
										<c:forEach var="titleObj" items="${titleList}" varStatus="status">
													<c:if test="${not empty titleObj.FIELD_QUERY and titleObj.FIELD_QUERY!='0' and titleObj.FIELD_INPUTTYPE!='INPUTHIDDEN' }">
													<c:set var="queryNum" value="${queryNum + 1 }"></c:set>
													<c:if test="${queryNum % 3 == 1 }">
														<div class="form-group" style="margin-top: -12px;">
													</c:if>
													<label class="col-sm-1 control-label no-padding-right" style="margin-top:10px">${titleObj.FIELD_NAME}</label>
													<div class="col-sm-3" style="margin-top:10px">
															<c:set var="_THSNAME" value="${titleObj.FIELD_CODE}_THSNAME"/>
															<c:if test="${empty  titleObj.FIELD_INPUTTYPE 
																		  or titleObj.FIELD_INPUTTYPE=='INPUTNUMBER' 
																		  or titleObj.FIELD_INPUTTYPE=='TEXTAREA'
																		  or titleObj.FIELD_INPUTTYPE=='INPUT'}">
																	<input type="text" class="form-control" 
																	id="QUERY_${titleObj.FIELD_ID}" 
																	name="form['${titleObj.FIELD_CODE}']" 
																	value="${form[titleObj.FIELD_CODE]}" >
															</c:if>
															<c:if test="${titleObj.FIELD_INPUTTYPE=='DATE'}">
																<div class="input-group">
																	<input type="hidden" name="form['${titleObj.FIELD_CODE}:_DATE_']" value="${titleObj.FIELD_DATETYPE}" />
																	<input type="text" class="form-control" 
																	id="QUERY_${titleObj.FIELD_ID}" 
																	name="form['${titleObj.FIELD_CODE}']" 
																	value="${form[titleObj.FIELD_CODE]}" 
																	readonly="readonly"
																	onclick="WdatePicker({el: 'QUERY_${titleObj.FIELD_ID}', dateFmt: '${titleObj.FIELD_DATETYPE}'});">
																	<span class="input-group-btn">
																  		<button type="button" class="btn btn-white btn-default" 
																		 onclick="WdatePicker({el: 'QUERY_${titleObj.FIELD_ID}', dateFmt: '${titleObj.FIELD_DATETYPE}'});">
																      	 <i class="ace-icon fa fa-calendar"></i>
																       	</button>
																	</span>
																</div>
															</c:if>
															<c:if test="${titleObj.FIELD_INPUTTYPE=='SELECT' 
																		or titleObj.FIELD_INPUTTYPE=='RADIO'
																		or titleObj.FIELD_INPUTTYPE=='CHECKBOX'}">
																	<select id="QUERY_${titleObj.FIELD_ID}" 
																	name="form['${titleObj.FIELD_CODE}']"  
																	class="form-control">
																		<option value="">--请选择--</option>
																		<c:forEach var="dictionaryObj" items='${dictionarys[titleObj.FIELD_DICTIONARY] }'>
																			<option value="${dictionaryObj.dictionary_code}" title="${dictionaryObj.dictionary_name}"
																				<c:if test="${dictionaryObj.dictionary_code==form[titleObj.FIELD_CODE] }">selected</c:if>>
																				${dictionaryObj.dictionary_name}
																			</option>
																		</c:forEach>
																	</select>
															</c:if>
															<c:if test="${titleObj.FIELD_INPUTTYPE=='OPENRADIO'}">
																	<div class="input-group">
																    	<input type="hidden" id="QUERY_${titleObj.FIELD_ID}" name="form['${titleObj.FIELD_CODE}']"   oldvalue="${form[titleObj.FIELD_CODE]}" value="${form[titleObj.FIELD_CODE]}">
																       	<input type="text" class="form-control" id="QUERY_${titleObj.FIELD_ID}_THSNAME"  name="form['${_THSNAME}']" readonly="readonly"  value="${form[_THSNAME]}" onclick="jdp_eform_openList(this,'1','${titleObj.FIELD_NAME}','${titleObj.FIELD_DICTIONARY}','','')">
																        <span class="input-group-btn">
																	    	<button type="button" class="btn btn-white btn-default" onclick="jdp_eform_clearValue(this)">
																	        	<i class="ace-icon fa fa-remove"></i>
																	    	</button>
																		</span>
																	</div>
															</c:if>
															<c:if test="${titleObj.FIELD_INPUTTYPE=='OPENCHECKBOX'}">
																	<div class="input-group">
																    	<input type="hidden" id="QUERY_${titleObj.FIELD_ID}" name="form['${titleObj.FIELD_CODE}']"   oldvalue="${form[titleObj.FIELD_CODE]}" value="${form[titleObj.FIELD_CODE]}">
																       	<input type="text" class="form-control" id="QUERY_${titleObj.FIELD_ID}_THSNAME"  name="form['${_THSNAME}']" readonly="readonly"  value="${form[_THSNAME]}" onclick="jdp_eform_openList(this,'2','${titleObj.FIELD_NAME}','${titleObj.FIELD_DICTIONARY}','','')">
																        <span class="input-group-btn">
																	    	<button type="button" class="btn btn-white btn-default" onclick="jdp_eform_clearValue(this)">
																	        	<i class="ace-icon fa fa-remove"></i>
																	    	</button>
																		</span>
																	</div>
															</c:if>
															<c:if test="${titleObj.FIELD_INPUTTYPE=='RADIOTREE'}">
																	<div class="input-group">
																    	<input type="hidden" id="QUERY_${titleObj.FIELD_ID}" name="form['${titleObj.FIELD_CODE}']"   oldvalue="${form[titleObj.FIELD_CODE]}" value="${form[titleObj.FIELD_CODE]}">
																       	<input type="text" class="form-control" id="QUERY_${titleObj.FIELD_ID}_THSNAME"  name="form['${_THSNAME}']" readonly="readonly"  value="${form[_THSNAME]}" onclick="jdp_eform_openTree(this,'1','${titleObj.FIELD_NAME}','','','','','${titleObj.FIELD_DICTIONARY}','')">
																        <span class="input-group-btn">
																	    	<button type="button" class="btn btn-white btn-default" onclick="jdp_eform_clearValue(this)">
																	        	<i class="ace-icon fa fa-remove"></i>
																	    	</button>
																		</span>
																	</div>
															</c:if>
															<c:if test="${titleObj.FIELD_INPUTTYPE=='CHECKBOXTREE'}">
																	<div class="input-group">
																    	<input type="hidden" id="QUERY_${titleObj.FIELD_ID}" name="form['${titleObj.FIELD_CODE}']"   oldvalue="${form[titleObj.FIELD_CODE]}" value="${form[titleObj.FIELD_CODE]}">
																       	<input type="text" class="form-control" id="QUERY_${titleObj.FIELD_ID}_THSNAME"  name="form['${_THSNAME}']" readonly="readonly"  value="${form[_THSNAME]}" onclick="jdp_eform_openTree(this,'2','${titleObj.FIELD_NAME}','','','','','${titleObj.FIELD_DICTIONARY}','')">
																        <span class="input-group-btn">
																	    	<button type="button" class="btn btn-white btn-default" onclick="jdp_eform_clearValue(this)">
																	        	<i class="ace-icon fa fa-remove"></i>
																	    	</button>
																		</span>
																	</div>
															</c:if>
															<c:if test="${titleObj.FIELD_INPUTTYPE=='AREATREE'}">
																	<div class="input-group">
																    	<input type="hidden" id="QUERY_${titleObj.FIELD_ID}" name="form['${titleObj.FIELD_CODE}']"   oldvalue="${form[titleObj.FIELD_CODE]}" value="${form[titleObj.FIELD_CODE]}">
																       	<input type="text" class="form-control" id="QUERY_${titleObj.FIELD_ID}_THSNAME"  name="form['${_THSNAME}']" readonly="readonly"  value="${form[_THSNAME]}" onclick="jdp_eform_openTree(this,'1','${titleObj.FIELD_NAME}','ths.jdp.eform.mapper.TreeMapper','jdp_region_tree','','')">
																        <span class="input-group-btn">
																	    	<button type="button" class="btn btn-white btn-default" onclick="jdp_eform_clearValue(this)">
																	        	<i class="ace-icon fa fa-remove"></i>
																	    	</button>
																		</span>
																	</div>
															</c:if>
															<c:if test="${titleObj.FIELD_INPUTTYPE=='TRADETREE'}">
																	<div class="input-group">
																    	<input type="hidden" id="QUERY_${titleObj.FIELD_ID}" name="form['${titleObj.FIELD_CODE}']"   oldvalue="${form[titleObj.FIELD_CODE]}" value="${form[titleObj.FIELD_CODE]}">
																       	<input type="text" class="form-control" id="QUERY_${titleObj.FIELD_ID}_THSNAME"  name="form['${_THSNAME}']" readonly="readonly"  value="${form[_THSNAME]}" onclick="jdp_eform_openTree(this,'1','${titleObj.FIELD_NAME}','ths.jdp.eform.mapper.TreeMapper','jdp_trade_tree','','')">
																        <span class="input-group-btn">
																	    	<button type="button" class="btn btn-white btn-default" onclick="jdp_eform_clearValue(this)">
																	        	<i class="ace-icon fa fa-remove"></i>
																	    	</button>
																		</span>
																	</div>
															</c:if>
															<c:if test="${titleObj.FIELD_INPUTTYPE=='RADIOUSER'}">
																	<div class="input-group">
																    	<input type="hidden" id="QUERY_${titleObj.FIELD_ID}" name="form['${titleObj.FIELD_CODE}']"   oldvalue="${form[titleObj.FIELD_CODE]}" value="${form[titleObj.FIELD_CODE]}">
																       	<input type="text" class="form-control" id="QUERY_${titleObj.FIELD_ID}_THSNAME" name="form['${_THSNAME}']" readonly="readonly"  value="${form[_THSNAME]}" onclick="jdp_eform_openUser(this,'1','${titleObj.FIELD_NAME}','','')">
																        <span class="input-group-btn">
																	    	<button type="button" class="btn btn-white btn-default" onclick="jdp_eform_clearValue(this)">
																	        	<i class="ace-icon fa fa-remove"></i>
																	    	</button>
																		</span>
																	</div>
															</c:if>
															<c:if test="${titleObj.FIELD_INPUTTYPE=='CHECKBOXUSER'}">
																	<div class="input-group">
																    	<input type="hidden" id="QUERY_${titleObj.FIELD_ID}" name="form['${titleObj.FIELD_CODE}']"   oldvalue="${form[titleObj.FIELD_CODE]}" value="${form[titleObj.FIELD_CODE]}">
																       	<input type="text" class="form-control" id="QUERY_${titleObj.FIELD_ID}_THSNAME"  name="form['${_THSNAME}']" readonly="readonly"  value="${form[_THSNAME]}" onclick="jdp_eform_openUser(this,'2','${titleObj.FIELD_NAME}','','')">
																        <span class="input-group-btn">
																	    	<button type="button" class="btn btn-white btn-default" onclick="jdp_eform_clearValue(this)">
																	        	<i class="ace-icon fa fa-remove"></i>
																	    	</button>
																		</span>
																	</div>
															</c:if>
															<c:if test="${titleObj.FIELD_INPUTTYPE=='RADIODEPT'}">
																	<div class="input-group">
																    	<input type="hidden" id="QUERY_${titleObj.FIELD_ID}" name="form['${titleObj.FIELD_CODE}']"   oldvalue="${form[titleObj.FIELD_CODE]}" value="${form[titleObj.FIELD_CODE]}">
																       	<input type="text" class="form-control" id="QUERY_${titleObj.FIELD_ID}_THSNAME"  name="form['${_THSNAME}']" readonly="readonly"  value="${form[_THSNAME]}" onclick="jdp_eform_openDept(this,'1','${titleObj.FIELD_NAME}','','')">
																        <span class="input-group-btn">
																	    	<button type="button" class="btn btn-white btn-default" onclick="jdp_eform_clearValue(this)">
																	        	<i class="ace-icon fa fa-remove"></i>
																	    	</button>
																		</span>
																	</div>
															</c:if>
															<c:if test="${titleObj.FIELD_INPUTTYPE=='CHECKBOXDEPT'}">
																	<div class="input-group">
																    	<input type="hidden" id="QUERY_${titleObj.FIELD_ID}" name="form['${titleObj.FIELD_CODE}']"   oldvalue="${form[titleObj.FIELD_CODE]}" value="${form[titleObj.FIELD_CODE]}">
																       	<input type="text" class="form-control" id="QUERY_${titleObj.FIELD_ID}_THSNAME"   name="form['${_THSNAME}']" readonly="readonly"  value="${form[_THSNAME]}"  onclick="jdp_eform_openDept(this,'2','${titleObj.FIELD_NAME}','','')">
																        <span class="input-group-btn">
																	    	<button type="button" class="btn btn-white btn-default" onclick="jdp_eform_clearValue(this)">
																	        	<i class="ace-icon fa fa-remove"></i>
																	    	</button>
																		</span>
																	</div>
															</c:if>
															<c:if test="${titleObj.FIELD_INPUTTYPE=='CHECKBOXROLE'}">
																	<div class="input-group">
																    	<input type="hidden" id="QUERY_${titleObj.FIELD_ID}" name="form['${titleObj.FIELD_CODE}']"   oldvalue="${form[titleObj.FIELD_CODE]}" value="${form[titleObj.FIELD_CODE]}">
																       	<input type="text" class="form-control" id="QUERY_${titleObj.FIELD_ID}_THSNAME"   name="form['${_THSNAME}']" readonly="readonly"  value="${form[_THSNAME]}" onclick="jdp_eform_openRole(this,'2','${titleObj.FIELD_NAME}','','')">
																        <span class="input-group-btn">
																	    	<button type="button" class="btn btn-white btn-default" onclick="jdp_eform_clearValue(this)">
																	        	<i class="ace-icon fa fa-remove"></i>
																	    	</button>
																		</span>
																	</div>
															</c:if>
															<c:if test="${titleObj.FIELD_INPUTTYPE=='CHECKBOXPOSI'}">
																	<div class="input-group">
																    	<input type="hidden" id="QUERY_${titleObj.FIELD_ID}" name="form['${titleObj.FIELD_CODE}']"   oldvalue="${form[titleObj.FIELD_CODE]}" value="${form[titleObj.FIELD_CODE]}">
																       	<input type="text" class="form-control" id="QUERY_${titleObj.FIELD_ID}_THSNAME"  name="form['${_THSNAME}']" readonly="readonly"  value="${form[_THSNAME]}" onclick="jdp_eform_openPosi(this,'2','${titleObj.FIELD_NAME}','','')">
																        <span class="input-group-btn">
																	    	<button type="button" class="btn btn-white btn-default" onclick="jdp_eform_clearValue(this)">
																	        	<i class="ace-icon fa fa-remove"></i>
																	    	</button>
																		</span>
																	</div>
															</c:if>
															<c:if test="${titleObj.FIELD_INPUTTYPE=='CHECKBOXGROUP'}">
																	<div class="input-group">
																    	<input type="hidden" id="QUERY_${titleObj.FIELD_ID}" name="form['${titleObj.FIELD_CODE}']"    oldvalue="${form[titleObj.FIELD_CODE]}" value="${form[titleObj.FIELD_CODE]}">
																       	<input type="text" class="form-control" id="QUERY_${titleObj.FIELD_ID}_THSNAME"  name="form['${_THSNAME}']" readonly="readonly"  value="${form[_THSNAME]}" onclick="jdp_eform_openGroup(this,'2','${titleObj.FIELD_NAME}','','')">
																        <span class="input-group-btn">
																	    	<button type="button" class="btn btn-white btn-default" onclick="jdp_eform_clearValue(this)">
																	        	<i class="ace-icon fa fa-remove"></i>
																	    	</button>
																		</span>
																	</div>
															</c:if>
													</div>
													<c:if test="${!status.last && queryNum > 1 && queryNum % 3 == 0 }">
														</div>
													</c:if>
													</c:if>
										</c:forEach>
										<c:if test="${queryNum > 0 }">
											<c:if test="${queryNum % 3 == 0 }">
												<div class="form-group" style="margin-top: -12px;">
											</c:if>
											<div class="col-sm-${queryNum % 3 == 0 ? 12 : queryNum % 3 == 1 ? 8 : 4 }  align-right" style="margin-top: 10px;">
												<div class="space-4 hidden-lg hidden-md hidden-sm"></div>
												<button type="button"
													class="btn btn-info btn-default-ths pull-right"
													data-self-js="doSearch(true)">
													<i class="ace-icon fa fa-search"></i> 搜索
												</button>
											</div>
											</div>
											<hr class="no-margin">
										</c:if>

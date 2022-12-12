<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
<head>
	<title>黑色金属冶炼和压延加工企业调查表</title>
	<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
	<script type="text/javascript" src="${ctx}/assets/js/eform/masterslave/js/subtable.js"></script>
	<link rel="stylesheet" href="${ctx}/assets/js/eform/masterslave/css/subtable.css"/>
  	<!--页面自定义的CSS，请放在这里 -->
</head>
<body>
<div id="title">
	<p>黑色金属冶炼和压延加工企业调查表</p>
	<button class="btn1" style="right: 100px;" onclick="doSave('1')">暂存</button>
	<button class="btn1" style="right: 30px;" onclick="doSave('2')">提交</button>
</div>
<div id="table-div">

<form class="form-horizontal" role="form" id="formInfo" action="" method="post">
		<input type="hidden" name="table['DEMO_ENTERINFO'].key['ENTER_ID']" id="DEMO_ENTERINFO_ENTER_ID" value="${table['DEMO_ENTERINFO'].key['ENTER_ID']}"/>
		<input type="hidden" name="table['DEMO_ENTERINFO'].column['FILL_PERSON']" id="DEMO_ENTERINFO_FILL_PERSON" value="${table['DEMO_ENTERINFO'].column['FILL_PERSON']}"/>
		<input type="hidden" name="table['DEMO_ENTERINFO'].column['FILL_PERSON_CODE']" id="DEMO_ENTERINFO_FILL_PERSON_CODE" value="${table['DEMO_ENTERINFO'].column['FILL_PERSON_CODE']}"/>
		<input type="hidden" name="table['DEMO_ENTERINFO'].column['STATE']" id="DEMO_ENTERINFO_STATE" value="${table['DEMO_ENTERINFO'].column['STATE']}"/>
		<input   type="hidden"  id="CREATE_TIME" name="table['DEMO_ENTERINFO'].column['CREATE_TIME']" value="${table['DEMO_ENTERINFO'].column['CREATE_TIME']}"  />
		<input type="hidden" id="REMARK" name="table['DEMO_ENTERINFO'].column['REMARK']"  value="${table['DEMO_ENTERINFO'].column['REMARK']}"/>
		<table id="tab-one" width="100%" cellpadding="0" cellspacing="0" border="1" bordercolor="#000000">
			<tr>
				<td class="tab-tit" rowspan="4">一、工业企业基本情况</td>
				<td class="left">
				<span>数据日期：</span>
					<select style="width:200px" name="table['DEMO_ENTERINFO'].column['TOTAL_YEAR']" data-validation-engine="validate[required]" >
								<option value="">--请选择--</option>
								<c:forEach var="total_year" items="${dictionarys_map.total_year}"  varStatus="status">
									<option value="${total_year.dictionary_code}" 
									 	<c:if test="${total_year.dictionary_code==table['DEMO_ENTERINFO'].column['TOTAL_YEAR']}">selected="selected"</c:if>>
									 	${total_year.dictionary_name}
									</option>
								</c:forEach>	
		            </select>
					<span>企业名称（公章）：</span>
					<input type="text" class="input_border_1" name="table['DEMO_ENTERINFO'].column['ENTER_NAME']" value="${table.DEMO_ENTERINFO.column.ENTER_NAME}"  style="width:500px" data-validation-engine="validate[required]" /><i class="ace-icon fa fa-asterisk red smaller-70"></i>
				</td>
			</tr>
			<tr>
				<td class="left">
					<span>所属行业名称:</span>
					<input type="text"  class="input_border_1"  id="INDUSTRY_NAME"  name="table['DEMO_ENTERINFO'].column['INDUSTRY_NAME']"  value="${table['DEMO_ENTERINFO'].column['INDUSTRY_NAME']}" 
						   style="width:240px"/><!-- onclick="openTrade()" --><i class="ace-icon fa fa-asterisk red smaller-70"></i>
					<span>行业代码（4位）</span>
					<input type="text" id="INDUSTRY_CODE" name="table['DEMO_ENTERINFO'].column['INDUSTRY_CODE']"  value="${table['DEMO_ENTERINFO'].column['INDUSTRY_CODE']}"  style="width:240px" data-validation-engine="validate[required]" />
				</td>
			</tr>
			<tr>
				<td class="left">
					<span>统一社会信用代码（18位）/组织机构代码（9位）：</span>
					<input type="text"  class="input_border_1"  name="table['DEMO_ENTERINFO'].column['ORG_CODE']"  value="${table['DEMO_ENTERINFO'].column['ORG_CODE']}"  style="width:240px" data-validation-engine="validate[required]" /><i class="ace-icon fa fa-asterisk red smaller-70"></i>
				</td>
			</tr>
			<tr>
				<td class="left">
					<p>
						<span>企业地址：</span>
						<input   class="input_border_1" type="text"  id="ADDR_HOUSEADDRESS" name="table['DEMO_ENTERINFO'].column['ADDR_HOUSEADDRESS']" style="width:540px" value="${table['DEMO_ENTERINFO'].column['ADDR_HOUSEADDRESS']}" data-validation-engine="validate[required]" maxlength="20" />
					</p>
					<p>
						<span>经度（厂房）：东经</span>
						<input  class="input_border_1" id="jingdu" type="text" name="table['DEMO_ENTERINFO'].column['LONGITUDE_DU']"  value="${table['DEMO_ENTERINFO'].column['LONGITUDE_DU']}"   data-validation-engine="validate[required,custom[greaterInteger],max[180]]" maxlength="3"/>
						<span>度</span><i class="ace-icon fa fa-asterisk red smaller-70"></i>
						<input  class="input_border_1" type="text" name="table['DEMO_ENTERINFO'].column['LONGITUDE_FEN']"  value="${table['DEMO_ENTERINFO'].column['LONGITUDE_FEN']}" data-validation-engine="validate[required,custom[greaterInteger],max[60]]"  maxlength="2"/>
						<span>分</span><i class="ace-icon fa fa-asterisk red smaller-70"></i>
						<input  class="input_border_1" type="text" name="table['DEMO_ENTERINFO'].column['LONGITUDE_MIAO']"  value="${table['DEMO_ENTERINFO'].column['LONGITUDE_MIAO']}"  data-validation-engine="validate[required,custom[greaterInteger],max[60]]" maxlength="6"/>
						<span>秒</span><i class="ace-icon fa fa-asterisk red smaller-70"></i>
						
						<span style="font-size: 12px">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
						
						<span>纬度（厂房）：</span>
						<span>北纬</span>
						<input type="text"  class="input_border_1"  name="table['DEMO_ENTERINFO'].column['LATITUDE_DU']"  value="${table['DEMO_ENTERINFO'].column['LATITUDE_DU']}"   data-validation-engine="validate[required,custom[greaterInteger],max[90]]" maxlength="2"/>
						<span>度</span><i class="ace-icon fa fa-asterisk red smaller-70"></i>
						<input type="text"  class="input_border_1"  name="table['DEMO_ENTERINFO'].column['LATITUDE_FEN']"  value="${table['DEMO_ENTERINFO'].column['LATITUDE_FEN']}"  data-validation-engine="validate[required,custom[greaterInteger],max[60]]" maxlength="2"/>
						<span>分</span><i class="ace-icon fa fa-asterisk red smaller-70"></i>
						<input type="text" class="input_border_1"  name="table['DEMO_ENTERINFO'].column['LATITUDE_MIAO']"  value="${table['DEMO_ENTERINFO'].column['LATITUDE_MIAO']}" data-validation-engine="validate[required,custom[greaterInteger],max[60]]" maxlength="6"/>
						<span>秒</span><i class="ace-icon fa fa-asterisk red smaller-70"></i>
					</p>
				</td>
			</tr>
</table>
<table id="tab-two" class="border-right-none" width="100%" cellpadding="0" cellspacing="0" border="1" bordercolor="#000000">
	<tr  class="two-tit">
		<td class="tab-tit" >二、燃料使用情况</td>
		<td class="border-left-none internal-top-none">
			<table class="tab-internal internal-top-none border-left-none border-bottom-none" width="100%" cellpadding="0" cellspacing="0" border="1" bordercolor="#000000" id="DEMO_HSJS_RMSYQK">
				<tr class="border-top-none">
					<td rowspan="2">锅炉类型</td>
					<td rowspan="2">锅炉蒸吨</td>
					<td colspan="8">燃料使用情况</td>
					<td rowspan="2" class="td  border-right-none width">
						<a href="javascript:void(0)" onclick="addRow('DEMO_HSJS_RMSYQK','DEMO_HSJS_RMSYQK_CLONE')"><i class="ace-icon fa fa-plus" title="添加行"></i></a>
				    </td>	
				</tr>	
				<tr>
					<td>燃煤种类</td>
					<td>燃煤消耗量（吨/年）</td>
					<td>硫分（%）</td>
					<td>灰分（%）</td>
					<td>干燥无灰基挥发分（Vdaf %）</td>
					<td>其他燃料名称</td>
					<td>其他燃料消耗量</td>
					<td>其他燃料单位</td>				
				</tr>	
				<c:forEach var="item" items="${multirowtable.DEMO_HSJS_RMSYQK.row}" varStatus="status">
					<tr class="td-border">
						<td style="border-left:1px solid #000;">
							<input type="hidden" class="input_border_0" name="multirowtable['DEMO_HSJS_RMSYQK'].row[${status.index}].key['RMSYQK_ID']"  value="${item.column.RMSYQK_ID}" generator="{&quot;classtype&quot;:&quot;uuid&quot;}"  />
							<input type="hidden" class="input_border_0" name="multirowtable['DEMO_HSJS_RMSYQK'].row[${status.index}].key['ENTER_ID']"  value="${item.column.ENTER_ID}"  generator="{&quot;classtype&quot;:&quot;form&quot;,&quot;formid&quot;:&quot;DEMO_ENTERINFO_ENTER_ID&quot;}"  />
							
						<select name="multirowtable['DEMO_HSJS_RMSYQK'].row[${status.index}].column['GLTYPE']" 
							<c:choose><c:when test="${item.column.GLTYPE==99}">style="width:48%"</c:when>
							   <c:otherwise>style="width:100%"</c:otherwise></c:choose>  onchange="javascript:getInput(this)" >
								
								<c:forEach var="gl_type" items="${dictionarys_map.gl_type}">
									<option value="${gl_type.dictionary_code}" 
									 	<c:if test="${gl_type.dictionary_code==item.column.GLTYPE}">selected="selected"</c:if>>
									 	${gl_type.dictionary_name}
									</option>
								</c:forEach>
							</select>	
							<c:choose><c:when test="${item.column.GLTYPE==99}"><input type="text"   class="input_border_0" name="multirowtable['DEMO_HSJS_RMSYQK'].row[${status.index}].column['GLTYPE_REMARK']"  value="${item.column.GLTYPE_REMARK}"   style="width:48%"  /></c:when>
								<c:otherwise><input type="hidden" class="input_border_0" name="multirowtable['DEMO_HSJS_RMSYQK'].row[${status.index}].column['GLTYPE_REMARK']"  value=""   style="width:50%"  /></c:otherwise></c:choose>
						</td>
						<td>
							<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_RMSYQK'].row[${status.index}].column['GLZD']"  value="${item.column.GLZD}"  style="width:100%"  />
						</td>
						<td>
							<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_RMSYQK'].row[${status.index}].column['RM_TYPE']"  value="${item.column.RM_TYPE}"  style="width:100%"  />
						</td>
						<td>
							<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_RMSYQK'].row[${status.index}].column['RMXHL']"  value="${item.column.RMXHL}"  style="width:100%"  />
						</td>
						<td>
							<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_RMSYQK'].row[${status.index}].column['MTLFBL']"  value="${item.column.MTLFBL}"  style="width:100%"  />
						</td>
						<td>
							<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_RMSYQK'].row[${status.index}].column['MTHFBL']"  value="${item.column.MTHFBL}"  style="width:100%"  />
						</td>
						<td>
							<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_RMSYQK'].row[${status.index}].column['MTGZWHJHFBL']"  value="${item.column.MTGZWHJHFBL}"  style="width:100%"  />
						</td>
						
						<td>
							<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_RMSYQK'].row[${status.index}].column['QTRLMC']"  value="${item.column.QTRLMC}"  style="width:100%"  />
						</td>
						<td>
							<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_RMSYQK'].row[${status.index}].column['QTRLXHL']"  value="${item.column.QTRLXHL}"  style="width:100%"  />
						</td>
						<td>
							<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_RMSYQK'].row[${status.index}].column['QTRLXHLDW']"  value="${item.column.QTRLXHLDW}"  style="width:100%"  />
						</td>
						<td class="td  border-right-none width">
							<a href="javascript:void(0)" onclick="deleteRow(this)"><i class="ace-icon fa fa-trash-o" title="删除行"></i></a>
						</td>
					</tr>
				</c:forEach>
					<tr class="td-border" id="DEMO_HSJS_RMSYQK_CLONE" style="display:none" >
						<td  style="border-left:1px solid #000;">
							<!--子表主键的generator属性配置实际效果， generator="{"classtype":"uuid"}"  -->
							<input type="hidden" class="input_border_0" name="multirowtable['DEMO_HSJS_RMSYQK'].row[index].key['RMSYQK_ID']" generator="{&quot;classtype&quot;:&quot;uuid&quot;}"  disabled/>
							<!--子表外键的generator属性配置实际效果， generator="{"classtype":"form","formid":"DEMO_ENTERINFO_ENTER_ID"}"  -->
							<input type="hidden" class="input_border_0" name="multirowtable['DEMO_HSJS_RMSYQK'].row[index].key['ENTER_ID']"  generator="{&quot;classtype&quot;:&quot;form&quot;,&quot;formid&quot;:&quot;DEMO_ENTERINFO_ENTER_ID&quot;}" disabled/>
							
							<select name="multirowtable['DEMO_HSJS_RMSYQK'].row[index].column['GLTYPE']"  onchange="javascript:getInput(this)" style="width:100%" disabled>
								
								<c:forEach var="gl_type" items="${dictionarys_map.gl_type}">
									<option value="${gl_type.dictionary_code}">
									 	${gl_type.dictionary_name}
									</option>
								</c:forEach>
							</select>	
							<input type="hidden" class="input_border_0" name="multirowtable['DEMO_HSJS_RMSYQK'].row[index].column['GLTYPE_REMARK']"  value=""   style="width:50%"  disabled/>
							
						</td>
						<td>
							<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_RMSYQK'].row[index].column['GLZD']"  style="width:100%"  disabled/>
						</td>
						<td>
							<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_RMSYQK'].row[index].column['RM_TYPE']"   style="width:100%"  disabled/>
						</td>
						<td>
							<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_RMSYQK'].row[index].column['RMXHL']"    style="width:100%" disabled />
						</td>
						<td>
							<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_RMSYQK'].row[index].column['MTLFBL']"  style="width:100%"  disabled/>
						</td>
						<td>
							<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_RMSYQK'].row[index].column['MTHFBL']"   style="width:100%"  disabled/>
						</td>
						<td>
							<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_RMSYQK'].row[index].column['MTGZWHJHFBL']"  value=""  style="width:100%"  disabled/>
						</td>
						<td>
							<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_RMSYQK'].row[index].column['QTRLMC']"  value=""  style="width:100%"  disabled/>
						</td>
						<td>
							<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_RMSYQK'].row[index].column['QTRLXHL']"    style="width:100%"  disabled/>
						</td>
						<td>
							<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_RMSYQK'].row[index].column['QTRLXHLDW']"  value=""  style="width:100%"  disabled/>
						</td>
						<td class="td  border-right-none width">
							<a href="javascript:void(0)" onclick="deleteRow(this)"><i class="ace-icon fa fa-trash-o" title="删除行"></i></a>
						</td>
					</tr>				
			</table>
		</td>
	</tr>
</table>
<table id="tab-three" width="100%" cellpadding="0" cellspacing="0" border="1" bordercolor="#000000">
	<tr class="three-tit">
		<td class="tab-tit">三、炼焦过程</td>
		<td class="border-left-none internal-top-none">
			<table class="tab-internal" width="100%" cellpadding="0" cellspacing="0" id="DEMO_HSJS_LJGC" >
				<tr>
					<td>焦炭总产量（吨/年）</td>
					<td>气态有机污染物名称</td>
					<td>总处理效率（%）</td>
					<td>有机废气处理技术</td>
					<td>处理设施年运行时间（小时）</td>
					<td>设备风量（m<sup>3</sup>/h）</td>
					<td>有机废气排放浓度（mg/m<sup>3</sup>）</td>
					<td class="td  border-right-none width">
						<a href="javascript:void(0)" onclick="addRow('DEMO_HSJS_LJGC','DEMO_HSJS_LJGC_CLONE')"><i class="ace-icon fa fa-plus" title="添加行"></i></a>
				    </td>	
				</tr>				
				<c:forEach var="item" items="${multirowtable.DEMO_HSJS_LJGC.row}" varStatus="status">
					<tr class="td-border">
						<td>
							<input type="hidden" class="input_border_0" name="multirowtable['DEMO_HSJS_LJGC'].row[${status.index}].key['LJGC_ID']"  value="${item.column.LJGC_ID}" generator="{&quot;classtype&quot;:&quot;uuid&quot;}"  />
							<input type="hidden" class="input_border_0" name="multirowtable['DEMO_HSJS_LJGC'].row[${status.index}].key['ENTER_ID']"  value="${item.column.ENTER_ID}"  generator="{&quot;classtype&quot;:&quot;form&quot;,&quot;formid&quot;:&quot;DEMO_ENTERINFO_ENTER_ID&quot;}"  />
							<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_LJGC'].row[${status.index}].column['JTZCL']"  value="${item.column.JTZCL}"  style="width:100%"/>
						</td>
						<td>
							<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_LJGC'].row[${status.index}].column['QTYJWRW']"  value="${item.column.QTYJWRW}"  style="width:100%" />
						</td>
						<td>
							<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_LJGC'].row[${status.index}].column['ZCLXL']"  value="${item.column.ZCLXL}"  style="width:100%" />
						</td>
						<td>
							<select name="multirowtable['DEMO_HSJS_LJGC'].row[${status.index}].column['YJFQCLJS']"
							   <c:choose><c:when test="${item.column.YJFQCLJS==99}">style="width:48%"</c:when>
							   <c:otherwise>style="width:100%"</c:otherwise></c:choose> onchange="javascript:getInput(this)" >
								<c:forEach var="com_cljs" items="${dictionarys_map.com_cljs}">
									<option value="${com_cljs.dictionary_code}" 
									 	<c:if test="${com_cljs.dictionary_code==item.column.YJFQCLJS}">selected="selected"</c:if>>
									 	${com_cljs.dictionary_name}
									</option>
								</c:forEach>
							</select>	
							<c:choose>
								<c:when test="${item.column.YJFQCLJS==99}"><input type="text"   class="input_border_0" name="multirowtable['DEMO_HSJS_LJGC'].row[${status.index}].column['YJFQCLJS_REMARK']"  value="${item.column.YJFQCLJS_REMARK}"   style="width:48%" /></c:when>
								<c:otherwise>
									<input type="hidden" class="input_border_0" name="multirowtable['DEMO_HSJS_LJGC'].row[${status.index}].column['YJFQCLJS_REMARK']"  value=""   style="width:50%"  />
								</c:otherwise>
							</c:choose>
						</td>
						<td>
							<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_LJGC'].row[${status.index}].column['CLSSNYXSJ']"  value="${item.column.CLSSNYXSJ}"  style="width:100%"  />
						</td>
						<td>
							<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_LJGC'].row[${status.index}].column['SBFL']"  value="${item.column.SBFL}"  style="width:100%" />
						</td>
						<td>
							<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_LJGC'].row[${status.index}].column['YJFQPFND']"  value="${item.column.YJFQPFND}"  style="width:100%" />
						</td>
						<td class="td  border-right-none width">
							<a href="javascript:void(0)" onclick="deleteRow(this)"><i class="ace-icon fa fa-trash-o" title="删除行"></i></a>
						</td>
					</tr>
				</c:forEach>
				<tr class="td-border" id="DEMO_HSJS_LJGC_CLONE" style="display:none" >
					<td>
						<input type="hidden" class="input_border_0" name="multirowtable['DEMO_HSJS_LJGC'].row[index].key['LJGC_ID']"   generator="{&quot;classtype&quot;:&quot;uuid&quot;}"  disabled/>
						<input type="hidden" class="input_border_0" name="multirowtable['DEMO_HSJS_LJGC'].row[index].key['ENTER_ID']"  generator="{&quot;classtype&quot;:&quot;form&quot;,&quot;formid&quot;:&quot;DEMO_ENTERINFO_ENTER_ID&quot;}"  disabled/>
						<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_LJGC'].row[index].column['JTZCL']"    style="width:100%"  disabled/>
					</td>
					<td>
						<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_LJGC'].row[index].column['QTYJWRW']"  style="width:100%"  disabled/>
					</td>
					<td>
						<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_LJGC'].row[index].column['ZCLXL']"    style="width:100%" disabled />
					</td>
					<td>
						<select name="multirowtable['DEMO_HSJS_LJGC'].row[index].column['YJFQCLJS']"  style="width:100%"  onchange="javascript:getInput(this)" disabled>
							<c:forEach var="com_cljs" items="${dictionarys_map.com_cljs}">
								<option value="${com_cljs.dictionary_code}" >
								 	${com_cljs.dictionary_name}
								</option>
							</c:forEach>
						</select>
						<input type="hidden" class="input_border_0" name="multirowtable['DEMO_HSJS_LJGC'].row[index].column['YJFQCLJS_REMARK']"  value=""   style="width:50%"  disabled/>
					</td>
					<td>
						<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_LJGC'].row[index].column['CLSSNYXSJ']"   style="width:100%"  disabled/>
					</td>
					<td>
						<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_LJGC'].row[index].column['SBFL']"   style="width:100%"  disabled/>
					</td>
					<td>
						<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_LJGC'].row[index].column['YJFQPFND']"    style="width:100%"  disabled/>
					</td>
					<td class="td  border-right-none width">
						<a href="javascript:void(0)" onclick="deleteRow(this)"><i class="ace-icon fa fa-trash-o" title="删除行"></i></a>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

<table id="tab-four" width="100%" cellpadding="0" cellspacing="0" border="1" bordercolor="#000000">
	<tr class="four-tit">
		<td class="tab-tit">四、炼钢过程</td>
		<td class="border-left-none internal-top-none">
			<table class="border-none" width="100%" cellpadding="0" cellspacing="0" border="1" bordercolor="#000000" id="DEMO_HSJS_LGGC">
				<!-- <tr>
					<td colspan="9" class="txt-left">废气处理技术请选择:（1）冷凝法（2）吸收法（3）吸附法（4）直接燃烧法（5）催化燃烧法（6）催化氧化法 （7）催化还原法 （8）冷凝净化法（9）其他方法（列出名称）<input type="text" class="input-hr"></td>
				</tr> -->
				<tr>
					<td colspan="2" style="width:300px;">产品信息</td>
					<td rowspan="2">气态有机污染物名称</td>
					<td rowspan="2">总处理效率（%）</td>
					<td rowspan="2" style="width:200px">有机废气处理技术</td>
					
					<td rowspan="2">处理设施年运行时间（小时）</td>
					<td rowspan="2">设备风量（m<sup>3</sup>/h）</td>
					<td rowspan="2">处理设施排放口有机废气排放浓度（mg/m<sup>3</sup>）</td>
					<td class="td  border-right-none width" rowspan="2">
						<a href="javascript:void(0)" onclick="addRow('DEMO_HSJS_LGGC','DEMO_HSJS_LGGC_CLONE')"><i class="ace-icon fa fa-plus" title="添加行"></i></a>
				    </td>	
				</tr>
				<tr>
					<td>炼钢工艺</td>
					<td>粗钢产量（吨/年）</td>
				</tr>
				<c:forEach var="item" items="${multirowtable.DEMO_HSJS_LGGC.row}" varStatus="status">
						<tr>
								<td>
									<input type="hidden" class="input_border_0" name="multirowtable['DEMO_HSJS_LGGC'].row[${status.index}].key['LGGC_ID']"  value="${item.column.LGGC_ID}" generator="{&quot;classtype&quot;:&quot;uuid&quot;}"  />
									<input type="hidden" class="input_border_0" name="multirowtable['DEMO_HSJS_LGGC'].row[${status.index}].key['ENTER_ID']"  value="${item.column.ENTER_ID}"  generator="{&quot;classtype&quot;:&quot;form&quot;,&quot;formid&quot;:&quot;DEMO_ENTERINFO_ENTER_ID&quot;}"  />
									
									<select name="multirowtable['DEMO_HSJS_LGGC'].row[${status.index}].column['LGGY']"  
									   <c:choose><c:when test="${item.column.LGGY==99}">style="width:48%"</c:when>
									   <c:otherwise>style="width:100%"</c:otherwise></c:choose> onchange="javascript:getInput(this)" >
										<c:forEach var="hsjs_lggy" items="${dictionarys_map.hsjs_lggy}">
											<option value="${hsjs_lggy.dictionary_code}" 
											 	<c:if test="${hsjs_lggy.dictionary_code==item.column.LGGY}">selected="selected"</c:if>>
											 	${hsjs_lggy.dictionary_name}
											</option>
										</c:forEach>
									</select>	
									<c:choose><c:when test="${item.column.LGGY==99}"><input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_LGGC'].row[${status.index}].column['LGGY_REMARK']"  value="${item.column.LGGY_REMARK}"   style="width:48%"  /></c:when>
										<c:otherwise><input type="hidden" class="input_border_0" name="multirowtable['DEMO_HSJS_LGGC'].row[${status.index}].column['LGGY_REMARK']"  value=""   style="width:50%"  /></c:otherwise></c:choose>
										
									
									

								</td>
								<td>
									<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_LGGC'].row[${status.index}].column['CGCL']"  value="${item.column.CGCL}"  style="width:100%"  />
								</td>
								<td>
									<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_LGGC'].row[${status.index}].column['QTYJWRW']"  value="${item.column.QTYJWRW}"  style="width:100%"  />
								</td>
								<td>
									<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_LGGC'].row[${status.index}].column['ZCLXL']"  value="${item.column.ZCLXL}"  style="width:100%"  />
								</td>
								<td> 
									<%-- <input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_LGGC'].row[${status.index}].column['YJFQCLJS']"  value="${item.column.YJFQCLJS}"  style="width:100%"  /> --%>
									<select name="multirowtable['DEMO_HSJS_LGGC'].row[${status.index}].column['YJFQCLJS']"  
									   <c:choose><c:when test="${item.column.YJFQCLJS==99}">style="width:48%"</c:when>
									   <c:otherwise>style="width:100%"</c:otherwise></c:choose> onchange="javascript:getInput(this)" >
										<c:forEach var="com_cljs" items="${dictionarys_map.com_cljs}">
											<option value="${com_cljs.dictionary_code}" 
											 	<c:if test="${com_cljs.dictionary_code==item.column.YJFQCLJS}">selected="selected"</c:if>>
											 	${com_cljs.dictionary_name}
											</option>
										</c:forEach>
									</select>	
									<c:choose><c:when test="${item.column.YJFQCLJS==99}"><input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_LGGC'].row[${status.index}].column['YJFQCLJS_REMAKR']"  value="${item.column.YJFQCLJS_REMAKR}"   style="width:48%"  /></c:when>
										<c:otherwise><input type="hidden" class="input_border_0" name="multirowtable['DEMO_HSJS_LGGC'].row[${status.index}].column['YJFQCLJS_REMAKR']"  value=""   style="width:50%"  /></c:otherwise></c:choose>
										
									<%-- <input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_LGGC'].row[${status.index}].column['YJFQCLJS']"  value="${item.column.YJFQCLJS}"   style="width:50%"  /> --%>
								</td>
								
								<td>
									<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_LGGC'].row[${status.index}].column['CLSSNYXSJ']"  value="${item.column.CLSSNYXSJ}"  style="width:100%"  />
								</td>
								<td>
									<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_LGGC'].row[${status.index}].column['SBFL']"  value="${item.column.SBFL}"  style="width:100%"  />
								</td>
								<td>
									<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_LGGC'].row[${status.index}].column['YJFQPFND']"  value="${item.column.YJFQPFND}"  style="width:100%"  />
								</td>
								<td class="td  border-right-none width">
									<a href="javascript:void(0)" onclick="deleteRow(this)"><i class="ace-icon fa fa-trash-o" title="删除行"></i></a>
								</td>
								
							</tr>
				</c:forEach>
						<tr  id="DEMO_HSJS_LGGC_CLONE" style="display:none">
								<td>
									<input type="hidden" class="input_border_0" name="multirowtable['DEMO_HSJS_LGGC'].row[index].key['LGGC_ID']"    generator="{&quot;classtype&quot;:&quot;uuid&quot;}"  disabled/>
									<input type="hidden" class="input_border_0" name="multirowtable['DEMO_HSJS_LGGC'].row[index].key['ENTER_ID']"   generator="{&quot;classtype&quot;:&quot;form&quot;,&quot;formid&quot;:&quot;DEMO_ENTERINFO_ENTER_ID&quot;}"  disabled/>
									<select name="multirowtable['DEMO_HSJS_LGGC'].row[index].column['LGGY']" style="width:100%" onchange="javascript:getInput(this)" disabled>
										<c:forEach var="hsjs_lggy" items="${dictionarys_map.hsjs_lggy}">
											<option value="${hsjs_lggy.dictionary_code}" >
											 	${hsjs_lggy.dictionary_name}
											</option>
										</c:forEach>
									</select>	
									<input type="hidden" class="input_border_0" name="multirowtable['DEMO_HSJS_LGGC'].row[index].column['LGGY_REMARK']"  value=""   style="width:50%"  disabled/>
										
									
								</td>
								<td>
									<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_LGGC'].row[index].column['CGCL']"      style="width:100%" disabled/>
								</td>
								<td>
									<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_LGGC'].row[index].column['QTYJWRW']"   style="width:100%"  disabled/>
								</td>
								<td>
									<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_LGGC'].row[index].column['ZCLXL']"    style="width:100%"  disabled/>
								</td>
								<td>
									<!-- <input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_LGGC'].column['YJFQCLJS']"    style="width:100%"  /> -->
									<select name="multirowtable['DEMO_HSJS_LGGC'].row[index].column['YJFQCLJS']"  style="width:100%"  onchange="javascript:getInput(this)" disabled>
										<c:forEach var="com_cljs" items="${dictionarys_map.com_cljs}">
											<option value="${com_cljs.dictionary_code}" >
											 	${com_cljs.dictionary_name}
											</option>
										</c:forEach>
									</select>
									<input type="hidden" class="input_border_0" name="multirowtable['DEMO_HSJS_LGGC'].row[index].column['YJFQCLJS_REMAKR']"  value=""   style="width:50%"  disabled/>
										
								</td>
								
								<td>
									<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_LGGC'].row[index].column['CLSSNYXSJ']"    style="width:100%"  disabled/>
								</td>
								<td>
									<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_LGGC'].row[index].column['SBFL']"   style="width:100%"  disabled/>
								</td>
								<td>
									<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_LGGC'].row[index].column['YJFQPFND']"   style="width:100%"  disabled/>
								</td>
								<td class="td  border-right-none width">
									<a href="javascript:void(0)" onclick="deleteRow(this)"><i class="ace-icon fa fa-trash-o" title="删除行"></i></a>
								</td>
							</tr>
			</table>
		</td>
	</tr>
</table>


<table id="tab-five" width="100%" cellpadding="0" cellspacing="0" border="1" bordercolor="#000000" style="border-top:0">
	<tr class="five-tit">
		<td class="tab-tit internal-top-none">五、燃煤和产品时间变化信息</td>
		<td class="border-left-none internal-top-none">
			<table class="border-none" width="100%" cellpadding="0" cellspacing="0" border="1" bordercolor="#000000" id="DEMO_HSJS_RLSYSJBHXX">
				<tr class="border-top-none">
					<td style="width:150px;">名称</td>
					<td>1月</td>
					<td>2月</td>
					<td>3月</td>
					<td>4月</td>
					<td>5月</td>
					<td>6月</td>
					<td>7月</td>
					<td>8月</td>
					<td>9月</td>
					<td>10月</td>
					<td>11月</td>
					<td>12月</td>
					<td width="5%">合计</td>
				</tr>
				<c:forEach var="hsjs_rlsyqk" items="${dictionarys_map.hsjs_rmhcpsj}"  varStatus="status">
							<c:forEach var="item_value" items="${multirowtable['DEMO_HSJS_RLSYSJBHXX'].row}" varStatus="status_value">
										<c:if test="${hsjs_rlsyqk.dictionary_code==item_value.column.CODE}">
												<c:set  var="MONTH1" value="${item_value.column.MONTH1}" /> 
												<c:set  var="MONTH2" value="${item_value.column.MONTH2}" /> 
												<c:set  var="MONTH3" value="${item_value.column.MONTH3}" /> 
												<c:set  var="MONTH4" value="${item_value.column.MONTH4}" /> 
												<c:set  var="MONTH5" value="${item_value.column.MONTH5}" /> 
												<c:set  var="MONTH6" value="${item_value.column.MONTH6}" /> 
												<c:set  var="MONTH7" value="${item_value.column.MONTH7}" /> 
												<c:set  var="MONTH8" value="${item_value.column.MONTH8}" /> 
												<c:set  var="MONTH9" value="${item_value.column.MONTH9}" /> 
												<c:set  var="MONTH10" value="${item_value.column.MONTH10}" /> 
												<c:set  var="MONTH11" value="${item_value.column.MONTH11}" /> 
												<c:set  var="MONTH12" value="${item_value.column.MONTH12}" />  
										</c:if>
							</c:forEach>
					<tr>
						<td class="main">${hsjs_rlsyqk.dictionary_name}
								<input type="hidden" class="input_border_0" name="multirowtable['DEMO_HSJS_RLSYSJBHXX'].row[${status.index}].key['RLSYSJBHXX_ID']"  value="${table['DEMO_ENTERINFO'].key['ENTER_ID']}${hsjs_rlsyqk.dictionary_code}" />
								<input type="hidden" class="input_border_0" name="multirowtable['DEMO_HSJS_RLSYSJBHXX'].row[${status.index}].key['ENTER_ID']"  value="${table['DEMO_ENTERINFO'].key['ENTER_ID']}"   />
								<input type="hidden" class="input_border_0" name="multirowtable['DEMO_HSJS_RLSYSJBHXX'].row[${status.index}].key['CODE']"  value="${hsjs_rlsyqk.dictionary_code}"   />
								<input type="hidden" class="input_border_0" name="multirowtable['DEMO_HSJS_RLSYSJBHXX'].row[${status.index}].key['MC']"  value="${hsjs_rlsyqk.dictionary_name}"   />
						</td>
						<td>
								<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_RLSYSJBHXX'].row[${status.index}].column['MONTH1']" value="${MONTH1}"   data-validation-engine="validate[custom[number]]" style="width:100%"/>
						</td>
						<td>
								<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_RLSYSJBHXX'].row[${status.index}].column['MONTH2']" value="${MONTH2}"   data-validation-engine="validate[custom[number]]" style="width:100%"/>
						</td>
						<td>
								<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_RLSYSJBHXX'].row[${status.index}].column['MONTH3']" value="${MONTH3}"   data-validation-engine="validate[custom[number]]" style="width:100%"/>
						</td>
						<td>
								<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_RLSYSJBHXX'].row[${status.index}].column['MONTH4']" value="${MONTH4}"   data-validation-engine="validate[custom[number]]" style="width:100%"/>
						</td>
						<td>
								<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_RLSYSJBHXX'].row[${status.index}].column['MONTH5']" value="${MONTH5}"   data-validation-engine="validate[custom[number]]" style="width:100%"/>
						</td>
						<td>
								<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_RLSYSJBHXX'].row[${status.index}].column['MONTH6']" value="${MONTH6}"   data-validation-engine="validate[custom[number]]" style="width:100%"/>
						</td>
						<td>
								<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_RLSYSJBHXX'].row[${status.index}].column['MONTH7']" value="${MONTH7}"   data-validation-engine="validate[custom[number]]" style="width:100%"/>
						</td>
						<td>
								<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_RLSYSJBHXX'].row[${status.index}].column['MONTH8']" value="${MONTH8}"   data-validation-engine="validate[custom[number]]" style="width:100%"/>
						</td>
						<td>
								<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_RLSYSJBHXX'].row[${status.index}].column['MONTH9']" value="${MONTH9}"   data-validation-engine="validate[custom[number]]" style="width:100%"/>
						</td>
						<td>
								<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_RLSYSJBHXX'].row[${status.index}].column['MONTH10']" value="${MONTH10}"   data-validation-engine="validate[custom[number]]" style="width:100%"/>
						</td>
						<td>
								<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_RLSYSJBHXX'].row[${status.index}].column['MONTH11']" value="${MONTH11}"   data-validation-engine="validate[custom[number]]" style="width:100%"/>
						</td>
						<td>
								<input type="text" class="input_border_0" name="multirowtable['DEMO_HSJS_RLSYSJBHXX'].row[${status.index}].column['MONTH12']" value="${MONTH12}"   data-validation-engine="validate[custom[number]]" style="width:100%"/>
						</td>
						<td>
							<span id="hj_${status.index}"></span>
						</td>
					</tr>
			 </c:forEach>		
			</table>
		</td>
	</tr>
</table>

<br/>
<table class="foot-table-input" style="width: 100%">
<tr>
	<td>
		<span>企业负责人：</span> <input type="text" name="table['DEMO_ENTERINFO'].column['CHARGE_PERSON']" id="DEMO_ENTERINFO_CHARGE_PERSON" value="${table['DEMO_ENTERINFO'].column['CHARGE_PERSON']}"/>
	</td>
	<td >	
		<span>填表人：</span> <input style="width: 300px" type="text" name="table['DEMO_ENTERINFO'].column['PERSON']" id="DEMO_ENTERINFO_PERSON" value="${table['DEMO_ENTERINFO'].column['PERSON']}"/>
	</td>
	<td >	
		<span>填表日期：</span>
		<input id="DEMO_ENTERINFO_FILL_DATETIME" name="table['DEMO_ENTERINFO'].column['FILL_DATETIME']"  type="text" onfocus="WdatePicker({skin:'twoer'})"
		 value="${table['DEMO_ENTERINFO'].column['FILL_DATETIME']}"/>
	</td> 
	</tr>                                     
</table>
</form>
</div>
<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
<script type="text/javascript">
jQuery(function ($) {
    //表单验证组件初始化，详细文档请参考http://code.ciaoca.com/jquery/validation-engine/ 或官网文档http://posabsolute.github.io/jQuery-Validation-Engine/
    $("#formInfo").validationEngine({
        scrollOffset: 98,//必须设置，因为Toolbar position为Fixed
        promptPosition: 'bottomLeft',
        autoHidePrompt: true
    });
    	/* 初始化行数 */
    initRow('DEMO_HSJS_RMSYQK','DEMO_HSJS_RMSYQK_CLONE',3,1); 
    initRow('DEMO_HSJS_LJGC','DEMO_HSJS_LJGC_CLONE',2,1);
    initRow('DEMO_HSJS_LGGC','DEMO_HSJS_LGGC_CLONE',3,1); 
    
    
    sum("tab-five","hj_","input[type='text']");
    setRowBlur("tab-five","hj_","input[type='text']");
});

var url = '${ctx}/demo/eform/complexform/masterslave/masterslave_save.vm';
function doSave(state){
	$("#DEMO_ENTERINFO_STATE").val(state);
	if(state!=null && state!=undefined && state == '2'){
		if($("#formInfo").validationEngine("validate")){
			if(confirm("是否确认提交?")){
				//submitCustom(url,state);
				openRemark("${ctx}/demo/eform/complexform/masterslave/masterslave_remark.vm","${table['DEMO_ENTERINFO'].key['ENTER_ID']}");
			}
		 }
	}else{
		//暂存时，使用ths.hideNullValidate进行validate校验，会忽略空值
		ths.hideNullValidate("formInfo",function(){
			submitCustom(url,state);
		})
	}
}

function openTrade(){
	  treeDialog=dialog({
			id:"dialog-user-muti",
	        title: "行业",
	        url: "${ctx}/eform/tree/window.vm?mapperid=trade_tree&callback=tradeCallBack",
	        width:380,
	        height:480
	    }).showModal();
}

function tradeCallBack(tree){
	$("#INDUSTRY_NAME").val(tree.TREE_NAME);
	$("#INDUSTRY_CODE").val(tree.TREE_ID);
}

function openCity(){
	  treeDialog=dialog({
			id:"dialog-user-muti",
	        title: "选在所在市",
	        url: "${ctx}/eform/tree/window.vm?mapperid=region_tree&callback=cityCallBack&PARENTCODE=350000000000",
	        width:280,
	        height:280
	    }).showModal();
}

function cityCallBack(tree){
	$("#ADDR_CITY").val(tree.TREE_NAME);
	$("#CITY_CODE").val(tree.TREE_ID);
}

function openCounty(){
	  treeDialog=dialog({
			id:"dialog-user-muti",
	        title: "选在所在区县",
	        url: "${ctx}/eform/tree/window.vm?mapperid=region_tree&callback=countyCallBack&PARENTCODE="+$("#CITY_CODE").val(),
	        width:280,
	        height:280
	    }).showModal();
}

function countyCallBack(tree){
	$("#ADDR_COUNTY").val(tree.TREE_NAME);
	$("#COUNTY_CODE").val(tree.TREE_ID);
}
//填写完备注后，调用该方法。进行数据保存，只有提交的时候使用
function toSubmit(txt){
	$("#REMARK").val(txt);
	submitCustom(url,'2');
}

</script>
</body>
</html>
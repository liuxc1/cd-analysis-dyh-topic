<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
<head>
	<title>黑色金属冶炼和压延加工企业调查表</title>
	<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
	<script type="text/javascript" src="${ctx}/assets/js/eform/masterslave/js/subtable.js?v=20221129015223"></script>
	<link rel="stylesheet" href="${ctx}/assets/js/eform/masterslave/css/subtable.css?v=20221129015223"/>
	<link rel="stylesheet" href="${ctx}/assets/js/eform/masterslave/css/kefu.css?v=20221129015223"/>
  	<!--页面自定义的CSS，请放在这里 -->
	<style> 
		body{text-align:center} 
		.shuli{ margin:0 auto;width:20px;line-height:24px;font-size: 16px;color: #fff;} 
	</style>
</head>
<script type="text/javascript">
 function print_(){
	 document.getElementById("title").style.display='none';
	 document.getElementById("floatTools").style.display='none';
	 document.getElementById("file_table").style.display='none';
	 window.print();
 }
 $(function(){
		$("#aFloatTools_Show").click(function(){
			$('#divFloatToolsView').animate({width:'show',opacity:'show'},100,function(){$('#divFloatToolsView').show();});
			$('#aFloatTools_Show').hide();
			$('#aFloatTools_Hide').show();				
		});
		$("#aFloatTools_Hide").click(function(){
			$('#divFloatToolsView').animate({width:'hide', opacity:'hide'},100,function(){$('#divFloatToolsView').hide();});
			$('#aFloatTools_Show').show();
			$('#aFloatTools_Hide').hide();	
		});
	});
</script>
<body>
<div id="floatTools" class="rides-cs" style="height:350px;">
  <div class="floatL">
  	<div class="shuli">查看填报备注说明</div> 
  	<a style="display:block" id="aFloatTools_Show" class="btnOpen" title="查看" style="top:20px" href="javascript:void(0);">展开</a>
  	<a style="display:none" id="aFloatTools_Hide" class="btnCtn" title="关闭" style="top:20px" href="javascript:void(0);">收缩</a>
  </div>
  <div id="divFloatToolsView" class="floatR" style="display: none;height:373px;width: 200px;">
    <div class="cn" style="height: 90%;overflow-y:scroll;">
      <p style="font-size: 15px">${table['DEMO_ENTERINFO'].column['REMARK']}</p>
    </div>
  </div>
</div>
<div id="title">
	<p>黑色金属冶炼和压延加工企业调查表</p>
</div>

<div id="table-div">

<form class="form-horizontal" role="form" id="formInfo" action="" method="post">
<h1 style="text-align:center;">黑色金属冶炼和压延加工企业调查表</h1>
<table id="tab-one" width="100%"   cellpadding="0" cellspacing="0" border="1" bordercolor="#000000">
			<tr>
				<td class="tab-tit" rowspan="5">一、工业企业基本情况</td>
				<td class="left">
					<span>数据日期：</span>
					<span style="width: 30%">
						<c:forEach var="total_year" items="${dictionarys_map.total_year}"  varStatus="status">
						  <c:if test="${total_year.dictionary_code==table['DEMO_ENTERINFO'].column['TOTAL_YEAR']}">
							${total_year.dictionary_name}
						</c:if>
						</c:forEach>
					</span>
				</td>
			</tr>
			<tr>
				<td class="left">
					<span>企业名称（公章）：</span>
					 ${table.DEMO_ENTERINFO.column.ENTER_NAME}
				</td>
			</tr>
			<tr>
				<td class="left">
					<span>统一社会信用代码（18位）/组织机构代码（9位）：</span>
					${table['DEMO_ENTERINFO'].column['ORG_CODE']}
				</td>
			</tr>
			<tr>
				<td class="left">
					<span>所属行业名称:</span>
					${table['DEMO_ENTERINFO'].column['INDUSTRY_NAME']}
					（${table['DEMO_ENTERINFO'].column['INDUSTRY_CODE']}）
				</td>
			</tr>
		
			<tr>
				<td class="left">
					<p>
						<span>企业地址：</span>
						${table['DEMO_ENTERINFO'].column['ADDR_HOUSEADDRESS']}
						<%-- ${table['DEMO_ENTERINFO'].column['ADDR_CITY']}
						<span>市</span>
						${table['DEMO_ENTERINFO'].column['ADDR_COUNTY']}
						<span>区（县）</span>
						${table['DEMO_ENTERINFO'].column['ADDR_TOWN']}
						<span>镇（街道）</span>
						${table['DEMO_ENTERINFO'].column['ADDR_ADDRESS']}
						<span>村（工业园、工业区）</span>
						${table['DEMO_ENTERINFO'].column['ADDR_HOUSEADDRESS']}
						<span>路、门牌号</span> --%>
					</p>
					<p>
						<span>经度（厂房）：东经</span>
						${table['DEMO_ENTERINFO'].column['LONGITUDE_DU']}
						<span>度</span>
						${table['DEMO_ENTERINFO'].column['LONGITUDE_FEN']}
						<span>分</span>
						${table['DEMO_ENTERINFO'].column['LONGITUDE_MIAO']}
						<span>秒</span>
						
						<span style="font-size: 12px">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
						
						<span>纬度（厂房）：</span>
						<span>北纬</span>
						${table['DEMO_ENTERINFO'].column['LATITUDE_DU']}
						<span>度</span>
						${table['DEMO_ENTERINFO'].column['LATITUDE_FEN']}
						<span>分</span>
						${table['DEMO_ENTERINFO'].column['LATITUDE_MIAO']}
						<span>秒</span>
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
								<td>
									<c:forEach var="gl_type" items="${dictionarys_map.gl_type}">
										<c:if test="${gl_type.dictionary_code==item.column.GLTYPE}">${gl_type.dictionary_name}</c:if>
									</c:forEach>
									<c:if test="${item.column.GLTYPE==99}">${item.column.GLTYPE_REMARK}</c:if>
										
								</td>
								<td>
									${item.column.GLZD}
								</td>
								<td>
									${item.column.RM_TYPE}
								</td>
								<td>
									${item.column.RMXHL}
								</td>
								<td>
									${item.column.MTLFBL}
								</td>
								<td>
									${item.column.MTHFBL}
								</td>
								<td>
									${item.column.MTGZWHJHFBL}
								</td>
								
								<td>
									${item.column.QTRLMC}
								</td>
								<td>
									${item.column.QTRLXHL}
								</td>
								<td>
									${item.column.QTRLXHLDW}
								</td>
							</tr>
				</c:forEach>
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
				</tr>				
				<c:forEach var="item" items="${multirowtable.DEMO_HSJS_LJGC.row}" varStatus="status">
						<tr>
								<td>
									${item.column.JTZCL}
								</td>
								<td>
									${item.column.QTYJWRW}
								</td>
								<td>
									${item.column.ZCLXL}
								</td>
								<td>
										<c:forEach var="com_cljs" items="${dictionarys_map.com_cljs}">
											<c:if test="${com_cljs.dictionary_code==item.column.YJFQCLJS}">${com_cljs.dictionary_name}</c:if>
										</c:forEach>
									<c:if test="${item.column.YJFQCLJS==99}">(${item.column.YJFQCLJS_REMARK})</c:if>
									
								</td>
								<td>
									${item.column.CLSSNYXSJ}
								</td>
								<td>
									${item.column.SBFL}
								</td>
								<td>
									${item.column.YJFQPFND}
								</td>
							</tr>
				</c:forEach>
			</table>
		</td>
	</tr>
</table>



<table id="tab-four" width="100%" cellpadding="0" cellspacing="0" border="1" bordercolor="#000000">
	<tr class="four-tit">
		<td class="tab-tit">四、炼钢过程</td>
		<td class="border-left-none internal-top-none">
			<table class="border-none" width="100%" cellpadding="0" cellspacing="0" border="1" bordercolor="#000000" id="DEMO_HSJS_LGGC">
				<tr>
					<td colspan="2" style="width:300px;">产品信息</td>
					<td rowspan="2">气态有机污染物名称</td>
					<td rowspan="2">总处理效率（%）</td>
					<td rowspan="2" style="width:200px">有机废气处理技术</td>
					
					<td rowspan="2">处理设施年运行时间（小时）</td>
					<td rowspan="2">设备风量（m<sup>3</sup>/h）</td>
					<td rowspan="2">处理设施排放口有机废气排放浓度（mg/m<sup>3</sup>）</td>
				</tr>
				<tr>
					<td>炼钢工艺</td>
					<td>粗钢产量（吨/年）</td>
				</tr>
				<c:forEach var="item" items="${multirowtable.DEMO_HSJS_LGGC.row}" varStatus="status">
					<tr class="">
						<td>
							<c:forEach var="hsjs_lggy" items="${dictionarys_map.hsjs_lggy}">
									<c:if test="${hsjs_lggy.dictionary_code==item.column.LGGY}">${hsjs_lggy.dictionary_name}</c:if>
							</c:forEach>
							<c:if test="${item.column.LGGY==99}">(${item.column.LGGY_REMARK})</c:if>
						<td>
							${item.column.CGCL}
						</td>
						<td>
							${item.column.QTYJWRW}
						</td>
						<td>
							${item.column.ZCLXL}
						</td>
						<td> 
								<c:forEach var="com_cljs" items="${dictionarys_map.com_cljs}">
									 	<c:if test="${com_cljs.dictionary_code==item.column.YJFQCLJS}">${com_cljs.dictionary_name}</c:if>
								</c:forEach>
							    <c:if test="${item.column.YJFQCLJS==99}">(${item.column.YJFQCLJS_REMAKR})</c:if>
						</td>
						
						<td>
							${item.column.CLSSNYXSJ}
						</td>
						<td>
							${item.column.SBFL}
						</td>
						<td>
							${item.column.YJFQPFND}
						</td>
					</tr>
				</c:forEach>
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
						</td>
						<td>
							${MONTH1}
							<input type="hidden" name="yf" value="${MONTH1}"/>
						</td>
						<td>
							${MONTH2}
							<input type="hidden" name="yf" value="${MONTH2}"/>
						</td>
						<td>
							${MONTH3}
							<input type="hidden" name="yf" value="${MONTH3}"/>
						</td>
						<td>
							${MONTH4}
							<input type="hidden" name="yf" value="${MONTH4}"/>
						</td>
						<td>
							${MONTH5}
							<input type="hidden" name="yf" value="${MONTH5}"/>
						</td>	
						<td>
							${MONTH6}
							<input type="hidden" name="yf" value="${MONTH6}"/>
						</td>
						<td>
							${MONTH7}
							<input type="hidden" name="yf" value="${MONTH7}"/>
						</td>
						<td>
							${MONTH8}
							<input type="hidden" name="yf" value="${MONTH8}"/>
						</td>
						<td>
							${MONTH9}
							<input type="hidden" name="yf" value="${MONTH9}"/>
						</td>
						<td>
							${MONTH10}
							<input type="hidden" name="yf" value="${MONTH10}"/>
						</td>
						<td>
							${MONTH11}
							<input type="hidden" name="yf" value="${MONTH11}"/>
						</td>
						<td>
							${MONTH12}
							<input type="hidden" name="yf" value="${MONTH12}"/>
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
<table id="tab-two" class="border-bottom-solid" width="100%"
	cellpadding="0" cellspacing="0" border="1" bordercolor="#000000">
	<tr>
		<td class="tab-tit border-left-none internal-top-none" >VOCs排放量统计(吨)</td>
		<td class="internal-top-none align-left">
			<c:choose >
				<c:when test="${table['T_VOCS_PFL'].column['R_VOCS_COUNT'] > -1}">
				${table['T_VOCS_PFL'].column['R_VOCS_COUNT']} (人工计算)
				</c:when>
				<c:otherwise>
				${table['T_VOCS_PFL'].column['VOCS_COUNT']}
				</c:otherwise>
			</c:choose>
		</td>
	</tr>
</table>
<table style="width: 100%">
	<tr>
		<td>企业负责人:${table['DEMO_ENTERINFO'].column['CHARGE_PERSON']}</td>
		<td>填表人：${table['DEMO_ENTERINFO'].column['PERSON']}</td>
		<td>填表日期：${table['DEMO_ENTERINFO'].column['FILL_DATETIME']}</td>
	</tr>
</table>
</form>
</div>
<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
<script src="${ctx}/assets/js/ths-eform.js?v=20221129015223"></script>
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
    
    
    sum("tab-five","hj_","input[name='yf']");
});


</script>
</body>
</html>
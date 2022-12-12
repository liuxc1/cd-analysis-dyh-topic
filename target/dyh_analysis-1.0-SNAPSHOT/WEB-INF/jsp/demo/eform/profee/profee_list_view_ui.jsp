<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
<head>
    <title>项目费用</title>
	<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
  	<!--页面自定义的CSS，请放在这里 -->
    <style type="text/css">

    </style>
</head>

<body class="no-skin">

<div class="main-container" id="main-container">
    <div class="main-content">
        <div class="unique-breadcrumbs main-content-inner fixed-page-header fixed-40">
            <div id="breadcrumbs" class="breadcrumbs">
                <ul class="breadcrumb">
                    <li class="active">
                        <h5 class="page-title" >
                            <i class="fa fa-file-text-o"></i>
                            <span class="THS_JDP_RES_DESC">${THS_JDP_RES_DESC}</span>
                        </h5>
                    </li>
                </ul><!-- /.breadcrumb -->

            </div>
        </div>
        <div class="main-content-inner padding-page-content">
            <div class="page-content">
                <div class="space-4"></div>
                <div class="row">
                    <div class="col-xs-12">
                        <form class="form-horizontal" role="form" id="formList" action="profee_list_view_ui.vm" method="post">
							<input type="hidden" name="THS_JDP_RES_DESC" value="${THS_JDP_RES_DESC }"/>
							<input type="hidden" name="THS_JDP_RES_ID" value="${THS_JDP_RES_ID }"/>
								<div class="module-layout">
								<div class="high-search-btn-box" style="display:none;">
									<a class="high-search-btn">高级搜索<i class="fa fa-angle-down"></i><i class="fa fa-angle-up"></i></a>
								</div>
	                            <div class="form-group">
	                                <label class="col-sm-1 control-label no-padding-right" for="txtName">
	                                    项目名称
	                                </label>
	                                <div class="col-sm-3">
	                                       <input type="text" class="form-control"  name="form['PRO_NAME']"  value="${form.PRO_NAME}" />
	                                </div>
	                                
	                                <label class="col-sm-1 control-label no-padding-right hidden-xs"
	                                       for="form-field-221">项目类型</label>
	                                <div class="col-sm-3 hidden-xs">
	                                    <select class="form-control"   name="form['CODE_KIND']">
	                                        <option value="">-全部-</option>
	                                        <option <c:if test="${form.CODE_KIND==1}">selected="selected"</c:if> value="1">北京项目</option>
	                                        <option <c:if test="${form.CODE_KIND==2}">selected="selected"</c:if> value="2">地方项目</option>
	                                        <option <c:if test="${form.CODE_KIND==3}">selected="selected"</c:if> value="3">清华项目</option>
	                                        <option <c:if test="${form.CODE_KIND==4}">selected="selected"</c:if> value="4">环保部项目</option>
	                                    </select>
	                                </div>
	                                
	                                <div class="col-sm-4  align-center">
	                                    <div class="space-4 hidden-lg hidden-md hidden-sm"></div>
	                                    <button type="button" class="btn btn-info"  data-self-js="doSearch(true)">
	                                        <i class="ace-icon fa fa-search"></i>
	                                        搜索
	                                    </button>
	                                </div>
	                            </div>
	                            <div class="high-search-box">
	                            <div class="form-group">
	                            		<label class="col-sm-1 control-label no-padding-right hidden-xs">签署日期</label>
	                                    <div class="col-xs-3 hidden-xs">
	                                        <div class="input-group input-group-date" id="divDate1">
	                                            <input type="text"  id="txtDateStart" class="form-control "  name="form['START_DATE']"  value="${form.START_DATE}" readonly="readonly">
			                                    <span class="input-group-btn">
			                                        <button type="button" class="btn btn-white  " id="btnDateStart">
			                                            <i class="ace-icon fa fa-calendar"></i>
			                                        </button>
			                                    </span>
	                                        </div>
	                                    </div>
	                                    <label class="col-xs-1 control-label no-padding-right  hidden-xs">至</label>
	                                    <div class="col-xs-3 hidden-xs">
	                                        <div class="input-group input-group-date" id="divDate2">
	                                            <input type="text" id="txtDateEnd" class="form-control"  name="form['END_DATE']"  value="${form.END_DATE}"  readonly="readonly">
			                                    <span class="input-group-btn">
			                                        <button type="button" class="btn btn-white  " id="btnDateEnd">
			                                            <i class="ace-icon fa fa-calendar"></i>
			                                        </button>
			                                    </span>
	                                        </div>
	                                    </div>
	                            </div>
	                            
	                            <div class="form-group">
	                            		<label class="col-sm-1 control-label no-padding-right hidden-xs">签署日期</label>
	                                    <div class="col-xs-3 hidden-xs">
	                                        <div class="input-group input-group-date" id="divDate1">
	                                            <input type="text"  id="txtDateStart" class="form-control "  name="form['START_DATE']"  value="${form.START_DATE}" readonly="readonly">
			                                    <span class="input-group-btn">
			                                        <button type="button" class="btn btn-white  " id="btnDateStart">
			                                            <i class="ace-icon fa fa-calendar"></i>
			                                        </button>
			                                    </span>
	                                        </div>
	                                    </div>
	                                    <label class="col-xs-1 control-label no-padding-right  hidden-xs">至</label>
	                                    <div class="col-xs-3 hidden-xs">
	                                        <div class="input-group input-group-date" id="divDate2">
	                                            <input type="text" id="txtDateEnd" class="form-control"  name="form['END_DATE']"  value="${form.END_DATE}"  readonly="readonly">
			                                    <span class="input-group-btn">
			                                        <button type="button" class="btn btn-white  " id="btnDateEnd">
			                                            <i class="ace-icon fa fa-calendar"></i>
			                                        </button>
			                                    </span>
	                                        </div>
	                                    </div>
	                            </div>
	                            <div class="form-group">
                            		<label class="col-sm-1 control-label no-padding-right hidden-xs">签署日期</label>
                                    <div class="col-xs-3 hidden-xs">
                                        <div class="input-group input-group-date" id="divDate1">
                                            <input type="text"  id="txtDateStart" class="form-control "  name="form['START_DATE']"  value="${form.START_DATE}" readonly="readonly">
		                                    <span class="input-group-btn">
		                                        <button type="button" class="btn btn-white  " id="btnDateStart">
		                                            <i class="ace-icon fa fa-calendar"></i>
		                                        </button>
		                                    </span>
                                        </div>
                                    </div>
                                    <label class="col-xs-1 control-label no-padding-right  hidden-xs">至</label>
                                    <div class="col-xs-3 hidden-xs">
                                        <div class="input-group input-group-date" id="divDate2">
                                            <input type="text" id="txtDateEnd" class="form-control"  name="form['END_DATE']"  value="${form.END_DATE}"  readonly="readonly">
		                                    <span class="input-group-btn">
		                                        <button type="button" class="btn btn-white  " id="btnDateEnd">
		                                            <i class="ace-icon fa fa-calendar"></i>
		                                        </button>
		                                    </span>
                                        </div>
                                    </div>
                            </div>
                            </div>
                            </div>
                            <!-- <hr class="no-margin"> -->
                            <div class="module-layout">
                            <div class="page-toolbar align-right list-toolbar">
                                <button type="button" class="btn btn-xs    btn-xs-ths"  data-self-js="doEdit('')" id="btnAdd">
                                    <i class="ace-icon fa fa-plus"></i>
                                    添加
                                </button>
                                <button type="button" class="btn btn-xs btn-xs-ths" data-self-js="doDelete()" id="btnDelete">
                                    <i class="ace-icon fa fa-trash-o"></i>
                                    删除
                                </button>
                                 <div class="btn-group">
                                    <button data-toggle="dropdown"
                                            class="btn btn-xs  btn-xs-ths dropdown-toggle"
                                            aria-expanded="false">
                                        <i class="ace-icon fa fa-wrench"></i>
                                        其他示例
                                        <i class="ace-icon fa fa-angle-down icon-on-right"></i>
                                    </button>

                                    <ul class="dropdown-menu dropdown-menu-right">
                                        <li>
                                            <a  data-self-href="${ctx}/demo/eform/complexform/multitable/multitable_edit.vm">
                                                <i class="ace-icon fa fa-files-o"></i>
                                                多表
                                            </a>
                                        </li>
										<li class="divider"></li>
                                        <li>
                                            <a data-self-href="${ctx}/demo/batchsql/index.vm"><i class="ace-icon fa fa-database align-left"></i>
                                                批量SQL</a>
                                        </li>
                                        <li class="divider"></li>
                                        <li>
                                            <a data-self-js="toMenu()"><i class="ace-icon fa fa-bars align-left"></i>
                                                菜单定位</a>
                                        </li>
                                    </ul>
                                </div>
                             </div>  
                            <table id="listTable" class="table table-bordered table-hover">
                                <thead>
                                <tr>
                                    <th class="center" style="width: 50px" >
                                        <label class="pos-rel">
                                            <input type="checkbox" class="ace" />
                                            <span class="lbl"></span>
                                        </label>
                                    </th>
                                    <th class="" data-sort-col="PRO_NAME"><i class="ace-icon fa fa-file-o"></i>
                                        项目名称
                                        <i class="ace-icon fa fa-sort pull-right"></i>
                                    </th>
                                    <th class="hidden-xs " style="width: 120px"  data-sort-col="DICT_NAME"><i class="ace-icon fa "></i>
                                        项目类型
                                        <i class="ace-icon fa fa-sort pull-right"></i>
                                    </th>
                                    <th class="hidden-xs "   data-sort-col="CONTRACT_NAME">
                                        合同名称
                                        <i class="ace-icon fa fa-sort pull-right"></i>
                                    </th>

                                    <th class="hidden-xs " style="width: 120px"  data-sort-col="SIGN_DATE">
                                    签署日期
                                        <i class="ace-icon fa fa-sort pull-right"></i>
                                    </th>
                                   
                                    <th class=" hidden-xs" style="width: 120px"  data-sort-col="MANAGER">
                                    项目经理
                                        <i class="ace-icon fa fa-sort pull-right"></i>
                                    </th>
                                    <th class=" align-right" style="width: 130px" data-sort-col="PRO_FEE"><i class="ace-icon fa fa-jpy pull-left"></i>
                                    项目经费(元)
                                        <i class="ace-icon fa fa-sort pull-right"></i>
                                      </th>
                                      <th class="align-center  hidden-xs" style="width: 120px" data-sort-col="PRO_STATUS">
                                    项目状态
                                        <i class="ace-icon fa fa-sort pull-right"></i>
                                    </th>
                                    <th class="align-center" style="width: 120px"><i class="ace-icon fa fa-wrench"></i>
                                        操作
                                    </th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="item" items="${pageInfo.list}">
                                <tr>
                                    <td class="center">
                                        <label class="pos-rel">
                                            <input type="checkbox" class="ace" value="${item.PRO_ID}"/>
                                            <span class="lbl"></span>
                                        </label>
                                    </td>
                                    <td style="width:250px;word-wrap:break-word;white-space:normal">
                                        ${item.PRO_NAME}
                                    </td>
                                     <td  class="hidden-xs ">
                                     	<span <c:if test="${item.CODE_KIND==3}">class="text-danger"</c:if>>${item.DICT_NAME}</span>
                                    </td>
                                    <td class="hidden-xs " style="width:250px;word-wrap:break-word;white-space:normal"> ${item.CONTRACT_NAME}</td>
                                    <td class="hidden-xs ">
                                    <fmt:formatDate value="${item.SIGN_DATE}" type="date" pattern="yyyy-MM-dd"/> 
                                    </td>
                                    <td class=" hidden-xs ">${item.MANAGER}</td>
                                    <td class="align-right">
                                    <fmt:formatNumber value="${item.PRO_FEE}" pattern="##.##" minFractionDigits="2" />
                                    </td>
                                    <td class="align-center hidden-xs">
                                        <c:if test="${item.PRO_STATUS==1}">
                                        <span class="label label-sm label-success arrowed-in-right min-width-75">
                                                <i class="ace-icon fa fa-info-circle"></i>
                                                在行 </span>
                                        </c:if>
                                        <c:if test="${item.PRO_STATUS==0}">
                                        <span class="label label-sm label-info arrowed-in-right min-width-75">
                                                <i class="ace-icon fa fa-check-circle"></i>
                                                竣工 </span>
                                        </c:if>
                                    </td>
                                    <td class="align-center col-op-ths">
                                        <button type="button" class="btn btn-sm  btn-white btn-op-ths" title="编辑"
                                                 data-self-js="doEdit('${item.PRO_ID}')">
                                            <i class="ace-icon fa fa-edit"></i>
                                        </button>
                                        <button type="button" class="btn btn-sm  btn-white btn-op-ths"  title="删除"
                                                data-self-js="doRead('${item.PRO_ID}')">
                                            <i class="ace-icon fa fa-eye"></i>
                                        </button>
                                    </td>
                                </tr>
								</c:forEach>
                                </tbody>
                            </table>
                              <%@ include file="/WEB-INF/jsp/_common/paging.jsp"%>
                              </div>
                        </form>
                    </div>
                </div>
            </div>
        </div><!--/.main-content-inner-->
    </div><!-- /.main-content -->
</div><!-- /.main-container -->

<iframe id="iframeInfo" name="iframeInfo" class="frmContent"
        src="" style="border: none; display: none" frameborder="0"
        width="100%"></iframe>
        
<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>

<!-- 自己写的JS，请放在这里 -->
<script type="text/javascript">
	//设置父页面元素的宽度 
	// $('.main-content-inner', parent.document).width('100%');
	//设置iframe自动高
	autoHeightIframe("iframeInfo");
	
	//搜索
	function doSearch(){
		if( typeof(arguments[0]) != "undefined" && arguments[0] == true)
			$("#pageNum").val(1);
		$("#orderBy").closest("form").submit();
	}
	//批量删除
	function doDelete(){
		var _ids="";
        $('#listTable > tbody > tr > td:first-child :checkbox:checked').each(function(){
        	_ids = _ids + $(this).val() + ",";
        });
        _ids = _ids=""?_ids:_ids.substr(0,_ids.length -1 );
        /**
         * 执行数据批量删除
         *  __ids 为英文逗号分隔的ID字符串,也可仅传递一个ID,执行单个删除
         *  serverUrl 服务器端AJAX POST 地址
         *  callBackFn 删除成功的回调函数,无参数,如function(){}
         */
		__doDelete(_ids,"profee_delete.vm",function(){
			//刷出之后，刷新列表
			doSearch();
		});
	}
    // 编辑或新增
    function  doEdit(id){
        _url="profee_edit.vm?id="+id;
        if ('${THS_JDP_RES_ID}') _url += "&THS_JDP_RES_ID=${THS_JDP_RES_ID}"
        $("#main-container").hide();
        $("#iframeInfo").attr("src",_url).show();
    }
	
	//查看(增、改、查页面如果都是采用调用方法的方式打开，可以采用下面的方式展示)
	function  doRead(id){
		_url="profee_read.vm?id="+id;
        if ('${THS_JDP_RES_ID}') _url += "&THS_JDP_RES_ID=${THS_JDP_RES_ID}"
		$("#main-container").hide();
        $("#iframeInfo").attr("src",_url).show();
	}
	//关闭dialog
	function closeDialog(id){
		dialog.get(id).close().remove();
	}
	//删除一条数据，可参考此函数
	function doDeleteOne(id){
		__doDelete(id,"profee_deleteOne.vm",function(){
			//刷出之后，刷新列表
			doSearch();
		});
	}
	
	jQuery(function($){
		//初始化表格的事件，如表头排序，列操作等
		__doInitTableEvent("listTable");

		  $("#btnDateStart").on(ace.click_event, function () { WdatePicker({el: "txtDateStart"});});
		  $("#btnDateEnd").on(ace.click_event, function () { WdatePicker({el: "txtDateEnd"});});
	});
	function toMenu(){
		window.top.location.href = "${ctx}/index.vm?tomenuid=0d895308-150e-4ad4-a26b-a6b94e00b0e8";
		//window.top.location.href = "${ctx}/index.vm?tomenuid=8c46cf73-3e6f-4535-b7a1-1f994d2c9dc7";
	}
</script>
</body>
</html>

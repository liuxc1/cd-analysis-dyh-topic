<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
	<head>
		<title>列表</title>
		<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
		<script type="text/javascript" src="${ ctx }/assets/js/eform/eform_custom.js"></script>
		<!--页面自定义的CSS，请放在这里 -->
		<style type="text/css">
		</style>
	</head>
	<body class="no-skin">
		<div class="main-container" id="main-container">
			<div class="main-content">
            <div id="breadcrumbs" class="breadcrumbs">
                <ul class="breadcrumb">
                    <li class="active">
                        <h5 class="page-title" >
                            <i class="fa fa-edit"></i>
                            复杂表单增删改查
                        </h5>
                    </li>
                </ul><!-- /.breadcrumb -->

            </div>
				<div class="main-content-inner padding-page-content">
					<div class="page-content">
						<div class="space-4"></div>
						<div class="row">
							<div class="col-xs-12">
								<form class="form-horizontal" role="form" id="formList"
									action="#" method="post">
									<div class="form-group">
										<label class="col-sm-1 control-label no-padding-right" for="txtName">
		                                   企业名称
		                                </label>
		                                <div class="col-sm-3">
		                                       <input type="text" class="form-control"  name="form['ENTER_NAME']"  value="${form.ENTER_NAME}" />
		                                </div>
		                                
		                                <label class="col-sm-1 control-label no-padding-right hidden-xs"
		                                       for="form-field-221">数据日期</label>
		                                <div class="col-sm-3 hidden-xs">
		                                    <select class="form-control"   name="form['TOTAL_YEAR']">
		                                        <option value="">-全部-</option>
		                                        <c:forEach items="${dictionary_map }" var="item">
		                                        	<option <c:if test="${form.TOTAL_YEAR==item.dictionary_code}">selected="selected"</c:if> value="${item.dictionary_code }">${item.dictionary_name }</option>
		                                    	</c:forEach>
		                                    </select>
		                                </div>
		                                <div class="col-sm-4  align-right">
										<div class="space-4 hidden-lg hidden-md hidden-sm"></div>
										<button type="button"
											class="btn btn-info pull-right"
											data-self-js="doSearch(true)">
											<i class="ace-icon fa fa-search"></i> 搜索
										</button>
									</div>
									</div>
									<hr class="no-margin">
									<div class="page-toolbar align-right list-toolbar">
										<button type="button" class="btn btn-xs    btn-xs-ths"
											id="btnAdd" data-self-js="doEdit();">
											<i class="ace-icon fa fa-plus"></i> 新建
										</button>
										<button type="button" class="btn btn-xs btn-xs-ths"
											data-self-js="doDelete()" id="btnDelete">
											<i class="ace-icon fa fa-remove"></i> 删除
										</button>
										<button type="button" class="btn btn-xs  btn-xs-ths" data-self-js="openWiki()" id="btnExport" >
		                                    <i class="ace-icon fa fa-file-excel-o"></i>
		                                    		打开wiki
		                                </button>
									</div>
									<table id="listTable" class="table table-bordered table-hover">
										<thead>
											<tr>
												<th class="center" style="width: 50px">
													<label class="pos-rel"> 
														<input type="checkbox" class="ace" />
														<span class="lbl"></span>
													</label>
												</th>
												<th  data-sort-col="TOTAL_YEAR">
													<i class="ace-icon fa "></i> <!--列标题图片-->
														数据日期
													<i class="ace-icon fa fa-sort pull-right"></i>
												</th>
												<th data-sort-col="ENTER_NAME">
														<i class="ace-icon fa"></i> <!--列标题图片-->
															企业名称
														<i class="ace-icon fa fa-sort pull-right"></i>
												</th>
												<th  data-sort-col="INDUSTRY_NAME">
														<i class="ace-icon fa "></i> <!--列标题图片-->
															所属行业名称
														<i class="ace-icon fa fa-sort pull-right"></i>
												</th>
												<th data-sort-col="INDUSTRY_CODE">
														<i class="ace-icon fa"></i> <!--列标题图片-->
															行业代码
														<i class="ace-icon fa fa-sort pull-right"></i>
												</th>
												<th class="align-center " style="width: 120px">
												<i class="ace-icon fa fa-wrench"></i> 操作</th>
											</tr>
										</thead>
										<tbody>
											<c:forEach var="item" items="${pageInfo.list }">
												<tr>
													<td class="center">
														<label class="pos-rel"> 
															<input type="checkbox" class="ace" value="${ item.ENTER_ID }" /> 
															<span class="lbl"></span>
														</label>
													</td>
													<td>
														${ item.TOTAL_YEAR}
													</td>
													<td>
														${ item.ENTER_NAME }
													</td>
													<td>
														${ item.INDUSTRY_NAME }
													</td>
													<td >
														${ item.INDUSTRY_CODE }
													</td>
													<td class=" align-center col-op-ths">
														<button type="button"
															class="btn btn-sm   btn-white btn-op-ths"
															title="编辑" data-self-js="doEdit('${ item.ENTER_ID }')">
															<i class="ace-icon fa fa-edit"></i>
														</button>
														<button type="button"
															class="btn btn-sm   btn-white btn-op-ths"
															title="查看" data-self-js="doRead('${ item.ENTER_ID }')">
															<i class="ace-icon fa fa-eye"></i>
														</button>
													</td>
												</tr>
											</c:forEach>
										</tbody>
									</table>
									<%@ include file="/WEB-INF/jsp/_common/paging.jsp"%>
								</form>
							</div>
						</div>
					</div>
				</div>
				<!--/.main-content-inner-->
			</div>
			<!-- /.main-content -->
		</div>
		<!-- /.main-container -->
	
		<iframe id="iframeInfo" name="iframeInfo" class="frmContent" src=""
			style="border: none; display: none" frameborder="0" width="100%"></iframe>
	
		<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
	
		<!-- 自己写的JS，请放在这里 -->
		<script type="text/javascript">
			//设置iframe自动高
			autoHeightIframe("iframeInfo");
			
			//搜索
			function doSearch(){
				if( typeof(arguments[0]) != "undefined" && arguments[0] == true)
					$("#pageNum").val(1);
				$("#orderBy").closest("form").submit();
			}
			
			//删除
   			function doDelete(){
   				var _ids="";
   				$('#listTable > tbody > tr > td:first-child :checkbox:checked').each(function(){
		        	_ids = _ids + $(this).val() + ",";
		        });
		        _ids = _ids == "" ? _ids : _ids.substr(0,_ids.length -1 );
		        if(_ids.length<=0){
		        	dialog({
		                title: '提示',
		                content: '请选择要删除的记录!',
		                wraperstyle:'alert-info',
		                width:300,
		                ok: function () {}
		            }).showModal();
		        }else{	
		        	dialog({
		                title: '删除',
		                wraperstyle:'alert-info',
		                content: '确实要删除选定记录吗?',
		                width:300,
		                ok: function () {
		                	$.ajax({
		                		url:'${ctx}/demo/eform/complexform/masterslave/masterslave_delete.vm?enterID='+_ids,
		                		dataType:'text',
		                		type:'post',
		                		success:function(response){
		                			if(response=="success"){
		                				dialog({
		            		                title: '提示',
		            		                content: '删除成功!',
		            		                wraperstyle:'alert-info',
		            		                width:300,
		            		                ok: function () {doSearch();}
		            		            }).showModal();
		                			}
		                		}
		                	})			
		                },
		                cancel:function(){}
		            }).showModal();
		        }
		        
   			}
   			//跳转到编辑
   			function doEdit(id){
   				var _url = "${ctx}/demo/eform/complexform/masterslave/masterslave_edit.vm";
   				if(id == null){
					id = generateUUID();
   				}
   				//$("#main-container").hide();
   				_url+="?table['DEMO_ENTERINFO'].key['ENTER_ID']="+id;
   				_url+="&multirowtable['DEMO_HSJS_RMSYQK'].key['ENTER_ID']="+id;
   				_url+="&multirowtable['DEMO_HSJS_LJGC'].key['ENTER_ID']="+id;
   				_url+="&multirowtable['DEMO_HSJS_LGGC'].key['ENTER_ID']="+id;
   				_url+="&multirowtable['DEMO_HSJS_RLSYSJBHXX'].key['ENTER_ID']="+id;
   				window.open(_url);
		        //$("#iframeInfo").attr("src",_url).show();
   			}
   			//查看
   			function doRead(id){
   				var _url = "${ctx}/demo/eform/complexform/masterslave/masterslave_read.vm";
   				_url += "?table[DEMO_ENTERINFO].key[ENTER_ID]=%s&multirowtable[DEMO_HSJS_RMSYQK].key[ENTER_ID]=%s&multirowtable[DEMO_HSJS_LJGC].key[ENTER_ID]=%s&multirowtable[DEMO_HSJS_LGGC].key[ENTER_ID]=%s&multirowtable[DEMO_HSJS_RLSYSJBHXX].key[ENTER_ID]=%s".replace(/%s/g, id);
   				//$("#main-container").hide();
		        //$("#iframeInfo").attr("src",_url).show();
   				window.open(_url);
   			}
   	
   			function openWiki(){
   				window.open("http://192.168.0.140:8080/wiki/en/Jdp4.0.release#a_.E5.AD.90.E8.A1.A8")
   			}
			jQuery(function($){
				//初始化表格的事件，如表头排序，列操作等
				__doInitTableEvent("listTable");
			});
		</script>
	</body>
</html>
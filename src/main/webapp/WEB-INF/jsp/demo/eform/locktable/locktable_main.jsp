<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
<head>
    <title>项目费用</title>
	<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
	<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
	<script type="text/javascript" src="${ctx}/assets/components/jquery-ui/jquery-ui.min.js"></script>
	<script type="text/javascript" src="${ctx}/assets/components/jquery-tablescroll/table-scroll.js"></script>
  	<!--页面自定义的CSS，请放在这里 -->
    <style type="text/css">
		th{
			border:1px solid #ddd!important;
			text-align:center;
		}
		td{
		}
    </style>
</head>
<body class="no-skin">

<div class="main-container" id="main-container">
    <div class="main-content">
        <div class="main-content-inner padding-page-content">
            <div class="page-content">
                <div class="space-4"></div>
                <div class="row">
                    <div class="col-xs-12">
                        <form class="form-horizontal" role="form" id="formList" action="list.vm" method="post">
							<h2>
							锁行锁列示例
							</h2>
                            <hr class="no-margin">
                            <div class="page-toolbar align-right list-toolbar">
                               <button type="button" class="btn btn-xs  btn-xs-ths" data-self-js="openWiki()" id="btnExport" >
                                    <i class="ace-icon fa fa-file-excel-o"></i>
                                    打开wiki
                                </button>
                            </div>
                            <table id="listTable" class="table table-bordered table-hover align-center table-layout-auto">
                                <thead>
                                <tr>
                                 	<th style="width:200px;">
                                       姓名
                                    </th>
                                    <th >
                                        1月
                                    </th>
                                     <th >
                                        2月
                                    </th>
                                     <th >
                                        3月
                                    </th>
                                     <th >
                                        4月
                                    </th>
                                     <th >
                                        5月
                                    </th>
                                     <th >
                                        6月
                                    </th>
                                     <th >
                                        7月
                                    </th>
                                     <th >
                                        8月
                                    </th>
                                     <th >
                                        9月
                                    </th> 
                                    <th >
                                        10月
                                    </th>
                                     <th >
                                        11月
                                    </th>
                                     <th >
                                        12月
                                    </th>
                                    <th style="width:150px;">
                                        平均销售额
                                    </th>
                                    <th style="width:150px;">
                                        销售总额
                                    </th>                                    
                                </tr>
                                </thead>
                                <tbody>
                                	<tr>
                                		<td>张一</td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                	</tr>
                                	<tr>
                                		<td>张二</td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                	</tr>
                                	<tr>
                                		<td>张三</td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                	</tr>
                                	<tr>
                                		<td>张四</td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                	</tr>
                                	<tr>
                                		<td>张五</td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                	</tr>
                                	<tr>
                                		<td>张六</td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                	</tr>
                                	<tr>
                                		<td>张七</td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                	</tr>
                                	<tr>
                                		<td>张八</td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                	</tr>
                                	<tr>
                                		<td>张九</td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                	</tr>
                                	<tr>
                                		<td>张十</td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                	</tr>
                                	<tr>
                                		<td>张十一</td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                	</tr>
                                	<tr>
                                		<td>张十二</td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                	</tr>
                                	<tr>
                                		<td>张十三</td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                	</tr>
                                	<tr>
                                		<td>张十四</td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                	</tr><tr>
                                		<td>张十五</td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                	</tr>
                                	<tr>
                                		<td>张十六</td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                	</tr>
                                	<tr>
                                		<td>张十七</td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                	</tr>
                                	<tr>
                                		<td>张十八</td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                	</tr>
                                	<tr>
                                		<td>张十九</td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                	</tr>
                                	<tr>
                                		<td>张二十</td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                	</tr>
                                </tbody>
                                <tfoot>
                                	<tr>
                                		<td>总计</td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                		<td></td>
                                	</tr>
                                </tfoot>
                            </table>
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
        

<!-- 自己写的JS，请放在这里 -->
<script type="text/javascript">
	//打开wiki说明
	function openWiki(){
		window.open("http://192.168.0.140:8080/wiki/en/Jdp4.0.release#a_.E9.94.81.E8.A1.8C.E9.94.81.E5.88.97")
	}
	//填充table数据
	$("tbody tr").each(function(){
		$(this).find("td:gt(0):even").text("100")
		$(this).find("td:gt(0):odd").text("200")
		$(this).find("td:eq(13)").text(($(this).find("td:gt(0):even").length*100+$(this).find("td:gt(0):odd").text("200").length*200)/12);
		$(this).find("td:eq(14)").text($(this).find("td:gt(0):even").length*100+$(this).find("td:gt(0):odd").text("200").length*200);
		$(this).find("td:first").css("background-color","#ebf3fe");
		$(this).find("td:eq(13)").css("background-color","#ebf3fe");
		$(this).find("td:eq(14)").css("background-color","#ebf3fe");
	})
	//设置首列背景色
	$("tfoot tr:first td").css("background-color","#ebf3fe");
	
	//设置表格索杭锁列参数
	$("#listTable").table_scroll({
		
	    fixedColumnsLeft: 1,
	    fixedColumnsRight:2,
	    columnsInScrollableArea: 6,
	    rowsInScrollableArea :10
	});
</script>
</body>
</html>
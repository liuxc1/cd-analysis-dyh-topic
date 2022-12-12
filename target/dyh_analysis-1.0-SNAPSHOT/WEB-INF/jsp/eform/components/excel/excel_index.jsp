<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
	<head>
		<title></title>
		<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
		<!--页面自定义的CSS，请放在这里 -->
		<style>
			.padding_1 {
				padding-left: 0px;
				padding-right: 0px;
				padding-top: 1px;
				padding-bottom: 1px;
			}
		</style>
		<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
	</head>
	<body class="no-skin">
				<div>
					<div class="page-toolbar align-right">
						<button type="button" class="btn btn-xs    btn-xs-ths" id="btnSave" onclick="showDownloadPage();">
							<i class="ace-icon fa fa-save"></i> 模板下载
						</button>
						<button type="button" class="btn btn-xs btn-xs-ths" id="btnSave" onclick="showUploadPage()">
							<i class="ace-icon fa fa-reply"></i> 数据导入
						</button>
					</div>
				</div>
		<div class="main-container" id="main-container">
			<div class="alert alert-block alert-warning col-sm-12">
	            <ul class="list-unstyled ">
	                <li class="blue">
	                    <i class="ace-icon fa fa-info-circle "></i>
	                    <span>功能描述</span>
	                </li>
		            <span class="text-warning">
		             	 本功能用于实现Excel的模版下载和Excel模版数据上传。
		             	<br/>
		             	模版下载：可以调用/eform/exceltemplate/download.vm?desigerid=模版ID（多个逗号分隔）
		             	<br/>
		             	数据上传：可以调用/eform/exceltemplate/goupload.vm?desigerid=模版ID（多个逗号分隔）
		             	<br/>
		            </span>
	            </ul>
         	</div>
         	
         	<div class="alert alert-block alert-warning col-sm-12">
	            <ul class="list-unstyled ">
	                <li class="blue">
	                    <i class="ace-icon fa fa-info-circle "></i>
	                    <span>集成步骤</span>
	                </li>
		            <span class="text-warning">
		             	 ①、复制/jsp/eform/components/excel文件夹到对应目录。<br/>
		             	 ②、MAVEN依赖lib-eform.jar。<br/>
		             	 <textarea rows="5" cols="5" style="width: 500px">
<dependency>						
<groupId>ths.jdp</groupId>
<artifactId>lib-eform</artifactId>
</dependency>
		             	 </textarea><br/>
		             	  ③、创建表【JDP_EFORM_EXCELSHEETS】，定义excel表名称、与数据表对应关系等。<br/>
		             	 <textarea rows="5" cols="5" style="width: 500px">
-- Create table
create table JDP_EFORM_EXCELSHEETS
(
  DESIGERID       VARCHAR2(50) not null,
  DESIGERNAME     VARCHAR2(100),
  EXCELNAME       VARCHAR2(100),
  SHEETNAME       VARCHAR2(100),
  STARTROW        NUMBER,
  TABLEDATASOURCE VARCHAR2(100),
  BEFORERUNSQL     VARCHAR2(4000),
  TABLENAME       VARCHAR2(100),
  AFTERRUNSQL     VARCHAR2(4000)
);
-- Add comments to the columns 
comment on column JDP_EFORM_EXCELSHEETS.DESIGERID
  is '唯一键';
comment on column JDP_EFORM_EXCELSHEETS.DESIGERNAME
  is '导入描述';
comment on column JDP_EFORM_EXCELSHEETS.EXCELNAME
  is 'EXCEL的名称';
comment on column JDP_EFORM_EXCELSHEETS.SHEETNAME
  is 'EXCEL中SHEET标签的名称';
comment on column JDP_EFORM_EXCELSHEETS.STARTROW
  is '数据开始行';
comment on column JDP_EFORM_EXCELSHEETS.TABLEDATASOURCE
  is '导入数据表对应的数据源';
comment on column JDP_EFORM_EXCELSHEETS.AFTERRUNSQL
  is '导入前执行的SQL语句';
comment on column JDP_EFORM_EXCELSHEETS.TABLENAME
  is '数据表CODE';
comment on column JDP_EFORM_EXCELSHEETS.AFTERRUNSQL
  is '导入后执行的SQL语句';

		             	 </textarea><br/>
		             	  ④、创建表【JDP_EFORM_EXCELFIELDS】，定义excel每列与数据表字段的对应关系、导入验证等。<br/>
		             	 <textarea rows="5" cols="5" style="width: 500px">
-- Create table
create table JDP_EFORM_EXCELFIELDS
(
  SHEETCOLPKID      VARCHAR2(50) not null,
  SHEETCOLNUM       NUMBER,
  SHEETCOLDESCR     VARCHAR2(500),
  FIELDCODE         VARCHAR2(50),
  FIELDDEFAULTVALUE VARCHAR2(500),
  CHECKMETHOD       VARCHAR2(500),
  CHECKMETHODDESCR  VARCHAR2(4000),
  DESIGERID         VARCHAR2(500),
  FIELDTYPE         VARCHAR2(50),
  INTRANSFORM       VARCHAR2(50),
  OUTTRANSFORM      VARCHAR2(50)
);
-- Add comments to the columns 
comment on column JDP_EFORM_EXCELFIELDS.SHEETCOLPKID
  is '唯一键';
comment on column JDP_EFORM_EXCELFIELDS.SHEETCOLNUM
  is '对应EXCEL列号（A对应0）';
comment on column JDP_EFORM_EXCELFIELDS.SHEETCOLDESCR
  is '对应EXCEL列描述';
comment on column JDP_EFORM_EXCELFIELDS.FIELDCODE
  is '对应字段编码';
comment on column JDP_EFORM_EXCELFIELDS.FIELDDEFAULTVALUE
  is '字段默认值';
comment on column JDP_EFORM_EXCELFIELDS.CHECKMETHOD
  is '数据校验方式，支持正则和自定义';
comment on column JDP_EFORM_EXCELFIELDS.CHECKMETHODDESCR
  is '数据校验中文描述';
comment on column JDP_EFORM_EXCELFIELDS.DESIGERID
  is '对应表JDP_EFORM_EXCELSHEETS的唯一ID';
comment on column JDP_EFORM_EXCELFIELDS.FIELDTYPE
  is '对应字段格式';
comment on column JDP_EFORM_EXCELFIELDS.INTRANSFORM
  is '入库转换,字典项目';
comment on column JDP_EFORM_EXCELFIELDS.OUTTRANSFORM
  is '模版转换';
		             	 </textarea><br/>
⑤、Excel模版路径：/WEB-INF/conf/eform/excel/。<br/>
		            </span>
	            </ul>
         	</div>
		</div>
		<!-- /.main-container -->
	
		<script type="text/javascript" src="${ ctx }/assets/js/eform/eform_custom.js?v=20221129015223"></script>
		<!-- 自己写的JS，请放在这里 -->
		<script type="text/javascript">
		function showDownloadPage()
		{
			dialog({
				id:"dialog-import",
	            title: '导出Excel模板',
	            url: '${ctx}/eform/exceltemplate/godownload.vm',
	            width:400,
	            height:200,
	           	cancel:function()
	           	{
	           	},
	           	cancelDisplay: false
	        }).showModal();
		}
		function showUploadPage()
		{
			dialog({
				id:"dialog-import",
	            title: '导入Excel数据',
	            url: '${ctx}/eform/exceltemplate/goupload.vm?desigerid=1',
	            width:400,
	            height:200,
	           	cancel:function()
	           	{
	           	},
	           	cancelDisplay: false
	        }).showModal();
		}
		//关闭dialog
		function closeDialog(id){
			dialog.get(id).close().remove();
		}
		
		</script>
	</body>
</html>
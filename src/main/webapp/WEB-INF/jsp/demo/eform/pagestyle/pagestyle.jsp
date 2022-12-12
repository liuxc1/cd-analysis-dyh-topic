<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>WebUploader上传示例</title>
		<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
		<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
		<style type="text/css">
			.content{
				padding:20px;
			}
			.buttonTitle{
				    font-weight: 900;
				    font-size: 15px;
				    color: gray;
			}
			.buttonContent{
				margin:30px auto;
			}
			.buttonContent label{
				margin:10px 10px;
				width:80px;
			}
			.buttonContent button{
				margin:10px 5px;
			}
			.buttonContent span{
				display:inline-block;
				width:300px;
			}
		</style>
	</head>
	<body class="no-skin">
		<div class="main-content-inner fixed-page-header fixed-82">
			<div class="content">
				 <div id="buttonTemplate" class="buttonTitle">
				 	<span>按钮示例</span>
				 </div>
				 <div class="buttonContent">
				 	<div style="height:50px;">
				 		 <span>
				 		 	<label>编辑：</label>
			                <button type="button" class="btn btn-sm  btn-white btn-op-ths" title="编辑">
			                    <i class="ace-icon fa fa-edit"></i>
			                </button>
				 		 </span>
			             <span>
			             	<label class="control-label no-padding-right">删除(单条)：</label>
			                 <button type="button" class="btn btn-sm btn-op-ths"  title="删除">
			                    <i class="ace-icon fa fa-trash-o"></i>
			                </button>
			              </span>
			              <span>
			              	<label class="control-label no-padding-right">查看：</label>
			                 <button type="button" class="btn btn-sm btn-op-ths"  title="查看">
			                     <i class="ace-icon fa fa-eye"></i>
			                 </button>
			              </span>
	             </div>
	             <hr>
	             <div class="" style="height:50px;">
	             	<span>
	             	 	<label class="control-label no-padding-right">添加：</label>
		                 <button type="button" class="btn btn-xs btn-xs-ths">
		                     <i class="ace-icon fa fa-plus"></i>
		                     添加
		                 </button>
		             </span>
		             <span>
		             	<label class="control-label no-padding-right">删除(批量)：</label>
		                 <button type="button" class="btn btn-xs btn-xs-ths">
			                    <i class="ace-icon fa fa-trash-o"></i>
			             删除
			              </button>
		             </span>
		             <span>
		             	<label class="control-label no-padding-right">保存：</label>
		                 <button type="button" class="btn btn-xs btn-xs-ths">
		                  <i class="ace-icon fa fa-save"></i>
		                  保存
		              	</button>
		             </span>
	             </div>
	             <div class="" style="height:50px;">
	             	<span>
	             		<label class="control-label no-padding-right">提交：</label>
		                 <button type="button" class="btn btn-xs btn-xs-ths">
		                  <i class="ace-icon fa  fa-hand-o-up"></i>
		                  提交
		              </button>
	             	</span>
	             	 <span>
	             	 	<label class="control-label no-padding-right">返回：</label>
		                  <button type="button" class="btn btn-xs btn-xs-ths">
		                  <i class="ace-icon fa fa-reply"></i>
		                  返回
		              </button>
	             	 </span>
	             	 <span class="form-group">
	             	 	<label class="control-label no-padding-right">搜索：</label>
		                <button type="button" class="btn btn-info">
                             <i class="ace-icon fa fa-search"></i>
                             搜索
                        </button>
	             	 </span>
	             </div>
	             <div class="" style="height:50px;">
	             	<span>
	             		<label class="control-label no-padding-right">刷新：</label>
		                 <button type="button" class="btn btn-xs btn-xs-ths">
		                  <i class="ace-icon fa  fa-refresh"></i>
		                 刷新
		              </button>
					</span>
					<span class="form-group">
	             		<label class="control-label no-padding-right">保存：</label>
		                 <button type="button" class="btn btn-save">
		                 <i class="ace-icon fa fa-save"></i>
		                 保存
		              </button>
					</span>
					<span class="form-group">
	             		<label class="control-label no-padding-right">取消：</label>
		                 <button type="button" class="btn btn-cancel">
		                 <i class="ace-icon fa fa-remove"></i>
		                 取消
		              </button>
					</span>
	             </div>
	             <div class="" style="height:50px;">
	             	<span class="form-group">
	             		<label class="control-label no-padding-right">删除：</label>
		                 <button type="button" class="btn btn-delete">
		                 <i class="ace-icon fa fa-trash-o"></i>
		                 删除
		              </button>
					</span>
	             </div>
	             <hr>
	             <div class="" style="height:50px;">
	             	<span>
	             		<label class="control-label no-padding-right">导出word：</label>
		                 <button type="button" class="btn btn-xs btn-xs-ths">
		                  <i class="ace-icon fa fa-file-word-o"></i>
		                  导出word
		              </button>
	             	</span>
	             	<span>
	             		<label class="control-label no-padding-right">导出excel：</label>
		                 <button type="button" class="btn btn-xs btn-xs-ths">
			                  <i class="ace-icon fa fa-file-excel-o"></i>
			                  导出excel
			              </button>
	             	</span>	
		             <span>
		             	<label class="control-label no-padding-right">导出pdf：</label>
		                 <button type="button" class="btn btn-xs btn-xs-ths">
			                  <i class="ace-icon fa fa-file-pdf-o"></i>
			                  导出pdf
			              </button>
		             </span>
	             </div>
	              <div class="" style="height:50px;">
	             	<span>
		             	<label class="control-label no-padding-right">导入：</label>
		                 <button type="button" class="btn btn-xs btn-xs-ths">
		                  <i class="ace-icon fa  fa-files-o"></i>
		                  导入
		              	</button>
		             </span>
		             <span>
		             	<label class="control-label no-padding-right">导入：</label>
		                 <button type="button" class="btn btn-xs btn-xs-ths">
		                  <i class="ace-icon fa  fa-download"></i>
		                  下载
		              	</button>
		             </span>
	             </div>
	             <hr>
	             <div class="" style="height:50px;">
	             	<span>
		             	<label class="control-label no-padding-right">授权：</label>
		                 <button type="button" class="btn btn-xs btn-xs-ths">
		                  <i class="ace-icon fa fa-key"></i>
		                  授权
		              	</button>
		             </span>
	             	<span>
	             		<label class="control-label no-padding-right">审核：</label>
		                 <button type="button" class="btn btn-xs btn-xs-ths">
			                  <i class="ace-icon fa fa-check"></i>
			                 审核
			              </button>
	             	</span>	
		             <span>
		             	<label class="control-label no-padding-right">退回：</label>
		                 <button type="button" class="btn btn-xs btn-xs-ths">
		                  <i class="ace-icon fa fa-arrow-left"></i>
		                退回
		              	</button>
		             </span>
	             </div>
			 </div>
			 </div>
		</div>
		<script>
		</script>
	</body>
</html>
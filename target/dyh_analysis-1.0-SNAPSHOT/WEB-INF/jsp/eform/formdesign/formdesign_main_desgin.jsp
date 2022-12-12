<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
	<head>
		<title></title>
		<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
		<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
		<!--页面自定义的CSS，请放在这里 -->
		<style type="text/css">
			.desgin_center {width:71%;float:left;overflow:hidden}
			.desgin_right {padding-top: 5px;margin-left: 5px;width:28%;float:left;background: #FFFFFF;min-width:300px}
		</style>
		<script type="text/javascript">
			function selectProperties(selectType,row_id,cell_id){
				$("#desgin_right_iframe").attr("src","${ctx}/eform/formdesign/formdesign_main_desgin_properties.vm?form_id=${form_id}&selectType="+selectType+"&row_id="+row_id+"&cell_id="+cell_id);
			}
			
			function selectTableProperties(selectType, td_id){
				$("#desgin_right_iframe").attr("src","${ctx}/eform/formdesign/formdesign_main_desgin_properties.vm?form_id=${form_id}&selectType=" + selectType + "&td_id=" + td_id);
			}
			
			function doSaveRow(row_id){
			    ths.submitFormAjax({
			        url:"${ctx}/eform/formdesign/formdesign_main_desgin_saverow.vm?form_id=${form_id}&row_id=" + row_id,// any URL you want to submit
			        async:false,
			    	success:function (response) {
			    		refreshFormHtml();
					}
			    });
			}
			function doDeleteRow(row_id){
				ths.submitFormAjax({
				    url:"${ctx}/eform/formdesign/formdesign_main_desgin_deleterow.vm?row_id="+row_id,// any URL you want to submit
				    async:false,
					success:function (response) {
						refreshFormHtml();
						selectProperties("","","");
					}
				});
			}
			function doMoveRow(row_id, step){
				ths.submitFormAjax({
					url : "${ctx}/eform/formdesign/formdesign_main_desgin_moverow.vm?row_id=" + row_id + "&step=" + step,
					async:false,
					success : function(response) {
						refreshFormHtml();
						$("#desgin_center_iframe")[0].contentWindow.selectFormRow(row_id, '');
					}
				});
			}
			/**
			 * 移动控件
			 * cellId 移动的控件id
			 * startAfterCellId 移动开始时，后面控件id
			 * endRowId 移动结束时，控件所属行id
			 * endAfterCellId 移动结束时，后面控件id
			 */
			function doMoveCell(cellId, startAfterCellId, endRowId, endAfterCellId){
		        ths.submitFormAjax({
		            url:"${ctx}/eform/formdesign/formdesign_main_desgin_movecell.vm",
		            data: {cellId: cellId, startAfterCellId: startAfterCellId, endRowId: endRowId, endAfterCellId: endAfterCellId},
		            async: false,
		        	success: function(response){
		        		refreshFormHtml();
						$("#desgin_center_iframe")[0].contentWindow.selectFormCell(endRowId, cellId);
					}
		        });
		    }
			
			//刷新表单页面内容
			function refreshFormHtml(){
				$("#desgin_center_iframe")[0].contentWindow.initFormHtml('${form_id}', '${formParam}');
				$("#desgin_center_iframe")[0].contentWindow.jdp_eform_initEditSelect();
			}
			
			//导入excel模板
			function jdp_eform_importExcelToForm(){
				dialog({
					id:"dialog-import",
			        title: "选择excel模板",
			        url: "${ctx}/eform/formdesign/formdesign_main_importexceltoform.vm?formId=${form_id}",
			        width:380,
			        height:180
			    }).showModal();
			}
			
			function closeDialog(id){
				dialog.get(id).close().remove();
			}
			
			function hideProperties(){
				if(!$("#desgin_right").is(":hidden")){
					$("#desgin_center").width("100%");
					$("#desgin_right").hide();
				}else{
					$("#desgin_center").width("71%");
					$("#desgin_right").show();
				}
			}
			
			/*字典维护dialog*/
			function openDictionaryEditDialog(){
				dialog({
					id:"dialog-dictionary-edit",
			        title: "字典维护",
			        url: "${ctx}/eform/dic/index.vm",
			        width: $(document).width(),
			        height: $(document).height(),
			        onclose: function () {
			    		$("#desgin_right_iframe")[0].contentWindow.openDistionary();
			    	}
			    }).showModal();
			}
		</script>
	</head>

	<body class="no-skin"  style="overflow-x: hidden; overflow-y:hidden">
		<div class="main-container" id="main-container" >
		    <div id="pancontent" style="width:99%;float:left"  >
				<div id="desgin_center" class="desgin_center">
					<iframe id="desgin_center_iframe" name="main" frameBorder="0"
			                    style="width:100%;border: none;overflow-x: hidden; overflow-y:hidden"
			                    scrolling="auto" src="${ctx}/eform/formdesign/formdesign_main_desgin_formhtml.vm?form_id=${form_id}&isdesign=true${formParam}"></iframe>
				</div>
				<div id="desgin_right" class="desgin_right" style="overflow-x: hidden; overflow-y:hidden">
						<iframe id="desgin_right_iframe" frameBorder="0"
			                    style="width:100%;border: none;overflow-x: hidden; overflow-y:hidden"
			                    scrolling="auto" src="${ctx}/eform/formdesign/formdesign_main_desgin_properties.vm?form_id=${form_id}&selectType=${form.DESIGN_MODEL == 'TABLE' ? 'table' : '' }"></iframe>
				</div>
			</div>
			<div style="position: absolute; right: 2px;">
				<a href="#" onclick="hideProperties();">
					<i class="fa fa-arrows-alt" aria-hidden="true"></i>
				</a>
			</div>
		</div><!-- /.main-container -->
	
		<script type="text/javascript">
			var h = $(window).height();
			$("#desgin_center_iframe").height(h-10);
			$("#desgin_right_iframe").height(h-10);
			
		</script>
	</body>
</html>

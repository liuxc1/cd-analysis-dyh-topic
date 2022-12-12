<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<div>
	<div class="page-toolbar align-right" id="listhtml_edit_btn_toolbar">
		<button type="button" class="btn btn-xs btn-primary btn-xs-ths" id="btnSave" data-self-js="saveFormInfo(1);">
			<i class="ace-icon fa fa-save"></i> 保存
		</button>
		<button type="button" class="btn btn-xs btn-danger btn-xs-ths" id="btnBack" onclick="goBack()">
			<i class="ace-icon fa fa-reply"></i> 返回
		</button>
	</div>
</div>
<script>
	//返回
	function goBack() {
		parent.doSearch();
	}
	
	function saveFormInfo(type){
		var eformFormWindow = document.getElementById("eformForm").contentWindow;
		if(eformFormWindow.jdp_eform_getValidate()){
			//保存自定义信息
			var paramStr = "formId=${formId}&id=" + eformFormWindow.getBusinessKey();
			var keyCount = {};
			var hasProcedureInfo = false;
			$(eformFormWindow.document).find("table.procedureTable").each(function(){
				hasProcedureInfo = true;
				var procedure = $(this).attr("procedure");
				var key = $(this).attr("key");
				$(this).find("> tbody > tr:not(:hidden)").each(function(){
					var index = 0;
					if(keyCount[key] != null){
						index = keyCount[key] + 1;
					}
					keyCount[key] = index;
					$(this).find("> td > input,select,textarea").each(function(){
						//获取字段id
						var fieldId = $(this).attr("fieldId");
						if(fieldId){
							//设置主键值
							if($(this).hasClass("primary")){
								$(this).val(generateUUID());
							}else if($(this).hasClass("foreign")){ //设置外键值
								//查找此表所在行的主键值
								$(this).val($(this).closest("table.procedureTable").closest("tr").find("> td > .primary").val());
							}else if($(this).hasClass("order")){ //设置排序值
								$(this).val(index);
							}
							//拼接参数
							paramStr += "&procedure['" + procedure + "'].table['" + key + "'].list[" + index + "]['" + fieldId + "']=" + $(this).val();
						}
					});
				});
			});
			var saveResponse = "success";
			if(hasProcedureInfo){
				$.ajax({
					url : '${ctx}/eform/custom/procedure/save.vm',// any URL you want to submit
		            type: "post",
		            async: false,
					data: encodeURI(paramStr),
					success:function (response) {
						saveResponse = response;
					}
				});
			}
			if(saveResponse != "success"){
				dialog({
                    title: '提示',
                    content: '保存loadUrl信息失败，请检查！',
                    wraperstyle:'alert-info',
                    ok: function () {
                    }
                }).showModal();
				return;
			}
			eformFormWindow.jdp_eform_uploadFile(function(uploadResponse){
				//设置子表排序
				$(eformFormWindow.document).find(".padding_1 table:not(.procedureTable)").each(function(){
					$(this).find(" > tbody > tr:visible").each(function(i){
						$(this).find("input.order").val(i);
					});
				});
				ths.submitFormAjax({
					url : '${ctx}/eform/formdesign/formdesign_main_desgin_listhtml_save.vm',// any URL you want to submit
		            type: "post",
		            async: false,
					data: $(eformFormWindow.document).find("#formInfo").serialize(),
					success:function (response) {
						if(response.indexOf("success") > -1){
							eformFormWindow.jdp_eform_updateFileBusinessKey(uploadResponse, eformFormWindow.getBusinessKey(), function(){
								dialog({
	                                title: '提示',
	                                content: '保存成功',
	                                wraperstyle:'alert-info',
	                                ok: function () {
	                                	if(type == 1 && parent && parent.doSearch){
	                                		parent.doSearch();
	                                	}
	                                }
	                            }).showModal();
							});
						}else{
                			dialog({
                                title: '提示',
                                content: '保存失败，原因：' + response,
                                wraperstyle:'alert-info',
                                ok: function () {}
                            }).showModal();
                		}
					}
				});
			});
		}
	}
</script>
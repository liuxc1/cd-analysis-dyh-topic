<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<div class="page-toolbar align-right list-toolbar" id="listhtml_bpm_btn_toobar">
	<c:if test="${empty form.HANDLE_STATE or form.HANDLE_STATE=='V_JDP_BPM_TODO_TASKS'}">
		<button type="button" class="btn btn-xs btn-primary btn-xs-ths"
				id="btnAdd" data-self-js="doEdit();">
			<i class="ace-icon fa fa-plus"></i> 起草流程
		</button>
		<!-- <button type="button" class="btn btn-xs btn-danger btn-xs-ths"
				data-self-js="doDelete()" id="btnDelete">
			<i class="ace-icon fa fa-remove"></i> 作废
		</button> -->
	</c:if>
	<c:if test="${not empty showDesign and showDesign=='true'}">
		<button type="button"
				class="btn btn-xs btn-inverse btn-xs-ths"
				data-self-js="showDesignPage()">
			<i class="ace-icon fa fa-wpforms"></i> 设计
		</button>
	</c:if>
</div>
${jdpEformForm.formListProperty }
<script>
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
	            		url:'${ctx}/eform/formdesign/formdesign_main_desgin_listhtml_delete.vm',
	            		data:{'id':_ids,'table_name':'${mainTableCode}','pk_name':'${mainPkColumn}','dataSource':'${dataSource}'},
	            		type:'post',
	            		dataType:'text',
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
	var _handleState='${form.HANDLE_STATE}';
	//跳转到编辑
	function doEdit(id, taskId){
		$.ajax({
			url:"${ctx}/eform/formdesign/checkContainPrimaryField.vm?formId=${formId}",
			dataType:"text",
			cache:false,
			success:function(response){
				if(response=="success"){
					var _url = "${ctx}/eform/formdesign/formdesign_main_desgin_listhtml_edit.vm?formId=${formId}&mainTableCode=${mainTableCode}&processDefKey=${processDefKey}";
					if(id){
						_url += "&businessKey=" + encodeURI(encodeURI(id)) + "&taskId=" + taskId;
					}
					_url += "&form['dataSource']=${dataSource}";
					if(_handleState=='V_JDP_BPM_DONE_TASKS'){
						_url+='&form[handleState]='+_handleState;
					}
					$("#main-container").hide();
					<c:forEach items="${form}" var="form" > 
						_url = _url + "&&form['${form.key}']=${form.value}";
					</c:forEach>
			    	$("#iframeInfo").attr("src", ths.urlEncode4Get(_url)).show();
				}else{
					dialog({
		                title: '提示',
		                content: response,
		                wraperstyle:'alert-info',
		                width:300,
		                ok: function () {}
		            }).showModal();
				}
			}
		})
		
	}
	//弹出字段设计页面
	function showDesignPage(){
		dialog({
			id:"dialog-eform-list-design",
	        title: '列属性设计',
	        url: '${ctx}/eform/formdesign/formListCustom.vm?formId=${formId}',
	        width:1000,
	        height:500>document.documentElement.clientHeight?document.documentElement.clientHeight:500,
	       	cancel:function()
	       	{
	       		doSearch();
	       	},
	       	cancelDisplay: false
	    }).showModal();
	}
	//检查表单是否包含主键域
	function checkPrimaryKey(){
		
	}
</script>
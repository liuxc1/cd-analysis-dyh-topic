//被选中的控件ID
var jdp_eform_selectFormCell_Id;
//清空值方法
function jdp_eform_clearValue(obj){
	$(obj).closest("div.input-group").find("input").each(function(){
		$(this).val("");
	});
}
//添加行
function jdp_eform_addTableRow(obj){
	var baseRowTr = $(obj).closest("table").find("tbody > .baseRowTr").clone();
	if($(baseRowTr).find("input.primary").length == 0){
		dialog({
            title: '提示',
            content: '不存在主键控件，请设置！',
            wraperstyle: 'alert-info',
            ok: function() {
            }
        }).showModal();
		return;
	}else if($(baseRowTr).find("input.primary").length > 1){
		dialog({
            title: '提示',
            content: '存在多个主键控件，请设置！',
            wraperstyle: 'alert-info',
            ok: function() {
            }
        }).showModal();
		return;
	}
	$(baseRowTr).css("display", "");
	$(baseRowTr).removeClass("baseRowTr");
	//设置索引
	var index = 0;
	if($(baseRowTr).attr("index")){
		index = parseInt($(baseRowTr).attr("index")) + 1;
	}
	$(baseRowTr).attr("index", index);
	$(baseRowTr).find("input,select,textarea").removeAttr("disabled");
	$(baseRowTr).find("input,select,textarea,div.file,div.multifile").each(function(){
		var id = $(this).attr("id");
		if(id && id.indexOf("_index") > 0){
			$(this).attr("id", id.replace("_index", "_" + index));
		}
		var onclick = $(this).attr("onclick");
		if(onclick && onclick.indexOf("_index") > 0){
			$(this).attr("onclick", onclick.replace("_index", "_" + index));
		}
	});
	$(obj).closest("table").find("> tbody").append(baseRowTr);
	//设置基础行索引
	$(obj).closest("table").find("> tbody > .baseRowTr").attr("index", index);
	//添加附件解析
	jdp_eform_addFileWebUploader(baseRowTr);
	return baseRowTr;
}
//删除行
function jdp_eform_deleteTableRow(obj){
	$(obj).closest("tr").remove();
	//记录需要删除的附件id
	$(obj).closest("tr").find("div.file,div.multifile").each(function(i){
		//判断id属性
		if($(this).attr("id") != null && $(this).attr("id") != ""){
			var thsUploader = ThsUploderUtil.ThsUploaderArray[$(this).attr("id")];
			if(thsUploader){
				var files = thsUploader.getUploader().getFiles();
				for(var i = 0; i < files.length; i++){
					if(files[i].getStatus() == "complete"){
						ThsUploderUtil.deleteFileIds += (ThsUploderUtil.deleteFileIds == "" ? "" : ",") + files[i].source.fileId;
					}
				}
			}
		}
	});
}
//上移行
function jdp_eform_upTableRow(obj){
	var $tr = $(obj).closest("tr");
	if ($tr.index() > 1) {
		$tr.prev().before($tr);
	}
}
//下移行
function jdp_eform_downTableRow(obj, tableId){
	var $tr = $(obj).closest("tr"); 
	if ($tr.index() != $(obj).closest("table").find("tbody > tr").legnth - 1) { 
		$tr.next().after($tr);
	}
}
/*-------------------列表dialog方法处理------------start----------------*/
function jdp_eform_openList(obj, selectType, dialogName, dictionary_code, formcell_openwidth, formcell_openheight){
	//设置默认宽度和高度
	if(formcell_openwidth == null || formcell_openwidth == ''){
		formcell_openwidth = 600;
	}
	if(formcell_openheight == null || formcell_openheight == ''){
		formcell_openheight = 430;
	}
	//设置点击的控件id
	jdp_eform_selectFormCell_Id = $(obj).attr("id");
	//获取表单参数
	var _eformVariable = $("_eformVariable").val();
	dialog({
		id: "dialog-jdp-eform-list",
        title: dialogName + "",
        url: ctx + "/eform/components/table/table_choose.vm?hiddenId=" + $(obj).closest("div").find("input[type='hidden']:first").attr("id") + "&textId=" + jdp_eform_selectFormCell_Id + "&selectType=" + selectType + "&dictionary_code=" + dictionary_code + "&callback=jdp_eform_openList_callback&closeCallback=jdp_eform_openList_close&" + _eformVariable,
        width: formcell_openwidth > document.documentElement.clientWidth ? document.documentElement.clientWidth : formcell_openwidth,
        height: formcell_openheight > document.documentElement.clientHeight ? document.documentElement.clientHeight : formcell_openheight
    }).showModal();
}
function jdp_eform_openList_callback(result){
	var setIdValue = "";
	var setNameValue = "";
	if(result && result.length){
		for(var i = 0; i < result.length; i++){
			if("" == setIdValue){
				setIdValue = result[i].CODE;
				setNameValue = result[i].NAME;
			}else{
				setIdValue = setIdValue + "," + result[i].CODE;
				setNameValue = setNameValue + "," + result[i].NAME;
			}
		}
	}else if(result){
		var setIdValue = result.CODE;
		var setNameValue = result.NAME;
	}
	var oldValue = $("#" + jdp_eform_selectFormCell_Id).val();
	$("#" + jdp_eform_selectFormCell_Id).val(setNameValue);
	$("#" + jdp_eform_selectFormCell_Id).closest("div").find("input[type='hidden']:first").val(setIdValue);
	if(oldValue != setIdValue){
		$("#" + jdp_eform_selectFormCell_Id).change();
		$("#" + jdp_eform_selectFormCell_Id).closest("div").find("input[type='hidden']:first").change();
	}
}
function jdp_eform_openList_close(){
	dialog.get("dialog-jdp-eform-list").close().remove();
}
/*-------------------列表dialog方法处理------------end----------------*/

/*-------------------tree dialog方法处理------------start----------------*/
function jdp_eform_openTree(obj, selectType, dialogName, sqlpackage, mapperid, formcell_openwidth, formcell_openheight, formcell_dictionary, form_id){
	//设置默认宽度和高度
	if(formcell_openwidth == null || formcell_openwidth == ''){
		formcell_openwidth = 380;
	}
	if(formcell_openheight == null || formcell_openheight == ''){
		formcell_openheight = 480;
	}
	//设置点击的控件id
	jdp_eform_selectFormCell_Id = $(obj).attr("id");
	//获取表单参数
	var _eformVariable = $("_eformVariable").val();
	dialog({
		id: "dialog-jdp-eform-tree",
        title: dialogName + "",
        url: ctx + "/eform/tree/window.vm?showRadio=1&hiddenId=" + $(obj).closest("div").find("input[type='hidden']:first").attr("id") + "&treetype=" + selectType + "&sqlpackage=" + sqlpackage + "&mapperid=" + mapperid + "&callback=jdp_eform_treeCallBack&closeCallback=jdp_eform_openTree_close&FORM_ID=" + form_id + "&formcell_dictionary=" + formcell_dictionary + "&" + _eformVariable,
        width: formcell_openwidth > document.documentElement.clientWidth ? document.documentElement.clientWidth : formcell_openwidth,
        height: formcell_openheight > document.documentElement.clientHeight ? document.documentElement.clientHeight : formcell_openheight
    }).showModal();
}
function jdp_eform_treeCallBack(result){
	var setIdValue = "";
	var setNameValue = "";
	if(result && result.length){
		for(var i = 0; i < result.length; i++){
			if("" == setIdValue){
				setIdValue = result[i].TREE_ID;
				setNameValue = result[i].TREE_NAME;
			}else{
				setIdValue = setIdValue + "," + result[i].TREE_ID;
				setNameValue = setNameValue + "," + result[i].TREE_NAME;
			}
		}
	}else if(result){
		var setIdValue = result.TREE_ID;
		var setNameValue = result.TREE_NAME;
	}
	var oldValue = $("#" + jdp_eform_selectFormCell_Id).val();
	$("#" + jdp_eform_selectFormCell_Id).val(setNameValue);
	$("#" + jdp_eform_selectFormCell_Id).closest("div").find("input[type='hidden']:first").val(setIdValue);
	if(oldValue != setIdValue){
		$("#" + jdp_eform_selectFormCell_Id).change();
		$("#" + jdp_eform_selectFormCell_Id).closest("div").find("input[type='hidden']:first").change();
	}
}
function jdp_eform_openTree_close(){
	dialog.get("dialog-jdp-eform-tree").close().remove();
}
/*-------------------tree dialog方法处理------------end----------------*/

/*-------------------选择人dialog方法处理------------start----------------*/
function jdp_eform_openUser(obj, selectType, dialogName, formcell_openwidth, formcell_openheight){
	//设置默认宽度和高度
	if(formcell_openwidth == null || formcell_openwidth == ''){
		formcell_openwidth = 600;
	}
	if(formcell_openheight == null || formcell_openheight == ''){
		formcell_openheight = 430;
	}
	//设置点击的控件id
	jdp_eform_selectFormCell_Id = $(obj).attr("id");
	dialog({
		id: "dialog-jdp-eform-user",
        title: dialogName + "",
        url: ctx + '/common/ou/selUser' + (selectType == 1 ? "" : "Muti") + '.html?hiddenId=' + $(obj).closest("div").find("input[type='hidden']:first").attr("id") + '&textId=' + jdp_eform_selectFormCell_Id + '&callback=jdp_eform_openUser_callback&closeCallback=jdp_eform_openUser_close',
        width: formcell_openwidth > document.documentElement.clientWidth ? document.documentElement.clientWidth : formcell_openwidth,
        height: formcell_openheight > document.documentElement.clientHeight ? document.documentElement.clientHeight : formcell_openheight
    }).showModal();
}
//选择人回调
function jdp_eform_openUser_callback(result){
	var setIdValue = "";
	var setNameValue = "";
	if(result && result.length){
		for(var i = 0; i < result.length; i++){
			if("" == setIdValue){
				setIdValue = result[i].loginName;
				setNameValue = result[i].name;
			}else{
				setIdValue = setIdValue + "," + result[i].loginName;
				setNameValue = setNameValue + "," + result[i].name;
			}
		}
	}else if(result){
		var setIdValue = result.loginName;
		var setNameValue = result.name;
	}
	var oldValue = $("#" + jdp_eform_selectFormCell_Id).val();
	$("#" + jdp_eform_selectFormCell_Id).val(setNameValue);
	$("#" + jdp_eform_selectFormCell_Id).closest("div").find("input[type='hidden']:first").val(setIdValue);
	if(oldValue != setIdValue){
		$("#" + jdp_eform_selectFormCell_Id).change();
		$("#" + jdp_eform_selectFormCell_Id).closest("div").find("input[type='hidden']:first").change();
	}
}
//选择人关闭
function jdp_eform_openUser_close() {
	dialog.get("dialog-jdp-eform-user").close().remove();
}
/*-------------------选择人dialog方法处理------------end----------------*/

/*-------------------选择部门dialog方法处理------------start----------------*/
function jdp_eform_openDept(obj, selectType, dialogName, formcell_openwidth, formcell_openheight){
	//设置默认宽度和高度
	if(formcell_openwidth == null || formcell_openwidth == ''){
		formcell_openwidth = 300;
	}
	if(formcell_openheight == null || formcell_openheight == ''){
		formcell_openheight = 500;
	}
	//设置点击的控件id
	jdp_eform_selectFormCell_Id = $(obj).attr("id");
	dialog({
		id: "dialog-jdp-eform-dept",
        title: dialogName + "",
        url: ctx + '/common/ou/treeDept' + (selectType == 1 ? "" : "Muti") + '.html?showRadio=1&hiddenId=' + $(obj).closest("div").find("input[type='hidden']:first").attr("id") + '&callback=jdp_eform_openDept_callback&closeCallback=jdp_eform_openDept_close',
        width: formcell_openwidth > document.documentElement.clientWidth ? document.documentElement.clientWidth : formcell_openwidth,
        height: formcell_openheight > document.documentElement.clientHeight ? document.documentElement.clientHeight : formcell_openheight
    }).showModal();
}
//单选部门回调
function jdp_eform_openDept_callback(result){
	var setIdValue = "";
	var setNameValue = "";
	if(result && result.length){
		for(var i = 0; i < result.length; i++){
			if("" == setIdValue){
				setIdValue = result[i].code;
				setNameValue = result[i].name;
			}else{
				setIdValue = setIdValue + "," + result[i].code;
				setNameValue = setNameValue + "," + result[i].name;
			}
		}
	}else if(result){
		var setIdValue = result.code;
		var setNameValue = result.name;
	}
	var oldValue = $("#" + jdp_eform_selectFormCell_Id).val();
	$("#" + jdp_eform_selectFormCell_Id).val(setNameValue);
	$("#" + jdp_eform_selectFormCell_Id).closest("div").find("input[type='hidden']:first").val(setIdValue);
	if(oldValue != setIdValue){
		$("#" + jdp_eform_selectFormCell_Id).change();
		$("#" + jdp_eform_selectFormCell_Id).closest("div").find("input[type='hidden']:first").change();
	}
}
//选择部门关闭
function jdp_eform_openDept_close() {
	dialog.get("dialog-jdp-eform-dept").close().remove();
}
/*-------------------选择部门dialog方法处理------------end----------------*/

/*-------------------选择角色dialog方法处理------------start----------------*/
function jdp_eform_openRole(obj, selectType, dialogName, formcell_openwidth, formcell_openheight){
	//设置默认宽度和高度
	if(formcell_openwidth == null || formcell_openwidth == ''){
		formcell_openwidth = 300;
	}
	if(formcell_openheight == null || formcell_openheight == ''){
		formcell_openheight = 500;
	}
	//设置点击的控件id
	jdp_eform_selectFormCell_Id = $(obj).attr("id");
	dialog({
		id: "dialog-jdp-eform-role",
        title: dialogName + "",
        url: ctx + '/common/ou/treeRoleMuti.html?hiddenId=' + $(obj).closest("div").find("input[type='hidden']:first").attr("id") + '&callback=jdp_eform_openRole_callback&closeCallback=jdp_eform_openRole_close',
        width: formcell_openwidth > document.documentElement.clientWidth ? document.documentElement.clientWidth : formcell_openwidth,
        height: formcell_openheight > document.documentElement.clientHeight ? document.documentElement.clientHeight : formcell_openheight
    }).showModal();
}
//选择角色回调
function jdp_eform_openRole_callback(result){
	var setIdValue = "";
	var setNameValue = "";
	if(result && result.length){
		for(var i = 0; i < result.length; i++){
			if("" == setIdValue){
				setIdValue = result[i].id;
				setNameValue = result[i].name;
			}else{
				setIdValue = setIdValue + "," + result[i].id;
				setNameValue = setNameValue + "," + result[i].name;
			}
		}
	}else if(result){
		var setIdValue = result.id;
		var setNameValue = result.name;
	}
	var oldValue = $("#" + jdp_eform_selectFormCell_Id).val();
	$("#" + jdp_eform_selectFormCell_Id).val(setNameValue);
	$("#" + jdp_eform_selectFormCell_Id).closest("div").find("input[type='hidden']:first").val(setIdValue);
	if(oldValue != setIdValue){
		$("#" + jdp_eform_selectFormCell_Id).change();
		$("#" + jdp_eform_selectFormCell_Id).closest("div").find("input[type='hidden']:first").change();
	}
}
//选择角色关闭
function jdp_eform_openRole_close() {
	dialog.get("dialog-jdp-eform-role").close().remove();
}
/*-------------------选择角色dialog方法处理------------end----------------*/

/*-------------------选择岗位dialog方法处理------------start----------------*/
function jdp_eform_openPosi(obj, selectType, dialogName, formcell_openwidth, formcell_openheight){
	//设置默认宽度和高度
	if(formcell_openwidth == null || formcell_openwidth == ''){
		formcell_openwidth = 300;
	}
	if(formcell_openheight == null || formcell_openheight == ''){
		formcell_openheight = 500;
	}
	//设置点击的控件id
	jdp_eform_selectFormCell_Id = $(obj).attr("id");
	dialog({
		id: "dialog-jdp-eform-role",
        title: dialogName + "",
        url: ctx + '/common/ou/selPositionMuti.html?hiddenId=' + $(obj).closest("div").find("input[type='hidden']:first").attr("id") + '&callback=jdp_eform_openPosi_callback&closeCallback=jdp_eform_openPosi_close',
        width: formcell_openwidth > document.documentElement.clientWidth ? document.documentElement.clientWidth : formcell_openwidth,
        height: formcell_openheight > document.documentElement.clientHeight ? document.documentElement.clientHeight : formcell_openheight
    }).showModal();
}
//选择岗位回调
function jdp_eform_openPosi_callback(result){
	var setIdValue = "";
	var setNameValue = "";
	if(result && result.length){
		for(var i = 0; i < result.length; i++){
			if("" == setIdValue){
				setIdValue = result[i].id;
				setNameValue = result[i].name;
			}else{
				setIdValue = setIdValue + "," + result[i].id;
				setNameValue = setNameValue + "," + result[i].name;
			}
		}
	}else if(result){
		var setIdValue = result.id;
		var setNameValue = result.name;
	}
	var oldValue = $("#" + jdp_eform_selectFormCell_Id).val();
	$("#" + jdp_eform_selectFormCell_Id).val(setNameValue);
	$("#" + jdp_eform_selectFormCell_Id).closest("div").find("input[type='hidden']:first").val(setIdValue);
	if(oldValue != setIdValue){
		$("#" + jdp_eform_selectFormCell_Id).change();
		$("#" + jdp_eform_selectFormCell_Id).closest("div").find("input[type='hidden']:first").change();
	}
}
//选择岗位关闭
function jdp_eform_openPosi_close() {
	dialog.get("dialog-jdp-eform-posi").close().remove();
}
/*-------------------选择岗位dialog方法处理------------end----------------*/

/*-------------------选择群组dialog方法处理------------start----------------*/
function jdp_eform_openGroup(obj, selectType, dialogName, formcell_openwidth, formcell_openheight){
	//设置默认宽度和高度
	if(formcell_openwidth == null || formcell_openwidth == ''){
		formcell_openwidth = 620;
	}
	if(formcell_openheight == null || formcell_openheight == ''){
		formcell_openheight = 500;
	}
	//设置点击的控件id
	jdp_eform_selectFormCell_Id = $(obj).attr("id");
	dialog({
		id: "dialog-jdp-eform-role",
        title: dialogName + "",
        url: ctx + '/common/ou/selGroupMuti.html?hiddenId=' + $(obj).closest("div").find("input[type='hidden']:first").attr("id") + '&textId=' + jdp_eform_selectFormCell_Id + '&callback=jdp_eform_openGroup_callback&closeCallback=jdp_eform_openGroup_close',
        width: formcell_openwidth > document.documentElement.clientWidth ? document.documentElement.clientWidth : formcell_openwidth,
        height: formcell_openheight > document.documentElement.clientHeight ? document.documentElement.clientHeight : formcell_openheight
    }).showModal();
}
//选择群组回调
function jdp_eform_openGroup_callback(result){
	var setIdValue = "";
	var setNameValue = "";
	if(result && result.length){
		for(var i = 0; i < result.length; i++){
			if("" == setIdValue){
				setIdValue = result[i].id;
				setNameValue = result[i].name;
			}else{
				setIdValue = setIdValue + "," + result[i].id;
				setNameValue = setNameValue + "," + result[i].name;
			}
		}
	}else if(result){
		var setIdValue = result.id;
		var setNameValue = result.name;
	}
	var oldValue = $("#" + jdp_eform_selectFormCell_Id).val();
	$("#" + jdp_eform_selectFormCell_Id).val(setNameValue);
	$("#" + jdp_eform_selectFormCell_Id).closest("div").find("input[type='hidden']:first").val(setIdValue);
	if(oldValue != setIdValue){
		$("#" + jdp_eform_selectFormCell_Id).change();
		$("#" + jdp_eform_selectFormCell_Id).closest("div").find("input[type='hidden']:first").change();
	}
}
//选择岗位关闭
function jdp_eform_openGroup_close() {
	dialog.get("dialog-jdp-eform-group").close().remove();
}
/*-------------------选择岗位dialog方法处理------------end----------------*/
/*唯一值校验*/
//校验编码是否已被使用,在validate校验中添加funcCall[ajaxCodeRepeated],例如data-validation-engine="validate[required,funcCall[ajaxCodeRepeated]]"
function jdp_eform_ajaxCodeRepeated(obj){
	var ajaxResult=true;
	var talbeCode = "";
	var fieldCode = "";
	var fieldValue = "";
	var fieldOldValue = "";
	var datasource = $("#dataSource").val();
	if($(obj).attr("id") != null && $(obj).attr("id").indexOf("_THSNAME") > -1){
		tableCode = $("#" + $(obj).attr("id").replace("_THSNAME", "")).attr("name").split("\.column")[0].split("\'")[1];
		fieldCode = $("#" + $(obj).attr("id").replace("_THSNAME", "")).attr("name").split("\.column")[1].split("\'")[1];
		fieldValue =$("#" + $(obj).attr("id").replace("_THSNAME", "")).val();
		fieldOldValue = $("#" + $(obj).attr("id").replace("_THSNAME", "")).attr("oldValue");
	}else{
		tableCode = $(obj).attr("name").split("\.column")[0].split("\'")[1];
		fieldCode = $(obj).attr("name").split("\.column")[1].split("\'")[1];
		fieldValue = $(obj).val();
		fieldOldValue = $(obj).attr("oldValue");
	}
	$.ajax({
		url:ctx +"/eform/validation/repeated.vm",
		//{datasource:"数据源",table:"表名",field:"需要校验的字段名",IgnoreCase:true|false,fieldValue:"该字段表单值",oldValue:"该字段数据库值"}
		//IgnoreCase取值，举例：当fieldValue值为form_info,如果数据库现有的值的FORM_INFO，当IgnoreCase为true时，服务端返回false，代表编号重复，如果IgnoreCase为false，服务端返回true，代表编号可用。
		data:{datasource: datasource,table:tableCode,field:fieldCode,IgnoreCase:true,fieldValue:fieldValue,oldValue:fieldOldValue },
		type:"post",
		dataType:"text",
		async:false,
		success:function(response){
			if(response=="false")
				ajaxResult=false;
		},
		error:function(response){
			ajaxResult=false; 
		}
	});
	if(ajaxResult==false)
		return "此编码已被其他人使用";
}
//设置select可以输入
function jdp_eform_selectCanEdit(select){
	if(select.length > 0){
		var content = '<input id="' + select.attr("id") + '_input_text" onkeyup="jdp_eform_selectCustomVal(this)" class="form-control selectEditInput" style="position:absolute;';
		if(select.closest("table.table").length <= 0){
			content += " left:13px; padding-left: 11px;";
		}else{
			content += " left:1px;";
		}
		content += ' height:90%;top:2px;border-bottom:0px;border-right:0px;border-left:0px;border-top:0px;" /><input type="hidden" id="' + select.attr("id") + '_input_value" name="' + select.attr("name") + '"/>';
		select.parent().append(content);
		select.removeAttr("name");
		select.change(function(){
			$("#" + select.attr("id") + "_input_text").val($(this).find("option:selected").text().trim());
			$("#" + select.attr("id") + "_input_value").val($(this).find("option:selected").val());
		});
		if(select.attr("oldValue") != ""){
			if(select.find("option[value='" + select.attr("oldValue") + "']").length > 0){
				$("#" + select.attr("id") + "_input_text").val(select.find("option[value='" + select.attr("oldValue") + "']").text().trim());
			}else{
				$("#" + select.attr("id") + "_input_text").val(select.attr("oldValue"));
			}
			$("#" + select.attr("id") + "_input_value").val(select.attr("oldValue"));
		}else{
			$("#" + select.attr("id") + "_input_text").val(select.find("option:selected").text().trim());
			$("#" + select.attr("id") + "_input_value").val(select.find("option:selected").val());
		}
	}
}
//改变select输入的值
function jdp_eform_selectCustomVal(obj){
	$("#" + $(obj).attr("id").replace("_input_text", "_input_value")).val($(obj).val());
}
//初始化可编辑下拉框
function jdp_eform_initEditSelect(){
	$("select.editable").each(function(){
		jdp_eform_selectCanEdit($(this));
	});
}

//设置accept参数
function jdp_eform_initFileAccept(){
	$(document).find(":file[data-validation-engine*='onlyPdfFile']").each(function(){
		if($(this).attr("accept") == null){
			$(this).attr("accept", "application/pdf");
		}else{
			$(this).attr("accept", $(this).attr("accept") + ", application/pdf");
		}
	});
}
//初始化附件
function jdp_eform_initFileWebUploader(businessKey, editType){
	jdp_eform_addFileWebUploader(document, businessKey, editType);
}
function jdp_eform_addFileWebUploader(obj, businessKey, editType){
	$(obj).find("div.file,div.multifile").each(function(){
		//判断id属性
		if($(this).attr("id") != null && $(this).attr("id") != "" && !ThsUploderUtil.ThsUploaderArray[$(this).attr("id")]){
			var options = null;
			if($(this).closest("tr").length == 1 && !$(this).closest("tr").hasClass("data_tr") && !$(this).closest("tr").hasClass("baseRowTr")){ //子表附件
				options = {
					pick: $(this).attr("id"),
					multifile: $(this).hasClass("multifile") + "",
					params:{
						businessKey: businessKey, 
						inputFileId: $(this).attr("id").substring(0, $(this).attr("id").lastIndexOf("_")), 
						subBusinessKey: $(this).closest("tr").find("input.primary").val()
					},
					editType: (editType == "view" ? "view" : "edit"),
					theme: "block",
					outside: true //仅对多选控件有用
				};
			}else{
				options = {
					pick: $(this).attr("id"),
					multifile: $(this).hasClass("multifile") + "",
					params:{
						businessKey: businessKey, 
						inputFileId: $(this).attr("id")
					},
					editType: (editType == "view" ? "view" : "edit"),
					theme: "block",
					outside: true //仅对多选控件有用
				};
			}
			//附件类型
			if($(this).attr("mimeTypes") != null){
				options.accept = {
					extensions: $(this).attr("mimeTypes").replace(/\./g, ""),
					mimeTypes: $(this).attr("mimeTypes")
				}
			}
			new ThsUploder(options);
			$(this).find("div.webuploader-pick:not(.webuploader-pick-single)").html("添加文件");
		}
	});
}
//多选控件上传页-outside模式使用
function jdp_eform_openMultifileUploadDialog(fileInputId){
	dialog({
		id: "dialog-jdp-eform-multifile-dialog",
        title: "选择",
        content: $("#" + fileInputId),
        ok: function(){},
        onshow: function () {
        	$("#" + fileInputId).find(".webuploader-pick").each(function(){
        		//将选择文件触发区域放置到按钮上
        		if(!$(this).is(":hidden")){
        			$(this).parent().find("input[type='file']").parent().css("left", this.offsetLeft);
        			$(this).parent().find("input[type='file']").parent().css("top", this.offsetTop);
        			$(this).parent().find("input[type='file']").parent().css("width", $(this).innerWidth());
        			$(this).parent().find("input[type='file']").parent().css("height", $(this).innerHeight());
        		}
        	});
    	},
        width: 515 > document.documentElement.clientWidth ? document.documentElement.clientWidth : 515,
        height: 330 > document.documentElement.clientHeight ? document.documentElement.clientHeight : 330
    }).showModal();
}
//上传附件
function jdp_eform_uploadFile(callback){
	var length = $("div.file,div.multifile").length;
	//没有附件直接返回
	if(length == 0){
		if(typeof callback === "function") {
			callback();
		}
		return;
	}
	//有附件，必须等所有附件上传成功再返回
	var uploadResponse = {};
	$("div.file,div.multifile").each(function(i){
		//判断id属性
		if($(this).attr("id") != null && $(this).attr("id") != ""){
			var _uploadStatus = {status: false};
			uploadResponse[$(this).attr("id")] = _uploadStatus;
			var thsUploader = ThsUploderUtil.ThsUploaderArray[$(this).attr("id")];
			if($(this).closest("tr").length == 1 && !$(this).closest("tr").hasClass("data_tr") && !$(this).closest("tr").hasClass("baseRowTr")){ //子表附件
				thsUploader.getUploader().options.formData.subBusinessKey = $(this).closest("tr").find("input.primary").val();
			}
			thsUploader.upload(function(response){
				_uploadStatus.response = response;
				_uploadStatus.status = true;
			});
		}
	});
	//定时检测上传同步状态
	var tt = window.setInterval(function() {
		var uploadStatus = true;
		for(var i in uploadResponse){
			if(!uploadResponse[i].status){
				uploadStatus = false;
			}
		}
		if (uploadStatus) {
			window.clearInterval(tt);
			if(typeof callback === "function") {
				var uploadResult = true;
				var uploadMsg = "";
				//检测文件是否都上传成功
				for(var i in uploadResponse){
					if(uploadResponse[i].response != null && uploadResponse[i].response.code == 0){
						uploadResult = false;
						uploadMsg = uploadResponse[i].response.msg;
						break;
					}
				}
				if(uploadResult){
					callback(uploadResponse);
				}else{
					dialog({
			            title: '提示',
			            content: '文件上传失败！' + uploadMsg,
			            wraperstyle: 'alert-info',
			            ok: function() {
			            }
			        }).showModal();
				}
			}
		}
	}, 100);
}
//更新附件主表业务主键
function jdp_eform_updateFileBusinessKey(uploadResponse, businessKey, callback){
	if(businessKey == null || businessKey == "" || uploadResponse == null || uploadResponse.length == 0){
		if(typeof callback === "function") {
			callback();
		}
		return;
	}
	var fileIds = "";
	for(var i in uploadResponse){
		if(uploadResponse[i].response){
			if(uploadResponse[i].response.length){
				for(var j = 0; j < uploadResponse[i].response.length; j++){
					fileIds += (fileIds == "" ? "" : ",") + uploadResponse[i].response[j].fileId;
				}
			}else{
				fileIds += (fileIds == "" ? "" : ",") + uploadResponse[i].response.fileId;
			}
		}
	}
	if(fileIds == ""){
		if(typeof callback === "function") {
			callback();
		}
		return;
	}
	//更新附件业务主键值
	$.ajax({
		url: ctx + "/eform/uploader/" + businessKey + "/update.vm",
		data: "fileIds=" + fileIds,
		type: "post",
		dataType: "json",
		async: false,
		success:function(response){
			if(typeof callback === "function") {
				callback();
			}
		}
	});
}
//检测文件必填验证
function jdp_eform_checkFileRequired(obj){
	var fileInputId = $(obj).attr("id");
	if(obj.hasClass("multifile-input")){
		fileInputId = fileInputId.replace(/_input$/,"");
	}
	var thsUploader = ThsUploderUtil.ThsUploaderArray[fileInputId];
	if(thsUploader != null){
		var fileCount = 0;
		var files = thsUploader.getUploader().getFiles();
		if(files != null && files.length > 0){
			for(var i = 0; i < files.length; i++){
				if(files[i].getStatus() != "cancelled"){
					fileCount++;
					break;
				}
			}
		}
		if(fileCount == 0){
			return "必填";
		}
	}
}
//点击删除附件按钮
function jdp_eform_clickRemoveFileBtn(obj){
	var $uploaderDiv = $(obj).closest("div.webuploader-container");
	var thsUploader = ThsUploderUtil.ThsUploaderArray[$uploaderDiv.attr("id")];
	if(thsUploader){
		var files = thsUploader.getUploader().getFiles();
		if(files != null && files.length > 0){
			thsUploader.getUploader().removeFile(files[0]);
			ThsUploderUtil.deleteFileIds += (ThsUploderUtil.deleteFileIds == "" ? "" : ",") + files[0].source.fileId;
		}
		thsUploader.getUploader().reset();
		$uploaderDiv.find(".ace-file-container").css("width", "100%");
		$(obj).hide();
		$uploaderDiv.find(".ace-file-name").attr("data-title", "");
		$uploaderDiv.find("input[type='file']").next().css("width", "100%");
	}
}

$(function() {
	//自定义验证
	$.validationEngineLanguage.allRules.onlyPdfFile= {
		"regex": /^.+(.pdf|.PDF)$/,
		"alertText": "* 请选择pdf文件"
	};
	jdp_eform_initEditSelect();
	jdp_eform_initFileAccept();
	
	//file绑定change事件，初始化控件remove按钮
	$(document).on("change", "input[type='file']", function(){
		$("div.file").each(function(i){
			//判断id属性
			if($(this).attr("id") != null && $(this).attr("id") != "" && $(this).find(".webuploader-pick-single").length > 0){
				var thsUploader = ThsUploderUtil.ThsUploaderArray[$(this).attr("id")];
				if(thsUploader != null && thsUploader.getUploader().options.editType != "view" && thsUploader.getUploader().getFiles().length > 0 
						&& $(this).find(".remove").is(":hidden")){
					$(this).validationEngine('validate');
					$(this).find(".ace-file-container").width($(this).find(".ace-file-container").width() - 27);
					$(this).find(".remove").css({"right": "5px", "z-index": "99"});
					$(this).find(".remove").show();
					$(this).find(".remove").attr("onclick", "jdp_eform_clickRemoveFileBtn(this);");
					$(this).find("input[type='file']").next().width($(this).find("input[type='file']").next().width() - 27);
				}
			}
		});
	});
});			
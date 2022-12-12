/*页面上要保留的JS方法。属于eform组件方法，请慎重修改 */
if(!window.stopEvent){
	//阻止事件起泡
	var stopEvent = function(){
		var event = window.event || arguments.callee.caller.arguments[0];
	    var e = event || window.event;
	    if(e){
	    	if(e.stopPropagation){
	            e.stopPropagation();
	        }else {
	            e.cancelBubble = true;
	            if(e.returnValue){
	            	e.returnValue = false;
	            }
	        } 
	    }
	};
}
//被选中的控件ID
var jdp_eform_selectFormCell_Id;
//清空值方法
function jdp_eform_clearValue(obj){
	$(obj).closest("div.input-group").find("input").each(function(){
		$(this).val("");
	});
}
//子表添加行			
function jdp_eform_addTableRow(obj){
	stopEvent();
	var baseRowTr = $(obj).closest("table").find("tbody > .baseRowTr").clone();
	if(baseRowTr.length == 0){
		baseRowTr = $($(obj).closest("table").children("tbody").children("tr").last()).clone();
	}
	baseRowTr.css("display", "");
	$(baseRowTr).removeClass("baseRowTr");
	var index = 0;
	if($(baseRowTr).attr("index")){
		index = parseInt($(baseRowTr).attr("index"));
	}
 	$(baseRowTr).attr("index", index + 1);
 	//添加行
 	$(obj).closest("table").find("> tbody").append(baseRowTr);
 	//设置基础行索引
	$(obj).closest("table").find("> tbody > .baseRowTr").attr("index", index + 1);
	$(baseRowTr).find("input,select").each(function(){
		if($(this).val() != null && $(this).attr("id") != null && $(this).val().indexOf("DATE:") < 0
				&& !$(this).is(":hidden")){
			if($(this).attr("type")=="checkbox" || $(this).attr("type")=="radio"){
				$(this).prop("checked",false);
			}else if(this.nodeName == "SELECT"){
				$(this).prop("selected",false);
			}else{
				$(this).val("");
			}
		}
		if($(this).attr("name") && $(this).attr("name").indexOf(".key[") > -1){ //隐藏域，name like key[]视为主键， 生成新的主键值
			$(this).val(generateUUID());
		}
		if($(this).attr("name") && $(this).attr("name").indexOf(".row[") > -1){
			$(this).attr("name", $(this).attr("name").replace(".row[" + index + "]", ".row[" + (index + 1) + "]"));
		}
		if($(this).attr("id") && $(this).attr("id").indexOf("_row_") > -1){
			$(this).attr("id", $(this).attr("id").replace("_row_" + index, "_row_" + (index + 1)));
		}else if($(this).attr("id") && /_index$/.test($(this).attr("id"))){
			$(this).attr("id", $(this).attr("id").replace(/index$/, index + 1));
		}
		if($(this).attr("onclick") != null){
			$(this).attr("onclick", $(this).attr("onclick").replace("_" + index + "'", "_" + (index + 1) + "'"));
		}
		if(this.nodeName == "SELECT"){
			$(this).change(function(){
				$("#" + $(this).attr("id") + "_input_text").val($(this).find("option:selected").text().trim());
				$("#" + $(this).attr("id") + "_input_value").val($(this).find("option:selected").val());
			});
		}
		//清空file
		if(this.type == "file"){
			$(this).parent().find("div.tags").html("");
		}
	});
	//时间id替换
	$(baseRowTr).find("i.fa-calendar").each(function(){
		$(this).parent().attr("onclick", $(this).parent().attr("onclick").replace("_" + index + "'", "_" + (index + 1) + "'"));
		$($(this).closest("div.input-group").children("input")[1]).attr("id", $($(this).closest("div.input-group").children("input")[1]).attr("id").replace("_" + index, "_" + (index + 1)));
	});
}
//子表删除行
function jdp_eform_deleteTableRow(tableObj){
	stopEvent();
	if($(tableObj).closest("table").find("> tbody > tr:visible").length == 1){
		dialog({
            title: '提示',
            content: '至少保留一行!',
            wraperstyle:'alert-info',
            ok: function () {}
        }).showModal();
		return;
	}
	$(tableObj).parent().parent().css("display", "none");
	//设置删除主键值为$hidden...$hidden
	$(tableObj).parent().parent().find("input[type='hidden']").each(function(){
		if($(this).attr("name") && $(this).attr("name").indexOf(".key[") > -1){
			$(this).val("$hidden" + $(this).val() + "$hidden");
		}
	});
}
//上移行
function jdp_eform_upTableRow(obj){
	var $tr = $(obj).closest("tr");
	if ($tr.index() > 0) {
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
function jdp_eform_openList(obj,selectType,dialogName, dictionary_code,formcell_openwidth,formcell_openheight){
	if(formcell_openwidth==''){
		formcell_openwidth=600;
	}
	if(formcell_openheight==''){
		formcell_openheight=430;
	}
	jdp_eform_selectFormCell_Id = $(obj).attr("id").replace("_THSNAME", "");
	var _eformVariable=$("#eformVariable").val();
	if(!_eformVariable ||  _eformVariable=="undefined"){
		_eformVariable="";
	}
	dialog({
		id:"dialog-jdp-eform-list",
        title: dialogName+" ",
        url: ctx + "/eform/components/table/table_choose.vm?hiddenId="+jdp_eform_selectFormCell_Id+"&textId="+$(obj).attr('id')+"&selectType=" + selectType + "&dictionary_code=" + dictionary_code + "&callback=jdp_eform_openList_callback&closeCallback=jdp_eform_openList_close" + _eformVariable,
        width:formcell_openwidth,
        height:formcell_openheight
    }).showModal();
}
function jdp_eform_openList_callback(listOneObj){
	var setIdValue = "";
	var setNameValue = "";
	if(listOneObj && listOneObj.length){
		for(var i=0;i<listOneObj.length;i++){
			if(""==setIdValue){
				setIdValue = listOneObj[i]["CODE"];
				setNameValue = listOneObj[i]["NAME"];
			}else{
				setIdValue = setIdValue +","+ listOneObj[i]["CODE"];
				setNameValue = setNameValue +","+listOneObj[i]["NAME"];
			}
		}
	}else if(listOneObj){
		var setIdValue = listOneObj.CODE;
		var setNameValue = listOneObj.NAME;
	}
	var oldValue = $("#"+jdp_eform_selectFormCell_Id).val();
	$("#"+jdp_eform_selectFormCell_Id).val(setIdValue);
	$("#"+jdp_eform_selectFormCell_Id+"_THSNAME").val(setNameValue);
	if(oldValue != setIdValue){
		$("#"+jdp_eform_selectFormCell_Id).change();
		$("#"+jdp_eform_selectFormCell_Id+"_THSNAME").change();
	}
}
function jdp_eform_openList_close(){
	dialog.get("dialog-jdp-eform-list").close().remove();
}
/*-------------------列表dialog方法处理------------end----------------*/

/*-------------------tree dialog方法处理------------start----------------*/
//树类型标识（1单选树、2多选树）
var jdp_eform_treeType = 1;
function jdp_eform_openTree(obj,selectType,dialogName,sqlpackage,mapperid,formcell_openwidth,formcell_openheight,formcell_dictionary, form_id){
	if(formcell_openwidth==''){
		formcell_openwidth=380;
	}
	if(formcell_openheight==''){
		formcell_openheight=480;
	}
	jdp_eform_selectFormCell_Id = $(obj).attr("id").replace("_THSNAME", "");
	var _eformVariable=$("#eformVariable").val();
	if(!_eformVariable ||  _eformVariable=="undefined"){
		_eformVariable="";
	}
	dialog({
			id:"dialog-jdp-eform-tree",
	        title: dialogName+" ",
	        url: ctx + "/eform/tree/window.vm?showRadio=1&hiddenId="+jdp_eform_selectFormCell_Id+"&treetype="+selectType+"&sqlpackage="+sqlpackage+"&mapperid="+mapperid+"&callback=jdp_eform_treeCallBack&closeCallback=jdp_eform_openTree_close&FORM_ID=" + form_id + "&formcell_dictionary="+formcell_dictionary + _eformVariable,
	        width:formcell_openwidth,
	        height:formcell_openheight
	    }).showModal();
	jdp_eform_treeType = selectType;
}
function jdp_eform_treeCallBack(tree){
	var tree_id = "",tree_name = "";
	if(jdp_eform_treeType == 1){	//单选
		tree_id = tree.TREE_ID;
		tree_name = tree.TREE_NAME;
	}else{	//多选
		for(var i=0;i<tree.length;i++){
			tree_id += tree[i].TREE_ID + ",";
			tree_name += tree[i].TREE_NAME + ",";
		}
		tree_id = tree_id.substring(0,tree_id.length-1);
		tree_name = tree_name.substring(0,tree_name.length-1);
	}
	var oldValue = $("#"+jdp_eform_selectFormCell_Id).val();
	$("#"+jdp_eform_selectFormCell_Id).val(tree_id);
	$("#"+jdp_eform_selectFormCell_Id+"_THSNAME").val(tree_name);
	if(oldValue != tree_id){
		$("#"+jdp_eform_selectFormCell_Id).change();
		$("#"+jdp_eform_selectFormCell_Id+"_THSNAME").change();
	}
}
function jdp_eform_openTree_close(){
	dialog.get("dialog-jdp-eform-tree").close().remove();
}
/*-------------------tree dialog方法处理------------end----------------*/

/*-------------------选择人dialog方法处理------------start----------------*/
var jdp_eform_openUser_type = 1; //（1单选、2多选）
//选择人dialog
function jdp_eform_openUser(obj,selectType,dialogName,formcell_openwidth,formcell_openheight){
	if(formcell_openwidth==''){
		formcell_openwidth=600;
	}
	if(formcell_openheight==''){
		formcell_openheight=430;
	}
	jdp_eform_selectFormCell_Id = $(obj).attr("id").replace("_THSNAME", "");
	dialog({
		id:"dialog-jdp-eform-user",
        title: dialogName,
        url: ctx + '/common/ou/selUser' + (selectType == 1 ? "" : "Muti") + '.html?hiddenId='+jdp_eform_selectFormCell_Id+'&textId='+$(obj).attr("id")+'&callback=jdp_eform_openUser_callback&closeCallback=jdp_eform_openUser_close',
        width:formcell_openwidth,
        height:formcell_openheight
    }).showModal();
	jdp_eform_openUser_type = selectType;
}
//选择人回调
function jdp_eform_openUser_callback(users){
	var loginName = "", name = "";
	if(jdp_eform_openUser_type == 1){	//单选
		loginName = users.loginName;
		name = users.name;
	}else{	//多选
		for(var i = 0; i < users.length; i++) {
			loginName += users[i].loginName + ",";
			name += users[i].name + ",";
		}
		loginName = loginName.substring(0, loginName.length - 1);
		name = name.substring(0, name.length - 1);
	}
	var oldValue = $("#" + jdp_eform_selectFormCell_Id).val();
	$("#" + jdp_eform_selectFormCell_Id).val(loginName);
	$("#" + jdp_eform_selectFormCell_Id + "_THSNAME").val(name);
	if(oldValue != loginName){
		$("#" + jdp_eform_selectFormCell_Id).change();
		$("#" + jdp_eform_selectFormCell_Id + "_THSNAME").change();
	}
}
//选择人关闭
function jdp_eform_openUser_close() {
	dialog.get("dialog-jdp-eform-user").close().remove();
}
/*-------------------选择人dialog方法处理------------end----------------*/

/*-------------------选择部门dialog方法处理------------start----------------*/
var jdp_eform_openDept_type = 1; //（1单选、2多选）
//选择部门dialog
function jdp_eform_openDept(obj,selectType,dialogName,formcell_openwidth,formcell_openheight){
	if(formcell_openwidth==''){
		formcell_openwidth=300;
	}
	if(formcell_openheight==''){
		formcell_openheight=500;
	}
	jdp_eform_selectFormCell_Id = $(obj).attr("id").replace("_THSNAME", "");
	dialog({
		id:"dialog-jdp-eform-dept",
        title: dialogName,
        url: ctx + '/common/ou/treeDept' + (selectType == 1 ? "" : "Muti") + '.html?showRadio=1&hiddenId='+jdp_eform_selectFormCell_Id+'&callback=jdp_eform_openDept_callback&closeCallback=jdp_eform_openDept_close',
        width:formcell_openwidth,
        height:formcell_openheight
    }).showModal();
	jdp_eform_openDept_type = selectType;
}
//单选部门回调
function jdp_eform_openDept_callback(depts){
	var id = "", name = "";
	if(jdp_eform_openDept_type == 1){	//单选
		id = depts.code;
		name = depts.name;
	}else{
		for(var i = 0; i < depts.length; i++) {
			id += depts[i].code + ",";
			name += depts[i].name + ",";
		}
		id = id.substring(0, id.length - 1);
		name = name.substring(0, name.length - 1);
	}
	var oldValue = $("#" + jdp_eform_selectFormCell_Id).val();
	$("#" + jdp_eform_selectFormCell_Id).val(id);
	$("#" + jdp_eform_selectFormCell_Id + "_THSNAME").val(name);
	if(oldValue != id){
		$("#" + jdp_eform_selectFormCell_Id).change();
		$("#" + jdp_eform_selectFormCell_Id + "_THSNAME").change();
	}
}
//选择部门关闭
function jdp_eform_openDept_close() {
	dialog.get("dialog-jdp-eform-dept").close().remove();
}
/*-------------------选择部门dialog方法处理------------end----------------*/

/*-------------------选择角色dialog方法处理------------start----------------*/
var jdp_eform_openRole_type = 1; //（1单选、2多选）
//选择角色dialog
function jdp_eform_openRole(obj,selectType,dialogName,formcell_openwidth,formcell_openheight){
	if(formcell_openwidth==''){
		formcell_openwidth=300;
	}
	if(formcell_openheight==''){
		formcell_openheight=500;
	}
	jdp_eform_selectFormCell_Id = $(obj).attr("id").replace("_THSNAME", "");
	dialog({
		id:"dialog-jdp-eform-role",
        title: dialogName,
        url: ctx + '/common/ou/treeRoleMuti.html?hiddenId='+jdp_eform_selectFormCell_Id+'&callback=jdp_eform_openRole_callback&closeCallback=jdp_eform_openRole_close',
        width:formcell_openwidth,
        height:formcell_openheight
    }).showModal();
	jdp_eform_openRole_type = selectType;
}
//选择角色回调
function jdp_eform_openRole_callback(roles){
	var id = "";
    var name = "";
    for(var i = 0; i < roles.length; i++) {
    	id += roles[i].id + ",";
		name += roles[i].name + ",";
	}
    id = id.substring(0, id.length - 1);
	name = name.substring(0, name.length - 1);
	var oldValue = $("#" + jdp_eform_selectFormCell_Id).val();
	$("#" + jdp_eform_selectFormCell_Id).val(id);
	$("#" + jdp_eform_selectFormCell_Id + "_THSNAME").val(name);
	if(oldValue != id){
		$("#" + jdp_eform_selectFormCell_Id).change();
		$("#" + jdp_eform_selectFormCell_Id + "_THSNAME").change();
	}
}
//选择角色关闭
function jdp_eform_openRole_close() {
	dialog.get("dialog-jdp-eform-role").close().remove();
}
/*-------------------选择角色dialog方法处理------------end----------------*/

/*-------------------选择岗位dialog方法处理------------start----------------*/
var jdp_eform_openPosi_type = 1; //（1单选、2多选）
//选择岗位dialog
function jdp_eform_openPosi(obj,selectType,dialogName,formcell_openwidth,formcell_openheight){
	if(formcell_openwidth==''){
		formcell_openwidth=300;
	}
	if(formcell_openheight==''){
		formcell_openheight=500;
	}
	jdp_eform_selectFormCell_Id = $(obj).attr("id").replace("_THSNAME", "");
	dialog({
		id:"dialog-jdp-eform-posi",
        title: dialogName,
        url: ctx + '/common/ou/selPositionMuti.html?hiddenId='+jdp_eform_selectFormCell_Id+'&callback=jdp_eform_openPosi_callback&closeCallback=jdp_eform_openPosi_close',
        width:formcell_openwidth,
        height:formcell_openheight
    }).showModal();
	jdp_eform_openPosi_type = selectType;
}
//选择岗位回调
function jdp_eform_openPosi_callback(positions){
	var id = "";
    var name = "";
    for(var i = 0; i < positions.length; i++) {
    	id += positions[i].id + ",";
		name += positions[i].name + ",";
	}
    id = id.substring(0, id.length - 1);
	name = name.substring(0, name.length - 1);
	var oldValue = $("#" + jdp_eform_selectFormCell_Id).val();
	$("#" + jdp_eform_selectFormCell_Id).val(id);
	$("#" + jdp_eform_selectFormCell_Id + "_THSNAME").val(name);
	if(oldValue != id){
		$("#" + jdp_eform_selectFormCell_Id).change();
		$("#" + jdp_eform_selectFormCell_Id + "_THSNAME").change();
	}
}
//选择岗位关闭
function jdp_eform_openPosi_close() {
	dialog.get("dialog-jdp-eform-posi").close().remove();
}
/*-------------------选择岗位dialog方法处理------------end----------------*/

/*-------------------选择群组dialog方法处理------------start----------------*/
var jdp_eform_openGroup_type = 1; //（1单选、2多选）
//选择群组dialog
function jdp_eform_openGroup(obj,selectType,dialogName,formcell_openwidth,formcell_openheight){
	if(formcell_openwidth==''){
		formcell_openwidth=620;
	}
	if(formcell_openheight==''){
		formcell_openheight=500;
	}
	jdp_eform_selectFormCell_Id = $(obj).attr("id").replace("_THSNAME", "");
	dialog({
		id:"dialog-jdp-eform-group",
        title: dialogName,
        url: ctx + '/common/ou/selGroupMuti.html?hiddenId='+jdp_eform_selectFormCell_Id+'&textId='+$(obj).attr("id")+'&callback=jdp_eform_openGroup_callback&closeCallback=jdp_eform_openGroup_close',
        width:formcell_openwidth,
        height:formcell_openheight
    }).showModal();
	jdp_eform_openGroup_type = selectType;
}
//选择群组回调
function jdp_eform_openGroup_callback(groups){
	var id = "";
    var name = "";
    for(var i = 0; i < groups.length; i++) {
    	id += groups[i].id + ",";
		name += groups[i].name + ",";
	}
    id = id.substring(0, id.length - 1);
	name = name.substring(0, name.length - 1);
	var oldValue = $("#" + jdp_eform_selectFormCell_Id).val();
	$("#" + jdp_eform_selectFormCell_Id).val(id);
	$("#" + jdp_eform_selectFormCell_Id + "_THSNAME").val(name);
	if(oldValue != id){
		$("#" + jdp_eform_selectFormCell_Id).change();
		$("#" + jdp_eform_selectFormCell_Id + "_THSNAME").change();
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
		var content = '<input id="' + select.attr("id") + '_input_text" onkeyup="jdp_eform_selectCustomVal(this)" class="form-control" style="position:absolute;';
		if(select.closest("table.table").length <= 0){
			content += " left:13px; padding-left: 11px;";
		}else{
			content += " left:1px;";
		}
		content += ' width:' + (select.width() - 5) + 'px;height:90%;top:2px;border-bottom:0px;border-right:0px;border-left:0px;border-top:0px;" /><input type="hidden" id="' + select.attr("id") + '_input_value" name="' + select.attr("name") + '"/>';
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

/*字典项最大长度验证*/
function jdp_eform_dic_maxLength(field, rules, i, options){
	var value = "";
	if($(field).attr("id") != null && $(field).attr("id").indexOf("_THSNAME") > -1){
		value = $("#" + $(field).attr("id").replace("_THSNAME","")).val();
	}
	value = value.replace(/[^\x00-\xff]/g, "***");
	if(value.length > rules[i + 2]){
		return "控件值已超过最大长度" + rules[i + 2];
	}
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
			if($(this).closest("tr").length == 1 && !$(this).closest("tr").hasClass("data_tr") && !$(this).closest("tr").hasClass("baseRowTr")){ //子表附件
				new ThsUploder({
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
				});
			}else{
				new ThsUploder({
					pick: $(this).attr("id"),
					multifile: $(this).hasClass("multifile") + "",
					params:{
						businessKey: businessKey, 
						inputFileId: $(this).attr("id")
					},
					editType: (editType == "view" ? "view" : "edit"),
					theme: "block",
					outside: true //仅对多选控件有用
				});
			}
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
	var thsUploader = ThsUploderUtil.ThsUploaderArray[$(obj).closest("div.file").attr("id")];
	if(thsUploader){
		var files = thsUploader.getUploader().getFiles();
		if(files != null && files.length > 0){
			thsUploader.getUploader().removeFile(files[0]);
		}
		thsUploader.getUploader().reset();
		$(obj).closest("div.file").find(".ace-file-container").css("width", "100%");
		$(obj).hide();
		$(obj).closest("div.file").find(".ace-file-name").attr("data-title", "");
		$(obj).closest("div.file").find("input[type='file']").next().css("width", "100%");
	}
}

function jdp_eform_initLoadUrl(formId, businessKey){
	//加载页面
	$("span.padding_1.loadUrl").each(function(){
		if($(this).attr("url")){
			var _url = ths.urlEncode4Get($(this).attr("url")).replace(/^\/./, "");
			$(this).load(ctx + "/" + _url + "&id=" + businessKey + "&formId=" + formId);
		}
	});
}

$(function() {
	//自定义验证
	$.validationEngineLanguage.allRules.onlyPdfFile= {
		"regex": /^.+(.pdf|.PDF)$/,
		"alertText": "* 请选择pdf文件"
	};
	
	$("#formInfo").validationEngine({
		scrollOffset : 98,//必须设置，因为Toolbar position为Fixed
		promptPosition : 'bottomLeft',
		autoHidePrompt : true
	});
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
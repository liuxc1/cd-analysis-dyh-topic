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

function initFormHtml(form_id, formParam){
	ths.submitFormAjax({
   		url: ctx + "/eform/formdesign/formdesign_main_desgin_formhtml_init.vm?isdesign=true&form_id="+form_id + formParam,// any URL you want to submit
      	//data:$("#formInfo").serialize()// 如果不需要提交整个表单，可构造JSON提交，如{name:'老王',age:50}
      	type:"post",
     	async:false,
       	success:function (json) {
        	if (json && json.length > 0) {
				var jsonData = JSON.parse(json);
				$("#formHtml").html(jsonData.formHtml);
				jdp_eform_onReadyInit();
				jdp_eform_initFileAccept();
				//加载load页面
				jdp_eform_initLoadUrl(form_id, null);
			}
		}
	});
}
//区分单击、双击事件
var isOnDbClick = false;
function selectFormCell(formrow_id,formcell_id, design_model){
	stopEvent();
	isOnDbClick = true;
	$("span").removeClass("selected");
	$("div").removeClass("selected");
	$("li").removeClass("selected");
	$("#cell_" + formcell_id).addClass("selected");
	if(design_model == 'TABLE'){
		jdp_eform_curMouseRightCell = $("#cell_" + formcell_id);
		$(".formTable").removeClass("table_selected");
	}
	window.parent.selectProperties('cell', formrow_id, formcell_id);
	// 重置列的排序
	destoryCellSortable();
	setCellSortable($("#cell_" + formcell_id));
}
function selectFormRow(formrow_id, formcell_id) {
	stopEvent();
	isOnDbClick = false;
	setTimeout(function() {
		if (isOnDbClick) {
			return;
		}
		$("span").removeClass("selected");
		$("div").removeClass("selected");
		$("#row_" + formrow_id).addClass("selected");
		window.parent.selectProperties('row', formrow_id, formcell_id);
		// 重置列的排序
		destoryCellSortable();
	}, 200);
}
//选中子表
function selectTableFormCell(formrow_id, formcell_id, table_formcell_id) {
	stopEvent();
	var index = $("#th_" + formcell_id).prop('cellIndex');
	$("#th_" + formcell_id).closest("table").find("thead tr th").eq(index).css({"border-top": "1px solid red", "border-left": "1px solid red", "border-right": "1px solid red"});
	$("#th_" + formcell_id).closest("table").find("tbody tr").first().children("td").eq(index).css({"border-right": "1px solid red","border-bottom": "1px solid red","border-left": "1px solid red"});
	if(index > 0){
		$("#th_" + formcell_id).closest("table").find("thead tr th").eq(index - 1).css({"border-right": "1px solid red"});
		$("#th_" + formcell_id).closest("table").find("tbody tr").first().children("td").eq(index - 1).css({"border-right": "1px solid red"});
	}
	selectFormCell(formrow_id, formcell_id);
}
//选中表格
function jdp_eform_selectFormTable(){
	if(jdp_eform_curMouseRightCell){
		jdp_eform_curMouseRightCell.closest(".formTable").addClass("table_selected");
	}
	window.parent.selectTableProperties('table');
}
//选中表格单元格
function jdp_eform_selectFormTableTd(td_id, selectType){
	$("#td_" + td_id).addClass("td_selected");
	window.parent.selectTableProperties(selectType, td_id);
}
//选中表格行tr
function jdp_eform_selectFormTableTr(tr_id){
	$("#tr_" + tr_id).addClass("tr_selected");
	window.parent.selectTableProperties("table_tr", tr_id);
}
//选中表格-单元格-控件
function jdp_eform_selectTdCell(cell_id){
	$("span").removeClass("selected");
	$("div").removeClass("selected");
	$("li").removeClass("selected");
	$("#cell_" + cell_id).addClass("selected");
	window.parent.selectProperties('cell', null, cell_id);
}
//设置列的排序
function setCellSortable(obj){
	if($(obj).length == 0){
		return;
	}
	//排序开始时，后面控件id
	var startAfterCellId = null;
	if($(obj).next("span").length > 0){
		startAfterCellId = $(obj).next("span").attr("id").replace(/^cell_/, "");
	}
	//排序开始时，所属行id
	var startRowId = $(obj).parent().attr("id").replace(/^row_/, "");
	//排序结束时，后面控件id
	var endAfterCellId = null;
	//排序结束时，所属行id
	var endRowId = null;
	//设置列可以排序
    $(".form-group.initrow").sortable({
        connectWith: ".form-group.initrow",
        items: "> span",
        cancel: "span:not(.selected)",
        containment: "window",
        tolerance: "pointer",
    	start: function( event, ui ) {
    		//将行上的onmouseover、onmouseout事件去掉，以免影响拖拽时抖动
    		$("#formHtml > div:not(.ui-sortable-placeholder)").each(function(i){
				$(this).removeAttr("onmouseover");
		 		$(this).removeAttr("onmouseout");
		 		$(this).find(".actions-wrapper").hide();
    		});
		},
		stop: function( event, ui ) {
			//将行上的onmouseover、onmouseout事件恢复
    		$("#formHtml > div:not(.ui-sortable-placeholder)").each(function(i){
    			$(this).attr("onmouseover", "rowMouseOver(this);");
		 		$(this).attr("onmouseout", "rowMouseOut(this);");
    		});
    		if($(obj).next("span").length > 0){
    			endAfterCellId = $(obj).next("span").attr("id").replace(/^cell_/, "");
    		}
    		endRowId = $(obj).parent().attr("id").replace(/^row_/, "");
			//移动控件
			if(startRowId != endRowId || startAfterCellId != endAfterCellId){
				window.parent.doMoveCell($(obj).attr("id").replace(/^cell_/, ""), startAfterCellId, endRowId, endAfterCellId);
			}
		}
    }).disableSelection();
}
//将列的排序置为不可用
function destoryCellSortable(){
	$(".form-group.initrow").each(function(){
		if($(this).hasClass("ui-sortable")){
			$(this).sortable("destroy");
			return;
		}
	});
}
//行 DIV的moseover事件
function rowMouseOver(obj){
	$(obj).find(".actions-wrapper").css("display", "block");
	$(obj).css("position", "relative");
}
//行 DIV的moseout事件
function rowMouseOut(obj){
	$(obj).find(".actions-wrapper").css("display", "none");
	$(obj).removeAttr("style");
}
//右键所在控件
var jdp_eform_curMouseRightCell = null;
//右键菜单点击事件
function jdp_eform_mouseRightClick(type, outside){
	$("span.padding_1").each(function(){
		$(this).removeClass("selected");
	});
	$(".table td, .table th").each(function(){
		$(this).css("border", "1px solid #ddd");
	});
	$(".formTable").each(function(){
		$(this).removeClass("table_selected");
	});
	if(outside == null){
		$(".formTable tr").each(function(){
			$(this).removeClass("tr_selected");
		});
		$(".formTable td,.formTable th").each(function(){
			$(this).removeClass("td_selected");
		});
	}
	$('#mouseRightDiv').css('display', 'none');
	if(type == 1){ //选中行
		var row_id = null;
		if(jdp_eform_curMouseRightCell.hasClass("initrow")){
			row_id = jdp_eform_curMouseRightCell.attr("id").replace("row_", "");
		}else{
			row_id = jdp_eform_curMouseRightCell.closest("div.form-group.initrow").attr("id").replace("row_", "");
		}
		selectFormRow(row_id,'');
	}else if(type == 2){ //选中控件
		var row_id = jdp_eform_curMouseRightCell.closest("div.form-group.initrow").attr("id").replace("row_", "");
		var cell_id = null;
		if(jdp_eform_curMouseRightCell.hasClass("padding_1")){
			cell_id = jdp_eform_curMouseRightCell.attr("id").replace("cell_", "");
		}else{
			cell_id = jdp_eform_curMouseRightCell.attr("id").replace("th_", "").replace("td_", "");
			var index = jdp_eform_curMouseRightCell.prop('cellIndex');
			jdp_eform_curMouseRightCell.closest("table").find("thead tr th").eq(index).css({"border-top": "1px solid red", "border-left": "1px solid red", "border-right": "1px solid red"});
			jdp_eform_curMouseRightCell.closest("table").find("tbody tr").first().children("td").eq(index).css({"border": "1px solid red","border-left": "1px solid red"});
			if(index > 0){
				jdp_eform_curMouseRightCell.closest("table").find("thead tr th").eq(index - 1).css({"border-right": "1px solid red"});
				jdp_eform_curMouseRightCell.closest("table").find("tbody tr").first().children("td").eq(index - 1).css({"border-right": "1px solid red"});
			}
		}
		selectFormCell(row_id, cell_id);
	}else if(type == 3){ //选中子表
		var row_id = jdp_eform_curMouseRightCell.closest("div.form-group.initrow").attr("id").replace("row_", "");
		var cell_id = jdp_eform_curMouseRightCell.closest("span.padding_1").attr("id").replace("cell_", "");
		selectFormCell(row_id, cell_id);
	}else if(type == 'select_table'){ //选中表格
		jdp_eform_selectFormTable();
	}else if(type == 'select_table_td'){ //选中表格单元格
		var td_id = jdp_eform_getTableTdId(jdp_eform_curMouseRightCell);
		jdp_eform_selectFormTableTd(td_id, "table_td");
	}else if(type == 'table_td_add_cell'){ //选中添加控件属性
		var td_id = jdp_eform_getTableTdId(jdp_eform_curMouseRightCell);
		jdp_eform_selectFormTableTd(td_id, "td_cell");
	}else if(type == 'table_add_tr'){ //添加行
		var tr_id = jdp_eform_curMouseRightCell.closest("tr.data_tr,tr.title_tr").attr("id").replace("tr_", "");
		jdp_eform_addTableFormRow(tr_id);
	}else if(type == 'table_delete_tr'){ //删除行
		var tr_id = jdp_eform_curMouseRightCell.closest("tr.data_tr").attr("id").replace("tr_", "");
		jdp_eform_deleteTableFormRow(tr_id);
	}else if(type == 'select_table_td_cell'){ //表格-单元格-控件
		var cell_id = jdp_eform_getTableTdCellId(jdp_eform_curMouseRightCell);
		jdp_eform_selectTdCell(cell_id);
	}else if(type == 'table_tr_up'){ //行上移
		var tr_id = jdp_eform_curMouseRightCell.closest("tr.data_tr").attr("id").replace("tr_", "");
		jdp_eform_moveTableFormRow(tr_id, 'up');
	}else if(type == 'table_tr_down'){ //行下移
		var tr_id = jdp_eform_curMouseRightCell.closest("tr.data_tr").attr("id").replace("tr_", "");
		jdp_eform_moveTableFormRow(tr_id, 'down');
	}else if(type == 'table_td_merge'){ //合并单元格
		jdp_eform_mergeTd();
	}else if(type == 'table_tr_properties'){ //行属性设置
		var tr_id = jdp_eform_curMouseRightCell.closest("tr.data_tr,tr.title_tr").attr("id").replace("tr_", "");
		jdp_eform_selectFormTableTr(tr_id);
	}else if(type == 'table_td_cell_left_move'){ //控件向左移
		var cell_id = jdp_eform_getTableTdCellId(jdp_eform_curMouseRightCell);
		jdp_eform_moveTableTdCell(cell_id, 'up');
	}else if(type == 'table_td_cell_right_move'){ //控件向右移
		var cell_id = jdp_eform_getTableTdCellId(jdp_eform_curMouseRightCell);
		jdp_eform_moveTableTdCell(cell_id, 'down');
	}else if(type == 'table_td_cell_move_to'){ //控件移动到
		var cell_id = jdp_eform_getTableTdCellId(jdp_eform_curMouseRightCell);
		jdp_eform_moveTableTdCellTo(cell_id);
	}else if(type == 'sub_table_cell'){ //单元格-子表-列属性
		var row_id = jdp_eform_curMouseRightCell.closest("tr.data_tr").attr("id").replace("tr_", "");
		var cell_id = jdp_eform_curMouseRightCell.attr("id").replace("th_", "").replace("td_", "");
		var index = jdp_eform_curMouseRightCell.prop('cellIndex');
		jdp_eform_curMouseRightCell.closest("table").find("thead tr th").eq(index).css({"border-top": "1px solid red", "border-left": "1px solid red", "border-right": "1px solid red"});
		jdp_eform_curMouseRightCell.closest("table").find("tbody tr").first().children("td").eq(index).css({"border": "1px solid red","border-left": "1px solid red"});
		if(index > 0){
			jdp_eform_curMouseRightCell.closest("table").find("thead tr th").eq(index - 1).css({"border-right": "1px solid red"});
			jdp_eform_curMouseRightCell.closest("table").find("tbody tr").first().children("td").eq(index - 1).css({"border-right": "1px solid red"});
		}
		selectFormCell(row_id, cell_id);
	}else if(type == 'table_td_split'){ //拆分单元格
		var td_id = jdp_eform_getTableTdId(jdp_eform_curMouseRightCell);
		jdp_eform_splitTd(td_id);
	}else if(type == 'table_add_td'){ //添加列
		var td_id = jdp_eform_getTableTdId(jdp_eform_curMouseRightCell);
		jdp_eform_addTableFormTdColumn(td_id);
	}else if(type == 'table_delete_td'){ //删除列
		var td_id = jdp_eform_getTableTdId(jdp_eform_curMouseRightCell);
		jdp_eform_deleteTableFormTdColumn(td_id);
	}
	
	//jdp_eform_curMouseRightCell = null;
	//删除活动状态的td
	$(".formTable td").each(function(){
		$(this).removeClass("active");
	});
}
//获取表格-单元格-控件id
function jdp_eform_getTableTdCellId(jdp_eform_curMouseRightCell){
	var cell_id = null;
	if(jdp_eform_curMouseRightCell[0].tagName != "SPAN"){
		cell_id = jdp_eform_curMouseRightCell.closest("span.padding_1").attr("id").replace("cell_", "");
	}else{
		cell_id = jdp_eform_curMouseRightCell.attr("id").replace("cell_", "");
	}
	return cell_id;
}
//获取表格-单元格id
function jdp_eform_getTableTdId(jdp_eform_curMouseRightCell){
	var td_id = null;
	if((jdp_eform_curMouseRightCell[0].tagName != "TD" && jdp_eform_curMouseRightCell[0].tagName != "TH") || !jdp_eform_curMouseRightCell.attr("cell_index")){
		td_id = jdp_eform_curMouseRightCell.closest("td[cell_index]").attr("id").replace("td_", "");
		
	}else{
		td_id = jdp_eform_curMouseRightCell.attr("id").replace("td_", "");
	}
	return td_id;
}
//右键事件绑定
function jdp_eform_bind_mouseRightEvent(){
	//控件右键
	$("div.form-group.initrow span.padding_1").bind('mousedown', function(e){
		var e = e || window.event;
		if(e.button == 2){
			jdp_eform_show_mouseRightMenu(e, $(this), ["select_cell"], ["select_cell_table", "select_table", "table_td_merge", "table_tr_properties", "select_table_td_cell", "select_table_td", "sub_table_cell"]);
			return false;
		}  
	});
	//行右键
	$("div.form-group.initrow").bind('mousedown', function(e){
		var e = e || window.event;
		if(e.button == 2){
			jdp_eform_show_mouseRightMenu(e, $(this), [], ["select_cell", "select_cell_table", "select_table", "table_td_merge", "table_tr_properties", "select_table_td_cell", "select_table_td", "sub_table_cell"]);
			return false;
		}  
	});
	//子表右键点击
	$("div.form-group.initrow .table th,div.form-group.initrow .table td").bind('mousedown', function(e){
		var e = e || window.event;
		if(e.button == 2){
			if($(this).find("i.fa-plus,i.fa-trash").length == 0){
				jdp_eform_show_mouseRightMenu(e, $(this), ["select_cell", "select_cell_table"], ["select_table", "table_td_merge", "table_tr_properties", "select_table_td_cell", "select_table_td", "sub_table_cell"]);
			}
			return false;
		}  
	});
	//表格-单元格右键点击
	$(".formTable td[id^='td_'][cell_index]").bind('mousedown', function(e){
		var e = e || window.event;
		if(e.button == 2){
			//移动行时禁止右键
			if($("#select_td_id").length > 0){
				return false;
			}
			if($(this)[0].tagName == "TD" && $(this).hasClass("active")){
				jdp_eform_show_mouseRightMenu(e, $(this), ["table_td_merge"], ["select_cell", "select_cell_table", "select_row", "select_table", "table_tr_properties", "select_table_td_cell", "select_table_td", "sub_table_cell"]);
			}else{
				jdp_eform_show_mouseRightMenu(e, $(this), ["select_table", "select_table_td", "table_tr_properties"], ["select_cell", "select_cell_table", "select_row", "table_td_merge", "select_table_td_cell", "sub_table_cell"]);
			}
			return false;
		}else if(e.button == 0){
			$("#mouseRightDiv").css("display", "none");
			//删除活动状态的td
			$(".formTable td").each(function(){
				$(this).removeClass("active");
			});
			if($("#select_td_id").length > 0){
				$("#select_td_id").val($(this).attr("id").replace("td_", ""));
			}
		}  
	});
	//表格-标题单元格右键点击
	$(".formTable th[cell_index]").bind('mousedown', function(e){
		var e = e || window.event;
		if(e.button == 2){
			//移动行时禁止右键
			if($("#select_td_id").length > 0){
				return false;
			}
			jdp_eform_show_mouseRightMenu(e, $(this), ["select_table", "select_table_td", "table_tr_properties"], ["select_cell", "select_cell_table", "select_row", "table_td_merge", "select_table_td_cell", "sub_table_cell"]);
			return false;
		}else if(e.button == 0){
			$("#mouseRightDiv").css("display", "none");
			//删除活动状态的td
			$(".formTable td").each(function(){
				$(this).removeClass("active");
			});
		}  
	});
	//表格-单元格-控件右键点击
	$(".formTable td[cell_index] > span.padding_1").bind('mousedown', function(e){
		var e = e || window.event;
		if(e.button == 2){
			//移动行时禁止右键
			if($("#select_td_id").length > 0){
				return false;
			}
			if($(this).closest("td").hasClass("active")){
				jdp_eform_show_mouseRightMenu(e, $(this), ["table_td_merge"], ["select_cell", "select_cell_table", "select_row", "select_table", "table_tr_properties", "select_table_td_cell", "select_table_td", "sub_table_cell"]);
			}else{
				$("#table_td_cell_dropmenu span.pull-left").html("控件属性");
				$("#select_table_td_cell").html("控件属性");
				jdp_eform_show_mouseRightMenu(e, $(this), ["select_table", "select_table_td", "table_tr_properties", "select_table_td_cell"], ["select_cell", "select_cell_table", "select_row", "table_td_merge", "sub_table_cell"]);
			}
			return false;
		}else if(e.button == 0){
			$("#mouseRightDiv").css("display", "none");
			//删除活动状态的td
			$(".formTable td").each(function(){
				$(this).removeClass("active");
			});
		}  
	});
	
	//表格-子表右键点击
	$(".formTable .table th,.formTable .table td").bind('mousedown', function(e){
		var e = e || window.event;
		if(e.button == 2){
			//移动行时禁止右键
			if($("#select_td_id").length > 0){
				return false;
			}
			$("#table_td_cell_dropmenu span.pull-left").html("子表属性");
			$("#select_table_td_cell").html("子表属性设置");
			jdp_eform_show_mouseRightMenu(e, $(this), ["select_table", "sub_table_cell", "select_table_td_cell", "table_tr_properties"], ["select_cell", "select_cell_table", "select_row", "table_td_merge"]);
			return false;
		}else if(e.button == 0){
			$("#mouseRightDiv").css("display", "none");
			//删除活动状态的td
			$(".formTable td").each(function(){
				$(this).removeClass("active");
			});
		}  
	});
}
//控制右键菜单显示或隐藏
function jdp_eform_show_mouseRightMenu(e, _this, showIds, hideIds){
	$("#mouseRightDiv").css("top", $(document).scrollTop() + e.clientY);
	$("#mouseRightDiv").css("left", $(document).width() - e.clientX < 120 ? $(document).width() - 120 : e.clientX);
	$("#mouseRightDiv").css("display", "");
	
	if($(document).width() - e.clientX < 240){
		var i = $(".ace-icon.fa-caret-right.pull-right");
		i.removeClass("fa-caret-right");
		i.addClass("fa-caret-left");
		$(".dropdown-hover .dropdown-menu").addClass("dropdown-menu-right");
	}else{
		var i = $(".ace-icon.fa-caret-left.pull-right");
		i.removeClass("fa-caret-left");
		i.addClass("fa-caret-right");
		$(".dropdown-hover .dropdown-menu").removeClass("dropdown-menu-right");
	}
	if(showIds && showIds.length > 0){
		for(var i = 0; i < showIds.length; i++){
			if(showIds[i] == "table_td_dropmenu"){//单元格属性
				var table_td = _this.attr("cell_index") ? _this : _this.closest("td[cell_index]");
				if(table_td.attr("colspan") || table_td.attr("rowspan")){
					$("#table_td_split").parent().show();
				}else{
					$("#table_td_split").parent().hide();
				}
			}
			$("#" + showIds[i]).parent().show();
		}
	}
	if(hideIds && hideIds.length > 0){
		for(var i = 0; i < hideIds.length; i++){
			$("#" + hideIds[i]).parent().hide();
		}
	}
	jdp_eform_curMouseRightCell = _this;
}
//添加表格tr
function jdp_eform_addTableFormRow(tr_id){
	var table_cols = parseInt($("#tr_" + tr_id).closest(".formTable").attr("cols"));
	var row_id = null;
	var rowspan = 1;
	$("#tr_" + tr_id).closest(".formTable").find("tr.data_tr,tr.title_tr").each(function(i){
		if(i >= $("#tr_" + tr_id).prevAll().length && $(this).find("td[cell_index][rowspan]").length == 0){
			var curTrCols = jdp_eform_getRowCols($(this));
			if(curTrCols == table_cols){
				row_id = $(this).attr("id").replace("tr_", "");
				return false;
			}
		}
	});
	if(row_id == null){
		row_id = $("#tr_" + tr_id).closest(".formTable").find("tr.data_tr,tr.title_tr").last().attr("id").replace("tr_", "");
	}
	if(tr_id != row_id){
		row_id = $("#tr_" + row_id).prev().attr("id").replace("tr_", "");
	}
	ths.submitFormAjax({
   		url: ctx + "/eform/formdesign/formdesign_main_desgin_addtableformrow.vm",
      	data: {row_id:row_id},
      	type:"post",
     	async:false,
       	success:function (json) {
        	window.parent.refreshFormHtml();
        	jdp_eform_selectFormTableTr(tr_id);
		}
	});
}
//删除表格tr
function jdp_eform_deleteTableFormRow(tr_id){
	var table_cols = parseInt($("#tr_" + tr_id).closest(".formTable").attr("cols"));
	var row_ids = "";
	var trs = $("#tr_" + tr_id).closest(".formTable").find("tr.data_tr,tr.title_tr");
	var startIndex = 0, endIndex = 0;
	for(var i = $("#tr_" + tr_id).prevAll().length; i >= 0; i--){ //向上查找最新tr索引
		var curTrCols = jdp_eform_getRowCols($(trs[i]));
		if(curTrCols == table_cols){
			startIndex = i;
			break;
		}
	}
	for(var i = $("#tr_" + tr_id).prevAll().length + 1; i < trs.length; i++){ //向下查找最新tr索引
		var curTrCols = jdp_eform_getRowCols($(trs[i]));
		if(curTrCols == table_cols){
			endIndex = i;
			break;
		}
	}
	if(endIndex == 0){
		endIndex = trs.length;
	}
	if(startIndex < endIndex){
		for(var i = startIndex; i < endIndex; i++){
			if(row_ids == ""){
				row_ids = $(trs[i]).attr("id").replace("tr_", "");
			}else{
				row_ids += "," + $(trs[i]).attr("id").replace("tr_", "");
			}
		}
	}else{ //删除本行
		row_ids = tr_id;
	}
	ths.submitFormAjax({
   		url: ctx + "/eform/formdesign/formdesign_main_desgin_deletetableformrow.vm",
      	data: {row_ids:row_ids},
      	type:"post",
     	async:false,
       	success:function (json) {
       		window.parent.refreshFormHtml();
       		jdp_eform_selectFormTable();
		}
	});
}
//获取行的列数
function jdp_eform_getRowCols(tr){
	var curTrCols = 0;
	tr.find("td[cell_index]").each(function(){
		if($(this).attr("colspan")){
			curTrCols += parseInt($(this).attr("colspan"));
		}else{
			curTrCols += 1;
		}
	});
	return curTrCols;
}
//移动tr
function jdp_eform_moveTableFormRow(tr_id, type){
	if(type == "up" && $("#tr_" + tr_id).prev().length > 0 && $("#tr_" + tr_id).prev().hasClass("title_tr")){
		return;
	}
	ths.submitFormAjax({
   		url: ctx + "/eform/formdesign/formdesign_main_desgin_movetableformrow.vm",
      	data: {row_id:tr_id, type: type},
      	type:"post",
     	async:false,
       	success:function (json) {
        	window.parent.refreshFormHtml();
        	jdp_eform_selectFormTableTr(tr_id);
		}
	});
}
//单元格控件左移右移
function jdp_eform_moveTableTdCell(cell_id, type){
	ths.submitFormAjax({
   		url: ctx + "/eform/formdesign/formdesign_main_desgin_movetabletdcell.vm",
      	data: {cell_id:cell_id, type: type},
      	type:"post",
     	async:false,
       	success:function (json) {
        	window.parent.refreshFormHtml();
        	var cell_id = jdp_eform_getTableTdCellId(jdp_eform_curMouseRightCell);
    		jdp_eform_selectTdCell(cell_id);
		}
	});
}
//单元格控件移动至
function jdp_eform_moveTableTdCellTo(cell_id){
	dialog({
		id: "select-td-dialog",
	    title: '移动控件',
	    content: '单元格：<input id="select_td_id" placeholder="请选择单元格"/>',
	    wraperstyle:'select-td-info',
	    ok: function () {
	    	var td_id = $("#select_td_id").val();
	    	if(td_id == ""){
	    		return false;
	    	}
	    	if($("#cell_" + cell_id).closest("td").attr("id").replace("td_", "") != td_id){
	    		ths.submitFormAjax({
		       		url: ctx + "/eform/formdesign/formdesign_main_desgin_movetabletdcellto.vm",
		          	data: {cell_id:cell_id, td_id: td_id},
		          	type:"post",
		         	async:false,
		           	success:function (json) {
		            	window.parent.refreshFormHtml();
		            	var cell_id = jdp_eform_getTableTdCellId(jdp_eform_curMouseRightCell);
		        		jdp_eform_selectTdCell(cell_id);
		    		}
		    	});
	    	}
	    },
	    width: 250
	}).show();
}
/* */
function jdp_eform_bind_formTableDraggable(){
	//合并单元格-绑定拖拽事件
	$(".formTable td[cell_index]").draggable({ 
		helper: "",
		start: function( event, ui ) {
			jdp_eform_startTd = event.toElement == null ? $(event.target) : $(event.toElement);
			if(jdp_eform_startTd[0].tagName != "TD"){
				jdp_eform_startTd = $(event.toElement).closest("td");
			}
			jdp_eform_startRowIndex = 0;
			jdp_eform_startCellIndex = 0;
			jdp_eform_endRowIndex = 0;
			jdp_eform_endCellIndex = 0;
		},
		drag: function( event, ui ) {
			var endTd = event.toElement == null ? $(event.originalEvent.target) : $(event.toElement);
			if(endTd[0].tagName != "TD"){
				endTd = endTd.closest("td");
			}
			jdp_eform_activeCell(jdp_eform_startTd, endTd);
		},
		stop: function( event, ui ) {
			startTd = null;
		}
	});
}
/*合并单元格-激活td*/
function jdp_eform_activeCell(startTd, endTd){
	//移动行时禁止合并单元格
	if($("#select_td_id").length > 0){
		return;
	}
	//删除活动状态的td
	startTd.closest(".formTable").find("td").each(function(){
		$(this).removeClass("active");
	});
	if(startTd[0] && startTd[0].tagName == "TD" && endTd[0] && endTd[0].tagName == "TD" && startTd.attr("id") != endTd.attr("id")){
		jdp_eform_startRowIndex = startTd.parent().prevAll().length;
		jdp_eform_startCellIndex = startTd.attr("cell_index");
		jdp_eform_endRowIndex = endTd.parent().prevAll().length;
		jdp_eform_endCellIndex = endTd.attr("cell_index");
		//重新计算合并的结束行、结束列
		startTd.closest(".formTable").find("tr:not(.title_tr)").each(function(){
			var rowIndex = $(this).prevAll().length;
			if(rowIndex >= jdp_eform_startRowIndex && rowIndex <= jdp_eform_endRowIndex){
				$(this).children("td").each(function(){
					var cellIndex = parseInt($(this).attr("cell_index"));
					if(cellIndex >= jdp_eform_startCellIndex && cellIndex <= jdp_eform_endCellIndex){
						if($(this).attr("rowspan") && jdp_eform_endRowIndex < (rowIndex + parseInt($(this).attr("rowspan")) - 1)){
							jdp_eform_endRowIndex = rowIndex + parseInt($(this).attr("rowspan")) - 1;
						}
						if($(this).attr("colspan") && jdp_eform_endCellIndex < (cellIndex + parseInt($(this).attr("colspan")) - 1)){
							jdp_eform_endCellIndex = cellIndex + parseInt($(this).attr("colspan")) - 1;
						}
					}
				});
			}
		});
		//单元格选中状态
		startTd.closest(".formTable").find("tr:not(.title_tr)").each(function(){
			var rowIndex = $(this).prevAll().length;
			if(rowIndex >= jdp_eform_startRowIndex && rowIndex <= jdp_eform_endRowIndex){
				$(this).children("td").each(function(){
					var cellIndex = parseInt($(this).attr("cell_index"));
					if(cellIndex >= jdp_eform_startCellIndex && cellIndex <= jdp_eform_endCellIndex){
						$(this).addClass("active");
					}
				});
			}
		});
	}
}
/*合并单元络*/
var jdp_eform_startRowIndex = 0, jdp_eform_startCellIndex = 0, jdp_eform_endRowIndex = 0, jdp_eform_endCellIndex = 0;
var jdp_eform_startTd;
function jdp_eform_mergeTd(){
	var mergeTd = null, deleteIds = [], merge_rowspan = 0, merge_colspan = 0;
	var curRow = null;
	$(".formTable td.active").each(function(i){
		if(i == 0){
			mergeTd = $(this);
			merge_colspan = $(this).attr("colspan") ? parseInt($(this).attr("colspan")) : 1;
			merge_rowspan = $(this).attr("rowspan") ? parseInt($(this).attr("rowspan")) : 1;
		}else{
			if($(this).closest("tr").attr("id") == mergeTd.closest("tr").attr("id")){
				merge_colspan += $(this).attr("colspan") ? parseInt($(this).attr("colspan")) : 1;
			}
			if($(this).closest("tr").attr("id") != curRow.attr("id")){
				merge_rowspan += $(this).attr("rowspan") ? parseInt($(this).attr("rowspan")) : 1;
			}
			deleteIds.push($(this).attr("id").replace("td_", ""));
		}
		curRow = $(this).closest("tr");
	});
	if(deleteIds.length > 0){ //合并
		ths.submitFormAjax({
	   		url: ctx + "/eform/formdesign/formdesign_main_desgin_mergeTd.vm",
	   		traditional: true,
	      	data: {merge_id:mergeTd.attr("id").replace("td_", ""), rowspan: merge_rowspan, colspan: merge_colspan, deleteIds: deleteIds},
	      	type:"post",
	     	async:false,
	       	success:function (json) {
	       		window.parent.refreshFormHtml();
	       		jdp_eform_selectFormTable();
			}
		});
	}
}
/*拆分单元格*/
function jdp_eform_splitTd(td_id){
	ths.submitFormAjax({
   		url: ctx + "/eform/formdesign/formdesign_main_desgin_splitTd.vm",
   		traditional: true,
      	data: {td_id: td_id},
      	type:"post",
     	async:false,
       	success:function (json) {
       		window.parent.refreshFormHtml();
    		jdp_eform_selectFormTableTd(td_id, "table_td");
		}
	});
}
/*表格添加列*/
function jdp_eform_addTableFormTdColumn(td_id){
	ths.submitFormAjax({
   		url: ctx + "/eform/formdesign/formdesign_main_desgin_addTdColumn.vm",
   		traditional: true,
      	data: {tdId: td_id},
      	type: "post",
     	async: false,
       	success: function (json) {
       		window.parent.refreshFormHtml();
    		jdp_eform_selectFormTableTd(td_id, "table_td");
		}
	});
}
/*表格删除列*/
function jdp_eform_deleteTableFormTdColumn(td_id){
	ths.submitFormAjax({
   		url: ctx + "/eform/formdesign/formdesign_main_desgin_deleteTdColumn.vm",
   		traditional: true,
      	data: {tdId: td_id},
      	type: "post",
     	async: false,
       	success: function (json) {
       		if(json == "success"){
       			window.parent.refreshFormHtml();
       			jdp_eform_selectFormTable();
       		}else{
       			dialog({
       	            title: '提示',
       	            content: json,
       	            wraperstyle:'alert-info',
       	            ok: function () {}
       	        }).showModal();
       		}
		}
	});
}
/*页面加载完成后，初始化调用函数*/
function jdp_eform_onReadyInit(){
	jdp_eform_bind_mouseRightEvent();
	jdp_eform_bind_formTableDraggable();
}

$(function(){
	// 表单验证组件初始化，详细文档请参考http://code.ciaoca.com/jquery/validation-engine/
	// 或官网文档http://posabsolute.github.io/jQuery-Validation-Engine/
	//设置行可以排序
	var rowStartIndex = 0;
	var rowEndIndex = 0;
	$("#formHtml").sortable({
		axis: "y",
		items: "div.form-group.initrow",
		start: function( event, ui ) {
		 	$("#formHtml > div:not(.ui-sortable-placeholder)").each(function(i){
		 		$(this).removeAttr("onmouseover");
		 		$(this).removeAttr("onmouseout");
		 		$(this).find(".actions-wrapper").hide();
				if($(ui.item).attr("id") == $(this).attr("id")){
					rowStartIndex = i;
				}
			});
		},
		stop: function( event, ui ) {
			$("#formHtml > div:not(.ui-sortable-placeholder)").each(function(i){
				$(this).attr("onmouseover", "rowMouseOver(this);");
		 		$(this).attr("onmouseout", "rowMouseOut(this);");
				if($(ui.item).attr("id") == $(this).attr("id")){
					rowEndIndex = i;
				}
			});
			//移动行
			if(rowEndIndex != rowStartIndex){
				var rowId = $(ui.item).attr("id");
				window.parent.doMoveRow(rowId.substring(rowId.indexOf("_") + 1), rowEndIndex - rowStartIndex);
			}
		}
	});
    $("#formHtml").disableSelection();
    
    jdp_eform_onReadyInit();
	$(document).bind('click', function(e){
		if(e.button == 1){
			$("#mouseRightDiv").css("display", "none");
			jdp_eform_curMouseRightCell = null;
		}
	});
});
			
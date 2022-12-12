//关闭对话框
function closeDialog(){
	  dialog.get("dialog-ID").close().remove();
}

//办理人－多选人
var selectUsers=[];
function showUsersSelect(){
	//dialog的使用，请参考官方文档http://aui.github.io/artDialog/doc/index.html
	dialog({
		id:"dialog-ID",
        title: '选择',
        url: ctx+'/common/ou/selUserMuti.html',
        width:800,
        height:500
    }).showModal();
}

//多选人回调
function userSelectMutiCallBack(users){
    selectUsers = users;//这行代码一定要写，用于二次打开选择人Dialog的已选中数据回显
    var show_user = "";
    var show_user_name = "";
    var show_user_title = "";
    $.each(users,function(i){
    	if(show_user!=''){
    		show_user_name = show_user_name+",";
    		show_user = show_user+",";
    		show_user_title = show_user_title +"\r\n";
    	}
    	show_user = show_user+"{≈id≈:≈"+this.loginName+"≈,≈name≈:≈"+this.name+"≈}";
    	show_user_name = show_user_name+this.name;
    	show_user_title = show_user_title+this.name;
    });
    window.designProperties.document.all.show_user.value = show_user;
    window.designProperties.document.all.show_user_name.value = show_user_name;
    window.designProperties.document.all.show_user_name.title = show_user_title;
 }

//办理人－多选部门
var selectDepts;
function showDeptsSelect(){
	dialog({
		id:"dialog-ID",
        title: '选择',
        url: ctx+'/common/ou/treeDeptMuti.html',
        width:300,
        height:500
    }).showModal();
}

//多选部门回调
function deptSelectMutiCallBack(depts){
	var show_dept = "";
    var show_dept_name = "";
    var show_dept_title = "";
	$.each(depts,function(i){
		selectDepts = selectDepts+this.id+",";
		if(show_dept!=''){
    		show_dept_name = show_dept_name+",";
    		show_dept = show_dept+",";
    		show_dept_title = show_dept_title +"\r\n";
    	}
		show_dept = show_dept+"{≈id≈:≈"+this.id+"≈,≈name≈:≈"+this.name+"≈}";
		show_dept_name = show_dept_name+this.name;
		show_dept_title = show_dept_title+this.name;
    });
	 window.designProperties.document.all.show_dept.value = show_dept;
	 window.designProperties.document.all.show_dept_name.value = show_dept_name;
	 window.designProperties.document.all.show_dept_name.title = show_dept_title;
}


//选择流程分类
function showCategorySelect(){
	dialog({
		id:"dialog-category-select",
        title: '选择',
        url: ctx + '/eform/tree/window.vm?sqlpackage=ths.jdp.bpm.dao.category.CategoryMapper&mapperid=tree&callback=diaCatSelCallback&loginName=' + loginName,
        width:300,
        height:400
    }).showModal();
}

//选择流程分类回调
function diaCatSelCallback(node){
	window.designProperties.document.all.categoryId.value = node.TREE_ID;
	window.designProperties.document.all.categoryName.value = node.TREE_NAME;
	dialog.get("dialog-category-select").close().remove();
}


//办理人--选择角色
var selectRoles;
function showRolesSelect(){
	dialog({
		id:"dialog-ID",
        title: '选择',
        url: ctx+'/common/ou/treeRoleMuti.html',
        width:300,
        height:500
    }).showModal();
}

//选择角色回调
function roleSelectMutiCallBack(roles){
	var show_role = "";
    var show_role_name = "";
    var show_role_title = "";
	$.each(roles,function(i){
		selectRoles = selectRoles+this.id+",";
		if(show_role!=''){
    		show_role_name = show_role_name+",";
    		show_role = show_role+",";
    		show_role_title = show_role_title +"\r\n";
    	}
		show_role = show_role+"{≈id≈:≈"+this.id+"≈,≈name≈:≈"+this.name+"≈}";
		show_role_name = show_role_name+this.name;
		show_role_title = show_role_title+this.name;
    });
	 window.designProperties.document.all.show_role.value = show_role;
	 window.designProperties.document.all.show_role_name.value = show_role_name;
	 window.designProperties.document.all.show_role_name.title = show_role_title;
}

//办理人--选择岗位
var selectPositions;
function showPositionSelect(){
	dialog({
		id:"dialog-ID",
      title: '选择',
      url: ctx+'/common/ou/selPositionMuti.html',
      width:300,
      height:500
  }).showModal();
}

//选择岗位回调
function positionSelectMutiCallBack(positions){
	var show_position = "";
	var show_position_name = "";
	var show_position_title = "";
	$.each(positions,function(i){
		selectPositions = selectPositions+this.id+",";
		if(show_position!=''){
  		show_position_name = show_position_name+",";
  		show_position = show_position+",";
  		show_position_title = show_position_title +"\r\n";
  	}
		show_position = show_position+"{≈id≈:≈"+this.id+"≈,≈name≈:≈"+this.name+"≈}";
		show_position_name = show_position_name+this.name;
		show_position_title = show_position_title+this.name;
  });
	 window.designProperties.document.all.show_position.value = show_position;
	 window.designProperties.document.all.show_position_name.value = show_position_name;
	 window.designProperties.document.all.show_position_name.title = show_position_title;
}


//办理人－－多选群组
var selectGroups=[];
function showGroupsSelect(){
	dialog({
		id:"dialog-ID",
      title: '选择',
      url: ctx+'/common/ou/selGroupMuti.html',
      width:800,
      height:500
  }).showModal();
}

//多选群组回调
function groupSelectMutiCallBack(groups){
  selectGroups = groups;
  var show_group = "";
  var show_group_name = "";
  var show_group_title = "";
  $.each(groups,function(i){
  	if(show_group!=''){
  		show_group_name = show_group_name+",";
  		show_group = show_group+",";
  		show_group_title = show_group_title +"\r\n";
  	}
  	show_group = show_group+"{≈id≈:≈"+this.id+"≈,≈name≈:≈"+this.name+"≈}";
  	show_group_name = show_group_name+this.name;
  	show_group_title = show_group_title+this.name;
  });
  window.designProperties.document.all.show_group.value = show_group;
  window.designProperties.document.all.show_group_name.value = show_group_name;
  window.designProperties.document.all.show_group_name.title = show_group_title;
}



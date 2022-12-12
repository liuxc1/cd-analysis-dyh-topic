	
var propertyDialog;
var _o_props_this;
var _text_this;
var _img_this;
function openProperty(_o,_o_props,_text, _src, _img){
	//console.log(_o_props);
	$("#myflow_props_custom").css("right",50);
	$("#myflow_props_custom").css("top",30); 
	if(_o_props_this==_o_props){
		$("#myflow_props_custom").show(300);
		return;
	}
	$('#myflow_props').hide();
	var pro_size=0;
	_img_this = _img;
	_o_props_this = _o_props; //属性对象
	_text_this = _text; //显示名称
	 	var thisProJsonArr=new Array();
	 	for ( var p in _o_props ){ // 方法 
			 var thisProJson = {
				      label : '',
				      name : '',
				      value : ''
				     };
			  if (typeof(_o_props[p]) == "function"){
				  //obj [ p ]() ; 
			  } else { // p 为属性名称，obj[p]为对应属性的值 
				  if(_o_props[p]&&_o_props[p].name){
					  thisProJson.label = _o_props[p].label;
					  thisProJson.name = _o_props[p].name;
					  thisProJson.value = _o_props[p].value;
					  //增加属性扩展（lixinda 2017-04-07）
					  if(_o_props[p].type){
						  thisProJson.type = _o_props[p].type;
					  }
					  if(_o_props[p].readonly){
						  thisProJson.readonly = _o_props[p].readonly;
					  }
					  if(_o_props[p].validate){
						  thisProJson.validate = _o_props[p].validate;
					  }
					  if(_o_props[p].onclick){
						  thisProJson.onclick = _o_props[p].onclick;
					  }
					  thisProJsonArr.push(thisProJson);
					  pro_size = pro_size+1;
				  }
			  } 
		 } // 最后显示所有的属性 
		document.getElementById('designProperties_o_props').value = JSON.stringify(thisProJsonArr);
		var objtype = "";
	 	if(_o==null){
	 		objtype = "_document";
	 	}else if(_o.type=='task'){
	 		objtype = "_task";
		}else if(_o.type=='fork'||_o.type=='join'||_o.type=='start'||_o.type=='end'){
	 		objtype = "";
		}else if(_src.from&&_src.to){
			objtype = "_path";
		}else if(_o.type=='subprocess'){
			objtype = "_subprocess";
		}
	 	document.getElementById('designProperties_o_type').value = objtype;
		document.designPropertiesForm.submit();
	var pro_size_height = pro_size*30+80;
	$("#myflow_props_custom").width("350px");
	$("#myflow_props_custom").show(300);
}

function deletePro(){
	$(document).trigger('keydown',true);
}

function getUuid(){
	 var tmp = (new Date()).valueOf();
	  return tmp; 
}  

function setHiddenProps(){
	$('#myflow_props').hide();
	$('#myflow_props_custom').hide();
}
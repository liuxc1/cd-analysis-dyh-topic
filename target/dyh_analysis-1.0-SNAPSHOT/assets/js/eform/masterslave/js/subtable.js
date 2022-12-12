
function initRow(tableid,trid,initrownum,addrownum){
	var trLen =  $("#"+tableid).find("tr").length;
	if(trLen==initrownum){
		for (var i=0;i<addrownum;i++){
			addRow(tableid,trid);
		}
	}
}


function addRow(tableid,trid){
	var newRow = $("#"+trid+"").clone();//克隆行
	newRow.show();//将行的隐藏属性去掉
	newRow.find("select,input,textarea").attr("disabled",false);
	//根据规则设置控件的值
	var generatorInputs = newRow.find("[generator]");
	generatorInputs.each(function(){
		var generatorValue = $(this).attr("generator");
		var generatorJson = $.parseJSON(generatorValue);
		//var generatorJson = eval("("+generatorValue+")");
		if(generatorJson.classtype=='uuid'){
			$(this).val(generateUUID());
		}else if(generatorJson.classtype=='form'){
			var formId = generatorJson.formid;
			var formIdValue =  $("#"+formId+"").val();
			$(this).val(formIdValue);
		}
	});
	//重写控件的name值
	var multirowtable = newRow.find("[name^='multirowtable']");
	var trLen =  $("#"+tableid).find("tr").length+1;
		multirowtable.each(function(){
			var multirowName = $(this).attr("name");
			multirowName = multirowName.replace(/.row\[index\]/,'.row['+trLen+']');
			$(this).attr("name",multirowName);
		});
	
	$("#"+tableid+" tr:last").after(newRow);
}

function deleteRow(thisObj){
	var curRow = $(thisObj).closest("tr");
	curRow.hide();
	var multirowtable = curRow.find("[name^='multirowtable']");
	multirowtable.each(function(){
		var hidenValue = '$hidden'+$(this).val()+'$hidden';
		$(this).val(hidenValue);
	});
}

//参数说明：str表示原字符串变量，flg表示要插入的字符串，sn表示要插入的位置
function insert_flg(str,flg,sn){
     var newstr="";
     if(str.length>sn){
    	 newstr = str.substring(0, sn)+flg+str.substring(sn, str.length);
     }else{
    	 newstr = str+flg;
     }
     return newstr;
 }

//选择框相关函数begin 
var treeDialog;
function closeTreeDialog(){
	treeDialog.close().remove();
}



//下拉框
function getInput(obj){
	var name=$(obj).next().prop("name");	
	if($(obj).val()=='99'){
		$(obj).css('width','50%');
		$(obj).nextAll().remove();
		$(obj).after('<input type=\"text\" class=\"input_border_1\" name='+name+' value=\"\" style=\"width:48%\"  data-validation-engine=\"validate[required,maxSize[33]\"/>');
	}else{
		$(obj).css('width','100%');
		$(obj).nextAll().remove();
		$(obj).after('<input type=\"hidden\" class=\"input_border_1\" name='+name+' value=\"\"  style=\"width:50%\" />');
	}
	
}

//合并单元格列
function _w_table_rowspan(_w_table_id,_w_table_colnum){
    _w_table_firsttd = "";
    _w_table_currenttd = "";
    _w_table_SpanNum = 0;
    _w_table_Obj = $(_w_table_id + " tr td:nth-child(" + _w_table_colnum + ")");
    _w_table_Obj.each(function(i){
        if(i==0){
            _w_table_firsttd = $(this);
            _w_table_SpanNum = 1;
        }else{
            _w_table_currenttd = $(this);
            if(_w_table_firsttd.text().replace(/(^\s*)|(\s*$)/g, "")==_w_table_currenttd.text().replace(/(^\s*)|(\s*$)/g, "")){
                _w_table_SpanNum++;
                _w_table_currenttd.hide(); //remove();
                _w_table_firsttd.attr("rowSpan",_w_table_SpanNum);
            }else{
                _w_table_firsttd = $(this);
                _w_table_SpanNum = 1;
            }
        }
    }); 
}


//合计
function sum(html_id,hj_,input_type){
	var tableLength = $("#"+html_id+" tr").length - 1;//获取表格数据行数
	//console.log(tableLength);
	for(var i=0;i<tableLength;i++){//循环tr
		var trObj = jQuery("#"+hj_+i).parent().parent();//获取一行tr
		var tds = trObj.find(input_type);//获取tds
		var sum = 0;
		for(var j=0;j<tds.length;j++){//循环tds
			if(tds[j].value != ''){
				var val = tds[j].value;
				val  = val.replace(",","");
				sum += parseFloat(val);//循环相加一行数据
			}
		}
		if (!isNaN(sum)) {
			sum = sum.toFixed(2); 
		}
		jQuery("#"+hj_+i).html(sum);//赋值
	}
}

//设置触发事件
function setRowBlur(html_id,hj_,input_type){
	var tableLength = $("#"+html_id+" tr").length - 1;//获取表格数据行数
	for(var i=0;i<tableLength;i++){//循环tr
		var trObj = jQuery("#"+hj_+i).parent().parent();//获取一行tr
		var tds = trObj.find(input_type);//获取tds
		for(var j=0;j<tds.length;j++){//循环tds
			var a = "sum(\""+html_id+"\",\""+hj_+"\",\""+input_type+"\");";
			//console.log(a);
			jQuery(tds[j]).attr("onblur",a);
		}
	}
}

//模版页面合计
function modelsum(html_id,hj_,input_type){
	
		var trObj = jQuery("#"+hj_).parent().parent();//获取一行tr
		var tds = trObj.find(input_type);//获取tds
		//console.log(tds);
		//console.log("-modelsum-tds-->>"+tds[0].value);
		var sum = 0;
		for(var j=0;j<tds.length;j++){//循环tds
			console.log("-modelsum-tds-->>"+$(tds[j]).val());
			if(tds[j].value != ''){
				sum += parseFloat(tds[j].value);//循环相加一行数据
			}
		}
		//console.log("----modelsum---sum---<>>>"+sum);
		jQuery("#"+hj_).html(sum);//赋值

}
//模版页面设置触发事件
function setModelRowBlur(html_id,hj_,input_type){
	var tableLength = $("#"+html_id+" tr").length - 1;//获取表格数据行数
	for(var i=0;i<tableLength;i++){//循环tr
		var trObj = jQuery("#"+hj_).parent().parent();//获取一行tr
		var tds = trObj.find(input_type);//获取tds
		for(var j=0;j<tds.length;j++){//循环tds
			var a = "modelsum(\""+html_id+"\",\""+hj_+"\",\""+input_type+"\");";
			//console.log("a-setModelRowBlur---a>>>>"+a);
			jQuery(tds[j]).attr("onblur",a);
		}
	}
}
//表单页面提交时执行的提交方法
function submitCustom(url,state){
	if(state!=null && state!=undefined && state == '2'){
		if ($('#formInfo').validationEngine('validate')) {
			ths.submitFormAjax(
					{
						url:url,
						data:$("#formInfo").serialize(),
						success:function (response) {
							console.log(response);
							dialog({
								title: '信息',
								content: response,
								ok: function () {
									if(state==2){
										self.opener.location.reload();
										window.close();
									}else if(state == 1){
										location=location ;
									}
								}
							}).showModal();
						}
					}
			);
		}
	}else{
		ths.submitFormAjax(
				{
					url:url,
					data:$("#formInfo").serialize(),
					success:function (response) {
						console.log(response);
						dialog({
							title: '信息',
							content: response,
							ok: function () {
								if(state==2){
									//		self.opener.location.href=self.opener.location.href; 
									/*	self.opener.location.reload();  */
									window.close();
								}else if(state == 1){
									location=location ;
								}
							}
						}).showModal();
					}
				}
		);
	}
}

//提交时弹出备注页面
function openRemark(url,id){
	dialog({
		id:"dialog-remark",
        title: '备注',
        url: url+'?enterID='+id,
        width:500,
        height:280>document.documentElement.clientHeight?document.documentElement.clientHeight:280
    }).showModal();
	return false;
}

function closeRemarkDialog(){
	dialog.get("dialog-remark").close().remove();
}
$(function(){
	$.validationEngineLanguage.allRules.greaterInteger= {
			//Integer: >=0
        	"regex" : /^(([1-9]\d*|0)|(\u65e0))$/,
        	"alertText" : "* 只能填无或大于等于0的整数数字"
	};
	$.validationEngineLanguage.allRules.greaterNumber= {
			 // Number: >=0
            "regex": /^([1-9]\d*(\.\d+)?|[0]{1}(\.\d+)?|(\u65e0))$/,
            "alertText": "* 只能填写无或不小于0的数目"
	};
	
})
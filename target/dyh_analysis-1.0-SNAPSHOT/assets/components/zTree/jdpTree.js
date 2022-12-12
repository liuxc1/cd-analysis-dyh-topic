/**
 * 此文件不要移动位置 如果必须要移动位置修改jdpTreeGlobal.baseurl的自动赋值语句
 */

var jdpTreeObject;

function jdpTreeInit() {
	$("script").each(function(index, element) {
		var src = $(element).attr("src");
		if (typeof (src) != "undefined") {
			var jsFile = src.substring(src.length - 10);
			if ("jdpTree.js" == jsFile) {
				var splitindex = src.lastIndexOf("/");
				if (splitindex == -1) {
					refFile(".");
				} else {
					var head = src.substring(0, splitindex);
					refFile(head);
				}

				var serverurl = src.substring(0, src.lastIndexOf("assets/"));
				jdpTreeObject.baseurl = serverurl

			}
		}
	})
	jdpTreeObject.isinit = true;
}

function refFile(head){
	
	$.ajax({url : head + "/js/jquery.ztree.core.js",cache : true,async : false,dataType : "script",});
	$.ajax({url : head + "/js/jquery.ztree.excheck.js",cache : true,async : false,dataType : "script",});
	$("head").append("<link>");
	css = $("head").children(":last");
	css.attr({rel : "stylesheet",type : "text/css",href : head + "/css/metroStyle/metroStyle.css"});

	$("head").append("<link>");
	css = $("head").children(":last");
	css.attr({rel : "stylesheet",type : "text/css",href : head + "/css/zTreeStyle/zTreeStyle.css"});
}

function JdpTree(zTree){
	  this.zTree = zTree;
	  this.nodes=function(){
		  var parent=null;
		  if(typeof (parent) != "undefined"){
			  parent=arguments[0];
		  }
		  return this.zTree.getNodesByFilter(function(){return true}, false, parent,null);
	  };
	  this.selectedNodes=function(){
		  var checked=arguments[0];
		  if(typeof (checked) == "undefined"){
			  checked=true
		  }
		  return this.zTree.getCheckedNodes(checked)
	  };
	  this.getNodeById=function(id){
		  function filter(node) {
			  return (id==node.id);
		  }
		  return this.zTree.getNodesByFilter(filter, true); // 仅查找一个节点
	  };
	  this.refresh=function(node){
		  this.zTree.reAsyncChildNodes(node,"refresh");
	  };
}

$.fn.jdpTree = function() {
	if (typeof (jdpTreeObject) == "undefined") {
		jdpTreeObject = new Object();
	}
	if (typeof (jdpTreeObject.isinit) == "undefined") {
		jdpTreeInit();
	}
	
	var setting={
			async : {
				enable : true,
				url : jdpTreeObject.baseurl + "JdpTree/getNodes.vm",
				autoParam : ["id"],
				otherParam:{showRoot:false},
			}
		};

	if (arguments[0] && Object.prototype.toString.call(arguments[0]) == '[object Function]'){
		setting.callback = {
			onClick : arguments[0]
		}
	}else if(arguments[0]){
		var userSetting=arguments[0];
		if(typeof (userSetting.url) != "undefined"){
			setting.async.url=userSetting.url;
		}
		if(typeof (userSetting.parentId) != "undefined"){
			setting.async.otherParam.parentId=userSetting.parentId;
		}
		if(typeof (userSetting.showRoot) != "undefined" && userSetting.showRoot){
			setting.async.otherParam.showRoot=true;
		}
		
		if(typeof (userSetting.singleSelect) != "undefined"){
			if(typeof (setting.check) == "undefined"){
				setting.check=new Object();
			}
			if(userSetting.singleSelect){
				setting.check.radioType = "level";				
			}else{
				setting.check.enable=true;
				setting.check.chkboxType = { "Y" : "ps", "N" : "ps" };
			}
		}
		if(typeof(userSetting.onClick) != "undefined"){
			if(typeof (setting.callback) == "undefined"){
				setting.callback=new Object();
			}
			setting.callback.onClick = userSetting.onClick;
		}
	}
	this.addClass("ztree");
	var zTree=$.fn.zTree.init(this, setting);
	var jdpTree = new JdpTree(zTree);
	return jdpTree;
}

$.extend({metaData:function(id,func,page,pageSize){
	if (typeof (jdpTreeObject) == "undefined") {
		jdpTreeObject = new Object();
	}
	if (typeof (jdpTreeObject.isinit) == "undefined") {
		jdpTreeInit();
	}
	
	$.post(jdpTreeObject.baseurl + "JdpTree/mateData.vm",{"id":id,"page":page,"pageSize":pageSize},function(json){
		func(json);
	},"json");
}});
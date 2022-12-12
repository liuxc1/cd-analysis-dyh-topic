var config = {};

//组织用户管理系统的访问地址，http://{ip}:{port}/{context}
config.ou_server_url = "http://182.48.115.108:7070/ou";

//根部门ID，也是根组织ID
config.root_ou_id = "root";

//皮肤初始化
$(function(){
	//注:因此段代码是页面加载完后执行,如果页面加载速度慢,会导致切换皮肤慢.为了提交用户体验,建议在body中直接写上<body class="${THS_SKIN}">
	if(window.parent && window.top != window.self && window.parent.location.origin == window.location.origin){ //判断为嵌套页面，并且处在相同域，继承父页面皮肤
		$(window.document.body).attr("class", $(window.parent.document.body).attr("class"));
	}
});
//皮肤设置
function ths_skin_setting(skin, flag){
	//设置body皮肤
	var bodySkin = skin;
	if(bodySkin != "no-skin"){
		bodySkin = "no-skin " + bodySkin;
	}
	$(document.body).attr("class", bodySkin);
	$("iframe").each(function(i){
		if(window.frames[i].window.location.origin == window.location.origin && window.frames[i].window.ths_skin_setting){ //判断当前页面与子页面处在相同域，继承当前页面皮肤
			window.frames[i].window.ths_skin_setting(skin);
		}
	});
}

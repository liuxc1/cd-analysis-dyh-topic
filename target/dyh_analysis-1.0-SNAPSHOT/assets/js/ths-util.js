//require artDialog 6.x

var ths={};
//获取URL参数
ths.getUrlParam = function(name)
{
	var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
	var r = window.location.search.substr(1).match(reg);
	if(r!=null)return  unescape(r[2]); return null;
}
/**
 * bind 事件
 * el 元素
 * eventName 事件名称
 * fn 函数
 */
ths.bind=function(el,eventName,fn) { 
    if (window.addEventListener) { 
        	el.addEventListener(eventName, fn,false); 
    } else if (window.attachEvent) { 
            el.attachEvent("on" + eventName, fn); 
    }  
}

String.prototype.trim=function()
{
	return this.replace(/(^\s*)|(\s*$)/g,'');
}

Array.prototype.indexOf = function (val) {
	for (var i = 0; i < this.length; i++) {
		if (this[i] == val) {
			return i;
		}
	}
	return -1;
};
/**
 * 从数组中移除指定元素
 */
Array.prototype.remove = function (val) {
	var index = this.indexOf(val);
	if (index > -1) {
		this.splice(index, 1);
	}
};
/*
 *  方法:Array.removeAt(index)
 *  功能:根据元素位置值删除数组元素.
 *  参数:元素值
 *  返回:在原数组上修改数组
 */
Array.prototype.removeAt = function (index) {
	if (isNaN(index) || index > this.length) {
		return false;
	}
	for (var i = 0, n = 0; i < this.length; i++) {
		if (this[i] != this[index]) {
			this[n++] = this[i];
		}
	}
	this.length -= 1;
};

/**
 * 针对get请求url中的特殊字符编码，目前对'['和']'进行编码
 */
var specialCharacter = ['[',']'];
ths.urlEncode4Get = function (url){
	if(!url){
		return "";
	}
	for(var i = 0;i<specialCharacter.length;i++){
		var reg = new RegExp("\\"+specialCharacter[i],"g");
		url = url.replace(reg,encodeURI(specialCharacter[i]));
	}
	return url;
}

window.console = window.console || (function(){
		var c = {};
		c.log = c.warn = c.debug = c.info = c.error = c.time = c.dir = c.profile = c.clear = c.exception = c.trace = c.assert = function(){};
		return c;
	})();
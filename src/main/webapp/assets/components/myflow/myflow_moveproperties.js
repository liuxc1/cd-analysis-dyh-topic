var _move=false;//移动标记
var _x,_y;//鼠标离控件左上角的相对位置
$(document).ready(function(){
 $("#myflow_props_custom").click(function(){
 //alert("click");//点击（松开后触发）
}).mousedown(function(e){
 _move=true;
 _x=e.pageX-parseInt($("#myflow_props_custom").css("left"));
 _y=e.pageY-parseInt($("#myflow_props_custom").css("top"));
 //$("#myflow_props_custom").fadeTo(20, 0.25);//点击后开始拖动并透明显示
});
 $(document).mousemove(function(e){
 if(_move){
 var x=e.pageX-_x;//移动时根据鼠标位置计算控件左上角的绝对位置
var y=e.pageY-_y;
 $("#myflow_props_custom").css({top:y,left:x});//控件新位置
}
 }).mouseup(function(){
 _move=false;
 $("#myflow_props_custom").fadeTo("fast", 1);//松开鼠标后停止移动并恢复成不透明
});
 });


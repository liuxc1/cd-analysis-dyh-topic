<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
<head>
 <!--[if !IE]> -->
	<script src="${ctx}/assets/components/jquery/dist/jquery.js"></script>
	<!-- <![endif]-->
	<!--[if IE]>
	<script src="${ctx}/assets/components/jquery.1x/dist/jquery.js"></script>
	<![endif]-->
<script type="text/javascript">
//监听父亲页面的换皮肤时间
window.addEventListener('message',function(e){
       var message = e.data;
       if(message){
	       	messageJson = JSON.parse(message);
	       	var messageType = messageJson.messageType;
	       	var currentSkin = messageJson.currentSkin;
	       	if(messageType=="command"&&currentSkin){
	       		//修改session用户对象皮肤
	       		var skin = currentSkin.replace("no-skin ",""); 
	   			try{
	   					$.ajax({
	   						type : 'post',
	   						async: false,
	   			    		url : "${ctx}/notice/user/skin/reset.vm",
	   			    		data : {"skin": skin},
	   			    		success : function(data) {
	   			    		},
	   			    		error : function(error,content,value) {
	   			    		}
	   					}); 
	   			}catch(ex){}
	       	}
       }
   },false);

</script>
  
</head>

</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
	<script type="text/javascript" src="${ctx}/assets/components/sockjs/dist/sockjs.js"></script>
</head>
<body>
</body>

<script type="text/javascript">	
	var socketServer="<%=ths.jdp.core.context.PropertyConfigure.getProperty("jdp.socket.server")%>";
	var useSockJs="<%=ths.jdp.core.context.PropertyConfigure.getProperty("jdp.socket.sockJs.enabled")%>";
	if(!socketServer || socketServer=="null" || socketServer==""){
    	socketServer="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}";
    }
	var socketPrefix="/websocket";
	var sockJsEndPoint = "/initSocket";
	var wsEndPoint = "/ws";
	ths.initSocket=function(customCode,receiveCallback,closeCallback){
   		var socket;
   		try{
   			if('WebSocket' in window && useSockJs=="false"){
   				socket=new WebSocket(socketServer.replace("http","ws")+socketPrefix+wsEndPoint);   
   			}else{
   				socket=new SockJS(socketServer+socketPrefix+sockJsEndPoint);
   			}
   		}catch(err){
   			console.log("websocket创建失败！")
   			console.log(socket);
   		}
   		if(socket){
   		//连接发生错误的回调方法
   	   	    socket.onerror = function () {
   	   	    	console.log("WebSocket连接发生错误");
   	   	    };
   	   	    //连接成功建立的回调方法
   	   	    socket.onopen = function () {
   	   	    	socket.send(customCode);
   	   	    }
   	   	    //接收到消息的回调方法
   	   	    socket.onmessage = function (event) {
   	   	  		var obj = JSON.parse(event.data);
   	   	  		if(obj.type=="js"){
   	   	  			eval('(' + obj.data + ')');
   	   	  		}else if(obj.type=="message"){
   	   	  			if(receiveCallback){
	   	    			receiveCallback(obj.data);
	   	    		}
   	   	  		}
   	   	    }
   	   	    //连接关闭的回调方法
   	   	    socket.onclose = function () {
   	   	       if(closeCallback){
   	   	    	   closeCallback();
   	   	       }
   	   	    }
   	   	    //监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
   	   	    window.onbeforeunload = function () {
   	   	        closeWebSocket();
   	   	    }
   			//关闭WebSocket连接
   		    function closeWebSocket() {
   		    	socket.close();
   		    }
   		}
		return socket;
	}
</script>
</html>
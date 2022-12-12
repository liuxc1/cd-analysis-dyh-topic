<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset='utf-8' />
<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
<link href='${ctx}/assets/components/fullcalendar/fullcalendar.min.css' rel='stylesheet' />
<link href='${ctx}/assets/components/fullcalendar/fullcalendar.print.min.css' rel='stylesheet' media='print' />
<link href='${ctx}/assets/components/fullcalendar/themes/redmond/jquery-ui.css' rel='stylesheet' />
<link rel="stylesheet" href="${ctx}/assets/components/fullcalendar/fullcalendar_custom.css"  />
<link rel="stylesheet" href="${ctx}/assets/components/artDialog/css/ui-dialog.css">
<script src='${ctx}/assets/components/fullcalendar/lib/moment.min.js'></script>
<script src='${ctx}/assets/components/fullcalendar/lib/jquery.min.js'></script>
<script src='${ctx}/assets/components/fullcalendar/lunar.js'></script>
<script src='${ctx}/assets/components/fullcalendar/fullcalendar.js'></script>
<script src='${ctx}/assets/components/fullcalendar/locale/zh-cn.js'></script>
<script src="${ctx}/assets/components/artDialog/dist/dialog-plus.js"></script>
<style>
	body {
		margin: 0;
		padding: 0;
		font-family: "Lucida Grande",Helvetica,Arial,Verdana,sans-serif;
		font-size: 13px;
		font-family:"微软雅黑";
		background: #fff;
	}
	#calendar.fc-unthemed {
		font-family: "Lucida Grande",Helvetica,Arial,Verdana,sans-serif;
	}
	#calendar {
		margin: 20px 20px;
		padding: 0 10px;
	}
</style>
</head>
<body>
	<div class="page-toolbar align-right list-toolbar" style="margin:5px 30px;">
          <button type="button" class="btn btn-xs  btn-xs-ths" onclick="openWiki()" >
               <i class="ace-icon fa fa-file-excel-o"></i>
               打开wiki
          </button>
    </div>
	<div id='calendar'></div>
</body>
</html>
<script>
	var holidays=[];
	$(document).ready(function() {
		var height = $(window).height();
		$('#calendar').fullCalendar({
			themeSystem: "jquery-ui",
			header: {
				left: 'prev,next today', //设置日历头左侧显示的按钮，可根据实际情况增减
				center: 'title',
				right: 'month,agendaWeek,agendaDay,listMonth' //设置右侧显示的按钮，可根据实际情况减少要显示的视图，其中listMonth可另外取值为listWeek和listDay
			},
			navLinks: true, //设置为true时点击单元格头部阳历日期数字可以直接跳转到日视图
			nongli:true,  //月视图下是否显示农历和节日
			timezone:'local',
			defaultView:'month', //设置日程的默认视图
			lang: 'zh-cn',   //设置日程控件的语言为中文
			minTime: "08:00:00", //设置周视图和日视图每天的开始时间
			maxTime: "23:00:00", //设置周视图和日视图每天的结束时间
			contentHeight:height, //设置日程控件的高度
			selectable: true, //设置日程控件是否可以用鼠标选择
			eventStartEditable:true, //控制日程事件是否可以被拖拽
			eventDurationEditable:true, //控制日程事件是否可以调整范围
	        slotEventOverlap:true,//设置周视图和日视图下事件是否可以重叠
	        eventLimit:true,//如果该参数设置为false,则每个单元格刚度将会根据日程数量自动变化
	        windowResize:function(view){//窗口大小变化时动态调整日程的高度
				var height = $(window).height()-20*2-45;
				$('#calendar').fullCalendar('option', 'contentHeight', height);
			}, 
	        select: function(startDate, endDate, allDay, jsEvent) {//该事件在上述的selecttable设置为true的时候才可以触发
	        	if(endDate._isUTC){
	        		var _startDate=startDate._d;
	        		_startDate.setHours(9); //设置选中时默认的开始时间
				}
				if(endDate._isUTC){
					var _endDate=endDate._d;
					_endDate.setDate(_endDate.getDate()-1);
					_endDate.setHours(21); //设置选中时默认的结束时间
				} 
				
				//下面为选择操作时执行的业务逻辑，可根据实际情况修改，目前是选中时弹出日程添加页面				
	        	var url = "${ctx}/demo/agenda/edit.vm?START_TIME="+startDate+"&END_TIME="+endDate;
	        	d = dialog({
					id:"dialog-select-prepare",
		            title: '添加日程',
		            url: url,
		            width:800,
		            height:430>document.documentElement.clientHeight?document.documentElement.clientHeight:430,
	        		onclose:function(){
		            	
		            }
		        }).showModal();
	        },
			events: function (start,end,timezone,callback) { //初始化日程界面中所显示的日程内容
				$('#calendar').fullCalendar('removeEvents');// 先移除页面的数据，再进行填充events。防止events叠加 
	            //获取数据
				$.ajax({
	                url: '${ctx}/demo/agenda/geteventsjson.vm?START_TIME='+start+'&END_TIME='+end,
	                type: 'post',
	                cache:false,
	                dataType:'json',
	                success: function (response) {
	                    var events=response.events;
	                    for (var i = 0; i < events.length; i++) {
	                    	events[i].start = events[i].START_TIME;
	                    	events[i].end = events[i].END_TIME;
	                    	events[i].id = events[i].AGENDA_ID;
	                    	events[i].title = events[i].TITLE;
	                    	if(events[i].AGENDA_IMPORTANCE=="非常重要"){
	                    		events[i].color = '#ff3600';
	                    		events[i].textColor = 'white'; 
	                    	}else if(events[i].AGENDA_IMPORTANCE=="重要"){
	                    		events[i].color = '#ff9600';
	                    		events[i].textColor = 'white'; 
	                    	}else{
	                    		events[i].color = '#79ca75';
	                    		events[i].textColor = 'white'; 
	                    	}
	                    }
	                    //events为json数组，json对象中必须包含id,start,end,id,title这5个字段，color和textColor为可选字段，用于自定义事件的颜色
	                    callback(events);
	                    //如需在法定节假日上显示‘假’字，请在返回当月日程时，将当月的节假日信息也同时返回
	                    holidays=['2017-12-09','2017-12-10']
	                    initPageStyle();
	                }
	            });
	        },
	        eventClick:function(event){
	        	//点击事件时所执行的业务逻辑
	   			var url = "${ctx}/demo/agenda/edit.vm?AGENDA_ID="+event.id;
	   			var title = '个人日程安排';
	   			dialog({
	   				id:"dialog-select-prepare",
	   	            title: title,
	   	            url: url,
	   	            quickClose: true,
	   	            width:900,
	   	            fixed:false,
	   	            height:500>document.documentElement.clientHeight?document.documentElement.clientHeight:500,
	   	           // follow:document.getElementById('btn2')
	   	        }).showModal();
	        },
	        eventDrop:function( event, dayDelta, minuteDelta, allDay, revertFunc, jsEvent, ui, view ) {
	        	//拖拽事件时执行的业务逻辑 
	        	var url = "${ctx}/demo/agenda/drop.vm?AGENDA_ID="+event.id+"&millDelta="+dayDelta._milliseconds+"&dayDelta="+dayDelta._days;
	   			var title = '个人日程安排';
	   			dialog({
	   				id:"dialog-select-prepare",
	   	            title: title,
	   	            url: url,
	   	            quickClose: true,
	   	            width:900,
	   	            fixed:false,
	   	            height:500>document.documentElement.clientHeight?document.documentElement.clientHeight:500,
	            	cancel:function(){
	            		doSearch()
			        },
			        cancelDisplay: false
	   	            		// follow:document.getElementById('btn2')
	   	        }).showModal(); 
	        },
	        eventResize:function( event, dayDelta, minuteDelta, revertFunc, jsEvent, ui, view ) {
	        	//周视图和日视图下改变事件大小时执行的业务逻辑
	        	var url = "${ctx}/demo/agenda/drag.vm?AGENDA_ID="+event.id+"&millDelta="+dayDelta._milliseconds+"&dayDelta="+dayDelta._days;
	   			var title = '个人日程安排';
	   			dialog({
	   				id:"dialog-select-prepare",
	   	            title: title,
	   	            url: url,
	   	            quickClose: true,
	   	            width:900,
	   	            fixed:false,
	   	            height:500>document.documentElement.clientHeight?document.documentElement.clientHeight:500,
	            	cancel:function(){
	            		doSearch()
			        },
			        cancelDisplay: false
	   	        }).showModal(); 
	        }
		});
	});

	//删除日程弹框
	function closeDialogAgenda(){
		if(dialog.get("dialog-select-prepare")){
			dialog.get("dialog-select-prepare").close().remove();
		}
	}
	
	//刷新当前日程
	function doSearch(){
		closeDialogAgenda();
		$('#calendar').fullCalendar('refetchEvents');
	}
	
	//初始化节假日标识
	function initPageStyle(){
		for(var j=0;j<holidays.length;j++){
	     	$("#"+holidays[j]).find("span:eq(1)").text("假");
	     }
	}
	//打开wiki
	function openWiki(){
		window.open("http://192.168.0.140:8080/wiki/en/Jdp4.0.release#a_.E6.97.A5.E5.8E.86.E7.BB.84.E4.BB.B6");
	}
</script>
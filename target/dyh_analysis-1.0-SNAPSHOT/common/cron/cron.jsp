﻿<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<html>
	<head>
	  	<title>时间设定</title>
		<meta name="description" content="通过这个生成器,您可以在线生成任务调度比如Quartz的Cron表达式,对Quartz Cron 表达式的可视化双向解析和生成." />
		<meta name="keywords" content="cron creater,generate Cron Expression,Cron Expression online,Quartz Cron Expresssion,cron在线生成工具" />
		<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
	    <link href="${ctx }/assets/components/cron/themes/bootstrap/easyui.css" rel="stylesheet" type="text/css" />
	    <link href="${ctx }/assets/components/cron/themes/icon.css" rel="stylesheet" type="text/css" />
	    <script type="text/javascript" src="${ctx }/assets/components/jquery/dist/jquery.js"></script>
	    <script type="text/javascript" src="${ctx }/assets/components/cron/jquery.easyui.min.js"></script>
	    <script type="text/javascript" src="${ctx }/assets/components/cron/cron.js"></script>
	    <style type="text/css">
	    	body{
	    		overflow: hidden;
	    	}
	    	
			.Wdate {
				border: #999 1px solid;
				height: 20px;
				background: #fff
					url(${ctx}/assets/components/My97DatePicker/skin/datePicker.gif) no-repeat
					right;
			}
			
			.WdateFmtErr {
				font-weight: bold;
				color: red;
			}
			
			.line {
				height: 25px;
				line-height: 25px;
				margin: 3px;
			}
			
			.imp {
				padding-left: 25px;
			}
			
			.col {
				width: 95px;
			}
		</style>
    
		<script type="text/javascript">
			$(function(){
				//初始为隐藏，加载完页面后显示，隐藏页面效果抖动问题。
	            $(".easyui-tabs").show();
				
				if(window.parent){
					$("#cron").val($('#${param.cronField}',window.parent.document).val());
				}
				btnFan();
	            $('.minList input').click(function(){
	            	$('#min_appoint').click();
	            	$(this).change();
	            });
	            $('.hourList input').click(function(){
	            	$('#hour_appoint').click();
	            	$(this).change();
	            });
	            $('.dayList input').click(function(){
	            	$('#day_appoint').click();
	            	$(this).change();
	            });
	            $('.weekList input').click(function(){
	            	$('#week_appoint').click();
	            	$(this).change();
	            });
	            $('.mouthList input').click(function(){
	            	$('#mouth_appoint').click();
	            	$(this).change();
	            });
			});
			
		    function selectRadio(datetype){
				if(datetype == "startDate"){
					document.getElementById('startDate').onFocus=WdatePicker({  el: 'startDate' , dateFmt: 'yyyy-MM-dd HH:mm:ss',maxDate:'#F{$dp.$D(\'endDate\');}'});
				}
				if(datetype == "endDate"){
					document.getElementById('endDate').onFocus=WdatePicker({ el:'endDate' ,dateFmt: 'yyyy-MM-dd HH:mm:ss',minDate:'#F{$dp.$D(\'startDate\');}'});
				}
			}
			
			function change(flag){
				if(flag == 0){
					$("#endDate").attr("disabled", true);
					$("#endDate").attr("readonly", "readonly");
					$("#endDate").css("background", "#E0E0E0 url(${ctx}/assets/components/My97DatePicker/skin/datePicker.gif) no-repeat right");
				}else if(flag == 1){
					$("#endDate").attr("disabled", false);
					$("#endDate").attr("readonly", "");
					$("#endDate").css("background", "#fff url(${ctx}/assets/components/My97DatePicker/skin/datePicker.gif) no-repeat right");
				}
			}
			
			//返回值并关闭窗口
			function choseone(){
				var cron = $("#cron").val();
				var value=new Array(dealCron(cron));
				if(window.parent){
					$('#${param.cronField}', window.parent.document).val(value);
					window.parent.closeDialog('${param.dialogId}');
				}
			}
			
			function closeDialog(){
				window.parent.closeDialog('${param.dialogId}');
			}
			
			//0 0/1 1 0 * ?
			function dealCron(cron){
				if(cron == ""){
					cron = "0 * * * * ?";
				}
				var crons = cron.split(" ");
				crons[0] = 0;
				if(crons[1] == "*" && (crons[2] != "*" || crons[3] != "*")){
					crons[1] = 0;
				}
				if(crons[2] == "*" && crons[3] != "*"){
					crons[2] = 0;
				}
				if(crons[3] == "*" && (crons[5] != "*" && crons[5] != "?")){
					crons[3] = '?';
				}
				
				if(crons.length == 6){
					return crons[0]+" "+crons[1]+" "+crons[2]+" "+crons[3]+" "+crons[4]+" "+crons[5];
				}else{
					return crons[0]+" "+crons[1]+" "+crons[2]+" "+crons[3]+" "+crons[4]+" "+crons[5]+" "+crons[6];
				}
			}
		</script>
	</head>
	<body>
		<form action="#" method="post" id="mainForm" name="mainForm">
		    <center>
		        <div class="easyui-layout" style="width:420px;height:355px; border: 1px rgb(202, 196, 196) solid;border-radius: 5px;">
		            <div style="height: 100%;">
		                <div class="easyui-tabs" data-options="fit:true,border:false" style="display: none;">
		                    <!-- 
		                    <div title="秒">
		                        <div class="line">
		                            <input type="radio" checked="checked" name="second" onclick="everyTime(this)" />每秒
		                        </div>
		                        <div class="line">
		                            <input type="radio" name="second" onclick="cycle(this)" />从第
		                            <input class="numberspinner" style="width: 60px;" data-options="min:1,max:58" value="1" 
		                            	id="secondStart_0" />-
		                            <input class="numberspinner" style="width: 60px;" data-options="min:2,max:59" value="2" 
		                            	id="secondEnd_0" />秒
		                        </div>
		                        <div class="line">
		                            <input type="radio" name="second" onclick="startOn(this)" />从第
		                            <input class="numberspinner" style="width: 60px;" data-options="min:0,max:59" value="0"
		                                id="secondStart_1" />秒开始，每
		                            <input class="numberspinner" style="width: 60px;" data-options="min:1,max:59" value="1"
		                                id="secondEnd_1" />秒执行一次
		                        </div>
		                        <div class="line">
		                            <input type="radio" name="second" id="sencond_appoint" />指定秒
		                        </div>
		                        <div class="imp secondList">
		                            <input type="checkbox" value="1" />01
		                            <input type="checkbox" value="2" />02
		                            <input type="checkbox" value="3" />03
		                            <input type="checkbox" value="4" />04
		                            <input type="checkbox" value="5" />05
		                            <input type="checkbox" value="6" />06
		                            <input type="checkbox" value="7" />07
		                            <input type="checkbox" value="8" />08
		                            <input type="checkbox" value="9" />09
		                            <input type="checkbox" value="10" />10
		                        </div>
		                        <div class="imp secondList">
		                            <input type="checkbox" value="11" />11
		                            <input type="checkbox" value="12" />12
		                            <input type="checkbox" value="13" />13
		                            <input type="checkbox" value="14" />14
		                            <input type="checkbox" value="15" />15
		                            <input type="checkbox" value="16" />16
		                            <input type="checkbox" value="17" />17
		                            <input type="checkbox" value="18" />18
		                            <input type="checkbox" value="19" />19
		                            <input type="checkbox" value="20" />20</div>
		                        <div class="imp secondList">
		                            <input type="checkbox" value="21" />21
		                            <input type="checkbox" value="22" />22
		                            <input type="checkbox" value="23" />23
		                            <input type="checkbox" value="24" />24
		                            <input type="checkbox" value="25" />25
		                            <input type="checkbox" value="26" />26
		                            <input type="checkbox" value="27" />27
		                            <input type="checkbox" value="28" />28
		                            <input type="checkbox" value="29" />29
		                            <input type="checkbox" value="30" />30</div>
		                        <div class="imp secondList">
		                            <input type="checkbox" value="31" />31
		                            <input type="checkbox" value="32" />32
		                            <input type="checkbox" value="33" />33
		                            <input type="checkbox" value="34" />34
		                            <input type="checkbox" value="35" />35
		                            <input type="checkbox" value="36" />36
		                            <input type="checkbox" value="37" />37
		                            <input type="checkbox" value="38" />38
		                            <input type="checkbox" value="39" />39
		                            <input type="checkbox" value="40" />40</div>
		                        <div class="imp secondList">
		                            <input type="checkbox" value="41" />41
		                            <input type="checkbox" value="42" />42
		                            <input type="checkbox" value="43" />43
		                            <input type="checkbox" value="44" />44
		                            <input type="checkbox" value="45" />45
		                            <input type="checkbox" value="46" />46
		                            <input type="checkbox" value="47" />47
		                            <input type="checkbox" value="48" />48
		                            <input type="checkbox" value="49" />49
		                            <input type="checkbox" value="50" />50</div>
		                        <div class="imp secondList">
		                            <input type="checkbox" value="51" />51
		                            <input type="checkbox" value="52" />52
		                            <input type="checkbox" value="53" />53
		                            <input type="checkbox" value="54" />54
		                            <input type="checkbox" value="55" />55
		                            <input type="checkbox" value="56" />56
		                            <input type="checkbox" value="57" />57
		                            <input type="checkbox" value="58" />58
		                            <input type="checkbox" value="59" />59
		                        </div>
		                    </div>
		                     -->
		                    <div title="分钟">
		                        <div class="line">
		                            <input type="radio" checked="checked" name="min" onclick="everyTime(this)" />每分钟<!-- 允许的通配符[, - * /] -->
		                        </div>
		                        <div class="line">
		                            <input type="radio" name="min" onclick="cycle(this)" />从第
		                            <input class="numberspinner" style="width: 90px;" data-options="min:1,max:58" value="1"
		                                id="minStart_0" />-
		                            <input class="numberspinner" style="width: 90px;" data-options="min:2,max:59" value="2"
		                                id="minEnd_0" />分钟</div>
		                        <div class="line">
		                            <input type="radio" name="min" onclick="startOn(this)" />从第
		                            <input class="numberspinner" style="width: 90px;" data-options="min:0,max:59" value="0"
		                                id="minStart_1" />分钟开始,每隔
		                            <input class="numberspinner" style="width: 90px;" data-options="min:1,max:59" value="1"
		                                id="minEnd_1" />分钟执行一次</div>
		                        <div class="line">
		                            <input type="radio" name="min" id="min_appoint" />指定分钟</div>
		                        <div class="imp minList">
		                        	<input type="checkbox" value="0" />00
		                            <input type="checkbox" value="1" />01
		                            <input type="checkbox" value="2" />02
		                            <input type="checkbox" value="3" />03
		                            <input type="checkbox" value="4" />04
		                            <input type="checkbox" value="5" />05
		                            <input type="checkbox" value="6" />06
		                            <input type="checkbox" value="7" />07
		                            <input type="checkbox" value="8" />08
		                            <input type="checkbox" value="9" />09
		                        </div>
		                        <div class="imp minList">
		                            <input type="checkbox" value="10" />10
		                            <input type="checkbox" value="11" />11
		                            <input type="checkbox" value="12" />12
		                            <input type="checkbox" value="13" />13
		                            <input type="checkbox" value="14" />14
		                            <input type="checkbox" value="15" />15
		                            <input type="checkbox" value="16" />16
		                            <input type="checkbox" value="17" />17
		                            <input type="checkbox" value="18" />18
		                            <input type="checkbox" value="19" />19
		                        </div>
		                        <div class="imp minList">
		                            <input type="checkbox" value="20" />20
		                            <input type="checkbox" value="21" />21
		                            <input type="checkbox" value="22" />22
		                            <input type="checkbox" value="23" />23
		                            <input type="checkbox" value="24" />24
		                            <input type="checkbox" value="25" />25
		                            <input type="checkbox" value="26" />26
		                            <input type="checkbox" value="27" />27
		                            <input type="checkbox" value="28" />28
		                            <input type="checkbox" value="29" />29
		                        </div>
		                        <div class="imp minList">
		                            <input type="checkbox" value="30" />30
		                            <input type="checkbox" value="31" />31
		                            <input type="checkbox" value="32" />32
		                            <input type="checkbox" value="33" />33
		                            <input type="checkbox" value="34" />34
		                            <input type="checkbox" value="35" />35
		                            <input type="checkbox" value="36" />36
		                            <input type="checkbox" value="37" />37
		                            <input type="checkbox" value="38" />38
		                            <input type="checkbox" value="39" />39
		                        </div>
		                        <div class="imp minList">
		                            <input type="checkbox" value="40" />40
		                            <input type="checkbox" value="41" />41
		                            <input type="checkbox" value="42" />42
		                            <input type="checkbox" value="43" />43
		                            <input type="checkbox" value="44" />44
		                            <input type="checkbox" value="45" />45
		                            <input type="checkbox" value="46" />46
		                            <input type="checkbox" value="47" />47
		                            <input type="checkbox" value="48" />48
		                            <input type="checkbox" value="49" />49
		                        </div>
		                        <div class="imp minList">
		                            <input type="checkbox" value="50" />50
		                            <input type="checkbox" value="51" />51
		                            <input type="checkbox" value="52" />52
		                            <input type="checkbox" value="53" />53
		                            <input type="checkbox" value="54" />54
		                            <input type="checkbox" value="55" />55
		                            <input type="checkbox" value="56" />56
		                            <input type="checkbox" value="57" />57
		                            <input type="checkbox" value="58" />58
		                            <input type="checkbox" value="59" />59
		                        </div>
		                    </div>
		                    <div title="小时">
		                        <div class="line">
		                            <input type="radio" checked="checked" name="hour" onclick="everyTime(this)" />每小时</div>
		                        <div class="line">
		                            <input type="radio" name="hour" onclick="cycle(this)" />从第
		                            <input class="numberspinner" style="width: 90px;" data-options="min:0,max:23" value="0"
		                                id="hourStart_0" />-
		                            <input class="numberspinner" style="width: 90px;" data-options="min:2,max:23" value="2"
		                                id="hourEnd_1" />小时</div>
		                        <div class="line">
		                            <input type="radio" name="hour" onclick="startOn(this)" />从第
		                            <input class="numberspinner" style="width: 90px;" data-options="min:0,max:23" value="0"
		                                id="hourStart_1" />小时开始，每
		                            <input class="numberspinner" style="width: 90px;" data-options="min:1,max:23" value="1"
		                                id="hourEnd_1" />小时执行一次</div>
		                        <div class="line">
		                            <input type="radio" name="hour" id="hour_appoint" />指定小时</div>
		                        <div class="imp hourList">
		                            <input type="checkbox" value="0" />00
		                            <input type="checkbox" value="1" />01
		                            <input type="checkbox" value="2" />02
		                            <input type="checkbox" value="3" />03
		                            <input type="checkbox" value="4" />04
		                            <input type="checkbox" value="5" />05
								</div>
		                        <div class="imp hourList">	                            
		                            <input type="checkbox" value="6" />06
		                            <input type="checkbox" value="7" />07
		                            <input type="checkbox" value="8" />08
		                            <input type="checkbox" value="9" />09
		                            <input type="checkbox" value="10" />10
		                            <input type="checkbox" value="11" />11
		                        </div>
		                        <div class="imp hourList">
		                            <input type="checkbox" value="12" />12
		                            <input type="checkbox" value="13" />13
		                            <input type="checkbox" value="14" />14
		                            <input type="checkbox" value="15" />15
		                            <input type="checkbox" value="16" />16
		                            <input type="checkbox" value="17" />17
		                        </div>
		                        <div class="imp hourList">
		                            <input type="checkbox" value="18" />18
		                            <input type="checkbox" value="19" />19
		                            <input type="checkbox" value="20" />20
		                            <input type="checkbox" value="21" />21
		                            <input type="checkbox" value="22" />22
		                            <input type="checkbox" value="23" />23
		                        </div>
		                    </div>
								<div title="日">
									<div class="line">
										<input type="radio" checked="checked" name="day"
											onclick="everyTime(this)" />每日
									</div>
			                        <div class="line" style="display: none">
			                            <input type="radio" name="day" onclick="unAppoint(this)" />不指定
			                        </div>
									<div class="line">
										<input type="radio" name="day" onclick="cycle(this)" />从第 
										<input class="numberspinner" style="width: 90px;"
											data-options="min:1,max:31" value="1" id="dayStart_0" />- 
										<input class="numberspinner" style="width: 90px;"
											data-options="min:2,max:31" value="2" id="dayEnd_0" />日
									</div>
									<div class="line">
										<input type="radio" name="day" onclick="startOn(this)" />从第 
										<input class="numberspinner" style="width: 90px;"
											data-options="min:1,max:31" value="1" id="dayStart_1" />日开始，每 
										<input class="numberspinner" style="width: 90px;"
											data-options="min:1,max:31" value="1" id="dayEnd_1" />天执行一次
									</div>
									<div class="line">
										<input type="radio" name="day" onclick="workDay(this)" />每月 
										<input class="numberspinner" style="width: 90px;"
											data-options="min:1,max:31" value="1" id="dayStart_2" />号最近的那个工作日
									</div>
									<div class="line">
										<input type="radio" name="day" onclick="lastDay(this)" />本月最后一天 
									</div>
									<div class="line">
										<input type="radio" name="day" id="day_appoint" />指定日 
									</div>
									<div class="imp dayList">
										<input type="checkbox" value="1" />01 
										<input type="checkbox" value="2" />02 
										<input type="checkbox" value="3" />03 
										<input type="checkbox" value="4" />04 
										<input type="checkbox" value="5" />05 
										<input type="checkbox" value="6" />06 
										<input type="checkbox" value="7" />07 
										<input type="checkbox" value="8" />08 
										<input type="checkbox" value="9" />09 
										<input type="checkbox" value="10" />10
									</div>
									<div class="imp dayList"> 
										<input type="checkbox" value="11" />11 
										<input type="checkbox" value="12" />12 
										<input type="checkbox" value="13" />13 
										<input type="checkbox" value="14" />14 
										<input type="checkbox" value="15" />15 
										<input type="checkbox" value="16" />16
										<input type="checkbox" value="17" />17 
										<input type="checkbox" value="18" />18 
										<input type="checkbox" value="19" />19 
										<input type="checkbox" value="20" />20
									</div>
									<div class="imp dayList">
										<input type="checkbox" value="21" />21 
										<input type="checkbox" value="22" />22 
										<input type="checkbox" value="23" />23 
										<input type="checkbox" value="24" />24 
										<input type="checkbox" value="25" />25 
										<input type="checkbox" value="26" />26 
										<input type="checkbox" value="27" />27 
										<input type="checkbox" value="28" />28 
										<input type="checkbox" value="29" />29 
										<input type="checkbox" value="30" />30 
										<input type="checkbox" value="31" />31 
									</div>
								</div>
								<div title="月">
									<div class="line">
										<input type="radio" checked="checked" name="mouth"
											onclick="everyTime(this)" />每月
									</div>
									<div class="line" style="display: none">
										<input type="radio" name="mouth" onclick="unAppoint(this)" />不指定
									</div>
									<div class="line">
										<input type="radio" name="mouth" onclick="cycle(this)" />从第
										<input class="numberspinner" style="width: 90px;"
											data-options="min:1,max:12" value="1" id="mouthStart_0" />- 
										<input class="numberspinner" style="width: 90px;"
											data-options="min:2,max:12" value="2" id="mouthEnd_0" />月
									</div>
									<div class="line">
										<input type="radio" name="mouth" onclick="startOn(this)" />从第
										<input class="numberspinner" style="width: 90px;"
											data-options="min:1,max:12" value="1" id="mouthStart_1" />月开始，每 
										<input class="numberspinner" style="width: 90px;"
											data-options="min:1,max:12" value="1" id="mouthEnd_1" />月执行一次
									</div>
									<div class="line">
										<input type="radio" name="mouth" id="mouth_appoint" />指定月
									</div>
									<div class="imp mouthList">
										<input type="checkbox" value="1" />01 
										<input type="checkbox" value="2" />02 
										<input type="checkbox" value="3" />03 
										<input type="checkbox" value="4" />04 
										<input type="checkbox" value="5" />05 
										<input type="checkbox" value="6" />06 
										<br />
										<input type="checkbox" value="7" />07 
										<input type="checkbox" value="8" />08 
										<input type="checkbox" value="9" />09 
										<input type="checkbox" value="10" />10 
										<input type="checkbox" value="11" />11 
										<input type="checkbox" value="12" />12
									</div>                                
								</div>
								<div title="周">
									<div class="line">
										<input type="radio" checked="checked" name="week"
											onclick="everyTime(this)" />每周
									</div>
									<div class="line">
										<input type="radio" name="week" onclick="unAppoint(this)" />不指定
									</div>
									<div class="line">
										<input type="radio" name="week" onclick="startOn(this)" />从周
										<input class="numberspinner" style="width: 90px;"
											data-options="min:1,max:7" id="weekStart_0" value="1" />
											- 
										<input class="numberspinner" style="width: 90px;"
											data-options="min:2,max:7" value="2" id="weekEnd_0" />
									</div>
									<div class="line">
										<input type="radio" name="week" onclick="weekOfDay(this)" />从第
										<input class="numberspinner" style="width: 90px;"
											data-options="min:1,max:4" value="1" id="weekStart_1" />周 的星期
										<input class="numberspinner" style="width: 90px;"
											data-options="min:1,max:7" id="weekEnd_1" value="1" />
									</div>
									<div class="line">
										<input type="radio" name="week" onclick="lastWeek(this)" />本月最后一个星期
										<input class="numberspinner" style="width: 90px;"
											data-options="min:1,max:7" id="weekStart_2" value="1" />
									</div>
									<div class="line">
										<input type="radio" name="week" id="week_appoint" />指定周
									</div>
									<div class="imp weekList">
										<input type="checkbox" value="2" />周一
										<input type="checkbox" value="3" />周二
										<input type="checkbox" value="4" />周三
										<input type="checkbox" value="5" />周四
										<input type="checkbox" value="6" />周五
										<input type="checkbox" value="7" />周六
										<input type="checkbox" value="1" />周日
									</div>
								</div>
								<div title="年">
									<div class="line">
										<input type="radio" checked="checked" name="year"
											onclick="unAppoint(this)" />不指定<!-- 允许的通配符[, - * /] 非必填 -->
									</div>
									<div class="line">
										<input type="radio" name="year" onclick="everyTime(this)" />每年
									</div>
									<div class="line">
										<input type="radio" name="year" onclick="cycle(this)" />从第 
										<input class="numberspinner" style="width: 90px;"
											data-options="min:2016,max:3000" id="yearStart_0" value="2016" />- 
										<input class="numberspinner" style="width: 90px;"
											data-options="min:2020,max:3000" id="yearEnd_0" value="2016" />年
									</div>
								</div>
							</div>
		            </div>
		            
					<div data-options="region:'south',border:false" style="height: 65px;overflow: hidden;">
						<!-- 
						<fieldset style="border-radius: 3px; height: 80px;">
		                <legend>重复范围</legend>
			                <table style="height: 35px;" width="100%">
			                    <tbody>
									<tr>
							            <td rowspan="2" colspan="1" valign="bottom">
							            	开始时间：<br />
							            	<input type="text" readonly="readonly"  id="startDate" name="startDate" 
							            		style="cursor: pointer; width: 145px;" filetype="String"
												class="Wdate" onFocus="selectRadio('startDate');" value="${startDate}" />
							            </td>
							            <td style="text-align: left;"><input type="radio" id="endTimeFlag0" name="endTimeFlag" onclick="change(0);" value="0"/>永不过期</td>
							        </tr>
							        <tr>
							            <td valign="bottom" style="text-align: left;">
							            	<input type="radio" id="endTimeFlag1" name="endTimeFlag" onclick="change(1);" value="1"/>结束时间：
							            	<input type="text" readonly="readonly"  id="endDate" name="endDate" 
							            		style="cursor: pointer; width: 145px;" filetype="String"
												class="Wdate" onFocus="selectRadio('endDate');" value="${endDate}" />
							            </td>
							        </tr>
			                	</tbody>
			            	</table>
		                </fieldset>
		                 -->
						<div style="text-align:center;margin-top: 10px;position: relative;">
			                <button type="button" class="btn btn-xs btn-primary btn-xs-ths" id="btnSave" onclick="choseone()">
			                    <i class="ace-icon fa fa-check"></i>确定
			                </button>
			                <button type="button" class="btn btn-xs btn-danger btn-xs-ths" id="btnReturn" onclick="closeDialog();">
				                <i class="ace-icon fa fa-close"></i>关闭
				            </button>
						</div>	                 
	
					</div>
		
					<!-- 
		            <div data-options="region:'south',border:false" style="height:70px;">
		                <fieldset style="border-radius: 3px; height: 60px;">
		                <legend>自定义表达式</legend>
			                <table style="height: 35px;" width="100%">
			                    <tbody>
			                        <tr style="text-align: center;">
										<td><input type="text" id="customerRon" name="customerRon" /></td>
									</tr>
			                	</tbody>
			            	</table>
		                </fieldset>
		            </div>
		             -->
		            
		            
		            <div data-options="region:'south',border:false" style="height:150px;display: none;">
						<fieldset style="border-radius: 3px; height: 116px;">
								<legend>
									表达式
								</legend>
								<table style="height: 100px;">
									<tbody>
										<tr>
											<td></td>
											<td align="center">秒</td>
											<td align="center">分钟</td>
											<td align="center">小时</td>
											<td align="center">日</td>
											<td align="center">月</td>
											<td align="center">星期</td>
											<td align="center">年</td>
										</tr>
										<tr>
											<td>
												表达式字段:
											</td>
											<td>
												<input type="text" name="v_second" class="col" value="*" readonly="readonly" />
											</td>
											<td>
												<input type="text" name="v_min" class="col" value="*" readonly="readonly" />
											</td>
											<td>
												<input type="text" name="v_hour" class="col" value="*" readonly="readonly" />
											</td>
											<td>
												<input type="text" name="v_day" class="col" value="*" readonly="readonly" />
											</td>
											<td>
												<input type="text" name="v_mouth" class="col" value="*" readonly="readonly" />
											</td>
											<td>
												<input type="text" name="v_week" class="col" value="?" readonly="readonly" />
											</td>
											<td>
												<input type="text" name="v_year" class="col" readonly="readonly" />
											</td>
										</tr>
										<tr>
											<td>
												Cron 表达式:
											</td>
											<td colspan="6">
												<input type="text" name="cron" style="width: 100%;" value="* * * * * ?" id="cron" />
											</td>
											<td>
												<input type="button" value="反解析到UI " id="btnFan" onclick="btnFan()" />
											</td>
										</tr>
									</tbody>
								</table>
							</fieldset>
							<div style="text-align: center; margin-top: 5px;">
		                    <script type="text/javascript">
		                        /*killIe*/
		                        $.parser.parse($("body"));
		                        
		
		                        function btnFan() {
		                            //获取参数中表达式的值
		                            var txt = $("#cron").val();
		                            if (txt) {
		                                var regs = txt.split(' ');
		                                $("input[name=v_second]").val(regs[0]);
		                                $("input[name=v_min]").val(regs[1]);
		                                $("input[name=v_hour]").val(regs[2]);
		                                $("input[name=v_day]").val(regs[3]);
		                                $("input[name=v_mouth]").val(regs[4]);
		                                $("input[name=v_week]").val(regs[5]);
		
		                                initObj(regs[0], "second");
		                                initObj(regs[1], "min");
		                                initObj(regs[2], "hour");
		                                initDay(regs[3]);
		                                initMonth(regs[4]);
		                                initWeek(regs[5]);
		
		                                if (regs.length > 6) {
		                                    $("input[name=v_year]").val(regs[6]);
		                                    initYear(regs[6]);
		                                }
		                            }
		                        }
		                      
		
		                        function initObj(strVal, strid) {
		                            var ary = null;
		                            var objRadio = $("input[name='" + strid + "'");
		                            if (strVal == "*") {
		                                objRadio.eq(0).attr("checked", "checked");
		                            } else if (strVal.split('-').length > 1) {
		                                ary = strVal.split('-');
		                                objRadio.eq(1).attr("checked", "checked");
		                                $("#" + strid + "Start_0").numberspinner('setValue', ary[0]);
		                                $("#" + strid + "End_0").numberspinner('setValue', ary[1]);
		                            } else if (strVal.split('/').length > 1) {
		                                ary = strVal.split('/');
		                                objRadio.eq(2).attr("checked", "checked");
		                                $("#" + strid + "Start_1").numberspinner('setValue', ary[0]);
		                                $("#" + strid + "End_1").numberspinner('setValue', ary[1]);
		                            } else {
		                                objRadio.eq(3).attr("checked", "checked");
		                                if (strVal != "?") {
		                                    ary = strVal.split(",");
		                                    for (var i = 0; i < ary.length; i++) {
		                                        $("." + strid + "List input[value='" + ary[i] + "']").attr("checked", "checked");
		                                    }
		                                }
		                            }
		                        }
		
		                        function initDay(strVal) {
		                            var ary = null;
		                            var objRadio = $("input[name='day'");
		                            if (strVal == "*") {
		                                objRadio.eq(0).attr("checked", "checked");
		                            } else if (strVal == "?") {
		                                objRadio.eq(1).attr("checked", "checked");
		                            } else if (strVal.split('-').length > 1) {
		                                ary = strVal.split('-');
		                                objRadio.eq(2).attr("checked", "checked");
		                                $("#dayStart_0").numberspinner('setValue', ary[0]);
		                                $("#dayEnd_0").numberspinner('setValue', ary[1]);
		                            } else if (strVal.split('/').length > 1) {
		                                ary = strVal.split('/');
		                                objRadio.eq(3).attr("checked", "checked");
		                                $("#dayStart_1").numberspinner('setValue', ary[0]);
		                                $("#dayEnd_1").numberspinner('setValue', ary[1]);
		                            } else if (strVal.split('W').length > 1) {
		                                ary = strVal.split('W');
		                                objRadio.eq(4).attr("checked", "checked");
		                                $("#dayStart_2").numberspinner('setValue', ary[0]);
		                            } else if (strVal == "L") {
		                                objRadio.eq(5).attr("checked", "checked");
		                            } else {
		                                objRadio.eq(6).attr("checked", "checked");
		                                ary = strVal.split(",");
		                                for (var i = 0; i < ary.length; i++) {
		                                    $(".dayList input[value='" + ary[i] + "']").attr("checked", "checked");
		                                }
		                            }
		                        }
		
		                        function initMonth(strVal) {
		                            var ary = null;
		                            var objRadio = $("input[name='mouth'");
		                            if (strVal == "*") {
		                                objRadio.eq(0).attr("checked", "checked");
		                            } else if (strVal == "?") {
		                                objRadio.eq(1).attr("checked", "checked");
		                            } else if (strVal.split('-').length > 1) {
		                                ary = strVal.split('-');
		                                objRadio.eq(2).attr("checked", "checked");
		                                $("#mouthStart_0").numberspinner('setValue', ary[0]);
		                                $("#mouthEnd_0").numberspinner('setValue', ary[1]);
		                            } else if (strVal.split('/').length > 1) {
		                                ary = strVal.split('/');
		                                objRadio.eq(3).attr("checked", "checked");
		                                $("#mouthStart_1").numberspinner('setValue', ary[0]);
		                                $("#mouthEnd_1").numberspinner('setValue', ary[1]);
		
		                            } else {
		                                objRadio.eq(4).attr("checked", "checked");
		
		                                ary = strVal.split(",");
		                                for (var i = 0; i < ary.length; i++) {
		                                    $(".mouthList input[value='" + ary[i] + "']").attr("checked", "checked");
		                                }
		                            }
		                        }
		
		                        function initWeek(strVal) {
		                            var ary = null;
		                            var objRadio = $("input[name='week'");
		                            if (strVal == "*") {
		                                objRadio.eq(0).attr("checked", "checked");
		                            } else if (strVal == "?") {
		                                objRadio.eq(1).attr("checked", "checked");
		                            } else if (strVal.split('/').length > 1) {
		                                ary = strVal.split('/');
		                                objRadio.eq(2).attr("checked", "checked");
		                                $("#weekStart_0").numberspinner('setValue', ary[0]);
		                                $("#weekEnd_0").numberspinner('setValue', ary[1]);
		                            } else if (strVal.split('#').length > 1) {
		                                ary = strVal.split('#');
		                                objRadio.eq(3).attr("checked", "checked");
		                                $("#weekStart_1").numberspinner('setValue', ary[0]);
		                                $("#weekEnd_1").numberspinner('setValue', ary[1]);
		                            } else if (strVal.split('L').length > 1) {
		                                ary = strVal.split('L');
		                                objRadio.eq(4).attr("checked", "checked");
		                                $("#weekStart_2").numberspinner('setValue', ary[0]);
		                            } else {
		                                objRadio.eq(5).attr("checked", "checked");
		                                ary = strVal.split(",");
		                                for (var i = 0; i < ary.length; i++) {
		                                    $(".weekList input[value='" + ary[i] + "']").attr("checked", "checked");
		                                }
		                            }
		                        }
		
		                        function initYear(strVal) {
		                            var ary = null;
		                            var objRadio = $("input[name='year'");
		                            if (strVal == "*") {
		                                objRadio.eq(1).attr("checked", "checked");
		                            } else if (strVal.split('-').length > 1) {
		                                ary = strVal.split('-');
		                                objRadio.eq(2).attr("checked", "checked");
		                                $("#yearStart_0").numberspinner('setValue', ary[0]);
		                                $("#yearEnd_0").numberspinner('setValue', ary[1]);
		                            }
		                        }
		                    </script>
		                    <div>
		                    </div>
		                </div>
		            </div>
		            <div>
		            </div>
		        </div>
		    </center>
	    </form>
	</body>
</html>

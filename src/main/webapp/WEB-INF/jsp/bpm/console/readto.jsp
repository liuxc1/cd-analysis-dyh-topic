<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
	<head>
		<title>转办原因</title>
		<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
		<!--页面自定义的CSS，请放在这里 -->
		<style type="text/css">
		
		</style>
	</head>
	<body class="no-skin">
		<div class="main-container" id="main-container">
			<div class="main-content">
				<div class="main-content-inner padding-page-content">
					<div class="page-content">
						<div class="space-4"></div>
						<div class="row">
							<div class=" col-xs-12">
								<form class="form-horizontal" role="form" id="form1" action=""
									method="post">
									<div class="form-group">
										<label class="col-xs-12 control-label no-padding-right blue" style="text-align:left;">传阅描述</label>
										<div class="col-xs-12 control-group">
											<textarea class="form-control" id="txtWfComment" data-validation-engine="maxSize[200]"
												placeholder="请输入传阅描述，200个字符以内" style="height: 66px;"></textarea>
										</div>
									</div>
									<div class="form-group">
										<label class="col-xs-12 control-label no-padding-right blue" style="text-align:left;"><i class="ace-icon fa fa-asterisk red smaller-70"></i>选择阅读人</label>
										<div class="col-xs-10" style="padding-right: 0px;">
		                                  	<input type="hidden" id="complexUsers" name="complexUsers"/>
		                            		<div class="chosen-container chosen-container-multi width-100"
		                                    	   	style="border: solid 1px #D5D5D5; min-height: 130px; ">
		                                       	<ul class="chosen-choices" style="border: none" id="manageUserUl">
													<!-- TODO:展示已选择的人员 -->
		                                       	</ul>
		                                    </div>
		                                </div>
		                              	<div class="col-xs-2">
		                                    <button id="btnChooseUserManager" type="button" class="btn btn-xs btn-default btn-white btn-xs-ths" title="选择">
		                                        <i class="ace-icon fa fa-search"></i>选择
		                                    </button>
		                                    <div class="space-4 hidden-xs"></div>
		                                    <button  id="btnChooseUserManagerX" type="button" class="btn btn-xs btn-default btn-white btn-xs-ths" title="清空" >
		                                        <i class="ace-icon fa fa-trash"></i>清空
		                                    </button>
		                                </div>
									</div>
								</form>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
		<!-- 自己写的JS，请放在这里 -->
		<script type="text/javascript">
			$(function(){
				$("#form1").validationEngine({
		            scrollOffset: 98,//必须设置，因为Toolbar position为Fixed
		            promptPosition: 'bottomLeft',
		            autoHidePrompt: true,
		            validateNonVisibleFields: true
		        });
				
	            $("#btnChooseUserManager").on(ace.click_event,function(){
	            	parent.selectUsers = parent.jdp_bpm_read_selectUsers;
	    			//dialog的使用，请参考官方文档http://aui.github.io/artDialog/doc/index.html
	    			if("${canread }" == "canread_BBM"){ //传阅本部门
	    				parent.dialog({
		    				id:"jdp-bpm-read-dialog-user-muti",
		    	            title: '选择',
		    	            url: "${ctx}/common/ou/selUserMuti.html?callback=jdp_bpm_read_complexUserChoose&hiddenId=selfDeptUserLoginNames&textId=selfDeptUserNames&closeCallback=jdp_bpm_readClose&orgid=${deptId }&showChildOrg=true",
		    	            width:500,
		    	            height:400,
		    	        }).showModal();
	    			}else{
	    				parent.dialog({
		    				id:"jdp-bpm-read-dialog-user-muti",
		    	            title: '选择',
		    	            url: "${ctx}/eform/components/complex/complex_user_choose.vm?hiddenId=complexUsers&callback=jdp_bpm_read_complexUserChoose&closeCallback=jdp_bpm_readClose",
		    	            width:600,
		    	            height:450
		    	        }).showModal();
	    			}
	    		});
	    		$("#btnChooseUserManagerX").on(ace.click_event,function(){
	    			$("#manageUserUl").html("");
	    			$("#complexUsers").val("");
	    		});
			});
			//多选人界面显示
			function showMutiUserSelected(complexUserObj) {
				if(complexUserObj != null && complexUserObj.length > 0 && complexUserObj.user == null){
					var loginNames = "";
					var names = "";
					for(var i = 0; i < complexUserObj.length; i++){
						complexUserObj[i].code = complexUserObj[i].loginName;
						if(loginNames == ""){
							loginNames = complexUserObj[i].loginName;
							names = complexUserObj[i].name;
						}else{
							loginNames += "," + complexUserObj[i].loginName;
							names += "," + complexUserObj[i].name;
						}
					}
					$("#selfDeptUserLoginNames", window.parent.document).val(loginNames);
					$("#selfDeptUserNames", window.parent.document).val(names);
					complexUserObj = {user: complexUserObj};
				}
				$("#complexUsers").val(JSON.stringify(complexUserObj));
				var listHTML = "" ;
				for(var type in complexUserObj){
					$.each(complexUserObj[type], function(i){
			        	listHTML += "<li class='search-choice' >";
			        	listHTML += "<span>"+this.name+"</span>";
			        	listHTML += "<a class='search-choice-close' onclick=\"$(this).parent().remove();removeComplexUser('"+this.code+"', '" + type + "')\"></a>";
			        	listHTML += "</li>";
			        });
				}
		        $("#manageUserUl").html(listHTML);
			}
			//删除待阅人
			function removeComplexUser(code, type){
				var complexUsersVal = $("#complexUsers").val();
				if(complexUsersVal != ""){
					var complexUserObj = JSON.parse(complexUsersVal);
					$.each(complexUserObj[type], function(i){
						if(this.code == code){
							complexUserObj[type].splice(i, 1);
							return false;
						}
					});
					$("#complexUsers").val(JSON.stringify(complexUserObj));
				}
			}
			function check(){
				return $('#form1').validationEngine('validate');
			}
		</script>
	</body>
</html>

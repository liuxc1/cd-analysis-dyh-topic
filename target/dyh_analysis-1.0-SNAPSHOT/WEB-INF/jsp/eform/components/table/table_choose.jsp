<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
	<head>
		<title>数据表列表</title>
		<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
		<!--页面自定义的CSS，请放在这里 -->
		<style type="text/css">
			.nodata{
				text-align:center;
				margin-top:10px;
				font-size:13px;
			}
		</style>
	</head>
	<body class="no-skin">
		<div class="main-container" id="main-container">
    		<div class="main-content">
        		<div class="main-content-inner padding-page-content">
                	<div class="col-xs-12 no-padding">
                        <div class="widget-box transparent">
                            <div class="widget-header" style="padding-left: 10px;">
                            		<form id="paramdoSearchForm"  onkeydown="if(event.keyCode==13)return false;">
										<input type="text" style="float:left;height:30px" id="paramName" name="NAME" value="">
									</form>
									<button type="button" class="btn btn-xs btn-primary btn-xs-ths" id="btnOk1" style=";margin-left: 10px" onclick="doSearch()">
										<i class="ace-icon fa fa-search"></i> 搜索
									</button>
                                    
									<button type="button" class="btn btn-xs btn-danger btn-xs-ths" id="btnCancel"  style="float:right;margin-right: 10px">
										<i class="ace-icon fa fa-remove"></i> 取消
									</button>
									<button type="button" class="btn btn-xs btn-primary btn-xs-ths" id="btnOk" style="float:right;;margin-right: 10px">
										<i class="ace-icon fa fa-plus"></i> 确定
									</button>
                            </div>
                            <div class="" style="margin-right: -1px;overflow: auto">
                                <div class="widget-main padding-2">
                                	<c:if test="${paramMap.selectType != 1 }">
	                                    <div id="divSelect" class="chosen-container chosen-container-multi width-100" style="border-bottom: solid 1px #D5D5D5; height: 65px;overflow-y: auto; margin-bottom: 2px;">
	                                        <ul id="selectList" class="chosen-choices"  style="border: none; background-image: none">
	
	                                        </ul>
	                                    </div>
	                                </c:if>
                                    <div class="col-xs-12 form-horizontal" style="height: ${paramMap.selectType != 1 ? 300 : 355 }px; overflow: auto">
                                    	<form class="form-horizontal" role="form" id="formList" method="post" target="formList" onsubmit="return doSearch();">
						            	</form>
						            	<form id="paramForm">
                                    		<c:forEach var="item" items="${paramMap }">
                                    			<input type="hidden" name="${item.key }" value="${item.value }" />
                                    		</c:forEach>
						            	</form>
                                        <!-- 隐藏域:用来隐藏table_data有数据情况的thead的html代码信息 -->
                                        <div style="display: none" id="formListTitle"></div>
	                                </div>
	                            </div>
	                        </div>
						</div>
	    			</div>
		        </div><!--/.main-content-inner-->
		    </div><!-- /.main-content -->
		</div><!-- /.main-container -->
		<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
		<!-- 自己写的JS，请放在这里 -->
		<script type="text/javascript">
			jQuery(function($){
				//确认按钮click事件
				$("#btnOk").on(ace.click_event,function () {
					if(window.parent && window.parent.${paramMap.callback}){
						if("${paramMap.selectType }" == "1"){ //单选
							window.parent.${paramMap.callback}(selectItems[0]);
						}else{ //多选
							window.parent.${paramMap.callback}(selectItems);
						}
					}
					if(parentExistsFun("${paramMap.closeCallback}") == true){
						eval("window.parent.${paramMap.closeCallback}()");
					}else if(window.parent.closeTableDialog) {
		                window.parent.closeTableDialog();
		            }
		        });
				//取消按钮click事件
		        $("#btnCancel").on(ace.click_event,function () {
		        	if(parentExistsFun("${paramMap.closeCallback}") == true){
						eval("window.parent.${paramMap.closeCallback}()");
					}else if(window.parent.closeTableDialog) {
		                window.parent.closeTableDialog();
		            }
		        });
		        //初始化-搜索第一页
		        doSearch();
		        //初始化-父窗口之前选中的项
		        if(window.parent && window.parent.selectItems) {
		        	selectItems.length = 0;
		            $.each(window.parent.selectItems,function (i) {
		            	selectItems[i] = this;
		            });
		        }
		        selectItems.render();
			});
			//搜索
			function doSearch(){
				if( typeof(arguments[0]) != "undefined" && arguments[0] == true)
					$("#pageNum").val(1);
				var url = "${ctx }/eform/components/table/table_data.vm?pageSize=${paramMap.selectType == 1 ? 7 : 5}";
				if($("#paramForm").serialize() != ""){
					url += "&" + $("#paramForm").serialize();
				}
				if($("#formList").serialize() != ""){
					url += "&" + $("#formList").serialize();
				}
				//分页pageSize现在设为单选8条，多选显示5条，合理利用空间防止出现滚动条
				$("#formList").load(url+"&_t=" + new Date().getTime(),{NAME:$("#paramName").val()});
				//formList 的onsubmit方法时，为防止刷新不提交form，只进行内容替换
				// 此处也可以用ajax组装数据，本列表采用的是，主load子jsp方式，不用再操作json
				return false;
			}
			/*以下 js选中项目操作*/
			var selectItems = [/*{CODE:"TEXT",NAME:"单行文本框",...}*/];
			
			//存储所选值的隐藏域ID和text域ID
			var hiddenId="${paramMap.hiddenId}";
			var textId="${paramMap.textId}";
			if(hiddenId && textId){
				var _selectHidden=$("#"+hiddenId, window.parent.document);
				var hiddenArry=_selectHidden.val().trim().split(",");
				var _selectText=$("#"+textId, window.parent.document);
				var textArray=_selectText.val().trim().split(",");
				if(hiddenArry.length>0 && textArray.length>0){
					$(hiddenArry).each(function(index,content){
						if(this!=""){
							var item={};
							item.CODE=content;
							item.NAME=textArray[index];
							selectItems[index]=item;
						}
					})
				}
			}
			selectItems.remove = function(code){
				for(var i = selectItems.length -1 ; i>= 0 ;i--) {
					if(code == selectItems[i].CODE) {
						selectItems.splice(i,1);
			     		removeSelectFromUL(code);
			     	}
			 	}
			};
			selectItems.add = function (item) {
				selectItems[selectItems.length] = item;
				addSelectToUL(item.CODE, item.NAME);
			};
			selectItems.clear = function(){
				selectItems.length = 0;
			};
			selectItems.render= function () {
				$.each(selectItems,function () {
			    	addSelectToUL(this.CODE,this.NAME);
			    	$("#" + escapeJquery(this.CODE)).prop('checked', true);
			  	});
			};
			//添加到UL
			function addSelectToUL(code, name){
		        $("#selectList").append("<li class='search-choice' id='li-" + code + "'><span>" + name + "</span>"
		                +"<a class='search-choice-close' onclick='selectItems.remove(\"" + code + "\")'></a></li>");
		    }
			//从UL中删除，并变成未选中
			function removeSelectFromUL(code) {
		        $("#selectList").find("#li-" + escapeJquery(code)).remove();
		        $("#" + escapeJquery(code)).prop('checked', false);
		    }
			
			//判断父页面是否存在方法
			function parentExistsFun(funName){
				if(funName == null || funName == ""){
					return false;
				}
				var existsFun = false;
				try{
		    		eval("window.parent." + funName);
		    		existsFun = true;
		    	}catch(err) {}
		    	return existsFun;
			}
			
			//特殊字符转义
			function escapeJquery(srcString) {
				 // 转义之后的结果
				 var escapseResult = srcString;
				 // javascript正则表达式中的特殊字符
				 var jsSpecialChars = ["\\", "^", "$", "*", "?", ".", "+", "(", ")", "[",
				   "]", "|", "{", "}"];
				 // jquery中的特殊字符,不是正则表达式中的特殊字符
				 var jquerySpecialChars = ["~", "`", "@", "#", "%", "&", "=", "'", "\"",
				   ":", ";", "<", ">", ",", "/"];
				 for (var i = 0; i < jsSpecialChars.length; i++) {
				  escapseResult = escapseResult.replace(new RegExp("\\"
				        + jsSpecialChars[i], "g"), "\\"
				      + jsSpecialChars[i]);
				 }
				 for (var i = 0; i < jquerySpecialChars.length; i++) {
				  escapseResult = escapseResult.replace(new RegExp(jquerySpecialChars[i],
				      "g"), "\\" + jquerySpecialChars[i]);
				 }
				 return escapseResult;
			}
		</script>
	</body>
</html>

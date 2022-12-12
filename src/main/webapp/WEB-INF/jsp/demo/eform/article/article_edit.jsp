<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
<head>
    <title>文章编辑</title>
	<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
  	<!--页面自定义的CSS，请放在这里 -->
    <style type="text/css">

    </style>
</head>

<body class="no-skin">

<div class="main-container" id="main-container">
    <div class="main-content">
        <div class="main-content-inner fixed-page-header fixed-60" style="z-index: 10">
            <div id="breadcrumbs" class="breadcrumbs">
                <ul class="breadcrumb">
                    <li class="active">
                        <h5 class="page-title" >
                            <i class="fa fa-edit"></i>
                            文章信息维护
                        </h5>
                    </li>
                </ul><!-- /.breadcrumb -->

            </div>

        </div>
        <div class="main-content-inner padding-page-content" style="height:200px;">
            <div class="page-content">
                <div class="space-4"></div>
                <div class="row">
                    <div class=" col-xs-12">
                        <form class="form-horizontal" role="form" id="formInfo" action="" method="post">
                            <div class="form-group">
                                <label class="col-sm-1 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                   标题
                                </label>
                                <div class="col-sm-3" id="title_div">
                                <input type="hidden" name="form['ARTICLE_ID']"  value="${form.ARTICLE_ID}"/> 
                                <span class="input-icon width-100">
                                        <input type="text" class="form-control"
                                               data-validation-engine="validate[required]" placeholder="25个汉字以内" 
                                               name="form['ARTICLE_TITLE']" value="${form.ARTICLE_TITLE}"/>
                                        <i class="ace-icon fa fa-info-circle"> </i>
                                   </span>
                                </div>
                                <label class="col-sm-1 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"> </i>
                                   分类
                                </label>
                                <div class="col-sm-2">
                                	<select class="form-control"  id="article_typeid" name="form['ARTICLE_TYPEID']"  data-validation-engine="validate[required]"  onchange="articleTypeChange()">
                                         <c:forEach items="${articletypesList }" var="item">
	                                        	<option <c:if test="${form.ARTICLE_TYPEID==item.dictionary_code}">selected="selected"</c:if> value="${item.dictionary_code }">${item.dictionary_name }</option>
	                                        </c:forEach>
                                    </select>
                                </div>
                                <label class="col-sm-1 control-label no-padding-right" id="article_statusid_show">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"> </i>
                                   状态
                                </label>
                                <div class="col-sm-2"  id="article_statusid_div">
                                	<select class="form-control"  id="article_statusid" name="form['ARTICLE_STATUSID']"  data-validation-engine="validate[required]" >
                                         <c:forEach items="${articlestatusList}" var="item">
	                                        	<option <c:if test="${form.ARTICLE_STATUSID==item.dictionary_code}">selected="selected"</c:if> value="${item.dictionary_code }">${item.dictionary_name }</option>
	                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-sm-2">
                                      <div class="page-toolbar align-right" style="padding:0px">
							                <button type="button" class="btn btn-xs    btn-xs-ths" id="btnSave" data-self-js="save()">
							                    <i class="ace-icon fa fa-save"></i>
							                    保存
							                </button>
							                <button type="button" class="btn btn-xs btn-xs-ths" id="btnReturn" data-self-js="goBack()">
							                    <i class="ace-icon fa fa-reply"></i>
							                    返回
							                </button>
							            </div>
                                </div>
                            </div>
                            <div class="form-group"  id="problemDiv" >
                                <label class="col-sm-1 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"></i>
                                   提出人
                                </label>
                                <div class="col-sm-3">
                                <input type="hidden" name="form['PROPOSER_USERID']"  value="${form.PROPOSER_USERID}"/> 
                                        <input type="text" class="form-control"
                                               data-validation-engine="validate[required]" placeholder=""
                                               name="form['PROPOSER_USERNAME']" value="${form.PROPOSER_USERNAME}"/>
                                </div>
                                <label class="col-sm-1 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"> </i>
                                   处理人
                                </label>
                                <div class="col-sm-2">
                                	<input type="text" class="form-control"
                                               data-validation-engine="validate[required]" placeholder=""
                                               name="form['HANDLE_USERNAME']" value="${form.HANDLE_USERNAME}"/>
                                </div>
                                <label class="col-sm-1 control-label no-padding-right">
                                    <i class="ace-icon fa fa-asterisk red smaller-70"> </i>
                                  处理时限
                                </label>
                                <div class="col-sm-2">
                                <div class="input-group">
                                	 <input type="text" class="form-control" readonly="readonly" id="txtSignDate" name="form['HANDLE_TIME']"  
                                        value="<fmt:formatDate value='${form.HANDLE_TIME}' type='date' pattern='yyyy-MM-dd'/>" data-validation-engine="validate[required]"/>
                                         <span class="input-group-btn">
                                        <button type="button" class="btn btn-white  " id="btnSignDate">
                                            <i class="ace-icon fa fa-calendar"></i>
                                        </button>
                                        </span>
                                        </div>
                                </div>
                                <div class="col-sm-2">
		                          
                                </div>
                            </div>
                            <hr class="no-margin">
                            <div class="form-group">
                                <div class="col-sm-12" style="padding-left: 0px" >
                                <textarea rows="10" id="article_content" name="form['ARTICLE_CONTENT']" style="resize:vertical;height:1px"
											data-validation-engine="validate[maxSize[6000]]">${form.ARTICLE_CONTENT}</textarea>
                                </div>
                            </div>
                            
                        </form>
                    </div>
                </div><!-- /.row -->
            </div>
        </div><!--/.main-content-inner-->
    </div><!-- /.main-content -->
</div><!-- /.main-container -->

<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
<script src="${ctx}/assets/components/ueditor/ueditor.config.js"></script>
<script src="${ctx}/assets/components/ueditor/ueditor.all.min.js"></script>
<script src="${ctx}/assets/components/ueditor/lang/zh-cn/zh-cn.js"></script>

<!-- 自己写的JS，请放在这里 -->
<script type="text/javascript">
	//暂存
	function save(){
		//提交之前，将多选人的值写到hidden中
		 if ($('#formInfo').validationEngine('validate')) {
			 ths.submitFormAjax({
		            url:'article_save.vm',// any URL you want to submit
		            data:$("#formInfo").serialize()// 如果不需要提交整个表单，可构造JSON提交，如{name:'老王',age:50}
		        	//如需自行处理返回值，请增加以下代码
		        	/*
		        	,success:function (response) {
						
					}
		        	*/
		        });
		 }
	}
	
	//返回
	function goBack() {
	    $("#main-container",window.parent.document).show();
	    $("#iframeInfo",window.parent.document).attr("src","").hide();
	}
	
	function articleTypeChange(){
		var article_typeid = $("#article_typeid").val();
		if(article_typeid=='problem'){
			$("#article_statusid_div").show();
			$("#article_statusid_show").show();
			$("#problemDiv").show();
			$("#title_div").removeClass("col-sm-6");
			$("#title_div").addClass("col-sm-3");
		}else{
			$("#article_statusid_div").hide();
			$("#article_statusid_show").hide();
			$("#problemDiv").hide();
			$("#title_div").removeClass("col-sm-3");
			$("#title_div").addClass("col-sm-6");
		}
	}
	
		jQuery(function ($) {
		    //日期控件使用示例，详细文档请参考http://www.my97.net/dp/demo/index.htm
		    $("#btnSignDate").on(ace.click_event, function () {
		        WdatePicker({el: 'txtSignDate'});
		    });
		
		    //表单验证组件初始化，详细文档请参考http://code.ciaoca.com/jquery/validation-engine/ 或官网文档http://posabsolute.github.io/jQuery-Validation-Engine/
		    $("#formInfo").validationEngine({
		        scrollOffset: 98,//必须设置，因为Toolbar position为Fixed
		        promptPosition: 'topRight',
		        autoHidePrompt: true
		    });
		    /* 
		    var ue = UE.getEditor('container'); */
		    articleTypeChange();
		    var contentHeight = $(window).height()-300;
		    $("#article_content").height(contentHeight);
		    var ue = UE.getEditor('article_content');
		    //container
		});
		
</script>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
	<head>
	    <title>codemirror ${THS_JDP_RES_DESC }</title>
		<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
		<script src="${ctx}/assets/js/eform/eform_custom.js"></script>
		<!-- codemirror core css and js -->
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/lib/codemirror.css">
		<script src="${ctx }/assets/components/codemirror/lib/codemirror.js"></script>
		<!-- codemirror fullscreen css and js -->
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/addon/display/fullscreen.css">
		<script src="${ctx }/assets/components/codemirror/addon/display/fullscreen.js"></script>
		<!-- codemirror hint css and js -->
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/addon/hint/show-hint.css" />
		<script src="${ctx }/assets/components/codemirror/addon/hint/show-hint.js"></script>
		<script src="${ctx }/assets/components/codemirror/addon/hint/sql-hint.js"></script>
		<script src="${ctx }/assets/components/codemirror/addon/hint/html-hint.js"></script>
		<script src="${ctx }/assets/components/codemirror/addon/hint/xml-hint.js"></script>
		<!-- codemirror fold css and js -->
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/addon/fold/foldgutter.css" />
		<script src="${ctx }/assets/components/codemirror/addon/fold/foldcode.js"></script>
  		<script src="${ctx }/assets/components/codemirror/addon/fold/foldgutter.js"></script>
  		<script src="${ctx }/assets/components/codemirror/addon/fold/brace-fold.js"></script>
  		<script src="${ctx }/assets/components/codemirror/addon/fold/xml-fold.js"></script>
  		<script src="${ctx }/assets/components/codemirror/addon/fold/comment-fold.js"></script>
		<!-- codemirror language css and js -->
		<script src="${ctx }/assets/components/codemirror/mode/sql/sql.js"></script>
		<script src="${ctx }/assets/components/codemirror/mode/xml/xml.js"></script>
		<script src="${ctx }/assets/components/codemirror/mode/htmlmixed/htmlmixed.js"></script>
		<!-- codemirror autorefresh css and js -->
		<script src="${ctx }/assets/components/codemirror/addon/display/autorefresh.js"></script>
		<!-- codemirror theme css -->
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/3024-day.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/3024-night.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/abcdef.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/ambiance.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/base16-dark.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/bespin.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/base16-light.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/blackboard.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/cobalt.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/colorforth.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/dracula.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/duotone-dark.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/duotone-light.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/eclipse.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/elegant.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/erlang-dark.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/hopscotch.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/icecoder.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/isotope.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/lesser-dark.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/liquibyte.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/material.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/mbo.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/mdn-like.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/midnight.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/monokai.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/neat.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/neo.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/night.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/oceanic-next.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/panda-syntax.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/paraiso-dark.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/paraiso-light.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/pastel-on-dark.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/railscasts.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/rubyblue.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/seti.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/shadowfox.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/solarized.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/the-matrix.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/tomorrow-night-bright.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/tomorrow-night-eighties.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/ttcn.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/twilight.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/vibrant-ink.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/xq-dark.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/xq-light.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/yeti.css">
		<link rel="stylesheet" href="${ctx }/assets/components/codemirror/theme/zenburn.css">
		
	  	<!--页面自定义的CSS，请放在这里 -->
	    <style type="text/css">
			.input-group-btn{
				vertical-align: top;
			}
			.label-middle{
				padding-top:5px;
			}
			hr{
				width:95%;
			}
			.CodeMirror {
	    		border: 1px solid #D5D5D5;
	    	}
	    	.CodeMirror-fullscreen{
	    		border-top: none;
	    	}
	    	.CodeMirror-hints {
	    		z-index: 9999;
	    	}
	    </style>
	</head>
	<body class="no-skin">
		<div class="main-container" id="main-container">
		    <div class="main-content">
		        <div class="main-content-inner fixed-page-header fixed-82">
		            <div id="breadcrumbs" class="breadcrumbs">
		                <ul class="breadcrumb">
		                    <li class="active">
		                        <h5 class="page-title" >
		                            <i class="fa fa-edit"></i>
									${THS_JDP_RES_DESC }
		                        </h5>
		                    </li>
		                </ul><!-- /.breadcrumb -->
		            </div>
			        <div class="main-content-inner padding-page-content" style="overflow: auto;">
			            <div class="page-content">
			                <div class="space-4"></div>
			                <div class="row">
			                	<div class="col-ms-12">SQL:</div>
			                    <div class="col-ms-12">
			                        <textarea id="editor_sql">SELECT * FROM DUAL</textarea>
			                    </div>
			                    <div style="height: 10px;"></div>
			                    <div class="col-ms-12">HTML:</div>
			                    <div class="col-ms-12">
			                        <textarea id="editor_html"><html>
	<head>
    </head>
	<body>
 	</body>
</html></textarea>
			                    </div>
			                    <div class="col-ms-12">XML:</div>
			                    <div class="col-ms-12">
			                        <textarea id="editor_xml"></textarea>
			                    </div>
			                    <div style="height: 10px;"></div>
			                    <div class="col-ms-12">换肤：
			                    	<select onchange="selectTheme()" id="themeSelect">
									    <option selected="">default</option>
									    <option>3024-day</option>
									    <option>3024-night</option>
									    <option>abcdef</option>
									    <option>ambiance</option>
									    <option>base16-dark</option>
									    <option>base16-light</option>
									    <option>bespin</option>
									    <option>blackboard</option>
									    <option>cobalt</option>
									    <option>colorforth</option>
									    <option>dracula</option>
									    <option>duotone-dark</option>
									    <option>duotone-light</option>
									    <option>eclipse</option>
									    <option>elegant</option>
									    <option>erlang-dark</option>
									    <option>hopscotch</option>
									    <option>icecoder</option>
									    <option>isotope</option>
									    <option>lesser-dark</option>
									    <option>liquibyte</option>
									    <option>material</option>
									    <option>mbo</option>
									    <option>mdn-like</option>
									    <option>midnight</option>
									    <option>monokai</option>
									    <option>neat</option>
									    <option>neo</option>
									    <option>night</option>
									    <option>oceanic-next</option>
									    <option>panda-syntax</option>
									    <option>paraiso-dark</option>
									    <option>paraiso-light</option>
									    <option>pastel-on-dark</option>
									    <option>railscasts</option>
									    <option>rubyblue</option>
									    <option>seti</option>
									    <option>shadowfox</option>
									    <option>solarized dark</option>
									    <option>solarized light</option>
									    <option>the-matrix</option>
									    <option>tomorrow-night-bright</option>
									    <option>tomorrow-night-eighties</option>
									    <option>ttcn</option>
									    <option>twilight</option>
									    <option>vibrant-ink</option>
									    <option>xq-dark</option>
									    <option>xq-light</option>
									    <option>yeti</option>
									    <option>zenburn</option>
									</select>
			                    </div>
			                    <div class="col-ms-12" style="color: red;">注：F11: 最大化/最小化，Ese取消最小化</div>
			                </div><!-- /.row -->
			            </div>
			        </div><!--/.main-content-inner-->
			    </div><!-- /.main-content -->
			</div><!-- /.main-container -->
		</div>
		<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
		
		<!-- 自己写的JS，请放在这里 -->
		<script type="text/javascript">
			
			function resize(){
				$(".main-content-inner").height($(window).height() - 82);
			}
			resize();
			window.resize = resize;
			$(function(){
				//初始化sql-codemirror
	    		editor_sql = CodeMirror.fromTextArea(document.getElementById('editor_sql'), {
					mode: 'text/x-sql',
					indentWithTabs: true,
					smartIndent: true,
					lineNumbers: true,
					matchBrackets : true,
					autofocus: true,
					autoRefresh: true,
					extraKeys: {
						"F11": function(cm) {
							cm.setOption("fullScreen", !cm.getOption("fullScreen"));
						},
						"Esc": function(cm) {
							if (cm.getOption("fullScreen")) cm.setOption("fullScreen", false);
						}
					}
				});
			  	//绑定keyup事件，设置textarea的值
	    		editor_sql.on('keyup', function(cm, event){
	    			//给textarea覆值（如果不覆值，serialize()获取的还是变更前的值）。
	    			$("#editor_sql").val(cm.doc.getValue());
	    			//判断当输入字母时，进行提示
	    			var pattern = /^[a-zA-Z]{1,}$/;
	    			if(event.key.length == 1 && pattern.test(event.key)){
	    				//判断仅当输入字符长度大于等于2，并且都为字母时才进行提示
	    				var searchChar = null;
		    			var lineContent = cm.doc.getLine(cm.getCursor("start").line);
		    			lineContent = lineContent.substring(0, cm.getCursor("start").ch);
		    			if(lineContent.indexOf(" ") > -1){
		    				searchChar = lineContent.substring(lineContent.lastIndexOf(" ") + 1);
		    			}else{
		    				searchChar = lineContent;
		    			}
		    			if(searchChar.length > 1 && pattern.test(searchChar)){
		    				editor_sql.showHint({
		    					completeSingle: false
		    				});
		    			}
	    			}
	    		});
			  	
	    		var tags = {
					"!top": ["root"], //根节点
				    "!attrs": { //公共属性
				 		id: null
				   	},
				   	root: {
						children: ["datacols", "paramlist", "page", "data", "creator", "toolbar", "actionlist", "script"]
					},
					datacols: {
						attrs: {
				            name: null
						},
						children: ["col"]
				  	},
				  	paramlist: {
				    	children: ["param"]
				 	},
				 	toolbar: {
				    	children: ["operations", "querys"]
				 	},
				 	operations: {
				    	children: ["operation"]
				 	},
				 	querys: {
				    	children: ["query"]
				 	},
				 	actionlist: {
				    	children: ["action"]
				 	},
				 	action: {
				    	children: ["param"]
				 	}
				};
			  	
	    		//初始化xml-codemirror
	    		editor_xml = CodeMirror.fromTextArea(document.getElementById('editor_xml'), {
					mode: 'xml',
					indentWithTabs: true,
					indentUnit: 0,
					lineNumbers: true,
					matchBrackets : true,
					autofocus: true,
					autoRefresh: true,
					foldGutter: true,
				    gutters: ["CodeMirror-linenumbers", "CodeMirror-foldgutter"],
				    hintOptions: {schemaInfo: tags},
					extraKeys: {
						"F11": function(cm) {
							cm.setOption("fullScreen", !cm.getOption("fullScreen"));
						},
						"Esc": function(cm) {
							if (cm.getOption("fullScreen")) cm.setOption("fullScreen", false);
						}
					}
				});
			  	//绑定keyup事件，设置textarea的值
	    		editor_xml.on('keyup', function(cm, event){
	    			//给textarea覆值（如果不覆值，serialize()获取的还是变更前的值）。
	    			$("#editor_xml").val(cm.doc.getValue());
	    			if(event.key.length == 1 && (event.key == "<" || event.key == "/")){
	    				editor_xml.showHint({
	    					completeSingle: false
	    				});
	    			}
	    		});
			  	
	    		//初始化html-codemirror
	    		editor_html = CodeMirror.fromTextArea(document.getElementById('editor_html'), {
					mode: 'text/html',
					indentWithTabs: true,
					indentUnit: 0,
					lineNumbers: true,
					matchBrackets : true,
					autofocus: true,
					autoRefresh: true,
					foldGutter: true,
				    gutters: ["CodeMirror-linenumbers", "CodeMirror-foldgutter"],
					extraKeys: {
						"F11": function(cm) {
							cm.setOption("fullScreen", !cm.getOption("fullScreen"));
						},
						"Esc": function(cm) {
							if (cm.getOption("fullScreen")) cm.setOption("fullScreen", false);
						}
					}
				});
			  	//绑定keyup事件，设置textarea的值
	    		editor_html.on('keyup', function(cm, event){
	    			//给textarea覆值（如果不覆值，serialize()获取的还是变更前的值）。
	    			$("#editor_html").val(cm.doc.getValue());
	    			if(event.key.length == 1 && (event.key == "<" || event.key == "/")){
	    				editor_html.showHint({
	    					completeSingle: false
	    				});
	    			}
	    		});
			});
			
			//更换主题
			function selectTheme(){
				editor_sql.setOption("theme", $("#themeSelect option:selected").text());
				editor_xml.setOption("theme", $("#themeSelect option:selected").text());
				editor_html.setOption("theme", $("#themeSelect option:selected").text());
			}
		</script>
	</body>
</html>

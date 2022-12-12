	//字典维护页面用到此方法
	function generateUUID() {
		var d = new Date().getTime();
		var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g,
				function(c) {
					var r = (d + Math.random() * 16) % 16 | 0;
					d = Math.floor(d / 16);
					return (c == 'x' ? r : (r & 0x3 | 0x8)).toString(16);
				});
		return uuid;
	};
	//iframe自动高,offsetHeight为边框高度之和
	 function autoHeightIframe()
	 {
		 var iframeId = arguments[0];
		 var offset = 4;
		 if(arguments.length >1) offset =  arguments[1];
		 var __frmInfo = document.getElementById(iframeId);
		 if(__frmInfo)
		 {
			 __resizeIframe(__frmInfo,offset);
			 ths.bind(window,"resize",function(){
				 __resizeIframe(__frmInfo,offset);
			 });
		  }
	 }
	//offsetHeight为边框高度之和
	 function __resizeIframe(frm,offsetHeight) {
	        var height = document.documentElement.clientHeight;
	        height -= offsetHeight;//边框的高度之和
	        frm.style.height = height + "px";
	 }

    /**
     * 执行数据批量删除
     * @param __ids 为英文逗号分隔的ID字符串,也可仅传递一个ID,执行单个删除
     * @param  serverUrl 服务器端AJAX POST 地址
     * @param callBackFn 删除成功的回调函数,无参数,如function(){}
     */
    function __doDelete(__ids,serverUrl,callBackFn){
        if(__ids.length == 0){
            dialog({
                title: '提示',
                content: '请选择要删除的记录!',
                wraperstyle:'alert-warning',
                ok: function () {}
            }).showModal();
        }
        else{
            dialog({
                title: '删除',
                icon:'fa-times-circle',
                wraperstyle:'alert-warning',
                content: '确实要删除选定记录吗?',
                ok: function () {
                    //TODO ajax submit
                	ths.submitFormAjax(
                			{
                				url:serverUrl,
                				data:{'id':__ids},
                				callback:callBackFn
                			}
                	);
                },
                cancel:function(){}
            }).showModal();
        }
    }

	//ajax提交表单
	ths.submitFormAjax = function (options) {
		var __options = {
			type:"post",
			url:"",
			data:{},
			callback:function () {
				//todo:search 提交成功，默认刷新列表页
				if(!window.parent) return;
				if(window.parent.doSearch) window.parent.doSearch();
				$("#iframeInfo",window.parent.document).attr("src","").hide();
				$("#main-container",window.parent.document).show();
			},
			success:function (response) {
				console.log(response);
				if (response == "success") {
					this.callback();
				}
				else {
					dialog({
						title: '信息',
						content: response,
						ok: function () {}
					}).showModal();
				}
			},
			error:function (msg) {
				dialog({
					title: '错误',
					icon:'fa-times-circle',
					wraperstyle:'alert-warning',
					content: msg.responseText,
					ok: function () {}
				}).showModal();
			}
		};
	
		var _options = $.extend({},__options,options);
		$.ajax(_options);
	}
	
	//validate校验时忽略空值
	ths.hideNullValidate=function(formid,func){
		//将空值的validate校验去掉
		$("#"+formid+" [data-validation-engine]").each(function(){
			var _value=$(this).val().trim();
			if(_value==""){
				$(this).val("");
				$(this).attr("data-validation-engine-hide",$(this).attr("data-validation-engine"));
				$(this).removeAttr("data-validation-engine");
			}
		});
		if($("#formInfo").validationEngine("validate")){
			func();
		}
		//将空值的validate校验加上
		$("#"+formid+" [data-validation-engine-hide]").each(function(){
			$(this).attr("data-validation-engine",$(this).attr("data-validation-engine-hide"));
			$(this).removeAttr("data-validation-engine-hide");
		})
	}
	
	//初始化表格事件
	function __doInitTableEvent(tableId)
	{
		//根据orderBy隐藏域的值，初始化排序信息
        var arrOlderBy =[];
        var sortcolumn="",sortdirection="";
        if($("#orderBy").length > 0)
            arrOlderBy =$("#orderBy").val().split(" ");
        if(arrOlderBy.length >=2)
        {
            sortcolumn = arrOlderBy[0];
            sortdirection = arrOlderBy[1];
        }
        if(sortcolumn != "" && sortdirection != "")
        {
            $("[data-sort-col='"+sortcolumn+"']").find("i:last")
                    .removeClass("fa-sort").addClass("sort-current fa-sort-" + sortdirection.split(",")[0]);
        }
        
      //为表格添加排序事件,点击后提交表单，页面会刷新
        $("[data-sort-col]").on(ace.click_event, function (e) {
            sortcolumn = $(this).data("sort-col");
            sortdirection = "asc";//默认asc
            var $i = $(this).find("i:last");
            if ($i.hasClass("fa-sort")) {
                $i.removeClass("fa-sort").addClass("sort-current fa-sort-asc");
                sortdirection = "asc";
            }
            else if ($i.hasClass("fa-sort-asc")) {
                $i.removeClass("fa-sort-asc").addClass("sort-current fa-sort-desc");
                sortdirection = "desc";
            }
            else if ($i.hasClass("fa-sort-desc")) {
                $i.removeClass("fa-sort-desc").addClass("sort-current fa-sort-asc");
                sortdirection = "asc";
            }
            $("#orderBy").val(sortcolumn + " " + sortdirection);
            $("#pageNum").val("0");
            //TODO:提交
            $("#orderBy").closest("form").submit();
        });

        //表头的checkbox 全选/反选
        var active_class = 'active';
        $('#' + tableId + ' > thead > tr > th input[type=checkbox]').eq(0).on('click', function(){
            var th_checked = this.checked;//checkbox inside "TH" table header

            $(this).closest('table').find('tbody > tr').each(function(){
                var row = this;
                if(th_checked) $(row).addClass(active_class).find('input[type=checkbox]').eq(0).prop('checked', true);
                else $(row).removeClass(active_class).find('input[type=checkbox]').eq(0).prop('checked', false);
            });
        });

        //每行的checkbox  checked/unchecked
        $('#' + tableId).on('click', 'td input[type=checkbox]' , function(){
            var $row = $(this).closest('tr');
            if(this.checked) $row.addClass(active_class);
            else $row.removeClass(active_class);
        });
        
	}
	//提示弹框
	ths.dialog=function(msg,icon,style){
		dialog({
			title: '提示',
			icon:!icon?'fa-info-circle':icon,
			wraperstyle:!style?'alert-info':style,
			content: msg,
			ok: function () {}
		}).showModal();
	}
	/**
	 * 平台扩展的resizable方法
	 */
	var initWidth;
	var initHeight;
	jQuery.fn._resizable=function(options){
		var _this = this;
		var _option = {};
		$.extend(_option,options);
		_option.start = function(event,ui){
			//将页面中的iframe鼠标事件禁用，以防影响拖动
			$("iframe").css("pointer-events","none");
			if(options.hasOwnProperty("start")){
				options.start(event,ui);
			}
		}
		_option.create = function(event,ui){
			initWidth = $(_this).width();
			initHeight = $(_this).height();
			if(options.hasOwnProperty("create")){
				options.create(event,ui);
			}
		}
		_option.resize = function(event,ui){
			if(initWidth!=ui.size.width){
				$(_this).next().css("width","calc(100% - "+ui.size.width+"px)");
			}
			if(initHeight!=ui.size.height){
				$(_this).next().css("height","calc(100% - "+ui.size.height+"px)");
			}
			if(options.hasOwnProperty("resize")){
				options.resize(event,ui);
			}
		}
		_option.stop = function(event,ui){
			//修正快速拖动时所造成的计算误差
			if(initWidth!=ui.size.width){
				$(_this).next().css("width","calc(100% - "+ui.size.width+"px)");
			}
			if(initHeight!=ui.size.height){
				$(_this).next().css("height","calc(100% - "+ui.size.height+"px)");
			}
			//将页面中的iframe鼠标事件禁用，以防影响拖动
			$("iframe").css("pointer-events","auto");
			if(options.hasOwnProperty("stop")){
				options.stop(event,ui);
			}
		}
		$(this).resizable(_option);
	}

    jQuery(function ($) {
        //data-self-href添加链接点击事件
        $("[data-self-href]").on(ace.click_event,function (e) {
            var _href = $(this).data("self-href");
            if(_href.trim() == "") return;
            $("#main-container").hide();
            $("#iframeInfo").attr("src",_href).show();
        });
        $("[data-self-js]").on(ace.click_event,function (e) {
            eval($(this).data("self-js"));
        });
    });

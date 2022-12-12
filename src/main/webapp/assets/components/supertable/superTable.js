(function($) {
	 // 封装获取滚动条宽度的方法
    function getScrollBarWidth() {
        var el = document.createElement("p"),
            styles = {
                width: "100px",
                height: "100px",
                overflowY: "scroll"
            },
            i;

        // 这里很巧妙呀，先定义了一个styles对象，里面写了各种样式值，然后通过for in将这个对象的值赋给p元素的style对象
        // 而不用通过style.width=***等来给p的样式对象赋值。
        for (i in styles) {
            el.style[i] = styles[i];
        }
        // 将元素加到body里面
        document.body.appendChild(el);
        var scrollBarWidth = el.offsetWidth - el.clientWidth;
        //将添加的元素删除
        $(el).remove();
        var userAgent = navigator.userAgent; 
        if(userAgent.indexOf("Chrome") > -1){
        	scrollBarWidth = scrollBarWidth-3;
        }else if(userAgent.indexOf("Firefox") > -1){
        	scrollBarWidth = scrollBarWidth-1;
        }
        return scrollBarWidth;
    }
    
	//获取滚动条的宽度
	$.fn.superTable = function(options){
		var $table = $(this);
		var col;
		var row;
		var superTableHeight;
		var superTableWidth;
		var scrollWidth;
		var tableClass = $table.attr("class");
		//将table包裹在一个div中
		$table.wrap("<div id='wrapDiv'></div>");
		var $wrapDiv = $("#wrapDiv");
		if(options){
			col = options.col;
			row = options.row;
			scrollWidth = options.scrollWidth;
			superTableHeight = options.superTableHeight;
			superTableWidth = options.superTableWidth;
		}
		var totalCount = $table.find("tr").length;
		if(!col){
			col = 0;
		}
		if(!row){
			row = 0;
		}
		if ((row > 0 || col > 0) == false ||  totalCount == 0) {
			$wrapDiv.css({"width":"100%","overflow-x":"auto"});
	        return;
	    }
		$table.css("overflow-x", "hidden");
		if(!scrollWidth){
			scrollWidth = 10;
		}
		
		for (var i = 0; i < $table.find("th").length; i++) {
	        var width = $($table.find("th")[i]).width();
	        $($table.find("th")[i]).css('width', width); // 用原来的宽度设置一次表格列宽度???
	    }
		//修正设置的高度值
		if(!superTableHeight){
			$("html").css("overflow","hidden");
	        $("body").css("overflow","hidden");
	        $("body").height($(window).height());
			if($table.height()+$table.offset().top+$("#zcz_page").height()+30>$(window).height()){
				superTableHeight = $(window).height()-$table.offset().top-$("#zcz_page").height()-20;
			}else{
				superTableHeight = $table.height()+20;
			}
		}else{
			if($table.height()<superTableHeight){
				superTableHeight = $wrapDiv.height();
			}
		}
		//修正设置的宽度值
		if(!superTableWidth){
			superTableWidth = $wrapDiv.width();
		}
		$table.jFixedtable({fixedCols: col, width:superTableWidth, height:superTableHeight, headerRows: row });
		//修改锁定行列后的宽度
		$(".sBase").find("table").attr("class",tableClass);
		var baseWidth = $(".sBase").width();
		var headerWidth = $(".sHeader").width();
		var $headerThs = $(".sHeader").find("th");
		var $dataThs = $(".sData").find("th");
		var $fHeaderThs = $(".sFHeader").find("th");
		var $fDataThs = $(".sFData").find("th");
		var $dataTrs = $(".sData").find("tr");
		var $fDataTrs = $(".sFData").find("tr");
		var scrollWidth = getScrollBarWidth();
		if(baseWidth > headerWidth){
			var avgAdd = (baseWidth-headerWidth-scrollWidth)/$headerThs.length;
			for(var i =0;i<$headerThs.length;i++){
				$($headerThs[i]).width($($headerThs[i]).width()+avgAdd);
				$($dataThs[i]).width($($dataThs[i]).width()+avgAdd);
			}
		}
		//修正锁定列的宽度
		for(var i = 0;i<$headerThs.length;i++){
			$($fHeaderThs[i]).width($($headerThs[i]).width());
			$($fHeaderThs[i]).height($($headerThs[i]).height())
			$($fDataThs[i]).width($($headerThs[i]).width());
			
		}
		//修正锁定列的高度
		for(var i = 0;i<$dataTrs.length;i++){
			$($fDataTrs[i]).height($($dataTrs[i]).height());
		}
	}
})(jQuery);

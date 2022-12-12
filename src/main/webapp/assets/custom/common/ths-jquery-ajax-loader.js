var thsAjaxLoader = {
	loaderObj : $('<div id="ths-ajax-loader" class="ths-ajax-loader-background" style="display:none;" ><div class="ths-ajax-loader" ></div></div>'),
	showNum : 0,
	showIndex : 0,
	showReqs : {},
	showTimer : null,
	checkThsAjaxLoader : function() {
		var showReqs = this.showReqs;
		$.each(showReqs, function(key, value) {
			if (value.readyState === 4) {
				delete showReqs[key];
			}
		});

		if ($.isEmptyObject(showReqs)) {
			this.loaderObj.hide();
			window.clearInterval(this.showTimer);
			this.showTimer = null;
		}
	},
	showThsAjaxLoader : function() {
		this.showNum++;
		this.loaderObj.show();
	},
	closeThsAjaxLoader : function() {
		this.showNum--;
		if (this.showNum <= 0) {
			this.showNum = 0;
			this.loaderObj.hide();
		}
	}
};
// 生成遮罩层
thsAjaxLoader.loaderObj.appendTo($('body'));

$(document).on('ajaxSend', function(event, request, settings) {
	if (settings.isShowLoader) {
		var aIndex = thsAjaxLoader.showIndex;
		thsAjaxLoader.showIndex++;
		thsAjaxLoader.showReqs[aIndex] = request;
		settings.thsAjaxLoaderShowIndex = aIndex;
		if (thsAjaxLoader.showTimer == null) {
			thsAjaxLoader.showTimer = window.setInterval(function() {
				thsAjaxLoader.checkThsAjaxLoader();
			}, 1000);
		}

		thsAjaxLoader.showThsAjaxLoader();
	}
});

$(document).on('ajaxComplete', function(event, request, settings) {
	if (settings.isShowLoader) {
		delete thsAjaxLoader.showReqs[settings.thsAjaxLoaderShowIndex];

		thsAjaxLoader.closeThsAjaxLoader();
	}
});

// 兼容旧版
jQuery.ajaxSetup({
	isShowLoader : false,
	showThsLoader : function() {
		if (this.isShowLoader) {
			thsAjaxLoader.showThsAjaxLoader();
		}
	},
	hideThsLoader : function() {
		if (this.isShowLoader) {
			thsAjaxLoader.closeThsAjaxLoader();
		}
	}
});

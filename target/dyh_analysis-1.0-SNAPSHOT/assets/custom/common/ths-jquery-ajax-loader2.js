var thsAjaxLoader = null;

$(function () {
    if (window.top && window.top.thsAjaxLoader) {
        thsAjaxLoader = window.top.thsAjaxLoader;
    } else {
        $("<style></style>").text('.ths-ajax-loader-background {position: fixed;top: 0;left: 0;right: 0;bottom: 0;background-color: #BCBCBC;z-index: 3001;opacity: 0.2;filter: alpha(opacity = 20);}  .ths-ajax-loader-background.hidden {display: none;}  .ths-ajax-loader {position: absolute;top: calc(50% - 48px);left: calc(50% - 48px);border-radius: 50%;width: 96px;height: 96px;z-index: 100;font-size: 5px;text-indent: -9999em;border-top: 1.1em solid rgba(100, 100, 100, 1);border-right: 1.1em solid rgba(100, 100, 100, 1);border-bottom: 1.1em solid rgba(100, 100, 100, 1);border-left: 1.1em solid #ffffff;transform: translateZ(0);animation: ths-load8 1.1s infinite linear;}  @keyframes ths-load8 { 0% {transform: rotate(0deg);} 100% {transform : rotate(360deg);} }').appendTo($("head"));

        thsAjaxLoader = {
            loaderObj: $('<div id="ths-ajax-loader" class="ths-ajax-loader-background" style="display:none;" ><div class="ths-ajax-loader" ></div></div>'),
            showNum: 0,
            showIndex: 0,
            showReqs: {},
            showTimer: null,
            checkThsAjaxLoader: function () {
                var showReqs = this.showReqs;
                $.each(showReqs, function (key, value) {
                    if (value.readyState === 4 || value.thsWindow.closed || (new Date().getTime() - value.thsTimestamp) > 90000) {
                        delete showReqs[key];
                    }
                });

                if ($.isEmptyObject(showReqs)) {
                    this.loaderObj.hide();
                    window.clearInterval(this.showTimer);
                    this.showTimer = null;
                }
            },
            showThsAjaxLoader: function () {
                this.showNum++;
                this.loaderObj.show();
            },
            closeThsAjaxLoader: function () {
                this.showNum--;
                if (this.showNum <= 0) {
                    this.showNum = 0;
                    this.loaderObj.hide();
                }
            }
        };

        // 生成遮罩层
        thsAjaxLoader.loaderObj.appendTo($('body'));
    }

    $(document).on('ajaxSend', function (event, request, settings) {
        if (settings.isShowLoader !== false) {
            let aIndex = thsAjaxLoader.showIndex;
            thsAjaxLoader.showIndex++;
            thsAjaxLoader.showReqs[aIndex] = request;
            settings.thsAjaxLoaderShowIndex = aIndex;
            if (thsAjaxLoader.showTimer == null) {
                thsAjaxLoader.showTimer = window.setInterval(function () {
                    thsAjaxLoader.checkThsAjaxLoader();
                }, 1000);
            }

            request.thsWindow = window;
            request.thsTimestamp = new Date().getTime();

            thsAjaxLoader.showThsAjaxLoader();
        }
    });

    $(document).on('ajaxComplete', function (event, request, settings) {
        if(settings.thsAjaxLoaderShowIndex>-1){
            request.thsWindow = null;
            delete thsAjaxLoader.showReqs[settings.thsAjaxLoaderShowIndex];

            thsAjaxLoader.closeThsAjaxLoader();
        }
    });

    // 兼容旧版
    // jQuery.ajaxSetup({
    // 	isShowLoader : false,
    // 	showThsLoader : function() {
    // 		if (this.isShowLoader) {
    // 			thsAjaxLoader.showThsAjaxLoader();
    // 		}
    // 	},
    // 	hideThsLoader : function() {
    // 		if (this.isShowLoader) {
    // 			thsAjaxLoader.closeThsAjaxLoader();
    // 		}
    // 	}
    // });
});




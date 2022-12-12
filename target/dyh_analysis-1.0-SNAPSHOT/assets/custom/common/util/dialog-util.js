/**
 * Dialog工具类
 */
var DialogUtil = {
    /**
     * 显示提示Dialog
     * @param {String} message 消息
     * @param {function} callback 确认的回调函数
     */
    showTipDialog: function (message, callback) {
        var s = dialog({
            id: 'msg-show-dialog',
            title: '提示',
            content: message,
            okValue: '确定',
            cancelDisplay: false,
            ok: function () {
                s.close().remove();
                if (callback) {
                    callback();
                }
            },
            cancel: function () {
                if (callback) {
                    callback();
                }
            }
        });
        s.showModal();
    },
    /**
     * 显示删除的dialog
     * @param {String} message 消息
     * @param {function} okCallback 确认的回调函数
     * @param {function} cancelCallback 取消的回调函数
     */
    showDeleteDialog: function (message, okCallback, cancelCallback) {
        this.showConfirmDialog(message || '删除选中的数据，请确认！', okCallback, cancelCallback);
    },
    /**
     * 显示确认Dialog
     * @param {String} message 消息
     * @param {function} okCallback 确认的回调函数
     * @param {function} cancelCallback 取消的回调函数
     */
    showConfirmDialog: function (message, okCallback, cancelCallback) {
        var s = dialog({
            title: '提示',
            icon: 'fa-info',
            wraperstyle: 'alert-info',
            content: message,
            okValue: '确定',
            cancelValue: '取消',
            ok: function () {
                if (okCallback) {
                    okCallback();
                }
            },
            cancel: function () {
                if (cancelCallback) {
                    cancelCallback();
                }
            },
        });
        s.showModal();
    },
    /**
     * 缓存dialog对象
     */
    thisDialog: null,
    /**
     * 显示Dialog
     * @param {String|HTMLElement} urlOrElement 需要显示是页面
     * @param {Number} widthPercent 宽度百分比（相对window宽度）(0~1)
     * @param {Number} heightPercent 高度百分比（相对window高度）(0~1)
     * @param {string} title 标题
     * @param {Function} okCallBack 确认回调函数
     * @param {Function} cancelCallback 取消回调函数
     * @return dialog对象
     */
    showDialog: function (urlOrElement, widthPercent, heightPercent, title, okCallBack, cancelCallback) {
        var option = {
            title: title,
            width: $(window).width() * widthPercent,
            height: $(window).height() * heightPercent,
            ok: okCallBack instanceof Function ? okCallBack : null,
            cancel: cancelCallback instanceof Function ? cancelCallback : null,
            onclose: function () {
                DialogUtil.thisDialog = null;
            },
        };

        if (typeof urlOrElement === 'string') {
            option.url = urlOrElement;
        } else {
            option.content = urlOrElement;
        }

        this.thisDialog = dialog(option);
        this.thisDialog.param_widthPercent = widthPercent;
        this.thisDialog.param_heightPercent = heightPercent;
        this.thisDialog.showModal();
        return this.thisDialog;
    },
    /**
     * 显示全屏Dialog
     * @param {String} url 需要显示是页面
     * @return dialog对象
     */
    showFullScreenDialog: function (url) {
        return this.showDialog(url, 1, 1, null, null, null);
    }
};

$(window).on('resize', function () {
    var thisDialog = DialogUtil.thisDialog;
    if (thisDialog) {
        var $window = $(window);
        thisDialog.width($window.width() * thisDialog.param_widthPercent);
        thisDialog.height($window.height() * thisDialog.param_heightPercent);
    }
});
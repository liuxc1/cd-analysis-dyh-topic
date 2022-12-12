/**
 * 文件下载工具类
 */
var FileDownloadUtil = {
    /**
     * 文件查询相对路径
     */
    fileListQueryUrl: '/system/file/file/queryFileList.vm',
    /**
     * 文件下载相对路径
     */
    fileDownloadUrl: '/system/file/file/downloadFile.vm',
    /**
     * 文件下载专用iframe对象
     */
    fileDownloadForm: null,
    /**
     * 文件下载
     * @param {String} url 下载地址
     * @param {Object} params  请求参数
     */
    downloadFile: function (url, params) {
        var _this = this;
        DialogUtil.showConfirmDialog("下载选中的文件，请确认！", function () {
            // 下载文件
            _this.createSubmitTempForm(url, params);
        }, null);
    },
    /**
     * 创建并提交临时表单
     * @param {String} url 表单url
     * @param {json || Object} params 表单参数
     */
    createSubmitTempForm: function (url, params) {
        var form = this.fileDownloadForm;
        if (form == null) {
            $('<iframe name="fileDownloadIframe" src="" style="display: none;"><iframe>').appendTo('body');
            // 定义一个form表单
            form = $('<form style="display: none;" target="fileDownloadIframe" method="post" action=""></form>');
            form.appendTo('body');
            this.fileDownloadForm = form;
        }
        form.empty();
        form.prop("action", url);
        $.each(params, function (key, value) {
            if (value || value === 0) {
                var input = $('<input type="hidden" name="" value="">');
                input.prop("name", key);
                input.prop("value", value);
                form.append(input);
            }
        });
        form.submit();
    }
};
/**
 * 文件下载工具类
 */
var FileDownloadUtil = {
	/**
	 * 文件下载
	 * @param {String} fileId 下载文件ID
	 */
	downloadFile: function (fileId) {
		var _this = this;
		DialogUtil.showConfirmDialog("下载选中的文件，请确认！", function () {
			// 查询文件信息的url
			var url = ctx + '/system/file/file/queryFile.vm';
			// 查询文件信息
			AjaxUtil.sendAjaxRequest(url, null, {fileId: fileId}, function (json) {
				// 下载文件的url
				url = ctx + '/system/file/file/downloadFile.vm';
				// 下载文件
				_this.createSubmitTempForm(url, json.data);
			}, function (json) {
				DialogUtil.showTipDialog(json.meta.message);
			});
		});
	},
	/**
	 * 创建并提交临时表单
	 * @param {String} url 表单url
	 * @param {json || Object} params 表单参数
	 */
	createSubmitTempForm: function (url, params) {
		var form = $("<form>"); // 定义一个form表单
        form.attr("class", "hidden");
        form.attr("target", "");
        form.attr("method", "post");
        form.attr("action", url);
        for(var key in params){
        	var input = $("<input>");
        	input.attr("type", "hidden");
        	input.attr("name", key);
        	input.attr("value", params[key]);
            form.append(input);
        }
        $("body").append(form); // 将表单放置在web中
        form.submit().remove(); // 表单提交
	}
};
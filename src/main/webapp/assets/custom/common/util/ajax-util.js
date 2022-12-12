/**
 * Ajax 工具类
 */
var AjaxUtil = {
    /**
     * 发送Ajax请求
     * @param {String} ajaxOption 发送请求配置
     * @param {function} successCallback 请求成功回调函数
     * @param {function} failureCallback 请求失败回调函数
     * @param {function} errorCallback 请求错误回调函数
     */
    doSendAjax: function (ajaxOption, successCallback, failureCallback, errorCallback) {
        return new Promise((resolve, reject) => {
            if (ajaxOption.isShowLoader === undefined) {
                ajaxOption.isShowLoader = true;
            }
            if (ajaxOption.xhrFields === undefined) {
                ajaxOption.xhrFields = {
                    withCredentials: true
                };
            }
            if (ajaxOption.crossDomain === undefined) {
                ajaxOption.crossDomain = true;
            }
            ajaxOption.success = function (json) {
                if (json && json.success === false) {
                    if (failureCallback) {
                        failureCallback(json);
                    } else {
                        if (DialogUtil) {
                            DialogUtil.showTipDialog(json.message ? json.message : '网络异常', null);
                        } else {
                            console.log(json.message ? json.message : '网络异常', json);
                        }
                    }
                } else {
                    if (successCallback) {
                        successCallback(json);
                    }
                }

                resolve(json);
            };
            ajaxOption.error = function (e) {
                if (errorCallback) {
                    errorCallback(e);
                } else {
                    if (DialogUtil) {
                        DialogUtil.showTipDialog('网络异常', null);
                    } else {
                        console.log('网络异常');
                    }
                    console.log('ajax-error', e);
                }
                reject(e);
            };
            $.ajax(ajaxOption);
        });
    },
    /**
     * 发送Ajax请求
     * @param {String} url 发送请求的地址
     * @param {string} type 请求类型
     * @param {Object} data 请求数据
     * @param {function} successCallback 请求成功回调函数
     * @param {function} failureCallback 请求失败回调函数
     * @param {function} errorCallback 请求错误回调函数
     */
    sendAjaxRequest: function (url, type, data, successCallback, failureCallback, errorCallback) {
        return this.doSendAjax({
            url: url,
            type: type || 'post',
            data: data,
            dataType: 'json',
            isShowLoader: true, // 加载动画，参考ths-jquery-ajax-loader.js
            xhrFields: {
                withCredentials: true
            },
            crossDomain: true,
        }, successCallback, failureCallback, errorCallback);
    },
    /**
     * 发送Ajax Post请求
     * @param {String} url 发送请求的地址
     * @param {Object} data 请求数据
     * @param {function} successCallback 请求成功回调函数
     * @param {function} failureCallback 请求失败回调函数
     * @param {function} errorCallback 请求错误回调函数
     */
    sendPostAjaxRequest: function (url, data, successCallback, failureCallback, errorCallback) {
        return this.sendAjaxRequest(url, 'post', data, successCallback, failureCallback, errorCallback);
    },
    /**
     * 发送Ajax请求
     * @param {String} url 发送请求的地址
     * @param {Object} data 请求数据
     * @param {function} successCallback 请求成功回调函数
     * @param {function} failureCallback 请求失败回调函数
     * @param {function} errorCallback 请求错误回调函数
     */
    sendAjax: function (url, data, successCallback, failureCallback, errorCallback) {
        return this.sendPostAjaxRequest(url, data, successCallback, failureCallback, errorCallback);
    },
    /**
     * 发送Ajax请求
     * @param {String} url 发送请求的地址
     * @param {Object} data 请求数据
     * @param {function} successCallback 请求成功回调函数
     * @param {function} failureCallback 请求失败回调函数
     * @param {function} errorCallback 请求失败回调函数
     */
    sendAjaxMultipart: function (url, data, successCallback, failureCallback, errorCallback) {
        return this.doSendAjax({
            url: url,
            type: 'post',
            data: data,
            processData: false, // 不需要对数据做处理（重点）
            contentType: false, // 修改发送给服务器的格式（重点）
            dataType: 'json',
            isShowLoader: true, // 加载动画，参考ths-jquery-ajax-loader.js
            xhrFields: {
                withCredentials: true
            },
            crossDomain: true,
        }, successCallback, failureCallback, errorCallback);
    },
    /**
     * 发送Ajax请求(json参数)
     * @param {String} url 发送请求的地址
     * @param {Object} data 请求数据
     * @param {function} successCallback 请求成功回调函数
     * @param {function} failureCallback 请求失败回调函数
     * @param {function} errorCallback 请求错误回调函数
     */
    sendAjaxJson: function (url, data, successCallback, failureCallback, errorCallback) {
        return this.doSendAjax({
            url: url,
            type: 'post',
            data: JSON.stringify(data),
            dataType: 'json',
            isShowLoader: true, // 加载动画，参考ths-jquery-ajax-loader.js
            contentType: "application/json;charset=utf-8",
            xhrFields: {
                withCredentials: true
            },
            crossDomain: true,
        }, successCallback, failureCallback, errorCallback);
    },
    /**
     * 发送文件上传Ajax请求
     * @param {String} url 发送请求的地址
     * @param {MyFormData} myFormData 自定义表单数据对象，通过new MyFormData()创建得到
     * @param {function} successCallback 请求成功回调函数
     * @param {function} failureCallback 请求失败回调函数
     * @param {function} errorCallback 请求错误回调函数
     */
    sendFileUploadAjaxRequest: function (url, myFormData, successCallback, failureCallback, errorCallback) {
        return this.sendAjaxMultipart(url, myFormData.formData, successCallback, failureCallback, errorCallback);
    }
};
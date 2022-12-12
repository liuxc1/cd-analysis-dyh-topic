/*
* 存放接口、服务地址
*/
var config = {
    //主机地址
    hostUrl: "/service/serviceinterface/search/run.action?",
    socketServer: "/dyh_view",
    socketServerYj: "/dyh_analysis/dyh_view",
    token: 'token=dcp',
    //大屏编码
    codeHidden: 'hiddenDetailIframe',//隐藏大气环境右屏
    codeRight: 'rightContent',//打开大气环境右屏
    codeHiddenRightYj: 'yhRightHiddenDetailIframe',//隐藏环境应急环境右屏
    codeShowRightYj: 'yjRightContent',//打开环境应急环境右屏
};
var utils = {
    /**
     * 站位随机数
     */
    testSJ(min, max) {
        //x上限，y下限
        return parseInt(Math.random() * (max - min + 1) + min);
    },
    /**
     *
     * @param date    yyyy-MM-dd HH:mm:ss
     * @param num     增减数量
     * @param unit    year,month,day,hour,min,ss
     */
    getDateAdd(time, num, unit, format) {
        if (!unit || unit.length <= 0) {
            console.error('未设置时间单位');
            return;
        }
        if (!time || time.length < 0) {
            console.error('未设置时间');
            return;
        }
        if (!num || num.length < 0) {
            console.error('未设置增减数量');
            return;
        }
        let dateN = new Date(time);
        switch (unit){
            case 'year':   dateN.setFullYear(dateN.getFullYear() + num);break;
            case 'month':  dateN.setMonth(dateN.getMonth() + num);break;
            case 'day':    dateN.setDate(dateN.getDate() + num);break;
            case 'hour':   dateN.setHours(dateN.getHours() + num);break;
            case 'min':    dateN.setMinutes(dateN.getMinutes() + num);break;
            case 'ss':     dateN.setMilliseconds(dateN.getMilliseconds() + num);break;
        }
        let date = new Date(dateN);
        if (format && format.length > 0) {
            return this.timeFormat(date, format);
        }
        return date;
    },
    getRandomTime: function (startDate, endDate) {
        let date = new Date(+startDate + Math.random() * (endDate - startDate));
        let hour = (Math.random() * 23) | 0;
        let minute = (Math.random() * 59) | 0;
        let second = (Math.random() * 59) | 0;
        date.setHours(hour);
        date.setMinutes(minute);
        date.setSeconds(second);
        return date;
    },
    timeFormat: function (time, fmt) {
        if (time == null) {
            return;
        }
        var fmt = fmt ? fmt : "yyyy-MM-dd";
        var time = new Date(time);
        var z = {
            M: time.getMonth() + 1,
            d: time.getDate(),
            h: time.getHours(),
            m: time.getMinutes(),
            s: time.getSeconds(),
        };
        fmt = fmt.replace(/(M+|d+|h+|m+|s+)/g, function (v) {
            return ((v.length > 1 ? "0" : "") + eval("z." + v.slice(-1))).slice(
                -2
            );
        });
        return fmt.replace(/(y+)/g, function (v) {
            return time.getFullYear().toString().slice(-v.length);
        });
    },
    /**
     * 发送HTTP请求
     * @param {string} url 发送请求的地址
     * @param {(Object|string|string[])} data 发送到服务器的数据，键值对形式
     * @param {string} [type=GET] 请求的类型，可以是"POST", "GET", "PUT"
     * @param {string} [dataType=json] 从服务器返回期望的数据类型,可以是"text", "html", "xml", "json", "jsonp"和"script"
     * @param {requestCallback} success 请求成功后的回调函数
     * @param {requestCallback} error 请求失败时调用此函数
     * @param {boolean} [cache=false] 从缓存中读取数据 设置false只在HEAD和GET请求有效
     * @param {boolean} [async=true]  默认为异步请求。如需发送同步请求，设置为 false
     */
    ajax: function (url, data, type, dataType, success, error, cache, async) {
        var type = type || "GET"; //请求类型
        var dataType = dataType || "json"; //接收数据类型
        var cache = cache || false; //浏览器历史缓存
        var async = async || true; //异步请求
        var success =
            success ||
            function (data) {
                console.log("请求成功");
            };
        var error =
            error ||
            function (data) {
                console.error("请求成功失败");
            };
        $.ajax({
            url: url,
            data: data,
            type: type,
            dataType: dataType,
            contentType: "application/x-www-form-urlencoded; charset=utf-8",
            success: success,
            error: error,
            cache: cache,
            async: async,
            timeout: 100000, //请求超时时长，单位毫秒 现在设为100秒
            jsonpCallback: "jsonp" + new Date().valueOf().toString().substr(-4),
            beforeSend: function () {
            },
        });
    },
};

var http = {
    /**
     * 公共发起请求方法
     */
    getSuperviseGet: function (params, success, error) {
        utils.ajax(
            config.hostUrl + config.token,
            params,
            "GET",
            null,
            function (data) {
                success(data);
            },
            function (err) {
                error(err);
            }
        );
    },
    getSupervisePost: function (params, success, error) {
        utils.ajax(
            config.hostUrl + config.token,
            params,
            "POST",
            null,
            function (data) {
                success(data);
            },
            function (err) {
                error(err);
            }
        );
    },
    sendMessage: function (id, clientCode, data,) {
        console.log('发送的消息', data, id, clientCode);
        var json = {
            id: id,
            type: "runInteractive",
            data: data,
        };
        $.ajax({
            url: "/dyh_view/interact/" + clientCode + id + "/message",
            type: "POST",
            data: {message: JSON.stringify(json)},
            async: true,
            cache: false,
            success: function (returnJson) {
                console.log("发送消息成功");
            },
        });
    },
};

var $axios = {
    config(type) {//基础配置
        const instance = axios.create({
            timeout: 30000,//超时设置
        });
        let contentType = 'application/json; charset=utf-8';
        if (type == 1) {
            contentType = 'application/x-www-form-urlencoded; charset=utf-8'
        }
        instance.defaults.headers['Content-Type'] = contentType;
        $axios.fliter(instance)
        return instance;
    },
    fliter(instance) {//拦截
        instance.interceptors.request.use(function (config) {// 添加请求拦截器
            // 在发送请求之前做些什么
            return config;
        }, function (error) {
            // 对请求错误做些什么
            return Promise.reject(error);
        });
        instance.interceptors.response.use(function (response) {// 添加响应拦截器
            // 对响应数据做点什么
            return response;
        }, function (error) {
            // 对响应错误做点什么
            return Promise.reject(error);
        });
    },
    dyhGet(params, url) {
        url = url || config.hostUrl + config.token;
        let axios = $axios.config(1);
        // instance.defaults.headers['Content-Type'] = 'application/x-www-form-urlencoded; charset=utf-8';
        return new Promise((resolve, reject) => {
            axios.get(url, {
                params: params
            }).then(res => {
                resolve(res.data)
            }).catch(err => {
                console.log("请求接口出错[" + (err) + "]");
                reject(err)
            })
        })
    },
    dyhPost(params, url) {// $axios.dyhPost(params).then(res=>{}).catch(err=>{});
        url = url || config.hostUrl + config.token;
        let axios = $axios.config(1);
        return new Promise((resolve, reject) => {
            axios.post(url, Qs.stringify(params)).then(res => {
                resolve(res.data)
            }).catch(err => {
                console.log("请求接口出错[" + (err) + "]");
                reject(err)
            })
        })
    },
    /*普通请求*/
    get(url, params) {
        let axios = $axios.config();
        return new Promise((resolve, reject) => {
            axios.get(url, {
                params: params
            }).then(res => {
                resolve(res.data)
            }).catch(err => {
                console.log("请求接口出错[" + (err) + "]");
                reject(err)
            })
        })
    },
    post(url, params, attr,isQs) {
        let axios = $axios.config();
        if(attr){
            axios.defaults.headers['Content-Type'] = attr.contentType;
            axios.defaults.headers['x-rbac-token'] = attr.xRbacToken;
        }
        return new Promise((resolve, reject) => {
            axios.post(url, isQs ? Qs.stringify(params) : params).then(res => {
                resolve(res.data)
            }).catch(err => {
                console.log("请求接口出错[" + (err) + "]");
                reject(err)
            })
        })
    },
}

/**
 * 页面工具
 * @type {{}}
 */
var htmlUtils = {
    /**
     * 获取url中的指定参数
     */
    getUrlKey: function (item, url) {
        url = url || this.getUrl();
        var sValue = url.match(new RegExp("[?&]" + item + "=([^&]*)(&?)", "i"));
        return sValue ? sValue[1] : sValue;
    },
    getUrl() {//获取请求路径
        return document.location.href;
    },
    getParentDocument() {//获取父类窗口节点
        return $(window.parent.document);
    },
    setDocumentByAttr(docName, attrName, value) {//设置父类中指定属性以及属性值.datav-transform ,height,1300
        this.getParentDocument().find(docName).css(attrName, value);
    }
}
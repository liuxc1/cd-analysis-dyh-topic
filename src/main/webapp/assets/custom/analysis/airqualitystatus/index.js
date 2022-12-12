var vue = new Vue({
    el: '#vue-app',
    data: {
        imagePath: imagePath,
        dateDayTime: dateDayTime,
        dateHourTime: dateHourTime,

        //时间类型
        dateType: 'hour',
        dateTime: dateHourTime,
        dateTimeList: [],
        //展示类型
        showType: 'cz',
        //指标
        pollute: 'aqi',
        //范围
        scope: 'cd',
        //url数组
        urlMap: [],

        styleObj: {
            'background-color': '#2F86F6 !important',
            'color': 'white !important'
        },
    },
    mounted: function () {
        this.resize();
        this.getImageUrl();
        // this.addDayRoHour('2021-09-29 12:00', -1)

    },
    methods: {
        resize: function () {
            var height = document.documentElement.clientHeight;//获取客户端高度
            document.getElementById("row_h").style.height = (height - 50) + 'px';
            document.getElementById("container").style.height = height + 'px';
        },
        /**
         * 查询类型选择
         * @param type
         */
        dateTypeChoose: function (type) {
            if (type == 'day') {
                this.dateType = 'day';
                if (this.dateTime == '' || this.dateTime.length == 16) {
                    this.dateTime = this.dateDayTime;
                }
            } else {
                this.dateType = 'hour';
                if (this.dateTime == '' || this.dateTime.length == 10) {
                    this.dateTime = this.dateHourTime;
                }
            }
            this.getImageUrl()
        },
        /**
         * 上一个时间
         */
        prevTime: function () {
            var date = new Date(this.dateTime);
            if (this.dateType == 'hour') {
                date.setTime(date.getTime() - 3600 * 1000);
                this.dateHourTime = this.formatDate(date, 'yyyy-mm-dd HH') + ':00';
                this.dateTime = this.dateHourTime;
            } else {
                date.setTime(date.getTime() - 3600 * 1000 * 24);
                this.dateDayTime = this.formatDate(date, 'yyyy-mm-dd');
                this.dateTime = this.dateDayTime;
            }
            this.getImageUrl();
        },
        /**
         * 下一个时间 
         */
        nextTime: function () {
            var date = new Date(this.dateTime);
            if (this.dateType == 'hour') {
                date.setTime(date.getTime() + 3600 * 1000);
                if (date.getTime() > new Date().getTime()) {
                    this.$message('已到当小时！');
                    return;
                }
                this.dateHourTime = this.formatDate(date, 'yyyy-mm-dd HH') + ':00';
                this.dateTime = this.dateHourTime;
            } else {
                date.setTime(date.getTime() + 3600 * 1000 * 24);
                if (date.getTime() > new Date().getTime()) {
                    this.$message('已到当天！');
                    return;
                }
                this.dateDayTime = this.formatDate(date, 'yyyy-mm-dd');
                this.dateTime = this.dateDayTime;
            }
            this.getImageUrl();
        },
        /**
         * 展示类型选择
         * @param type
         */
        showTypeChoose: function (type) {
            this.showType = type;
            this.getImageUrl()
        },

        /**
         * 指标选择
         * @param type
         */
        indexChoose: function (type) {
            this.pollute = type;
            this.getImageUrl()
        },

        /**
         * 范围选择
         * @param type
         */
        scopeChoose: function (type) {
            this.scope = type;
            this.getImageUrl()
        },
        /**
         * 组装url地址
         * @param type
         * /home/silu/PIC/day/2021/09/12/cdcz/aqi/srf-01.gif 00点
         * /home/silu/PIC/hour/2021/09/12/cdcz/aqi/srf-01.gif
         * /home/silu/PIC/day/2021/10/13/scuv/srf-01.gif
         */
        getImageUrl: async function () {
            let _this = this;
            let urlMap = [];
            let key = ['one', 'two', 'three', 'four'];
            let url = ''
            //获取过去3天或者3小时
            this.getLastThreeTime(_this.dateTime);
            for (let i = 0; i < _this.dateTimeList.length; i++) {
                //组装URL
                url = _this.assembleUrl(_this.dateTimeList[i])
                let item={
                    dataTime:_this.dateTimeList[i],
                    url:url
                }
                //判断url是否存在,存在返回当前url，不存在，返回前24小时中最新有图片的url
                url = await _this.decideImageIsExist(item,0)
                urlMap[key[i]] = url;
            }
            _this.urlMap = urlMap;
        },
        /**
         * 组装URL
         */
        assembleUrl:function (dateTime){
            let _this = this;
            let imgName = 'srf-01.gif';
            let url = '';
            if (_this.dateType == 'hour') {
                let hourNum = parseInt(dateTime.substring(11, 14)) + 1 + '';
                imgName = 'srf-' + (hourNum < 10 ? ('0' + hourNum) : hourNum) + '.gif';
            }
            url = _this.imagePath + _this.dateType + '/'
                + dateTime.substring(0, 4) + '/'
                + dateTime.substring(5, 7) + '/'
                + dateTime.substring(8, 10) + '/'
                + _this.scope + _this.showType + '/';
            if (_this.showType != 'uv') {
                url = url + _this.pollute + '/' + imgName;
            } else {
                url = url + imgName;
            }
            return url;
        },
        /**
         * 判断图片是否存在
         */
        decideImageIsExist:async function (item,num) {
            let _this = this;
            if (item){
                let tempUrl = await new Promise(resolve => {
                    let tempUrl = item.url;
                    let img = new Image();
                    img.onload = function () {
                        resolve(tempUrl);
                    }
                    // 加载错误
                    img.onerror = async function(){
                        num += 1;
                        let lastTime=_this.addDayRoHour(item.dataTime, -1)
                        tempUrl = _this.assembleUrl(lastTime);
                        let temp={
                            dataTime:lastTime,
                            url:tempUrl
                        }
                        if (num < 24){
                            tempUrl = await _this.decideImageIsExist(temp,num);
                        }else{
                            tempUrl =  item.url;
                        }
                        resolve(tempUrl);
                    }
                    //先绑定事件，然后指定地址
                    img.src = item.url;
                });
                return tempUrl;
            }
        },
        /**
         * 获取过去3天或者3小时
         */
        getLastThreeTime: function (queryTime) {
            let _this = this;
            _this.dateTimeList = [];
            _this.dateTimeList.push(queryTime);
            _this.dateTimeList.push(_this.addDayRoHour(queryTime, -1));
            _this.dateTimeList.push(_this.addDayRoHour(queryTime, -2));
            _this.dateTimeList.push(_this.addDayRoHour(queryTime, -3));
        },
        /**
         * 小时加减
         */
        addDayRoHour: function (queryTime, num) {
            var i = parseInt(num);
            var date = new Date(queryTime);
            let lastTime = '';
            if (this.dateType == 'hour') {
                date.setTime(date.getTime() + i * 3600 * 1000);
                lastTime = this.formatDate(date, 'yyyy-mm-dd HH') + ':00';
            } else {
                date.setTime(date.getTime() + i * 24 * 3600 * 1000);
                lastTime = this.formatDate(date, "yyyy-mm-dd")
            }
            return lastTime;
        },
        /**
         * 查询开始时间
         */
        queryHourTime: function () {
            var _this = this;
            WdatePicker({
                dateFmt: 'yyyy-MM-dd HH:00',
                el: 'hourTime',
                isShowClear: false,
                onpicking: function (dp) {
                    _this.dateHourTime = dp.cal.getNewDateStr();
                    _this.dateTime = dp.cal.getNewDateStr();
                    _this.getImageUrl();
                },
                onclearing: function () {
                    _this.dateHourTime = '';
                },
                readOnly: true
            });
        },
        /**
         * 查询结束时间
         */
        queryDayTime: function () {
            var _this = this;
            WdatePicker({
                dateFmt: 'yyyy-MM-dd',
                el: 'dayTime',
                isShowClear: false,
                onpicking: function (dp) {
                    _this.dateDayTime = dp.cal.getNewDateStr();
                    _this.dateTime = dp.cal.getNewDateStr();
                    _this.getImageUrl();
                },
                onclearing: function () {
                    _this.dateDayTime = '';
                },
                readOnly: true
            });
        },
        /**
         * 时间格式化
         * @param obj
         * @param pattern
         * @returns {string|boolean}
         */
        formatDate: function (obj, pattern) {
            var date;
            if (obj.constructor === Date) {
                date = obj;
            } else if (typeof obj === "number") {
                date = new Date(obj);
            } else {
                return false;
            }
            var y = date.getFullYear();
            var m = date.getMonth() + 1;
            m = m > 9 ? m : ('0' + m);
            var d = date.getDate();
            d = d > 9 ? d : ('0' + d);
            var h = date.getHours();
            h = h > 9 ? h : ('0' + h);
            pattern = pattern || 'yyyy-mm-dd';
            return pattern.toLowerCase().replace("yyyy", y).replace("mm", m).replace("dd", d).replace("hh", h);
        },
        /**
         * 下载图片
         * @param src
         */
        download: function (src) {
            var tempArr = src.split("/");
            var imgName = tempArr[tempArr.length - 1];
            var fType = imgName.split(".")[1];
            if (this.isImageInChromeNotEdge(fType)) {//判断是否为chrome里的图片
                this.ImgtodataURL(src, imgName, fType);
            } else {
                this.downloadNormalFile(src, imgName);
            }
        },
        isImageInChromeNotEdge: function (fType) {
            let bool = false;
            if (window.navigator.userAgent.indexOf("Chrome") !== -1 && window.navigator.userAgent.indexOf("Edge") === -1)
                (fType === "jpg" || fType === "gif" || fType === "png" || fType === "bmp" || fType === "jpeg" || fType === "svg") && (bool = true);
            return bool;
        },
        downloadNormalFile: function (src, filename) {
            var link = document.createElement('a');
            link.setAttribute("download", filename);
            link.href = src;
            document.body.appendChild(link);//添加到页面中，为兼容Firefox浏览器
            link.click();
            document.body.removeChild(link);//从页面移除
        },
        ImgtodataURL: function (url, filename, fileType) {
            this.getBase64(url, fileType, (_baseUrl) => {
                // 创建隐藏的可下载链接
                var eleLink = document.createElement('a');
                eleLink.download = filename;
                eleLink.style.display = 'none';
                // 图片转base64地址
                eleLink.href = _baseUrl;
                // 触发点击
                document.body.appendChild(eleLink);
                eleLink.click();
                // 然后移除
                document.body.removeChild(eleLink);
            });

        },
        getBase64: function (url, fileType, callback) {
            //通过构造函数来创建的 img 实例，在赋予 src 值后就会立刻下载图片
            var Img = new Image(),
                dataURL = '';
            Img.src = url;
            Img.setAttribute("crossOrigin", 'Anonymous');
            Img.onload = function () { //要先确保图片完整获取到，这是个异步事件
                var canvas = document.createElement("canvas"), //创建canvas元素
                    width = Img.width, //确保canvas的尺寸和图片一样
                    height = Img.height;
                canvas.width = width;
                canvas.height = height;
                canvas.getContext("2d").drawImage(Img, 0, 0, width, height); //将图片绘制到canvas中
                dataURL = canvas.toDataURL('image/' + fileType); //转换图片为dataURL
                callback ? callback(dataURL) : null;
            };
        }

    }, filters: {}
});
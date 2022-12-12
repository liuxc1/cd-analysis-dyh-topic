/**
 * 日期时间工具类
 */
var DateTimeUtil = {
    /**
     * 获取当前时间
     * @returns 当前时间（格式：yyyy-MM-dd HH:mm:ss）
     */
    getNowTime: function () {
        var date = new Date();
        var seperator = ':';
        var hour = date.getHours();
        var minute = date.getMinutes();
        var second = date.getSeconds();
        hour = this.beforeCompleZero(hour);
        minute = this.beforeCompleZero(minute);
        second = this.beforeCompleZero(second);
        return this.getNowDate() + ' ' + hour + seperator + minute + seperator + second;
    },
    /**
     * 获取当前时间
     * @returns 当前时间（格式：yyyy-MM-dd HH）
     */
    getNowTimeHour: function () {
        var date = new Date();
        var seperator = ':';
        var hour = date.getHours();
        var minute = date.getMinutes();
        var second = date.getSeconds();
        hour = this.beforeCompleZero(hour);
        minute = this.beforeCompleZero(minute);
        second = this.beforeCompleZero(second);
        return this.getNowDate() + ' ' + hour;
    },
    /**
     * 获取当前日期
     * @returns 当前日期（格式：yyyy-MM-dd）
     */
    getNowDate: function () {
        var date = new Date();
        var seperator = '-';
        var year = date.getFullYear();
        var month = date.getMonth() + 1;
        var day = date.getDate();
        month = this.beforeCompleZero(month);
        day = this.beforeCompleZero(day);
        return year + seperator + month + seperator + day;
    },
    /**
     * 获取当前年份
     * @returns 当前日期（格式：yyyy）
     */
    getNowYear: function () {
        var date = new Date();
        var year = date.getFullYear();
        return year;
    },
    /**
     * 查询今天是星期几
     * @param date 时间字符串，格式：yyyy-MM-dd
     * @return  num  查询当前是星期几
     */
    getWeekNum: function (date) {
        // 将传递的日期字符串变成时间戳
        var timeStamp = Date.parse(date);
        // 根据时间戳得到时间
        var dateTime = new Date(timeStamp);
        return dateTime.getDay();
    },
    /**
     * 计算指定日期是年内的哪一星期
     * @param date 时间字符串，格式：yyyy-MM-dd
     * @returns week 年内的哪一星期
     */
    getWeek: function (date) {
        // 将传递的日期字符串变成时间戳
        var timeStamp = Date.parse(date);
        // 根据时间戳得到时间
        var dateTime = new Date(timeStamp);
        // 获取今年的第一天
        var newYear = new Date(dateTime.getFullYear().toString());
        // 计算今天是今年的第多少天
        var yearDay = Math.ceil((dateTime - newYear) / (24 * 60 * 60 * 1000)) + 1;
        // 获取1月1日的星期
        var oneDayAsWeek = newYear.getDay();
        // 将该星期记录到临时变量
        // var oneDayAsWeekTemp = oneDayAsWeek;
        // 如果1月1日是星期日，则将其改为星期七
        /*if (oneDayAsWeek === 0) {
            oneDayAsWeekTemp = 7;
        }*/
        // 去掉不完整星期的天
        // yearDay -= (7 - oneDayAsWeekTemp - 1);
        if (oneDayAsWeek === 0) {
            // 星期日距离下星期一相差1天
            yearDay -= 1;
        } else if (oneDayAsWeek === 6) {
            // 星期六距离下星期一相差2天
            yearDay -= 2;
        } else if (oneDayAsWeek === 5) {
            // 星期五距离下星期一相差3天
            yearDay -= 3;
        } else if (oneDayAsWeek === 4) {
            // 星期四距离下星期一相差4天
            yearDay -= 4;
        } else if (oneDayAsWeek === 3) {
            // 星期三距离下星期一相差5天
            yearDay -= 5;
        } else if (oneDayAsWeek === 2) {
            // 星期二距离下星期一相差6天
            yearDay -= 6;
        }
        // 计算剩余的星期数
        var week = Math.ceil(yearDay / 7);
        // 如果当年第一天不是星期一，则需要手动加1周（原因是因为上面去掉了不完整星期的天）
        if (oneDayAsWeek != 1) {
            week++;
        }
        return week;
    },
    /**
     * 年份加减
     * @param {String} date 基础日期
     * @param {int} num 需要加减的年份数。负数为减
     * @returns 结果月份
     */
    addYear: function (date, num) {
        var year = parseInt(date);
        return (year + num);
    },
    /**
     * 月份加减
     * @param {String} date 基础日期
     * @param {int} num 需要加减的月份数。负数为减
     * @returns 结果月份
     */
    addMonth: function (date, num) {
        var monthNum = parseInt(num);
        var year = parseInt(date.substring(0, 4));
        var month = parseInt(date.substring(5, 7));
        var newYear = '';
        var newMonth = '';
        if (month + monthNum > 12) {
            newYear = year + 1;
            newMonth = month + monthNum - 12;
        } else if (month + monthNum < 1) {
            newYear = year - 1;
            newMonth = 12 - (month + monthNum);
        } else {
            newYear = year;
            newMonth = month + monthNum;
        }
        return newYear + "-" + this.beforeCompleZero(newMonth);
    },
    /**
     * 加减天数
     * @param date
     * @param days
     * @returns {string}
     */
    addDate: function (date, days) {
        let d = new Date(date);
        d.setDate(d.getDate() + days);
        return this.toDateString(d);
    },
    /**
     * 加减小时
     * @param date
     * @param days
     * @returns {string}
     */
    addHour:function(date, hours){
        const time = new Date(date);
        let newTime = new Date(time.getFullYear(), time.getMonth(), time.getDate(), time.getHours() + hours, time.getMinutes(), time.getSeconds());
        const year = newTime.getFullYear(),
            month = newTime.getMonth() + 1,//月份是从0开始的
            day = newTime.getDate(),
            hour = newTime.getHours();
        let newTimeStr = year + '-' + (month > 9 ? month : ('0' + month)) + '-' + (day > 9 ? day : ('0' + day)) + ' ' + (hour > 9 ? hour : ('0' + hour));
        return newTimeStr;
    },
    /**
     * 数字前面补0
     * @param {int} value
     * @returns 补0后的字符串
     */
    beforeCompleZero: function (value) {
        if (value >= 1 && value <= 9) {
            return '0' + value;
        }
        return value;
    },
    formatDate: function (time) {
        var date = new Date(time);

        var year = date.getFullYear(),
            month = date.getMonth() + 1,//月份是从0开始的
            day = date.getDate(),
            hour = date.getHours(),
            min = date.getMinutes(),
            sec = date.getSeconds();
        var newTime = year + '-' +
            month + '-' +
            day + ' ' +
            hour + ':' +
            min + ':' +
            sec;
        return newTime;
    },


    timeLineHour:function(time){
        var timeLine = [];
        var date = Date.parse(time);
        for(var i = 24; i  >= 0; i--){
            var newTime = date - (i * 60 * 60 * 1000);
            timeLine.push(this.toDateTimeString(newTime));
        }
        return timeLine;
    },
    toDateTimeString: function (time) {
        var date = new Date(time);
        var year = date.getFullYear(),
            month = this.beforeCompleZero(date.getMonth() + 1),//月份是从0开始的
            day = this.beforeCompleZero(date.getDate()),
            hour = this.beforeCompleZero(date.getHours());
        var newTime = year + '-' +
            month + '-' +
            day + ' ' +
            hour + ':' +
            '00:00'
        return newTime;
    },
    timeLineDay:function(time){
        var timeLine = [];
        var date = Date.parse(time);
        for(var i = 7; i  >= 0; i--){
            var newTime = date - (i*24 * 60 * 60 * 1000);
            timeLine.push(this.toDateString(newTime));
        }
        return timeLine;
    },
    toDateString: function (time) {
        var date = new Date(time);
        var year = date.getFullYear(),
            month = this.beforeCompleZero(date.getMonth() + 1),//月份是从0开始的
            day = this.beforeCompleZero(date.getDate());
        var newTime = year + '-' +
            month + '-' +
            day ;
        return newTime;
    },
    timeLineDayForcast:function (time) {
        var timeLine = [];
        var date = Date.parse(time);
        for(var i = 1; i  < 4; i++){
            var newTime = date + (i*24 * 60 * 60 * 1000);
            timeLine.push(this.toDateString(newTime));
        }
        return timeLine;
    },
    timeLineDayForecast_s:function (time) {
        var timeLine = [];
        var date = Date.parse(time);
        for(var i = 1; i  < 15; i++){
            var newTime = date + (i*24 * 60 * 60 * 1000);
            timeLine.push(this.toDateString(newTime));
        }
        return timeLine;
    },

    dateFormat: function (fmt, time) {
        var date = new Date(time);
        let ret;
        const opt = {
            "Y+": date.getFullYear().toString(),        // 年
            "m+": (date.getMonth() + 1).toString(),     // 月
            "d+": date.getDate().toString(),            // 日
            "H+": date.getHours().toString(),           // 时
            "M+": date.getMinutes().toString(),         // 分
            "S+": date.getSeconds().toString()          // 秒
            // 有其他格式化字符需求可以继续添加，必须转化成字符串
        };
        for (let k in opt) {
            ret = new RegExp("(" + k + ")").exec(fmt);
            if (ret) {
                fmt = fmt.replace(ret[1], (ret[1].length == 1) ? (opt[k]) : (opt[k].padStart(ret[1].length, "0")))
            }
            ;
        }
        ;
        return fmt;
    }

}
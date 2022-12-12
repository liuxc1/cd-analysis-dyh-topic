var search = {
    resize: function () {
        const height = document.documentElement.clientHeight;//获取客户端高度
        const width = document.documentElement.clientWidth;
        document.getElementById("container").style.height = height + 'px';
        document.getElementById("r1_col2").style.width = (width - 420) + 'px';
    },
    /**
     * 获取PT相关图片URL地址
     */
    getPtImgUrl:function (){
        const self = this;
        debugger
        const reportTime = $("#dateTime").val();
        const date = new Date(Date.parse(reportTime.replace(/-/g, "/")));
        const dateStr = self.formatDate(date, "yyyyMMdd");
        let dxtUrl = wrfImagePth + '/snowMountain/SPSP_PT_DXT-' + dateStr + '.png';
        let ymfUrl = wrfImagePth + '/snowMountain/SPSP_PT_YMF-' + dateStr + '.png';
        $('#pt_dxt').attr('src', dxtUrl);
        $('#pt_ymf').attr('src', ymfUrl);
    },
    /**
     * 获取图片URL和播放
     */
    getImgUrlAndPlay: function () {
        const self = this;
        const list = [];
        let listTimes = [];
        let reportTime = $("#dateTime").val();
        const date = new Date(Date.parse(reportTime.replace(/-/g, "/")));
        const dateStr = self.formatDate(date, "yyyyMMdd");
        let j = 1;
        for (let i = 1; i < 9; i++) {
            const dds = addDate(date, j);
            listTimes = this.setDayParameters(listTimes, dds, i);
            j++;
            list.push({
                name: listTimes[i - 1],
                url: wrfImagePth + '/snowMountain/SPSP_D'+ i + '_YMF-' + dateStr + '.png',
                url12: wrfImagePth + '/snowMountain/SPSP_D'+ i + '_DXT-' + dateStr + '.png',
            });
        }
        player.reset(list).showNext();
    },

    /**
     * 设置天
     * @param listTimes
     * @param dds
     * @param i
     * @returns {*}
     */
    setDayParameters: function (listTimes, dds, i) {
        if (i == 1 || i == 9 || i == 17 || i == 25 || i == 33) {
            listTimes[i - 1] = dds;
        }
        if (i == 2 || i == 10 || i == 18 || i == 26) {
            listTimes[i - 1] = dds;
        }
        if (i == 3 || i == 11 || i == 19 || i == 27) {
            listTimes[i - 1] = dds;
        }
        if (i == 4 || i == 12 || i == 20 || i == 28) {
            listTimes[i - 1] = dds;
        }
        if (i == 5 || i == 13 || i == 21 || i == 29) {
            listTimes[i - 1] = dds;
        }
        if (i == 6 || i == 14 || i == 22 || i == 30) {
            listTimes[i - 1] = dds;
        }
        if (i == 7 || i == 15 || i == 23 || i == 31) {
            listTimes[i - 1] = dds;
        }
        if (i == 8 || i == 16 || i == 24 || i == 32) {
            listTimes[i - 1] = dds;
        }
        return listTimes;
    },

    /**
     * 添加监听
     */
    addEventListener: function () {
        const self = this;
        $(document.body).on("click", ".isButton", function (e) {
            const oper = this.getAttribute("data-oper");
            if (oper == "search") {
                self.getPtImgUrl();
                self.getImgUrlAndPlay();
                $('#index_1').css("display","block");
                $('#index_2').css("display","none");
            }
        });
    },
    /**
     * 日期格式化
     * @param obj
     * @param pattern
     * @returns {string|boolean}
     */
    formatDate: function (obj, pattern) {
        let date;
        if (obj.constructor === Date) {
            date = obj;
        } else if (typeof obj === "number") {
            date = new Date(obj);
        } else {
            return false;
        }
        const y = date.getFullYear();
        let m = date.getMonth() + 1;
        m = m > 9 ? m : ('0' + m);
        let d = date.getDate();
        d = d > 9 ? d : ('0' + d);
        let h = date.getHours();
        h = h > 9 ? h : ('0' + h);
        pattern = pattern || 'yyyy-mm-dd';
        return pattern.toLowerCase().replace("yyyy", y).replace("mm", m).replace("dd", d).replace("hh", h);
    },

    /**
     * 初始化
     */
    init: function () {
        this.resize();
        this.getPtImgUrl();
        this.getImgUrlAndPlay();
        this.addEventListener();
    }
};
/**
 * js入口函数
 */
$(function () {
    const height = document.documentElement.clientHeight;//获取客户端高度
    document.getElementById("row_h").style.height = (height - 380) + 'px';
    search.init();
    $("#dateTime,#dateTimeBtn").on(ace.click_event, function () {
        WdatePicker({
            el: "dateTime",
            dateFmt: "yyyy-MM-dd",
            isShowClear: false,
            isShowToday: false,
            maxDate: '%y-%M-{%d-1}'
        });
    });
});

/**
 * 日期加减
  * @param date
 * @param days
 * @returns {string}
 */
function addDate(date, days) {
    const d = new Date(date);
    d.setDate(d.getDate() + days);
    let month = d.getMonth() + 1;
    let day = d.getDate();
    if (month < 10) {
        month = "0" + month;
    }
    if (day < 10) {
        day = "0" + day;
    }
    const val = d.getFullYear() + "" + month + "" + day;
    return val;
}
let errorImg = null;
function onError (id) {
    errorImg = document.getElementById("errorImg");
    if (!errorImg) {
        return;
    }
    let img = document.getElementById(id);
    img.src = errorImg.src;
}
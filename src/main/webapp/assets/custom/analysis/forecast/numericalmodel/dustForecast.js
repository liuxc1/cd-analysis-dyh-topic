const search = {
    /**
     * 获取客户端高度
     */
    resize: function () {
        const height = document.documentElement.clientHeight;
        const width = document.documentElement.clientWidth;
        document.getElementById("container").style.height = height + 'px';
        document.getElementById("r1_col2").style.width = (width - 420) + 'px';
    },
    /**
     * 获取url地址
     */
    getImgAndPlay: function () {
        const self = this;
        const list = [];
        const dateType = $('input[name="dateType"]:checked').val();
        let dateTime = $("#dateTime").val();
        const date = new Date(Date.parse(dateTime.replace(/-/g, "/")));
        dateTime = self.formatDate(date, "yyyy-MM-dd");
        if (dateType === 'day'){
            for (let i = 1; i < 8; i++) {
                const dds = DateTimeUtil.addDate(date, i-1);
                const index = (i > 9) ? i : ('0' + i);
                list.push({
                    name: dds,
                    url12: wrfImagePth +'/DUST/'+ (dateTime.replace(/-/g, "")) + "/NCPLOTS/WRFCHEM_daily_pm10_day" + index + ".png",
                    url: wrfImagePth +'/DUST/'+ (dateTime.replace(/-/g, "")) + "/NCPLOTS/WRFCHEM_daily_tpcpn_day" + index + ".png",
                });
            }
        } else {
            for (let i = 1; i < 194; i++) {
                const dds = DateTimeUtil.addHour(date, i-1).substring(0,13);
                const index = (i > 99) ? i : (i > 9) ? ('0' + i) : ('00' + i);
                list.push({
                    name: dds,
                    url12: wrfImagePth +'/DUST/'+ (dateTime.replace(/-/g, "")) + "/NCPLOTS/WRFCHEM_pm10_" + index + ".png",
                    url: wrfImagePth +'/DUST/'+ (dateTime.replace(/-/g, "")) + "/NCPLOTS/WRFCHEM_pcpn_" + index + ".png",
                });
            }
        }
        player.reset(list).showNext();
    },

    /**
     * 添加监听时间
     */
    addEventListener: function () {
        const self = this;
        $(document.body).on("click", ".isButton", function () {
            const opera = this.getAttribute("data-oper");
            if (opera === "search") {
                self.getImgAndPlay();
            }
        });
    },
    /**
     * 格式化日期
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
        const y = date.getFullYear()+'';
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
        this.getImgAndPlay();
        this.addEventListener();
    }
};
/**
 * js入口函数
 */
$(function () {
    //获取客户端高度
    const height = document.documentElement.clientHeight;
    document.getElementById("row_h").style.height = (height - 50) + 'px';
    search.init();
    $("#dateTime,#dateTimeBtn").on(ace.click_event, function () {
        WdatePicker({
            el: "dateTime",
            dateFmt: "yyyy-MM-dd",
            isShowClear: false,
            isShowToday: false,
            maxDate: '%y-%M-%d',
            onpicked: function() {
                search.getImgAndPlay();
            }
        });
    });
});
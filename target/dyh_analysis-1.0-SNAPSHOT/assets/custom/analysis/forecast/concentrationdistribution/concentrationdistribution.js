var search = {
    resize: function () {
        var height = document.documentElement.clientHeight;//获取客户端高度
        const width = document.documentElement.clientWidth;
        document.getElementById("container").style.height = height + 'px';
        document.getElementById("r1_col2").style.width = (width - 420) + 'px';
    },
    getLocationSearchByName: function (name) {
        var search = decodeURIComponent(window.location.search.substring(1));
        var param = {};
        arr = search.split("&");
        var i, key_value;
        for (i = 0; i < arr.length; i++) {
            key_value = arr[i].split("=");
            param[key_value[0]] = key_value[1];
        }
        return param[name] || null;
    },
    getImgsAndPlay: function () {
        var self = this;
        var list = [];
        var listTimes = [];
        var types = $('input[name="types"]:checked').val();
        var dateTime = $("#dateTime").val();
        var date = new Date(Date.parse(dateTime.replace(/-/g, "/")));
        dateTime = self.formatDate(date, "yyyy-MM-dd");
        var j = 1;
        if (types == "pm25") {
            for (var i = 1; i < 9; i++) {
                var dds = addDate(date, j);
                listTimes = this.setDayParameters(listTimes, dds, i);
                j++;
                list.push({
                    name: listTimes[i - 1],
                    url: wrfImagePth + dateTime + "/00/NCPLOTS/" + "daily_pm25_day" + i + ".png",
                    url12: wrfImagePth + dateTime + "/12/NCPLOTS/" + "daily_pm25_day" + i + ".png"
                });
            }
        } else if (types == "no2") {
            for (var i = 1; i < 9; i++) {
                var dds = addDate(date, j);
                listTimes = this.setDayParameters(listTimes, dds, i);
                j++;
                list.push({
                    name: listTimes[i - 1],
                    url: wrfImagePth + dateTime + "/00/NCPLOTS/" + "daily_no2_day" + i + ".png",
                    url12: wrfImagePth + dateTime + "/12/NCPLOTS/" + "daily_no2_day" + i + ".png"
                });
            }
        }else if (types == "o3"){
            for (var i = 1; i < 9; i++) {
                var dds = addDate(date, j);
                listTimes = this.setDayParameters(listTimes, dds, i);
                j++;
                list.push({
                    name: listTimes[i - 1],
                    url: wrfImagePth + dateTime + "/00/NCPLOTS/" + "daily_o3m_day" + i + ".png",
                    url12: wrfImagePth + dateTime + "/12/NCPLOTS/" + "daily_o3m_day" + i + ".png"
                });
            }
        }
        player.reset(list).showNext();
    },

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
    addEventListener: function () {
        var self = this;
        $(document.body).on("click", ".isButton", function (e) {
            var oper = this.getAttribute("data-oper");
            if (oper == "search") {
                self.getImgsAndPlay();
            }
        });
    },
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
        var str = '';
        pattern = pattern || 'yyyy-mm-dd';
        return pattern.toLowerCase().replace("yyyy", y).replace("mm", m).replace("dd", d).replace("hh", h);
    },

    getYesterday: function (obj) {
        var date = new Date(), dateArr;
        if (!obj) {
        } else if (typeof obj == "string") {
            dateArr = obj.split(" ")[0].split("-");
            date.setDate(+dateArr[0]);
            date.setMonth(+dateArr[1] - 1);
            date.setDate(+dateArr[2]);
        } else if (typeof obj == "number") {
            date.setDate(obj);
        } else if (date.constructor === Date) {
            date = obj;
        }
        date = new Date(date.getTime() - 8.64e7);
        console.dir(date);
        return date;
    },

    init: function () {
        this.resize();
        this.getImgsAndPlay();
        this.addEventListener();
    }
};
$(function () {//js入口函数
    var height = document.documentElement.clientHeight;//获取客户端高度
    document.getElementById("row_h").style.height = (height - 50) + 'px';
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

//
function addDate(date, days) {
    var d = new Date(date);
    d.setDate(d.getDate() + days);
    var month = d.getMonth() + 1;
    var day = d.getDate();
    if (month < 10) {
        month = "0" + month;
    }
    if (day < 10) {
        day = "0" + day;
    }
    var val = d.getFullYear() + "" + month + "" + day;
    return val;
}


function xzfw(vals) {
    if (vals == 'd1') {
        $(".highg").show();
    } else {
        $(".highg").hide();
    }
    $("input[name='high']").eq(0).prop("checked", true);
    gaodu($("input[name='high']").val());
    $("input[name='types']").eq(0).prop("checked", true);
}

function gaodu(vals) {
    if (vals == 'surface') {
        $(".d").show();
        $(".five").hide();
        $(".eight").hide();
        $("input[name='types'][value='RH']").prop("checked", true);
    } else if (vals == '500') {
        $(".d").hide();
        $(".five").show();
        $(".eight").hide();
        $("input[name='types'][value='FIVE']").prop("checked", true);
    } else {
        $(".d").hide();
        $(".five").hide();
        $(".eight").show();
        $("input[name='types'][value='EIGHT']").prop("checked", true);
    }
}
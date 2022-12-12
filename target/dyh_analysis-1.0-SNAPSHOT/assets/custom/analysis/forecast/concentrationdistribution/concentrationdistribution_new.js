var search = {
    resize: function () {
        const height = document.documentElement.clientHeight;//获取客户端高度
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
    getImgsAndPlay1: function () {
        var self = this;
        var list = [];
        var listTimes = [];
        var types = $('input[name="w_types"]:checked').val();
        var dateTime = $("#dateTime").val();
        var date = new Date(Date.parse(dateTime.replace(/-/g, "/")));
        dateTime = self.formatDate(date, "yyyy-MM-dd");
        var j = 1;
        if (types == "DTD") {
            for (var i = 1; i < 9; i++) {
                var dds = addDate(date, j);
                listTimes = this.setDayParameters(listTimes, dds, i);
                j++;
                list.push({
                    name: listTimes[i - 1],
                    url: wrfImagePth + dateTime + "/00/NCPLOTS/" + "daily_temp2_day" + i + ".png",
                    url12: wrfImagePth + dateTime + "/12/NCPLOTS/" + "daily_temp2_day" + i + ".png"
                });
            }
        } else if (types == "DT") {
            for (var i = 1; i < 9; i++) {
                var dds = addDate(date, j);
                listTimes = this.setDayParameters(listTimes, dds, i);
                j++;
                list.push({
                    name: listTimes[i - 1],
                    url: wrfImagePth + dateTime + "/00/NCPLOTS/" + "daily_rain_day" + i + ".png",
                    url12: wrfImagePth + dateTime + "/12/NCPLOTS/" + "daily_rain_day" + i + ".png"
                });
            }
        } else if (types == "HWF") {
            var imagePath = null;
            var imagePath12 = null;
            var name = "windws";
            for (var i = 15; i < 207; i++) {
                imagePath = this.setHourParameters(dateTime, listTimes, date, i, name, j);
                imagePath12 = this.setHourParameters12(dateTime, listTimes, date, i, name, j);
                if (i - 14 == 24 || i - 14 == 48 || i - 14 == 72 || i - 14 == 96 || i - 14 == 120 || i - 14 == 144 || i - 14 == 168 || i - 14 == 192) {
                    j++;
                }
                list.push({
                    name: listTimes[i - 14],
                    url: imagePath,
                    url12: imagePath12
                });
            }

        } else if (types == "PPH") {
            imagePath = null;
            var name = "rain";
            for (var i = 15; i < 207; i++) {
                imagePath = this.setHourParameters(dateTime, listTimes, date, i, name, j);
                imagePath12 = this.setHourParameters12(dateTime, listTimes, date, i, name, j);
                if (i - 14 == 24 || i - 14 == 48 || i - 14 == 72 || i - 14 == 96 || i - 14 == 120 || i - 14 == 144 || i - 14 == 168 || i - 14 == 192) {
                    j++;
                }
                list.push({
                    name: listTimes[i - 14],
                    url: imagePath,
                    url12: imagePath12
                });
            }
        } else if (types == "HC") {
            imagePath = null;
            var name = "cloud";
            for (var i = 15; i < 207; i++) {
                imagePath = this.setHourParameters(dateTime, listTimes, date, i, name, j);
                imagePath12 = this.setHourParameters12(dateTime, listTimes, date, i, name, j);
                if (i - 14 == 24 || i - 14 == 48 || i - 14 == 72 || i - 14 == 96 || i - 14 == 120 || i - 14 == 144 || i - 14 == 168 || i - 14 == 192) {
                    j++;
                }
                list.push({
                    name: listTimes[i - 14],
                    url: imagePath,
                    url12: imagePath12
                });
            }
        } else if (types == "HGCARC") {
            imagePath = null;
            var name = "rh";
            for (var i = 15; i < 207; i++) {
                imagePath = this.setHourParameters(dateTime, listTimes, date, i, name, j);
                imagePath12 = this.setHourParameters12(dateTime, listTimes, date, i, name, j);
                if (i - 14 == 24 || i - 14 == 48 || i - 14 == 72 || i - 14 == 96 || i - 14 == 120 || i - 14 == 144 || i - 14 == 168 || i - 14 == 192) {
                    j++;
                }
                list.push({
                    name: listTimes[i - 14],
                    url: imagePath,
                    url12: imagePath12
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

    setHourParameters12: function (dateTime, listTimes, date, i, name, j) {
        var imagePath12 = null;
        var dds = addDate(date, j);
        if (i - 14 == 1 || i - 14 == 25 || i - 14 == 49 || i - 14 == 73 || i - 14 == 97 || i - 14 == 121 || i - 14 == 145 || i - 14 == 169 || i - 14 == 193) {
            listTimes[i - 14] = dds + "00";
        }
        if (i - 13 == 2 || i - 13 == 26 || i - 13 == 50 || i - 13 == 74 || i - 13 == 98 || i - 13 == 122 || i - 13 == 146 || i - 13 == 170) {
            listTimes[i - 13] = dds + "01";
        }
        if (i - 12 == 3 || i - 12 == 27 || i - 12 == 51 || i - 12 == 75 || i - 12 == 99 || i - 12 == 123 || i - 12 == 147 || i - 12 == 171) {
            listTimes[i - 12] = dds + "02";
        }
        if (i - 11 == 4 || i - 11 == 28 || i - 11 == 52 || i - 11 == 76 || i - 11 == 100 || i - 11 == 124 || i - 11 == 148 || i - 11 == 172) {
            listTimes[i - 11] = dds + "03";
        }
        if (i - 10 == 5 || i - 10 == 29 || i - 10 == 53 || i - 10 == 77 || i - 10 == 101 || i - 10 == 125 || i - 10 == 149 || i - 10 == 173) {
            listTimes[i - 10] = dds + "04";
        }
        if (i - 9 == 6 || i - 9 == 30 || i - 9 == 54 || i - 9 == 78 || i - 9 == 102 || i - 9 == 126 || i - 9 == 150 || i - 9 == 174) {
            listTimes[i - 9] = dds + "05";
        }
        if (i - 8 == 7 || i - 8 == 31 || i - 8 == 55 || i - 8 == 79 || i - 8 == 103 || i - 8 == 127 || i - 8 == 151 || i - 8 == 175) {
            listTimes[i - 8] = dds + "06";
        }
        if (i - 7 == 8 || i - 7 == 32 || i - 7 == 56 || i - 7 == 80 || i - 7 == 104 || i - 7 == 128 || i - 7 == 152 || i - 7 == 176) {
            listTimes[i - 7] = dds + "07";
        }
        if (i - 6 == 9 || i - 6 == 33 || i - 6 == 57 || i - 6 == 81 || i - 6 == 105 || i - 6 == 129 || i - 6 == 153 || i - 6 == 177) {
            listTimes[i - 6] = dds + "08";
        }
        if (i - 5 == 10 || i - 5 == 34 || i - 5 == 58 || i - 5 == 82 || i - 5 == 106 || i - 5 == 130 || i - 5 == 154 || i - 5 == 178) {
            listTimes[i - 5] = dds + "09";
        }
        if (i - 4 == 11 || i - 4 == 35 || i - 4 == 59 || i - 4 == 83 || i - 4 == 107 || i - 4 == 131 || i - 4 == 155 || i - 4 == 179) {
            listTimes[i - 4] = dds + "10";
        }
        if (i - 3 == 12 || i - 3 == 36 || i - 3 == 60 || i - 3 == 84 || i - 3 == 108 || i - 3 == 132 || i - 3 == 156 || i - 3 == 180) {
            listTimes[i - 3] = dds + "11";
        }
        if (i - 2 == 13 || i - 2 == 37 || i - 2 == 61 || i - 2 == 85 || i - 2 == 109 || i - 2 == 133 || i - 2 == 157 || i - 2 == 181) {
            listTimes[i - 2] = dds + "12";
        }
        if (i - 1 == 14 || i - 1 == 38 || i - 1 == 62 || i - 1 == 86 || i - 1 == 110 || i - 1 == 134 || i - 1 == 158 || i - 1 == 182) {
            listTimes[i - 1] = dds + "13";
        }
        if (i == 15 || i == 39 || i == 63 || i == 87 || i == 111 || i == 135 || i == 159 || i == 183) {
            listTimes[i] = dds + "14";
        }
        if (i == 16 || i == 40 || i == 64 || i == 88 || i == 112 || i == 136 || i == 160 || i == 184) {
            listTimes[i] = dds + "15";
        }
        if (i == 17 || i == 41 || i == 65 || i == 89 || i == 113 || i == 137 || i == 161 || i == 185) {
            listTimes[i] = dds + "16";
        }
        if (i == 18 || i == 42 || i == 66 || i == 90 || i == 114 || i == 138 || i == 162 || i == 186) {
            listTimes[i] = dds + "17";
        }
        if (i == 19 || i == 43 || i == 67 || i == 91 || i == 115 || i == 139 || i == 163 || i == 187) {
            listTimes[i] = dds + "18";
        }
        if (i == 20 || i == 44 || i == 68 || i == 92 || i == 116 || i == 140 || i == 164 || i == 188) {
            listTimes[i] = dds + "19";
        }
        if (i == 21 || i == 45 || i == 69 || i == 93 || i == 117 || i == 141 || i == 165 || i == 189) {
            listTimes[i] = dds + "20";
        }
        if (i == 22 || i == 46 || i == 70 || i == 94 || i == 118 || i == 142 || i == 166 || i == 190) {
            listTimes[i] = dds + "21";
        }
        if (i == 23 || i == 47 || i == 71 || i == 95 || i == 119 || i == 143 || i == 167 || i == 191) {
            listTimes[i] = dds + "22";
        }
        if (i == 24 || i == 48 || i == 72 || i == 96 || i == 120 || i == 144 || i == 168 || i == 192) {
            listTimes[i] = dds + "23";
        }
        if (i < 100) {
            imagePath12 = wrfImagePth + dateTime + "/12/NCPLOTS/" + name + "_0" + i + ".png"
        } else {
            imagePath12 = wrfImagePth + dateTime + "/12/NCPLOTS/" + name + "_" + i + ".png"
        }
        return imagePath12;
    },

    setHourParameters: function (dateTime, listTimes, date, i, name, j) {
        var imagePath = null;
        var dds = addDate(date, j);
        if (i - 14 == 1 || i - 14 == 25 || i - 14 == 49 || i - 14 == 73 || i - 14 == 97 || i - 14 == 121 || i - 14 == 145 || i - 14 == 169 || i - 14 == 193) {
            listTimes[i - 14] = dds + "00";
        }
        if (i - 13 == 2 || i - 13 == 26 || i - 13 == 50 || i - 13 == 74 || i - 13 == 98 || i - 13 == 122 || i - 13 == 146 || i - 13 == 170) {
            listTimes[i - 13] = dds + "01";
        }
        if (i - 12 == 3 || i - 12 == 27 || i - 12 == 51 || i - 12 == 75 || i - 12 == 99 || i - 12 == 123 || i - 12 == 147 || i - 12 == 171) {
            listTimes[i - 12] = dds + "02";
        }
        if (i - 11 == 4 || i - 11 == 28 || i - 11 == 52 || i - 11 == 76 || i - 11 == 100 || i - 11 == 124 || i - 11 == 148 || i - 11 == 172) {
            listTimes[i - 11] = dds + "03";
        }
        if (i - 10 == 5 || i - 10 == 29 || i - 10 == 53 || i - 10 == 77 || i - 10 == 101 || i - 10 == 125 || i - 10 == 149 || i - 10 == 173) {
            listTimes[i - 10] = dds + "04";
        }
        if (i - 9 == 6 || i - 9 == 30 || i - 9 == 54 || i - 9 == 78 || i - 9 == 102 || i - 9 == 126 || i - 9 == 150 || i - 9 == 174) {
            listTimes[i - 9] = dds + "05";
        }
        if (i - 8 == 7 || i - 8 == 31 || i - 8 == 55 || i - 8 == 79 || i - 8 == 103 || i - 8 == 127 || i - 8 == 151 || i - 8 == 175) {
            listTimes[i - 8] = dds + "06";
        }
        if (i - 7 == 8 || i - 7 == 32 || i - 7 == 56 || i - 7 == 80 || i - 7 == 104 || i - 7 == 128 || i - 7 == 152 || i - 7 == 176) {
            listTimes[i - 7] = dds + "07";
        }
        if (i - 6 == 9 || i - 6 == 33 || i - 6 == 57 || i - 6 == 81 || i - 6 == 105 || i - 6 == 129 || i - 6 == 153 || i - 6 == 177) {
            listTimes[i - 6] = dds + "08";
        }
        if (i - 5 == 10 || i - 5 == 34 || i - 5 == 58 || i - 5 == 82 || i - 5 == 106 || i - 5 == 130 || i - 5 == 154 || i - 5 == 178) {
            listTimes[i - 5] = dds + "09";
        }
        if (i - 4 == 11 || i - 4 == 35 || i - 4 == 59 || i - 4 == 83 || i - 4 == 107 || i - 4 == 131 || i - 4 == 155 || i - 4 == 179) {
            listTimes[i - 4] = dds + "10";
        }
        if (i - 3 == 12 || i - 3 == 36 || i - 3 == 60 || i - 3 == 84 || i - 3 == 108 || i - 3 == 132 || i - 3 == 156 || i - 3 == 180) {
            listTimes[i - 3] = dds + "11";
        }
        if (i - 2 == 13 || i - 2 == 37 || i - 2 == 61 || i - 2 == 85 || i - 2 == 109 || i - 2 == 133 || i - 2 == 157 || i - 2 == 181) {
            listTimes[i - 2] = dds + "12";
        }
        if (i - 1 == 14 || i - 1 == 38 || i - 1 == 62 || i - 1 == 86 || i - 1 == 110 || i - 1 == 134 || i - 1 == 158 || i - 1 == 182) {
            listTimes[i - 1] = dds + "13";
        }
        if (i == 15 || i == 39 || i == 63 || i == 87 || i == 111 || i == 135 || i == 159 || i == 183) {
            listTimes[i] = dds + "14";
        }
        if (i == 16 || i == 40 || i == 64 || i == 88 || i == 112 || i == 136 || i == 160 || i == 184) {
            listTimes[i] = dds + "15";
        }
        if (i == 17 || i == 41 || i == 65 || i == 89 || i == 113 || i == 137 || i == 161 || i == 185) {
            listTimes[i] = dds + "16";
        }
        if (i == 18 || i == 42 || i == 66 || i == 90 || i == 114 || i == 138 || i == 162 || i == 186) {
            listTimes[i] = dds + "17";
        }
        if (i == 19 || i == 43 || i == 67 || i == 91 || i == 115 || i == 139 || i == 163 || i == 187) {
            listTimes[i] = dds + "18";
        }
        if (i == 20 || i == 44 || i == 68 || i == 92 || i == 116 || i == 140 || i == 164 || i == 188) {
            listTimes[i] = dds + "19";
        }
        if (i == 21 || i == 45 || i == 69 || i == 93 || i == 117 || i == 141 || i == 165 || i == 189) {
            listTimes[i] = dds + "20";
        }
        if (i == 22 || i == 46 || i == 70 || i == 94 || i == 118 || i == 142 || i == 166 || i == 190) {
            listTimes[i] = dds + "21";
        }
        if (i == 23 || i == 47 || i == 71 || i == 95 || i == 119 || i == 143 || i == 167 || i == 191) {
            listTimes[i] = dds + "22";
        }
        if (i == 24 || i == 48 || i == 72 || i == 96 || i == 120 || i == 144 || i == 168 || i == 192) {
            listTimes[i] = dds + "23";
        }
        if (i < 100) {
            imagePath = wrfImagePth + dateTime + "/00/NCPLOTS/" + name + "_0" + i + ".png"
        } else {
            imagePath = wrfImagePth + dateTime + "/00/NCPLOTS/" + name + "_" + i + ".png"
        }
        return imagePath;
    },
    addEventListener: function () {
        var self = this;
        $(document.body).on("click", ".isButton", function (e) {
            var oper = this.getAttribute("data-oper");
            if (oper == "search") {
                var chooseType = $('input[name="chooseType"]:checked').val();
                if (chooseType=='1'){
                    self.getImgsAndPlay1();
                    $('#index_1').css("display","none");
                    $('#index_2').css("display","block");
                }else {
                    self.getImgsAndPlay();
                    $('#index_1').css("display","block");
                    $('#index_2').css("display","none");
                }
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
        if (type==2){
            $('#type1').prop('checked',false);
            $('#type2').prop('checked',true);
            $('#index_1').css("display","none");
            $('#index_2').css("display","block");
            this.getImgsAndPlay1();
        }else {
            this.getImgsAndPlay();
        }
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
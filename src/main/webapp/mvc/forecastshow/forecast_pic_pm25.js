var search = {
    resize: function() {
        var height = document.documentElement.clientHeight;
        document.getElementById("container").style.height = height + 'px';
    },
    
    getLocationSearchByName: function(name) {
        var search = window.location.search.substring(1);  
        var param = {};
            arr = search.split("&");
        var i, key_value;
        for (i = 0; i < arr.length; i++) {
            key_value = arr[i].split("=");
            param[key_value[0]] = key_value[1];
        }
        return param[name] || null;
    },
    /**
     * PM2.5垂直组分预报图，不需要播放功能。只需要根据查询，展现一张图片就可以了。
     **/
    getImgsAndPlay: function() {
        var date = $("#dateTime").val();
        var url= cfg.imgBaseUrl + "WeatherForecast/PM25/";
        
        var model = $("#model input:checked").val();
        var datePath = date.replace(/-/g, "/");
        var region = $("#region input:checked").val();
        var src = url + model+"/"+datePath+"/"+region+"/"+type+".png";
        var data = [];
        data.push({
            url: src,
            name: date
        });
        $(document.body).addClass("no_play");//不显示播放功能
        player.reset(data).showNext();
    },
    
    addEventListener: function() {
        var self = this;
        $(document.body).on("click", ".isButton", function(e) {
            var oper = this.getAttribute("data-oper");
            if (oper == "search") {
                self.getImgsAndPlay();
            }
      })  
    },
    
    formatDate: function(obj, pattern) {
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
    
    getYesterday: function(obj) {
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
        return date;
    },
    
    init: function() {
        //console.log(this.getYesterday());
        $("#dateTime").val(this.formatDate(this.getYesterday()));
        this.resize();
        this.getImgsAndPlay();
        this.addEventListener();
    }
};
$(function() {
    search.init();
});
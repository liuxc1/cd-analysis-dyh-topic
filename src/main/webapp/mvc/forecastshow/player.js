var player = {
    init: function () {
        this.timer = 1800; //播放间隔 ms
        this.datetime = '';
        this.index = 0; //index为 1 时，当前正在播放的是第 1 张，预加载第 2 张。
        this.isPlaying = false; //是否正在播放
        this.pro = document.getElementById("progress_bar");
        this.text = $(".progress_text")[0];
        this.tips = $(".progress_tips")[0];
        this.tipsArrow = $(".progress_tips_arrow")[0];
        this.errorImg = document.getElementById("errorImg");
        this.$cache = $(".progress_cache");
        var itemList = $(".item_img_list");
        if (itemList[0]) {
            this.$itemList = itemList;
        }
        this.total = 0;
        this.interval = []; //定时任务

        //图片容器
        this.container = document.getElementById("img_wrap");
        this.container12 = document.getElementById("img_wrap12");
        //在此接入imageViewer组件
        this.viewer = ImageViewer(this.container);
        this.viewer12 = ImageViewer(this.container12);
        this.addEventListener();
        this.reset();
    },
    isCurImg: function (img) {
        var curImg = this.layers[this.index ];
        if (curImg == img) {
            return true;
        }
        return false;
    },
    onError: function (img) {
        if (!this.errorImg) {
            return;
        }
        img.src = this.errorImg.src;
        if (this.isCurImg(img)) {
            this.viewer.load(this.errorImg.src, this.errorImg.src);
        }
    },
    reset: function (imgs) {
        //清空时间轴下方时间样式
        $(".progress_text").html("");
        $("#progress_bar").css("width", "100%");
        $(".progress_tips").html("");
        if (this.isPlaying) {
            this.stop();
        }
        if (imgs) {
            this.imgs = imgs;
            this.total = this.imgs.length;
        }
        if (this.$itemList && imgs) {
            this.setItemList();
        }
        this.index = 0;
        this.showProgress();
        this.resetLayers();
        return this;
    },

    setItemList: function () {
        this.$itemList.empty();
        var ul = document.createElement("ul");
        var li;
        $.each(this.imgs, function () {
            li = document.createElement("li");
            li.innerHTML = this.name;
            li.setAttribute("data-src", this.url);
            if (this.title != undefined && this.title != '') {
                li.setAttribute("data-title", this.title);
            }
            li.setAttribute("data-oper", "progress_item");
            li.className = "isButton";
            ul.appendChild(li);
        });
        this.$itemList.append(ul);

    },

    resetLayers: function () {
        this.layers = [new Image(), new Image(), new Image()];
        this.layers12 = [new Image(), new Image(), new Image()];
        this.$cache.empty();
        var that = this;
        $.each(this.layers, function () {
            this.addEventListener("error", function () {
                that.onError(this);
            });
            that.$cache.append(this);
        });
        $.each(this.layers12, function () {
            this.addEventListener("error", function () {
                that.onError(this);
            });
            that.$cache.append(this);
        });
    },

    addEventListener: function () {
        if (this.eventReady) {
            return;
        }
        this.eventReady = true;
        var that = this;
        $(document.body).on("click", ".isButton", function (e) {
            var click = $(this);
            var oper = this.getAttribute("data-oper");
            if (oper == "showPrev") {
                that.stop().showPrev();
                return;
            }
            if (oper == "showNext") {
                that.stop().showNext();
                return;
            }
            if (oper == "play") {
                if (click.hasClass("active")) {
                    that.stop();
                } else {
                    that.play();
                }
                return;
            }
            if (oper == "goProgress") {
                that.stop().goProgress(click, e);
                return;
            }
            if (oper == "progress_item") {


                that.reset();
                that.index = $(this).index();
                that.showNext();
                return;
            }
            if (oper == "iview") {
            }
            if (oper == "big") {
                $("#row1").addClass("full");
                that.viewer.refresh();
                return;
            }
            if (oper == "small") {
                $("#row1").removeClass("full");
                that.viewer.refresh();
                return;
            }

        });

        $(".progress_wrap").on("mousemove", function (e) {
            var click = $(this);
            that.showHoverProgress(click, e);
        });
    },

    play: function (imgs) {
        if (imgs) {
            this.reset(imgs);
        }
        this.isPlaying = true;
        $("#time_line .play").addClass("active");
        var player = this;
        this.interval.push(setInterval(function () {
            player.showNext();
        }, this.timer));
        return this;
    },

    stop: function () {
        this.isPlaying = false;
        while (this.interval.length) {
            clearInterval(this.interval.pop());
        }
            $("#time_line .play").removeClass("active");
        return this;
    },
    showHoverProgress: function (click, e) {
        var offset = e.pageX - click.offset().left;
        var width = click.width();
        var index = parseInt(offset * this.total / width);
        if (this.imgs.length > 0) {
            this.tips.innerHTML = this.imgs[index].name + "(" + (index + 1) + "/" + this.total + ")";
        }
        this.tipsArrow.style.left = -5 + offset + "px";
        this.tips.style.left = -80 + offset + "px";
    },
    goProgress: function (click, e) {
        var offset = e.pageX - click.offset().left;
        var width = click.width();
        var index = parseInt(offset * this.total / width);
        this.reset();
        this.index = index;
        this.showNext();
    },

    showProgress: function () {

        var width = parseFloat((this.index) * 100 / this.total).toFixed(2) + "%";
        this.pro.style.width = width;
        if (!this.index) {
            return;
        }
        if (this.imgs.length == 0) {
            return;
        }
        this.text.innerHTML = this.imgs[this.index - 1].name;
        var $li;
        if (this.$itemList) {

            $li = this.$itemList.find(".active").removeClass("active")
                .end().find("li").eq(this.index - 1).addClass("active");
            //li.active如果条件允许，显示在ul的最上方。此时ul允许滚动，并且li.offset 
            var title = $li.attr("data-title");
            if (title != undefined && title != '') {//如果有标题则显示标题
                $("#title").show();
                $("#title").html(title);
            }

            var offsetTop = $li[0].offsetTop;
            var ul = $li[0].parentNode;
            var allowScroll = ul.scrollHeight - ul.clientHeight;
            if (!this.isPlaying) {
                //判断此时 图片name是否由点击进度条引起滚动，导致在框外，是的话，滚动

                if (offsetTop < ul.scrollTop || offsetTop > (ul.scrollTop + ul.clientHeight - 30)) {
                    ul.scrollTop = Math.min(allowScroll, offsetTop - 62);
                }
                return;
            }
            if (allowScroll > 0) {
                ul.scrollTop = Math.min(allowScroll, offsetTop - 62);
            }
        }
    },
    getDateTime: function (index) {
//        var date = new Date();
//        date.setFullYear(this.datetime.split('-')[0]);
//        date.setMonth(parseInt(this.datetime.split('-')[1]) - 1);
//        date.setDate(parseInt(this.datetime.split('-')[2]));
//        date.setHours(0);
//        date.setMinutes(0);
//        var now = new Date(date.getTime() + ((index + 1) || this.index) * 3.6e6);
//        function getDateStr(date) {
//            var str = date.getFullYear() 
//            + '-' 
//            + (date.getMonth() < 9 ?  '0' + (date.getMonth() + 1) : (date.getMonth() + 1))
//            + '-' 
//            + (date.getDate() < 10 ? '0' + date.getDate() : date.getDate());
//            return str;
//        }
//        var str = getDateStr(now) + ' ' + (now.getHours() + '时'); 
        return str;
    },
    showNext: function () {
        ++this.index;
        if (this.index > this.total) {
            if (!this.total % 3 == 0) {
                //图片数目不能被三整出，在播放循环交界处，需要先重置
                this.resetLayers();
            }
            this.index = 1;
        }
        this.hidePrev()//隐藏第0张
            .showCur()//显示第一张
            .loadNext();//预加载第二张
        this.showProgress();
        return this;
    },
    showPrev: function () {
        //显示上一张。1 2 3 显示的永远是中间的 。
        //退后一步，变为 3 1 2，此时，显示1，加载3，隐藏2
        --this.index;
        if (this.index <= 0) {
            if (!this.total % 3 == 0) {
                //图片数目不能被三整出，在播放循环交界处，需要先重置
                this.resetLayers();
            }
            this.index = this.total;
        }
        this.hideNext()//隐藏当前显示的
            .showCur()//显示上一张被隐藏的
            .loadPrev();//预加载再上一张
        this.showProgress();
        return this;
    },
    hideNext: function () {
        return this;
    },
    hidePrev: function () {
        return this;
    },
    //
    showCur: function () {
        var curImg = this.layers[this.index % 3];
        var curImg12 = this.layers12[this.index % 3];
        if (!curImg.src) {
            this.loadCur();
            this.loadCur12();
        }
        this.viewer.load(curImg.src, curImg.src);
        this.viewer12.load(curImg12.src,curImg12.src);
        return this;
    },

    getUrl: function (number) {
        if (this.imgs.length == 0) {
            return;
        }
        return this.imgs[number - 1].url;
    },

    getUrl12: function (number) {
        if (this.imgs.length == 0) {
            return;
        }
        return this.imgs[number - 1].url12;
    },

    loadCur: function () {
        var curImg = this.layers[this.index % 3];
        curImg.src = this.getUrl(this.index);
        return this;
    },

    loadCur12: function () {
        var curImg12 = this.layers12[this.index % 3];
        curImg12.src = this.getUrl12(this.index);
        return this;
    },

    loadPrev: function () {
        var prevImg = this.layers[(this.index - 1) % 3];
        var prevImg12 = this.layers12[(this.index - 1) % 3];
        var number = (this.index - 1) <= 0 ? this.total : (this.index - 1);
        prevImg.src = this.getUrl(number);
        prevImg12.src = this.getUrl12(number);
        return this;
    },
    loadNext: function () {
        var prevImg = this.layers[(this.index + 1) % 3];
        var prevImg12 = this.layers12[(this.index + 1) % 3];
        var number = (this.index + 1) > this.total ? 1 : (this.index + 1);
        prevImg.src = this.getUrl(number);
        prevImg12.src = this.getUrl12(number);
        return this;
    }
};
player.init();
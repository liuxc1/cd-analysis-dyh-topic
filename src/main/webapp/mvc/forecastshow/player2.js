var player2 = {
    init: function (cjList) {
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
        this.checkList=cjList;
        //图片容器
        this.containerArr =[];
        this.viewerArr=[];
        for(var i=0;i<this.checkList.length;i++){
            if(this.checkList[i].info.checked){
                var container1 = document.getElementById("sceneDiv"+this.checkList[i].info.sceneId+'41');
                var container2 = document.getElementById("sceneDiv"+this.checkList[i].info.sceneId+'42');
                this.containerArr.push(container1);
                this.containerArr.push(container2);
            }
        }
        for(var i=0;i<this.containerArr.length;i++){
            this.viewerArr.push(ImageViewer(this.containerArr[i]));
        }
        this.addEventListener();
        this.reset();
    },
    isCurImg: function (img) {
        var curImg = this.layersArr[this.index - 1];
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
    reset: function (imgs,checkList) {
        this.checkList = checkList;
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
            li.setAttribute("data-src", this.urlBase);
            if (this.title != undefined && this.title != '') {
                li.setAttribute("data-title", this.title);
            }
            li.setAttribute("data-oper", "progress_item");
            li.className = "isButton";
            ul.appendChild(li);
        });
        $(".item_img_list").html(ul);
    },

    resetLayers: function () {
        this.layersArr = [];
        for (let i = 0; i < this.containerArr.length; i++) {
            this.layersArr.push([new Image(), new Image(), new Image()])
        }
        this.$cache.empty();
        var that = this;

        for (let i = 0; i < this.containerArr.length; i++) {
            $.each(this.layersArr[i], function () {
                this.addEventListener("error", function () {
                    that.onError(this);
                });
                that.$cache.append(this);
            });
        }
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
            $li = $(".item_img_list").find(".active").removeClass("active")
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
        var curImgArr = [];
        for (let i = 0; i < this.viewerArr.length ; i++) {
            curImgArr.push(this.layersArr[i][this.index % 3])
        }
        for (let i = 0; i <this.viewerArr.length  ; i++) {
            if (!curImgArr[i].src){
                this.loadCurArr(i);
            }
        }
        for (let i = 0; i < this.viewerArr.length ; i++) {
            this.viewerArr[i].load(curImgArr[i].src,curImgArr[i].src)
        }

        return this;
    },
    getUrl: function (number,i) {
        if (this.imgs.length == 0) {
            return;
        }
        let key=i%2!=0?"urlBase":"urlCase";
        return this.imgs[number - 1][key];
    },

    loadCurArr:function(i){
        var curImg = this.layersArr[i][this.index % 3];
        curImg.src = this.getUrl(this.index,i);
        return this;
    },
    loadPrev: function () {
        var prevImgArr = [];
        var number = (this.index - 1) <= 0 ? this.total : (this.index - 1);
        for (let i = 0; i < this.viewerArr.length; i++) {
            var prevImg = this.layersArr[i][(this.index + 1) % 3];
            prevImg.src = this.getUrl(number,i);
            prevImgArr.push(prevImg)
        }
    },
    loadNext: function () {
        var prevImgArr = [];
        var number = (this.index + 1) > this.total ? 1 : (this.index + 1);
        for (let i = 0; i < this.viewerArr.length; i++) {
            var prevImg = this.layersArr[i][(this.index + 1) % 3];
            prevImg.src = this.getUrl(number,i);
            prevImgArr.push(prevImg)
        }
        return this;
    }
};

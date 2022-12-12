var search = {
    resize: function() {
        var height = document.documentElement.clientHeight;
        document.getElementById("container").style.height = height + 'px';
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
        //var str = '';
        pattern = pattern || 'yyyy-mm-dd';
        return pattern.toLowerCase().replace("yyyy", y).replace("mm", m).replace("dd", d).replace("hh", h);
    },
    
    
    init: function() {
        var today = new Date();
        $("#dateTime").val(this.formatDate(today.getTime()));
        this.resize();
    }
};
$(function() {
    search.init();
    //http://112.49.34.57:10093/ModelSimulate/A1A0C9BD0556476B95FC0E199DE7C24C/hourly/d2/aqi/srf-007.gif
    $('.col.btn-col').click(function(){//timeData,sensNames,picData
    	searchPicture();
    });
    searchPicture();
});

function searchPicture(){
	//时间列表
	var arr = $("#dateTime").val();
	var modelDate = strToDate(arr);
	//污染物
	var pollute = $('input[name="pollutions"]:checked').val();
	//选中模型的名称
	var sensNames = new Array(); 
	$('input[name="models"]:checked').each(function(){//遍历每一个名字为models的复选框，其中选中的执行函数  
		sensNames.push($(this).val());//将选中的值添加到数组chk_value中  
	});
	
	//存放播放时间
	var timeData = new Array();
	for (var i = 0; i < 3; i++) {
		timeData.push(getDateStr(modelDate));
		modelDate.setDate(modelDate.getDate() +1);
    }
	//存放url
	var picData = new Array();
	
	//var url = "http://119.253.32.9:8183/forecast/";
	
	//注意此处
	for(var i = 1; i <= timeData.length; i++){
		var urlArr = new Array(); 
		for (var j = 0; j < sensNames.length; j++) {
			var modelName = "";
			if("CMAQ" == sensNames[j]){
				modelName = "CMAQ";
			}else if("WRF_CHEM" == sensNames[j]){
				modelName = "WRFCHEM";
			}else if("CAMX" == sensNames[j]){
				modelName = "CAMX";
			}
			urlArr.push(url + modelName + "/" + timeData[i-1].replace(/-/g,'/') + "/d2/" + pollute + "/srf-00" + i + ".gif");
			//urlArr.push('http://112.49.34.57:10093/ModelSimulate/A1A0C9BD0556476B95FC0E199DE7C24C/hourly/d2/aqi/srf-00' + i + '.gif');
	    }
		picData.push(urlArr);
	}
	picTime.init(timeData,sensNames,picData);
}

//字符串转date
function strToDate(dateStr) {
	return new Date(dateStr.replace(/-/g, "/"));
}
//日期增加
function addDate(dd,dadd){
	var a = new Date(dd);
	a = a.valueOf();
	a = a + dadd * 24 * 60 * 60 * 1000;
	a = new Date(a);
	return a;
}
//获取指定日期的字符串
function getDateStr(date) {
		var y = date.getFullYear();
		var m = date.getMonth() + 1;//获取当前月份的日期 
		var c = "" + m;
		var d = date.getDate();
		var x = "" + d;
		if (c.length == 1) {
			c = '0' + c;
		}
		if (x.length == 1) {
			x = '0' + x;
		}
		return y + "-" + c + "-" + x;
}

var picTime = new Object({
	init : function(timeData,sensNames,picData){
		this.timeLen = timeData.length,//天数
		this.picLen = sensNames.length,//展示几张图片
		this.width='467px',
		this.height='367px',
		this.clickIndex=0,//选中索引
		this.time='',
		this.bindEvent(),// 事件绑定
		this.showTime(timeData),//渲染
		this.showPic(sensNames,picData)//渲染
	},
	bindEvent: function(){
		var _this=this
		$(".next").off('click').on("click",function(){
			if(_this.clickIndex==_this.timeLen-1){
				_this.clickIndex=0;
			  }else{
			  	_this.clickIndex+=1;
			  }
			  _this.move(_this.clickIndex);
			  _this.stoptime();
		})
		//上一张
		$(".prev").off('click').on("click",function(){
			if(_this.clickIndex==0){
				_this.clickIndex=0;
			  }else{
			  	_this.clickIndex-=1;
			  }
			  _this.move2(_this.clickIndex);
			  _this.stoptime();
		})
		//播放
		$(".play").off('click').on("click",function(){
			$(this).hide().next().show();
			_this.time=setInterval(function(){
				if(_this.clickIndex==_this.timeLen-1){
					_this.clickIndex=0;
					_this.stoptime();
				  }else{
					_this.clickIndex+=1;
				  }
				  _this.move(_this.clickIndex);
			},1000);
		});	
		$(".stop").off('click').on("click",function(){
			$(this).hide().prev().show();
			clearInterval(_this.time);	
		});
	},
	showPic: function(sensNames,picData){
		var _this=this,ml='0',name=sensNames, picSrc=picData;
		
		//console.log(sensNames);
		//console.log(picData);
		
		$('.main-pic .ul li').html(' ');
		if(_this.picLen<2){
			ml='25%';
		}
		for(var i=0;i<_this.timeLen;i++){
			for(var j=0;j<_this.picLen;j++){
				$('.main-pic .ul li').eq(i).append("<div class='div-pic' style='margin-left:"+ml+"'><img alt='"+picSrc[i][j]+"' src='"+picSrc[i][j]+"' style='width:"+_this.width+";height:"+_this.height+"'/><p>"+name[j]+"</p></div>");
			}
		}
		$(".div-pic img").error(function () {
			
	        $(this).attr("src", ctx + "/assets/components/MM5/images/style/0.jpg");
	    });
	},
	showTime:function(timeData){
		var _this=this;
		var day=timeData;
		$('.main-pic .ul').html(' ');
		$('.main-pic .ol').html(' ');
		$('.main-pic-timeNum').html(' ');
		for(var i=0;i<_this.timeLen;i++){
			$('.main-pic .ul').append("<li></li>");
			$('.main-pic .ol').append("<li style='width:"+(100/_this.timeLen)+"%' tit='"+day[i]+"'></li>");
			$('.main-pic-timeNum').append("<p style='width:"+(100/_this.timeLen)+"%;display: none;'>"+day[i]+"</p>");
		}
		$('.main-pic .ul li').eq(0).addClass('cur').siblings('li').removeClass('cur');
		$('.main-pic .ol li').eq(0).addClass('cur').siblings('li').removeClass('cur');
		$('.main-pic .ol li').eq(0).addClass('first');
		$('.main-pic .ol li').eq(_this.timeLen-1).addClass('last');
		$('.main-pic-day span').html($('.main-pic .ol li').eq(0).attr('tit'));
	},
	move:function(index){
		$('.main-pic .ul li').eq(index).addClass('cur').siblings('li').removeClass('cur');
		$('.main-pic .ol li').eq(index).addClass('cur');
		$('.main-pic .ol li').eq(index).prevAll($('li')).addClass('cur');
		$('.main-pic .ol li').eq(index).nextAll($('li')).removeClass('cur');
		$('.main-pic-day span').html($('.main-pic .ol li').eq(index).attr('tit'));
	},
	move2:function(index){
		$('.main-pic .ul li').eq(index).addClass('cur').siblings('li').removeClass('cur');
		$('.main-pic .ol li').eq(index).nextAll($('li')).removeClass('cur');
		$('.main-pic-day span').html($('.main-pic .ol li').eq(index).attr('tit'));
	},
	stoptime:function(){
		var _this=this;
		clearInterval(_this.time);
		$('.play').show();
		$('.stop').hide();
	}
});


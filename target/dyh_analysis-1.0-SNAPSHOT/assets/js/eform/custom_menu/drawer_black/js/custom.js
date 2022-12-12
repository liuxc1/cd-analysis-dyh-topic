$(function() {
	$('#scroll').niceScroll();
	$('div[name=scroll2]').niceScroll();
	$('.lr-close').click(function() {
		$('.l-wrap').css({
			'width': "79px"
		});
		$('.l-right').animate({
			"left": "-350px"
		}, 1000);
		$('.l-left').addClass('l-left-shadow');
		$('.l-left dl').removeClass('cur');
	});
	$('.close').click(function() {
		$('.pop-up').hide();
	});

	//左侧添加滑出菜单
	$('.l-left>dl').hover(function() {
		var hover_top = $(this).offset().top;
		/*lr操作开始*/
		$(".vertical-nav").eq($(this).index()).siblings('.vertical-nav').hide();
		$(".vertical-nav").eq($(this).index()).show().css("top",hover_top-20);
		var _windowHeight=document.documentElement.clientHeight;
   	 	if($('.vertical-nav').eq($(this).index()).find("li").length>0 && $('.vertical-nav').eq($(this).index()).offset().top+$('.vertical-nav').eq($(this).index()).height()>_windowHeight){
   	 		var _curnav=$('.vertical-nav').eq($(this).index());
   	 		_curnav.css("top",_windowHeight-_curnav.height()-22+"px");
   	 		
   	 	}
   	 	/*lr操作结束*/
		$(this).css('background', '#464f5e').siblings().css('background', 'transparent');
	})
	
	$('.vertical-nav').hover(function(){
		
	},function(){
		$(".vertical-nav").css('display', 'none')
	})
	
});
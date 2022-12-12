<%@ page language="java" pageEncoding="UTF-8" %>
<div id="zcz_page" class="no-margin-bottom">
    <div class="space-4"></div>
    <ul class="page_ul pagination no-margin">
        <li id="zcz_page_li1" num="first" class="disabled"><a href="javascript:void(0)"> <i class="ace-icon fa fa-angle-double-left"></i></a></li>
        <li id="zcz_page_li2" num="up" class="disabled"><a href="javascript:void(0)"><i class="ace-icon fa fa-angle-left"></i></a></li><li num="1" class="zcz_page_li active"><a href="javascript:void(0)">1</a></li><li num="2" class="zcz_page_li"><a href="javascript:void(0)">2</a></li>
        <li id="zcz_page_li8" num="next"><a href="javascript:void(0)"><i class="ace-icon fa fa-angle-right"></i></a></li>
        <li id="zcz_page_li9" num="last"><a href="javascript:void(0)"><i class="ace-icon fa fa-angle-double-right"></i></a></li>
    </ul>
    <div class="page_total pull-right" style="height: 32px; float: left;">
    	<div style="position: relative; height: 18px; margin: 7px 0px; float: left;">  
           	<span>共${pageInfo.pages}页/共${pageInfo.total}条</span> 跳到第
        </div>
        &nbsp;
        <div style="position: relative; height: 26px; margin: 3px 0px; float: right;">
        	<input type="text" id="pageChangeNum" value="${pageInfo.pageNum}"  style="width:35px;height:26px; padding: 1px 4px;"
            onKeyUp="$.Page.pageChange(this)"> 页
        <button class="btn  btn-xs  btn-xs-ths"  style="min-width:40px; height: 26px; margin-top: -3px;" onclick="$.Page.submit()">GO</button>
        </div>
    </div>
    <input type="hidden" id="pages" name="pages" value="2">
    <input type="hidden" id="pageNum" name="pageNum" value="1">
    <input type="hidden" id="pageSize" name="pageSize" value="10">
    <input type="hidden" id="orderBy" name="orderBy" value=" t.tree_sort asc">
</div>
<script>

    $(function () {
        //pageTable();
    })
    function pageTable() {
        var li1 = $("#zcz_page_li1");
        var li2 = $("#zcz_page_li2");
        var li8 = $("#zcz_page_li8");
        var li9 = $("#zcz_page_li9");
        
        /*if($("#pages").val() == "1")
        	$("#zcz_page").hide();
        */
        
        var pageNum = $("#pageNum");
        //初始化分页的方法，首先取得总页数
        var totalnum = parseInt($("#pages").val());
		
        //如果共1页，则关闭上一页下一页等
        if (totalnum < 1)
            totalnum = 1;
        li1.addClass("disabled");
        li2.addClass("disabled");
        if (totalnum == 1) {
            li8.addClass("disabled");
            li9.addClass("disabled");
        }

        shownum = totalnum;

        //如果页数大于5，初始化上一页下一页之间的页码
        if (shownum > 5)
            shownum = 5;
        var pagehtml = ""
        for (i = 1; i <= shownum; i++) {
            pagehtml += "<li num=" + i + " class='zcz_page_li'><a href='javascript:void(0)'>"
                    + i + "</a></li>";
        }
        li2.after(pagehtml);
        li2.next().addClass("active");

        //初始化当前页面
        init();

        //添加每个按钮的点击事件
        $("#zcz_page ul li").on(
                "click",
                function () {
                    var linum = $(this).attr("num");
                    var li = $(".zcz_page_li");
                    if (linum == "first") {
                        pageNum.val(1);
                    } else if (linum == "last") {
                        pageNum.val(totalnum);
                        //alert(pageNum.val())
                    } else if (linum == "up") {
                        pagenum = pageNum.val();
                        if (pagenum == 1)
                            pagenum = 2;
                        pageNum.val(pagenum - 1);
                    } else if (linum == "next") {
                        pagenum = pageNum.val();
                        if (pagenum == totalnum)
                            pagenum = totalnum - 1;
                        if (pagenum <= totalnum)
                            pageNum.val(parseInt(pagenum)
                                    + parseInt(1));
                    } else {
                        pagenum = pageNum.val();
                        pageNum.val(linum);
                    }
                    if ($(this).attr("class") != "disabled") {
                        doSearch();
                    }

                });

        function init() {
            //获取当前页
            var linum = parseInt($("#pageNum").val());
            var li = $(".zcz_page_li");

            if (linum <= totalnum - 2 && linum > 3
                    && linum <= totalnum) {
                for (i = 1; i <= li.size(); i++) {
                    $(li.get(i - 1)).attr("num", linum - 3 + i)
                    $(li.get(i - 1)).find("a").html(
                            linum - 3 + i);
                }
            }
            if (linum == totalnum - 1 && linum > 3
                    && linum <= totalnum) {
                for (i = 1; i <= li.size(); i++) {
                    $(li.get(i - 1)).attr("num", linum - 4 + i)
                    $(li.get(i - 1)).find("a").html(
                            linum - 4 + i);
                }
            }
            if (linum == totalnum && linum > 4
                    && linum <= totalnum) {
                for (i = 1; i <= li.size(); i++) {
                    $(li.get(i - 1)).attr("num", linum - 5 + i)
                    $(li.get(i - 1)).find("a").html(
                            linum - 5 + i);
                }
            }
            if (linum == 2 && totalnum > 3 && linum <= totalnum) {
                for (i = 1; i <= li.size(); i++) {
                    $(li.get(i - 1)).attr("num", linum - 2 + i)
                    $(li.get(i - 1)).find("a").html(
                            linum - 2 + i);
                }
            }
            if (linum == (totalnum - 1) && totalnum > 4
                    && linum <= totalnum) {
                for (i = 1; i <= li.size(); i++) {
                    $(li.get(i - 1)).attr("num", linum - 4 + i)
                    $(li.get(i - 1)).find("a").html(
                            linum - 4 + i);
                }
            }
            if (linum > totalnum) {
                var num = 5;
                if (linum < 5)
                    num = linum;
                for (i = 1; i <= num; i++) {
                    $(li.get(i - 1)).attr("num",
                            linum - num + i)
                    $(li.get(i - 1)).find("a").html(
                            linum - num + i);
                }
            }

            //判断显示那一页
            pagenum = parseInt(pageNum.val());
            if (pagenum == 0)
                pagenum = 1;
            li.removeClass("active");
            if (pagenum == 1 && totalnum != 1) {
                li1.addClass("disabled");
                li2.addClass("disabled");
                li8.removeClass("disabled");
                li9.removeClass("disabled");
            } else if (pagenum == totalnum && totalnum != 1) {
                li8.addClass("disabled");
                li9.addClass("disabled");
                li1.removeClass("disabled");
                li2.removeClass("disabled");
            } else if (pagenum == totalnum && totalnum == 1) {
                li8.addClass("disabled");
                li9.addClass("disabled");
                li1.addClass("disabled");
                li2.addClass("disabled");
            } else if (pagenum > totalnum) {
                li8.addClass("disabled");
                li9.addClass("disabled");
                li1.removeClass("disabled");
                li2.removeClass("disabled");
            } else {
                li8.removeClass("disabled");
                li9.removeClass("disabled");
                li1.removeClass("disabled");
                li2.removeClass("disabled");
            }
            for (i = 1; i <= li.size(); i++) {
                if ($(li.get(i - 1)).attr("num") == pagenum)
                    $(li.get(i - 1)).addClass("active");

            }
        }
    }


    jQuery.Page = {
        pageChange: function (o) {
            var $o = $(o);
            var reg = /^(-|\+)?\d+$/;
            var numpage = $o.val();
            var tatalpage = $("#pages").val();
            if (reg.test(numpage)) {
                var pagenum = $o.val();
                if (parseInt(numpage) > parseInt(tatalpage)) {
                    $o.val(tatalpage);
                    pagenum = tatalpage;
                }
                if (numpage == 0) {
                    $o.val("1");
                    pagenum = 1;
                }
                $("#pageNum").val(pagenum);
            } else {
                $o.val("");
            }

        },
        submit: function () {
            if ($("#pageChangeNum").val() == "") {
                //alert("跳转页面不能为空");
            } else {
                doSearch();
            }
        }
    }

</script>
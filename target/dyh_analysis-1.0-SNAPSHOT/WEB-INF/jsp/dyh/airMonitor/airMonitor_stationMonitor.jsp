<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <title>数据查询-空气监测数据查询-国省市控站点数据</title>
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp" %>
    <style type="text/css">
        ul {
            width: 100%;
            margin-bottom: 0px;
            display: block;
        }

        li {
            display: inline-block;
            margin-right: 15px;
            cursor: pointer;
            padding-left: 5px;
            padding-right: 5px;
            font-size: 14px
        }

        .hactive {
            color: #1f66f6;
            padding-left: 4px;
            padding-right: 4px;
            /* font-weight: bold; */
        }

        td {
            vertical-align: middle !important;
            font-size: 14px;
        }

        td:nth-child(odd) {
            background-color: #f5f5f5
        }
    </style>
</head>

<body class="no-skin">
<div class="main-container">
    <div class="main-content">
        <div class="main-content-inner">
            <c:if test="${showTitle=='true'}">
                <div class=" fixed-page-header fixed-40">
                    <div id="breadcrumbs" class="breadcrumbs">
                        <ul class="breadcrumb">
                            <li class="active">
                                <h5 class="page-title">
                                    <i class="fa fa-map-pin"></i>
                                    国省市控站点数据
                                </h5>
                            </li>
                        </ul>
                    </div>
                </div>
            </c:if>
            <div class="main-content-inner padding-page-content">
                <div class="page-content">
                    <form id="formlist" class="form-horizontal" method="post" target="echart"
                          action="countryMonitor.vm">
                        <input type="hidden" id="REGION" name="form[REGION]"/>
                        <i></i>
                        <input type="hidden" id="STATIONTYPE" name="form[STATIONTYPE]" value="${form.STATIONTYPE }"/>
                        <i></i>
                        <input type="hidden" id="SNAME" name="form[SNAME]" value="${form.SNAME }"/>
                        <i></i>
                        <input type="hidden" id="NEARSNAME" name="form[NEARSNAME]" value="${form.NEARSNAME }"/>
                        <i></i>
                        <input type="hidden" id="PULL" name="form[PULL]" value="${form.PULL }"/>
                        <table class="table table-bordered">
                            <colgroup>
                                <col width="8%"/>
                                <col width="96%"/>
                            </colgroup>
                            <tr>
                                <td class="text-center">
                                    <div>监测时间</div>
                                </td>
                                <td id="datequery">
                                    <div class="row">
                                        <div class="col-md-4 no-padding-right">
                                            <div class="input-group">
                                                <input type="text" id="beginHour" class="form-control" readonly
                                                       name="form[beginDate]" value="${form.beginHour}"
                                                       placeholder="开始时间"
                                                       onclick="WdatePicker({firstDayOfWeek:1,isShowClear:false,dateFmt:'yyyy-MM-dd HH',maxDate:'#F{$dp.$D(\'endHour\')}'})"/>
                                                <span class="input-group-btn">
														<button type="button" class="btn btn-white btn-default"
                                                                onclick="WdatePicker({el:'beginHour',dateFmt:'yyyy-MM-dd HH',isShowClear:false,firstDayOfWeek:1,maxDate:'#F{$dp.$D(\'endHour\')}'})">
															<i class="fa fa-calendar"></i>
														</button>
													</span>
                                            </div>
                                        </div>
                                        <div class="col-md-1" style="margin-top: 8px">
                                            <label>至</label>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="input-group">
                                                <input type="text" id="endHour" class="form-control" readonly
                                                       name="form[endDate]" value="${form.endHour}" placeholder="结束时间"
                                                       onclick="WdatePicker({firstDayOfWeek:1,isShowClear:false,dateFmt:'yyyy-MM-dd HH',minDate:'#F{$dp.$D(\'beginHour\')}',maxDate:'%y-%M-%d'})"/>
                                                <span class="input-group-btn">
														<button type="button" class="btn btn-white btn-default"
                                                                onclick="WdatePicker({el:'endHour',dateFmt:'yyyy-MM-dd HH',isShowClear:false,firstDayOfWeek:1,minDate:'#F{$dp.$D(\'beginHour\')}',maxDate:'%y-%M-%d'})">
															<i class="fa fa-calendar"></i>
														</button>
													</span>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td class="text-center">
                                    <div>行政区</div>
                                </td>
                                <td colspan="3">
                                    <div class="col-md-12 no-padding no-margin">
                                        <div class="col-md-11 no-padding no-margin regionlist"
                                             style="height: 22px; overflow: hidden;">
                                            <ul class="countryquency">
                                            </ul>
                                        </div>
                                        <div style="float: right">
                                            <div style="display: inline-block; cursor: pointer;">
                                                <span class="moreregion">更多</span>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td class="text-center">站点类型</td>
                                <td colspan="3">
                                    <ul class="stationtype">
                                        <li code="全部">全部</li>
                                        <li code="0">国控</li>
                                        <li code="1">省控</li>
                                        <li code="2">市控</li>
                                        <li code="9">微站</li>
                                        <li code="99">微站_校核后</li>
                                    </ul>
                                </td>
                            </tr>
                            <tr>
                                <td class="text-center">站点</td>
                                <td colspan="3">
                                    <div class="col-md-12 no-padding no-margin">
                                        <div class="col-md-11 no-padding no-margin stationlist"
                                             style="height: 22px; overflow: hidden;">
                                            <ul class="stationname">
                                            </ul>
                                        </div>
                                        <div style="float: right">
                                            <div style="display: inline-block; cursor: pointer;">
                                                <span class="more">更多</span>
                                            </div>
                                        </div>
                                    </div>

                                </td>
                            </tr>
                            <tr>
                                <td class="text-center">附近站点</td>
                                <td colspan="3">
                                    <div class="col-md-12 no-padding no-margin">
                                        <div class="col-md-11 no-padding no-margin near-station-list"
                                             style="height: 22px; overflow: hidden;">
                                            <ul class="near-station">
                                            </ul>
                                        </div>
                                        <div style="float: right">
                                            <div style="display: inline-block; cursor: pointer;">
                                                <span class="more-near-station">更多</span>
                                            </div>
                                        </div>
                                    </div>

                                </td>
                            </tr>
                            <tr>
                                <td class="text-center">指标选择</td>
                                <td colspan="3">
                                    <ul class="polluquency">
                                        <li code="AQI">AQI</li>
                                        <li code="PM25">
                                            PM<sub>2.5</sub>
                                        </li>
                                        <li code="PM10">
                                            PM<sub>10</sub>
                                        </li>
                                        <li code="NO2">
                                            NO<sub>2</sub>
                                        </li>
                                        <li code="SO2">
                                            SO<sub>2</sub>
                                        </li>
                                        <li code="O3">
                                            O<sub>3</sub>
                                        </li>
                                        <li code="CO">CO</li>
                                    </ul>
                                </td>
                            </tr>
                        </table>
                        <div class="row" style="margin-top: 12px;">
                            <div class="form-group" style="position: absolute; right: 3%; z-index: 99">
                                <button type="button" class="btn  btn-info btn-default-ths" data-self-js="doSearch()">
                                    <i class="fa fa-search"></i>
                                    查询
                                </button>
                                <button type="button" class="btn btn-purple btn-default-ths"
                                        data-self-js="exportExcel()">
                                    <i class="ace-icon fa fa-file-excel-o"></i>
                                    导出
                                </button>
                            </div>
                        </div>
                    </form>
                    <div>
                        <iframe name="echart" height="400px" width="100%" scrolling="no"
                                style="border: none; margin-top: 35px;"></iframe>
                    </div>
                    <div>
                        <iframe name="table" height="450px" width="100%" style="border: none;" scrolling="no"></iframe>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp" %>
<script type="text/javascript" src="${ctx}/assets/components/echarts/echarts.min.js?v=20221129015223"></script>

<script type="text/javascript">
    $(function () {
        //行政区点击事件
        $(".countryquency").on("click", "li", function () {
            if ($(this).attr("code") == "全部") {
                $(".countryquency li").removeClass("hactive");
                $(this).addClass("hactive");
            } else {
                $(".countryquency li:first").removeClass("hactive");
                if ($(this).hasClass("hactive")) {
                    $(this).removeClass("hactive");
                } else {
                    $(this).addClass("hactive");
                }
                if ($(".countryquency .hactive").length == 0) {
                    $(".countryquency li:first").addClass("hactive");
                }
            }
            var data = new Array();
            $(".countryquency .hactive").each(function (i, e) {
                data.push($(e).attr("code"))
            })
            $("#REGION").val(data);
            getStation();
        })

        //站点类型点击事件
        $(".stationtype li").on("click", function () {
            if ($(this).attr("code") == "全部") {
                $(".stationtype li").removeClass("hactive");
                $(this).addClass("hactive");
            } else {
                $(".stationtype li:first").removeClass("hactive");
                if ($(this).hasClass("hactive")) {
                    $(this).removeClass("hactive");
                } else {
                    $(this).addClass("hactive");
                }
                if ($(".stationtype .hactive").length == 0) {
                    $(".stationtype li:first").addClass("hactive");
                }
            }
            var data = new Array();
            $(".stationtype .hactive").each(function (i, e) {
                data.push($(e).attr("code"))
            })
            $("#STATIONTYPE").val(data);
            getStation();
        })
        //站点选择
        $(".stationname").on("click", 'li', function () {
            if ($(this).hasClass("hactive")) {
                $(this).removeClass("hactive");
            } else {
                $(this).addClass("hactive");
            }
            var data = new Array();
            $(".stationname .hactive").each(function (i, e) {
                data.push($(e).attr("code"))
            })
            if (data.length > 5) {
                alert("最多只能选择五个站点");
                $(this).removeClass("hactive");
                data.remove($(this).attr("code"));
            }
            if (data.length == 0) {
                $(this).addClass("hactive");
                data.push($(this).attr("code"));
            }
            $("#SNAME").val(data);
            $("#NEARSNAME").val("");
            getNearStation();
        })
        //附近站点
        $(".near-station").on("click", '#nearStation', function () {
            if ($(this).hasClass("hactive")) {
                $(this).removeClass("hactive");
            } else {
                $(this).addClass("hactive");
            }
            var data = new Array();
            $(".near-station .hactive").each(function (i, e) {
                data.push($(e).attr("code"))
            })
            if (data.length > 5) {
                alert("最多只能选择五个站点");
                $(this).removeClass("hactive");
                data.remove($(this).attr("code"));
            }
            $("#NEARSNAME").val(data);
        })
        //指标选择点击事件
        $(".polluquency li").on("click", function () {
            $(".polluquency li").removeClass("hactive");
            $(this).addClass("hactive");
            var data = new Array();
            $(".polluquency .hactive").each(function (i, e) {
                data.push($(e).attr("code"))
            })
            if (data.length == 0) {
                $(this).addClass("hactive");
                data.push($(this).attr("code"));
            }
            $("#PULL").val(data);
        })
        $(".moreregion").on("click", function () {
            var code = $(this).text();
            if (code == "更多") {
                $(this).text("收起");
                $(".regionlist").css("height", "100%")
                $(".regionlist").css("overflow", "visible")
            } else {
                $(this).text("更多");
                $(".regionlist").css("height", "22px")
                $(".regionlist").css("overflow", "hidden")
            }

        })

        $(".more").on("click", function () {
            var code = $(this).text();
            if (code == "更多") {
                $(this).text("收起");
                $(".stationlist").css("height", "100%")
                $(".stationlist").css("overflow", "visible")
            } else {
                $(this).text("更多");
                $(".stationlist").css("height", "22px")
                $(".stationlist").css("overflow", "hidden")
            }

        })
        $(".more-near-station").on("click", function () {
            var code = $(this).text();
            if (code == "更多") {
                $(this).text("收起");
                $(".near-station-list").css("height", "100%")
                $(".near-station-list").css("overflow", "visible")
            } else {
                $(this).text("更多");
                $(".near-station-list").css("height", "22px")
                $(".near-station-list").css("overflow", "hidden")
            }

        })

        initialize();
        doSearch();
    })

    function initialize() {
        getRegionList();
        $(".countryquency li:first").click();
        $(".polluquency li:first").click();
        $(".stationtype li:first").click();
        $(".datafrequency li:first").click();

    }

    //获取行政区
    function getRegionList() {
        $.post("./getRegionList.vm", {
            "form[parentCode]": '510100000000',
        }, function (data) {
            $(".countryquency").html("");
            var lis = "";
            var codes = new Array();
            for (let i = 0; i < data.length; i++) {
                lis += "<li code=" + data[i].NAME + ">" + data[i].NAME + "</li>"
                codes.push(data[i].NAME);
            }
            $(".countryquency").html(lis);
            $(".countryquency li:first").click();

            if ($(".countryquency li").length == 0) {
                $(".countryquency").html("<p style='color:red'>暂无数据<p>");
                $("button").attr('disabled', "true");
            } else {
                $("button").removeAttr("disabled");
            }
            var width = 0;
            for (var i = 0; i < $(".countryquency li").length; i++) {
                width += ($(".countryquency li").eq(i).width() + 30);
            }
            if (width > ($(".countryquency").width() + 30)) {
                $(".moreregion").show();
            } else {
                $(".moreregion").hide();
            }
        }, 'json')
    }

    //获取站点
    function getStation() {
        $.post("./getStationList.vm", {
            "form[REGION]": $("#REGION").val(),
            "form[TYPECODE]": '2',
            "form[STATIONTYPE]": $("#STATIONTYPE").val()
        }, function (data) {
            $(".stationname").html("");
            var lis = "";
            var codes = new Array();
            for (var i = 0; i < data.length; i++) {
                lis += "<li code=" + data[i].NAME + ">" + data[i].NAME + "</li>"
                codes.push(data[i].NAME);
            }
            $(".stationname").html(lis);
            $(".stationname li:first").click();

            if ($(".stationname li").length == 0) {
                $(".stationname").html("<p style='color:red'>无相关站点<p>");
                $("button").attr('disabled', "true");
            } else {
                $("button").removeAttr("disabled");
            }
            var width = 0;
            for (var i = 0; i < $(".stationname li").length; i++) {
                width += ($(".stationname li").eq(i).width() + 30);
            }
            if (width > ($(".stationname").width() + 30)) {
                $(".more").show();
            } else {
                $(".more").hide();
            }
        }, 'json')
    }

    //获取附近站点
    function getNearStation() {
        $.post("./getNearStationList.vm", {
            "form[SNAME]": $("#SNAME").val(),
        }, function (data) {
            $(".near-station").html("");
            var lis = "";
            var codes = new Array();
            for (var key in data) {
                for (let i = 0; i < data[key].length; i++) {
                    lis += "<li code=" + key + ">" + key + ":" + "</li><li id='nearStation' code=" + data[key][i].NAME + ">" + data[key][i].NAME + "," + "</li>"
                    codes.push(data[key][i].NAME);
                }
            }

            $(".near-station").html(lis);

            if ($(".near-station li").length == 0) {
                $(".near-station").html("<p style='color:red'>无相关站点<p>");
                // $("button").attr('disabled', "true");
            } else {
                $("button").removeAttr("disabled");
            }
            var width = 0;
            for (var i = 0; i < $(".near-station li").length; i++) {
                width += ($(".near-station li").eq(i).width() + 30);
            }
            if (width > ($(".near-station").width() + 30)) {
                $(".more-near-station").show();
            } else {
                $(".more-near-station").hide();
            }
        }, 'json')
    }


    function doSearch() {
        $('#formlist').prop('target', 'echart').prop('action', 'getEchartDatas.vm').submit();
        $('#formlist').prop('target', 'table').prop('action', 'getTableDatas.vm').submit();
    }

    function exportExcel() {
        $('form').prop('action', 'exportTable.vm').submit();
    }
</script>
</body>
</html>
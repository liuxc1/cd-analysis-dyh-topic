<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>烟花爆竹案例分析</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge">
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp" %>
</head>
<style>
    .text-rank {
        text-align: left;
        text-indent: 2em;
        font-size: 16px;
        font-weight: bold;
        font-family: 'SimHei';
        padding: 10px 20px
    }
    .text-title {
        text-align: center;
        font-size: 18px;
        font-weight: bold;
        color: #3BBAB7;
        font-family: 'Microsoft YaHei';
        padding: 10px 20px
    }
</style>
<body>
<div id="vue-app" class="main-container" style="min-width: 1150px; height: auto">
    <div id="container">
        <div class="main-content-inner fixed-page-header fixed-40">
            <div id="breadcrumbs" class="breadcrumbs">
                <ul class="breadcrumb">
                    <li class="active">
                        <h5 class="page-title">
                            <i class="menu-icon fa fa-image"></i>
                            烟花爆竹案例分析
                        </h5>
                    </li>
                </ul>
            </div>
        </div>
        <div class="main-content-inner padding-page-content">
            <div class="main-content">
                <div class="col-xs-12">
                    <div class="row" id="row1">
                        <div class="col-xs-12" id="r1_col2">
                            <div class="row" id="row_h">
                                <div style="margin-top:20px;">
                                    <div class="col-xs-1"></div>
                                    <div class="col-xs-4" style="height: 550px;text-align: center">
                                        <div class="col-xs-12 text-title" >成都市烟花禁燃区分布图</div>
                                        <img src="成都市烟花禁燃分布图.png" alt=""
                                             width=600px height=440px/>
                                        <div class="col-xs-12 text-rank" >成都市主城区、温江区、双流区、天府新区、东部新区烟花爆竹全域禁燃禁放，其余区市县禁燃禁放区主要集中在建成区。
                                        </div>
                                    </div>
                                    <div class="col-xs-6" style="height: 550px">
                                        <div class="col-xs-6 text-title" >除夕（1月31日）成都市空气质量</div>
                                        <div class="col-xs-6 text-title" >大年初一（2月1日）成都市空气质量</div>
                                        <img src="除夕.png" alt=""
                                             width=49.75% height=440px/>
                                        <img src="大年年初一.png" alt=""
                                             width=49.75% height=440px/>
                                        <div class="col-xs-6 text-rank" >除夕成都市各区（市）县空气质量均为良。
                                        </div>
                                        <div class="col-xs-6 text-rank" >大年初一，受烟花爆竹燃放及传输影响，新津区等9个区市县为中度污染，龙泉驿区等8个区市县为轻度污染。
                                        </div>
                                    </div>
                                    <div class="col-xs-1"></div>
                                </div>
                                </div>
                                <div style="margin-top:10px;">
                                    <div class="col-xs-1"></div>
                                    <div class="col-xs-4" style="height: 550px;text-align: center">
                                        <div class="col-xs-12 text-title" >除夕夜至大年初一PM2.5浓度演变趋势</div>
                                        <img src="除夕至初一空气质量小时浓度变化图.gif" alt=""
                                             width=600px height=500px/>
                                        <div class="col-xs-12 text-rank" >除夕夜，受烟花爆竹燃放影响，郫都区、新都区、蒲江县等区域PM2.5浓度从20时开始出现快速升高，多个站点出现小时重度及以上污染，随后在偏北风影响下，自北向南传输影响全市；城区及偏南区域以传输影响为主。
                                        </div>
                                    </div>
                                    <div class="col-xs-6" style="height: 550px">
                                        <div class="col-xs-12 text-title" >2016-2022年春节期间空气质量变化趋势</div>
                                        <img src="1.png" alt=""
                                             width=100% height=250px/>
                                        <img src="2.png" alt=""
                                             width=100% height=250px/>
                                        <div class="col-xs-12 text-rank" >从2016-2022随着成都市烟花爆竹禁止燃放区不断扩展，禁燃禁放管控推动春节期间空气质量整体呈改善趋势，除夕至大年初一污染程度明显降低，小时重污染持续时间缩短且峰值浓度降低。
                                        </div>
                                    </div>
                                    <div class="col-xs-1"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp" %>
</body>
</html>
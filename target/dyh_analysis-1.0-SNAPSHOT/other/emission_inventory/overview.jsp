<%@ page contentType="text/html;charset=UTF-8" language="java"%><%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%><!DOCTYPE html><html lang="en"><head>    <meta charset="UTF-8">    <title>排放清单-总览</title>    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>    <link rel="stylesheet" href="${ctx }/assets/components/viewer-master/dist/viewer.min.css?v=20221129015223"></head><link href="../../assets/components/element-ui/css/index.css?v=20221129015223"/><style>    #dyh {        width: 100%;        height: 100vh;    }    .echarts-left {        height: 480px;        width: 40%;        float: left;    }    #city-polution {        height: 480px;        width: 100%;    }    .title {        text-align: center;        color: red;        font-size: 18px;        font-weight: 600;        margin-bottom: 10px;    }    .Nox-p {        width: 24%;        float: left;    }    .table {        font-size: 14px;    }    td {        color: #000000 !important;    }    th {        color: #000000 !important;    }</style><body><div class="main-container" id="dyh" v-cloak>    <div class="main-content">        <div class="main-content-inner fixed-page-header fixed-40">            <div id="breadcrumbs" class="breadcrumbs">                <ul class="breadcrumb">                    <li class="active">                        <h5 class="page-title">                            <i class="header-icon fa fa-bars"></i>                            总览                        </h5>                    </li>                </ul>            </div>        </div>        <div class="main-content-inner">            <div class="page-content">                <div class="echarts-box-side">                    <div class="title" style="text-align: left;color: #000000">一、大气污染物</div>                    <hr class="no-margin">                    <div class="col-xs-6" style="height:480px ">                        <div class="title">成都市全年大气污染物排放量</div>                        <div id="echart_1" style="height: 480px">                        </div>                    </div>                    <div class="col-xs-6" style="height:480px ">                        <div class="title">成都市全年各污染源大气污染排放占比</div>                        <div id="city-polution">                        </div>                    </div>                    <div class="pictrue-list">                        <div class="Nox-p"  id="NOx">                            <div class="title">NOx</div>                            <img style="width: 100%" src="../yqd/pictrue/2020inventory-NOx.png"/>                        </div>                        <div class="Nox-p">                            <div class="title">VOCs</div>                            <img id="VOC"  style="width: 100%" src="../yqd/pictrue/2020inventory-VOC.png"/>                        </div>                        <div class="Nox-p">                            <div class="title">PM₂.₅</div>                            <img id="PM25"  style="width: 100%" src="../yqd/pictrue/2020inventory-pm25.png"/>                        </div>                        <div class="Nox-p">                            <div class="title">PM₁₀</div>                            <img id="PM10"  style="width: 100%" src="../yqd/pictrue/2020inventory-PM10.png"/>                        </div>                    </div>                </div>                <div class="col-xs-12" style="margin-top: 20px;margin-bottom: 20px;display: none">                    <div class="title" style="text-align: left;color: #000000">二、温室气体</div>                    <hr class="no-margin">                    <div class="title" style="color: #000000;margin: 10px"> 成都市温室气体排放汇总</div>                    <table class="table table-bordered table-hover">                        <thead>                        <tr>                            <th style="text-align: center;"></th>                            <th style="text-align: center; width: 180px">二氧化硫</th>                            <th style="text-align: center; width: 180px">甲烷</th>                            <th style="text-align: center; width: 180px">氧化亚氮</th>                            <th style="text-align: center; width: 180px">氢氟碳化物</th>                            <th style="text-align: center; width: 180px">全氟化碳</th>                            <th style="text-align: center; width: 180px">六氟化硫</th>                            <th style="text-align: center; width: 180px">合计</th>                        </tr>                        </thead>                        <tbody>                        <tr v-for="(tabItem,index) in tableList">                            <template v-for="(item,index) in tabItem">                                <td :style="{'text-align': index!=0?'right':'left'}">{{item || '--'}}</td>                            </template>                        </tr>                        </tbody>                    </table>                    <div class="col-xs-12" style="margin-top: 30px">                        <div class="col-xs-6" style="height: 350px" id="air_pie">                        </div>                        <div class="col-xs-6" style="height: 350px" id="air_bar">                        </div>                    </div>                </div>            </div>        </div>    </div></div></body><script type="text/javascript" src="../../other/comon.js?v=20221129015223"></script><!-- jQuery图片查看器插件 --><script type="text/javascript" src="${ctx}/assets/components/viewer-master/dist/viewer.min.js?v=20221129015223"></script><script>    new Vue({        el: "#dyh",        data: {            tableList:[                ['温室气体排放（包括土地利用变化和林业）', '5311.08', '689.86','203.54','0.18','3.71','5.04','6213.40'],                ['能源活动', '4843.71','44.59','38.67','','','','4926.98'],                ['工业生产过程', '614.77','','0.00','0.18','3.71','5.04','623.69'],                ['农业活动', '','97.86','128.75','','','','226.61'],                ['废弃物处理','15.36','547.36','36.12','','','','598.84'],                ['土地利用变化与林业', '-162.77','0.05','0.00','','','','-162.72'],                ['温室气体排放（不包括土地利用变化和林业）','5473.85','689.81','203.54','0.18','3.71','5.04','6376.12'],            ],        },        methods: {            initCityBar1(){                // 基于准备好的dom，初始化echarts实例                var myChart = echarts.init(document.getElementById('echart_1'));                let option = {                    color: ['#3AA1FF'],                    tooltip: {                        trigger: 'axis',                        axisPointer: {                            type: 'shadow'                        }                    },                    grid: {                        containLabel: true                    },                    xAxis: [                        {                            type: 'category',                            axisTick: {show: false},                            data:['SO₂', 'NOx', 'VOCs', 'PM₁₀', 'PM₂.₅']                        }                    ],                    yAxis: [                        {                            name:'万吨',                            type: 'value'                        }                    ],                    series: [                        {                            name: '排放量',                            type: 'bar',                            barGap: 0,                            barWidth : 40,                            label: {                                normal: {                                    show: true,//开启显示                                    position: 'top',//柱形上方                                    textStyle: { //数值样式                                        color: '#000000',                                        fontSize:14                                    }                                }                            },                            // data: [7846,90873,182451,184250,63241]                            data: [0.8,9.1,18.2,18.4,6.3]                        }                    ]                };                // 使用刚指定的配置项和数据显示图表。                myChart.setOption(option);            },            initCityPolution() {                let myChart = echarts.init(document.getElementById("city-polution"));                let option = {                    tooltip: {                        trigger: 'axis',                        axisPointer: {                            type: 'shadow'                        },                        formatter: function (list) {                            let str = list[0].name;                            let num = 1;                            switch (str) {                                case 'SO₂':                                    num = 7846;                                    break;                                case 'NOx':                                    num = 90873;                                    break;                                case 'VOCs':                                    num = 182451;                                    break;                                case 'PM₁₀':                                    num = 184250;                                    break;                                case 'PM₂.₅':                                    num = 63241;                                    break;                            }                            str = str + '(吨)</br>';                            list.forEach(val => {                                str = str +'</br>'+ val.marker + val.seriesName + "&nbsp;:&nbsp;" + Math.round(((val.value / 100) * num))                            });                            return str;                        }                    },                    legend: {},                    grid: {                        containLabel: true                    },                    xAxis: {                        type: 'category',                        data: ['SO₂', 'NOx', 'VOCs', 'PM₁₀', 'PM₂.₅']                    }                    ,                    yAxis: {                        type: 'value',                        interval: 10,                        max: 100,                        axisLabel: {                            formatter: function (value) {                                return value + '%'                            }                        }                    }                    ,                    series: [                        {                            name: '工业源',                            type: 'bar',                            stack: 'Ad',                            barWidth : 50,                            emphasis: {                                focus: 'series'                            },                            data: [59.46979353, 10.25827253, 53.89940313, 26.87489824, 32.54059866]                        },                        {                            name: '移动源',                            type: 'bar',                            stack: 'Ad',                            emphasis: {                                focus: 'series'                            },                            data: [36.06933469, 86.49653913, 24.78364054, 1.337313433, 3.374393194]                        },                        {                            name: '扬尘源',                            type: 'bar',                            stack: 'Ad',                            emphasis: {                                focus: 'series'                            },                            data: [0, 0, 0, 67.07788331, 52.43591974]                        },                        {                            name: '生活源',                            type: 'bar',                            stack: 'Ad',                            emphasis: {                                focus: 'series'                            },                            data: [0, 2.937066015, 14.29808551, 0, 0]                        },                        {                            name: '农业源',                            type: 'bar',                            stack: 'Ad',                            emphasis: {                                focus: 'series'                            },                            data: [4.460871782, 0.308122325, 1.511638741, 1.413297151, 3.842443984]                        },                        {                            name: '餐饮源',                            type: 'bar',                            stack: 'Ad',                            emphasis: {                                focus: 'series'                            },                            data: [0, 0, 2.339806304, 3.29660787, 7.806644424]                        },                        {                            name: '其他源',                            type: 'bar',                            stack: 'Ad',                            emphasis: {                                focus: 'series'                            },                            data: [0, 0, 3.167425775, 0, 0]                        },                    ]                };                myChart.setOption(option, true);            },            initCityBar(){                // 基于准备好的dom，初始化echarts实例                var myChart = echarts.init(document.getElementById('air_bar'));                let option = {                    title:{                        text: "2015-2020年成都市温室气体排放变化",                        left: 'center',                        top: 0,                        textStyle:{                            fontSize:18,                            color:'#000000'                        }                    },                    color: ['#3AA1FF'],                    tooltip: {                        trigger: 'axis',                        axisPointer: {                            type: 'shadow'                        }                    },                    xAxis: [                        {                            type: 'category',                            axisTick: {show: false},                            data: ['2015年','2016年','2017年','2018年','2019年','2020年']                        }                    ],                    yAxis: [                        {                            name:'温室气体排放量（万吨CO2e）',                            nameRotate: 90,                            nameLocation: "middle",                            nameTextStyle: {                                padding: [40, 0]                            },                            type: 'value'                        }                    ],                    series: [                        {                            name: 'emissions',                            type: 'bar',                            barGap: 0,                            barWidth : 40,                            data: [6500,7200,7500,6000,6100,6200]                        }                    ]                };                // 使用刚指定的配置项和数据显示图表。                myChart.setOption(option);            },            initCityPie(){                // 基于准备好的dom，初始化echarts实例                var myChart = echarts.init(document.getElementById('air_pie'));                // 指定图表的配置项和数据                var option = {                    title:{                        text: "成都市各领域温室气体排放占比",                        left: 'center',                        top: 0,                        textStyle:{                            fontSize:18,                            color:'#000000'                        }                    },                    tooltip : {                        show: true,                        trigger: 'item',                        formatter: "{b}:{c}%"                    },                    color: ['#3AA1FF','#36CBCB','#4ECB73','#FBD437','#F2637B'],                    legend: {                        show: true,                        bottom: 10,                        icon: 'circle'                    },                    series : [                        {                            name: '温室气体',                            type: 'pie',                            radius: '65%',                            data:[                                {value:75.34, name:'能源活动'},                                {value:9.54, name:'工业生产过程'},                                {value:3.47, name:'农业活动'},                                {value:2.49, name:'土地利用变化与林业'},                                {value:9.16, name:'废弃物处理'}                            ],                            label: {                                normal: {                                    formatter: '{b}:{c}%'  //显⽰⽂字样式                                }                            },                            itemStyle: {        //饼图按块划分时是否需要⽤线隔开，不需要注释即可                                normal: {                                    borderWidth: 1,                                    borderColor: '#FFFFFF'                                }                            }                        }                    ]                };                // 使用刚指定的配置项和数据显示图表。                myChart.setOption(option);            },        },        mounted() {            const _this = this;            _this.$nextTick(() => {                _this.initCityBar1();                _this.initCityPolution();                _this.initCityBar();                _this.initCityPie();                $("#dyh").viewer('destroy');                $("#dyh").viewer();            });        },    });</script></html>
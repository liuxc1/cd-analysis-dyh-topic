<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Echarts数据</title>
    <script src="${ctx}/assets/components/jquery/dist/jquery.min.js?v=20221129015223"></script>
    <script type="text/javascript" src="${ctx}/assets/components/echarts/echarts.min.js?v=20221129015223"></script>
</head>
<body>
<div id="mychart" style="height: 350px"></div>
</body>
<script>
    var myChart = null;
    var myData = $.parseJSON('${list}');

    function initEcharts() {
        var data = myData;
        var title = "${form.SNAME}".replace('郫县', '郫都区').replace('都江堰', '都江堰市');
        var series = new Array(), names = new Array(), xdatas = new Array(), nowNames = new Array(),
            nearNames = new Array();
        var titlename = "${form.PULL}";
        if (titlename == 'PM25') {
            titlename = 'PM₂.₅';
        } else if (titlename == 'PM10') {
            titlename = 'PM₁₀';
        } else if (titlename == 'O3') {
            titlename = 'O₃';
        } else if (titlename == 'NO2') {
            titlename = 'NO₂';
        } else if (titlename == 'SO2') {
            titlename = 'SO₂';
        }
        title = title + titlename + "对比";
        for (var i = 0; i < data.length; i++) {
            if (xdatas.indexOf(data[i].MONDATE) == -1) {
                xdatas.push(data[i].MONDATE);
            }
        }
        var pull = parent.$("#PULL").val();
        var titlestr = pull;
        if (pull == 'PM25') {
            titlestr = 'PM<sub>2.5</sub>'
        } else if (pull == 'PM10') {
            titlestr = 'PM<sub>10</sub>'
        } else if (pull == 'NO2') {
            titlestr = 'NO<sub>2</sub>'
        } else if (pull == 'SO2') {
            titlestr = 'SO<sub>2</sub>'
        } else if (pull == 'O3') {
            titlestr = 'O<sub>3</sub>'
        }
        //当前站点
        nowNames = "${form.NOWSNAME}".split(',');
        for (var i = 0; i < nowNames.length; i++) {
            var datas = new Array();
            for (var j = 0; j < data.length; j++) {
                if (data[j].SNAME == nowNames[i]) {
                    datas.push(data[j][pull])
                }
            }
            series[i] = {
                name: nowNames[i],
                type: 'line',
                smooth: 'true',
                data: datas
            }
        }
        //附近站点
        nearNames = "${form.NEARSNAME}".split(',');
        var seriesSize = series.length;
        for (var i = 0; i < nearNames.length; i++) {
            var datas = new Array();
            for (var j = 0; j < data.length; j++) {
                if (data[j].SNAME == nearNames[i]) {
                    datas.push(data[j][pull])
                }
            }
            series[seriesSize + i] = {
                name: nearNames[i],
                type: 'bar',
                smooth: 'true',
                data: datas
            }
        }


        var option = {
            title: {
                text: title,
                left: 'left',
                textStyle: {
                    fontSize: 20,
                    fontFamily: 'Microsoft YaHei',
                    fontWeight: 'bold'
                }
            },
            tooltip: {
                trigger: 'axis'
            },
            grid: {
                left: '6%',
                right: '5%',
                bottom: '15%'
            },
            legend: {
                bottom: 'bottom',
                data: nowNames.concat(nearNames)
            },
            xAxis: {
                type: 'category',
                data: xdatas
            },
            yAxis: {
                type: 'value',
                name: 'μg/m³（CO：mg/m³）'
            },
            series: series
        }
        myChart.setOption(option);
    }

    $(function () {
        myChart = echarts.init(document.getElementById('mychart'));
        window.onresize = myChart.resize;
        initEcharts();
    })
</script>
</html>
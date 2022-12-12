<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>中长期预报</title>
    <%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
</head>
<body>
<div class="main-container" id="dyh" v-cloak>
    <div class="main-content">
        <div class="main-content-inner fixed-page-header fixed-40">
            <div id="breadcrumbs" class="breadcrumbs">
                <ul class="breadcrumb">
                    <li class="active">
                        <h5 class="page-title">
                            <i class="header-icon fa fa-bar-chart"></i>
                            中长期预报
                        </h5>
                    </li>
                </ul>
            </div>
        </div>
        <div class="main-content-inner">
            <div class="page-content">
                <div class="col-sm-12 no-padding" >
                    <img src="zcq.jpg" width="100%">
                </div>
            </div>
        </div>
    </div>
</div>
</body>
<script type="text/javascript" src="../../other/comon.js"></script>
<script>
    new Vue({
        el: "#dyh",
        data: {
        },
        methods: {

        },
        mounted() {
        },
    });
</script>
</html>

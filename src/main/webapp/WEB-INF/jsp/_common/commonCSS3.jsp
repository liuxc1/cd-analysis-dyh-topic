<%@ page pageEncoding="UTF-8" %>
<!--浏览器兼容性设置-->
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
<meta name="renderer" content="webkit">
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0"/>

<link rel="stylesheet" href="${ctx}/assets/ths-custom2.css">

<script src="${ctx}/assets/components/jquery/dist/jquery.js"></script>

<script type="text/javascript">
    var ctx = "${pageContext.request.contextPath}";
    //全局的AJAX访问，处理AJAX清求时SESSION超时
    $.ajaxSetup({
        contentType: "application/x-www-form-urlencoded;charset=utf-8",
        complete: function (XMLHttpRequest, textStatus) {
            if (XMLHttpRequest.getResponseHeader) {
                var ths_un_login_flag = XMLHttpRequest.getResponseHeader('THS_UN_LOGIN_FLAG');
                if (ths_un_login_flag != null && ths_un_login_flag == "true") {
                    var loginPage = XMLHttpRequest.getResponseHeader('LOGIN_PAGE');
                    window.top.location.replace(loginPage);
                }
            }
        }
    });
    //皮肤初始化
    $(function () {
        var thsSkin = "<%=ths.jdp.project.util.SkinUtils.getSkin()%>";
        if (thsSkin != "") {
            if (!$(window.document.body).hasClass("login-layout")) {
                $(window.document.body).attr("class", thsSkin);
            }
        }
        //如果没有用户对象需要询问父亲页面的样式 window.parent.postMessage('{"messageType":"ask","currentSkin": "?"}','*');
        //window.top.postMessage('{"messageType":"ask","currentSkin": "?"}','*');
        //监听父亲页面的换皮肤时间
        window.addEventListener('message', function (e) {
            var message = e.data;
            if (message) {
                messageJson = JSON.parse(message);
                var messageType = messageJson.messageType;
                var currentSkin = messageJson.currentSkin;
                var menuPath = messageJson.menuPath;
                if (messageType == "command" && currentSkin) {
                    $(window.document.body).attr("class", currentSkin);
                    $("iframe").each(function (i) {
                        window.frames[i].postMessage(message, '*');
                    });
                } else if (messageType == "ask" && currentSkin) {
                    $("iframe").each(function (i) {
                        window.frames[i].postMessage('{"messageType":"answer","currentSkin": "' + $(window.document.body).attr("class") + '"}', '*');
                    });
                } else if (messageType == "answerBreadcrumbs") {
                    // 当前页面得资源id
                    var iconHtml = " <i class='fa fa-caret-right'></i> ";
                    var resName = '${THS_JDP_RES_DESC}';
                    if (menuPath) {
                        resName = menuPath.split(",").join(iconHtml);
                    }
                    $(".THS_JDP_RES_DESC").empty().append(resName);
                    $("iframe").each(function (i) {
                        window.frames[i].postMessage(message, '*');
                    });
                }
            }
        }, false);
    });

</script>
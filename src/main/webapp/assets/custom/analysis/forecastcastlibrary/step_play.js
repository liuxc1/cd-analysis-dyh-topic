var search = {
    resize: function () {
        var height = $(window).height();
        $('#mainIframe').height(height - 200);
    },
    setTree: function (setpType) {
        var item, cur, pplHtml = '', reportHtml = '';
        var active = 'ppl';
        if (stepType == null || stepType == '' || stepType == 'normal') {
            pplHtml += '<li data-type="' + stepType + '" data-value="' + "wrgc" + '" title="' + "污染过程基本情况" + '" data-name="' + "污染过程基本情况" + '" data-oper="imgInfo"  class="isButton imgInfo active">' + "污染过程基本情况" + '</li>';
            pplHtml += '<li data-type="' + stepType + '" data-value="' + "klw" + '" title="' + "颗粒物组分分析" + '" data-name="' + "颗粒物组分分析" + '" data-oper="imgInfo"  class="isButton imgInfo ">' + "颗粒物组分分析" + '</li>';
            pplHtml += '<li data-type="' + stepType + '" data-value="' + "qxys" + '" title="' + "气象要素分析" + '" data-name="' + "气象要素分析" + '" data-oper="imgInfo"  class="isButton imgInfo ">' + "气象要素分析" + '</li>';
            pplHtml += '<li data-type="' + stepType + '" data-value="' + "eczh" + '" title="' + "二次转化分析" + '" data-name="' + "二次转化分析" + '" data-oper="imgInfo"  class="isButton imgInfo ">' + "二次转化分析" + '</li>';
            pplHtml += '<li data-type="' + stepType + '" data-value="' + "szw" + '" title="' + "示踪物分析" + '" data-name="' + "示踪物分析" + '" data-oper="imgInfo"  class="isButton imgInfo ">' + "示踪物分析" + '</li>';
            pplHtml += '<li data-type="' + stepType + '" data-value="' + "zywrw" + '" title="' + "主要污染物浓度变化" + '" data-name="' + "主要污染物浓度变化" + '" data-oper="imgInfo"  class="isButton imgInfo ">' + "主要污染物浓度变化" + '</li>';
            pplHtml += '<li data-type="' + stepType + '" data-value="' + "tcqxyx" + '" title="' + "剔除气象影响" + '" data-name="' + "剔除气象影响" + '" data-oper="imgInfo"  class="isButton imgInfo ">' + "剔除气象影响" + '</li>';
        } else if (setpType == 'dust') {
            pplHtml += '<li data-type="' + stepType + '" data-value="' + "wrgc" + '" title="' + "污染过程基本情况" + '" data-name="' + "污染过程基本情况" + '" data-oper="imgInfo"  class="isButton imgInfo active">' + "污染过程基本情况" + '</li>';
            pplHtml += '<li data-type="' + stepType + '" data-value="' + "klw" + '" title="' + "颗粒物组分分析" + '" data-name="' + "颗粒物组分分析" + '" data-oper="imgInfo"  class="isButton imgInfo ">' + "颗粒物组分分析" + '</li>';
            pplHtml += '<li data-type="' + stepType + '" data-value="' + "qxys" + '" title="' + "气象要素分析" + '" data-name="' + "气象要素分析" + '" data-oper="imgInfo"  class="isButton imgInfo ">' + "气象要素分析" + '</li>';
            pplHtml += '<li data-type="' + stepType + '" data-value="' + "eczh" + '" title="' + "二次转化分析" + '" data-name="' + "二次转化分析" + '" data-oper="imgInfo"  class="isButton imgInfo ">' + "二次转化分析" + '</li>';
            pplHtml += '<li data-type="' + stepType + '" data-value="' + "szw" + '" title="' + "示踪物分析" + '" data-name="' + "示踪物分析" + '" data-oper="imgInfo"  class="isButton imgInfo ">' + "示踪物分析" + '</li>';
            pplHtml += '<li data-type="' + stepType + '" data-value="' + "jgld" + '" title="' + "激光雷达" + '" data-name="' + "激光雷达" + '" data-oper="imgInfo"  class="isButton imgInfo ">' + "激光雷达" + '</li>';
            pplHtml += '<li data-type="' + stepType + '" data-value="' + "zywrw" + '" title="' + "主要污染物浓度变化" + '" data-name="' + "主要污染物浓度变化" + '" data-oper="imgInfo"  class="isButton imgInfo ">' + "主要污染物浓度变化" + '</li>';
            pplHtml += '<li data-type="' + stepType + '" data-value="' + "tcqxyx" + '" title="' + "剔除气象影响" + '" data-name="' + "剔除气象影响" + '" data-oper="imgInfo"  class="isButton imgInfo ">' + "剔除气象影响" + '</li>';
        } else if (setpType == 'actinology') {
            pplHtml += '<li data-type="' + stepType + '" data-value="' + "wrgc" + '" title="' + "污染过程基本情况" + '" data-name="' + "污染过程基本情况" + '" data-oper="imgInfo"  class="isButton imgInfo active">' + "污染过程基本情况" + '</li>';
            pplHtml += '<li data-type="' + stepType + '" data-value="' + "vocs" + '" title="' + "VOCs组分变化及占比" + '" data-name="' + "VOCs组分变化及占比" + '" data-oper="imgInfo"  class="isButton imgInfo ">' + "VOCs组分变化及占比" + '</li>';
            pplHtml += '<li data-type="' + stepType + '" data-value="' + "cyscqs" + '" title="' + "臭氧生成潜势关键物种" + '" data-name="' + "臭氧生成潜势关键物种" + '" data-oper="imgInfo"  class="isButton imgInfo ">' + "臭氧生成潜势关键物种" + '</li>';
            pplHtml += '<li data-type="' + stepType + '" data-value="' + "gjsl" + '" title="' + "光解速率" + '" data-name="' + "光解速率" + '" data-oper="imgInfo"  class="isButton imgInfo ">' + "光解速率" + '</li>';
            pplHtml += '<li data-type="' + stepType + '" data-value="' + "qxyx" + '" title="' + "气象条件" + '" data-name="' + "气象条件" + '" data-oper="imgInfo"  class="isButton imgInfo ">' + "气象条件" + '</li>';
            pplHtml += '<li data-type="' + stepType + '" data-value="' + "zywrw" + '" title="' + "主要污染物浓度变化" + '" data-name="' + "主要污染物浓度变化" + '" data-oper="imgInfo"  class="isButton imgInfo ">' + "主要污染物浓度变化" + '</li>';
            pplHtml += '<li data-type="' + stepType + '" data-value="' + "tcqxyx" + '" title="' + "剔除气象影响" + '" data-name="' + "剔除气象影响" + '" data-oper="imgInfo"  class="isButton imgInfo ">' + "剔除气象影响" + '</li>';
         }

        $("#ppl_list ul").html(pplHtml);
        $("#" + active + "_list").addClass("active");
        self.getStepInfo($(".imgInfo.active"));
    },
    getStepInfo: function ($elem) {
        $("#pollution_process_conclusion_id").val('');
        $("#pollution_process_id").val('');
        $("#pollution_process_type").val('');
        $("#tab_type").val('');
        $("#conclusion_content").val('');


        var dataType = $elem.attr("data-type");
        var dataValue = $elem.attr("data-value");
        var _href = ctx + "/ppl/" + dataType + "/view/step.vm?dataType=" + dataType + "&dataValue=" + dataValue + "&id=" + id+ "&startTime=" + startTime+ "&endTime=" + endTime;
        $("#mainIframe").attr("src", _href);

        self.getConclusion($elem);
    },
    getConclusion($elem) {
        var param = {
            processType: $elem.attr("data-type"),
            tabType: $elem.attr("data-value"),
            processId: id
        }
        $.ajax({
            type: 'post',
            data: param,
            dataType: 'json',
            url: ctx + '/ppl/conclusion/dosearch.vm',
            success: function (res) {
                if (res.meta.success) {
                    if (res.data) {
                        $("#pollution_process_conclusion_id").val(res.data.pollution_process_conclusion_id);
                        $("#pollution_process_id").val(res.data.pollution_process_id);
                        $("#pollution_process_type").val(res.data.pollution_process_type);
                        $("#tab_type").val(res.data.tab_type);
                        $("#conclusion_content").val(res.data.conclusion_content);
                    }
                } else {
                    $("#pollution_process_id").val(param.processId);
                    $("#pollution_process_type").val(param.processType);
                    $("#tab_type").val(param.tabType);
                }

            }
        })
    },
    saveConclusion: function () {
        var param = ($("#conclusionForm").serializeArray());
        $.ajax({
            url: ctx + '/ppl/conclusion/change.vm',
            data: param,
            type: 'post',
            success: function (res) {
                if (res.meta.success) {
                    dialog({
                        title: '提示',
                        content: '保存成功!',
                        wraperstyle: 'alert-warning',
                        ok: function () {
                        }
                    }).showModal();
                }
            }
        })
    },


    addEventListener: function () {
        $(document.body).on("click", ".isButton", function (e) {
            var oper = this.getAttribute("data-oper");
            var click = $(this);

            if (oper == "imgInfo") {
                $(".imgInfo.active").removeClass("active");
                click.addClass("active");
                self.getStepInfo(click);
                return;
            }

            if (oper === "menu") {
                if (click.hasClass("active")) {
                    return;
                }
                console.log(oper);
                click.addClass("active").siblings(".active").removeClass("active");
            }
        });

    },


    init: function () {
        this.resize();
        this.addEventListener();

    }

};

$(function () {
    $("#myTab3").on("click", ".isButton", function (e) {
        var oper = this.getAttribute("data-oper");
        var click = $(this);
        if (click.hasClass("active")) {
            return;
        }
        click.addClass("active").siblings(".active").removeClass("active");
    });
});

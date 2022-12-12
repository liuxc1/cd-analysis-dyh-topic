////注册
//Vue.filter('getdate', function (date) {
//	if(date){
//		return date.replace("-","").replace("-","");
//	}
//})
var sourceDoalog = null;
//var vue=null;
var countryTipsRegions = [];
//function init() {
var vue = new Vue({
    el: '#main-container',
    data: {
        // 该功能调用的所有url列表
        urls: {
            queryPartitionInfoById: ctx + '/analysis/air/partition/query.vm',
            savePartitionInfoUrl: ctx + '/analysis/air/partition/saveForecastInfo.vm',
            // 报告是否有提交记录
            queryStateNumber: ctx + '/analysis/report/generalReport/queryStateNumber.vm',
        },
        reportId: reportId,
        countrys: [{}],
        form: [],
        form3d: [],
        formTips: [],
//		form24h:[{}],
        userlist: [{}],
        // 城市预报对应的主信息
        resultData: {
            // 预报ID
            STATE: '',
            FORECAST_ID: '',
            FORECAST_TIME: '',
            AREA_OPINION: '',
            HINT: '',
            INSCRIBE: '',
            DELETE_FILE_IDS: []
        },
        fileList: [],
        // 归属类型
        ascriptionType: 'PARTITION_FORECAST',
    },
    created: function () {
        var _this = this;

    },
    /**
     * 页面加载完后调用
     */
    mounted: function () {
        var _this = this;
        this.$nextTick(function () {
            // 注册表单验证
            $('#mainForm').validationEngine({
                // 屏幕自动滚动到第一个验证不通过的位置。必须设置，因为Toolbar position为Fixed
                scrollOffset: 98,
                // 提示框位置为下左
                promptPosition: 'bottomLeft',
                // 自动隐藏提示框
                autoHidePrompt: true,
                // 不可见字段验证
                validateNonVisibleFields: true
            });
            _this.queryDataIsUpload();
        });
    },
    methods: {
        getstate: function (str1, str2) {
            if (str1 == null || str1 == '') {
                return -1;
            }
            return str1.indexOf(str2);
        },
        /**
         *    Table新增行
         */
        createRow: function () {
            var table = $("#districtTable");
            //克隆第一行
            var createNewRow = table.children("tbody").find("tr").eq(0).clone();
            table.children("tbody").append(createNewRow);
            createNewRow.children("select").val('');
            createNewRow.children("select").data('selectpicker', null);
            createNewRow.find("button").eq(0).remove();
            createNewRow.find(".dropdown-menu").eq(0).remove();
            $('.selectpicker').selectpicker("refresh");
            createNewRow.find(".important_tips").val('');
            table.children("tbody").find("tr").eq(0).find(".selectpicker").selectpicker('val', countryTipsRegions[0].split(','));
        },
        /**
         * 查询,初始化数据
         */
        queryForecastInfo: function (opt) {
            var _this = this;
            $.ajax({
                url: 'query.vm',
                type: 'post',
                async: false,
                data: {
                    PKID: $('#PKIDInput').val(),
                    FORECAST_TIME: _this.resultData.FORECAST_TIME
                },
                dataType: 'json',
                success: function (result) {
                    if (result.meta.success) {
                        var data = result.data;
                        _this.countrys = data.countrys;
                        _this.form = data.form;
                        _this.formTips = data.formTips;

                        if ($('#PKIDInput').val() != '') {
                            _this.resultData = {
                                STATE: data.form.FLOW_STATE,
                                FORECAST_ID: $('#PKIDInput').val(),
                                FORECAST_TIME: data.form.CREATE_TIME,
                                AREA_OPINION: data.form.AREA_OPINION,
                                HINT: data.form.HINT,
                                INSCRIBE: data.form.INSCRIBE,
                                DELETE_FILE_IDS: []
                            };
                        }
                        if (_this.resultData.INSCRIBE == '') {
                            _this.resultData.INSCRIBE = '成都市环境保护科学研究院、成都平原经济区环境气象中心';
                        }
                        _this.form3d = data.form3d;
//						_this.form24h=data.form24h;
                        _this.userlist = data.userlist;
                        //回显文件
                        if (data.fileList != null && data.fileList.length > 0) {
                            for (var i = 0; i < data.fileList.length; i++) {
                                var file = data.fileList[i];
                                _this.fileList.push({
                                    file: null,
                                    fileId: file.FILE_ID,
                                    name: file.FILE_FULL_NAME,
                                    type: file.FILE_TYPE,
                                    size: file.FILE_FORMAT_SIZE,
                                    uploadTime: file.CREATE_TIME
                                });
                            }
                        } else {
                            _this.fileList = [];
                        }
                    } else {
                        if (opt == 'mounted') {
                            alert(result.meta.message);
                        }
                    }
                    _this.$nextTick(function () {
                        _this.initEvents();
                    });
                }
            });
        },
        /**
         * 取消
         * @param {boolean} isParentRefresh 是否父页面刷新
         */
        cancel: function (isParentRefresh) {  //暂不管
            if (window.parent && window.parent.vue.closePageDialog) {
                if (isParentRefresh != true && isParentRefresh != false) {
                    isParentRefresh = false;
                }
                // 调用父页面的关闭方法
                window.parent.vue.closePageDialog(isParentRefresh);
            } else {
                window.history.go(-1);
            }
        },
        /**
         * 日期选择插件
         */
        wdatePicker: function () {
            var _this = this;
            WdatePicker({
                // 回显数据的对象ID
                el: 'txtDateStart',
                // 时间格式
                dateFmt: 'yyyy-MM-dd',
                // 是否显示清除按钮
                isShowClear: false,
                // 只读
                readOnly: true,
                // 最大时间限制，参考：http://www.my97.net/demo/index.htm
                //maxDate:'%y-%M-%d',
                onpicked: function (dp) {
                    // 确认按钮点击事件
                    _this.resultData.FORECAST_TIME = dp.cal.getNewDateStr();
                    //查询当天数据是否已提交
                    AjaxUtil.sendAjaxRequest(_this.urls.queryStateNumber, null, {
                        ascriptionType: _this.ascriptionType,
                        reportTime: _this.resultData.FORECAST_TIME
                    }, function (result) {
                        if (result.data.STATE_NUMBER > 0) {
                            DialogUtil.showTipDialog(_this.resultData.FORECAST_TIME + "的预报数据已提交，请重新选择填报日期！");
                            if (_this.resultData.FORECAST_TIME == DateTimeUtil.getNowDate()) {
                                _this.resultData.FORECAST_TIME = '';
                            } else {
                                _this.resultData.FORECAST_TIME = DateTimeUtil.getNowDate();
                            }

                        }
                        if (_this.resultData.FORECAST_TIME != '') {
                            _this.queryForecastInfo('mounted');

                            //初始化区县数据
                            $("#districtTable").children("tbody").find("tr").each(function (i, e) {
                                if (i == 0)
                                    $(e).find(".selectpicker").selectpicker('val', '');
                                else
                                    $(e).remove();
                            });
                        }
                    });
                    return _this.resultData.FORECAST_TIME;
                }
            });
        },
        /**
         * 保存
         */
        saveData: function (code) {
            var _this = this;
            // 验证表单
            var flag = $('#mainForm').validationEngine('validate');
            if (!flag) {
//				// 验证不通过，不提交
                return;
            }
            _this.resultData.STATE = code;
//			$("#FLOW_STATE").val(code);
            var areas = new Array(), countrys = new Array(), countrys3d = new Array(), countrysTips = new Array();
            var tableFlag=true;

            //遍历区县重要提示表格
            $("#districtTable").children("tbody").find("tr").each(function (i, e) {
                var countryTips = {};
                countryTips.REGION_CODE = $.trim($(e).children().eq(0).find(".selectpicker").val());
                countryTips.REGION_NAME = $.trim($(e).find("button").find(".filter-option").text());
                countryTips.IMPORTANT_HINTS = $(e).find(".important_tips").val();
                countryTips.SORT = i;
                if (countryTips.IMPORTANT_HINTS != null && countryTips.IMPORTANT_HINTS != '') {
                    countrysTips.push(countryTips);
                }
            });
            for (let i = 0; i < countryTipsRegions.length; i++) {
                countrysTips[i].REGION_CODE = countryTipsRegions[i];
            }
            $("#tab_3 table tr:gt(1)").each(function (i, e) {
                var country3d = {};
                country3d.REGIONNAME = $.trim($(e).children().eq(0).text());
                country3d.AQI_START1 = $(e).children().eq(1).children(".3dbefore").val();
                if (country3d.AQI_START1 == null || country3d.AQI_START1 == '') {
                    tableFlag=false;
                    DialogUtil.showTipDialog("请填写预报AQI范围！");
                    return false;
                }
                country3d.AQI_END1 = $(e).children().eq(1).children(".3dafter").val();
                if (country3d.AQI_END1 == null || country3d.AQI_END1 == '') {
                    tableFlag=false;
                    DialogUtil.showTipDialog("请填写预报AQI范围！");
                    return false;
                }
                var pullname1 = $(e).children().eq(2).children(".form-control").find(".selectpicker").val();
                if (pullname1) {
                    country3d.PULLNAME1 = pullname1.join(",");
                } else {
                    country3d.PULLNAME1 = ""
                }
                let id1='#'+country3d.REGIONNAME+'_1';
                let btn1=$(id1).siblings();
                btn1.eq(0).css("border-color","#4F99C6");
                if (country3d.AQI_END1 > 50 && country3d.PULLNAME1 == '') {
                    tableFlag=false;
                    btn1.eq(0).css("border-color","red")
                    DialogUtil.showTipDialog("当污染级别不是优时，必须选择首要污染物！");
                    return false;
                }
                if (country3d.AQI_END1 <= 50 && country3d.PULLNAME1 != '') {
                    tableFlag=false;
                    btn1.eq(0).css("border-color","red");
                    DialogUtil.showTipDialog("当污染级别是优时不存在首要污染物！");
                    return false;
                }
                country3d.AQI_START2 = $(e).children().eq(3).children(".3dbefore").val();
                if (country3d.AQI_START2 == null || country3d.AQI_START2 == '') {
                    tableFlag=false;
                    DialogUtil.showTipDialog("请填写预报AQI范围！");
                    return false;
                }
                country3d.AQI_END2 = $(e).children().eq(3).children(".3dafter").val();
                if (country3d.AQI_END2 == null || country3d.AQI_END2 == '') {
                    tableFlag=false;
                    DialogUtil.showTipDialog("请填写预报AQI范围！");
                    return false;
                }
                var pullname2 = $(e).children().eq(4).children(".form-control").find(".selectpicker").val();
                if (pullname2) {
                    country3d.PULLNAME2 = pullname2.join(",");
                } else {
                    country3d.PULLNAME2 = ""
                }
                let id2='#'+country3d.REGIONNAME+'_2';
                let btn2=$(id2).siblings();
                btn2.eq(0).css("border-color","#4F99C6");
                if (country3d.AQI_END2 > 50 && country3d.PULLNAME2 == '') {
                    tableFlag=false;
                    btn2.eq(0).css("border-color","red");
                    DialogUtil.showTipDialog("当污染级别不是优时，必须选择首要污染物！");
                    return false;
                }
                if (country3d.AQI_END2 <= 50 && country3d.PULLNAME2 != '') {
                    tableFlag=false;
                    btn2.eq(0).css("border-color","red");
                    DialogUtil.showTipDialog("当污染级别是优时不存在首要污染物！");
                    return false;
                }
                country3d.AQI_START3 = $(e).children().eq(5).children(".3dbefore").val();
                if (country3d.AQI_START3 == null || country3d.AQI_START3 == '') {
                    tableFlag=false;
                    DialogUtil.showTipDialog("请填写预报AQI范围！");
                    return false;
                }
                country3d.AQI_END3 = $(e).children().eq(5).children(".3dafter").val();
                if (country3d.AQI_END3 == null || country3d.AQI_END3 == '') {
                    tableFlag=false;
                    DialogUtil.showTipDialog("请填写预报AQI范围！");
                    return false;
                }
                var pullname3 = $(e).children().eq(6).children(".form-control").find(".selectpicker").val();
                if (pullname3) {
                    country3d.PULLNAME3 = pullname3.join(",");
                } else {
                    country3d.PULLNAME3 = ""
                }
                let id3='#'+country3d.REGIONNAME+'_3';
                let btn3=$(id3).siblings();
                btn3.eq(0).css("border-color","#4F99C6");
                if (country3d.AQI_END3 > 50 && country3d.PULLNAME3 == '') {
                    tableFlag=false;
                    btn3.eq(0).css("border-color","red");
                    DialogUtil.showTipDialog("当污染级别不是优时，必须选择首要污染物！");
                    return false;
                }
                if (country3d.AQI_END3 <= 50 && country3d.PULLNAME3 != '') {
                    tableFlag=false;
                    btn3.eq(0).css("border-color","red");
                    DialogUtil.showTipDialog("当污染级别是优时不存在首要污染物！");
                    return false;
                }
                if (country3d.REGIONCODE != "请选择") {
                    countrys3d.push(country3d)
                }

            })
            if (!tableFlag){
                return;
            }
            // 将文件添加到表单数据中
            var formData = _this.$refs.fileUploadTable.getFileFormData();
            if (formData == null) {
                return;
            }
            formData = _this.appendBaseDataToForm(formData);
            formData.append("AREAS", JSON.stringify(areas));
            formData.append("COUNTRYS3D", JSON.stringify(countrys3d));
            //添加区县重要提示
            formData.append("COUNTRYS_TIPS", JSON.stringify(countrysTips));
            // 验证通过，提交到后台
            var tipMessage = _this.getSaveTipMessage(code);
            DialogUtil.showConfirmDialog(tipMessage.confirmMessage, function () {
                AjaxUtil.sendFileUploadAjaxRequest(_this.urls.savePartitionInfoUrl, formData, function () {
                    DialogUtil.showTipDialog(tipMessage.successMessage, function () {
                        _this.cancel(true);
                    }, function () {
                        _this.cancel(true);
                    });
                });
            });
        },
        /**校验区县是否重复*/
        checkDuplicate: function (obj) {
            var repeatFlag = false;
            var arrayEntity = [];
            //遍历区县重要提示表格
            $("#districtTable").children("tbody").find("tr").each(function (i, e) {
                var rowRegionCode = $.trim($(e).children().eq(0).find(".selectpicker").val());
                if (rowRegionCode.toString() != "")
                    arrayEntity.push(rowRegionCode.toString());
            });
            countryTipsRegions = arrayEntity;
            //遍历数组是否重复
            for (var i = 0; i < arrayEntity.length; i++) {
                var repeatCount = 0;
                for (var j = 0; j < arrayEntity.length; j++) {
                    if (arrayEntity[i] == arrayEntity[j])
                        repeatCount++;
                }
                if (repeatCount > 1) {
                    repeatFlag = true;
                    break;
                }
            }

            if (repeatFlag) {
                if ($("#districtWarning").hasClass("hidden"))
                    $("#districtWarning").removeClass("hidden");
            } else {
                if (!$("#districtWarning").hasClass("hidden"))
                    $("#districtWarning").addClass("hidden")
            }

        },
        /**
         * 查询数据是否提交
         */
        queryDataIsUpload: function () {
            let _this = this;
            let nowDate = DateTimeUtil.getNowDate();
            AjaxUtil.sendAjaxRequest(_this.urls.queryStateNumber, null, {
                ascriptionType: _this.ascriptionType,
                reportTime: nowDate
            }, function (result) {
                if (result.data.STATE_NUMBER == 0) {
                    _this.resultData.FORECAST_TIME = nowDate;
                    _this.queryForecastInfo('mounted');
                } else {
                    _this.resultData.FORECAST_TIME = '';
                }
            })
        },
        /**
         * 获取保存提示信息
         */
        getSaveTipMessage: function (state) {
            var tipMessage = null;
            if (state === 'UPLOAD') {
                tipMessage = {
                    confirmMessage: '提交选中的数据，提交成功后将不能编辑和删除，请确认！',
                    successMessage: '提交成功！'
                }
            } else {
                tipMessage = {
                    confirmMessage: '暂存数据，请确认！',
                    successMessage: '暂存成功！'
                }
            }
            return tipMessage;
        },
        /**
         * 将基础数据添加到表单数据中
         * @param {FormData} formData 表单数据对象
         * @returns {FormData} formData 表单数据对象
         */
        appendBaseDataToForm: function (formData) {
            for (var key in this.resultData) {
                formData.append(key, this.resultData[key]);
            }
            return formData;
        },
        /**
         * 获取污染源等级
         */
        getlevel: function (value) {
            var result = "";
            if (0 <= value && value <= 50) {
                result = "优";
            } else if (50 < value && value <= 100) {
                result = "良";
            } else if (100 < value && value <= 150) {
                result = "轻度污染";
            } else if (150 < value && value <= 200) {
                result = "中度污染";
            } else if (200 < value && value <= 300) {
                result = "重度污染";
            } else if (300 < value) {
                result = "严重污染";
            } else {
                result = "无";
            }
            return result
        },
        inputAqi: function (index, str, number) {
            var _this = this;
            if (number == 1) {
                if (str == 'add') {
                    if (isNaN(parseInt(_this.form3d[index].AQI_START1)) || parseInt(_this.form3d[index].AQI_START1) == 0) {
                        _this.form3d[index].AQI_START1 = 1;
                    } else {
                        _this.form3d[index].AQI_START1 = parseInt(_this.form3d[index].AQI_START1);
                    }
                    _this.form3d[index].AQI_END1 = _this.form3d[index].AQI_START1 + 30;
                } else {
                    if (isNaN(parseInt(_this.form3d[index].AQI_END1))) {
                        _this.form3d[index].AQI_END1 = 31;
                    } else {
                        _this.form3d[index].AQI_END1 = parseInt(_this.form3d[index].AQI_END1);
                    }
                    _this.form3d[index].AQI_START1 = _this.form3d[index].AQI_END1 - 30;
                }
            } else if (number == 2) {
                if (str == 'add') {
                    if (isNaN(parseInt(_this.form3d[index].AQI_START2)) || parseInt(_this.form3d[index].AQI_START2) == 0) {
                        _this.form3d[index].AQI_START2 = 1;
                    } else {
                        _this.form3d[index].AQI_START2 = parseInt(_this.form3d[index].AQI_START2);
                    }
                    _this.form3d[index].AQI_END2 = _this.form3d[index].AQI_START2 + 30;
                } else {
                    if (isNaN(parseInt(_this.form3d[index].AQI_END2))) {
                        _this.form3d[index].AQI_END2 = 31;
                    } else {
                        _this.form3d[index].AQI_END2 = parseInt(_this.form3d[index].AQI_END2);
                    }
                    _this.form3d[index].AQI_START2 = _this.form3d[index].AQI_END2 - 30;
                }
            } else {
                if (str == 'add') {
                    if (isNaN(parseInt(_this.form3d[index].AQI_START3)) || parseInt(_this.form3d[index].AQI_START3) == 0) {
                        _this.form3d[index].AQI_START3 = 1;
                    } else {
                        _this.form3d[index].AQI_START3 = parseInt(_this.form3d[index].AQI_START3);
                    }
                    _this.form3d[index].AQI_END3 = _this.form3d[index].AQI_START3 + 30;
                } else {
                    if (isNaN(parseInt(_this.form3d[index].AQI_END3))) {
                        _this.form3d[index].AQI_END3 = 31;
                    } else {
                        _this.form3d[index].AQI_END3 = parseInt(_this.form3d[index].AQI_END3);
                    }
                    _this.form3d[index].AQI_START3 = _this.form3d[index].AQI_END3 - 30;
                }
            }
        },
        cancelDialog: function () {
            sourceDoalog.close().remove();
        },
        //判断是否是选中的城市
        getIsSelect: function (regioncode, regioncodes) {
            if (regioncodes) {
                var array = regioncodes.split(',');
                if (array.indexOf(regioncode) >= 0) {
                    return true;
                }
                return false;
            }
            return false;
        },
        showCommonSubTaskDialog: function (callback) {
            sourceDoalog = dialog({
                id: "sourceSelection",
                title: '批量选择首要污染物',
                width: $(window).width() * 0.4,
                height: $(window).height() > 100 ? 100 : $(window).height(),
                content: document.getElementById('sourceSelection'),
            });
            sourceDoalog.showModal();
        },

        /**
         * 用jquery,初始化一些点击事件
         */
        initEvents: function () {
            var _this = this;
            $(".open_modal").on("click", function () {
                var pulltype = $(this).attr("pulltype");
                debugger;
                _this.showCommonSubTaskDialog(function (subTaskList) {

                });
                //	$('#myModal').modal('show');
                $('#sourceSelection').attr("pulltype", pulltype);
            })

            $(".pull_modal").on("click", function () {
                var pulltype = $('#sourceSelection').attr("pulltype");
                var select = ".selectpull" + pulltype;
                var pulls = new Array();
                $("input[name=pull]:checked").each(function (i, e) {
                    pulls.push($(this).val())
                });
                $(select).selectpicker('val', pulls);
                //$('#myModal').modal('hide');
                sourceDoalog.close().remove();

            });

            $("input[name=pull]").on("change", function () {
                var length = $("input[name=pull]:checked").length
                if (length > 2) {
                    $(".modal_label").text("*最多选择2项!")
                    this.checked = false;
                } else {
                    $(".modal_label").text("")
                }
            })

            //初始化数据
//			$("#districtTable").find(".selectpicker").each(function(i,e){
//				if(vue.formTips[i]!=null && vue.formTips[i].REGION_CODE!=undefined&&vue.formTips[i].REGION_CODE!=null&&vue.formTips[i].REGION_CODE!=''){
//					var datas = vue.formTips[i].REGION_CODE.split(",");
//					$(this).selectpicker('val',datas);
//				} 
//			});

            var count = 1;
            $("#tab_3").find(".selectpicker").each(function (i, e) {
                if (count >= 4) {
                    count = 1;
                }
                var j = Math.floor(i / 3);
                if (vue.form3d[j].PULLNAME1 != undefined && vue.form3d[j].PULLNAME1 != null && vue.form3d[j].PULLNAME1 != '' && count == 1) {
                    var datas = vue.form3d[j].PULLNAME1.split(",");
                    $(this).selectpicker('val', datas);
                } else if (count == 1) {
                    var datas = new Array();
                    $(this).selectpicker('val', datas);
                } else {

                }
                if (vue.form3d[j].PULLNAME2 != undefined && vue.form3d[j].PULLNAME2 != null && vue.form3d[j].PULLNAME2 != '' && count == 2) {
                    var datas = vue.form3d[j].PULLNAME2.split(",");
                    $(this).selectpicker('val', datas);
                } else if (count == 2) {
                    var datas = new Array();
                    $(this).selectpicker('val', datas);
                } else {

                }
                if (vue.form3d[j].PULLNAME3 != undefined && vue.form3d[j].PULLNAME3 != null && vue.form3d[j].PULLNAME3 != '' && count == 3) {
                    var datas = vue.form3d[j].PULLNAME3.split(",");
                    $(this).selectpicker('val', datas);
                } else if (count == 3) {
                    var datas = new Array();
                    $(this).selectpicker('val', datas);
                } else {

                }
                count++;
            })

//			$(".minusbutton").on("click",function(){
//				var tr = $(this).parent().parent();
//				$(tr).remove();
//			})

//			$(".aqi_level").each(function(i,e){
//				$(this).val($(this).attr("value"))
//			})
        },
        exportData: function () {
            ths.submitFormAjax({
                url: ctx + '/eform/exceltemplate/checkdownload.vm',// any URL you want
                                                                   // to submit
                data: $("#formhidden").serialize(),
                success: function (response) {
                    if (response.returnMessage == 'OK') {
                        $("#formhidden").submit();
                    } else {
                        dialog({
                            title: '信息',
                            content: response.returnMessage,
                            ok: function () {
                            }
                        }).showModal();
                    }
                }
            });
        },
        importData: function () {
            var _this = this;
            var s = dialog({
                id: "dialog-import",
                title: '导入Excel数据',
                url: ctx + '/eform/exceltemplate/goupload.vm?desigerid=1&callbackClass=ExcelHandleService&LOGINNAME=' + loginName,
                width: 400,
                height: 200,
                cancel: function () {
                    s.close().remove();
                },
                cancelDisplay: false
            }).showModal();
        },
        doSearch: function () {
            $.ajax({
                url: 'queryExcel.vm',
                type: 'post',
                async: false,
                dataType: 'json',
                success: function (result) {
                    if (result.meta.success) {
                        vue.form3d = result.data;
                        vue.initEvents();
                    } else {
                        alert(result.meta.message);
                    }
                }
            });
        }
    }
});
//}
//关闭dialog
function closeDialog(id, mess) {
    if (mess == 'success') {
        vue.doSearch();
    }
    dialog.get(id).close().remove();
}
$(function () {
//	init();
});
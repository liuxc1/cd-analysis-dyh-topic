/**
 * 通用数据选择插件 v2.0
 *
 * 说明： 本插件适用于已有简单数据的选择。
 *
 * 调用插件之前需要引用CSS文件：
 *   <link href="${ctx}/assets/components/zTree/css/zTreeStyle/zTreeStyle.css" rel="stylesheet">
 *   <link href="${ctx}/assets/components/zTree/css/metroStyle/metroStyle.css" rel="stylesheet">
 * 调用插件之前需要引用JS文件：
 *   <script src="${ctx}/assets/components/zTree/js/jquery.ztree.all.min.js" type="text/javascript"></script>
 *
 * @param id
 *            弹框的ID，一般不用修改。默认："dialog-point-choose"。
 * @param icon
 *            弹框的图标。默认："fa-globe"。可参考Font Awesome插件。
 * @param title
 *            弹框的标题。默认："内容选择"。
 * @param width
 *            弹框的宽度。默认：70%，最大600px。
 * @param height
 *            弹框的高度。默认：窗口70%高度。
 * @param closeOnEscape
 *            点击键盘Esc退出。默认：true。
 * @param quickClose
 *            点击空白关闭。默认：false。
 * @param ok
 *            是否显示确认按钮或者确认的回调函数。
 * @param okValue
 *            确认按钮的文本。默认："确认"。
 * @param cancel
 *            是否显示取消按钮或取消按钮的回调函数，可选值：boolean、function。默认：true。
 * @param cancelValue
 *            取消按钮的文本。默认："取消"。
 * @param modal
 *            是否使用模态框。默认：false。
 * @param single
 *            单选。默认：false。
 * @param min
 *            最小选中节点个数，注意不能同"single=true"连用。默认：0。
 * @param max
 *            最小选中节点个数，注意不能同"single=true"连用。默认：99999。
 * @param dataTypes
 *            点位类型，字符串数组。默认：[]。
 * @param dataTypeNames
 *            点位类型，字符串数组。默认：[]。
 * @param defaultDataType
 *            回显点位类型。默认：null。
 * @param dataCodes
 *            回显code值域，字符串，以逗号分隔，默认："";
 * @param dataNames
 *            回显code值域对应名称，字符串，以逗号分隔，默认：""。
 * @param callback
 *            点击确认后的回调函数。默认：function(dataType,nodeArray){}。
 */

var dataChooseCache = {
    currentUrl: null,
    dataChooseDialog: null,
    isInitedVueCompnent: false,
};
dataChooseCache.currentUrl = $("script").last().attr("src");
dataChooseCache.currentUrl = dataChooseCache.currentUrl.substring(0, dataChooseCache.currentUrl.lastIndexOf("/"));

$(function () {
    var head = $('head')[0];
    var link3 = document.createElement('link');
    link3.rel = 'stylesheet';
    link3.href = dataChooseCache.currentUrl + '/jquery.data-dialog-choose.css';
    head.appendChild(link3);

    if (!$.fn.zTree && dataChooseCache.currentUrl.indexOf('/assets/') > 0) {
        var ztreeUrl = dataChooseCache.currentUrl + '/../../../components/zTree';

        var link1 = document.createElement('link');
        link1.rel = 'stylesheet';
        link1.href = ztreeUrl + '/css/zTreeStyle/zTreeStyle.css';
        head.appendChild(link1);

        var link2 = document.createElement('link');
        link2.rel = 'stylesheet';
        link2.href = ztreeUrl + '/css/metroStyle/metroStyle.css';
        head.appendChild(link2);

        var script = document.createElement('script');
        script.type = 'text/javascript';
        script.src = ztreeUrl + '/js/jquery.ztree.all.min.js';
        head.appendChild(script);

    }

    $.get(dataChooseCache.currentUrl + "/jquery.data-dialog-choose.html", {}, function (result) {
        Vue.component('component-jquery-data-dialog-choose', {
            template: result,
            data: function () {
                return {
                    config: {
                        single: false, // 单选
                        isCheckParent: false, // 是否可选父节点
                        isShowLeaf:true, //是否显示叶子节点
                        min: 0, // 允许选中最小的数量
                        max: 99999, // 允许选中最大的数量

                        dataTypes: [], // 数据类型code
                        dataTypeNames: [], // 数据类型名称
                        defaultDataType: '', // 默认选中
                        dataCodes: '',// 回显code值域对象。
                        dataNames: '',// 回显值域名称对象
                        data: {}, // 供选择的列表数据
                    },
                    datas: {
                        // 默认选中
                        defaultDataType: '',
                        //所属父级路径
                        parentCodePath: '',
                        //关键字
                        keyWord: '',
                        // 是否包含子目录
                        isContainSubParent: true,
                        // 已选择的数据
                        selectList: [],
                        selectCache: {},
                        // 要展示的数据
                        dataList: [],
                        // 是否选择所有
                        checkAll: false,
                        // ztree对象
                        treeObj: null,
                    },
                };
            },
            mounted: function () {
            },
            watch: {
                'datas.parentCodePath': function () {
                    this.refreshDataList();
                },
            },
            methods: {
                initChoose: function (option) {
                    var _this = this;

                    var config = _this.$options.data().config;
                    $.each(config, function (key) {
                        if (option[key] != null) {
                            if (typeof option[key] === 'object') {
                                $.extend(true, config[key], option[key]);
                            } else {
                                config[key] = option[key];
                            }
                        }
                    });
                    _this.config = config;

                    $.each(_this.config.data, function (key, value) {
                        var cache = {};
                        $.each(value, function (index, data) {
                            cache[data.CODE] = data;
                        });
                        function resolvePath(data, firstCode) {

                            if (data.codePath) {
                                return;
                            }

                            if (!data.PCODE || cache[data.PCODE] == null || cache[data.PCODE].CODE === firstCode) {
                                data.codePath = key+','+ data.CODE + ',';
                                data.namePath ="/" + data.NAME;
                                data.PCODE = key;
                                return;
                            }
                            var pData = cache[data.PCODE];

                            resolvePath(pData, firstCode);
                            pData.isParent = true;

                            data.codePath = pData.codePath + data.CODE + ',';
                            data.namePath = pData.namePath + "/" + data.NAME;
                            data.isParent = false;
                        }

                        $.each(value, function (index, data) {
                            resolvePath(data, data.CODE);
                        });

                        //拼上一个父节点。
                        var name = '';
                        for (let i = 0; i <config.dataTypes.length ; i++) {
                            if( config.dataTypes[i] == key){
                                name = config.dataTypeNames[i]
                            }
                        }
                        value.push({
                            "CODE":key,
                            "PCODE":'0',
                            "NAME":name,
                            "SORT":0,
                            "codePath":key+',',
                            "namePath": "/" + name,
                            "isParent":true
                        });
                    });

                    _this.checkDataType(_this.config.defaultDataType);

                    if (_this.config.dataCodes) {
                        var dataCodes = _this.config.dataCodes.split(',');
                        $.each(_this.config.data, function (key, value) {
                            $.each(value, function (index, data) {
                                var sIndex = dataCodes.indexOf(data.CODE);
                                if (sIndex >= 0) {
                                    _this.addSelect(data);
                                    dataCodes.splice(sIndex, 1);
                                }
                            });
                        });
                    }
                },
                checkDataType: function (dataType) {
                    var _this = this;
                    var datas = _this.$options.data().datas;
                    datas.defaultDataType = dataType;
                    _this.datas = datas;

                    _this.initTree();
                    _this.refreshDataList();
                },
                refreshDataList: function () {
                    var _this = this;
                    var dataList = _this.config.data[_this.datas.defaultDataType];
                    var newDataList = [];
                    var isCheckParent = _this.config.isCheckParent;
                    var parentCodePath = _this.datas.parentCodePath;
                    var isContainSubParent = _this.datas.isContainSubParent;
                    var keyWord = _this.datas.keyWord ? _this.datas.keyWord.trim() : null;
                    $.each(dataList, function (index, data) {
                        //将第一个节点排出去
                        if(parentCodePath == data.CODE+','){
                            return;
                        }
                        if (parentCodePath && !data.codePath.startsWith(parentCodePath)) {
                            return;
                        }
                        if (!isCheckParent && data.isParent) {
                            return;
                        }
                        if (keyWord && data.namePath.indexOf(keyWord) === -1) {
                            return;
                        }
                        if (!isContainSubParent && (parentCodePath + data.CODE + ',') !== data.codePath) {
                            return;
                        }
                        newDataList.push(data);
                    });
                    _this.datas.dataList = newDataList;
                },
                /** 初始化树 * */
                initTree: function () {
                    var _this = this;

                    var treeList = _this.config.data[_this.datas.defaultDataType];
                    var treeListNew = [];
                    if(!_this.config.isShowLeaf){
                        $.each(treeList, function (index, data) {
                            if (data.isParent) {
                                treeListNew.push(data);
                            }
                        });
                    }else{
                        treeListNew = treeList;
                    }

                    // 配置
                    var setting = {
                        check: {
                            enable: false,
                        },
                        data: {
                            key: {
                                name: "NAME"
                            },
                            simpleData: {
                                enable: true,
                                idKey: "CODE",
                                pIdKey: "PCODE"
                            }
                        },
                        callback: {
                            onClick: function (event, treeId, treeNode) { // 节点单击事件
                                _this.datas.parentCodePath = treeNode.codePath;
                            },
                        }
                    };
                    // 初始化树
                    if (_this.datas.treeObj != null) {
                        _this.datas.treeObj.destroy();
                    }
                    _this.datas.treeObj = $.fn.zTree.init($(_this.$refs['div_node_tree']), setting, treeListNew);
                    _this.datas.treeObj.expandAll(true);
                    //默认选中第一个节点
                    node =_this.datas.treeObj.getNodes();
                    _this.datas.parentCodePath = node[0].codePath;
                },
                addSelect: function (item) {
                    var _this = this;
                    if (_this.config.single) {
                        for (var i = _this.datas.selectList.length - 1; i >= 0; i--) {
                            _this.removeSelect(_this.datas.selectList[i]);
                        }
                    } else if (_this.datas.selectCache[item.CODE]) {
                        return;
                    }
                    _this.datas.selectList.push(item);
                    Vue.set(_this.datas.selectCache, item.CODE, item);
                },
                removeSelect: function (item) {
                    var _this = this;
                    if (_this.datas.selectCache[item.CODE]) {
                        var index = _this.datas.selectList.indexOf(item);
                        _this.datas.selectList.splice(index, 1);
                        Vue.delete(_this.datas.selectCache, item.CODE);
                    }
                },
                checkItem: function (index) {
                    var _this = this;
                    var item = _this.datas.dataList[index];
                    if (_this.datas.selectCache[item.CODE]) {
                        _this.removeSelect(item);
                    } else {
                        _this.addSelect(item);
                    }
                    _this.refreshCheckAll();
                },
                refreshCheckAll: function () {
                    var _this = this;
                    var checkAll = true;
                    for (var i = 0; i < _this.datas.dataList.length; i++) {
                        if (_this.datas.selectCache[_this.datas.dataList[i].CODE] == null) {
                            checkAll = false;
                            break;
                        }
                    }
                    _this.datas.checkAll = checkAll;
                },
                checkItemAll: function () {
                    var _this = this;
                    var checked = !_this.datas.checkAll;
                    _this.datas.checkAll = checked;
                    if (checked) {
                        $.each(_this.datas.dataList, function (index, data) {
                            _this.addSelect(data);
                        });
                    } else {
                        $.each(_this.datas.dataList, function (index, data) {
                            _this.removeSelect(data);
                        });
                    }
                },
                getSelect: function () {
                    var _this = this;
                    var selectList = _this.datas.selectList;

                    if (selectList.length < _this.config.min) {
                        dialog({
                            title: '提示',
                            content: '至少需要选择' + _this.config.min + "个",
                        }).showModal();
                        return false;
                    } else if (selectList.length > _this.config.max) {
                        dialog({
                            title: '提示',
                            content: '最多只能选择' + _this.config.max + "个",
                        }).showModal();
                        return false;
                    }

                    return {
                        dataType: _this.datas.defaultDataType,
                        selectList: selectList
                    };
                }
            },
        });

        dataChooseCache.isInitedVueCompnent = true;
    }, 'text');

    var dataChoose = function (option) {
        // 将当前对象存储到临时变量中
        var wWidth = $(window).width() * 0.7;
        if (wWidth > 1000) {
            wWidth = 1000;
        }
        var wHeight = $(window).height() * 0.7;

        /** 插件需要传递的参数 * */
        var defaults = {
            id: "dialog-point-choose",
            icon: "fa-globe",
            title: "选择", // 标题
            width: wWidth, // 宽度
            height: wHeight, // 高度
            closeOnEscape: true,// 点击Esc退出
            quickClose: false, // 点击空白关闭
            okValue: "确认", // 确认按钮文字
            cancel: true, // 取消按钮
            cancelValue: "取消", // 取消按钮文字
            modal: true, // 模态框
            eject: true, // 弹框
            single: false, // 单选
            isCheckParent: false, // 是否可选父节点
            isShowLeaf:true, //是否显示叶子节点
            min: 0, // 允许选中最小的数量
            max: 99999, // 允许选中最大的数量
            dataTypes: [], // 数据类型code
            dataTypeNames: [], // 数据类型名称
            defaultDataType: null, // 默认选中
            dataCodes: null,// 回显code值域对象。
            dataNames: null,// 回显值域名称对象
            data: null, // 供选择的列表数据
            callback: function (dataType, nodeArray) {
            }, // 回调函数
        }

        // 将传递的参数，继承刚才定义的defaults对象
        option = $.extend(defaults, option);
        // 初始化数据配置
        if (!option.dataTypes || option.dataTypes.length === 0) {
            // 处理无dataTypes情况的的数据
            option.dataTypes = ["DATA0"];
            option.dataTypeNames = ["默认"]
            option.data = {
                DATA0: option.data,
            }
            option.defaultDataType = "DATA0";
        } else {
            // 检查并修正默认数据类型
            if (option.defaultDataType) {
                var isExsit = false;
                for (var i = 0; i < option.dataTypes.length; i++) {
                    if (option.defaultDataType === option.dataTypes[i]) {
                        isExsit = true;
                    }
                }
                if (isExsit === false) {
                    option.defaultDataType = option.dataTypes[0];
                }
            } else {
                option.defaultDataType = option.dataTypes[0];
            }
        }

        var dataChooseDialog = dataChooseCache.dataChooseDialog;
        if (dataChooseDialog != null) {
            // 关闭上次dialog对象
            dataChooseDialog.close().remove();
        }
        var divContent = dataChooseCache.divContent;
        if (divContent == null) {
            divContent = $('<div style="height: 100%;"><div ref="component-data-choose" is="component-jquery-data-dialog-choose"></div></div>');
            divContent.appendTo($('body'));
            dataChooseCache.divContent = divContent;

            dataChooseCache.vueObj = new Vue({
                el: divContent.find('div')[0],
                data: function () {
                    return {};
                },
                mounted: function () {
                },
                methods: {
                    initChoose: function (option) {
                        var _this = this;
                        _this.$refs['component-data-choose'].initChoose(option);
                    },
                    getSelect: function () {
                        return this.$refs['component-data-choose'].getSelect();
                    }
                },
            });
        }
        dataChooseDialog = dialog({
            id: option.id,
            icon: option.icon,
            wraperstyle: "",
            title: option.title,
            width: option.width,
            height: option.height,
            closeOnEscape: option.closeOnEscape,
            quickClose: option.quickClose,
            ok: function () {
                var result = dataChooseCache.vueObj.getSelect();
                // 回调函数
                if (result && option.callback && typeof option.callback == "function") {
                    option.callback(result.dataType, result.selectList);
                }
            },
            okValue: option.okValue,
            cancel: option.cancel,
            cancelValue: option.cancelValue,
            content: divContent[0],
        });
        dataChooseCache.dataChooseDialog = dataChooseDialog;

        if (option.modal) {
            dataChooseDialog.showModal();
        } else {
            dataChooseDialog.show(option.eject);
        }
        dataChooseCache.vueObj.initChoose(option);
    }

    $.dataChoose = dataChoose;
});
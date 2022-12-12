Vue.mixin({
    filters: {
        /**
         * 通用内容格式器（无效值用返回--）
         * @param val 值
         * @returns {string|*} 格式化后的值
         */
        resultFormat: function (val) {
            if (val || val === 0) {
                return val;
            } else {
                return '--';
            }
        },
        /**
         * 通用内容格式器（无效值用返回--）
         * @param val 值
         * @returns {string|*} 格式化后的值
         */
        message: function (val) {
            if (val || val === 0) {
                return val;
            } else {
                return '--';
            }
        },
        fieldType: function (value) {
            var resultText = '--';
            if (value.indexOf("input") > -1) {
                resultText = "单行文本";
            } else if (value.indexOf("textarea") > -1) {
                resultText = "多行文本";
            } else if (value.indexOf("number") > -1) {
                resultText = "数字";
            } else if (value.indexOf("datetime") > -1) {
                resultText = "日期时间";
            } else if (value.indexOf("radiogroup") > -1) {
                resultText = "单选按钮组";
            } else if (value.indexOf("checkboxgroup") > -1) {
                resultText = "复选框组";
            } else if (value.indexOf("select") > -1) {
                resultText = "下拉框";
            } else if (value.indexOf("selectcheckbox") > -1) {
                resultText = "下拉框组";
            } else if (value.indexOf("file") > -1) {
                resultText = "文件";
            } else if (value.indexOf("user") > -1) {
                resultText = "成员单选";
            } else if (value.indexOf("usergroup") > -1) {
                resultText = "成员多选";
            } else if (value.indexOf("dept") > -1) {
                resultText = "部门单选";
            } else if (value.indexOf("deptgroup") > -1) {
                resultText = "部门多选";
            }

            return resultText;
        }
    },
    methods: {
        /**
         * 公用时间选择功能
         * @param target 目标vue数据属性集
         * @param key 属性对应的key
         * @param option 时间选择框配置
         * @param ele 目标input元素
         */
        pickDatetime: function (target, key, option, ele) {
            let option2 = {
                isShowClear: true,
                isShowToday: false,
                readOnly: true,
            };
            $.extend(option2, option);
            option2.onpickedOriginal = option2.onpicked;
            option2.onclearingOriginal = option2.onclearing;
            option2.onpicked = function (dp) {
                if (target != null) {
                    Vue.set(target, key, dp.cal.getNewDateStr());
                }
                if (this.onpickedOriginal != null) {
                    this.onpickedOriginal(dp);
                }
            };
            option2.onclearing = function () {
                if (target != null) {
                    Vue.set(target, key, '');
                }
                if (this.onclearingOriginal != null) {
                    this.onclearingOriginal(dp);
                }
            };
            if (ele) {
                option2.el = ele;
            }
            WdatePicker(option2);
        },
        /**
         * 表格数据选择变动处理（单个与全局的互相影响）
         * @param {Object} global 全局选择属性所属对象
         * @param {String} allCheckKeyName 全局选择属性名称
         * @param {Array} itemList 表格数据集合
         * @param {String} itemKeyName 单个元素的对应选择属性名称
         * @param {Object} item 单个元素
         */
        checkTableData: function (global, allCheckKeyName, itemList, itemKeyName, item) {
            if (item) {
                let check = item[itemKeyName];
                if (check) {
                    for (let i = 0; i < itemList.length; i++) {
                        if (itemList[i][itemKeyName] !== check) {
                            check = false;
                            break;
                        }
                    }
                }
                Vue.set(global, allCheckKeyName, check);
            } else {
                let check = global[allCheckKeyName];
                for (let i = 0; i < itemList.length; i++) {
                    Vue.set(itemList[i], itemKeyName, check);
                }
            }
        },
        /**
         * 去除表格数据的某个元素
         * @param {Array} itemList 表格数据集合
         * @param {Integer} itemIndex 要去除的元素在集合中的位置索引
         * @param {String} itemKeyName 判断元素是否要删除的标识属性名称
         * @param {Function} beforeCallback 去除前回调函数
         * @param {Function} afterCallback 去除后回调函数
         */
        removeTableData: function (itemList, itemIndex, itemKeyName, beforeCallback, afterCallback) {
            var removeItemList = [];
            var retainItemList = [];
            if (itemIndex != null) {
                removeItemList.push(itemList[itemIndex]);
            } else {
                for (let i = 0; i < itemList.length; i++) {
                    if (itemList[i][itemKeyName] === true) {
                        removeItemList.push(itemList[i]);
                    } else {
                        retainItemList.push(itemList[i]);
                    }
                }
            }
            if (removeItemList.length === 0) {
                DialogUtil.showTipDialog("请选择要删除的数据！", null);
                return;
            }

            function doDelete() {
                if (itemIndex != null) {
                    itemList.splice(itemIndex, item);
                } else {
                    itemList.splice(0, itemList.length);
                    for (let i = 0; i < retainItemList.length; i++) {
                        itemList.push(retainItemList[i]);
                    }
                }
                if (afterCallback && afterCallback instanceof Function) {
                    afterCallback(itemList, itemIndex, itemKeyName, removeItemList);
                }
            }

            if (beforeCallback && beforeCallback instanceof Function) {
                beforeCallback(itemList, itemIndex, itemKeyName, removeItemList, doDelete);
            } else {
                let msg = "确认删除选择的" + removeItemList.length + "条数据吗？";
                DialogUtil.showConfirmDialog(msg, doDelete, null);
            }
        },
        /**
         * 添加回调函数到window对象上
         * @param obj 函数名称所属对象
         * @param key 记录函数名称的对应属性名
         * @param callback 回调函数
         */
        setCallbackToWindow: function (obj, key, callback) {
            //设置回调函数
            var timestamp = new Date().getTime();
            var callbackName = obj[key];
            while (window[callbackName + timestamp] != null) {
                timestamp++;
            }
            obj[key] = callbackName + timestamp;
            window[obj[key]] = callback;
        },
        /**
         * 初始化字典数据
         * @param dictionaryTreeCode 字段类编码
         * @param dictionaryList 字典条目
         * @param callback 数据回调
         */
        initDictionaryList: function (dictionaryTreeCode, dictionaryList, callback) {
            var url = ctx + '/dictionary/dictionaryCommon/listByTreeCode.vm';
            AjaxUtil.sendAjax(url, {
                treeCode: dictionaryTreeCode
            }, function (result) {
                if (callback) {
                    callback(result.data);
                } else {
                    dictionaryList.splice(0);
                    $.each(result.data, function (index, info) {
                        dictionaryList.push(info);
                    });
                }
            }, null, null);
        },
    },
});

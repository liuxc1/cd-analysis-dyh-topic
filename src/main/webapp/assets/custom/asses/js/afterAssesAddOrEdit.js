/** 快报分析报告-编辑逻辑js **/
new Vue({
    el: '#main-container',
    data: {
        urls: {
            addOrEditAfterAssesUrl: ctx + '/asses/addOrEditAsses.vm',//添加或者编辑数据
            exportTemplate: ctx + '/asses/exportTemplate.vm',//导出模板
            afterAssesById: ctx + '/asses/afterAssesById.vm',//根据方案id获取对应的场景以及排放数据
            deleteAssessScene: ctx + '/asses/deleteAssessScene.vm',//编辑场景
            exportExcel: ctx + '/asses/exportExcel.vm'//导出excel数据
        },
        params: {//方案
            name: '',//方案名称
            startTime: '',//开始时间
            endTime: '',//结束时间
            remarks: '',//备注
            id: id,//方案id
        },
        tabIndex: 0,//当前被激活场景的索引,位置
        tabCount: 1,//统计面板累计数量
        tabList: [{//新建场景,tab集合
            id: '', name: '新建场景1', active: true, ariaHidden: true,
            pollutantList: [],//污染物减排信息
            quality: []//质量改善信息
        }],
        tip: {//提示
            form: {
                name: '未填写方案名称',
                timeIsNull: '未填写时间',
                timeStartGtEnd: '结束时间不能小于开始时间',
                confirm: '确认提交数据?',
                save: '数据保存成功'
            },
            tab: {
                maxSize: '以达到目前最多场景数量为10个',
                minSize: '至少保证一个场景存在',
                delete: '确认删除该场景?提交后才生效'
            },
            excel: {
                format: '上传格式不正确，请上传xls或者xlsx格式',
                error: '文件解析错误'
            }
        },
        //2:后评估 1:预评估
        type:type
    },
    // 页面加载完后调用
    mounted: function () {
        const _this = this;
        _this.initData();
        _this.$nextTick(() => {
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
            _this.tabCount = _this.tabList.length;
        })
    },
    methods: {
        /**
         * 初始化数据，获取全部数据
         */
        async initData() {
            const _this = this;
            let params = {id: _this.params.id};
            let res = await $axios.post(_this.urls.afterAssesById, params);
            if (res.code == 200 && res.data != null) {
                let item = res.data;
                _this.params.name = item.assessName;
                _this.params.remarks = item.remark;
                _this.params.id = item.pkid;
                _this.params.startTime = item.startTime;
                _this.params.endTime = item.endTime;
                _this.tabList=[];
                item.list.forEach(val=>{
                    let item={id:val.sceneId,name:val.sceneName,
                        active: val.active, ariaHidden: val.ariaHidden,
                        pollutantList:val.pollutantList,quality:val.quality}
                    _this.tabList.push(item);
                })

            } else {
                _this.initEmpty();
            }
        },
        //初始化数据为空是默认数据
        initEmpty: function (index) {
            const _this = this;
            if (index) {
                _this.tabIndex = index;
            }
            let tabIndex = index == undefined ? _this.tabIndex : index;
            for (let i = 0; i < 5; i++) {
                for (let j = 0; j < 6; j++) {
                    let item = {//污染物减排信息
                        emissionsType: i==4?(i+2):(i + 1),//减排类型
                        warningColor: 1,//减排的颜色等级(1红2橙3黄)
                        warningType: 1,//减排的颜色等级(类型:1吨,比列)'
                        list: [0, 0, 0, 0, 0]
                    }
                    if (j < 3) {
                        item.warningType = 1;
                    } else {
                        item.warningType = 2;
                    }
                    if (j == 0 || j == 3) {
                        item.warningColor = 'red';
                    } else if (j == 1 || j == 4) {
                        item.warningColor = 'orange';
                    } else {
                        item.warningColor = 'yellow';
                    }
                    _this.tabList[tabIndex].pollutantList.push(item);
                }
            }
            for (let i = 0; i < 3; i++) {
                for (let j = 0; j < 6; j++) {
                    let item = {//污染物减排信息
                        emissionsType: 5,//污染物类型 PM10:1,PM2.5:2,NO2:3
                        dataType: (i + 1),
                        warningType: '',//消减类型ug/m3:1,比列:2
                        warningColor: '',//减排的颜色等级(1红2橙3黄)
                        list: [0]
                    }
                    if (j < 3) {
                        item.warningType = 1;
                    } else {
                        item.warningType = 2;
                    }
                    if (j == 0 || j == 3) {
                        item.warningColor = 'red';
                    } else if (j == 1 || j == 4) {
                        item.warningColor = 'orange';
                    } else {
                        item.warningColor = 'yellow';
                    }
                    _this.tabList[tabIndex].quality.push(item);
                }
            }
        },
        /**
         * 取消
         * @param {boolean} isParentRefresh 是否父页面刷新
         */
        goBack: function (isParentRefresh) {
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
         * 保存
         */
        saveData: function () {
            const _this = this;
            //控制结束时间不能小于开始时间
            if (_this.params.startTime>_this.params.endTime){
                DialogUtil.showTipDialog("模拟开始日期必须小于等于结束日期！");
                return;
            }
            let form = _this.tip.form;
            var flag = $('#mainForm').validationEngine('validate');
            if (!flag) {
                return;
            }
            let list=[];
            _this.tabList.forEach(val=>{
                let item={sceneId:val.id,sceneName:val.name, deleteFlag:0,
                    pollutantList:val.pollutantList,quality:val.quality}
                list.push(item);
            })
            var params = {
                assessType:_this.type,
                pkid: _this.params.id,
                assessName: _this.params.name,
                startTime: _this.params.startTime,
                endTime: _this.params.endTime,
                remark: _this.params.remarks,
                date:_this.params.startTime+'~'+_this.params.endTime,
                deleteFlag:0,
                list: list
            }
            DialogUtil.showConfirmDialog(form.confirm, function () {
                $axios.post(_this.urls.addOrEditAfterAssesUrl, params).then(res => {
                    if (res.code == 200) {
                        DialogUtil.showTipDialog(form.save, function () {
                            _this.goBack(true);
                        });
                    } else {
                        DialogUtil.showTipDialog(res.message);
                    }
                })
            });
        },
        /**
         * 日期选择插件
         */
        wdatePicker1: function (doucmentId) {
            var _this = this;
            WdatePicker({
                // 回显数据的对象ID
                el: doucmentId,
                // 时间格式
                dateFmt: 'yyyy-MM-dd',
                // 是否显示清除按钮
                isShowClear: true,
                // 是否显示今天按钮
                isShowToday: false,
                // 只读
                readOnly: true,
                // 限制最大时间
                // maxDate: '%y-%M-%d',
                maxDate: doucmentId=='txtDate'?'#F{$dp.$D(\'txtDate2\')}':'',
                minDate: doucmentId=='txtDate2'?'#F{$dp.$D(\'txtDate\')}':'',

                onpicked: function (dp) {
                    // 防止重复点击当月
                    var yearMonthDay = dp.cal.getNewDateStr();
                    if (doucmentId == 'txtDate' && yearMonthDay === _this.params.startTime) {
                        return;
                    }
                    if (doucmentId == 'txtDate2' && yearMonthDay === _this.params.endTime) {
                        return;
                    }
                    if (doucmentId == 'txtDate') {
                        _this.params.startTime = yearMonthDay;
                    } else {
                        _this.params.endTime = yearMonthDay;
                    }
                }
            });
        },
        /**
         * 增加table场景
         */
        addTable: function () {
            const _this = this;
            if (_this.tabList.length >= 10) {
                DialogUtil.showTipDialog(_this.tip.tab.maxSize);
                return;
            }
            _this.tabList.forEach(val => {
                val.active = false;
            })
            _this.tabCount = _this.tabCount + 1;
            _this.tabList.push({
                id: '',
                name: '新建场景' + (_this.tabCount),
                active: true,
                ariaHidden: true,
                pollutantList: [],
                quality: []
            });
            _this.initEmpty(_this.tabList.length - 1);

        },
        /**
         * 切换场景时展示不同数据模块
         * @param item
         */
        changeTable: function (item, index) {
            const _this = this;
            let length = _this.tabList.length;
            for (let i = 0; i < length; i++) {
                _this.tabList[i].active = index == i ? true : false;
            }
            _this.tabIndex = index;
        },
        /**
         * 导入或导出
         */
        excel: function (type) {
            const _this = this;
            let tagName = '';//标签名称
            let qualifiledName = [];//属性名称
            if (type == 'IMPORT') {//导入
                tagName = 'input';
                qualifiledName.push({name: 'type', value: 'file'});
            } else if (type == 'TEMPLATE') {//导出模板
                tagName = 'a';
                qualifiledName.push({name: 'download', value: ''});
                qualifiledName.push({name: 'href', value: _this.urls.exportTemplate});
            } else {//导出数据
                tagName = 'a';
                qualifiledName.push({name: 'download', value: ''});
                let url = _this.urls.exportExcel + '?id=' + _this.params.id + '&index=' + _this.tabIndex;
                qualifiledName.push({name: 'href', value: url});
            }
            const a = document.createElement(tagName); // 创建a标签
            qualifiledName.forEach(val => {// 添加属性
                a.setAttribute(val.name, val.value);
            })
            if (type == 'IMPORT') {//添加事件回调
                a.addEventListener('change', _this.readExcel, false);
            }
            a.click();// 自执行点击事件
            a.remove();
        },
        /**
         * 读取excel
         * @param obj
         * @returns {boolean}
         */
        readExcel: function (obj) {
            const _this = this;
            const files = obj.target.files;
            const excel = _this.tip.excel;
            let vali = /\.(xls|xlsx)$/;
            if (!vali.test(files[0].name.toLowerCase())) {
                DialogUtil.showTipDialog(excel.format);
                return false;
            }
            const fileReader = new FileReader();//捕获文件状态
            fileReader.onload = (e) => {//文件读取成功时触发
                try {
                    const data = e.target.result;//获取文件数据
                    const workdata = XLSX.read(data, {//使用工具将数据转换成workbook对象
                        type: "binary"
                    });
                    _this.formatResult(workdata);
                } catch (excpetion) {
                    DialogUtil.showTipDialog(excel.error);
                    return false;
                }
            };
            fileReader.readAsBinaryString(files[0]);
        },
        // 将读取的数据转成JSON方向
        formatResult: function (data) {
            const _this = this;
            const sheets = data.Sheets;// 获取总数据
            const sheetItem = Object.keys(sheets); // 获取全部sheet
            for (let i = 0; i < sheetItem.length; i++) {//获取对应sheet数据
                const sheetName = sheetItem[i];
                const sheetJson = XLSX.utils.sheet_to_json(sheets[sheetName], {header: 1});
                let array = [];//判断sheet,填充入当前选择tab页的指定表格中
                if (i == 0) {
                    array = _this.tabList[_this.tabIndex].pollutantList;//第一个sheet
                } else {
                    array = _this.tabList[_this.tabIndex].quality;//第二个sheet
                }
                let groupNums = i == 0 ? 5 : 1;//几个数一组
                let arrayIndex = 0;//表格数量索引(几个数一组,为一个索引)
                for (let j = 3; j < sheetJson.length; j++) {
                    if (sheetJson[j].length > 0) {//获取当前行数据,为空的排除
                        let rowList = sheetJson[j]; //当前行所有数据
                        let start = i == 0 ? 2 : 1;//截取数组开始位置
                        let end = start + groupNums;//截取数组结束位置
                        for (let x = 0; x < 6; x++) {
                            //截取数组指定长度的数据
                            let newArr = rowList.slice(start, end);
                            //替换原来数组的值
                            array[arrayIndex].list = newArr;
                            //增加指定间隔值的开始索引
                            start = start + groupNums;
                            //增加指定间隔值的结束索引
                            end = end + groupNums;
                            arrayIndex++;
                        }
                    }
                }
            }
        },
        /**
         * 删除场景
         */
        async delScenario(item, index) {
            const _this = this;
            const tab = _this.tip.tab;
            if (_this.tabList.length > 1) {
                DialogUtil.showConfirmDialog(tab.delete, function () {
                    //新增的场景可以直接删除
                    if (item.id == null || item.id == undefined || item.id.length <= 0) {
                        _this.tabList.splice(index, 1);
                        let length = _this.tabList.length;
                        for (let i = 0; i < length; i++) {
                            let item = _this.tabList[i];
                            item.active = false;
                            if (i == length - 1) {
                                item.active = true;
                                _this.tabIndex = i;
                            }
                        }
                    } else {//需要调用接口删除
                        _this.deleteAssessScene(item.id, index);
                    }
                });
            } else {
                DialogUtil.showTipDialog(tab.minSize);
            }
        },
        /**
         * 删除场景:(存储的数据)
         */
        deleteAssessScene: async function (id, index) {
            const _this = this;
            let params = {
                sceneId: id,
                deleteFlag: 1
            }
            let res = await $axios.post(_this.urls.deleteAssessScene, params);
            if (res.code == 200) {
                _this.tabList.splice(index, 1);//删除数组指定位置元素
                let length = _this.tabList.length;
                for (let i = 0; i < length; i++) {
                    let item = _this.tabList[i];
                    item.active = false;
                    if (i == length - 1) {
                        item.active = true;
                        _this.tabIndex = i;
                    }
                }
            }
        },
        /**
         * 过滤菜单信息(污染物减排信息)
         */
        filterTableListForPollution(type) {
            const _this = this;
            let list = _this.tabList[_this.tabIndex].pollutantList;
            if (list.length > 0) {
                return list.filter(value => value.emissionsType == type);
            }
        },
        /**
         * 过滤菜单信息(质量改善信息)
         */
        filterTableListForQuality: function (type) {
            const _this = this;
            let list = _this.tabList[_this.tabIndex].quality;
            if (list.length > 0) {
                return list.filter(data => data.dataType == type);
            }
        },
        /**
         * 验证数字
         */
        verifyFloat(e) {
            const input = e.target;//获取input dom
            let value = input.value;//获取输入值
            if (value) {
                let first = value.indexOf('.');//第一次出现位置
                let leng = value.length;//字符长度
                let zero = value.indexOf('0');//校验是否0开始
                let subtract = value.indexOf('-');//减号位置
                let reg = /^\-?([1-9]+|0)(\.[0-9]+)?$/;
                //校验0开始
                if (((subtract == 0 && zero == 1) || zero == 0) && (leng - 1) > zero) {//有-号的0开始,没有-号0开始,并且从0之后开始校验
                    if (first == -1 && !reg.test(value)) {//校验非浮点
                        return input.value = '0';
                    } else if (first != -1 && (leng - 2) > zero && !reg.test(value)) {//校验浮点
                        return input.value = '0';
                    }
                }
                //校验非0的浮点数
                if (first != -1 && (leng - 1) > first && !reg.test(value)) {//小数点后一位开始校验
                    return input.value = '0';
                }
                if ((first != -1 && first != 0) || (subtract != -1 && leng == 1)) {//只通过 逗号不在第一位置以及不存在时,和只存在一个-号时(举例:0.,-1.,-)
                    return input.value;
                }
                if (!reg.test(value)) {//完整校验
                    return input.value = '0';
                }

            }
        }
    }
});

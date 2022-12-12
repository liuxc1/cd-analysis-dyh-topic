<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>警情中心</title>
    <link href="../../assets/components/element-ui/lib/theme-chalk/index.css?v=20221129015223" rel="stylesheet" type="text/css">
    <style>
        .el-date-editor.el-input, .el-date-editor.el-input__inner {
            width: 130px;
        }

        .el-input--suffix .el-input__inner {
            padding-right: 0px;
        }

        .el-main {
            padding: 20px 0px 20px 0px;
        }

        .module-div {
            padding-bottom: 20px;
            color: #ffffff;
        }

        /**
        滚动条
         */
        ::-webkit-scrollbar {
            /*滚动条整体样式*/
            width: 10px; /*高宽分别对应横竖滚动条的尺寸*/
            height: 1px;
        }

        ::-webkit-scrollbar-thumb {
            /*滚动条里面小方块*/
            border-radius: 10px;
            box-shadow: inset 0 0 5px rgba(0, 0, 0, 0.2);
            background: #535353;
        }

        ::-webkit-scrollbar-track {
            /*滚动条里面轨道*/
            box-shadow: inset 0 0 5px rgba(0, 0, 0, 0.2);
            border-radius: 10px;
            background: #4a3636;
        }

        .el-checkbox {
            margin-right: 10px;
        }

        .el-checkbox__label {
            font-size: 12px;
        }

        .el-form-item__label {
            color: #ffffff;
        }

        .el-table, .el-table__expanded-cell {
            background-color: #00000000;
        }

        .el-table th, .el-table tr {
            background-color: #00000000;
        }

        .el-table--border, .el-table--group {
            border: 1px solid #858585;
        }

        .el-table--border::after, .el-table--group::after, .el-table::before {
            content: '';
            position: absolute;
            background-color: #858585;
            z-index: 1;
        }

        .el-checkbox {
            color: #ffffff;
        }

        *::-webkit-scrollbar {
            width: 7px;
            height: 10px;
            background-color: transparent;
        }

        /*定义滚动条高宽及背景 高宽分别对应横竖滚动条的尺寸*/
        *::-webkit-scrollbar-track {
            background-color: #858585;
        }

        /*定义滚动条轨道 内阴影+圆角*/
        *::-webkit-scrollbar-thumb {
            background-color: #858585;
            border-radius: 6px;
        }

        /*定义滑块 内阴影+圆角*/
        .scrollbarHide::-webkit-scrollbar {
            display: none
        }

        .scrollbarShow::-webkit-scrollbar {
            display: block
        }

        .locationPoint {
            font-size: 20px;
            color: #0a8bea;
            cursor: pointer;
        }

        [v-cloak] {
            display: none;
        }
    </style>
</head>
<body>
<el-container id="container" v-cloak>
    <el-header style="padding: 0px">
        <el-form ref="params" :model="params" label-width="80px">
            <el-form-item label="报警时间">
                <el-col :span="10">
                    <el-date-picker
                            v-model="params.warnTime"
                            type="date"
                            @change="timeChange(true)"
                            value-format="yyyy-MM-dd"
                            placeholder="选择日期">
                    </el-date-picker>
                </el-col>
                <label class="el-form-item__label" style="width: 50px;">区县</label>
                <el-col :span="10">
                    <el-select v-model="params.region" placeholder="请选择" @change="timeChange(true)">
                        <el-option key="" label="全部" value=""></el-option>
                        <el-option
                                v-for="item in regionList"
                                :key="item.REGIONCODE"
                                :label="item.REGIONNAME"
                                :value="item.REGIONCODE">
                        </el-option>
                    </el-select>
                </el-col>
            </el-form-item>
        </el-form>
    </el-header>
    <el-main>
        <div class="module-div">
            <span>区县报警</span><span style="float: right">{{params.warnTime}}</span>
            <hr/>
            <el-table
                    :data="regionTable" border style="width: 100%;"
                    max-height="500"
                    :header-cell-style="headStyle"
                    :cell-style="tdStyle"
            >
                <el-table-column prop="POINT_NAME" label="区县" :show-overflow-tooltip='true'
                                 min-width="60"></el-table-column>
                <el-table-column prop="WARN_TYPE" label="报警类型" :show-overflow-tooltip='true'
                                 min-width="60"></el-table-column>
                <el-table-column prop="WARN_DETAIL" label="问题详情" :show-overflow-tooltip='true'
                                 min-width="60"></el-table-column>
                <el-table-column prop="WARN_TIME" label="开始时间" :show-overflow-tooltip='true'
                                 min-width="60"></el-table-column>
                <el-table-column label="状态" :show-overflow-tooltip='true' width="100">
                    <a>任务详情</a>
                    <a>效果</a>
                </el-table-column>
            </el-table>

        </div>
        <div class="module-div">
            <span>站点报警</span><span style="float: right">{{params.warnTime}}</span>
            <hr/>
            <span style="font-size: 12px;">站点类型:</span>
            <el-checkbox-group v-model="params.pointType" style="display: inline">
                <el-checkbox v-for="item in pointTypes" :label="item.code" @change="listPointTable(true)">
                    {{item.name}}
                </el-checkbox>
            </el-checkbox-group>
            <el-table
                    :data="pointTable" border style="width: 100%;"
                    max-height="500"
                    :header-cell-style="headStyle"
                    :cell-style="tdStyle"
            >
                <el-table-column label="定位" :show-overflow-tooltip='true' width="50">
                    <template slot-scope="scope">
                        <i class="el-icon-location locationPoint" @click="location(scope.row)"></i>
                    </template>
                </el-table-column>
                <el-table-column prop="POINT_NAME" label="站点名称" :show-overflow-tooltip='true'
                                 min-width="60"></el-table-column>
                <el-table-column prop="POINT_TYPE" label="站点类型" :show-overflow-tooltip='true' min-width="60">
                    <template slot-scope="scope">{{ scope.row.POINT_TYPE|pointType }}</template>
                </el-table-column>
                <el-table-column prop="WARN_TYPE" label="报警类型" :show-overflow-tooltip='true'
                                 min-width="60"></el-table-column>
                <el-table-column prop="WARN_DETAIL" label="问题详情" :show-overflow-tooltip='true'
                                 min-width="60"></el-table-column>
                <el-table-column prop="WARN_TIME" label="开始时间" :show-overflow-tooltip='true'
                                 min-width="60"></el-table-column>
                <el-table-column label="状态" :show-overflow-tooltip='true' width="100">
                    <a>任务详情</a>
                    <a>效果</a>
                </el-table-column>
            </el-table>
        </div>
        <div class="module-div">
            <span>污染源在线监测报警</span><span style="float: right">{{params.warnTime}}</span>
            <hr/>
            <span style="font-size: 12px;">污染源类型:</span>
            <el-checkbox-group v-model="params.sourceType" style="display: inline">
                <el-checkbox v-for="item in sourceTypes" :label="item.code" @change="listSourceTable(true)">
                    {{item.name}}
                </el-checkbox>
            </el-checkbox-group>
            <el-table
                    :data="sourceTable" border style="width: 100%;"
                    max-height="500"
                    :header-cell-style="headStyle"
                    :cell-style="tdStyle"
            >
                <el-table-column label="定位" :show-overflow-tooltip='true' width="50">
                    <template slot-scope="scope">
                        <i class="el-icon-location locationPoint" @click="location(scope.row)"></i>
                    </template>
                </el-table-column>
                <el-table-column prop="POINT_NAME" label="点位名称" :show-overflow-tooltip='true'
                                 min-width="60"></el-table-column>
                <el-table-column prop="POINT_TYPE" label="污染源类型" :show-overflow-tooltip='true' min-width="60">
                    <template slot-scope="scope">{{ scope.row.POINT_TYPE|pointType }}</template>
                </el-table-column>
                <el-table-column prop="WARN_TYPE" label="报警类型" :show-overflow-tooltip='true'
                                 min-width="60"></el-table-column>
                <el-table-column prop="WARN_DETAIL" label="问题详情" :show-overflow-tooltip='true'
                                 min-width="60"></el-table-column>
                <el-table-column prop="WARN_TIME" label="开始时间" :show-overflow-tooltip='true'
                                 min-width="60"></el-table-column>
                <el-table-column label="状态" :show-overflow-tooltip='true' width="100">
                    <a>任务详情</a>
                    <a>效果</a>
                </el-table-column>
            </el-table>
        </div>
        <div class="module-div">
            <span>雷达观测问题</span><span style="float: right">{{params.warnTime}}</span>
            <hr/>
            <span style="font-size: 12px;">问题来源:</span>
            <el-checkbox-group v-model="params.radarType" style="display: inline">
                <el-checkbox v-for="item in radarTypes" :label="item.code" @change="listRadarTable(true)">
                    {{item.name}}
                </el-checkbox>
            </el-checkbox-group>
            <el-table
                    :data="RadarTable" border style="width: 100%;"
                    max-height="500"
                    :header-cell-style="headStyle"
                    :cell-style="tdStyle"
            >
                <el-table-column label="定位" :show-overflow-tooltip='true' width="50">
                    <template slot-scope="scope">
                        <i class="el-icon-location locationPoint" @click="location(scope.row)"></i>
                    </template>
                </el-table-column>
                <el-table-column prop="POINT_NAME" label="点位名称" :show-overflow-tooltip='true'
                                 min-width="60"></el-table-column>
                <el-table-column prop="POINT_TYPE" label="问题来源" :show-overflow-tooltip='true' min-width="60">
                    <template slot-scope="scope">{{ scope.row.POINT_TYPE|pointType }}</template>
                </el-table-column>
                <el-table-column prop="WARN_DETAIL" label="问题详情" :show-overflow-tooltip='true'
                                 min-width="60"></el-table-column>
                <el-table-column prop="WARN_TIME" label="发现时间" :show-overflow-tooltip='true'
                                 min-width="60"></el-table-column>
                <el-table-column label="状态" :show-overflow-tooltip='true' width="100">
                    <a>任务详情</a>
                    <a>效果</a>
                </el-table-column>
            </el-table>
        </div>
        <div class="module-div">
            <span>污染溯源</span><span style="float: right">{{params.warnTime}}</span>
            <hr/>
            <span style="font-size: 12px;">问题来源:</span>
            <el-checkbox-group v-model="params.polluteType" style="display: inline">
                <el-checkbox v-for="item in polluteTypes" :label="item.code" @change="listPolluteTable(true)">
                    {{item.name}}
                </el-checkbox>
            </el-checkbox-group>
            <el-table
                    :data="polluteTable" border style="width: 100%;"
                    max-height="500"
                    :header-cell-style="headStyle"
                    :cell-style="tdStyle"
            >
                <el-table-column label="定位" :show-overflow-tooltip='true' width="50">
                    <template slot-scope="scope">
                        <i class="el-icon-location locationPoint" @click="location(scope.row)"></i>
                    </template>
                </el-table-column>
                <el-table-column prop="POINT_NAME" label="点位名称" :show-overflow-tooltip='true'
                                 min-width="60"></el-table-column>
                <el-table-column prop="POINT_TYPE" label="问题来源" :show-overflow-tooltip='true' min-width="60">
                    <template slot-scope="scope">{{ scope.row.POINT_TYPE|pointType }}</template>
                </el-table-column>
                <el-table-column prop="WARN_DETAIL" label="问题详情" :show-overflow-tooltip='true'
                                 min-width="60"></el-table-column>
                <el-table-column prop="WARN_TIME" label="发现时间" :show-overflow-tooltip='true'
                                 min-width="60"></el-table-column>
                <el-table-column label="状态" :show-overflow-tooltip='true' width="100">
                    <a>任务详情</a>
                    <a>效果</a>
                </el-table-column>
            </el-table>
        </div>
    </el-main>
</el-container>
<script type="text/javascript" src="${ctx}/other/comon.js?v=20221129015223"></script>
<script>
    let vue = new Vue({
        el: '#container',
        data: {
            headStyle: {
                background: '#00000000',
                color: '#00ffe1',
                fontSize: '12px',
                textAlign: 'center',
                borderColor: '#858585'
            },
            tdStyle: {
                fontSize: '12px',
                color: '#ffffff',
                background: '#00000000',
                borderColor: '#858585'
            },
            httpUrl: '/service/serviceinterface/search/run.action',
            regionList: [],
            pointTypes: [
                {
                    code: '2',
                    name: '国控'
                },
                {
                    code: '3',
                    name: '省控'
                },
                {
                    code: '4',
                    name: '市控'
                },
                {
                    code: '5',
                    name: '微站'
                }
            ],
            sourceTypes: [
                {
                    code: '6',
                    name: '固定源'
                },
                {
                    code: '7',
                    name: '面源'
                },
                {
                    code: '8',
                    name: '扬尘源'
                },
                {
                    code: '9',
                    name: '移动源'
                }
            ],
            radarTypes: [
                {
                    code: '10',
                    name: '定点扫描'
                },
                {
                    code: '11',
                    name: '走航观测'
                }
            ],
            polluteTypes: [
                {
                    code: '12',
                    name: '污染地图'
                },
                {
                    code: '13',
                    name: '小尺度'
                }
            ],
            params: {
                pointType: ['2', '3', '4', '5'],
                sourceType: ['6', '7', '8', '9'],
                radarType: ['10', '11'],
                polluteType: ['12', '13'],
                warnTime: '',
                region: ''
            },
            regionTable: [],
            pointTable: [],
            sourceTable: [],
            RadarTable: [],
            polluteTable: [],
            checkList: []
        },
        mounted() {
            this.listRegionInfo();
            this.listRegionTable();
            this.listPointTable();
            this.listSourceTable();
            this.listRadarTable();
            this.listPolluteTable();

        },
        filters: {
            pointType: function (value) {
                let result = '';
                switch (value) {
                    case '1':
                        result = '区县';
                        break;
                    case '2':
                        result = '国控';
                        break;
                    case '3':
                        result = '省控';
                        break;
                    case '4':
                        result = '市控';
                        break;
                    case '5':
                        result = '微站';
                        break;
                    case '6':
                        result = '固定源';
                        break;
                    case '7':
                        result = '面源';
                        break;
                    case '8':
                        result = '扬尘源';
                        break;
                    case '9':
                        result = '移动源';
                        break;
                    case '10':
                        result = '定点扫描';
                        break;
                    case '11':
                        result = '走航观测';
                        break;
                    case '12':
                        result = '污染地图';
                        break;
                    case '13':
                        result = '小尺度';
                        break;
                    default:
                        break;
                }
                return result;
            }
        },
        methods: {
            listRegionInfo() {
                let _this = this;
                let params = {
                    interfaceId: 'f1a3162aef69fd54bca3680badc2dd2b',
                }
                http.getSuperviseGet(params, function (data) {
                    _this.regionList = data.data;
                })
            },
            listRegionTable(sendMsg) {
                let _this = this;
                let params = {
                    interfaceId: 'be918bc04ac814d6cf0612ce6c9b6ca8',
                    WARN_SOURCE: '1',
                    WARN_TIME: (_this.params.warnTime || utils.timeFormat(new Date(), 'yyyy-MM-dd')) + ' 00:00:00',
                    REGION_CODE: _this.params.region,
                    CODE_REGION: _this.params.region,
                }
                http.getSuperviseGet(params, function (data) {
                    _this.regionTable = data.data;
                })
                /*$.post("listTable.vm",params,function(data){
                    _this.regionTable = data.data;
                },'json')*/
                if (sendMsg) {
                    _this.sendMessage('regionType', params);
                }
            },
            listPointTable(sendMsg) {
                let _this = this;
                let params = {
                    interfaceId: 'be918bc04ac814d6cf0612ce6c9b6ca8',
                    WARN_SOURCE: '2',
                    POINT_TYPES: _this.params.pointType.join("、") || '0',
                    WARN_TIME: (_this.params.warnTime || utils.timeFormat(new Date(), 'yyyy-MM-dd')) + ' 00:00:00',
                    REGION_CODE: _this.params.region,
                    CODE_REGION: _this.params.region,
                }
                http.getSuperviseGet(params, function (data) {
                    _this.pointTable = data.data;
                })
                /*$.post("listTable.vm",params,function(data){
                    _this.pointTable = data.data;
                },'json')*/
                if (sendMsg) {
                    _this.sendMessage('pointType', params);
                }
            },
            listSourceTable(sendMsg) {
                let _this = this;
                let params = {
                    interfaceId: 'be918bc04ac814d6cf0612ce6c9b6ca8',
                    WARN_SOURCE: '3',
                    POINT_TYPES: _this.params.sourceType.join("、") || '0',
                    WARN_TIME: (_this.params.warnTime || utils.timeFormat(new Date(), 'yyyy-MM-dd')) + ' 00:00:00',
                    REGION_CODE: _this.params.region,
                    CODE_REGION: _this.params.region,
                }
                http.getSuperviseGet(params, function (data) {
                    _this.sourceTable = data.data;
                })
                /*$.post("listTable.vm",params,function(data){
                    _this.sourceTable = data.data;
                },'json')*/
                if (sendMsg) {
                    _this.sendMessage('sourceType', params);
                }
            },
            listRadarTable(sendMsg) {
                let _this = this;
                let params = {
                    interfaceId: 'be918bc04ac814d6cf0612ce6c9b6ca8',
                    WARN_SOURCE: '4',
                    POINT_TYPES: _this.params.radarType.join("、") || '0',
                    WARN_TIME: (_this.params.warnTime || utils.timeFormat(new Date(), 'yyyy-MM-dd')) + ' 00:00:00',
                    REGION_CODE: _this.params.region,
                    CODE_REGION: _this.params.region,
                }
                http.getSuperviseGet(params, function (data) {
                    _this.RadarTable = data.data;
                })
                /*$.post("listTable.vm",params,function(data){
                    _this.RadarTable = data.data;
                },'json')*/
                if (sendMsg) {
                    _this.sendMessage('radarType', params);
                }
            },
            listPolluteTable(sendMsg) {
                let _this = this;
                let params = {
                    interfaceId: 'be918bc04ac814d6cf0612ce6c9b6ca8',
                    WARN_SOURCE: '5',
                    POINT_TYPES: _this.params.polluteType.join("、") || '0',
                    WARN_TIME: (_this.params.warnTime || utils.timeFormat(new Date(), 'yyyy-MM-dd')) + ' 00:00:00',
                    REGION_CODE: _this.params.region,
                    CODE_REGION: _this.params.region,
                }
                http.getSuperviseGet(params, function (data) {
                    _this.polluteTable = data.data;
                })
                /*$.post("listTable.vm",params,function(data){
                    _this.polluteTable = data.data;
                },'json')*/
                if (sendMsg) {
                    _this.sendMessage('polluteType', params);
                }
            },
            timeChange(sendMsg) {
                this.listRegionTable(sendMsg);
                this.listPointTable(sendMsg);
                this.listSourceTable(sendMsg);
                this.listRadarTable(sendMsg);
                this.listPolluteTable(sendMsg);
            },
            sendMessage(code, params) {
                let data = [
                    {
                        "code": code,
                        "name": "",
                        "defaultValue": "",
                        "shareCode": code,
                        "runtimeValue": JSON.stringify(params),
                    }
                ];
                utils.sendMessage('91156746e8bf9a05a1a92be6473a5704', data);
            },
            location(params) {
                let data = [
                    {
                        "code": 'location',
                        "name": "",
                        "defaultValue": "",
                        "shareCode": 'location',
                        "runtimeValue": JSON.stringify(params),
                    }
                ];
                utils.sendMessage('91156746e8bf9a05a1a92be6473a5704', data);
            }
        }
    })
</script>
</body>
</html>

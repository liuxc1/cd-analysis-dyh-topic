(function($){
var myflow = $.myflow;

$.extend(true,myflow.config.rect,{
	attr : {
	r : 8,
	fill : '#ffffff',
	stroke : '#a0a0a0',
	"stroke-width" : 1
},margin:0
});

$.extend(true,myflow.config.props.props,{
	procKey : {name:'procKey', label:'流程编号', value: 'p_' + new Date().getTime()},
	procName : {name:'procName', label:'流程名称', value:''},
	categoryId : {name:'categoryId', label:'', value:''},
	categoryName : {name:'categoryName', label:'流程分类', value:''},
	sort : {name:'sort', label:'排序', value:''},
	version : {name:'version', label:'版本', value:'1.0'},
	definitionId: {name:'definitionId', label:'', value:''}
});

$.extend(true,myflow.config.tools.states,{
	start : {
				showType: 'image',
				type : 'start',
				name : {text:'<<start>>'},
				text : {text:'开始'},
				img : {src : ctx+'/assets/components/myflow/img/42/start_event_empty.png',width : 42, height:42},
				attr : {width:30 ,height:30 },
				props : {
					id: {name:'id', label: '开始节点ID', value:'', editor: function(){return new myflow.editors.textEditor();}, value:''},
					name: {name:'name', label: '开始节点名称', value:'', editor: function(){return new myflow.editors.textEditor();}, value:''}
				}},
			end : {showType: 'image',type : 'end',
				name : {text:'<<end>>'},
				text : {text:'结束'},
				img : {src :  ctx+'/assets/components/myflow/img/42/end_event_empty.png',width : 42, height:42},
				attr : {width:30 ,height:30 },
				props : {
					id: {name:'id', label: '结束节点ID', value:'', editor: function(){return new myflow.editors.textEditor();}, value:''},
					name: {name:'name', label: '结束节点名称', value:'', editor: function(){return new myflow.editors.textEditor();}, value:''}
					/*text: {name:'text',label: '显示', value:'', editor: function(){return new myflow.editors.textEditor();}, value:'结束'},
					temp1: {name:'temp1', label : '文本', value:'', editor: function(){return new myflow.editors.inputEditor();}},
					temp2: {name:'temp2', label : '选择', value:'', editor: function(){return new myflow.editors.selectEditor([{name:'aaa',value:1},{name:'bbb',value:2}]);}}*/
				}},
			'end-cancel' : {showType: 'image',type : 'end-cancel',
				name : {text:'<<end-cancel>>'},
				text : {text:'取消'},
				img : {src :  ctx+'/assets/components/myflow/img/48/end_event_cancel.png',width : 48, height:48},
				attr : {width:50 ,height:50 },
				props : {
					text: {name:'text',label: '显示', value:'', editor: function(){return new myflow.editors.textEditor();}, value:'取消'},
					temp1: {name:'temp1', label : '文本', value:'', editor: function(){return new myflow.editors.inputEditor();}},
					temp2: {name:'temp2', label : '选择', value:'', editor: function(){return new myflow.editors.selectEditor([{name:'aaa',value:1},{name:'bbb',value:2}]);}}
				}},
			'end-error' : {showType: 'image',type : 'end-error',
				name : {text:'<<end-error>>'},
				text : {text:'错误'},
				img : {src :  ctx+'/assets/components/myflow/img/48/end_event_error.png',width : 48, height:48},
				attr : {width:50 ,height:50 },
				props : {
					text: {name:'text',label: '显示', value:'', editor: function(){return new myflow.editors.textEditor();}, value:'错误'},
					temp1: {name:'temp1', label : '文本', value:'', editor: function(){return new myflow.editors.inputEditor();}},
					temp2: {name:'temp2', label : '选择', value:'', editor: function(){return new myflow.editors.selectEditor([{name:'aaa',value:1},{name:'bbb',value:2}]);}}
				}},
			state : {showType: 'text',type : 'state',
				name : {text:'<<state>>'},
				text : {text:'状态'},
				img : {src :  ctx+'/assets/components/myflow/img/48/task_empty.png',width : 48, height:48},
				props : {
					text: {name:'text',label: '显示', value:'', editor: function(){return new myflow.editors.textEditor();}, value:'状态'},
					temp1: {name:'temp1', label : '文本', value:'', editor: function(){return new myflow.editors.inputEditor();}},
					temp2: {name:'temp2', label : '选择', value:'', editor: function(){return new myflow.editors.selectEditor([{name:'aaa',value:1},{name:'bbb',value:2}]);}}
				}},
			fork : {showType: 'image',type : 'fork',
				name : {text:'<<fork>>'},
				text : {text:'分支'},
				img : {src :  ctx+'/assets/components/myflow/img/42/gateway_exclusive_empty.png',width :42, height:42},
				attr : {width:42 ,height:42 },
				props : {
					id: {name:'id', label: '网关ID', value:'', editor: function(){return new myflow.editors.textEditor();}, value:''},
					name: {name:'name', label: '网关名称', value:'', editor: function(){return new myflow.editors.textEditor();}, value:''}
				}},
			join : {showType: 'image',type : 'join',
				name : {text:'<<join>>'},
				text : {text:'并行'},
				img : {src :  ctx+'/assets/components/myflow/img/42/gateway_parallel_empty.png',width :42, height:42},
				attr : {width:42 ,height:42 },
				props : {
					id: {name:'id', label: '网关ID', value:'', editor: function(){return new myflow.editors.textEditor();}, value:''},
					name: {name:'name', label: '网关名称', value:'', editor: function(){return new myflow.editors.textEditor();}, value:''}
				}},
			include : {showType: 'image',type : 'include',
				name : {text:'<<include>>'},
				text : {text:'包含'},
				img : {src :  ctx+'/assets/components/myflow/img/42/gateway_inclusive_empty.png',width :42, height:42},
				attr : {width:42 ,height:42 },
				props : {
					id: {name:'id', label: '网关ID', value:'', editor: function(){return new myflow.editors.textEditor();}, value:''},
					name: {name:'name', label: '网关名称', value:'', editor: function(){return new myflow.editors.textEditor();}, value:''}
				}},
			task : {showType: 'image&text',type : 'task',
				name : {text:'<<task>>'},
				text : {text:'任务', 'font-size' : 14, fill: '#585858', 'font-weight': 'bold'},
				img : {src :  ctx+'/assets/components/myflow/img/42/task_empty.png',width :20, height:20},
				attr : {width:105 ,height:40, r:5 },
				props : {
					id: {name:'id', label: '节点ID', value:'', editor: function(){return new myflow.editors.textEditor();}, value:''},
					name: {name:'name', label: '节点名称', value:'', editor: function(){return new myflow.editors.textEditor();}, value:''},
					priority: {name:'priority', label: '优先级（为空默认50，数字越小优先级越高）', value:''},
					activiti_assignee: {name:'activiti_assignee', label: '办理人', value:'', editor: function(){return new myflow.editors.textEditor();}, value:''},
					minsloopchar: {name:'minsloopchar', label: '是否会签', value:'', editor: function(){return new myflow.editors.textEditor();}, value:''},
					minsloopchar_issequential: {name:'minsloopchar_issequential', label: '是否顺序办理', value:'', editor: function(){return new myflow.editors.textEditor();}, value:''},
					minsloopchar_activiticollection: {name:'minsloopchar_activiticollection', label: '办理人集合', value:'', editor: function(){return new myflow.editors.textEditor();}, value:''},
					minsloopchar_activitielementvariable: {name:'minsloopchar_activitielementvariable', label: '办理人集合对象', value:'', editor: function(){return new myflow.editors.textEditor();}, value:''},
					minsloopchar_completioncondition: {name:'minsloopchar_completioncondition', label: '通过条件', value:'', editor: function(){return new myflow.editors.textEditor();}, value:''},

					handleType: {name:'handleType', label: '办理类型', value:'', editor: function(){return new myflow.editors.textEditor();}, value:''},
					jzblSelectType: {name:'jzblSelectType', label: '竞争办理选择类型', value:''},
					handleUser: {name:'handleUser', label: '办理人', value:'', editor: function(){return new myflow.editors.textEditor();}, value:''},
					timeLimit: {name:'timeLimit', label: '办理时限', value:'', editor: function(){return new myflow.editors.textEditor();}, value:''},
					handleOperate: {name:'handleOperate', label: '操作权限', value:'', editor: function(){return new myflow.editors.textEditor();}, value:''},
					formSetting: {name:'formSetting', label: '表单设置', value:''}
				}},
			decision : {showType: 'image',type : 'decision',
                name : {text:'<<decision>>'},
                text : {text:'决定'},
                img : {src :  ctx+'/assets/components/myflow/img/48/gateway_parallel.png',width :48, height:48},
                attr : {width:50 ,height:50 },
                props : {
                    text: {name:'text', label: '显示', value:'', editor: function(){return new myflow.editors.textEditor();}, value:'决定'},
                    expr: {name:'expr', label : '表达式', value:'', editor: function(){return new myflow.editors.inputEditor();}},
                    desc: {name:'desc', label : '描述', value:'', editor: function(){return new myflow.editors.inputEditor();}}
                }},
            subprocess : {showType: 'image&text',type : 'subprocess',
    				name : {text:'<<subprocess>>'},
    				text : {text:'子流程', 'font-size' : 14, fill: '#585858', 'font-weight': 'bold'},
    				img : {src :  ctx+'/assets/components/myflow/img/16/mi.parallel.png',width :16, height:16},
    				attr : {width:350 ,height:175, fill : '#ffffff', stroke : '#a0a0a0', r: 5 },
    				props : {
    					id: {name:'id', label: '', value:''},
    					name: {name:'name', label: '节点名称', value:''},
    					minsloopchar_issequential: {name:'minsloopchar_issequential', label: '是否顺序办理', value:'false'},
    					minsloopchar_activiticollection: {name:'minsloopchar_activiticollection', label: '办理人集合', value:''},
    					minsloopchar_activitielementvariable: {name:'minsloopchar_activitielementvariable', label: '办理人集合对象', value:''},
    					minsloopchar_completioncondition: {name:'minsloopchar_completioncondition', label: '通过条件', value:''},
    				}}
});
})(jQuery);
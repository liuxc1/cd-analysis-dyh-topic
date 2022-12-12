(function($) {

	var myflow = {};
	//全局states集合 add by lixinda 2017-04-13
	myflow.global = {states: []};

	myflow.config = {
		onlyView : true, //仅查看状态设置，默认为true，在editable=false时起作用 add by lixinda 2017-04-24
		editable : true,
		lineHeight : 15,
		basePath : '',
		rect : {// 状态
			attr : {
				x : 10,
				y : 10,
				width : 105,
				height : 55,
				r : 5,
				fill : '90-#fff-#C0C0C0',
				stroke : '#000',
				"stroke-width" : 1
			},
			showType : 'image&text',// image,text,image&text
			type : 'state',
			name : {
				text : 'state',
				'font-style' : 'italic'
			},
			text : {
				text : '状态',
				'font-size' : 13
			},
			margin : 5,
			props : [],
			img : {}
		},
		path : {// 路径转换
			attr : {
				path : {
					path : 'M10 10L100 100',
					stroke : '#808080',
					fill : "none",
					"stroke-width" : 1.5
				},
				arrow : {
					path : 'M10 10L10 10',
					stroke : '#808080',
					fill : "#808080",
					"stroke-width" : 1,
					radius : 4
				},
				fromDot : {
					width : 5,
					height : 5,
					stroke : '#fff',
					fill : '#000',
					cursor : "move",
					"stroke-width" : 1
				},
				toDot : {
					width : 5,
					height : 5,
					stroke : '#fff',
					fill : '#000',
					cursor : "move",
					"stroke-width" : 1
				},
				bigDot : {
					width : 5,
					height : 5,
					stroke : '#fff',
					fill : '#000',
					cursor : "move",
					"stroke-width" : 1
				},
				smallDot : {
					width : 5,
					height : 5,
					stroke : '#fff',
					fill : '#000',
					cursor : "move",
					"stroke-width" : 1
				},
				text : {
				    cursor : "move",
                    'background' : '#000'
				}
			},
			text : {
				patten : '',//安建华：去掉了新建时候显示的内容  TO {to}
				textPos : {
                    x : 0,
                    y : -10
                }
			},
			// 安建华：连线显示的字段行
			props : {
				id : {
					name : 'id',
					label : '连线ID',
					value : '',
					editor : function() {
						return new myflow.editors.textEditor();
					}
				},
				name : {
					name : 'name',
					label : '连线名称',
					value : '',
					editor : function() {
						return new myflow.editors.textEditor();
					}
				},
				path_completioncondition : {
					name : 'path_completioncondition',
					label : '条件',
					value : '',
					editor : function() {
						return new myflow.editors.textEditor();
					}
				}
			}
		},
		tools : {// 工具栏
			attr : {
				left : 10,
				top : 10
			},
			pointer : {},
			path : {},
			states : {},
			save : {
				onclick : function(data) {
				
				}
			}
		},
		props : {// 属性编辑器
			attr : {
				top : 10,
				right : 30
			},
			props : {}
		},
		restore : '',
		activeRects : {// 当前激活状态
			rects : [],
			rectAttr : {
				stroke : '#ff0000',
				"stroke-width" : 1
			}
		},
		historyRects : {// 历史激活状态
			rects : [],
			pathAttr : {
				path : {
					stroke : '#00ff00'
				},
				arrow : {
					stroke : '#00ff00',
					fill : "#00ff00"
				}
			},
			rectAttr : {
				stroke : '#00ff00',
				"stroke-width" : 1
			}
		}
	};

	myflow.util = {
		isLine : function(p1, p2, p3) {// 三个点是否在一条直线上
			var s, p2y;
			if ((p1.x - p3.x) == 0)
				s = 1;
			else
				s = (p1.y - p3.y) / (p1.x - p3.x);
			p2y = (p2.x - p3.x) * s + p3.y;
			// $('body').append(p2.y+'-'+p2y+'='+(p2.y-p2y)+', ');
			if ((p2.y - p2y) < 10 && (p2.y - p2y) > -10) {
				p2.y = p2y;
				return true;
			}
			return false;
		},
		center : function(p1, p2) {// 两个点的中间点
			return {
				x : (p1.x - p2.x) / 2 + p2.x,
				y : (p1.y - p2.y) / 2 + p2.y
			};
		},
		nextId : (function() {
			var uid = 0;
			return function() {
				return ++uid;
			};
		})(),
		textId : (function() {
			var uids = {};
			return function(type) {
				if(!uids[type]){
					uids[type] = 0;
				}
				uids[type] = ++uids[type];
				return uids[type];
			};
		})(),

		connPoint : function(rect, p) {// 计算矩形中心到p的连线与矩形的交叉点
			var start = p, end = {
				x : rect.x + rect.width / 2,
				y : rect.y + rect.height / 2
			};
			// 计算正切角度
			var tag = (end.y - start.y) / (end.x - start.x);
			tag = isNaN(tag) ? 0 : tag;

			var rectTag = rect.height / rect.width;
			// 计算箭头位置
			var xFlag = start.y < end.y ? -1 : 1, yFlag = start.x < end.x
					? -1
					: 1, arrowTop, arrowLeft;
			// 按角度判断箭头位置
			if (Math.abs(tag) > rectTag && xFlag == -1) {// top边
				arrowTop = end.y - rect.height / 2;
				arrowLeft = end.x + xFlag * rect.height / 2 / tag;
			} else if (Math.abs(tag) > rectTag && xFlag == 1) {// bottom边
				arrowTop = end.y + rect.height / 2;
				arrowLeft = end.x + xFlag * rect.height / 2 / tag;
			} else if (Math.abs(tag) < rectTag && yFlag == -1) {// left边
				arrowTop = end.y + yFlag * rect.width / 2 * tag;
				arrowLeft = end.x - rect.width / 2;
			} else if (Math.abs(tag) < rectTag && yFlag == 1) {// right边
				arrowTop = end.y + rect.width / 2 * tag;
				arrowLeft = end.x + rect.width / 2;
			}
			return {
				x : arrowLeft,
				y : arrowTop
			};
		},

		arrow : function(p1, p2, r) {// 画箭头，p1 开始位置,p2 结束位置, r前头的边长
			var atan = Math.atan2(p1.y - p2.y, p2.x - p1.x) * (180 / Math.PI);

			var centerX = p2.x - r * Math.cos(atan * (Math.PI / 180));
			var centerY = p2.y + r * Math.sin(atan * (Math.PI / 180));

			var x2 = centerX + r * Math.cos((atan + 120) * (Math.PI / 180));
			var y2 = centerY - r * Math.sin((atan + 120) * (Math.PI / 180));

			var x3 = centerX + r * Math.cos((atan + 240) * (Math.PI / 180));
			var y3 = centerY - r * Math.sin((atan + 240) * (Math.PI / 180));
			return [p2, {
						x : x2,
						y : y2
					}, {
						x : x3,
						y : y3
					}];
		}
	}

	myflow.rect = function(o, r) {
		var _this = this, _uid = myflow.util.nextId(), _o = $.extend(true, {},
				myflow.config.rect, o), _id = 'rect' + _uid, _r = r, // Raphael画笔
		_rect, _img, // 图标
		_name, // 状态名称
		_text, // 显示文本
		_omsx, _omsy, // 父层拖动时，保存子元素起点位置  add by lixinda 2017-04-18
		_ox, _oy; // 拖动时，保存起点位置;
		_o.text.text += myflow.util.textId(_o.type);
		//初始化text值
		if(_o.props.name){
			_o.props.name.value = _o.text.text;
		}
		/*console.log(myflow.config.rect);
		console.log(o);*/
		var cprops = {pt: _id};
		
		_rect = _r.rect(_o.attr.x, _o.attr.y, _o.attr.width, _o.attr.height,
				_o.attr.r, cprops).hide().attr(_o.attr);

		_img = _r.image(myflow.config.basePath + _o.img.src,
				_o.attr.x + _o.img.width / 2,
				_o.attr.y + (_o.attr.height - _o.img.height) / 2, _o.img.width,
				_o.img.height, cprops).hide();
		_name = _r.text(
				_o.attr.x + _o.img.width + (_o.attr.width - _o.img.width) / 2,
				_o.attr.y + myflow.config.lineHeight / 2, _o.name.text, cprops).hide()
				.attr(_o.name);
		_text = _r.text(
				_o.attr.x + _o.img.width + (_o.attr.width - _o.img.width) / 2,
				_o.attr.y + (_o.attr.height - myflow.config.lineHeight) / 2
						+ myflow.config.lineHeight, _o.text.text, cprops).hide()
				.attr(_o.text);// 文本

		// 拖动处理----------------------------------------
		_rect.drag(function(dx, dy) {
					dragMove(dx, dy);
				}, function() {
					dragStart()
				}, function() {
					dragUp();
				});
		_img.drag(function(dx, dy) {
					dragMove(dx, dy);
				}, function() {
					dragStart()
				}, function() {
					dragUp();
				});
		_name.drag(function(dx, dy) {
					dragMove(dx, dy);
				}, function() {
					dragStart()
				}, function() {
					dragUp();
				});
		_text.drag(function(dx, dy) {
					dragMove(dx, dy);
				}, function() {
					dragStart()
				}, function() {
					dragUp();
				});

		var dragMove = function(dx, dy) {// 拖动中
			if (!myflow.config.editable)
				return;

			var x = (_ox + dx);// -((_ox+dx)%10);
			var y = (_oy + dy);// -((_oy+dy)%10);

			_bbox.x = x - _o.margin;
			_bbox.y = y - _o.margin;
			// subprocess拖动中时，通知子元素开始移动 add by lixinda 2017-04-13
			if(_o.type == 'subprocess'){
				for(var i in myflow.global.states){
					if(myflow.global.states[i].o && myflow.global.states[i].o().props.parentNodeId){ //rect
						var parentNodeId = myflow.global.states[i].o().props.parentNodeId.value;
						if(_o.props.id && parentNodeId != "" && parentNodeId == _o.props.id.value){
							myflow.global.states[i].subResize(dx, dy);
						}
					}
				}
			}
			resize();
		};

		var dragStart = function() {// 开始拖动
			_ox = _rect.attr("x");
			_oy = _rect.attr("y");
			_rect.attr({
						opacity : 0.5
					});
			_img.attr({
						opacity : 0.5
					});
			_text.attr({
						opacity : 0.5
					});
		};

		var dragUp = function() {// 拖动结束
			_rect.attr({
						opacity : 1
					});
			_img.attr({
						opacity : 1
					});
			_text.attr({
						opacity : 1
					});
			// subprocess拖动结束时，通知子元素结束 add by lixinda 2017-04-13
			if(_o.type == 'subprocess'){
				for(var i in myflow.global.states){
					if(myflow.global.states[i].o && myflow.global.states[i].o().props.parentNodeId){ //rect
						var parentNodeId = myflow.global.states[i].o().props.parentNodeId.value;
						if(_o.props.id && parentNodeId != "" && parentNodeId == _o.props.id.value){
							myflow.global.states[i].subResizeOver();
						}
					}
				}
			}
			_this.isOnParentRect();
		};

		// 改变大小的边框
		var _bpath, _bdots = {}, _bw = 5, _bbox = {
			x : _o.attr.x - _o.margin,
			y : _o.attr.y - _o.margin,
			width : _o.attr.width + _o.margin * 2,
			height : _o.attr.height + _o.margin * 2
		};

		_bpath = _r.path('M0 0L1 1', cprops).hide();
		_bdots['t'] = _r.rect(0, 0, _bw, _bw, 0, cprops).attr({
					fill : '#000',
					stroke : '#fff',
					cursor : 's-resize'
				}).hide().drag(function(dx, dy) {
					bdragMove(dx, dy, 't');
				}, function() {
					bdragStart(this.attr('x') + _bw / 2, this.attr('y') + _bw
									/ 2, 't');
				}, function() {
				});// 上
		_bdots['lt'] = _r.rect(0, 0, _bw, _bw, 0, cprops).attr({
					fill : '#000',
					stroke : '#fff',
					cursor : 'nw-resize'
				}).hide().drag(function(dx, dy) {
					bdragMove(dx, dy, 'lt');
				}, function() {
					bdragStart(this.attr('x') + _bw / 2, this.attr('y') + _bw
									/ 2, 'lt');
				}, function() {
				});// 左上
		_bdots['l'] = _r.rect(0, 0, _bw, _bw, 0, cprops).attr({
					fill : '#000',
					stroke : '#fff',
					cursor : 'w-resize'
				}).hide().drag(function(dx, dy) {
					bdragMove(dx, dy, 'l');
				}, function() {
					bdragStart(this.attr('x') + _bw / 2, this.attr('y') + _bw
									/ 2, 'l');
				}, function() {
				});// 左
		_bdots['lb'] = _r.rect(0, 0, _bw, _bw, 0, cprops).attr({
					fill : '#000',
					stroke : '#fff',
					cursor : 'sw-resize'
				}).hide().drag(function(dx, dy) {
					bdragMove(dx, dy, 'lb');
				}, function() {
					bdragStart(this.attr('x') + _bw / 2, this.attr('y') + _bw
									/ 2, 'lb');
				}, function() {
				});// 左下
		_bdots['b'] = _r.rect(0, 0, _bw, _bw, 0, cprops).attr({
					fill : '#000',
					stroke : '#fff',
					cursor : 's-resize'
				}).hide().drag(function(dx, dy) {
					bdragMove(dx, dy, 'b');
				}, function() {
					bdragStart(this.attr('x') + _bw / 2, this.attr('y') + _bw
									/ 2, 'b');
				}, function() {
				});// 下
		_bdots['rb'] = _r.rect(0, 0, _bw, _bw, 0, cprops).attr({
					fill : '#000',
					stroke : '#fff',
					cursor : 'se-resize'
				}).hide().drag(function(dx, dy) {
					bdragMove(dx, dy, 'rb');
				}, function() {
					bdragStart(this.attr('x') + _bw / 2, this.attr('y') + _bw
									/ 2, 'rb');
				}, function() {
				});// 右下
		_bdots['r'] = _r.rect(0, 0, _bw, _bw, 0, cprops).attr({
					fill : '#000',
					stroke : '#fff',
					cursor : 'w-resize'
				}).hide().drag(function(dx, dy) {
					bdragMove(dx, dy, 'r');
				}, function() {
					bdragStart(this.attr('x') + _bw / 2, this.attr('y') + _bw
									/ 2, 'r')
				}, function() {
				});// 右
		_bdots['rt'] = _r.rect(0, 0, _bw, _bw, 0, cprops).attr({
					fill : '#000',
					stroke : '#fff',
					cursor : 'ne-resize'
				}).hide().drag(function(dx, dy) {
					bdragMove(dx, dy, 'rt');
				}, function() {
					bdragStart(this.attr('x') + _bw / 2, this.attr('y') + _bw
									/ 2, 'rt')
				}, function() {
				});// 右上
		$([_bdots['t'].node,_bdots['lt'].node,_bdots['l'].node,_bdots['lb'].node,_bdots['b'].node,_bdots['rb'].node,_bdots['r'].node,_bdots['rt'].node]).click(function(){return false;});

		//改变任务窗口大小
		var bdragMove = function(dx, dy, t) {
			if (!myflow.config.editable)
				return;
			var x = _bx + dx, y = _by + dy;
			switch (t) {
				case 't' :
					_bbox.height += _bbox.y - y;
					_bbox.y = y;
					break;
				case 'lt' :
					_bbox.width += _bbox.x - x;
					_bbox.height += _bbox.y - y;
					_bbox.x = x;
					_bbox.y = y;
					break;
				case 'l' :
					_bbox.width += _bbox.x - x;
					_bbox.x = x;
					break;
				case 'lb' :
					_bbox.height = y - _bbox.y;
					_bbox.width += _bbox.x - x;
					_bbox.x = x;
					break;
				case 'b' :
					_bbox.height = y - _bbox.y;
					break;
				case 'rb' :
					_bbox.height = y - _bbox.y;
					_bbox.width = x - _bbox.x;
					break;
				case 'r' :
					_bbox.width = x - _bbox.x;
					break;
				case 'rt' :
					_bbox.width = x - _bbox.x;
					_bbox.height += _bbox.y - y;
					_bbox.y = y;
					break;
			}
			resize();
			// $('body').append(t);
		};
		var bdragStart = function(ox, oy, t) {
			_bx = ox;
			_by = oy;
		};

		// 事件处理--------------------------------
		$([_rect.node, _text.node, _name.node, _img.node]).bind('click',
				function() {
					if (!myflow.config.editable && myflow.config.onlyView)
						return;
					showBox();
					var mod = $(_r).data('mod');
					switch (mod) {
						case 'pointer' :
							break;
						case 'path' :
							var pre = $(_r).data('currNode');
							if (pre && pre.getId() != _id
									&& pre.getId().substring(0, 4) == 'rect') {
								$(_r).trigger('addpath', [pre, _this]);
							}
							break;
					}
					$(_r).trigger('click', _this);
					$(_r).data('currNode', _this);
					//安建华，增加了点击弹出自定义属性页面的方法（任务）
					openProperty(_o,_o.props,_text,_this, _img);
					return false;
				});

		var clickHandler = function(e, src) {
			if (!myflow.config.editable && myflow.config.onlyView)
				return;
			if (src.getId() == _id) {
				$(_r).trigger('showprops', [_o.props, src]);
			} else {
				hideBox();
			}
		};
		$(_r).bind('click', clickHandler);

		var textchangeHandler = function(e, text, src) {
			if (src.getId() == _id) {
				//console.log(src);
				//console.log(e);
				//alert(text);
				_text.attr({
							text : text
						});
			}
		};
		$(_r).bind('textchange', textchangeHandler);

		// 私有函数-----------------------
		// 边框路径
		function getBoxPathString() {
			return 'M' + _bbox.x + ' ' + _bbox.y + 'L' + _bbox.x + ' '
					+ (_bbox.y + _bbox.height) + 'L' + (_bbox.x + _bbox.width)
					+ ' ' + (_bbox.y + _bbox.height) + 'L'
					+ (_bbox.x + _bbox.width) + ' ' + _bbox.y + 'L' + _bbox.x
					+ ' ' + _bbox.y;
		}
		// 显示边框
		function showBox() {
			_bpath.show();
			for (var k in _bdots) {
				_bdots[k].show();
			}
		}
		// 隐藏
		function hideBox() {
			_bpath.hide();
			for (var k in _bdots) {
				_bdots[k].hide();
			}
		}
		
		this.subResizeOver = function(){
			_omsx = null;
			_omsy = null;
		};
		
		this.subResize = function(dx, dy){
			if(_omsx == null){
				_omsx = _bbox.x;
				_omsy = _bbox.y;
			}
			var rx = _omsx + _o.margin + dx, ry = _omsy + _o.margin + dy, rw = _bbox.width
			- _o.margin * 2, rh = _bbox.height - _o.margin * 2;
			_bbox.x = rx;
			_bbox.y = ry;
			
			_rect.attr({
				x : rx,
				y : ry,
				width : rw,
				height : rh
			});
			switch (_o.showType) {
				case 'image' :
					_img.attr({
								x : rx + (rw - _o.img.width) / 2,
								y : ry + (rh - _o.img.height) / 2
							}).show();
					break;
				case 'text' :
					_rect.show();
					_text.attr({
								x : rx + rw / 2,
								y : ry + rh / 2
							}).show();// 文本
					break;
				case 'image&text' :
					_rect.show();
					/*_name.attr({
								x : rx + _o.img.width + (rw - _o.img.width) / 2,
								y : ry + myflow.config.lineHeight / 2
							}).show();*/
					_text.attr({
						x : rx + rw / 2,
						y : ry + (rh - myflow.config.lineHeight) / 2
								+ myflow.config.lineHeight
					}).show();// 文本	
					_img.attr({
						x : rx + _o.img.width/3 ,
						y : ry + _o.img.height/3
							}).show();
					break;
			}
			_bdots['t'].attr({
				x : _bbox.x + _bbox.width / 2 - _bw / 2,
				y : _bbox.y - _bw / 2
			});// 上
			_bdots['lt'].attr({
						x : _bbox.x - _bw / 2,
						y : _bbox.y - _bw / 2
					});// 左上
			_bdots['l'].attr({
						x : _bbox.x - _bw / 2,
						y : _bbox.y - _bw / 2 + _bbox.height / 2
					});// 左
			_bdots['lb'].attr({
						x : _bbox.x - _bw / 2,
						y : _bbox.y - _bw / 2 + _bbox.height
					});// 左下
			_bdots['b'].attr({
						x : _bbox.x - _bw / 2 + _bbox.width / 2,
						y : _bbox.y - _bw / 2 + _bbox.height
					});// 下
			_bdots['rb'].attr({
						x : _bbox.x - _bw / 2 + _bbox.width,
						y : _bbox.y - _bw / 2 + _bbox.height
					});// 右下
			_bdots['r'].attr({
						x : _bbox.x - _bw / 2 + _bbox.width,
						y : _bbox.y - _bw / 2 + _bbox.height / 2
					});// 右
			_bdots['rt'].attr({
						x : _bbox.x - _bw / 2 + _bbox.width,
						y : _bbox.y - _bw / 2
					});// 右上
			_bpath.attr({
						path : getBoxPathString()
					});
		
			$(_r).trigger('rectresize', _this);
		};
		
		/**
		 * 判断rect是否包含在子流程中，add by lixinda 2017-04-13
		 */
		this.isOnParentRect = function(){
			if(_o.type != 'subprocess'){
				for(var i in myflow.global.states){
					if(myflow.global.states[i].o && myflow.global.states[i].o().type == 'subprocess'){ //subprocess rect
						var stateBBox = myflow.global.states[i].getBBox();
						if(_rect.attr("x") >= stateBBox.x && _rect.attr("x") + _rect.attr("width") <= stateBBox.x + stateBBox.width
								&& _rect.attr("y") >= stateBBox.y && _rect.attr("y") + _rect.attr("height") <= stateBBox.y + stateBBox.height){
							if(!myflow.global.states[i].o().props.id){
								myflow.global.states[i].o().props.id = {value: myflow.global.states[i].getId()};
							}
							_o.props.parentNodeId = {value: myflow.global.states[i].o().props.id.value};
						}else{
							_o.props.parentNodeId = {value: ""};
						}
					}
				}
			}
		};
		
		// 根据_bbox，更新位置信息
		function resize() {
			var rx = _bbox.x + _o.margin, ry = _bbox.y + _o.margin, rw = _bbox.width
					- _o.margin * 2, rh = _bbox.height - _o.margin * 2;
			
			_rect.attr({
						x : rx,
						y : ry,
						width : rw,
						height : rh
					});
			
			switch (_o.showType) {
				case 'image' :
					_img.attr({
								x : rx + (rw - _o.img.width) / 2,
								y : ry + (rh - _o.img.height) / 2
							}).show();
					break;
				case 'text' :
					_rect.show();
					_text.attr({
								x : rx + rw / 2,
								y : ry + rh / 2
							}).show();// 文本
					break;
				case 'image&text' :
					_rect.show();
					/*_name.attr({
								x : rx + _o.img.width + (rw - _o.img.width) / 2,
								y : ry + myflow.config.lineHeight / 2
							}).show();*/
					//子流程文本垂直居上  add by lixinda 2017-04-13
					if(o.type == 'subprocess'){ 
						_text.attr({
							x : rx + rw / 2,
							y : ry + myflow.config.lineHeight
						}).show();// 文本
						_img.attr({
							x : rx + rw / 2 - _o.img.width/2,
							y : ry + rh - _o.img.height - 4
						}).show();
					}else{
						_text.attr({
							x : rx + rw / 2,
							y : ry + (rh - myflow.config.lineHeight) / 2
									+ myflow.config.lineHeight
						}).show();// 文本
						_img.attr({
							x : rx + _o.img.width/3 ,
							y : ry + _o.img.height/3
						}).show();
					}
					break;
			}

			_bdots['t'].attr({
						x : _bbox.x + _bbox.width / 2 - _bw / 2,
						y : _bbox.y - _bw / 2
					});// 上
			_bdots['lt'].attr({
						x : _bbox.x - _bw / 2,
						y : _bbox.y - _bw / 2
					});// 左上
			_bdots['l'].attr({
						x : _bbox.x - _bw / 2,
						y : _bbox.y - _bw / 2 + _bbox.height / 2
					});// 左
			_bdots['lb'].attr({
						x : _bbox.x - _bw / 2,
						y : _bbox.y - _bw / 2 + _bbox.height
					});// 左下
			_bdots['b'].attr({
						x : _bbox.x - _bw / 2 + _bbox.width / 2,
						y : _bbox.y - _bw / 2 + _bbox.height
					});// 下
			_bdots['rb'].attr({
						x : _bbox.x - _bw / 2 + _bbox.width,
						y : _bbox.y - _bw / 2 + _bbox.height
					});// 右下
			_bdots['r'].attr({
						x : _bbox.x - _bw / 2 + _bbox.width,
						y : _bbox.y - _bw / 2 + _bbox.height / 2
					});// 右
			_bdots['rt'].attr({
						x : _bbox.x - _bw / 2 + _bbox.width,
						y : _bbox.y - _bw / 2
					});// 右上
			_bpath.attr({
						path : getBoxPathString()
					});

			$(_r).trigger('rectresize', _this);
		};

		// 函数----------------
		// 转化json字串
		this.toJson = function() {
			var data = "{≡type≡:≡" + _o.type + "≡,≡text≡:{≡text≡:≡"
					+ _text.attr('text') + "≡}, ≡attr≡:{ ≡x≡:"
					+ Math.round(_rect.attr('x')) + ", ≡y≡:"
					+ Math.round(_rect.attr('y')) + ", ≡width≡:"
					+ Math.round(_rect.attr('width')) + ", ≡height≡:"
					+ Math.round(_rect.attr('height')) + "}, ≡props≡:{";
			for (var k in _o.props) {
				data += "≡"+k+"≡" + ":{≡value≡:≡"
						+ _o.props[k].value + "≡},";
			}
			if (data.substring(data.length - 1, data.length) == ',')
				data = data.substring(0, data.length - 1);
			data += "}}";
			return data;
		};
		// 从数据中恢复图
		this.restore = function(data) {
			var obj = data;
			// if (typeof data === 'string')
			// obj = eval(data);
			_o = $.extend(true, _o, data);
			_text.attr({
						text : obj.text.text
					});
			_text.attr({
				text : obj.text.text
			});
			resize();
		};

		this.getBBox = function() {
			return _bbox;
		};
		this.setBBox = function(bbox){
			_bbox = bbox;
		}
		this.getId = function() {
			return _id;
		};
		this.getPropsId = function() {
			var propsId;
			for (var k in _o.props) {
				if(k=='id'){
					propsId = _o.props[k].value;
				}
			}
			return propsId;
		};
		this.setPropsId = function(id) {
			var propsId;
			for (var k in _o.props) {
				if(k=='id'){
					if(_o.props[k].value==''){
						_o.props[k].value=_o.type + "_" + id;
					}
				}
			}
		};
		this.remove = function() {
			_rect.remove();
			_text.remove();
			_name.remove();
			_img.remove();
			_bpath.remove();
			for (var k in _bdots) {
				_bdots[k].remove();
			}
		};
		this.text = function() {
			return _text.attr('text');
		};
		this.o = function(){
			return _o;
		};
		this.attr = function(attr) {
			if (attr)
				_rect.attr(attr);
		};
		this.getRect = function(){
			return _rect;
		};
		//以下为控件闪烁效果实现，add by lixinda 2017-04-21
		var hasAnimate = false, isShow = false;
		this.animate = function(){
			if(hasAnimate){
				return;
			}
			hasAnimate = true;
			setInterval(function(){
			    if(isShow){
			    	_rect.show();
			    	_img.show();
			    	_text.show();
			    	isShow = false;    
			    }else{
			    	isShow = true;
			    	_rect.hide();
			    	_img.hide();
			    	_text.hide();
			    }
			},500);
		};
		
		//移动子流程所有元素的位置到最底层 add by lixinda 2017-04-14
		if(_o.type == 'subprocess'){
			if(_r.canvas.nodeName == 'svg'){ //svg
				var rmNodes = [];
				for(var i in _r.canvas.childNodes){
					if(typeof(_r.canvas.childNodes[i]) == 'object' && $(_r.canvas.childNodes[i]).attr("pt") == _id){
						rmNodes.push(_r.canvas.childNodes[i]);
					}
				}
				rmNodes.reverse();
				for(var i = 0; i < rmNodes.length; i++){
					_r.canvas.removeChild(rmNodes[i]);
					$(rmNodes[i]).insertAfter($(_r.canvas).children().eq(1));
				}
			}else if(_r.canvas.nodeName == 'DIV'){ //vml IE TODO 待完善
				var rmNodes = [];
				for(var i in _r.canvas.childNodes){
					if(_r.canvas.childNodes[i].nodeName == 'group' && _r.canvas.childNodes[i].pt == _id){
						rmNodes.push(_r.canvas.childNodes[i]);
					}
				}
				rmNodes.reverse();
				for(var i = 0; i < rmNodes.length; i++){
					_r.canvas.removeChild(rmNodes[i]);
					$(rmNodes[i]).insertAfter($(_r.canvas).children().eq(0));
				}
			}
		}
		
		resize();// 初始化位置
	};

	myflow.path = function(o, r, from, to) {
		var _this = this, _r = r, _o = $.extend(true, {}, myflow.config.path), _path, _arrow, _text, _textPos = _o.text.textPos, _ox, _oy, _from = from, _to = to, _id = 'path'
				+ myflow.util.nextId(), _dotList, _autoText = true, _textPosX, _textPosY;

		// 点
		function dot(type, pos, left, right) {
			var _this = this, _t = type, _n, _lt = left, _rt = right, _ox, _oy, // 缓存移动前时位置
			_pos = pos;// 缓存位置信息{x,y}, 注意：这是计算出中心点

			switch (_t) {
				case 'from' :
					_n = _r.rect(pos.x - _o.attr.fromDot.width / 2,
							pos.y - _o.attr.fromDot.height / 2,
							_o.attr.fromDot.width, _o.attr.fromDot.height)
							.attr(_o.attr.fromDot);
					break;
				case 'big' :
					_n = _r.rect(pos.x - _o.attr.bigDot.width / 2,
							pos.y - _o.attr.bigDot.height / 2,
							_o.attr.bigDot.width, _o.attr.bigDot.height)
							.attr(_o.attr.bigDot);
					break;
				case 'small' :
					_n = _r.rect(pos.x - _o.attr.smallDot.width / 2,
							pos.y - _o.attr.smallDot.height / 2,
							_o.attr.smallDot.width, _o.attr.smallDot.height)
							.attr(_o.attr.smallDot);
					break;
				case 'to' :
					_n = _r.rect(pos.x - _o.attr.toDot.width / 2,
							pos.y - _o.attr.toDot.height / 2,
							_o.attr.toDot.width, _o.attr.toDot.height)
							.attr(_o.attr.toDot);

					break;
			}
			if (_n && (_t == 'big' || _t == 'small')) {
				_n.drag(function(dx, dy) {
							dragMove(dx, dy);
						}, function() {
							dragStart()
						}, function() {
							dragUp();
						});// 初始化拖动
				var dragMove = function(dx, dy) {// 拖动中
					if (!myflow.config.editable)
						return;
					var x = (_ox + dx), y = (_oy + dy);
					_this.moveTo(x, y);
				};

				var dragStart = function() {// 开始拖动
					if (_t == 'big') {
						_ox = _n.attr("x") + _o.attr.bigDot.width / 2;
						_oy = _n.attr("y") + _o.attr.bigDot.height / 2;
					}
					if (_t == 'small') {
						_ox = _n.attr("x") + _o.attr.smallDot.width / 2;
						_oy = _n.attr("y") + _o.attr.smallDot.height / 2;
					}
				};

				var dragUp = function() {// 拖动结束

				};
			}
			$(_n.node).click(function(){return false;});

			this.type = function(t) {
				if (t)
					_t = t;
				else
					return _t;
			};
			this.node = function(n) {
				if (n)
					_n = n;
				else
					return _n;
			};
			this.left = function(l) {
				if (l)
					_lt = l;
				else
					return _lt;
			};
			this.right = function(r) {
				if (r)
					_rt = r;
				else
					return _rt;
			};
			this.remove = function() {
				_lt = null;
				_rt = null;
				_n.remove();
			};
			this.pos = function(pos) {
				if (pos) {
					_pos = pos;
					_n.attr({
								x : _pos.x - _n.attr('width') / 2,
								y : _pos.y - _n.attr('height') / 2
							});
					return this;
				} else {
					return _pos
				}
			};

			this.moveTo = function(x, y) {
				this.pos({
							x : x,
							y : y
						});
				switch (_t) {
					case 'from' :
						if (_rt && _rt.right() && _rt.right().type() == 'to') {
							_rt.right().pos(myflow.util.connPoint(
									_to.getBBox(), _pos));
						}
						if (_rt && _rt.right()) {
							_rt
									.pos(myflow.util.center(_pos, _rt.right()
													.pos()));
						}
						break;
					case 'big' :

						if (_rt && _rt.right() && _rt.right().type() == 'to') {
							_rt.right().pos(myflow.util.connPoint(
									_to.getBBox(), _pos));
						}
						if (_lt && _lt.left() && _lt.left().type() == 'from') {
							_lt.left().pos(myflow.util.connPoint(_from
											.getBBox(), _pos));
						}
						if (_rt && _rt.right()) {
							_rt
									.pos(myflow.util.center(_pos, _rt.right()
													.pos()));
						}
						if (_lt && _lt.left()) {
							_lt.pos(myflow.util.center(_pos, _lt.left().pos()));
						}
						// 三个大点在一条线上，移除中间的小点
						var pos = {
							x : _pos.x,
							y : _pos.y
						};
						if (myflow.util.isLine(_lt.left().pos(), pos, _rt
										.right().pos())) {
							_t = 'small';
							_n.attr(_o.attr.smallDot);
							this.pos(pos);
							var lt = _lt;
							_lt.left().right(_lt.right());
							_lt = _lt.left();
							lt.remove();
							var rt = _rt;
							_rt.right().left(_rt.left());
							_rt = _rt.right();
							rt.remove();
							// $('body').append('ok.');
						}
						break;
					case 'small' :// 移动小点时，转变为大点，增加俩个小点
						if (_lt && _rt && !myflow.util.isLine(_lt.pos(), {
									x : _pos.x,
									y : _pos.y
								}, _rt.pos())) {

							_t = 'big';

							_n.attr(_o.attr.bigDot);
							var lt = new dot('small', myflow.util.center(_lt
													.pos(), _pos), _lt, _lt
											.right());
							_lt.right(lt);
							_lt = lt;

							var rt = new dot('small', myflow.util.center(_rt
													.pos(), _pos), _rt.left(),
									_rt);
							_rt.left(rt);
							_rt = rt;

						}
						break;
					case 'to' :
						if (_lt && _lt.left() && _lt.left().type() == 'from') {
							_lt.left().pos(myflow.util.connPoint(_from
											.getBBox(), _pos));
						}
						if (_lt && _lt.left()) {
							_lt.pos(myflow.util.center(_pos, _lt.left().pos()));
						}
						break;
				}

				refreshpath();
			};
		}

		function dotList() {
			// if(!_from) throw '没有from节点!';
			var _fromDot, _toDot, _fromBB = _from.getBBox(), _toBB = _to
					.getBBox(), _fromPos, _toPos;

			_fromPos = myflow.util.connPoint(_fromBB, {
						x : _toBB.x + _toBB.width / 2,
						y : _toBB.y + _toBB.height / 2
					});
			_toPos = myflow.util.connPoint(_toBB, _fromPos);

			_fromDot = new dot('from', _fromPos, null, new dot('small', {
								x : (_fromPos.x + _toPos.x) / 2,
								y : (_fromPos.y + _toPos.y) / 2
							}));
			_fromDot.right().left(_fromDot);
			_toDot = new dot('to', _toPos, _fromDot.right(), null);
			_fromDot.right().right(_toDot);

			// 转换为path格式的字串
			this.toPathString = function() {
				if (!_fromDot)
					return '';

				var d = _fromDot, p = 'M' + d.pos().x + ' ' + d.pos().y, arr = '';
				// 线的路径
				while (d.right()) {
					d = d.right();
					p += 'L' + d.pos().x + ' ' + d.pos().y;
				}
				// 箭头路径
				var arrPos = myflow.util.arrow(d.left().pos(), d.pos(),
						_o.attr.arrow.radius);
				arr = 'M' + arrPos[0].x + ' ' + arrPos[0].y + 'L' + arrPos[1].x
						+ ' ' + arrPos[1].y + 'L' + arrPos[2].x + ' '
						+ arrPos[2].y + 'z';
				return [p, arr];
			};
			this.toJson = function() {
				var data = "[", d = _fromDot;

				while (d) {
					if (d.type() != 'small'){
						data += "{≡x≡:" + Math.round(d.pos().x) + ",≡y≡:"
						+ Math.round(d.pos().y) + "},";
					}
					d = d.right();
				}
				if (data.substring(data.length - 1, data.length) == ',')
					data = data.substring(0, data.length - 1);
				data += "]";
				return data;
			};
			this.restore = function(data) {
				/*重置_fromDot，折线起始点位置，add by lixinda 2017-04-11*/
				if(data.length > 0){
					_fromPos = {
						x : data[0].x,
						y : data[0].y
					};
					_toPos = {
						x : data[data.length - 1].x,
						y : data[data.length - 1].y
					};
			
					_fromDot = new dot('from', _fromPos, null, new dot('small', {
										x : (_fromPos.x + _toPos.x) / 2,
										y : (_fromPos.y + _toPos.y) / 2
									}));
					_fromDot.right().left(_fromDot);
					_toDot = new dot('to', _toPos, _fromDot.right(), null);
					_fromDot.right().right(_toDot);
				}
				
				var obj = data, d = _fromDot.right();
				//安建华修改于2017年01月18日，去掉了首尾节点
				for (var i = 1; i < obj.length - 1; i++) {
					d.moveTo(obj[i].x, obj[i].y);
					if(d){
						d = d.right();
					}
				}

				this.hide();
			};

			this.fromDot = function() {
				return _fromDot;
			};
			this.toDot = function() {
				return _toDot;
			};
			this.midDot = function() {// 返回中间点
				var mid = _fromDot.right(), end = _fromDot.right().right();
				while (end.right() && end.right().right()) {
					end = end.right().right();
					mid = mid.right();
				}
				return mid;
			};
			this.show = function() {
				var d = _fromDot;
				while (d) {
					d.node().show();
					d = d.right();
				}
			};
			this.hide = function() {
				var d = _fromDot;
				while (d) {
					d.node().hide();
					d = d.right();
				}
			};
			this.remove = function() {
				var d = _fromDot;
				while (d) {
					if (d.right()) {
						d = d.right();
						d.left().remove();
					} else {
						d.remove();
						d = null;
					}
				}
			};
		}

		// 初始化操作
		_o = $.extend(true, _o, o);
		_path = _r.path(_o.attr.path.path).attr(_o.attr.path);
		_arrow = _r.path(_o.attr.arrow.path).attr(_o.attr.arrow);

		_dotList = new dotList();
		_dotList.hide();
		
		_text = _r.text(0, 0, _o.text.text||_o.text.patten.replace('{from}', _from.text()).replace('{to}',
                    _to.text())).attr(_o.attr.text);
		_text.drag(function(dx, dy) {
					if (!myflow.config.editable)
						return;
					_text.attr({
								x : _ox + dx,
								y : _oy + dy
							});
				}, function() {
					_ox = _text.attr('x');
					_oy = _text.attr('y');
				}, function() {
					var mid = _dotList.midDot().pos();
					_textPos = {
						x : _text.attr('x') - mid.x,
						y : _text.attr('y') - mid.y
					};
				});

		refreshpath();// 初始化路径

		// 事件处理--------------------
		$([_path.node, _arrow.node, _text.node]).bind('click', function() {
					if (!myflow.config.editable && myflow.config.onlyView)
						return;
					$(_r).trigger('click', _this);
					//安建华，增加了点击弹出自定义属性页面的方法（连线）
					openProperty(_o,_o.props,_text,_this);
					$(_r).data('currNode', _this);
					return false;
				});

		// 处理点击事件，线或矩形
		var clickHandler = function(e, src) {
			if (!myflow.config.editable && myflow.config.onlyView)
				return;
			if (src && src.getId() == _id) {
				_dotList.show();
				$(_r).trigger('showprops', [_o.props, _this]);
			} else {
				_dotList.hide();
			}

			var mod = $(_r).data('mod');
			switch (mod) {
				case 'pointer' :

					break;
				case 'path' :

					break;
			}

		};
		$(_r).bind('click', clickHandler);

		// 删除事件处理
		var removerectHandler = function(e, src) {
			if (!myflow.config.editable)
				return;
			if (src
					&& (src.getId() == _from.getId() || src.getId() == _to
							.getId())) {
				// _this.remove();
				$(_r).trigger('removepath', _this);
			}
		};
		$(_r).bind('removerect', removerectHandler);

		// 矩形移动时间处理
		var rectresizeHandler = function(e, src) {
			if (!myflow.config.editable)
				return;
			if (_from && _from.getId() == src.getId()) {
				var rp;
				if (_dotList.fromDot().right().right().type() == 'to') {
					rp = {
						x : _to.getBBox().x + _to.getBBox().width / 2,
						y : _to.getBBox().y + _to.getBBox().height / 2
					};
				} else {
					rp = _dotList.fromDot().right().right().pos();
				}
				var p = myflow.util.connPoint(_from.getBBox(), rp);
				_dotList.fromDot().moveTo(p.x, p.y);
				if(_from.o().props.parentNodeId.value != "" && _from.o().props.parentNodeId.value == _to.o().props.parentNodeId.value){
					_o.props.parentNodeId.value = _from.o().props.parentNodeId.value;
				}
				refreshpath();
			}
			if (_to && _to.getId() == src.getId()) {
				var rp;
				if (_dotList.toDot().left().left().type() == 'from') {
					rp = {
						x : _from.getBBox().x + _from.getBBox().width / 2,
						y : _from.getBBox().y + _from.getBBox().height / 2
					};
				} else {
					rp = _dotList.toDot().left().left().pos();
				}
				var p = myflow.util.connPoint(_to.getBBox(), rp);
				_dotList.toDot().moveTo(p.x, p.y);
				if(_from.o().props.parentNodeId && _to.o().props.parentNodeId && _from.o().props.parentNodeId.value != "" 
					&& _from.o().props.parentNodeId.value == _to.o().props.parentNodeId.value){
					_o.props.parentNodeId = {"value" : _from.o().props.parentNodeId.value};
				}
				refreshpath();
			}
		};
		$(_r).bind('rectresize', rectresizeHandler);

		var textchangeHandler = function(e, v, src) {
			if (src.getId() == _id) {// 改变自身文本
				_text.attr({
							text : v
						});
				_autoText = false;
			}
			//$('body').append('['+_autoText+','+_text.attr('text')+','+src.getId()+','+_to.getId()+']');
			if (false) {//安建华20170118修改为false，解决鼠标离开改变原来值得问题
				if (_to.getId() == src.getId()){
					//$('body').append('change!!!');
					_text.attr({
								text : _o.text.patten.replace('{from}',
										_from.text()).replace('{to}', v)
							});
				}
				else if (_from.getId() == src.getId()){
					//$('body').append('change!!!');
					_text.attr({
								text : _o.text.patten.replace('{from}', v)
										.replace('{to}', _to.text())
							});
				}
			}
		};
		$(_r).bind('textchange', textchangeHandler);

		// 函数-------------------------------------------------
		this.from = function() {
			return _from;
		};
		this.to = function() {
			return _to;
		};
		// 转化json数据
		this.toJson = function() {
			var data = "{≡from≡:≡" + _from.getPropsId() + "≡,≡to≡:≡" + _to.getPropsId()
					+ "≡, ≡dots≡:" + _dotList.toJson() + ",≡text≡:{≡text≡:≡"
					+ _text.attr('text') + "≡,≡textPos≡:{≡x≡:"
					+ Math.round(_text.attr('x')) + ",≡y≡:" + Math.round(_text.attr('y'))
					+ ",≡width≡:100,≡height≡:14"
					+ "}}, ≡props≡:{";
			for (var k in _o.props) {
				data += "≡"+k+"≡" + ":{≡value≡:≡"
						+ _o.props[k].value + "≡},";
			}
			if (data.substring(data.length - 1, data.length) == ',')
				data = data.substring(0, data.length - 1);
			data += '}}';
			return data;
		};
		// 恢复
		this.restore = function(data) {
			var obj = data;

			_o = $.extend(true, _o, data);
			//$('body').append('['+_text.attr('text')+','+_o.text.text+']');
			if(_text.attr('text')!=_o.text.text){
				 //$('body').append('['+_text.attr('text')+','+_o.text.text+']');
			     _text.attr({text:_o.text.text});
			     _autoText = false;
			}

			_dotList.restore(obj.dots);
		};
		// 删除
		this.remove = function() {
			_dotList.remove();
			_path.remove();
			_arrow.remove();
			_text.remove();
			try {
				$(_r).unbind('click', clickHandler);
			} catch (e) {
			}
			try {
				$(_r).unbind('removerect', removerectHandler);
			} catch (e) {
			}
			try {
				$(_r).unbind('rectresize', rectresizeHandler);;
			} catch (e) {
			}
			try {
				$(_r).unbind('textchange', textchangeHandler);
			} catch (e) {
			}
		};
		// 刷新路径
		function refreshpath() {
			var p = _dotList.toPathString(), mid = _dotList.midDot().pos();
			/*修改text位置，add by lixinda 2017-04-11*/
			if(_textPos && _textPos.height != null){
				_textPosX = _textPos.x - mid.x;
				_textPosY = _textPos.y - mid.y;
			}else if(_textPosX == null){
				_textPosX = 0;
				_textPosY = 0;
			}
			_path.attr({
						path : p[0]
					});
			_arrow.attr({
						path : p[1]
					});
			_text.attr({
						x : mid.x + _textPosX,
						y : mid.y + _textPosY
					});
			// $('body').append('refresh.');
		}

		this.getId = function() {
			return _id;
		};
		this.getPropsId = function() {
			var propsId;
			for (var k in _o.props) {
				if(k=='id'){
					propsId = _o.props[k].value;
				}
			}
			return propsId;
		};
		
		this.setPropsId = function(id) {
			var propsId;
			for (var k in _o.props) {
				if(k=='id'){
					if(_o.props[k].value==''){
						_o.props[k].value= 'path_' + id;
					}
				}
			}
		};
		
		this.text = function() {
			return _text.attr('text');
		};
		this.attr = function(attr) {
			if (attr && attr.path)
				_path.attr(attr.path);
			if (attr && attr.arrow)
				_arrow.attr(attr.arrow);
			// $('body').append('aaaaaa');
		};

	};

	myflow.props = function(o, r) {
		var _this = this, _pdiv = $('#myflow_props').hide().draggable({
					handle : '#myflow_props_handle'
				}).resizable().css(myflow.config.props.attr).bind('click',
				function() {
					return false;
				}), _tb = _pdiv.find('table'), _r = r, _src;

		var showpropsHandler = function(e, props, src) {
			if (_src && _src.getId() == src.getId()) {// 连续点击不刷新
				return;
			}
			_src = src;
			$(_tb).find('.editor').each(function() {
						var e = $(this).data('editor');
						if (e)
							e.destroy();
					});
			_tb.empty();
			_pdiv.show();
			for (var k in props) {
				if(props[k]&&props[k].label){
					_tb.append('<tr><th>' + props[k].label + '</th><td><div id="p'
							+ k + '" class="editor"></div></td></tr>');
					if (props[k].editor){
						props[k].editor().init(props, k, 'p' + k, src, _r);
					}
				}
				
				// $('body').append(props[i].editor+'a');
			}
		};
		$(_r).bind('showprops', showpropsHandler);

	};

	// 属性编辑器
	myflow.editors = {
		textEditor : function() {
			var _props, _k, _div, _src, _r;
			this.init = function(props, k, div, src, r) {
				_props = props;
				_k = k;
				_div = div;
				_src = src;
				_r = r;
				//安建华：弹出属性窗口初始化
				//1、input框添加了name属性。2、触发属性添加了判断条件，只有name==“name”的输入框改变时候才改变显示值
				$('<input  style="width:100%;" name="'+props[_k].name+'"/>').val(props[_k].value).change(
						function() {
							props[_k].value = $(this).val();
							if($(this).attr("name")=='name'){
								$(_r).trigger('textchange', [$(this).val(), _src]);
							}
						}).appendTo('#' + _div);
				// $('body').append('aaaa');

				$('#' + _div).data('editor', this);
			};
			this.destroy = function() {
				/*$('#' + _div + ' input').each(function() {
							_props[_k].value = $(this).val();
							if($(this).attr("name")=='name'){
								$(_r).trigger('textchange', [$(this).val(), _src]);
							}
						});*/
				// $('body').append('destroy.');
			};
		}
	};

	// 初始化流程
	myflow.init = function(c, o) {
		var _w = $(window).width(), _h = $(window).height(), _r = Raphael(c, _w
						* 1.5, _h * 1.5), _states = {}, _paths = {};
		
		$.extend(true, myflow.config, o.restore);//安建华于2017年01月19日 添加数据的合并
		$.extend(true, myflow.config, o);
		
		
		//alert(myflow.config);

		/**
		 * 删除： 删除状态时，触发removerect事件，连接在这个状态上当路径监听到这个事件，触发removepath删除自身；
		 * 删除路径时，触发removepath事件
		 */
		$(document).keydown(function(arg,deletebutton) {
			if (!myflow.config.editable)
				return;
			if (arg.keyCode == 46||deletebutton==true) {
				var c = $(_r).data('currNode');
				if (c) {
					if (c.getId().substring(0, 4) == 'rect') {
						$(_r).trigger('removerect', c);
					} else if (c.getId().substring(0, 4) == 'path') {
						$(_r).trigger('removepath', c);
					}

					$(_r).removeData('currNode');
				}
				//安建华，添加删除节点或连线时候，隐藏窗口
				$("#myflow_props_custom").hide();
			}
				// alert(arg.keyCode);
			});
		

		$("#myflow").click(function() {
					$(_r).data('currNode', null);
					$(_r).trigger('click', {
								getId : function() {
									return '11';
								}
							});
					$(_r).trigger('showprops', [myflow.config.props.props, {
										getId : function() {
											return '2';
										}
									}]);
					//console.log(myflow.config.props.props);
					//安建华，增加了点击弹出自定义属性页面的方法（流程属性）
					if (!myflow.config.editable && myflow.config.onlyView)
						return;
					openProperty(null,myflow.config.props.props,null,null);
				});

		// 删除事件
		var removeHandler = function(e, src) {
			if (!myflow.config.editable)
				return;
			if (src.getId().substring(0, 4) == 'rect') {
				_states[src.getId()] = null;
				src.remove();
				removeGlobalStates(src.getId());
			} else if (src.getId().substring(0, 4) == 'path') {
				_paths[src.getId()] = null;
				src.remove();
				removeGlobalStates(src.getId());
			}
		};
		$(_r).bind('removepath', removeHandler);
		$(_r).bind('removerect', removeHandler);
		
		//删除集合对象，add by lixinda 2017-04-17
		var removeGlobalStates = function(id){
			for(var i = 0; i < myflow.global.states.length; i++){
				if(id != null && id != "" && myflow.global.states[i].getId() == id){
					myflow.global.states.splice(i, 1);
					break;
				}
			}
		};

		// 添加状态
		$(_r).bind('addrect', function(e, type, o) {
			
			//------------------------
			var rect = new myflow.rect($.extend(true, {},
							myflow.config.tools.states[type], o), _r);
			//安建华：新增的用户任务，添加ID------------
			rect.setPropsId((new Date()).valueOf());
			//---------------------------------
			_states[rect.getId()] = rect;
			myflow.global.states.push(rect);
			rect.isOnParentRect();
			$("#myflow_props_custom").hide();
		});
		// 添加路径
		var addpathHandler = function(e, from, to) {
			//判断from to之间是否有同方向连线，如果不存在进行连线，存在不做操作 add by lixinda 2017-04-17
			var _add_path_flag = true;
			for(var i = 0; i < myflow.global.states.length; i++){
				if(!myflow.global.states[i].o){ //path
					var _check_path = myflow.global.states[i];
					if(from.getId() == _check_path.from().getId() && to.getId() == _check_path.to().getId()){
						_add_path_flag = false;
						break;
					}
				}
			}
			if(_add_path_flag){
				var path = new myflow.path({}, _r, from, to);
				path.setPropsId((new Date()).valueOf());
				_paths[path.getId()] = path;
				myflow.global.states.push(path);
				$("#pointer").click();
			}
		};
		$(_r).bind('addpath', addpathHandler);

		// 模式
		$(_r).data('mod', 'point');
		if (myflow.config.editable) {
			// 工具栏
			$("#myflow_tools").draggable({
						handle : '#myflow_tools_handle'
					}).css(myflow.config.tools.attr);

			$('#myflow_tools .node').hover(function() {
						$(this).addClass('mover');
					}, function() {
						$(this).removeClass('mover');
					});
			$('#myflow_tools .selectable').click(function() {
						$('.selected').removeClass('selected');
						$(this).addClass('selected');
						$(_r).data('mod', this.id);

					});

			$('#myflow_tools .state').each(function() {
						$(this).draggable({
									helper : 'clone'
								});
					});

			$(c).droppable({
						accept : '.state',
						drop : function(event, ui) {
							$(_r).trigger('addrect', [ui.helper.attr('type'), {
												attr : {
													x : ui.helper.offset().left,
													y : ui.helper.offset().top
												}
											}]);
							// $('body').append($(ui).attr('type')+'drop.');
						}
					});

			$('#myflow_save').click(function() {// 保存
				var data = getJsonData();
				submitForm(data,'save');
						//myflow.config.tools.save.onclick(data);
						// alert(data);
			});
			
			$('#deploy_save').click(function() {// 发布
				var data = getJsonData();
				submitForm(data,'deploy');
			});
			
			$('#beautiful_save').click(function() {// 安建华：美化
				var data = getJsonData();
				submitForm(data,'beautiful');
						// alert(data);
			});
			
			function getJsonData(){
				var data = '{≡states≡:{';
				for (var k in _states) {
					if (_states[k]) {
						data +="≡"+ _states[k].getPropsId() + '≡:'
								+ _states[k].toJson() + ',';
					}
				}
				if (data.substring(data.length - 1, data.length) == ','){
					data = data.substring(0, data.length - 1);
				}
				data += '},≡paths≡:{';
				for (var k in _paths) {
					if (_paths[k]) {
						data += '≡'+_paths[k].getPropsId() + '≡:'
								+ _paths[k].toJson() + ',';
					}
				}
				if (data.substring(data.length - 1, data.length) == ','){
					data = data.substring(0, data.length - 1);
				}
				data += '},≡props≡:{≡props≡:{';
				for (var k in myflow.config.props.props) {
					if(myflow.config.props.props[k]){//安建华于2017年1月19日添加判断
						data += "≡"+k+"≡" + ":{≡value≡:≡"
						+ myflow.config.props.props[k].value
						+ "≡},";
					}
				}
				if (data.substring(data.length - 1, data.length) == ',')
					data = data.substring(0, data.length - 1);
				data += '}}}';
				return data;
			}

			// 属性框
			new myflow.props({}, _r);
		}
		// 恢复
		if (o.restore) {
			// var data = ((typeof o.restore === 'string') ? eval(o.restore) :
			// o.restore);
			var data = o.restore;
			var rmap = {};
			if (data.states) {
				for (var k in data.states) {
					var rect = new myflow.rect(
							$
									.extend(
											true,
											{},
											myflow.config.tools.states[data.states[k].type],
											data.states[k]), _r);
					rect.restore(data.states[k]);
					rmap[k] = rect;
					_states[rect.getId()] = rect;
					myflow.global.states.push(rect);
				}
			}
			if (data.paths) {
				for (var k in data.paths) {
					var p = new myflow.path($.extend(true, {},
									myflow.config.tools.path, data.paths[k]),
							_r, rmap[data.paths[k].from],
							rmap[data.paths[k].to]);
					p.restore(data.paths[k]);
					_paths[p.getId()] = p;
					myflow.global.states.push(p);
				}
			}
		}
		// 历史状态
		var hr = myflow.config.historyRects, ar = myflow.config.activeRects;
		if (hr.rects.length || ar.rects.length) {
			var pmap = {}, rmap = {};
			for (var pid in _paths) {// 先组织MAP
				if (!rmap[_paths[pid].from().getPropsId()]) {
					rmap[_paths[pid].from().getPropsId()] = {
						rect : _paths[pid].from(),
						paths : {}
					};
				}
				rmap[_paths[pid].from().getPropsId()].paths[_paths[pid].getPropsId()] = _paths[pid];
				if (!rmap[_paths[pid].to().getPropsId()]) {
					rmap[_paths[pid].to().getPropsId()] = {
						rect : _paths[pid].to(),
						paths : {}
					};
				}
			}
			for (var i = 0; i < hr.rects.length; i++) {
				if (rmap[hr.rects[i].id]) {
					if(rmap[hr.rects[i].id].rect.o().showType == 'image'){ //image显示边框
						var src = rmap[hr.rects[i].id].rect.o();
						var rectAttr = {
							x: src.attr.x + (src.attr.width - src.img.width - 2) / 2,
							y: src.attr.y + (src.attr.height - src.img.height - 2) / 2,
							width: src.img.width + 2,
							height: src.img.height + 2
						};
						rmap[hr.rects[i].id].rect.attr($.extend(rectAttr, hr.rectAttr));
						rmap[hr.rects[i].id].rect.getRect().show();
					}else{
						rmap[hr.rects[i].id].rect.attr(hr.rectAttr);
					}
				}
				for (var j = 0; j < hr.rects[i].paths.length; j++) {
					if (rmap[hr.rects[i].id].paths[hr.rects[i].paths[j]]) {
						rmap[hr.rects[i].id].paths[hr.rects[i].paths[j]]
								.attr(hr.pathAttr);
					}
				}
			}
			for (var i = 0; i < ar.rects.length; i++) {
				if (rmap[ar.rects[i].id]) {
					rmap[ar.rects[i].id].rect.attr(ar.rectAttr);
					rmap[ar.rects[i].id].rect.animate();
				}
				for (var j = 0; j < ar.rects[i].paths.length; j++) {
					if (rmap[ar.rects[i].id].paths[ar.rects[i].paths[j]]) {
						rmap[ar.rects[i].id].paths[ar.rects[i].paths[j]]
								.attr(ar.pathAttr);
					}
				}
			}
		}
	}

	// 添加jquery方法
	$.fn.myflow = function(o) {
		return this.each(function() {
					myflow.init(this, o);
				});
	};

	$.myflow = myflow;
})(jQuery);
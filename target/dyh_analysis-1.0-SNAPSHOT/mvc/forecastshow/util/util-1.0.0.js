/**
 * by wangpengbo 
 * 2017-05-16
 * learn of jQuery1.7.1
 */
(function(window, undefined) {

var $ = util = (function(selector, context) {
    var util = function(selector, context) {
        return new util.fn.init(selector, context);
    };
    return util;
})();
var rfind = /^#([\w\-]*)$/;
var document = window.document;
util.fn = util.prototype = {
    init: function(selector, context) {
        if (!selector) {
            return this;
        } else if (selector.nodeType) {
            this.context = this[0] = selector;
            this.length = 1;
            return this;
        } else if (util.type(selector) === "string") {
            var match = rfind.exec(selector);
            if (match[1]) {
                var result = document.getElementById(match[1]);
                if (result) {
                    this[0] = result;
                    this.context = result.ownerDocument;
                    this.length = 1;
                }
                return this;
            }
            return this;
        }
    }
};

util.fn.init.prototype = util.fn;

util.extend = util.fn.extend = function() {
    var options, copy, 
        target = arguments[0] || {},
        i = 1,
        length = arguments.length;

    if (typeof target !== "object") {
        target = {};
    }
    if (length === i) {
        target = this;
        --i;
    }
    for ( ; i < length; i++) {
        if ((options = arguments[i]) != null) {
            
            for (name in options) {
                src = target[name];
                copy = options[name];
                target[name] = copy;
            }
        }
    }
    return target;
};

var class2type = {};
var arr = [];
var toString = class2type.toString;
var utilId = "util" + (Math.random() + '').replace('.', '');
var push = arr.push;

var rclass = /[\n\t\r]/g;
var rtrim = /(^\s+)|(\s+$)/g;
var rtrimInner = /\s+/g;
util.extend({
    
    id: utilId,
    
    guid: 1,
    
    
    type: function(obj) {
        if (obj == null) {
            return obj + ""; 
        }
        return class2type[toString.call(obj)] || "object";
    },
    
    each: function(obj, cb, args) {
        var name, length = obj.length,
        isObj = length === undefined || util.type(obj) === "function";
        
        if (args) {
            if (isObj) {
                for (name in obj) {
                    if (cb.apply(obj[name], args) === false) {
                        break;
                    }
                }
            } else {
                for (var i = 0; i < length; i++) {
                    if (cb.apply(obj[i], args) === false) {
                        break;
                    }
                }
            }
        } else {
            if (isObj) {
                for (name in obj) {
                    if (cb.call(obj[name], name, obj[name]) === false) {
                        break;
                    }
                }
            } else {
                for (var i = 0; i < length; i++) {
                    if (cb.call(obj[i], i, obj[i]) === false) {
                        break;
                    }
                }
            }
        }
        return obj;
    },
    
    isEmptyObject: function(obj) {
        for (var name in obj) {
            return false;
        }
        return true;
    },
    
    g: function(id, context) {
        if (!context) {
            context = document;
        }
        return context.getElementById(id);
    },
    
    merge: function(arr1, arr2) {
        var i = arr1.length;
        var j = 0;;
        if (typeof arr2.length === "number") {
            for (; j < arr2.length; i++,j++) {
                arr1[i] = arr2[j];
            }
        }
        
    },
    noop: function() {},
    
    param: function(a) {
        var r20 = /%20/g;
        var s = [],
        add = function( key, value ) {
            s[ s.length ] = encodeURIComponent( key ) + "=" + encodeURIComponent( value );
        };
        for ( var prefix in a ) {
            add( prefix, a[prefix] );
        }
        return s.join( "&" ).replace( r20, "+" );
    }
});

util.extend({
    //$.cache
    cache: {},
    
    cacheId: 1,
    
    hasData: function(elem) {
        var data = elem.nodeType ? util.cache[elem[utilId]] : elem[utilId];
        return data && !util.isEmptyObject(data);
    },
    
    data: function(elem, name, data, pvt/*是否是util内部调用的*/) {
        var key = util.id,
            isNode = !!elem.nodeType,
            cache = isNode ? util.cache : elem,
            id = isNode ? elem[key] : elem[key] && key;//
            var privateCache, thisCache;
            //暂时不考虑isNode == false 时的情况
        if (!id) {
            if (isNode) {
                elem[key] = id = util.cacheId++;
            } else {
                id = key;
            }
        }
        if (!cache[id]) {
            cache[id] = {};
            //cache[ id ].toJSON = jQuery.noop;这一行没看懂
        }
        if (typeof name == "object") {
            if (pvt) {
                cache[id] = util.extend(cache[id], name);
            } else {
                cache[id].data = util.extend(cache[id].data, name);
            }
        }
        
        //
        privateCache = thisCache = cache[id];
        if (!pvt) {
            if (!thisCache.data) {
                thisCache.data = {};
            }
            thisCache = thisCache.data;
        }
        
        if (data !== undefined) {
            thisCache[name] = data;
        }
        
        var rData;
        if (typeof name === "string") {
            rData = thisCache[name];
        } else {
            rData = thisCache;
        }
        return rData;
    },
    
    _data: function(elem, name, data) {
        return util.data(elem, name, data, true);
    }
});

util.ajax = {
    ajaxSetup: function() {
        if (!window.jQuery) {
            return;
        }
        jQuery.ajaxSetup({
            cache: false,
            contentType: "application/x-www-form-urlencoded; charset=UTF-8",
            type: "POST",
            dataType: "json",
            error: function() {
                util.error.errorAjax(arguments);
            }
        })
    }   
};

util.fn.extend({
    constructor: util,
    //$(body).data(); 
    //$(body).data({a: b}); 
    //$(body).data("acsd", {a: b}); 
    //$(body).data("acsd");
    data: function(key, data) {
        if (typeof key === "undefined") {
            //此时一个参数没有传入，即是为了查询绑在该元素上的数据
            return util.data(this[0]);
            //jQuery 额外提供了对 HTML页面上 data-* 属性的查询，不过我不需要
        } else if (typeof key === "object") {
            return this.each(function() {
                //为每个元素绑定数据
                util.data(this, key); 
            });
        } else if (data === undefined && this.length) {
            return util.data(this[0], key);
        } else {
            return this.each(function() {
                util.data(this, key, data);
            });
        }
    }
});

util.fn.extend({
    
    each: function(cb, args) {
        return util.each(this, cb, args);
    },
    //$().on("click",fn); or //$().on("click", ".isButton", fn);
    on: function(type, selector, fn) {
        if (typeof selector === "function" && !fn) {
            fn = selector;
            selector = undefined;
        } 
        return this.each(function() {
            util.event.add(this, type, selector, fn);
        });
        
    },
    
    hasClass: function(className) {
        if (this[0].nodeType === 1 
                && new RegExp(' '+ className + ' ').test(' ' + this[0].className.replace(/[\n\t\r]/g, ' ') + ' ')){
            return true;
        }
        return false;
    },
    
    addClass: function(className) {
        this.each(function() {
           this.className += ' ' + className;
        });
        return this;
    },
    
    removeClass: function(className) {
        var className;
        var reg = new RegExp(' ' + className + ' ', 'g');
        this.each(function() {
            this.className = (' '+ this.className + ' ')
                                .replace(rclass, ' ')
                                .replace(/' '/g, '  ')
                                .replace(reg, '')
                                .replace(rtrim, '')
                                .replace(rtrimInner, ' ');
         });
        return this;
    },
    
    quick: function(elem) {
        this[0] = elem;
        this.context = elem;
        return this;
    },
    
    hasParent: function(parent) {
        var cur;
        for (cur = this[0]; cur != null; cur = cur.parentNode || null) {
            if (cur == parent) {
                return true;
            }
        }
        return false;
    },
    
    empty: function() {
        this.each(function() {
            while (this.firstChild) {
                this.removeChild(this.firstChild);
            }
        });
        return this;
    },
    
    pushStack: function(elems) {
        var $cur = this.constructor();//创建一个新的util对象

        if (util.type(elems) === "array" ) {//elems是一个array,那就push合并一下
            push.apply( $cur, elems );
        } else {// elems很可能是util对象（类数组对象）: merge合并一下
            $cur = util.merge( $cur, elems );
        }

        $cur.prevObject = this; //ret的过去指向当前this对象，形成一个链式栈
        $cur.context = this.context;//jQuery对象的上下文不变
        return $cur;//返回这个对象
    },
    
    children: function(selector) {
        var $cur = $();
        var result = [];
        this.each(function() {
           util.each(this.childNodes, function() {
               if (!selector && this.nodeType === 1) {
                   result.push(this);
               } else if ($cur.quick(this).is(selector)) {
                   result.push(this);
               }
           }); 
        });
        return this.pushStack(result);
    },
    
    parent: function() {
        return this.pushStack([this[0].parentNode]);
    },
    
    is: function(selector) {
        var match = rquickIs.exec(selector);
        if (match[1]) {
            
            return this[0].nodeName.toLowerCase() === selector.toLowerCase();
        } else if (match[2]) {
            return this.hasClass(match[2]);
        } else {
            return false;
        }
        
    }
    
});

util.each("Boolean Number String Function Array Date RegExp Object".split(" "), function(i, name) {
    class2type["[object " + name + "]"] = name.toLowerCase();
});

//快速判断一个元素是否符合 事件委托的selector 条件。就我个人而言，只判断 类名 和标签名足够了。
var rquickIs = /^(?:(\w*)|(?:\.([\w\-]+)))$/;
function quickParse(selector) {
   
    var match = rquickIs.exec(selector);
    // 标签名 、类名 等属于可以快速判断的内容
    if (match) {
        match[1] = (match[1] || "").toLowerCase();
        //把判断hasClass的正则new在绑定事件时
        match[2] = match[2] && new RegExp("(?:^|\\s)" + match[2] + "(?:\\s|$)");
    }
    return match;
};
function quickIs(elem, match) {
    if (match[1]) {
        return elem.nodeName.toLowerCase() == match[1];
    } else if (match[2]) {
        return match[2].test(elem.className);
    }
}


util.event = {
    //绑定一个主function，触发这个主function，然后过滤出符合条件的触发
    add: function(elem, type, selector, fn) {//绑定 
        //dom元素绑定的数据
        var elemData,
            //主监听函数
            eventHandle,
            //缓存的事件相关数据
            events,
            t, tns, type, namespaces, handleObj,
            handleObjIn, quick, handlers, special;
        
        elemData = util._data(elem);
        
        if (!fn.guid) {
            fn.guid = util.guid++;
        }

        events = elemData.events;
        if (!events) {
            elemData.events = events = {};
        }
        //
        eventHandle = elemData.eventHandle;
        if (!eventHandle) {
            elemData.eventHandle = eventHandle = function(event) {
                return util.event.dispatch.call(elem, event);
            };
        }
        handleObj = {
            type: type,
            handler: fn,
            guid: fn.guid,
            quick: quickParse(selector),
            selector: selector
        }

        handlers = events[ type ];
        if (!handlers) {
            handlers = events[type] = [];
            handlers.delegateCount = 0;
            
            if (elem.addEventListener) {
                elem.addEventListener(type, eventHandle, false);
            } else if (elem.attachEvent) {
                elem.attachEvent("on" + type, eventHandle);
            }
        }

        if (selector) {
            handlers.splice(handlers.delegateCount++, 0, handleObj);
        } else {
            handlers.push(handleObj);
        }
        //elem = null;
    },
    fix: function(old) {
        var event = {};
        for (var name in old) {
            event[name] = old[name];
        }
        if (!old.target) {
            event.target = old.srcElement;
        }
        return event;
    },
    dispatch: function(event) {
        event = util.event.fix(event);//原生event只读，自己建一个可修改的
        var arr = (util._data(this, "events") ||{})[event.type] || [];
        var delegateCount = arr.delegateCount;
        var cur, i, j, matched, handleObj, result; 
        
        var queue = [];
        if (delegateCount && !event.target.disabled) {
            
            $cur = $(this);
            $cur.context = this.ownerDocument || this;
            
            for (cur = event.target; cur != this; cur = cur.parentNode || this) {
               var curMatch = {},
                    matches = [];
                $cur[0] = cur;
                
                for (i = 0; i < delegateCount; i++) {
                    handleObj = arr[i];
                    selector = handleObj.selector;
                    if (curMatch[selector] === undefined) {
                        curMatch[selector] = handleObj.quick ? quickIs(cur, handleObj.quick) : $cur.is(selector);
                        if (cur.nodeName == "div" && cur.className.length) {
                        }
                    }
                    if (curMatch[selector]) {
                        //这个子元素符合事件触发条件，放进arr，挨个执行事件。
                        matches.push(handleObj);
                    }
                }
                if (matches.length) {
                    queue.push({
                        elem: cur,
                        matches: matches
                    });
                }
            }
        }
        
        if (arr.length > delegateCount) {
            queue.push({
                elem: this, 
                matches: arr.slice(delegateCount) //之后的
            });
        }
        for (i = 0; i < queue.length; i++) {
            matched = queue[i];
            event.currentTarget = matched.elem;
            for (j = 0; j < matched.matches.length; j++) {
                handleObj = matched.matches[j];
                event.data = handleObj.data;
                event.handleObj = handleObj;
                result = handleObj.handler.call(matched.elem, event);
                if (result !== undefined) {
                    event.result = result;
                }
            }
        }
    }
    
}

util.extend({
    isLowerIE: function() {
        var explorer = window.navigator.userAgent.toLowerCase();
        if (explorer.indexOf("msie") > -1) {
            var ver = explorer.match(/msie ([\d.]+)/)[1].charAt(0);
            if (parseInt(ver, 10) <= 8) {
                return true;
            }
        }
        return false;
    },
    
    isIE: function() {
        var explorer = window.navigator.userAgent.toLowerCase();
        if (explorer.indexOf("msie") > -1) {               // /msie ([\d.]+)/
            return explorer.match(/msie ([\d.]+)/)[1];
        } else if (!!window.ActiveXObject || "ActiveXObject" in window){
            //IE11
            return "edge";
        }
        return false; 
    },
    
    alert: function(data) {
        if (typeof data !== "string") {
            
            return;
        }
        alert(data);
    },
    delayNumber: 0,
    
    delay: function(fn, time) {
        clearTimeout(util.delayNumber);
        util.delayNumber = setTimeout(fn, time);
    },
    
    error: {
        errorAjax: function(data) {
            if (data.msg) {
                util.alert(data.msg);
            } else if (data[0] && data[0].readyState != null && data[0].status != null) {
                if (data[0].readyState == '0'&& data[0].status == '0') {
                    return;
                } else {
                    util.alert('error: ' +data[0].status + ' !');
                }
            } else {
                util.alert('error!');
            }
        }
    },
    
    date: {
        format: function(obj) {
            var date;
            if (util.type(obj) === "date") {
                date = obj;
            } else if (util.type(obj) === "number") {
                date = new Date(obj);
            } else {
                console.error('paramter type must be date/number!');
                return false;
            }
            var y = date.getFullYear();
            var m = date.getMonth() + 1;
            var d = date.getDate();
            return y + '-' + (m > 9 ? m : ('0' + m)) 
                     + '-' + (d > 9 ? d : ('0' + d));
        }
    },
    
    select: {
        id: 1,
        
        init: function() {
            var selects = document.getElementsByTagName("select");
            util.each(selects, function() {
                util.select.reset.call($cur.quick(this.parentNode), this);
            });
        },
        
        reset: function(select) {
            var options = select.options;
            var selectedOption = options[options.selectedIndex];
            var _text = this[0].getElementsByTagName("span")[0];
            if (_text) {
                _text.innerHTML = selectedOption ? selectedOption.innerHTML : '';
            }
        },
        
        open: function(select, ul) {
            
            $.select.cur = this[0];
            if (!this.outer) {
                this.addClass("active");
            }
            this.outer = undefined;
            return this;
        },

        select: function(elem) {
            var text = elem.getAttribute("data-text");
            var value = elem.getAttribute("data-value");
            var select = this[0].getElementsByTagName("select")[0];
            var old = select.value;
            select.value = value;
            if (old != value) {
               // console.log(!!select.change || !!select.fireEvent);
                if (select.change) {
                    select.change();
                } else if (select.fireEvent) {
                    select.fireEvent('onchange');
                }
            }
            this[0].getElementsByTagName("span")[0].innerHTML = text;
            $.select.close.call(this);
            return this;
        },
        
        close: function() {
            if (!this.outer) {
                this.removeClass("active");
            }
            $.select.cur = undefined;
            this.outer = undefined;
            return this;
            
        },
        
        ul: function() {
            
            var elemData = this.data();
            var sId = elemData.w_select_ul_id;
            var ul;
            if (!sId) {
               // console.log('!sId');
                sId = elemData.w_select_ul_id = 'w_select_ul_' + $.select.id++;
                ul = document.createElement("ul");
                ul.className = "w-select-list";
                ul.id = sId;
                if (this.outer) {
                    document.body.appendChild(ul);
                } else {
                    this[0].appendChild(ul);
                }
            }
            if (!ul) {
                ul = document.getElementById(sId);
            }
            return ul;
        },
        
        click: function() {
            if ($.select.cur && this[0] !=$.select.cur) {
                var _select = this[0];
                util.select.close.call(this.quick($.select.cur));
                this.quick(_select);
            }
            this.outer = false;
            if (this.hasClass("outer")) {
                this.outer = true;
            }
            if (this.hasClass("active")) {
                $.select.close.call(this);
                return;
            }
            
            var ul = $.select.ul.call(this);
           
            var select = this[0].getElementsByTagName("select")[0];
            var options = select.options;
            var index = options.selectedIndex;
            var items = ul.childNodes;
            if (items.length !== options.length) {
                ul.innerHTML = '';
                var li;
                $.each(options, function(i) {
                    li = document.createElement("li");
                    li.setAttribute("data-value", this.value);
                    li.setAttribute("data-text", this.text);
                    li.innerHTML = this.innerHTML;
                    if (i == index) {
                        li.className = "selected";
                    }
                    ul.appendChild(li);
                });
                items = ul.childNodes;
            } else {
                $.each(items, function(i) {
                    if (this.className == "selected" && i != index) {
                        this.className = '';
                    } else if (i == index) {
                        this.className = "selected";
                    }
                });
            }
            
            $.select.open.call(this);
            return this;
        },
        //TODO
        remove: function() {
            
        }
    },
    loading: {
        pro: {
            length: 0
        },
        
        init: function() {
            if (!util.loading.screen) {
                return;
            }
     
            jQuery.ajaxSetup({
                beforeSend: function (xhr) {
              
                    util.loading.pro.length++;
                    var value = setTimeout('util.loading.show();');
                },
                complete: function (xhr, status) {
                  
                    util.loading.pro.length--;
                    
                    util.loading.hide();
                }
            });
        },
        
        screen: document.getElementById('w-loading-screen'),
        
        show: function() {
            var screen = util.loading.screen;
            if (screen && util.loading.pro.length > 0) {
                screen.style.display = 'block';
            }
        },
        
        hide: function() {
            var screen = util.loading.screen;
            if (screen && util.loading.pro.length == 0) {
                //screen.style.display = 'none';
                setTimeout("util.loading.screen.style.display = 'none';", 0)
            }
        }
    }
});

util.fn.extend({
    /**
     * ****************************************************************************************************************
     * w-select start
     */
    reset: function() {
        var select = this[0];
        if (!select || select.nodeName.toLowerCase() != "select") {
            console.error('select');
            return this;
        }
        util.select.reset.call($(select.parentNode), select);
        return this;
    },

    options: function(data, cfg) {
        var select = this[0];
        if (!select || select.nodeName.toLowerCase() != "select") {
            console.error('select');
            return this;
        }
        var name = 'name', value = 'value';
        var required, flag;
        if (typeof cfg === "object") {
            name = cfg.name ? cfg.name : name;
            value = cfg.value ? cfg.value : value ;
            required = !!cfg.required;
            flag = !!cfg.flag;
        }
        select.innerHTML = '';
        
        var option;
        if (!required) {
            option = document.createElement("option");
            option.value = '';
            option.text = '请选择';
            select.appendChild(option);
        }
        util.each(data, function(i, item) {
            option = document.createElement("option");
            option.value = flag ? this[value] + '_' + this[name] : this[value];
            option.text = this[name];
            select.appendChild(option);
        });
        $.select.ul.call(this.parent()).innerHTML = '';
        
        return this.reset();
    }
    /**
     * w-select end
     * ****************************************************************************************************************
     */

});

if(window.utilFixed && window.utilFixed.length) {
    $.each(window.utilFixed, function(i, item) {
        var target = util[item['name']];
        if (!!target) {
            util.extend(target, item['fixed']);
        }
    });
}


var $cur = $(document.body);
var $prev = $(document.body);
window.$cur = $cur;
util.$prev = $prev;
window.util = util;
window.g = util.g;
util.select.init();
util.loading.init();
util.ajax.ajaxSetup();
$(document.body).on('click', '.isButton', function(e) {
    var click = $cur.quick(this);
    var oper = this.getAttribute("data-oper");
    if (click.hasClass('w-select')) {
        if (e.target.nodeName.toLowerCase() === "li") {
            util.select.select.call(click, e.target);
        } else {
            util.select.click.call(click, e.target);
        }
        return;
    }
    if (oper == "w-modal-close") {
        this.parentNode.parentNode.style.display = "none";
        return;
    }
});
$(document.body).on('click', function(e) {
    var curSelect = $.select.cur;
    if (curSelect && !$cur.quick(e.target).hasParent(curSelect)) {
        util.select.close.call($cur.quick(curSelect));
    }
});
})(window);
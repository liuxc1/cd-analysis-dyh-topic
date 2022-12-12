/*!
 * Author: wangpengbo
 * Date: 2017-06-29
 * Email: 316370554@163.com
 */
(function() {
    var $ = window.$;
    $(document.body).on("click", ".pager_button", function() {
        var click = $(this);
        var t = $._data(click.closest(".w-pager")[0], "w-table");
        if (click.hasClass("cur") || click.hasClass("disabled")) {
            return;
        }
        t.goPage(this);
    });
    //入口，接收一堆参数
    $.fn.dataTable = $.fn.datatable = function(option) {
        if (!this[0]) {
            return;
        }
        var table = this[0];
        if ($._data(table, "w-table")) {
            $._removeData(table, "w-table");
        }
        var t = new DataTable(this, option);
        $._data(table, "w-table", t);
        $._data(t.$pager[0], "w-table", t);
        return this;
    };
    DataTable = function($t, option) {
        this.per_page = option.per_page || 10;
        this.cur_page = 1; 
        this.type = option.type || 'post';
        this.url = option.url;
        this.cfg = option.cfg || {};
        if (option.error || !(window.util && window.util.ajax)) {
            this.error = option.error || function(a, b) {
                alert(b);
            }
        }
        
        this.getTbodyHtml = option.tbody;
        this.getParameters = option.data;
        this.$tbody = $t.children("tbody").empty();
        if (!this.$tbody[0]) {
            this.$tbody = $("<tbody>").appendTo($t);
        }
        
        this.$pager = $t.siblings(".w-pager").empty();
        if (!this.$pager[0]) {
            this.$pager = $("<div>").addClass("w-pager").insertAfter($t);
        }
        
        this.ajaxGetData();
        
    };
    DataTable.prototype = {
        goPage: function(elem) {
            var oper = elem.getAttribute("data-oper");
            switch(oper) {
                case 'first':
                    this.cur_page = 1;
                    break;
                case 'prev':
                    this.cur_page--;
                    break;
                case 'next':
                    this.cur_page++;
                    break;
                case 'last':
                    this.cur_page = this.total_page;
                    break;
                case 'pager':
                    this.cur_page = parseInt(elem.innerHTML, 10);
                    break;
            }
            this.ajaxGetData();
        },
        ajaxGetData: function() {
            var data = (typeof this.getParameters === "function" ? this.getParameters() : this.getParameters) || {};
            this.setPagerInfo(data);
            var t = this;
            jQuery.ajax({
                cache: false,
                contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                type: this.type,
                dataType: "json",
                url: this.url,
                data: data,
                error: this.error,
                success: function(rdata) {
                    t.htmlData(rdata);
                }
            });
        },
        
        setPagerInfo: function(data) {
            //permit user to define parameter/attribute names
            data[this.cfg.per_page || "per_page"] = this.per_page;
            data[this.cfg.cur_page || "cur_page"] = this.cur_page;
        },
        
        htmlData: function(rdata) {
            ////permit user to define parameter/attribute names
            this.total = parseInt(rdata.data[this.cfg.total || "total"], 10);
            this.per_page = parseInt(rdata.data[this.cfg.per_page || "per_page"], 10);
            this.cur_page = parseInt(rdata.data[this.cfg.cur_page || "cur_page"], 10);
            this.total_page = Math.ceil(this.total/this.per_page);
            var tbody = this.getTbodyHtml(rdata);
            var pager = this.getPagerHtml();
            this.$pager.empty().append(pager);
            this.$tbody.empty().append(tbody);
        },
        
        getPagerNumberLi: function() {
            var frag = document.createDocumentFragment();
            var pageArr = [];
            if(this.total_page == 0) {
            } else if (this.total <= this.per_page * 5) {
                for(var i = 1; i <= this.total_page; i++){
                    pageArr.push(i);
                 }
            } else if (this.cur_page <= 3) {
                pageArr.push.apply(pageArr, [1, 2, 3, 4, 5]);
            } else if (this.cur_page >= this.total_page - 2) {
                pageArr.push.apply(pageArr, [this.total_page - 4, this.total_page - 3, this.total_page - 2, this.total_page - 1, this.total_page]);
            } else {
                pageArr.push.apply(pageArr, [this.cur_page - 2, this.cur_page - 1, this.cur_page, this.cur_page + 1, this.cur_page + 2]);
            }
            var t = this;
            $.each(pageArr, function(i, pageNumber) {
                var li = document.createElement("li");
                    li.className = pageNumber == t.cur_page ? 'pager_button cur' : 'pager_button';
                    li.innerHTML = pageNumber;
                    li.setAttribute("data-oper", "pager");
                    frag.appendChild(li);
            });
            return frag;
        },
        
        getPagerHtml: function() {
            var frag = document.createDocumentFragment();
            var rightContainer = document.createElement("div");
            rightContainer.className = 'w-pager-right';
            
            var btnList = document.createElement("ul");
            btnList.className = 'w-pager-btn-list';
            rightContainer.appendChild(btnList);
            
            var firstBtn = document.createElement("li");
            firstBtn.className = this.cur_page === 1 ? 'pager_button first disabled' : 'pager_button first';
            firstBtn.setAttribute("data-oper", "first");
            btnList.appendChild(firstBtn);
            
            var prevBtn = document.createElement("li");
            prevBtn.className = this.cur_page === 1 ? 'pager_button prev disabled' : 'pager_button prev';
            prevBtn.setAttribute("data-oper", "prev");
            btnList.appendChild(prevBtn);
            
            btnList.appendChild(this.getPagerNumberLi());
            
            var nextBtn = document.createElement("li");
            nextBtn.className = this.cur_page === this.total_page
                ? 'pager_button next disabled' 
                : 'pager_button next';
            nextBtn.setAttribute("data-oper", "next");
            btnList.appendChild(nextBtn);
            
            var lastBtn = document.createElement("li");
            lastBtn.className = this.cur_page === this.total_page
                ? 'pager_button last disabled'
                : 'pager_button last';
            lastBtn.setAttribute("data-oper", "last");
            btnList.appendChild(lastBtn);
            
            var pageInfo = document.createElement("div");
            pageInfo.className = 'w-pager-info';
            pageInfo.innerHTML = '当前第' + this.cur_page + '页，共' + this.total_page + '页';
            rightContainer.appendChild(pageInfo);
            
            frag.appendChild(rightContainer);
            return frag;
        }
    };
})();
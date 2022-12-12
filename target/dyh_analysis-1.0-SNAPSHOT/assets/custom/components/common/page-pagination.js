// 注册分页
Vue.component('my-pagination', {
	template : '#vue-template-pagination',
	data : function() {
		return {
			pageWidth : 1600,
		};
	},
	props : {
		tableobj : {
			type : Object,
			// 默认数据
			'default' : {
				pageNum : 1, // 第几页
				pageSize : 10,// 每页条数
				total : 0,// 总条数
			}
		},
		/**
		 * 是否显示每页条数设置
		 */
		showPageChange:{
			type : Boolean,
			default:true
		}
	},
	mounted : function() {
		var _this = this;
		_this.$nextTick(function() {
			var divCuPagination = this.$refs.divCuPagination;
			if (divCuPagination && divCuPagination.offsetWidth > 0) {
				this.pageWidth = divCuPagination.offsetWidth;
			}
		})
	},
	computed : {
		totalPage : function() {
			var totalPage = Math.ceil(this.tableobj.total / this.tableobj.pageSize);
			if (totalPage <= 0) {
				totalPage = 1;
			}
			return totalPage;
		},
		// 分页
		pages : function() {
			var pag = [];
			// 当前页
			var currentPage = parseInt(this.tableobj.pageNum);
			var totalPage = this.totalPage;

			if (this.tableobj.pageNum <= totalPage) {
				// 得到总页数
				var i = totalPage;
				if (i <= 5) {
					while (i > 0) {
						pag.unshift(i--);
					}
				} else if (currentPage <= 3) {
					var num = 5;
					while (num > 0) {
						pag.unshift(num--);
					}
				} else if ((i - currentPage) <= 2) {
					var num = 5;
					while (num > 0) {
						pag.unshift(i--);
						num--;
					}
				} else {
					i = currentPage + 2;
					var num = 5;
					while (num > 0) {
						pag.unshift(i--);
						num--;
					}
				}
			} else if (this.tableobj.pageNum > totalPage && this.tableobj.total > 0) {
				this.tableobj.pageNum = totalPage;
			} else if (this.tableobj.pageNum < 1) {
				this.tableobj.pageNum = 1;
			}
			return pag;
		},
	},
	methods : {
		// 首页
		firstPage : function() {
			this.tableobj.pageNum = 1;
			this.goPage();
		},
		// 上一页
		lastPage : function() {
			if (this.tableobj.pageNum > 1) {
				this.tableobj.pageNum = this.tableobj.pageNum - 1;
				this.goPage();
			}
		},
		// 下一页
		nextPage : function() {
			if (this.tableobj.pageNum < this.totalPage) {
				this.tableobj.pageNum = this.tableobj.pageNum + 1;
				this.goPage();
			}
		},
		// 尾页
		finalPage : function() {
			this.tableobj.pageNum = this.totalPage;
			this.goPage();
		},
		// 是否支持跳转
		showSkipInput : function() {
			var newPageNum = parseInt(this.$refs.inputPageNum.value);
			var newPageSize = this.showPageChange?parseInt(this.$refs.inputPageSize.value):this.tableobj.pageSize;
			var totalPage = this.totalPage;
			if (newPageNum > 0 && newPageNum <= totalPage) {
				this.tableobj.pageNum = newPageNum;
			} else if (newPageNum > totalPage) {
				newPageNum = totalPage;
			} else if (newPageNum < 1) {
				this.tableobj.pageNum = 1;
			} else {
				alert("请输入正确的页数 !");
				return;
			}

			if (newPageSize < 1 && newPageSize > 1000) {
				alert("每页条数范围限制1~2000 !");
				return;
			}

			this.tableobj.pageNum = newPageNum;
			this.tableobj.pageSize = newPageSize;
			this.goPage();
		},
		// 选中
		selectedPage : function(val) {
			this.tableobj.pageNum = val;
			this.goPage();
		},
		goPage : function() {
			this.$emit('handlecurrentchange', this.tableobj.pageNum, this.tableobj.pageSize);
		}
	}
})
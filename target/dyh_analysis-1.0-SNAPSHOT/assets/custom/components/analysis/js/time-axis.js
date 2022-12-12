/**
 * 分析平台-时间轴组件-逻辑js
 */
Vue.component('time-axis', {
    template: '#vue-template-time-axis',
    /**
     * 外部接收的参数
     */
    props: {
    	// 上一页
    	prev: {
    		type: Object,
    		default: {
    			limit: '',
    			title: '上一月',
    			isShow: true
    		}
    	},
    	// 下一页
    	next: {
    		type: Object,
			default: {
				limit: '',
				title: '下一月',
				isShow: true
			}
		},
		// 数据列表。样例数据：{
		//  	唯一键
		// 		key: '',
		//  	值（用于显示）
		// 		text: '',
		//  	是否禁用
		// 		disabled: false
		//  	是否选中
		//  	selected: false
		// }
		list: Array,
		// 当前时间
		current: String
    },
    /**
     * 监听器
     */
	watch: {
		/**
		 * 监听list的变化
		 */
		list: function (newValue, oldValue) {
			// 选中列表并返回选中的索引
    		var index = this.getListSelected;
    		// 重新加载
    		this.listClick(index, true);
		}
	},
    /**
	 * 组件所有方法
	 */
	methods: {
		/**
		 * 上一页点击事件
		 */
		prevClick: function () {
			if (this.prevDisabled) {
				return;
			}
			// 调用父组件方法。
			// 由于不知道父组件中该方法是同步还是异步，对数据是否有增减，所以加载后的刷新动作，交给用户自己完成。
			// 推荐：父组件中调用listClick方法进行刷新动作。(this.$refs.timeAxis.listClick(index, isRefresh))
			// 备注：父组件调用子组件方法：this.$refs.ref名称.方法名。
			//     其中'ref名称'为使用组件时，在组件上定义的ref属性值。
			//     如：<time-axis ref="timeAxis"></time-axis>。
			this.$emit('prevclick', this.prev);
		},
		/**
		 * 下一页点击事件
		 */
		nextClick: function () {
			if (this.nextDisabled) {
				return;
			}
			// 调用父组件方法。
			this.$emit('nextclick', this.next);
		},
		/**
		 * 数据点击事件
		 * @param index 点击元素索引
		 * @param isRefresh 是否刷新。True：刷新，False：不刷新
		 */
		listClick: function (index, isRefresh) {

			if (index < 0) {
				return;
			}
			var data = this.list[index];
			// 防止点击禁用项和重复点击
			if (data.disabled || (data.selected && !isRefresh)) {
				return;
			}
			// 选中列表
			this.selectedList(index);
			// 调用父组件方法
			this.$emit('listclick', data);
		},
		/**
		 * 选中列表
		 * @results 选中列表的索引，默认为：0
		 */
		selectedList: function (index) {
			index = 0 || index;
			for (var i = 0; i < this.list.length; i++) {
				var temp = this.list[i];
				if (i === index) {
					temp.selected = true;
				} else {
					temp.selected = false;
				}
			}
		}
	},
	/**
	 * 计算属性（带缓存）
	 */
	computed: {
		/**
		 * 计算上一页是否禁用
		 * @results 是否禁用。True：禁用，Flase：不禁用
		 */
		prevDisabled: function() {
			return this.current <= this.prev.limit;
		},
		/**
		 * 计算下一页是否禁用
		 * @results 是否禁用。True：禁用，Flase：不禁用
		 */
		nextDisabled: function() {
			return this.current >= this.next.limit;
		},
		/**
		 * 获取选中列表数据的索引
		 * @results 选中列表数据的索引，默认0
		 */
		getListSelected: function () {
			if (this.list == null || this.list.length === 0) {
				return -1;
			}
			for (var i = 0; i < this.list.length; i++) {
				var temp = this.list[i];
				if (temp.selected) {
					return i;
				}
			}
			return 0;
		}
	}
});
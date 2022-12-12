/**
 * 分析平台-记录列表组件-逻辑js
 */
Vue.component('record', {
    template: '#vue-template-record',
    /**
     * 外部接收的参数
     */
    props: {
		// 数据列表。样例数据：{
		//  	唯一键
		// 		key: '',
		//  	值（用于显示）
		// 		text: '',
		//  	是否选中
		//  	selected: false
		// }
    	records: Array
    },
	 /**
     * 监听器
     */
	watch: {
		/**
		 * 监听records的变化
		 */
		records: function (newValue, oldValue) {
			this.refresh();
		}
	},
    /**
	 * 组件所有方法
	 */
	methods: {
		/**
		 * 记录点击事件
		 * @param index 点击记录的索引
		 * @param isRefresh 是否刷新。True：刷新，False：不刷新
		 */
		recordClick: function (index, isRefresh) {
			if (index < 0) {
				return;
			}
			var record = this.records[index];
			// 防止重复点击
			if (record.selected && !isRefresh) {
				return;
			}
			// 选中记录
			this.selectedRecord(index);
			// 记录本次选中，作为下次点击时候的'上次选中记录'
			// this.oldIndex = index;
			// 调用父组件方法
			this.$emit('recordclick', record);
		},
		/**
		 * 刷新
		 */
		refresh: function (title) {
			// 选中列表并返回选中的索引
    		var index = this.getRecordSelected;
    		if (title) {
    			this.records[index].text = title;
    		}
    		// 重新加载
    		this.recordClick(index, true);
		},
		/**
		 * 选中记录
		 * @param index 点击记录的索引
		 */
		selectedRecord: function (index) {
			for (var i = 0; i < this.records.length; i++) {
				if (i === index) {
					this.records[i].selected = true;
				} else {
					this.records[i].selected = false;
				}
			}
		}
	},
	/**
	 * 计算属性（带缓存）
	 */
	computed: {
		/**
		 * 获取选中记录数据的索引
		 * @results 选中列表数据的索引，默认0
		 */
		getRecordSelected: function () {
			if (this.records == null || this.records.length === 0) {
				return -1;
			}
			for (var i = 0; i < this.records.length; i++) {
				var temp = this.records[i];
				if (temp.selected) {
					return i;
				}
			}
			return 0;
		}
	}
});
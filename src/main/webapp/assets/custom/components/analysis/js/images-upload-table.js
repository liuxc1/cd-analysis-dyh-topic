/**
 * 分析平台-文件上传表格组件-逻辑js
 */
Vue.component('images-upload-table', {
    template: '#vue-template-file-upload-table',
    /**
     * 外部接收的参数
     */
    props: {
    	// 文件列表
    	fileList: {
    		type: Array,
    		default: []
    	},
    	// 删除的文件ID列表
    	deleteFileIds: {
    		type: Array,
    		default: []
    	},
    	// 最大文件大小
    	maxFileSize: {
    		type: Number,
    		// 默认大小为5 MB
    		default: 5 * 1024 * 1024
    	},
    	// 允许文件类型对象
    	allowFileTypes: [String, Object],
    	// 最小文件个数
    	minFileNumber: {
    		type: Number,
			default: 0
		},
    	// 最大文件个数
    	maxFileNumber: {
    		type: Number,
			default: 10
		},
		// 是否允许下载
		isDownload: {
			type: Boolean,
			default: true
		},
		// 是否隐藏上传按钮
		isHiddenUploadButton: {
			type: Boolean,
			default: false
		},
		// 是否隐藏删除按钮
		isHideDeleteButton : {
			type: Boolean,
			default: false
		},
		// 是否验证图片解析
		isValidate : {
			type: Boolean,
			default: false
		},
		// 是否只读
		isReadOnly : {
			type: Boolean,
			default: false
		},
		// 是否展示图片解析列
		isShowImageAnalysis : {
			type: Boolean,
			default: true
		}
    },
    /**
     * 数据
     */
    data: function () {
    	return {
    		// 文件工具类，交给Vue托管
    		fileUploadUtil: null,
    		fileDownloadUtil : null,
    		fileUrl:''
    	}
    },
    /**
     * 挂载开始之前被调用
     */
    beforeMount: function () {
    	this.fileUploadUtil = new ImagesUploadUtil(this.maxFileSize, this.allowFileTypes, this.maxFileNumber);
    	this.fileDownloadUtil = FileDownloadUtil;
    },
    updated: function () {
	  this.$nextTick(function () {
		  $("#picTable").viewer('destroy');
		  $("#picTable").viewer({url:"data-original"});
	  })
	},
    /**
	 * 组件所有方法
	 */
	methods: {
		/**
		 * 自定义elementui 文件上传事件
		 * @param {Object} param element-ui 文件上传组件返回的参数
		 */
		fileUpload: function (param) {
			param.file.url=this.fileUrl;
			this.fileUploadUtil.elementFileUpload(param, this.fileList);
		},
		/**
		 * 图片预览地址
		 */
		beforeAvatarUpload:function(file, fileList){
				this.fileUrl=URL.createObjectURL(file.raw);
		},
		/**
		 * 获取文件表单数据对象
		 * @param {Object} formData 表单数据对象
		 * @param {Array} fileList 文件列表
		 * @param {String} key 后台接收文件的Key
		 * @returns 文件表单数据对象（FormData）
		 */
		getFileFormData: function (formData, fileList, key) {
			if (fileList == null || fileList.length == 0) {
				fileList = this.fileList;
			}
			// 校验文件个数
			if (fileList.length < this.minFileNumber) {
				DialogUtil.showTipDialog("文件不能少于" + this.minFileNumber + "个，请确认。");
				return null;
			}
			if (fileList.length > this.maxFileNumber) {
				DialogUtil.showTipDialog("文件不能多于" + this.maxFileNumber + "个，请确认。");
				return null;
			}
			
			//加入验证
			if(this.isValidate && !$("#mainForm").validationEngine('validate')){
				return null;
			}
			
			return this.fileUploadUtil.getFileFormData(formData, fileList, key);
		},
		/**
		 * 获取删除文件ID列表
		 * @returns 删除文件的ID列表
		 */
		getDeleteFileIds: function () {
			return this.deleteFileIds;
		}
	},
	/**
	 * 计算属性（带缓存）
	 */
	computed: {
		/**
		 * 获取允许的文件原始（真实）类型字符串
		 * @results 允许的文件原始（真实）类型字符串
		 */
		getAllowRawTypeStr: function () {
			return this.fileUploadUtil.getAllowRawTypeStr();
		},
		/**
		 * 获取允许的文件类型字符串
		 * @results 允许的文件类型字符串
		 */
		getAllowFileTypeStr: function () {
			var types = this.fileUploadUtil.allowFileTypes;
			var arr = [];
			for (var i = 0; i < types.length; i++) {
				arr.push(types[i].fileType);
			}
			return arr.join("/");
		},
		/**
		 * 获取最大文件大小显示的文本
		 * @results 最大文件大小显示的文本
		 */
		getMaxFileSizeShowText: function () {
			return this.fileUploadUtil.maxFileSizeShowText;
		},
		/**
		 * 获取上传最少文件个数
		 * @results 上传最大文件个数
		 */
		getMinFileNumber: function () {
			return this.minFileNumber;
		},
		/**
		 * 获取上传最多文件个数
		 * @results 上传最大文件个数
		 */
		getMaxFileNumber: function () {
			return this.fileUploadUtil.maxFileNumber;
		}
	}
});
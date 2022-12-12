(function() {
	ThsUploderUtil = {};
	ThsUploderUtil.pickUploader = {};
	ThsUploderUtil.ThsUploaderArray = {};
	ThsUploderUtil.initFlag = false;
	ThsUploderUtil.deleteFileIds = "";

	//获取当前所有文件的ajax请求中的data属性数据
    ThsUploderUtil.data;
    //获取的所有文件的信息
    ThsUploderUtil.files = [];

    if(typeof uploaderMimeTypes == "undefined"){
		uploaderMimeTypes = "*";
	}
	if(typeof uploaderMaxUploadSize == "undefined"){
		uploaderMaxUploadSize = "-1";
	}
	ThsUploderUtil.opts = {
		"get_breakpoint_url" : ctx+ "/eform/uploader/getBreakPoint.vm",
		"chunk_check_url" : ctx + "/eform/uploader/chunk/check.vm",
		"chunk_merge_url" : ctx + "/eform/uploader/chunk/merge.vm",
		"delete_url" : ctx + "/eform/uploader/{1}/delete.vm",
		"download_url" : ctx + "/eform/uploader/{1}/download.vm",
		"get_files_url": ctx+"/eform/uploader/files.vm",
		"delete_thread_url" : ctx + "/eform/uploader/thread/{1}/delete.vm",
		//根据fileId集合批量删除附件地址
		"batch_delete_url": ctx + "/eform/uploader/delete.vm",
		// swf文件路径
		"swf" : ctx + "/assets/components/webuploader/Uploader.swf",
		// 文件接收服务端。
		"server" : ctx + "/eform/uploader.vm",
		//	{Selector} [可选] [默认值：undefined] 指定Drag And Drop拖拽的容器，如果不指定，则不启动。
		dnd : undefined,
		//	{Selector} [可选] [默认值：false] 是否禁掉整个页面的拖拽功能，如果不禁用，图片拖进来的时候会默认被浏览器打开。
		disableGlobalDnd : false,
		//	{Selector} [可选] [默认值：undefined] 指定监听paste事件的容器，如果不指定，不启用此功能。此功能为通过粘贴来添加截屏的图片。建议设置为document.body.
		paste : undefined,
		// 	{Array} [可选] [默认值：undefined] 指定接受哪些类型的文件。 由于目前还有ext转mimeType表，所以这里需要分开指定。
		/* 例：
		{
		    title: 'Images', //	{String} 文字描述
		    extensions: 'gif,jpg,jpeg,bmp,png', // {String} 允许的文件后缀，不带点，多个用逗号分割。
		    mimeTypes: 'image/*' // {String} 多个用逗号分割。
		}
		 */
		accept : {
		    title: 'customFile',
		    extensions: uploaderMimeTypes.replace(/\./g, ""),
		    mimeTypes: uploaderMimeTypes
		},
		// {Object} [可选] 配置生成缩略图的选项。
		thumb : {
			width : 110,
			height : 110,
			// 图片质量，只有type为`image/jpeg`的时候才有效。
			quality : 70,
			// 是否允许放大，如果想要生成小图的时候不失真，此选项应该设置为false.
			allowMagnify : true,
			// 是否允许裁剪。
			crop : true,
			// 为空的话则保留原有图片格式。
			// 否则强制转换成指定的类型。
			type : 'image/jpeg'
		},
		// {Object} [可选] 配置压缩的图片的选项。如果此选项为false, 则图片在上传前不进行压缩。
		compress : {
			width : 1600,
			height : 1600,
			// 图片质量，只有type为`image/jpeg`的时候才有效。
			quality : 90,
			// 是否允许放大，如果想要生成小图的时候不失真，此选项应该设置为false.
			allowMagnify : false,
			// 是否允许裁剪。
			crop : false,
			// 是否保留头部meta信息。
			preserveHeaders : true,
			// 如果发现压缩后文件大小比原来还大，则使用原来图片
			// 此属性可能会影响图片自动纠正功能
			noCompressIfLarger : false,
			// 单位字节，如果图片大小小于此值，不会采用压缩。
			compressSize : 0
		},
		// {Boolean} [可选] [默认值：false] 设置为 true 后，不需要手动调用上传，有文件选择即开始上传。
		auto : true,
		// {Object} [可选] [默认值：html5,flash] 指定运行时启动顺序。默认会先尝试 html5 是否支持，如果支持则使用 html5, 否则使用 flash.可以将此值设置成 flash，来强制使用 flash 运行时。
		runtimeOrder : "html5,flash",
		// {Boolean} [可选] [默认值：false] 是否允许在文件传输时提前把下一个文件准备好。 某些文件的准备工作比较耗时（比如图片压缩，md5序列化）， 如果能提前在当前文件传输期处理，可以节省总体耗时。
		prepareNextFile : true,
		// {Boolean} [可选] [默认值：false] 是否要分片处理大文件上传。
		chunked : true,
		// {Boolean} [可选] [默认值：5242880] 如果要分片，分多大一片？ 默认大小为5M.
		chunkSize : 5 * 1024 * 1024,
		// {Boolean} [可选] [默认值：2] 如果某个分片由于网络问题出错，允许自动重传多少次？
		chunkRetry : 2,
		// {Boolean} [可选] [默认值：3] 上传并发数。允许同时最大上传进程数。
		threads : 10,
		// {Object} [可选] [默认值：{}] 文件上传请求的参数表，每次发送都会发送此对象中的参数。
		formData : {},
		// {Object} [可选] [默认值：'file'] 设置文件上传域的name。
		fileVal : "file",
		// {Object} [可选] [默认值：'POST'] 文件上传方式，POST或者GET。
		method : "POST",
		// {Object} [可选] [默认值：false] 是否已二进制的流的方式发送文件，这样整个上传内容php://input都为文件内容， 其他参数在$_GET数组中。
		sendAsBinary : false,
		// {int} [可选] [默认值：undefined] 验证文件总数量, 超出则不允许加入队列。
		fileNumLimit : undefined,
		// {int} [可选] [默认值：undefined] 验证文件总大小是否超出限制, 超出则不允许加入队列。
		fileSizeLimit : undefined,
		// {int} [可选] [默认值：undefined] 验证单个文件大小是否超出限制, 超出则不允许加入队列。
		fileSingleSizeLimit : uploaderMaxUploadSize == "-1" ? undefined : uploaderMaxUploadSize,
		// {Boolean} [可选] [默认值：undefined] false去重，true为不去重， 根据文件名字、文件大小和最后修改时间来生成hash Key.
		duplicate : false,
		// {String, Array} [可选] [默认值：undefined] 默认所有 Uploader.register 了的 widget 都会被加载，如果禁用某一部分，请通过此 option 指定黑名单。
		disableWidgets : undefined
	};
	ThsUploderUtil.register = function() {
		// 监听分块上传的时间点，断点续传
		WebUploader.Uploader.register(
			{
				"before-send-file" : "beforeSendFile",
				"before-send" : "beforeSend",
				"after-send-file" : "afterSendFile"
			},
			{
				//上传文件之前，将文件的md5串作为参数传到后台
				beforeSendFile : function(file) {
					// 创建一个deffered,用于通知是否完成操作
					var deferred = WebUploader.Deferred();
					var _uploader = this;
					// 返回的是 promise 对象
					_uploader.owner.md5File(file, 0, 5 * 1024 * 1024)
					// 可以用来监听进度
					.progress(function(percentage) {
					})
					// 处理完成后触发
					.then(function(ret) {
						_uploader.options.formData.chunkSize = ThsUploderUtil.opts.chunkSize;
						_uploader.options.formData.sort = file.sort;
						//设置文件fileMd5参数
						file.md5 = ret;
						//参数
						var data = {
							// 文件唯一表示
							fileMd5 : file.md5,
							//文件名称
							name: file.name,
							//文件大小
							size: file.size,
							//根据文件名字、文件大小和最后修改时间来生成hash Key.
							fileHash: file.__hash,
							//当前uploader所存在的断点
							breakPoints: _uploader.options.breakPoints,
							//断点所涉及到的文件id
							breakFileids: _uploader.options.breakFileids,
							//断点处涉及到的文件的MD5值
							breakFileMd5s: _uploader.options.breakFileMd5s,
							//扩展参数
							extParams: {}
						};
						if(_uploader.options.formData != null){
							for(var key in _uploader.options.formData){
								if(key.indexOf("extParams") == 0){
									data.extParams[key.substring(key.indexOf(".") + 1)] = _uploader.options.formData[key];
								}else{
									data[key] = _uploader.options.formData[key];
								}
							}
						}
						//确定文件是否存在断点目录
						$.ajax({
							type : "POST",
							url : ThsUploderUtil.opts.get_breakpoint_url,
							async : false,
							data : data,
							dataType:"json",
							success : function(response) {
								//上传成功
								if(response.code == 1){
									if(response.breakPoint){
										_uploader.options.formData.breakPoint=response.breakPoint;
									}
									if(response.pkId){
										file.source.fileId = response.pkId;
										_uploader.options.formData.pkId=response.pkId;
									}
									//放行
									deferred.resolve();
								}else{ //上传失败
									file.response = response;
									deferred.reject();
								}
							}
						});
					});
					// 通知完成操作
					return deferred.promise();
				},
				//
				beforeSend : function(block) {
					var _uploader = this;
					var deferred = WebUploader.Deferred();
					// 支持断点续传，发送到后台判断是否已经上传过
					$.ajax({
						type : "POST",
						url : ThsUploderUtil.opts.chunk_check_url,
						async : false,
						data : {
							// 文件上传路径
							fileDirectory: _uploader.options.formData.fileDirectory,
							// 文件唯一表示
							fileMd5: block.file.md5,
							// 当前分块下标
							chunk: block.chunk,
							// 当前分块大小
							chunkSize: block.end - block.start,
							//当前文件的断点
							breakPoint: _uploader.options.formData.breakPoint ? _uploader.options.formData.breakPoint : "",
							//目录时间格式
							dicDateFormat: _uploader.options.formData.dicDateFormat
						},
						success : function(response) {
							if (response == "true") { // 分块存在，跳过该分块
								deferred.reject();
							} else {// 分块不存在或不完整，重新发送
								deferred.resolve();
							}
						}
					});
					return deferred.promise();
				},
				//上传文件完成之后，合并分块
				afterSendFile : function(file) {
					var _uploader = this;
					var deferred = WebUploader.Deferred();
					// 通知合并分块
					$.ajax({
						type : "POST",
						url : ThsUploderUtil.opts.chunk_merge_url,
						async : false,
						dataType : "json",
						data : {
							// 文件唯一表示                               
							fileMd5 : file.md5,
							//数据源
							dataSource: _uploader.options.formData.dataSource
						},
						success : function(response) {
							file.response = response;
						}
					});
					deferred.resolve();
					return deferred.promise();
				}
			}
		);
	};
	ThsUploderUtil.init = function() {
		if (!ThsUploderUtil.initFlag) {
			ThsUploderUtil.register();
			ThsUploderUtil.initFlag = true;
		}
	};
	ThsUploderUtil.create = function(opts) {
		var _opts = $.extend({}, ThsUploderUtil.opts, opts);
		ThsUploderUtil.init();
		var uploader = WebUploader.create({
			swf : _opts.swf,
			server : _opts.server,
			// 选择文件的按钮。可选。
			// 内部根据当前运行是创建，可能是input元素，也可能是flash.
			pick : {
				id: _opts.pick,
				multiple: _opts.multifile == "true"
			},
			dnd : _opts.dnd,
			disableGlobalDnd : _opts.disableGlobalDnd,
			paste : _opts.paste,
			accept : _opts.accept,
			mimeTypes : _opts.accept,
			thumb : _opts.thumb,
			compress : _opts.compress,
			auto : _opts.auto,
			runtimeOrder : _opts.runtimeOrder,
			prepareNextFile : _opts.prepareNextFile,
			chunked : _opts.chunked,
			chunkSize : _opts.chunkSize,
			chunkRetry : _opts.chunkRetry,
			threads : _opts.threads,
			formData : _opts.formData,
			fileVal : _opts.fileVal,
			method : _opts.method,
			sendAsBinary : _opts.sendAsBinary,
			fileNumLimit : _opts.fileNumLimit,
			fileSizeLimit : _opts.fileSizeLimit,
			fileSingleSizeLimit : _opts.fileSingleSizeLimit,
			duplicate : _opts.duplicate,
			disableWidgets : _opts.disableWidgets
		});
		if(opts.params){
			uploader.options.formData = $.extend({}, uploader.options.formData, opts.params);
		}
		uploader.options.formData.fileDirectory = opts.fileDirectory;
		if (opts.dataSource) {
			uploader.options.formData.dataSource = opts.dataSource;
		}
		ThsUploderUtil.pickUploader[_opts.pick] = uploader;
		return uploader;
	};
	ThsUploderUtil.deleteFileQueued = function(pick, fileId){
		if(ThsUploderUtil.pickUploader[pick]){
			var file = ThsUploderUtil.getFileById(ThsUploderUtil.pickUploader[pick], fileId);
			if(file != null){
				ThsUploderUtil.deleteFileIds += (ThsUploderUtil.deleteFileIds == "" ? "" : ",") + fileId;
				ThsUploderUtil.pickUploader[pick].removeFile(file, true);
			}
		}
	};

	//获取指定文件信息
	ThsUploderUtil.getFileById = function(uploader, fileId){
		var files = uploader.getFiles();
		for(var i = 0; i < files.length; i++){
			if(files[i].id === fileId){
				return files[i];
			}
		}
		return null;
	};

    //预览文件
    ThsUploderUtil.previewFile = function(file){
        console.log(file);
    	//1.将.jdpf文件另存为真实文件
		//真实的文件后缀
		var fileId = file.source.fileId;
       	$.ajax({
            type: "post",
            url : ctx+"/eform/uploader/"+fileId+"/conversionSuffix.vm",
            dataType:'json',
            success: function(result){
                if (result.code === 200) {
                    //要预览文件的访问地址
                    var kkFileViewUrl = result.kkFileViewUrl;
                    //版本
                    var kkFileViewVersion = result.kkFileViewVersion;
                    var fileServer = result.fileServer;
                    var realFileName = result.realFileName;
                    var fileDesk=result.fileDesk;
                    var encodeUrl = encodeURIComponent(fileServer+realFileName);
                    if (kkFileViewVersion === "3") {
                        encodeUrl = encodeURIComponent(base64Encode(fileServer+realFileName));
                    }
                    //kkFileViewUrl+'onlinePreview?url='+encodeURIComponent("http://localhost:9096/eodesk/eform/uploader/downRealFile.vm?fileDesk="+fileDesk+"&fileName="+realFileName+"&fullfilename="+realFileName)
                    dialog({
                        title:"预览",
                        url: kkFileViewUrl+'onlinePreview?url='+encodeUrl,
                        width: 1000 > window.parent.document.documentElement.clientWidth ? window.parent.document.documentElement.clientWidth : 1000,
                        height: 600 > window.parent.document.documentElement.clientHeight ? window.parent.document.documentElement.clientHeight : 600
                    }).showModal();
                }else{
                    dialog({
                        title:"错误",
                        content:result.message,
                        wraperstyle:'alert-warning',
                        width: 500 > window.parent.document.documentElement.clientWidth ? window.parent.document.documentElement.clientWidth : 500,
                        height: 100 > window.parent.document.documentElement.clientHeight ? window.parent.document.documentElement.clientHeight : 100
                    }).showModal();
                }
            },
            error:function () {
                dialog({
                    title: '错误',
                    icon:'fa-times-circle',
                    wraperstyle:'alert-warning',
                    content: '服务器异常',
                    ok: function () {

                    },
                    cancel:function(){}
                }).showModal()
            }
        });
    };

	ThsUploderUtil.downFile = function(fileId){
		location.href=ThsUploderUtil.opts.download_url.replace("{1}", fileId);
	};
	//初始化outside模式的input框文件名称
	ThsUploderUtil.initOutsideInputFileNames = function(fileInputId){
		if($("#" + fileInputId + "_input").length > 0){
			var fileNames = "";
			var thsUploader = ThsUploderUtil.ThsUploaderArray[fileInputId];
			var files = thsUploader.getUploader().getFiles();
			if(files != null && files.length > 0){
				for(var i = 0; i < files.length; i++){
					if(files[i].getStatus() != "cancelled"){
						fileNames += (fileNames == "" ? "" : ";") + files[i].name;
					}
				}
			}
			$("#" + fileInputId + "_input").val(fileNames);
		}
	};
	//文件校验失败方法
	ThsUploderUtil.checkFileError = function(code, file, uploader){
		var msg = code;
		if(code == "F_EXCEED_SIZE"){
			msg = "【" + file.name + "】文件大小超过限制，最大为：" + uploader.options.fileSingleSizeLimit/1024/1024 + "MB";
		}else if(code == "Q_EXCEED_SIZE_LIMIT"){
			msg = "队列总文件大小超过限制，最大为：" + uploader.options.fileSizeLimit/1024/1024 + "MB";
		}else if(code == "Q_EXCEED_NUM_LIMIT"){
			msg = "队列总文件个数超过限制，最多上传" + uploader.options.fileNumLimit  + "文件";
		}else if(code == "Q_TYPE_DENIED"){
			if(!file || file.size < 6){
				msg = "【" + file.name + "】为空文件";
			}else{
				msg = "【." + file.ext + "】文件类型被禁止上传";
			}
		}else if(code == "F_DUPLICATE"){
			msg = "【" + file.name + "】文件已存在";
		}
		if(msg != null){
			alert(msg);
			console.log(msg);
		}
	};
	//获取文件Id
    ThsUploderUtil.getFiles= function(){
        console.log(ThsUploderUtil.data)
        $.ajax({
            type: "POST",
            url: ThsUploderUtil.opts.get_files_url,
            data: ThsUploderUtil.data,
            async: false,
            dataType: "json",
            success: function(response) {
                ThsUploderUtil.files = response;
                console.log(ThsUploderUtil.files)
            }
        });
        return ThsUploderUtil.files;
	}
	
	ThsUploder = function(opts) {
		//放置全局对象
		ThsUploderUtil.ThsUploaderArray[opts.pick] = this;
		var _this = this;
		var uploader = null;
		this.init = function(opts){
			if(!this.startWith(opts.pick, "#")){
				opts.pick = "#" + opts.pick;
			}
			this.create(opts);
		};
		
		this.startWith = function(str1, str){     
			var reg = new RegExp("^"+str);     
			return reg.test(str1);        
		};
		
		this.create = function(opts) {
			//设置默认为编辑模式
			opts.editType = opts.editType == "view" ? "view" : "edit";
			//单文件上传样式，先设置后创建uploader。
			if(opts.multifile != "true"){
				$(opts.pick).addClass("act-input-file");
				$(opts.pick).html("<label class=\"ace-file-input\"><span class=\"ace-file-container\" data-title=\"选择\"><span class=\"ace-file-name\" data-title=\"No File ...\"><i class=\" ace-icon fa fa-upload\"></i></span></span></label>");
			}
			//创建WebUploader对象
			uploader = ThsUploderUtil.create(opts);
			//设置deleteFileBeforeUpload属性，默认为false
			uploader.options.formData.deleteFileBeforeUpload = false;
			
			var myVar = setInterval(
				function(){
					if($("#"+opts.params.inputFileId).find("#dndArea")[0] && opts.params && opts.params.businessKey){
						 clearInterval(myVar);
						if(opts.params && opts.params.businessKey){
							_this.initFiles(opts);
							//初始化文件名
							if(uploader.getFiles().length > 0){
								if(opts.multifile != "true"){
									$(opts.pick).find(".ace-file-name").attr("data-title", uploader.getFiles()[0].name);
									//查看时显示下载按钮，将选择事件取消
									console.log($(opts.pick).find(".ace-file-container").width() - 27)
									$(opts.pick).find(".ace-file-container").width("99.5%");
									$(opts.pick).find(".remove").css({"right": "5px", "z-index": "99"});
									$(opts.pick).find(".remove").show();
									if(opts.editType == "view"){
										$(opts.pick).find(".webuploader-pick-single").css("z-index", "99");
										$(opts.pick).find(".remove > i").removeClass("fa-times");
										$(opts.pick).find(".remove > i").addClass("fa-download");
										$(opts.pick).find(".remove").css("background", "#0ada0a");
										$(opts.pick).find(".remove").attr("onclick", "ThsUploderUtil.downFile('" + uploader.getFiles()[0].source.fileId + "');");
									}else{ //编辑操作时，显示删除按钮
										$(opts.pick).find(".remove").attr("onclick", "jdp_eform_clickRemoveFileBtn(this);");
									}
								}
							}else{

							}
						}
						//查看模式将选择文件按钮隐藏
						if(opts.editType == "view"){
							if(opts.multifile != "true"){
								$(opts.pick).find(".webuploader-container").hide();
							}else if(uploader.getFiles().length<=0){
								$(opts.pick).find(".webuploader-pick").text("暂无内容");
								$(opts.pick).find(".webuploader-pick").css("pointer-events","none");
							}
						}
					}
				},10);
			//判断是否为单文件上传
			if (opts.multifile != "true") {
				//设置上传前删除原有文件（暂不用，单文件上传改为上传完成再删除原来文件）
				//uploader.options.formData.deleteFileBeforeUpload = true;
				$($(opts.pick).find("div").first()).addClass("webuploader-pick-single");
				//在添加队列前
				uploader.on('beforeFileQueued', function(file) {
					uploader.preFiles = uploader.getFiles();
					uploader.reset();
				});
				//添加队列
				uploader.on('fileQueued', function(file) {
					$(opts.pick).find(".ace-file-name").attr("data-title", file.name);
				});
				//验证错误
				uploader.on('error', function(code, file) {
				    ThsUploderUtil.checkFileError(code, file, uploader);
				});
				//上传进度
				uploader.on('uploadProgress', function( file, percentage ) {
					//$percent.css( 'width', percentage * 100 + '%' );
				});
				//上传失败事件
				uploader.on('uploadError', function(file) {
					console.log('上传出错' + file.response);
					uploader.response = file.response;
				});
				//上传完成
				uploader.on('uploadComplete', function(file) {
					uploader.response = file.response;
					//回显附件名称
		    		ThsUploderUtil.initOutsideInputFileNames($(opts.pick).attr("id"));
				});
				//所有文件上传完成
				uploader.on('uploadFinished', function() {
					//删除原来的文件
					if(uploader.preFiles != null && uploader.preFiles.length > 0
							&& uploader.response != null && uploader.response.code == 1){
						_this.deleteFile(uploader.preFiles[0].source.fileId);
						uploader.preFiles = null;
					}
					uploader.options.UPLOAD_COMPLETE_FLAG = true;
					//回显附件名称
		    		ThsUploderUtil.initOutsideInputFileNames($(opts.pick).attr("id"));
				});
			} else {
				if(opts.theme && opts.theme!=''){
					$("head").append("<link>");
					var css = $("head").children(":last");
					css.attr({
						rel: "stylesheet",
						type: "text/css",
						href: ctx + "/assets/js/eform/upload/" + opts.theme + "/" + opts.theme + ".css"
					});
					$.getScript(ctx + "/assets/js/eform/upload/" + opts.theme + "/" + opts.theme + ".js", function(){
						Theme.uploader(uploader, opts, _this);
					});
				}else{
					$(opts.pick).prepend("<div id=\"" + opts.pick.substring(1) + "_thelist\" class=\"queueList\" style=\"width: 100%;\"></div>");

					// 当有文件被添加进队列的时候
					uploader.on('fileQueued', function(file) {
						$(opts.pick + "_thelist").append(
							'	<div id="thsuploader_' + file.id + '" style="border-bottom: 1px dotted #D0D8E0; height: 45px; width: 100%;">'
							+ '		<div style="float: left; height: 45px; width: 90%;">'
							+ '			<div style="height: 25px;">' + file.name + '</div>'
							+ '			<div class="progress progress-striped pos-rel active" style="width: 100%; color: black; height: 15px; margin-bottom: 0px; float: left;" data-percent="0%">'
							+ '		    	<div class="progress-bar" style="width: 0px"></div>'
							+ '			</div>'
							+ ' 	</div>'
							+ '		<div style="float: right; height: 45px; width: 10%; padding: 14px 4px;">'
							+ '			<div style="float: right; height: 45px;">'
							+ '				<a href="#" onclick="ThsUploderUtil.deleteFileQueued(\'' + opts.pick + '\', \'' + file.id + '\')" class="red">'
							+ '					<i class="ace-icon fa fa-times bigger-125"></i>'
							+ '				</a>'
							+ '	    	</div>'
							+ '		</div>'
							+ '	</div>'
						);
					});
					uploader.on('error', function(code, file) {
					    ThsUploderUtil.checkFileError(code, file, uploader);
					});
					//当有文件被移除队列时触发
					uploader.on('fileDequeued', function(file) {
						if($("#thsuploader_" + file.id).attr("fileId")){
							ThsUploderUtil.deleteFileIds += (ThsUploderUtil.deleteFileIds == "" ? "" : ",") + $("#thsuploader_" + file.id).attr("fileId");
						}
						$("#thsuploader_" + file.id).remove();
					});
					// 文件上传过程中创建进度条实时显示。
					uploader.on('uploadProgress', function(file, percentage) {
						var progress = percentage * 100 + "";
						if(progress.indexOf(".") > -1){
							progress = progress.substring(0, progress.indexOf("."));
						}
						$("#thsuploader_" + file.id).find(".progress").attr("data-percent", progress + "%");
						$("#thsuploader_" + file.id).find(".progress-bar").css("width", progress + "%");
					});
					//上传成功
					uploader.on('uploadSuccess', function(file) {
						$("#" + file.id).find(".state").html("上传成功");
					});
					//上传失败事件
					uploader.on('uploadError', function(file) {
						console.log('上传出错' + file.response);
						if (uploader.response == null) {
							uploader.response = [];
						}
						$("#thsuploader_" + file.id).attr("fileId", file.response.fileId);
						uploader.response.push(file.response);
					});
					//单个文件上传完成
					uploader.on('uploadComplete', function(file) {
						if (uploader.response == null) {
							uploader.response = [];
						}
						$("#thsuploader_" + file.id).attr("fileId", file.response.fileId);
						uploader.response.push(file.response);
						//回显附件名称
			    		ThsUploderUtil.initOutsideInputFileNames($(opts.pick).attr("id"));
					});
					//所有文件上传完成
					uploader.on('uploadFinished', function() {
						uploader.options.UPLOAD_COMPLETE_FLAG = true;
						//回显附件名称
			    		ThsUploderUtil.initOutsideInputFileNames($(opts.pick).attr("id"));
					});
				}
				
				//设置外部显示
				if(opts.outside){
					//隐藏多选控件，在dialog中显示
					$(opts.pick).hide();
					//设置一个上传按钮
					$(opts.pick).parent().append(
						'	<div class="input-group multifile-outside">'
						+ '		<i class="ace-icon fa fa-upload"></i>'
						+ '		<input type="text" class="form-control multifile-input" id="' + $(opts.pick).attr("id") + '_input" readonly="readonly">'
						+ '		<span class="input-group-btn">'
						+ '			<button type="button" onclick="jdp_eform_openMultifileUploadDialog(\'' + $(opts.pick).attr("id") + '\')">'
						+ '				附件'
						+ '			</button>'
						+ '		</span>'
						+ '	</div>'
					);
					if($(opts.pick).attr("data-validation-engine") != null){
						$("#" + $(opts.pick).attr("id") + "_input").attr("data-validation-engine", $(opts.pick).attr("data-validation-engine"));
					}
					//显示附件名称
					ThsUploderUtil.initOutsideInputFileNames($(opts.pick).attr("id"));
				}
			}
		};
		
		this.deleteFile = function(fileId){
			$.ajax({
				type : "POST",
				url : ThsUploderUtil.opts.delete_url.replace("{1}", fileId),
				async : false,
				dataType : "json",
				success : function(response) {
					//console.log(response);
				}
			});
		};

		this.upload = function(callback) {
			uploader.response = null;
			//删除附件（删除行时存在的附件需要删除）
			if(ThsUploderUtil.deleteFileIds != null && ThsUploderUtil.deleteFileIds != ""){
				var deleteFileIds = ThsUploderUtil.deleteFileIds;
				ThsUploderUtil.deleteFileIds = "";
				$.ajax({
					url: ThsUploderUtil.opts.batch_delete_url,
					data: "fileIds=" + deleteFileIds,
					type: "post",
					dataType: "json",
					async: false,
					success:function(response){
					}
				});
			}
			uploader.options.UPLOAD_COMPLETE_FLAG = true;
			//检测是否有未上传文件
			var files = uploader.getFiles();
			for(var i = 0; i < files.length; i++){
				//将error文件设置为队列
				if(files[i].getStatus() == "error"){
					files[i].setStatus("queued");
				}
				//如果状态不为完成，则标识完成状态为false
				if(files[i].getStatus() != "complete"){
					uploader.options.UPLOAD_COMPLETE_FLAG = false;
				}else{ //需要记录返回结果
					if(uploader.options.pick.multiple == true){ //多附件上传
						if (uploader.response == null) {
							uploader.response = [];
						}
						uploader.response.push({fileId: files[i].source.fileId});
					}else{ //单附件上传
						uploader.response = {fileId: files[i].source.fileId};
					}
				}
			}
			//如果有未上传文件，调用上传方法
			if(uploader.options.UPLOAD_COMPLETE_FLAG == false){
				uploader.upload();
			}
			//定时检测上传完成状态
			var tt = window.setInterval(function() {
				if (uploader.options.UPLOAD_COMPLETE_FLAG == true) {
					if (typeof callback === "function") {
						callback(uploader.response);
					}
					window.clearInterval(tt);
				}
			}, 200);
		};
		
		this.getUploader = function(){
			return uploader;
		};
		
		this.initFiles = function(opts){
			if(opts.params.businessKey == null || opts.params.businessKey == "" || opts.params.inputFileId == null 
					|| opts.params.inputFileId == ""){
				return;
			}
			var data;
			if(opts.params.subBusinessKey != null && opts.params.subBusinessKey != ""){
				data = {'form[BUSINESS_KEY]': opts.params.businessKey, 'form[INPUT_FILE_ID]': opts.params.inputFileId, 'form[SUB_BUSINESS_KEY]': opts.params.subBusinessKey};
			}else{
				data = {'form[BUSINESS_KEY]': opts.params.businessKey, 'form[INPUT_FILE_ID]': opts.params.inputFileId};
			}
			//放入全局变量data中
            ThsUploderUtil.data = data;

			$.ajax({
				type: "POST",
				url: ThsUploderUtil.opts.get_files_url,
				data: data,
				async: false,
				dataType: "json",
				success: function(response) {
                    console.log(response)
					if(response && response.length > 0){
						var breakPoints = "";
						var breakFileids = "";
						var breakFileMd5s = "";
						for(var i = 0; i < response.length; i++){
							if(response[i].FILE_STATUS == "1"){
								var source = {
									id: "WU_FILE_" + i,
									name: response[i].FILE_NAME,
									fileId: response[i].FILE_ID,
									size: parseInt(response[i].FILE_SIZE),
									md5: response[i].FILE_MD5
								}
								var _file = new WebUploader.File(source);
								_file.__hash = response[i].FILE_HASH;
								//先放进queued，再改变状态
								uploader.addFiles(_file);
								_file.setStatus("complete");
							}else{
								breakPoints += response[i].FILE_PATH + ";";
								breakFileids += response[i].FILE_ID + ";";
								breakFileMd5s += response[i].FILE_MD5 + ";";
							}
						}
						uploader.options.breakPoints = breakPoints;
						uploader.options.breakFileids = breakFileids;
						uploader.options.breakFileMd5s = breakFileMd5s;
					}
				}
			});
		};
		
		this.checkUpload = function(){
			if(opts.theme && opts.theme!=""){
				return Theme.checkUpload(opts)
			}else{
				return true;
			}
		}
		
		this.init(opts);
		
		this.refresh=function(){
			uploader.refresh();
		}
	};
})();
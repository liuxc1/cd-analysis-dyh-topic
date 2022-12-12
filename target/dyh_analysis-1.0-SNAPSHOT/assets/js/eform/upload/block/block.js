var Theme={};
Theme.uploader=function(_uploader,opts){
	if(opts.theme=='block'){
		var $ = jQuery,$wrap ;
		// 实例化
		var uploader =_uploader;
		$wrap=$(opts.pick);
		var $content=$wrap.children();
		$wrap.append('<div class="queueList"><div id="dndArea" class="placeholder"><div id="filePicker_'+opts.pick.replace("#","")+'" class="filePicker"></div><p></p></div></div>');
		if(_uploader.options.auto){
			$wrap.append('<div class="statusBar" style="display:none;"><div class="progress"><span class="text">0%</span><span class="percentage"></span></div><div class="btns"><div id="filePicker2_'+opts.pick.replace("#","")+'" class="filePicker2"></div></div><div class="info"></div></div>');
		}else{
			$wrap.append('<div class="statusBar" style="display:none;"><div class="progress"><span class="text">0%</span><span class="percentage"></span></div><div class="btns"><div id="filePicker2_'+opts.pick.replace("#","")+'" class="filePicker2"></div><div class="info"></div><div class="uploadBtn">开始上传</div></div></div>');
		}
		$content.remove();
		// 图片容器
	    var $queue = $('<ul class="filelist" style="pointer-events:auto;"></ul>')
	        .appendTo( $wrap.find('.queueList') ),

	    // 状态栏，包括进度和控制按钮
	    $statusBar = $wrap.find('.statusBar'),

	    // 文件总体选择信息。
	    $info = $statusBar.find('.info'),

	    // 上传按钮
	    $upload = $wrap.find('.uploadBtn'),

	    // 没选择文件之前的内容。
	    $placeHolder = $wrap.find('.placeholder'),

	    // 总体进度条
	    $progress = $statusBar.find('.progress').hide(),

	    // 添加的文件数量
	    fileCount = 0,

		//文件列表
		fileList = [],

	    // 添加的文件总大小
	    fileSize = 0,

	    // 优化retina, 在retina下这个值是2
	    ratio = window.devicePixelRatio || 1,

	    // 缩略图大小
	    thumbnailWidth = 110 * ratio,
	    thumbnailHeight = 110 * ratio,

	    // 可能有pedding, ready, uploading, confirm, done.
	    state = 'pedding',

	    // 所有文件的进度信息，key为file id
	    percentages = {},

	    supportTransition = (function(){
	        var s = document.createElement('p').style,
	            r = 'transition' in s ||
	                  'WebkitTransition' in s ||
	                  'MozTransition' in s ||
	                  'msTransition' in s ||
	                  'OTransition' in s;
	        s = null;
	        return r;
	    })();
		uploader.addButton({
		    id: "#filePicker_"+opts.pick.replace("#",""),
		    label: '添加文件'
		});
		if(!_uploader.options.fileNumLimit || _uploader.options.fileNumLimit > 1){
			// 添加“添加文件”的按钮，
			uploader.addButton({
			    id: "#filePicker2_"+opts.pick.replace("#",""),
			    label: '继续添加'
			});
		}
		// 当有文件添加进来时执行，负责view的创建
		function addFile( file ) {
			file.sort=file.id.replace(/[^0-9]/ig,"");
			var firstSpan='<span class="download"></span><span class="read"></i></span>';
			if(opts.editType!="view"){
				firstSpan = '<span class="cancel"></span>' + firstSpan;
			}
		    var $li = $( '<li id="' + file.id + '">' +
		            '<p class="imgWrap"></p>'+
		            '<p class="progress"><span></span></p>' +
		            '</li>' ),
		        $btns = $('<div class="file-panel">' +firstSpan +
		            '</div>').appendTo( $li ),
		        $prgress = $li.find('p.progress span'),
		        $wrap = $li.find( 'p.imgWrap' ),
		        $info = $('<p class="error"></p>'),
		        showError = function( code ) {
		            switch( code ) {
		                case 'exceed_size':
		                    text = '文件大小超出';
		                    break;
		
		                case 'interrupt':
		                    text = '上传暂停';
		                    break;
		
		                default:
		                    text = '上传失败，请重试';
		                    break;
		            }
		            $info.text( text ).appendTo( $li );
		        };
		    if ( file.getStatus() === 'invalid' ) {
		        showError( file.statusText );
		    } else {
		        // @todo lazyload
		        $wrap.text( '预览中' );
		        uploader.makeThumb( file, function( error, src ) {
		            if ( error ) {
		            	if(isImage(file.ext)){
		            		var img = $('<img src="'+ctx+'/eform/uploader/{1}/preview.vm">'.replace("{1}", file.source.fileId));
				            $wrap.empty().append( img );
		            		return;
		            	}else{
		            		$wrap.text('');
			            	$wrap.append('<p style="font-size:60px;">'+createThump(file)+'</p>');
			            	$wrap.append('<p class="title" style="padding-top:30px" title="'+file.name+'">'+file.name+'</p>')
			            	return;
		            	}
		            }
		            var img = $('<img src="'+src+'">');
		            $wrap.empty().append( img );
		        }, thumbnailWidth, thumbnailHeight );
		        
		        if(file.getStatus()=="complete"){
		        	percentages[ file.id ] = [ file.size, 1 ,"complete" ];
		        }else{
		        	percentages[ file.id ] = [ file.size, 0 ];
		        }
		        file.rotation = 0;
		    }
		    file.on('statuschange', function( cur, prev ) {
		        if ( prev === 'progress' ) {
		            $prgress.hide().width(0);
		        } else if ( prev === 'queued' ) {
		            //$li.off( 'mouseenter mouseleave' );
		            //$btns.find("span:gt(0)").remove();
		        }
		
		        // 成功
		        if ( cur === 'error' || cur === 'invalid' ) {
		            console.log( file.statusText );
		            showError( file.statusText );
		            percentages[ file.id ][ 1 ] = 1;
		        } else if ( cur === 'interrupt' ) {
		            showError( 'interrupt' );
		        } else if ( cur === 'queued' ) {
		            percentages[ file.id ][ 1 ] = 0;
		        } else if ( cur === 'progress' ) {
		            $info.remove();
		            $prgress.css('display', 'block');
		        } else if ( cur === 'complete' ) {
		        	if(opts.editType=='edit'){
		        		$li.append( '<span class="success"></span>' );
		        	}
		        }
		
		        $li.removeClass( 'state-' + prev ).addClass( 'state-' + cur );
		    });
		
		    $li.on( 'mouseenter', function() {
		        $btns.stop().animate({height: 30});
		    });
		
		    $li.on( 'mouseleave', function() {
		        $btns.stop().animate({height: 0});
		    });

		    $btns.on( 'click', 'span', function() {
		        var index = $(this).index(),
		            deg;
		        if ($(this).hasClass("read")){
                    ThsUploderUtil.previewFile( file );
				}else if($(this).hasClass("cancel")){
                    dialog({
                        id:"dialog-delete",
                        title: "提示",
                        wraperstyle:'alert-warning',
						content:"确定要删除文件吗?",
                        width:500 > window.parent.document.documentElement.clientWidth ? window.parent.document.documentElement.clientWidth : 500,
                        height:50 > window.parent.document.documentElement.clientHeight ? window.parent.document.documentElement.clientHeight : 50,
                        ok:function () {
                            uploader.removeFile( file );
                        }
                    }).showModal();
		        }else if($(this).hasClass("download")){
		        	ThsUploderUtil.downFile( file.source.fileId );
		        }else if($(this).hasClass("rotateRight")){
		        	 file.rotation += 90;
		        }else if($(this).hasClass("rotateLeft")){
		        	file.rotation -= 90;
		        }
		        if ( supportTransition ) {
		            deg = 'rotate(' + file.rotation + 'deg)';
		            $wrap.css({
		                '-webkit-transform': deg,
		                '-mos-transform': deg,
		                '-o-transform': deg,
		                'transform': deg
		            });
		        } else {
		            $wrap.css( 'filter', 'progid:DXImageTransform.Microsoft.BasicImage(rotation='+ (~~((file.rotation/90)%4 + 4)%4) +')');
		            // use jquery animate to rotation
		            // $({
		            //     rotation: rotation
		            // }).animate({
		            //     rotation: file.rotation
		            // }, {
		            //     easing: 'linear',
		            //     step: function( now ) {
		            //         now = now * Math.PI / 180;
		
		            //         var cos = Math.cos( now ),
		            //             sin = Math.sin( now );
		
		            //         $wrap.css( 'filter', "progid:DXImageTransform.Microsoft.Matrix(M11=" + cos + ",M12=" + (-sin) + ",M21=" + sin + ",M22=" + cos + ",SizingMethod='auto expand')");
		            //     }
		            // });
		        }
		
		
		    });
		    if(file.getStatus()=='complete'){
		    	if(opts.editType=='edit'){
		    		$li.append( '<span class="success"></span>' );
		    	}
		    	//$btns.find("span:gt(0)").remove();
		    }
		    $li.appendTo( $queue );
		}

		// 负责view的销毁
		function removeFile( file ) {
			
		    var $li = $('#'+file.id);
		    var  fileId="";
		    if(file.source && file.source.fileId){
		    	fileId=file.source.fileId;
		    }
		    if(file.response && file.response.FILE_ID){
		    	fileId=file.response.FILE_ID;
		    }
		    if(fileId!=""){
		    	$.ajax({
		    		type : "POST",
		    		url : ThsUploderUtil.opts.delete_url.replace("{1}", fileId),
		    		async : false,
		    		dataType : "json",
		    		success : function(response) {
		    			console.log(response);
		    		}
		    	});
		    }
		    delete percentages[ file.id ];
		    updateTotalProgress();
		    $li.off().find('.file-panel').off().end().remove();
		    
		}
				
		function updateTotalProgress() {
		    var loaded = 0,
		        total = 0,
		        spans = $progress.children(),
		        percent;
		    $.each( percentages, function( k, v ) {
		    	if(v[2]!="complete"){
		    		total += v[ 0 ];
		    		loaded += v[ 0 ] * v[ 1 ];
		    	}
		    } );
		    
		    percent = total ? loaded / total : 0;
		    
		    spans.eq( 0 ).text( Math.round( percent * 100 ) + '%' );
		    spans.eq( 1 ).css( 'width', Math.round( percent * 100 ) + '%' );
		    updateStatus();
		}
		
		function updateStatus() {
		    var text = '', stats;
		    if ( state === 'ready' ) {
		        text = '选中' + fileCount + '个文件,共'+WebUploader.formatSize( fileSize )+'。';
		    } else if ( state === 'confirm' ) {
		        stats = uploader.getStats();
		        if ( stats.uploadFailNum ) {
		            text = '已成功上传' + stats.successNum+ '个文件，'+
		                stats.uploadFailNum + '个文件上传失败，<a class="retry" href="#">重新上传</a>失败文件或<a class="ignore" href="#">忽略</a>'
		                $upload.hide();
		            	$( "#filePicker2_"+opts.pick.replace("#","")).addClass( 'element-invisible' );
		            	$info.show();
		        }
		
		    }else if(state==='uploading'){
		    	var stats=uploader.getStats();
		    	text="正在上传中……";
		    }else{
		        stats = uploader.getStats();
		        text = '已上传' + fileCount + '个文件（'+WebUploader.formatSize( fileSize )+'）';
               /*text = '已上传' + fileCount + '个文件: ';
                if (fileList) {
                	for (var i = 0 ;  i<fileList.length; i++) {
                        var file = fileList[i];
                        text += file.source.name + '(' + WebUploader.formatSize(file.size) + ') ';
					}
                    text += "----共" + WebUploader.formatSize( fileSize );
				}*/
		    }
		    $info.html( text );
		}
		function setState( val ) {
		    var file, stats;
		    if ( val === state ) {
		        return;
		    }
		    
		    $upload.removeClass( 'state-' + state );
		    $upload.addClass( 'state-' + val );
		    state = val;
		
		    switch ( state ) {
		        case 'pedding':
		            $placeHolder.removeClass( 'element-invisible' );
		            $queue.parent().removeClass('filled');
		            $queue.hide();
		            $statusBar.addClass( 'element-invisible' );
		            uploader.refresh();
		            break;
		
		        case 'ready':
		            $placeHolder.addClass( 'element-invisible' );
		            $( "#filePicker2_"+opts.pick.replace("#","") ).removeClass( 'element-invisible');
		            $queue.parent().addClass('filled');
		            $queue.show();
		            $statusBar.removeClass('element-invisible');
		            uploader.refresh();
		            break;
		
		        case 'uploading':
		            $( "#filePicker2_"+opts.pick.replace("#","") ).addClass( 'element-invisible' );
		            $progress.show();
		            $upload.text( '暂停上传' );
		            $upload.hide();
		            break;
		
		        case 'paused':
		            $progress.show();
		            $upload.text( '继续上传' );
		            break;
		
		        case 'confirm':
		            $progress.hide();
		            $upload.text( '开始上传' );
		            $upload.show();
		            $( "#filePicker2_"+opts.pick.replace("#","") ).removeClass( 'element-invisible' );
		            stats = uploader.getStats();
		            if ( stats.successNum && !stats.uploadFailNum ) {
		                setState( 'finish' );
		                return;
		            }
		            break;
		        case 'finish':
		            stats = uploader.getStats();
		            if ( stats.successNum ) {
		                
		            } else {
		                // 没有成功的图片，重设
		                state = 'done';
		                location.reload();
		            }
		            break;
		    }
		
		    updateStatus();
		}
		
		uploader.onUploadProgress = function( file, percentage ) {
		    var $li = $('#'+file.id),
		        $percent = $li.find('.progress span');
		
		    $percent.css( 'width', percentage * 100 + '%' );
		    percentages[ file.id ][ 1 ] = percentage;
		    updateTotalProgress();
		};
		uploader.onBeforeFileQueued = function(file){
			if(fileCount+1>_uploader.options.fileNumLimit){
				this.trigger( 'error', '文件总数超过限制，最多上传'+_uploader.options.fileNumLimit+"个文件", file );
				return false;
			}
			if(file.name.length>80){
				this.trigger( 'error', '文件名称太长，请保持在80字符以内！', file );
				return false;
			}
		};
		uploader.onFileQueued = function( file ) {
		    fileCount++;
		    fileSize += file.size;
		    fileList.push(file);
		    if ( fileCount === 1 ) {
		        $placeHolder.addClass( 'element-invisible' );
		        if(opts.editType=='edit'){
		        	$statusBar.show();
		        }
		    }
		    addFile( file );
		    setState( 'ready' );
		    updateTotalProgress();
		};
		uploader.onFileDequeued = function( file ) {
		    fileSize -= file.size;
		    fileCount--;
            fileList.pop(file);
		    if ( !fileCount ) {
		        setState( 'pedding' );
		    }
		    removeFile( file );
		    state="done";
		    //
		    $(uploader.getFiles()).each(function(){
		    	if(this.getStatus()=='queued'){
		    		state='ready';
		    	}
		    })
		    updateTotalProgress();
		
		};
		//单个文件上传完成
		uploader.on('uploadComplete', function(file) {
			if (uploader.response == null) {
				uploader.response = [];
			}
			uploader.response.push(file.response);
		});
		//所有的文件上传完成
		uploader.on('uploadFinished', function() {
			uploader.options.UPLOAD_COMPLETE_FLAG = true;
			setState( 'confirm' );
		});
		
		uploader.on( 'all', function( type ) {
		    var stats;
		    switch( type ) {		
		        case 'startUpload':
		            setState( 'uploading' );
		            break;
		
		        case 'stopUpload':
		            setState( 'paused' );
		            break;
		
		    }
		});
		
		//验证错误
		uploader.on('error', function(code, file) {
		    ThsUploderUtil.checkFileError(code, file, uploader);
		});
		
		$upload.on('click', function() {
		    if ( $(this).hasClass( 'disabled' ) ) {
		        return false;
		    }
		    console.log(state);
		    if ( state === 'ready' ) {
		        uploader.upload();
		    } else if ( state === 'paused' ) {
		        uploader.upload();
		    } else if ( state === 'uploading' ) {
		        uploader.stop(true);
		    }
		});
		
		$info.on( 'click', '.retry', function() {
		    uploader.retry();
		} );
		
		$info.on( 'click', '.ignore', function() {
		    //当选择忽略时，删除当前失败的file
			var errorFiles=uploader.getFiles("error");
			for(var i=0;i<errorFiles.length;i++){
				uploader.removeFile(errorFiles[i]);
			}
			setState( 'finish' );
			$upload.show();
            $( "#filePicker2_"+opts.pick.replace("#","") ).removeClass( 'element-invisible' );
		} );
		
		$upload.addClass( 'state-' + state );
		updateTotalProgress();
		
		//获取非图片文件的缩略图
		function createThump(_file){
			var ext=_file.ext.toLowerCase();
			switch( ext ) {
			case 'pdf':
				return '<i class="fa fa-file-pdf-o text-danger"></i>';
			case 'excel':
			case 'xlsx':
            case 'xls':
			case 'et':
				return '<i class="fa fa-file-excel-o text-danger"></i>';
			case 'doc':
			case 'docx':
			case 'wps':
				return '<i class="fa fa-file-word-o text-danger"></i>';
			case 'ppt':
			case 'pptx':
			case 'dps':
				return '<i class="fa fa-file-powerpoint-o text-danger"></i>';
			case 'txt':
				return '<i class="fa fa-file-text-o text-danger"></i>';
			case 'mp4':
			case 'avi':
			case 'flv':
			case 'mkv':
			case 'wmv':
			case 'f4v':
				return '<i class="fa fa-file-video-o text-danger"></i>';
			case 'rar':
			case 'zip':
			case '7z':
			case 'war':
				return '<i class="fa fa-file-zip-o text-danger"></i>';
			default:
				return '<i class="fa fa-file-o text-danger"></i>';
			}
		}
		var isImage=function(ext){
			var isimg=false;
			if(ext){
				ext =  ext.toLowerCase();
				switch(ext){
					case 'png':
					case 'jpg':
					case 'jpeg':
					case 'gif':
					case 'bmp':
						isimg=true;
						break;
					default:
						break;
				}
			}
			return isimg;
		}
		if(opts.editType!='edit'){
			$statusBar.hide();
		}
	}		
}    	
//判断文件是否全部上传
Theme.checkUpload=function(opts){
	var status=true;
	if(opts.theme=='demo1'){
		$wrap=$(opts.pick);
		$wrap.find(".filelist li").each(function(){
			if($(this).find(".success").length<=0){
				status=false;
			}
		})
	}
	return status;
}
<%@ page pageEncoding="UTF-8" %>
<div style="width: 100%;overflow-x: auto;">
	<div v-if="allowUpload">
	    <table class="table table-bordered table-hover" style="min-width: 800px;">
	        <thead>
	        <tr>
	            <th class="text-center" style="width:80px">序号</th>
	            <th class="text-center" style="width:200px">图片预览</th>
	            <th class="text-center">图片名称</th>
	            <th class="text-center" v-if="showFileDesc">图片解析</th>
	            <th class="text-center" style="width:180px;">
	                <i class="ace-icon fa fa-calendar"></i>
	                上传时间
	            </th>
	            <th class="text-center" style="width:150px;">
	                <i class="ace-icon fa fa-wrench"></i>
	                操作
	            </th>
	        </tr>
	        </thead>
	        <tbody ref="fileListTableBody">
	        <tr v-for="(file, index) in tempFileList">
	            <td class="text-right">{{index + 1}}</td>
	            <td class="text-center">
	            	<div v-if="file.fileType == 'mp4'" class="box-item" style="position:relative;cursor:pointer;float: left;" @click.stop="showvideo(file.fileUrl)">
						<img class="img-thumbnail" style="height: 120px;width: 115px;" :src="file.fileUrl?file.fileUrl:taskImgUrl+file.previewSavePath" :title="file.fileName" alt="--" />
						<img src="${ctx }/assets/custom/common/common/images/videoplay.png" style="left:50%;top:50%;position:absolute;width:24px;height:24px;margin-top:-12px;margin-left:-12px;">
					</div>
					<div v-else class="box-item">
		                <img class="img-thumbnail" style="max-height: 120px;max-width: 95%;" alt="--" :src="file.fileUrl?file.fileUrl:taskImgUrl+file.previewSavePath" :title="file.fileName"/>
					</div>
	            </td>
	            <td class="align-left" :title="file.fileName">{{file.fileName}}</td>
	            <td v-if="showFileDesc">
	                <textarea v-if="allowDelete" rows="4" class="form-control validate[required,maxSize[500]]"
	                          v-model="file.fileDesc" data-prompt-position="bottomLeft" placeholder="请输入图片解析，限制500个字符"
	                          maxlength="500"></textarea>
	                <span v-else :title="file.fileDesc">{{file.fileDesc | resultFormat}}</span>
	            </td>
	            <td class="text-center" :title="file.createTime">{{file.createTime | resultFormat}}</td>
	            <td class="text-center">
	                <button type="button" class="btn btn-sm btn-white btn-op-ths" v-if="allowDownload && file.fileId"
	                        @click="downloadFile(file)" title="下载">
	                    <i class="ace-icon fa fa-download"></i>
	                </button>
	                <button type="button" class="btn btn-sm btn-white btn-op-ths btn-danger" v-if="allowDelete"
	                        @click="deleteFileInfo(index)" title="删除">
	                    <i class="ace-icon fa fa-trash-o"></i>
	                </button>
	            </td>
	        </tr>
	        <tr v-if="(tempFileList==null || tempFileList.length===0)">
	            <td colspan="5" class="align-center">暂无图片信息</td>
	        </tr>
	        <tr v-if="allowUpload && (tempFileList.length < getMaxFileNumber)">
	            <td :colspan="5">
	                <input type="file" ref="fileSelectInput" multiple="multiple" :accept="getAllowRawTypeStr"
	                       @change="addFileInfo" style="display: none !important;">
	                <button type="button" class="btn-noborder" @click="openFileSelect">
	                    <i class="ace-icon fa fa-plus"></i>
	                    选择图片
	                </button>
	                <span style="margin-left: 20px;color: #858B9C;">
						<template v-if="titles!=''">
							{{titles}}且单个图片不超过{{getMaxFileSizeShowText}}。图片个数为：{{getMinFileNumber}}
	                    ~{{getMaxFileNumber}} 个。
						</template>
						<template v-else>
							    只能上传{{getAllowFileTypeStr}}图片，且单个图片不超过{{getMaxFileSizeShowText}}。图片个数为：{{getMinFileNumber}}
	                    ~{{getMaxFileNumber}} 个。
						</template>

	                </span>
	            </td>
	        </tr>
	        </tbody>
	    </table>
    </div>
    <div v-else>
    	<table>
    		<tbody ref="fileListTableBody">
    			<tr v-if="(tempFileList==null || tempFileList.length===0)">
		            <td  class="align-center">暂无图片信息</td>
		        </tr>
    			<tr v-else>
    				<td v-for="(file, index) in tempFileList" style="padding: 6px;">
    					<div v-if="file.fileType == 'mp4'" class="box-item" style="position:relative;cursor:pointer;float: left;">
							<div @click.stop="showvideo(file.fileUrl)">
								<img class="img-thumbnail" style="height: 120px;width: 115px;" :src="taskImgUrl+file.previewSavePath" :title="file.fileName" alt="--" />
								<div style="background:url(${ctx}/assets/custom/common/common/images/videoplay.png);
										left:25%;
										top:25%;
										position:absolute;
										width:62px;
										height:60px;
										">
								</div>
							</div>
							<div style="height: 25px;width: 115px;text-align: center;"><a :href="file.fileUrl" :download="file.fileName">下载</a></div>
						</div>
						<div v-else class="box-item">
	    					<img class="img-thumbnail" style="height: 120px;width: 115px;" :alt="file.fileName"  :src="taskImgUrl+file.previewSavePath" :data-original="file.fileUrl" :title="file.fileName"/>
							<div style="height: 25px;width: 115px;text-align: center;"><a :href="file.fileUrl" :download="file.fileName">下载</a></div>
						</div>
    				</td>
    			</tr>
    		</tbody>
    	</table>
    </div>
</div>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<table class="table table-bordered file-upload-table">
	<thead>
		<tr>
			<th class="text-center" width="6%">序号</th>
			<th class="text-center" width="49%">
				<i class="ace-icon fa fa-file-text-o"></i>
				文件名称
			</th>
			<th class="text-center" width="10%">文件类型</th>
			<th class="text-center" width="10%">文件大小</th>
			<th class="text-center" width="15%">
				<i class="ace-icon fa fa-calendar"></i>
				上传时间
			</th>
			<th class="text-center" width="10%">
				<i class="ace-icon fa fa-wrench"></i>
				操作
			</th>
		</tr>
	</thead>
	<tbody>
		<tr v-if="(fileList && fileList.length > 0)" v-for="(file, index) in fileList">
			<td class="text-right">{{index + 1}}</td>
			<td :title="file.name">{{file.name}}</td>
			<td class="text-center" :title="file.type">{{file.type}}</td>
			<td class="text-right" :title="file.size">{{file.size}}</td>
			<td class="text-center" :title="file.uploadTime">{{file.uploadTime}}</td>
			<td class="text-center">
				<button type="button" class="btn btn-sm btn-white btn-op-ths" v-if="isDownload && file.fileId" @click="fileDownloadUtil.downloadFile(file.fileId)" title="下载">
					<i class="ace-icon fa fa-download"></i>
				</button>
				<button type="button" class="btn btn-sm btn-white btn-op-ths btn-danger" v-if="isHideDeleteButton==false" @click="fileUploadUtil.deleteFile(fileList, index, deleteFileIds)" title="删除">
					<i class="ace-icon fa fa-trash-o"></i>
				</button>
			</td>
		</tr>
		<tr v-if="(fileList==null || fileList.length===0)">
			<td colspan="6" class="align-center">暂无文件信息</td>
		</tr>
		<tr v-if="isHiddenUploadButton==false && (fileList==null || fileList.length < getMaxFileNumber)">
			<td colspan="6">
				<el-upload class="upload-file" ref="upload" :multiple="true" :show-file-list="false" :accept="getAllowRawTypeStr" :http-request="fileUpload" :auto-upload="true" action="">
				<button slot="trigger" type="button" class="btn btn-xs btn-xs-ths">
					<i class="ace-icon fa fa-plus"></i>
					选择文件
				</button>
				<div>只能上传{{getAllowFileTypeStr}}文件，且单个文件不超过{{getMaxFileSizeShowText}}。文件个数为：{{getMinFileNumber}} ~ {{getMaxFileNumber}} 个。</div>
				</el-upload>
			</td>
		</tr>
	</tbody>
</table>
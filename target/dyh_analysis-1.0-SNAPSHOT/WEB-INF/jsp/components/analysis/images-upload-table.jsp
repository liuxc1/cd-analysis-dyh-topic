<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<form id="mainForm" class="form-horizontal" role="form" method="post">
<table class="table table-bordered">
	<thead>
		<tr>
			<th class="text-center" width="5%">序号</th>
			<th class="text-center" width="15%">图片预览</th>
			<th class="text-center" width="25%" v-if="isShowImageAnalysis">图片解析</th>
			<th class="text-center" width="15%"> <i class="ace-icon fa fa-file-text-o"></i> 图片名称 </th>
			<th class="text-center" width="15%"> <i class="ace-icon fa fa-calendar"></i> 上传时间 </th>
			<th class="text-center" width="10%" v-if="!isReadOnly"> <i class="ace-icon fa fa-wrench"></i> 操作 </th>
		</tr>
	</thead>
	<tbody id="picTable">
		<tr v-if="(fileList && fileList.length > 0)" v-for="(file, index) in fileList">
			<td class="text-right" style="vertical-align: middle; ">{{index + 1}}</td>
			<td class="text-center" style="display: table-cell;vertical-align: middle;text-align: center;">
			  	<img :src="file.url" :alt="file.name" class="img-thumbnail" style="max-height: 120px;max-width: 200px;"/>
			</td>
			<td style="vertical-align: middle;" v-if="isShowImageAnalysis">
				<template v-if="isValidate">
					<textarea :disabled="isReadOnly" rows="4" class="form-control validate[required,maxSize[500]]" v-model="file.describe" data-prompt-position="bottomLeft" placeholder="请输入图片解析，限制500个字符" maxlength="500"></textarea>
				</template>
				<template v-else>
					<textarea :disabled="isReadOnly" rows="4" class="form-control validate[maxSize[500]]" v-model="file.describe" data-prompt-position="bottomLeft" placeholder="请输入图片解析，限制500个字符" maxlength="500"></textarea>
				</template>
				<p v-if="isValidate && !isReadOnly" class="text-danger"><i class="ace-icon fa fa-asterisk red smaller-70"></i> 必填，且字符长度不能超1000字符。</p>
			</td> 
			<td class="text-left" style="vertical-align: middle; " :title="file.name">{{file.name}}</td>
			<td class="text-center" style="vertical-align: middle; " :title="file.uploadTime">{{file.uploadTime}}</td>
			<td class="text-center" style="vertical-align: middle;"  v-if="!isReadOnly">
				<button type="button" class="btn btn-sm btn-white btn-op-ths" v-if="isDownload && file.fileId" @click="fileDownloadUtil.downloadFile(file.fileId)" title="下载">
					<i class="ace-icon fa fa-download"></i>
				</button>
				<button type="button" class="btn btn-sm btn-white btn-op-ths btn-danger" v-if="isHideDeleteButton==false" @click="fileUploadUtil.deleteFile(fileList, index, deleteFileIds)" title="删除">
					<i class="ace-icon fa fa-trash-o"></i>
				</button>
			</td>
		</tr>
		<tr v-if="(fileList==null || fileList.length===0)">
			<td :colspan="isReadOnly?5:6" class="align-center">暂无文件信息</td>
		</tr>
		<tr v-if="isHiddenUploadButton==false && (fileList==null || fileList.length < getMaxFileNumber)">
			<td colspan="6">
				<el-upload  :on-change="beforeAvatarUpload"  class="upload-file" ref="upload" :multiple="true" :show-file-list="false"	 :accept="getAllowRawTypeStr" :http-request="fileUpload" :auto-upload="true"  
				 action="">
				<button slot="trigger" type="button" class="btn btn-xs btn-xs-ths">
					<i class="ace-icon fa fa-plus"></i>
					选择图片
				</button>
				<div>只能上传{{getAllowFileTypeStr}}图片，且单个图片不超过{{getMaxFileSizeShowText}}。图片个数为：{{getMinFileNumber}} ~ {{getMaxFileNumber}} 个。</div>
				</el-upload>
			</td>
		</tr>
	</tbody>
</table>
</form>
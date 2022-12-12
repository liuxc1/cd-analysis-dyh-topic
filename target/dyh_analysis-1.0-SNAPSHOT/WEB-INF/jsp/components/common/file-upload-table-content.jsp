<%@ page pageEncoding="UTF-8" %>
<div style="width: 100%;overflow-x: auto;">
    <div v-if="allowUpload">
	    <table class="table table-bordered table-hover table-text-one-line" style="min-width: 800px;">
	        <thead>
	        <tr>
	            <th class="align-center" style="width: 80px;">序号</th>
	            <th class="align-center">文件名称</th>
	            <th class="align-center" style="width: 100px;">文件类型</th>
	            <th class="align-center" style="width: 130px;">文件大小</th>
	            <th class="align-center" style="width: 180px;">
	                <i class="ace-icon fa fa-calendar"></i>
	                上传时间
	            </th>
	            <th class="align-center" style="width: 150px;">
	                <i class="ace-icon fa fa-wrench"></i>
	                操作
	            </th>
	        </tr>
	        </thead>
	        <tbody ref="fileListTableBody">
	        <tr v-for="(file, index) in tempFileList">
	            <td class="align-right">{{index + 1}}</td>
	            <td :title="file.fileFullName">{{file.fileFullName}}</td>
	            <td class="align-center" :title="file.fileType">{{file.fileType}}</td>
	            <td class="align-right" :title="getFormatFileSize(file.fileSize)+', '+file.fileSize">
	                {{getFormatFileSize(file.fileSize)}}
	            </td>
	            <td class="align-center" :title="file.createTime">{{file.createTime | resultFormat}}</td>
	            <td class="align-center">
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
	        <tr v-if="(tempFileList.length===0)">
	            <td colspan="6" class="align-center">暂无文件信息</td>
	        </tr>
	        <tr v-if="allowUpload && (tempFileList.length < getMaxFileNumber)">
	            <td colspan="6">
	                <input type="file" ref="fileSelectInput" multiple="multiple" :accept="getAllowRawTypeStr"
	                       @change="addFileInfo" style="display: none !important;">
	                <button type="button" class="btn-noborder" @click="openFileSelect">
	                    <i class="ace-icon fa fa-plus"></i>
	                    选择文件
	                </button>
	                <span style="margin-left: 20px;color: #858B9C;">
	                    只能上传{{getAllowFileTypeStr}}文件，且单个文件不超过{{getMaxFileSizeShowText}}。文件个数为：{{getMinFileNumber}}
	                    ~{{getMaxFileNumber}} 个。
	                </span>
	            </td>
	        </tr>
	        </tbody>
	    </table>
     </div>
     <div v-else>
     	<table>
     		<tbody>
     			 <tr v-if="(tempFileList.length===0)">
					<td class="align-center">暂无文件信息</td>
				</tr>
     			<tr v-else  v-for="(file, index) in tempFileList">
     				<td>
     					<a @click="downloadFile(file)"><span class="highlight—name">{{file.fileFullName}}</span></a>
     				</td>
     			</tr>
     		</tbody>
     	</table>
     </div>
</div>
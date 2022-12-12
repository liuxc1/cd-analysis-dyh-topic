<%@ page language="java" pageEncoding="utf-8"%>
<div>
	<div class="cu-pagination" ref="divCuPagination">
		<ul style="left: 0; z-index: 7;">
			<li @click="firstPage" :class="[tableobj.pageNum>1?'':'disabled']">
				<i class="ace-icon fa fa-angle-double-left"></i>
			</li>
			<li @click="lastPage" :class="[tableobj.pageNum>1?'':'disabled']">
				<i class="ace-icon fa fa-angle-left"></i>
			</li>
			<li v-for="(item,index) in pages" v-show="(pageWidth>720 || item==tableobj.pageNum)" :key="index" :class="[item==tableobj.pageNum?'active':'']" @click="selectedPage(item)">{{item}}</li>
			<li @click="nextPage" :class="[totalPage>tableobj.pageNum?'':'disabled']">
				<i class="ace-icon fa fa-angle-right"></i>
			</li>
			<li @click="finalPage" :class="[totalPage>tableobj.pageNum?'':'disabled']">
				<i class="ace-icon fa fa-angle-double-right"></i>
			</li>
		</ul>
		<ul style="right: 0; text-align: right; z-index: 8;">
			<li class="totalPage">共{{tableobj.total}}条/{{totalPage}}页，每页</li>
			<li class="totalPage">
				<select :value="tableobj.pageSize" ref="inputPageSize" @change="showSkipInput">
					<option>5</option>
					<option>10</option>
					<option>20</option>
					<option>50</option>
					<option>100</option>
					<option>1000</option>
				</select>
			</li>
			<li class="totalPage">条，跳转到</li>
			<li class="totalPage">
				<!-- 防止enter建提交页面 -->
				<input style="display: none"/>
				<input style="display: none"/>
				<!-- ./防止enter建提交页面 -->
				<input type="number" :value="tableobj.pageNum" ref="inputPageNum">
			</li>
			<li class="totalPage">页</li>
			<li class="totalPage">
				<button type="button" class="gobtn" @click="showSkipInput">GO</button>
			</li>
		</ul>
	</div>
</div>
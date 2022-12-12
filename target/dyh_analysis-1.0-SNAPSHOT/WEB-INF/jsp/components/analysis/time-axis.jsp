<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="col-sm-12 no-padding">
	<ul class="time-axis no-margin-left">
		<li :title="prev.title" v-show="prev.isShow" :class="{'disabled' : prevDisabled}" @click="prevClick">
			<i class="ace-icon fa fa-angle-double-left"></i>
		</li>
		<li v-for="(data, index) in list" :class="{'disabled': data.disabled,   'hasData':data.hasData,'selected': data.selected, 'tip': data.isTip}" @click="listClick(index)">
			{{data.text}}
		</li>
		<li :title="next.title" v-show="next.isShow" :class="{'disabled' : nextDisabled}" @click="nextClick">
			<i class="ace-icon fa fa-angle-double-right"></i>
		</li>
	</ul>
</div>
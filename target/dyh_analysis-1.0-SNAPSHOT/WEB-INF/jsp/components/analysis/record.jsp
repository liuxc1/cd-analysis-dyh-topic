<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="col-sm-12 no-padding" >
	<ul class="record">
		<li class="divomit"  v-for="(record, index) in records" :class="{'selected': record.selected}" @click="recordClick(index)">
			<i class="ace-icon fa fa-hand-o-right"></i>
			<span v-bind:title="record.text" v-text="record.text"></span>
		</li>
	</ul>
</div>
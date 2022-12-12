<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="divmessdialog" style="display: none;">
	<div class="col-xs-12" style="padding-top: 10px; padding-bottom: -10px; height: 150px;">
		<div class="alert ths-dialog-content alert-info" style="height: 80%;">
			<form class="form-horizontal" role="form" style="">
				<div class="form-group">
					<label class="col-xs-11 control-label no-padding ">提交后不能再修改，当天其他人的填报内容也会自动提交，确认提交吗？</label>
				</div>
				<div class="form-group">
<%--					<label class="col-xs-11 control-label no-padding ">温馨提示：当前时间大于16:00，请勾选手动发送短信的内容(如不发送则不选择)。</label>--%>
					<label class="col-xs-11 control-label no-padding ">温馨提示：当前时间大于16:00，提交将自动发送短信。</label>
				</div>
<%--			<div class="form-group">
					<div class="col-xs-11 no-padding">
						<div class="col-xs-1 no-padding" style="width: 20px;">
							<input type="checkbox" v-model="threeday">
						</div>
						<label class="col-xs-10 control-label no-padding"><span style="color: black;">3天预报</span></label>
					</div>
				</div>
				<div class="form-group">
					<div class="col-xs-11 no-padding">
						<div class="col-xs-1 no-padding" style="width: 20px;">
							<input type="checkbox" v-model="sevenday">
						</div>
						<label class="col-xs-10 control-label no-padding "><span style="color: black;">7天预报</span></label>
					</div>
				</div>--%>
			</form>
		</div>
	</div>
</div>
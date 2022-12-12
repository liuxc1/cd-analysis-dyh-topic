<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/_common/taglib.jsp"%>
<!DOCTYPE html>
<html lang="zh">
<head>
<title>首页</title>
<%@ include file="/WEB-INF/jsp/_common/commonCSS.jsp"%>
<!--页面自定义的CSS，请放在这里 -->

<!-- 引入样式 -->
<link href="${ctx}/assets/components/viewer-master/dist/viewer.css?v=20221129015223" rel="stylesheet">
<style type="text/css">
	.viewer-backdrop {
    	background-color: rgba(0, 0, 0, 0);
}
	#home1{
		width: 100%;
		height: 100%;
	}
</style>
</head>
<body class="no-skin" >
	<div style="width: 100%;overflow-x: auto;">
	<!-- <div v-else class="box-item">
	             <img class="img-thumbnail homePic" id="home1" style="max-height: 100%;max-width: 100%;width: 100%;height: 100%" alt="--" src="home1.jpg" />
	</div> -->
	<div v-if="allowUpload" style="width: 100%;height: 100%">
	    <table class="table table-bordered table-hover" style="min-width: 800px; display: none;">
	        <tbody class="fileListTableBody">
	        <tr><!-- v-for="(file, index) in tempFileList" -->
	            <td class="text-center" >
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home1" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_01.png" />
					</div>
	            </td>
	             <td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home2" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_02.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home3" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_03.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home4" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_04.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home5" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_05.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home6" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_06.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home7" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_07.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home8" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_08.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home9" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_09.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home10" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_10.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home11" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_11.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home12" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_12.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home13" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_13.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home14" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_14.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home15" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_15.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home16" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_16.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home17" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_17.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home18" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_18.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home19" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_19.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home20" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_20.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home21" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_21.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home22" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_22.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home23" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_23.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home24" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_24.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home25" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_25.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home26" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_26.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home27" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_27.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home28" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_28.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home29" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_29.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home30" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_30.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home31" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_31.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home32" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_32.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home33" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_33.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home34" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_34.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home35" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_35.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home36" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_36.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home37" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_37.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home38" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_38.png"/>
					</div>
	            </td>
				<td class="text-center">
					<div v-else class="box-item">
		                <img class="img-thumbnail homePic" id="home39" style="max-height: 100%;max-width: 100%;" alt="--" src="院士站大事记-网页版_39.png"/>
					</div>
	            </td>
	        </tr>
	        </tbody>
	    </table>
    </div>
</div>
	<!-- /.modal -->

	<%@ include file="/WEB-INF/jsp/_common/commonJS.jsp"%>
	<!-- 图片放大插件 -->
	<script type="text/javascript" src="${ctx }/assets/components/viewer-master/dist/viewer-202104028.js?v=20221129015223"></script>
	<!-- vue插件 -->
	<script type="text/javascript" src="${ctx}/assets/components/vue/vue.min.js?v=20221129015223"></script>
	<script type="text/javascript">
		var ctx = "${ctx}";
	</script>
	<!-- 自定义 javascript -->
	<script type="text/javascript">
	 $(function(){
		var viewa = $(".fileListTableBody").viewer({button:false,navbar:false,fullscreen:true,movable:false,tooltip:false,title:false,
			viewed() {
		    this.viewer.zoomTo(1.1);
		  }});
		$("#home1").click();
	});
	</script>
</body>

</html>
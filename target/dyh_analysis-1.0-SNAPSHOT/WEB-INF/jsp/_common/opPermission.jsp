<script type="text/javascript">
	jQuery(function ($) {
		 var __ops = '<%= new ths.jdp.api.OuApi().getNotAllowOperation(request.getServletPath())%>';
		 if(__ops && __ops != ""){
			 $(__ops).hide();
		 }
	});
</script>
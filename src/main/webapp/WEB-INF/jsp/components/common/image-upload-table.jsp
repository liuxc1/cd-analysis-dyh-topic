<%@ page import="ths.jdp.core.context.PropertyConfigure" %>
<%@ page pageEncoding="UTF-8" %>
<script id="vue-template-image-upload-table" type="text/x-template">
    <%@ include file="image-upload-table-content.jsp" %>
</script>
<script type="text/javascript">
    var taskImgUrl = '<%=PropertyConfigure.getProperty("TASK_IMG_CONTEXT_PATH")%>';
</script>
<script type="text/javascript" src="${ctx}/assets/custom/common/file/file-download-util.js"></script>
<script type="text/javascript" src="${ctx}/assets/custom/common/file/file-upload-util.js"></script>
<script type="text/javascript" src="${ctx}/assets/custom/components/common/file-upload-table.js"></script>
<script type="text/javascript" src="${ctx}/assets/custom/components/common/file-upload-table-image.js"></script>
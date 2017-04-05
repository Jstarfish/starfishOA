<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<script type="text/javascript" src="${basePath}/js/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="${basePath}/js/jquery/jquery.form.js"></script>
<link rel="stylesheet" href="${basePath}/component/messageBox/myJsBox.css" type="text/css"/>
<script type="text/javascript" src="${basePath}/component/messageBox/myJsBox.js"></script>
<script type="text/javascript">
function backUrl(){
	location.href="${reservedUrl}";
}

$(document).ready(function() {
	if('${backFlg}'=='true')
		showMsg("",'${reservedSuccessMsg}',"warn",'backUrl()');
	else
		showWarn('${reservedSuccessMsg}');
});
</script>
</head>

</html>
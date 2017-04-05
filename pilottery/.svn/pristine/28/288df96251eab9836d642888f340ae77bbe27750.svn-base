<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8"%>
<%@ include file="/views/common/taglibs.jsp"%>
<html>
<head>
<title></title>
<%@ include file="/views/common/meta.jsp" %>
<style type="text/css">

#error_page table {
	margin-left: auto;
	margin-right: auto;
}

</style>

</head>

<body>
	<div id="error_page">
		<table border="0" cellspacing="0" cellpadding="0" width="600" height="100px" style="background:#fff;padding:40px 0px;margin-top:50px; border:1px solid #f1f1f1;">
		   	<tr>
		   		<td align="right" width="20%">
		   			<img alt="error" src="${basePath}/img/errorTip.png">
		   		</td>
		   		<td align="left" style="padding: 0px 20px 0px 10px;">
	   				<c:if test="${not empty systemErrorMsg}">System Error:${systemErrorMsg}</c:if>
					<c:if test="${empty systemErrorMsg}">System Error,Please Contract The Administrator </c:if>
		   		</td>
		   	</tr>
		</table>
	</div>

</body>
</html>
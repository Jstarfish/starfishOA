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
		<table border="0" cellspacing="0" cellpadding="0" width="100%" height="100px">
		   	<tr>
		   		<td align="right" width="30%">
		   			<img alt="error" src="${basePath}/img/error.png">
		   		</td>
		   		<td align="left" style="padding: 0px 50px 0px 10px;">
	   				<c:if test="${not empty system_message}">System Error:${system_message}</c:if>
					<c:if test="${empty system_message}">You do not have this permission </c:if>
		   		</td>
		   	</tr>
		</table>
	</div>

</body>
</html>
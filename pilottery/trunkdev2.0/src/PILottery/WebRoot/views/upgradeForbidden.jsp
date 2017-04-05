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
		   			<img alt="error" src="${basePath}/img/kul.png">
		   		</td>
		   		<td align="left" style="padding: 0px 20px 0px 10px;">
		   			Please upgrade your browser to the latest version
		   		</td>
		   	</tr>
		</table>
	</div>

</body>
</html>
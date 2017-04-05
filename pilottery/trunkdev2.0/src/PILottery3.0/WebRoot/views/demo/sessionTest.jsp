<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/views/common/taglibs.jsp"%>
<%@ include file="/views/common/meta.jsp" %>

<html>
<head>
<title>Session Test</title>
<link rel="stylesheet" type="text/css" href="${basePath}/css/style.css" />
</head>
<body>
<div id="title">Session Test-29</div>
	<div class="queryDiv">
	<c:choose>
		<c:when test="${!empty user }">
			<span> Current login user is ${user.loginId}.</br></span>
		</c:when>
		<c:otherwise>
			<span> We can't get the user's session info.</br></span>
		</c:otherwise>
	</c:choose>
	<c:if test="${!empty error} ">
		<span>Something is wrong in testing.${error}</br></span>
	</c:if>
  
	<span>Test ip ${ip}</br></span>

	<c:if test="${!empty ipr} ">
		<span>Test ip-r ${ipr}</br></span>
	</c:if>
    </div>
</html>
